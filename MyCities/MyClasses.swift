//
//  MyClasses.swift
//  MyCities
//
//  Created by Cool Dude on 9/27/16.
//  Copyright © 2016 Organization Name. All rights reserved.
//

import Foundation;
import MapKit;


var structureTypes = StructureTypesAndBenefits();

class MapLocation{
    
    var name:String = "Basic Structure";
    
    var locationLat:Double = 0.0;
    var locationLon:Double = 0.0;
    
    var mapPictureOfLocation = "";
    var structureIcon = "";
    
    var mapPointColor = "red";
    
}

extension Double {
    func toRadians() -> CGFloat {
        return CGFloat(self * .pi / 180.0)
    }
}


extension UIImage {
    func rotated(by degrees: Double, flipped: Bool = false) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let transform = CGAffineTransform(rotationAngle: degrees.toRadians())
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: rect.size)
            return renderer.image { renderContext in
                renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
                renderContext.cgContext.rotate(by: degrees.toRadians())
                renderContext.cgContext.scaleBy(x: flipped ? -1.0 : 1.0, y: -1.0)
                
                let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
                renderContext.cgContext.draw(cgImage, in: drawRect)
            }
        } else {
            // Fallback on earlier versions
            return nil;
        }
       
    }
}


class StructureTypesAndBenefits
{
   var dictionary = [ String : String ]();
    
    init(){
        
        dictionary["Home"] = "Points : 40 \n Coins : 200 \n Cost in coins: 1000";
        dictionary["Work"] = "Points : 0 \n Coins : 100  \n Cost in coins: 200";
        dictionary["Park"] = "Points : 35 \n Coins : 0 \n Cost in coins: 20";
        dictionary["Viewpoint"] = "Points : 25 \n Coins : 0 \n Cost in coins: 10";
        dictionary["Sculpture"] = "Points : 30 \n Coins : 0 \n Cost in coins: 15";
        dictionary["Supermarket"] = "Points : 50 \n Coins : -5 \n Cost in coins: 50";
        dictionary["Mall"] = "Points : 70 \n Coins : -10 \n Cost in coins: 80";
        dictionary["Restaurant"] = "Points : 100 \n Coins : -20 \n Cost in coins: 30";
        dictionary["Bar"] = "Points : 90 \n Coins : -15 \n Cost in coins: 70";
        dictionary["Gym"] = "Points : 5 \n Coins : 5 \n Cost in coins: 30";
        
        
    }
    
    
}

class MapLocationAnnotation : NSObject,MKAnnotation {

    let benefits: String
   // let discipline: String
    let coordinate: CLLocationCoordinate2D
    var title: String?
    var image :String = "";
    
    
    init(title: String, benefits: String, coordinate: CLLocationCoordinate2D, imgLocation: String) {

        self.title = title;
        self.benefits = benefits
        //self.discipline = discipline
        self.coordinate = coordinate
        self.image = imgLocation;
        super.init()
    }
    
    var subtitle: String?{
        return "";
    }
    
    init(title : String){
        self.title = title;
        self.coordinate = CLLocationCoordinate2D();
        self.benefits = structureTypes.dictionary[title]!;
        super.init();
    }
    
    init(title: String, coordinates: CLLocationCoordinate2D){
        self.title = title;
        self.coordinate = coordinates;
        self.benefits = structureTypes.dictionary[title]!;
        super.init();
    }
    
    func changeTitle(_ str :String){
        self.title = str;
    }
  
   
    
}



class StarbucksAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var phone: String!
    var name: String!
    var address: String!
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
