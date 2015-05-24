//
//  PublicMethod.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import Foundation

class PublicMethod{
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func getFromatedTimeFromTimeStamp(timeStamp: Double )-> String
    {
      //  let date = NSDate()
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
      //  formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //println(formatter.stringFromDate(date))
        return formatter.stringFromDate(date)
    }
    
    class func getDayNameFromTimeStamp(date: NSDate )-> String
    {
        //  let date = NSDate()
       // let date = NSDate(timeIntervalSince1970: timeStamp)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
      //  formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //println(formatter.stringFromDate(date))
        return formatter.stringFromDate(date)
    }
    
    class func getStatus(status: Int )-> String
    {
        if(status == 1)
        {
         return "ACTIVE"
        }
        else if(status == 2)
        {
         return "INACTIVE"
            
        }
        else if(status == 3)
        {
            return "PAID"
            
        }            
        else
        {
            return ""
        }
    }
    
    class func getTYPE(status: Int )-> String
    {
        if(status == 1)
        {
            return "CUSTOMER"
        }
        else if(status == 2)
        {
            return "BARBER"
            
        }
        else
        {
            return ""
        }
    }
    
    
    class func getFirstDateOfMonth(date : NSDate) -> NSDate
    {
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()        // Create an NSDate for the first and last day of the month
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date)
        
        
        //  components.month
        
        // Getting the First and Last date of the month
        components.day = 1
        let firstDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        
        return firstDateOfMonth
       
    }
    
    
    class func getlastDateOfMonth(date : NSDate) -> NSDate
    {
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()        // Create an NSDate for the first and last day of the month
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date)
        
        
        //  components.month
        
        
        
        // Getting the Last date of the month
        components.month  += 1
        components.day     = 0
       
        let lastDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        
        return lastDateOfMonth
    }
    
    
    class func getNumberDaysOfMonth(date : NSDate) -> Int
    {
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()        // Create an NSDate for the first and last day of the month
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date)
        
        // Getting the Last date of the month
        components.month  += 1
        components.day     = 0
        
        components.minute    -= 1
        components.minute    -= 1
        
        components.minute    -= 1
        
        let lastDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        
        return components.day
    }
    
    
    class func getDateByAddDay(date : NSDate , Day day : Int  ) -> NSDate
    {
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()        // Create an NSDate for the first and last day of the month
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date)
        
        
        //  components.month
        
        
        
        // Getting the Last date of the month
        //components.month  += 1
        components.day     += day
        let lastDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        
        return lastDateOfMonth
    }
    
    class func getDateByDay(date : NSDate , Day day : Int  ) -> NSDate
    {
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()        // Create an NSDate for the first and last day of the month
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: date)
        
       
        components.day     = day
        let dateOfMonth: NSDate = calendar.dateFromComponents(components)!
        
        return dateOfMonth
    }
    
    class func getFormatedPrice(number : NSDecimalNumber ) -> String
    {
        
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "es_CL")
    
        return formatter.stringFromNumber(number)! // $123"
       
    }
    
    
    class func encodeToBase64String (image : UIImage) -> String {
    
    var image : UIImage = UIImage(named:"imageNameHere")!
    var imageData = UIImagePNGRepresentation(image)
    let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
  //  println(base64String)
        
        return base64String
    }
    
    
    class func decodeBase64ToImage (base64String : String) -> UIImage  {
        
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.allZeros)
        var decodedimage = UIImage(data: decodedData!)
        
        return decodedimage!
      
    }
    
    
    class func showAlertDialog( title : String, Message message : String )
    {
        
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok")
        
        alert.show()
    }
    
    class func getMonthByMonthString(month: String) -> Int
    {
        switch(month)
        {
        
        case "January":
            return 1

        case "February":
        return 2

        case "March":
        return 3

        case "April":
        return 4
            
        case "May":
        return 5
            
        case "Jun":
        return 6
            
        case "July":
        return 7
            
        case "Auguest":
        return 8
        
        case "September":
            return 9
            
        case "October":
            return 10
            
        case "November":
            return 11
            
        case "December":
            return 12
        default:
            return -1
        }

    }
    
    
    class func getMonthStringByMonth(month: Int) -> String
    {
        switch(month)
        {
            
        case 1:
            return "January"
            
        case 2:
            return "February"
            
        case 3:
            return "March"
            
        case 4:
            return "April"
            
        case 5:
            return "May"
            
        case 6:
            return "Jun"
            
        case 7:
            return "July"
            
        case 8:
            return "Auguest"
            
        case 9:
            return "September"
            
        case 10:
            return "October"
            
        case 11:
            return "November"
            
        case 12:
            return "December"
            
        default:
            return ""
        }
        
    }
 
    class func scheduleNotification(title : String, Message message: String, StartTime startTime : NSDate)
    {
        var  notif = UILocalNotification()
        
        notif.fireDate = startTime
        notif.timeZone = NSTimeZone.defaultTimeZone()
        
        notif.alertBody = message
        notif.alertAction = title
        notif.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        notif.soundName = UILocalNotificationDefaultSoundName
        //  notif.repeatInterval = 0
        
        UIApplication.sharedApplication().scheduleLocalNotification(notif)
        
    }
    
}
