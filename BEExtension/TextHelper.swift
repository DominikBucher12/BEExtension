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
    
    
    
    /// From buffer, we get the selected Line indexes to further work with
    ///
    /// - Parameters:
    ///   - buffer: buffer we use 🤷🏻‍♂️
    ///   - completion: bool for indicating success, buffer and array of line indexes to iterate and find our line Strings
    class func getSelectedLineIndexes(fromBuffer buffer: XCSourceTextBuffer, completion: (Bool, XCSourceTextBuffer, [Int]?) -> Void){
        guard let selectedRange = buffer.selections as? [XCSourceTextRange],
              let theOnlySelectedRange = selectedRange.first
              else {
            completion(false, buffer, nil)
            return
        }
        //Fast, clean, no useless variables declarations, we simply return selected line indexes
        completion(true, buffer, Array(theOnlySelectedRange.start.line...theOnlySelectedRange.end.line))
    }
    
    
    
    /// This method should be universal and implemented right from Apple. (excluding the condition for case OC)
    ///  gets specified text from line indexes
    ///
    /// - Parameters:
    ///   - buffer: buffer to work with(usually the same instance as in all other functions)
    ///   - indexes: indexes of lines to get text bounded to them
    /// - Returns: returns array of texts on specific lines
    class func getSelectedLinesText(withBuffer buffer: XCSourceTextBuffer, withIndexes indexes: [Int]) -> [String]{
        var lines = [String]()
        for index in indexes{
            
            if let line = buffer.lines[index] as? String{
                
                if line.contains("case"){
                    lines.append(line)
                }
            }
        }
        return lines
    }
    
    /// From selected text filters out the case words and awful things like enum asociatedTypes brackets, rawValue's equal marks etc
    ///
    /// - Parameter text: Array of line strings (looks for instance like this: "`case` myLeastFavouriteEnumCase(AnyObject)")
    /// - Returns: [.myLeastFavouriteEnumCase, .anotherCase, .tellMeSomeThingNew]
    class func getPreparedWords(fromText text: [String]) -> [String]{
        return text.map({$0.extractWordInEnum() ?? ""})
    }
    
    /// Generates variable based on previous selected enum cases 🤗
    ///
    /// - Parameters:
    ///   - cases: clear words dropped case mark and argument brackets and other stuff
    ///   - tabWidth: (count of spaces from left)
    /// - Returns: Beautiful generated enum variable
    class func generateVariable(withEnumCases cases: [String], withTabWidth tabWidth: Int) -> String{
        let indent = String(repeating: " ", count: tabWidth)
        let doubleIndent = String(repeating: " ", count: 2*tabWidth)
        let casesStr = cases.map { "\n\(doubleIndent)case .\($0):\n" + "\(indent)\(doubleIndent)return <#value#>\n" }.joined()
        
        // Should be fine:
        // var <#name#>: <#type#>{
        //     switch self{
        //    case generated:
        //     return <#value#>
        return "\(indent)var <#name#>: <#type#>{\n" +
            "\(doubleIndent)switch self {\n" +
            "\(casesStr)\(doubleIndent)}\n" +
        "\(indent)}\n\n"
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
        let casesStr = cases.map { "\n\(doubleIndent)case .\($0):\n"+"\(indent)\(doubleIndent)return <#type#>\n" }.joined()
        
        // Should be fine:
        // switch <#name#>{
        //    case generated:
        //     return <#value#>
        return "\(indent)switch <#name#> {\n" +
            "\(casesStr)\(doubleIndent)}\n" +
        "\(indent)}\n"
    }
    
    
    
    
    
    
    
    
}
