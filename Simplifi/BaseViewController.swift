//
//  BaseViewController.swift
//  Simplifi
//
//  Created by Jared on 3/30/16.
//  Copyright © 2016 Jared. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var lowestItemHeight: CGFloat?
    
    var padding: CGFloat?
    
    var keyboard = false
    
    var currentlyRaised : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotificationListers()
        setTapGestureRecognizer()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setNotificationListers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func setTapGestureRecognizer() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.closeKeyboard))
        tapped.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapped)
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboard {
            keyboard = true
            if let height = lowestItemHeight {
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size {
                    if let pad = padding {
                        self.view.frame.origin.y -= (pad + (keyboardSize.height - height))
                        currentlyRaised = pad + (keyboardSize.height - height)
                    } else {
                        self.view.frame.origin.y -= (keyboardSize.height - height)
                        currentlyRaised = keyboardSize.height - height
                    }
                }
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboard {
            keyboard = false
            self.view.frame.origin.y += currentlyRaised
        }
    }
    
    func setupSimplifiButton(button: UIButton) {
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = SimplifiColor()
    }
    
    func displayActivityIndicator(msg:String, _ indicator:Bool ) {
        let bgView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.screenWidth(), height: UIScreen.screenHeight())))
        bgView.backgroundColor = UIColor.clearColor()
        let strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        let messageFrame = UIView(frame: CGRect(x: bgView.frame.midX - 90, y: bgView.frame.midY - 50, width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = SimplifiColor()
        bgView.tag = 100
        if indicator {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        bgView.addSubview(messageFrame)
        view.addSubview(bgView)
    }
    
    func removeActivityIndicator() {
        let activityView = self.view.viewWithTag(100)
        activityView?.removeFromSuperview()
    }
    
}

extension UIScreen {
    class func screenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    class func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
}

extension UITextField {
    class func setupHoshiTextField(textfield: HoshiTextField, placeholder: String?) {
        textfield.borderStyle = .None
        textfield.font = UIFont(name: "HelveticaNeue", size: 24)
        textfield.placeholderColor = UIColor.lightGrayColor()
        textfield.borderInactiveColor = UIColor.darkGrayColor()
        textfield.borderActiveColor = SimplifiColor()
        textfield.borderStyle = .None
        if let holder = placeholder {
            textfield.placeholder = holder
        }
    }
}
