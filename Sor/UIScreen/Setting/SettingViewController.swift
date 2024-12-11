//
//  SettingViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/09/2024.
//

import UIKit
import SwiftUI

class SettingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let contentView = SettingView()
        let hostingController = UIHostingController(rootView: contentView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
          hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}

struct SettingView: View {
    @StateObject private var userModel = RealmHelper<User>()
    @State private var newName: String = ""
    @State private var isEditingName = false
    var body: some View {
        VStack {
            Text("Setting")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
                .frame(height: 20)
            HStack {
                Text("Profile")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
            }
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 16)
                    Image(.icProfileSett)
                    Spacer()
                        .frame(width: 12)
                    Text("Name")
                    Spacer()
                    if isEditingName {
                        TextField("Enter new name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                    } else {
                        Text("\(userModel.objects.first?.name ?? "Sonph")")
                    }
                    Spacer()
                        .frame(width: 12)
                    Image(.icNextSett)
                    Spacer()
                        .frame(width: 16)
                }
                .frame(height: 52)
                Divider()
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 16)
                    Image(.icAge)
                    Spacer()
                        .frame(width: 12)
                    Text("Age")
                    Spacer()
                    Text("\(userModel.objects.first?.age ?? 20)")
                    Spacer()
                        .frame(width: 12)
                    Image(.icNextSett)
                    Spacer()
                        .frame(width: 16)
                }
                .frame(height: 52)
                Divider()
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 16)
                    Image(.icCycleLength)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .fixedSize()
                    Spacer()
                        .frame(width: 12)
                    Text("Cycle Length")
                    Spacer()
                    Text("\(userModel.objects.first?.cycleLength ?? 28)")
                    Spacer()
                        .frame(width: 12)
                    Image(.icNextSett)
                    Spacer()
                        .frame(width: 16)
                }
                .frame(height: 52)
                Divider()
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 16)
                    Image(.icDateRangeLight)
                    Spacer()
                        .frame(width: 12)
                    Text("Last Cycle")
                    Spacer()
                    Text("\(userModel.objects.first?.cycleLatest.toString(format: "MMM d, yyyy") ?? Date().toString(format: "MMM d, yyyy"))")
                    Spacer()
                        .frame(width: 12)
                    Image(.icNextSett)
                    Spacer()
                        .frame(width: 16)
                }
                .frame(height: 52)
            }
            .background(Color(hex: "F2F6FF"))
            .cornerRadius(10)
            
            Spacer()
                .frame(height: 20)

            HStack {
                Text("General")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
            }
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 16)
                    Image(.icVersion)
                    Spacer()
                        .frame(width: 12)
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.red)
                    Spacer()
                        .frame(width: 16)
                }
                .frame(height: 52)
                Divider()
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 16)
                    Image(.icPolicy)
                    Spacer()
                        .frame(width: 12)
                    Text("Privacy policy")
                    Spacer()
                    Spacer()
                        .frame(width: 12)
                    Image(.icNextSett)
                    Spacer()
                        .frame(width: 16)
                }
                .frame(height: 52)
            }
            .background(Color(hex: "F2F6FF"))
            .cornerRadius(10)
            Spacer()
        }
        .padding(.horizontal, 24)
        .onAppear {
            userModel.getAll()
            newName = userModel.objects.first?.name ?? ""
        }
    }
    
    private func saveUser() {
        let newUser = User()
        newUser.name = newName
//        newUser.age = currentAge + 12
//        newUser.cycleLatest = startDate ?? Date()
//        newUser.cycleLength = 28
//        newUser.periodLength = 5
        
        userModel.insertOrUpdate(newUser)
    }
}
