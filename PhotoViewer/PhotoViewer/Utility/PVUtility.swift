//
//  PVUtility.swift
//  PhotoViewer
//
//  Created by Yadhu Manoharan on 27/08/19.
//  Copyright © 2019 YadhuManoharan. All rights reserved.
//

import UIKit

enum kColorType {
    case shadowColor
    case buttonColor
}

class PVUtility: NSObject {

    static func getColor(type: kColorType) -> UIColor{
        
        switch type {
        case .shadowColor:
            return UIColor.lightGray
        case .buttonColor:
            return UIColor.init(red: 2/234, green: 56/234, blue: 46/234, alpha: 1)
        
        default:
            return .white
        }
    }
}
