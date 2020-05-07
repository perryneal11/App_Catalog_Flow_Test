//
//  ProxyManager.swift
//  App Catalog Flow Test
//
//  Created by Neal, Perry (P.) on 4/20/20.
//  Copyright © 2020 Neal, Perry (P.). All rights reserved.
//

import Foundation
import SmartDeviceLink

class ProxyManager: NSObject {
    private let appName = "App Catalog Test"
    private let appId = "123456"

    // Manager
    fileprivate var sdlManager: SDLManager!

    // Singleton
    static let sharedManager = ProxyManager()

    private override init() {
        super.init()

        // Used for USB Connection
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId)

        // Used for TCP/IP Connection
        // let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId, ipAddress: "<#IP Address#>", port: <#Port#>)

        // App icon image
        let appImage = UIImage(named: "icon")
        let appIcon = SDLArtwork(image: appImage!, name: "icon", persistent: true, as: .JPG /* or .PNG */)
            lifecycleConfiguration.appIcon = appIcon
        
        
        lifecycleConfiguration.shortAppName = "app catalog"
        lifecycleConfiguration.appType = .information
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .enabled(), logging: .default(), fileManager: .default())
        sdlManager = SDLManager(configuration: configuration, delegate: self)
        
        // Menu
        // Create the menu cell
        let cell = SDLMenuCell(title: "Home", icon: appIcon, voiceCommands: nil) { (triggerSource: SDLTriggerSource) in
            // Menu item was selected, check the `triggerSource` to know if the user used touch or voice to activate it
            self.homeScreen()
        }

        sdlManager.screenManager.menu = [cell]
    }

    func connect() {
        // Start watching for a connection with a SDL Core
        self.home()

}
    
    func homeScreen(){
        print("Your app has successfully connected with the SDL Core")
        self.sdlManager.screenManager.softButtonObjects = []
        
        let display = SDLSetDisplayLayout(predefinedLayout: .tilesWithGraphic)
        self.sdlManager.send(request: display) { (request, response, error) in
            guard response?.success.boolValue == true else { print(error); return }
                print("The template has been set successfully")
        }
        
        let featuredSoftButton = SDLSoftButtonObject(name: "Featured", text: "Featured", artwork: nil) { (buttonPress, buttonEvent) in
             guard let buttonPress = buttonPress else { return }
             print("Button selected")
         }
        let allAppsSoftButton = SDLSoftButtonObject(name: "All apps", text: "All apps", artwork: nil) { (buttonPress, buttonEvent) in
             guard let buttonPress = buttonPress else { return }
             print("Button selected")
         }
        let categoriesLoadingSoftButton = SDLSoftButtonObject(name: "Categories/Loading", text: "Categories/Loading", artwork: nil) { (buttonPress, buttonEvent) in
             guard let buttonPress = buttonPress else { return }
             print("Button selected")
            let cellOne = SDLChoiceCell(text: "Music")
            let cellTwo = SDLChoiceCell(text: "Communication")
            let cellThree = SDLChoiceCell(text: "Connected Home")
            let cellFour = SDLChoiceCell(text: "Food")
            let cellFive = SDLChoiceCell(text: "Fuel")
            let cellSix = SDLChoiceCell(text: "Health and Wellness")
            let cellSeven = SDLChoiceCell(text: "Audio Books")
            let cellEight = SDLChoiceCell(text: "Must Have")
            let cellNine = SDLChoiceCell(text: "Navigation")
            let cellTen = SDLChoiceCell(text: "New")
            let cellEleven = SDLChoiceCell(text: "News")
            let cellTwelve = SDLChoiceCell(text: "Parking")
            let cellThriteen = SDLChoiceCell(text: "Productivity")
            let cellFourteen = SDLChoiceCell(text: "Sports")
            let choices = [cellOne, cellTwo, cellThree, cellFour, cellFive, cellSix, cellSeven, cellEight, cellNine, cellTen, cellEleven, cellTwelve, cellThriteen, cellFourteen]
            let helpItem = SDLVRHelpItem(text: "help text", image: nil)
            let choiceSet = SDLChoiceSet(title: "categories", delegate: self, layout: .list, timeout: 10, initialPromptString: "inital prompt string", timeoutPromptString: "timeout prompt", helpPromptString: "this is a help string", vrHelpList: [helpItem], choices: choices)
            print(choiceSet)
            self.sdlManager.screenManager.present(choiceSet, mode: .manualOnly)
         }
        self.sdlManager.screenManager.beginUpdates()
        self.sdlManager.screenManager.softButtonObjects = [ featuredSoftButton, allAppsSoftButton, categoriesLoadingSoftButton]
        self.sdlManager.screenManager.primaryGraphic = SDLArtwork(image: UIImage(named: "image")!, persistent: false, as: .PNG)
        self.sdlManager.screenManager.endUpdates { (error) in
            if error != nil {
                print("Error updating UI")
            } else {
                print("Update to UI was successful")
            }
        }
    }

    func home(){
            sdlManager.start { (success, error) in
                if success {
                    self.homeScreen()
                }
                else {
                    print("error")
                }
            }
        }
    }
    
    
