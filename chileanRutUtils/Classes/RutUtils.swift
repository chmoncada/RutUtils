//
//  RutUtils.swift
//  chileanRutUtils
//
//  Created by Charles Moncada Pizarro on 16-11-19.
//

import Foundation

public class RUTValidator: NSObject {

    public static func validateRUT(rutToEval: String) -> (isValid: Bool, formatedRut: String) {
        let rutRegEx = "^0*(\\d{1,3}(\\.?\\d{3})*)\\-?([\\dkK])$"
        let predicateToEval = NSPredicate(format: "SELF MATCHES %@", rutRegEx)
        var rut = rutToEval.replacingOccurrences(of: ".", with: "")
        rut = rut.replacingOccurrences(of: "-", with: "")

        if predicateToEval.evaluate(with: rut) {

            let endIndex = rut.index(rut.endIndex, offsetBy: -1)
            let rutWithNoDV = String(rut[..<endIndex])
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
                String(11 - total % 11)) == String(describing: rut.last!).lowercased()), formatRut(rutToFormat: rut))
        }

        return (false, rutToEval)
    }

    public static func formatRut(rutToFormat: String) -> String! {
        var counter = 0
        var formatedRut: String
        var rut = rutToFormat.replacingOccurrences(of: ".", with: "")
        rut = rut.replacingOccurrences(of: "-", with: "")
        formatedRut = "-" + String(describing: rut.last!)
        for index in (0...(rut.count - 2)).reversed() {
            let subString = rut.dropFirst(index).first!
            formatedRut = String(describing: subString) + formatedRut
            counter += 1
            if counter == 3 && index != 0 {
                formatedRut = "." + formatedRut
                counter = 0
            }
        }

        return formatedRut
    }
}
