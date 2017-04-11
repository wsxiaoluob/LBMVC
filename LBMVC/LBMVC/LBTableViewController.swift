//
//  LBTableViewController.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/30.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class LBTableViewController: LBViewController {
    
    override init() {
        super.init();
        self.tableView = UITableView.init(frame: CGRect.zero, style: self.tableViewStyle);
        self.tableView.isOpaque = true;
        self.tableView.separatorStyle = .none;
        self.tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
        self.tableView.dataSource = nil;
        self.tableView.delegate = nil;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public var tableView:UITableView!
    public var dataSource: LBTableViewDataSource!  {
        didSet {
            self.tableView.dataSource = dataSource;
            self.dataSource.controller = self;
        }
    }
    weak public var delegate:LBTableViewDelegate! {
        didSet {
            self.tableView.delegate = delegate;
            self.delegate.controller = self;
        }
    }
    
    public var keyModel:LBListModel?
    public var bNeedLoadMore:Bool = false;
    public var bNeedPullRefresh:Bool = false;
    public var clearItemsWhenModelReload:Bool = true;
    public var tableViewStyle:UITableViewStyle {
        get {
            return .plain;
        }
    }
    
    public func loadModelForSection(_ section:Int) {
        for index:Int in 0...self._modelDictInternal.count - 1 {
            let model:LBListModel = self._modelDictInternal[String(index)] as! LBListModel;
            if section == model.sectionNumber {
                model.load();
            }
        }
    }
    public func reloadModelForSection(_ section:Int) {
        for index:Int in 0...self._modelDictInternal.count - 1 {
            let model:LBListModel = self._modelDictInternal[String(index)] as! LBListModel;
            if section == model.sectionNumber {
                self.reloadTableView();
                model.reload();
            }
        }
    }
    public func loadModelByKey(_ key:String) {
        for (_key, model) in self._modelDictInternal {
            if key == _key {
                model.load();
            }
        }
    }
    public func reloadModelByKey(_ key:String) {
        for (_key, model) in self._modelDictInternal {
            if key == _key {
                self.dataSource.removeAllItems();
                self.reloadTableView();
                model.reload();
            }
        }
    }
    public func beginRefreshing() {
        self.delegate.beginRefresh();
    }
    public func endRefreshing() {
        self.delegate.endRefreshing();
    }
    public func showLocalModel(_ model:LBListModel) {
        self.dataSource.removeAllItems();
        self.didLoadModel(model);
        
        self.reloadTableView();
        self.tableView.tableFooterView = self.footerViewComplete;
        
        self.endRefreshing();
    }
    public func showNoResult(_ model:LBListModel) {
        self.endRefreshing();
        if model == self.keyModel {
            self.tableView.tableFooterView = self.footerViewNoResult;
        } else {
            //TODO: 处理非keymodel的empty状态
        }
    }
    
    public func showComplete(_ model:LBListModel) {
        if model == self.keyModel {
            self.tableView.tableFooterView = self.footerViewComplete;
        }
    }
    override func load() {
        assert(self.keyModel != nil, "至少需要指定一个keymodel");
        super.load();
    }
    override func reload() {
        assert(self.keyModel != nil, "至少需要指定一个keymodel");
    }
    override func loadMore() {
        if self.bNeedLoadMore {
            assert(self.keyModel != nil, "至少需要指定一个keymodel");
            if (self.keyModel?.hasMore)! {
                self.keyModel?.loadMore()
            }
        }
    }
    override func didLoadModel(_ model: LBModel!) {
        if model is LBListModel {
            let listModel:LBListModel = model as! LBListModel;
            let section:Int = (self.keyModel?.sectionNumber)!;
            if listModel.sectionNumber == section {
                if model == self.keyModel {
                    //TODO
                    self.dataSource.tableViewControllerDidLoadModel(listModel, ForSection: listModel.sectionNumber);
                } else {
                    //@discussion
                    //对于非keymodel带回来的数据，是否需要缓存在datasource中
                }
            } else {
                self.dataSource.tableViewControllerDidLoadModel(listModel, ForSection: listModel.sectionNumber);
            }
        }
        
    }
    override func canShowModel(_ model: LBModel!) -> Bool {
        guard super.canShowModel(model) else {
            return false;
        }
        var numberOfRows:Int = 0;
        var numberOfSection:Int = 0;
        
        numberOfSection = self.dataSource.numberOfSections(in: self.tableView);
        if numberOfSection == 0 {
            return false;
        }
        for index:Int in 0...numberOfSection {
            numberOfRows = self.dataSource.tableView(self.tableView, numberOfRowsInSection: index);
            if numberOfRows > 0 {
                break;
            }
        }
        if numberOfRows == 0 {
            return false;
        } else {
            //多个model注册同一个section，只有keymodel才能被显示
            if numberOfSection == 1 {
                return model == self.keyModel;
            }
            return false;
        }
    }
    override func showEmpty(_ model: LBModel!) {
        super.showEmpty(model);
        self.endRefreshing();
        self.showNoResult(model as! LBListModel);
    }
    override func showLoading(_ model: LBModel!) {
        if model == self.keyModel {
            self.tableView.tableFooterView = self.footerViewLoading;
        } else {
            //section model是否需要loading
        }
    }
    override func showModel(_ model: LBModel!) {
        super.showModel(model);
        self.reloadTableView();
        self.tableView.tableFooterView = self.footerViewComplete;
        self.endRefreshing();
    }
    override func showError(error: NSError!, model: LBModel!) {
        self.endRefreshing();
        let listModel:LBListModel = model as! LBListModel;
        if model == self.keyModel {
            if model.itemList?.array.count == 0 {
                if listModel.sectionNumber == 0 {
                    self.tableView.tableFooterView = LBTableViewFactory.getErrorFooterView(Frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.tableView.frame.size.height), Text: error.localizedDescription);
                } else {
                    self.tableView.tableFooterView = LBTableViewFactory.getErrorFooterView(Frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44), Text: error.localizedDescription);
                }
            } else {
                self.tableView.tableFooterView = nil;
            }
        } else {
            //section model 是否需要error
        }
    }
    //MARK: - private 
    var footerViewNoResult:UIView?
    var footerViewLoading:UIView?
    var footerViewComplete:UIView?
    var footerViewEmpty:UIView?
    var footerViewError:UIView?
    //MARK: - life cycle
    override func loadView() {
        super.loadView();
        self.footerViewNoResult = LBTableViewFactory.getNormalFooterView(Frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44), Text: "空空如也");
        self.footerViewLoading = LBTableViewFactory.getLoadingFooterView(Frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44), Text: "");
        self.footerViewError = LBTableViewFactory.getErrorFooterView(Frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44), Text: "加载失败");
        self.footerViewEmpty = LBTableViewFactory.getNormalFooterView(Frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44), Text: "");
        self.footerViewComplete = LBTableViewFactory.getNormalFooterView(Frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44), Text: "");
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.addSubview(self.tableView);
    }
    
    func reloadTableView() {
        self.tableView!.dataSource = self.dataSource;
        self.tableView!.delegate = self.delegate;
        self.tableView!.reloadData();
    }
    //MARK: - subclass override
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, component bundle:Dictionary<String, Any>) {
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
