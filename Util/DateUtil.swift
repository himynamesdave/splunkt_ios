//
//  DateUtil.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//


import Foundation

class DateUtil{
    
class func startOfMonth(date : NSDate) -> NSDate? {
    
    let calendar = NSCalendar.currentCalendar()
    let currentDateComponents = calendar.components(.YearCalendarUnit | .MonthCalendarUnit, fromDate: date)
    let startOfMonth = calendar.dateFromComponents(currentDateComponents)
    
    return startOfMonth
}

class func dateByAddingMonths(date : NSDate, MonthsToAdd monthsToAdd: Int) -> NSDate? {
    
    let calendar = NSCalendar.currentCalendar()
    let months = NSDateComponents()
    months.month = monthsToAdd
    
    return calendar.dateByAddingComponents(months, toDate: date, options: nil)
}

class func endOfMonth(date : NSDate) -> NSDate? {
    
    let calendar = NSCalendar.currentCalendar()
    if let plusOneMonthDate = dateByAddingMonths(date, MonthsToAdd: 1) {
        
        let plusOneMonthDateComponents = calendar.components(.YearCalendarUnit | .MonthCalendarUnit, fromDate: plusOneMonthDate)
        
        let endOfMonth = calendar.dateFromComponents(plusOneMonthDateComponents)?.dateByAddingTimeInterval(-1)
        
        return endOfMonth
    }
    
    return nil
}
    
    
    class func getNumberDaysOfMonth(date : NSDate) -> Int
    {
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()
        if let plusOneMonthDate = dateByAddingMonths(date, MonthsToAdd: 1) {
            
            let plusOneMonthDateComponents = calendar.components(.YearCalendarUnit | .MonthCalendarUnit, fromDate: plusOneMonthDate)
            
            let endOfMonth = calendar.dateFromComponents(plusOneMonthDateComponents)?.dateByAddingTimeInterval(-1)
            
         //   NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
            
            let flags = NSCalendarUnit.DayCalendarUnit
            
          let components =   calendar.components(flags, fromDate: startOfMonth(date)!, toDate: endOfMonth!, options: nil)

            
         //  let components =  NSCalendar.currentCalendar().components(NSCalendarUnit.C | NSCalendarUnit.CalendarUnitMonth, fromDate: endOfMonth!)
            
            return components.day
        }
        
        return 0
    }
    
    
    class func getDateByDay(date : NSDate , DayOfMonth dayOfMonth : Int) -> NSDate
    {
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()
        
       // let dateOfMonth =  startOfMonth(date)
        
         let components = calendar.components(.YearCalendarUnit | .MonthCalendarUnit, fromDate: date)
        
       // let components = calendar.components(.DayCalendarUnit, fromDate: dateOfMonth!)
        
        components.day = dayOfMonth
        
        let lastDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        
        return lastDateOfMonth
       
    }
    
    
    class func getDateTimeByDayAndTime(date : NSDate , Time time  : NSDate) -> NSDate
    {
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()
        
      //  let componentsDate = calendar.components(.YearCalendarUnit | .MonthCalendarUnit, fromDate: date)
       // let componentsTime = calendar.components(.YearCalendarUnit | .MonthCalendarUnit, fromDate: time)
        
        let componentsDate = calendar.components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit, fromDate: date)
        let componentsTime = calendar.components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit, fromDate: time)
        
        // let components = calendar.components(.DayCalendarUnit, fromDate: dateOfMonth!)
        
        componentsDate.minute = componentsTime.minute
        componentsDate.hour = componentsTime.hour
        
        let dateOfMonth: NSDate = calendar.dateFromComponents(componentsDate)!
        
        return dateOfMonth
        
    }
    
    
    class func getDateTimeByAdmingMinute(date : NSDate,  Minute minute : Int) -> NSDate? {
        
        let calendar = NSCalendar.currentCalendar()
       // if let plusOneMonthDate = dateByAddingMonths(date, MonthsToAdd: 1) {
            
        let componentsDate = calendar.components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit, fromDate: date)
        
        // let components = calendar.components(.DayCalendarUnit, fromDate: dateOfMonth!)
        
        componentsDate.minute = componentsDate.minute + minute
        
        let dateOfMonth: NSDate = calendar.dateFromComponents(componentsDate)!
    
        
        return dateOfMonth
        
        //   }
        
    //    return nil
    }

    class func GetDayString(date: NSDate )-> String
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
    
    
    class func GetFormatedDateStringByDate(date: NSDate )-> String
    {
        //  let date = NSDate()
        // let date = NSDate(timeIntervalSince1970: timeStamp)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //  formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //println(formatter.stringFromDate(date))
        return formatter.stringFromDate(date)
    }
    
    class func GetFormatedDateTimeStringByDate(date: NSDate )-> String
    {
        //  let date = NSDate()
        // let date = NSDate(timeIntervalSince1970: timeStamp)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        //  formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //println(formatter.stringFromDate(date))
        return formatter.stringFromDate(date)
    }
    
    class func getFromatedTimeFromTimeStamp(date: NSDate )-> String
    {
        //  let date = NSDate()
        //let date = NSDate(timeIntervalSince1970: timeStamp)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        //  formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //println(formatter.stringFromDate(date))
        return formatter.stringFromDate(date)
    }
    
    
    class func getMonthByDate(date : NSDate) -> Int
    {
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()
        
        let componentsDate = calendar.components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit, fromDate: date)
        
        //
        return componentsDate.month
        
    }
    
    
    class func GetFormatedDateByDateString(date: String )-> NSDate
    {
        //  let date = NSDate()
        // let date = NSDate(timeIntervalSince1970: timeStamp)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //  formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //println(formatter.stringFromDate(date))
        return formatter.dateFromString(date)!
    }
    
    
    
    
    class func getMiliSecondByDate( date: NSDate )-> Double
    {
        return date.timeIntervalSince1970 * 1000
        
    }
    
    class func getSecondByMiliSecond( date: Double )-> Double
    {
        return date / 1000
        
    }
    
    class func getDateByMiliSecond( date: Double )-> NSDate
    {
     let seceond  = date / 1000
        
      return  NSDate(timeIntervalSince1970: seceond)
        
    }
   
}