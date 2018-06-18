//
//  String+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension String {
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(self.startIndex, offsetBy: r.upperBound)
        
        return String(self[start...end])
    }
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    func invertedEncodeURLQueryValue() -> String? {
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        
        if let escapedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            return escapedString
        }
        return nil
    }
    
    func removeForwardSlashes() -> String {
        return self.replacingOccurrences(of: "\\", with: "")
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func buildURLString(_ params: [String: String]) -> String {
        let paramString = params.stringFromHttpParameters()
        return "\(self)?\(paramString)"
    }
    
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }

    func convertURLToDictionary() -> [String: String] {
        let paramsStripped = self.components(separatedBy: "?")
        if paramsStripped.count > 1 {
            let keyValueStrings = paramsStripped[1].components(separatedBy: "&")
            let dictionary = keyValueStrings.reduce([String: String]()) {
                aggregate, element in
                var newAggregate = aggregate
                
                let elements = element.components(separatedBy: "=")
                let key = elements[0]
                
                let value = (elements.count > 1) ? elements[1] : nil
                newAggregate[key] = value
                
                return newAggregate
            }
            
            return dictionary
        }
        return [:]
    }
    
    func plainDigitCharacterSet() -> String {
        let components = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "")
        return decimalString
    }
    
    func phoneNumberWithoutCode() -> String {
        var plainNumber = self.plainDigitCharacterSet()
        if plainNumber.count > 0 && plainNumber.hasPrefix("1") {
            plainNumber.remove(at: plainNumber.startIndex)
        }
        return plainNumber
    }

    // Phone Number Formatter > Intended to help input via UITextField
    
    func formatPhoneNumber(_ replacementString: String, range: Range<String.Index>)  -> (formattedString: String?, shouldChangeCharacters: Bool)  {
        let newString = self.replacingCharacters(in: range, with: replacementString)
        let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "")
        let length = decimalString.count
        let hasLeadingOne = decimalString.hasPrefix("1")
        
        if length > 10 && !hasLeadingOne || length > 11 {
            return (formattedString: nil, shouldChangeCharacters: true )
        }
        
        var index = 0
        var formattedString = String()

        index += hasLeadingOne ? 1 : 0
        formattedString = formattedString.appending("+1 ")
      
        if (length - index) > 3 {
            let toIndex = hasLeadingOne ? 3 : 2
            let areaCode = decimalString[index..<toIndex]
            formattedString = formattedString.appendingFormat("(%@)", areaCode)
            index += 3
        }
        
        if (length - index) > 3 {
            let prefixRemainder = decimalString.subString(index)

            let prefix = prefixRemainder[0..<2]
            formattedString = formattedString.appendingFormat(" %@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.subString(index)
        formattedString = formattedString.appending(remainder)
        return (formattedString: formattedString, shouldChangeCharacters: true )
    }
    
    func formatPhoneNumberOld(_ replacementString: String, range: NSRange) -> (formattedString: String?, shouldChangeCharacters: Bool) {
        let newString = (self as NSString).replacingCharacters(in: range, with: replacementString)
        let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "")
        let length = decimalString.count
        let hasLeadingOne = decimalString.hasPrefix("1")


        if length > 10 && !hasLeadingOne || length > 11 {
            return (formattedString: nil, shouldChangeCharacters: true )
        }
        
        var index = 0
        var formattedString = String()
        
        index += hasLeadingOne ? 1 : 0
        formattedString = formattedString.appending("+1 ")
        
        if (length - index) > 3 {
            let toIndex = hasLeadingOne ? 3 : 2
            let areaCode = decimalString[index..<toIndex]
            formattedString = formattedString.appendingFormat("(%@)", areaCode)
            index += 3
        }
        
        if (length - index) > 3 {
            let prefixRemainder = decimalString.subString(index)
            
            let prefix = prefixRemainder[0..<2]
            formattedString = formattedString.appendingFormat(" %@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.subString(index)
        formattedString = formattedString.appending(remainder)
        return (formattedString: formattedString, shouldChangeCharacters: true )

    }
    
    func formatPhoneNumber() -> String? {

        let start = self.index(self.startIndex, offsetBy: 0)
        let end = self.index(self.endIndex, offsetBy: 0)
        let range = start..<end
        
        let phoneNumber = self.formatPhoneNumber(self, range: range).formattedString
        return phoneNumber
    }
    
    func formatPhoneNumberToPlainDigit() -> String {
        var phone = self.plainDigitCharacterSet()
        if phone.hasPrefix("1") {
            phone.removeFirst()
        }
        return phone
    }
    
    // String height
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    // Validations
    
    func isValidEmail() -> Bool {
        let textRange = NSMakeRange(0, self.count)
        let detector : NSDataDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        // options value is ignored for this method, but still required!
        if let result = detector.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.anchored, range: textRange) {
            // check range to make sure a substring was not detected
            return result.url!.scheme == "mailto" && (result.range.location == textRange.location) && (result.range.length == textRange.length)
        } else {
            return false
        }
    }
    
    // NSRange to Range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    // Length and Text of UITextField
    func replacedTextAndCount(range: NSRange, replacementString: String) -> (replacedString: String, newLength: Int) {
        let replacedString = (self as NSString).replacingCharacters(in: range, with: replacementString)
        let newLength = self.utf16.count + replacementString.utf16.count - range.length
        return (replacedString, newLength)
    }
    
    // API Bridge Token Generator
    func generateToken(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    // Check if a valid URL
    func canOpenURL() -> Bool {
        guard let url = NSURL(string: self) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self)
    }
    
    // Check if phone number string is valid US number
    func isValidUSPhoneNumber() -> Bool {
        let phoneMinChar: Int = 10
        let phoneMaxChar: Int = 12
        let charsToRemove: Set<Character> = Set("()- []")
        let trimmedText = String(self.filter { !charsToRemove.contains($0) })
        if trimmedText.hasPrefix("+") && trimmedText.count == phoneMaxChar {
            return  String(trimmedText[..<trimmedText.index(trimmedText.startIndex, offsetBy: 2)]) == "+1" && trimmedText[trimmedText.index(trimmedText.startIndex, offsetBy: 2)] != "0"
        } else {
            return trimmedText.count == phoneMinChar && !trimmedText.hasPrefix("0")
        }
    }

    // Capitalize First Char
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var containsLettersAndNumbers: Bool {
        return !isEmpty && range(of: "^(?=.*[a-zA-Z])(?=.*[0-9])", options: .regularExpression) != nil
    }
    
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    func subString(_ from: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        return String(self[start ..< endIndex])
    }
    
    //get total from response (response.description)
    func getTotal() -> Int {
        let responseStringArray = self.split{$0 == "\n"}.map(String.init)
        var total: Int = 0
        if responseStringArray.count > 0 {
            let totalStringArray = responseStringArray.first?.split{$0 == " "}.map(String.init)
            guard let totalString = totalStringArray?.last else { return 0 }
            guard let unwrappedTotal = Int(totalString) else { return 0 }
            total = unwrappedTotal
        }
        return total
    }
}
