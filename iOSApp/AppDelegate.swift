import UIKit
import CoreMotion
import Network

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var motionManager = CMMotionManager()
    var connection: NWConnection?
    
    let pcIP = "192.168.1.100"
    let pcPort: UInt16 = 8080

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = VRStreamViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        setupUDPConnection()
        startGyroscopeTracking()
        
        return true
    }
    
    func setupUDPConnection() {
        let host = NWEndpoint.Host(pcIP)
        let port = NWEndpoint.Port(rawValue: pcPort)!
        connection = NWConnection(host: host, port: port, using: .udp)
        connection?.start(queue: .global())
    }
    
    func startGyroscopeTracking() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
                guard let data = data, error == nil else { return }
                
                let pitch = data.attitude.pitch
                let roll = data.attitude.roll
                let yaw = data.attitude.yaw
                
                let payload = "\(pitch),\(roll),\(yaw)"
                self?.sendUDPPayload(payload)
            }
        }
    }
    
    func sendUDPPayload(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        connection?.send(content: data, completion: .contentProcessed({ error in
            if let error = error {
                print("Error UDP: \(error)")
            }
        }))
    }
}

class VRStreamViewController: UIViewController {
    let leftEyeView = UIImageView()
    let rightEyeView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        let halfWidth = screenWidth / 2
        
        leftEyeView.frame = CGRect(x: 0, y: 0, width: halfWidth, height: screenHeight)
        rightEyeView.frame = CGRect(x: halfWidth, y: 0, width: halfWidth, height: screenHeight)
        
        leftEyeView.contentMode = .scaleAspectFit
        rightEyeView.contentMode = .scaleAspectFit
        
        view.addSubview(leftEyeView)
        view.addSubview(rightEyeView)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}
