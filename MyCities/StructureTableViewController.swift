//
//  StructureTableViewController.swift
//  MyCities
//
//  Created by Cool Dude on 9/27/16.
//  Copyright © 2016 Organization Name. All rights reserved.
//

import UIKit
import MapKit

class StructureTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var takePhotoButton: UIBarButtonItem!
    var elements : StructureTypesAndBenefits = StructureTypesAndBenefits();
    var selectedStructure = "none";
    var userLocationSet = false;
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D();
    var hasPickture = false;
    var structImgLocation:String = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //print("View loaded with : \(userLocationSet) and player Location : \(userLocation)");
        
        let defaults = UserDefaults.standard;
        if !defaults.bool(forKey: "hasStructures") {
         selectedStructure = "Home";
            //UIApplication.sharedApplication().sendAction(takePhotoButton.action, to: takePhotoButton.target, from: self, forEvent: nil)
            //takePhotoButton.performSelector((self.navigationItem.rightBarButtonItem?.action)!);
            //self.navigationItem.rightBarButtonItem.performSelector();
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return elements.dictionary.keys.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StructureSelectionCellIdentity", for: indexPath) as! StructureSelectionCell
        cell.structureType.text = Array(elements.dictionary.keys)[indexPath.row]
        cell.structureBenefits.text = elements.dictionary[Array(elements.dictionary.keys)[indexPath.row]]
        
        
        
        // Configure the cell...
        
        return cell

    }
 
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if(identifier == "confirmationStructureSegue"){
            
            // takePhoto();
            
            print("woops this happened");
            	
            if(selectedStructure == "none" || !userLocationSet || !hasPickture)
            {		
                
                return false;
            }
            else {

                return true;
                
            }
            
        }
      //  print("we have diffferent segue");
        
        return true;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let newView = segue.destination as? BuildingConfirmation
        {

            newView.userLocation = self.userLocation;
            newView.selectedBuilding = self.selectedStructure;
            newView.structImgLoc = self.structImgLocation;
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let defaults = UserDefaults.standard;
        if defaults.bool(forKey: "hasStructures") {
        selectedStructure = Array(elements.dictionary.keys)[indexPath.row];
        let myAnnotation = MapLocationAnnotation(title: selectedStructure);
        var tempStr = myAnnotation.benefits.characters.split{ $0 == "\n" }.map(String.init);
        tempStr[2] = tempStr[2].characters.split{ $0 == ":" }.map(String.init)[1];
        tempStr[0] = tempStr[0].characters.split{ $0 == ":" }.map(String.init)[1];
        tempStr[2] = tempStr[2].characters.split{ $0 == " " }.map(String.init)[0];
        tempStr[0] = tempStr[0].characters.split{ $0 == " " }.map(String.init)[0];
        let coins = Int(tempStr[2])!;
        
        
        let defaults = UserDefaults.standard;
        
        let playerCoins = defaults.integer(forKey: "playerGold");
        
        if playerCoins >= coins {
            //playerCoins -= coins;
            //defaults.setInteger(playerCoins, forKey: "playerGold")
            //defaults.synchronize();
            
        }
        else {
            print("Not enough gold");
            
            let ac = UIAlertController(title: "You have \(playerCoins)", message: "You don't have enough coins for \(selectedStructure).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)

            
            selectedStructure = "none";
        }

        }
     
        
    }
    @IBAction func whelpFunction(_ sender: AnyObject) {
        
        if (selectedStructure == "none" || !userLocationSet)
        {
            
            let ac = UIAlertController(title: "Can't continiue", message: "You bundle a building.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            
            
        }
        else {
        
            takePhoto();
        }
    }

    func takePhoto(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
/*
        let pick =  UIImagePickerController();
        pick.delegate = self;
        pick.sourceType = .Camera;
        
        presentViewController(pick, animated: true, completion: nil);
 */
    }
    
    
        
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
       
        for key in info.keys {
            print("key\(key)");
        }
        
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage;
        /*
        if (img!.CIImage != nil) {
            img =  UIImage(CIImage: img!.CIImage!, scale: CGFloat(1.0), orientation: .Up);
        }
 
        if img!.CGImage != nil {
            img =   UIImage(CGImage: img!.CGImage!, scale: CGFloat(1.0), orientation: .Down);
        }
        */
        /*
        UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil);
        
        print ("W2ell this is : \(img)");
        */
        let defaults = UserDefaults.standard;
        var playerBuildingNum = defaults.integer(forKey: "StructureNumber");
        playerBuildingNum += 1;

        let imageData = UIImageJPEGRepresentation(img!,100)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let imagePath = paths + "/structImg\(playerBuildingNum).png"
        
        if !((try? imageData!.write(to: URL(fileURLWithPath: imagePath), options: [])) != nil)
        {
            print("not saved \(imagePath)")
        } else {
            print("saved")
            structImgLocation = "/structImg\(playerBuildingNum).png";
            hasPickture = true;
            
            self.performSegue(withIdentifier: "confirmationStructureSegue", sender: self)
            
            //NSUserDefaults.standardUserDefaults().setObject(imagePath, forKey: "imagePath")
        }
        
        
        dismiss(animated: true, completion: nil);
        
        
    }

}
