//
//  CheckedInViewController.swift
//  MyCities
//
//  Created by Cool Dude on 10/3/16.
//  Copyright © 2016 Organization Name. All rights reserved.
//

import UIKit
import TwitterKit


class CheckedInViewController: UIViewController {
    
    @IBOutlet var shareOnTwitterButton: UIButton!
    @IBOutlet var structTitleLabel: UILabel!
    
    @IBOutlet var StructureImage: UIImageView!
    @IBOutlet var playerStatsLabel: UILabel!
    
    @IBAction func shareOnFacebookButton(_ sender: AnyObject) {
        
        let composer = TWTRComposer()
        let defaults = UserDefaults.standard;
        composer.setText("Just checked in at \(checkInStruct.title!) and I'm rocking \(defaults.integer(forKey: "playerPoints")) points!!! #MyCity")
        composer.setImage(UIImage(named: "fabric"))
        
        // Called from a UIViewController
        composer.show(from: self) { result in
            if (result == TWTRComposerResult.cancelled) {
                print("Tweet composition cancelled")
            }
            else {
                print("Sending tweet!")
            }
        }
      
    }
    
    var checkInStruct: MapLocationAnnotation = MapLocationAnnotation(title: "Home");

    override func viewDidLoad() {
        
        super.viewDidLoad()

        shareOnTwitterButton.layer.cornerRadius = 5;
        
        structTitleLabel.text = checkInStruct.title;
        
        DispatchQueue.global(qos: .background).async {
            
            // Validate user input
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            
            let getImagePath = paths + self.checkInStruct.image;
            
            var img = UIImage(contentsOfFile: getImagePath)
            
            if img != nil {
               
               // img = img!.rotated(by: 90);
            }
            
            // Go back to the main thread to update the UI
            DispatchQueue.main.async {
                
                
                self.StructureImage.image = img;
                
            }
        }
     
        
        checkIn();

        
        
        // Do any additional setup after loading the view.
    }

    func checkIn(){
        
        
       
        var tempStr = checkInStruct.benefits.characters.split{ $0 == "\n" }.map(String.init);
        tempStr[1] = tempStr[1].characters.split{ $0 == ":" }.map(String.init)[1];
        tempStr[0] = tempStr[0].characters.split{ $0 == ":" }.map(String.init)[1];
        tempStr[1] = tempStr[1].characters.split{ $0 == " " }.map(String.init)[0];
        tempStr[0] = tempStr[0].characters.split{ $0 == " " }.map(String.init)[0];
        let coins = Int(tempStr[1])!;
        let points = Int(tempStr[0])!;
        
    
        let defaults = UserDefaults.standard;
        var playerGold = defaults.integer(forKey: "playerGold");
        var playerPoints = defaults.integer(forKey: "playerPoints");
        
        playerGold += coins;
        playerPoints += points;
        
        defaults.set(playerGold, forKey: "playerGold");
        defaults.set(playerPoints, forKey: "playerPoints");
        
        var checkinsNumber = defaults.integer(forKey: "ToDayNumberOfCheckins");
        //lon = defaults.doubleForKey("CheckinNumberLon\(i)");
        //lat = defaults.doubleForKey("CheckinNumberLat\(i)");
        defaults.set(checkInStruct.coordinate.latitude, forKey: "CheckinNumberLat\(checkinsNumber)")
        defaults.set(checkInStruct.coordinate.longitude, forKey: "CheckinNumberLon\(checkinsNumber)")
        checkinsNumber += 1;
        defaults.set(checkinsNumber, forKey: "ToDayNumberOfCheckins");
        
        print("There was a checkin \(checkinsNumber)" );
        defaults.synchronize();
        
        playerStatsLabel.text = "Now you have:\nGold: \(playerGold)\nPoints: \(playerPoints)";
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    

}
