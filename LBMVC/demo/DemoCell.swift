//
//  demoCell.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/4/6.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class DemoCell: LBTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews();
        if self.item != nil {
            let _demoItem:DemoItem! = self.item as! DemoItem;
            self.textLabel?.text = _demoItem.title;
            self.detailTextLabel?.text = _demoItem.desc;
        }
    }
    
}
