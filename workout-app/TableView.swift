//
//  TableView.swift
//  workout-app
//
//  Created by Ralph Lee on 4/11/22.
//

import UIKit
import CoreData

protocol WorkoutDelegate: AnyObject {
    func addWorkout(workout: Workout, amountDone: AmountDone)
    func confirmWorkouts() -> [WorkoutEntity]
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WorkoutDelegate {
    var tableView: UITableView!
    weak var topViewDelegate: TopViewDelegate?
    
    // 1 declare the moc
    var managedObjectContext: NSManagedObjectContext?
    
    var workouts: [Workout] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var workoutEntity: [WorkoutEntity] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var workoutNames: [String] = []
    var amountDone:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topViewDelegate = self.parent as? TopViewDelegate
        setupTableView()
        
        // 2 set up the view context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    func addWorkout(workout: Workout, amountDone: AmountDone) {
        guard let managedObjectContext = managedObjectContext else {
            fatalError("no MOC")
        }
        if workoutEntity.isEmpty {
            topViewDelegate?.makeFloatingButtonVisible()
        }
        if !workoutEntity.contains(where: {$0.name == workout.name}) {
            let workoutCore = WorkoutEntity(context: managedObjectContext)
            workoutCore.name = workout.name
            
            // no program, no amount done
            workoutEntity.append(workoutCore)
        }
        if let exercise = workoutEntity.firstIndex(where: {$0.name == workout.name}) {
            
            let AmountDoneCoreData = AmountDoneEntity(context: managedObjectContext)
            
            AmountDoneCoreData.weight = amountDone.weight
            AmountDoneCoreData.rep = Int64(amountDone.rep)
            AmountDoneCoreData.set = Int64(amountDone.set!)
            
            workoutEntity[exercise].addToAmountDone([AmountDoneCoreData])

            self.tableView.reloadData()
        }
    }
    
    func confirmWorkouts() -> [WorkoutEntity] {
        return workoutEntity
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WorkoutCell")
        
        // always do this
        tableView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        // set the constraints
        constraints.append(tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor))
        
        // activate the constraints
        NSLayoutConstraint.activate(constraints)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return workoutNames.count
        return workoutEntity.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return workoutNames[section]
        return workoutEntity[section].name
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return amountDone[section].count
        return workoutEntity[section].amountDone!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell")! as UITableViewCell
        let category = workoutEntity[indexPath.section].amountDone!.array as! [AmountDoneEntity]
        let amount = category[indexPath.row]
        let weight = amount.weight
        let rep = amount.rep
        let set = amount.set
        var cellText = ""
        if (set != 0) {
            cellText = "\(weight!) x \(rep) x \(set)"
        } else {
            cellText = "\(weight!) x \(rep)"
        }
        cell.textLabel?.text = cellText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print(amountDone[indexPath.row])
        print("hello")
    }
}
