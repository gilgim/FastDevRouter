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
        LottieTestView()
        ExerciseContentView()
        CommonView()
        GridView()
        SearchBar(text: .constant(""))
    }
}

struct ExerciseContentView: View {
    @State var exerciseName: String = "Test Name"
    @State var bodyPart: String = "Test Part"
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
                    VStack(alignment: .leading) {
                        Text(exerciseName)
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .fixedSize()
                        Text(bodyPart)
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
                        .frame(width: 30)
                }
                .padding(.trailing, 24)
            }
        }
        .frame(height: 90)
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

