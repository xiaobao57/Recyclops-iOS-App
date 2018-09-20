//
//  LocationViewController.swift
//  FinalProject
//
//  Created by Anna Su on 4/25/18.
//  Copyright © 2018 Group 12. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class LocationViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    let colors = [UIColor.white, UIColor(red: 255/255, green: 253/255, blue: 198/255, alpha: 1),  UIColor(red: 255/255, green: 219/255, blue: 207/255, alpha: 1),  UIColor(red: 247/255, green: 220/255, blue: 255/255, alpha: 1), UIColor(red: 218/255, green: 227/255, blue: 255/255, alpha: 1), UIColor(red: 196/255, green: 255/255, blue: 194/255, alpha: 1), UIColor.lightGray]
    var indes = 0
    
    //display maps for current location and search location
    @IBOutlet weak var locationMap: MKMapView!
    
    var alertController:UIAlertController? = nil
    
    //search places icon on navigation bar
    @IBAction func searchMap(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    //implement the search ability
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ignore user
        UIApplication.shared.beginIgnoringInteractionEvents()

        //activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        self.view.addSubview(activityIndicator)

        //Hide Search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)

        //create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text

        let activeSearch = MKLocalSearch(request: searchRequest)

        //we'll be getting two variables in return
        activeSearch.start { (response, error) in

            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()

            if response == nil {
                print("Error")
            } else {
                //when you actually have a result; also you want to remove annotation
                let annotations = self.locationMap.annotations
                self.locationMap.removeAnnotations(annotations)

                //getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude

                //create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text!
                annotation.subtitle = "Friend's Location"
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.locationMap.addAnnotation(annotation)

                //zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.locationMap.setRegion(region, animated: true)
            }
        }
    }
    
    let manager = CLLocationManager()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        locationMap.setRegion(region, animated: true)
        
        self.locationMap.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    //Sets info
    var ownerInfoArr = [NSManagedObject]()
    var ownerInfo = NSManagedObject()
    
    //Pulls Owner's Name from CoreData for background color
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
        
        let background = ownerInfo.value(forKey: "backgroundColor") as? Int
        indes = background!
        self.view.backgroundColor = colors[indes]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
