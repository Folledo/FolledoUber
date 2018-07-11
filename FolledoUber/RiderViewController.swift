//
//  RiderViewController.swift
//  FolledoUber
//
//  Created by Samuel Folledo on 7/3/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//
// 1) Firebase Installation
// 2) Login & Signup = Setting up login and sign up with firebase
// 3) The Rider ViewController =
// 4) The Driver ViewController
// 5) Sharing the Driver's Location with the Driver

import UIKit
import MapKit //3 //7mins
import FirebaseDatabase //3 //19mins to access database
import FirebaseAuth //23mins
import GoogleMobileAds //AdMob //7mins

class RiderViewController: UIViewController, CLLocationManagerDelegate { //3 //9mins for locationManager
    @IBOutlet weak var mapView: MKMapView! //3 //7mins
    @IBOutlet weak var callAnUberButton: UIButton! //3 //7mins
    @IBOutlet weak var bannerView: GADBannerView! //AdMob //7mins view for banner ads
    
    
    var locationManager = CLLocationManager() //3 //7mins
    
    var userLocation = CLLocationCoordinate2D() //3 //23mins
    var uberHasBeenCalled = false //3 //27mins
    var driverOnTheWay = false //5 //6mins
    var driverLocation = CLLocationCoordinate2D() //5 //5mins
    
//viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111" //AdMob //8mins
        bannerView.rootViewController = self //AdMob //8min s
        bannerView.load(GADRequest()) //AdMob //9mins
        
        locationManager.delegate = self //3 //8mins
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //3 //8mins
        locationManager.requestWhenInUseAuthorization() //3 //8mins
        locationManager.startUpdatingLocation() //3 //8mins
        
        //3 //37mins check and see if there is a current ride request
        if let email = Auth.auth().currentUser?.email {//3 //37mins
            
            Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in //3 //37mins
                //snapshot.ref.removeValue() //3 //37mins but we dont want to remove it, but set uberHasBeenCalled to true instead
                self.uberHasBeenCalled = true //3 //38mins
                self.callAnUberButton.setTitle("Cancel Uber", for: .normal) //3 //38mins
                
                //3 //37mins lets you order another after canceling
                Database.database().reference().child("RideRequests").removeAllObservers() //3 //34mins
                
                //5 //4mins here we check and see if there's a driver come to pick up the rider
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] { //5 //4mins
                    if let driverLat = rideRequestDictionary["driverLat"] as? Double { //5 //4mins
                        if let driverLon = rideRequestDictionary["driverLon"] as? Double { //5 //4mins if we reach here, then we know that there is a driver for sure picking the rider up
                            self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon) //5 //5mins now we have to write a chunk of code if we want the rider and the driver to be displayed on the same map
                            self.driverOnTheWay = true //5 //6mins
                            self.displayDriverAndRider() //5 //10mins
                            
                            //5 //21mins pasted
                            //5 //19mins now we check and see if there's been any update about the driver's location
                            if let email = Auth.auth().currentUser?.email {
                                Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childChanged) { (snapshot) in //5 //20mins query equal to email, then we observe on the .childChanged event. Hey the driver's latitude and longitude change
                                    
                                    //5 //21mins if we are trying to figure out if someone is currently being picked up or not, we want to see if there's a driver latitude and longitude, and use those info to update our stuff by copy pasting from viewDidLoad
                                    if let rideRequestDictionary = snapshot.value as? [String:AnyObject] { //5 //21mins
                                        if let driverLat = rideRequestDictionary["driverLat"] as? Double { //5 //21mins
                                            if let driverLon = rideRequestDictionary["driverLon"] as? Double { //5 //21mins if we reach here, then we know that there is a driver for sure picking the rider up
                                                self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon) //5 //21mins
                                                self.driverOnTheWay = true //5 //6mins
                                                
                                                self.displayDriverAndRider() //5 //10mins
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
        
    }
    
    
//displayDriverAndRider method  //5 //6mins
    func displayDriverAndRider() { //5 //7mins we want to show both the driver and the rider on the map so they can see the distance between the two of them
        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude) //5 //8mins
        let riderCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude) //5 //8mins
        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000 //5 //8mins
        let roundedDistance = round((distance * 0.621371) * 100 ) / 100 //5 //8mins
        
        self.callAnUberButton.setTitle("Your driver is \(roundedDistance) miles away", for: .normal) //5 //9mins set the title of the button to show how far the driver away is
        mapView.removeAnnotations(mapView.annotations) //5 //12mins remove all annotations
        
        let latDelta = abs(driverLocation.latitude - userLocation.latitude) * 2 + 0.005 //5 //13mins however far away from each other and multiply it by 2 in order to see everything. Set it to absolute value to always have positive value
        let lonDelta = abs(driverLocation.longitude - userLocation.longitude) * 2 + 0.005 //5 //14mins
        
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)) //5 //13mins
        mapView.setRegion(region, animated: true) //5 //14mins
        
        let riderAnno = MKPointAnnotation() //5 //15mins
        riderAnno.coordinate = userLocation //5 //15mins
        riderAnno.title = "Your location" //5 //16mins
        mapView.addAnnotation(riderAnno) //5 //16mins
        
        let driverAnno = MKPointAnnotation() //5 //15mins
        driverAnno.coordinate = driverLocation //5 //15mins
        driverAnno.title = "Your driver's location" //5 //16mins
        mapView.addAnnotation(driverAnno) //5 //16mins
    }
    
