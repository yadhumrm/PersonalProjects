//
//  PVErrorHandler.swift
//  PhotoViewer
//
//  Created by Yadhu Manoharan on 26/08/19.
//  Copyright © 2019 YadhuManoharan. All rights reserved.
//

import UIKit

class PVErrorHandler: NSObject {

    static func getErrorMessage(for error:Error) -> String{
        
        let nsError = error as NSError
        //YADHU-TODO: Handle error messages appropriately
        switch nsError.code {
        case 204:
            return "Sorry! No content to show."
        case 400...499:
            return "Sorry! Unable to get the content you requested."
        case 500...599:
            return "This service is temporarily unavailable! Please try after sometime."
        default:
            return "Something went wrong."
        }
    }    
    
}
