//
//  RegistrationViewController.swift
//  FinalProject
//
//  Created by Avila, Colton C on 4/3/18.
//  Copyright © 2018 Group 12. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController, UITextFieldDelegate, BEMCheckBoxDelegate {
    // outlets
    @IBOutlet weak var usernameTField: UITextField!
    @IBOutlet weak var passwordTField: UITextField!
    @IBOutlet weak var nameTField: UITextField!
    @IBOutlet weak var cityTField: UITextField!
    @IBOutlet weak var stateTField: UITextField!
    @IBOutlet weak var ageTField: UITextField!
    @IBOutlet weak var femaleCheckBox: BEMCheckBox!
    @IBOutlet weak var maleCheckBox: BEMCheckBox!
    @IBOutlet weak var successLabel: UILabel!
    
    // alertcontroller
    var alertController:UIAlertController? = nil
    
    var entityExists = false
    
    // string variable to set sex of user
    var sex = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreenTitle()
        
        // Do any additional setup after loading the view.
        self.usernameTField.delegate = self
        self.passwordTField.delegate = self
        self.nameTField.delegate = self
        self.cityTField.delegate = self
        self.stateTField.delegate = self
        self.ageTField.delegate = self
        femaleCheckBox.delegate = self
        maleCheckBox.delegate = self
        
        // Configure checkboxes
        femaleCheckBox.onAnimationType = .bounce
        maleCheckBox.onAnimationType = .bounce
        femaleCheckBox.onCheckColor = .magenta
        maleCheckBox.onCheckColor = .blue
        femaleCheckBox.offAnimationType = .fade
        maleCheckBox.offAnimationType = .fade
    }
    
    // delegate handler to handle checkbox taps
    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.tag == 1 {
            sex = "Female"
            maleCheckBox.on = false
        }
        else if checkBox.tag == 2 {
            sex = "Male"
            femaleCheckBox.on = false
        }
        else{
            sex = ""
        }
    }
    
    //setting the screeentitle
    private func setScreenTitle() {
        self.title = "Create Account"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Event handler for the Save User button
    @IBAction func saveUserInfo(_ sender: UIButton) {
        
        // Sends a pop-up alert if username or password field are empty
        if usernameTField.text == "" || passwordTField.text == "" || nameTField.text == "" || stateTField.text == "" || cityTField.text == "" || ageTField.text == "" || femaleCheckBox == nil  && maleCheckBox == nil {
            self.alertController = UIAlertController(title: "Error", message: "You must enter a value for all fields", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            self.present(self.alertController!, animated: true, completion:nil)
        
        //Create recycler
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // Create the entity we want to save
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Recycler")

            print("Check1")            //bug check
            do{
                let check = try managedContext.fetch(fetchRequest)
                print(check.count)          //bug check
                if check.count == 1
                {
                    print("Heyo! I'm overwritten")            //bug check
                    let recycler = check[0] as! NSManagedObject
                    recycler.setValue(0, forKey: "cardboardTotal")
                    recycler.setValue(0, forKey: "glassTotal")
                    recycler.setValue(0, forKey: "metalsTotal")
                    recycler.setValue(0, forKey: "paperTotal")
                    recycler.setValue(0, forKey: "plasticTotal")
                    recycler.setValue(0, forKey: "pureGarbageTotal")
                    recycler.setValue(["Recycler"], forKey: "friendsList")
                    recycler.setValue(usernameTField.text, forKey: "name")
                    recycler.setValue(passwordTField.text, forKey: "password")
                    recycler.setValue(nameTField.text, forKey: "humanName")
                    recycler.setValue(cityTField.text, forKey: "city")
                    recycler.setValue(stateTField.text, forKey: "state")
                    recycler.setValue(sex, forKey: "gender")
                    recycler.setValue(ageTField.text, forKey: "age")
                    recycler.setValue(0, forKey: "backgroundColor")
                    recycler.setValue([""], forKey: "badges")
                    recycler.setValue("photo", forKey: "photo")
                    entityExists = true
                    do {
                        try managedContext.save()
                    } catch {
                        // what to do if an error occurs?
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                        abort()
                    }
                    
                    successLabel.text = ("Welcome \(recycler.value(forKey: "humanName") as! String)!")
                    let person = Person(cardBoardTotal: "0", glassTotal: "0", metalsTotal: "0", paperTotal: "0", garbageTotal: "0", plasticTotal: "0", username: usernameTField.text!, password: passwordTField.text!, city: cityTField.text!, state: stateTField.text!, gender: sex, humanName: nameTField.text!, age: ageTField.text!, friendsList: ["Recycler"], backgroundColor: "0", badges: [""], photo: "photo")
                    DataStore.shared.addUser(person: person)
                }
            }
            catch
            {
                print(error)
            }
                
            if entityExists == false{
                let entity =  NSEntityDescription.entity(forEntityName: "Recycler", in: managedContext)
                
                let recycler = NSManagedObject(entity: entity!, insertInto:managedContext)
                
                recycler.setValue(0, forKey: "cardboardTotal")
                recycler.setValue(0, forKey: "glassTotal")
                recycler.setValue(0, forKey: "metalsTotal")
                recycler.setValue(0, forKey: "paperTotal")
                recycler.setValue(0, forKey: "plasticTotal")
                recycler.setValue(0, forKey: "pureGarbageTotal")
                recycler.setValue(["Recycler"], forKey: "friendsList")
                recycler.setValue(usernameTField.text, forKey: "name")
                recycler.setValue(passwordTField.text, forKey: "password")
                recycler.setValue(nameTField.text, forKey: "humanName")
                recycler.setValue(cityTField.text, forKey: "city")
                recycler.setValue(stateTField.text, forKey: "state")
                recycler.setValue(sex, forKey: "gender")
                recycler.setValue(ageTField.text, forKey: "age")
                recycler.setValue(0, forKey: "backgroundColor")
                recycler.setValue([""], forKey: "badges")
                recycler.setValue("photo", forKey: "photo")
                
                // Commit the changes.
                do {
                    try managedContext.save()
                } catch {
                    // what to do if an error occurs?
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
                
                successLabel.text = ("Welcome \(recycler.value(forKey: "humanName") as! String)!")
                let person = Person(cardBoardTotal: "0", glassTotal: "0", metalsTotal: "0", paperTotal: "0", garbageTotal: "0", plasticTotal: "0", username: usernameTField.text!, password: passwordTField.text!, city: cityTField.text!, state: stateTField.text!, gender: sex, humanName: nameTField.text!, age: ageTField.text!, friendsList: ["Recycler"], backgroundColor: "0", badges: [""], photo: "photo")
                //FireBase
                DataStore.shared.addUser(person: person)
                
            }
        }
    }
}
