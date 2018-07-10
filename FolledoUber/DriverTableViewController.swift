//
//  DriverTableViewController.swift
//  
//
//  Created by Samuel Folledo on 7/5/18.
//
// 1) Firebase Installation
// 2) Login & Signup = Setting up login and sign up with firebase
// 3) The Rider ViewController =
// 4) The Driver ViewController
// 5) Sharing the Driver's Location with the Driver

import UIKit
import FirebaseAuth //4 //14mins
import FirebaseDatabase //4 //14mins
import MapKit //4 //23mins

class DriverTableViewController: UITableViewController, CLLocationManagerDelegate { //4 //23mins

    var rideRequests: [DataSnapshot] = [] //4 //17mins
    var locationManager = CLLocationManager() //4 //23mins
    var driverLocation = CLLocationCoordinate2D() //4 //23mins
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self //4 //23mins
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //4 //23mins
        locationManager.requestWhenInUseAuthorization() //4 //23mins
        locationManager.startUpdatingLocation() //4 //23mins
        
        
        //query
        Database.database().reference().child("RideRequests").observe(.childAdded) { (snapshot) in //4 //16mins observe(eventType: with:) observeEventType:withBlock: is used to listen for data changes at a particular location. This is the primary way to read data from the Firebase Database. Your block will be triggered for the initial data and again whenever the data changes.
            
            self.rideRequests.append(snapshot) //4 //17mins each of these snapshot is going to be the rideRequest and appen it to the array
            self.tableView.reloadData() //4 //18mins and reload tableView
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in //4 //29mins
            self.tableView.reloadData() //4 //30mins
        }
    }

//didUpdateLocations method //4 //24mins
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //4 //24mins we are looking to find out the driver's current location
        if let coord = manager.location?.coordinate { //4 //24mins
            driverLocation = coord //4 //24mins set the driver's coordinate to our property
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideRequests.count //4 //18mins
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //4 //18mins
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideRequestCell", for: indexPath) //4 //19mins
        
        let snapshot = rideRequests[indexPath.row] //4 //19mins
        if let rideRequestDictionary = snapshot.value as? [String:AnyObject] { //4 //20mins create a dictionary out of the value of the snapshot, anyObject because they could be int or strings
            if let email = rideRequestDictionary["email"] as? String { //4 //20mins get their email for the dictionary
                
                if let lat = rideRequestDictionary["latitude"] as? Double { //4 //25mins After getting the driver's coord, we need to determine how far away the driver and the rider are. So once we have pulled out the email, next thing we want
                    if let lon = rideRequestDictionary["longitude"] as? Double { //4 //25mins
                        
                        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude) //4 //26mins driver's location
                        let riderCLLocation = CLLocation(latitude: lat, longitude: lon) //4 //26mins grabs the rider's lat/long from the rideRequestDictionary
                        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000 //4 //27mins measure those meters in kilometers // This distance method measures the distance between the location in the current object and the value in the location parameter. The distance is calculated by tracing a line between the two points
                        let roundedDistance = (round(distance * 100) / 100) * 0.621371 //4 //28mins rounded and multiplied by 0.621371to get the kilometers to miles
                        cell.textLabel?.text = "\(email) is \(roundedDistance) away" //4 //28mins
                        
                    }
                }
                //cell.textLabel?.text = email //4 //20mins
            }
        }
        return cell//4 //19mins
    }
    
    
    
    @IBAction func logoutTapped(_ sender: Any) { //4 //13mins
        try? Auth.auth().signOut() //4 /13mins
        navigationController?.dismiss(animated: true, completion: nil) //4 //13mins
    }
    
//didSelectRowAt method for the driver to see AcceptRequestVC on the row they select //4 //34mins
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //4 //34mins
        let snapshot = rideRequests[indexPath.row] //4 //39mins snapshot is equal to the rideRequest where they tapped on
        
        performSegue(withIdentifier: "acceptSegue", sender: snapshot) //4 //35mins //4 //39mins sender to pass over was changed from nil to snapshot //now unwrap it in prepare (for segue:)
    }
//prepare forSegue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //4 //38mins this method notifies the view controller that a segue is about to be performed. The default implementation of this method does nothing. Subclasses override this method and use it to configure the new view controller prior to it being displayed. The segue object contains information about the transition, including references to both view controllers that are involved.

        if let acceptVC = segue.destination as? AcceptRequestViewController { //4 //38mins
            
            if let snapshot = sender as? DataSnapshot { //4 //40mins make sure the unwrapped snapshot from didSelectRowAt is an actual DataSnapshot //now we unwrap the email, latitude and longitude
                
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] { //4 //40mins
                    if let email = rideRequestDictionary["email"] as? String { //4 //40mins
                        
                        if let lat = rideRequestDictionary["latitude"] as? Double { //4 //40mins
                            if let lon = rideRequestDictionary["longitude"] as? Double { //4 //40mins
                                acceptVC.requestEmail = email //4 //38mins and be able to accept the requestEmail
                                
                                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon) //4 //39mins create a coordinate from the unwrapped DataSnapshot
                                acceptVC.requestLocation = location //4 //40mins we want to be able to set the requestLocation
                                acceptVC.driverLocation = driverLocation
                                
                            } //4 //41mins Now we have the actual request locationa dn the email to the selected row for the AcceptRequestViewController.swift
                        }
                    }
                }
            }
        }
    }

}
