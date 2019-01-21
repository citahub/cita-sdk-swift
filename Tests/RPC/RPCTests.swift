//
//  RPCTests.swift
//  CITATests
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
import BigInt
@testable import CITA

class RPCTests: XCTestCase {
    private static var txHashRecentSent: String!

    override class func setUp() {
        super.setUp()

        do {
            let cita = CITA.default
            let currentBlock = try cita.rpc.blockNumber()
            let metaData = try cita.rpc.getMetaData()

            let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
            let tx = Transaction(
                to: Address("0x0000000000000000000000000000000000000000"),
                nonce: UUID().uuidString,
                validUntilBlock: currentBlock + 88,
                chainId: metaData.chainId,
                version: metaData.version
            )
            let signed = try! Signer().sign(transaction: tx, with: privateKey)

            txHashRecentSent = try cita.rpc.sendRawTransaction(signedTx: signed)
        } catch {
            txHashRecentSent = ""
        }

        Thread.sleep(forTimeInterval: 10) // Allow it to be mined
    }

    func testPeerCount() throws {
        let peerCount = try cita.rpc.peerCount()
        XCTAssertTrue(peerCount > 0)
    }

    func testBlockNumber() throws {
        let blockNumber = try cita.rpc.blockNumber()
        XCTAssertTrue(blockNumber > 100)
    }

    func testSendRawTransaction() throws {
        let currentBlock = try cita.rpc.blockNumber()
        let metaData = try cita.rpc.getMetaData()

        let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
        let tx = Transaction(
            to: Address("0x0000000000000000000000000000000000000000"),
            nonce: UUID().uuidString,
            validUntilBlock: currentBlock + 88,
            data: Data.fromHex("6060604052341561000f57600080fd5b60d38061001d6000396000f3006060604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c14606e575b600080fd5b3415605857600080fd5b606c60048080359060200190919050506094565b005b3415607857600080fd5b607e609e565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202d9a0979adf6bf48461f24200e635bc19cd1786efbcfc0608eb1d76114d405860029")!,
            chainId: metaData.chainId,
            version: metaData.version
        )
        guard let signed = try? Signer().sign(transaction: tx, with: privateKey) else {
            return XCTFail("Sign tx failed")
        }

        let txhash = try cita.rpc.sendRawTransaction(signedTx: signed)
        XCTAssert(txhash.hasPrefix("0x"))
        XCTAssertEqual(66, txhash.count)
    }

    func testGetBlockByHash() throws {
        let block = try cita.rpc.getBlockByNumber(number: BigUInt(try cita.rpc.blockNumber()), fullTransactions: true)
        let hash = block.hash.toHexString().addHexPrefix()
        let query = try cita.rpc.getBlockByHash(hash: hash, fullTransactions: true)
        XCTAssertEqual(query.hash.toHexString().addHexPrefix(), hash)
    }

    func testGetBlockByNumberNullProof() throws {
        let number = BigUInt(0)
        let block = try cita.rpc.getBlockByNumber(number: number, fullTransactions: true)
        XCTAssertEqual(block.header.number, number)
    }

    func testGetBlockByNumber() throws {
        let currentBlock = try cita.rpc.blockNumber()
        let block = try cita.rpc.getBlockByNumber(number: BigUInt(currentBlock), fullTransactions: true)
        XCTAssertEqual(block.header.number, BigUInt(currentBlock))
    }

    func testGetTransactionReceipt() throws {
        let receipt = try cita.rpc.getTransactionReceipt(txhash: RPCTests.txHashRecentSent!)
        XCTAssertEqual(receipt.transactionHash.toHexString().addHexPrefix(), RPCTests.txHashRecentSent!)
    }

    func testGetLogs() throws {
        var filter = Filter()
        filter.fromBlock = "0x0"
        filter.topics = [["0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2", "0xa84557f35aab907f9be7974487619dd4c05be1430bf704d0c274a7b3efa50d5a", "0x00000000000000000000000000000000000000000000000000000165365f092d"]]
        let logs = try cita.rpc.getLogs(filter: filter)
        XCTAssertTrue(logs.count >= 0)
    }

    func testCall() throws {
        let request = CallRequest(from: "0x46a23e25df9a0f6c18729dda9ad1af3b6a131160", to: "0x6fc32e7bdcb8040c4f587c3e9e6cfcee4025ea58", data: "0x9507d39a000000000000000000000000000000000000000000000000000001653656eae7")
        let data = try cita.rpc.call(request: request)
        XCTAssert(data.hasPrefix("0x"))
    }

    func testGetTransaction() throws {
        let txhash = RPCTests.txHashRecentSent!
        let tx = try cita.rpc.getTransaction(txhash: txhash)
        XCTAssertEqual(tx.hash.toHexString().addHexPrefix(), txhash)
        XCTAssertEqual(tx.unsignedTransaction?.sender.address, "0x46a23e25df9a0f6c18729dda9ad1af3b6a131160")
    }

    func testGetTransactionCountByBlockNumber() throws {
        let count = try cita.rpc.getTransactionCount(address: "0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523", blockNumber: "0xf5dc9")
        XCTAssert(count >= 0)
    }

    func testGetTransactionCountLatest() throws {
        let count = try cita.rpc.getTransactionCount(address: "0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523", blockNumber: "latest")
        XCTAssertTrue(count >= 0)
    }

