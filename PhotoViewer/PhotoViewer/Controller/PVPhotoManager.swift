//
//  PhotoManager.swift
//  PhotoViewer
//
//  Created by Yadhu Manoharan on 25/08/19.
//  Copyright © 2019 YadhuManoharan. All rights reserved.
//

import UIKit
import Networking

fileprivate let accessKey = "9da242ad85084ad7ca951738b8e7d9478fd637ba6d41cf835be09e7e1628c9dc"
//fileprivate let accessKey = "e3e4ea1cea5f69938efbff107b709d415e0ab0f480661867e4af928ff32010c6"
fileprivate let secKey = "7ad93cf21e1cc7e82cde34c28284fcac2d242e6db1318240155acb138812b911"

fileprivate let myUserName:String = "yadhum900"//"brianhaferkamp"

class PVPhotoManager: NSObject {

    static let shareManager = PVPhotoManager()
    var overrideUserName:String?
    private var userName:String{
        get{
            if let name = overrideUserName{
                if !name.isEmpty{
                    return name
                }
            }
            return myUserName
        }
    }
    var networking:Networking!
    
    
    //MARK: - initialisation
    private override init() {
        super.init()
        self.setupNetworking()
    }    
    
    private func setupNetworking(){
        networking = Networking(baseURL: "https://api.unsplash.com/")
    }
    
    //MARK: - Public
    func getMyPhotos(completion:@escaping ([PVPhoto]?,Error?)->()) {
        let path = "users/\(userName)/likes/?client_id=\(accessKey)"
        networking.get(path) { (result) in
            
            switch result{
            case .success(let successJson):
                let result = self.parsePhotoListJsonResponse(responseArray: successJson.arrayBody)
                completion(result, nil)
                
            case .failure(let failureJson):
                completion(nil, failureJson.error)
            }
        }
    }
    
    
    //MARK: - Parser
    private func parsePhotoListJsonResponse(responseArray : [[String: Any]]) -> [PVPhoto] {
        var result:[PVPhoto] = []
        for content in responseArray {
            if let pId = content["id"] as? String { //Consider as mandatory param
                let width   = content["width"] as? Double
                let height  = content["height"] as? Double
                let desc    = content["description"] as? String
                let large   = (content["urls"] as? [String : String])? ["full"]
                let medium  = (content["urls"] as? [String : String])? ["regular"]
                let small   = (content["urls"] as? [String : String])? ["small"]
                let thumb   = (content["urls"] as? [String : String])? ["thumb"]
                
                var size:CGSize? = nil
                if let pWidth = width, let pHeight = height{
                    size = CGSize.init(width: pWidth, height: pHeight)
                }
                
                let photo = PVPhoto.init(with: pId, size: size, large: large, medium: medium, small: small, thumb: thumb, descriptionText: desc)
                result.append(photo)
            }
        }
        return result
    }
    
}
