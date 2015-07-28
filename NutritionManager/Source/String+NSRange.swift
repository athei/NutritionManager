//
//  String+NSRange.swift
//  NutritionManager
//
//  Created by Alexander Theißen on 28.07.15.
//
//

import Foundation

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        if let from = String.Index(self.utf16.startIndex + nsRange.location, within: self),
            let to = String.Index(self.utf16.startIndex + nsRange.location + nsRange.length, within: self) {
                return from ..< to
        }
        return nil
    }
    
    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(from - utf16view.startIndex, to - from)
    }
}