//
//  Version.swift
//  CITA
//
//  Created by XiaoLu on 2019/4/22.
//  Copyright © 2019 Cryptape. All rights reserved.
//

import Foundation

public struct Version: Decodable {
    public var softwareVersion: String

    enum CodingKeys: String, CodingKey {
        case softwareVersion
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let softwareVersion = try container.decode(String.self, forKey: .softwareVersion)
        self.softwareVersion = softwareVersion
    }
}
