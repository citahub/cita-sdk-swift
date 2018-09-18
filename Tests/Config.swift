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
        let testServer = Config.shared["rpcServer"] ?? "http://127.0.0.1:1337"
        return URL(string: testServer)!
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

class Config {
    private let dict: [String: String]
    private init() {
        if let path = Bundle(for: type(of: self)).path(forResource: "Config", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            dict = json as? [String: String] ?? [:]
        } else {
            dict = [:]
        }
    }

    static var shared = Config()

    subscript(_ key: String) -> String? {
        return dict[key]
    }
}

extension XCTestCase {
    var nervos: Nervos {
        return DefaultNervos.instance
    }

    var nobody: Nervos {
        return DefaultNervos.deadInstance
    }
}
