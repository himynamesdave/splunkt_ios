//
//  ManualLeadEntryViewController.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import UIKit

import Foundation


class ManualLeadEntryViewController : UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate{
    
    
    //Edit Text box
    var jobTitleTextField: BazarTextField!
    var firstNameTextField: BazarTextField!
    var secondNameTextField: BazarTextField!
    var companyEmailTextField: BazarTextField!
    
    var saveButton: BazarButton!
        
    
    
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
        
    
        var refreshButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "toggleLeft")
        navigationItem.backBarButtonItem = refreshButton
        self.navigationItem.hidesBackButton = false
        
        //
        var rightButtonArray : Array<UIBarButtonItem> = []
        var staff_email = defaults.valueForKey("staff_email") as! String
        
        var index = staff_email.indexOf("@") as Int!
        
        staff_email = staff_email.substringToIndex(index)!
        
        
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
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "startView", andValue: "viewWillAppear"))
        Mint.sharedInstance().logViewWithCurrentViewName("ManualLeadEntryViewController", limitedExtraDataList: datalist)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "closeView", andValue: "viewDidDisappear"))
        Mint.sharedInstance().logViewWithCurrentViewName("ManualLeadEntryViewController", limitedExtraDataList: datalist)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ///
    }
    
    
    override func shouldAutorotate() -> Bool {
        
        return false
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
        
        toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        
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
        scrollView.addSubview(createLabel("Enter Lead Details", frame: CGRectMake(leftOffset, top, fullWidth, 18), align:1))
        
          top += 40.0
      
        
        scrollView.addSubview(createLabel("First Name", frame: CGRectMake(leftOffset, top, fullWidth, 18), align:0))
        top += 20.0
       
        firstNameTextField = createTextField(CGRectMake(leftOffset, top, fullWidth, 30))
        firstNameTextField.keyboardType = .NamePhonePad
        firstNameTextField.autocapitalizationType = .None
        firstNameTextField.autocorrectionType = .No
        firstNameTextField.placeholder = "First Name"
    
        scrollView.addSubview(firstNameTextField)
        
        top += 40.0
        
        scrollView.addSubview(createLabel("Second Name", frame: CGRectMake(leftOffset, top, fullWidth, 18), align:0))
        top += 20.0
        
        secondNameTextField = createTextField(CGRectMake(leftOffset, top, fullWidth, 30))
        secondNameTextField.keyboardType = .NamePhonePad
        secondNameTextField.autocapitalizationType = .None
        secondNameTextField.autocorrectionType = .No
        
        secondNameTextField.placeholder = "Second Name"
     
        scrollView.addSubview(secondNameTextField)
        
        top += 40.0
        
        scrollView.addSubview(createLabel("Job Title", frame: CGRectMake(leftOffset, top, fullWidth, 18), align:0))
        top += 20.0
        
        jobTitleTextField = createTextField(CGRectMake(leftOffset, top, fullWidth, 30))
        jobTitleTextField.keyboardType = .NamePhonePad
        jobTitleTextField.autocapitalizationType = .None
        jobTitleTextField.autocorrectionType = .No
        jobTitleTextField.placeholder = "Job Title"
        scrollView.addSubview(jobTitleTextField)
        
        top += 40.0
        
        scrollView.addSubview(createLabel("Company Email", frame: CGRectMake(leftOffset, top, fullWidth, 18), align:0))
        top += 20.0
        
        companyEmailTextField = createTextField(CGRectMake(leftOffset, top, fullWidth, 30))
        companyEmailTextField.keyboardType = .EmailAddress
        companyEmailTextField.autocapitalizationType = .None
        companyEmailTextField.autocorrectionType = .No
        companyEmailTextField.placeholder = "Company Email"
        
        scrollView.addSubview(companyEmailTextField)
        
        
        
        
        top += 60.0
        
        
        saveButton = createButton("Submit", frame: CGRectMake(leftOffset, top, fullWidth , 32))
        saveButton.tag = 100
        saveButton.setTitleColor(UIColor(white: 1, alpha: 1), forState: .Normal)
        saveButton.backgroundColor = UIColor.blackColor()
        saveButton.addTarget(self, action: "savePressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(saveButton)
        
        top += 50
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
  
        
        firstDone = true
    }
    
    
    //tapGesture clcik
    @IBAction func tapGesture(sender: AnyObject) {
        
        //    self.showAlertDialog()
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
    
    func createImageView(picture:UIImage!, frame:CGRect) -> UIImageView{
        
        var newImageView = UIImageView(frame: frame)
        newImageView.image = picture
        
        return newImageView
    }
//    
//    func createPFImageView(picture:UIImage!, frame:CGRect) -> PFImageView{
//        
//        var newImageView = PFImageView(frame: frame)
//        // newImageView.image = picture
//        
//        return newImageView
//    }
    
    func createImageView(picture:UIImage!, frame:CGRect, isCenterFit:Bool) -> UIImageView{
        
        var newImageView = UIImageView(frame: frame)
        if(isCenterFit)
        {
            newImageView.contentMode = .ScaleAspectFit
        }
        
        newImageView.image = picture
        
        return newImageView
    }
    
//    func createPFImageView(picture:UIImage!, frame:CGRect, isCenterFit:Bool) -> PFImageView{
//        
//        var newImageView = PFImageView(frame: frame)
//        if(isCenterFit)
//        {
//            newImageView.contentMode = .ScaleAspectFit
//        }
//        // newImageView.image = picture
//        
//        return newImageView
//    }
    
    
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
        
        
        
        //
        if(jobTitleTextField.text == "" ){
            errors.append("Please enter a job title")
            jobTitleTextField.backgroundColor = bazarRed
        }
        else{
            jobTitleTextField.backgroundColor = UIColor.whiteColor() //PublicMethod.hexStringToUIColor("#202020")
        }
        
        ///
        
        if(firstNameTextField.text == "" ){
            errors.append("Please enter first name")
            firstNameTextField.backgroundColor = bazarRed
        }
        else{
            firstNameTextField.backgroundColor = UIColor.whiteColor() //PublicMethod.hexStringToUIColor("#202020")
        }
        
        if(secondNameTextField.text == ""){
            errors.append("Please enter second name")
            secondNameTextField.backgroundColor = bazarRed
        }
        else{
            secondNameTextField.backgroundColor = UIColor.whiteColor() //PublicMethod.hexStringToUIColor("#202020")
        }
        
        if(!isValidEmail(companyEmailTextField.text)){
            errors.append("Please enter a valid company email address")
            companyEmailTextField.backgroundColor = bazarRed
        }
        else
        {
            companyEmailTextField.backgroundColor = UIColor.whiteColor() //PublicMethod.hexStringToUIColor("#202020")
        }
        
  
        if(errors.count > 0){
            
            let alert = UIAlertView(title: "Error!", message: errors.implode("\n"), delegate: nil, cancelButtonTitle: "Ok")
            
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
        // Create
        
        
        if(!checkForm(sender.tag)){
            return
        }
        
        Constants.sharedInstance.leadData.isQRCode = 0
    
        
        Constants.sharedInstance.leadData.job_title = jobTitleTextField.text
        Constants.sharedInstance.leadData.first_name = firstNameTextField.text
        Constants.sharedInstance.leadData.second_name = secondNameTextField.text
        Constants.sharedInstance.leadData.company_email = companyEmailTextField.text

        self.showShirtSloganViewController()
    
    }
    
    ///
    func showShirtSloganViewController()
    {
        println("showShirtSloganViewController")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      
        
        
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
   
    @IBAction func staffEmailPressed(sender: UIButton){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
