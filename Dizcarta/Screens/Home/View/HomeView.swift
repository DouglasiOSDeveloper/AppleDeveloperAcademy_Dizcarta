//
//  Home.swift
//  Dizcarta
//
//  Created by Felipe Brigagão de Almeida on 19/09/22.
//

import SwiftUI
import CoreData

struct HomeView: View {
    let shared = GenericFunctions()
    @State var isPlayerListView = false
    
    var body: some View {
        NavigationView {
            Group {
                VStack {
                    shared.checkIfImageExist(name: "LogoHome")
                        .resizable()
                        .frame(minWidth: 280, idealWidth: 340,
                               maxWidth: 360, minHeight: 160,
                               idealHeight: 192, maxHeight: 210,
                               alignment: .center)
                        .padding(25)
                    VStack {
                        NavigationLink {
                            PlayerListView()
                        } label: {
                            GenericButtons(label: "Jogar", image: "PlayButtonHome")
                        }
                        
                    .padding(15)
                        NavigationLink {
                            ConfigurationsView(isNarratorPressed: false, isHapticsPressed: false, isRulesPressed: false, isColorBlindnessPressed: false)
                        } label: {
                            GenericButtons(label: "Configurações", image: "ConfigButtonHome")
                        }
                        .padding(15)
                        
                        Button {
                            
                        } label: {
                            GenericButtons(label: "Histórico", image: "HistoryButtonHome")
                        }
                        .padding(15)
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
