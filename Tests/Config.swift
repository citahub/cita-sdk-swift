//
//  Config.swift
//  AppChainTests
//
//  Created by Yate Fulham on 2018/08/09.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import XCTest
@testable import AppChain

extension HTTPProvider {
    static var testnetProviderURL: URL {
        let testServer = Config.shared["rpcServer"] ?? "http://127.0.0.1:1337"
        return URL(string: testServer)!
    }

    static var deadProviderURL: URL {
        return URL(string: "http://111.111.111.111:1111")!
    }

    static var testnetProvider: HTTPProvider {
        return HTTPProvider(testnetProviderURL)!
    }

    static var deadProvider: HTTPProvider {
        return HTTPProvider(deadProviderURL)!
    }
}

struct DefaultNervos {
    static let instance: AppChain = AppChain(provider: HTTPProvider.testnetProvider)
    static let deadInstance: AppChain = AppChain(provider: HTTPProvider.deadProvider)
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
    var nervos: AppChain {
        return DefaultNervos.instance
    }

    var nobody: AppChain {
        return DefaultNervos.deadInstance
    }

    /// Load JSON fixture file from appchain-tests folder.
    ///
    /// - Parameter jsonFile: JSON file file name excluding the appchain-tests part and json extension, e.g. "transactions/TransactionValueOverflow".
    /// - Returns: JSON content.
    func load(jsonFile: String) -> Any {
        let path = Bundle(for: type(of: self)).path(forResource: "appchain-tests/" + jsonFile, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return try! JSONSerialization.jsonObject(with: data, options: [.allowFragments])
    }

    func jsonFiles(in folder: String) -> [String] {
        let path = Bundle(for: type(of: self)).path(forResource: "appchain-tests/" + folder, ofType: "")!
        let enumerator = FileManager.default.enumerator(atPath: path)!
        return enumerator.allObjects.map { $0 as! String }
            .filter { $0.hasSuffix(".json") }
            .map { folder + "/" + $0.replacingOccurrences(of: ".json", with: "") }
    }
}
