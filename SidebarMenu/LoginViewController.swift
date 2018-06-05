//
//  LoginViewController.swift
//  SidebarMenu
//
//  Created by Developer on 15/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import JLToast
import SwiftValidator

class LoginViewController: UIViewController,ValidationDelegate {
    
    @IBOutlet var lblUser: UITextField!
    
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet var lblPassword: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    var defaults : NSUserDefaults!
    var loadingNotification : MBProgressHUD!
    var validator : Validator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        validator = Validator()
        defaults = NSUserDefaults.standardUserDefaults()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
//        btnCancel.backgroundColor = UIColor(rgba: "#FFCC00")
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
    
    func validation()
    {
     validator.registerField(lblUser, errorLabel: l1, rules: [RequiredRule()])
     validator.registerField(lblPassword, errorLabel: l2, rules: [RequiredRule()])
    }

    func ButtonCornor()
    {
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 2
        btnLogin.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 2
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        
        lblPassword.layer.cornerRadius = 5
        lblPassword.layer.borderWidth = 2
        lblPassword.layer.borderColor = UIColor.whiteColor().CGColor
        
        lblUser.layer.cornerRadius = 5
        lblUser.layer.borderWidth = 2
        lblUser.layer.borderColor = UIColor.whiteColor().CGColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCancelActionDown(sender: AnyObject) {
        btnCancel.backgroundColor = UIColor.redColor()
    }

    @IBAction func btnCancelAction(sender: AnyObject) {
         btnCancel.backgroundColor = appDelegate.colorWithHexString("FF7F00")
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("home") as! HomeViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
   
    @IBAction func btnForgotAction(sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("forgot") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func btnLoginActionDown(sender: AnyObject) {
        btnLogin.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }
    @IBAction func btnLoginAction(sender: AnyObject) {
        btnLogin.backgroundColor = UIColor.redColor()
        validator.validate(self)
        if lblUser.text == ""
        {
         print("Enter Username")
        }
        else if lblPassword.text == ""
        {
         print("Enter Password")
        }
        else
        {
           
        }
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
    func CheckLogin()
    {
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Logining"
        
        let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/user_login.php?email=\(lblUser.text!)&password=\(lblPassword.text!)")!)!)
        let tbl_user = json["tbl_user"]
        if json.count > 0
        {
          print("Login Scessfully")
         
          defaults.setBool(true, forKey: "Login")
            //print(tbl_user)
          
            
          let email = tbl_user[0]["u_email"].stringValue
          defaults.setObject(email, forKey: "email")
          
          let name = tbl_user[0]["u_name"].stringValue
          defaults.setObject(name, forKey: "name")
            
          let id = tbl_user[0]["u_id"].intValue
          defaults.setInteger(id, forKey: "u_id")

         JLToast.makeText("Login Successful").show()
          
           appDelegate.rootVC()
        }
        else
        {
          JLToast.makeText("Login Failed").show()
          loadingNotification.hide(true)
          lblUser.text = ""
          lblPassword.text = ""
          print("Login Failed")
        }
        
    }
}
