//
//  ViewController.swift
//  jiagexian_Swfit
//
//  Created by derex pan on 2016/12/6.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

let BLQueryKeyFinishedNotification = "BLQueryKeyFinishedNotification"

class ViewController: UIViewController, CitesTableViewControllerDelegate, KeysTableViewControllerDelegate {
    @IBOutlet weak var selectCity: UIButton!
    @IBOutlet weak var selectKey: UIButton!
    @IBOutlet weak var priceRange: UIButton!
    @IBOutlet weak var checkinDate: UIButton!
    @IBOutlet weak var checkoutDate: UIButton!
    
    var cityInfo = NSDictionary()
    
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
        switch identifier {
        case "showkeys":
            HotelBL.sharedInstance.selectKey(city: (self.selectKey.titleLabel?.text)!)
            return false
        case "queryHotel":
            break
        default:
            break
        }
        
        return true
    }
    
    //成功查询到关键字
    func querySelectkey(not:Notification) {
        
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
    
    func closeKeysCtroller(info: NSDictionary) {
        
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
            default:
                break
            }
        }

        

    }

}

