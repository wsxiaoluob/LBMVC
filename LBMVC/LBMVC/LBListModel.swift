//
//  LBListModel.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/30.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class LBListModel: LBModel {
    var hasMore:Bool = false
    var currentPageIndex:Int = 0
    var totalCount:Int = 0
    var pageSize:Int = 20
    var sectionNumber:Int = 0
    
    override func parse(_ JSON: Any?) -> Bool {
        if !super.parse(JSON) {
            return super.parse(JSON)
        } else {
            var error:NSError? = nil;
            let list:Array<AnyObject>? = self.parseResponse(object: JSON, error: &error);
            if error != nil {
                self.requestDidFailWithError(error: error);
            } else {
                self.hasMore = (list?.count)! >= self.pageSize;
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
