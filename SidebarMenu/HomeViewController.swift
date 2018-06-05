//
//  HomeViewController.swift
//  SidebarMenu
//
//  Created by Developer on 15/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var lblPush: UILabel!
    @IBOutlet weak var pushView: UIView!
    @IBOutlet weak var tempCartView: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mealView: UIView!
    @IBOutlet var lblDay: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var defaults : NSUserDefaults!
    var is_holiday: Int = 0
    @IBOutlet weak var btnOrder_now: UIButton!
    
    @IBOutlet weak var btnOffer: UIButton!
    var imgArr = [String]()
    var index = 0
    var index1 = 0
    var index2 = 0
    let animationDuration: NSTimeInterval = 0.25
    let switchingInterval: NSTimeInterval = 3
    var nameArr = [String]()
    var priceArr = [String]()
    let appdelegate = UIApplication.sharedApplication().delegate
    var loadingNotification : MBProgressHUD!
    var menuArr = [String]()
    var cou = 0
    var id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = NSUserDefaults.standardUserDefaults()
        
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Please Wait Loading"
        view?.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        
        mainView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        tableView?.backgroundColor = UIColor(patternImage: UIImage(named: "smallbg.png")!)
        tableView?.hidden = true
        
        tableView?.tableFooterView = UIView(frame: CGRectZero)
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
    
        
        imgArr = ["slide1.png","slide2.png","slide3.png","slide4.png"]
        nameArr = ["Daily","King's Feast","Monthly"]
        priceArr = ["65 Rs/Tiffin","99 Rs/Tiffin","1890Rs/Tiffin"]
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        btnOrder_now.layer.cornerRadius = 5
        btnOrder_now.layer.borderWidth = 2
        btnOrder_now.layer.borderColor = UIColor.whiteColor().CGColor
        
        pushView.layer.cornerRadius = 10
        pushView.layer.borderWidth = 2
        pushView.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnOffer.layer.cornerRadius = 5
        btnOffer.layer.borderWidth = 2
        btnOffer.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        priceView.layer.cornerRadius = 40
        priceView.layer.borderWidth = 2
        priceView.layer.borderColor = UIColor.yellowColor().CGColor
        
        tempCartView.layer.cornerRadius = tempCartView.frame.height / 2
        tempCartView.layer.borderWidth = 3
        tempCartView.layer.borderColor = UIColor.whiteColor().CGColor
        
        mainImage.image = UIImage(named: imgArr[index++])
        lblName.text = nameArr[index1++]
        lblPrice.text = priceArr[index2++]
        animateImageView()
        
        let a = getDayOfWeek()
        print(a)
        
        switch a
        {
           case 1:
              lblDay.text = "Sunday"
              break;
            
           case 2:
              lblDay.text = "Monday"
              break;
            
           case 3:
              lblDay.text = "Tuesday"
              break;
 
           case 4:
              lblDay.text = "Wednesday"
              break;
            
           case 5:
              lblDay.text = "Thursday"
              break;

           case 6:
              lblDay.text = "Friday"
              break;

           case 7:
              lblDay.text = "Saturday"
              break;

           default:
              break;
        }
       id = defaults?.integerForKey("u_id")
       let check = defaults.boolForKey("Login")
       if check == true
       {
        tempCartView.hidden = false
        pushView.hidden = false
       }
       else
       {
        tempCartView.hidden = true
        pushView.hidden = true
       }
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

        
        // Do any additional setup after loading the view.
    }
 
    override func viewDidLayoutSubviews() {
        let height = tableView.frame.size.height
        print(height)
        if height == 122
        {
         tableView.scrollEnabled = true
        }
        else if menuArr.count < 5
        {
         tableView.scrollEnabled = false
        }
        else
        {
         tableView.scrollEnabled = true
        }
    }
    func getDayOfWeek()->Int {

        let today = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: today)
        let weekDay = myComponents.weekday
        return weekDay
    }
    func animateImageView() {
        
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(self.switchingInterval * NSTimeInterval(NSEC_PER_SEC/2)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                self.animateImageView()
            }
        }
        
        let transition = CATransition()
       // transition.type = kCATransitionFromLeft
        
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        mainImage.layer.addAnimation(transition, forKey: kCATransition)
        lblName.layer.addAnimation(transition, forKey: kCATransition)
        lblPrice.layer.addAnimation(transition, forKey: kCATransition)
        
        mainImage.image = UIImage(named: imgArr[index])
        lblName.text = nameArr[index1]
        lblPrice.text = priceArr[index2]

        print(nameArr[index1])
        
        CATransaction.commit()
        
        index = index < imgArr.count - 1 ? index + 1 : 0
        index1 = index1 < nameArr.count - 1 ? index1 + 1 : 0
        index2 = index2 < priceArr.count - 1 ? index2 + 1 : 0
    }
   
    
    func FetchData()
    {
        menuArr.removeAll()
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_today_meal.php?day=\(self.lblDay.text!)")!)!)
            let tbl_today_meal = json["tbl_today_meal"]
            
            
            for (index,_):(String, JSON) in tbl_today_meal {
                let name = tbl_today_meal[Int(index)!]["pro_name"].stringValue
                self.menuArr.append(name)
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.hidden = false
                self.tableView.reloadData()
                self.loadingNotification.hide(true)
                print("Finish")
            }
        }
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/simple_cartcounter.php?u_id=\(self.id)")!)!)
            let tbl_cart = json["tbl_cart"]
            
            self.cou = tbl_cart[0]["cart"].intValue
            
            print(self.cou)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if self.cou > 0
                {
                 self.pushView.hidden = false
                 self.lblPush.text = "\(self.cou)"
                }
                else
                {
                 self.pushView.hidden = true
                }
                self.loadingNotification.hide(true)
                print("Finish")
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_holiday.php")!)!)
            let tbl_holiday = json["tbl_holiday"]
            
            self.is_holiday = tbl_holiday[0]["is_holiday"].intValue
            
            print(self.cou)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in

                self.loadingNotification.hide(true)
                print("Finish")
            }
        }


        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOrderAction(sender: AnyObject) {
        if is_holiday == 1
        {
         let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("holiday") as! HolidayViewController
         self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else
        {
          let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("order") as! OrderViewController
          self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        
        btnOrder_now.backgroundColor = UIColor.redColor()
    }
    @IBAction func btnTodayAction(sender: AnyObject) {
        btnOffer.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }
    @IBAction func btnTodayActionDown(sender: AnyObject) {
        btnOffer.backgroundColor = UIColor.redColor()
    }
    @IBAction func btnOrderActionDown(sender: AnyObject) {
        btnOrder_now.backgroundColor = appDelegate.colorWithHexString("FF7F00")
    }

    @IBAction func btnCartAction(sender: AnyObject) {
        tempCartView.backgroundColor = UIColor.redColor()
        
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("cart") as! CartViewController
        let nav = UINavigationController(rootViewController: secondViewController)
        presentViewController(nav, animated: true, completion: nil)

    }
    
    @IBAction func btnCardActionDown(sender: AnyObject) {
        tempCartView.backgroundColor = appDelegate.colorWithHexString("#FFCC00")
    }
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue){
        
    }
    
    override func viewWillLayoutSubviews() {
     }
    //TableView
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menuArr.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
//        cell.mainView.layer.cornerRadius = 5
        cell.mainView.layer.borderWidth = 0
//        cell.mainView.layer.borderColor = UIColor.redColor().CGColor
        cell.mainView.clipsToBounds = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.imgIcon.image = UIImage(named: "meal.png")
        cell.imgIcon.layer.cornerRadius = cell.imgIcon.frame.height / 2
        cell.imgIcon.layer.borderWidth = 3
        cell.imgIcon.layer.borderColor = UIColor.whiteColor().CGColor
        cell.imgIcon.clipsToBounds = true
        
        let view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        cell.selectedBackgroundView = view
        
        cell.lblName.text = menuArr[indexPath.section]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 100))
        
        //footerView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        footerView.backgroundColor = UIColor.clearColor()
        
        return footerView
    
    }
}
