//
//  AppChainTests.swift
//  NervosTests
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
import BigInt
@testable import Nervos

class AppChainTests: XCTestCase {
    func testPeerCount() {
        let result = nervos.appChain.peerCount()
        switch result {
        case .success(let count):
            XCTAssertTrue(count > 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testBlockNumber() {
        let result = nervos.appChain.blockNumber()
        switch result {
        case .success(let blockNumber):
            XCTAssertTrue(blockNumber > 100)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testSendRawTransaction() {
        let currentBlock = nervos.appChain.blockNumber().value!
        guard case .success(let metaData) = nervos.appChain.getMetaData() else { return XCTFail() }

        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let tx = NervosTransaction(
            to: Address("0x0000000000000000000000000000000000000000"),
            nonce: UUID().uuidString,
            validUntilBlock: currentBlock + 88,
            data: Data.fromHex("6060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029")!,
            chainId: metaData.chainId
        )
        guard let signed = try? NervosTransactionSigner.sign(transaction: tx, with: privateKey) else {
            return XCTFail("Sign tx failed")
        }

        let result = nervos.appChain.sendRawTransaction(signedTx: signed)
        switch result {
        case .success(let result):
            XCTAssertEqual(32, result.hash.count)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testSendRawTransactionPaddingValue() {
        let sender = Web3Utils.publicToAddress(Web3Utils.privateToPublic(Data.fromHex("0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")!)!)!.address.lowercased()
        XCTAssertEqual(sender, "0x46a23e25df9a0f6c18729dda9ad1af3b6a131160")

        let newTxhash = "0x28fdc784441fd59701496db2830a03cbd090bb058b5a695d1b56ddc3a9b9a823"
        let newTxOnChain = nervos.appChain.getTransaction(txhash: newTxhash).value!
        XCTAssertEqual(sender, newTxOnChain.unsignedTransaction!.sender.address)
    }

    func testGetBlockByHash() {
        let hash = "0x60ee895fa92a5f094a28ac225f62b797c1d0d1349081b1f67c0e5c6358f66f8b"
        let result = nervos.appChain.getBlockByHash(hash: hash, fullTransactions: true)
        switch result {
        case .success(let block):
            XCTAssertEqual(block.hash.toHexString().addHexPrefix(), hash)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetBlockByNumberNullProof() {
        let number = BigUInt(1)
        let result = nervos.appChain.getBlockByNumber(number: number, fullTransactions: true)
        switch result {
        case .success(let block):
            XCTAssertEqual(BigUInt.fromHex(block.header.number.toHexString())!, number)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetBlockByNumber() {
        let number = BigUInt(2)
        let result = nervos.appChain.getBlockByNumber(number: number, fullTransactions: true)
        switch result {
        case .success(let block):
            XCTAssertEqual(BigUInt.fromHex(block.header.number.toHexString())!, number)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetTransactionReceipt() {
        let result = nervos.appChain.getTransactionReceipt(txhash: "0x28fdc784441fd59701496db2830a03cbd090bb058b5a695d1b56ddc3a9b9a823")
        switch result {
        case .success(let receipt):
            XCTAssertEqual(receipt.blockHash.toHexString().addHexPrefix(), "0xf154478f8fbfdbcd05c58727bb033084c4a20953c546de01ecd85c2fa6d0fae8")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetLogs() {
        var filter = Filter()
        filter.fromBlock = "0x0"
        filter.topics = [["0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2", "0xa84557f35aab907f9be7974487619dd4c05be1430bf704d0c274a7b3efa50d5a", "0x00000000000000000000000000000000000000000000000000000165365f092d"]]
        let result = nervos.appChain.getLogs(filter: filter)
        switch result {
        case .success(let logs):
            XCTAssertTrue(logs.count >= 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testCall() {
        let request = CallRequest(from: "0x46a23e25df9a0f6c18729dda9ad1af3b6a131160", to: "0x6fc32e7bdcb8040c4f587c3e9e6cfcee4025ea58", data: "0x9507d39a000000000000000000000000000000000000000000000000000001653656eae7")
        let result = nervos.appChain.call(request: request)
        switch result {
        case .success(let data):
            XCTAssert(data.hasPrefix("0x"))
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetTransaction() {
        let txhash = "0x28fdc784441fd59701496db2830a03cbd090bb058b5a695d1b56ddc3a9b9a823"
        let result = nervos.appChain.getTransaction(txhash: txhash)
        switch result {
        case .success(let tx):
            XCTAssertEqual(tx.hash.toHexString().addHexPrefix(), txhash)
            XCTAssertEqual(tx.unsignedTransaction?.sender.address, "0x46a23e25df9a0f6c18729dda9ad1af3b6a131160")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetTransactionCountByBlockNumber() {
        let result = nervos.appChain.getTransactionCount(address: "0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523", blockNumber: "0xf5dc9")
        switch result {
        case .success(let count):
            XCTAssert(count >= 1)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetTransactionCountLatest() {
        let result = nervos.appChain.getTransactionCount(address: "0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523", blockNumber: "latest")
        switch result {
        case .success(let count):
            XCTAssertTrue(count >= 1)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetTransactionCountByAddress() {
        let address = Address("0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523")!
        let result = nervos.appChain.getTransactionCount(address: address, blockNumber: "latest")
        switch result {
        case .success(let count):
            XCTAssertTrue(count >= 1)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetCode() {
        let result = nervos.appChain.getCode(address: "0xd8fb3e5600a682f340761280ccf9d29c7ee114a7", blockNumber: "latest")
        switch result {
        case .success(let code):
            XCTAssert(code.hasPrefix("0x"))
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetAbi() {
        let result = nervos.appChain.getAbi(address: "0xb93b22a67D724A3487C2BD83a4aaac66F1B7C882", blockNumber: "latest")
        switch result {
        case .success(let code):
            XCTAssert(code.hasPrefix("0x"))
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetBalance() {
        let result = nervos.appChain.getBalance(address: "0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523", blockNumber: "0xf5dc9")
        switch result {
        case .success(let balance):
            XCTAssertEqual(balance.toHexString().addHexPrefix(), "0xfff6fffde1e61f36454da21191")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testNewFilter() {
        var filter = Filter()
        filter.fromBlock = "0x0"
        filter.topics = [["0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2", "0xa84557f35aab907f9be7974487619dd4c05be1430bf704d0c274a7b3efa50d5a", "0x00000000000000000000000000000000000000000000000000000165365f092d"]]
        let result = nervos.appChain.newFilter(filter: filter)
        switch result {
        case .success(let id):
            XCTAssertTrue(id > 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testNewBlockFilter() {
        let result = nervos.appChain.newBlockFilter()
        switch result {
        case .success(let id):
            XCTAssertTrue(id > 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testUninstallFilter() {
        guard case .success(let filterID ) = nervos.appChain.newBlockFilter() else { return XCTFail() }
        var result = nervos.appChain.uninstallFilter(filterID: filterID)
        switch result {
        case .success(let uninstalled):
            XCTAssertTrue(uninstalled)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }

        result = nervos.appChain.uninstallFilter(filterID: filterID)
        switch result {
        case .success(let uninstalled):
            XCTAssertFalse(uninstalled)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetFilterChanges() {
        let result = nervos.appChain.getFilterChanges(filterID: 1)
        switch result {
        case .success(let changes):
            XCTAssertTrue(changes.count >= 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetFilterLogs() {
        let result = nervos.appChain.getFilterLogs(filterID: 1)
        switch result {
        case .success(let changes):
            XCTAssertTrue(changes.count >= 0)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetTransactionProof() {
        let result = nervos.appChain.getTransactionProof(txhash: "0x28fdc784441fd59701496db2830a03cbd090bb058b5a695d1b56ddc3a9b9a823")
        switch result {
        case .success(let proof):
            XCTAssertEqual(proof, "0xf90d7cf901dfa441394132434142342d453830352d344545462d394144372d39324344343132423832433680830f424094000000000000000000000000000000000000000080b8f06060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029830f58710180b841def56bb5111be9742bfd8ced6f4b167c92c7d85affd54b24a7245dd7ce12c3657cd5637f6f17b03efb4331c4bcbc780b3de55b2f9b3f981ba5066e6457f2ffc80080a028fdc784441fd59701496db2830a03cbd090bb058b5a695d1b56ddc3a9b9a823b840a706ad8f73115f90500266f273f7571df9429a4cfb4bbfbcd825227202dabad1ba3d35c73aec698af852b327ba1c24e11758936bb6322fe93d7469b182f66631f9012a64b9010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0c0820306a028fdc784441fd59701496db2830a03cbd090bb058b5a695d1b56ddc3a9b9a823c0f90408a0637c81ab439fb04396ae07f4c114556fae8aeb5b4f293184ed5254c35eb30788a0f671e222f085a6bccd5bff1b91e6395ba37fa42435ebc6a5d083895dd1689fc5a028fdc784441fd59701496db2830a03cbd090bb058b5a695d1b56ddc3a9b9a823a0e145987bc770123192e7375ae8d2a3428d0425cb020ab591357815e4cfe3f9a9b9010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000830f581b88ffffffffffffffff6486016618ef689c80b902530ace0442000000000000003078613735633264323463353736386464623762306264663061303334663634633230303535323730666331623033643664656162316261333939396138383236321a580f0000000000000000000000000004000000000000002a000000000000003078323761616135666532653935303338356364626533643034353935343036396630353830616235624100000000000000f79f322545c412d85845302d70e7a215c4802d329a4df3203a4ac2048bc833f36f0a2a998bd07a9671503f6c8750b9cce632076d77d91b42d334ce658a882d33002a000000000000003078633135616534666364663033393833373935333136373430356565666262396465343431323462344100000000000000c32fa02252e678d21f526bedce81c7f4984aa8b8aef3ebaad99459d3ce445c5b52418051047dd694ecc57fb2bf992e75ccbdeae4bbbaa99d6bd610237b7d7309012a000000000000003078306536313163346132303161386333646664396137653662663161356338653565373762303461324100000000000000c9b1027749e149c3b7615638ac084a93b4073d8bd9ae69edd72fee3da62e40b0416cdadf25a38740c66fb0ad23b15290e5b4a91807a2bd782c39cc8710b6e513002a000000000000003078626433633365613132353539303764313935633061313431393538633063616333386564663334314100000000000000721bd8ee1dcacd1ff3a4a8bed37cdd64cc6b10f0e4d8a0b16354767fa4ce2b41132b0c4a87d08a516b44d6f1a25264ee365a0803252330b49c25f3c3f1fde5c00110029427aaa5fe2e950385cdbe3d045954069f0580ab5bf90408a0f154478f8fbfdbcd05c58727bb033084c4a20953c546de01ecd85c2fa6d0fae8a056e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421a056e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421a056e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421b9010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000830f581c88ffffffffffffffff8086016618ef6d2a80b902530ace0442000000000000003078616337326232353631353130386436613335643463646637363965626362616631653032346531613139323965646161373439393230663036306563306533661b580f0000000000000000000000000004000000000000002a000000000000003078306536313163346132303161386333646664396137653662663161356338653565373762303461324100000000000000267b09fac35aeb9da07d44882c7a88039a37efaa6ea901c87552583b6c532efb780c3cec336d7ab09a461ab19360d5b043f58915a63dd869ce5920ee2a9e6981002a0000000000000030786264336333656131323535393037643139356330613134313935386330636163333865646633343141000000000000004e2f42a0b6b77fee876c021e9d78486efeb1d892ba6608c1aa8ad288a75a0628547d9a79519b8118e2b3b81096c0e5395de39e52bde2fffea6b1ea820527f472012a000000000000003078633135616534666364663033393833373935333136373430356565666262396465343431323462344100000000000000442b046286c8e6e5d8f22022b73cea4f9d0f6709137c58cb04b36b26df31e3b169f5175528890cb35be866c6bd3dc8f8c6d3c18a00ed23b7c7f2d39e6ea80faf002a0000000000000030783237616161356665326539353033383563646265336430343539353430363966303538306162356241000000000000009c7220d1940b1f0c75167234f2efd08aa87469439a91bf25b02e7c78e5c01cf32bda6233f06e9be915f0e122f10f5c9a3d53592b2358cb3ff8185a8f7053b89d001002940e611c4a201a8c3dfd9a7e6bf1a5c8e5e77b04a2b902530ace0442000000000000003078343632623265343138646461353461643636663131663231376235646434356638333566383263623138386337316436363366623336353366323638333862631c580f0000000000000000000000000004000000000000002a000000000000003078323761616135666532653935303338356364626533643034353935343036396630353830616235624100000000000000b9ee9a4037ac43209ecfbb18999e80132b0d1af63cf9efd1e60e75b24e44433b6b84debdd7264c3c8c750501d2339a405e2a45c3ded509ea38fef8f413de7810012a000000000000003078626433633365613132353539303764313935633061313431393538633063616333386564663334314100000000000000695172b01d95e4101dcb67e5f8e335548ba97e71d66ad7ce3d9c9f8aa81205b464524a130199adc663aa398f4f44f72b5bd48f5d8ae38c1b2322c95e271a1005012a0000000000000030786331356165346663646630333938333739353331363734303565656662623964653434313234623441000000000000001b6a4b3177251b9096fa78c2d2d67da6facc2c9d07e6d2594ceb0671a7d3107759010a768e7503a84eeae6304eae330fba1b67b1ec9253fadc3c00afa7a676d3012a000000000000003078306536313163346132303161386333646664396137653662663161356338653565373762303461324100000000000000dbfa9196e2d960cd236c77b24721afedb214957e58cbf9a2f3760b912f94f4583ca6e0440b589f794d3ac9808ba7eba2ecd81cd0ccfa13933bb124c4dfa43390011002")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetMetaData() {
        let result = nervos.appChain.getMetaData(blockNumber: "latest")
        switch result {
        case .success(let metaData):
            XCTAssertEqual(metaData.chainId, 1)
            XCTAssertEqual(metaData.chainName, "test-chain")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetBlockHeader() {
        let result = nervos.appChain.getBlockHeader(blockNumber: "0x4cfcb")
        switch result {
        case .success(let blockHeader):
            XCTAssert(blockHeader.hasPrefix("0x"))
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func xtestGetStateProof() {
        let result = nervos.appChain.getStateProof(address: "0xad54ae137c6c39fa413fa1da7db6463e3ae45664", key: "0xa40893b0c723e74515c3164afb5b2a310dd5854fac8823bfbffa1d912e98423e", blockNumber: "latest")
        switch result {
        case .success(let proof):
            XCTAssertEqual(proof, "0xf902a594ad54ae137c6c39fa413fa1da7db6463e3ae45664f901eeb90114f9011180a088e2efeed0516020141cbbba149711e0ce67634363097a441520704040aa8dd9a0479ca451cdb343dd2eedbf313e805983e87c0f4f16e9c14f28ab3f1750eb1b8e80a0dd94e00536c62d8c801b8496fb0834ab7225954bac452a7d14c0f4a35df81074a07c689f1111314c391b164c458f902366bb18b90a53d9000a1ffd41abc96373d380808080a0b219eebc746ca232aa4a839213565d1932b4b952c93c5aa585e226ac5412d836a0b758264786a8fb6eaa6f7f2185a3f38111de3c532517ef4e46b99b80e4866d27a093ddedf515207b9a68b50f5f344aae23e709316d96345b146746ae2e511893178080a03b5530655278a731d4c895c92359fb217c64f9fde0c6945339863638396627f480b853f851808080808080808080808080a0d7a0fd35748eceb8fc8040517033416adcfb5523f4abe9789b749700c36b4ba5a0e4fe51db54afdd475e2c50888623567385f2b3694ffdb33c92a1bc782de44be7808080b880f87e942054ae137c6c39fa413fa1da7db6463e3ae45664b867f8658080a0a860517f2f639d5c3e9e8a8c04ef6c71018e18cd0881099776a73653973f90a4a00f1cd9fb6dda499878b60cdb90cf0acf25424afb5583131e4dff5e512cd64a4da0c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470a0a40893b0c723e74515c3164afb5b2a310dd5854fac8823bfbffa1d912e98423ef87cb853f851a02c839c2946385ef0a820355b6969c49c97bdaa6a19b02384bcc39c992046d6b9808080808080808080a051be428c087e3544a47f273c93ffcb9999267593d3b36042a9d3e96ed068fceb808080808080a6e5a0340893b0c723e74515c3164afb5b2a310dd5854fac8823bfbffa1d912e98423e83827a02")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
}

extension AppChainTests {
    func xtestInvalidNode() {
        let result = nobody.appChain.peerCount()
        switch result {
        case .success(let count):
            XCTFail("Should not get peerCount \(count) from an invalid nervos node")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }
}
