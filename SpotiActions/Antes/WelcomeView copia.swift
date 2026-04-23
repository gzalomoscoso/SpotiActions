import SwiftUI

struct WelcomeView: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var activeTab: Int

    @AppStorage("noVolverAMostrarWelcome") private var noVolverAMostrarWelcome = false
    @AppStorage("MedejasContinuar") private var MedejasContinuar = false

    var body: some View {
        ZStack {
            // Gradiente de fondo
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 158/255, green: 36/255, blue: 29/255), location: 0.00),
                    .init(color: Color(red: 183/255, green: 42/255, blue: 32/255), location: 0.13),
                    .init(color: Color(red: 205/255, green: 47/255, blue: 36/255), location: 0.25),
                    .init(color: Color(red: 190/255, green: 44/255, blue: 33/255), location: 0.35),
                    .init(color: Color(red: 158/255, green: 36/255, blue: 29/255), location: 0.50),
                    .init(color: Color(red: 158/255, green: 36/255, blue: 29/255), location: 0.75),
                    .init(color: Color.white, location: 0.75),
                    .init(color: Color.white, location: 1.00)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // 1) Bloque de textos al top 5%
                Spacer(minLength: height * 0.05)
                    Text("Welcome to SpotiActions")
                        .font(.largeTitle).bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
               
                //  Spacer(minLength: height * 0.01)

                    Text("forget boring alarms")
                        .italic()
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 32)
                        .frame(maxWidth: .infinity)
                
                    Spacer(minLength: height * 0.03)
                    Text("When your playlist hits first thing in the\nmorning you’ll know you made the right choice")
                        .multilineTextAlignment(.center)
                        .font(.title3).bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .frame(maxWidth: .infinity)

                
                
                // 2) Viñetas al siguiente 17%
                Spacer(minLength: height * 0.10)
                Text("""
                • You can set your Spotify music as an alarm  
                • Create as many alarms as you want  
                • Make sure you have Spotify Premium 
                • This app installs shortcuts to playlists that can run even when your iPhone is locked
                """)
                .font(.headline).bold()
                .foregroundColor(.white.opacity(0.85))
                .frame(width: width * 0.9, alignment: .leading)

                // 3) Botones al 57% aprox.
                Spacer(minLength: height * 0.13)
                HStack(spacing: width * 0.1) {
                    LanguageButton(code: "ES", title: "Continuar") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            MedejasContinuar = true
                        }
                    }
                    .frame(width: width * 0.4)

                    LanguageButton(code: "EN", title: "Continue") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            MedejasContinuar = true
                        }
                    }
                    .frame(width: width * 0.4)
                }

                // 4) Toggle al ~80%
                Spacer(minLength: height * 0.15)
                Toggle(isOn: $noVolverAMostrarWelcome) {
                    Text("Don't show this again")
                        .foregroundColor(.black.opacity(0.70))
                        .font(.system(size: 16))
                }
                .toggleStyle(SwitchToggleStyle(tint: .orange))
                .padding()
                .background(Color.black.opacity(0.02))
                .cornerRadius(12)
                .frame(width: width * 0.9)

                Spacer()
            }
            .onAppear {
                MedejasContinuar = false
            }
        }
    }
}

// Helper view para los botones de idioma
struct LanguageButton: View {
    let code: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(red: 0.8, green: 0.1, blue: 0.1))
                        .frame(width: 36, height: 36)
                    Text(code)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color(red: 60/255, green: 20/255, blue: 20/255))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
        }
    }
}
