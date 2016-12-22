//
//  ViewController.swift
//  jiagexian_Swfit
//
//  Created by derex pan on 2016/12/6.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

let BLQueryKeyFinishedNotification = "BLQueryKeyFinishedNotification"
//定义BL关键字查询失败通知
let BLQueryKeyFailedNotification = "BLQueryKeyFailedNotification"

//定义BL查询酒店成功通知
let BLQueryHotelFinishedNotification = "BLQueryHotelFinishedNotification"
//定义BL查询酒店失败通知
let BLQueryHotelFailedNotification = "BLQueryHotelFailedNotification"

//定义BL查询酒店房间成功通知
let BLQueryRoomFinishedNotification = "BLQueryRoomFinishedNotification"
//定义BL查询酒店房间失败通知
let BLQueryRoomFailedNotification = "BLQueryRoomFailedNotification"

class ViewController: UIViewController, CitesTableViewControllerDelegate, KeysTableViewControllerDelegate, MyPickerViewControllerDelegate, MyDatePickerViewControllerDelegate {
    
    @IBOutlet weak var selectCity: UIButton!
    @IBOutlet weak var selectKey: UIButton!
    @IBOutlet weak var priceRange: UIButton!
    @IBOutlet weak var checkinDate: UIButton!
    @IBOutlet weak var checkoutDate: UIButton!
    
    var checkinView:MyDatePickerViewController? = nil
    var checkoutView:MyDatePickerViewController? = nil
    var priceSelect: MyPickerViewController? = nil
    var hotelQueryKey = Dictionary<String, String>()
    var cityInfo: Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkinView = MyDatePickerViewController()
        checkinView?.delegate = self
        
        checkoutView = MyDatePickerViewController()
        checkoutView?.delegate = self
        
        priceSelect = MyPickerViewController()
        priceSelect?.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(querySelectkey(not:)), name: NSNotification.Name(rawValue: BLQueryKeyFinishedNotification), object: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showkeys" {
            HotelBL.sharedInstance.selectKey(city: (self.selectCity.titleLabel?.text)!)
            return false
        } else if identifier == "queryHotel" {
            var errMsg: String? = nil
            if self.selectCity.titleLabel?.text == "选择城市" {
                errMsg = "请选择城市"
            } else if self.selectKey.titleLabel?.text == "选择关键字"{
                errMsg = "请选择关键字"
            } else if self.checkinDate.titleLabel?.text == "选择日期" {
                errMsg = "请选择入住日期"
            } else if self.checkoutDate.titleLabel?.text == "选择日期" {
                errMsg = "请选择退房日期"
            }
            
            if errMsg != nil {
                let alert = UIAlertController(title: "提示信息", message: errMsg, preferredStyle: .alert)
                let alertButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(alertButton)
                self.present(alert, animated: true, completion: nil)
            }
            let tempDict = self.cityInfo as! NSDictionary
            let plcityID = tempDict.object(forKey: "Plcityid") as! String
            
            self.hotelQueryKey[plcityID] = "Plcityid"
            self.hotelQueryKey["currentPage"] = "1"
            self.hotelQueryKey["key"] = self.selectKey.titleLabel?.text
            self.hotelQueryKey["Price"] = self.priceRange.titleLabel?.text
            self.hotelQueryKey["Checkin"] = self.checkinDate.titleLabel?.text
            self.hotelQueryKey["Checkout"] = self.checkoutDate.titleLabel?.text
            
            if let hotelQueryKeyNSDic = self.hotelQueryKey as? NSDictionary {
                HotelBL.sharedInstance.queryHotel(keyInfo: hotelQueryKeyNSDic)
            }
        
            return false
        }
        return true
    }
    
    //成功查询到关键字
    func querySelectkey(not:Notification) {
        if not.object != nil {
            self.cityInfo = not.object
            performSegue(withIdentifier: "showkeys", sender: nil)
        } else {
            let alert = UIAlertController(title: "提示信息", message: "没有数据", preferredStyle: .alert)
            let button = UIAlertAction(title: "了解", style: .cancel, handler: nil)
            alert.addAction(button)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func closeCitiesView(info: NSDictionary) {

        self.cityInfo = info 
        self.dismiss(animated: false, completion: nil)
        if let cityname = info["name"] as? String {
            self.selectCity.setTitle(cityname, for: .normal)
        }
        
        
    }
    
    func closeKeysCtroller(info: String) {
        self.dismiss(animated: false, completion: nil)
        self.selectKey.setTitle(info, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifierString = segue.identifier {
            switch identifierString {
            case "showcities":
                let nvgViewController = segue.destination as! UINavigationController
                let topViewController = nvgViewController.topViewController as! CitesTableViewController
                topViewController.delegate = self
            case "showkeys":
                let nvgViewController = segue.destination as! UINavigationController
                let topViewController = nvgViewController.topViewController as! KeysTableViewController
                topViewController.delegate = self
                topViewController.keyDict = self.cityInfo as! NSDictionary
            default:
                break
            }
        }
    }
    @IBAction func selectPriceRange(_ sender: UIButton) {
        self.priceSelect?.show(in: self.view)
    }
    @IBAction func selectCheckout(_ sender: UIButton) {
        self.checkoutView?.show(in: self.view)
    }
    @IBAction func selectCheckin(_ sender: UIButton) {
        self.checkinView?.show(in: self.view)
    }

    func myPickDateViewControllerDidFinish(_ controller: MyDatePickerViewController!, andSelectedDate selected: Date!) {
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        date.locale = Locale(identifier: "zh_CN")
        
        let strData = date.string(from: selected)
        if self.checkinView == controller {
            self.checkinDate.setTitle(strData, for: .normal)
        } else if self.checkoutView == controller {
            self.checkoutDate.setTitle(strData, for: .normal)
        }
        
    }
    
    func myPickViewClose(_ selected: String!) {
        self.priceRange.setTitle(selected, for: .normal)
    }

}

