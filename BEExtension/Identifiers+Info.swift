//
//  ContentIdentifiers.swift
//  emptyProject
//
//  Created by Dominik Bucher on 21/05/2017.
//  Copyright © 2017 Dominik Bucher. All rights reserved.
//

import Foundation
import XcodeKit

/*
 Maybe I should write down the algorithm in here:
 
 The idea is pretty straightforward and simple, as everything in this world...well except you take one piece of task and you find out it is as comprehensive as the whole universe itself with revealing more things to study or observe... jokes aside, let's get to business.
 
 1.) We must make sure, we are editing the right document -> It Cannot be Objective-C (Who wants to code Objective C anyway)
 
 -> We use ContentUTI here (kUTTypeSwiftSource) AKA public.swift-source AKA spend whole night finding information about this AKA my head will blow
 
 2.) We take our selected text
 -> This is a bit complicated now, because of taking-text-from-buffer algorithm, so I will divide it into few tasks:
 a) Get indexes of lines in a current file
 a - optional) For the weak type of solution -> Get index of last selected line to recognize where to put the variable/switch
 b) According to indexes, we extract our lines as [String]
 c) Now we are done with taking the selected text
 
 3.) After we got our beautiful iterating trought lines, we must extract the cases names and remove every garbage we don't need -> rawValue declarations, associatedTypes, handle multiple cases on one line...I WOULD LIKE TO THANK KEN THOMPSON AND DENNIS RITCHIE that we have one problem solved, Enum with raw type cannot have cases with arguments 🤔 (Yes, please refer to them as gods)
 Anyway -> This freaking point includes impossible-to-do REGEX which I sure will be figuring out for at least 20 hours, so I will start timer and post the result(woahh great, only 3 hours thanks to that beautiful tool referenced in String+Extensions.swift file 😎
 
 4.) Next thing we do is putting those cases into our switch/variable String containing the structure...
 -> I would really love Swift to have a feature which is contained in other languages, including C# 🎸, which is priceless: Multilined Strings aka I love you
 
 //C# :
 
 String thisIsSuperBeautiful = @"
 Hello there,
 I am multilined text, as you can see,
 this is my really cool feature, so I would be really happy to be your favourite programming language";
 
 //Swifty Swift
 
 let iDGAF: String = "Sup' bro\n" + "sorry, no multilines\n" + "but you can use your imagination\n" +
 "or divide lines like this\n" +
 "but you can forget semicolon\n" +
 "or let it be as is"
 
 //Objective-C bonus:
 
 //oh how I hate this thing:
 NSString *my_string = @"Good evening mister, \
 even I can do multilines!";
 
 //should work this way too:
 
 NSString *whatsGoingOnWithThisSyntax = @"Good evening mister,"
 "even I can do multilines!";
 
 
 5.) After we fire this up we need to insert this text properly... I guess I will map functions under these points
 
 
 */



//TODO: Make more of singleton, didn't think of creating only one instance

struct Identifiers {
    ///Content UTIs identificators -> You can do your homework and read this:  https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
    public enum ContentUTIs: String {
        case swiftSource = "public.swift-source"
    }
    
    
    //TODO: Make this more generic -> could be some class XcodeKitError which implements NSError straight to completionHandler
    public enum PossibleErrors: LocalizedError{
        case wrongUTI
        case emptySelection
        case wrongSelection
        case `default`
        
        var errorDescription: String? {
            switch self {
            case .wrongUTI:
                return NSLocalizedString("Wrong UTI, please ensure you are trying to edit Swift source code", comment: "wrong UTI")
            case .emptySelection:
                
                return NSLocalizedString("Empty selection, please select enum cases to work with", comment: "Empty selection")
            case .wrongSelection:
                
                return NSLocalizedString("Whoops, something went bad, please ensure you are selecting right part of text", comment: "Wrong selection")
            case .default:
                
                return NSLocalizedString("Whoops, something went wrong", comment: "Default error")
            }
        }
    }
    
    /// enum for identifiying command names (Available to change in info.plist of this extension)
    /// No need for declaring rawValues as it carries the same name, cool feature Swift 👍
    /// - makeVariable: 🙀
    /// - makeJustSwitch: 🙀
    public enum Commands: String{
        case makeVariable
        case makeJustSwitch
    }
    
}
