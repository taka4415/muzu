import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let _controller = window?.rootViewController as! FlutterViewController
    // let _navigationController = window?.rootViewController as! UINavigationController

    var ref: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: "apple")
    let _channel = FlutterMethodChannel(
      name: "ios",
      binaryMessenger: _controller.binaryMessenger)
    

    _channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in

      if call.method == "getDictionary" {
       
        guard let args = call.arguments as? [String: String] else {return}
        let name = args["name"]!
        ref = UIReferenceLibraryViewController(term: name)
        // _controller.present(ref, animated: true, completion: nil)
        // ref.navigationController?.setNavigationBarHidden(true, animated: true)
        let navigationBar = ref.view.findViews(subclassOf: UINavigationBar.self).first
        navigationBar!.topItem?.rightBarButtonItem = nil
        // navigationBar!.items.setRightBarButtonItems(nil, animated: true)
        // navigationBar!.prefersLargeTitles = true
        // navigationBar!.removeFromSuperview()
        // navigationBar!.frame = CGRectMake(0, 0, 0, 0)
        let toolBar = ref.view.findViews(subclassOf: UIToolbar.self).first
        // toolBar!.removeFromSuperview()
        // ref.view.layoutMargins = UIEdgeInsets.init(top:-50,left:0,bottom:0,right:0)
        ref.view.frame = CGRect(x:12,y:300,width:(_controller.view.bounds.width-24),height:(_controller.view.bounds.height/1.5))
        _controller.view.addSubview(ref.view)
        ref.view.isHidden = true;
        result("success")
      } else if call.method == "showDictionary" {
         ref.view.isHidden = false;
        // _controller.view.addSubview(ref.view)
        // result(ref)
      } else if call.method == "removeDictionary" {
        ref.view.removeFromSuperview();
        // result(ref)
      }
      else if call.method == "modalDictionary" {
        guard let args = call.arguments as? [String: String] else {return}
        let name = args["name"]!
        ref = UIReferenceLibraryViewController(term: name)
         _controller.present(ref, animated: true, completion: nil)
        // result(ref)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension UIView {
        func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
            /*<T: UIView>この表記はジェネリクス関数であることを表す。
            ローマ字は何でも良いが、ここではT。引数はUIView以下のクラスの型。返り値はクラス?*/
            return recursiveSubviews.compactMap { $0 as? T }
            //compactMapに関してはまた今度調べよう!
        }
        
        var recursiveSubviews: [UIView] {
            return subviews + subviews.flatMap { $0.recursiveSubviews }
            //flatmapってなんだよ!
        }
    }
