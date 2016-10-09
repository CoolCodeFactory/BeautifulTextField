# BeautifulTextField

[![Version](https://img.shields.io/cocoapods/v/BeautifulTextField.svg?style=flat)](http://cocoapods.org/pods/BeautifulTextField)
[![License](https://img.shields.io/cocoapods/l/BeautifulTextField.svg?style=flat)](http://cocoapods.org/pods/BeautifulTextField)
[![Platform](https://img.shields.io/cocoapods/p/BeautifulTextField.svg?style=flat)](http://cocoapods.org/pods/BeautifulTextField)

## About

BeautifulTextField is just a beautiful UITextField. Easy to customize! Easy to use! Try it now!


## Example

![Example Gif](https://raw.githubusercontent.com/CoolCodeFactory/BeautifulTextField/master/example.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements

Inside Interface Builder (storyboard / XIB) set borderStyle to None and setup custom height of textField ~ 40pt~50pt (depends on fontSize and placeholderFontScale)


## Customize

Use default property to setup textField
```swift
// Readonly views
var borderView: UIView!
var bottomBorderView: UIView!
var placeholderLabel: UILabel!

// Border
var borderInactiveColor: UIColor = .lightGray
var borderActiveColor: UIColor = .red
var borderWidth: CGFloat = 2.0

// Placeholder
var placeholderFontScale: CGFloat = 0.7
var placeholderColor: UIColor = .black
var placeholder: String  // Setup placeholder inside Inteface Builder or right inside code!

// Error
var errorColor: UIColor = .red
var errorValidationHandler: (String) -> (String?)
var isValid: Bool  // (readonly) Anytime you could check textField validation status
```

Use your own validator 
```swift
emailTextField.errorValidationHandler = { text in
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let match = emailTest.evaluate(with: text)
    return (match ? "Invalid email" : nil)
}
```

Setup custom textColor animation! (or whatever you want!)
```swift
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
```

## Installation

BeautifulTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BeautifulTextField"
```

## Author

Dmitry Utmanov, utm4@mail.ru

## License

BeautifulTextField is available under the MIT license. See the LICENSE file for more info.
