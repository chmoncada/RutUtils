//
//  RutUtils.swift
//  chileanRutUtils
//
//  Created by Charles Moncada Pizarro on 16-11-19.
//

import Foundation

public enum RutUtils {

    // MARK: - REGEX Patterns

    private static let allowedRutCharacters = #"[^\d,^k^K]"#

    private static let patternFormatted = """
    ^[0-9]{1,2} # chequea si hay 2 o 3 numeros iniciales
    (\\.[0-9]{3})* # chequea los bloques .XXX
    \\- # signo de division de digito identificador
    [0-9,kK] # digito identificador
    """

    private static let patternRaw = """
    ^[0-9] # un primer digito
    [0-9]* # varios digitos
    [0-9,kK]$ # puede terminar en k como digito verificador
    """

    // MARK: - REGEX definitions

    private static let regexFormatted = try? NSRegularExpression(
        pattern: patternFormatted,
        options: .allowCommentsAndWhitespace
    )

    private static let regexRaw = try? NSRegularExpression(
        pattern: patternRaw,
        options: .allowCommentsAndWhitespace
    )

    // MARK: - Methods to check a given RUT is correct

    /// This method wil check first if the given rut israw or correct formatted , and second if its a valid chilean rut number
    /// Returns a tuple group (bool, and correct format string)
    ///
    /// - Parameter rut: chilean rut string, can be formatted with hypen and dots, or a string.
    public static func validateRUT(_ rut: String) -> (isValid: Bool, formatted: String) {

        guard
            let regexFormatted = regexFormatted,
            let regexRaw = regexRaw,
            regexFormatted.matches(rut) || regexRaw.matches(rut)
        else {
                return (false, rut)
        }

        let cleanedRut = cleanRut(rut)

        let endIndex = cleanedRut.index(cleanedRut.endIndex, offsetBy: -1)
        let rutWithNoDV = String(cleanedRut[..<endIndex])
        var multiplier = 2
        var total = 0
        for current in String(rutWithNoDV.reversed()) {
            total += Int(String(current))! * multiplier
            multiplier += 1
            if multiplier > 7 {
                multiplier = 2
            }
        }
        return ((((11 - total % 11 == 10) ?
            "k" : 11 - total % 11 == 11 ? "0" :
            String(11 - total % 11)) == String(describing: cleanedRut.last!).lowercased()), formatRut(cleanedRut))

    }

    /// This method returns a correct formated chilean rut string
    ///
    /// - Parameter rut: chilean valid rut string, can be formatted with hypen and dots, or a string.
    public static func formatRut(_ rut: String) -> String! {

        guard rut.count > 1 else {
            return rut
        }

        var counter = 0
        var formattedRut: String
        var rut = rut.replacingOccurrences(of: ".", with: "")
        rut = rut.replacingOccurrences(of: "-", with: "")
        formattedRut = "-" + String(describing: rut.last!)
        for index in (0...(rut.count - 2)).reversed() {
            let subString = rut.dropFirst(index).first!
            formattedRut = String(describing: subString) + formattedRut
            counter += 1
            if counter == 3 && index != 0 {
                formattedRut = "." + formattedRut
                counter = 0
            }
        }

        return formattedRut
    }

    // MARK: - Utils

    /// This method returns a string and removes dots and hypen from the rut,
    /// it will also remove any other foreign chracters too.
    ///
    /// - Parameter rut: chilean rut string, can be formatted with hypen and dots, or a string.
    public static func cleanRut(_ rut: String) -> String {
        let cleanRut = rut.replacingOccurrences(of: allowedRutCharacters, with: "", options: .regularExpression)
        return cleanRut
    }
}

// MARK: - Private Extensions

private extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
