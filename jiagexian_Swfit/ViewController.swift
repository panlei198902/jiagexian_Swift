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
    
    let checkinView:MyDatePickerViewController? = nil
    let checkoutView:MyDatePickerViewController? = nil
    var cityInfo:Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            return false
        }
        return true
    }
    
    //成功查询到关键字
    func querySelectkey(not:Notification) {
        self.cityInfo = not.object
        if self.cityInfo == nil {
            let alert = UIAlertController(title: "提示信息", message: "没有数据", preferredStyle: .alert)
            let button = UIAlertAction(title: "了解", style: .cancel, handler: nil)
            alert.addAction(button)
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "showkeys", sender: nil)
        }
        
        
    }
    
    func closeCitiesView(info: NSDictionary) {
        
        //        self.cityInfo = info;
        //        [self dismissViewControllerAnimated:NO completion:nil];
        //        NSString* cityname = info[@"name"];
        //        [self.selectCity setTitle:cityname forState:UIControlStateNormal];
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

