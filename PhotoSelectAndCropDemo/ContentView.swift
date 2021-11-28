//
//  ContentView.swift
//  ImageSelectAndCropDemo
//
//  Created by Dave Kondris on 28/11/21.
//

import SwiftUI
import PhotoSelectAndCrop

struct ContentView: View {
    @State private var isEditMode: Bool = false
    @State private var isShowingSettings: Bool = false
    @State private var isShowingDetails: Bool = false
    
    @StateObject var viewModel: ContentView.ViewModel
    
    init(viewModel: ViewModel = .init(), image: ImageAttributes) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @State private var image: ImageAttributes = placeholderImage
    @State private var renderingMode: SymbolRenderingMode = .hierarchical
    @State private var renderingModeInt: Int = 1
    @State private var colors: [Color] = [.accentColor, Color(.systemTeal), Color.init(red: 248.0 / 255.0, green: 218.0 / 255.0, blue: 174.0 / 255.0)]
    @State private var themeColor: Color = Color.accentColor
    @State private var isGradient: Bool = false
    
    let size: CGFloat = 220
    let renderingButtonWidth: CGFloat = 167.5
    let renderingButtonHeight: CGFloat = 32
    var body: some View {
        VStack {
            ZStack {
                Text("Demo")
                    .font(.largeTitle).bold()
                    .foregroundColor(Color.white)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    if isEditMode {
                        Button("Cancel", action:  {
                            withAnimation {
                                isEditMode.toggle()
                            }
                        })
                            .frame(width: 80, height: 36, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color(.systemPink).opacity(0.85))
                            .cornerRadius(8)
                    }
                    Spacer()
                    Button(isEditMode ? "Save" : "Edit", action:  {
                        withAnimation {
                            isEditMode.toggle()
                        }
                    })
                        .frame(width: 80, height: 36, alignment: .center)
                        .foregroundColor(.white)
                        .background(isEditMode ? Color.green.opacity(0.85) : Color.white.opacity(0.35))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 6)
                .opacity(isShowingSettings ? 0.0 : 1.0)
            }
            .background(
                themeColor.edgesIgnoringSafeArea(.top).shadow(radius: 8))
            .padding(.bottom, 8)
            
            Group {
                ZStack {
                    if !(image.originalImage == nil) {
                        Button(action: {
                            isShowingDetails.toggle()
                        }) { Image(systemName: "info.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(themeColor)
                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                .padding(.trailing, 30)
                                .padding(.bottom, 18)
                        }
                    }
                    if isGradient {
                        ImagePane(image: image, isEditMode: $isEditMode, renderingMode: renderingMode, linearGradient: LinearGradient(colors: [colors[0], colors[1]], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: size, height: size)
                            .foregroundColor(themeColor)
                    } else {
                        ImagePane(image: image,
                                  isEditMode: $isEditMode,
                                  renderingMode: renderingMode,
                                  colors: colors)
                            .frame(width: size, height: size)
                            .foregroundColor(themeColor)
                    }
                }
            }
            .padding(.top, 10)
            Divider()
            if !isShowingSettings {
                        Text("Camina Drummer")
                    .font(.title)
                    Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    TextField("", text: $viewModel.symbolName,onCommit:  {
                        checkUpdate()
                    })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .simultaneousGesture(TapGesture().onEnded {
                        })
                    Button("Set", action:  {
                        withAnimation {
                            checkUpdate()
                        }
                    })
                        .frame(width: 90, height: renderingButtonHeight)
                        .border(.white, width: 2)
                        .foregroundColor(.white)
                        .background(themeColor.opacity(0.85))
                }
                Divider()
                HStack {
                    VStack {
                        ColorPicker("Primary", selection: $colors[0])
                        ColorPicker("Secondary", selection: $colors[1])
                        ColorPicker("Tertiary", selection: $colors[2])
                        Toggle("Gradient", isOn: $isGradient)
                    }
                    Divider()
                    VStack (spacing: 6) {
                        Button(".monochrome", action:  {
                            withAnimation {
                                renderingMode = .monochrome
                                renderingModeInt = 0
                            }
                        })
                            .padding()
                            .frame(width: renderingButtonWidth, height: renderingButtonHeight)
                            .border(.white, width: 2)
                            .background( (renderingModeInt == 0) ? .green : themeColor)
                        Button(".hierarchal", action:  {
                            withAnimation {
                                renderingMode = .hierarchical
                                renderingModeInt = 1
                            }
                        })
                            .padding()
                            .frame(width: renderingButtonWidth, height: renderingButtonHeight)
                            .border(.white, width: 2)
                            .background( (renderingModeInt == 1) ? .green : themeColor)
                        Button(".palette", action:  {
                            withAnimation {
                                renderingMode = .palette
                                renderingModeInt = 2
                            }
                        })
                            .padding()
                            .frame(width: renderingButtonWidth, height: renderingButtonHeight)
                            .border(.white, width: 2)
                            .background( (renderingModeInt == 2) ? .green : themeColor)
                        Button(".multiColor", action:  {
                            withAnimation {
                                renderingMode = .multicolor
                                renderingModeInt = 3
                            }
                        })
                            .padding()
                            .frame(width: renderingButtonWidth, height: renderingButtonHeight)
                            .border(.white, width: 2)
                            .background( (renderingModeInt == 3) ? .green : themeColor)
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                }
                .frame(height: 160)
                Divider()
                ColorPicker("Theme Color", selection: $themeColor)
                if !(image.originalImage == nil) {
                    Button("Remove Photo", action:  {
                        withAnimation {
                            self.image = ImageAttributes(withSFSymbol: viewModel.symbolName)
                        }
                    })
                        .padding()
                        .frame(width: renderingButtonWidth, height: renderingButtonHeight)
                        .border(.white, width: 2)
                        .foregroundColor(.white)
                        .background(themeColor.opacity(0.85))
                }
            }
            .padding(.horizontal)
            .rotation3DEffect(.degrees(isShowingSettings ? 0 : 540.5), axis: (x: 1, y: 0, z: 0))
            .scaleEffect(isShowingSettings ? 1.0 : 0.0, anchor: .center)
            .frame(maxHeight: isShowingSettings ? .infinity : 160)
            
            Button(action: {
                withAnimation(.spring()) {
                    isShowingSettings.toggle()
                }
                
            }) { Label(isShowingSettings ? "Hide Settings" : "Show Settings", systemImage: "gearshape.fill")
                    .foregroundColor(themeColor)
                    .padding(.bottom, 15)
            }
            .opacity(isEditMode ? 0.0 : 1.0)
        }
        .sheet(isPresented: $isShowingDetails){
            DetailsView(image: image, themeColor: themeColor)
        }
    }
    
    
    func checkUpdate() {
        self.image = ImageAttributes(withSFSymbol: viewModel.symbolName)
        viewModel.update(image)
        if viewModel.symbolName == "avatar" {
            image = placeholderAvatar
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var symbolName: String = "person.crop.circle.fill"
        func update(_ image: ImageAttributes) {
            if symbolName != "avatar" {
                image.image = Image(systemName: symbolName.lowercased())
            }
        }
    }
}

struct ContentVieww_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(image: placeholderImage)
    }
}
