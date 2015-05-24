//
//  CompetitionViewController.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import UIKit

import Foundation


class CompetitionViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,  UITableViewDelegate, UITableViewDataSource{
    
    
    ///
    var tableView: UITableView!
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
    
    
    var toolbar: UIToolbar!
    
    var competitionList : Array<String> = []
    var selectedCompetitionList : Array<String> = []
    
    
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
        
        if( self.competitionList.count == 0)
        {
            getAllCompetitionData()
        }
        
        
        //Track
        //Track
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "startView", andValue: "viewWillAppear"))
        Mint.sharedInstance().logViewWithCurrentViewName("CompetitionViewController", limitedExtraDataList: datalist)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        let datalist = LimitedExtraDataList()
        datalist.add(ExtraData(key: "closeView", andValue: "viewDidDisappear"))
        Mint.sharedInstance().logViewWithCurrentViewName("CompetitionViewController", limitedExtraDataList: datalist)
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
    
        //
        self.competitionList =   Constants.sharedInstance.competitionList
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
        scrollView.addSubview(createLabel("Select All Products Mentioned", frame: CGRectMake(leftOffset, top, fullWidth, 16), align:1))
      
        ///
        top += 40
        //TableView
        self.tableView =  createTableView(CGRectMake(leftOffset, top, fullWidth , self.view.frame.size.height - 240.0))
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
       
        
        self.tableView.registerNib(UINib(nibName: "UseCaseTableViewCell", bundle: nil), forCellReuseIdentifier: "UseCaseTableViewCell")
        
        
        scrollView.addSubview(tableView)
        
        
        top += self.view.frame.size.height - 240.0 + 10.0
        
         top += 10
        
        // scrollView.addSubview(createImageView( UIImage(named: "pickup_btn"), frame: CGRectMake(leftOffset, top, fullWidth, 32)))
        
        saveButton = createButton("Submit", frame: CGRectMake(leftOffset, top, fullWidth , 32))
        saveButton.tag = 100
        saveButton.setTitleColor(UIColor(white: 1, alpha: 1), forState: .Normal)
        saveButton.backgroundColor = UIColor.blackColor()
        ///PublicMethod.hexStringToUIColor("#00acee")// UIColor(red: 0, green: 204, blue: 255, alpha: 1)
        saveButton.addTarget(self, action: "savePressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(saveButton)
        
        ///
              
        top += 50
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        
      //  self.view.backgroundColor = UIColor.clearColor()
        
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
    
   
    
    
    override func shouldAutorotate() -> Bool {
        
        return false
    }
    
    func createView(frame:CGRect) -> UIView{
        
        var view = UIView(frame: frame)
        view.backgroundColor = UIColor.whiteColor()
        return view
    }
    
    //TableView
    func createTableView(frame:CGRect) -> UITableView{
        
        var tableView = UITableView(frame: frame)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
          tableView.tableFooterView = UIView()
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
        
       
        
        if(self.selectedCompetitionList.count == 0 )
        {
              errors.append("Please select at least one competitor")
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
        
        let bgColor = PublicMethod.hexStringToUIColor("#759e39")
        scrollView.backgroundColor = bgColor
        
        self.view = scrollView
        
    }
    
    ////
    
    //Picture taking area
    
    
    @IBAction func savePressed(sender: UIButton){
        // Create
        // Create
//        if(!checkForm(sender.tag)){
//            return
//        }
        
        ///
        var isFirst = 0
        var competition = ""
        
        for tempCompetition in selectedCompetitionList
        {
            if(isFirst == 1)
            {
                competition = "\(competition),\(tempCompetition)"
                
            }else
            {
                isFirst = 1
                competition = tempCompetition
            }
        }
        
        
        Constants.sharedInstance.leadData.compe66on = competition
        
        self.showNotesViewController()
        
    }
    
    ///
    func showNotesViewController()
    {
        println("showNotesViewController")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let notesViewController = storyBoard.instantiateViewControllerWithIdentifier("notesViewController") as! NotesViewController
        
        self.navigationController!.pushViewController(notesViewController, animated: true)
    }
    
    
    //Table View Area
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitionList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        //generate cell
        let cell = tableView.dequeueReusableCellWithIdentifier("UseCaseTableViewCell", forIndexPath: indexPath) as! UseCaseTableViewCell
        
        let useCase = self.competitionList[indexPath.row]
            as String
        
        //day
        cell.nameLabel.text = useCase
       
        
        if(indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor.whiteColor()
            
        }else
        {
            cell.backgroundColor =  UIColor.whiteColor() //PublicMethod.hexStringToUIColor("#4c4b4b")
        }
        // cell.nameLabel.text = menuList[indexPath.row]
        
        var isFound = false
        
        
        for tempUseCase in selectedCompetitionList
        {
            if(tempUseCase == useCase)
            {
                isFound = true;
            }
        }
        
        
        if(isFound)
        {
            cell.accessoryType = .Checkmark
          ///  cell.checkImageView.image = UIImage(named: "check_select")
            
        }else
        {
            cell.accessoryType = .None
            
            //cell.checkImageView.image = UIImage(named: "check_normal")
        }
        
        
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        
        // add it to the image view;
        cell.checkImageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        cell.checkImageView.userInteractionEnabled = true
        
        cell.checkImageView.tag = indexPath.row
        
        
        // Log details of the failure
        
        
        //  cell.userInteractionEnabled = false
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        
        var index = indexPath.row
        
        let competition = self.competitionList[index]
            as String
        
        var position = 0
        var isFound = false
        for tempUseCase in self.selectedCompetitionList
        {
            if(tempUseCase == competition)
            {
                // position++
                
                isFound = true
                selectedCompetitionList.removeAtIndex(position)
                
                break
            }
            
            position++
        }
        
        if(!isFound)
        {
            selectedCompetitionList.append(competition)
        }
        
        tableView.reloadData()

        
        
        
    }
    

    
    //tapGesture clcik
    @IBAction func tapGesture(sender: AnyObject) {
        
        var tapRecognizer = sender as! UITapGestureRecognizer
        
        var  tapLocation = tapRecognizer.locationInView(tableView) as CGPoint
        
        var tappedIndexPath =   tableView.indexPathForRowAtPoint(tapLocation) as NSIndexPath!;
        
        //    var imageView = sender as UITapGestureRecognizer
        
        var index = tappedIndexPath.row
        
        let competition = self.competitionList[index]
            as String
        
        var position = 0
        var isFound = false
        for tempUseCase in self.selectedCompetitionList
        {
            if(tempUseCase == competition)
            {
                // position++
                
                isFound = true
                selectedCompetitionList.removeAtIndex(position)
                
                break
            }
            
            position++
        }
        
        if(!isFound)
        {
            selectedCompetitionList.append(competition)
        }
        
        tableView.reloadData()
        
    }
    
    
    
    //Get all data
    
    func getAllCompetitionData(){
        
        
        ///
        var basicUrl =   "https://INDEXER:8089/servicesNS/nobody/splunkt_splunk_app/storage/collections/data/competitioncollection"
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
        
        
        client.responseSerializer = responseSerializer
        client.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json") as Set<NSObject>
        
        client.GET(basicUrl, parameters: params, success: { (operation : AFHTTPRequestOperation!, response : AnyObject!) -> Void in
            
            println("Response :  \(response.description)")
            
            
            //Fair
            
            println("LoadAllTollInfo Response :  \(response.description)")
            
            
            let jsonDict = response  as! NSArray
            
            Constants.sharedInstance.competitionList = []
            
            if(jsonDict.count > 0)
            {
                
                for var i=0 ;i < jsonDict.count; i++ {
                    
                    
                    let row = jsonDict.objectAtIndex(i) as! NSDictionary
                    
                    println("row :  \(row)")
                    
                    var addCompetition = row.valueForKey("addCompetition") as! String!
                    
                    Constants.sharedInstance.competitionList.append(addCompetition)
                    
                }
                
                self.competitionList =   Constants.sharedInstance.competitionList
                self.tableView.reloadData()
            }
            
            
            } , failure: { (operation : AFHTTPRequestOperation!, error : NSError!) -> Void in
                
                println("Error \(error.description) \(operation.responseObject) ")
                
                //  onCompletion(false, nil, nil, nil)
        })
        
    }

    @IBAction func staffEmailPressed(sender: UIButton){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
