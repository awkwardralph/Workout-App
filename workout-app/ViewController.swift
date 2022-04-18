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
    weak var delegate: WorkoutDelegate?
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repTextField: UITextField!
    @IBOutlet weak var setTextField: UITextField!
    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var inputHStack: UIStackView!
    
    let tableView = TableViewController()
    
    @IBAction func editButtonTouched(_ sender: Any) {
        exerciseTextField.becomeFirstResponder()
    }
    
    @IBAction func confirmButtonTouched(_ sender: Any) {
        self.view.endEditing(true)
        let workout: Workout = Workout(name: exerciseTextField.text!)
        let amountDone: AmountDone = AmountDone(weight: String(weightTextField.text!), rep: Int(repTextField.text!)!, set: Int(setTextField.text ?? "") ?? 0)
        delegate?.addWorkout(workout: workout, amountDone: amountDone)
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
        
        setUpTableView()
        }
    
    func setUpTableView() {
        addChild(tableView)
        self.delegate = tableView
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
        constraints.append(tableView.view.topAnchor.constraint(equalTo: inputHStack.safeAreaLayoutGuide.bottomAnchor, constant: 20))
        
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
