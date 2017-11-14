//
//  BeautifulTextField.swift
//  Pods
//
//  Created by Dima on 06/10/2016.
//
//

import UIKit



@IBDesignable open class BaseBeautifulTextField: UITextField {
    
    // MARK: - States
    public enum TextFieldStateType {
        case entry
        case display
    }
    
    public enum TextStateType {
        case empty
        case notEmpty
    }
    
    public enum PlaceholderAlignmentType {
        case top
        case center
        case bottom
    }
    
    open private(set) var textFieldStateType: TextFieldStateType = .display
    open private(set) var textStateType: TextStateType = .empty

    
    @IBInspectable var animationDuration: TimeInterval = 0.2
    
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
    
    private var placeholderFont: UIFont? {
        if let font = font {
            return font.withSize(font.pointSize * placeholderFontScale)
        }
        return nil
    }
    
    @IBInspectable open var placeholderColor: UIColor = .darkGray {
        didSet {
            updatePlaceholder()
        }
    }
    
    open var placeholderAlignment: PlaceholderAlignmentType = .center {
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
    
    open var textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            layoutSubviews()
        }
    }
    
    // MARK: - Error handling
    open var validateOnEdit = true
    open var errorColor: UIColor = .red
    open var errorValidationHandler: (String) -> (String?) = { _ in
        return nil
    }
    
    open var isValid: Bool {
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
        
        let _bottomBorderView = UIView(frame: .zero)
        addSubview(_bottomBorderView)
        bottomBorderView = _bottomBorderView
        
        let _borderView = UIView(frame: .zero)
        addSubview(_borderView)
        borderView = _borderView
        
        let _placeholderLabel = UILabel(frame: .zero)
        addSubview(_placeholderLabel)
        placeholderLabel = _placeholderLabel

        borderStyle = .none
        
        _placeholder = super.placeholder
        super.placeholder = nil
        
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
        
        if borderView.bounds.width != bounds.width {
            configureTextField(forTextFieldStateType: textFieldStateType, forTextStateType: textStateType, animated: false)
        }
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        let offsetY: CGFloat
        if let placeholderFont = placeholderFont {
            offsetY = placeholderFont.lineHeight + 5
        } else {
            offsetY = 0
        }
        let finalRect = CGRect(x: 0, y: offsetY, width: rect.width, height: rect.height - offsetY)
        let rectWithInsets = UIEdgeInsetsInsetRect(finalRect, textInsets)
        return rectWithInsets
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        let offsetY: CGFloat
        if let placeholderFont = placeholderFont {
            offsetY = placeholderFont.lineHeight + 5
        } else {
            offsetY = 0
        }
        let finalRect = CGRect(x: 0, y: offsetY, width: rect.width, height: rect.height - offsetY)
        let rectWithInsets = UIEdgeInsetsInsetRect(finalRect, textInsets)
        return rectWithInsets
        
    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        let offsetY: CGFloat
        if let placeholderFont = placeholderFont {
            offsetY = placeholderFont.lineHeight + 5
        } else {
            offsetY = 0
        }
        let finalRect = CGRect(x: rect.minX, y: offsetY, width: rect.width, height: rect.height)
        let rectWithInsets = UIEdgeInsetsInsetRect(finalRect, textInsets)
        return rectWithInsets
    }
    
    // MARK: - Private
    @objc private func textFieldDidBeginEditing() {
        if hasText {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .notEmpty)
        } else {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .empty)
        }
        guard validateOnEdit else { return }
        validate()
    }
    
    @objc private func textFieldTextDidChange() {
        if hasText {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .notEmpty)
        } else {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .empty)
        }
        guard validateOnEdit else { return }
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
    
    private func validate() {
        if let text = text, !text.isEmpty {
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

    private func updateBorder() {
        configureBorder(forTextFieldStateType: textFieldStateType)
    }
    
    private func updatePlaceholder() {
        configurePlaceholder(forTextFieldStateType: textFieldStateType, forTextStateType: textStateType)
    }
    
    private func configureBorder(forTextFieldStateType textFieldStateType: TextFieldStateType) {
        switch textFieldStateType {
        case .entry:
            bottomBorderView.frame = CGRect(x: 0, y: bounds.height - borderWidth, width: bounds.width, height: borderWidth)
            bottomBorderView.layer.cornerRadius = bottomBorderView.bounds.height / 2
            bottomBorderView.backgroundColor = borderInactiveColor
            
            borderView.frame = CGRect(x: 0, y: bounds.height - borderWidth, width: bounds.width, height: borderWidth)
            borderView.layer.cornerRadius = borderView.bounds.height / 2
            borderView.backgroundColor = borderActiveColor
            
        case .display:
            bottomBorderView.frame = CGRect(x: 0, y: bounds.height - borderWidth, width: bounds.width, height: borderWidth)
            bottomBorderView.layer.cornerRadius = bottomBorderView.bounds.height / 2
            bottomBorderView.backgroundColor = borderInactiveColor

            borderView.frame = CGRect(x: 0, y: bounds.height - borderWidth, width: 0, height: borderWidth)
            borderView.layer.cornerRadius = borderView.bounds.height / 2
            borderView.backgroundColor = borderActiveColor
        }
    }
    
    private func configurePlaceholder(forTextFieldStateType textFieldStateType: TextFieldStateType, forTextStateType textStateType: TextStateType) {
        if let text = text, !text.isEmpty, validateOnEdit {
            placeholderLabel.text = errorValidationHandler(text) ?? placeholder
        } else {
            placeholderLabel.text = placeholder
        }
        placeholderLabel.font = placeholderFont
        placeholderLabel.textAlignment = textAlignment

        let size = placeholderLabel.sizeThatFits(bounds.size)
        placeholderLabel.frame.size.height = size.height

        if textFieldStateType == .entry && textStateType == .empty {
            placeholderLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: placeholderLabel.bounds.height)
        } else if textFieldStateType == .entry && textStateType == .notEmpty {
            placeholderLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: placeholderLabel.bounds.height)
        } else if textFieldStateType == .display && textStateType == .empty {
            let textRectHeight = bounds.height - (placeholderLabel.bounds.height + 5)
            
            let offsetY: CGFloat
            switch placeholderAlignment {
            case .top:
                offsetY = 5.0

            case .center:
                offsetY = placeholderLabel.bounds.height + textRectHeight / 2 - placeholderLabel.bounds.height + 5.0

            case .bottom:
                offsetY = placeholderLabel.bounds.height + (textRectHeight - placeholderLabel.bounds.height) / 2 + 5.0
            }
            
            let rect = CGRect(x: 0, y: offsetY, width: bounds.width, height: placeholderLabel.bounds.height)
            placeholderLabel.frame = rect
        } else if textFieldStateType == .display && textStateType == .notEmpty {
            placeholderLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: placeholderLabel.bounds.height)
        }
        placeholderLabel.frame = UIEdgeInsetsInsetRect(placeholderLabel.frame, textInsets)
    }

    
    // MARK: - Public
    open func configureTextField(forTextFieldStateType textFieldStateType: TextFieldStateType, forTextStateType textStateType: TextStateType, animated: Bool = true, animations: (() -> ())? = nil, completion: ((Bool) -> ())? = nil) {
        self.textFieldStateType = textFieldStateType
        self.textStateType = textStateType
        
        func configure() {
            configureBorder(forTextFieldStateType: textFieldStateType)
            configurePlaceholder(forTextFieldStateType: textFieldStateType, forTextStateType: textStateType)
        }
        
        if animated {
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut], animations: {
                configure()
                animations?()
            }, completion: { (finished) in
                completion?(finished)
            })
        } else {
            configure()
        }
    }
}


@IBDesignable open class BeautifulTextField: BaseBeautifulTextField {

    open override func configureTextField(forTextFieldStateType textFieldStateType: BaseBeautifulTextField.TextFieldStateType, forTextStateType textStateType: BaseBeautifulTextField.TextStateType, animated: Bool, animations: (() -> ())?, completion: ((Bool) -> ())?) {
        super.configureTextField(forTextFieldStateType: textFieldStateType, forTextStateType: textStateType, animated: animated, animations: { 
            switch textFieldStateType {
            case .display:
                self.textColor = self.textColor?.withAlphaComponent(0.6)
                
            case .entry:
                self.textColor = self.textColor?.withAlphaComponent(1.0)
            }
        }) { (finished) in
            // ...
        }
    }
}
