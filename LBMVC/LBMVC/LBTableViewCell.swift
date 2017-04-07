//
//  LBTableViewCell.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/30.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

protocol LBTableviewCellDelegate {
    func onCellComponentClicked(AtIndex index:IndexPath!,bundle extra:Dictionary<String, Any>?)
}

class LBTableViewCell: UITableViewCell {
    var indexPath:IndexPath?
    var item:LBTableViewItem?
    var delegate:LBTableviewCellDelegate?
    
    /// cell高度计算 此方法在主线程回调，如果需要很复杂的计算请使用item.itemHeight字段
    ///
    /// - Parameters:
    ///   - tableView: cell所在tableview
    ///   - item: cell对应数据源
    ///   - indexPath: cell的indexPath
    /// - Returns: 高度
    class func tableView(tableView:UITableView!, variantRowHeightForItem item:AnyObject!, AtIndex indexPath:IndexPath!) -> CGFloat {
        return 44;
    }
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.backgroundColor = UIColor.clear;
        self.contentView.backgroundColor = UIColor.clear;
        self.clipsToBounds = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
}
