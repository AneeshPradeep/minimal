//
//  String+Ext.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit

extension String {
    
    ///Tính CGRect của một String
    func estimatedTextRect(width: CGFloat = CGFloat.greatestFiniteMagnitude, fontN: String, fontS: CGFloat) -> CGRect {
        let height = CGFloat.greatestFiniteMagnitude
        let size = CGSize(width: width, height: height)
        let options: NSStringDrawingOptions = [
            .usesLineFragmentOrigin//.union(.usesFontLeading)
        ]
        let attributes: [NSAttributedString.Key: Any] = [
            .font : UIFont(name: fontN, size: fontS)!
        ]
        
        return NSString(string: self).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    ///Lấy cờ quốc gia từ String
    func flag() -> String {
        let base: UInt32 = 127397
        var usv = ""
        
        for v in unicodeScalars {
            if let uni = UnicodeScalar(base + v.value) {
                usv.unicodeScalars.append(uni)
            }
        }
        
        return usv
    }
    
    func getLinkFromString() -> String {
        var link = ""
        
        if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) {
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            for match in matches {
                if let range = Range(match.range, in: self) {
                    link = String(self[range])
                    break
                }
            }
        }
        
        return link
    }
    
    ///yyyyMMddHHmmss
    func convertUTCDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = formatter.date(from: self) {
            //formatter.timeZone = .current
            
            return formatter.string(from: date)
        }
        
        return self
    }
    
    ///FirstName-LastName
    func firstLastName(completion: @escaping (String, String) -> Void) {
        var fn = ""
        var ln = ""
        var comp = components(separatedBy: " ")
        
        if comp.count > 0 {
            fn = comp.removeFirst()
            ln = comp.joined(separator: " ")
        }
        
        completion(fn, ln)
    }
}

//MARK: - Localizable

extension String {
    
    func convertToLocalized() -> String {
        var txt = self
        
        let char = CharacterSet.decimalDigits
        let range = txt.rangeOfCharacter(from: char)
        
        if range != nil {
            var array = txt.split(separator: " ").map({ "\($0)" })
            
            if array.count > 0 {
                let first = array.removeFirst()
                array.insert("%d", at: 0)
                
                txt = array.joined(separator: " ").localized()
                
                if first == "one" {
                    txt = txt.replacingOccurrences(of: "%d", with: "\(1)")
                    
                } else {
                    if let number = Int(first) {
                        txt = txt.replacingOccurrences(of: "%d", with: "\(number)")
                    }
                }
            }
            
            txt = txt.replacingOccurrences(of: "%d", with: "")
            
        } else {
            txt = txt.localized()
        }
        
        return txt
    }
    
    func localized() -> String {
        var str = NSLocalizedString(self, comment: self)
        
        if let path = Bundle.main.path(forResource: getLanguageCode() ?? "en", ofType: "lproj"),
           let bundle = Bundle(path: path) {
            str = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
        
        return str
    }
}

//MARK: - Check

extension String {
    
    ///Check email
    func matches(_ expression: String) -> Bool {
        if let range = range(of: expression, options: .regularExpression, range: nil, locale: nil) {
            return range.lowerBound == startIndex && range.upperBound == endIndex
            
        } else {
            return false
        }
    }
    
    ///Check email
    var isValidEmail: Bool {
        matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    ///Contains Only Digits
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: .literal, range: nil) == nil
    }
    
    ///Chỉ lấy số
    var digits: String {
        return components(separatedBy: .decimalDigits.inverted).joined()
    }
    
    ///Xác thực là số điện thoại
    func validatePhoneNumber() -> Bool {
        let regex = "^\\d{3}\\d{3}\\d{4}$" //"^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = phoneTest.evaluate(with: self)
        
        return result
    }
    
    ///String chỉ chứa chữ cái
    var containsOnlyLetters: Bool {
        let notLetters = NSCharacterSet.letters.union(NSCharacterSet.whitespaces).inverted
        return rangeOfCharacter(from: notLetters, options: .literal, range: nil) == nil
    }
    
    ///String chứa chữ cái
    var containsLetters: Bool {
        let notLetters = NSCharacterSet.letters
        return rangeOfCharacter(from: notLetters, options: .literal, range: nil) == nil
    }
    
    ///Chữ HOA
    var isUppercase: Bool {
        let upperRegEx = ".*[A-Z]+.*"
        let upperTest = NSPredicate(format: "SELF MATCHES %@", upperRegEx)
        let upperResult = upperTest.evaluate(with: self)
        return upperResult
    }
    
    ///Chữ thường
    var isLowercase: Bool {
        let lowerRegEx = ".*[a-z]+.*"
        let lowerTest = NSPredicate(format: "SELF MATCHES %@", lowerRegEx)
        let lowerResult = lowerTest.evaluate(with: self)
        return lowerResult
    }
    
    ///Chứa số
    var isNumber: Bool {
        let numberRegEx = ".*[0-9]+.*"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let numberResult = numberTest.evaluate(with: self)
        return numberResult
    }
    
