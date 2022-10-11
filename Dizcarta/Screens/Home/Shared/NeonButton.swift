//
//  ButtonHomeCOmponent.swift
//  Dizcarta
//
//  Created by Douglas Figueirôa on 06/10/22.
//

import SwiftUI

struct NeonButton: View {
    var text: String
    var image: ButtonsNameImage
    
    init(text: String, image: ButtonsNameImage) {
        self.text = text
        self.image = image
    }
    
    var body: some View {
        HStack {
            GenericFunctions.checkIfImageExist(name: image.rawValue)
                .overlay {
                    Text(text)
                        .font(Font(name: .primaryFont, size: 30))
                        .bold()
                        .foregroundColor(.white)
                }
        }
    }
}

struct NeonButton_Previews: PreviewProvider {
    static var previews: some View {
        NeonButton(text: "auau", image: .configButton)
    }
}
