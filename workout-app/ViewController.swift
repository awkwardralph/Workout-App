//
//  ViewController.swift
//  workout-app
//
//  Created by Ralph Lee on 4/10/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repTextField: UITextField!
    @IBOutlet weak var setTextField: UITextField!
    

    override func viewDidLoad() {
        setUpToolbar()
        weightTextField.keyboardType = .numberPad
        
        repTextField.keyboardType = .numberPad
        
        setTextField.keyboardType = .numberPad
        
        weightTextField.delegate = self
        repTextField.delegate = self
        setTextField.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setUpToolbar() {
        let bar = UIToolbar()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneTapped))
        bar.items = [flexible, done]
        bar.sizeToFit()
        weightTextField.inputAccessoryView = bar
        repTextField.inputAccessoryView = bar
        setTextField.inputAccessoryView = bar
    }
    
    //MARK - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For numers
        if textField == weightTextField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    @objc func doneTapped() {
        if weightTextField.isFirstResponder {
            self.view.endEditing(true)
            repTextField.becomeFirstResponder()
        } else if repTextField.isFirstResponder {
            self.view.endEditing(true)
            setTextField.becomeFirstResponder()
        } else if setTextField.isFirstResponder {
            self.view.endEditing(true)
        }
        
    }

}

