//
//  NasaView.swift
//  ApiSession
//
//  Created by @DavidSanSan110 on 3/11/23.
//

import SwiftUI

struct NasaView: View {

    var viewModel = ViewModel()
    @Binding var view: Int
    @State var date = Date()
    @State var item: NasaItem?
    @State var selectedImageURL: URL?
    @State var isModalPresented = false
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
                        .foregroundColor(.white)
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
                        .foregroundColor(.black)
                }
            }
            VStack(spacing: 20) {
                Text("Elige el día")
                    .fontWeight(.bold)
                Spacer()
                .frame(height: 40)
                DatePicker("Fecha", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(width: 300, height: 150)
                Spacer()
                .frame(height: 40)
                Button("Buscar") {
                    Task {
                        self.item = nil
                        self.item = try await viewModel.fetchNasaItems(date: date)
                    }
                }
                .frame(width: 100, height: 20)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()

            if let item = item {
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 5)
                        )
                    VStack(spacing: 10) {
                        Text(item.title)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text(item.explanation)
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        AsyncImage(url: item.imgUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .onTapGesture {
                            self.selectedImageURL = item.imgUrl
                            self.isModalPresented.toggle()
                        }
                        .sheet(isPresented: $isModalPresented) {
                            if let imageURL = selectedImageURL {
                                ModalView(imageURL: imageURL, isModalPresented: $isModalPresented)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                }
                .padding(.horizontal, 30)
            }


        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct ModalView: View {
    var imageURL: URL
    @Binding var isModalPresented: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            AsyncImage(url: imageURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else if phase.error != nil {
                    Text("Error loading image")
                } else {
                    ProgressView()
                }
            }
            HStack {
                Spacer()
                Button(action: {
                    // Close the modal
                    isModalPresented.toggle()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding()
                .position(x: UIScreen.main.bounds.width - 30, y: 30)
            }
        }
    }
}