    ///Chứa ký tự đặc biệt
    var isSpecialCharacter: Bool {
        let specialCharacterRegEx = ".*[._!&^%$#@()/]+.*" //Bao gồm các ký tự hợp lệ
        let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegEx)
        let specialCharacterResult = specialCharacterTest.evaluate(with: self)
        return specialCharacterResult
    }
    
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { (_, range, _, _) in
            byWords.append(self[range])
        }
        
        return byWords
    }
    
    ///Chỉ chứa chữ cái, số && "._"
    var isUsername: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9._].*")
        let range = NSRange(location: 0, length: self.count)
        
        return regex.firstMatch(in: self, range: range) == nil
    }
}

//MARK: - Online

extension String {
    
    func getOnlineStatusFromOnlineTime(_ lastMessage: Bool = false) -> String {
        var text = ""
        
        if let date = longFormatter().date(from: self) {
            let timeInterval = NSDate().timeIntervalSince(date)
            
            let minute = Double(60*60)
            let hour = Double(24*minute)
            
            if timeInterval <= 5 {
                if lastMessage {
                    text = "Just now".localized()
                    
                } else {
                    text = "Online just now".localized()
                }
                
            } else if timeInterval > 5 && timeInterval < 60 {
                text = "\(getSecond(timeInterval))" + " " + "seconds ago".localized()
                
            } else if timeInterval >= 60 && timeInterval < minute {
                text = "\(getMinute(timeInterval))" + " " + "minutes ago".localized()
                
            } else if (timeInterval >= minute) && (timeInterval < hour) {
                text = "\(getHour(timeInterval))" + " " + "hours ago".localized()
                
            } else if (timeInterval >= hour) && (timeInterval <= (7*hour)) {
                text = "\(getDate(timeInterval))" + " " + "days ago".localized()
                
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                
                text = formatter.string(from: date)
            }
        }
        
        return text
    }
    
    ///lastPathComponent
    var lastPath: String {
        return NSString(string: self).lastPathComponent
    }
    
    //Tên thiết bị
    func deviceName() -> String {
        switch self {
        case "iPod5,1": return "iPod Touch 5th Generation"
        case "iPod7,1": return "iPod Touch 6th Generation"
        case "iPod9,1": return "iPod Touch 7th Generation"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
            
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
            
        case "iPhone9,1", "iPhone9,3": return "iPhone 7"
        case "iPhone9,2", "iPhone9,4": return "iPhone 7 Plus"
            
        case "iPhone8,4": return "iPhone SE"
            
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
            
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
        case "iPhone11,8": return "iPhone XR"
            
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
            
        case "iPhone12,8": return "iPhone SE (2nd generation)"
            
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,1": return "iPhone 12 Mini"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
            
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,4": return "iPhone 13 Mini"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
            
        case "iPhone14,6": return "iPhone SE (3rd generation)"
            
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"
            
        case "iPhone15,4": return "iPhone 15"
        case "iPhone15,5": return "iPhone 15 Plus"
        case "iPhone16,1": return "iPhone 15 Pro"
        case "iPhone16,2": return "iPhone 15 Pro Max"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad6,11", "iPad6,12": return "iPad 5"
        case "iPad7,5", "iPad7,6": return "iPad 6"
        case "iPad11,3", "iPad11,4": return "iPad Air 3"
        case "iPad7,11", "iPad7,12": return "iPad 7"
        case "iPad11,6", "iPad11,7": return "iPad 8"
        case "iPad12,1", "iPad12,2": return "iPad 9"
        case "iPad13,18", "iPad13,19": return "iPad 10"
        case "iPad13,1", "iPad13,2": return "iPad Air 4"
        case "iPad13,16", "iPad13,17": return "iPad Air 5"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad11,1", "iPad11,2": return "iPad Mini 5"
        case "iPad14,1", "iPad14,2": return "iPad Mini 6"
        case "iPad6,3", "iPad6,4": return "iPad Pro 9.7-inch"
        case "iPad6,7", "iPad6,8": return "iPad Pro 12.9-inch (1st generation)"
        case "iPad7,1", "iPad7,2": return "iPad Pro 12.9-inch (2nd generation)"
        case "iPad7,3", "iPad7,4": return "iPad Pro 10.5-inch"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro 11-inch (1st generation)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro 12.9-inch (3rd generation)"
        case "iPad8,9", "iPad8,10": return "iPad Pro 11-inch (2nd generation)"
        case "iPad8,11", "iPad8,12": return "iPad Pro 12.9-inch (4th generation)"
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return "iPad Pro 11-inch (3rd generation)"
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return "iPad Pro 12.9-inch (5th generation)"
        case "i386", "x86_64", "arm64": return "SIMULATOR"
        default: return "Unknown Identifyer"
        }
    }
    
