//
//  ScannerVC.swift
//  QRScanner
//
//  Created by nirzar on 17/08/20.
//  Copyright © 2020 nirzar. All rights reserved.
//

class ScannerVC: UIViewController {
    
    //MARK: - QRScannerView Outlet
    @IBOutlet weak var vScanner: QRScannerView! {
        didSet {
            vScanner
                .delegate = self
        }
    }
    
    //MARK: - UILabel Outlet
    @IBOutlet weak var lblInformation: UILabel!
    
    //MARK: - Variable Declaration
    var qrData: QRDataModel?
    
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkCameraAccess()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !vScanner.isRunning {
            vScanner.stopScanning()
        }
    }
    
    //MARK: - Initialization Method
    func initialization() {
        setNavigationHeader(strTitleName: "QRScanner")
    }
    
    //MARK: - Check Camera Access Method
    func checkCameraAccess() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .denied:
            presentAlert(withTitle: "Error", message: "Camera access is denied", isCameraPermission: true)
            
        case .restricted:
            print("Restricted, device owner must approve")
            
        case .authorized:
            if !vScanner.isRunning {
                vScanner.startScanning()
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    if !self.vScanner.isRunning {
                        self.vScanner.startScanning()
                    }
                } else {
                    print("Permission denied")
                }
            }
            
        default:
            break
        }
    }
    
    //MARK: - UIButton Action Method
    @IBAction func btnOpenURLAction(_ sender: Any) {
        
        if let url = URL(string: qrData?.codeString ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            showToast(message : "Not a valid URL")
        }
    }
}

//MARK: - Extension QRScannerViewDelegate
extension ScannerVC: QRScannerViewDelegate {
    
    func qrScanningDidStop() {
        
    }
    
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRDataModel(codeString: str)
        
        lblInformation.text = self.qrData?.codeString ?? "No data available"
        
        vScanner.startScanning()
    }
}


