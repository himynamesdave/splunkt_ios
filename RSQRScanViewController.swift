//
//  RSQRScanViewController.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import UIKit

import Foundation
import AVFoundation


class RSQRScanViewController : UIViewController,  ZBarReaderDelegate{
    
    var reader : ZBarReaderViewController!
    
    var firstName = ""
    var secondName = ""
    var  companyEmail = ""
    
  
    func initNavigationBar()
    {
        self.setNavigationBar()
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        var addEventName = defaults.valueForKey("addEventName") as! String!
        self.navigationItem.title = addEventName
        
        
        var refreshButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "toggleLeft")
        navigationItem.backBarButtonItem = refreshButton
        //
        var rightButtonArray : Array<UIBarButtonItem> = []
        var staff_email = defaults.valueForKey("staff_email") as! String!
        
        var index = staff_email.indexOf("@") as Int!
        
        staff_email = staff_email.substringToIndex(index)
        
        
        var rightButton1: UIBarButtonItem = UIBarButtonItem(title: staff_email, style: UIBarButtonItemStyle.Bordered, target: self, action: "toggleRight")
        
        var rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout")!, style: UIBarButtonItemStyle.Bordered, target: self, action: "toggleRight")
        
        rightButtonArray.append(rightButton)
        rightButtonArray.append(rightButton1)
        
