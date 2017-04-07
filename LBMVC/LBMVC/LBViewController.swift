//
//  LBViewController.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/29.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class LBViewController: UIViewController, LBModelDelegate {

    init() {
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: model delegate
    func modelDidStart(model: LBModel!) {
        self.showLoading(model)
    }
    func modelDidFinish(model: LBModel!) {
        self.didLoadModel(model);
        if self.canShowModel(model) {
            self.showModel(model);
        } else {
            //MARK: discuss
            self.showEmpty(model);
        }
    }
    func modelDidFail(model: LBModel!, error: NSError!) {
        self.showError(error: error, model: model);
    }
    lazy var _modelDictInternal:Dictionary<String, LBModel> = [:];
    
    func registerModel(_ model:LBModel?) {
        if model != nil {
            assert(model?.key != nil, "model的key不能为空")
            model!.delegate = self;
            //MARK: discuss
            objc_sync_enter(self);
            self._modelDictInternal[model!.key] = model;
            objc_sync_exit(self);
        }
    }
    func unRegisterModel(_ model:LBModel?) {
        if model != nil {
            objc_sync_enter(self);
            model!.delegate = nil;
            self._modelDictInternal[model!.key] = nil;
            objc_sync_exit(self);
        }
    }
    func load() {
        for (_, model) in self._modelDictInternal {
            model.load();
        }
    }
    func reload() {
        for (_, model) in self._modelDictInternal {
            model.reload();
        }
    }
    func loadMore() {
        
    }
    deinit {
        objc_sync_enter(self);
        self._modelDictInternal.removeAll();
        objc_sync_exit(self);
    }
    //MARK: subclass override
    func didLoadModel(_ model:LBModel!) {}
    func canShowModel(_ model:LBModel!) -> Bool {
        return _modelDictInternal[model.key] != nil;
    }
    func showEmpty(_ model:LBModel!) {}
    func showModel(_ model:LBModel!) {}
    func showLoading(_ model:LBModel!) {}
    func showError(error:NSError!, model:LBModel!) {}
}
