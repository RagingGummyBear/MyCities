//
//  ViewController.swift
//  MyCities
//
//  Created by Cool Dude on 9/14/16.
//  Copyright © 2016 Organization Name. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import TwitterKit
import UserNotifications


class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet var checkInButton: UIButton!
    
    @IBOutlet var seeTownButton: UIButton!
    
    @IBOutlet var aboutMainMenuButton: UIButton!
    
    @IBOutlet var addNewLocationButton: UIButton!
    
    @IBOutlet var exitMainMenuButton: UIButton!
    
    
    @IBOutlet var placeHolder: UIButton!
    @IBOutlet var playerStats: UILabel!
    @IBOutlet weak var testMap: MKMapView!
    
    var upperLeft = CLLocationCoordinate2D(latitude: 0,longitude: 0);
    var lowerRight = CLLocationCoordinate2D(latitude: 0,longitude: 0);
    var coordinateCenter = CLLocationCoordinate2D(latitude: 0,longitude: 0);
    var userSelectedMapRegion = MKCoordinateRegion();
    
    
    let locationManager = CLLocationManager()
    var googleLocationWebsite = "http://maps.googleapis.com/maps/api/geocode/json?latlng=";
    var googleLocationWebsiteTail = "&sensor=true";

    var playerStructures = [MapLocationAnnotation]();
    var playerTodayCheckins = [CLLocationCoordinate2D]();
    var structuresLoaded = false;
    var havePlayerLocation = false;
    var playerLocation:CLLocationCoordinate2D =  CLLocationCoordinate2D();
    
    var playerCurrentCity:String = "none";
    var playerHomeCity:String = "none";
    
    var canBuildStructure = false;
    var canCheckIn = false;
    
    var playerGold = 0;
    var playerPoints = 0;
    
    var shouldSaveCurrentCity = false;
    
    var checkInStruct: MapLocationAnnotation = MapLocationAnnotation(title: "Home");
    
    let notificationIdentifier = "InactivityNotificationIdentifier";
    let notificationTitle = "inactivity notification";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNotification();
        loadAllStructures();
        setUpTwitterLoginButton();
        getThePlayerLocationaNCity();
        annimateTheLabels();
        getAllCheckInsToday();
        setAllButtonsUp();
        //print("something")
        
        // Do any additional setup after loading the view, typically from a nib.
        
       // self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground

        playerStats.text = "You have : \nGold: \(playerGold) and Points: \(playerPoints)";
        
    }
    
    func setAllButtonsUp(){
        
        checkInButton.layer.cornerRadius = 5;
        
        seeTownButton.layer.cornerRadius = 5;
        
        aboutMainMenuButton.layer.cornerRadius = 5;
        
        addNewLocationButton.layer.cornerRadius = 5;
        
        //exitMainMenuButton.layer.cornerRadius = 5;
        
        
    }
    
    func getAllCheckInsToday(){
        
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        //let year =  components.year
        let month = components.month
        
        let day = components.day
        
        let defaults = UserDefaults.standard;
        let savedMonth = defaults.integer(forKey: "LastCheckInMonth");
        let savedDay = defaults.integer(forKey: "LastCheckInDay");
        
        //let sMonth = Int(savedMonth);
        //let sDay = Int(savedDay);
        
        
        //print("There is fail here somewhere \(savedDay) + \(day) + \(month) + \(savedMonth)")
        
        if( savedDay == day && savedMonth == month){
            
            let checkinsNumber = defaults.integer(forKey: "ToDayNumberOfCheckins");
            
            var lon:Double = 0.0;
            var lat:Double = 0.0;
            
            if(checkinsNumber > 0)
            {
                
              //  print("You have checked in today")
                
                
            for i in 0...checkinsNumber - 1 {
                lon = defaults.double(forKey: "CheckinNumberLon\(i)");
                lat = defaults.double(forKey: "CheckinNumberLat\(i)");
                
                playerTodayCheckins.append(CLLocationCoordinate2D(latitude: lat, longitude: lon));
                
            }
                
            }
            else
            {
                playerTodayCheckins = [CLLocationCoordinate2D]();
            }
            
        }
        else
        {
            playerTodayCheckins = [CLLocationCoordinate2D]();
            
          
          //  print("No checkins today")
            
            defaults.set(day, forKey: "LastCheckInDay");
            defaults.set(month, forKey: "LastCheckInMonth");
            defaults.set(0, forKey: "ToDayNumberOfCheckins");
            
            defaults.synchronize();
        }
        
        
    }
    
    
    func annimateTheLabels(){
        
        UIView.animate(withDuration: 1.5, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            
            //self.titleLabelFooter.center = CGPoint(x: 155, y: 91);
            
            }, completion: nil);
        
        
        self.checkInButton.alpha = 0
        
        self.seeTownButton.alpha = 0
        
        self.aboutMainMenuButton.alpha = 0
        
        self.addNewLocationButton.alpha = 0
        
        
        UIView.animate(withDuration: 1.5, animations: {
            
            self.checkInButton.alpha = 1.0
            
            self.seeTownButton.alpha = 1.0
            
            self.aboutMainMenuButton.alpha = 1.0
            
            self.addNewLocationButton.alpha = 1.0
            /*
            self.myFirstLabel.alpha = 1.0
            self.myFirstButton.alpha = 1.0
            self.mySecondButton.alpha = 1.0
 */
        })
        
        
    }
    
    
    func getThePlayerLocationaNCity (){
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.startUpdatingLocation()
            
        }
    }

    func setUpNotification(){
        
        //UIApplication.sharedApplication().cancelAllLocalNotifications();
        
        for notification in UIApplication.shared.scheduledLocalNotifications! {
            UIApplication.shared.cancelLocalNotification(notification)
            
     
        }
       
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        
        let notification = UILocalNotification()
        //notification.fireDate = NSDate(timeIntervalSinceNow: (60 * 24 * 60));
        notification.fireDate = Date(timeIntervalSinceNow: (30));
        notification.alertBody = "Hey! I require some love, LOVE ME!";
        notification.alertAction = "open";
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.userInfo = ["CustomField1": "w00t"];
        UIApplication.shared.scheduleLocalNotification(notification);
        
        
        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
        
        if settings.types == UIUserNotificationType() {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        

    }
    
    func setUpTwitterLoginButton(){
        
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y * 1.8);
    
        self.view.addSubview(logInButton)

    }
    
    func setCurrentCityAsHome(){
        
        let defaults = UserDefaults.standard;
        defaults.setValue(playerCurrentCity, forKey: "homeCityName")
        defaults.synchronize();
        playerHomeCity = playerCurrentCity;
        
    }
    
    
    func loadAllStructures(){
        
        let defaults = UserDefaults.standard;
        
        var playerStructureNumber = 0;
        //var tempStruct = MapLocationAnnotation(title: "Home");
        if defaults.bool(forKey: "hasStructures") {
            //playerStructures = defaults.arrayForKey("usersStructures") as! [MapLocationAnnotation];
            playerStructureNumber = defaults.integer(forKey: "StructureNumber");
            playerGold = defaults.integer(forKey: "playerGold");
            playerPoints = defaults.integer(forKey: "playerPoints");
            
            
            
            for i in 0...playerStructureNumber - 1  {
             
                playerStructures.append(loadPlayerStructure(i, defaults: defaults));
            }
            if !shouldSaveCurrentCity {
                playerHomeCity = defaults.string(forKey: "homeCityName")!;
            }
        }
        else
        {
            playerGold = 1300;
            playerPoints = 0;
            defaults.set(playerGold, forKey: "playerGold");
            defaults.set(playerPoints, forKey: "playerPoints");
            defaults.synchronize();

        }
        
         structuresLoaded = true;
        if havePlayerLocation {
            checkPlayersInfo();
        }
        
    }
    
    func loadPlayerStructure (_ num:Int, defaults: UserDefaults) -> MapLocationAnnotation{
        return MapLocationAnnotation(title: defaults.object(forKey: "structureTitle\(num)") as! String, benefits: structureTypes.dictionary[defaults.object(forKey: "structureTitle\(num)") as! String ]!, coordinate: CLLocationCoordinate2D(latitude: defaults.double(forKey: "playerStructureLocationLat\(num)"),
            longitude: defaults.double(forKey: "playerStructureLocationLon\(num)")),imgLocation:defaults.object(forKey: "playerStructImg\(num)")  as! String);
        

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        playerLocation = locValue;
        
        
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
          self.locationManager.stopUpdatingLocation();
        
        
        
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {

            
            let requestURL: URL = URL(string: "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(locValue.latitude),\(locValue.longitude)&sensor=true")!
            
            print("https://maps.googleapis.com/maps/api/geocode/json?latlng=\(locValue.latitude),\(locValue.longitude)&sensor=true")
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
            let session = URLSession.shared
      
            let task = session.dataTask(with : requestURL as URL, completionHandler: {
                (data, response, error) -> Void in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {

                    do{
                        var json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any]

                        
                                 // let results = json["results"]!![0]["address_components"]!![3]["long_name"];
                        
                        /*
                        let coordinateOrigin =
                            CLLocationCoordinate2D(latitude: json["results"]!![2]["geometry"]!!["bounds"]!!["northeast"]!!["lat"] as! Double,longitude: json["results"]!![2]["geometry"]!!["bounds"]!!["northeast"]!!["lng"] as! Double);
                        let coordinateMax =
                            CLLocationCoordinate2D(latitude: json["results"]!![2]["geometry"]!!["bounds"]!!["southwest"]!!["lat"] as! Double,longitude: json["results"]!![2]["geometry"]!!["bounds"]!!["southwest"]!!["lng"] as! Double);
                        
                        */
                       // self.coordinateCenter =  CLLocationCoordinate2D(latitude: json["results"]!![5]["geometry"]!!["location"]!!["lat"] as! Double,longitude: json["results"]!![2]["geometry"]!!["location"]!!["lng"] as! Double);
                       
                        //print("Heyo look below");
                        //print(json["results"]!![0]["address_components"]!![4]["long_name"])
                        
                        
                        let results = json["results"] as! [[String:Any]];
                        let addressComp = results[0]["address_components"] as! [[String:Any]];
                        
                        for var address in addressComp {
                            let types = address["types"] as! [String]
                            for var type in types {
                                if(type == "locality"){
                                    self.playerCurrentCity = address["long_name"] as! String;
                                    
                                }
                            }
                            
                        }
                        
                        
                        //self.playerCurrentCity = addressComp[3]["long_name"] as! String;
                        
                        
                        //self.playerCurrentCity = json["results"][0]["address_components"]!![3]["long_name"] as! String
                        print("Current city : \(self.playerCurrentCity) home city \(self.playerHomeCity)");
                        
                        
                        if(self.shouldSaveCurrentCity){
                            self.setCurrentCityAsHome();
                        }
                        
                        
                        
                        //print("Player current city " + self.playerCurrentCity);
                        self.havePlayerLocation = true;

                    }
                    catch{
                        print(error);
                    }
                    }
                
            })
            
            task.resume()
            

            DispatchQueue.main.async {
                
                if self.structuresLoaded {
                    self.checkPlayersInfo();
                }

                
            }
        }
        
        
    }
 
    
    func checkPlayersInfo(){
        
        if playerHomeCity == "none" {
            //print("Home city == none")
            canBuildStructure = true;
            canCheckIn = false;
        }
        else
        {
            if playerHomeCity == playerCurrentCity {
                
                checkPlayersSurroundings();
                
            }
            else
            {
                print("What is this? + \(playerHomeCity) + \(playerCurrentCity)");
                canBuildStructure = false;
                canCheckIn = false;
            }
        }

    }
    
    
    func checkPlayersSurroundings(){
        
        for structure in playerStructures {
            
            var x = structure.coordinate.latitude - playerLocation.latitude;
            var y = structure.coordinate.longitude - playerLocation.longitude;
            x = abs(x);
            y = abs(y);
            if ( x > 0.009 * 0.2 || y >  abs(1 / 111.320*cos(playerLocation.latitude)) * 0.2 ){
                canBuildStructure = true;
                canCheckIn = false;
               // print("x and y are bigger than 0.2 km :D x: \(x) && y: \(y) and this thing : \(1 / 111.320*cos(playerLocation.latitude) * 0.5)");
                
            }
            else
            {
                print("x and y are lower than 0.2 km :D x: \(x) && y: \(y) and this thing : \(1 / 111.320*cos(playerLocation.latitude) * 0.5)");
                checkInStruct = structure;
                canBuildStructure = false;
                canCheckIn = true;
                break;
            }
            
        }
        
    }
    
    
    @IBAction func saveLocationButton(_ sender: AnyObject) {
        
        self.userSelectedMapRegion = testMap.region;
    }

    @IBAction func returnToSavedLocationButton(_ sender: AnyObject) {
        testMap.setRegion(userSelectedMapRegion, animated: true);
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        checkPlayersInfo();
        
        if(identifier == "userWantsToAddNewBuilding"){
            
            if !canBuildStructure {
                let ac = UIAlertController(title: "Can't build", message: "Either you are in different city or you are too close to another location.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            }
            return canBuildStructure;
            
        }
        if( identifier == "checkInStructureSegueIdentifier" ){
            
            //var flag = false;
            
            if(canCheckIn){
                
           // for elem in playerStructures {
            
                for loc in playerTodayCheckins {
                    
                    //print("This is working ");
                    
                    if (loc.latitude == checkInStruct.coordinate.latitude && loc.longitude == checkInStruct.coordinate.longitude)
                    {
                        print("locations : \(loc.latitude) + \(loc.longitude) + Elem : \(checkInStruct.coordinate.latitude) + \(checkInStruct.coordinate.longitude) + name \(checkInStruct.title)");
                        
                        let ac = UIAlertController(title: "Can't check in", message: "You already checked in to this location.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        present(ac, animated: true, completion: nil)
                        
                        return false;
                    }
                }
                
           // }
            }
            
            if !canCheckIn {
                let ac = UIAlertController(title: "Can't check in", message: "There aren't any nearby locations.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            }
            
            
            return canCheckIn;
        }
        
        
        return true;
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if(segue.identifier == "userWantsToAddNewBuilding"){
            let dest = segue.destination as? TransitionNavigationController
            if dest != nil
            {
                dest?.userLocation = playerLocation;
                dest?.userLocationSet = true;
        
            }
           
        }
        
        if ( segue.identifier == "checkInStructureSegueIdentifier" ) {
            
            let dest = segue.destination as? TransitionNavigationController
            if dest != nil
            {
                dest?.checkInStruct = self.checkInStruct;
                
            }
        }
        
        
    }
    
    override var canBecomeFirstResponder : Bool {
        return true;
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
            if motion == .motionShake {
                
                checkInButton.sendActions(for: UIControlEvents.touchUpInside);
                
            }
        
    }

}

