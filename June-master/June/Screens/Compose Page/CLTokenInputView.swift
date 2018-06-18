import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


protocol CLTokenInputViewDelegate: class {
    func tokenInputViewDidEndEditing(_ aView: CLTokenInputView)
    func tokenInputViewDidBeginEditing(_ aView: CLTokenInputView)
    func tokenInputView(_ aView:CLTokenInputView, didChangeText text:String)
    func tokenInputView(_ aView:CLTokenInputView, didAddToken token:CLToken)
    func tokenInputView(_ aView:CLTokenInputView, didRemoveToken token:CLToken)
    func tokenInputView(_ aView:CLTokenInputView, tokenForText text:String) -> CLToken?
    func tokenInputView(_ aView:CLTokenInputView, didChangeHeightTo height:CGFloat)
}

class CLTokenInputView: UIView, CLBackspaceDetectingTextFieldDelegate, CLTokenViewDelegate {
    weak var delegate:CLTokenInputViewDelegate?
    var fieldLabel:UILabel!
    var fieldView:UIView? {
        willSet {
            if self.fieldView != newValue {
                self.fieldView?.removeFromSuperview()
            }
        }
        
        didSet {
            if oldValue != self.fieldView {
                if (self.fieldView != nil) {
                    self.addSubview(self.fieldView!)
                }
                self.repositionViews()
            }
        }
    }
    var fieldName:String? {
        didSet {
            if oldValue != self.fieldName {
                self.fieldLabel.text = self.fieldName
                self.fieldLabel.sizeToFit()
                let showField:Bool = self.fieldName!.count > 0
                self.fieldLabel.isHidden = !showField
                if showField && self.fieldLabel.superview == nil {
                    self.addSubview(self.fieldLabel)
                }
                else if !showField && self.fieldLabel.superview != nil {
                    self.fieldLabel.removeFromSuperview()
                }
                
                if oldValue == nil || oldValue != self.fieldName {
                    self.repositionViews()
                }
            }
            
        }
    }
    var fieldColor:UIColor? {
        didSet {
            self.fieldLabel.textColor = self.fieldColor
        }
    }
    var placeholderText:String? {
        didSet {
            if oldValue != self.placeholderText {
                self.updatePlaceholderTextVisibility()
            }
        }
    }
    
    var keyboardType: UIKeyboardType! {
        didSet {
            self.textField.keyboardType = self.keyboardType;
        }
    }
    var autocapitalizationType: UITextAutocapitalizationType! {
        didSet {
            self.textField.autocapitalizationType = self.autocapitalizationType;
        }
    }
    var autocorrectionType: UITextAutocorrectionType! {
        didSet {
            self.textField.autocorrectionType = self.autocorrectionType;
        }
    }
    var tokenizationCharacters:Set<String> = Set<String>()
    var drawBottomBorder:Bool! {
        didSet {
            if oldValue != self.drawBottomBorder {
                self.setNeedsDisplay()
            }
        }
    }
    //var editing:Bool = false
    
    var tokens:[CLToken] = []
    var tokenViews:[CLTokenView] = []
    var textField:CLBackspaceDetectingTextField!
    var intrinsicContentHeight:CGFloat!
    var additionalTextFieldYOffset:CGFloat!
    
    let HSPACE:CGFloat = 0.0
    let TEXT_FIELD_HSPACE:CGFloat = 4.0 // Note: Same as CLTokenView.PADDING_X
    let VSPACE:CGFloat = 4.0
    let MINIMUM_TEXTFIELD_WIDTH:CGFloat = 56.0
    let PADDING_TOP:CGFloat = 10.0
    let PADDING_BOTTOM:CGFloat = 10.0
    let PADDING_LEFT:CGFloat = -3.0
    let PADDING_RIGHT:CGFloat = 16.0
    let STANDARD_ROW_HEIGHT:CGFloat = 25.0
    let FIELD_MARGIN_X:CGFloat = 4.0
    
