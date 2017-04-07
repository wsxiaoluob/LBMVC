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
            self.setValuesForKeys(dictionary!);
        }
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
    required override init() {
        super.init()
    }
}
