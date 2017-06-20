//
//  Login.swift
//  login
//
//  Created by Guillaume Bellue on 19/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit

public class LoginConfiguration {
    var landingBackgroundImage: UIImage? = nil
    var landingBrandView: UIView? = nil

    var landingTextFont: UIFont = .systemFont(ofSize: 18, weight: UIFontWeightMedium)
    var landingTextColor: UIColor = .white

    var ctaBackgroundColor: UIColor = UIColor(red: 73.0/255, green: 144.0/255, blue: 226.0/255, alpha: 1)
    var ctaFont: UIFont = .systemFont(ofSize: 15, weight: UIFontWeightHeavy)
    var ctaTextColor: UIColor = .white

    var font: UIFont = .systemFont(ofSize: 14)

    static let `default`: LoginConfiguration = {
        let config = LoginConfiguration()
        // set default
        return config
    }()
}

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
    func nsRange(from range: Range<Index>) -> NSRange {
        let lower = UTF16View.Index(range.lowerBound, within: utf16)
        let upper = UTF16View.Index(range.upperBound, within: utf16)
        return NSRange(location: utf16.startIndex.distance(to: lower), length: lower.distance(to: upper))
    }
}

extension UIView {
    func updateAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}

