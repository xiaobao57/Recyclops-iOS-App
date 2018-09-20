//
//  SignInViewController.swift
//  FinalProject
//
//  Created by Anna Su on 3/27/18.
//  Copyright © 2018 Group 12. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate{
    
    @IBOutlet weak var loginTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var alertController:UIAlertController? = nil
    @IBOutlet weak var bgImageView: UIImageView!
    
    // Not called when alert is dismissed.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Login
        self.loginTextfield.delegate = self
        self.passwordTextField.delegate = self
        
        //set the Google ui delegate
        GIDSignIn.sharedInstance().uiDelegate = self
        self.view.sendSubview(toBack: bgImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Keyobard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Normal Login
    @IBAction func loginButton(_ sender: UIButton) {
        var ownerInfoArr = [NSManagedObject]()
        var ownerInfo = NSManagedObject()
        var username:String = "testusernameNobody"
        var password:String = "xxxReallySecretCode"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Recycler")
        
        //
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
            if results.count == 0{
                print("nothing here")
            }
            else{
                ownerInfoArr = results
                ownerInfo = ownerInfoArr[0]
                username = (ownerInfo.value(forKey: "name") as! String)
                password = (ownerInfo.value(forKey: "password") as! String)
            }
        } else {
            print("Could not fetch")
        }
        
    // Sends a pop-up alert if either the login or password fields are empty
       if loginTextfield.text == "" || passwordTextField.text == ""{
            self.alertController = UIAlertController(title: "Error", message: "Make sure both fields are full", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            
            self.present(self.alertController!, animated: true, completion:nil)
        }
        else if username != loginTextfield.text || password != passwordTextField.text{
            self.alertController = UIAlertController(title: "Error", message: "Username / Password Combination Incorrect", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            
            self.present(self.alertController!, animated: true, completion:nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "LandingPage"{
            _ = segue.destination as? ItemSelectorView
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        else if segue.identifier == "RegisterView"
        {
            _ = segue.destination as? RegistrationViewController
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
    }
}
