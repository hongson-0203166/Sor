//
//  VCService.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 21/09/2024.
//

import UIKit

class VCService {
    static var pushCount = 0
    
    static func type<T: UIViewController>(_ type: T.Type) -> T {
        let nibName = VCService.nameOf(type: type)
        let vc = T(nibName: nibName, bundle: nil)
        return vc
        
    }
    
    static func nameOf<T: UIViewController>(type: T.Type) -> String {
        let typeName = NSStringFromClass(type)
        let returnName = typeName.split { $0 == "." }.map { String($0) }.last ?? typeName
        return returnName
    }
    
    static func present<T: UIViewController>(type: T.Type,
                                             fromController: UIViewController? = nil,
                                             prepare: ((_ vc: T) -> Void)? = nil,
                                             animated: Bool = true,
                                             completion: (() -> Void)? = nil) {
        let vc = VCService.type(type)
        prepare?(vc)
        let parentVC = fromController ?? UIViewController.topViewController()
        parentVC?.present(vc, animated: animated, completion: completion)
    }
    
    static func present(controller: UIViewController,
                        fromController: UIViewController? = nil,
                        prepare: ((_ vc: UIViewController) -> Void)? = nil,
                        animated: Bool = true,
                        completion: (() -> Void)? = nil) {
        prepare?(controller)
        let parentVC = fromController ?? UIViewController.topViewController()
        parentVC?.present(controller, animated: animated, completion: completion)
    }
    
    static func push(controller: UIViewController,
                     fromController: UIViewController? = nil,
                     prepare: ((_ vc: UIViewController) -> Void)? = nil,
                     animated: Bool = true,
                     isShowInterstitial: Bool = true) {
        prepare?(controller)
        let parentVC = fromController ?? UIViewController.topViewController()
        controller.hidesBottomBarWhenPushed = true
        if let navigationController = parentVC?.navigationController {
            navigationController.pushViewController(controller, animated: animated)
        } else {
            delay(after: 600) {
                UIViewController.topViewController()?.navigationController?.pushViewController(controller, animated: animated)
            }
        }
    }
    
    static func dismiss(controller: UIViewController? = UIViewController.topViewController(), animated: Bool = true, completion: ((_ rootVC: UIViewController?) -> Void)? = nil) {
        controller?.view.endEditing(true)
        if let presentingViewController = controller?.presentingViewController {
            controller?.dismiss(animated: animated, completion: {
                completion?(presentingViewController)
            })
        } else {
            pop()
            completion?(controller)
        }
    }
    
    static func pop(controller: UIViewController? = UIViewController.topViewController(), animated: Bool = true, completion: ((_ rootVC: UIViewController?) -> Void)? = nil) {
        controller?.view.endEditing(true)
        if let naviController = controller?.navigationController {
            naviController.popViewController(animated: animated)
        } else {
            completion?(controller)
        }
    }
    
    static func changeTabbar(index: Int) {
        if let topVC = UIViewController.topViewController() as? UITabBarController {
            topVC.selectedIndex = index
        }
    }
    
    static func getTabbar(from: UIViewController? = UIViewController.topViewController()) -> UITabBarController? {
        return from?.tabBarController as? UITabBarController
    }
    
    static func getSelectedViewControllerOfTabbar() -> UIViewController? {
        return getTabbar()?.selectedViewController?.navigationController?.topViewController
    }
}

extension UIViewController {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

func delay(after milliseconds: Int, execute work: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: work)
}
