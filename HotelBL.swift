//
//  HotelBL.swift
//  jiagexian_Swift
//
//  Created by derex pan on 2016/12/9.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class HotelBL: NSObject {
    
    //定义几个HTTP相关常量
    let HOST_NAME = "jiagexian.com"
    let KEY_QUERY_URL = "http://jiagexian.com/ajaxplcheck.mobile?method=mobilesuggest&v=1&city="
    let HOTEL_QUERY_URL = "http://jiagexian.com/hotelListForMobile.mobile?newSearch=1"
    
    //单例
    static let sharedInstance: HotelBL = {
        let instance = HotelBL()
        return instance
    }()
    

    func selectKey(city: String) {
        
        //转换url
        var strURL = self.KEY_QUERY_URL + city
        var dict = NSDictionary()
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        print("strURL: \(strURL)")
        Alamofire.request(strURL).responseJSON { response in
            debugPrint(response)
            print("response: \(response)")
            if let json = response.result.value{
                do {
                    print("json: \(json)")
                    if JSONSerialization.isValidJSONObject(json) {
                        print("is a vailid JSONObject")
                        //利用自带的json库转换成Data
                        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
                        let data = try? JSONSerialization.data(withJSONObject: json, options: [])
                        dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        
                        print("dict: \(dict)")
                    }
                    
                } catch {
                    print("error")
                }
                
                
                
            }
            //抛出通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLQueryKeyFinishedNotification), object: dict)
            
        }
        
        
    }

    
    func queryHotel(keyInfo: NSMutableDictionary) {
        
        var strURL = self.HOTEL_QUERY_URL
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        var param = NSDictionary() as! Parameters
        param["f_plcityid"] = keyInfo.object(forKey: "Plcityid")
        param["f_plcityid"] = keyInfo.object(forKey: "Plcityid")
        param["q"] = keyInfo.object(forKey: "key")
        param["currentPage"] = keyInfo.object(forKey: "currentPage")
        
        let price = keyInfo.object(forKey: "Price") as! NSString
        print("price :\(price)")
        if price.isEqual(to: "价格不限") {
            param["priceSlider_minSliderDisplay"] = "￥0"
            param["priceSlider_maxSliderDisplay"] = "￥3000+"
        } else {
            let set = CharacterSet(charactersIn: "--> ")
            let tempArray = price.components(separatedBy: set)
            param["priceSlider_minSliderDisplay"] = tempArray[0]
            param["priceSlider_maxSliderDisplay"] = tempArray[3]
        }
        param["fromDate"] = keyInfo.object(forKey: "Checkin")
        param["toDate"] = keyInfo.object(forKey: "Checkout")
        print("param: \(param)")
        Alamofire.request(strURL, method: .post,
                          parameters: param).responseData { response in
                            debugPrint(response)
                            let list = NSMutableArray()
                            if let dataResult = response.result.value{
                                do {
                                    print("dataResult: \(dataResult)")
                                    let xml = SWXMLHash.parse(dataResult)
                                    print("xml: \(xml)")
                              
                                    for elem in xml["result"]["hotel_list"]["hotel"] {
                                        var dict = Dictionary <String, Any>()
                                        print("id: \(elem["id"].element?.text)")
                                        dict["id"] = elem["id"].element?.text
                                        dict["name"] = elem["name"].element?.text!
                                        dict["city"] = elem["city"].element?.text!
                                        dict["address"] = elem["address"].element?.text!
                                        dict["phone"] = elem["phone"].element?.text!
                                        

                                        dict["lowprice"] = BLHelp.prePrice(price: (elem["lowprice"].element?.text)!)
                                        
                                        dict["grade"] = BLHelp.preGrade(grade: (elem["grade"].element?.text)!)
                                        
                                        dict["description"] = elem["description"].element?.text!
                                        //属性名字
                                        dict["img"] = elem["img"].element?.attribute(by: "src")?.text

                                        list.add(dict)

                                    }

                                    //抛出通知
                                }
    
                            }
        }
    }
}
