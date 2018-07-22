//
//  AddChannelVC.swift
//  Smack
//
//  Created by Pieter Kuijsten on 22/07/2018.
//  Copyright © 2018 Pieter Kuijsten. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var channelDescText: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createChannelPressed(_ sender: Any) {
    }
    
    func setupView() {
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        channelDescText.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
