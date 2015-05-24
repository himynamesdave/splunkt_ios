//
//  LeadData.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import Foundation


class LeadData {
    
    var event_ID: String?
    var device_6mestamp: String?
    var staff_email: String?
    var qr_data: String?
    
    var isQRCode: Int?
    var first_name: String?
    var second_name:  String?
    var company_email: String?
    
    var shirt_size: String?
    var shirt_slogan:  String?
    var use_case: String?
    
    var compe66on: String?
    var note: String?
    var job_title: String?
    
    
    init(){
        
        self.event_ID = ""
       self.device_6mestamp = ""
       self.staff_email = ""
       self.qr_data = ""
       self.isQRCode = 0
       self.first_name = ""
       self.second_name =  ""
       self.company_email = ""
       self.shirt_size = ""
       self.shirt_slogan = ""
       self.use_case = ""
       self.compe66on = ""
       self.note = ""
       self.job_title = ""

    }
}

