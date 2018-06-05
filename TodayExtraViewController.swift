//
//  TodayExtraViewController.swift
//  SidebarMenu
//
//  Created by Developer on 20/01/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import JLToast
import SwiftyJSON

class TodayExtraViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CustomIOS7AlertViewDelegate {

    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnExtra: UIButton!
    @IBOutlet weak var mainView: UIView!
    var o_id : Int!
    var type : String!
    var day : String!
    var defaults : NSUserDefaults!
    var loadingNotification : MBProgressHUD!
    var check : NSString!
    
    var priceArr = [Int]()
    var e_idArr = [Int]()
    var nameArr = [String]()
    var totalpriceArr = [Int]()
    var quantityArr = [Int]()
    var totaltiffinArr = [Int]()
    var m_timeArr = [String]()
    var m_typeArr = [String]()
    var sum = 0
    var ce_id: Int = 0
    
    
    let buttons = [
        "Cancel",
        "OK"
    ]
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        check = ""
        defaults = NSUserDefaults.standardUserDefaults()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        //tableView?.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        tableView?.backgroundColor = UIColor.clearColor()
        tableView?.tableFooterView = UIView(frame: CGRectZero)
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        
     
        ButtonCornor()
        
    }
    
    func customIOS7AlertViewButtonTouchUpInside(alertView: CustomIOS7AlertView, buttonIndex: Int) {
        print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        alertView.close()
    }
    override func viewWillAppear(animated: Bool) {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ButtonCornor()
    {
        btnExtra.layer.cornerRadius = 5
        btnExtra.layer.borderWidth = 2
        btnExtra.layer.borderColor = UIColor.whiteColor().CGColor
        
        mainView.layer.cornerRadius = 5
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnConfirm.layer.cornerRadius = 5
        btnConfirm.layer.borderWidth = 2
        btnConfirm.layer.borderColor = UIColor.whiteColor().CGColor
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
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_order_extra_cart.php?o_id=\(self.o_id)")!)!)
            let tbl_extra_order_cart = json["tbl_extra_order_cart"]
            print(json)
            
            self.ce_id = tbl_extra_order_cart[0]["e_id"].intValue
            for (index,_):(String, JSON) in tbl_extra_order_cart {
                
                let t_day = tbl_extra_order_cart[Int(index)!]["pro_name"].stringValue
                self.nameArr.append(t_day)
                
                let e_id = tbl_extra_order_cart[Int(index)!]["e_id"].intValue
                self.e_idArr.append(e_id)
                
                
                let total_price = tbl_extra_order_cart[Int(index)!]["price"].intValue
                self.priceArr.append(total_price)
                
                let pro_price = tbl_extra_order_cart[Int(index)!]["pro_price"].intValue
                self.totalpriceArr.append(pro_price)
                
                let quantity = tbl_extra_order_cart[Int(index)!]["quantity"].intValue
                self.quantityArr.append(quantity)
                
                let meal_type = tbl_extra_order_cart[Int(index)!]["meal_type"].stringValue
                self.m_typeArr.append(meal_type)
                
                let meal_time = tbl_extra_order_cart[Int(index)!]["meal_time"].stringValue
                self.m_timeArr.append(meal_time)
                
                self.defaults.setInteger(self.nameArr.count, forKey: "Cart_Counter")
                
            }
            print(self.nameArr.count)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if self.ce_id == 0
                {
                    JLToast.makeText("No Cart Items").show()
                    self.lbl1.text = "Total: \(0) Rs."
                    self.tableView.hidden = false
                }
                else
                {
                    self.tableView.hidden = false
                    self.tableView.reloadData()
                    self.sum = 0
                    for self.i=0;self.i<self.priceArr.count;self.i++
                    {
                        self.sum = self.sum + self.priceArr[self.i]
                    }
                    self.lbl1.text = "Total: \(self.sum) Rs."
                }
                self.loadingNotification.hide(true)
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
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.clipsToBounds = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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
    func btnTapped(sender : UIButton)
    {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sender.tag)) as! DetailTableViewCell
        cell.ExtraView.backgroundColor = UIColor.redColor()
        
        print("Click \(sender.tag)")
        
        let netReach = Reachability.reachabilityForInternetConnection()
        let networkstatus = netReach.currentReachabilityStatus()
        
        if networkstatus == NotReachable
        {
            exit(0)
        }
        else
        {
            //print(self.e_idArr[self.uphar])
            self.loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.loadingNotification.mode = MBProgressHUDMode.Indeterminate
            let id = self.defaults.integerForKey("u_id")
            print(id)
            Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/delete_extraorder_cart1.php", parameters: ["c_id":e_idArr[sender.tag]])
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
    func btnTappedDown(sender : UIButton)
    {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sender.tag)) as! DetailTableViewCell
        cell.ExtraView.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
        print("Click \(sender.tag)")
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
    @IBAction func btnConfirmActionDown(sender: AnyObject) {
        btnConfirm.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }
    @IBAction func btnConfirmAction(sender: AnyObject) {
        
        btnConfirm.backgroundColor = UIColor.redColor()
        alertConfirm()
    }
    
    @IBAction func btnExtraActionDown(sender: AnyObject) {
        btnExtra.backgroundColor = UIColor.redColor()
    }
    
    
    @IBAction func btnExtraAction(sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("extraItem") as! ExtraItemViewController
        secondViewController.flagCheck = 1
        secondViewController.c_id = o_id
        secondViewController.typess = self.type
        let nav = UINavigationController(rootViewController: secondViewController)
        presentViewController(nav, animated: true, completion: nil)

        btnExtra.backgroundColor = appDelegate.colorWithHexString("FF7F00")
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
            let netReach = Reachability.reachabilityForInternetConnection()
            let networkstatus = netReach.currentReachabilityStatus()
            if networkstatus == NotReachable
            {
                exit(0)
            }
            else
            {
                if buttonIndex == 1
                {
                    self.loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    self.loadingNotification.mode = MBProgressHUDMode.Indeterminate
                   
                    Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/conform_order_extra_cart.php", parameters: ["o_id":self.o_id!])
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
                                    JLToast.makeText("Your Extra Cart Items Added").show()
                                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("currentOrder") as! CurrentOrderViewController
                                    self.navigationController?.pushViewController(vc, animated: true)
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
        
        print(containerView.frame.width)
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRectMake(0, 0, containerView.frame.width, containerView.frame.height));
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = UIImage(named:"delivery.png")
        containerView.addSubview(imageView)
        
        
        let lblPrices = UILabel(frame: CGRectMake(170, 50, 42, 110))
        lblPrices.font = UIFont.boldSystemFontOfSize(8)
        lblPrices.textColor = UIColor.blackColor()
        lblPrices.text = "You have To Pay \(lbl1.text!) On COD"
        lblPrices.numberOfLines = 5
        lblPrices.textAlignment = NSTextAlignment.Center
        imageView.addSubview(lblPrices)
        //        lblPrice.hidden = true
        
        containerView.backgroundColor = UIColor(patternImage: UIImage(named: "smallbg.png")!)
        
        return containerView
    }


}
