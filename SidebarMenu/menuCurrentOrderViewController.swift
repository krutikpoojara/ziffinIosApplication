

//
//  menuCurrentOrderViewController.swift
//  SidebarMenu
//
//  Created by Developer on 02/01/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import JLToast
import Alamofire

class menuCurrentOrderViewController: UIViewController,UITableViewDataSource,CustomIOS7AlertViewDelegate {

    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnExtra: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    var t_day: Int!
    var c_id : Int!
    var ce_id: Int = 0
    var e_id: Int = 0
    var tiffin_price: Int!
    var tot_price: Int!
    var quantity: Int!
    var total_tiffin: Int!
    var meal_type: String!
    var meal_time: String!
    var uphar = 0
    
    var priceArr = [Int]()
    var e_idArr = [Int]()
    var nameArr = [String]()
    var cartCount = [String]()
    var totalpriceArr = [Int]()
    var quantityArr = [Int]()
    var totaltiffinArr = [Int]()
    var m_timeArr = [String]()
    var m_typeArr = [String]()
    var check : NSString!
    var sum = 0
    var ce_ids : Int = 0
    
    @IBOutlet weak var l1: UILabel!
    var loadingNotification : MBProgressHUD!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    var defaults : NSUserDefaults!
    var google = 0
    
    let buttons = [
        "Cancel",
        "OK"
    ]
    var i = 0
    
