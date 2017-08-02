//
//  LBItemProperty.swift
//  MeidaShare
//
//  Created by 萝卜 on 2017/7/27.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

enum LBItemPropertyType {
    case int, double, bool, string, array, dictionary, any, item
}

class LBItemProperty {
    var propertyName:String?
    var propertyType:LBItemPropertyType?
    var arrayClass:LBItemPropertyType?
    var dicValueClass:LBItemPropertyType?
    init(_ propertyName:String, _ propertyType:String) {
        self.propertyName = propertyName;
        self.propertyType = self.getPropertyType(propertyType);
    }
    func getPropertyType(_ typeName:String) -> LBItemPropertyType {
        if let srcClass = NSClassFromString(typeName) {
            if srcClass.isSubclass(of: LBItem.self) {
                return .item;
            } else {
                return .any;
            }
        } else {
            switch typeName {
                case "String":
                    return .string;
                case "Int":
                    return .int;
                case "Double":
                    return .double;
                case "Bool":
                    return .bool;
                case _ where typeName.hasPrefix("Array"):
                    //Array<Any>
                    let arrayClassName = typeName.substring(with: typeName.index(typeName.startIndex, offsetBy: 6)..<typeName.index(typeName.endIndex, offsetBy: -1));
                    //只取第一个泛型，不递归
                    if self.arrayClass == nil {
                        self.arrayClass = self.getPropertyType(arrayClassName);
                    }
                    return .array;
                case _ where typeName.hasPrefix("Dictionary"):
                    //Dictionary<String,Any>，排除掉key不是string类型的dictionary
                    if typeName.characters.count > 19 {
                        let dicClassName = typeName.substring(with: typeName.index(typeName.startIndex, offsetBy: 19)..<typeName.index(typeName.endIndex, offsetBy: -1));
                        //只取第一层泛型
                        if self.dicValueClass == nil {
                            self.dicValueClass = self.getPropertyType(dicClassName);
                        }
                    }
                    return .dictionary;
                default:
                    return .any;
            }
        }
    }
}
