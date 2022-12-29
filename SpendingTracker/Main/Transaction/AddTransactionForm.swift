//
//  AddTransactionForm.swift
//  SpendingTracker
//
//  Created by David Lee on 12/29/22.
//

import SwiftUI

struct AddTransactionForm: View {
  let card: Card
  
  @Environment(\.presentationMode) var presentationMode
  
  @State private var name = ""
  @State private var amount = ""
  @State private var date = Date()
  
  @State private var shouldPresentPhotoPicker = false
  @State private var photoData: Data?

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Information")) {
          TextField("Name", text: $name)
          TextField("Amount", text: $amount)
          DatePicker(
            "Date",
            selection: $date,
            displayedComponents: .date
          )
          
          NavigationLink(destination: Text("Many").navigationTitle("New Title")) {
            Text("Many to many")
          }
        }
        
        Section(header: Text("Photo/Receipt")) {
          Button {
            shouldPresentPhotoPicker.toggle()
          } label: {
            Text("Select Photo")
          }
          .fullScreenCover(isPresented: $shouldPresentPhotoPicker) {
            PhotoPickerView(photoData: $photoData)
          }
          
          if let data = self.photoData, let image = UIImage.init(data: data) {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
          }
        }
      }.navigationTitle("Add Transaction")
        .navigationBarItems(leading: cancelButton, trailing: saveButton)
    }
  }
  
  private var saveButton: some View {
    Button {
      let context = PersistenceController.shared.container.viewContext
      let transaction = CardTransaction(context: context)
      transaction.name = self.name
      transaction.timestamp = self.date
      transaction.amount = Float(self.amount) ?? 0
      transaction.photoData = self.photoData
      
      transaction.card = self.card
      
      do {
        try context.save()
        presentationMode.wrappedValue.dismiss()
      } catch let customError {
        print("Failed to save transaction: \(customError)")
      }
    } label: {
      Text("Save")
    }    
  }
  
  private var cancelButton: some View {
    Button {
      presentationMode.wrappedValue.dismiss()
    } label: {
      Text("Cancel")
    }
  }
}

struct PhotoPickerView: UIViewControllerRepresentable {
  @Binding var photoData: Data?
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }
  
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private let parent: PhotoPickerView
    
    init(parent: PhotoPickerView) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
      let image = info[.originalImage] as? UIImage
      let imageData = image?.jpegData(compressionQuality: 0.5)
      self.parent.photoData = imageData
      
      picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true)
    }
  }
  
  func makeUIViewController(context: Context) -> some UIViewController {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = context.coordinator
    return imagePicker
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}

struct AddTransactionForm_Previews: PreviewProvider {
  static let firstCard: Card? = {
    let context = PersistenceController.shared.container.viewContext
    let request = Card.fetchRequest()
    request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
    return try? context.fetch(request).first
  }()
  
  static var previews: some View {
    if let card = firstCard {
      AddTransactionForm(card: card)
    }
  }
}
