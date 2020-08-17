//
//  UIViewController+Alert.swift
//  QRScanner
//
//  Created by nirzar on 17/08/20.
//  Copyright © 2020 nirzar. All rights reserved.
//

extension UIViewController {
    
    //MARK: - Present Alert Method
    func presentAlert(withTitle title: String, message : String, isCameraPermission : Bool = false) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if isCameraPermission {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Open Settings",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            
                                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                            
            }))
        } else {
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Show Toast Method
    func showToast(message : String, seconds: Double = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
