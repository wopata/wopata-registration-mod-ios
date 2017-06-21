//
//  InputField.swift
//  login
//
//  Created by Guillaume Bellue on 20/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit
import SnapKit

class InputField: UIView, UITextFieldDelegate {
    let legend = UILabel()
    let field = UITextField()

    var font: UIFont = .systemFont(ofSize: 17)
    var value: String? = nil
    var label: String = ""

    var valueChanged: ((String?) -> Void)?
    var returnKeyPressed: (() -> Void)!

    override var tintColor: UIColor! {
        didSet {
            field.tintColor = tintColor
        }
    }

    init(font: UIFont, label: String, value: String? = nil) {
        super.init(frame: .zero)
        self.font = font
        self.value = value
        self.label = label
        loadView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }

    private func loadView() {
        field.delegate = self
        field.font = font
        field.text = value

        returnKeyPressed = {
            self.field.resignFirstResponder()
        }
        
        addSubview(field)
        field.snp.makeConstraints {
            $0.top.equalTo(25)
            $0.left.right.equalToSuperview()
        }

        let line = UIView()
        line.backgroundColor = UIColor(white: 0, alpha: 0.15)
        addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(field.snp.bottom).offset(10)
        }

        legend.text = label
        legend.isUserInteractionEnabled = false
        legend.font = font.withSize(17)
        addSubview(legend)
        legend.snp.makeConstraints {
            $0.left.equalToSuperview()
        }
        if field.text?.isEmpty == false {
            self.legend.textColor = self.tintColor
            self.legend.transform = CGAffineTransform(scaleX: 0.82, y: 0.82)
            legend.snp.makeConstraints {
                $0.top.equalToSuperview()
            }
        } else {
            legend.textColor = UIColor(white: 0, alpha: 0.5)
            legend.snp.makeConstraints {
                $0.top.equalTo(field)
            }
        }
    }

    var offset: CGFloat = -1
    override func layoutSubviews() {
        super.layoutSubviews()
        guard offset < 0 else { return }
        offset = self.legend.frame.width * 0.1
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        legend.snp.remakeConstraints {
            $0.left.top.equalToSuperview()
        }

        UIView.animate(withDuration: 0.3) {
            self.legend.textColor = self.tintColor
            self.legend.transform = CGAffineTransform(scaleX: 0.82, y: 0.82).translatedBy(x: -self.offset, y: 0)
            self.layoutIfNeeded()
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        legend.snp.remakeConstraints {
            $0.left.equalToSuperview()
            if field.text?.isEmpty == false {
                $0.top.equalToSuperview()
            } else {
                $0.top.equalTo(field)
            }
        }

        UIView.animate(withDuration: 0.3) {
            if self.field.text?.isEmpty == false {
                self.legend.textColor = self.tintColor
                self.legend.transform = CGAffineTransform(scaleX: 0.82, y: 0.82).translatedBy(x: -self.offset, y: 0)
            } else {
                self.legend.textColor = UIColor(white: 0, alpha: 0.5)
                self.legend.transform = .identity
            }
            self.legend.layoutIfNeeded()
            self.layoutIfNeeded()
        }

        valueChanged?(self.field.text)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnKeyPressed()
        return true
    }

    override func becomeFirstResponder() -> Bool {
        return field.becomeFirstResponder()
    }
}

class EmailField: InputField {
    convenience init(font: UIFont) {
        self.init(font: font, label: NSLocalizedString("EmailAddress", comment: "Adresse email"), value: nil)
        field.isSecureTextEntry = false
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
    }
}

class PasswordField: InputField {
    convenience init(font: UIFont) {
        self.init(font: font, label: NSLocalizedString("Password", comment: "Mot de passe"), value: nil)
        field.isSecureTextEntry = true
        field.keyboardType = .default
        field.returnKeyType = .done
    }
}
