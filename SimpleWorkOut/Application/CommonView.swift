//
//  CommonView.swift
//  SimpleWorkOut
//
//  Created by Gilgim on 2023/08/15.
//

import SwiftUI
import Lottie

struct CommonView: View {
    @State var isCustomButtonSelect: Bool = false
    var body: some View {
        Button(action: {
            isCustomButtonSelect.toggle()
        }) {
            Text("type")
        }
        .buttonStyle(CustomButtonStyle(isPressed: isCustomButtonSelect))
    }
}

struct CommonView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
        LottieTestView()
        ExerciseContentView()
        CommonView()
        GridView()
        SearchBar(text: .constant(""))
    }
}
struct TestView: View {
    @State private var showCustomAlert = false
    var body: some View {
        VStack {
            ZStack {
                Color.black.opacity(0.58).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                
                GeometryReader { geo in
                    ZStack {
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 35)
                                    .clipShape(Rectangle().offset(y: -240))
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(lineWidth: 5)
                            }
                        VStack(spacing: 20) {
                            Spacer().frame(height: 35)
                            Text("Title")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                            Spacer()
                            HStack {
                                Button(action: {
                                    
                                }) {
                                    Text("CONFIRM")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.blue))
                                }
                                Spacer().frame(width:30)
                                Button(action: {
                                    
                                }) {
                                    Text("CONFIRM")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.blue))
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(width: 270, height: 300)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2) // 뷰를 중앙에 배치
                    
                }
            }
        }
    }
}
extension View {
    func customAlert<Content: View>(isPresented: Binding<Bool>, title: String, message: String, views: [AnyView]) -> some View {
        self.overlay(
                Group {
                    if isPresented.wrappedValue {
                        ZStack {
                            Color.black.opacity(0.58).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .ignoresSafeArea()
                            
                            GeometryReader { geo in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                                    
                                    VStack(spacing: 20) {
                                        Text(title)
                                            .font(.title)
                                        
                                        Button(action: {
                                            isPresented.wrappedValue = false
                                        }) {
                                            Text("CONFIRM")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                                        }
                                    }
                                    .padding()
                                }
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.2)
                                .position(x: geo.size.width / 2, y: geo.size.height / 2) // 뷰를 중앙에 배치
                            }
                        }
                    }
                }
            )
    }
}
struct ExerciseContentView: View {
    @State var exerciseName: String = "테스트 입니다"
    @State var bodyPart: String = "테스트 입니다."
    var exercisePlayButtonClickHandler: (()->())? = nil
    var exerciseButtonClickHandler: (()->())? = nil
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.064), radius: 12, x: 0, y: 2)
            HStack {
                Button {
                    exerciseButtonClickHandler?()
                }label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(exerciseName)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .fixedSize()
                        Text(bodyPart)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .padding(.leading, 8)
                    }
                    .foregroundColor(.black)
                    .padding(.leading, 24)
                    Rectangle()
                        .foregroundColor(.white)
                }
                Button {
                    exercisePlayButtonClickHandler?()
                }label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(.systemGreen))
                        .frame(width: 25)
                }
                .padding(.trailing, 24)
            }
        }
        .frame(height: 75)
    }
}


struct GridView: View {
    @State private var items: [String] = ["+"] // 초기에 + 버튼만 있는 배열
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
            ForEach(items.indices, id: \.self) { index in
                if items[index] == "+" {
                    Button(action: {
                        items.insert("Item \(items.count)", at: 0) // 새 항목을 배열의 첫 번째에 추가
                    }) {
                        Image("banchPress")
                            .resizable()
                            .scaledToFit()
//                        Text("+")
//                            .font(.largeTitle)
//                            .frame(width: 120, height: 120)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
                    }
                } else {
                    Text(items[index])
                        .frame(width: 120, height: 120)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}

struct CustomButtonStyle: ButtonStyle {
    var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundColor(isPressed ? Color(.white) : Color(.systemGray2))
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isPressed ? Color(.systemBlue) : Color(.systemGray6)) // 상태에 따른 색상 변경
                    .shadow(radius: 2, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: isPressed ? 2 : 0) // 상태에 따른 테두리 변경
            )
    }
}

struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
    }
}

struct LottieView: UIViewRepresentable {
    var name: String
    var size: CGSize
    @Binding var isPlaying: Bool

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name:name)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.8
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: size.height * 1.9),
            animationView.widthAnchor.constraint(equalToConstant: size.width * 1.9),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        context.coordinator.animationView = animationView

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        if isPlaying {
            context.coordinator.animationView?.play()
        } else {
            context.coordinator.animationView?.play()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.000001) {
                context.coordinator.animationView?.pause()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: LottieView
        var animationView: LottieAnimationView?

        init(_ parent: LottieView) {
            self.parent = parent
        }
    }
}


struct LottieTestView: View {
    @State var isWorkOut: Bool = false
    var body: some View {
        VStack {
            LottieView(name: "runningAnimation", size: .init(width: 60, height: 60), isPlaying: $isWorkOut)
                .background(.red)
                .frame(width: 60, height: 60)
            Button("click") {
                isWorkOut.toggle()
            }
        }
    }
}