    func split(font: UIFont, lineWidths: [CGFloat], lineBreak: TextPreferences.LineBreakMode, splitCharacter: String = " ") -> [String] {
        
        /// List of split strings to lines
        var linedStrings: [String] = []
        
        /// Split character width
        let splitCharacterWidth = splitCharacter.width(by: font)
        
        /// Available words for String
        var words = self.split(separator: splitCharacter.first!)
        
        /// The minimum size of the last word
        var lastWordMinimumSize = CGFloat.greatestFiniteMagnitude
        
        if let lastWord = words.last {
            lastWordMinimumSize = String(lastWord.suffix(4)).width(by: font)
        }
        
        /// Latest added word to the lines
        var latestAddedWord = 0
        
        /// Splits String to lines, up to last word
        for index in stride(from: 0, to: lineWidths.count, by: 1) {
            
            /// String at the line
            var linedString = ""
            
            /// Available width in line
            var availableWidthInLine = lineWidths[index]
            
            /// Adds each word to line
            for wordIndex in latestAddedWord..<words.count {
                
                /// Check for although there are lines available, no more words are left.
                guard latestAddedWord != words.count else { break }
                
                /// Is word first in the line
                let isFirstWordInLine = linedString.count < 1
                
                /// Current word
                let word = String(words[wordIndex])
                
                /// Word width, if it's not first in the line, adds the space before the word
                let wordWidth = isFirstWordInLine ? word.width(by: font) : word.width(by: font) + splitCharacterWidth
                
                /// Is word fit in the line
                let isWordFit = availableWidthInLine > wordWidth
                
                /// If word fit in the line, adds the word and calculates available width in the line for next word.
                if isWordFit {
                    linedString = isFirstWordInLine ? linedString + word : linedString + splitCharacter + word
                    availableWidthInLine -= wordWidth
                    latestAddedWord = wordIndex + 1
                } else {
                    /// Сhecks if lineBreak == .wordWrap then the current word should not be added to the line
                    guard lineBreak != .wordWrap else { continue }
                    
                    /// Split by character
                    if lineBreak == .characterWrap {
                        /// Cropped word
                        let croppedWord = word.crop(by: isFirstWordInLine ? availableWidthInLine : availableWidthInLine - splitCharacterWidth, font: font)
                        
                        /// Second part of cropped word
                        let wordSecondPart = word.dropFirst(croppedWord.count)
                        
                        // if word first in the line, crops the word and adds it to the line
                        if isFirstWordInLine {
                            linedString = linedString + croppedWord
                        } else {
                            linedString = linedString + splitCharacter + croppedWord
                        }
                        /// Insert second word part to iteration
                        words.insert(wordSecondPart, at: wordIndex+1)
                        
                        availableWidthInLine = 0
                        latestAddedWord = wordIndex + 1
                    } else {
                        /// if word first in the line, crops the word and adds it to the line
                        if isFirstWordInLine {
                            /// Cropped word
                            var croppedWord = word.crop(by: availableWidthInLine, font: font)
                            if lineBreak == .truncateTail {
                                croppedWord.replaceLastCharactersWithDots()
                            }
                            linedString += croppedWord
                            availableWidthInLine = 0
                            latestAddedWord = wordIndex + 1
                        } else {
                            /// Is the latest line
                            let isLatestLine = lineWidths.count - 1 == index
                            /// If the line is not latest, the current word most likely will be added to the next line
                            guard isLatestLine else { continue }
                            /// Checks available width in the line for the cropped word, the word won't be added if available width is less then for 5 character
                            guard availableWidthInLine >= splitCharacterWidth + lastWordMinimumSize else { continue }
                            /// Cropped word
                            var croppedWord = word.crop(by: availableWidthInLine, font: font)
                            /// Checks are cropped word more than 3 character
                            guard croppedWord.count > 3 else { continue }
                            if lineBreak == .truncateTail {
                                croppedWord.replaceLastCharactersWithDots()
                            }
                            linedString += splitCharacter + croppedWord
                            availableWidthInLine = 0
                            latestAddedWord = wordIndex + 1
                        }
                    }
                }
            }
            /// If no words are available for the line, then line won't be added
            guard linedString.count > 0 else { continue }
            linedStrings.append(linedString)
        }
        
        return linedStrings
    }
    
    func width(by font: UIFont) -> CGFloat {
        var textWidth: CGFloat = 0
        for element in self {
            let characterString = String(element)
            let letterSize = characterString.size(withAttributes: [.font: font])
            textWidth += letterSize.width
        }
        
        return textWidth + 1
    }
    
    func crop(by width: CGFloat, font: UIFont) -> String {
        var croppedText = ""
        var textWidth: CGFloat = 0
        
        for element in self {
            let characterString = String(element)
            let letterSize = characterString.size(withAttributes: [.font: font])
            textWidth += letterSize.width
            
            guard textWidth < width else {
                break
            }
            croppedText += characterString
        }
        
        return croppedText
    }
    
    mutating func replaceLastCharactersWithDots(count: Int = 3) {
        var string = self
        let dots = Array.init(repeating: ".", count: count).joined()
        let start = string.index(string.endIndex, offsetBy: -count)
        let end = string.endIndex
        string.replaceSubrange(start..<end, with: dots)
        self = string
    }
}
