//
//  PVDetailViewController.swift
//  PhotoViewer
//
//  Created by Yadhu Manoharan on 28/08/19.
//  Copyright © 2019 YadhuManoharan. All rights reserved.
//

import UIKit
import SVProgressHUD

class PVDetailViewController: UIViewController {
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lblDecription: UILabel!
    
    var photoModel:PVPhoto!
    var imageData:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUIComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchImage()
    }
    
    func configureUIComponents(){
        
        let label = UILabel.init(frame: CGRect(x: 30, y: 0, width: 400, height: 60))
        label.font = UIFont.init(name: "Noteworthy", size: 25)
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        label.textColor = PVUtility.getColor(type: .buttonColor)
        label.text = "Photo viewer"
        self.navigationItem.titleView = label
        
        btnDownload.isUserInteractionEnabled = false
        btnDownload.alpha = 0.5
        lblDecription.text = photoModel.descriptionString ?? NSLocalizedString("No description available", comment: "")
        lblDecription.textColor = photoModel.descriptionString != nil ? PVUtility.getColor(type: .buttonColor) : .lightGray
        imgPhoto.layer.borderWidth = 2
        imgPhoto.layer.borderColor = PVUtility.getColor(type: .buttonColor).cgColor
        
        btnDownload.layer.cornerRadius = btnDownload.frame.height/2
        btnDownload.layer.borderWidth = 2
        btnDownload.layer.masksToBounds = false
        btnDownload.layer.borderColor = PVUtility.getColor(type: .buttonColor).cgColor
    }
    
    
    func fetchImage(){
        guard let urlString = photoModel.mainURL else{
            return
        }
        if let url = URL.init(string: urlString) {
            SVProgressHUD.show()
            let task =  URLSession.shared.dataTask(with: url) { [weak self] (data, _, err) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    if let imageData = data{
                        let image = UIImage.init(data: imageData)
                        self?.imageData = image
                        self?.imgPhoto.image  = image
                        self?.btnDownload.isUserInteractionEnabled = true
                        self?.btnDownload.alpha = 1
                    }
                }
            }
            task.resume()
        }
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        guard let image = imageData else{
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageDidFinishSaving(image:error:contextInfo:)), nil)
    }
    
    @objc func imageDidFinishSaving(image:UIImage?, error:Error?, contextInfo:Any){
        SVProgressHUD.showSuccess(withStatus: NSLocalizedString("Image saved to library", comment: ""))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
