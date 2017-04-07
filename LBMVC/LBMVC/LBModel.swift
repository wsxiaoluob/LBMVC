//
//  LBModel.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/27.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

typealias LBModelCallback = (_ model:LBModel?, _ error: NSError?) -> Void

enum LBModelState {
    case Error
    case Ready
    case Loading
    case Finished
}
enum LBModelMode {
    case load
    case reload
    case loadMore
}

protocol LBModelDelegate {
    func modelDidStart(model:LBModel!)
    func modelDidFinish(model:LBModel!)
    func modelDidFail(model:LBModel!, error:NSError!)
}

class LBModel: NSObject, LBRequestDelegate {

    //MARK: override相关
    public func dataParams() -> Dictionary<String, Any>? {
        return nil;
    }
    public func urlPath() -> String? {
        return nil;
    }
    public func parseResponse(object:Any?, error: inout NSError?) -> Array<AnyObject>? {
        return nil;
    }
    public func prepareForLoad() -> Bool {
        return true;
    }
    public func prepareParseResponse(object:Any?, error: inout NSError?) -> Bool {
        return true;
    }
    public func headerParams() -> Dictionary<String, String>? {
        return nil;
    }
    public func useCache() -> Bool {
        return false;
    }
    public func useAuth() -> Bool {
        return false;
    }
    public func needManualLogin() -> Bool {
        return true;
    }
    public func apiCacheTimeOutSeconds() -> TimeInterval {
        return TimeInterval(CGFloat.greatestFiniteMagnitude);
        
    }
    public func customRequestClassName() -> String! {
        return "LBRequest";
    }
    public func bodyData() -> Dictionary<String, Any>? {
        return nil;
    }
    public func usePost() -> Bool {
        return false
    }
    private(set) var state:LBModelState = .Ready
    
    private(set) var mode:LBModelMode = .load
    
    var delegate:LBModelDelegate?
    
    var requestCallback:LBModelCallback?
    
    var request:LBRequest!
    
    var itemList:LBItemList! = LBItemList.init()
    var item:AnyObject?
    var error:NSError?
    var key:String! {
        get {
            return NSString.init(utf8String: object_getClassName(self))! as String;
        }
    }
    var isFromCache:Bool = false
    var responseObject:Any?
    var responseString:String?
    var cacheKey:String?
    
    func load() {
        self.mode = LBModelMode.load;
        self.reset();
        
        if self._prepareForload() {
            self.loadInternal();
        }
        
    }
    func load(completion: @escaping LBModelCallback) {
        self.requestCallback = completion;
        self.load();
    }
    func reload() {
        self.mode = .reload;
        self.reset();
        if self._prepareForload() {
            self.loadInternal();
        }
    }
    func reload(completion: @escaping LBModelCallback) {
        self.requestCallback = completion;
        self.reload();
    }
    func loadMore() {
        self.mode = .loadMore;
        self.loadInternal();
    }
    func reset() {
        self.cancel();
        self.itemList?.reset();
    }
    func _prepareForload() -> Bool {
        if self.urlPath() != nil {
            if self.state == .Loading {
                self.cancel();
            }
            return self.prepareForLoad();
        } else {
            let error:NSError = NSError.init(domain: "domain", code: 999, userInfo:[NSLocalizedDescriptionKey: "缺少方法名"]);
            self.requestDidFailWithError(error: error);
            return false;
        }
    }
    func cancel() {
        if self.request != nil {
            self.request.cancel();
            self.request = nil;
            self.state = .Ready;
        }
    }
    
    //MARK: private
    func loadInternal() {
        self.error = nil;
        let dataParams = self.dataParams();
        self.request = LBAFRequest();
        self.request.useAuth = self.useAuth();
        self.request.useCache = self.mode == LBModelMode.load && self.useCache();
        self.request.delegate = self;
        self.request.usePost = self.usePost();
        self.request.apiCacheTimeOutSeconds = self.apiCacheTimeOutSeconds();
        self.request.mode = self.mode;
        
        self.request.setup(baseUrl: self.urlPath())
        
        self.request.addParams(params:dataParams, forKey: "data");
        self.request.addHeaderParams(params: self.headerParams());
        
        if self.usePost() {
            self.request.addBodyData(data: self.bodyData(), forKey: "file");
        }
        
        DispatchQueue.global(qos:.default).async {
            self.request.load()
        }
    }
    func requestDidStartLoad(request: LBRequest!) {
        self.state = LBModelState.Loading;
        //TODO: respondesToSelector
        self.delegate?.modelDidStart(model: self);
    }
    func requestDidFinish(JSON: Any!) {
        self.isFromCache = self.request.isFromCache;
        
        self.state = .Finished;
        
        self.responseObject = self.request.responseObject;
        self.responseString = self.request.responseString;
        self.cacheKey = self.request.cacheKey;
        
        if self.parse(JSON) {
            self.delegate?.modelDidFinish(model: self);
            
            if self.requestCallback != nil {
                self.requestCallback!(self, nil);
                self.requestCallback = nil;
            }
        }
    }
    func requestDidFailWithError(error: NSError?) {
        self.isFromCache = self.request.isFromCache;
        self.state = .Error;
        self.error = error;
        
        self.responseString = self.request.responseString;
        self.responseObject = self.request.responseObject;
    }
    func parse(_ JSON:Any?) -> Bool {
        var error:NSError? = nil;
        if !self.prepareParseResponse(object: JSON, error: &error) && (error != nil) {
            self.requestDidFailWithError(error: error);
            return false;
        }
        
        let list:Array<AnyObject>? = self.parseResponse(object: JSON, error: &error);
        if error != nil {
            self.requestDidFailWithError(error: error);
            return false;
        } else {
            self.itemList?.addObjectFromArray(otherArray: list);
            return true;
        }
    }
    func isLoading() -> Bool {
        return self.state == .Loading;
    }
}



















