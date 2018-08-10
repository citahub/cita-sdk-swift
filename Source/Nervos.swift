//
//  Nervos.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import web3swift

public protocol NervosOptionsInheritable {
    var options: NervosOptions { get }
}

public class Nervos: NervosOptionsInheritable {
    public var provider: NervosProvider
    public var options: NervosOptions = NervosOptions.defaultOptions()
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
public typealias Address = EthereumAddress
public typealias Transaction = EthereumTransaction
public typealias Block = web3swift.Block
public typealias TransactionDetails = web3swift.TransactionDetails
public typealias TransactionReceipt = web3swift.TransactionReceipt
public typealias TransactionSendingResult = web3swift.TransactionSendingResult
