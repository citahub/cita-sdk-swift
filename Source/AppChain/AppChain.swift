//
//  AppChain.swift
//  AppChain
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public class AppChain: NervosOptionsInheritable {
    var provider: NervosProvider
    weak var nervos: Nervos?

    public var options: NervosOptions {
        return nervos!.options
    }

    public init(provider: NervosProvider, nervos: Nervos) {
        self.provider = provider
        self.nervos = nervos
    }
}
