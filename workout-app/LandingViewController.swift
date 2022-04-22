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
    
    
    @IBAction func startButtonPressed(_ sender: Any) {
        print("made it")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        let nav = UINavigationController(rootViewController: vc!)
        
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
//        self.present(vc!, animated: true)
//        nav.pushViewController(vc!, animated: true)
//        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateTableView()
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Workouts"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleProgram.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dateTableView.dequeueReusableCell(withIdentifier: "DateCell")
        
        // get date from object
        let cellDate = sampleProgram[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        let formattedDate = dateFormatter.string(from: cellDate)
        
        var content = cell?.defaultContentConfiguration()
        content?.text = formattedDate
        cell?.contentConfiguration = content
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print(amountDone[indexPath.row])
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.program = sampleProgram[indexPath.row]
        let nav = UINavigationController(rootViewController: vc!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
}
