//
//  NervosProvider.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/09.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import web3swift
import PromiseKit

/// Nervos HTTP Provider.
public class NervosProvider {
    public var attachedKeystoreManager: KeystoreManager?
    public var url: URL

    public var session: URLSession = { () -> URLSession in
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        return urlSession
    }()

    public init?(_ url: URL, keystoreManager: KeystoreManager? = nil) {
        guard ["http", "https"].contains(url.scheme) else {
            return nil
        }
        self.url = url
        attachedKeystoreManager = keystoreManager
    }

    public func sendAsync(_ request: Request, queue: DispatchQueue = .main) -> Promise<Response> {
        guard request.isValid else {
            return Promise(error: NervosError.nodeError("RPC request is invalid.Perhaps method is nil?"))
        }

        return NervosProvider.post(request, providerURL: self.url, queue: queue, session: self.session)
    }

    public func sendAsync(_ requests: RequestBatch, queue: DispatchQueue = .main) -> Promise<ResponseBatch> {
        return NervosProvider.post(requests, providerURL: self.url, queue: queue, session: self.session)
    }
}

extension NervosProvider {
    static func post(_ request: Request, providerURL: URL, queue: DispatchQueue = .main, session: URLSession) -> Promise<Response> {
        let rp = Promise<Data>.pending()
        var task: URLSessionTask? = nil
        queue.async {
            do {
                let encoder = JSONEncoder()
                let requestData = try encoder.encode(request)
                var urlRequest = URLRequest(url: providerURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
                urlRequest.httpMethod = "POST"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
                urlRequest.httpBody = requestData
                task = session.dataTask(with: urlRequest) { (data, _, error) in
                    guard error == nil else {
                        rp.resolver.reject(error!)
                        return
                    }
                    guard data != nil else {
                        rp.resolver.reject(NervosError.nodeError("Node response is empty"))
                        return
                    }
                    rp.resolver.fulfill(data!)
                }
                task?.resume()
            } catch {
                rp.resolver.reject(error)
            }
        }
        return rp.promise.ensure(on: queue) { task = nil }.map(on: queue) { (data: Data) throws -> Response in
            let parsedResponse = try JSONDecoder().decode(Response.self, from: data)
            if parsedResponse.error != nil {
                throw NervosError.nodeError("Received an error message from node\n" + String(describing: parsedResponse.error!))
            }
            return parsedResponse
        }
    }

    static func post(_ request: RequestBatch, providerURL: URL, queue: DispatchQueue = .main, session: URLSession) -> Promise<ResponseBatch> {
        let rp = Promise<Data>.pending()
        var task: URLSessionTask? = nil
        queue.async {
            do {
                let encoder = JSONEncoder()
                let requestData = try encoder.encode(request)
                var urlRequest = URLRequest(url: providerURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
                urlRequest.httpMethod = "POST"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
                urlRequest.httpBody = requestData
                task = session.dataTask(with: urlRequest) { (data, _, error) in
                    guard error == nil else {
                        rp.resolver.reject(error!)
                        return
                    }
                    guard data != nil, data!.count != 0 else {
                        rp.resolver.reject(NervosError.nodeError("Node response is empty"))
                        return
                    }
                    rp.resolver.fulfill(data!)
                }
                task?.resume()
            } catch {
                rp.resolver.reject(error)
            }
        }
        return rp.promise.ensure(on: queue) { task = nil }.map(on: queue) { (data: Data) throws -> ResponseBatch in
            return try JSONDecoder().decode(ResponseBatch.self, from: data)
        }
    }
}
