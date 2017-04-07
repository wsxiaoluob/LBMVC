//
//  demoModel.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/4/6.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class DemoModel: LBListModel {
    override func urlPath() -> String? {
        return "https://mock.avosapps.com/swift/demo";
    }
    override func parseResponse(object: Any?, error: inout NSError?) -> Array<AnyObject>? {
        if object != nil {
            let response:Dictionary<String, Any> = object as! Dictionary<String, Any>
            if response["data"] != nil && response["data"] is Dictionary<String, Any> {
                let data:Dictionary<String, Any> = response["data"] as! Dictionary<String, Any>;
                //业务
                if data["list"] != nil && data["list"] is Array<Dictionary<String, String>> {
                    let list:Array<Dictionary<String, String>> = data["list"] as! Array<Dictionary<String, String>>;
                    let items:Array<DemoItem> = DemoItem.itemsWithArray(list) as! Array<DemoItem>;
                    return items;
                }
            }
        }
        
        return [];
    }
}
