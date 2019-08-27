//
//  PVPhotoCollectionCell.swift
//  PhotoViewer
//
//  Created by Yadhu Manoharan on 27/08/19.
//  Copyright © 2019 YadhuManoharan. All rights reserved.
//

import UIKit
import Networking

class PVPhotoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgContentPhoto: UIImageView!
 
    func configureCell(photo:PVPhoto) {
        if let photoURL = photo.thumbURL, let _ = PVPhotoManager.shareManager.networking{
            guard let url = URL.init(string: photoURL) else{
                return
            }
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, err) in
                if let imageData = data{
                    DispatchQueue.main.async {
                        self?.imgContentPhoto.image = UIImage.init(data: imageData)
                    }
                }
            }            
            task.resume()
        }
    }
    
}
