//
//  CartOrderViewController.swift
//  SidebarMenu
//
//  Created by Developer on 17/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import JLToast

class CartOrderViewController: UIViewController,UITextFieldDelegate,CustomIOS7AlertViewDelegate {
    @IBOutlet weak var extraView: UIView!

    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var txtCouponCode: UITextField!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnExtra: UIButton!
    var sum = 0
    var e_idArr = [Int]()
    var uphar = 0
    var check : NSString!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    var defaults : NSUserDefaults!
    
    var t_day: Int!
    var c_id : Int!
    var ce_id: Int = 0
    var tiffin_price: Int!
    var tot_price: Int!
    var quantity: Int!
    var total_tiffin: Int!
    var meal_type: String!
    var meal_time: String!
    
    var priceArr = [Int]()
    var nameArr = [String]()
    var totalpriceArr = [Int]()
    var quantityArr = [Int]()
    var totaltiffinArr = [Int]()
    var m_timeArr = [String]()
    var m_typeArr = [String]()
    
    var loadingNotification : MBProgressHUD!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    let buttons = [
        "Cancel",
        "OK"
    ]
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = NSUserDefaults.standardUserDefaults()
       // extraView.backgroundColor = appDelegate.colorWithHexString("#CC0000")
        check = ""
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Please Wait Loading"
        view?.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        tableView?.hidden = true

        
        txtCouponCode.delegate = self
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

    }

    func customIOS7AlertViewButtonTouchUpInside(alertView: CustomIOS7AlertView, buttonIndex: Int) {
        print("DELEGATE: Button '\(buttons[buttonIndex])' touched")
        alertView.close()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func ButtonCornor()
    {
        subView.layer.cornerRadius = subView.frame.height / 2
        subView.layer.borderWidth = 2
        subView.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 2
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnConfirm.layer.cornerRadius = 5
        btnConfirm.layer.borderWidth = 2
        btnConfirm.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnApply.layer.cornerRadius = 5
        btnApply.layer.borderWidth = 2
        btnApply.layer.borderColor = UIColor.whiteColor().CGColor
        
        txtCouponCode.layer.cornerRadius = 5
        txtCouponCode.layer.borderWidth = 2
        txtCouponCode.layer.borderColor = UIColor.whiteColor().CGColor
        
        mainView.layer.cornerRadius = 5
        mainView.layer.borderWidth = 0
        mainView.layer.borderColor = UIColor.redColor().CGColor
        
        tempView.layer.cornerRadius = 5
        tempView.layer.borderWidth = 2
        tempView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    override func viewWillAppear(animated: Bool) {
        sum = 0
        l1.text = "Total: \(tot_price + sum) Rs."
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
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_extraorder_cart.php?c_id=\(self.c_id)")!)!)
            let tbl_extra_order_cart = json["tbl_extra_order_cart"]
            print(json)
            
            self.ce_id = tbl_extra_order_cart[0]["ce_id"].intValue
            for (index,_):(String, JSON) in tbl_extra_order_cart {
                
                let t_day = tbl_extra_order_cart[Int(index)!]["pro_name"].stringValue
                self.nameArr.append(t_day)
                
                let e_id = tbl_extra_order_cart[Int(index)!]["ce_id"].intValue
                self.e_idArr.append(e_id)
                
                let total_price = tbl_extra_order_cart[Int(index)!]["total_price"].intValue
                self.priceArr.append(total_price)
                
                let pro_price = tbl_extra_order_cart[Int(index)!]["pro_price"].intValue
                self.totalpriceArr.append(pro_price)
                
                let quantity = tbl_extra_order_cart[Int(index)!]["quantity"].intValue
                self.quantityArr.append(quantity)
                
                let total_tiffin = tbl_extra_order_cart[Int(index)!]["total_tiffin"].intValue
                self.totaltiffinArr.append(total_tiffin)
                
                
                let meal_type = tbl_extra_order_cart[Int(index)!]["meal_type"].stringValue
                self.m_typeArr.append(meal_type)
                
                let meal_time = tbl_extra_order_cart[Int(index)!]["meal_time"].stringValue
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

    @IBAction func btnExtraAction(sender: AnyObject) {
        
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("extraItem") as! ExtraItemViewController
        secondViewController.c_id = c_id
        secondViewController.flagCheck = 0
        let nav = UINavigationController(rootViewController: secondViewController)
        
        self.presentViewController(nav, animated: true, completion: nil)

        subView.backgroundColor = UIColor.redColor()
     
    }
    
    @IBAction func btnExtraActionDown(sender: AnyObject) {
         subView.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
    }
    
    @IBAction func btnCancelACtion(sender: AnyObject) {
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        // let id = defaults.integerForKey("u_id")
        Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/delete_tiffin_cart.php", parameters: ["c_id":self.c_id!])
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
                     appDelegate.rootVC()
                    }
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
        uphar = sender.tag
        print("Click \(sender.tag)")
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
       // let id = defaults.integerForKey("u_id")
        Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/delete_extraorder_cart.php", parameters: ["c_id":self.e_idArr[self.uphar]])
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
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("cart") as! CartViewController
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
    
    @IBAction func btnApplyAction(sender: AnyObject) {
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
        let id = defaults.integerForKey("u_id")
        Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/apply_cupan_code.php", parameters: ["code":self.txtCouponCode.text!,"total":self.lblTotalPrice.text!,"u_id":id])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    let message = JSON["apply"] as! NSMutableArray
                    let status = message.objectAtIndex(0) as! NSDictionary
                    self.check = status.valueForKey("status") as! NSString
                    
                    if self.check == "0"
                    {
                        self.loadingNotification.hide(true)
                        JLToast.makeText("Invalid Coupon Code").show()
                        self.txtCouponCode.text = ""
                    }
                    else if self.check == "2"
                    {
                        self.loadingNotification.hide(true)
                        JLToast.makeText("Coupan Already Used").show()
                        self.txtCouponCode.text = ""
                    }
                    else
                    {
                        self.loadingNotification.hide(true)
                        JLToast.makeText("Coupon Apply Successfully").show()
                        self.txtCouponCode.text = ""
                    }
                    
                }
            }}

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
                        let id = self.defaults.integerForKey("u_id")
                        let email : String = (self.defaults?.objectForKey("email"))!
                            as! String
                        Alamofire.request(.GET, "http://shreehariconsultant.com/cooker_webservice/conform_order.php", parameters: ["c_id":self.c_id!,"u_id":id,"u_email":email,"grant_total":self.l1.text!])
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
                                        JLToast.makeText("Order Confirm").show()
                                        appDelegate.rootVC()
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
        lblPrices.text = "You have To Pay \(l1.text!) On COD"
        lblPrices.numberOfLines = 5
        lblPrices.textAlignment = NSTextAlignment.Center
        imageView.addSubview(lblPrices)
//        lblPrice.hidden = true
        
        containerView.backgroundColor = UIColor(patternImage: UIImage(named: "smallbg.png")!)
        
        return containerView
    }

    @IBAction func btnConfirmAction(sender: AnyObject) {
        
        alertConfirm()

    }
    
}
