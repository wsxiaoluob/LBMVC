//
//  LBTableViewDelegate.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/30.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

protocol LBListPullRefreshViewDelegate {
    func scrollviewDidScroll(scrollview:UIScrollView)
    func scrollviewDidEndDragging(scrollview:UIScrollView)
    func startRefreshing()
    func endRefreshing()
}

class LBTableViewDelegate: NSObject, UITableViewDelegate, LBTableviewCellDelegate {
    weak var controller: LBTableViewController?;
    var pullRefreshView: LBListPullRefreshViewDelegate? {
        didSet {
            if self.pullRefreshView != nil {
                self.controller?.tableView.addSubview(self.pullRefreshView as! UIView);
            } else {
                let pullView:UIView? = self.pullRefreshView as? UIView;
                pullView?.removeFromSuperview();
            }
        }
    };
    lazy var pullRefreshViewInternal: LBListDefaultPullRefreshView! = {() -> LBListDefaultPullRefreshView in
        if self.controller != nil {
            var bounds:CGRect = self.controller!.tableView.bounds;
            var _pullRefreshViewInternal = LBListDefaultPullRefreshView.init(frame: CGRect.init(x: 0, y: 0 - kRefreshViewHeight, width: bounds.size.width, height: kRefreshViewHeight));
            _pullRefreshViewInternal.backgroundColor = self.controller!.tableView.backgroundColor;
            _pullRefreshViewInternal.controller = self.controller!;
            self.controller!.tableView.addSubview(_pullRefreshViewInternal)
            return _pullRefreshViewInternal;
        }
        
        return LBListDefaultPullRefreshView.init(frame: .zero);
    }()
    func beginRefresh() {
        if self.controller != nil && self.controller!.bNeedPullRefresh {
            self.pullRefreshView?.startRefreshing();
        }
    }
    func endRefreshing() {
        if self.controller != nil && self.controller!.bNeedPullRefresh {
            self.pullRefreshView?.endRefreshing();
        }
    }
    func onCellComponentClicked(AtIndex index: IndexPath!, bundle extra: Dictionary<String, Any>?) {
        guard self.controller != nil else {
            return;
        }
        if extra == nil {
            self.controller!.tableView(self.controller!.tableView, didSelectRowAt: index);
        } else {
            self.controller!.tableView(self.controller!.tableView, didSelectRowAt: index, component: extra!);
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controller?.tableView(tableView, didSelectRowAt: indexPath);
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.dataSource is LBTableViewDataSource {
            let dataSource:LBTableViewDataSource = tableView.dataSource as! LBTableViewDataSource;
            let item:LBTableViewItem = dataSource.itemForCell(AtIndex: indexPath)!;
            if item.itemHeight > 0 {
                return item.itemHeight;
            }
        }
        return 100;
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.controller != nil else {
            return;
        }
        let sections = self.controller!.dataSource.numberOfSections(in: tableView);
        if indexPath.section == Int(sections - 1) {
            let items = self.controller!.dataSource.getItems(Section: indexPath.section);
            if items != nil && indexPath.row == items!.count - 1 {
                self.controller!.loadMore();
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "";
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if self.controller != nil && self.controller!.isEditing {
            return .none;
        } else {
            return .delete;
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.controller != nil {
            if self.controller!.bNeedPullRefresh {
                self.pullRefreshView?.scrollviewDidScroll(scrollview: scrollView);
            }
            self.controller!.scrollViewDidScroll(scrollView);
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.controller != nil else {
            return;
        }
        if self.controller!.bNeedPullRefresh {
            self.pullRefreshView?.scrollviewDidEndDragging(scrollview: scrollView);
        }
        self.controller!.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate);
    }
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if self.controller != nil {
            self.controller!.scrollViewShouldScrollToTop(scrollView);
        }
        return true;
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.controller?.scrollViewWillBeginDragging(scrollView);
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.controller?.scrollViewDidEndDecelerating(scrollView);
    }
    
}

enum PullRefreshState {
    case idle, pulling, loading
}

let kRefreshViewHeight:CGFloat = 40.0;

class LBListDefaultPullRefreshView: UIView, LBListPullRefreshViewDelegate {
    var state:PullRefreshState?;
    var indicator:UIActivityIndicatorView?;
    var textLabel:UILabel?;
    var progress:Float = 0;
    var bRefreshing:Bool = false;
    weak var controller: LBTableViewController?;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.state = .idle;
        let width = frame.size.width;
        let height = frame.size.height;
        
        let orix = (width - 100) / 2;
        
        let _textLabel:UILabel! = UILabel.init(frame: CGRect.init(x: orix, y: 0, width: 100, height: height));
        _textLabel.autoresizingMask = .flexibleHeight;
        _textLabel.textAlignment = .center;
        _textLabel.textColor = UIColor.gray;
        _textLabel.font = UIFont.systemFont(ofSize: 12);
        _textLabel.backgroundColor = UIColor.clear;
        _textLabel.text = "下拉刷新"
        
        self.textLabel = _textLabel;
        self.addSubview(self.textLabel!);
        
        let _indicator = UIActivityIndicatorView.init(frame: CGRect.init(x: (width - 20) / 2, y: 0, width: 20, height: height));
        _indicator.activityIndicatorViewStyle = .gray;
        _indicator.isHidden = true;
        self.indicator = _indicator;
        
        self.addSubview(self.indicator!);
    }
    func scrollviewDidScroll(scrollview: UIScrollView) {
        if self.bRefreshing {
            if scrollview.contentOffset.y >= 0 {
                scrollview.contentInset = .zero;
            } else {
                scrollview.contentInset = UIEdgeInsets.init(top: min(-scrollview.contentOffset.y, kRefreshViewHeight), left: 0, bottom: 0, right: 0);
            }
        } else {
            let visibleHeight:CGFloat = max(-scrollview.contentOffset.y - scrollview.contentInset.top, 0);
            self.progress = Float(min(max(visibleHeight / kRefreshViewHeight, 0), CGFloat(1)));
            if visibleHeight > kRefreshViewHeight {
                self.textLabel?.text = "松开即可刷新";
            } else {
                self.textLabel?.text = "下拉刷新";
            }
        }
        var frame:CGRect = self.frame;
        frame.size.height = max(-scrollview.contentOffset.y, kRefreshViewHeight);
        frame.origin.y = -frame.size.height;
        self.frame = frame;
    }
    func scrollviewDidEndDragging(scrollview: UIScrollView) {
        if self.progress >= 1.0 && !self.bRefreshing {
            self.startRefreshing()
        }
    }
    func startRefreshing() {
        let scrollView:UIScrollView = self.superview as! UIScrollView;
        if !self.bRefreshing {
            self.bRefreshing = true;
            self.textLabel?.text = nil;
            self.indicator?.isHidden = false;
            self.indicator?.startAnimating();
            UIView.animate(withDuration: 0.3, animations: { 
                var inset:UIEdgeInsets = scrollView.contentInset;
                inset.top = kRefreshViewHeight;
                scrollView.contentInset = inset;
                scrollView.contentOffset = CGPoint.init(x: 0, y: 0 - kRefreshViewHeight);
            }, completion: { (finished:Bool) in
                DispatchQueue.perform(#selector(self.controller?.reload), with: nil, afterDelay: 0.3);
            })
        }
    }
    func endRefreshing() {
        let scrollView:UIScrollView = self.superview as! UIScrollView;
        if self.bRefreshing {
            UIView.animate(withDuration: 0.3, animations: { 
                var inset:UIEdgeInsets = scrollView.contentInset;
                inset.top = 0;
                scrollView.contentInset = inset;
            }, completion: { (finished:Bool) in
                self.bRefreshing = false;
                self.textLabel?.text = "下拉刷新";
                self.indicator?.isHidden = true;
                self.indicator?.stopAnimating();
            })
        } else {
            var inset:UIEdgeInsets = scrollView.contentInset;
            inset.top = 0;
            scrollView.contentInset = inset;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
}
