//
//  AppChain.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import web3swift

public class AppChain: Web3OptionsInheritable {
    var provider: NervosProvider
    weak var nervos: Nervos?

    public var options: Web3Options {
        return nervos!.options
    }

    public init(provider: NervosProvider, nervos: Nervos) {
        self.provider = provider
        self.nervos = nervos
    }
}
