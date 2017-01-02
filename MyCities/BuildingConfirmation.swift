//
//  BuildingConfirmation.swift
//  MyCities
//
//  Created by Cool Dude on 10/1/16.
//  Copyright © 2016 Organization Name. All rights reserved.
//

import UIKit
import MapKit

class BuildingConfirmation: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var selectedBuilding:String = "";
    var userLocation:CLLocationCoordinate2D = CLLocationCoordinate2D();
    var structImgLoc:String = "" ;
    var structureTypes = StructureTypesAndBenefits();
    var userStruct = MapLocationAnnotation(title: "none",benefits: "none",coordinate: CLLocationCoordinate2D(),imgLocation:" ");
    var allPlayerStructures = [MapLocationAnnotation]();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userStruct = MapLocationAnnotation(title: selectedBuilding, benefits: structureTypes.dictionary[selectedBuilding]!, coordinate: userLocation,imgLocation:structImgLoc);
        
        mapView.addAnnotation(userStruct);
        loadAllPlayerStructures();
        
        let latitude:CLLocationDegrees = userStruct.coordinate.latitude;
        
        let longitude:CLLocationDegrees = userStruct.coordinate.longitude;
        
        let latDelta:CLLocationDegrees = 0.05;
        
        let lonDelta:CLLocationDegrees = 0.05;
        
        let span = MKCoordinateSpanMake(latDelta, lonDelta);
        
        let location = CLLocationCoordinate2DMake(latitude, longitude);
        
        let region = MKCoordinateRegionMake(location, span);
        
        mapView.setRegion(region, animated: true);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func saveStructure(_ structure: MapLocationAnnotation ){
        
        let defaults = UserDefaults.standard;
        var playerBuildingNum = defaults.integer(forKey: "StructureNumber");

        defaults.set(userStruct.title, forKey: "structureTitle\(playerBuildingNum)");
        defaults.set(self.userLocation.latitude, forKey: "playerStructureLocationLat\(playerBuildingNum)");
        defaults.set(self.userLocation.longitude, forKey: "playerStructureLocationLon\(playerBuildingNum)");
        defaults.set(true, forKey: "hasStructures");
        defaults.set(structImgLoc, forKey: "playerStructImg\(playerBuildingNum)");
        playerBuildingNum += 1;
        defaults.set(playerBuildingNum, forKey: "StructureNumber");
        defaults.synchronize();
        
    }
    
    
    func loadAllPlayerStructures(){
        
        allPlayerStructures = [MapLocationAnnotation]();
        let defaults = UserDefaults.standard;
        let playerBuildingNum = defaults.integer(forKey: "StructureNumber");
        
        let priority = DispatchQueue.GlobalQueuePriority.default
        
        DispatchQueue.global(priority: priority).async {
            if(playerBuildingNum > 0) {
            for i in 0...playerBuildingNum - 1 {
                
                self.allPlayerStructures.append(self.loadPlayerStructure(i, defaults: defaults));
                self.mapView.addAnnotation(self.loadPlayerStructure(i, defaults: defaults));
                }
            }
           
            
            
        }
        
        
    }
    
    
    func loadPlayerStructure (_ num:Int, defaults: UserDefaults) -> MapLocationAnnotation{
        if defaults.string(forKey: "structureTitle\(num)") != nil
        {
            return  MapLocationAnnotation(title: defaults.object(forKey: "structureTitle\(num)") as! String, benefits: structureTypes.dictionary[defaults.object(forKey: "structureTitle\(num)") as! String ]!, coordinate: CLLocationCoordinate2D(latitude: defaults.double(forKey: "playerStructureLocationLat\(num)"),
                longitude: defaults.double(forKey: "playerStructureLocationLon\(num)")),imgLocation:defaults.object(forKey: "playerStructImg\(num)")  as! String);
        
           
        }
        else
        {
            print("This is nil?!")
            return MapLocationAnnotation(title: "Home");
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PlayerStructureAddedSegue" {
            saveStructure(userStruct);
            
            var tempStr = userStruct.benefits.characters.split{ $0 == "\n" }.map(String.init);
            tempStr[2] = tempStr[2].characters.split{ $0 == ":" }.map(String.init)[1];
            tempStr[0] = tempStr[0].characters.split{ $0 == ":" }.map(String.init)[1];
            tempStr[2] = tempStr[2].characters.split{ $0 == " " }.map(String.init)[0];
            tempStr[0] = tempStr[0].characters.split{ $0 == " " }.map(String.init)[0];
            let coins = Int(tempStr[2])!;
            
            
            let defaults = UserDefaults.standard;
            
            var playerCoins = defaults.integer(forKey: "playerGold");
            
            if playerCoins >= coins {
                playerCoins -= coins;
                defaults.set(playerCoins, forKey: "playerGold")
                defaults.synchronize();
            }
            
            if let nextView = segue.destination as? ViewController {
                
                nextView.shouldSaveCurrentCity = true;
                
            }
        }
        
    }
    

}
