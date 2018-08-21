//
//  RequestDispatcher.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import PromiseKit

/// JSON-RPC Request Dispatcher
public class RequestDispatcher {
    public var maxWaitTime: TimeInterval = 0.1
    public var policy: DispatchPolicy
    public var queue: DispatchQueue

    private var provider: NervosProvider
    private var lockQueue: DispatchQueue
    private var batches: [Batch] = []

    init(provider: NervosProvider, queue: DispatchQueue, policy: DispatchPolicy) {
        self.provider = provider
        self.queue = queue
        self.policy = policy
        lockQueue = DispatchQueue.init(label: "batchingQueue")
        batches.append(Batch(provider: self.provider, capacity: 32, queue: self.queue, lockQueue: self.lockQueue))
    }

    internal final class Batch {
        var capacity: Int
        var promisesDict: [UInt64: (promise: Promise<Response>, resolver: Resolver<Response>)] = [:]
        var requests: [Request] = []
        var pendingTrigger: Guarantee<Void>?
        var provider: NervosProvider
        var queue: DispatchQueue
        var lockQueue: DispatchQueue
        var triggered = false

        func add(_ request: Request, maxWaitTime: TimeInterval) throws -> Promise<Response> {
            if triggered {
                throw NervosError.nodeError("Batch is already in flight")
            }
            let requestID = request.id
            let promiseToReturn = Promise<Response>.pending()
            lockQueue.async {
                if self.promisesDict[requestID] != nil {
                    promiseToReturn.resolver.reject(NervosError.processingError("Request ID collision"))
                }
                self.promisesDict[requestID] = promiseToReturn
                self.requests.append(request)
                if self.pendingTrigger == nil {
                    self.pendingTrigger = after(seconds: maxWaitTime).done(on: self.queue) {
                        self.trigger()
                    }
                }
                if self.requests.count == self.capacity {
                    self.trigger()
                }
            }
            return promiseToReturn.promise
        }

        func trigger() {
            lockQueue.async {
                if self.triggered {
                    return
                }
                self.triggered = true
                let requestsBatch = RequestBatch(requests: self.requests)
                _ = self.provider.sendAsync(requestsBatch, queue: self.queue).done(on: self.queue) { batch in
                    for response in batch.responses {
                        if self.promisesDict[UInt64(response.id)] == nil {
                            for k in self.promisesDict.keys {
                                self.promisesDict[k]?.resolver.reject(NervosError.nodeError("Unknown request id"))
                            }
                            return
                        }
                    }
                    for response in batch.responses {
                        let promise = self.promisesDict[UInt64(response.id)]!
                        promise.resolver.fulfill(response)
                    }
                }.catch(on: self.queue) { err in
                    for k in self.promisesDict.keys {
                        self.promisesDict[k]?.resolver.reject(err)
                    }
                }
            }
        }

        init (provider: NervosProvider, capacity: Int, queue: DispatchQueue, lockQueue: DispatchQueue) {
            self.provider = provider
            self.capacity = capacity
            self.queue = queue
            self.lockQueue = lockQueue
        }
    }

    func getBatch() throws -> Batch {
        guard case .batch(let batchLength) = policy else {
            throw NervosError.inputError("Trying to batch a request when policy is not to batch")
        }
        let currentBatch = batches.last!
        if currentBatch.requests.count % batchLength == 0 || currentBatch.triggered {
            let newBatch = Batch(provider: provider, capacity: Int(batchLength), queue: queue, lockQueue: lockQueue)
            batches.append(newBatch)
            return newBatch
        }
        return currentBatch
    }

    public enum DispatchPolicy {
        case batch(Int)
        case noBatching
    }

    func addToQueue(request: Request) -> Promise<Response> {
        switch policy {
        case .noBatching:
            return provider.sendAsync(request, queue: queue)
        case .batch:
            let promise = Promise<Response> { seal in
                lockQueue.async {
                    do {
                        let batch = try self.getBatch()
                        let internalPromise = try batch.add(request, maxWaitTime: self.maxWaitTime)
                        internalPromise.done(on: self.queue) { resp in
                            seal.fulfill(resp)
                        }.catch(on: self.queue) { err in
                            seal.reject(err)
                        }
                    } catch {
                        seal.reject(error)
                    }
                }
            }
            return promise
        }
    }
}
