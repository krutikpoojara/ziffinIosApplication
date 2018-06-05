//
//  ProfileViewController.swift
//  SidebarMenu
//
//  Created by Developer on 18/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import JLToast

class ProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    @IBOutlet weak var multipleView: UIView!

    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var v4: UIView!
    @IBOutlet weak var v5: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    var name: String!
    var mobile: Int!
    var id: Int!
    var locId: Int!
    var temp : Int!
    var address: String!
    var pass: String!
    var emails: String!
    var location: String = ""
    
    
    var defaults : NSUserDefaults!
    var locArr = [String]()
    var loadingNotification : MBProgressHUD!
    var flag = 0
    var loc: String = ""
    
    @IBOutlet weak var table1: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = NSUserDefaults.standardUserDefaults()
        btnUpdate.hidden = true
        btnLocation.enabled = false
        txtName.enabled = false
        txtMobile.enabled = false
        txtEmail.enabled = false
        txtArea.enabled = false
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Please Wait Loading"
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        table1.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        table1.hidden = true
        table1.tableFooterView = UIView(frame: CGRectZero)
        table1.separatorInset = UIEdgeInsetsZero
        table1.scrollEnabled = true
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let netReach = Reachability.reachabilityForInternetConnection()
        let networkstatus = netReach.currentReachabilityStatus()
        if networkstatus == NotReachable
        {
            exit(0)
        }
        else
        {
        fetchFirstData()
        }
        //FetchData()
        ButtonCornor()
        
        let height = self.view.frame.size.height
        print(height)
        