    //didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //3 //12mins
        if let coord = manager.location?.coordinate { //3 //12mins
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude) //3 //12mins
            userLocation = center //3 //23mins
            
            
            if uberHasBeenCalled { //5 //17mins
                displayDriverAndRider() //5 //17mins
                
                
                
            } else { //5 //17mins
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) //3 //13mins how big you want the region to be
                mapView.setRegion(region, animated: true) //3 //13mins set region
                
                mapView.removeAnnotations(mapView.annotations) //3 //16mins removes all the annotations everytime we change our location
                //13mins now the map shows our location on the mapView. Now we need an annotation to show exactly where our user is and add it to our map
                let annotation = MKPointAnnotation() //3 //14mins
                annotation.coordinate = center //3 //15mins put it on the center
                annotation.title = "Your location" //3 //15mins
                mapView.addAnnotation(annotation) //3 //16mins now time to start saving our location to firebase
            }
        }
    }
    
    @IBAction func callAnUberTapped(_ sender: Any) { //3 //7mins
        if !driverOnTheWay { //5 //9mins if theres no driver on the way
            if let email = Auth.auth().currentUser?.email { //24mins a way to get to an email
                
                if uberHasBeenCalled { //28mins
                    uberHasBeenCalled = false //3 //29mins
                    callAnUberButton.setTitle("Call an Uber", for: .normal) //3 //29mins
                    
                    //3 //29mins now we cancel in the database
                    Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in //3 //30mins
                        snapshot.ref.removeValue() //3 //31mins removes it
                        
                        //3 //32mins now the problem is after canceling, we can't call an uber again, write this following code so we can recall and request an uber
                        Database.database().reference().child("RideRequests").removeAllObservers() //3 //34mins
                    })
                } else {
                    
                    let rideRequestDictionary: [String: Any] = ["email":email , "latitude":userLocation.latitude , "longitude":userLocation.longitude] //3 //21mins dictionary that will store user's email, lat, long
                    Database.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictionary) //3 //20mins this is where we're going to set a value to hold the dictionary of the user's information to our database
                    
                    uberHasBeenCalled = true //3 //27mins
                    callAnUberButton.setTitle("Cancel Uber", for: .normal) //3 //28mins
                }
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) { //3 //7mins
        try? Auth.auth().signOut() //3 //36mins
        //3 //35mins //we have to go to our navigation controller and dismiss the segue
        navigationController?.dismiss(animated: true, completion: nil) //3 //35mins
        //3 //37mins now the problem is after we log out, our app doesnt remember that we called an Uber already, and calling an uber would create 2 things on the database. It should show first if there's a current ride request open
    }
    
    
}
