//
//  EmptyView.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 7/11/24.
//

import SwiftUI

struct EmptyView: View {
  var body: some View {
    VStack(spacing: 0, content: {
      Spacer()
      Image(R.image.ic_emptyData)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 190, height: 150)
      Spacer()
        .frame(height: 24)
      Text("It’s look a bit empty here")
        .foregroundColor(Color(hex: "#050505"))
        .font(.system(size: 18))
      Spacer()
        .frame(height: 4)
      Text("Let’s fill me up by creating conversations with AI")
        .foregroundColor(Color(hex: "#AFAFAF"))
        .font(.system(size: 14))
        .padding(.horizontal, 50)
        .multilineTextAlignment(.center)
      Spacer()
    })
  }
}
