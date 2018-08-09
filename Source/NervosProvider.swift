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
public class NervosProvider: Web3Provider {
    public var network: Networks? // Not used, always nil.
    public var attachedKeystoreManager: KeystoreManager?
    public var url: URL

    public var session: URLSession = { () -> URLSession in
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        return urlSession
    }()

    public init?(_ httpProviderURL: URL, keystoreManager manager: KeystoreManager? = nil) {
        guard ["http", "https"].contains(httpProviderURL.scheme) else {
            return nil
        }
        url = httpProviderURL
        attachedKeystoreManager = manager
    }

    public func sendAsync(_ request: JSONRPCrequest, queue: DispatchQueue = .main) -> Promise<JSONRPCresponse> {
        guard request.isValid else {
            return Promise(error: Web3Error.nodeError("RPC request is invalid.Perhaps method is nil?"))
        }

        return NervosProvider.post(request, providerURL: self.url, queue: queue, session: self.session)
    }

    public func sendAsync(_ requests: JSONRPCrequestBatch, queue: DispatchQueue = .main) -> Promise<JSONRPCresponseBatch> {
        return NervosProvider.post(requests, providerURL: self.url, queue: queue, session: self.session)
    }
}

extension NervosProvider {
    static func post(_ request: JSONRPCrequest, providerURL: URL, queue: DispatchQueue = .main, session: URLSession) -> Promise<JSONRPCresponse> {
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
                        rp.resolver.reject(Web3Error.nodeError("Node response is empty"))
                        return
                    }
                    rp.resolver.fulfill(data!)
                }
                task?.resume()
            } catch {
                rp.resolver.reject(error)
            }
        }
        return rp.promise.ensure(on: queue) { task = nil }.map(on: queue) { (data: Data) throws -> JSONRPCresponse in
            let parsedResponse = try JSONDecoder().decode(JSONRPCresponse.self, from: data)
            if parsedResponse.error != nil {
                throw Web3Error.nodeError("Received an error message from node\n" + String(describing: parsedResponse.error!))
            }
            return parsedResponse
        }
    }

    static func post(_ request: JSONRPCrequestBatch, providerURL: URL, queue: DispatchQueue = .main, session: URLSession) -> Promise<JSONRPCresponseBatch> {
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
                        rp.resolver.reject(Web3Error.nodeError("Node response is empty"))
                        return
                    }
                    rp.resolver.fulfill(data!)
                }
                task?.resume()
            } catch {
                rp.resolver.reject(error)
            }
        }
        return rp.promise.ensure(on: queue) { task = nil }.map(on: queue) { (data: Data) throws -> JSONRPCresponseBatch in
            return try JSONDecoder().decode(JSONRPCresponseBatch.self, from: data)
        }
    }
}
