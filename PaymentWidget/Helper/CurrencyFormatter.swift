//
//  CurrencyFormatter.swift
//  PaymentWidgetExtension
//
//  Created by Pheayuit.Yen    on 4/2/25.
//

import Foundation

class CurrencyFormatter {
    
    // 1. Using NumberFormatter for basic currency formatting
    static func basicCurrencyFormat(_ amount: Double, currencyCode: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: NSNumber(value: amount)) ?? "Invalid Amount"
        // Ex Output: $1,234.56
    }
    
    // 2. Customized currency formatting with specific locale
    static func localizedCurrencyFormat(_ amount: Double, locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: amount)) ?? "Invalid Amount"
        // European formatting (Euro)
        // print(CurrencyFormatter.localizedCurrencyFormat(amount, locale: Locale(identifier: "de_DE")))
        // Ex Output: 1.234,56 €
    }
    
    // 3. Formatting with custom decimal and grouping styles
    static func preciseCurrencyFormat(_ amount: Double,
                                      currencyCode: String = "USD",
                                      minimumFractionDigits: Int = 2,
                                      maximumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: NSNumber(value: amount)) ?? "Invalid Amount"
        // Japanese Yen (no decimal places)
//            print(CurrencyFormatter.preciseCurrencyFormat(amount,
//                                                          currencyCode: "JPY",
//                                                          minimumFractionDigits: 0,
//                                                          maximumFractionDigits: 0))
        // Ex Output: ¥1,235
    }
    
    // 4. Parsing currency string back to a numeric value
    static func parseCurrency(_ currencyString: String, locale: Locale = Locale.current) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.number(from: currencyString)?.doubleValue
        // Parsing back to numeric value
        //  if let parsedAmount = CurrencyFormatter.parseCurrency("$1,234.56") {
        //    print(parsedAmount) // Output: 1234.56
        //  }
    }
    
}
