//
//  Extensions.swift
//  login
//
//  Created by Guillaume Bellue on 22/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit

extension UIFont {
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))!
        return UIFont(descriptor: descriptor, size: 0)
    }

    func boldItalic() -> UIFont {
        return withTraits(traits: .traitBold, .traitItalic)
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        guard
            let from = String.UTF16View.Index(range.lowerBound, within: utf16view),
            let to = String.UTF16View.Index(range.upperBound, within: utf16view)
            else { return NSMakeRange(0, 0) }
        let utf16Offset = utf16view.startIndex.encodedOffset
        let toOffset = to.encodedOffset
        let fromOffset = from.encodedOffset
        return NSMakeRange(fromOffset - utf16Offset, toOffset - fromOffset)
    }
}
