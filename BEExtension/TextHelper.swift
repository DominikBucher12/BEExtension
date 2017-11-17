//
//  TextHelper.swift
//  emptyProject
//
//  Created by Dominik Bucher on 21/05/2017.
//  Copyright © 2017 Dominik Bucher. All rights reserved.
//

import Foundation
import XcodeKit

class TextHelper {

    /// From selected text filters out the case words and awful things like enum asociatedTypes brackets, rawValue's equal marks etc
    ///
    /// - Parameter text: Array of line strings (looks for instance like this: "`case` myLeastFavouriteEnumCase(AnyObject)")
    /// - Returns: [.myLeastFavouriteEnumCase, .anotherCase, .tellMeSomeThingNew]
    class func getPreparedWords(fromText text: [String]) -> [String] {

        let filteredText = text.filter { $0.contains("case ") }

        return filteredText.map { $0.extractWordInEnum() ?? "" }
    }
    
    /// Generates variable based on previous selected enum cases 🤗
    ///
    /// - Parameters:
    ///   - cases: clear words dropped case mark and argument brackets and other stuff
    ///   - tabWidth: (count of spaces from left)
    /// - Returns: Beautiful generated enum variable
    class func generateVariable(withEnumCases cases: [String], withTabWidth tabWidth: Int) -> String {

        let indent = String(repeating: " ", count: tabWidth)
        let doubleIndent = String(repeating: " ", count: 2*tabWidth)
        let casesStr = cases.map { """
            \(doubleIndent)case .\($0):\n
            \(indent)\(doubleIndent)return <#type#>\n
            """
            }
            .joined()
        
        // Should be fine:
        // var <#name#>: <#type#>{
        //     switch self{
        //     case generated:
        //     return <#value#>
        return """
        \(indent)var <#name#>: <#type#>{\n
        \(doubleIndent)switch self {
        \(casesStr)\(doubleIndent)}\n
        \(indent)}\n
        """
    }

    /// Generates switch given on the cases...
    ///
    /// - Parameters:
    ///   - cases: array of cases to fill with return and types
    ///   - tabWidth: spacing from left
    /// - Returns: whole code block of variable
    class func generateSwitch(fromCases cases: [String], tabWidth: Int) -> String {

        let indent = String(repeating: " ", count: tabWidth)
        let doubleIndent = String(repeating: " ", count: 2*tabWidth)
        let casesStr = cases.map { """
            \(doubleIndent)case .\($0):\n
            \(indent)\(doubleIndent) <#case body#>\n
            """
            }
            .joined()
        
        // Should be fine:
        // switch <#name#>{
        //    case generated:
        //     return <#value#>
        return """
                \(indent)switch <#name#> {
                \(casesStr)\(doubleIndent)}\n
                """
    }
}
