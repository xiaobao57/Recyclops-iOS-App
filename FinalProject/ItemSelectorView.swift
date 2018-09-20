//
//  ItemSelectorView.swift
//  FinalProject
//
//  Created by Avila, Colton C on 3/27/18.
//  Copyright © 2018 Group 12. All rights reserved.
//

import UIKit
import CoreData

class ItemSelectorView: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var recyclePicker: UIPickerView!
    @IBOutlet weak var trashPicker: UIPickerView!
    @IBOutlet weak var streamSegment: UISegmentedControl!
    
    //Check to see what saved
    @IBOutlet weak var checkDataLabel: UILabel!
    @IBOutlet weak var nameCheckLabel: UILabel!
    @IBOutlet weak var totalGarbLabel: UILabel!
    
    //background colors
    let colors = [UIColor.white, UIColor(red: 255/255, green: 253/255, blue: 198/255, alpha: 1),  UIColor(red: 255/255, green: 219/255, blue: 207/255, alpha: 1),  UIColor(red: 247/255, green: 220/255, blue: 255/255, alpha: 1), UIColor(red: 218/255, green: 227/255, blue: 255/255, alpha: 1), UIColor(red: 196/255, green: 255/255, blue: 194/255, alpha: 1), UIColor.lightGray]
    var indes = 0
    
    //Stream ID
    var streamType:String = "Plastic"
    
    //Segmented controller
    @IBAction func streamSelector(_ sender: Any) {
        switch streamSegment.selectedSegmentIndex{
        case 0:
            streamType = "Plastic"
            picker1Options = ["Nothing","Tiny : Utensils","Small : Cups","Medium: Bottles","Large: Jugs","Huge : Buckets"]
        case 1:
            streamType = "Paper"
            picker1Options = ["Nothing","Tiny : 1 Sheet","Small : 5 Sheets","Medium: 10 Sheets","Large: Magazine(30 Sheets)","Huge : Newspaper(60 Sheets)"]
        case 2:
            streamType = "Cardboard"
            picker1Options = ["Nothing","Tiny : Ring Box","Small : DVD Box","Medium: Cereal Box","Large: Shoe Box","Huge : Microwave Box"]
        case 3:
            streamType = "Glass"
            picker1Options = ["Nothing","Tiny : Shards","Small : Jars","Medium: Soda Bottle","Large: Wine Bottle","Huge : Jugs"]
        case 4:
            streamType = "Metals"
            picker1Options = ["Nothing","Tiny : Bottle Tabs","Small : Foil","Medium: Soda Cans","Large: Coffee Cans","Huge : Microwave"]
        default:
            break
        }
    }
    
    //Recycling Array
    var picker1Options:[String] = []
    //Trash Array
    var picker2Options:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setScreenTitle()
        
        //Initial Picker
        picker1Options = ["Nothing", "Tiny : Utensils","Small : Cups","Medium: Bottles","Large: Jugs","Huge : Buckets"]
        picker2Options = ["Nothing","Tiny: Wrapper","Small : Apple","Medium : NBA Shoe","Large : Basketball","Huge : Microwave"]
        // Do any additional setup after loading the view.
        
        recyclePicker.delegate = self
        trashPicker.delegate = self
        
    }
    
    //Sets info
    var ownerInfoArr = [NSManagedObject]()
    var ownerInfo = NSManagedObject()
    
    //Pulls Owner's Name from CoreData
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            ownerInfoArr = results
        } else {
            print("Could not fetch")
        }
        
        //Pulls the data from owner to Array
        ownerInfo = ownerInfoArr[0]
        
        nameCheckLabel.text = (ownerInfo.value(forKey: "name") as! String)
        
        let background = ownerInfo.value(forKey: "backgroundColor") as? Int
        indes = background!
        self.view.backgroundColor = colors[indes]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return picker1Options.count
        }
        else{
            return picker2Options.count
        }
    }
    
    //for add
    var recycleIndex: Int = 0
    var trashIndex: Int = 0
    
    //Title of Picker Row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            print(row)
            return (picker1Options[row])
        }else{
            trashIndex = row
            return (picker2Options[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            recycleIndex = row
        }else{
            trashIndex = row
        }
    }
    
    
    @IBAction func addDataButton(_ sender: UIButton) {
        self.saveRecyler(recycleIndex: recycleIndex, trashIndex: trashIndex)
    }

    
    func saveRecyler(recycleIndex:Int,trashIndex:Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        var newVolume:Int = 0
        var newGarbageV:Int = 0
        
        //Milliliters
        switch recycleIndex {
        case 0:
            newVolume = 0
        case 1:
            newVolume = 125
        case 2:
            newVolume = 200
        case 3:
            newVolume = 300
        case 4:
            newVolume = 750
        case 5:
            newVolume = 1200
        default:
            break
        }
        
        switch trashIndex {
        case 0:
            newGarbageV = 0
        case 1:
            newGarbageV = 125
        case 2:
            newGarbageV = 200
        case 3:
            newGarbageV = 300
        case 4:
            newGarbageV = 750
        case 5:
            newGarbageV = 1200
        default:
            break
        }
        
        //Recycling
        var totalTrash:Int = 0
        //Trash
        var totalGarbage:Int = ownerInfo.value(forKey: "pureGarbageTotal") as! Int
        
        // Set the attribute values depending on the streamType value
        switch streamType {
        case "Plastic":
            totalTrash = ownerInfo.value(forKey: "plasticTotal") as! Int
            totalTrash = totalTrash + newVolume
            ownerInfo.setValue(totalTrash, forKey: "plasticTotal")
        case "Paper":
            totalTrash = ownerInfo.value(forKey: "paperTotal") as! Int
            totalTrash = totalTrash + newVolume
            ownerInfo.setValue(totalTrash, forKey: "paperTotal")
        case "Cardboard":
            totalTrash = ownerInfo.value(forKey: "cardboardTotal") as! Int
            totalTrash = totalTrash + newVolume
            ownerInfo.setValue(totalTrash, forKey: "cardboardTotal")
        case "Glass":
            totalTrash = ownerInfo.value(forKey: "glassTotal") as! Int
            totalTrash = totalTrash + newVolume
            ownerInfo.setValue(totalTrash, forKey: "glassTotal")
        case "Metals":
            totalTrash = ownerInfo.value(forKey: "metalsTotal") as! Int
            totalTrash = totalTrash + newVolume
            ownerInfo.setValue(totalTrash, forKey: "metalsTotal")
        default:
            break
        }
        
        totalGarbage = totalGarbage + newGarbageV
        ownerInfo.setValue(totalGarbage, forKey: "pureGarbageTotal")
        
        
        checkDataLabel.text = " +\(newVolume) ml of \(streamType) & +\(newGarbageV) ml of garbage"
        totalGarbLabel.text = "\(ownerInfo.value(forKey: "pureGarbageTotal") as! Int) ml of trash you have in total"
        
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
    
    //setting the screentitle
    private func setScreenTitle() {
        self.title = "Add"
    }
}
