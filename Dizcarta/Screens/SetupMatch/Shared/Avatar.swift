//
//  Avatar.swift
//  Dizcarta
//
//  Created by Felipe Brigagão de Almeida on 06/10/22.
//

import SwiftUI

struct Avatar: View {
  // MARK: - PROPERTIES
  @State private var isPressed: Bool = false
  @State var avatar: String
  @State var name: String
  @State private var changeOpacity: Bool = false
  @EnvironmentObject var gameCore: GameCore
  var isSelection: Bool
  var removeAction: () -> Void
  var createAction: () -> Void
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      HStack {
        Image(avatar)
          .padding(isSelection ? -10 : 20)
          .opacity(changeOpacity ? 1.0 : 0.5)
          .onTapGesture {
              self.createAction()
              self.changeOpacity = true
          }
          .background {
              if gameCore.players.contains(where: { $0.wrappedAvatar == avatar }) {
              Image("BackgroundSelectedPlayer")
            }
          }
          .overlay {
            if gameCore.players.contains(where: { $0.wrappedAvatar == avatar }) {
              ZStack(alignment: .bottomTrailing) {
                Image("BackgroundSelectedPlayer")
                  .opacity(0.0)
                Image("removePlayer")
                  .onTapGesture {
                    self.removeAction()
                    self.changeOpacity = false
                  }
              }
            }
          }
        
        if !isSelection {
          Text(name)
            .font(.system(size: 24, weight: .semibold))
        }
      }
    }
  }
}

// MARK: - BODY
struct Avatar_Previews: PreviewProvider {
  static var previews: some View {
      Avatar(avatar: "avatarRed", name: "Alice", isSelection: true) {
          
      } createAction: {
      }
      .preferredColorScheme(.light)
      .previewLayout(.sizeThatFits)
  }
}
