//
//  RutUtils.swift
//  chileanRutUtils
//
//  Created by Charles Moncada Pizarro on 16-11-19.
//

import Foundation

public enum RutUtils {

    // MARK: - Methods to check a given RUT is correct

    /// This method wil check first if the given rut israw or correct formatted , and second if its a valid chilean rut number
    /// Returns a tuple group (bool, and correct format string)
    ///
    /// - Parameter rut: chilean rut string, can be formatted with hypen and dots, or a string.
    public static func validateRUT(_ rut: String) -> (isValid: Bool, formatted: String) {

        guard rut.matchesRutPatterns else {
            return (false, rut)
        }

        let cleanedRut = cleanRut(rut)
        return (isValidRut(cleanedRut), formatRut(cleanedRut))
    }

    /// This method will check if the rut is mathematically correct.
    ///
    /// - Parameter string: chilean rut numbers  with verification digit
    public static func isValidRut(_ rut: String) -> Bool {
        var rutBody = rut

        guard rut.matchesRutPatterns else { return false }

        let lastChar = String(rutBody.removeLast())
        let digit = getValidationDigit(of: rutBody)

        switch digit {
        case 11:
            return lastChar == "0"
        case 10:
            return lastChar.lowercased() == "k"
        default:
            return Int(lastChar) == digit
        }
    }

    /// This method returns a correct formated chilean rut string
    ///
    /// - Parameter rut: chilean valid rut string, can be formatted with hypen and dots, or a string.
    public static func formatRut(_ rut: String) -> String {

        var cleanedRut = cleanRut(rut)

        guard rut.count > 1 else {
            return rut
        }

        //Get dv and body rut
        let validationDigit = cleanedRut.removeLast()

        //Reverse the string
        let reversedCleanedRut = cleanedRut.reversed()

        //Group rutBody by maxLength of 3, glue it with separator, reverse it
        let formattedRutBody = String(
            reversedCleanedRut
                .groupedBy(3)
                .joined(separator: ".")
                .reversed()
        )

        return "\(formattedRutBody)-\(validationDigit)"
    }

    // MARK: - Methods to generate Valid RUT

    /// This method will calculate the digit verifier from a rut body
    ///  Returns and Int from 0 to 11
    ///
    /// - Parameter rutBody: the chilean rut number, but without the identifier number.
    public static func getValidationDigit(of rutBody: String) -> Int {

        struct RutValidatorGenerator: Sequence, IteratorProtocol {
            var current = 0

            mutating func next() -> Int? {
                defer { current += 1 }

                return current % 6 + 2
            }
        }

        let validateChar = rutBody.reversed()

        let validatorSequence = RutValidatorGenerator().prefix(validateChar.count)
        let sum = zip(validateChar, validatorSequence).map { Int(String($0))! * $1 }.reduce(0, +)
        let digit = 11 - sum % 11

        return digit
    }

    /// This method will return the full chilean rut with generated digit verifier, it will tell:
    ///  first if its valid, second the formetted chilean rut, and its raw string.
    ///
    /// - Parameter rutBody: the chilean rut number, but without the identifier number.
    public static func getValidRut(of rutBody: String) -> (formatted: String, rawRut: String) {
        let cleanRutBody = cleanRut(rutBody)
        let digit = getValidationDigit(of: cleanRutBody)

        var digitV = ""

        switch digit {
        case 11:
            digitV = "0"
        case 10:
            digitV = "k"
        default:
            digitV = String(digit)
        }

        let rut = cleanRutBody + String(digitV)
        let formattedRut = formatRut(rut)
        return (formattedRut, rut)
    }

    // MARK: - Utils

    /// This method returns a string and removes dots and hypen from the rut,
    /// it will also remove any other foreign chracters too.
    ///
    /// - Parameter rut: chilean rut string, can be formatted with hypen and dots, or a string.
    public static func cleanRut(_ rut: String) -> String {
        let cleanRut = rut.replacingOccurrences(of: String.allowedRutCharacters, with: "", options: .regularExpression)
        return cleanRut
    }
}

// MARK: - Private Extensions

private extension String {

    // MARK: REGEX Patterns

    static let allowedRutCharacters = #"[^\d,^k^K]"#

    static let rutFormattedPattern = """
    ^[0-9]{1,3} # chequea si hay 2 o 3 numeros iniciales
    (\\.[0-9]{3})* # chequea los bloques .XXX
    \\- # signo de division de digito identificador
    [0-9,kK] # digito identificador
    """

    static let rutRawPattern = """
    ^[0-9] # un primer digito
    [0-9]* # varios digitos
    [0-9,kK]$ # puede terminar en k como digito verificador
    """

    var matchesRutPatterns: Bool {
        return NSRegularExpression.rutFormatted.matches(self) || NSRegularExpression.rutRaw.matches(self)
    }
}

private extension NSRegularExpression {

    // MARK: REGEX definitions

    static let rutFormatted = try! NSRegularExpression(
        pattern: String.rutFormattedPattern,
        options: .allowCommentsAndWhitespace
    )

    static let rutRaw = try! NSRegularExpression(
        pattern: String.rutRawPattern,
        options: .allowCommentsAndWhitespace
    )

    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

private extension ReversedCollection where Base == String {
    /// This method returns an array of grouped strings of given length
    ///
    /// - Parameter length: max length string to group
    func groupedBy(_ length: Int) -> [String] {
        return
            stride(from: 0, to: self.count, by: length)
            .map {
                let start = self.index(self.startIndex, offsetBy: $0)
                let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
                return String(self[start..<end])
            }
    }
}
