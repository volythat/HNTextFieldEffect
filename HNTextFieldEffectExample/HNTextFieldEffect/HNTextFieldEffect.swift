//
//  HNTextFieldEffect.swift
//  HNTextFieldEffectExample
//
//  Created by Harry Nguyen on 3/25/17.
//  Copyright © 2017 Harry Nguyen. All rights reserved.
//

import UIKit

class HNTextFieldEffect: UITextField {
    var effectPlaceHolder: UILabel!
    var lbValidator: UILabel!
    var originalTfFrame : CGRect!
    var lineBottomTextField : CALayer!
    
    
    struct effectLabelColor {
        static let active : UIColor = UIColor(red: 41/255, green: 182/255, blue: 246/255, alpha: 1)
        static let inActive : UIColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)
    }
    struct lineBottomColor {
        static let active : UIColor = UIColor(red: 41/255, green: 182/255, blue: 246/255, alpha: 1)
        static let inActive : UIColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        static let error : UIColor = UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1)
    }
    struct fontText {
        static let validator : UIFont = UIFont(name: "HelveticaNeue-Medium",size:8)!
        static let effectHolder : UIFont = UIFont(name: "HelveticaNeue-Medium",size:8)!
    }
    
    //MARK: - INIT
    
    //init from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpObserver()
    }
    
    
    //init from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpObserver()
    }
    override func draw(_ rect: CGRect) {
        self.setUpDefault()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - LAYOUT
    func setUpObserver(){
        //observers
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing(notification:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing(notification:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    func setUpDefault(){
        
        setUpEffectPlaceHolder()
        setUpValidatorLabel()
        setUpLineBottom()
        
        self.originalTfFrame = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsMake(5.0, 0.0, 2.0, 0.0))
        self.frame = self.originalTfFrame
        self.backgroundColor = UIColor.clear
    }
    
    func setUpEffectPlaceHolder(){
        if (self.hasText){
            self.effectPlaceHolder = UILabel(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y-5, width: self.frame.size.width, height: 10))
            self.effectPlaceHolder.alpha = 1
        }else{
            self.effectPlaceHolder = UILabel(frame: self.frame)
            self.effectPlaceHolder.alpha = 0
        }
        self.effectPlaceHolder.font = fontText.effectHolder
        self.effectPlaceHolder.textAlignment = self.textAlignment
        self.effectPlaceHolder.backgroundColor = UIColor.clear
        self.effectPlaceHolder.text = self.placeholder
        self.effectPlaceHolder.textColor = effectLabelColor.inActive
        self.superview?.addSubview(self.effectPlaceHolder)
        
    }
    func setUpValidatorLabel() {
        self.lbValidator = UILabel(frame: CGRect(x: self.frame.origin.x, y: self.frame.size.height + self.frame.origin.y, width: self.frame.size.width, height: 10))
        self.lbValidator.font = fontText.validator
        self.lbValidator.textAlignment = self.textAlignment
        self.lbValidator.backgroundColor = UIColor.clear
        self.lbValidator.alpha = 0
        self.lbValidator.textColor = lineBottomColor.error
        self.superview?.addSubview(self.lbValidator)
    }
    func setUpLineBottom(){
        if (self.lineBottomTextField == nil) {
            self.lineBottomTextField = CALayer()
            self.lineBottomTextField.borderColor = lineBottomColor.inActive.cgColor
            self.lineBottomTextField.frame = CGRect(x: 0, y: self.frame.size.height - 4, width: self.bounds.size.width, height: 1)
            self.lineBottomTextField.borderWidth = 1
            self.layer.addSublayer(self.lineBottomTextField)
            self.layer.masksToBounds = true
        }
        else {
            self.lineBottomTextField.removeFromSuperlayer()
            self.lineBottomTextField = nil
            self.setUpLineBottom()
        }
    }
    
    //MARK: - FUNCTIONS
    
    func showEffectPlaceHolderWithAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            self.effectPlaceHolder.alpha = 1.0
            self.effectPlaceHolder.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y-5, width: self.frame.size.width, height: 10)
        }) { (finish) in
            
        }
    }
    
    func hiddenEffectPlaceHolderWithAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            self.effectPlaceHolder.alpha = 0.0
            self.effectPlaceHolder.frame = self.frame
        }) { (finish) in
            
        }
    }
    
    
    func showValidatorWithString(validate:String){
        self.lbValidator.text = validate
        self.lbValidator.alpha = 1
        self.lineBottomTextField.borderColor = lineBottomColor.error.cgColor
        self.becomeFirstResponder()
    }
    
    func hiddenValidator(){
        self.lbValidator.text = ""
        self.lbValidator.alpha = 0
    }
    
    //MARK: - NOTIFICATIONS
    
    func textFieldDidBeginEditing(notification: NSNotification){
        let tf = notification.object as! UITextField
        if (tf == self){
            effectPlaceHolder.textColor = effectLabelColor.active
            lineBottomTextField.borderColor = lineBottomColor.active.cgColor
        }
    }
    func textFieldDidEndEditing(notification: NSNotification){
        let tf = notification.object as! UITextField
        if (tf == self){
            self.effectPlaceHolder.textColor = effectLabelColor.inActive
            self.lineBottomTextField.borderColor = lineBottomColor.inActive.cgColor
            //            self.hiddenValidator()
        }
    }
    func textFieldTextDidChange(notification: NSNotification){
        self.hiddenValidator()
        if (self.hasText){
            showEffectPlaceHolderWithAnimation()
        }else{
            hiddenEffectPlaceHolderWithAnimation()
        }
    }
    
    func screenRotate(){
//        setUpDefault()
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            print("Landscape")
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            print("Portrait")
        }
        
        if self.effectPlaceHolder != nil {
            self.effectPlaceHolder.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y-5, width: self.frame.size.width, height: 10)
        }
        if self.lbValidator != nil {
            self.lbValidator.frame = CGRect(x: self.frame.origin.x, y: self.frame.size.height + self.frame.origin.y, width: self.frame.size.width, height: 10)
        }
        if self.lineBottomTextField != nil {
            self.lineBottomTextField.frame = CGRect(x: 0, y: self.frame.size.height - 4, width: self.bounds.size.width, height: 1)
        }
    }
}
