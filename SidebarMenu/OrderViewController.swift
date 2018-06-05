//
//  OrderViewController.swift
//  SidebarMenu
//
//  Created by Developer on 16/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import JLToast
import Alamofire

extension NSDate
{
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
}
class OrderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var table3: UITableView!
    @IBOutlet weak var btnQuantity: UIButton!
    @IBOutlet weak var btnMealTime: UIButton!
    @IBOutlet weak var btnMealType: UIButton!
    @IBOutlet weak var table1: UITableView!
    var tiffin_price : Int!
    var total_tiffin : Int!
    var totals : Int!
    var t_day : Int!
    var quan: String?
    var flag = 0
    var total = 0
    var time: Int!
    var time_type: String!
    var defaults : NSUserDefaults!
    var totalSum = 0
    var check : NSString!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    var checks: Bool!
    @IBOutlet weak var table2: UITableView!
    
    var loadingNotification : MBProgressHUD!
    var locArr = [String]()
    var priceArr = [Int]()
    var TimeArr = ["Lunch","Dinner","Both"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        check = ""
        defaults = NSUserDefaults.standardUserDefaults()
         checks = defaults.boolForKey("Login")
        
        if checks == true
        {
         btnNext.setTitle("Order", forState: UIControlState.Normal)
        }
        lblPrice.hidden = true
        defaults = NSUserDefaults.standardUserDefaults()
        
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Please Wait Loading"
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        table1.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        table2.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        table3.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        ButtonCornor()

        table1.hidden = true
        table1.tableFooterView = UIView(frame: CGRectZero)
        table1.separatorInset = UIEdgeInsetsZero
        table1.scrollEnabled = false
        
        table2.hidden = true
        table2.tableFooterView = UIView(frame: CGRectZero)
        table2.separatorInset = UIEdgeInsetsZero
        table2.scrollEnabled = false
        
        table3.hidden = true
        table3.tableFooterView = UIView(frame: CGRectZero)
        table3.separatorInset = UIEdgeInsetsZero
        table3.scrollEnabled = true
        // Do any additional setup after loading the view.
        let netReach = Reachability.reachabilityForInternetConnection()
        let networkstatus = netReach.currentReachabilityStatus()
        if networkstatus == NotReachable
        {
            exit(0)
        }
        else
        {
        FetchData()
        fetchTime()
        }
        currentTime()
    }

    func FetchData()
    {
        locArr.removeAll()
        priceArr.removeAll()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_tiffin_type.php")!)!)
            let tbl_tiffin = json["tbl_tiffin"]
            
            self.total = tbl_tiffin[1]["t_total"].intValue
            for (index,_):(String, JSON) in tbl_tiffin {
                let name = tbl_tiffin[Int(index)!]["t_type"].stringValue
                let price = tbl_tiffin[Int(index)!]["t_price"].intValue
                
                self.locArr.append(name)
                self.priceArr.append(price)
                
                
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
    
    func fetchTime()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_time.php")!)!)
            let tbl_time = json["tbl_time"]
            
            self.time = tbl_time[0]["time"].intValue
            self.time_type = tbl_time[0]["time_type"].stringValue
            
            print(self.time)
            print(self.time_type)

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                //self.table1.hidden = false
               // self.table1.reloadData()
                self.loadingNotification.hide(true)
                print("Finish")
            }
        }

    }
    
    func currentTime()
    {
        let currentDate = NSDate()
        print(currentDate.hour())
    }
    func ButtonCornor()
    {
        btnQuantity.layer.cornerRadius = 5
        btnQuantity.layer.borderWidth = 2
        btnQuantity.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnMealTime.layer.cornerRadius = 5
        btnMealTime.layer.borderWidth = 2
        btnMealTime.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnMealType.layer.cornerRadius = 5
        btnMealType.layer.borderWidth = 2
        btnMealType.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnNext.layer.cornerRadius = 5
        btnNext.layer.borderWidth = 2
        btnNext.layer.borderColor = UIColor.whiteColor().CGColor
        btnQuantity.setTitle("Select Quantity", forState: UIControlState.Normal)
        btnMealTime.setTitle("Select Meal Time", forState: UIControlState.Normal)
    }
    @IBAction func btnMealTypeAction(sender: AnyObject) {
        table2?.hidden = true
        table3?.hidden = true
        
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
    
    @IBAction func btnMealTimeAction(sender: AnyObject) {
        table1?.hidden = true
        table3?.hidden = true
        
        if flag == 0
        {
            table2.hidden = false
            flag = 1
        }
        else
        {
            table2.hidden = true
            flag = 0
        }
    }
    
    
    @IBAction func btnQuantityAction(sender: AnyObject) {
        table1?.hidden = true
        table2?.hidden = true
        
        if flag == 0
        {
            table3.hidden = false
            flag = 1
        }
        else
        {
            table3.hidden = true
            flag = 0
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == table1
        {
          return locArr.count + 1
        }
        else if tableView == table2
        {
          return TimeArr.count + 1
        }
        else
        {
          return 11
        }
       
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        cell.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
        cell.lblName.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero

        if tableView == table1
        {
         if indexPath.row == 0
         {
            cell.lblName.text = "Select Meal Type"
         }
         else
         {
            cell.lblName.text = locArr[indexPath.row - 1]
         }
        }
        else if tableView == table2
        {
         if indexPath.row == 0
         {
           cell.lblName.text = "Select Meal Time"
         }
         else
         {
           cell.lblName.text = TimeArr[indexPath.row - 1]
         }
        }
        else if tableView == table3
        {
          if indexPath.row == 0
          {
            cell.lblName.text = "Select Quantity"
          }
          else
          {
            cell.lblName.text = "\(indexPath.row)"
          }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
     
        if tableView == table1
        {
            if indexPath.row == 0
            {
                btnMealType.setTitle("Select Meal Type", forState: UIControlState.Normal)
            }
            else
            {
                btnMealType.setTitle(locArr[indexPath.row - 1], forState: UIControlState.Normal)
            }
            table1.hidden = true
            flag = 0

        }
        else if tableView == table2
        {
   
            
             if indexPath.row == 0
             {
                btnMealTime.setTitle("Select Meal Time", forState: UIControlState.Normal)
             }
             else
             {
                btnMealTime.setTitle(TimeArr[indexPath.row - 1], forState: UIControlState.Normal)
             }
            
            if btnMealType.titleLabel?.text == "Daily" || btnMealType.titleLabel?.text == "King's Feast"
            {
                print(time)
                if (time >= 11) && TimeArr[indexPath.row - 1] == "Lunch"
                {
                    JLToast.makeText("Lunch out of stock").show()
                    btnMealTime.setTitle("Select Meal Time", forState: UIControlState.Normal)
                }
                else if (time >= 20 && time <= 24) && TimeArr[indexPath.row - 1] == "Dinner"
                {
                    JLToast.makeText("Dinner out of stock").show()
                    btnMealTime.setTitle("Select Meal Time", forState: UIControlState.Normal)
                }
                else if TimeArr[indexPath.row - 1] == "Both"
                {
                    if time >= 11 && (time >= 20 && time <= 24)
                    {
                        JLToast.makeText("Lunch out of stock").show()
                        JLToast.makeText("Dinner out of stock", duration: 3.0).show()
                    }
                    else if time >= 11
                    {
                        JLToast.makeText("Lunch out of stock").show()
                    }
                    else
                    {
                        JLToast.makeText("Dinner out of stock").show()
                    }
                    btnMealTime.setTitle("Select Meal Time", forState: UIControlState.Normal)
                }
            }

             table2.hidden = true
             flag = 0
        }
        else if tableView == table3
        {
            if indexPath.row == 0
            {
               btnQuantity.setTitle("Select Quantity", forState: UIControlState.Normal)
            }
            else
            {
               btnQuantity.setTitle("\(indexPath.row)", forState: UIControlState.Normal)
            }
            table3.hidden = true
            
            if btnMealType.titleLabel?.text == "Daily" && btnMealTime.titleLabel?.text != "Select Meal Time"
            {
              lblPrice.hidden = false
              let a = priceArr[0]
              //let ab = Int((btnQuantity.titleLabel?.text)!)
              totalSum = a * indexPath.row
                print("\(a * indexPath.row)")
               lblPrice.text = "Total Price : \(a * indexPath.row)"
            }
            else if btnMealType.titleLabel?.text == "Monthly ( Exec.)" && btnMealTime.titleLabel?.text != "Select Meal Time"
            {
                lblPrice.hidden = false
                let a = priceArr[1]
               // let ab = Int((btnQuantity.titleLabel?.text)!)
                print(total)
                totalSum = (a * total) * indexPath.row
                print("\((a * total) * indexPath.row)")
                lblPrice.text = "Total Price : \((a * total) * indexPath.row)"
            }
            else if btnMealType.titleLabel?.text == "King's Feast" && btnMealTime.titleLabel?.text != "Select Meal Time"
            {
                lblPrice.hidden = false
                let a = priceArr[2]
                print(total)
                totalSum = a * indexPath.row
                print("\(a * indexPath.row)")
                lblPrice.text = "Total Price : \(a * indexPath.row)"
            }
            
             quan = btnQuantity.titleLabel?.text
            flag = 0

        }
 
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        table1.deselectRowAtIndexPath(indexPath, animated: true)
//        table1.hidden = true
//
//        table2.deselectRowAtIndexPath(indexPath, animated: true)
//        table2.hidden = true
//
//        table3.deselectRowAtIndexPath(indexPath, animated: true)
//        table3.hidden = true
//        flag = 0
    }
    
    
    @IBAction func btnNextAction(sender: AnyObject) {
        
        btnNext.backgroundColor = UIColor.redColor()
        if btnMealType.titleLabel?.text == "Select Meal Type"
        {
          JLToast.makeText("Select Meal Type").show()
        }
        else if btnMealTime.titleLabel?.text == "Select Meal Time"
        {
          JLToast.makeText("Select Meal Time").show()
        }
        else if btnQuantity.titleLabel?.text == "Select Quantity"
        {
          JLToast.makeText("Select Quantity").show()
        }
        else
        {
            let netReach = Reachability.reachabilityForInternetConnection()
            let networkstatus = netReach.currentReachabilityStatus()
            if networkstatus == NotReachable
            {
                exit(0)
            }
            else
            {
            if checks == true
            {
                self.loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.loadingNotification.mode = MBProgressHUDMode.Indeterminate
                let id = self.defaults.integerForKey("u_id")
                let email : String = (self.defaults?.objectForKey("email"))!
                    as! String
                
                if btnMealType.titleLabel?.text == "Monthly ( Exec.)"
                {
                    t_day = total
                    total_tiffin = total
                    tiffin_price = priceArr[1]
                }
                else
                {
                    t_day = 1
                    total_tiffin = 1
                    
                    if btnMealType.titleLabel?.text == "Daily"
                    {
                        tiffin_price = priceArr[0]
                    }
                    else
                    {
                        tiffin_price = priceArr[2]
                    }
                }
                
                
                print(btnQuantity.titleLabel!.text!)
                Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/add_ordercart.php?user_id=\(id)", parameters: ["meal_time":"\(btnMealTime.titleLabel!.text!)","meal_type":"\(btnMealType.titleLabel!.text!)","quantity":"\(btnQuantity.titleLabel!.text!)","tiffin_price":self.tiffin_price,"total_tiffin":self.total_tiffin,"total":self.totalSum,"t_day":self.t_day])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            
                            let message = JSON["cart"] as! NSMutableArray
                            let status = message.objectAtIndex(0) as! NSDictionary
                            self.check = status.valueForKey("status") as! NSString
                            
                            if self.check == "1"
                            {
                                self.loadingNotification.hide(true)
                                JLToast.makeText("Order sucess full").show()
                                appDelegate.rootVC()
                            }
                        }
                }
                }
            else
            {
             let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("confirm_order") as! ConfirmOrderViewController
             secondViewController.meal_type = btnMealType.titleLabel?.text
             secondViewController.meal_time = btnMealTime.titleLabel?.text
             secondViewController.quantity = Int((btnQuantity.titleLabel?.text!)!)
             secondViewController.totals =  totalSum
             secondViewController.t_day = 1
             
                print(Int(lblPrice.text!))
             if btnMealType.titleLabel?.text == "Monthly ( Exec.)"
             {
              secondViewController.t_day = total
              secondViewController.total_tiffin = total
              secondViewController.tiffin_price = priceArr[1]
             }
             else
             {
              secondViewController.t_day = 1
              secondViewController.total_tiffin = 1
              
              if btnMealType.titleLabel?.text == "Daily"
              {
               secondViewController.tiffin_price = priceArr[0]
              }
              else
              {
               secondViewController.tiffin_price = priceArr[2]
              }
             }
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
        }
        }}
    
    @IBAction func btnNextActionDown(sender: AnyObject) {
        btnNext.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }

}
