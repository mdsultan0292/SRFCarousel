//
//  AppDelegate.swift
//  SRFCarousel
//
//  Created by Mohd Sultan on 06/02/20.
//  Copyright © 2020 Mohd Sultan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewcontroller:UIViewController = mainstoryboard.instantiateViewController(withIdentifier: "SRFCarouselVC") as! SRFCarouselVC
        self.window?.rootViewController = newViewcontroller
        self.window?.makeKeyAndVisible()
        return true
    }

    


}

