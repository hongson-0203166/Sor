//
//  ChatViewModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 03/10/2024.
//

import Foundation
import OpenAI

private enum Constant {
  static let apiToken = ""
}

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
  
    let openAI = OpenAI(apiToken: Constant.apiToken)
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .gpt3_5Turbo
        )
      
      openAI.chatsStream(query: query) { partialResult in
        switch partialResult {
            case .success(let result):
          guard let choice = result.choices.first else {
              return
          }
          if let messagePart = choice.delta.content {
            DispatchQueue.main.async {
              if let lastMessage = self.messages.last, !lastMessage.isUser {
                self.messages[self.messages.count - 1].content += messagePart
              } else {
                self.messages.append(Message(content: messagePart, isUser: false))
              }
            }
          }
        case .failure(let error):
                print(error)
            }
      } completion: { error in
      }
    }
}
