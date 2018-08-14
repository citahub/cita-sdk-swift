//
//  Config.swift
//  NervosTests
//
//  Created by Yate Fulham on 2018/08/09.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import XCTest
@testable import Nervos

extension NervosProvider {
    static var testnetProviderURL: URL {
        return URL(string: "http://121.196.200.225:1337")!
    }

    static var deadProviderURL: URL {
        return URL(string: "http://111.111.111.111:1111")!
    }

    static var testnetProvider: NervosProvider {
        return NervosProvider(testnetProviderURL)!
    }

    static var deadProvider: NervosProvider {
        return NervosProvider(deadProviderURL)!
    }
}

struct DefaultNervos {
    static let instance: Nervos = Nervos(provider: NervosProvider.testnetProvider)
    static let deadInstance: Nervos = Nervos(provider: NervosProvider.deadProvider)
}

extension XCTestCase {
    var nervos: Nervos {
        return DefaultNervos.instance
    }

    var nobody: Nervos {
        return DefaultNervos.deadInstance
    }
}
