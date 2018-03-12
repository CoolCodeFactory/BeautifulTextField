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
    open weak private(set) var topBorderView: UIView!
    open weak private(set) var bottomBorderView: UIView!

    @IBInspectable public var borderInactiveColor: UIColor = .lightGray {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable public var borderActiveColor: UIColor = .cyan {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 2.0 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable public var isTopBorderAvailable: Bool = false {
        didSet {
            updateBorder()
        }
    }
    
    open var rightViewOffset = CGPoint(x: 0, y: 0)
    open var placeholderEntryOffset = CGPoint(x: 0, y: 0)
    
    // MARK: - Placeholder
    open var placeholderOffset: CGPoint = CGPoint(x: 0, y: 5) {
        didSet {
            updatePlaceholder()
        }
    }
    
    open weak private(set) var placeholderLabel: UILabel!
    
    @IBInspectable public var placeholderFontScale: CGFloat = 0.7 {
        didSet {
            updatePlaceholder()
        }
    }
    
    private var placeholderFont: UIFont? {
        return font
    }
    
    @IBInspectable public var placeholderColor: UIColor = .darkGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
            updatePlaceholder()
        }
    }
    
    public var placeholderAlignment: PlaceholderAlignmentType = .center {
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
    
    public var textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            layoutSubviews()
        }
    }
    
    // MARK: - Error handling
    open var isLiveValidation = true
    
    public enum ErrorMarkType {
        case placeholder
        case border
    }
    
    open var errorMarkType: [ErrorMarkType] = [.placeholder, .border]
    
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
        
        let _topBorderView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: borderWidth))
        _topBorderView.layer.cornerRadius = _topBorderView.bounds.height / 2
        _topBorderView.autoresizingMask = .flexibleWidth
        addSubview(_topBorderView)
        topBorderView = _topBorderView
        
        let _bottomBorderView = UIView(frame: CGRect(x: 0, y: bounds.height - borderWidth, width: bounds.width, height: borderWidth))
        _bottomBorderView.layer.cornerRadius = _bottomBorderView.bounds.height / 2
        _bottomBorderView.autoresizingMask = .flexibleWidth
        addSubview(_bottomBorderView)
        bottomBorderView = _bottomBorderView
        
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
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightViewOffset.x
        textRect.origin.y -= rightViewOffset.y
        return textRect
    }
    
    
    // MARK: - Private
    
    @objc private func textFieldDidBeginEditing() {
        if hasText {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .notEmpty)
        } else {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .empty)
        }
        guard isLiveValidation else { return }
        validate()
    }
    
    @objc private func textFieldTextDidChange() {
        if hasText {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .notEmpty)
        } else {
            configureTextField(forTextFieldStateType: .entry, forTextStateType: .empty)
        }
        guard isLiveValidation else { return }
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
                if errorMarkType.contains(where: { $0 == .placeholder }) {
                    placeholderLabel.textColor = errorColor
                }
                if errorMarkType.contains(where: { $0 == .border }) {
                    bottomBorderView.backgroundColor = errorColor
                }
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
        updateBorderState(forTextFieldStateType: textFieldStateType)
    }
    
    private func updatePlaceholder() {
        configurePlaceholder(forTextFieldStateType: textFieldStateType, forTextStateType: textStateType)
    }
    
    private func updateBorderState(forTextFieldStateType textFieldStateType: TextFieldStateType) {
        topBorderView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: borderWidth)
        bottomBorderView.frame = CGRect(x: 0, y: bounds.height - borderWidth, width: bounds.width, height: borderWidth)
        topBorderView.isHidden = !isTopBorderAvailable
        
        switch textFieldStateType {
        case .entry:
            topBorderView.backgroundColor = borderActiveColor
            bottomBorderView.backgroundColor = borderActiveColor
            
        case .display:
            topBorderView.backgroundColor = borderInactiveColor
            bottomBorderView.backgroundColor = borderInactiveColor
        }
    }
    
    private func configurePlaceholder(forTextFieldStateType textFieldStateType: TextFieldStateType, forTextStateType textStateType: TextStateType) {
        placeholderLabel.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        if textFieldStateType == .display && textStateType == .empty {
            placeholderLabel.transform = CGAffineTransform.identity
        } else {
            placeholderLabel.transform = CGAffineTransform(scaleX: placeholderFontScale, y: placeholderFontScale)
        }
        
        if let text = text, !text.isEmpty, isLiveValidation {
            placeholderLabel.text = errorValidationHandler(text) ?? placeholder
        } else {
            placeholderLabel.text = placeholder
        }
        placeholderLabel.font = font
        placeholderLabel.textAlignment = textAlignment

        let size = placeholderLabel.sizeThatFits(bounds.size)
        placeholderLabel.frame.size.height = size.height

        if textFieldStateType == .entry && textStateType == .empty {
            placeholderLabel.frame = CGRect(x: placeholderOffset.x, y: placeholderOffset.y + placeholderEntryOffset.y, width: bounds.width, height: placeholderLabel.frame.height)
        } else if textFieldStateType == .entry && textStateType == .notEmpty {
            placeholderLabel.frame = CGRect(x: placeholderOffset.x, y: placeholderOffset.y + placeholderEntryOffset.y, width: bounds.width, height: placeholderLabel.frame.height)
            if !isLiveValidation {
                placeholderLabel.textColor = placeholderColor
            }
        } else if textFieldStateType == .display && textStateType == .empty {
            let textRectHeight = bounds.height - (placeholderLabel.frame.height + 5)
            
            let offsetY: CGFloat
            switch placeholderAlignment {
            case .top:
                offsetY = placeholderOffset.y

            case .center:
                offsetY = placeholderLabel.frame.height + textRectHeight / 2 - placeholderLabel.frame.height + placeholderOffset.y

            case .bottom:
                offsetY = placeholderLabel.frame.height + (textRectHeight - placeholderLabel.frame.height) / 2 + placeholderOffset.y
            }
            
            let rect = CGRect(x: 0, y: offsetY, width: bounds.width, height: placeholderLabel.frame.height)
            placeholderLabel.frame = rect
        } else if textFieldStateType == .display && textStateType == .notEmpty {
            placeholderLabel.frame = CGRect(x: placeholderOffset.x, y: placeholderOffset.y + placeholderEntryOffset.y, width: bounds.width, height: placeholderLabel.frame.height)
        }
        placeholderLabel.frame = UIEdgeInsetsInsetRect(placeholderLabel.frame, textInsets)
    }

    
    // MARK: - Public
    open func configureTextField(forTextFieldStateType textFieldStateType: TextFieldStateType, forTextStateType textStateType: TextStateType, animated: Bool = true, animations: (() -> ())? = nil, completion: ((Bool) -> ())? = nil) {
        self.textFieldStateType = textFieldStateType
        self.textStateType = textStateType
        
        func configure() {
            updateBorderState(forTextFieldStateType: textFieldStateType)
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
                self.textColor = self.textColor?.withAlphaComponent(0.9)
                
            case .entry:
                self.textColor = self.textColor?.withAlphaComponent(1.0)
            }
        }) { (finished) in
            // ...
        }
    }
}