//        if height == 480
//        {
//         let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
//         scrollView.scrollEnabled = true
//         view.addSubview(scrollView)
//         scrollView.contentSize = CGSize(width:1234, height: 5678)
//   
//        }
        
    }

    @IBAction func btnLocationACtion(sender: AnyObject) {
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
    func fetchFirstData()
    {
        //locId = 0
        let email : String = (defaults?.objectForKey("email"))!
            as! String
        print(email)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_user_detail.php?email=\(email)")!)!)
            let tbl_user = json["tbl_user"]
            print(tbl_user)
            
            self.name = tbl_user[0]["u_name"].stringValue
            self.mobile = tbl_user[0]["u_mobile"].intValue
            self.id = tbl_user[0]["u_id"].intValue
            self.defaults.setInteger(self.id, forKey: "u_id")
            self.locId = tbl_user[0]["loc_id"].intValue
            self.emails = tbl_user[0]["u_email"].stringValue
            self.address = tbl_user[0]["u_address"].stringValue
            self.pass = tbl_user[0]["u_pass"].stringValue
            
            self.defaults.setInteger(self.id, forKey: "id")
            self.defaults.setObject(self.pass, forKey: "Password")
            print(self.locId)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.txtName.text = self.name
                self.txtMobile.text = "\(self.mobile)"
                self.txtEmail.text = self.emails
                self.txtArea.text = self.address
                print("Finish 1")
                self.FetchData()
            }
        }

    }
    func FetchData()
    {
        locArr.removeAll()
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://www.shreehariconsultant.com/cooker_webservice/fatch_location.php")!)!)
            let tbl_location = json["tbl_location"]
            
            print(tbl_location)
            for (index,_):(String, JSON) in tbl_location {
                let name = tbl_location[Int(index)!]["loc_name"].stringValue
                let id = tbl_location[Int(index)!]["loc_id"].intValue
                self.locArr.append(name)
            
                if id == self.locId
                {
                 if id > 48
                 {
                  self.loc = tbl_location[id - 10]["loc_name"].stringValue
                 }
                 else if id > 18
                 {
                  self.loc = tbl_location[id - 5]["loc_name"].stringValue
                 }
                 else
                 {
                  self.loc = tbl_location[id - 3]["loc_name"].stringValue
                 }
                 
                 print("Find \(id - 3)")
                }
                
            }
            print(json)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                //self.table1.hidden = false
                self.table1.reloadData()
                self.assignValue()
                self.loadingNotification.hide(true)
                print("Finish 2")
            }
        }
    }
    


    func assignValue()
    {
     if self.loc != ""
     {
      print(self.locId)
      self.btnLocation.titleLabel?.text = self.loc
      self.btnLocation?.setTitle(self.loc, forState: UIControlState.Normal)
     }
    }
    func ButtonCornor()
    {
        
        
        btnUpdate.layer.cornerRadius = 5
        btnUpdate.layer.borderWidth = 2
        btnUpdate.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnEdit.layer.cornerRadius = 5
        btnEdit.layer.borderWidth = 2
        btnEdit.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnChangePassword.layer.cornerRadius = 5
        btnChangePassword.layer.borderWidth = 2
        btnChangePassword.layer.borderColor = UIColor.whiteColor().CGColor
        
        multipleView.layer.cornerRadius = 5
        multipleView.layer.borderWidth = 0
        multipleView.layer.borderColor = UIColor.redColor().CGColor
        
        v1.layer.cornerRadius = 5
        v1.layer.borderWidth = 0
        v1.layer.borderColor = UIColor.redColor().CGColor
        v2.layer.cornerRadius = 5
        v2.layer.borderWidth = 0
        v2.layer.borderColor = UIColor.redColor().CGColor
        v3.layer.cornerRadius = 5
        v3.layer.borderWidth = 0
        v3.layer.borderColor = UIColor.redColor().CGColor
        v4.layer.cornerRadius = 5
        v4.layer.borderWidth = 0
        v4.layer.borderColor = UIColor.redColor().CGColor
        v5.layer.cornerRadius = 5
        v5.layer.borderWidth = 0
        v5.layer.borderColor = UIColor.redColor().CGColor


        
        btnBack.layer.cornerRadius = 5
        btnBack.layer.borderWidth = 2
        btnBack.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnUpdateActionDown(sender: AnyObject) {
        btnUpdate.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }
    @IBAction func btnUpdateAction(sender: AnyObject) {
         btnUpdate.backgroundColor = UIColor.redColor()
        let netReach = Reachability.reachabilityForInternetConnection()
        let networkstatus = netReach.currentReachabilityStatus()
        if networkstatus == NotReachable
        {
            exit(0)
        }
        else
        {
           
        btnEdit.enabled = true
        btnUpdate.hidden = true
        
        btnLocation.enabled = false
        txtName.enabled = false
        txtMobile.enabled = false
        txtEmail.enabled = false
        txtArea.enabled = false

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
                self.assignValue()
                self.loadingNotification.hide(true)
                print("Finish 2")
                
                Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/update_user_detail.php?u_id=\(self.id)", parameters: ["name":self.txtName.text!,"email":self.txtEmail.text!,"mobile":self.txtMobile.text!,"address":self.txtArea.text!,"location":self.temp])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                }
               JLToast.makeText("Updated Successfully").show()
               self.defaults.removeObjectForKey("Login")
               appDelegate.rootVC()
                
            }
        }
        }
    }
    
    @IBAction func btnEditActionDown(sender: AnyObject) {
        btnEdit.backgroundColor = UIColor.redColor()
    }

    @IBAction func btnEditAction(sender: AnyObject) {
        btnEdit.backgroundColor = appDelegate.colorWithHexString("FF7F00")
        btnUpdate.hidden = false
        btnEdit.enabled = false
        
        btnLocation.enabled = true
        txtName.enabled = true
        txtMobile.enabled = true
        txtEmail.enabled = true
        txtArea.enabled = true
     }
    @IBAction func btnBackActionDown(sender: AnyObject) {
        btnBack.backgroundColor = UIColor.redColor()
    }
    @IBAction func btnBackAction(sender: AnyObject) {
        btnBack.backgroundColor = appDelegate.colorWithHexString("FF7F00")
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("home") as! HomeViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @IBAction func btnChangePasswordAction(sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("change") as! ChangePasswordViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
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
