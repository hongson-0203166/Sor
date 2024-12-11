//
//  RealmEntity.swift
//  Sor
//
//  Created by Hồng Sơn Phạm on 26/11/24.
//

import RealmSwift
import Combine
import SwiftUI

// MARK: - RealmEntity Protocol
protocol RealmEntity: Object {
    static var primaryKeyName: String { get }
}

// MARK: - RealmHelper
class RealmHelper<T: RealmEntity>: ObservableObject {
    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    @Published var objects: [T] = []
    private var notificationToken: NotificationToken?
    private let objectSubject = PassthroughSubject<[T], Never>()
    
    init() {
        observeChanges()
    }
    
    // Insert or Update Object
    func insertOrUpdate(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch {
            print("Error saving object: \(error.localizedDescription)")
        }
    }
    
    // Fetch All Objects
    func getAll() {
        let results = realm.objects(T.self)
        objects = Array(results)
        objectSubject.send(objects)
    }
    
    // Delete by Primary Key
    func deleteByPrimaryKey(_ key: Any) {
        do {
            if let object = realm.object(ofType: T.self, forPrimaryKey: key) {
                try realm.write {
                    realm.delete(object)
                }
            }
        } catch {
            print("Error deleting object: \(error.localizedDescription)")
        }
    }
    
    // Observe Changes for SwiftUI and Combine
    private func observeChanges() {
        let results = realm.objects(T.self)
        notificationToken = results.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(let collection):
                self.objects = Array(collection)
                self.objectSubject.send(self.objects)
            case .update(let collection, _, _, _):
                self.objects = Array(collection)
                self.objectSubject.send(self.objects)
            case .error(let error):
                print("Error observing changes: \(error.localizedDescription)")
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    // Combine Publisher for UIKit
    func publisher() -> AnyPublisher<[T], Never> {
        objectSubject.eraseToAnyPublisher()
    }
}

// MARK: - SwiftUI Example
//struct UserListView: View {
//    @StateObject var userHelper = RealmHelper<User>()
//    
//    var body: some View {
//        VStack {
//            List(userHelper.objects, id: \.id) { user in
//                Text(user.name)
//            }
//            .onAppear {
//                userHelper.getAll()
//            }
//            Button("Add User") {
//                let user = User()
//                user.id = Int.random(in: 1...100)
//                user.name = "User \(user.id)"
//                userHelper.insertOrUpdate(user)
//            }
//        }
//    }
//}

// MARK: - UIKit Example
//import UIKit
//class UserListViewController: UIViewController {
//    private let userHelper = RealmHelper<User>()
//    private var cancellables: Set<AnyCancellable> = []
//    private let tableView = UITableView()
//    private var users: [User] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        bindData()
//        userHelper.getAll()
//    }
//    
//    private func setupTableView() {
//        tableView.dataSource = self
//        view.addSubview(tableView)
//        tableView.frame = view.bounds
//    }
//    
//    private func bindData() {
//        userHelper.publisher()
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] users in
//                self?.users = users
//                self?.tableView.reloadData()
//            }
//            .store(in: &cancellables)
//    }
//}
