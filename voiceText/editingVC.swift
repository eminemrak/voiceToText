//
//  editingVC.swift
//  voiceText
//
//  Created by Eminko on 26.06.2023.
//

import UIKit

class editingVC: UIViewController {
    
    @IBOutlet weak var uiTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var discardButton: UIButton!
    var textt = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiTextView.text = textt
        
        uiTextView.layer.borderWidth = 1.0
        uiTextView.layer.borderColor = UIColor(named: "dark-brown-2")?.cgColor
        
        uiTextView.layer.cornerRadius = 20
        
        discardButton.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 12)
        saveButton.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 12)
        
        
        discardButton.setTitleColor(UIColor(named: "backgraund"), for: .normal)
        saveButton.setTitleColor(UIColor(named: "backgraund"), for: .normal)
        discardButton.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
        
    }
    
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name("VeriAktarildi"), object: nil, userInfo: ["veri": uiTextView.text])
        showAlert(title: "Değişiklikler kaydedildi!", message: "Değişiklikler kaydedildi!", okTitle: "Tamam!")
        
    }
    
    
    
    @IBAction func discardButton(_ sender: Any) {
        uiTextView.text = textt
        showAlert(title: "Değişiklikler silindi!", message: "Değişiklikler silindi!", okTitle: "Tamam!")
    }
    
    
    
    func showAlert(title: String, message: String, okTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        //0.6saniye sonra alert sona ericek.
        let when = DispatchTime.now() + 0.6
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
}
