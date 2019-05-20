//
//  TDDTestTests.swift
//  TDDTestTests
//
//  Created by 최혜선 on 15/05/2019.
//  Copyright © 2019 ulike. All rights reserved.
//

import XCTest
@testable import TDDTest

protocol Expression {
    func reduce(to: String) -> Money
}

protocol MoneyProtocol {
    func currency() -> String
    func times(multiplier: Int) -> Money
}

public class Bank {
    func reduce(source: Expression, to: String) -> Money {
        return source.reduce(to: to)
    }
}

public class Sum: Expression {
    let augend: Money!
    let addend: Money!
    
    init(augend: Money, addend: Money) {
        self.augend = augend
        self.addend = addend
    }
    
    func reduce(to: String) -> Money {
        let amount = augend.amount + addend.amount
        return Money(amount: amount, currency: to)
    }
}

public class Money: Equatable, Expression {
    fileprivate var currencyUnit: String = ""
    fileprivate var amount: Int = 0
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currencyUnit = currency
    }
    
    func equals(_ money: Any) -> Bool {
        let money = money as! Money
        return amount == money.amount && currency() == money.currency()
    }
    
    static func dollar(amount: Int) -> Money {
        return Money(amount: amount, currency: "USD")
    }
    
    static func franc(amount: Int) -> Money {
        return Money(amount: amount, currency: "CHF")
    }
    
    func currency() -> String {
        return currencyUnit
    }
    
    func toString() -> String {
        return "\(amount) \(currencyUnit)"
    }
    
    func times(multiplier: Int) -> Money {
        return Money(amount: amount * multiplier, currency: currencyUnit)
    }
    
    func plus(addend: Money) -> Expression {
        return Sum(augend: self, addend: addend)
    }
    
    func reduce(to: String) -> Money {
        return self
    }
    
    public static func == (lhs: Money, rhs: Money) -> Bool {
        return lhs.amount == rhs.amount
    }
}

class TDDTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMultiplication() {
        let five = Money.dollar(amount: 5)
        XCTAssertEqual(Money.dollar(amount: 10), five.times(multiplier: 2))
        XCTAssertEqual(Money.dollar(amount: 15), five.times(multiplier: 3))
    }
    
    func testFrancMultiplication() {
        let five = Money.franc(amount: 5)
        XCTAssertEqual(Money.franc(amount: 10), five.times(multiplier: 2))
        XCTAssertEqual(Money.franc(amount: 15), five.times(multiplier: 3))
    }

    func testEquality() {
        XCTAssertTrue(Money.dollar(amount: 5).equals(Money.dollar(amount: 5)))
        XCTAssertFalse(Money.dollar(amount: 5).equals(Money.dollar(amount: 6)))
        XCTAssertFalse(Money.franc(amount: 5).equals(Money.dollar(amount: 5)))
    }
    
    func testCurrency() {
        XCTAssertEqual("USD", Money.dollar(amount: 1).currency())
        XCTAssertEqual("CHF", Money.franc(amount: 1).currency())
    }
    
    func testSimpleAddition() {
        // $5 만들기
        let five = Money.dollar(amount: 5)
        // 두 Money의 합은 Expression이어야한다
        let sum: Expression = five.plus(addend: five)
        // 간단한 예제에서 Bank가 할 일은 없다
        let bank = Bank()
        let reduced: Money = bank.reduce(source: sum, to: "USD")
        XCTAssertEqual(Money.dollar(amount: 10), reduced)
    }
    
    func testPlusReturnsSum() {
        let five = Money.dollar(amount: 5)
        let result: Expression = five.plus(addend: five)
        let sum: Sum = result as! Sum
        XCTAssertEqual(five, sum.augend)
        XCTAssertEqual(five, sum.addend)
    }
    
    func testReduceSum() {
        let sum = Sum(augend: Money.dollar(amount: 3), addend: Money.dollar(amount: 4))
        let bank = Bank()
        let result = bank.reduce(source: sum, to: "USD")
        XCTAssertEqual(Money.dollar(amount: 7), result)
    }
    
    func testReduceMoney() {
        let bank = Bank()
        let result = bank.reduce(source: Money.dollar(amount: 1), to: "USD")
        XCTAssertEqual(Money.dollar(amount: 1), result)
    }
}
