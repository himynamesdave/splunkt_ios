//
//  LoginViewController1.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var emailTextField: BazarTextField!
    var eventIDTextField: BazarTextField!
    
    //
    let leftOffset: CGFloat = 20.0
    let rightOffset: CGFloat = 20.0
    let middleSpace: CGFloat = 10.0
    let greyColor = UIColor(red: 146.0/255, green: 146.0/255, blue: 146.0/255, alpha: 1)
    var scrollView: UIScrollView!
    
    var firstDone = false
    
    let bazarRed = UIColor(red: 208.0/255, green: 28.0/255, blue: 19.0/255, alpha: 0.1)
    
    var mode = "login"
    
    
    //updated 
    var userInformationLabel: UILabel!
    var registrationLabel: UILabel!
    var paymentInformationLabel: UILabel!
    //
    
    var credicardNumberTextField: BazarTextField!
    var securityCodeTextField: BazarTextField!
    var typeTextField: BazarTextField!
    
    var monthTextField: BazarTextField!
    var yearTextField: BazarTextField!
    //
    
    var termCoditionsImageView: UIImageView!
    var checkSwitch: UISwitch!
    
    var toolbar: UIToolbar!
    
    
    
    let hud: M13ProgressHUD = M13ProgressHUD(progressView: M13ProgressViewRing())
    
    
    override func awakeFromNib() {
        drawUserInterface()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "modalClosed", name: KGModalDidHideNotification, object: nil)
        
    }
    
    
    func setupView(){
        //make indicator visible
        
        ///
        self.initHelpers()
        
        
        Constants.sharedInstance.leadData = LeadData()
    }
    
    func initHelpers(){
        
        hud.progressViewSize = CGSizeMake(60.0, 60.0)
        hud.animationPoint = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        hud.indeterminate = true
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = delegate.window
        window!.addSubview(hud)
        
    }
    
      
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true // for navigation bar hide
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "startView", andValue: "viewWillAppear"))
        Mint.sharedInstance().logViewWithCurrentViewName("loginViewController", limitedExtraDataList: datalist)
 
    }
    
    override func shouldAutorotate() -> Bool {
   
        return false
    }
    
   
    override func viewDidDisappear(animated: Bool) {
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "closeView", andValue: "viewDidDisappear"))
        Mint.sharedInstance().logViewWithCurrentViewName("loginViewController", limitedExtraDataList: datalist)
    }
    

    
    func drawUserInterface(){
        
        self.setupView()
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        
        if(scrollView != nil){
            for view in scrollView.subviews{
                view.removeFromSuperview()
            }
        }
        
        
        var top: CGFloat = 10.0
        
        let version:NSString = UIDevice.currentDevice().systemVersion as NSString;
        
        if (version.doubleValue <= 8.0){
            top = 15.0
        }
        
        var fullWidth = self.view.frame.size.width * 0.8 - leftOffset - rightOffset
        var halfWidth = self.view.frame.size.width / 2 * 0.8
        
       // if(firstDone){
            fullWidth = self.view.frame.size.width - leftOffset - rightOffset
            halfWidth = self.view.frame.size.width / 2
       // }
        top += 20.0
        scrollView.addSubview(createLabel("Login", frame: CGRectMake(leftOffset, top, fullWidth, 18), align:1))
        
        top += 90.0
        //scrollView.addSubview(createLabel("Splunk email", frame: CGRectMake(leftOffset, top, fullWidth, 18)))
        ///
        emailTextField = createTextField(CGRectMake(leftOffset, top, fullWidth, 30))
        emailTextField.keyboardType = .EmailAddress
        emailTextField.autocapitalizationType = .None
        emailTextField.autocorrectionType = .No
        emailTextField.placeholder = "Splunk email"
        scrollView.addSubview(emailTextField)
        
        top += 35.0
        // scrollView.addSubview(createLabel("Event ID", frame: CGRectMake(leftOffset, top, fullWidth, 18)))
        //
        eventIDTextField = createTextField(CGRectMake(leftOffset, top, fullWidth, 30))
        eventIDTextField.autocapitalizationType = .None
        eventIDTextField.keyboardType = .NamePhonePad
        eventIDTextField.autocorrectionType = .No
        eventIDTextField.placeholder = "Event ID"
        scrollView.addSubview(eventIDTextField)
        
        top += 35.0
   
        
        
        top += 60.0
        let  loginButton = createButton("Enter", frame: CGRectMake(leftOffset, top, fullWidth , 32))
        loginButton.tag = 100
        loginButton.setTitleColor(UIColor(white: 1, alpha: 1), forState: .Normal)
        loginButton.backgroundColor = UIColor.blackColor()
        loginButton.addTarget(self, action: "loginPressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(loginButton)
        
        
        top += 60
        println("Top height:\(top)")
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
      //  self.view.backgroundColor = UIColor.clearColor()
        
        firstDone = true
    
    
    }
    
   
    
    func keyboardWasShown(sender: NSNotification){
        
        if(mode == "register"){
        
              scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.8, UIScreen.mainScreen().bounds.size.height + 160 + 150)
            
        }
        else
        {
          scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.8, UIScreen.mainScreen().bounds.size.height + 150)
        }
    }
    
    func keyboardWillHide(sender: NSNotification){
          if(mode == "register"){
            scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.8, UIScreen.mainScreen().bounds.size.height + 160)
            
          }
        else
          {
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.8, UIScreen.mainScreen().bounds.size.height-80)
        }
    }
    
    
    func createTextField(frame:CGRect) -> BazarTextField
    {
        var newTextField = BazarTextField(frame: frame)
        newTextField.backgroundColor = UIColor.whiteColor()
        newTextField.font = UIFont.systemFontOfSize(15)
        newTextField.layer.borderColor = UIColor.whiteColor().CGColor
        newTextField.layer.borderWidth = 0.5
        
        newTextField.textColor = UIColor.blackColor() //(black: 1, alpha: 1)
        
        newTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
       
        return newTextField
        
    }
    
    func createButton(text: String, picture:UIImage, frame:CGRect) -> BazarButton{
        
        var newButton = BazarButton(frame: frame)
        newButton.setTitle(text, forState: .Normal)
        newButton.setImage(picture, forState: .Normal)
        let bazarGreen = UIColor(red: 0.255, green: 0.506, blue: 0.180, alpha: 1)
        newButton.backgroundColor = bazarGreen
        return newButton
    }
    
    func createButton(text: String, frame:CGRect) -> BazarButton{
        
        var newButton = BazarButton(frame: frame)
        newButton.setTitle(text, forState: .Normal)
       
        newButton.titleLabel?.textColor = UIColor(white: 1, alpha: 1)
        return newButton
    }

    
    
    func createLabel(text:String!, frame:CGRect) -> UILabel{
        
        var newLabel = UILabel(frame: frame)
        newLabel.text = text
        newLabel.textColor = UIColor(white: 1, alpha: 1)
        newLabel.font = UIFont.boldSystemFontOfSize(15)
        return newLabel
    }
    
    func createLabel(text:String!, frame:CGRect, align:Int) -> UILabel{
        
        var newLabel = UILabel(frame: frame)
        newLabel.text = text
        newLabel.textColor = UIColor(white: 1, alpha: 1)
        newLabel.font = UIFont.boldSystemFontOfSize(15)
        
        if(align == 1)
        {
            newLabel.textAlignment = NSTextAlignment.Center
        }
        
        return newLabel
    }
    
    
    func createSwitchView(frame:CGRect) -> UISwitch{
        
        var newSwitch = UISwitch(frame: frame)
     
        return newSwitch
    }
    
    
    func createImageView(picture:UIImage!, frame:CGRect) -> UIImageView{
        
        var newImageView = UIImageView(frame: frame)
        newImageView.image = picture
       
        return newImageView
    }
    
    func createImageView(picture:UIImage!, frame:CGRect, isCenterFit:Bool) -> UIImageView{
        
        var newImageView = UIImageView(frame: frame)
        if(isCenterFit)
        {
            newImageView.contentMode = .ScaleAspectFit
        }
        newImageView.image = picture
        
        return newImageView
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if count(cString) != 6 {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    func isValidEmail(testStr:String) -> Bool {
        println("validate email: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    func checkForm(tag: Int) -> Bool{
        
        var errors: [String] = []
        
        if(emailTextField.text == ""){
            errors.append("Please enter your Splunk email address")
            emailTextField.backgroundColor = bazarRed
        }
        else{
            emailTextField.backgroundColor = UIColor.whiteColor() // UIColor.whiteColor()
        }
        
        if(eventIDTextField.text == ""){
            errors.append("Please enter an event ID")
            eventIDTextField.backgroundColor = bazarRed
        }
        else{
            eventIDTextField.backgroundColor = UIColor.whiteColor() // UIColor.whiteColor()
        }
        
        
        
        if(errors.count > 0){
            
            let alert = UIAlertView(title: "Error!", message: errors.implode("\n"), delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            
            return false
        }
        return true
        
    }
    
    
   
    
    override func loadView() {
        scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
       let bgColor = self.hexStringToUIColor("#759e39")// UIColor(red: 30, green: 30, blue: 30, alpha: 1)
      //let bgColor = UIColor(patternImage: UIImage(named: "bg")!)

        scrollView.backgroundColor = bgColor
        self.view = scrollView
        
    }
   
    
    @IBAction func loginPressed(sender: UIButton){
        
        if(!Reachability.isConnectedToNetwork())
        {
            PublicMethod.showAlertDialog("Internet Connection unavailable!", Message: "It looks like you are not connected. Splunkt needs internet access to work properly")
            
            return;
            
        }
        
       
        if(!checkForm(sender.tag)){
            return
        }

        
//        
        var splunktEmail = emailTextField.text as String
        if(!splunktEmail.contains("splunk.com"))
        {
            PublicMethod.showAlertDialog("Invalid Email Address!", Message: "Please enter valid splunk email address")
            return;
        }
        
        Constants.sharedInstance.leadData.staff_email = splunktEmail
      
        self.getEventDataByEventID()
        
    }
   
    
    func showLeadCaptureMethodViewController()
    {
        
        
        println("showLeadCaptureMethodViewController")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let leadCaptureMethodViewController = storyBoard.instantiateViewControllerWithIdentifier("leadCaptureMethodViewController") as! LeadCaptureMethodViewController
        
        self.navigationController!.pushViewController(leadCaptureMethodViewController, animated: true)
    }
    

    

    
    //Get all data 
    
    func getEventDataByEventID(){
        
        var eventId = eventIDTextField.text as String!
       
        var subUrl = "{\"addEventId\": \"\(eventId)\"}"
        
        subUrl = subUrl.URLEncodedString()!
        ///
        //https://INDEXER:8089
         var basicUrl =   "https://INDEXER:8089/servicesNS/nobody/splunkt_splunk_app/storage/collections/data/eventcollection?query=\(subUrl)"
        
     
        
                println("basicUrl :  \(basicUrl)")
        
                var policy : AFSecurityPolicy = AFSecurityPolicy();
                policy.allowInvalidCertificates = true;
        
                var client = AFHTTPRequestOperationManager()
                client.operationQueue = NSOperationQueue.mainQueue()
                client.securityPolicy = policy
        
        
        
                var requestSerializer : AFJSONRequestSerializer = AFJSONRequestSerializer()
                var responseSerializer : AFJSONResponseSerializer = AFJSONResponseSerializer()
        
      
        
                client.requestSerializer = requestSerializer
        
               client.requestSerializer.setAuthorizationHeaderFieldWithUsername(Constants.sharedInstance.SPLUNK_USER, password: Constants.sharedInstance.SPLUNK_PASS)
               client.securityPolicy.allowInvalidCertificates = true
        
                var params = NSMutableDictionary()
        
        
      //  params .setValue("EventID1", forKey: "addEventId")
        
        
        client.responseSerializer = responseSerializer
         client.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json") as Set<NSObject>
        
        
        hud.show(true)
        
        client.GET(basicUrl, parameters: params, success: { (operation : AFHTTPRequestOperation!, response : AnyObject!) -> Void in
        
            
           self.hud.hide(true)
            
            println("Response :  \(response.description)")
        
            
            
            let jsonDict = response  as! NSArray
            
            
            if(jsonDict.count > 0)
            {
                
                for var i=0 ;i < jsonDict.count; i++ {
                    
                    
                    let row = jsonDict.objectAtIndex(i) as! NSDictionary
                    
                    println("row :  \(row)")
                    
                    var addEventId = row.valueForKey("addEventId") as! String!
                    
                    var addEventName = row.valueForKey("addEventName") as! String!
                    var showShirt = row.valueForKey("showShirt") as! String!
                    
                    var isShowShirt = false
                    if(showShirt == "true")
                    {
                        isShowShirt = true
                    }
                    
                    var defaults = NSUserDefaults.standardUserDefaults()
                    
                    Constants.sharedInstance.leadData.staff_email = self.emailTextField.text as String!
                    Constants.sharedInstance.leadData.event_ID = addEventId
                    
                    defaults.setValue(addEventName, forKey: "addEventName")
                    defaults.setValue(Constants.sharedInstance.leadData.staff_email , forKey: "staff_email")
                    defaults.setValue(Constants.sharedInstance.leadData.event_ID , forKey: "event_ID")
                    
                    defaults.setValue(isShowShirt , forKey: "showShirt")
                    
                   // Constants.sharedInstance.eventIDList.append(addEventId)
                      self.showLeadCaptureMethodViewController()
                }
                
            }else
            {
                PublicMethod.showAlertDialog("Error!", Message: "The event ID does not exist")
            }
                    } , failure: { (operation : AFHTTPRequestOperation!, error : NSError!) -> Void in
                        
                        println("Error \(error.description) \(operation.responseObject) ")
                        
                        self.hud.hide(true)
                         PublicMethod.showAlertDialog("Error", Message: error.description)
                        //  onCompletion(false, nil, nil, nil)
                })
                
        
    }
    
  
    
}
