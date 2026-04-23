import SwiftUI

struct WelcomeView: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var activeTab: Int

    @AppStorage("noVolverAMostrarWelcome") private var noVolverAMostrarWelcome = false
    @AppStorage("MedejasContinuar") private var MedejasContinuar = false

    var body: some View {
        ZStack {
            // Fondo sólido (negro en este caso)
            Color.black
                .ignoresSafeArea(.all)

            // Imagen que mantiene proporción exacta
            Image("welcome")
                .resizable()
                .scaledToFit() // mantiene proporción sin recorte
                .frame(width: width) // ajusta al ancho de pantalla
                .clipped()
                .ignoresSafeArea(.all)

            // Área "tapable" el BOTON CONTINUAR
            VStack {
                Spacer()

                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        MedejasContinuar = true
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.2))
                            .frame(width: width * 0.40, height: 55)

                        VStack(spacing: 2) {
                            Text("Continue")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)

                            Text("Continuar")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .multilineTextAlignment(.center)
                    }

                }
                .buttonStyle(.plain)

                Spacer().frame(height: height * 0.105)
            }



            // Toggle sobre la imagen, bien abajo
            VStack {
                Spacer()
                Toggle(isOn: $noVolverAMostrarWelcome) {
                    Text("Don't show this again")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 18))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .toggleStyle(SwitchToggleStyle(tint: .orange))
                .scaleEffect(0.70)
                .frame(maxWidth: width * 0.6)
                .background(Color.clear)
                .cornerRadius(10)
                .offset(y: 10) // ⬅️ DESPLAZA HACIA ABAJO RELATIVO AL FONDO
            }

            .padding(.bottom, 20) // ⬅️ mueve toda la VStack más abajo

        }
        .onAppear {
            MedejasContinuar = false
            print("DEBUG RootView → noVolverAMostrarWelcome:", noVolverAMostrarWelcome)
            print("DEBUG RootView → MedejasContinuar:", MedejasContinuar)
        }
        
    }
}

