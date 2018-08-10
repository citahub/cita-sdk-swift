//
//  Nervos.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import web3swift

public class Nervos: Web3OptionsInheritable {
    public var provider: NervosProvider
    public var options: Web3Options = Web3Options.defaultOptions()
    public var requestDispatcher: RequestDispatcher

    public var appChain: AppChain {
        if appChainInstance == nil {
            appChainInstance = AppChain(provider: provider, nervos: self)
        }
        return appChainInstance!
    }

    private var appChainInstance: AppChain?

    public init(provider: NervosProvider, queue: OperationQueue? = nil, requestDispatcher: RequestDispatcher? = nil) {
        self.provider = provider
        self.requestDispatcher = requestDispatcher ?? RequestDispatcher(provider: provider, queue: DispatchQueue.global(qos: .userInteractive), policy: .batch(32))
    }

    // Keystore manager can be bound to Web3 instance. If some manager is bound all further account related functions, such
    // as account listing, transaction signing, etc. are done locally using private keys and accounts found in a manager.
    public func addKeystoreManager(_ manager: KeystoreManager?) {
        provider.attachedKeystoreManager = manager
    }
}

public typealias NervosError = Web3Error

public typealias NervosOptions = Web3Options
