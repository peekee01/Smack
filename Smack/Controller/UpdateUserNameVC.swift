//
//  updateUserName.swift
//  Smack
//
//  Created by Pieter Kuijsten on 24/07/2018.
//  Copyright © 2018 Pieter Kuijsten. All rights reserved.
//

import UIKit

class UpdateUserNameVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var currentUserNameLbl: UILabel!
    @IBOutlet weak var newUserNameTxt: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    
    //Variables
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateUserNameVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        setupView()
    }
    
    func setupView() {
        newUserNameTxt.attributedPlaceholder = NSAttributedString(string: "new username", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        currentUserNameLbl.text = UserDataService.instance.name
        avatarImage.image = UIImage(named: UserDataService.instance.avatarName)
        avatarImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(UpdateUserNameVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupView()
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNamePressed(_ sender: Any) {
        guard let newName = newUserNameTxt.text, newUserNameTxt.text != nil else { return }
        
        AuthService.instance.updateUserName(newUserName: newName) { (success) in
            if success {
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeModalBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectNewImagePressed(_ sender: Any) {
        let updateAvatarPicker = UpdateAvatarPickerVC()
        updateAvatarPicker.modalPresentationStyle = .custom
        present(updateAvatarPicker, animated: true, completion: nil)
    }
    
    @IBAction func generateNewAvatarColor(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        UserDataService.instance.setAvatarColor(avatarColor: avatarColor)
        UIView.animate(withDuration: 0.2) {
            self.avatarImage.backgroundColor = self.bgColor
        }
    }
    

}
