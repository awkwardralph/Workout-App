//
//  ViewController.swift
//  workout-app
//
//  Created by Ralph Lee on 4/10/22.
//

import UIKit
import SwiftUI
import CoreData

class ViewController: UIViewController {
    var container: NSPersistentContainer!
    
    var program: Program?
    var currentDate: Date = {
        return Date()
    }()
    
    weak var delegate: WorkoutDelegate?
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repTextField: UITextField!
    @IBOutlet weak var setTextField: UITextField!
    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var inputHStack: UIStackView!
    @IBOutlet weak var exerciseFieldStack: UIStackView!
    @IBOutlet weak var dateField: UILabel!
    
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
        
        checkWorkoutDone()
        setUpDate()
        
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(dismissView))
        }
    
    func setUpTableView() {
        addChild(tableView)
        self.delegate = tableView
        view.addSubview(tableView.view)
        tableView.didMove(toParent: self)
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        // add        
        constraints.append(tableView.view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(tableView.view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(tableView.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        
        if program != nil {
            tableView.workouts = program!.workouts
            constraints.append(tableView.view.topAnchor.constraint(equalTo: dateField.safeAreaLayoutGuide.bottomAnchor, constant: 20))
        } else {
            constraints.append(tableView.view.topAnchor.constraint(equalTo: inputHStack.safeAreaLayoutGuide.bottomAnchor, constant: 20))
        }
        
        // activate
        NSLayoutConstraint.activate(constraints)
    }
    
    func checkWorkoutDone() {
        if program != nil {
            inputHStack.isHidden = true
            confirmationButton.isHidden = true
            exerciseFieldStack.isHidden = true
            currentDate = program!.date
        }
    }
    
    func setUpDate() {
//        let timeStamp = Date.currentTimeStamp
//        print(timeStamp)
//        let date2 = Date.init(timeIntervalSince1970: TimeInterval(timeStamp))
//        print(date2)
//        let date = Date()
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        print(date)
//        print(calendar)
//        print(hour)
//        print(minutes)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let formattedDate = dateFormatter.string(from: currentDate)
        // Apr 21, 2022 at 9:45 PM
        print(formattedDate)
        dateField.text = formattedDate
        print(currentDate)
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
    
    @objc func dismissView() {
        self.dismiss(animated: true)
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

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
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
