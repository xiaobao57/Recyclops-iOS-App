//
//  FriendsListViewController.swift
//  FinalProject
//
//  Created by Avila, Colton C on 4/10/18.
//  Copyright © 2018 Group 12. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class FriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var friendsListViewController: UITableView!
    
    //background colors
    let colors = [UIColor.white, UIColor(red: 255/255, green: 253/255, blue: 198/255, alpha: 1),  UIColor(red: 255/255, green: 219/255, blue: 207/255, alpha: 1),  UIColor(red: 247/255, green: 220/255, blue: 255/255, alpha: 1), UIColor(red: 218/255, green: 227/255, blue: 255/255, alpha: 1), UIColor(red: 196/255, green: 255/255, blue: 194/255, alpha: 1), UIColor.lightGray]
    var indes = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.count()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        let person = DataStore.shared.getPerson(index: indexPath.row)
        cell.textLabel?.text = "\(person.humanName)"
        cell.detailTextLabel?.text = "\(person.garbageTotal)"
        
        return cell
    }
    
    @IBAction func addFriendButton(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreenTitle()
        // Do any additional setup after loading the view.
        friendsListViewController.delegate = self
        friendsListViewController.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        getOwner()
        friendsListViewController.delegate = self
        friendsListViewController.dataSource = self
    }

    //setting the screeentitle
    private func setScreenTitle() {
        self.title = "Friends List"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var ownerInfoArr = [NSManagedObject]()
    var ownerInfo = NSManagedObject()
    var ownerName:String = ""
    
    func getOwner(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Recycler")
        
        var fetchedResult: [NSManagedObject]? = nil
        
        // Sets fetchedResult NSManagedObject to user's Recycler entity
        do {
            try fetchedResult = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        // Sets the ownerInfoArr variable if fetchedResult has been created properly
        if let results = fetchedResult {
            self.ownerInfoArr = results
        } else {
            print("Could not fetch")
        }
        
        //Pulls the data from owner to Array
        self.ownerInfo = ownerInfoArr[0]
        
        // Sets the ownerName variable by pullling from the data in the ownerInfo variable
        self.ownerName = (ownerInfo.value(forKey: "name") as! String)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
