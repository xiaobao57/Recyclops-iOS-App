//
//  LandingPageViewController.swift
//  FinalProject
//
//  Created by Avila, Colton C on 4/10/18.
//  Copyright © 2018 Group 12. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class LandingPageViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    
    //start music
    @IBAction func playMusic(_ sender: Any) {
        audioPlayer.play()
    }
    
    //stop music
    @IBAction func stopMusic(_ sender: Any) {
        if audioPlayer.isPlaying{
            audioPlayer.pause()
        } else {
            //do nothing
        }
    }
    
    // Labels
    @IBOutlet weak var homeTitle: UILabel!
    @IBOutlet weak var cardboardTitle: UILabel!
    @IBOutlet weak var glassTitle: UILabel!
    @IBOutlet weak var metalTitle: UILabel!
    @IBOutlet weak var paperTitle: UILabel!
    @IBOutlet weak var plasticTitle: UILabel!
    @IBOutlet weak var recyclingTitle: UILabel!
    @IBOutlet weak var garbageTitle: UILabel!
    @IBOutlet weak var cardboardValue: UILabel!
    @IBOutlet weak var glassValue: UILabel!
    @IBOutlet weak var metalValue: UILabel!
    @IBOutlet weak var paperValue: UILabel!
    @IBOutlet weak var plasticValue: UILabel!
    @IBOutlet weak var garbageValue: UILabel!
    @IBOutlet weak var recyclingValue: UILabel!
    
    //background colors
    let colors = [UIColor.white, UIColor(red: 255/255, green: 253/255, blue: 198/255, alpha: 1),  UIColor(red: 255/255, green: 219/255, blue: 207/255, alpha: 1),  UIColor(red: 247/255, green: 220/255, blue: 255/255, alpha: 1), UIColor(red: 218/255, green: 227/255, blue: 255/255, alpha: 1), UIColor(red: 196/255, green: 255/255, blue: 194/255, alpha: 1), UIColor.lightGray]
    var indes = 0
    
    // Buttons
    @IBAction func itemSelectorButton(_ sender: UIButton) {
    }
    @IBAction func friendsListButton(_ sender: Any) {
    }
    @IBAction func addFriendButton(_ sender: Any) {
    }
    
    // User entities and name variable
    var ownerInfoArr = [NSManagedObject]()
    var ownerInfo = NSManagedObject()
    var ownerName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreenTitle()
        //FIREBASE
        
        //load background music
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Forest2", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
            var audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print(error)
            }
            
        } catch {
            //debug error
            print(error)
        }
    }
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        getOwner()
        DataStore.shared.loadFriends(ownerName: ownerName)
        DataStore.shared.updateGarbage()
        var totalRecycling: Int = 0
        
        // Set value labels to respective ownerInfo values
        if let glassNum = ownerInfo.value(forKey: "glassTotal") as? Int{
            glassValue.text = String(glassNum)
            totalRecycling += glassNum
        }
        if let cardNum = ownerInfo.value(forKey: "cardboardTotal") as? Int{
            cardboardValue.text = String(cardNum)
            totalRecycling += cardNum
        }
        if let metalNum = ownerInfo.value(forKey: "metalsTotal") as? Int{
            metalValue.text = String(metalNum)
            totalRecycling += metalNum
        }
        if let paperNum = ownerInfo.value(forKey: "paperTotal") as? Int{
            paperValue.text = String(paperNum)
            totalRecycling += paperNum
        }
        if let plasticNum = ownerInfo.value(forKey: "plasticTotal") as? Int{
            plasticValue.text = String(plasticNum)
            totalRecycling += plasticNum
        }
        if let glassNum = ownerInfo.value(forKey: "glassTotal") as? Int{
            glassValue.text = String(glassNum)
            totalRecycling += glassNum
        }
        if let garbageNum = ownerInfo.value(forKey: "pureGarbageTotal") as? Int {
            garbageValue.text = String(garbageNum)
        }
        
        recyclingValue.text = String(totalRecycling)
        
        let background = ownerInfo.value(forKey: "backgroundColor") as? Int
        indes = background!
        self.view.backgroundColor = colors[indes]
  
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ItemSelector"{
            _ = segue.destination as? ItemSelectorView
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        else if segue.identifier == "FriendsList"{
            _ = segue.destination as? FriendsListViewController
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        else if segue.identifier == "AddFriend"{
            _ = segue.destination as? AddFriendViewController
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        else if segue.identifier == "ProfilePage"{
            _ = segue.destination as? ProfileViewController
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        else if segue.identifier == "badgeSegue"{
            _ = segue.destination as? BadgesViewController
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    //setting the screeentitle
    private func setScreenTitle() {
        self.title = "Welcome to Recyclops!"
    }

}
