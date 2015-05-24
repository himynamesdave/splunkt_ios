//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIViewController {
    
//    func setNavigationBarItem() {
//        
//       
//        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
//        self.addRightBarButtonWithImage(UIImage(named: "plus_icon")!)
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
//        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()
//    }
//    
//    func removeNavigationBarItem() {
//    
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.rightBarButtonItem = nil
//
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
//        
//    }
    
    func setNavigationBar() {        
         self.addNavigationBarWithBackgroundAndLogo()
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    func addNavigationBarWithBackgroundAndLogo()
    {
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
       
    }
    
    func toggleLeft() {
        // self.slideMenuController()?.toggleLeft()
    }
    
    func toggleRight() {
        // self.slideMenuController()?.toggleRight()
    }
    

}