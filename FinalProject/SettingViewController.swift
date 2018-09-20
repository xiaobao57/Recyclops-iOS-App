//
//  SettingViewController.swift
//  FinalProject
//
//  Created by Anna Su on 4/12/18.
//  Copyright © 2018 Group 12. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class SettingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var humanName = "none"
    
    @IBOutlet weak var passwordvalue: UITextField!
    @IBOutlet weak var namevalue: UITextField!
    @IBOutlet weak var cityvalue: UITextField!
    @IBOutlet weak var statevalue: UITextField!
    var alertController:UIAlertController? = nil
    
    //Notification button
    @IBOutlet weak var notification: UILabel!
    
    @IBAction func notificationswitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            notification.text = "On"
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
                //check to see if user did allow
                if didAllow {
                    print("allow")
                    
                    let content = UNMutableNotificationContent()
                    content.title = "You have a message from Recyclops:"
                    content.subtitle = "Time to update your tracker!"
                    content.body = "Recycling turns things into other things, which is like MAGIC"
                    content.badge = 1
                    
                    //takes 5 second for notification to display and doesn't repeat
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)                } else {
                    print("not allow")
                }
            })
        } else {
            notification.text = "Off"
        }
    }
    
    var imagePickerController:UIImagePickerController!
    @IBOutlet var myImageView: UIImageView!
    
    //Profile Photo change
    @IBAction func photoChange(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        
        //get it from photolibrary
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {
            //after it is complete, do this if needed
        }
    }
    
    //when the user has picked its image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //want to try to convert it into a UIImage
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myImageView.image = image
            //if there's an error loading the photo
        } else {
            //Error Message
            print("Not working")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //function to save profile images in documents directory
    func saveImage(imageName: String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //to see what it looks like
        print(imagePath)
        //get the image we took with camera
        let image = myImageView.image!
        //get the PNG data for this image
        let data = UIImagePNGRepresentation(image)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        print("this ran")
    }
    
    //button to save the photo to the profile
    @IBAction func savePhoto(_ sender: UIButton) {
        print(humanName+"profile.png")
        self.saveImage(imageName: humanName+"profile.png")
        print("photosave")
    }
    
    //get profile photo
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            myImageView.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("Panic! No Image!")
        }
    }
    
    //background color change choosing
    let colors = [UIColor.white, UIColor(red: 255/255, green: 253/255, blue: 198/255, alpha: 1),  UIColor(red: 255/255, green: 219/255, blue: 207/255, alpha: 1),  UIColor(red: 247/255, green: 220/255, blue: 255/255, alpha: 1), UIColor(red: 218/255, green: 227/255, blue: 255/255, alpha: 1), UIColor(red: 196/255, green: 255/255, blue: 194/255, alpha: 1), UIColor.lightGray]
    var indes = 0
    
    
    @IBAction func backgroundcolor(_ sender: UIButton) {
        
        ////update changes made to the profile
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let dummyIndex = (ownerInfo.value(forKey: "backgroundColor") as! Int)
        indes = dummyIndex
        
        if indes == colors.count - 1 {
            indes = 0
        } else {
            indes += 1
        }
        self.view.backgroundColor = colors[indes]
        self.ownerInfo.setValue(indes, forKey: "backgroundColor")
        
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
    
    //set up the submit button
    @IBAction func submitsetting(_ sender: UIButton) {
        // Sends a pop-up alert if any of the fields are empty
        if passwordvalue.text == "" || namevalue.text == "" || cityvalue.text == "" || statevalue.text == "" {
            self.alertController = UIAlertController(title: "Error", message: "You must enter a value for all fields", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            
            self.present(self.alertController!, animated: true, completion:nil)
            
            //if the boxes are all filled
        } else {
            self.alertController = UIAlertController(title: "Update Information", message: "You are about to make changes to your profile", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let ok = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                print("Confirm Button Pressed")
                
                ////update changes made to the profile
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.persistentContainer.viewContext
                
                self.ownerInfo.setValue(self.passwordvalue.text, forKey: "password")
                self.self.ownerInfo.setValue(self.cityvalue.text, forKey: "city")
                self.ownerInfo.setValue(self.statevalue.text, forKey: "state")
                self.ownerInfo.setValue(self.namevalue.text, forKey: "humanName")
                
                // Commit the changes.
                do {
                    try managedContext.save()
                } catch {
                    // what to do if an error occurs?
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                print("Cancel Button Pressed")
            })
            
            self.alertController!.addAction(ok)
            self.alertController!.addAction(cancel)
            
            present(self.alertController!, animated: true, completion: nil)
            
        }
    }
    
    //load and update the core data - set info
    var ownerInfoArr = [NSManagedObject]()
    var ownerInfo = NSManagedObject()
    
    //Pulls Owner's Name from CoreData
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        //Pulls the data from owner to Array
        ownerInfo = ownerInfoArr[0]
        
        //automatically generate user profile information to fillin the textbox
        let dummyPassword = (ownerInfo.value(forKey: "password") as! String)
        passwordvalue.text = dummyPassword
        let dummyName = (ownerInfo.value(forKey: "humanName") as! String)
        namevalue.text = dummyName
        let dummyCity = (ownerInfo.value(forKey: "city") as! String)
        cityvalue.text = dummyCity
        let dummyState = (ownerInfo.value(forKey: "state") as! String)
        statevalue.text = dummyState
        let background = ownerInfo.value(forKey: "backgroundColor") as? Int
        indes = background!
        self.humanName = (ownerInfo.value(forKey: "name") as! String)
        self.view.backgroundColor = colors[indes]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreenTitle()
        
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
        self.humanName = (ownerInfo.value(forKey: "name") as! String)
        print(self.humanName)
        self.getImage(imageName:self.humanName+"profile.png")
        // Do any additional setup after loading the view.
        
    }
    
    //setting the screeentitle
    private func setScreenTitle() {
        self.title = "Settings"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
