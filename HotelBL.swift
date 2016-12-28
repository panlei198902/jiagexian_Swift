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
    
    //拉取关键字方法
    func selectKey(city: String) {
        
        //转换url
        var strURL = self.KEY_QUERY_URL + city
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        print("strURL: \(strURL)")
        Alamofire.request(strURL).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value{
                do {
                    print("json: \(json)")
                    if JSONSerialization.isValidJSONObject(json) {
                        print("is a vailid JSONObject")
                        //利用自带的json库转换成Data
                        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
                        let data = try? JSONSerialization.data(withJSONObject: json, options: [])
                        let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        print("dict: \(dict)")
                        //抛出通知
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLQueryKeyFinishedNotification), object: dict)
                    }
                    
                } catch {
                    print("error")
                }
                
                
                
            }
            
            
        }
        
        
    }

    
    func queryHotel(keyInfo: NSMutableDictionary) {
        
        var strURL = self.HOTEL_QUERY_URL
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        var param:Parameters = Dictionary<String, String>()
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
                          parameters: param,
                          encoding: JSONEncoding.default).responseData { (response) in
                            debugPrint(response)
                            let list = NSMutableArray()
                            if let dataResult = response.result.value{
                                do {
                                    print("dataResult: \(dataResult)")
                                    let xml = SWXMLHash.parse(dataResult)
                                    print("xml: \(xml)")
//                                    print(dataResult.description)
                                    var n = 1
                                    var hotelElement = xml["root"]["hotel_list"].element
                                    while (hotelElement != nil) {
                                        var dict = Dictionary <String, Any>()
                                        dict["id"] = xml["root"]["hotel_list"]["hotel"][n]["id"].element?.text!
                                        dict["name"] = xml["root"]["hotel_list"]["hotel"][n]["name"].element?.text!
                                        dict["city"] = xml["root"]["hotel_list"]["hotel"][n]["city"].element?.text!
                                        dict["address"] = xml["root"]["hotel_list"]["hotel"][n]["address"].element?.text!
                                        dict["phone"] = xml["root"]["hotel_list"]["hotel"][n]["phone"].element?.text!
                                        
                                        //这里有问题
                                        dict["lowprice"] = BLHelp.prePrice(price: (xml["root"]["hotel_list"]["hotel"][n]["lowprice"].element?.text)!)
                                        
                                        dict["grade"] = BLHelp.preGrade(grade: (xml["root"]["hotel_list"]["hotel"][n]["grade"].element?.text)!)
                                        
                                        dict["description"] = xml["root"]["hotel_list"]["hotel"][n]["description"].element?.text!
                                        //属性名字
                                        dict["img"] = xml["root"]["hotel_list"]["hotel"][n].element?.attribute(by: "img")?.text
                                        n = n + 1 //下一个元素
                                        list.add(dict)
                                        hotelElement = xml["root"]["hotel_list"]["hotel"][n].element
                                        
                                    }
                                    //抛出通知
                                }
                                catch let error {
                                    print(error)
                                }
                            }
        }
    }
}
