//
//  SourceEditorCommand.swift
//  BEExtension
//
//  Created by Dominik Bucher on 21/05/2017.
//  Copyright © 2017 Dominik Bucher. All rights reserved.
//

import Foundation
import XcodeKit

//TODO: Do some refactoring later when adding new features.

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        guard invocation.buffer.contentUTI == Identifiers.ContentUTIs.swiftSource.rawValue else {
            
            let errorWithUTI = createError(withError: .wrongUTI)
            completionHandler(errorWithUTI)
            
            return
            
        }
        TextHelper.getSelectedLineIndexes(fromBuffer: invocation.buffer, completion: { (success, buffer, indexes) in
            guard success,
                  let indexes = indexes, indexes.count > 1 
                  else {
                    let emptySelectionError = createError(withError: .emptySelection)
                    completionHandler(emptySelectionError)
                   
                    return
                    
            }
            let lines = TextHelper.getPreparedWords(fromText: TextHelper.getSelectedLinesText(withBuffer: buffer, withIndexes: indexes))
            
            guard let lastSelectedLine = lastSelectedLine(fromBuffer: invocation.buffer)
                  else {
               
                    completionHandler(nil)
               
                    return
                    
            }
            
            
            let pieceOfCode = codeSnippet(
                                withCommandIdentifier: invocation.commandIdentifier,
                                withWords: lines, 
                                withTabWidth: invocation.buffer.tabWidth
                                )
            
            let linesAhead = self.linesAhead(lastSelectedline: lastSelectedLine, withBuffer: invocation.buffer)
            
            invocation.buffer.lines.insert("\n", at: lastSelectedLine + linesAhead )
            invocation.buffer.lines.insert(pieceOfCode, at: lastSelectedLine + linesAhead + 1)
            completionHandler(nil)
        })
    }
    
    
    func codeSnippet(withCommandIdentifier identifier: String, withWords words: [String], withTabWidth tabWidth: Int ) -> String{
        //  let words = TextHelper.getPreparedWords(fromText: words)
        switch identifier {
        case Identifiers.Commands.makeJustSwitch.rawValue:
            
            return TextHelper.generateSwitch(fromCases: words, tabWidth: tabWidth)
        case Identifiers.Commands.makeVariable.rawValue:
            
            return TextHelper.generateVariable(withEnumCases: words, withTabWidth: tabWidth)
        default:
            
            return "Nothin', sorry..."
            //Cannot happen until we change that rawValue in our enum...
        }
    }
    
    /// Generates our defined error
    ///
    /// - Parameter error: error from possible errors that could occur during text selection
    /// - Returns: NSError to pass to Xcode
    func createError(withError error: Identifiers.PossibleErrors) -> NSError{
        let userInfo: [AnyHashable : Any] =
            [
                NSLocalizedDescriptionKey :  NSLocalizedString(error.errorDescription ?? "neverNil", value: error.errorDescription ?? "NeveNil", comment: "") ,
                ]
        let error = NSError(domain: "com.dominikbucher.xcodeKitError", code: 1, userInfo: userInfo)
        return error
    }
    
    //MARK: Inserting methods
    
    /// returns index of last selected line from buffer
    ///
    /// - Parameter buffer: The only buffer we get
    /// - Returns: index of last line we selected
    private func lastSelectedLine(fromBuffer buffer: XCSourceTextBuffer) -> Int? {
        if let range = (buffer.selections.lastObject as? XCSourceTextRange){
            
            return range.end.line
        }
        
        return nil
    }
    
    
    // TODO: Implement function that will automatically add default case when not selected all enum cases
    /// Returns lines below our selected text (to be a bit idiotproof, but not too much) - if we find something in our way, we simply skip that or break on next var, enum end or next enum in enum...
    ///
    /// - Parameters:
    ///   - line: the last line we selected
    ///   - buffer: text buffer upon we are working
    /// - Returns: returns how many lines from selected text we need to skip to extract nice piece of code...
    private func linesAhead(lastSelectedline line: Int, withBuffer buffer: XCSourceTextBuffer) -> Int{
        var linesAhead = 0
        for index in line...buffer.lines.count{
            
            if let line = buffer.lines[index] as? String{
                
                if line.contains("case"){
                    linesAhead += 1
                }
                else{
                    buffer.lines.insert("\n", at: index)
                    break
                }
            }
        }
        return linesAhead
    }
}
