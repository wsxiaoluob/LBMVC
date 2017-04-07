//
//  LBTableViewFactory.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/31.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class LBTableViewFactory: NSObject {
    class public func getClickableFooter(Frame frame:CGRect, Text text:String, Target target:AnyObject, Action action:Selector) -> UIView! {
        let btn:UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        btn.backgroundColor = UIColor.clear;
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside);
        btn.setTitle(text, for: UIControlState.normal);
        btn.setTitleColor(UIColor.gray, for: UIControlState.normal);
        
        return btn
    }
    class public func getNormalFooterView(Frame frame:CGRect, Text text:String) -> UIView! {
        let view:UIView = UIView.init(frame: frame);
        let titleLabel:UILabel = UILabel.init(frame: frame);
        titleLabel.backgroundColor = UIColor.clear;
        titleLabel.text = text;
        titleLabel.font = UIFont.systemFont(ofSize: 16);
        titleLabel.textColor = UIColor.gray;
        titleLabel.textAlignment = NSTextAlignment.center;
        titleLabel.backgroundColor = UIColor.clear;
        view.backgroundColor = UIColor.clear;
        
        view.addSubview(titleLabel);
        return view;
    }
    class public func getLoadingFooterView(Frame frame:CGRect, Text text:String!) -> UIView! {
        let view = UIView.init(frame: frame);
        view.backgroundColor = UIColor.clear;
        
        let nsText = NSString.init(string: text);
        
        let textSize = nsText.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]);
        
        let titleLabel:UILabel = UILabel.init(frame: CGRect.init(x: (view.frame.size.width - textSize.width) / 2, y: (frame.size.height - textSize.height) / 2, width: textSize.width, height: textSize.height))
        
        titleLabel.backgroundColor = UIColor.clear;
        titleLabel.text = text;
        titleLabel.font = UIFont.systemFont(ofSize: 14);
        titleLabel.textColor = UIColor.gray;
        titleLabel.textAlignment = NSTextAlignment.center;
        
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray);
        activityIndicator.color = UIColor.gray;
        activityIndicator.backgroundColor = UIColor.clear;
        activityIndicator.startAnimating();
        
        if text.isEmpty {
            activityIndicator.frame = CGRect.init(x: (frame.size.width - 20) / 2, y: (frame.size.height - 20) / 2, width: 20, height: 20);
        } else {
            activityIndicator.frame = CGRect.init(x: titleLabel.frame.origin.x - 30, y: (frame.size.height - 20) / 2, width: 20, height: 20);
        }
        view.addSubview(titleLabel);
        view.addSubview(activityIndicator);
        return view;
    }
    class public func getErrorFooterView(Frame frame:CGRect, Text text:String) -> UIView! {
        let view = UIView.init(frame: frame);
        
        let titleLabel:UILabel = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: frame.size.width - 20, height: frame.size.height));
        titleLabel.backgroundColor = UIColor.clear;
        titleLabel.text = text;
        titleLabel.font = UIFont.systemFont(ofSize: 16);
        titleLabel.textColor = UIColor.gray;
        titleLabel.textAlignment = NSTextAlignment.center;
        titleLabel.backgroundColor = UIColor.clear;
        titleLabel.numberOfLines = 0;
        
        view.addSubview(titleLabel);
        
        return view;
    }
}
