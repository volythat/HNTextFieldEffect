//
//  ViewController.swift
//  HNTextFieldEffectExample
//
//  Created by oneweek on 3/25/17.
//  Copyright © 2017 Harry Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfFirst: HNTextFieldEffect!
    @IBOutlet weak var tfLast: HNTextFieldEffect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func validate()->Bool {
        if self.tfFirst.text?.isEmpty == true {
            self.tfFirst.showValidatorWithString(validate: "First name is empty")
            return false
        }
        
        if self.tfLast.text?.isEmpty == true {
            self.tfLast.showValidatorWithString(validate: "Last name is empty")
            return false
        }
        
        return true
    }
    
    
    @IBAction func taoclickroi(_ sender: Any) {
        
        if validate() {
            print("success")
        }
        
    }
    
    
}