    func commonInit() {

        


        self.textField = CLBackspaceDetectingTextField(frame: self.bounds)
        let font = UIFont(name: "Proxima Nova", size: 12)!
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.font : font]
        self.textField.attributedPlaceholder = NSAttributedString(string: "TO", attributes:attributes)
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.backgroundColor = UIColor.clear
        self.textField.keyboardType = UIKeyboardType.default
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none
        self.textField.delegate = self
        //self.additionalTextFieldYOffset = 0.0
        self.additionalTextFieldYOffset = 1.5
        self.textField.addTarget(self, action: #selector(CLTokenInputView.onTextFieldDidChange(_:)), for: .editingChanged)
        self.addSubview(self.textField)
        
        self.fieldLabel = UILabel(frame: CGRect.zero)
        self.fieldLabel.translatesAutoresizingMaskIntoConstraints = false
        self.fieldLabel.font = self.textField.font
        self.fieldLabel.textColor = self.fieldColor
        self.addSubview(self.fieldLabel)
        self.fieldLabel.isHidden = true
        self.fieldColor = UIColor.lightGray
        self.intrinsicContentHeight = STANDARD_ROW_HEIGHT
        
        self.repositionViews()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override var intrinsicContentSize : CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: max(45, self.intrinsicContentHeight))
    }
    
    override func tintColorDidChange() {
        self.tokenViews.forEach { $0.tintColor = self.tintColor }
    }
    
    func addToken(_ token:CLToken) {
        if self.tokens.contains(token) {
            return
        }
        
        self.tokens.append(token)
        print(tokens.count)
        
        let tokenView:CLTokenView = CLTokenView(token: token, font: self.textField.font)
        tokenView.translatesAutoresizingMaskIntoConstraints = false
        tokenView.tintColor = self.tintColor
        tokenView.delegate = self
        
        let intrinsicSize:CGSize = tokenView.intrinsicContentSize
        tokenView.frame = CGRect(x: 0.0, y: 0.0, width: intrinsicSize.width , height: intrinsicSize.height)
        self.tokenViews.append(tokenView)
        self.addSubview(tokenView)
        self.textField.text = ""
        self.delegate?.tokenInputView(self, didAddToken: token)
        self.onTextFieldDidChange(self.textField)
        
        self.updatePlaceholderTextVisibility()
        
        self.repositionViews()
    }
    
    func removeTokenAtIndex(_ index:Int) {
        if index == -1 {
            return
        }
        let tokenView = self.tokenViews[index]
        tokenView.removeFromSuperview()
        self.tokenViews.remove(at: index)
        let removedToken = self.tokens[index]
        self.tokens.remove(at: index)
        self.delegate?.tokenInputView(self, didRemoveToken: removedToken)
        self.updatePlaceholderTextVisibility()
        self.repositionViews()
    }
    
    func removeToken(_ token:CLToken) {
        let index:Int? = self.tokens.index(of: token)
        if index != nil {
            self.removeTokenAtIndex(index!)
        }
    }
    
    func allTokens() -> [CLToken] {
        return Array(self.tokens)
    }
    
    func tokenizeTextfieldText() -> CLToken? {
        //print("tokenizeTextfieldText()")
        var token:CLToken? = nil
        
        let text:String = self.textField.text!
        if text.count > 0  {
            token = self.delegate?.tokenInputView(self, tokenForText: text)
            if (token != nil) {
                self.addToken(token!)
                self.textField.text = ""
                self.onTextFieldDidChange(self.textField)
            }
        }
        
        return token
    }
    
    func repositionViews() {
        let bounds:CGRect = self.bounds
        let rightBoundary:CGFloat = bounds.width - PADDING_RIGHT
        let firstLineRightBoundary:CGFloat = rightBoundary
        var curX:CGFloat = PADDING_LEFT
        var curY:CGFloat = PADDING_TOP
        var totalHeight:CGFloat = STANDARD_ROW_HEIGHT
        var isOnFirstLine:Bool = true
        
        // Position field view (if set)
        if self.fieldView != nil {
            var fieldViewRect:CGRect = self.fieldView!.frame
            fieldViewRect.origin.x = curX + FIELD_MARGIN_X
            fieldViewRect.origin.y = curY + ((STANDARD_ROW_HEIGHT - fieldViewRect.height / 2.0)) - PADDING_TOP
            self.fieldView?.frame = fieldViewRect
            
            curX = fieldViewRect.maxX + FIELD_MARGIN_X
            // print("fieldViewRect=\(fieldViewRect)")
        }
        
        // Position field label (if field name is set)
        if !(self.fieldLabel.isHidden) {
            var fieldLabelRect:CGRect = self.fieldLabel.frame
            fieldLabelRect.origin.x = curX + FIELD_MARGIN_X
            fieldLabelRect.origin.y = curY + ((STANDARD_ROW_HEIGHT - fieldLabelRect.height / 2.0)) - PADDING_TOP
            
            self.fieldLabel.frame = fieldLabelRect
            
            curX = fieldLabelRect.maxX + FIELD_MARGIN_X
            //print("fieldLabelRect=\(fieldLabelRect)")
        }
        
        // Position token views
        var tokenRect:CGRect = CGRect.null
        for tokenView:CLTokenView in self.tokenViews {
            tokenRect = tokenView.frame
            
            let tokenBoundary:CGFloat = isOnFirstLine ? firstLineRightBoundary : rightBoundary
            if curX + tokenRect.width > tokenBoundary {
                // Need a new line
                curX = PADDING_LEFT
                curY += STANDARD_ROW_HEIGHT + VSPACE
                totalHeight += STANDARD_ROW_HEIGHT
                isOnFirstLine = false
            }
            
            if (self.tokenViews.count != 0) {
                tokenRect.origin.x = curX + 20
            } else {
                tokenRect.origin.x = curX
            }
            
            
            // Center our tokenView vertically within STANDARD_ROW_HEIGHT
            tokenRect.origin.y = curY + ((STANDARD_ROW_HEIGHT - tokenRect.height) / 2.0)
            tokenView.frame = tokenRect
            
            curX = tokenRect.maxX + HSPACE
            
        }
        
        // Always indent textfield by a little bit
        curX += TEXT_FIELD_HSPACE
        let textBoundary:CGFloat = isOnFirstLine ? firstLineRightBoundary : rightBoundary
        var availableWidthForTextField:CGFloat = textBoundary - curX;
        if availableWidthForTextField < MINIMUM_TEXTFIELD_WIDTH {
            isOnFirstLine = false
            curX = PADDING_LEFT + TEXT_FIELD_HSPACE
            curY += STANDARD_ROW_HEIGHT + VSPACE
            totalHeight += STANDARD_ROW_HEIGHT
            // Adjust the width
            availableWidthForTextField = rightBoundary - curX;
        }
        
        var textFieldRect:CGRect = self.textField.frame;
        textFieldRect.origin.x = curX
        textFieldRect.origin.y = curY + self.additionalTextFieldYOffset
        textFieldRect.size.width = availableWidthForTextField
        textFieldRect.size.height = STANDARD_ROW_HEIGHT
        self.textField.frame = textFieldRect
        
        let oldContentHeight:CGFloat = self.intrinsicContentHeight;
        self.intrinsicContentHeight = textFieldRect.maxY+PADDING_BOTTOM;
        self.invalidateIntrinsicContentSize()
        
        if oldContentHeight != self.intrinsicContentHeight {
            self.delegate?.tokenInputView(self, didChangeHeightTo: self.intrinsicContentSize.height)
        }
        self.setNeedsDisplay()
    }
    
    func updatePlaceholderTextVisibility() {
        if self.tokens.count > 0 {
            self.textField.placeholder = nil
        }
        else {
            self.textField.placeholder = self.placeholderText
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.repositionViews()
    }
    
    
    // MARK: CLBackspaceDetectingTextFieldDelegate
    
    func textFieldDidDeleteBackwards(_ textField: UITextField) {
        DispatchQueue.main.async { () -> Void in
            if textField.text?.count == 0 {
                let tokenView:CLTokenView? = self.tokenViews.last
                if tokenView != nil {
                    self.selectTokenView(tokenView!, animated: true)
                    self.textField.resignFirstResponder()
                }
            }
        }
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("textFieldDidBeginEditing:")
        self.delegate?.tokenInputViewDidBeginEditing(self)
        
        self.tokenViews.last?.hideUnselectedComma = false
        self.unselectAllTokenViewsAnimated(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("textFieldDidEndEditing:")
        
        self.delegate?.tokenInputViewDidEndEditing(self)
        self.tokenViews.last?.hideUnselectedComma = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("textFieldShouldReturn:")
        textField.resignFirstResponder();
        //   self.tokenizeTextfieldText()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //print("textField:shouldChangeCharactersInRange:replacementString:\(string)")
        
        if string.count > 0 && self.tokenizationCharacters.contains(string) {
            //   self.tokenizeTextfieldText()
            return false
        }
        return true
    }
    
    @objc func onTextFieldDidChange(_ sender:UITextField) {
        // print("onTextFieldDidChange")
        self.delegate?.tokenInputView(self, didChangeText: self.textField.text!)
    }
    
    
    func textFieldDisplayOffset() -> CGFloat {
        return self.textField.frame.minY - PADDING_TOP;
    }
    
    func text() -> String? {
        return self.textField.text
    }
    
    func tokenViewDidRequestDelete(_ tokenView:CLTokenView, replaceWithText replacementText:String?) {
        self.textField.becomeFirstResponder()
        if replacementText?.count > 0 {
            self.textField.text = replacementText
        }
        let index:Int? = self.tokenViews.index(of: tokenView)
        if index == nil {
            return
        }
        self.removeTokenAtIndex(index!)
    }
    
    func tokenViewDidRequestSelection(_ tokenView:CLTokenView) {
        self.selectTokenView(tokenView, animated:true)
    }
    
    func selectTokenView(_ tokenView:CLTokenView, animated aBool:Bool) {
        tokenView.setSelected(true, animated: aBool)
        for otherTokenView:CLTokenView in self.tokenViews {
            if otherTokenView != tokenView {
                otherTokenView.setSelected(false, animated: aBool)
            }
        }
    }
    
    func unselectAllTokenViewsAnimated(_ animated:Bool) {
        for tokenView:CLTokenView in self.tokenViews {
            tokenView.setSelected(false, animated: animated)
        }
    }
    
    
    //
    
    func isEditing() -> Bool {
        return self.textField.isEditing
    }
    
    func beginEditing() {
        self.textField.becomeFirstResponder()
        self.unselectAllTokenViewsAnimated(false)
    }
    
    func endEditing() {
        self.textField.resignFirstResponder()
    }
    
    //
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.drawBottomBorder == true {
            let context:CGContext? = UIGraphicsGetCurrentContext()
            context?.setStrokeColor(UIColor.lightGray.cgColor)
            context?.setLineWidth(0.5)
            
            context?.move(to: CGPoint(x: self.bounds.width, y: self.bounds.size.height))
            context?.addLine(to: CGPoint(x: bounds.width, y: bounds.size.height));
            context?.strokePath()
        }
    }
    
}
