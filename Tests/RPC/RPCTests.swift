//
//  RPCTests.swift
//  AppChainTests
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
import BigInt
@testable import AppChain

class RPCTests: XCTestCase {
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
        guard let signed = try? Signer().sign(transaction: tx, with: privateKey) else {
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

        let txhash = "0xb439c647b3c3b135a30154f33026d0a7074473766cb26d6017ac9d8269559f4d"
        if let txOnChain = nervos.appChain.getTransaction(txhash: txhash).value {
            XCTAssertEqual(sender, txOnChain.unsignedTransaction!.sender.address)
        } else {
            XCTFail("TX not found on chain.")
        }
    }

    func testGetBlockByHash() {
        let hash = "0xcb15cc7a90841f2eecda99107a00776b7c8968a4182ea4bb3bba09a70608e76f"
        let result = nervos.appChain.getBlockByHash(hash: hash, fullTransactions: true)
        switch result {
        case .success(let block):
            XCTAssertEqual(block.hash.toHexString().addHexPrefix(), hash)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetBlockByNumberNullProof() {
        let number = BigUInt(0)
        let result = nervos.appChain.getBlockByNumber(number: number, fullTransactions: true)
        switch result {
        case .success(let block):
            XCTAssertEqual(block.header.number, number)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetBlockByNumber() {
        let number = BigUInt(1_000_000)
        let result = nervos.appChain.getBlockByNumber(number: number, fullTransactions: true)
        switch result {
        case .success(let block):
            XCTAssertEqual(block.header.number, number)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func testGetTransactionReceipt() {
        let result = nervos.appChain.getTransactionReceipt(txhash: "0xb439c647b3c3b135a30154f33026d0a7074473766cb26d6017ac9d8269559f4d")
        switch result {
        case .success(let receipt):
            XCTAssertEqual(receipt.blockHash.toHexString().addHexPrefix(), "0xcb15cc7a90841f2eecda99107a00776b7c8968a4182ea4bb3bba09a70608e76f")
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
        let txhash = "0xb439c647b3c3b135a30154f33026d0a7074473766cb26d6017ac9d8269559f4d"
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
            XCTAssertTrue(balance > 0)
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
        let result = nervos.appChain.getTransactionProof(txhash: "0xb439c647b3c3b135a30154f33026d0a7074473766cb26d6017ac9d8269559f4d")
        switch result {
        case .success(let proof):
            XCTAssertEqual(proof, "0xf90d02f901dfa431323737443930352d384633332d344343392d413934322d34464634323544434145463480830f424094000000000000000000000000000000000000000080b8f06060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029831da0880180b8410776182f0a636499d9fe2091dc09fd12a0f7dc572f9b51f5e9be5c6e79d57b94606159bd33a3cb09f51c6b5e63d1b944d264754a000ad2dfeeffdbcdea06b0450080a0b439c647b3c3b135a30154f33026d0a7074473766cb26d6017ac9d8269559f4db840a706ad8f73115f90500266f273f7571df9429a4cfb4bbfbcd825227202dabad1ba3d35c73aec698af852b327ba1c24e11758936bb6322fe93d7469b182f66631f9012b64b9010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0c083013954a0b439c647b3c3b135a30154f33026d0a7074473766cb26d6017ac9d8269559f4dc0f9038da0b76031e349cbf3778786049df868be839bc3fa50e3202cb8d64b88300aaaed53a0b82584e194061d9c1d3b242ffb6a023f3464d4b4edc0b76a508e7ac65fb9a229a0b439c647b3c3b135a30154f33026d0a7074473766cb26d6017ac9d8269559f4da0e27875b7d50f0bb2ca7f458b2c818c45ed1d1c93a2b27e69073d29c1a27dcdb1b9010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000831da03388ffffffffffffffff648601662a4d1e2f80b901d80ad303420000000000000030786630326161646563353033333230326330363565353963363566613666396535366131373263303863386562396331326538343932643064643936353062623732a01d0000000000000000000000000003000000000000002a0000000000000030786565303162396261393736373165386131383931653835623230366234393966313036383232613141000000000000001a1fd1619e1f1edc3629a68b2dbe80af217d5f584af336c21d04b31997f3ada7479f815ef81802e083935dc36c951f212b15d9fb3892c9d7e376de4ec9323bac002a00000000000000307834383662623638386338643239303536626437663837633236373333303438623061366162646136410000000000000091c3f6dbb77ec136b74375c4dde70fd47182298522469353767c6305871bd7d7443dc08175392157948f09e040b52834363bb6ed3db08cf4c8a79cf6a82848c3002a00000000000000307833313034326434663736363263646466386465643532323964623363356537333032383735653130410000000000000077e38c12cc946abe15b64d2a202b4fe17dd4098f688b9b18933eb2459822abe63954d4d160eb1ae97571f4a6148a613b7d7ba8afea412484c0ab3c43300fe5340110029431042d4f7662cddf8ded5229db3c5e7302875e10f90408a0cb15cc7a90841f2eecda99107a00776b7c8968a4182ea4bb3bba09a70608e76fa056e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421a056e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421a056e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421b9010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000831da03488ffffffffffffffff808601662a4d2c1e80b902530ace04420000000000000030783631636636363234313064396631636338363931376165653733303232323864383334653034623137373332636564323231666132346337346631636433343833a01d0000000000000000000000000004000000000000002a000000000000003078373162303238653439633666343161616137343933326437303363373037656363613664373332654100000000000000b029d1964cf905c1ebb372d4c0d9df0a06198867c1585d0f9e46b583345b1c124659fc832a2e3f2a37edaca7c81f3f209686402a460978b4f41770a6ad735694012a000000000000003078333130343264346637363632636464663864656435323239646233633565373330323837356531304100000000000000e741855959c728e41f590f992855b7cff84e6ead8165d5b6280900bf2209d2e77857ca8c56de0c5a958dc3b8185b423da3e13de16bd116b6240792727674878b002a0000000000000030783438366262363838633864323930353662643766383763323637333330343862306136616264613641000000000000006a9a4da72e87e90e1297ccaf371852889da96ba66e14f5caec69bc4467d7fe942617a56ef49328f6fa1363e8eff8b72a03826d2a94a5d50ca067320afa79fa59002a00000000000000307865653031623962613937363731653861313839316538356232303662343939663130363832326131410000000000000057cc3288b4da176154db54e2ccb23f8a3f27a94a101fd0a5c23bbefc725881a6067bf541cb643c1bec139a9d434f2aec9da1a451be1e89be2ffeb0f27e2e4c0f0110029471b028e49c6f41aaa74932d703c707ecca6d732eb902530ace04420000000000000030786537306330633633653764633237393234353534396366323036666237356137323061383430623033326664333930356431313562656430613734376137373234a01d0000000000000000000000000004000000000000002a000000000000003078656530316239626139373637316538613138393165383562323036623439396631303638323261314100000000000000c8836cb8a89739af22121fab9c3d378dedeaac38654f089626ef64e410e4622873fa9ef75735524d5b0201b5defbda0475da9905a7e9e0176ff85ac477f75c4f002a0000000000000030783331303432643466373636326364646638646564353232396462336335653733303238373565313041000000000000002356c6256ac2876173bd96087e14f07f3949f1e428bc755d80d6e170d9c3e89a73bc911889e024451ff28a142268b582951983ebc01b814ba1ca38c847d9775f012a000000000000003078373162303238653439633666343161616137343933326437303363373037656363613664373332654100000000000000d62d9922e82b3691aa52328a7b3c5e021902c3dd5e0e7fb0064aa835eda34927319d0f771cab466ca0c57cb93155a10e29dc3f3246218ac2fd34c65aeb2870d3002a0000000000000030783438366262363838633864323930353662643766383763323637333330343862306136616264613641000000000000002a4e944af2e087bbb7c6a473c1cb70d9903ec9a30d761fd03568dfbd3b51335c7794b619cddf83359f44329409af27aada08d310c64702ec05a473cac4c4c18b001002")
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