    func testGetTransactionCountByAddress() throws {
        let address = Address("0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523")!
        let count = try cita.rpc.getTransactionCount(address: address, blockNumber: "latest")
        XCTAssertTrue(count >= 0)
    }

    func testGetCode() throws {
        let code = try cita.rpc.getCode(address: "0xd8fb3e5600a682f340761280ccf9d29c7ee114a7", blockNumber: "latest")
        XCTAssert(code.hasPrefix("0x"))
    }

    func testGetAbi() throws {
        let code = try cita.rpc.getAbi(address: "0xb93b22a67D724A3487C2BD83a4aaac66F1B7C882", blockNumber: "latest")
        XCTAssert(code.hasPrefix("0x"))
    }

    func testGetBalance() throws {
        let balance = try cita.rpc.getBalance(address: "0x4b5ae4567ad5d9fb92bc9afd6a657e6fa13a2523", blockNumber: "0xf5dc9")
        XCTAssertTrue(balance >= 0)
    }

    func testNewFilter() throws {
        var filter = Filter()
        filter.fromBlock = "0x0"
        filter.topics = [["0xe4af93ca7e370881e6f1b57272e42a3d851d3cc6d951b4f4d2e7a963914468a2", "0xa84557f35aab907f9be7974487619dd4c05be1430bf704d0c274a7b3efa50d5a", "0x00000000000000000000000000000000000000000000000000000165365f092d"]]
        let id = try cita.rpc.newFilter(filter: filter)
        XCTAssertTrue(id > 0)
    }

    func testNewBlockFilter() throws {
        let id = try cita.rpc.newBlockFilter()
        XCTAssertTrue(id > 0)
    }

    func testUninstallFilter() throws {
        let filterID = try cita.rpc.newBlockFilter()
        let uninstalled = try cita.rpc.uninstallFilter(filterID: filterID)
        XCTAssertTrue(uninstalled)

        let uninstalledAgain = try cita.rpc.uninstallFilter(filterID: filterID)
        XCTAssertFalse(uninstalledAgain)
    }

    func testGetFilterChanges() throws {
        let changes = try cita.rpc.getFilterChanges(filterID: 1)
        XCTAssertTrue(changes.count >= 0)
    }

    func testGetFilterLogs() throws {
        let changes = try cita.rpc.getFilterLogs(filterID: 1)
        XCTAssertTrue(changes.count >= 0)
    }

    func testGetTransactionProof() throws {
        let proof = try cita.rpc.getTransactionProof(txhash: RPCTests.txHashRecentSent!)
        XCTAssert(proof.hasPrefix("0x"))
    }

    func testGetMetaData() throws {
        let metaData = try cita.rpc.getMetaData(blockNumber: "latest")
        XCTAssertEqual(metaData.chainName, "test-chain")
    }

    func testGetBlockHeader() throws {
        let blockNumber = try cita.rpc.blockNumber()
        let blockHeader = try cita.rpc.getBlockHeader(blockNumber: blockNumber - 1)
        XCTAssert(blockHeader.hasPrefix("0x"))
    }

    func xtestGetStateProof() throws {
        let proof = try cita.rpc.getStateProof(address: "0xad54ae137c6c39fa413fa1da7db6463e3ae45664", key: "0xa40893b0c723e74515c3164afb5b2a310dd5854fac8823bfbffa1d912e98423e", blockNumber: "latest")
        XCTAssertEqual(proof, "0xf902a594ad54ae137c6c39fa413fa1da7db6463e3ae45664f901eeb90114f9011180a088e2efeed0516020141cbbba149711e0ce67634363097a441520704040aa8dd9a0479ca451cdb343dd2eedbf313e805983e87c0f4f16e9c14f28ab3f1750eb1b8e80a0dd94e00536c62d8c801b8496fb0834ab7225954bac452a7d14c0f4a35df81074a07c689f1111314c391b164c458f902366bb18b90a53d9000a1ffd41abc96373d380808080a0b219eebc746ca232aa4a839213565d1932b4b952c93c5aa585e226ac5412d836a0b758264786a8fb6eaa6f7f2185a3f38111de3c532517ef4e46b99b80e4866d27a093ddedf515207b9a68b50f5f344aae23e709316d96345b146746ae2e511893178080a03b5530655278a731d4c895c92359fb217c64f9fde0c6945339863638396627f480b853f851808080808080808080808080a0d7a0fd35748eceb8fc8040517033416adcfb5523f4abe9789b749700c36b4ba5a0e4fe51db54afdd475e2c50888623567385f2b3694ffdb33c92a1bc782de44be7808080b880f87e942054ae137c6c39fa413fa1da7db6463e3ae45664b867f8658080a0a860517f2f639d5c3e9e8a8c04ef6c71018e18cd0881099776a73653973f90a4a00f1cd9fb6dda499878b60cdb90cf0acf25424afb5583131e4dff5e512cd64a4da0c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470a0a40893b0c723e74515c3164afb5b2a310dd5854fac8823bfbffa1d912e98423ef87cb853f851a02c839c2946385ef0a820355b6969c49c97bdaa6a19b02384bcc39c992046d6b9808080808080808080a051be428c087e3544a47f273c93ffcb9999267593d3b36042a9d3e96ed068fceb808080808080a6e5a0340893b0c723e74515c3164afb5b2a310dd5854fac8823bfbffa1d912e98423e83827a02")
    }
}
