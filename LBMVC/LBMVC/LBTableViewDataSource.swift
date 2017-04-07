//
//  LBTableViewDataSource.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/30.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class LBTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    public func tableViewControllerDidLoadModel(_ model:LBListModel, ForSection section:Int) {
        if model.itemList != nil {
            self.set(Items: model.itemList!.array as! Array<LBItem>, ForSection: section);
        }
    }
    public func cellClassFor(Item item:LBTableViewItem?, AtIndex indexPath:IndexPath) -> LBTableViewCell.Type {
        return LBTableViewCell.self;
    }
    public func itemForCell(AtIndex indexPath:IndexPath) -> LBTableViewItem! {
        let items:Array<LBItem>? = self._itemsForSectionInternal[String(indexPath.section)];
        var item:LBTableViewItem! = LBTableViewItem.init();
        if items != nil && indexPath.row < items!.count {
            item = items![indexPath.row] as? LBTableViewItem;
        }
        return item;
    }
    var controller:LBTableViewController?;
    var itemForSection:Dictionary<String, Array<LBItem>> {
        get {
            return self._itemsForSectionInternal;
        }
    }
    
    public func set(Items items:Array<LBItem>, ForSection section:Int) {
        if section >= 0 {
            self._itemsForSectionInternal[String(section)] = items;
        }
    }
    public func getItems(Section section:Int) -> Array<LBItem>? {
        if section >= 0 {
            return self._itemsForSectionInternal[String(section)];
        }
        return nil;
    }
    public func remove(Object object:LBItem, ForSection section:Int) -> Bool {
        if section >= 0 {
            if var array:Array = self._itemsForSectionInternal[String(section)] {
                for (index, value) in array.enumerated() {
                    if value == object {
                        array.remove(at: index);
                        return true;
                    }
                }
            }
        }
        return false;
    }
    public func removeItemsForSection(_ section:Int) {
        if section >= 0 {
            self._itemsForSectionInternal[String(section)] = nil
        }
    }
    public func removeAllItems() {
        self._itemsForSectionInternal.removeAll();
    }
    private var _itemsForSectionInternal:Dictionary<String, Array<LBItem>> = [:];
    
    deinit {
        self.controller = nil
        self._itemsForSectionInternal.removeAll();
    }
    //MARK: tableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items:Array? = self._itemsForSectionInternal[String(section)];
        return items != nil ? items!.count : 0;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "";
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "";
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.controller?.tableView(tableView, commit: editingStyle, forRowAt: indexPath);
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item:LBTableViewItem? = self.itemForCell(AtIndex: indexPath);
        let cellClass:LBTableViewCell.Type = self.cellClassFor(Item: item, AtIndex: indexPath);
        let identifiler:String = String(describing: cellClass);
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifiler);
        if cell == nil {
            cell = cellClass.init(style: .default, reuseIdentifier: identifiler);
            cell!.selectionStyle = .none;
        }
        if cell is LBTableViewCell {
            let customCell:LBTableViewCell! = cell as! LBTableViewCell;
            customCell.indexPath = indexPath;
            customCell.delegate = tableView.delegate as! LBTableviewCellDelegate!;
            if item != nil {
                item?.indexPath = indexPath;
                customCell.item = item!;
            } else {
                //TODO: 异常处理
            }
        }
        return cell!;
    }
}
