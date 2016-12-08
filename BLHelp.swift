//
//  BLHelp.swift
//  jiagexian_Swfit
//
//  Created by derex pan on 2016/12/6.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

class BLHelp: NSObject {
    //预处理价格
    static func prePrice(price: String) -> String {
        if price.isEmpty || Int(price) == 0 {
            return "无房"
        }
        return "￥\(price)/天起"
    }
    //预处理级别
    static func preGrade(grade: String) -> String {
        return "\(grade)星级"
    }
    
     //room breakfast: 含几份早餐，不可为空,-1 <= breakfast <= 4。-1表示含早（数量不定），0表示无早，其他数值表示含N早
    static func preBreakfast(breakfast:String) -> String {
        
        switch breakfast {
        case "-1":
            return "含早餐"
        case "0":
            return "无早餐"
        default:
            return "含\(breakfast)份早餐"
        }
    }
    
    //预处理床型
    //床型，不可为空, 0大床 / 1双床 / 2大/双床 / 3三床 / 4一单一双 / 5单人床 / 6上下铺 / 7通铺 / 8榻榻米 / 9水床 / 10圆床 / 拼床
    static func preBed(bed:String) -> String {
        
        let intBed = Int(bed)!
        
        switch intBed {
        case 0:
            return "大床"
        case 1:
            return "双床"
        case 2:
            return "大/双床"
        case 3:
            return "三床"
        case 4:
            return "一单一双"
        case 5:
            return "单人床"
        case 6:
            return "上下铺"
        case 7:
            return "通铺"
        case 8:
            return "榻榻米"
        case 9:
            return "水床"
        case 10:
            return "圆床"
        default:
            return "拼床"
        }
    }
//    //预处理宽带

//    //room broadband: 宽带，不可为空，0无 / 1有 / 2免费 / 3收费 / 4部分收费 / 5部分有且收费 / 6部分有且免费 / 7部分有且部分收费
    static func preBroadband(broadband: String) -> String {

        switch broadband {
        case "0":
            return "无"
        case "1":
            return "有"
        case "2":
            return "免费"
        case "3":
            return "收费"
        case "4":
            return "部分收费"
        case "5":
            return "部分有且收费"
        case "6":
            return "部分有且免费"
        default:
            return "部分有且部分收费"
        }
    }
   
//    //预处理支付类型
//    //room prepay:支付类型，不可为空， 0 需预付 / 1 前台现付
    static func prePaymode(prepay: String) -> String {
        
        let intPrepay = Int(prepay)!
        
        switch intPrepay {
        case 0:
            return "需预付"
        default:
            return "前台支付"
        }
    }
    
    
}

