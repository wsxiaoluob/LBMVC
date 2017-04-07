//
//  demoDataSource.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/4/6.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class DemoDataSource: LBTableViewDataSource {
    override func cellClassFor(Item item: LBTableViewItem?, AtIndex indexPath: IndexPath) -> LBTableViewCell.Type {
        if item is DemoItem {
            return DemoCell.self;
        }
        return super.cellClassFor(Item: item, AtIndex: indexPath);
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
