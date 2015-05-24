//
//  NotesViewController.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import UIKit

import Foundation


class NotesViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate{
    
    
    //Edit Text box
 //   var typeTextField: BazarTextField!
    
    var saveButton: BazarButton!    
    
    var textView: UITextView!
    
    
    let leftOffset: CGFloat = 20.0
    let rightOffset: CGFloat = 20.0
    let middleSpace: CGFloat = 10.0
    let greyColor = UIColor(red: 146.0/255, green: 146.0/255, blue: 146.0/255, alpha: 1)
    var scrollView: UIScrollView!
    
    var firstDone = false
    
    let bazarRed = UIColor(red: 208.0/255, green: 28.0/255, blue: 19.0/255, alpha: 0.1)
    
    var mode = "login"
    
    
    var  editMode = false
    
    
    let hud: M13ProgressHUD = M13ProgressHUD(progressView: M13ProgressViewRing())
    
    var refreshControl:UIRefreshControl!
    
    //
    var limit = 30
    var skip = 0
    var isLoading = false
    
    
    var typePicker: UIPickerView!
    var toolbar: UIToolbar!
        
    
    override func awakeFromNib() {
        
        drawUserInterface()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "modalClosed", name: KGModalDidHideNotification, object: nil)
        
        
    }
    
    func initNavigationBar()
    {
        self.setNavigationBar()

        var defaults = NSUserDefaults.standardUserDefaults()
        
        var addEventName = defaults.valueForKey("addEventName") as! String!
        self.navigationItem.title = addEventName
        
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
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
        self.initNavigationBar()
        
        //Track
        //Track
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "startView", andValue: "viewWillAppear"))
        Mint.sharedInstance().logViewWithCurrentViewName("NotesViewController", limitedExtraDataList: datalist)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "closeView", andValue: "viewDidDisappear"))
        Mint.sharedInstance().logViewWithCurrentViewName("NotesViewController", limitedExtraDataList: datalist)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Track
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ///
    }
    
    func setupView(){
        //make indicator visible
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //add pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGrayColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        ///
        self.initHelpers()
        
    }
    
    func initHelpers(){
        
        hud.progressViewSize = CGSizeMake(60.0, 60.0)
        hud.animationPoint = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        hud.indeterminate = true
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = delegate.window
        window!.addSubview(hud)
    
    }
    
    ////
    func refresh(){
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func drawUserInterface(){
        
        self.setupView();
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if(scrollView != nil){
            for view in scrollView.subviews{
                view.removeFromSuperview()
            }
        }else
        {
            scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            
            let bgColor = PublicMethod.hexStringToUIColor("#759e39")
            scrollView.backgroundColor = bgColor
            
            self.view = scrollView
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
        scrollView.addSubview(createLabel("Add Any Notes", frame: CGRectMake(leftOffset, top, fullWidth, 16), align:1))
        
        
        
        top += 40.0
        
        textView = createTextView(CGRectMake(leftOffset, top, fullWidth, 100))
       // textView.delegate = self
        textView.font = UIFont.systemFontOfSize(15)
     //   textView.text =
        self.view.addSubview(textView)
        
        top += 130.0
        
        
        saveButton = createButton("Submit", frame: CGRectMake(leftOffset, top, fullWidth , 32))
        saveButton.tag = 100
        saveButton.setTitleColor(UIColor(white: 1, alpha: 1), forState: .Normal)
        saveButton.backgroundColor = UIColor.blackColor()
        ///PublicMethod.hexStringToUIColor("#00acee")// UIColor(red: 0, green: 204, blue: 255, alpha: 1)
        saveButton.addTarget(self, action: "savePressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(saveButton)
        
        top += 50
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        
        firstDone = true
    }
    
    
    //tapGesture clcik
    @IBAction func tapGesture(sender: AnyObject) {

    }
    
    
    
    func keyboardWasShown(sender: NSNotification){
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.8, UIScreen.mainScreen().bounds.size.height + 150)
    }
    
    func keyboardWillHide(sender: NSNotification){
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.8, UIScreen.mainScreen().bounds.size.height-80)
    }
    
    
    func createTextField(frame:CGRect) -> BazarTextField{
        
        var newTextField = BazarTextField(frame: frame)
        newTextField.backgroundColor = UIColor.whiteColor() //PublicMethod.hexStringToUIColor("#202020") // UIColor.whiteColor()
        newTextField.font = UIFont.systemFontOfSize(15)
        newTextField.layer.borderColor = UIColor.whiteColor().CGColor
        newTextField.layer.borderWidth = 0.5
        newTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        newTextField.textColor = UIColor.blackColor()
        return newTextField
        
    }
    
    func createButton(text: String, picture:UIImage, frame:CGRect) -> BazarButton{
        
        var newButton = BazarButton(frame: frame)
        //newButton.setTitle(text, forState: .Normal)
        // newButton.setImage(picture, forState: .Normal)
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
    
    
    func createTextView(frame:CGRect) -> UITextView{
        var newTextView = UITextView(frame: frame)
        newTextView.layer.borderColor = UIColor.blackColor().CGColor
        newTextView.layer.borderWidth = 0.5
        return newTextView
        
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
    
  
    
    
    //TableView
    func createTableView(frame:CGRect) -> UITableView{
        
        var tableView = UITableView(frame: frame)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        return tableView
    }
    
    func createView(frame:CGRect) -> UIView{
        
        var view = UIView(frame: frame)
        view.backgroundColor = UIColor.whiteColor()
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func facebookPressed(){
        //UserManager.sharedInstance.loginWithFacebook()
    }
    
    func twitterPressed(){
        //  UserManager.sharedInstance.loginWithTwitter()
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
        
        //Edit Text box
        
       
        
        if(textView.text == ""){
            errors.append("Please enter note")
            textView.backgroundColor = bazarRed
        }
        else
        {
            textView.backgroundColor = UIColor.whiteColor() //PublicMethod.hexStringToUIColor("#202020")
        }
        
       
        
        if(errors.count > 0){
            
            let alert = UIAlertView(title: "Oops! You have to fill out some forgotten", message: errors.implode("\n"), delegate: nil, cancelButtonTitle: "Ok")
            
            //           let alert = UIAlertView(title: "Oops! You have to fill out some forgotten", message: errors, delegate: nil, cancelButtonTitle: "Ok")
            
            alert.show()
            
            return false
        }
        return true
        
    }
    
    override func loadView() {
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        
        let bgColor = PublicMethod.hexStringToUIColor("#759e39")
        scrollView.backgroundColor = bgColor
        
        self.view = scrollView
        
    }
    
    ////
    
    //Picture taking area
    
    
    @IBAction func savePressed(sender: UIButton){
        
        var errors: [String] = []
        
        if(!Reachability.isConnectedToNetwork())
        {
            PublicMethod.showAlertDialog("Internet Connection unavailable!", Message: "It looks like you are not connected. Splunkt needs internet access to work properly")
            
            return;
        }
       
        Constants.sharedInstance.leadData.note = textView.text
        
        self.sendEventDataToServer()
        
    }
    
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
  
   
    //Send data to server
    func sendEventDataToServer(){
        
        var basicUrl = "https://INDEXER:8089/services/receivers/simple?source=splunkt_splunk_app&sourcetype=event_lead&index=splunkevents"
        
     
        println("basicUrl :  \(basicUrl)")
        
        var policy : AFSecurityPolicy = AFSecurityPolicy();
        policy.allowInvalidCertificates = true;
        
        var client = AFHTTPRequestOperationManager()
        client.operationQueue = NSOperationQueue.mainQueue()
        client.securityPolicy = policy
        
        
        var requestSerializer : AFJSONRequestSerializer = AFJSONRequestSerializer()
        
        var responseSerializer : AFXMLParserResponseSerializer = AFXMLParserResponseSerializer()
        client.requestSerializer = requestSerializer
        
        client.requestSerializer.setAuthorizationHeaderFieldWithUsername(Constants.sharedInstance.SPLUNK_USER, password: Constants.sharedInstance.SPLUNK_PASS)
        client.securityPolicy.allowInvalidCertificates = true
        
        
        var timeStamp = DateUtil.getMiliSecondByDate(NSDate()) as Double!
        
        
        
        
        var paramsLeads = NSMutableDictionary()
        
        paramsLeads.setValue(Constants.sharedInstance.leadData.company_email , forKey: "company_email")
        paramsLeads.setValue(Constants.sharedInstance.leadData.first_name , forKey: "first_name")
        paramsLeads.setValue(Constants.sharedInstance.leadData.second_name , forKey: "second_name")
        paramsLeads.setValue(Constants.sharedInstance.leadData.job_title , forKey: "job_title")
        
       // dictionaryWithObjectsAndKeys
        
        
        var paramsQR = NSMutableDictionary()
        
        
        //   for(var i = 0)
        if(Constants.sharedInstance.leadData.qr_data != nil && Constants.sharedInstance.leadData.qr_data?.length > 0)
        {
            if(Constants.sharedInstance.leadData.qr_data!.contains("BEGIN:VCARD"))
            {
                var fullNameArr = Constants.sharedInstance.leadData.qr_data!.componentsSeparatedByString("\n")
                var i = 0
                for qrData in fullNameArr{
                    
                    var value = ""
                    var key = ""
                    var fullStr = qrData as NSString?
                    var range: NSRange = fullStr!.rangeOfString(":")
                    
                    if(range.location != NSNotFound)
                    {
                        key = fullStr!.substringToIndex(range.location)
                        value = fullStr!.substringFromIndex(range.location + 1)
                        
                    }
                    
                    paramsQR.setValue(value, forKey: key)
                    
                    i++
                    
                }
                
            }else
            {
                var fullNameArr = Constants.sharedInstance.leadData.qr_data!.componentsSeparatedByString(",")
                var i = 0
                for qrData in fullNameArr{
                    
                    paramsQR.setValue(qrData, forKey: "field\(i.toString())")
                    
                    i++
                    
                }
            }
            
        }

        
        
        
        var params = NSMutableDictionary()
        
        params.setValue(Constants.sharedInstance.leadData.event_ID , forKey: "event_id")
        params.setValue( timeStamp.toString(), forKey: "device_timestamp")
        params.setValue(Constants.sharedInstance.leadData.staff_email , forKey: "staff_email")
        
        params.setValue(paramsQR , forKey: "qr_data")
        params.setValue(paramsLeads , forKey: "lead_details")
        
        
        params.setValue(Constants.sharedInstance.leadData.shirt_slogan , forKey: "shirt_slogan")
        params.setValue(Constants.sharedInstance.leadData.shirt_size , forKey: "shirt_size")
        
        //Constants.sharedInstance.leadData.use_case
        params.setValue( Constants.sharedInstance.leadData.use_case, forKey: "use_case")
        //Constants.sharedInstance.leadData.compe66on
        params.setValue( Constants.sharedInstance.leadData.compe66on, forKey: "competition")
        params.setValue(Constants.sharedInstance.leadData.note , forKey: "notes")
        
     //   println("use \(Constants.sharedInstance.leadData.use_case!)")
       // println("compe66on \(Constants.sharedInstance.leadData.compe66on!)")
        
        //Device model name 
        let modelName = UIDevice.currentDevice().modelName
        let deviceId   = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        params.setValue(modelName , forKey: "device_type")
        params.setValue(deviceId , forKey: "device_id")
        
        //
        
        
        client.responseSerializer = responseSerializer
        client.responseSerializer.acceptableContentTypes = NSSet(object: "text/xml") as Set<NSObject>
    
        
        client.POST(basicUrl, parameters: params, success: { (operation : AFHTTPRequestOperation!, response : AnyObject!) -> Void in
            
            println("Response :  \(response.description)")
            
            //Fair
            self.showSuccessViewController()
            
            
            } , failure: { (operation : AFHTTPRequestOperation!, error : NSError!) -> Void in
                
                println("Error \(error.description) \(operation.responseObject) ")
                
                //  onCompletion(false, nil, nil, nil)
        })
        
        
       

    }
    
    
    @IBAction func staffEmailPressed(sender: UIButton){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    ///
    func showSuccessViewController()
    {
        
        
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "addedLeadData", andValue: "successfully"))
        Mint.sharedInstance().logViewWithCurrentViewName("sendEventDataToServer", limitedExtraDataList: datalist)
        
        println("showSuccessViewController")
                
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let successViewController = storyBoard.instantiateViewControllerWithIdentifier("successViewController") as! SuccessViewController
        
        self.navigationController!.pushViewController(successViewController, animated: true)
    }
    
   
}
