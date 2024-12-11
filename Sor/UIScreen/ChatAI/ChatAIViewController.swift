//
//  ChatAIViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/09/2024.
//

import UIKit
import SwiftUI
import Hooks

class ChatAIViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let contentView = ChatView()
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

struct ChatView: HookView {
  @StateObject var viewModel = ChatViewModel()
  @State var textMessage: String = ""
//  @State private var areButtonsHidden: Bool = false
  @State private var showingCustomCamera = false
  @State private var image: UIImage?
  
  var hookBody: some View {
    HookScope {
      let areButtonsHidden = useState(false)
      VStack {
        Text("AI Chat")
            .font(.title)
            .fontWeight(.bold)
        if viewModel.messages.isEmpty {
          EmptyView()
        } else {
          Spacer()
            .frame(height: 20)
          ScrollViewReader { proxy in
            ScrollView {
              ForEach(viewModel.messages, id: \.self) {
                message in
                MessageView(message: message)
                  .padding(5)
                  .id(message.id)
              }
            }
            .onAppear {
              proxy.scrollTo(viewModel.messages.last, anchor: .bottom)
            }
            .onReceive(viewModel.$messages) { _ in
              if let lastMessage = viewModel.messages.last {
                withAnimation {
                  proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
              }
            }
          }
        }
        
        HStack {
//          if !areButtonsHidden.wrappedValue {
//            Button {
//              showingCustomCamera = true
//            } label: {
//              Image(R.image.ic_camera)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 24, height: 24)
//            }
//            .sheet(isPresented: $showingCustomCamera, onDismiss: {
//                      guard let inputImage = image else { return }
//                      print("\(inputImage)")
//            }) {
//              CustomCameraView(image: $image)
//            }
//            Button { } label: {
//              Image(R.image.ic_photo)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 24, height: 24)
//            }
//            
//            Button { } label: {
//              Image(R.image.ic_voice)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 24, height: 24)
//            }
//          } else {
//            Button {
//              withAnimation {
//                areButtonsHidden.wrappedValue = false
//              }
//            } label: {
//              Image(R.image.ic_next1)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 24, height: 24)
//            }
//          }
          
          TextField("Enter your ask...", text: self.$textMessage, onEditingChanged: { isEditing in
                    if isEditing {
                      withAnimation {
                        areButtonsHidden.wrappedValue = true
                      }
                    }
                  })
            .padding(5)
            .frame(height: 48)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            
          Button {
            if !textMessage.trimmingCharacters(in: .whitespaces).isEmpty {
              viewModel.sendNewMessage(content: textMessage)
              textMessage = ""
            }
          } label: {
            Image(R.image.ic_sent)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 24, height: 24)
          }
        }
        .padding()
        .animation(.easeInOut, value: areButtonsHidden.wrappedValue)
      }
      .onTapGesture {
        areButtonsHidden.wrappedValue = false
        UIApplication.shared.endEditing()
      }
    }
  }
}
