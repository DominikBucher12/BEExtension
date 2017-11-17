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
        return indexes.map({ buffer.lines[$0] as? String }).flatMap({$0})
    }
}
