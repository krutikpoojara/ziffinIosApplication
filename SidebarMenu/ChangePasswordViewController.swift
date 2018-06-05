
//
//  ChangePasswordViewController.swift
//  SidebarMenu
//
//  Created by Developer on 18/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import JLToast
import SwiftyJSON
import SwiftValidator

class ChangePasswordViewController: UIViewController,ValidationDelegate {
    @IBOutlet weak var btnChage: UIButton!
    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l3: UILabel!
    
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtRePass: UITextField!
    var defaults : NSUserDefaults!
    var check : NSString!
    var validator : Validator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults = NSUserDefaults.standardUserDefaults()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        check = ""
        ButtonCornor()
        validator = Validator()
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            validationRule.textField.layer.borderColor = UIColor.whiteColor().CGColor
            validationRule.textField.layer.borderWidth = 2.0
            
            }, error:{ (validationError) -> Void in
                print("error")
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.textColor = UIColor.orangeColor()
                validationError.errorLabel?.text = validationError.errorMessage
                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                validationError.textField.layer.borderWidth = 2.0
        })
        ButtonCornor()
        validation()
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        
    }
    func validationSuccessful() {
        let netReach = Reachability.reachabilityForInternetConnection()
        let networkstatus = netReach.currentReachabilityStatus()
        if networkstatus == NotReachable
        {
            exit(0)
        }
        else
        {
            print(defaults.objectForKey("Password")!)
            let id = defaults.integerForKey("id")
            
            if txtNewPass.text == txtRePass.text
            {
                Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/changepassword.php?u_id=\(id)", parameters: ["oldpass":self.txtOldPass.text!,"newpass":self.txtNewPass.text!])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            let message = JSON["message"] as! NSMutableArray
                            let status = message.objectAtIndex(0) as! NSDictionary
                            self.check = status.valueForKey("status") as! NSString
                            print(self.check)
                            
                            if self.check == "0"
                            {
                                print("Old Password Wrong")
                            }
                            else
                            {
                                JLToast.makeText("Password Change Successfully").show()
                                self.defaults.removeObjectForKey("Login")
                                appDelegate.rootVC()
                            }
                        }
                }
                
            }
            else
            {
                print("Confirm Password not Match")
                self.txtNewPass.text = ""
                self.txtOldPass.text = ""
                self.txtRePass.text = ""
            }
        }

        
    }
    func validation()
    {
        validator.registerField(txtOldPass, errorLabel: l1, rules: [RequiredRule()])
        validator.registerField(txtNewPass, errorLabel: l2, rules: [RequiredRule()])
        validator.registerField(txtRePass, errorLabel: l3, rules: [RequiredRule(),ConfirmationRule(confirmField: txtNewPass, message: "Password Mismatch")])

    }

    @IBAction func btnCancelAction(sender: AnyObject) {
         btnCancel.backgroundColor = appDelegate.colorWithHexString("FF7F00")
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("profile") as! ProfileViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @IBAction func btnCancelActionDown(sender: AnyObject) {
        btnCancel.backgroundColor = UIColor.redColor()
    }

    @IBAction func btnChageActionDown(sender: AnyObject) {
        btnChage.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }
    @IBAction func btnChageAction(sender: AnyObject) {
        btnChage.backgroundColor = UIColor.redColor()
        validator.validate(self)
    }

    func ButtonCornor()
    {
        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 2
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnChage.layer.cornerRadius = 5
        btnChage.layer.borderWidth = 2
        btnChage.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtNewPass.layer.cornerRadius = 5
        txtNewPass.layer.borderWidth = 2
        txtNewPass.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtRePass.layer.cornerRadius = 5
        txtRePass.layer.borderWidth = 2
        txtRePass.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtOldPass.layer.cornerRadius = 5
        txtOldPass.layer.borderWidth = 2
        txtOldPass.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
