//
//  FirebaseService.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseService {
    static let share = FirebaseService()
    
    private init() {}
    
    enum DatabaseValue: String {
        case health_test_category = "health_test_category"
        case heart_blog = "heart_blog"
        case articles = "articles"
        case receipt = "receipt"
    }
    
    enum ObserveType {
        case single
        case observe
    }
}

//MARK: - Resend Email, Reset password
extension FirebaseService {
    func getData<T: Codable>(
        _ dbValue: FirebaseService.DatabaseValue,
        showLoading: Bool = true,
        observe: FirebaseService.ObserveType = .single,
        type: T.Type,
        completion: ((_ data : T?) -> Void)? = nil
    ) {
        let ref = Database.database().reference(withPath: dbValue.rawValue)
        
        displayLoading(showLoading)
        
        if !Reachability.isConnectedToNetwork() {
            debugPrint("Kết nối mạng thất bại")
            hideLoading(showLoading)
            completion?(nil)
        }
        
        switch observe {
        case .single:
            singleEvent(ref: ref, type: T.self, completion: completion)
        case .observe:
            observeEvent(ref: ref, type: T.self, completion: completion)
        }
    }
    
    private func singleEvent<T: Codable>(ref: DatabaseReference, showLoading: Bool = true, type: T.Type, completion: ((_ data : T?) -> Void)? = nil) {
        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let `self` = self, let value = snapshot.value else {
                completion?(nil)
                self?.hideLoading(showLoading)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                if let model: T = Parser.parser(data: jsonData) {
                    hideLoading(showLoading)
                    completion?(model)
                } else {
                    hideLoading(showLoading)
                    completion?(nil)
                }
            } catch _ {
                hideLoading(showLoading)
                completion?(nil)
            }
        }) { _ in
            self.hideLoading(showLoading)
            completion?(nil)
        }
    }
    
    private func observeEvent<T: Codable>(ref: DatabaseReference, showLoading: Bool = true, type: T.Type, completion: ((_ data : T?) -> Void)? = nil) {
        ref.observe(.value, with: { [weak self] snapshot in
            guard let `self` = self, let value = snapshot.value else {
                self?.hideLoading(showLoading)
                completion?(nil)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                if let model: T = Parser.parser(data: jsonData) {
                    hideLoading(showLoading)
                    completion?(model)
                } else {
                    hideLoading(showLoading)
                    completion?(nil)
                }
            } catch _ {
                hideLoading(showLoading)
                completion?(nil)
            }
        }) { _ in
            self.hideLoading(showLoading)
            completion?(nil)
        }
    }
    
    private func displayLoading(_ allow: Bool) {
        if allow {
            DispatchQueue.main.async {
                if let view = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                    ActivityIndicator.shared.show()
                }
            }
        }
    }

    private func hideLoading(_ allow: Bool) {
        if allow {
            DispatchQueue.main.async {
                if let view = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                    ActivityIndicator.shared.hide()
                }
            }
        }
    }
}



struct Parser {
    internal static func parser<T: Codable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        var json: T
        do {
            json = try decoder.decode(T.self, from: data)
        } catch let error {
            print(error)
            return nil
        }
        return json
    }
    
    internal static func toDict(data: Codable) -> [String: Any] {
        return data.dictionary
    }
}

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}


class ActivityIndicator {

    static let shared = ActivityIndicator()
    var container: UIView = UIView()

    var loadingView: UIView = UIView()

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func show() {
        if let uiView = UIWindow.visibleWindow() {
            container.frame = uiView.bounds
            container.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.3)
            loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.center = CGPoint(x: uiView.bounds.width / 2, y: uiView.bounds.height / 2)
            loadingView.backgroundColor = .clear
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            activityIndicator.style = UIActivityIndicatorView.Style.large
            activityIndicator.tintColor = UIColor(hex: 0x444444, alpha: 0.5)
            activityIndicator.center = CGPoint(x: (loadingView.frame.size.width / 2) + 1.5, y: (loadingView.frame.size.height / 2) + 1.5)
            loadingView.addSubview(activityIndicator)
            container.addSubview(loadingView)
            uiView.addSubview(container)

            activityIndicator.startAnimating()
        }
    }

    func hide() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}


extension UIWindow {
    static func visibleWindow() -> UIWindow? {
        var originalKeyWindow: UIWindow?
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            originalKeyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            originalKeyWindow = UIApplication.shared.keyWindow
        }
        #else
        originalKeyWindow = UIApplication.shared.keyWindow
        #endif
        return originalKeyWindow
    }
}
