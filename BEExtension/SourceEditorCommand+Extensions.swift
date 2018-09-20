//
//  SourceEditorCommand+Extensions.swift
//  BEExtension
//
//  Created by Dominik Bucher on 12/11/2017.
//  Copyright © 2017 Dominik Bucher. All rights reserved.
//

import Foundation
import XcodeKit

extension SourceEditorCommand {

    /// This method should be universal and implemented right from Apple. (excluding the condition for case OC)
    ///  gets specified text from line indexes
    ///
    /// - Parameters:
    ///   - buffer: buffer to work with(usually the same instance as in all other functions)
    /// - Returns: returns array of texts on specific lines
    func getSelectedLinesText(withBuffer buffer: XCSourceTextBuffer) throws -> [String] {

        guard let selectedRange = buffer.selections as? [XCSourceTextRange],
            let firstRange = selectedRange.first
        else { throw NSError() } // You can handle the completion handler here, something like no selection or something like that...

        let indexes = Array(firstRange.start.line...firstRange.end.line)
        return indexes.map({ buffer.lines[$0] as? String }).compactMap({$0})
    }
}

// MARK: Inserting methods
extension SourceEditorCommand {

    /// returns index of last selected line from buffer
    ///
    /// - Parameter buffer: The only buffer we get
    /// - Returns: index of last line we selected
    func lastSelectedLine(fromBuffer buffer: XCSourceTextBuffer) -> Int? {

        return (buffer.selections.lastObject as? XCSourceTextRange)?.end.line ?? nil
    }

    /// Returns lines below our selected text (to be a bit idiotproof, but not too much) - if we find something in our way,
    /// we simply skip that or break on next var, enum end or next enum in enum...
    ///
    /// - Parameters:
    ///   - line: the last line we selected
    ///   - buffer: text buffer upon we are working
    /// - Returns: returns how many lines from selected text we need to skip to extract nice piece of code...
    func linesAhead(lastSelectedline line: Int, withBuffer buffer: XCSourceTextBuffer) -> Int {

        var linesAhead = 0

        for index in line...buffer.lines.count {

            if let line = buffer.lines[index] as? String {

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
