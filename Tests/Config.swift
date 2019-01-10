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
    static var testnetURL: URL {
        let testServer = Config.shared["rpcServer"] ?? "http://127.0.0.1:1337"
        return URL(string: testServer)!
    }

    static var testnetProvider: HTTPProvider {
        return HTTPProvider(testnetURL)!
    }
}

extension AppChain {
    static var `default` = AppChain(provider: HTTPProvider.testnetProvider)
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
    var appChain: AppChain {
        return AppChain.default
    }

    /// Load JSON fixture file from cita-sdk-tests folder.
    ///
    /// - Parameter jsonFile: JSON file file name excluding the cita-sdk-tests part and json extension, e.g. "transactions/TransactionValueOverflow".
    /// - Returns: JSON content.
    func load(jsonFile: String) -> Any {
        let path = Bundle(for: type(of: self)).path(forResource: "cita-sdk-tests/" + jsonFile, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return try! JSONSerialization.jsonObject(with: data, options: [.allowFragments])
    }

    func jsonFiles(in folder: String) -> [String] {
        let path = Bundle(for: type(of: self)).path(forResource: "cita-sdk-tests/" + folder, ofType: "")!
        let enumerator = FileManager.default.enumerator(atPath: path)!
        return enumerator.allObjects.map { $0 as! String }
            .filter { $0.hasSuffix(".json") }
            .map { folder + "/" + $0.replacingOccurrences(of: ".json", with: "") }
    }
}
