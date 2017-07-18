//
//  InputField.swift
//  login
//
//  Created by Guillaume Bellue on 20/06/2017.
//  Copyright © 2017 Wopata. All rights reserved.
//

import UIKit
import SnapKit

open class InputField: UIView, UITextFieldDelegate {
    let legend = UILabel()
    let errorLabel = UILabel()
    let field = UITextField()

    var font: UIFont = .systemFont(ofSize: 17)
    public var value: String? = nil {
        didSet { field.text = value }
    }
    var label: String = ""
    var offset: CGFloat = -1

    public var valueChanged: ((String?) -> Void)?
    public var returnKeyPressed: (() -> Void)!
    public var returnKeyType: UIReturnKeyType = .next {
        didSet { field.returnKeyType = returnKeyType }
    }
    public var keyboardType: UIKeyboardType = .default {
        didSet { field.keyboardType = keyboardType }
    }
    override open var inputView: UIView? {
        get { return field.inputView }
        set { field.inputView = newValue }
    }
    private var _inputAccessoryView: UIView?
    open override var inputAccessoryView: UIView? {
        get { return _inputAccessoryView }
        set {
            field.inputAccessoryView = newValue
            _inputAccessoryView = newValue
        }
    }

    override open var tintColor: UIColor! {
        didSet {
            field.tintColor = tintColor
        }
    }

    public init(font: UIFont, label: String, value: String? = nil) {
        super.init(frame: .zero)
        self.font = font
        self.value = value
        self.label = label

        loadView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }

    private func loadView() {
        field.delegate = self
        field.font = font
        field.text = value
        field.autocapitalizationType = .none
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        field.returnKeyType = .next

        returnKeyPressed = {
            self.field.resignFirstResponder()
        }
        
        addSubview(field)
        field.snp.makeConstraints {
            $0.top.equalTo(25).priority(.high)
            $0.left.right.equalToSuperview()
        }

        let line = UIView()
        line.backgroundColor = UIColor(white: 0, alpha: 0.15)
        addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1).priority(.high)
            $0.top.equalTo(field.snp.bottom).offset(10).priority(.high)
        }

        errorLabel.textColor = UIColor(red: 1, green: 91.0/255, blue: 91.0/255, alpha: 1)
        errorLabel.text = nil
        errorLabel.numberOfLines = 1
        errorLabel.font = font.withSize(12)
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(line.snp.bottom).offset(3).priority(.high)
        }

        legend.text = label
        legend.textColor = UIColor(white: 0, alpha: 0.5)
        legend.isUserInteractionEnabled = false
        legend.font = font.withSize(17)
        addSubview(legend)
        legend.snp.makeConstraints {
            $0.left.equalToSuperview()
        }

        offset = legend.intrinsicContentSize.width * 0.1
        if field.text?.isEmpty == false {
            self.legend.transform = CGAffineTransform(scaleX: 0.82, y: 0.82).translatedBy(x: -offset, y: 0)
            legend.snp.makeConstraints {
                $0.top.equalToSuperview()
            }
        } else {
            legend.snp.makeConstraints {
                $0.top.equalTo(field)
            }
        }
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        legend.snp.remakeConstraints {
            $0.left.top.equalToSuperview()
        }

        UIView.animate(withDuration: 0.3) {
            self.legend.textColor = self.tintColor
            self.legend.transform = CGAffineTransform(scaleX: 0.82, y: 0.82).translatedBy(x: -self.offset, y: 0)
            self.layoutIfNeeded()
        }

        resetErrors()

        return true
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        legend.snp.remakeConstraints {
            $0.left.equalToSuperview()
            if field.text?.isEmpty == false {
                $0.top.equalToSuperview()
            } else {
                $0.top.equalTo(field)
            }
        }

        UIView.animate(withDuration: 0.3) {
            self.legend.textColor = UIColor(white: 0, alpha: 0.5)
            if self.field.text?.isEmpty == false {
                self.legend.transform = CGAffineTransform(scaleX: 0.82, y: 0.82).translatedBy(x: -self.offset, y: 0)
            } else {
                self.legend.transform = .identity
            }
            self.legend.layoutIfNeeded()
            self.layoutIfNeeded()
        }

        if checkErrors(forText: field.text) {
            valueChanged?(self.field.text)
        }

        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnKeyPressed()
        return true
    }

    func editingChanged() {
        let value = (isValid(text: field.text) == nil) ? field.text : nil
        valueChanged?(value)
    }

    override open func becomeFirstResponder() -> Bool {
        return field.becomeFirstResponder()
    }

    override open func resignFirstResponder() -> Bool {
        return field.resignFirstResponder()
    }

    func resetErrors() {
        UIView.animate(withDuration: 0.1) {
            self.field.textColor = .black
            self.errorLabel.text = nil
            self.layoutIfNeeded()
        }
    }

    func checkErrors(forText text: String?) -> Bool {
        if let error = isValid(text: text) {
            addError(error: error)
            return false
        }
        return true
    }

    open func isValid(text: String?) -> String? {
        return nil
    }

    public func addError(error: String) {
        UIView.animate(withDuration: 0.1) {
            self.field.textColor = UIColor(red: 1, green: 91.0/255, blue: 91.0/255, alpha: 1)
            self.errorLabel.text = error
            self.layoutIfNeeded()
        }
    }
}

class EmailField: InputField {
    convenience init(font: UIFont) {
        self.init(font: font, label: localize("email_address"), value: nil)
        field.isSecureTextEntry = false
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
    }

    override func isValid(text: String?) -> String? {
        guard let text = text, !text.isEmpty else {
            return localize("error_email_empty")
        }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        guard emailTest.evaluate(with: text) else {
            return localize("error_email_invalid")
        }

        return nil
    }
}

class PasswordField: InputField {
    convenience init(font: UIFont) {
        self.init(font: font, label: localize("password"), value: nil)
        field.isSecureTextEntry = true
        field.keyboardType = .default
        field.returnKeyType = .done
    }

    override func isValid(text: String?) -> String? {
        if text?.isEmpty != false {
            return localize("error_password_empty")
        }

        return nil
    }
}
