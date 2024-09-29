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
    
    var cancelable = Set<AnyCancellable>()

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
      setupObservable()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    func setupObservable() {}
  
    func pushToViewController(with vc: UIViewController, animated: Bool = true) {
        VCService.push(controller: vc, animated: animated)
    }
}
