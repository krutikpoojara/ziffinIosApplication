//
//  ForgotPasswordViewController.swift
//  SidebarMenu
//
//  Created by Developer on 15/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import JLToast
import SwiftValidator

class ForgotPasswordViewController: UIViewController,ValidationDelegate {

    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    var loadingNotification : MBProgressHUD!
    var validator : Validator!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
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
         validation()
        // Do any additional setup after loading the view.
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
            CheckLogin()
        }
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        
    }
    func validation()
    {
        validator.registerField(txtEmail, errorLabel: l1, rules: [RequiredRule(),EmailRule(message: "Invalid Email Format")])
        validator.registerField(txtMobile, errorLabel: l2, rules: [RequiredRule(),MinLengthRule(length: 10, message: "Enter 10 Digit Mobile No"),MaxLengthRule(length: 10, message: "Enter Valid Number")])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ButtonCornor()
    {
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.borderWidth = 2
        btnSubmit.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 2
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtMobile.layer.cornerRadius = 5
        txtMobile.layer.borderWidth = 2
        txtMobile.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtEmail.layer.cornerRadius = 5
        txtEmail.layer.borderWidth = 2
        txtEmail.layer.borderColor = UIColor.whiteColor().CGColor
    }
    

    @IBAction func btnCloseAction(sender: AnyObject) {
        btnCancel.backgroundColor = appDelegate.colorWithHexString("FF7F00")
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @IBAction func btnCloseActionDown(sender: AnyObject) {
        btnCancel.backgroundColor = UIColor.redColor()
    }
    @IBAction func btnSubmitAction(sender: AnyObject) {
        btnSubmit.backgroundColor = UIColor.redColor()
        validator.validate(self)
        if txtEmail.text == ""
        {
            print("Enter Email")
        }
        else if txtMobile.text == ""
        {
            print("Enter mobile")
        }
        else
        {
            
        }
    }
    
    func CheckLogin()
    {
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        
        let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/forgotpassword.php?email=\(txtEmail.text!)&mobile=\(txtMobile.text!)")!)!)
        if json.count > 0
        {
            appDelegate.rootVC()
        }
    }
    @IBAction func btnSubmitActionDown(sender: AnyObject) {
        btnSubmit.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
