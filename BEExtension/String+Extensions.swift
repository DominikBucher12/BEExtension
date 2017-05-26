//
//  String+Extensions.swift
//  emptyProject
//
//  Created by Dominik Bucher on 21/05/2017.
//  Copyright © 2017 Dominik Bucher. All rights reserved.
//

import Foundation


/*
 SUPER HUGE THANKS TO AARON FOR MAKING MY REGEX PAIN IN THE ASS LESS HURT!!
 
 https://github.com/aaronvegh/nsregextester show some love to this guy!
 
 */


extension String{
    //
    /// According to regex filters out bad words and characters from line and returns clean word
    ///
    /// - Returns: Clean name for case to play with
    func extractWordInEnum() -> String?{
        do{
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "(case )([`a-zA-Z0-9, ]*)((\\W)|($))(.*)", options: .init(rawValue: 0))
            if let cutDownString = self.mutableCopy() as? NSMutableString{
                regex.replaceMatches(in: cutDownString, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count) , withTemplate: "$2")
                let cutDownStringWithoutspaces = (cutDownString as String).trimmingCharacters(in: .whitespacesAndNewlines)
                let finalString = cutDownStringWithoutspaces.replacingOccurrences(of: ", ", with: ", .")
                print(finalString)
                return finalString
                
            }
        }
        catch{
            print("Unexpected error while creating regular expression")
        }
        return nil
    }
}


