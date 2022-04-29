//
//  LandingViewController.swift
//  workout-app
//
//  Created by Ralph Lee on 4/21/22.
//

import Foundation
import UIKit
import CoreData

protocol LandingViewDelegate: AnyObject {
    func addProgram(_ program: Program)
}

class LandingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LandingViewDelegate {
    var dateTableView: UITableView!
    
    // 1 declare the moc
    var managedObjectContext: NSManagedObjectContext?
    
    var program: [Program] = [Program]() {
        didSet {
            program.sort(by: {
                $1.date < $0.date
            })
            
            DispatchQueue.main.async {
                self.dateTableView.reloadData()
            }
        }
    }
    
    var programEntity: [ProgramEntity] = [] {
        didSet {
            programEntity.sort(by: {
                $1.date! < $0.date!
            })
            
            DispatchQueue.main.async {
                self.dateTableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var startButton: UIButton!
    
    
    @IBAction func startButtonPressed(_ sender: Any) {
        self.saveProgram()
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
//        vc?.landingDelegate = self
//        let nav = UINavigationController(rootViewController: vc!)
//
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateTableView()
        self.program = sampleProgram
        
        // 2 set up the view context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCoreDate()
    }
    
    func saveProgram() {
        // 1
        guard let managedObjectContext = managedObjectContext else {
            fatalError("no MOC")
        }
        
        let program = ProgramEntity(context: managedObjectContext)
        program.date = Date()
        program.programDone = true
//        program.workouts = WorkoutE
        
        // 4
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.fetchCoreDate()
    }
    
    func fetchCoreDate() {
        // 1
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
        // 1
        guard let managedObjectContext = managedObjectContext else {
            fatalError("no MOC")
        }
        
        // 2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProgramEntity")
        
        // 3
        do {
            programEntity = try managedObjectContext.fetch(fetchRequest) as! [ProgramEntity]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func addProgram(_ program: Program) {
        print("got here!")
        self.program.append(program)
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
//        return program.count
        return programEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dateTableView.dequeueReusableCell(withIdentifier: "DateCell")
        
//        print(programEntity)
        // get date from object
//        let cellDate = program[indexPath.row].date
        let cellDate = programEntity[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        let formattedDate = dateFormatter.string(from: cellDate!)
        
        var content = cell?.defaultContentConfiguration()
        content?.text = formattedDate
        cell?.contentConfiguration = content
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print(amountDone[indexPath.row])
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.program = program[indexPath.row]
        let nav = UINavigationController(rootViewController: vc!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
}
