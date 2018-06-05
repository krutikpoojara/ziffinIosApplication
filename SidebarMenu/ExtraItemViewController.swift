//
//  ExtraItemViewController.swift
//  SidebarMenu
//
//  Created by Developer on 18/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import JLToast
import Alamofire

class ExtraItemViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,CustomIOS7AlertViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var loadingNotification : MBProgressHUD!
    var priceArr = [Int]()
    var pro_idArr = [Int]()
    var nameArr = [String]()
    var tableView1: UITableView!
    var tableView2,tableView3: UITableView!
    var flag = 0
    var total = 0
    var typess: String!
    var type: String!
    var totalSum = 0
    var flagCheck : Int!
    var check : NSString!
    var button: UIButton!
    var button1: UIButton!
    var button2: UIButton!
    var lblPrice: UILabel!
    var newArr = ["Today","Regular"]
    var TimeArr = ["Lunch","Dinner","Both"]
    var time: Int!
    var indexPaths : Int!
    var c_id : Int!
    var defaults : NSUserDefaults!
    var containerView: UIView!
    
    // The buttons that will appear in the alertView
    let buttons = [
        "Cancel",
        "OK"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = ""
        check = ""
        
        defaults = NSUserDefaults.standardUserDefaults()

        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Please Wait Loading"
        
        tableView1 = UITableView()
        tableView2 = UITableView()
        tableView3 = UITableView()
        view?.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        tableView?.hidden = true
        tableView?.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        tableView?.tableFooterView = UIView(frame: CGRectZero)
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        
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
    }

    func FetchData()
    {
        priceArr.removeAll()
        nameArr.removeAll()
        pro_idArr.removeAll()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_itemlist.php")!)!)
            let tbl_product = json["tbl_product"]
            
            print(tbl_product)
            for (index,_):(String, JSON) in tbl_product {

               let price = tbl_product[Int(index)!]["pro_price"].intValue
               self.priceArr.append(price)
                
               let name = tbl_product[Int(index)!]["pro_name"].stringValue
               self.nameArr.append(name)
                
               let pro_id = tbl_product[Int(index)!]["pro_id"].intValue
                self.pro_idArr.append(pro_id)

 
            }
            
            print(self.priceArr)
            print(json)
               dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.hidden = false
                self.tableView.reloadData()
                self.loadingNotification.hide(true)
                print("Finish")
     }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_tiffin_type.php")!)!)
                let tbl_tiffin = json["tbl_tiffin"]
                
                self.total = tbl_tiffin[1]["t_total"].intValue
                print(json)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    print("Finish")
                }
            }
  
            
    }
      
     
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customIOS7AlertViewButtonTouchUpInside(alertView: CustomIOS7AlertView, buttonIndex: Int) {
        print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        alertView.close()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == tableView1
        {
         return 1
        }
        else if tableView == tableView2
        {
            return 1
        }
        else if tableView == tableView3
        {
            return 1
        }
        else
        {
         return priceArr.count
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1
        {
         return newArr.count + 1
        }
        else if tableView == tableView2
        {
         return TimeArr.count + 1
        }
        else if tableView == tableView3
        {
            return 11
        }
        else
        {
         return 1
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if tableView == tableView1!
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
         cell.textLabel?.font = UIFont.boldSystemFontOfSize(13)
         cell.textLabel?.textAlignment = NSTextAlignment.Center
         cell.textLabel?.textColor = UIColor.whiteColor()
            
            if indexPath.row == 0
            {
                cell.textLabel!.text = "Select Extra Type"
            }
            else
            {
                cell.textLabel!.text = newArr[indexPath.row - 1]
            }

            
            
         cell.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
         cell.textLabel!.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
         cell.preservesSuperviewLayoutMargins = false
         cell.layoutMargins = UIEdgeInsetsZero
            return cell
        }
        else if tableView == tableView2!
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(13)
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.textLabel?.textColor = UIColor.whiteColor()
            
            if indexPath.row == 0
            {
                cell.textLabel!.text = "Select Extra Time"
            }
            else
            {
                cell.textLabel!.text = TimeArr[indexPath.row - 1]
            }

            cell.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
            cell.textLabel!.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        }
        else if tableView == tableView3!
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

            cell.textLabel?.font = UIFont.boldSystemFontOfSize(13)
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.textLabel?.textColor = UIColor.whiteColor()
            
            
            if indexPath.row == 0
            {
                cell.textLabel?.text = "Select Quantity"
            }
            else
            {
                cell.textLabel?.text = "\(indexPath.row)"
            }

            cell.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
            cell.textLabel!.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DetailTableViewCell
         cell.backgroundColor = UIColor.orangeColor()
         cell.layer.cornerRadius = 5
         cell.layer.borderWidth = 0
         cell.layer.borderColor = UIColor.whiteColor().CGColor
         cell.clipsToBounds = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.tag = indexPath.section
        cell.ExtraView.layer.cornerRadius = cell.ExtraView.frame.height / 2
        cell.ExtraView.layer.borderWidth = 2
        cell.ExtraView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.ExtraView.clipsToBounds = true
        
        cell.imgIcon.image = UIImage(named: "meal.png")
        cell.btnExtra.tag = indexPath.section

        cell.btnExtra.addTarget(self, action: "btnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnExtra.addTarget(self, action: "btnTappedDown:", forControlEvents: UIControlEvents.TouchDown)
        cell.lblDetail.text = nameArr[indexPath.section]
        cell.lblPrice.text = "Price : \(priceArr[indexPath.section])"
            
            return cell
        }
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == tableView1
        {
         return 30
        }
        else if tableView == tableView2
        {
            return 30
        }
        else if tableView == tableView3
        {
            return 30
        }
        else
        {
         return 60
        }
    }
    func btnTapped(sender : UIButton)
    {
      let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sender.tag)) as! DetailTableViewCell
      cell.ExtraView.backgroundColor = UIColor.redColor()
      indexPaths = cell.tag
        
        let alertView = CustomIOS7AlertView()
        
        // Set the button titles array
        alertView.buttonTitles = buttons
        
        // Set a custom container view
        alertView.containerView = createContainerView()
        
        // Set self as the delegate
        alertView.delegate = self
        
        // Or, use a closure
        alertView.onButtonTouchUpInside = { (alertView: CustomIOS7AlertView, buttonIndex: Int) -> Void in
            print("CLOSURE: Button '\(self.buttons[buttonIndex])' touched")

            if buttonIndex == 1
            {

                if self.button?.titleLabel?.text! == "Select Extra type"
                {
                    JLToast.makeText("Select Extra type").show()
                }
                else if self.button1?.titleLabel?.text == "Select Extra time"
                {
                    JLToast.makeText("Select Extra time").show()
                }
                else if self.button2.titleLabel?.text == "Select Quantity"
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
                self.loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.loadingNotification.mode = MBProgressHUDMode.Indeterminate
                let id = self.defaults.integerForKey("u_id")
                let timess = self.button1?.titleLabel?.text
                
                 self.type = self.button?.titleLabel?.text
                
                let quantity = self.button2.titleLabel?.text
                print(id)
                if self.flagCheck == 0
                {
                    Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/add_extra_ordercart.php?c_id=\(self.c_id)", parameters: ["user_id":id,"meal_time":timess!,"meal_type":self.type!,"t_day":1,"pro_id":self.pro_idArr[self.indexPaths],"pro_price":self.priceArr[self.indexPaths],"quantity":quantity!,"total":self.totalSum])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            
                            let message = JSON["extra_cart"] as! NSMutableArray
                            let status = message.objectAtIndex(0) as! NSDictionary
                            self.check = status.valueForKey("status") as! NSString
                            
                            if self.check == "1"
                            {
                                self.loadingNotification.hide(true)
                                JLToast.makeText("order success full").show()
                            }
                        }
                        }
                 }
                 else if self.flagCheck == 1
                 {
                    print(self.c_id)
                    print(self.typess)
                    Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/add_order_cart.php?o_id=\(self.c_id)", parameters: ["user_id":id,"meal_time":timess!,"meal_type":self.typess!,"t_day":1,"pro_id":self.pro_idArr[self.indexPaths],"pro_price":self.priceArr[self.indexPaths],"quantity":quantity!,"total":self.totalSum])
                        .responseJSON { response in
                            print(response.request)  // original URL request
                            print(response.response) // URL response
                            print(response.data)     // server data
                            print(response.result)   // result of response serialization
                            
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                
                                let message = JSON["extra_cart"] as! NSMutableArray
                                let status = message.objectAtIndex(0) as! NSDictionary
                                self.check = status.valueForKey("status") as! NSString
                                
                                if self.check == "1"
                                {
                                    self.loadingNotification.hide(true)
                                    JLToast.makeText("order success full").show()
                                }
                            }
                    }
                 }
                 else
                 {
                    print(self.c_id)
                    Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/add_todayorder_cart.php?d_id=\(self.c_id)", parameters: ["user_id":id,"t_day":1,"pro_id":self.pro_idArr[self.indexPaths],"pro_price":self.priceArr[self.indexPaths],"quantity":quantity!,"total":self.totalSum])
                        .responseJSON { response in
                            print(response.request)  // original URL request
                            print(response.response) // URL response
                            print(response.data)     // server data
                            print(response.result)   // result of response serialization
                            
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                
                                let message = JSON["extra_cart"] as! NSMutableArray
                                let status = message.objectAtIndex(0) as! NSDictionary
                                self.check = status.valueForKey("status") as! NSString
                                
                                if self.check == "1"
                                {
                                    self.loadingNotification.hide(true)
                                    JLToast.makeText("order success full").show()
                                }
                            }
                    }
                 }
                    
                        

            }
            }
        }
        
        // Show time!
        
    }
        alertView.show()
    }
    func createContainerView() -> UIView {
        
        if flagCheck == 0
        {
            containerView = UIView(frame: CGRectMake(0, 0, 290, 160))
            
            print(containerView.frame.width)
            button  = UIButton(type: UIButtonType.System) as UIButton
            button.frame = CGRectMake(50, 10, containerView.frame.width - 100, 30)
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.whiteColor().CGColor
            
            button.backgroundColor = UIColor.orangeColor()
            button.setTitle("Select Extra type", forState: UIControlState.Normal)
            button.tintColor = UIColor.whiteColor()
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
            button.addTarget(self, action: "btnExtraTypeAction:", forControlEvents: UIControlEvents.TouchUpInside)
            containerView.addSubview(button)
            
            button1  = UIButton(type: UIButtonType.System) as UIButton
            button1.frame = CGRectMake(50, 50, containerView.frame.width - 100, 30)
            button1.layer.cornerRadius = 5
            button1.layer.borderWidth = 2
            button1.layer.borderColor = UIColor.whiteColor().CGColor
            
            button1.backgroundColor = UIColor.orangeColor()
            button1.setTitle("Select Extra time", forState: UIControlState.Normal)
            button1.tintColor = UIColor.whiteColor()
            button1.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
            button1.addTarget(self, action: "btnExtraTimeAction:", forControlEvents: UIControlEvents.TouchUpInside)
            containerView.addSubview(button1)
            
            
            button2  = UIButton(type: UIButtonType.System) as UIButton
            button2.frame = CGRectMake(50, 90, containerView.frame.width - 100, 30)
            button2.layer.cornerRadius = 5
            button2.layer.borderWidth = 2
            button2.layer.borderColor = UIColor.whiteColor().CGColor
            
            button2.backgroundColor = UIColor.orangeColor()
            button2.setTitle("Select Quantity", forState: UIControlState.Normal)
            button2.tintColor = UIColor.whiteColor()
            button2.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
            
            button2.addTarget(self, action: "btnQuantityAction:", forControlEvents: UIControlEvents.TouchUpInside)
            containerView.addSubview(button2)
            
            tableView1.frame         =   CGRectMake(50, 40, containerView.frame.width - 100, 95);
            tableView1.delegate      =   self
            tableView1.dataSource    =   self
            tableView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView1.scrollEnabled = false
            tableView1.separatorInset = UIEdgeInsetsZero
            tableView1.backgroundColor  = appDelegate.colorWithHexString("#FFCC00")
            tableView1.hidden = true
            containerView.addSubview(tableView1)
            
            tableView2.frame = CGRectMake(50, 80, containerView.frame.width - 100, 80);
            tableView2.delegate      =   self
            tableView2.dataSource    =   self
            tableView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            //        tableView2.scrollEnabled = false
            tableView2.separatorInset = UIEdgeInsetsZero
            tableView2.backgroundColor  = appDelegate.colorWithHexString("#FFCC00")
            tableView2.hidden = true
            containerView.addSubview(tableView2)
            
            tableView3.frame = CGRectMake(50, -0, containerView.frame.width - 100, 90);
            tableView3.delegate      =   self
            tableView3.dataSource    =   self
            tableView3.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            //        tableView3.scrollEnabled = false
            tableView3.separatorInset = UIEdgeInsetsZero
            tableView3.backgroundColor  = appDelegate.colorWithHexString("#FFCC00")
            tableView3.hidden = true
            containerView.addSubview(tableView3)
            
            
            lblPrice = UILabel(frame: CGRectMake(0, 135, containerView.frame.width, 20))
            lblPrice.font = UIFont.boldSystemFontOfSize(15)
            lblPrice.textColor = UIColor.whiteColor()
            lblPrice.text = "ddsf"
            lblPrice.textAlignment = NSTextAlignment.Center
            containerView.addSubview(lblPrice)
            lblPrice.hidden = true
            
            containerView.backgroundColor = UIColor(patternImage: UIImage(named: "smallbg.png")!)
        }
        else if flagCheck == 1
        {
            containerView = UIView(frame: CGRectMake(0, 0, 290, 130))
            
            print(containerView.frame.width)
            
            button1  = UIButton(type: UIButtonType.System) as UIButton
            button1.frame = CGRectMake(50, 10, containerView.frame.width - 100, 30)
            button1.layer.cornerRadius = 5
            button1.layer.borderWidth = 2
            button1.layer.borderColor = UIColor.whiteColor().CGColor
            
            button1.backgroundColor = UIColor.orangeColor()
            button1.setTitle("Select Extra time", forState: UIControlState.Normal)
            button1.tintColor = UIColor.whiteColor()
            button1.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
            button1.addTarget(self, action: "btnExtraTimeAction:", forControlEvents: UIControlEvents.TouchUpInside)
            containerView.addSubview(button1)
            
            
            button2  = UIButton(type: UIButtonType.System) as UIButton
            button2.frame = CGRectMake(50, 50, containerView.frame.width - 100, 30)
            button2.layer.cornerRadius = 5
            button2.layer.borderWidth = 2
            button2.layer.borderColor = UIColor.whiteColor().CGColor
            
            button2.backgroundColor = UIColor.orangeColor()
            button2.setTitle("Select Quantity", forState: UIControlState.Normal)
            button2.tintColor = UIColor.whiteColor()
            button2.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
            
            button2.addTarget(self, action: "btnQuantityAction:", forControlEvents: UIControlEvents.TouchUpInside)
            containerView.addSubview(button2)
            
            tableView2.frame = CGRectMake(50, 40, containerView.frame.width - 100, 95);
            tableView2.delegate      =   self
            tableView2.dataSource    =   self
            tableView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            //        tableView2.scrollEnabled = false
            tableView2.separatorInset = UIEdgeInsetsZero
            tableView2.backgroundColor  = appDelegate.colorWithHexString("#FFCC00")
            tableView2.hidden = true
            containerView.addSubview(tableView2)
            
            tableView3.frame = CGRectMake(50, -0, containerView.frame.width - 100, 90);
            tableView3.delegate      =   self
            tableView3.dataSource    =   self
            tableView3.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            //        tableView3.scrollEnabled = false
            tableView3.separatorInset = UIEdgeInsetsZero
            tableView3.backgroundColor  = appDelegate.colorWithHexString("#FFCC00")
            tableView3.hidden = true
            containerView.addSubview(tableView3)
            
            
            lblPrice = UILabel(frame: CGRectMake(0, 100, containerView.frame.width, 20))
            lblPrice.font = UIFont.boldSystemFontOfSize(15)
            lblPrice.textColor = UIColor.whiteColor()
            lblPrice.text = "ddsf"
            lblPrice.textAlignment = NSTextAlignment.Center
            containerView.addSubview(lblPrice)
            lblPrice.hidden = true
            
            containerView.backgroundColor = UIColor(patternImage: UIImage(named: "smallbg.png")!)
        }
        else
        {
            containerView = UIView(frame: CGRectMake(0, 0, 290, 100))
            
            button2  = UIButton(type: UIButtonType.System) as UIButton
            button2.frame = CGRectMake(50, 10, containerView.frame.width - 100, 30)
            button2.layer.cornerRadius = 5
            button2.layer.borderWidth = 2
            button2.layer.borderColor = UIColor.whiteColor().CGColor
            
            button2.backgroundColor = UIColor.orangeColor()
            button2.setTitle("Select Quantity", forState: UIControlState.Normal)
            button2.tintColor = UIColor.whiteColor()
            button2.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
            
            button2.addTarget(self, action: "btnQuantityAction:", forControlEvents: UIControlEvents.TouchUpInside)
            containerView.addSubview(button2)
            
            tableView3.frame = CGRectMake(50, 40, containerView.frame.width - 100, 60);
            tableView3.delegate      =   self
            tableView3.dataSource    =   self
            tableView3.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            //        tableView3.scrollEnabled = false
            tableView3.separatorInset = UIEdgeInsetsZero
            tableView3.backgroundColor  = appDelegate.colorWithHexString("#FFCC00")
            tableView3.hidden = true
            containerView.addSubview(tableView3)
            
            
            lblPrice = UILabel(frame: CGRectMake(0, 60, containerView.frame.width, 20))
            lblPrice.font = UIFont.boldSystemFontOfSize(15)
            lblPrice.textColor = UIColor.whiteColor()
            lblPrice.text = "ddsf"
            lblPrice.textAlignment = NSTextAlignment.Center
            containerView.addSubview(lblPrice)
            lblPrice.hidden = true
            
            containerView.backgroundColor = UIColor(patternImage: UIImage(named: "smallbg.png")!)
        }
        
        return containerView
    }

      func btnTappedDown(sender : UIButton)
    {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sender.tag)) as! DetailTableViewCell
        cell.ExtraView.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
        print("Click \(sender.tag)")
        
    }
    
    
    func fetchTime()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_time.php")!)!)
            let tbl_time = json["tbl_time"]
            
            self.time = tbl_time[0]["time"].intValue
            //self.time_type = tbl_time[0]["time_type"].stringValue
            
            print(self.time)
           // print(self.time_type)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                //self.table1.hidden = false
                // self.table1.reloadData()
                self.loadingNotification.hide(true)
                print("Finish")
            }
        }
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == tableView1
        {
            if indexPath.row == 0
            {
                button.setTitle("Select Extra Type", forState: UIControlState.Normal)
            }
            else
            {
                button.setTitle(newArr[indexPath.row - 1], forState: UIControlState.Normal)
            }
            tableView1.hidden = true
            flag = 0
            
        }
        else if tableView == tableView2
        {
            if indexPath.row == 0
            {
                button1.setTitle("Select Extra Time", forState: UIControlState.Normal)
            }
            else
            {
                button1.setTitle(TimeArr[indexPath.row - 1], forState: UIControlState.Normal)
            }
            
            if button?.titleLabel?.text == "Today"
            {
                print(time)
                if (time >= 11) && TimeArr[indexPath.row - 1] == "Lunch"
                {
                    JLToast.makeText("Lunch out of stock").show()
                    button1.setTitle("Select Extra Time", forState: UIControlState.Normal)
                }
                else if (time >= 20 && time <= 24) && TimeArr[indexPath.row - 1] == "Dinner"
                {
                    JLToast.makeText("Dinner out of stock").show()
                    button1.setTitle("Select Extra Time", forState: UIControlState.Normal)
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
                  
                    button1.setTitle("Select Extra Time", forState: UIControlState.Normal)
                }
            }
            
            tableView2.hidden = true
            flag = 0
            
        }
        else if tableView == tableView3
        {
            if indexPath.row == 0
            {
                button2.setTitle("Select Quantity", forState: UIControlState.Normal)
            }
            else
            {
                button2.setTitle("\(indexPath.row)", forState: UIControlState.Normal)
            }
            
    
            if (button?.titleLabel?.text == "Today" && button1.titleLabel?.text != "Select Extra Time") || (flagCheck == 1 || flagCheck == 2)
            {
                lblPrice.hidden = false
                let a = priceArr[indexPaths]
                //let ab = Int((btnQuantity.titleLabel?.text)!)
                totalSum = a * indexPath.row
                print("\(a * indexPath.row)")
                lblPrice.text = "Total Price : \(totalSum)"
            }
            else if button?.titleLabel?.text == "Regular" && button1.titleLabel?.text != "Select Extra Time"
            {
                lblPrice.hidden = false
                let a = priceArr[indexPaths]
                // let ab = Int((btnQuantity.titleLabel?.text)!)
                print(total)
                totalSum = a  * indexPath.row
                print("\(a * indexPath.row)")
                lblPrice.text = "Total Price : \(totalSum)"
            }

            tableView3.hidden = true
            flag = 0

        }


        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tableView
        {
         return 5
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 100))
        footerView.backgroundColor = UIColor.clearColor()
        
        return footerView
        
    }
    override func viewDidLayoutSubviews() {
    
         tableView.scrollEnabled = false
        
    }
    @IBAction func dismissVC(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
        @IBAction func btnExtraTypeAction(sender: AnyObject) {
            tableView2?.hidden = true
            tableView3?.hidden = true
    
            if flag == 0
            {
                tableView1.hidden = false
                flag = 1
            }
            else
            {
                tableView1.hidden = true
                flag = 0
            }
        }
    
        @IBAction func btnExtraTimeAction(sender: AnyObject) {
            tableView1.hidden = true
            tableView3?.hidden = true
      
            if flag == 0
            {
                tableView2.hidden = false
                flag = 1
            }
            else
            {
                tableView2.hidden = true
                flag = 0
            }
        }
    
       @IBAction func btnQuantityAction(sender: AnyObject) {
         tableView2?.hidden = true
         tableView1?.hidden = true
        
         if flag == 0
         {
            tableView3.hidden = false
            flag = 1
         }
         else
         {
            tableView3.hidden = true
            flag = 0
         }
      }



}
