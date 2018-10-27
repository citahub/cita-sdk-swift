//
//  AppChain.swift
//  AppChain
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public final class AppChain {
    public var provider: HTTPProvider

    public lazy var rpc: RPC = {
        return RPC(provider: self.provider)
    }()

    public init(provider: HTTPProvider) {
        self.provider = provider
    }
}
