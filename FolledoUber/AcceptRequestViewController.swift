//
//  AcceptRequestViewController.swift
//  FolledoUber
//
//  Created by Samuel Folledo on 7/9/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//
// 1) Firebase Installation
// 2) Login & Signup = Setting up login and sign up with firebase
// 3) The Rider ViewController =
// 4) The Driver ViewController
// 5) Sharing the Driver's Location with the Driver
/*
    5) remove the rider in the driverTableViewController if a driver accepted them already
*/

import UIKit
import MapKit //4 //36mins
import FirebaseDatabase

class AcceptRequestViewController: UIViewController { //4 //33mins //36mins the main purpse of this VC is you want to take the right request put it on the map and we want to be able to have the driver be able to say OK yes I want to take this ride, hit the button and then launch Apple maps so they can get some directions about how to go get that user

    @IBOutlet weak var mapView: MKMapView! //4 //36mins
    
    var requestLocation = CLLocationCoordinate2D() //4 //37mins
    var requestEmail = "" //4 //37mins
    var driverLocation = CLLocationCoordinate2D() //4 //47mins now equal this property to the driver's location from DriverTableViewController in prepare for segue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) //4 //42mins
        mapView.setRegion(region, animated: false) //4 //42mins create and set a region for the mapView
        
        let annotation = MKPointAnnotation() //4 //43mins
        annotation.coordinate = requestLocation //4 //43mins make an annotation for the requestor's location
        annotation.title = requestEmail //4 //43mins and put their email as the title
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func acceptTapped(_ sender: Any) { //4 //36mins
        //update the ride request
        Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in //4 //46mins queryOrdered by and this is us trying to find the proper ride request, order this by the email address, and equal the query to the requestEmail passed by the DriverTableVC //.observe =  observeEventType:withBlock: is used to listen for data changes at a particular location. This is the primary way to read data from the Firebase Database. Your block will be triggered for the initial data and again whenever the data changes.
            
            snapshot.ref.updateChildValues(["driverLat": self.driverLocation.latitude, "driverLon": self.driverLocation.longitude]) //4 //47mins update the values, we have the rider's location but we dont have the driver's location
            Database.database().reference().child("RideRequests").removeAllObservers() //4 //48mins this should be everything we need to update the particular ride request and have the Driver's coordinates in the server, and now we can start giving directions
        }
        
        //4 //49mins give directions
        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude) //4 //50mins
        
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in //4 //50mins Here we use Geocoder to do some searching to make sure than this is a place that can be route driver to.
            if let placemarks = placemarks { //4 //51mins unwrap the optional
                if placemarks.count > 0 { //4 //52mins if there is actually something in this array of placemarks
                    let placemark = MKPlacemark(placemark: placemarks[0]) //4 //53mins grab the first one only
                    let mapItem = MKMapItem(placemark: placemark) //4 //53mins
                    mapItem.name = self.requestEmail //4 //53mins
                    let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] //4 //54mins we're trying to say that this should be a driving directions
                    mapItem.openInMaps(launchOptions: options) //4 //55mins then we open the map app once the driver accepts the rider's request
                }
            }
        }

    }
    

}
