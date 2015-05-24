//
//  Constants.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import Foundation


class Constants
{
    let BASE_URL = "https://INDEXER:8089/services/"
    let messages = "messages"
    
   let BASE_CONFIG_URL =  "https://INDEXER:9089/servicesNS/nobody/splunktapp/storage/collections/config"
   let BASE_PROPERTISE_URL =  "https://INDEXER:8089/servicesNS/nobody/search/properties/props"

    let SERVER_IP       = "INDEXER"
    let  SERVER_PORT     = "8089"
    
    let  SPLUNK_USER     = "USER"
    let  SPLUNK_PASS     = "PASSWORD"
    
    // API Return Code
    let  SUCCESS        =      1000
    let  FAILURE         =     1001
    
    let  SPLUNK_NOCONNECT =    2001
    
    let  LOGIN_FAILURE    =    3001
    let  LOGIN_STAFF     =     3002
    let  LOGIN_ADMIN      =    3003
    
    
    ////
    var leadData : LeadData!
    
    var shirtSloganList : Array<String> = []
    var shirtSizeList : Array<String> = []
    var useCaseList : Array<String> = []
    var competitionList : Array<String> = []
    var eventIDList : Array<String> = []
    
    
    
    class var sharedInstance: Constants {
    struct Singleton {
        static let instance = Constants()
        }
        return Singleton.instance
    }


    init(){
        
    }
}