//
//  FullEmailViewController.swift
//  June
//
//  Created by Joshua Cleetus on 10/2/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit
import Down

class FullEmailViewController: UIViewController {

    var emailThread: Messages?
    var scrollView: UIScrollView = UIScrollView()
    private var delegate: FullEmailViewDelegate?
    
    private var subjectTitleLabel: UILabel!
    private var titleLabel: UILabel!
    
    private var moreButton: UIButton!
    private var arrowDownBtn: UIButton!
    private var ccInt: Int = 0
    private var toString = "to "
    private var ccString = ""
    
    let fromLabel = UILabel()
    let toLabel = UILabel()
    let toTextView = UITextView()
    let ccLabel = UILabel()
    let ccTextView = UITextView()
    let bccLabel = UILabel()
    let dateLabel = UILabel()
    let webView = UIWebView()
    
    static let subjectTitleLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .mediumLarge)
    static let titleLabelFont: UIFont = UIFont.latoStyleAndSize(style: .regular, size: .midSmall)
    static let fromLabelFont: UIFont = UIFont.latoStyleAndSize(style: .black, size: .mediumLarge)
    static let toLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .bold, size: .regular)
    static let ccLabelFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regMid)
    static let bccLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    static let dateLabelFont: UIFont = UIFont.proximaNovaStyleAndSize(style: .semibold, size: .regMid)
    static let moreButtonTitleFont: UIFont = UIFont.latoStyleAndSize(style: .bold, size: .regular)

    private let leftOffset = 0.051 * UIScreen.main.bounds.width
    private let leftWebOffset = (0.051 * UIScreen.main.bounds.width) - 8

    var isExpandTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back_arrow")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_arrow")
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(18, 0), for: .default)
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    let whiteView = UIView()
    func addMoreButton() {
        
        whiteView.frame = CGRect(x: 280, y: 89, width: 40, height: 23)
        whiteView.backgroundColor = UIColor.white
        self.scrollView.addSubview(whiteView)
        
        let str = self.ccInt - 3
        let buttonTitle = UILabel()
        buttonTitle.textColor = UIColor.init(hexString: "8E9198")
        buttonTitle.text = "+\(str) more"
        buttonTitle.frame = CGRect(x: 4, y: 4, width: 59, height: 13)
        buttonTitle.textAlignment = .center
        buttonTitle.backgroundColor = .white
        buttonTitle.font = FullEmailViewController.moreButtonTitleFont
        
        self.moreButton = UIButton()
        self.moreButton.frame = CGRect(x: 289, y: 90, width: 69, height: 21)
        self.moreButton.backgroundColor = .white
        self.moreButton.layer.cornerRadius = self.moreButton.frame.size.height / 2
        self.moreButton.layer.borderWidth = 1
        self.moreButton.layer.borderColor = UIColor.init(hexString: "8E9198").cgColor
        self.moreButton.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
        self.scrollView.addSubview(moreButton)
        self.moreButton.addSubview(buttonTitle)
        
    }
    
    @objc func moreButtonPressed() {
        whiteView.removeFromSuperview()
        
        let toArray = emailThread?.messages_to?.allObjects as? Array<Messages_To>
        if toArray?.count != nil {
            
            var nameArray: [NSAttributedString] = []
            var emailArray: [NSAttributedString] = []
            for toData in toArray! {
                let toObject:Messages_To = toData
                
                if let name = toObject.name {
                    var nameAtrStr = NSAttributedString()
                    nameAtrStr = NSAttributedString(string: name.capitalized, attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .bold, size: .regMid)])
                    nameArray.append(nameAtrStr)
                }
                if let email = toObject.email {
                    var emailAtrStr = NSAttributedString()
                    emailAtrStr = NSAttributedString(string: email, attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .regular, size: .regMid)])
                    emailArray.append(emailAtrStr)
                }
            }
            
            var space: [NSAttributedString] = []
            var spaceAtr = NSAttributedString()
            spaceAtr = NSAttributedString(string: "  ", attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .regular, size: .regMid)])
            space.append(spaceAtr)
            
            var toStr = NSAttributedString()
            toStr = NSAttributedString(string: "TO \n", attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .regular, size: .regMid)])
            
            var comma: [NSAttributedString] = []
            var commaAtr = NSAttributedString()
            commaAtr = NSAttributedString(string: ", \n", attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .regular, size: .regMid)])
            comma.append(spaceAtr)
            
            let concatenatedStr: NSMutableAttributedString = NSMutableAttributedString.init(string: "")
            concatenatedStr.append(toStr)
            
            for (index, element) in nameArray.enumerated() {
                concatenatedStr.append(element)
                if element.string.count > 0 {
                    concatenatedStr.append(spaceAtr)
                }
                concatenatedStr.append(emailArray[index])
                if index != nameArray.count - 1 {
                    concatenatedStr.append(commaAtr)
                }
            }
            
            toLabel.attributedText = concatenatedStr
            toTextView.attributedText = concatenatedStr
        }
        
        
        let ccArray = emailThread?.messages_cc?.allObjects as? Array<Messages_Cc>
        if ccArray?.count != nil {
            var nameArray: [NSAttributedString] = []
            var emailArray: [NSAttributedString] = []
            
            for ccData in ccArray! {
                let ccObject:Messages_Cc = ccData
                
                if let name = ccObject.name {
                    var nameAtrStr = NSAttributedString()
                    nameAtrStr = NSAttributedString(string: name.capitalized, attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .bold, size: .regMid)])
                    nameArray.append(nameAtrStr)
                }
                
                if let email = ccObject.email {
                    var emailAtrStr = NSAttributedString()
                    emailAtrStr = NSAttributedString(string: email, attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .regular, size: .regMid)])
                    emailArray.append(emailAtrStr)
                }
            }
            
            var space: [NSAttributedString] = []
            var spaceAtr = NSAttributedString()
            spaceAtr = NSAttributedString(string: "  ", attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .regular, size: .regMid)])
            space.append(spaceAtr)
            
            var comma: [NSAttributedString] = []
            var commaAtr = NSAttributedString()
            commaAtr = NSAttributedString(string: ", \n", attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .regular, size: .regMid)])
            comma.append(spaceAtr)
            
            var ccAtr = NSAttributedString()
            ccAtr = NSAttributedString(string: "CC \n", attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .regular, size: .regMid)])
            
            let concatenatedStr: NSMutableAttributedString = NSMutableAttributedString.init(string: "")
            concatenatedStr.append(ccAtr)
            
            for (index, element) in nameArray.enumerated() {
                concatenatedStr.append(element)
                if element.string.count > 0 {
                    concatenatedStr.append(spaceAtr)
                }
                concatenatedStr.append(emailArray[index])
                if index != nameArray.count - 1 {
                    concatenatedStr.append(commaAtr)
                }
            }
            
            ccLabel.attributedText = concatenatedStr
            
            ccTextView.attributedText = concatenatedStr
            ccLabel.numberOfLines = 0
        }
        
        UIView.animate(withDuration: 0.5) {
            self.toLabel.numberOfLines = 0
            self.ccTextView.snp.remakeConstraints({ (make) in
                make.leading.equalTo(self.scrollView.snp.leading).offset(16)
                make.top.equalTo(self.toLabel.snp.bottom)
                make.width.equalTo(340)
            })
          
        }
        toLabel.isHidden = true
        toTextView.isHidden = false
        ccLabel.isHidden = true
        ccTextView.isHidden = false
        loadWebView()
        
        self.addArrowDown()
        moreButton.removeFromSuperview()
    }
    
    func addArrowDown() {
        
        self.arrowDownBtn = UIButton()
        self.arrowDownBtn.frame = CGRect(x: 345, y: 76, width: 16, height: 10)
        self.arrowDownBtn.setImage(#imageLiteral(resourceName: "arrow-down"), for: .normal)
        self.arrowDownBtn.addTarget(self, action: #selector(arrowButtonClicked), for: .touchUpInside)
        self.scrollView.addSubview(arrowDownBtn)
    }
    
    @objc func arrowButtonClicked() {
       
        toLabel.isHidden = false
        self.toLabel.text = toString
        toTextView.isHidden = true
        self.ccTextView.isHidden = true

        self.ccLabel.isHidden = false
        self.ccLabel.text = ccString

        UIView.animate(withDuration: 0.4) {
            self.toLabel.numberOfLines = 1
            self.ccLabel.numberOfLines = 2
        }

        self.arrowDownBtn.removeFromSuperview()

        ccLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(scrollView.snp.leading).offset(20)
            make.top.equalTo(toLabel.snp.bottom).offset(10)
            make.width.equalTo(320)
        }
        self.ccTextView.snp.remakeConstraints({ (make) in
            make.leading.equalTo(self.scrollView.snp.leading).offset(16)
            make.top.equalTo(self.ccLabel.snp.bottom)
            make.width.equalTo(340)
        })
        self.addMoreButton()
        loadWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setUpView() {
        self.view.backgroundColor = .white
        
        delegate = FullEmailViewDelegate(parentVC: self)

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = self.view.bounds.size
        scrollView.contentInset = UIEdgeInsets(
            top: 0, left: 0, bottom: 0, right: 0)
        scrollView.delegate = delegate
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.isUserInteractionEnabled = true
        scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(fromLabel)
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(scrollView.snp.leading).offset(20)
            make.top.equalTo(scrollView.snp.top).offset(20)
            make.width.equalTo(310)
        }
        fromLabel.numberOfLines = 0
        fromLabel.font = FullEmailViewController.fromLabelFont
        fromLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        fromLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        scrollView.addSubview(toLabel)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        toLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(scrollView.snp.leading).offset(20)
            make.top.equalTo(fromLabel.snp.bottom).offset(10)
            make.width.equalTo(310)
        }
        toLabel.numberOfLines = 0
        toLabel.font = FullEmailViewController.toLabelFont
        toLabel.textColor = UIColor.init(hexString: "8E9198")
        toLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        toLabel.textAlignment = .left
        
        scrollView.addSubview(toTextView)
        toTextView.widthAnchor.constraint(equalToConstant: 310).isActive = true
        toTextView.snp.remakeConstraints { (make) in
            make.leading.equalTo(scrollView.snp.leading).offset(16)
            make.top.equalTo(fromLabel.snp.bottom).offset(10)
            make.width.equalTo(310)
        }
        toTextView.isHidden = true
        toTextView.font = FullEmailViewController.toLabelFont
        toTextView.textColor = UIColor.init(hexString: "8E9198")
        toTextView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        toTextView.isEditable = false
        toTextView.isScrollEnabled = false
        toTextView.textAlignment = .left
        
        scrollView.addSubview(ccLabel)
        ccLabel.translatesAutoresizingMaskIntoConstraints = false
        ccLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(scrollView.snp.leading).offset(20)
            make.top.equalTo(toLabel.snp.bottom).offset(10)
            make.width.equalTo(320)
        }
        ccLabel.numberOfLines = 2
        ccLabel.isHidden = false
        ccLabel.font = FullEmailViewController.ccLabelFont
        ccLabel.textColor = UIColor.init(hexString: "8E9198")
        ccLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        ccLabel.textAlignment = .left
        
        scrollView.addSubview(self.ccTextView)
        ccTextView.font = FullEmailViewController.ccLabelFont
        ccTextView.textColor = UIColor.init(hexString: "2D3855")
        ccTextView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        ccTextView.isEditable = false
        ccTextView.isScrollEnabled = false
        ccTextView.isHidden = true
        self.ccTextView.translatesAutoresizingMaskIntoConstraints = false
        self.ccTextView.snp.remakeConstraints { (make) in
            make.leading.equalTo(scrollView.snp.leading).offset(16)
            make.top.equalTo(toLabel.snp.bottom).offset(10)
            make.width.equalTo(340)
        }
        ccTextView.textAlignment = .left
        
        let fromArray = emailThread?.messages_from?.allObjects as? Array<Messages_From>
        if let fromArrayCount = fromArray?.count, fromArrayCount > 0 {
            if let from:Messages_From = fromArray?[0] {
                var fromString = ""
                if let name = from.name {
                    fromString = name.capitalized
                }
                if let email = from.email {
                    fromString = fromString + " <" + email + ">"
                }
                fromLabel.text = fromString
            }
        }
        
        let toArray = emailThread?.messages_to?.allObjects as? Array<Messages_To>
        if toArray?.count != nil {
            var nameArray: [String] = []
            for toData in toArray! {
                let toObject:Messages_To = toData
                if let email = toObject.email {
                    nameArray.append(email)
                } else {
                    nameArray.append(toObject.name!)
                }
            }
            let nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: ", ")
            self.toString = "TO " + nameConcatenatedString
            
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: toString, attributes: [NSAttributedStringKey.font:UIFont.latoStyleAndSize(style: .bold, size: .regular)])
            myMutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.latoStyleAndSize(style: .regular, size: .regular), range: NSRange(location:0,length:2))
            
            toLabel.attributedText = myMutableString
        }
        
        let maxNum: Int = 4
        
        let ccArray = emailThread?.messages_cc?.allObjects as? Array<Messages_Cc>
        if ccArray?.count != nil {
            
            self.ccInt = (ccArray?.count)!
            if self.ccInt > maxNum {
                self.addMoreButton()
            }
            
            var nameArray: [String] = []
            for ccData in ccArray! {
                let ccObject:Messages_Cc = ccData
                if let email = ccObject.email {
                    nameArray.append(email)
                } else  if let name = ccObject.name {
                    nameArray.append(name)
                    print(nameArray)
                }
            }
            
            let nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: ", ")
            if nameConcatenatedString.count > 0 {
                let ccString = "CC: " + nameConcatenatedString
                self.ccString = ccString
                ccLabel.text = ccString
            }
        }
        
        scrollView.addSubview(bccLabel)
        bccLabel.translatesAutoresizingMaskIntoConstraints = false
        bccLabel.snp.remakeConstraints { (make) in
            if let ccString = ccLabel.text {
                if ccString.count > 0 {
                    make.top.equalTo(ccLabel.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(toLabel.snp.bottom).offset(10)
                }
            } else {
                make.top.equalTo(toLabel.snp.bottom).offset(10)
            }
            make.leading.equalTo(scrollView.snp.leading).offset(20)
            make.width.equalTo(310)
        }
        bccLabel.numberOfLines = 0
        bccLabel.font = FullEmailViewController.bccLabelFont
        bccLabel.textColor = #colorLiteral(red: 0.6509803922, green: 0.6509803922, blue: 0.6509803922, alpha: 1)
        bccLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        let bccArray = emailThread?.messages_bcc?.allObjects as? Array<Messages_Bcc>
        if bccArray?.count != nil {
            var nameArray: [String] = []
            for bccData in bccArray! {
                let bccObject:Messages_Bcc = bccData
                if let email = bccObject.email {
                    nameArray.append(email)
                } else  if let name = bccObject.name {
                    nameArray.append(name)
                }
            }
            let nameConcatenatedString = nameArray.compactMap({$0}).joined(separator: ", ")
            if nameConcatenatedString.count > 0 {
                let bccString = "bcc: " + nameConcatenatedString
                bccLabel.text = bccString
            }
        }
        
        scrollView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(scrollView.snp.leading).offset(20)
            if let bccString = bccLabel.text {
                if bccString.count > 0 {
                    make.top.equalTo(bccLabel.snp.bottom).offset(10)
                } else if let ccString = ccLabel.text {
                    if ccString.count > 0 {
                        make.top.equalTo(ccLabel.snp.bottom).offset(10)
                    } else {
                        make.top.equalTo(toLabel.snp.bottom).offset(10)
                    }
                } else {
                    make.top.equalTo(toLabel.snp.bottom).offset(10)
                }
            } else if let ccString = ccLabel.text {
                if ccString.count > 0 {
                    make.top.equalTo(ccLabel.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(toLabel.snp.bottom).offset(10)
                }
            } else {
                make.top.equalTo(toLabel.snp.bottom).offset(10)
            }
            make.width.equalTo(310)
        }
        dateLabel.numberOfLines = 0
        dateLabel.font = FullEmailViewController.dateLabelFont
        dateLabel.textColor = #colorLiteral(red: 0.6509803922, green: 0.6509803922, blue: 0.6509803922, alpha: 1)
        dateLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        dateLabel.textAlignment = .left
        
        if let dateInt = emailThread?.date {
            print(dateInt)
            dateLabel.text = self.relativePast(for: dateInt)
        }
        
       loadWebView()
    }
    
    func loadWebView() {
        
        scrollView.addSubview(webView)
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.snp.remakeConstraints { (make) in
            make.leading.equalTo(scrollView.snp.leading).offset(12)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.width.equalTo(0.85 * self.view.frame.size.width)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        webView.delegate = delegate
        webView.backgroundColor = .clear
        webView.isOpaque = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnWebView(gesture:)))
        tapGesture.delegate = self
        webView.addGestureRecognizer(tapGesture)
        let html = emailThread?.body
        if !((html?.isEmpty)!) {
            self.webView.loadHTMLString(html!, baseURL: nil)
        } else {
            self.webView.loadHTMLString("<p> <p>", baseURL: nil)
        }
    }
    
    func relativePast(for dateInt : Int32) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date, to: Date())
        
        if (components.day! > 1) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "EEEE, MMM d yyyy h:mm a"
            let localDate = dateFormatter.string(from: date as Date)
            return localDate
        } else if components.day! == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.string(from: date as Date)
            let labelDate = "Yesterday at " + localDate
            return labelDate
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.string(from: date as Date)
            let labelDate = "Today at " + localDate
            return labelDate
        }
    }
    
    @objc private func tapOnWebView(gesture: UIGestureRecognizer) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.updateWebViewFrame()
        }
    }
    
    private func updateWebViewFrame() {
        webView.layoutSubviews()
        // Set to smallest rect value
        var frame:CGRect = webView.frame
        frame.size.height = 1.0
        webView.frame = frame
        webView.frame.size.height = webView.scrollView.contentSize.height
        var totalHeight = webView.frame.origin.y + webView.frame.height
        if isExpandTapped {
            totalHeight = view.bounds.height
        }
        scrollView.contentSize.height = totalHeight + 50
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: totalHeight)
        webView.snp.remakeConstraints { (make) in
            make.leading.equalTo(scrollView.snp.leading).offset(12)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.width.equalTo(0.85 * self.view.frame.size.width)
            make.height.equalTo(webView.scrollView.contentSize.height)
        }
        webView.window?.setNeedsUpdateConstraints()
        webView.window?.setNeedsLayout()
        isExpandTapped = !isExpandTapped
    }
}

extension FullEmailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

