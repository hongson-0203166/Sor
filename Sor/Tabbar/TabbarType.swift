//
//  TabbarType.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 21/09/2024.
//

import UIKit

enum TabbarType: CaseIterable {
    case home
    case chatAI
    case bmi
    case features
    case settings
    
    var title: String? {
        switch self {
        case .home:
            return "Home"
        case .chatAI:
            return "AI"
        case .bmi:
            return nil
        case .features:
            return "Features"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: UIImage? {
      switch self {
      case .home:
        return R.image.tab_home()?.withRenderingMode(.alwaysOriginal)
      case .chatAI:
        return R.image.tab_folder()?.withRenderingMode(.alwaysOriginal)
      case .bmi:
          return nil
      case .features:
        return R.image.tab_features()?.withRenderingMode(.alwaysOriginal)
      case .settings:
        return R.image.tab_settings()?.withRenderingMode(.alwaysOriginal)
      }
    }
    
    var iconFill: UIImage? {
      switch self {
      case .home:
        return R.image.tab_home_fill()?.withRenderingMode(.alwaysOriginal)
      case .chatAI:
        return R.image.tab_folder_fill()?.withRenderingMode(.alwaysOriginal)
      case .bmi:
        return R.image.tab_add()?.withRenderingMode(.alwaysOriginal)
      case .features:
        return R.image.tab_features_fill()?.withRenderingMode(.alwaysOriginal)
      case .settings:
        return R.image.tab_settings_fill()?.withRenderingMode(.alwaysOriginal)
      }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .chatAI:
            return ChatAIViewController()
        case .bmi:
            return PulseViewController()
        case .features:
            return RecommendViewController()
        case .settings:
            return SettingViewController()
        }
    }
}
