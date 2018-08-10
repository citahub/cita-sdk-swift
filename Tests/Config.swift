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
    static var defaultProviderURL: URL {
        return URL(string: "http://121.196.200.225:1337")!
    }

    static var defaultProvider: NervosProvider {
        return NervosProvider(defaultProviderURL)!
    }
}

extension Nervos {
    static var `default`: Nervos {
        return Nervos(provider: NervosProvider.defaultProvider)
    }
}
