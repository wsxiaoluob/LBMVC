//
//  ViewController.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/27.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class DemoViewController: LBTableViewController {
    var model:DemoModel! = DemoModel.init();
    var ds:DemoDataSource = DemoDataSource.init();
    var dl:LBTableViewDelegate = LBTableViewDelegate.init();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "demo"
        self.tableView.frame = self.view.bounds;
        
        self.dataSource = self.ds;
        self.delegate = self.dl;
        
        self.registerModel(self.model);
        self.keyModel = self.model;
        
        self.load();
    }
}

