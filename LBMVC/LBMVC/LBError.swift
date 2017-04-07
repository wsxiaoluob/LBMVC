//
//  LBError.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/30.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

public protocol LBError: Error {
    var errorDomain: String {get}
    var errorCode: Int {get}
    var errorUserInfo: [String:Any] {get}
}
