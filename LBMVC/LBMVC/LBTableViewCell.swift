//
//  LBTableViewCell.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/30.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

protocol LBTableviewCellDelegate:class {
    func onCellComponentClicked(AtIndex index:IndexPath!,bundle extra:Dictionary<String, Any>?)
}

class LBTableViewCell: UITableViewCell {
    var indexPath:IndexPath?
    var item:LBTableViewItem?
    weak var delegate:LBTableviewCellDelegate?
    
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.backgroundColor = UIColor.clear;
        self.contentView.backgroundColor = UIColor.clear;
        self.clipsToBounds = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    /// 在此方法内布局，布局之后可以设置item.itemHeight，
    /// warning: 此方法内不要调用self.width和self.height，宽度可以调用item.tableViewWidth
    func setupSubviews() {
        //DO NOTHING
    }
}
