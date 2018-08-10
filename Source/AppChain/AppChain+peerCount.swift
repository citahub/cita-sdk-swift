//
//  AppChain+peerCount.swift
//  Nervos
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import Foundation
import BigInt
import PromiseKit

extension AppChain {
    func peerCountPromise() -> Promise<BigUInt> {
        let request = RequestFabric.prepareRequest(.peerCount, parameters: [])
        return nervos!.dispatch(request).map(on: nervos!.requestDispatcher.queue) { response in
            guard let value: BigUInt = response.getValue() else {
                throw self.responseError(response)
            }
            return value
        }
    }
}
