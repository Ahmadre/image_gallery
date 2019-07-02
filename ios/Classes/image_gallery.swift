import Flutter;
import UIKit;
import Photos;

@objc open class SwiftFlutterGallaryPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "image_gallery", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterGallaryPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getPlatformVersion") {
            result("iOS " + UIDevice.current.systemVersion)
        }
        else if (call.method == "getAllImages") {
            
            DispatchQueue.main.async {
                
                let imgManager = PHImageManager.default()
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
                
                let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
                var allImages = [String]()
                
                var totalItration = 0
                
                var savedLocalIdentifiers = [String]()
                
                for index in 0..<fetchResult.count
                {
                    let asset = fetchResult.object(at: index) as PHAsset
                    let localIdentifier = asset.localIdentifier
                    savedLocalIdentifiers.append(localIdentifier)
                    
                    imgManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFit, options: PHImageRequestOptions(), resultHandler:{(image, info) in
                        let path = (info?["PHImageFileURLKey"] as! NSURL).path!;
                    
                        if image != nil {
                                allImages.append(path);
                        }
                        totalItration += 1
                        if totalItration == (fetchResult.count) {
                            result(allImages)
                        }
                    })
                }
            }
        }
    }
}
