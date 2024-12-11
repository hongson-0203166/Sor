//
//  FillData1View.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 13/11/24.
//

import SwiftUI

struct FillData1View: View {
  @Binding var textInput: String
  
  var body: some View {
    ZStack {
      TextField("", text: $textInput)
        .frame(height: 52)
        .background(Color.white)
        .font(.system(size: 16, weight: .medium))
        .foregroundColor(.black)
        .cornerRadius(10)
        .shadow(
          color: Color(red: 0.08, green: 0.06, blue: 0.33, opacity: 0.12), radius: 10, y: 4
        )
        .overlay(alignment: .trailing) {
          Image(.icDelete)
            .resizable()
            .scaledToFit()
            .frame(width: 35, height: 35)
            .padding(.trailing, 10.38)
            .hidden(textInput.isEmpty)
            .onTapGesture {
              textInput = ""
            }
        }
        .padding(.horizontal, 34)
      
    }
  }
}

