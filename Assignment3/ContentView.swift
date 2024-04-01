//
// ContentView.swift : Assignment3
//
// Copyright © 2023 Auburn University.
// All Rights Reserved.

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = CharacterViewModel()
    @State private var characterID: String = ""
    
    var body: some View {
        VStack {
            Text("Rick and Morty Character Locator").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
                .padding()
            TextField("Character ID", text: $characterID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Fetch Character") {
                if let id = Int(characterID) {
                    fetchCharacter(id: id)
                }
            }.buttonStyle(BorderedButtonStyle())
                .padding()
            
            if let character = viewModel.character {
                Text("Name: \(character.name)")
                Text("Current Location: \(character.location.name)")
                Button("Refresh") {
                    if let id = Int(characterID) {
                        fetchCharacter(id: id)
                    }
                }
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchCharacter()
        }
        .padding()
    }
    
    private func fetchCharacter(id: Int) {
        let urlString = "https://rickandmortyapi.com/api/character/\(id)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let decodedResponse = try? JSONDecoder().decode(Character.self, from: data) {
                DispatchQueue.main.async {
                    viewModel.character = decodedResponse
                }
                return
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

