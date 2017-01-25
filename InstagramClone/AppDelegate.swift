//
//  AppDelegate.swift
//  InstagramClone
//
//  Created by Xuehua Chen on 1/23/17.
//  Copyright © 2017 Xuehua Chen. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn
import AWSCognito

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, AWSIdentityProviderManager {

    var window: UIWindow?
    var googleIdToken = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            googleIdToken = user.authentication.idToken // Safe to send to the server
//            let userId = user.userID                  // For client-side use only!
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            // [START_EXCLUDE]
//            NotificationCenter.default.post(
//                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
//                object: nil,
//                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
//            // [END_EXCLUDE]
//            print(userId!, googleIdToken!, fullName!, givenName!, familyName!, email!)
            signIntoCognito(user: user)
            
        }
    }
    
    func signIntoCognito(user: GIDGoogleUser) {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .usWest2, identityPoolId: "us-west-2:2f59c7dc-6222-467d-bcdd-3ae9c211c27d", identityProviderManager: self)
        let configuration = AWSServiceConfiguration(region: .usWest2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        credentialsProvider.getIdentityId().continue({ (task:AWSTask) -> Any? in
            if task.error != nil {
                print("hello", task.error as Any)
                return nil
            }
            
            if let syncClient = AWSCognito.default() {
                if let dataset = syncClient.openOrCreateDataset("InstagramDataset") {
                    dataset.setString(user.profile.email, forKey: "email")
                    dataset.setString(user.profile.name, forKey: "name")
                    
                    let result = dataset.synchronize()
                    
                    result?.continue({ (task: AWSTask) -> Any? in
                        if task.error != nil {
                            print("hello1", task.error as Any)
                        } else {
                            print("hello2", task.result as Any)
                        }
                        return nil
                    })
                }
            }
            return nil
        })
    }
    
    func logins() -> AWSTask<NSDictionary> {
        let result = NSDictionary(dictionary: [AWSIdentityProviderGoogle : googleIdToken])
        return AWSTask(result: result)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("disconnect")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

