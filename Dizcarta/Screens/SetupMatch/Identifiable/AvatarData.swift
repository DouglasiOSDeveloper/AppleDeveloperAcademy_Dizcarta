//
//  AvatarData.swift
//  Dizcarta
//
//  Created by Felipe Brigagão de Almeida on 06/10/22.
//

import Foundation

struct AvatarData: Hashable, Identifiable {
    let id = UUID()
    let image: String
    let name: String
}
