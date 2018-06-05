//
//  ConfirmOrderViewController.swift
//  SidebarMenu
//
//  Created by Developer on 16/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import JLToast
import SwiftValidator

class ConfirmOrderViewController: UIViewController,UITableViewDataSource,UITextFieldDelegate,ValidationDelegate {

    @IBOutlet weak var l7: UILabel!
    @IBOutlet weak var l6: UILabel!
    @IBOutlet weak var l5: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var table1: UITableView!
    var check : NSString!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnOrderNow: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var location: String = ""
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtComfirmPassword: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    var meal_time : String!
    var meal_type : String!
    var quantity : Int!
    var tiffin_price : Int!
    var total_tiffin : Int!
    var totals : Int!
    var t_day : Int!
     var temp : Int!
    var loadingNotification : MBProgressHUD!
    var locArr = [String]()
    var flag = 0
    var defaults : NSUserDefaults!
    var validator : Validator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validator = Validator()
        defaults = NSUserDefaults.standardUserDefaults()
        check = ""
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Please Wait Loading"

        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        table1.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        table1.tableFooterView = UIView(frame: CGRectZero)
        table1.hidden = true
        table1.separatorInset = UIEdgeInsetsZero
        table1.scrollEnabled = true

        ButtonCornor()
        txtDelegate()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "KeyboardAppear", name: UIKeyboardDidShowNotification, object: nil)
        let netReach = Reachability.reachabilityForInternetConnection()
        let networkstatus = netReach.currentReachabilityStatus()
        if networkstatus == NotReachable
        {
            exit(0)
        }
        else
        {
        FetchData()
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
          validation()
    }
    func validation()
    {
        validator.registerField(txtName, errorLabel: l1, rules: [RequiredRule(),FullNameRule(message: "Enter Full Name")])
        validator.registerField(txtEmail, errorLabel: l2, rules: [RequiredRule(),EmailRule(message: "Invalid Email Format")])
        validator.registerField(txtMobile, errorLabel: l4, rules: [RequiredRule(),MinLengthRule(length: 10, message: "Enter 10 Digit Mobile No"),MaxLengthRule(length: 10, message: "Enter Valid Number")])
        validator.registerField(txtPassword, errorLabel: l5, rules: [RequiredRule()])
        
        if btnLocation == ""
        {
         l7.text = "Field is required"
        }

        validator.registerField(txtComfirmPassword, errorLabel: l6, rules: [RequiredRule(),ConfirmationRule(confirmField: txtPassword, message: "Password Mismatch")])
        validator.registerField(txtAddress, errorLabel: l3, rules: [RequiredRule()])
        
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
            reg()
        }

    }
    func FetchData()
    {
        locArr.removeAll()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://www.shreehariconsultant.com/cooker_webservice/fatch_location.php")!)!)
            let tbl_location = json["tbl_location"]
            
            
            for (index,_):(String, JSON) in tbl_location {
                let name = tbl_location[Int(index)!]["loc_name"].stringValue
                self.locArr.append(name)

            }
            print(json)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                //self.table1.hidden = false
                self.table1.reloadData()
                self.loadingNotification.hide(true)
                print("Finish")
            }
        }
    }
    

    func KeyboardAppear()
    {
        table1.hidden = true
        flag = 0
    }
    
    func txtDelegate()
    {
     txtAddress.delegate = self
     txtName.delegate = self
     txtEmail.delegate = self
     txtMobile.delegate = self
     txtPassword.delegate = self
     txtComfirmPassword.delegate = self
    }
    func ButtonCornor()
    {
        txtEmail.layer.cornerRadius = 5
        txtEmail.layer.borderWidth = 2
        txtEmail.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtMobile.layer.cornerRadius = 5
        txtMobile.layer.borderWidth = 2
        txtMobile.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtName.layer.cornerRadius = 5
        txtName.layer.borderWidth = 2
        txtName.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtPassword.layer.cornerRadius = 5
        txtPassword.layer.borderWidth = 2
        txtPassword.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtComfirmPassword.layer.cornerRadius = 5
        txtComfirmPassword.layer.borderWidth = 2
        txtComfirmPassword.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtAddress.layer.cornerRadius = 5
        txtAddress.layer.borderWidth = 2
        txtAddress.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnLocation.layer.cornerRadius = 5
        btnLocation.layer.borderWidth = 2
        btnLocation.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnOrderNow.layer.cornerRadius = 5
        btnOrderNow.layer.borderWidth = 2
        btnOrderNow.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 2
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        
         btnLocation.setTitle("Your Location", forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func reg()
    {
        
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Updating...."
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://www.shreehariconsultant.com/cooker_webservice/fatch_location.php")!)!)
            let tbl_location = json["tbl_location"]
            
            print(tbl_location)
            for (index,_):(String, JSON) in tbl_location {
                let name = tbl_location[Int(index)!]["loc_name"].stringValue
                let id = tbl_location[Int(index)!]["loc_id"].intValue
                
                print(name)
                if self.location != ""
                {
                    if name == self.location
                    {
                        self.temp = id
                        print(self.temp)
                        print("Final Loction \(name)")
                        break
                    }
                }
            }
            print(json)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                //self.table1.hidden = false
                self.table1.reloadData()
    
                self.loadingNotification.hide(true)
                print("Finish 2")
                print(self.quantity)
                print(self.meal_type)
                print(self.totals)
                print(self.t_day)
                Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/user_registration.php", parameters: ["meal_time":self.meal_time,"meal_type":self.meal_type,"quantity":self.quantity,"tiffin_price":self.tiffin_price,"total_tiffin":self.total_tiffin,"total":self.totals,"t_day":self.t_day,"name":self.txtName.text!,"email":self.txtEmail.text!,"mobile":self.txtMobile.text!,"password":self.txtPassword.text!,"address":self.txtAddress.text!,"location":self.temp])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let value = response.result.value {
                            print("JSON: \(value)")
                            
                            let json = JSON(value)
                            print(json)
                            let message = value["registration"] as! NSMutableArray
                            let status = message.objectAtIndex(0) as! NSDictionary
                            self.check = status.valueForKey("status") as! NSString
                        }
    
                
                if self.check == "1"
                {
                    
                    self.defaults.setBool(true, forKey: "Login")
                    JLToast.makeText("Registered Successfully").show()
                
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                        let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_user_detail.php?email=\(self.txtEmail.text!)")!)!)
                        let tbl_user = json["tbl_user"]
                        print(tbl_user)
                        

                        let id = tbl_user[0]["u_id"].intValue
                        let email = tbl_user[0]["u_email"].stringValue
                        let name = tbl_user[0]["u_name"].stringValue
                        self.defaults.setObject(name, forKey: "name")

                        self.defaults.setInteger(id, forKey: "u_id")
                     
                        
                       // self.defaults.setInteger(self.id, forKey: "id")
                        self.defaults.setObject(email, forKey: "email")
    
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                          
                            let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("cart") as! CartViewController
                            
                            self.navigationController?.pushViewController(secondViewController, animated: true)

                      }
                    }
   
                }
                else
                {
                    JLToast.makeText("Email or Mobile Already Registered").show()
                    self.loadingNotification.hide(true)
                    self.txtEmail.text = ""
                    self.txtMobile.text = ""
                    self.txtPassword.text = ""
                    self.txtComfirmPassword.text = ""
                }
            }
        }
        
        }
      
    }
    
    @IBAction func btnOrderNowAction(sender: AnyObject) {
        btnOrderNow.backgroundColor = UIColor.redColor()
        validator.validate(self)
        
    }
    
    @IBAction func btnOrderNowActionDown(sender: AnyObject) {
        btnOrderNow.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }
    
    @IBAction func btnCancelActionDown(sender: AnyObject) {
        btnCancel.backgroundColor = UIColor.redColor()
    }
    
    @IBAction func btnCancelAction(sender: AnyObject) {
        btnCancel.backgroundColor = appDelegate.colorWithHexString("FF7F00")
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("order") as! OrderViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func btnLocationAction(sender: AnyObject) {
         sender.setTitle("Google", forState: UIControlState.Selected)
        if flag == 0
        {
            table1.hidden = false
            flag = 1
        }
        else
        {
            table1.hidden = true
            flag = 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locArr.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        cell.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
        cell.lblName.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
        cell.lblName.text = locArr[indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        location = locArr[indexPath.row]
        print(location)
        
        btnLocation.setTitle(locArr[indexPath.row], forState: UIControlState.Normal)
        table1.deselectRowAtIndexPath(indexPath, animated: true)
        table1.hidden = true
        flag = 0
    }
    
}
