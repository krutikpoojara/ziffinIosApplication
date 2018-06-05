//
//  TodayOrderListViewController.swift
//  SidebarMenu
//
//  Created by Developer on 18/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON
import JLToast

class TodayOrderListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var welcomeImg: UIImageView!
    
    @IBOutlet weak var logoImg: UIImageView!
    
    var loadingNotification : MBProgressHUD!
    var defaults : NSUserDefaults!
    var priceArr = [Int]()
    var dayArr = [Int]()
    var c_idArr = [Int]()
    var d_idArr = [Int]()
    var totalpriceArr = [Int]()
    var quantityArr = [Int]()
    var totaltiffinArr = [Int]()
    var d_id: Int!
    var c_id: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        defaults = NSUserDefaults.standardUserDefaults()
        tableView.addSubview(welcomeImg)
        tableView.addSubview(logoImg)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"

        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    
        tableView?.hidden = true
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        tableView?.tableFooterView = UIView(frame: CGRectZero)
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        
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
        let id = defaults.integerForKey("u_id")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_today_tiffin.php?u_id=\(id)")!)!)
            let tbl_tiffin_deliver = json["tbl_tiffin_deliver"]
            
            print(tbl_tiffin_deliver)
            for (index,_):(String, JSON) in tbl_tiffin_deliver {
                self.d_id = tbl_tiffin_deliver[Int(index)!]["d_id"].intValue
                self.d_idArr.append(self.d_id)
                
                self.c_id = tbl_tiffin_deliver[Int(index)!]["o_id"].intValue
                self.c_idArr.append(self.c_id)
                
                let tiffin_price = tbl_tiffin_deliver[Int(index)!]["price"].intValue
                self.priceArr.append(tiffin_price)
                
                let tot_price = tbl_tiffin_deliver[Int(index)!]["total_price"].intValue
                self.totalpriceArr.append(tot_price)
                
                let quantity = tbl_tiffin_deliver[Int(index)!]["quantity"].intValue
                self.quantityArr.append(quantity)
                
                let total_tiffin = tbl_tiffin_deliver[Int(index)!]["total_tiffin"].intValue
                self.totaltiffinArr.append(total_tiffin)
                
            }
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if self.d_id == 0
                {
                    JLToast.makeText("No Order").show()
                    self.tableView.hidden = false
                }
                else
                {
                    self.tableView.hidden = false
                    self.tableView.reloadData()
                }
                self.loadingNotification.hide(true)
                print("Finish")
            }
        }
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return d_idArr.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        cell.mainView.layer.cornerRadius = 5
        cell.mainView.layer.borderWidth = 0
        cell.mainView.layer.borderColor = UIColor.redColor().CGColor
        cell.mainView.clipsToBounds = true
        
        cell.lblPrice.text = "Price : \(quantityArr[indexPath.section]) X \(priceArr[indexPath.section])"
        cell.lblTotalPrice.text = "Total Price:\(totalpriceArr[indexPath.section])"
        
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("todayMenu") as! TodayMenuViewController
        secondViewController.quantity = quantityArr[indexPath.section]
        secondViewController.tot_price = totalpriceArr[indexPath.section]
        secondViewController.tiffin_price = priceArr[indexPath.section]
        secondViewController.c_id = d_idArr[indexPath.section]
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 100))
        
        footerView.backgroundColor = UIColor.clearColor()
        return footerView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
