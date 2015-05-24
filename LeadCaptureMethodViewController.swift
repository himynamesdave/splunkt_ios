//
//  LeadCaptureMethodViewController.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import Foundation
import UIKit

class LeadCaptureMethodViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate{
    
    var saveButton: BazarButton!
  
    let leftOffset: CGFloat = 20.0
    let rightOffset: CGFloat = 20.0
    let middleSpace: CGFloat = 10.0
    let greyColor = UIColor(red: 146.0/255, green: 146.0/255, blue: 146.0/255, alpha: 1)
    var scrollView: UIScrollView!
    
    var firstDone = false
    
    let bazarRed = UIColor(red: 208.0/255, green: 28.0/255, blue: 19.0/255, alpha: 0.1)
    
    var  editMode = false
    
    let hud: M13ProgressHUD = M13ProgressHUD(progressView: M13ProgressViewRing())
    
    //
    
    var toolbar: UIToolbar!
    
    //
    var limit = 30
    var skip = 0
    var isLoading = false
    
    
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
        //self.
     
        
        var refreshButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "toggleLeft")
        refreshButton.tintColor = UIColor.blackColor()
        navigationItem.backBarButtonItem = refreshButton
        
     //  self.removeNavigationBarItem()
        
       self.navigationItem.hidesBackButton = true

        
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
        //   self.screenName = "Login"
        navigationController?.navigationBar.hidden = false
        self.initNavigationBar()
        
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "startView", andValue: "viewWillAppear"))
        Mint.sharedInstance().logViewWithCurrentViewName("LeadCaptureMethodViewController", limitedExtraDataList: datalist)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "closeView", andValue: "viewDidDisappear"))
        Mint.sharedInstance().logViewWithCurrentViewName("LeadCaptureMethodViewController", limitedExtraDataList: datalist)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Track
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    func setupView(){
        //make indicator visible
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //  self.initNavigationBar();
        // self.fillInfos()
    }
    
    func drawUserInterface(){
        
        self.setupView();
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if(scrollView != nil){
            for view in scrollView.subviews{
                view.removeFromSuperview()
            }
        } else if(scrollView == nil)
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
        
        
        
        top = self.view.frame.size.height / 2 - 100 ;
       
        
        //top += 60.0
        let  loginButton = createButton("Scan barcode", frame: CGRectMake(leftOffset, top, fullWidth , 32))
        loginButton.tag = 100
        loginButton.setTitleColor(UIColor(white: 1, alpha: 1), forState: .Normal)
        loginButton.backgroundColor = UIColor.blackColor()
        loginButton.addTarget(self, action: "scanBarcodePressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(loginButton)
        
        top += 60.0
    
        
        var attrs = [kCTUnderlineStyleAttributeName : NSNumber(int: CTUnderlineStyle.Single.rawValue), NSForegroundColorAttributeName: UIColor.whiteColor()] as [NSObject : AnyObject]
        
        var attributedString = NSMutableAttributedString(string: "No barcode?", attributes: attrs )
        
        
        let passwordButton = createButton("", picture: UIImage(named: "pixel")!, frame: CGRectMake(leftOffset, top, fullWidth , 22))
        passwordButton.backgroundColor = UIColor.clearColor()
        passwordButton.tag = 101
        passwordButton.setAttributedTitle(attributedString, forState:.Normal)
        passwordButton.titleLabel!.font = UIFont.systemFontOfSize(15)
        passwordButton.addTarget(self, action: "scanBarcodePressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(passwordButton)
        
        
        
        ///
        top += 50.0
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        
     
        
        firstDone = true
    }
    
    func keyboardWasShown(sender: NSNotification){
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.8, UIScreen.mainScreen().bounds.size.height + 150)
    }
    
    func keyboardWillHide(sender: NSNotification){
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.8, UIScreen.mainScreen().bounds.size.height-80)
    }
    
    
    func createTextField(frame:CGRect) -> BazarTextField{
        
        var newTextField = BazarTextField(frame: frame)
        newTextField.backgroundColor = UIColor.whiteColor()
        newTextField.font = UIFont.systemFontOfSize(15)
        newTextField.layer.borderColor = UIColor.blackColor().CGColor
        newTextField.layer.borderWidth = 0.5
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
        //  newButton.setImage(picture, forState: .Normal)
        //let bazarGreen = UIColor(red: 0.255, green: 0.506, blue: 0.180, alpha: 1)
        // newButton.backgroundColor = bazarGreen
        
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
    
    func createImageView(picture:UIImage!, frame:CGRect, isCenterFit:Bool) -> UIImageView{
        
        var newImageView = UIImageView(frame: frame)
        if(isCenterFit)
        {
            newImageView.contentMode = .ScaleAspectFit
        }
        
        newImageView.image = picture
        
        return newImageView
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
    
 
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    ////
    
    @IBAction func scanBarcodePressed(sender: UIButton){
        
        if(sender.tag == 100)
        {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let qRScanViewController = storyBoard.instantiateViewControllerWithIdentifier("qrScanViewController") as! RSQRScanViewController
        
        self.navigationController!.pushViewController(qRScanViewController, animated: true)

        
            
            
        }
        else  if(sender.tag == 101)
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
          //  self.navigationItem.hidesBackButton = false
            
            let manualLeadEntryViewController = storyBoard.instantiateViewControllerWithIdentifier("manualLeadEntryViewController") as!ManualLeadEntryViewController
            
            self.navigationController!.pushViewController(manualLeadEntryViewController, animated: true)
        }
        
    }
    
}