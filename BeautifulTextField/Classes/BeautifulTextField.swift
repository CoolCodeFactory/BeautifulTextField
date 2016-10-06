//
//  BeautifulTextField.swift
//  Pods
//
//  Created by Dima on 06/10/2016.
//
//

import UIKit



open class BaseBeautifulTextField: UITextField {
    
    // MARK: - States
    public enum TextFieldStateType {
        case entry
        case display
    }
    
    public enum TextStateType {
        case empty
        case notEmpty
    }
    
    open private(set) var textFieldStateType: TextFieldStateType = .display
    open private(set) var textStateType: TextStateType = .empty

    
    // MARK: - Border
    open weak private(set) var borderView: UIView!
    open weak private(set) var bottomBorderView: UIView!

    @IBInspectable open var borderInactiveColor: UIColor = .lightGray {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable open var borderActiveColor: UIColor = .red {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 2.0 {
        didSet {
            updateBorder()
        }
    }
    
    
    // MARK: - Placeholder
    open weak private(set) var placeholderLabel: UILabel!
    
    @IBInspectable open var placeholderFontScale: CGFloat = 0.7 {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }

    
    private var _placeholder: String?
    open override var placeholder: String? {
        set {
            self._placeholder = newValue
            updatePlaceholder()
        }
        get {
            return _placeholder
        }
    }
    
    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    // MARK: - Error handling
    @IBInspectable open var errorColor: UIColor = .red
    
    open var errorValidationHandler: (String) -> (String?) = { _ in
        return nil
    }
    
    var isValid: Bool {
        if let text = text, !text.isEmpty {
            let error = errorValidationHandler(text)
            if error == nil {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    // MARK: - Init/Deinit
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    internal func initialize() {
        self.addTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControlEvents.editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControlEvents.editingDidEnd)
        self.addTarget(self, action: #selector(textFieldTextDidChange), for: UIControlEvents.editingChanged)
        
        super.borderStyle = .none
        
        _placeholder = super.placeholder
        super.placeholder = nil
        
        let _bottomBorderView = UIView(frame: .zero)
        addSubview(_bottomBorderView)
        bottomBorderView = _bottomBorderView
        
        let _borderView = UIView(frame: .zero)
        addSubview(_borderView)
        borderView = _borderView
        
        let _placeholderLabel = UILabel(frame: .zero)
        addSubview(_placeholderLabel)
        placeholderLabel = _placeholderLabel
        placeholderLabel.textAlignment = textAlignment
        
        textFieldTextDidChange()
        textFieldDidEndEditing()
        updateBorder()
        updatePlaceholder()
        
        if hasText {
            configureTextField(forTextFieldStateType: .display, forTextStateType: .notEmpty, animated: false)
        } else {
            configureTextField(forTextFieldStateType: .display, forTextStateType: .empty, animated: false)
        }
    }
    
    deinit {
        self.removeTarget(self, action: #selector(textFieldDidBeginEditing), for: UIControlEvents.editingDidBegin)
        self.removeTarget(self, action: #selector(textFieldDidEndEditing), for: UIControlEvents.editingDidEnd)
        self.removeTarget(self, action: #selector(textFieldTextDidChange), for: UIControlEvents.editingChanged)
    }
    
    
    // MARK: - Overrides
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        updateBorder()
        updatePlaceholder()
        configureTextField(forTextFieldStateType: textFieldStateType, forTextStateType: textStateType)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        let offsetY = placeholderLabel.bounds.height + 5
        let finalRect = CGRect(x: 0, y: offsetY, width: rect.width, height: rect.height - offsetY)
        return finalRect
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        let offsetY = placeholderLabel.bounds.height + 5
        let finalRect = CGRect(x: 0, y: offsetY, width: rect.width, height: rect.height - offsetY)
        return finalRect
    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        let offsetY = placeholderLabel.bounds.height + 5
        let finalRect = CGRect(x: rect.minX, y: offsetY, width: rect.width, height: rect.height)
        return finalRect
    }

    
    // MARK: - Private
    @objc private func textFieldDidBeginEditing() {
        if hasText {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .notEmpty)
        } else {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .empty)
        }
        validate()
    }
    
    @objc private func textFieldTextDidChange() {
        if hasText {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .notEmpty)
        } else {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .empty)
        }
        validate()
    }
    
    @objc private func textFieldDidEndEditing() {
        if hasText {
            configureTextField(forTextFieldStateType: .display, forTextStateType: .notEmpty)
        } else {
            configureTextField(forTextFieldStateType: .display, forTextStateType: .empty)
        }
        validate()
    }
    
    private func updateBorder() {
        configureBorder(forTextFieldStateType: textFieldStateType)
    }
    
    private func updatePlaceholder() {
        configurePlaceholder(forTextFieldStateType: textFieldStateType, forTextStateType: textStateType)
    }
    
    private func configureBorder(forTextFieldStateType textFieldStateType: TextFieldStateType) {
        if let text = text, !text.isEmpty {
            placeholderLabel.text = errorValidationHandler(text) ?? placeholder
        }
        if let font = font {
            placeholderLabel.font = font.withSize(font.pointSize * placeholderFontScale)
        }
        
        let size = placeholderLabel.sizeThatFits(bounds.size)
        placeholderLabel.frame.size.height = size.height

        switch textFieldStateType {
        case .entry:
            bottomBorderView.frame = CGRect(x: 0, y: bounds.maxY - borderWidth, width: bounds.width, height: borderWidth)
            bottomBorderView.backgroundColor = borderInactiveColor
            
            borderView.frame = CGRect(x: 0, y: bounds.maxY - borderWidth, width: bounds.width, height: borderWidth)
            borderView.backgroundColor = borderActiveColor
            
        case .display:
            bottomBorderView.frame = CGRect(x: 0, y: bounds.maxY - borderWidth, width: bounds.width, height: borderWidth)
            bottomBorderView.backgroundColor = borderInactiveColor

            borderView.frame = CGRect(x: 0, y: bounds.maxY - borderWidth, width: 0, height: borderWidth)
            borderView.backgroundColor = borderActiveColor
        }
    }
    
    private func validate() {
        if isFirstResponder, let text = text, !text.isEmpty {
            if let error = errorValidationHandler(text) {
                placeholderLabel.text = error
                placeholderLabel.textColor = errorColor
            } else {
                placeholderLabel.text = placeholder
                placeholderLabel.textColor = placeholderColor
            }
        } else {
            placeholderLabel.text = placeholder
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    private func configurePlaceholder(forTextFieldStateType textFieldStateType: TextFieldStateType, forTextStateType textStateType: TextStateType) {
        let color: UIColor
        if let text = text, !text.isEmpty {
            color = isValid ? placeholderColor : errorColor
        } else {
            color = placeholderColor
        }
        
        if textFieldStateType == .entry && textStateType == .empty {
            placeholderLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: placeholderLabel.bounds.height)
            placeholderLabel.textColor = color
        } else if textFieldStateType == .entry && textStateType == .notEmpty {
            placeholderLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: placeholderLabel.bounds.height)
            placeholderLabel.textColor = color
        } else if textFieldStateType == .display && textStateType == .empty {
            let textRectHeight = bounds.height - (placeholderLabel.bounds.height + 5)
            let offsetY = placeholderLabel.bounds.height + 5 + (textRectHeight / 2 - placeholderLabel.bounds.height / 2)
            let rect = CGRect(x: 0, y: offsetY, width: bounds.width, height: placeholderLabel.bounds.height)
            placeholderLabel.frame = rect
            placeholderLabel.textColor = color
        } else if textFieldStateType == .display && textStateType == .notEmpty {
            placeholderLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: placeholderLabel.bounds.height)
            placeholderLabel.textColor = color.withAlphaComponent(0.6)
        }
    }

    
    // MARK: - Public
    open func configureTextField(forTextFieldStateType textFieldStateType: TextFieldStateType, forTextStateType textStateType: TextStateType, animated: Bool = true) {
        self.textFieldStateType = textFieldStateType
        self.textStateType = textStateType
        
        let animationDuration: TimeInterval = animated ? 0.2 : 0.0
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut], animations: {
            self.configureBorder(forTextFieldStateType: textFieldStateType)
            self.configurePlaceholder(forTextFieldStateType: textFieldStateType, forTextStateType: textStateType)
        }, completion: { (finished) in
            // ...
        })
    }
}


@IBDesignable open class BeautifulTextField: BaseBeautifulTextField {
    
//    open override func configureTextField(forTextFieldStateType textFieldStateType: TextFieldStateType, forTextStateType textStateType: TextStateType, animated: Bool = true) {
//        super.configureTextField(forTextFieldStateType: textFieldStateType, forTextStateType: textStateType, animated: animated)
//        
//        let animationDuration = animated ? 0.15 : 0.0
//
//        UIView.animate(withDuration: animationDuration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
//            self.configureTextColor(forTextFieldStateType: textFieldStateType)
//        }, completion: { (finished) in
//                // ...
//        })
//    }
//    
//    
//    // MARK: - Custom
//    func configureTextColor(forTextFieldStateType textFieldStateType: TextFieldStateType) {
//        switch textFieldStateType {
//        case .display:
//            textColor = .gray
//            
//        case .entry:
//            textColor = .black
//        }
//    }
}
