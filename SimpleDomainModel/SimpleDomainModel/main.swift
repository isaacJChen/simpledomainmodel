//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    private let conversions: [String: Double] = [
        "GBP": 0.5,
        "USD": 1,
        "EUR": 1.5,
        "CAN": 1.25
    ]

    
    public func convert(_ to: String) -> Money {
        let amount: Int = Int((Double(self.amount) / conversions[self.currency]! * conversions[to]!))
        let convertedMoney: Money = Money(amount: amount, currency:to)
        print(convertedMoney.amount)
        return convertedMoney
    }
    
    public func add(_ to: Money) -> Money {
        let amount: Int = self.convert(to.currency).amount + to.amount
        return Money(amount: amount, currency:to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        let amount: Int = self.convert(from.currency).amount - from.amount
        return Money(amount: amount, currency:from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType

    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
        
        func get() -> (Double, String) {
            switch self {
            case .Salary(let num):
                return (Double(num), "Salary")
            case .Hourly(let num):
                return (num, "Hourly")
            }
        }
        
        func raise(_ amount: Double) -> JobType {
            switch self {
            case .Salary(let num):
                return JobType.Salary(Int(Double(num) + amount))
            case .Hourly(let num):
                return JobType.Hourly(num + amount)
            }
        }
    }

    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }

    open func calculateIncome(_ hours: Int) -> Int {
        let tup:(Double, String) = self.type.get()
        return tup.1 == "Salary" ? Int(tup.0) : Int(tup.0 * Double(hours))
    }

    open func raise(_ amt : Double) {
        self.type = self.type.raise(amt)
    }
}

//////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0

    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { return self._job }
        set(value) {
            self._job = self.age >= 18 ? value : nil
        }
    }

    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return self._spouse}
        set(value) {
            self._spouse = self.age >= 18 ? value : nil
        }
    }

    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self._job) spouse:\(self._spouse)]"
    }
}

//////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []

    public init(spouse1: Person, spouse2: Person) {
        self.members.append(spouse1)
        self.members.append(spouse2)
    }

    open func haveChild(_ child: Person) -> Bool {
        var canHaveKids = true
        self.members.forEach { (person) in
            if person.age < 21 && person._spouse != nil {
                canHaveKids = false
            }
        }
        
        if canHaveKids{
            self.members.append(child)
        }
        
        return canHaveKids
    }

    open func householdIncome() -> Int {
        var income = 0
        self.members.forEach { (person) in
            if person._job != nil{
                income += (person._job?.calculateIncome(2000))!
            }
        }
        return income
    }
}






