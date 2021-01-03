//
//  AppDelegate.swift
//
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print("Realm Database Location: \(Realm.Configuration.defaultConfiguration.fileURL!)")
//        print("CoreData Database Location: \(FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.absoluteString ?? ".libraryDirectory")Application Support/DataModel.sqlite")
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm, \(error)")
        }

        return true
    }
}

