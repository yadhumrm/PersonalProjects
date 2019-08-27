//
//  PVLaunchViewController.swift
//  PhotoViewer
//
//  Created by Yadhu Manoharan on 27/08/19.
//  Copyright © 2019 YadhuManoharan. All rights reserved.
//

import UIKit
import SVProgressHUD

class PVLaunchViewController: UIViewController {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var messageYConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnContinue: UIButton!
    
    //MARK: ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIComponents()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perform(#selector(animateUI), with: nil, afterDelay: 0.5)
    }
    
    //MARK: Private
    private func configureUIComponents(){
        
        lblMessage.text = NSLocalizedString("Welcome", comment: "")
        txtUserName.isHidden = true
        messageYConstraint.constant = 0
        btnContinue.isHidden = true
        
        btnContinue.layer.cornerRadius = btnContinue.frame.height/2
        btnContinue.layer.borderWidth = 3
        btnContinue.layer.masksToBounds = false
        btnContinue.layer.borderColor = PVUtility.getColor(type: .buttonColor).cgColor
        
        txtUserName.layer.shadowColor = PVUtility.getColor(type: .shadowColor).cgColor
        txtUserName.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        txtUserName.layer.shadowOpacity = 1
        txtUserName.layer.cornerRadius = txtUserName.frame.height/2
        txtUserName.layer.masksToBounds = true        
    }
    
    @objc private func animateUI(){
        self.messageYConstraint.constant = -50
        self.lblMessage.text = NSLocalizedString("Provide an 'unsplash' username", comment: "")
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
            
        }) { (completed) in
            if completed{
//                self.lblMessage.text = NSLocalizedString("Provide an 'unsplash' username", comment: "")
                self.txtUserName.isHidden = false
                self.btnContinue.isHidden = false
            }
        }
    }

    private func navigateToHomeView(with imageList:[PVPhoto]){
        let homeViewController = self.storyboard!.instantiateViewController(withIdentifier: "PVHomeViewController") as! PVHomeViewController
        homeViewController.photosList = imageList
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    //MARK: IBActions
    @IBAction func viewImagesAction(_ sender: Any) {
        SVProgressHUD.show()
        PVPhotoManager.shareManager.getMyPhotos { (list, err) in
            SVProgressHUD.dismiss()
            if let error = err{
                SVProgressHUD.showError(withStatus: PVErrorHandler.getErrorMessage(for: error))
            }else if let results = list{
                
                self.navigateToHomeView(with: results)
            }
        }
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
