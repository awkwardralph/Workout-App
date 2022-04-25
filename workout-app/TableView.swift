//
//  TableView.swift
//  workout-app
//
//  Created by Ralph Lee on 4/11/22.
//

import UIKit

protocol WorkoutDelegate: AnyObject {
    func addWorkout(workout: Workout, amountDone: AmountDone)
    func confirmWorkouts() -> [Workout]
}

//class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WorkoutDelegate {
    var tableView: UITableView!
    weak var topViewDelegate: TopViewDelegate?
    var workouts: [Workout] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var workoutNames: [String] = []
    var amountDone:[String] = []
//    let workoutNames = ["Bench Press", "Pull ups", "Runing", "Squat", "Deadlift", "Flips"]
//    let amountDone = [
//                        ["135 x 5 x 4", "135 x 5 x 5", "135 x 5 x 6", "135 x 5 x 7"],
//                        ["135 x 5 x 7", "BW x 3 x 4"],
//                        ["BW x 3 x 4"],
//                        ["135 x 5 x 4", "135 x 5 x 5", "135 x 5 x 6"],
//                        ["135 x 5 x 4"],
//                        ["900 x 1 x 4"]
//                    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topViewDelegate = self.parent as? TopViewDelegate
        setupTableView()
    }
    
    func addWorkout(workout: Workout, amountDone: AmountDone) {
        if workouts.isEmpty {
            topViewDelegate?.makeFloatingButtonVisible()
        }
        if !workouts.contains(where: {$0.name == workout.name}) {
            workoutNames.append(workout.name)
            workouts.append(Workout(name: workout.name))
        }
        if let exercise = workouts.firstIndex(where: {$0.name == workout.name}) {
            workouts[exercise].add(runThrough: amountDone)
        }
    }
    
    func confirmWorkouts() -> [Workout] {
        return workouts
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
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return workoutNames[section]
        return workouts[section].name
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return amountDone[section].count
        return workouts[section].amount!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell")! as UITableViewCell
        let category = workouts[indexPath.section]
        let amount = category.amount![indexPath.row]
        let weight = amount.weight
        let rep = amount.rep
        let set = amount.set
        var cellText = ""
        if (set != 0) {
            cellText = "\(weight) x \(rep) x \(set!)"
        } else {
            cellText = "\(weight) x \(rep)"
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
