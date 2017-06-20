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

