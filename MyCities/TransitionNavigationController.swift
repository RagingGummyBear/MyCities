//
//  TransitionNavigationController.swift
//  MyCities
//
//  Created by Cool Dude on 10/1/16.
//  Copyright © 2016 Organization Name. All rights reserved.
//

import UIKit
import MapKit

class TransitionNavigationController: UINavigationController {
    
    var userLocation = CLLocationCoordinate2D();
    var userLocationSet = false;
    var userFirstBuilding = false;
    var checkInStruct : MapLocationAnnotation = MapLocationAnnotation(title: "Home");
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let newView = self.viewControllers[0] as? StructureTableViewController
        {
            //print("W00t?")
            newView.userLocationSet = self.userLocationSet;
            newView.userLocation = self.userLocation;
        }
        
        if let newView = self.viewControllers[0] as? CheckedInViewController
        {
            //print("W00t?")
            newView.checkInStruct = self.checkInStruct;

        }
        
        // Do any additional setup after loading the view.
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        //print("Destination :  \(segue.destinationViewController.nibName)");
        /*
        if(segue.identifier == "userWantsToAddNewBuilding"){
            var dest = segue.destinationViewController as? TransitionNavigationController
            if dest != nil
            {
                dest?.userLocation = playerLocation;
                dest?.userLocationSet = true;
                
            }
            
        }
 */
        
        
    }

}
