//
//  LBItemList.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/28.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class LBItemList: NSObject {
    lazy var array:Array<AnyObject>! = [];
    var currentPage:UInt = 0;
    var totalCount:CLong = 0;
    var pageSize:UInt = 0;
    var havNextPage:Bool = false;
    var count:Int {
        get {
            return (self.array?.count)!;
        }
    }
    var hasMore:Bool {
        get {
            return CLong(self.currentPage * self.pageSize) < self.totalCount;
        }
    }
    
    func reset() {
        self.currentPage = 0;
        self.totalCount = 0;
        self.havNextPage = false;
        self.removeAllObjects();
    }
    func objectAtIndex(_ index:Int) -> AnyObject? {
        if (self.array?.count)! < index {
            return self.array![index] as AnyObject?;
        }
        return nil;
    }
    func addObject(anObject:AnyObject?) {
        if anObject != nil {
            self.array?.append(anObject!);
        }
        
    }
    func addObjectFromArray(otherArray:Array<AnyObject>?) {
        if otherArray != nil {
            self.array?.append(contentsOf: otherArray!)
        }
        
    }
    func removeAllObjects() {
        self.array?.removeAll()
    }
    func removeObject(anObject:AnyObject?) {
        for index:Int in 0...self.array.count - 1 {
            let element = self.array[index];
            if element as! _OptionalNilComparisonType == anObject {
                self.array.remove(at: index);
                return;
            }
        }
    }
    
}
