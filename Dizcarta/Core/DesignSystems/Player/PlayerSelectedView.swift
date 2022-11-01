//
//  PlayerSelectedView.swift
//  Dizcarta
//
//  Created by Douglas Figueirôa on 07/10/22.
//

import SwiftUI

struct PlayerSelectedView: View {
  // MARK: - PROPERTIES
  @State var isEditing: Bool = false
  @FocusState var nameIsFocused: FocusedField?
  @ObservedObject var player: Player
  @State private var backupName: String = ""
  var saveAction: () -> Void
  var deleteAction: () -> Void
  enum FocusedField {
      case username
  }

  // MARK: - BODY
  var body: some View {
    GeometryReader { geometry in
      HStack {
        GenericFunctions.checkIfImageExist(name: player.wrappedAvatar)
          .resizable()
          .frame(width: 95, height: 95)
          .padding(.leading, 10)
          .padding(.trailing, -15)
          .opacity(1.0)
        
        if isEditing {
          TextField("", text: $player.wrappedName)
            .foregroundColor(.white)
            .font(Font(name: .primaryFont, size: 20))
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled(true)
            .focused($nameIsFocused, equals: .username)
            .modifier(TextFieldClearButton(text: $player.wrappedName))
            .padding(.vertical, 8)
            .task {
              self.nameIsFocused = .username
            }
          
        } else {
          TextField("", text: $player.wrappedName)
            .foregroundColor(.white)
            .font(Font.custom("DINAlternate-Bold", size: 20))
            .disabled(!isEditing)
        }
        
        Button {
          self.isEditing.toggle()
        } label: {
          if isEditing {
            GenericFunctions.checkIfImageExist(name: "checkmark")
              .frame(width: 22, height: 18)
              .padding(20)
              .onTapGesture {
                if player.wrappedName.trimmingCharacters(in: .whitespaces).isEmpty {
                  player.wrappedName = backupName
                }
                saveAction()
                backupName = player.wrappedName
                self.isEditing.toggle()
              }
          } else {
            Image(systemName: "pencil")
              .resizable()
              .frame(width: 16, height: 16)
              .padding(22)
              .foregroundColor(Color(.textPlayersCount))
          }
        }
      }
      .background(
        HStack {
          RoundedRectangle(cornerRadius: 5)
            .foregroundColor(Color(.playerListBackgroundColor))
            .frame(width: geometry.size.width - 25, height: 40)
        }
      )
      .onAppear {
        backupName = player.wrappedName
      }
      
    }
  }
}

// MARK: - PREVIEW
// struct PlayerSelectedView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerSelectedView(player: Player()) {
//            print("Hello World")
//        }
//            .preferredColorScheme(.dark)
//    }
// }
