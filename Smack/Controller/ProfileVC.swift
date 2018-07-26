//
//  ProfileVC.swift
//  Smack
//
//  Created by Pieter Kuijsten on 18/07/2018.
//  Copyright © 2018 Pieter Kuijsten. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileVC.newUserNameWasSet), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    
    func setupView() {
        userName.text = UserDataService.instance.name
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        userEmail.text = UserDataService.instance.email
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func newUserNameWasSet(_ notif: Notification) {
        setupView()
    }
    
    @IBAction func updateUserName(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let updateUserName = UpdateUserNameVC()
            updateUserName.modalPresentationStyle = .custom
            present(updateUserName, animated: true, completion: nil)

        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    
    
}
