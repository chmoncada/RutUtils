//
//  RutUtilsTests.swift
//  chileanRutUtils_Tests
//
//  Created by Charles Moncada Pizarro on 16-11-19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

@testable import RutUtils
import XCTest

// swiftlint:disable type_body_length
class RutUtilsTests: XCTestCase {

    // MARK: - validateRUT invalid test
    func testEmpty() {
        let validator = RutUtils.validateRUT("")
        XCTAssertFalse(validator.isValid)
    }

    func testInvalidOne() {
        let validator = RutUtils.validateRUT("I")
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, "I")
    }

    func testInvalidTwo() {
        let validator = RutUtils.validateRUT("IN")
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, "IN")
    }

    func testInvalidThree() {
        let validator = RutUtils.validateRUT("INV")
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, "INV")
    }

    func testInvalidFour() {
        let validator = RutUtils.validateRUT("INVA")
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, "INVA")
    }

    func testInvalidFive() {
        let validator = RutUtils.validateRUT("INVAL")
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, "INVAL")
    }

    func testInvalidSix() {
        let validator = RutUtils.validateRUT("INVALI")
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, "INVALI")
    }

    func testInvalidFull() {
        let validator = RutUtils.validateRUT("INVALID")
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, "INVALID")
    }

    func testValidFormatInvalidRut() {
        let invalidRut = "19.200.923-1"
        let validator = RutUtils.validateRUT(invalidRut)
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, invalidRut)
    }

    func testInValidFormatWrongDotsPosition() {
        //dots shuld be on groups of numbers step 3
        let invalidFormatRut = "19.20.09.23-1"
        let validator = RutUtils.validateRUT(invalidFormatRut)
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, invalidFormatRut)
    }

    // MARK: - validateRUT Test

    func testValidRutLengthOne() {
        let unformattedRut = "1"
        let formattedRut = "1"
        let validator = RutUtils.validateRUT(unformattedRut)

        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    func testValidRutLengthTwo() {
        let unformattedRut = "19"
        let formattedRut = "1-9"
        let validator = RutUtils.validateRUT(unformattedRut)

        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    func testValidRutLengthThree() {
        let unformattedRut = "124"
        let formattedRut = "12-4"
        let validator = RutUtils.validateRUT(unformattedRut)

        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    func testValidRutLengthFour() {
        let unformattedRut = "345K"
        let formattedRut = "345-K"
        let validator = RutUtils.validateRUT(unformattedRut)

        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    func testValidRutLengthFive() {
        let unformattedRut = "64572"
        let formattedRut = "6.457-2"
        let validator = RutUtils.validateRUT(unformattedRut)

        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    func testValidFormatValidRut() {
        let validRut = "19.200.923-5"
        let validator = RutUtils.validateRUT(validRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, validRut)
    }

    func testInValidFormatNoHypen() {
        //no hypen
        let unformattedRut = "14.400.4035"
        let formattedRut = "14.400.403-5"
        let validator = RutUtils.validateRUT(unformattedRut)

        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, unformattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    func testHypenSemiUnFormattedValidFormatValidRut() {
        //no dots
        let unformattedRut = "19200923-5"
        let formattedRut = "19.200.923-5"

        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, unformattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    func testDigitK() {
        let unformattedRut = "20961605-K"
        let formattedRut = "20.961.605-K"
        let validator = RutUtils.validateRUT(unformattedRut)

        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, unformattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    func testDigitKSmallCap() {
        let unformattedRut = "20961605-k"
        let formattedRut = "20.961.605-k"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertFalse(validator.isValid)
        XCTAssertEqual(validator.formatted, unformattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    func testDigit0() {
        let unformattedRut = "14.400.400-0"
        let formattedRut = "14.400.400-0"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testDigit1() {
        let unformattedRut = "14.400.405-1"
        let formattedRut = "14.400.405-1"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testDigit2() {
        let unformattedRut = "14.400.413-2"
        let formattedRut = "14.400.413-2"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testDigit3() {
        let unformattedRut = "14.400.404-3"
        let formattedRut = "14.400.404-3"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testDigit4() {
        let unformattedRut = "14.400.409-4"
        let formattedRut = "14.400.409-4"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testDigit5() {
        let unformattedRut = "14.400.403-5"
        let formattedRut = "14.400.403-5"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testDigit6() {
        let unformattedRut = "14.400.408-6"
        let formattedRut = "14.400.408-6"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testDigit7() {
        let unformattedRut = "14.400.402-7"
        let formattedRut = "14.400.402-7"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testDigit8() {
        let unformattedRut = "14.400.407-8"
        let formattedRut = "14.400.407-8"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testDigit9() {
        let unformattedRut = "14.400.401-9"
        let formattedRut = "14.400.401-9"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
    }

    func testUnFormattedValidFormatValidRut() {
        //no hypen, no dots
        let unformattedRut = "192009235"
        let formattedRut = "19.200.923-5"
        let validator = RutUtils.validateRUT(unformattedRut)
        XCTAssertTrue(validator.isValid)
        XCTAssertEqual(validator.formatted, formattedRut)

        let realFormatedRut = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(formattedRut, realFormatedRut)
    }

    // MARK: - formatedRut Test

    func testFormattedEmpty() {
        let unformattedRut = ""
        let formattedRut = ""
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedLength1() {
        let unformattedRut = "1"
        let formattedRut = "1"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedLength2() {
        let unformattedRut = "19"
        let formattedRut = "1-9"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedLength3() {
        let unformattedRut = "124"
        let formattedRut = "12-4"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedLength4() {
        let unformattedRut = "345K"
        let formattedRut = "345-K"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedLength5() {
        let unformattedRut = "64572"
        let formattedRut = "6.457-2"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigitK() {
        let unformattedRut = "20961605K"
        let formattedRut = "20.961.605-K"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigitKSmallCap() {
        let unformattedRut = "20961605k"
        let formattedRut = "20.961.605-k"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit0() {
        let unformattedRut = "144004000"
        let formattedRut = "14.400.400-0"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit1() {
        let unformattedRut = "14.400.405-1"
        let formattedRut = "14.400.405-1"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit2() {
        let unformattedRut = "144004132"
        let formattedRut = "14.400.413-2"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit3() {
        let unformattedRut = "144004043"
        let formattedRut = "14.400.404-3"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit4() {
        let unformattedRut = "144004094"
        let formattedRut = "14.400.409-4"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit5() {
        let unformattedRut = "144004035"
        let formattedRut = "14.400.403-5"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit6() {
        let unformattedRut = "144004086"
        let formattedRut = "14.400.408-6"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit7() {
        let unformattedRut = "144004027"
        let formattedRut = "14.400.402-7"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit8() {
        let unformattedRut = "144004078"
        let formattedRut = "14.400.407-8"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    func testFormattedDigit9() {
        let unformattedRut = "144004019"
        let formattedRut = "14.400.401-9"
        let result = RutUtils.formatRut(unformattedRut)
        XCTAssertEqual(result, formattedRut)
    }

    // MARK: - cleanRut Method Test

    func testCleanFormatedRut() {
        let unformattedRut = "14.400.407-8"
        let expectedCleanRut = "144004078"
        let cleanRut = RutUtils.cleanRut(unformattedRut)
        XCTAssertEqual(cleanRut, expectedCleanRut)
    }

    func testCleanFormatedRutDigitK() {
        let unformattedRut = "20.961.605-K"
        let expectedCleanRut = "20961605K"
        let cleanRut = RutUtils.cleanRut(unformattedRut)
        XCTAssertEqual(cleanRut, expectedCleanRut)
    }

    func testCleanFormatedRutDigitKSmall() {
        let unformattedRut = "20.961.605-k"
        let expectedCleanRut = "20961605k"
        let cleanRut = RutUtils.cleanRut(unformattedRut)
        XCTAssertEqual(cleanRut, expectedCleanRut)
    }

    func testCleanBadRutCharacters() {
        let unformattedRut = "1abcd#)(-9"
        let expectedCleanRut = "19"
        let cleanRut = RutUtils.cleanRut(unformattedRut)
        XCTAssertEqual(cleanRut, expectedCleanRut)
    }

    func testCleanEmptyRut() {
        let unformattedRut = ""
        let expectedCleanRut = ""
        let cleanRut = RutUtils.cleanRut(unformattedRut)
        XCTAssertEqual(cleanRut, expectedCleanRut)
    }

    // MARK: - isValidRut Method Basic Tests

    func testCoreValidRutPositive() {
        let unformattedRut = "144004019"
        let isValid = RutUtils.isValidRut(unformattedRut)
        XCTAssertTrue(isValid)
    }

    func testCoreValidRutNegative() {
        let unformattedRut = "144004010"
        let isValid = RutUtils.isValidRut(unformattedRut)
        XCTAssertFalse(isValid)
    }

    func testCoreValidRutDigitCapitalK() {
        let unformattedRut = "20961605K"
        let isValid = RutUtils.isValidRut(unformattedRut)
        XCTAssertTrue(isValid)
    }

    func testCoreValidRutDigitSmallK() {
        let unformattedRut = "20961605k"
        let isValid = RutUtils.isValidRut(unformattedRut)
        XCTAssertTrue(isValid)
    }

    func testCoreValidRutDigitCapitalKNegative() {
        let unformattedRut = "20961604K" //bad rut, no k
        let isValid = RutUtils.isValidRut(unformattedRut)
        XCTAssertFalse(isValid)
    }

    func testCoreValidRutDigitSmallKNegative() {
        let unformattedRut = "20961604k" //bad rut, no k
        let isValid = RutUtils.isValidRut(unformattedRut)
        XCTAssertFalse(isValid)
    }

    func testCoreValidRutEmpty() {
        let unformattedRut = ""
        let isValid = RutUtils.isValidRut(unformattedRut)
        XCTAssertFalse(isValid)
    }

    func testCoreValidRutOneChar() {
        let unformattedRut = "1"
        let isValid = RutUtils.isValidRut(unformattedRut)
        XCTAssertFalse(isValid)
    }

    func testCoreValidRutTwoChar() {
        let unformattedRut = "19"
        let isValid = RutUtils.isValidRut(unformattedRut)
        XCTAssertTrue(isValid)
    }

    // MARK: - calculate Validation Digit

    func testCalculateRutDvDigitK() {
        let bodyRut = "9043943"
        let validationDigit = 10
        let calculatedDV = RutUtils.getValidationDigit(of: bodyRut)
        XCTAssertEqual(calculatedDV, validationDigit)
    }

    func testCalculateRutDvDigit6() {
        let bodyRut = "14400408"
        let validationDigit = 6
        let calculatedDV = RutUtils.getValidationDigit(of: bodyRut)
        XCTAssertEqual(calculatedDV, validationDigit)
    }

    // MARK: - getValidRut method

    func testGetRutDigitKSmall() {
        let bodyRut = "9043943"
        let formattedRut = "9.043.943-k"
        let rawRut = "9043943k"
        let validator = RutUtils.getValidRut(of: bodyRut)
        XCTAssertTrue(RutUtils.validateRUT(validator.formatted).isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
        XCTAssertEqual(validator.rawRut, rawRut)
    }

    func testGetRutDigit6() {
        let bodyRut = "14400408"
        let formattedRut = "14.400.408-6"
        let rawRut = "144004086"
        let validator = RutUtils.getValidRut(of: bodyRut)
        XCTAssertTrue(RutUtils.validateRUT(validator.formatted).isValid)
        XCTAssertEqual(validator.formatted, formattedRut)
        XCTAssertEqual(validator.rawRut, rawRut)
    }
}
