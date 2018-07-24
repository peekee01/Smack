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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        newUserNameTxt.attributedPlaceholder = NSAttributedString(string: "new username", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        currentUserNameLbl.text = UserDataService.instance.name
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(UpdateUserNameVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNamePressed(_ sender: Any) {
    }
    
    @IBAction func closeModalBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
