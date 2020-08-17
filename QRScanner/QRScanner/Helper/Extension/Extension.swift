//
//  Extension.swift
//  coinbidz
//
//  Created by Nirzar on 02/01/18.
//  Copyright © 2018 . All rights reserved.
//

extension UIApplication {
    
    var screenShot: UIImage?  {
        
        if let rootViewController = keyWindow?.rootViewController {
            let scale = UIScreen.main.scale
            let bounds = rootViewController.view.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale);
            if let _ = UIGraphicsGetCurrentContext() {
                rootViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
        }
        return nil
    }
    
    public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }
    
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension UIViewController {
    
    //MARK: - Show/Hide Navigation Bar Methods
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setNavigationHeader(strTitleName : String = "") {
        
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        
        self.navigationController?.navigationBar.titleTextAttributes = (titleDict as! [NSAttributedString.Key : Any])
        self.navigationItem.title = strTitleName
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = .lightGray
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK: - Setup Back Button Method
    func setBackButton() {
        let btnBack = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_back_arrow"), style: .plain, target: self, action: #selector(popVC))
        self.navigationItem.leftBarButtonItem = btnBack
    }
    
    @objc func popVC() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}
