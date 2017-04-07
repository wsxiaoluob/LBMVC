//
//  LBTableViewItem.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/30.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

enum LBTableViewItemType {
    case normal, loading, error, customize
}

class LBTableViewItem: LBItem, NSCoding {
    var indexPath: IndexPath! = IndexPath.init(row: 0, section: 0);
    var itemHeight: CGFloat! = 0
    var itemType: LBTableViewItemType?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.indexPath, forKey: "indexPath");
        aCoder.encode(self.itemHeight, forKey: "itemHeight");
    }
    required init() {
        super.init();
    }
    required init?(coder aDecoder: NSCoder) {
        //TODO: ERROR？
        self.indexPath = aDecoder.decodeObject(forKey: "indexPath") as! IndexPath;
        self.itemHeight = aDecoder.decodeObject(forKey: "itemHeight") as! CGFloat;
    }
}
