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

            let errorWithUTI = create(error: .wrongUTI)
            completionHandler(errorWithUTI)
            return
        }

        // Select the text, get the identifier chosen, if something fails return without error...
        guard let selectedText = try? getSelectedLinesText(withBuffer: invocation.buffer),
              let commandIdentifier = Identifiers.Commands(rawValue: invocation.commandIdentifier)
        else { completionHandler(nil); return; }

        // Prepare the text from the buffer to be parsed.
        let words = TextHelper.getPreparedWords(fromText: selectedText)

        // We need to get the last selected line to insert our variable / switch below
        guard let lastSelectedLine = lastSelectedLine(fromBuffer: invocation.buffer) else { completionHandler(nil); return; }

        // Create the code snippet
        let pieceOfCode = codeSnippet(
            withCommandIdentifier: commandIdentifier,
            withWords: words,
            withTabWidth: invocation.buffer.tabWidth
        )

        // Get the lines ahead of the selection.
        let linesAhead = self.linesAhead(lastSelectedline: lastSelectedLine, withBuffer: invocation.buffer)

        invocation.buffer.lines.insert("\n", at: lastSelectedLine + linesAhead )
        invocation.buffer.lines.insert(pieceOfCode, at: lastSelectedLine + linesAhead + 1)
        completionHandler(nil)
    }
    
    
    func codeSnippet(withCommandIdentifier identifier: Identifiers.Commands, withWords words: [String], withTabWidth tabWidth: Int ) -> String {

        switch identifier {
        case .makeJustSwitch:
            return TextHelper.generateSwitch(fromCases: words, tabWidth: tabWidth)

        case .makeVariable:
            return TextHelper.generateVariable(withEnumCases: words, withTabWidth: tabWidth)
        }
    }
    
    /// Generates our defined error
    ///
    /// - Parameter error: error from possible errors that could occur during text selection
    /// - Returns: NSError to pass to Xcode
    private func create(error: Identifiers.PossibleErrors) -> NSError {

        let userInfo: [AnyHashable : Any] = [
            NSLocalizedDescriptionKey :  NSLocalizedString(
                error.errorDescription,
                value: error.errorDescription,
                comment: ""
            )
            ]

        let error = NSError(domain: "com.dominikbucher.xcodeKitError", code: 1, userInfo: userInfo as? [String : Any])
        return error
    }
}
