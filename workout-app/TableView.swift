//
//  TableView.swift
//  workout-app
//
//  Created by Ralph Lee on 4/11/22.
//

import UIKit

//class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    
    let workoutNames = ["Bench Press", "Pull ups", "Runing", "Squat", "Deadlift", "Flips"]
    let amountDone = [
                        ["135 x 5 x 4", "135 x 5 x 5", "135 x 5 x 6", "135 x 5 x 7"],
                        ["135 x 5 x 7", "BW x 3 x 4"],
                        ["BW x 3 x 4"],
                        ["135 x 5 x 4", "135 x 5 x 5", "135 x 5 x 6"],
                        ["135 x 5 x 4"],
                        ["900 x 1 x 4"]
                    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        setupTableView()
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
        return workoutNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return workoutNames[section]
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amountDone[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell")! as UITableViewCell
        let category = amountDone[indexPath.section]
        cell.textLabel?.text = category[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(amountDone[indexPath.row])
    }
    
    
}
