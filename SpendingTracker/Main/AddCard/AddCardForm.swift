//
//  AddCardForm.swift
//  SpendingTracker
//
//  Created by David Lee on 12/29/22.
//

import SwiftUI

struct AddCardForm: View {
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    NavigationView {
      ScrollView {
        Text("Add card form")
      }
      .navigationTitle("Add Credit Card")
      .navigationBarItems(
        leading: Button(
          action: {
            presentationMode.wrappedValue.dismiss()
          },
          label: {
            Text("Cancel")
          }
        )
      )
    }
  }
}

struct AddCardForm_Previews: PreviewProvider {
  static var previews: some View {
//    AddCardForm()
    MainView()
  }
}
