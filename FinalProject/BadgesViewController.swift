//
//  BadgesViewController.swift
//  FinalProject
//
//  Created by Xiao, Bryan on 4/21/18.
//  Copyright © 2018 Group 12. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BadgesViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewTwo: UITextView!
    @IBOutlet weak var textViewThree: UITextView!
    @IBOutlet weak var textViewFour: UITextView!
    @IBOutlet weak var textViewFive: UITextView!
    @IBOutlet weak var textViewSix: UITextView!
    
    //load and update the core data - set info
    var ownerInfoArr = [NSManagedObject]()
    var ownerInfo = NSManagedObject()
    
    // alert controller
    var alertController:UIAlertController? = nil
    
    // draggedText variable to hold value of text being dragged
    private var draggedText = ""
    // list variable to edit user's badges
    private var newBadges = [String]()
    
    // data source for table view
    var tableViewData = [String]()
    
    // Initial setups
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreenTitle()
        // Do any additional setup after loading the view.
        tableView.dropDelegate = self
        tableView.dataSource = self
        
        // set ownerinfo data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Recycler")
        
        var fetchedResult: [NSManagedObject]? = nil
        
        do {
            try fetchedResult = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResult {
            ownerInfoArr = results
        } else {
            print("Could not fetch")
        }
        
        ownerInfo = ownerInfoArr[0]
        
        tableViewData = ownerInfo.value(forKey: "badges") as! [String]
    }
    
    // setting the screentitle
    private func setScreenTitle() {
        self.title = "Badges"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clearBtn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // set current badgelist to empty
        newBadges = []
        ownerInfo.setValue(newBadges, forKey: "badges")
        
        // Commit the changes.
        do {
            try managedContext.save()
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
}

extension BadgesViewController:UITextDragDelegate, UITableViewDropDelegate{
    
    // sets image for drag event
    func textDraggableView(_ textDraggableView: UIView & UITextDraggable, dragPreviewForLiftingItem item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        
        // creates image view for drag event
        let imageView = UIImageView(image: UIImage(named:"smiley-face"))
        imageView.backgroundColor = UIColor.red
        
        let dragView = textDraggableView
        // where drag originates from
        let dragPoint = session.location(in: dragView)
        // drag preview target
        let target = UIDragPreviewTarget(container: dragView, center: dragPoint)
        
        return UITargetedDragPreview(view: imageView, parameters: UIDragPreviewParameters(), target: target)
        
    }
    
    // sets the value of the dragged object
    func textDraggableView(_ textDraggableView: UIView & UITextDraggable, itemsForDrag dragRequest: UITextDragRequest) -> [UIDragItem] {
        print("drag working bug check")
        // 'string' is set to whatever text is being dragged
        if let string = textView.text(in: dragRequest.dragRange){
            draggedText = string
            let itemProvider = NSItemProvider(object: string as NSString)
            return [UIDragItem(itemProvider: itemProvider)]
        }
            
        else
        {
            return []
        }
        
    }
    
    // handles when dragged object is dropped
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        // check to see if the user has too many badges
        newBadges = ownerInfo.value(forKey: "badges") as! [String]
        if (newBadges.count) >= 4{
            self.alertController = UIAlertController(title: "Error", message: "You have too many badges!", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            self.present(self.alertController!, animated: true, completion:nil)
        }
        else{
            // Sends a pop-up alert if user doesn't meet badge requirements
            if (ownerInfo.value(forKey: "plasticTotal") as! Int32) < 500 && draggedText == "Badge1"{
                self.alertController = UIAlertController(title: "Error", message: "You do not meet the requirements for this badge", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                }
                self.alertController!.addAction(OKAction)
                self.present(self.alertController!, animated: true, completion:nil)
            }
            else{
                let destIndexPath:IndexPath
                
                // sets the destinationIndexPath depending on where the dragged item is dropped
                if let indexPath = coordinator.destinationIndexPath {
                    destIndexPath = indexPath
                }
                else{
                    let section = tableView.numberOfSections - 1
                    let row = tableView.numberOfRows(inSection: section)
                    destIndexPath = IndexPath(row: row, section: section)
                }
                
                // inserts the text set from the function above into the tableViewData
                coordinator.session.loadObjects(ofClass: NSString.self)
                {items in
                    guard let stringsArray = items as? [String] else {return}
                    print(stringsArray.first!)
                    self.tableViewData.insert(stringsArray.first!, at: destIndexPath.row)
                    
                    // set user's badge list to include new badge if user has met badge requirements
                    self.newBadges.insert(stringsArray.first!, at: 0)
                    self.ownerInfo.setValue(self.newBadges, forKey: "badges")
                    
                    tableView.insertRows(at: [destIndexPath], with: .automatic)
                    
                }
                
                
            }
        }
    }
}

// Configure the Table View
extension BadgesViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let stringObject = tableViewData[indexPath.row]
        
        cell.textLabel?.text = stringObject
        
        return cell
    }
}
