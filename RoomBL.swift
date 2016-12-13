//
//  RoomBL.swift
//  jiagexian_Swift
//
//  Created by derex pan on 2016/12/11.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class RoomBL: NSObject {
    let HOST_NAME = "jiagexian.com"
    let ROOM_QUERY_URL = "/priceline/hotelroom/hotelroomcache.mobile"
    
    //单例
    static let sharedInstance: RoomBL = {
        let instance = RoomBL()
        return instance
    }()
    
    func queryRoom(keyInfo: NSDictionary) {
        
        //准备URL
        let strURL = self.ROOM_QUERY_URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        //准备参数
        var param = Dictionary<String, Any>()
        param["supplierid"] = keyInfo.object(forKey: "hotelId")
        param["fromDate"] = keyInfo.object(forKey: "Checkin")
        param["toDate"] = keyInfo.object(forKey: "Checkout")
        
        Alamofire.request(strURL, method: .post,
                          parameters: param,
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON {
                            
                            response in debugPrint(response)
                            let list: NSMutableArray = NSMutableArray()
                            
                            if let dataResult = response.result.value as? Data {
                                let xml = SWXMLHash.parse(dataResult)
                                var n = 0
                                var hotelElement = xml["rooms"]["room"][n].element?.text
                                repeat {
                                    var dict = Dictionary <String, Any>()
                                    dict["name"] = xml["rooms"]["room"][n].element?.attribute(by: "name")?.text
                                    dict["breakfast"] = BLHelp.preBreakfast(breakfast: (xml["rooms"]["room"][n].element?.attribute(by: "breakfast")?.text)!)
                                    dict["bed"] = BLHelp.preBed(bed: (xml["rooms"]["room"][n].element?.attribute(by: "bed")?.text)!)
                                    dict["broadband"] = BLHelp.preBroadband(broadband: (xml["rooms"]["room"][n].element?.attribute(by: "broadband")?.text)!)
                                    dict["paymode"] = BLHelp.prePaymode(prepay: (xml["rooms"]["room"][n].element?.attribute(by: "paymode")?.text)!)
                                    dict["frontprice"] = BLHelp.prePrice(price: (xml["rooms"]["room"][n].element?.attribute(by: "frontprice")?.text)!)
                                    
                                    list.add(dict)
                                    n = n + 1
                                    hotelElement = xml["rooms"]["room"][n].element?.text
                                } while hotelElement != nil
                            }
        }
        
    }
}




