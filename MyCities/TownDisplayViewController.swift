//
//  TownDisplayViewController.swift
//  MyCities
//
//  Created by Cool Dude on 9/26/16.
//  Copyright © 2016 Organization Name. All rights reserved.
//

import UIKit
import MapKit;
import CoreLocation

class TownDisplayViewController: UIViewController,MKMapViewDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    
    var mapRegion = MKCoordinateRegion();
    var hasStartinglocation = false;
    var structureBenefits = StructureTypesAndBenefits();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.mapView.delegate = self;
        setStartingLocation();
        loadAllAnnotations();
        
    }
    
    func setStartingLocation(){
        
        
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "TownRegionhasStartingLoc"){
            
            let centerLat = defaults.double(forKey: "TownRegionCenterLat");
            let centerLon = defaults.double(forKey: "TownRegionCenterLon");
            let spanLat = defaults.double(forKey: "TownRegionSpanLat");
            let spanlon = defaults.double(forKey: "TownRegionSpanLon");
            
            hasStartinglocation = true;
            createMapRegion(centerLat, centerLon: centerLon, spanLat: spanLat, spanLon: spanlon);
        }
        
    }
    
    func saveCoordinates(){
        let defaults = UserDefaults.standard;
        
        defaults.set(true, forKey: "TownRegionhasStartingLoc");
        defaults.set(mapView.region.center.latitude, forKey: "TownRegionCenterLat");
        defaults.set(mapView.region.center.longitude, forKey: "TownRegionCenterLon");
        defaults.set(mapView.region.span.latitudeDelta, forKey: "TownRegionSpanLat");
        defaults.set(mapView.region.span.longitudeDelta, forKey: "TownRegionSpanLon");
        
        defaults.synchronize();
        
    }
    
    func createMapRegion(_ centerLat: Double, centerLon: Double,spanLat:Double,spanLon:Double){
        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLat,longitude: centerLon), span: MKCoordinateSpan(latitudeDelta: spanLat,longitudeDelta: spanLon))
        mapView.setRegion(mapRegion, animated: true)
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

    @IBAction func goToSavedLocation(_ sender: AnyObject) {
        if(hasStartinglocation) {
            mapView.setRegion(mapRegion, animated: true);
        }
    }

    @IBAction func savePositionAction(_ sender: AnyObject) {
    
      mapRegion = MKCoordinateRegion(center: mapView.region.center,span: mapView.region.span)
        
        saveCoordinates();
        
        
    }
    
    
    func loadAllAnnotations(){
        
        loadAllPlayerStructures();
        }
    
    
    
    func loadAllPlayerStructures(){
        
        //allPlayerStructures = [MapLocationAnnotation]();
        let defaults = UserDefaults.standard;
        let playerBuildingNum = defaults.integer(forKey: "StructureNumber");
        
        let priority = DispatchQueue.GlobalQueuePriority.default
        
        DispatchQueue.global(priority: priority).async {
            if(playerBuildingNum > 0) {
                for i in 0...playerBuildingNum - 1 {
                    
                    //self.allPlayerStructures.append(self.loadPlayerStructure(i, defaults: defaults));
                    self.mapView.addAnnotation(self.loadPlayerStructure(i, defaults: defaults));
                   
                }
                
            }

            DispatchQueue.main.async {
                if(self.hasStartinglocation) {
                    self.mapView.setRegion(self.mapRegion, animated: true)
                
                }
                
            }
            
        }
        
        
    }
    
    
    func loadPlayerStructure (_ num:Int, defaults: UserDefaults) -> MapLocationAnnotation{
        if defaults.string(forKey: "structureTitle\(num)") != nil
        {
            
            
            return MapLocationAnnotation(title: defaults.object(forKey: "structureTitle\(num)") as! String, benefits: structureTypes.dictionary[defaults.object(forKey: "structureTitle\(num)") as! String ]!, coordinate: CLLocationCoordinate2D(latitude: defaults.double(forKey: "playerStructureLocationLat\(num)"),
                longitude: defaults.double(forKey: "playerStructureLocationLon\(num)")),imgLocation:defaults.object(forKey: "playerStructImg\(num)")  as! String);
            
            
            // return MapLocationAnnotation(title: "",benefits: structureBenefits.dictionary[defaults.objectForKey("structureTitle\(num)") as! String]! ,coordinate: CLLocationCoordinate2D(latitude: defaults.doubleForKey("playerStructureLocationLat\(num)"),longitude: defaults.doubleForKey("playerStructureLocationLon\(num)")) );
            
        }
        else
        {
            print("This is nil?!")
            return MapLocationAnnotation(title: "Home");
        }
    }

    
    
    
    //Annotation copy pasta from stackoverflow
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
        if annotation is MKUserLocation {
            return nil
        }
        
        
        let identifier = "MyCustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
       // let mapLocationAnno = annotation as! MapLocationAnnotation;
        if let mapLocationAnno = annotation as? MapLocationAnnotation {
            
            configureDetailView(annotationView!,myAnnotation: mapLocationAnno);
        }
        
        return annotationView
        
        }

    
    
    
    
    
    
    
    
    func fixOrientation(_ img:UIImage?) -> UIImage {
        
     // UIImage(CIImage: <#T##CIImage#>, scale: <#T##CGFloat#>, orientation: <#T##UIImageOrientation#>)
        
        
        if (img != nil) {
            
        if img!.ciImage != nil {
          return  UIImage(ciImage: img!.ciImage!, scale: CGFloat(1.0), orientation: .right);
        }
        
        if img!.cgImage != nil {
            return  UIImage(ciImage: img!.ciImage!, scale: CGFloat(1.0), orientation: .right);
        }
        }
        else
        {
            print("img is nil")
            ;        }
        print("All are nil");
        return img!;
        
    }
    
    

    
    
    
    
    func configureDetailView(_ annotationView: MKAnnotationView, myAnnotation: MapLocationAnnotation) {
       // let width = 300
        //let height = 200
        
        let snapshotView = CustomCalloutView()
        let views = ["snapshotView": snapshotView]
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(290)]", options: [], metrics: nil, views: views))
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(236)]", options: [], metrics: nil, views: views))
        
        snapshotView.loadViewFromNib();
        
        var tempStr = myAnnotation.benefits.characters.split{ $0 == "\n" }.map(String.init);
        tempStr[1] = tempStr[1].characters.split{ $0 == ":" }.map(String.init)[1];
        tempStr[0] = tempStr[0].characters.split{ $0 == ":" }.map(String.init)[1];
        tempStr[1] = tempStr[1].characters.split{ $0 == " " }.map(String.init)[0];
        tempStr[0] = tempStr[0].characters.split{ $0 == " " }.map(String.init)[0];
        let coins = Int(tempStr[1])!;
        let points = Int(tempStr[0])! ;
        
        
        snapshotView.lblTitleText = "If you check in here you will recieve \(coins) coins and \(points) points" ;
        
        DispatchQueue.global(qos: .background).async {
            
            // Validate user input
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            
            let getImagePath = paths + myAnnotation.image;
            
            var img = UIImage(contentsOfFile: getImagePath)

            if img != nil {
              //  img = img!.rotated(by: 90);
            }
            
            // Go back to the main thread to update the UI
            DispatchQueue.main.async {
                
                snapshotView.myImageView.image = img;
                
            }
        }
       

        //snapshotView.myImageView.image = fixOrientation(UIImage(contentsOfFile: myAnnotation.image));
        
        //snapshotView.lblTitleText = "Hey yo";
        
        annotationView.detailCalloutAccessoryView = snapshotView
        
        //annotationView.backgroundColor = UIColor(red: 255, green: 0, blue: 255, alpha: 1);
        
        //annotationView.callout
    }
    
    
    
    
    func rotateCameraImageToProperOrientation(_ imageSource : UIImage, maxResolution : CGFloat = 320) -> UIImage? {
        
        guard let imgRef = imageSource.cgImage else {
            return nil
        }
        
        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))
        
        switch(imageSource.imageOrientation) {
        case .up:
            transform = .identity
        case .upMirrored:
            transform = CGAffineTransform
                .init(translationX: imageSize.width, y: 0)
                .scaledBy(x: -1.0, y: 1.0)
        case .down:
            transform = CGAffineTransform
                .init(translationX: imageSize.width, y: imageSize.height)
                .rotated(by: CGFloat.pi)
        case .downMirrored:
            transform = CGAffineTransform
                .init(translationX: 0, y: imageSize.height)
                .scaledBy(x: 1.0, y: -1.0)
        case .left:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: 0, y: imageSize.width)
                .rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .leftMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: imageSize.height, y: imageSize.width)
                .scaledBy(x: -1.0, y: 1.0)
                .rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: imageSize.height, y: 0)
                .rotated(by: CGFloat.pi / 2.0)
        case .rightMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(scaleX: -1.0, y: 1.0)
                .rotated(by: CGFloat.pi / 2.0)
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            if orient == .right || orient == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }
            
            context.concatenate(transform)
            context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy
    }
    
    
    
    
   
        

    
 
}



