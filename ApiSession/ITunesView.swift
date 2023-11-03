//
//  ITunesView.swift
//  ApiSession
//
//  Created by @DavidSanSan110 on 3/11/23.
//

import SwiftUI

struct ITunesView: View {
    
    var viewModel = ViewModel()
    @State var selectedOption = 0
    @State var items: [ITunesItem] = []
    @State var menuVisible = false
    @State var theme = ""

    let options = ["movie", "podcast", "music", "musicVideo", "audiobook", "shortFilm", "tvShow", "software", "ebook", "all"]

    @Binding var view: Int

    
    var body: some View {
        VStack {
            //Barra de navegación para cambiar de vista
            HStack {
                VStack {
                    Button("iTunes") {
                        self.view = 0
                    }
                    .frame(width: 180, height: 20)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Rectangle()
                        .frame(width: 180, height: 5)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    }
                VStack {
                    Button("Nasa") {
                        self.view = 1
                    }
                    .frame(width: 180, height: 20)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Rectangle()
                        .frame(width: 180, height: 5)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }

            Text("Buscador de multimedia")
                .fontWeight(.bold)
                .padding()
            HStack {
                Text("Tipo de multimedia: ")
                Picker("Selecciona una opción", selection: $selectedOption) {
                    ForEach(0 ..< options.count, id: \.self) {
                        index in
                        Text(self.options[index]).tag(index)
                    }
                }
            }
            .pickerStyle(MenuPickerStyle())
            TextField("Introduce el nombre",text: $theme)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            Button("Cargar datos") {
                Task {
                    self.items = []
                    self.items = try await viewModel.fetchITunesItems(theme: self.theme, media: self.options[self.selectedOption])
                    self.theme = ""
                }
            }
            List(items, id: \.name) { item in
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.artist)
                        .font(.subheadline)
                    Text(item.kind)
                        .font(.subheadline)
                    AsyncImage(url: item.artworkURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
