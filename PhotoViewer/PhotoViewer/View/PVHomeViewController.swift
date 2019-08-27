//
//  ViewController.swift
//  PhotoViewer
//
//  Created by Yadhu Manoharan on 25/08/19.
//  Copyright © 2019 YadhuManoharan. All rights reserved.
//

import UIKit

class PVHomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var photosList:[PVPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUIComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.homeCollectionView.reloadData()
    }
    
    func configureUIComponents(){
        let label = UILabel.init(frame: CGRect(x: 30, y: 0, width: 400, height: 60))
        label.font = UIFont.init(name: "Noteworthy", size: 25)
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        label.textColor = PVUtility.getColor(type: .buttonColor)
        label.text = "Photo viewer"
        self.navigationItem.titleView = label
        
        homeCollectionView?.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        if let layout = homeCollectionView?.collectionViewLayout as? PVCollectionViewLayout {
            layout.delegate = self
        }
    }

    func navigateToDetailView(with photo:PVPhoto){
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "PVDetailViewController") as! PVDetailViewController
        detailVC.photoModel = photo
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension PVHomeViewController: PVCollectionViewLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let photo = photosList[indexPath.row]
        return photo.photoSize ?? CGSize.init(width: 100, height: 100)
    }
}

extension PVHomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photosList[indexPath.row]
        navigateToDetailView(with: photo)
    }
}

extension PVHomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PVPhotoCollectionCell", for: indexPath) as! PVPhotoCollectionCell
        let photo = photosList[indexPath.row]
        cell.configureCell(photo: photo)
        return cell
    }
}

