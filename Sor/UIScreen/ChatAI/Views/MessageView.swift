//
//  MessageView.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 07/10/2024.
//

import SwiftUI

struct MessageView: View {
  var message: Message
  var body: some View {
    Group {
      if message.isUser {
        HStack {
          Spacer()
          Text(message.content)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color(hex: "#DFE8F9"))
            .foregroundColor(Color(hex: "0F1827"))
            .cornerRadius(4)
        }
      } else {
        HStack {
          Text(message.content)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color(hex: "#E9E9EB"))
            .foregroundColor(Color(hex: "0F1827"))
            .cornerRadius(4)
          Spacer()
        }
      }
    }
  }
}