//MARK: SDLManagerDelegate
extension ProxyManager: SDLManagerDelegate {
  func managerDidDisconnect() {
    print("Manager disconnected!")
  }

  func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
    print("Went from HMI level \(oldLevel) to HMI level \(newLevel)")
  }

}

//MARK: SDLChoiceSetDelegate
extension ProxyManager: SDLChoiceSetDelegate {
               func choiceSet(_ choiceSet: SDLChoiceSet, didSelectChoice choice: SDLChoiceCell, withSource source: SDLTriggerSource, atRowIndex rowIndex: UInt) {
                self.catSelected()
                
               }
    
    
               func choiceSet(_ choiceSet: SDLChoiceSet, didReceiveError error: Error) {
                   print("fail")
               }
    
    
    func catSelected(){
        var display = SDLSetDisplayLayout(predefinedLayout: .tilesOnly)
            self.sdlManager.send(request: display) { (request, response, error) in
                guard response?.success.boolValue == true else { print(error); return }
                    print("The template has been set successfully")
            }
            
            self.sdlManager.screenManager.softButtonObjects = []

            let appImage = UIImage(named: "icon")
            let appIcon = SDLArtwork(image: appImage!, name: "icon", persistent: true, as: .JPG /* or .PNG */)
            
            let menuName1SoftButton = SDLSoftButtonObject(name: "Music app", text: "Music app", artwork: appIcon) { (buttonPress, buttonEvent) in
                 guard let buttonPress = buttonPress else { return }
                self.appSelected()
        
             }
            
            let menuName2SoftButton = SDLSoftButtonObject(name: "jam app", text: "jam app", artwork: appIcon) { (buttonPress, buttonEvent) in
                 guard let buttonPress = buttonPress else { return }
                 self.appSelected()
             }
            
            let menuName3SoftButton = SDLSoftButtonObject(name: "sounds app", text: "sounds app", artwork: appIcon) { (buttonPress, buttonEvent) in
                 guard let buttonPress = buttonPress else { return }
                 self.appSelected()
             }
            
            let menuName4SoftButton = SDLSoftButtonObject(name: "Another app ", text: "Another app", artwork: appIcon) { (buttonPress, buttonEvent) in
                 guard let buttonPress = buttonPress else { return }
                 self.appSelected()
             }
            
            
            self.sdlManager.screenManager.softButtonObjects = [menuName1SoftButton, menuName2SoftButton, menuName3SoftButton, menuName4SoftButton]
            self.sdlManager.screenManager.beginUpdates()
            self.sdlManager.screenManager.endUpdates { (error) in
                if error != nil {
                    print("Error updating UI")
                } else {
                    print("Update to UI was successful")
                }
            }
        
    }
    
    
    func appSelected(){
        
        var display = SDLSetDisplayLayout(predefinedLayout: .nonMedia)
        self.sdlManager.send(request: display) { (request, response, error) in
             guard response?.success.boolValue == true else { print(error); return }
                 print("The template has been set successfully")
         }
        self.sdlManager.screenManager.softButtonObjects = []
        self.sdlManager.screenManager.beginUpdates()
        self.sdlManager.screenManager.primaryGraphic = SDLArtwork(image: UIImage(named: "image")!, persistent: true, as: .PNG)
        self.sdlManager.screenManager.textField1 = "Loading......"
        self.sdlManager.screenManager.textField2 = ""
        self.sdlManager.screenManager.textField3 = ""
        

        print(self.sdlManager.screenManager.textField1)
        
        let homeSoftButton = SDLSoftButtonObject(name: "Home", text: "Home", artwork: nil) { (buttonPress, buttonEvent) in
            guard let buttonPress = buttonPress else { return }
            self.homeScreen()
        }
        
        let backSoftButton = SDLSoftButtonObject(name: "Back", text: "Back", artwork: nil) { (buttonPress, buttonEvent) in
            guard let buttonPress = buttonPress else { return }
            self.catSelected()
           
        }
        
        let wishlistSoftButton = SDLSoftButtonObject(name: "Wishlist", text: "Wishlist", artwork: nil) { (buttonPress, buttonEvent) in
            guard let buttonPress = buttonPress else { return }
            print("Button selected")
        }
        self.sdlManager.screenManager.softButtonObjects = [homeSoftButton, backSoftButton, wishlistSoftButton]
        self.sdlManager.screenManager.endUpdates { (error) in
            if error != nil {
                print("Error updating UI")
                print(error)
            } else {
                print("Update to UI was successful")
            }
        }
        
        let secondsToDelay = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
           print("This message is delayed")
           // Put any code you want to be delayed here
            self.sdlManager.screenManager.beginUpdates()
            self.sdlManager.screenManager.textField1 = "A subscription based music audio"
            self.sdlManager.screenManager.textField2 = "podcast that combines lossless"
            self.sdlManager.screenManager.textField3 = "audio"
            self.sdlManager.screenManager.endUpdates { (error) in
                if error != nil {
                    print("Error updating UI")
                    print(error)
                } else {
                    print("Update to UI was successful")
                }
            }
        }
        
    }
}
