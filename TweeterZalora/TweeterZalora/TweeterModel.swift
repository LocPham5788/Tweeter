//
//  TweeterModel.swift
//  TweeterZalora
//
//  Created by Pham Tan Loc on 8/24/17.
//  Copyright © 2017 Pham Tan Loc. All rights reserved.
//

import Foundation

class TweeterModel: NSObject {
    
    /// Used Singleton design pattern
    static let shared = TweeterModel()
    
    /**
     Check if input message contains a span of non-whitespace
     characters longer than 50 characters or not
     
     - parameter message: Input message to check.
     */
    func checkIfMessageIsNonWhiteSpace(message: String) -> Bool {
        if message.isEmpty {
            return true
        }
        // Create regex that contains a span of non-whitespace
        // characters longer than 50 characters
        let regexSyntax = "[^\\s]{50}([^\\s])*"
        // If we used regex matchs the complexity is about O(n)
        do {
            let regex = try NSRegularExpression(pattern: regexSyntax)
            let textMessage = message as NSString
            let results = regex.matches(in: message, range: NSRange(location: 0, length: textMessage.length))
            return results.count > 0
        }
        catch _ {
            print("Invalid regex: \(regexSyntax)")
            return false
        }
    }
    
    /**
     Split message into multi part with limitation characters count.
     
     - parameter message: Input message to check, limit: Number of characters limit.
     */
    func splitMessageToParts(message: String, limit: Int) -> [String] {
        var inputMessage = message
        var partResults: [String] = [String]()
        if inputMessage.isEmpty {
            return partResults
        }
        if inputMessage.characters.count <= 50 {
            partResults.append(inputMessage)
        } else {
            let numberOfLine:Double = Double(message.characters.count)/50 >= 1.5 ? Double(Double(message.characters.count)/50).rounded() : 2.0
            
            for y in 0..<Int(numberOfLine) {
                let characterAppend = "\(y)/\(Int(numberOfLine))"
                let characTerApeendSpace = characterAppend.characters.count + 2
                
                var offsetEnd = ((50 - characTerApeendSpace) * y) == 0 ? 50 - characTerApeendSpace : (50 - characTerApeendSpace) * (y + 1)
                if offsetEnd >= message.characters.count {
                    offsetEnd = message.characters.count - 1
                }
                
                let start = message.index(message.startIndex, offsetBy: ((50 - characTerApeendSpace) * y))
                let end = message.index(message.startIndex, offsetBy: offsetEnd)
                
                let range = start...end
                let substring = message[range].trimmingCharacters(in: .whitespaces)
                
                partResults.append(substring)
            }
        }
        return partResults
    }
    
}
