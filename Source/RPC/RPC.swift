//
//  RPC.swift
//  AppChain
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import PromiseKit

public final class RPC {
    private(set) var provider: HTTPProvider
    private(set) var requestDispatcher: RequestDispatcher

    public init(provider: HTTPProvider) {
        self.provider = provider
        self.requestDispatcher = RequestDispatcher(provider: provider, queue: DispatchQueue.global(qos: .userInteractive), policy: .batch(32))
    }

    public func dispatch(_ request: Request) -> Promise<Response> {
        return requestDispatcher.addToQueue(request: request)
    }
}
