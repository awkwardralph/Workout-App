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
    func addProgram(workouts: [WorkoutEntity], date: Date, programDone: Bool)
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
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.landingDelegate = self
        let nav = UINavigationController(rootViewController: vc!)

        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    func getCoreDataDBPath() {
            let path = FileManager
                .default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .last?
                .absoluteString
                .replacingOccurrences(of: "file://", with: "")
                .removingPercentEncoding

            print("Core Data DB Path :: \(path ?? "Not found")")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateTableView()
        self.program = sampleProgram
        
        self.getCoreDataDBPath()
        
        
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
        
        let workout = WorkoutEntity(context: managedObjectContext)
        workout.name = "Decline Bench"
        
        let workout2 = WorkoutEntity(context: managedObjectContext)
        workout2.name = "Bench Press"
        
        let amountDone = AmountDoneEntity(context: managedObjectContext)
        amountDone.weight = "BW"
        amountDone.rep = 5
        amountDone.set = 5
        
        let amountDone2 = AmountDoneEntity(context: managedObjectContext)
        amountDone2.weight = "185"
        amountDone2.rep = 5
        amountDone2.set = 1
        
        let amountDone3 = AmountDoneEntity(context: managedObjectContext)
        amountDone3.weight = "185"
        amountDone3.rep = 5
        amountDone3.set = 1
        
        let amountDone4 = AmountDoneEntity(context: managedObjectContext)
        amountDone4.weight = "185"
        amountDone4.rep = 5
        amountDone4.set = 1
        
        workout.amountDone = [amountDone, amountDone2]
        workout2.amountDone = [amountDone3, amountDone4]
        program.workouts = [workout, workout2]
        
        print(program)
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
    
    func addProgram(workouts: [WorkoutEntity], date: Date, programDone: Bool) {
        // 1
        guard let managedObjectContext = managedObjectContext else {
            fatalError("no MOC")
        }
        
        let program = ProgramEntity(context: managedObjectContext)
        program.date = date
        program.programDone = programDone

        for workout in workouts {
            program.addToWorkouts(workout)
        }

        // 4
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
//        print(programEntity[indexPath.row])
        vc?.programEntity = programEntity[indexPath.row]
//        vc?.program = program[indexPath.row]
        let nav = UINavigationController(rootViewController: vc!)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
}
