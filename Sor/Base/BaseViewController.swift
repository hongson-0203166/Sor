//
//  BaseViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 21/09/2024.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    var subscriptions = Set<AnyCancellable>()
    
    deinit {
        print("\(Date()): ✅ \(String(describing: self))")
    }
    
    var cancellable = Set<AnyCancellable>()
    var tintColor: UIColor? = .white
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.isTranslucent = false
        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.tintColor = tintColor
        
        let className = NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
        debugPrint("\(className) \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.tintColor = tintColor
    }
    
    func configView() {}
    
    func pushToViewController(with vc: UIViewController, animated: Bool = true) {
        VCService.push(controller: vc, animated: animated)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension BaseViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