    @IBOutlet weak var pushView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        defaults = NSUserDefaults.standardUserDefaults()
        check = ""
        view?.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        tableView?.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        //tableView?.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        tableView?.backgroundColor = UIColor.clearColor()
        tableView?.tableFooterView = UIView(frame: CGRectZero)
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        
        ButtonCornor()
        lblDay.text = "Day : \(t_day)"
        lblDetails.text = "Meal Type : \(meal_type) | Meal Time : \(meal_time)"
        lblPrice.text = "Price : \(quantity) X \(tiffin_price)Rs."
        lblTotalPrice.text = "Total Price:\(tot_price)"
        l1.text = "Total Price:\(tot_price)"
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let netReach = Reachability.reachabilityForInternetConnection()
        let networkstatus = netReach.currentReachabilityStatus()
        if networkstatus == NotReachable
        {
            exit(0)
        }
        else
        {
            FetchData()
            fetchCart_counter()
        }
    }
    
    
    func fetchCart_counter()
    {
      cartCount.removeAll()
      print(c_id)
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
       let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_order_extra_cart.php?o_id=\(self.c_id)")!)!)
        print(json)
       

        let tbl_extra_order_cart = json["tbl_extra_order_cart"]
         self.ce_ids = tbl_extra_order_cart[0]["e_id"].intValue
   
           for (index,_):(String, JSON) in tbl_extra_order_cart {
         
            let t_day = tbl_extra_order_cart[Int(index)!]["pro_name"].stringValue
             self.cartCount.append(t_day)
            
            
    }
    print(self.cartCount.count)
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        if self.ce_ids == 0
        {
            self.lbl.text = "0"
        }
        else
        {
            self.lbl.text = "\(self.cartCount.count)"
            
        }
        self.loadingNotification.hide(true)
       }
     }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ButtonCornor()
    {
        subView.layer.cornerRadius = subView.frame.height / 2
        subView.layer.borderWidth = 2
        subView.layer.borderColor = UIColor.whiteColor().CGColor

        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 2
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        
        mainView.layer.cornerRadius = 5
        mainView.layer.borderWidth = 0
        mainView.layer.borderColor = UIColor.redColor().CGColor
        
        
        pushView.layer.cornerRadius = 10
        pushView.layer.borderWidth = 2
        pushView.layer.borderColor = UIColor.whiteColor().CGColor
        
        tempView.layer.cornerRadius = 5
        tempView.layer.borderWidth = 2
        tempView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func FetchData()
    {
        nameArr.removeAll()
        priceArr.removeAll()
        totalpriceArr.removeAll()
        totaltiffinArr.removeAll()
        quantityArr.removeAll()
        m_timeArr.removeAll()
        m_typeArr.removeAll()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_extra_order.php?o_id=\(self.c_id)")!)!)
            let tbl_extra_order = json["tbl_extra_order"]
            print(json)
            
            self.ce_id = tbl_extra_order[0]["e_id"].intValue
            for (index,_):(String, JSON) in tbl_extra_order {
                
                let t_day = tbl_extra_order[Int(index)!]["pro_name"].stringValue
                self.nameArr.append(t_day)
                
                let e_id = tbl_extra_order[Int(index)!]["e_id"].intValue
                self.e_idArr.append(e_id)

                
                let total_price = tbl_extra_order[Int(index)!]["price"].intValue
                self.priceArr.append(total_price)
                
                let pro_price = tbl_extra_order[Int(index)!]["pro_price"].intValue
                self.totalpriceArr.append(pro_price)
                
                let quantity = tbl_extra_order[Int(index)!]["quantity"].intValue
                self.quantityArr.append(quantity)
                
                let meal_type = tbl_extra_order[Int(index)!]["meal_type"].stringValue
                self.m_typeArr.append(meal_type)
                
                let meal_time = tbl_extra_order[Int(index)!]["meal_time"].stringValue
                self.m_timeArr.append(meal_time)
                
            }
            print(self.nameArr.count)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.hidden = false
                self.tableView.reloadData()
                self.loadingNotification.hide(true)
                self.sum = 0
                for self.i=0;self.i<self.priceArr.count;self.i++
                {
                    self.sum = self.sum + self.priceArr[self.i]
                }
                self.l1.text = "Total: \(self.tot_price + self.sum) Rs."
                print("Finish")
            }
        }
        
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if ce_id == 0
        {
            return 0
        }
        else
        {
            return nameArr.count
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DetailTableViewCell
        cell.backgroundColor = UIColor.orangeColor()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.clipsToBounds = true
        
        cell.ExtraView.layer.cornerRadius = cell.ExtraView.frame.height / 2
        cell.ExtraView.layer.borderWidth = 2
        cell.ExtraView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.ExtraView.clipsToBounds = true
        
        cell.lblDay.text = "\(nameArr[indexPath.section])"
        cell.lblDetail.text = "Meal Type : \(m_typeArr[indexPath.section]) | Meal Time : \(m_timeArr[indexPath.section])"
        cell.lblPrice.text = "Price : \(quantityArr[indexPath.section]) X \(totalpriceArr[indexPath.section])Rs."
        cell.lblTotalPrice.text = "Total Price:\(priceArr[indexPath.section])"
        
        cell.btnExtra.tag = indexPath.section
        cell.btnExtra.addTarget(self, action: "btnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnExtra.addTarget(self, action: "btnTappedDown:", forControlEvents: UIControlEvents.TouchDown)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.Blue
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 100))
        footerView.backgroundColor = UIColor.clearColor()
        
        return footerView
        
    }
    @IBAction func btnCartActionDown(sender: AnyObject) {
        subView.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
    }
    @IBAction func btnCartAction(sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("todayExtra") as! TodayExtraViewController
        secondViewController.o_id = c_id
        secondViewController.type = meal_type
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        subView.backgroundColor = UIColor.redColor()
    }
    
    func btnTapped(sender : UIButton)
    {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sender.tag)) as! DetailTableViewCell
        cell.ExtraView.backgroundColor = UIColor.redColor()

        print("Click \(sender.tag)")
        uphar = sender.tag
        google = 0
        alertConfirm()
    }
    func btnTappedDown(sender : UIButton)
    {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sender.tag)) as! DetailTableViewCell
        cell.ExtraView.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
        print("Click \(sender.tag)")
        
    }
    
    override func viewDidLayoutSubviews() {
        if nameArr.count > 2
        {
            tableView.scrollEnabled = true
        }
        else
        {
            tableView.scrollEnabled = false
        }
        
    }
    
    func alertConfirm()
    {
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
                let netReach = Reachability.reachabilityForInternetConnection()
                let networkstatus = netReach.currentReachabilityStatus()
                
                if networkstatus == NotReachable
                {
                    exit(0)
                }
                else
                {
                    print(self.e_idArr[self.uphar])
                    self.loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    self.loadingNotification.mode = MBProgressHUDMode.Indeterminate
                    
                    if self.google == 0
                    {
                    let id = self.defaults.integerForKey("u_id")
                    print(id)
                    Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/delete_conform_extraorder.php", parameters: ["c_id":self.e_idArr[self.uphar],"u_id":id])
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
                                
                                if self.check == "1"
                                {
                                    self.loadingNotification.hide(true)
                                    JLToast.makeText("Order Remove").show()
                                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("currentOrder") as! CurrentOrderViewController
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                    }
                }
                else
                {
                    let id = self.defaults.integerForKey("u_id")
                    print(id)
                    Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/delete_conform_tiffin.php", parameters: ["c_id":self.c_id,"u_id":id])
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
                                
                                if self.check == "1"
                                {
                                    self.loadingNotification.hide(true)
                                    JLToast.makeText("Order Remove").show()
                                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("currentOrder") as! CurrentOrderViewController
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                    }
                }
          }
        }
        }
        // Show time!
        alertView.show()
        
    }
    func createContainerView() -> UIView {
        let containerView = UIView(frame: CGRectMake(0, 0, 290, 200))
        
        let lblPrices = UILabel(frame: CGRectMake(0, 25, containerView.frame.size.width, 20))
        lblPrices.font = UIFont.boldSystemFontOfSize(20)
        lblPrices.textColor = UIColor.whiteColor()
        lblPrices.text = "Order Cancel"
        lblPrices.numberOfLines = 5
        lblPrices.textAlignment = NSTextAlignment.Center
        containerView.addSubview(lblPrices)
        
        let lblPrices1 = UILabel(frame: CGRectMake(0, 60, containerView.frame.size.width, 100))
        lblPrices1.font = UIFont.boldSystemFontOfSize(15)
        lblPrices1.textColor = UIColor.whiteColor()
        lblPrices1.text = "On Your Order Cancel You Will \n Get Credit Back in Your Ziffin \n Account and You can use \n Credit in Your Next Order."
        lblPrices1.numberOfLines = 5
        lblPrices1.textAlignment = NSTextAlignment.Center
        containerView.addSubview(lblPrices1)
        
        containerView.backgroundColor = UIColor(patternImage: UIImage(named: "smallbg.png")!)
        
        return containerView
    }
        
        func customIOS7AlertViewButtonTouchUpInside(alertView: CustomIOS7AlertView, buttonIndex: Int) {
            print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
            alertView.close()
        }
    
    @IBAction func btnCancelActionDown(sender: AnyObject) {
        btnCancel.backgroundColor = UIColor.redColor()
        btnCancel.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    }
    @IBAction func btnCancelAction(sender: AnyObject) {
        btnCancel.backgroundColor = appDelegate.colorWithHexString("FF7F00")
        btnCancel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        google = 1
        alertConfirm()
    }
    
    
}
