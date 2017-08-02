//
//  LBItem.swift
//  LBMVC
//
//  Created by 萝卜 on 2017/3/29.
//  Copyright © 2017年 萝卜. All rights reserved.
//

import UIKit

class LBItem: NSObject {
    
    func autoKVCBinding(_ dictionary:Dictionary<String, Any>?) {
        if dictionary != nil {
            let mirror:Mirror = Mirror(reflecting: self);
            let properties = self.properties(mirror);
            for property in properties {
                guard property.propertyName != nil && property.propertyType != nil && dictionary![property.propertyName!] != nil else {
                    continue;
                }
                let value = dictionary![property.propertyName!]!;
                let valueType = String(describing: Mirror(reflecting: value).subjectType);
                
                var ret:Any?;
                switch property.propertyType! {
                case .string: fallthrough
                case .int:fallthrough
                case .double:fallthrough
                case .bool:
                    ret = self.generateRet(value: value, retType: property.propertyType!);
                case .array:
                    if valueType.hasPrefix("Array") {
                        let arrayClassName = valueType.substring(with: valueType.index(valueType.startIndex, offsetBy: 6)..<valueType.index(valueType.endIndex, offsetBy: -1));
                        if arrayClassName.hasPrefix("Dictionary<String") {
//                            let dicClassName = arrayClassName.substring(with: arrayClassName.index(arrayClassName.startIndex, offsetBy: 19)..<arrayClassName.index(arrayClassName.endIndex, offsetBy: -1));
                            if property.arrayClass != nil && property.arrayClass == .item {
                                ret = type(of: self).itemsWithArray(value as! Array<Dictionary<String, Any>>);
                            } else  {
                                //arrayClass不是item，无需作数组泛型KVC，直接赋值，此处有因为Dictionary的泛型不一致导致的crash风险，待处理
                                ret = value;
                            }
                        } else {
                            ret = value;
                        }
                    }
                case .dictionary:
                    if valueType.hasPrefix("Dictionary<String") {
                        ret = dictionary;
                    }
                case .item:
                    if valueType.hasPrefix("Dictionary<String") {
                        ret = type(of: self).itemWithDictionary(value as! Dictionary<String, Any>);
                    }
                default:
                    break;
                }
                //若转换出错不改变原值
                if ret != nil {
                    self.setValue(ret, forKey: property.propertyName!);
                }
            }
//            for (label,value) in mirror.children {
//                if label != nil && dictionary![label!] != nil {
//                    if value is LBItem && dictionary![label!] is Dictionary<String, Any> {
//                        let subItem = value as! LBItem;
//                        subItem.autoKVCBinding(dictionary![label!] as? Dictionary<String, Any>);
//                    } else {
//                        self.setValue(dictionary![label!], forKey: label!);
//                    }
//                }
//            }
        }
//        self.doArrayMemberKVC(array: []);
    }
    func generateRet(value:Any, retType:LBItemPropertyType) -> Any? {
        var ret:Any?;
        switch retType {
        case .string:
            ret = "\(value)";
        case .int:
            ret = Int.init("\(value)");
        case .double:
            ret = Double.init("\(value)");
        case .bool:
            if value is NSNumber {
                ret = Bool.init(value as! NSNumber);
            } else {
                ret = Bool.init("\(value)");
            }
        default: break
            //DONOTHING
        }
        return ret;
    }
    func properties(_ mirror:Mirror) -> [LBItemProperty] {
        var ret = [LBItemProperty]();
        for (label, value) in mirror.children {
            if label != nil {
                let subMirror = Mirror(reflecting:value);
                ret.append(LBItemProperty.init(label!, String.init(describing: subMirror.subjectType)))
            }
        }
        if mirror.superclassMirror != nil && !String.init(describing: mirror.superclassMirror!.subjectType).hasPrefix("NS") {
            ret.append(contentsOf: self.properties(mirror.superclassMirror!));
        }
        return ret;
    }
    func doArrayMemberKVC<T>(array:Array<T>) {
        var count:UInt32 = 0;
        let properties = class_copyPropertyList(type(of: self), &count);
        for i in 0..<count {
            let property = properties![Int(i)];
            let attributeString = String.init(cString: property_getAttributes(property));
            
            print(attributeString);
        }
    }
    class func itemsWithArray(_ array:Array<Dictionary<String, Any>>) -> Array<LBItem> {
        //TODO: Any格式的解析
        var ret:Array<LBItem> = [];
        for dic:Dictionary<String, Any> in array {
            let item = self.init();
            item.autoKVCBinding(dic);
            ret.append(item);
        }
        return ret;
    }
    class func itemWithDictionary(_ dic:Dictionary<String, Any>) -> Self {
        let item = self.init();
        item.autoKVCBinding(dic);
        return item;
    }
    required override init() {
        super.init()
    }
}
