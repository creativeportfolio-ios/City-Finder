

import UIKit
import Foundation
import SVProgressHUD

class AppUtility: NSObject {

    //MARK: -
    static let shared = AppUtility()
    public static var appDelegate : AppDelegate! {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    override init() {
        super.init()
        intializeOnce()
    }

    func intializeOnce() -> Void {
        UIApplication.shared.statusBarStyle = .lightContent
        self.SETUP_SVPROGRESS()
    }

    //MARK: - Class Functions
    class func STORY_BOARD() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard
    }

    class func SCREEN_WIDTH() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

    class func SCREEN_HEIGHT() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }

    class func RGBACOLOR(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: (red) / 255.0, green: (green) / 255.0, blue: (blue) / 255.0, alpha: alpha)
    }

    class func RGBCOLOR(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return RGBACOLOR(red: red, green: green, blue: blue, alpha: 1)
    }

    //MARK: - Instance Functions
    func SETUP_SVPROGRESS() {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.blue)
    }
}
