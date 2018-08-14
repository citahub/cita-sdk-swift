//
//  TransactionSendingResult.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/14.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation

public struct TransactionSendingResult: Decodable {
    public var status: String
    public var hash: String
}
