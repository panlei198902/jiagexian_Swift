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
    let HOTEL_QUERY_URL = "/hotelListForMobile.mobile?newSearch=1"
    
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
                        let dict = String(data:data!, encoding: String.Encoding.utf8)
                        print("dict: \(dict!)")
                        //抛出通知
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: BLQueryKeyFinishedNotification), object: dict!)
                    }

                } catch {
                    print("error")
                }


                
            }
         
            
        }
        
        
    }
    //    -(void)selectKey:(NSString*)city
    //    {
    //    NSString *strURL = [[NSString alloc] initWithFormat:KEY_QUERY_URL, city];
    //    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    NSLog(@"strURL: %@",strURL);
    //    MKNetworkEngine *engine = [[MKNetworkEngine alloc]
    //    initWithHostName:HOST_NAME customHeaderFields:nil];
    //    MKNetworkOperation *op = [engine operationWithPath:strURL];
    //
    //    [op addCompletionHandler:^(MKNetworkOperation *operation) {
    //
    //    //NSLog(@"responseData : %@", [operation responseString]);
    //    NSData *data  = [operation responseData];
    //    NSDictionary *resDict = [NSJSONSerialization
    //    JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //    [[NSNotificationCenter defaultCenter] postNotificationName: BLQueryKeyFinishedNotification object: resDict];
    //
    //    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
    //    NSLog(@"MKNetwork请求错误 : %@", [err localizedDescription]);
    //    [[NSNotificationCenter defaultCenter] postNotificationName: BLQueryKeyFailedNotification
    //    object: err];
    //    }];
    //
    //    [engine enqueueOperation:op];
    //
    //    }
    //
    func queryHotel(keyInfo: NSDictionary) {
        
        var strURL = self.HOTEL_QUERY_URL
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        var param = Dictionary<String, Any>()
        param["f_plcityid"] = keyInfo.object(forKey: "Plcityid")
        param["q"] = keyInfo.object(forKey: "key")
        param["currentPage"] = keyInfo.object(forKey: "currentPage")
        
        let price = keyInfo.object(forKey: "Price") as! NSString
        print("price :\(price)")
        if price.isEqual(to: "价格不限") {
            param["priceSlider_minSliderDisplay"] = keyInfo.object(forKey: "￥0")
            param["priceSlider_maxSliderDisplay"] = keyInfo.object(forKey: "￥3000+")
        } else {
            let set = CharacterSet(charactersIn: "--> ")
            let tempArray = price.components(separatedBy: set)
            param["priceSlider_minSliderDisplay"] = keyInfo.object(forKey: tempArray[0])
            param["priceSlider_maxSliderDisplay"] = keyInfo.object(forKey: tempArray[3])
        }
        param["fromDate"] = keyInfo.object(forKey: "Checkin")
        param["toDate"] = keyInfo.object(forKey: "Checkout")
        
        Alamofire.request(strURL, method: .post,
                          parameters: param,
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON { response in
                            debugPrint(response)
                            let list = NSMutableArray()
                            if let dataResult = response.result.value as? Data {
                                let xml = SWXMLHash.parse(dataResult)
                                var n = 0
                                var hotelElement = xml["root"]["hotel_list"]["hotel"][n].element?.text
                                repeat {
                                    var dict = Dictionary <String, Any>()
                                    dict["id"] = xml["root"]["hotel_list"]["hotel"][n]["id"].element?.text!
                                    dict["name"] = xml["root"]["hotel_list"]["hotel"][n]["name"].element?.text!
                                    dict["city"] = xml["root"]["hotel_list"]["hotel"][n]["city"].element?.text!
                                    dict["address"] = xml["root"]["hotel_list"]["hotel"][n]["address"].element?.text!
                                    dict["phone"] = xml["root"]["hotel_list"]["hotel"][n]["phone"].element?.text!
                                    dict["lowprice"] = BLHelp.prePrice(price: (xml["root"]["hotel_list"]["hotel"][n]["lowprice"].element?.text)!)
                                    
                                    dict["grade"] = BLHelp.preGrade(grade: (xml["root"]["hotel_list"]["hotel"][n]["grade"].element?.text)!)
                                    
                                    dict["description"] = xml["root"]["hotel_list"]["hotel"][n]["description"].element?.text!
                                    //属性名字
                                    dict["img"] = xml["root"]["hotel_list"]["hotel"][n].element?.attribute(by: "img")?.text
                                    
                                    //    NSMutableDictionary *dict = [NSMutableDictionary new];
                                    //    //取id
                                    //    TBXMLElement *idElement = [TBXML childElementNamed:@"id" parentElement:hotelElement];
                                    //    if (idElement) {
                                    //    [dict setValue:[TBXML textForElement:idElement] forKey:@"id"];
                                    //    }
                                    //    //取name
                                    //    TBXMLElement *nameElement = [TBXML childElementNamed:@"name" parentElement:hotelElement];
                                    //    if (nameElement) {
                                    //    [dict setValue:[TBXML textForElement:nameElement] forKey:@"name"];
                                    //    }
                                    //    //取city
                                    //    TBXMLElement *cityElement = [TBXML childElementNamed:@"city" parentElement:hotelElement];
                                    //    if (cityElement) {
                                    //    [dict setValue:[TBXML textForElement:cityElement] forKey:@"city"];
                                    //    }
                                    //    //取address
                                    //    TBXMLElement *addressElement = [TBXML childElementNamed:@"address" parentElement:hotelElement];
                                    //    if (addressElement) {
                                    //    [dict setValue:[TBXML textForElement:addressElement] forKey:@"address"];
                                    //    }
                                    //    //取phone
                                    //    TBXMLElement *phoneElement = [TBXML childElementNamed:@"phone" parentElement:hotelElement];
                                    //    if (phoneElement) {
                                    //    [dict setValue:[TBXML textForElement:phoneElement] forKey:@"phone"];
                                    //    }
                                    //    //取lowprice
                                    //    TBXMLElement *lowpriceElement = [TBXML childElementNamed:@"lowprice" parentElement:hotelElement];
                                    //    if (lowpriceElement) {
                                    //    NSString *price = [BLHelp prePrice:[TBXML textForElement:lowpriceElement]];
                                    //    [dict setValue:price forKey:@"lowprice"];
                                    //    }
                                    //    //取grade
                                    //    TBXMLElement *gradeElement = [TBXML childElementNamed:@"grade" parentElement:hotelElement];
                                    //    if (gradeElement) {
                                    //    NSString *grade = [BLHelp preGrade:[TBXML textForElement:gradeElement]];
                                    //    [dict setValue:grade forKey:@"grade"];
                                    //    }
                                    //    //取description
                                    //    TBXMLElement *descriptionElement = [TBXML childElementNamed:@"description" parentElement:hotelElement];
                                    //    if (descriptionElement) {
                                    //    [dict setValue:[TBXML textForElement:descriptionElement] forKey:@"description"];
                                    //    }
                                    //    //取img
                                    //    TBXMLElement *imgElement = [TBXML childElementNamed:@"img" parentElement:hotelElement];
                                    //    if (imgElement) {
                                    //    NSString *src = [TBXML valueOfAttributeNamed:@"src" forElement:imgElement];
                                    //    [dict setValue:src forKey:@"img"];
                                    //    }
                                    n = n + 1 //下一个元素
                                    list.add(dict)
                                    hotelElement = xml["root"]["hotel_list"]["hotel"][n].element?.text
                                    
                                } while hotelElement != nil
                                //抛出通知
                            }
                            
                            
        }
        
        
        
    }
    //    //查询酒店
    //    -(void)queryHotel:(NSDictionary*)keyInfo
    //    {
    //    NSString *strURL = [[NSString alloc] initWithFormat:HOTEL_QUERY_URL];
    //    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    //    [param setValue:[keyInfo objectForKey:@"Plcityid"] forKey:@"f_plcityid"];
    //    [param setValue:[keyInfo objectForKey:@"key"] forKey:@"q"];
    //    [param setValue:[keyInfo objectForKey:@"currentPage"] forKey:@"currentPage"];
    //
    //    NSString *price = [keyInfo objectForKey:@"Price"];
    //    NSLog(@"price: %@",price);
    //    if ([price isEqualToString:@"价格不限"]) {
    //    [param setValue:@"￥0" forKey:@"priceSlider_minSliderDisplay"];
    //    [param setValue:@"￥3000+" forKey:@"priceSlider_maxSliderDisplay"];
    //    } else {
    //    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"--> "];
    //    NSArray *tempArray = [price componentsSeparatedByCharactersInSet:set];
    //    [param setValue:tempArray[0] forKey:@"priceSlider_minSliderDisplay"];
    //    [param setValue:tempArray[3] forKey:@"priceSlider_maxSliderDisplay"];
    //    }
    //
    //    [param setValue:[keyInfo objectForKey:@"Checkin"] forKey:@"fromDate"];
    //    [param setValue:[keyInfo objectForKey:@"Checkout"] forKey:@"toDate"];
    //
    //
    //    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_NAME customHeaderFields:nil];
    //    MKNetworkOperation *op = [engine operationWithPath:strURL params:param httpMethod:@"POST"];
    //    NSLog(@"request: %@",op);
    //    [op addCompletionHandler:^(MKNetworkOperation *operation) {
    //
    //    //NSLog(@"responseData : %@", [operation responseString]);
    //    NSData *data  = [operation responseData];
    //    //        NSLog(@"data: %@",data);
    //    NSMutableArray *list = [[NSMutableArray alloc] init];
    //    NSError *error = nil;
    //
    //    TBXML* tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
    //
    //    if (!error) {
    //    TBXMLElement * root = tbxml.rootXMLElement;
    //
    //    if (root) {
    //    TBXMLElement * hotel_listElement = [TBXML childElementNamed:@"hotel_list" parentElement:root];
    //    if (hotel_listElement) {
    //    TBXMLElement * hotelElement = [TBXML childElementNamed:@"hotel" parentElement:hotel_listElement];
    //
    //    while (hotelElement) {
    //
    
    //
    //    hotelElement = [TBXML nextSiblingNamed:@"hotel" searchFromElement:hotelElement];
    //
    //    [list addObject:dict];
    //    }
    //
    //    }
    //    }
    //    }
    //
    //    NSLog(@"解析完成...");
    //    [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryHotelFinishedNotification object:list];
    //    
    //    
    //    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
    //    NSLog(@"MKNetwork请求错误 : %@", [err localizedDescription]);
    //    [[NSNotificationCenter defaultCenter] postNotificationName:BLQueryHotelFailedNotification object:err];
    //    }];
    //    
    //    [engine enqueueOperation:op];
    
}
