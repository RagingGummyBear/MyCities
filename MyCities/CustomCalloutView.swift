//
//  CustomCalloutView.swift
//  MyCities
//
//  Created by Cool Dude on 9/27/16.
//  Copyright © 2016 Organization Name. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    @IBOutlet var Text: UILabel!
    
    @IBOutlet var myImageView: UIImageView!
    
    
    
    @IBInspectable var lblTitleText : String?
        {
        get{
            return Text.text;
           // return "text"
        }
        set(lblTitleText)
        {
            Text.text = lblTitleText!;
        }
    }
    
    
    var reuseIdentifier = "CustomCalloutView"
    

    //var view:UIView!;

    class func instanceFromNib() -> UIView {

        return UINib(nibName: "CustomCalloutView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView;
    }
    
    
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AnnotationCalloutView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        //lblTitleText = " wtf?! ";
    }
    

    

    
    
}
