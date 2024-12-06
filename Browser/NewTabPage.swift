import SwiftUI
#if os(macOS)
import Cocoa
#endif
import AVFoundation

struct NewTabPage: View {
    @State private var image: Image? = nil
    @AppStorage("Use-Image") var useImage = false
    var body: some View {
        ZStack {
            if useImage {
                DefaultImageView()
            }
            else {
                CameraView()
                
            }
            Text("""
                Hello
                """)
                .font(.largeTitle)
                .bold()
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(width: 10000, height: 10000)
                )
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}
#if os (iOS)
struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

class CameraViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
    }
    
    private func setupCamera() {
        captureSession.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Unable to access the camera")
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        // Setup the preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        if let previewLayer = previewLayer {
            view.layer.addSublayer(previewLayer)
        }
        
        // Start the session
        captureSession.startRunning()
    }
    
    private func checkCameraPermission() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraStatus {
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCamera()
                    } else {
                        self?.showPermissionAlert()
                    }
                }
            }
        case .authorized:
            // Permission already granted
            setupCamera()
        case .denied, .restricted:
            // Permission denied or restricted
            showPermissionAlert()
        @unknown default:
            break
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Access Needed",
            message: "Please grant camera access in Settings to use this feature.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
}
#elseif os(macOS)
struct CameraView: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }
    
    func updateNSViewController(_ nsViewController: CameraViewController, context: Context) {
        // No updates needed for now
    }
}

class CameraViewController: NSViewController {
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()
    }
    
    private func setupCamera() {
        captureSession.sessionPreset = .high
        
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Unable to access the camera")
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        // Setup the preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        if let previewLayer = previewLayer {
            view.layer = CALayer()
            view.layer?.addSublayer(previewLayer)
        }
        
        // Start the session
        captureSession.startRunning()
    }
    
    private func checkCameraPermission() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraStatus {
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCamera()
                    } else {
                        self?.showPermissionAlert()
                    }
                }
            }
        case .authorized:
            // Permission already granted
            setupCamera()
        case .denied, .restricted:
            // Permission denied or restricted
            showPermissionAlert()
        @unknown default:
            break
        }
    }
    
    private func showPermissionAlert() {
        let alert = NSAlert()
        alert.messageText = "Camera Access Needed"
        alert.informativeText = "Please grant camera access in System Preferences to use this feature."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Preferences")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn, let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera") {
            NSWorkspace.shared.open(url)
        }
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        previewLayer?.frame = view.bounds
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        captureSession.stopRunning()
    }
}
#endif
import SwiftUI

// Define a protocol for handling images that works across platforms
protocol PlatformImage {
    associatedtype ImageType
    static func create(from data: Data) -> ImageType?
}

#if os(iOS)
import UIKit

// Conform to PlatformImage for iOS using UIImage
extension UIImage: PlatformImage {
    static func create(from data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
#elseif os(macOS)
import AppKit

// Conform to PlatformImage for macOS using NSImage
extension NSImage: PlatformImage {
    static func create(from data: Data) -> NSImage? {
        return NSImage(data: data)
    }
}
#endif

struct DefaultImageView: View {

    var body: some View {
        VStack {
            Image("visionOS-BG")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(
            Image("visionOS-BG")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
        .edgesIgnoringSafeArea(.all)
    }
}