        navigationItem.rightBarButtonItems = rightButtonArray
        
    }

    
    override func toggleRight() {
        
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    override func toggleLeft(){
        
        self.navigationController!.popToRootViewControllerAnimated(true)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
        self.initNavigationBar()
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "startView", andValue: "viewWillAppear"))
        Mint.sharedInstance().logViewWithCurrentViewName("QRScanViewController", limitedExtraDataList: datalist)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "closeView", andValue: "viewDidDisappear"))
        Mint.sharedInstance().logViewWithCurrentViewName("QRScanViewController", limitedExtraDataList: datalist)
    }
    
   
    override func shouldAutorotate() -> Bool {
        
        return true
    }
    
    @IBAction func scanAction(sender: AnyObject) {
        
        // ADD: present a barcode reader that scans from the camera feed
         reader = ZBarReaderViewController()
        reader.readerDelegate = self
        
        var scanner  =  reader.scanner as ZBarImageScanner
    
        scanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)
        
        // present and release the controller
        presentViewController(reader, animated: true, completion: nil)
    
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
         println("UIImagePickerController:scan")
       
        
          var data = info as NSDictionary

        var results: NSFastEnumeration = data.objectForKey(ZBarReaderControllerResults) as! NSFastEnumeration
        
        var symbolFound : ZBarSymbol?
        
        for symbol in results as! ZBarSymbolSet {
            symbolFound = symbol as? ZBarSymbol
            break
        }
      
        var resultString = NSString(string: symbolFound!.data)
        
         println("data\(resultString)")
        
        var result =  resultString as String!
        
        Constants.sharedInstance.leadData.first_name = ""
        Constants.sharedInstance.leadData.second_name = ""
        Constants.sharedInstance.leadData.company_email = ""
        
        if(result != nil && result?.length > 0)
        {
            Constants.sharedInstance.leadData.qr_data = result
            
            
            if(self.checkStr1_spec(result))
            {
                Constants.sharedInstance.leadData.first_name = self.firstName;
                Constants.sharedInstance.leadData.second_name = self.secondName;
                Constants.sharedInstance.leadData.company_email = self.companyEmail;
                
            }else if(self.checkStr1_5comment(result))
            {
                Constants.sharedInstance.leadData.first_name = self.firstName;
                Constants.sharedInstance.leadData.second_name = self.secondName;
                Constants.sharedInstance.leadData.company_email = self.companyEmail;
            }else if(self.checkStr1_space(result))
            {
                Constants.sharedInstance.leadData.first_name = self.firstName;
                Constants.sharedInstance.leadData.second_name = self.secondName;
                Constants.sharedInstance.leadData.company_email = self.companyEmail;
            }
            else  if(self.checkStr1_nospace(result))
            {   Constants.sharedInstance.leadData.first_name = self.firstName;
                Constants.sharedInstance.leadData.second_name = self.secondName;
                Constants.sharedInstance.leadData.company_email = self.companyEmail;
                
            }
            
        }
        
        self.showShirtSloganViewController()
        
        reader.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showShirtSloganViewController()
    {
        
        println("showShirtSloganViewController")
        
    
        var defaults = NSUserDefaults.standardUserDefaults()
        
        var showShirt =  defaults.valueForKey("showShirt") as! Bool!
        
        if(showShirt == true)
        {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let shirtSloganViewController = storyBoard.instantiateViewControllerWithIdentifier("shirtSloganViewController") as! ShirtSloganViewController
            
            self.navigationController!.pushViewController(shirtSloganViewController, animated: true)
            
        }else
        {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let useCaseViewController = storyBoard.instantiateViewControllerWithIdentifier("useCaseViewController") as! UseCaseViewController
            
            self.navigationController!.pushViewController(useCaseViewController, animated: true)
        }
    }

    
    
    func checkStr1_spec (fullStr1 : NSString!) ->Bool{
        
        var fullStr = fullStr1 as NSString
        
        firstName = ""
        secondName = ""
        companyEmail = ""
        
        var range: NSRange = fullStr.rangeOfString("firstname=")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        fullStr = fullStr.substringFromIndex(range.location + 10)
        
        range = fullStr.rangeOfString(",")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        firstName = fullStr.substringToIndex(range.location)
        
        fullStr = fullStr.substringFromIndex(range.location + 1)
        
        range = fullStr.rangeOfString("secondname=")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        
        fullStr = fullStr.substringFromIndex(range.location + 11)
        
        range = fullStr.rangeOfString(",")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        secondName = fullStr.substringToIndex(range.location)
        
        fullStr = fullStr.substringFromIndex(range.location + 1)
        
        range = fullStr.rangeOfString("email=")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        
        
        companyEmail = fullStr.substringFromIndex(range.location + 6)
        
        
        return true;
    }
    
    
    func checkStr1_5comment (fullStr1 : NSString!) ->Bool{
        
        var fullStr = fullStr1 as NSString
        
        var firstName = ""
        var secondName = ""
        var  companyEmail = ""
        
        var range: NSRange = fullStr.rangeOfString(", ")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        firstName = fullStr.substringToIndex(range.location)
        
        fullStr = fullStr.substringFromIndex(range.location + 2)
        
        range = fullStr.rangeOfString(", ")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        secondName = fullStr.substringToIndex(range.location)
        
        fullStr = fullStr.substringFromIndex(range.location + 2)
        
        range = fullStr.rangeOfString(", ")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        companyEmail = fullStr.substringFromIndex(range.location)
        
        return true;
    }
    
    
    func checkStr1_space (fullStr1 : NSString!) ->Bool{
        
        
        var fullStr = fullStr1 as NSString
        
        var firstName = ""
        var secondName = ""
        var  companyEmail = ""
        
        var range: NSRange = fullStr.rangeOfString(", ")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        firstName = fullStr.substringToIndex(range.location)
        
        fullStr = fullStr.substringFromIndex(range.location + 2)
        
        range = fullStr.rangeOfString(", ")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        secondName = fullStr.substringToIndex(range.location)
        companyEmail = fullStr.substringFromIndex(range.location + 2)
        
        return true;
    }
    
    
    func checkStr1_nospace (fullStr1 : NSString!) ->Bool{
        
        
        var fullStr = fullStr1 as NSString
        
        var firstName = ""
        var secondName = ""
        var companyEmail = ""
        
        var range: NSRange = fullStr.rangeOfString(",")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        firstName = fullStr.substringToIndex(range.location)
        
        fullStr = fullStr.substringFromIndex(range.location + 1)
        
        range = fullStr.rangeOfString(",")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        secondName = fullStr.substringToIndex(range.location)
        companyEmail = fullStr.substringFromIndex(range.location + 1)
        
        return true;
    }
    
    func checkVCard(fullStr1 : NSString!) ->Bool{
        
        var fullStr = fullStr1 as NSString
        
        firstName = ""
        secondName = ""
        companyEmail = ""
        
        var range: NSRange = fullStr.rangeOfString("TITLE:")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        fullStr = fullStr.substringFromIndex(range.location + 6)
        
        range = fullStr.rangeOfString("\n")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        firstName = fullStr.substringToIndex(range.location)
        
        fullStr = fullStr.substringFromIndex(range.location + 1)
        
        //
        //  secondName =""
        //
        
        range = fullStr.rangeOfString("EMAIL:")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        
        fullStr = fullStr.substringFromIndex(range.location + 6)
        
        range = fullStr.rangeOfString("\n")
        
        if(range.location == NSNotFound)
        {
            return false
        }
        
        companyEmail = fullStr.substringToIndex(range.location)
        
        
        return true;
    }
    
}