//
//  PVPhoto.swift
//  PhotoViewer
//
//  Created by Yadhu Manoharan on 25/08/19.
//  Copyright © 2019 YadhuManoharan. All rights reserved.
//

import UIKit

class PVPhoto: NSObject {

    var photoId:String
    var photoSize:CGSize?
    private var largeURL:String?
    private var mediumURL:String?
    private var smallURL:String?
    var thumbURL:String?
    var descriptionString:String?
    
    var mainURL:String?{
        get{
            return largeURL
        }
    }
    
    init(with id:String, size:CGSize?, large:String?, medium:String?, small:String?, thumb:String?, descriptionText:String?) {
        self.photoId = id
        self.photoSize = size
        self.largeURL = large
        self.mediumURL = medium
        self.smallURL = small
        self.thumbURL = thumb
        self.descriptionString = descriptionText
        
        super.init()
    }
    
}
