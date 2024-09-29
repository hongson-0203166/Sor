import UIKit
import ESTabBarController

import UIKit
import ESTabBarController
import SnapKit

class MainTabBarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupViewControllers()
        setupMiddleButton()
    }
  
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      setupTabar()
    }

    private func setupViewControllers() {
      navigationController?.isNavigationBarHidden = true
      let homeVC = TabbarType.home.viewController
      homeVC.tabBarItem = ESTabBarItem(TabbarContentView(), title: TabbarType.home.title, image: TabbarType.home.icon, selectedImage: TabbarType.home.iconFill)

      let chatAIVC = TabbarType.chatAI.viewController
      chatAIVC.tabBarItem = ESTabBarItem(TabbarContentView(), title: TabbarType.chatAI.title, image: TabbarType.chatAI.icon, selectedImage: TabbarType.chatAI.iconFill)

      let middleVC = TabbarType.bmi.viewController
      middleVC.tabBarItem = ESTabBarItem(TabbarContentView(), title: "", image: UIImage(named: ""), selectedImage: UIImage(named: ""))

      let featuresVC = TabbarType.features.viewController
      featuresVC.tabBarItem = ESTabBarItem(TabbarContentView(), title: TabbarType.features.title, image: TabbarType.features.icon, selectedImage: TabbarType.features.iconFill)

      let settingVC = TabbarType.settings.viewController
      settingVC.tabBarItem = ESTabBarItem(TabbarContentView(), title: TabbarType.settings.title, image: TabbarType.settings.icon, selectedImage: TabbarType.settings.iconFill)

        viewControllers = [homeVC, chatAIVC, middleVC, featuresVC, settingVC]
    }
  
    private func setupTabar() {
      let appearance = UITabBarAppearance()
      appearance.configureWithOpaqueBackground()
      let normal = [NSAttributedString.Key.foregroundColor: R.color.light() as Any]
      let selected = [NSAttributedString.Key.foregroundColor: R.color.primary() as Any]
      appearance.stackedLayoutAppearance.normal.titleTextAttributes = normal
      appearance.stackedLayoutAppearance.selected.titleTextAttributes = selected
      tabBar.standardAppearance = appearance
      if #available(iOS 15.0, *) {
          UITabBar.appearance().scrollEdgeAppearance = appearance
      } else {
          UITabBarItem.appearance().setTitleTextAttributes(normal, for: .normal)
          UITabBarItem.appearance().setTitleTextAttributes(selected, for: .selected)
      }
      tabBar.isTranslucent = false
      tabBar.backgroundColor = .white
    }

  private func setupMiddleButton() {
    let middleButton = UIButton(type: .custom)
    middleButton.backgroundColor = R.color.primary()
    middleButton.layer.cornerRadius = 35
    middleButton.setImage(TabbarType.bmi.iconFill, for: .normal)
    middleButton.tintColor = .white
    middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
    
    self.tabBar.addSubview(middleButton)
    middleButton.snp.makeConstraints { make in
      make.centerX.equalTo(self.tabBar)
      make.bottom.equalTo(self.tabBar).offset(-40)
      make.width.height.equalTo(70)
    }
    
    self.tabBar.bringSubviewToFront(middleButton)
  }

    @objc func middleButtonTapped() {
        self.selectedIndex = 2
    }
}
