//
//  ViewController.swift
//  workout-app
//
//  Created by Ralph Lee on 4/10/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    var workouts: [Workout] = []
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repTextField: UITextField!
    @IBOutlet weak var setTextField: UITextField!
    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var resultsTextView: UITextView!
    @IBOutlet weak var confirmationButton: UIButton!
    
    let tableView = TableViewController()
    
    @IBAction func editButtonTouched(_ sender: Any) {
        exerciseTextField.becomeFirstResponder()
    }
    
    @IBAction func confirmButtonTouched(_ sender: Any) {
        print("confirm")
        self.view.endEditing(true)
        resultsTextView.text = ("\(exerciseTextField.text ?? "exercise")\n\(weightTextField.text!) x \(repTextField.text!) x \(setTextField.text!)")
        let confirmedWorkout: Workout = Workout(name: exerciseTextField.text!, weight: String(weightTextField.text!), rep: Int(repTextField.text!)!, set: Int(setTextField.text ?? "") ?? 0)
        workouts.append(confirmedWorkout)
        print(workouts)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        weightTextField.keyboardType = .numberPad
        repTextField.keyboardType = .numberPad
        setTextField.keyboardType = .numberPad
        exerciseTextField.clearsOnBeginEditing = true

        weightTextField.delegate = self
        repTextField.delegate = self
        setTextField.delegate = self
        exerciseTextField.delegate = self
        
        confirmationButton.isEnabled = false
        
        setUpToolbar()
        print("VALIDITY:", isValid)
        resultsTextView.layer.borderWidth = 1
        resultsTextView.layer.cornerRadius = 6
        resultsTextView.layer.borderColor = UIColor.gray.cgColor
        
        setUpTableView()
    }
    
    func setUpTableView() {
        addChild(tableView)
        view.addSubview(tableView.view)
        tableView.didMove(toParent: self)
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        // add
//        constraints.append(tableView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor))
//        constraints.append(tableView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor))
//        constraints.append(tableView.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
//        constraints.append(tableView.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor))
        
        constraints.append(tableView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(tableView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(tableView.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(tableView.view.topAnchor.constraint(equalTo: resultsTextView.safeAreaLayoutGuide.bottomAnchor, constant: 20))
        
        // activate
        NSLayoutConstraint.activate(constraints)
    }
    
    func setUpToolbar() {
        let bar = UIToolbar()
        let bodyWeightBar = UIToolbar()
        
        // bar buttons
        let bodyWeight = UIBarButtonItem(title: "Bodyweight", style: .plain, target: nil, action: #selector(self.bwTapped))
        let doneWeight = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTapped))
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneTapped))
        
        bodyWeightBar.items = [bodyWeight,flexible,doneWeight]
        bar.items = [flexible, done]
        bodyWeightBar.sizeToFit()
        bar.sizeToFit()
        
        weightTextField.inputAccessoryView = bodyWeightBar
        repTextField.inputAccessoryView = bar
        setTextField.inputAccessoryView = bar
    }
    
    @objc func bwTapped() {
        weightTextField.text = "BW"
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

extension ViewController: UITextFieldDelegate {
    //MARK - UITextField Delegates
    var isValid: Bool {
        if exerciseTextField.hasText && weightTextField.hasText && repTextField.hasText {
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For numbers
        if textField == repTextField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == exerciseTextField {
            self.view.endEditing(true)
            weightTextField.becomeFirstResponder()
        }
        return false
    }
    
    // calls this method after the users types their
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if isValid {
            confirmationButton.isEnabled = true
        } else {
            confirmationButton.isEnabled = false
        }
    }
}

extension ViewController: UITextViewDelegate {
}
