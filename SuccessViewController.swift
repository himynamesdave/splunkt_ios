//
//  SuccessViewController
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import UIKit
import Foundation

class SuccessViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate{
    
    
    //Edit Text box
    var typeTextField: BazarTextField!
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
        
        
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    
    override func toggleLeft(){
        
        self.navigationController!.popToRootViewControllerAnimated(true)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        
        navigationController?.navigationBar.hidden = true
        
        //Track
        //Track
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "startView", andValue: "viewWillAppear"))
        Mint.sharedInstance().logViewWithCurrentViewName("SuccessViewController", limitedExtraDataList: datalist)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "closeView", andValue: "viewDidDisappear"))
        Mint.sharedInstance().logViewWithCurrentViewName("SuccessViewController", limitedExtraDataList: datalist)
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
        
        top += 30.0
        
        self.scrollView.addSubview(createImageView( UIImage(named: "icon"), frame: CGRectMake(0, top, self.view.frame.size.width, 279), isCenterFit: true))
        
        
        top += 279.0
   
        
        top += 40.0
        
        
        
        let label = createLabel("Great work, we’ve got it. Now go hunt down another!", frame: CGRectMake(leftOffset, top, fullWidth, 40), align:1)
        label.numberOfLines = 2
        scrollView.addSubview(label)
        
        saveButton = createButton("", frame: CGRectMake(leftOffset, 0, fullWidth , self.view.frame.size.height-20))
        saveButton.tag = 100
        saveButton.setTitleColor(UIColor(white: 1, alpha: 1), forState: .Normal)
        saveButton.backgroundColor = UIColor.clearColor()
        ///PublicMethod.hexStringToUIColor("#00acee")// UIColor(red: 0, green: 204, blue: 255, alpha: 1)
        saveButton.addTarget(self, action: "savePressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(saveButton)
        
        ///
        
        
        top += 50
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        
     //   self.view.backgroundColor = UIColor.clearColor()
        
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
        
        
        
        if(typeTextField.text == ""){
            errors.append("Please enter some notes")
            typeTextField.backgroundColor = bazarRed
        }
        else
        {
            typeTextField.backgroundColor = UIColor.whiteColor() //PublicMethod.hexStringToUIColor("#202020")
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
        
        var errors: [String] = []
        
        if(!Reachability.isConnectedToNetwork())
        {
            errors.append("It looks like you are not connected. Splunkt needs internet access to work properly")
        }
        
        if(errors.count > 0){
            
            let alert = UIAlertView(title: "Internet Connection unavailable!", message: errors.implode("\n"), delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            
            return
        }
        
        // Create
        ///
        
         Constants.sharedInstance.leadData = LeadData()
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        Constants.sharedInstance.leadData.staff_email = defaults.valueForKey("staff_email") as! String!
        Constants.sharedInstance.leadData.event_ID = defaults.valueForKey("event_ID") as! String!
                
        var stack = self.navigationController!.viewControllers as Array
        
//        for (var i = stack.count-1 ; i > 0; --i) {
//            
//            if(1 == i)
//            {
                var view = stack[1] as! LeadCaptureMethodViewController
                self.navigationController!.popToViewController(view, animated: true)
                
      //      }
            
     //   }
        
    }
    
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    
    
}
