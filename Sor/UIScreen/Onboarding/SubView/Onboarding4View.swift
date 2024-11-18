//
//  Onboarding4View.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/11/24.
//

import SwiftUI

struct Onboarding4View: View {
    
  var body: some View {
    VStack {
      Image(R.image.ic_ob4)
      Spacer()
      NavigationLink(destination: FillDataView()) {
        CommonButton()
        .frame(height: 55)
        .padding(.horizontal, 24)
      }
      Spacer()
        .frame(height: 50)
      }.ignoresSafeArea()
  }
}
