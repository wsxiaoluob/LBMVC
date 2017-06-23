//
//  LBItem.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/29.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class LBItem: NSObject {
    func autoKVCBinding(_ dictionary:Dictionary<String, Any>?) {
        if dictionary != nil {
            let mirror:Mirror = Mirror(reflecting: self);
            for (label,value) in mirror.children {
                if label != nil && dictionary![label!] != nil {
                    if value is LBItem && dictionary![label!] is Dictionary<String, Any> {
                        let subItem = value as! LBItem;
                        subItem.autoKVCBinding(dictionary![label!] as? Dictionary<String, Any>);
                    } else {
                        self.setValue(dictionary![label!], forKey: label!);
                    }
                }
            }
        }
    }
    func doArrayMemberKVC<T>(array:Array<T>) {
        
    }
    class func itemsWithArray(_ array:Array<Dictionary<String, Any>>) -> Array<LBItem> {
        //TODO: Any格式的解析
        var ret:Array<LBItem> = [];
        for dic:Dictionary<String, Any> in array {
            let item = self.init();
            item.autoKVCBinding(dic);
            ret.append(item);
        }
        return ret;
    }
    class func itemWithDictionary(_ dic:Dictionary<String, Any>) -> Self {
        let item = self.init();
        item.autoKVCBinding(dic);
        return item;
    }
    required override init() {
        super.init()
    }
}
