//
//  LBListModel.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/30.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

enum LBListModelPageMode {
    //当前数据大于0条即尝试翻页
    case always;
    //如果当前数据少于pageSize则不翻页，等于或多于pageSize再翻页
    case returnCount
}

class LBListModel: LBModel {
    var hasMore:Bool = false
    var currentPageIndex:Int = 0
    var totalCount:Int = 0
    var pageSize:Int {
        return 20;
    }
    var pageMode:LBListModelPageMode {
        return .returnCount;
    }
    var sectionNumber:Int = 0
    
    override func parse(_ JSON: Any?) -> Bool {
        let ret = super.parse(JSON);
        if !ret {
            return false;
        } else {
            if self.parsedResponse != nil {
                switch self.pageMode {
                case .always:
                    self.hasMore = self.parsedResponse!.count > 0;
                case .returnCount:
                    self.hasMore = self.parsedResponse!.count >= self.pageSize;
                }
            } else {
                self.hasMore = false;
            }
        }
        return true;
    }
    override func reload() {
        self.currentPageIndex = 0;
        super.reload();
    }
    override func loadMore() {
        if self.hasMore {
            self.currentPageIndex += 1;
            super.loadMore();
        }
    }
    override func prepareForLoad() -> Bool {
        var superCls:AnyClass! = type(of: self);
        while superCls != type(of: LBModel()) {
            superCls = class_getSuperclass(superCls)
        }
        let superMethod:IMP = class_getMethodImplementation(superCls, #selector(prepareForLoad));
        typealias ClosureType = @convention(c) (AnyObject, Selector) -> Bool;
        let function:ClosureType = unsafeBitCast(superMethod, to: ClosureType.self);
        let ret = function(self, #selector(prepareForLoad));
        if ret {
            self.currentPageIndex = 0;
            return true;
        } else {
            return false;
        }
    }
}
