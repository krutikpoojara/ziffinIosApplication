//
//  FeedbackViewController.swift
//  SidebarMenu
//
//  Created by Developer on 15/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import JLToast
import SwiftValidator

class FeedbackViewController: UIViewController,ValidationDelegate {

    @IBOutlet var lblName: UITextField!
    @IBOutlet var lblEmail: UITextField!
    @IBOutlet var lblSubject: UITextField!
    @IBOutlet var txtComment: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    var loadingNotification : MBProgressHUD!
    var validator : Validator!
    var check : NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        check = ""
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
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

    func ButtonCornor()
    {
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.borderWidth = 2
        btnSubmit.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 2
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        
        lblName.layer.cornerRadius = 5
        lblName.layer.borderWidth = 2
        lblName.layer.borderColor = UIColor.whiteColor().CGColor
        
        lblEmail.layer.cornerRadius = 5
        lblEmail.layer.borderWidth = 2
        lblEmail.layer.borderColor = UIColor.whiteColor().CGColor
        
        lblSubject.layer.cornerRadius = 5
        lblSubject.layer.borderWidth = 2
        lblSubject.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtComment.layer.cornerRadius = 5
        txtComment.layer.borderWidth = 2
        txtComment.layer.borderColor = UIColor.whiteColor().CGColor


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            
            Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/feedback.php", parameters: ["name":self.lblName.text!,"email":self.lblEmail.text!,"subject":self.lblSubject.text!,"comment":self.txtComment.text!])
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
                        let message = JSON["tbl_feedback"] as! NSMutableArray
                        let status = message.objectAtIndex(0) as! NSDictionary
                        self.check = status.valueForKey("status") as! NSString
                        
                        if self.check == "0"
                        {
                            print("Old Password Wrong")
                        }
                        else
                        {
                            self.loadingNotification.hide(true)
                            JLToast.makeText("Feedback Submited").show()
                            self.txtComment.text = ""
                            self.lblName.text = ""
                            self.lblEmail.text = ""
                            self.lblSubject.text = ""
                        }
                        
                    }
            }
        }

    }
    
    @IBAction func btnFeedbackActionDown(sender: AnyObject) {
        btnSubmit.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }
    func validationFailed(errors: [UITextField : ValidationError]) {
        
    }
    @IBAction func btnFeedbackAction(sender: AnyObject) {
         btnSubmit.backgroundColor = UIColor.redColor()
         validator.validate(self)
    }
    func validation()
    {
        validator.registerField(lblEmail, errorLabel: l2, rules: [RequiredRule(),EmailRule(message: "Invalid Email Format")])
        validator.registerField(txtComment, errorLabel: l4, rules: [RequiredRule()])
        validator.registerField(lblName, errorLabel: l1, rules: [RequiredRule()])
        validator.registerField(lblSubject, errorLabel: l3, rules: [RequiredRule()])
    }
    @IBAction func btnDismissActionDown(sender: AnyObject) {
        btnCancel.backgroundColor = UIColor.redColor()
    }
    @IBAction func btnDismissAction(sender: AnyObject) {
         btnCancel.backgroundColor = appDelegate.colorWithHexString("FF7F00")
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("home") as! HomeViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

}
