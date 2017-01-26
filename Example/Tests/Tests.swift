//
//  Tests.swift
//  Tests
//
//  Created by Patrick Balestra on 1/25/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import ValueStepper

class Tests: XCTestCase {
    
    func test_incrementAtLowerBound() {
        let stepper = ValueStepper()
        stepper.value = 0
        stepper.stepValue = 1
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        XCTAssertEqual(stepper.value, 0)
        stepper.increase(UIButton())
        XCTAssertEqual(stepper.value, 1)
    }

    func test_incrementAtUpperBound() {
        let stepper = ValueStepper()
        stepper.value = 100
        stepper.stepValue = 1
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        XCTAssertEqual(stepper.value, 100)
        stepper.increase(UIButton())
        XCTAssertEqual(stepper.value, 100)
    }

    func test_decrementAtLowerBound() {
        let stepper = ValueStepper()
        stepper.value = 0
        stepper.stepValue = 1
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        XCTAssertEqual(stepper.value, 0)
        stepper.decrease(UIButton())
        XCTAssertEqual(stepper.value, 0)
        // isEnabled tests
    }

    func test_decrementAtUpperBound() {
        let stepper = ValueStepper()
        stepper.value = 100
        stepper.stepValue = 1
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        XCTAssertEqual(stepper.value, 100)
        stepper.decrease(UIButton())
        XCTAssertEqual(stepper.value, 99)
    }

    func test_buttonAreSetUpC() {
        let stepper = ValueStepper()
        stepper.value = 50
        stepper.stepValue = 1
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        XCTAssertTrue(stepper.decreaseButton.isEnabled)
        XCTAssertTrue(stepper.increaseButton.isEnabled)
    }

    func test_buttonAreSetUpAtUpperBound() {
        let stepper = ValueStepper()
        stepper.value = 100
        stepper.stepValue = 1
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        XCTAssertTrue(stepper.decreaseButton.isEnabled)
        XCTAssertFalse(stepper.increaseButton.isEnabled)
    }

    func test_buttonAreSetUpAtLowerBound() {
        let stepper = ValueStepper()
        stepper.value = 0
        stepper.stepValue = 1
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        XCTAssertTrue(stepper.increaseButton.isEnabled)
        XCTAssertFalse(stepper.decreaseButton.isEnabled)
    }
}
