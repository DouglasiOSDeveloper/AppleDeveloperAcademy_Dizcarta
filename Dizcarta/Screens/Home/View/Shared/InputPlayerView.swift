//
//  PickColorView.swift
//  Dizcarta
//
//  Created by Victor Brito on 21/09/22.
//

import SwiftUI

struct InputPlayerView: View {
    
    @Binding var text: String
    @State private var textFieldColor: Color = .black
    @Binding var selectedColor: Color
    var saveAction: (() -> Void) = {}
    var cancelAction: (() -> Void) = {}
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 318, height: 350, alignment: .center)
                .cornerRadius(20)
                .foregroundColor(Color(.backGroundPickerColor))
            VStack {
                ZStack {
                    Circle()
                        .frame(width: 80, height: 80, alignment: .center)
                        .foregroundColor(selectedColor)
                    
                    Image(systemName: "person")
                        .font(.custom("macrofont", size: 60))
                }
                TextField("Nome", text: $text)
                    .frame(width: 240, height: 20)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 13)
                        .stroke(textFieldColor, lineWidth: 1))
                
                Picker(selectedColor: $selectedColor)
                HStack {
                    GenericButtons(label: "Cancelar")
                        .frame(width: 120, height: 40)
                        .onTapGesture {
                            cancelAction()
                        }
                        .padding(.top)
                    // TODO: Mudar opacidade do botão de salvar quando o text for empty
                    GenericButtons(label: "Salvar")
                        .frame(width: 120, height: 40)
                        .onTapGesture {
                            if !text.isEmpty {
                                saveAction()
                            }
                        }
                        .padding(.top)
                }
            }
        }
    }
}

struct InputPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        InputPlayerView(text: .constant(""), selectedColor: .constant(Color(.avatarColorBlue)))
    }
}
