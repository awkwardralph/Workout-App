//
//  LandingViewController.swift
//  workout-app
//
//  Created by Ralph Lee on 4/21/22.
//

import Foundation
import UIKit

class LandingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var dateTableView: UITableView!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateTableView()
        print(sampleProgram)
    }
    
    func setupDateTableView() {
        dateTableView = UITableView(frame: view.bounds)
        view.addSubview(dateTableView)
        dateTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DateCell")
        
        // always do this
        dateTableView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        // set the constraints
        constraints.append(dateTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(dateTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(dateTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(dateTableView.topAnchor.constraint(equalTo: startButton.safeAreaLayoutGuide.bottomAnchor, constant: 20))
        
        // activate the constraints
        NSLayoutConstraint.activate(constraints)
        
        dateTableView.dataSource = self
        dateTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dateTableView.dequeueReusableCell(withIdentifier: "DateCell")
        var content = cell?.defaultContentConfiguration()
        content?.text = "hello"
        cell?.contentConfiguration = content
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print(amountDone[indexPath.row])
        print("hello")
    }
    
}
