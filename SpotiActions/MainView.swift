
import SwiftUI
import AVKit // Necesario para reproducir el video

// MARK: - 1. Modelo de Datos
struct ShortcutItem: Identifiable {
    let id = UUID()
    let order: Int
    let name: String
    let imageAsset: String
    let tipodelista: Bool
}

// MARK: - Componente de Botón Rectangular (Especificaciones Gonzalo)


struct ActionRectangularButton: View {
    let title: String?
    let subTitle: String?
    let systemImage: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Base Glass
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.black.opacity(0.6))
                    )
                
                // Brillo superior
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.15), .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                
                VStack(spacing: 2) {
                    if let title = title {
                        Text(title)
                            .font(.system(size: 9, weight: .bold))
                            .textCase(.uppercase)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    if let subTitle = subTitle {
                        Text(subTitle)
                            .font(.system(size: 20, weight: .light, design: .monospaced))
                            .foregroundColor(Color("ColorNaranja"))
                    }
                    
                    if let systemImage = systemImage {
                        Image(systemName: systemImage)
                            .font(.system(size: systemImage == "questionmark.app.fill" ? 26 : 22, weight: .medium))
                            /* Aplicación del gradiente naranja a rojo solicitado */
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("ColorNaranja"), .red],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    
                    
                }
            }
            .frame(width: 90, height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.6), .white.opacity(0.1), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
            )
            .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(GlassPressedStyle())
    }
}

struct GlassPressedStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .brightness(configuration.isPressed ? 0.05 : 0)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: configuration.isPressed)
    }
}




// MARK: - 2. Vista Principal (Versión Corregida)
struct MainView: View {
    @Binding var activeTab: Int
    @Binding var isDarkMode: Bool
    
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var navigationState: NavigationState
    @Environment(\.dismiss) var dismiss
    
    @State private var activeIndex: Int? = 2 // El '?' es la clave para que sea Hashable opcional
    
    @State private var showHowToSetup: Bool = false
    @State private var selectedTutorialItem: ShortcutItem? = nil
    @State private var isShortcutMode: Bool = UserDefaults.standard.bool(forKey: "ShortcutPlayModeEnabled")
    @State private var showTip: Bool = false
    @State private var lastMessage: String = ""
    
    let allShortcuts: [ShortcutItem] = [
        ShortcutItem(order: 1, name: "Pop Rising", imageAsset: "cover01", tipodelista: false),
        ShortcutItem(order: 2, name: "Your All-Time Top Songs", imageAsset: "cover02", tipodelista: true),
        ShortcutItem(order: 3, name: "My Liked Songs", imageAsset: "cover03", tipodelista: true),
        ShortcutItem(order: 4, name: "Wake Up Happy", imageAsset: "cover04", tipodelista: false),
        ShortcutItem(order: 5, name: "Discover Weekly", imageAsset: "cover05", tipodelista: true),
        ShortcutItem(order: 6, name: "Crying myself to sleep", imageAsset: "cover06", tipodelista: false),
        ShortcutItem(order: 7, name: "Songs to Sing in the Shower", imageAsset: "cover07", tipodelista: true),
        ShortcutItem(order: 8, name: "Release Radar", imageAsset: "cover08", tipodelista: true),
        ShortcutItem(order: 9, name: "Daily Mix Two", imageAsset: "cover09", tipodelista: true),
        ShortcutItem(order: 10, name: "Indie Mix", imageAsset: "cover10", tipodelista: true),
        ShortcutItem(order: 11, name: "Hits of the 80's", imageAsset: "cover11", tipodelista: false),
        ShortcutItem(order: 12, name: "All Out 2010s", imageAsset: "cover12", tipodelista: false),
        ShortcutItem(order: 13, name: "Happy Hits", imageAsset: "cover13", tipodelista: true),
        ShortcutItem(order: 14, name: "Classic Road Trip", imageAsset: "cover14", tipodelista: false),
        ShortcutItem(order: 15, name: "Energy Booster Rock", imageAsset: "cover15", tipodelista: false),
        ShortcutItem(order: 16, name: "Monday Motivation", imageAsset: "cover16", tipodelista: false),
        ShortcutItem(order: 17, name: "Good Vibes Friday", imageAsset: "cover17", tipodelista: false),
        ShortcutItem(order: 18, name: "Neo Soul and RnB", imageAsset: "cover18", tipodelista: false),
        ShortcutItem(order: 19, name: "Old School Coldplay", imageAsset: "cover19", tipodelista: false),
        ShortcutItem(order: 20, name: "This is Coldplay", imageAsset: "cover20", tipodelista: false),
        ShortcutItem(order: 21, name: "Taylor Swift's Radio", imageAsset: "cover21", tipodelista: false),
        ShortcutItem(order: 22, name: "This Is Taylor Swift", imageAsset: "cover22", tipodelista: false),
        ShortcutItem(order: 23, name: "This Is The Weeknd", imageAsset: "cover23", tipodelista: false),
        ShortcutItem(order: 24, name: "Your Top Songs 2024", imageAsset: "cover24", tipodelista: true),
        ShortcutItem(order: 25, name: "Piano - Wake Up Gently", imageAsset: "cover25", tipodelista: false),
        ShortcutItem(order: 26, name: "On Repeat", imageAsset: "cover26", tipodelista: true),
        ShortcutItem(order: 27, name: "Today's Top Hits", imageAsset: "cover27", tipodelista: false),
        ShortcutItem(order: 28, name: "Top 100 most Streaming (updated)", imageAsset: "cover28", tipodelista: false),
        ShortcutItem(order: 29, name: "LDS Hymns violin-piano", imageAsset: "cover29", tipodelista: false),
        ShortcutItem(order: 30, name: "Magnetismo", imageAsset: "cover30", tipodelista: false),
        ShortcutItem(order: 31, name: "This Is Luis Miguel", imageAsset: "cover31", tipodelista: false),
        ShortcutItem(order: 32, name: "This Is Lofi Girl", imageAsset: "cover32", tipodelista: false),
        ShortcutItem(order: 33, name: "TikTok Viral 2026", imageAsset: "cover33", tipodelista: false),
        ShortcutItem(order: 34, name: "Top 50: México", imageAsset: "cover34", tipodelista: false),
        ShortcutItem(order: 35, name: "Top: Alemania", imageAsset: "cover35", tipodelista: false),
        ShortcutItem(order: 36, name: "Top 50: Japón", imageAsset: "cover36", tipodelista: false),
        ShortcutItem(order: 37, name: "Top 50: Argentina", imageAsset: "cover37", tipodelista: false),
        ShortcutItem(order: 38, name: "AC⚡️DC Curated Playlist", imageAsset: "cover38", tipodelista: false),
        ShortcutItem(order: 39, name: "This Is AC/DC", imageAsset: "cover39", tipodelista: false),
        ShortcutItem(order: 40, name: "Tribal Electrónica", imageAsset: "cover40", tipodelista: false),
        ShortcutItem(order: 41, name: "Rap Caviar", imageAsset: "cover41", tipodelista: false)
    ]
    
    var body: some View {
        ZStack {
            Color("ColorFondo").ignoresSafeArea()
            
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    // --- AJUSTE 1: HEADER CON MARGEN PARA LA ISLA ---
                    headerSection
                        .padding(.top, 15)

                    // --- ESPACIO ENTRE HEADER Y COVERFLOW ---
                    Spacer().frame(height: 100)
                    
                    // --- COVER FLOW CORREGIDO PARA XCODE (iOS 17+) ---
                    VStack(spacing: 0) {
                        GeometryReader { geometry in
                            let screenWidth = geometry.size.width
                            let coverWidth: CGFloat = 220
                            let horizontalPadding = (screenWidth - coverWidth) / 2
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 3) {   // espacio entre covers
                                    ForEach(allShortcuts) { item in
                                        VStack(spacing: 0) {
                                            ZStack {
                                                Image(item.imageAsset)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: coverWidth, height: 220)
                                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                                    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 8)

                                                // Comparación segura con el opcional
                                                if activeIndex == item.order {
                                                    Color.clear
                                                        .contentShape(Rectangle())
                                                        .frame(width: coverWidth, height: 220)
                                                        .onTapGesture { ejecutarShortcut() }
                                                }
                                            }
                                            
                                            // Reflejo (se mantiene igual)
                                            Image(item.imageAsset)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: coverWidth, height: 60)
                                                .rotationEffect(.degrees(180))
                                                .scaleEffect(x: -1, y: 1)
                                                .opacity(0.5)
                                                .mask(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [.black.opacity(0.5), .clear]),
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                )
                                                .offset(y: 2)
                                        }
                                        .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                            content
                                                .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                                                .rotation3DEffect(
                                                    Angle(degrees: phase.value * -20),
                                                    axis: (x: 0, y: 1, z: 0)
                                                )
                                                .opacity(phase.isIdentity ? 1.0 : 0.6)
                                        }
                                        .id(item.order) // Xcode usa este ID para el posicionamiento
                                    }
                                }
                                .padding(.horizontal, horizontalPadding)
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            // CORRECCIÓN: Ahora el Binding coincide con el tipo esperado
                            .scrollPosition(id: $activeIndex)
                            .defaultScrollAnchor(.center)
                        }
                        .frame(height: 360)
                        .onAppear {
                            // Simulación de Swipe: Iniciamos en el 1 y movemos al 2
                            activeIndex = 1
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                activeIndex = 2
                            }
                        }
                    }
                    
                    // --- ESPACIO PARA DESPLAZAR TODO HACIA ABAJO ---
                    Spacer().frame(height: 50)
                    
                    // --- SECCIÓN DE TÍTULO Y BOTONES ---
                    if let currentItem = allShortcuts.first(where: { $0.order == activeIndex }) {
                        VStack(spacing: 35) {
                            
                            // --- AJUSTE: TÍTULO Y SUBTÍTULO CONDICIONAL ---
                            // --- TÍTULO Y SUBTÍTULO CON ESPACIO RESERVADO ---
                            VStack(spacing: 4) {
                                Text(currentItem.name.uppercased())
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(Color("Color1reverse"))
                                    .mask(
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: .black.opacity(0.3), location: 0.0),
                                                .init(color: .black.opacity(0.6), location: 0.5),
                                                .init(color: .black.opacity(0.3), location: 1.0)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                // Usamos el estado de tipodelista para controlar la opacidad
                                // Esto mantiene el espacio vertical (10 puntos de fuente) siempre ocupado
                                Text(NSLocalizedString("TIPOplaylist", comment: ""))
                                    .font(.system(size: 10, weight: .regular))
                                    //.foregroundColor(Color("Color1reverse"))
                                    .foregroundColor(Color("ColorNaranja"))
                                    .opacity(currentItem.tipodelista ? 1.0 : 0.0) // Invisible pero presente
                            }
                            
                            VStack(spacing: 25) {
                                HStack(spacing: 25) {
                                    ActionRectangularButton(title: "PLAYLIST", subTitle: String(format: "%03d", currentItem.order), systemImage: nil) { }
                                    
                                    ActionRectangularButton(title: nil, subTitle: nil, systemImage: "questionmark.app.fill") {
                                        selectedTutorialItem = currentItem
                                    }
                                    
                                    ActionRectangularButton(title: nil, subTitle: nil, systemImage: "headphones") {
                                        ejecutarShortcut()
                                    }
                                }
                                
                                Spacer().frame(height: 5)
                                
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .white.opacity(0.0), location: 0.0),
                                        .init(color: .white.opacity(0.1), location: 0.25),
                                        .init(color: .white.opacity(0.2), location: 0.5),
                                        .init(color: .white.opacity(0.1), location: 0.75),
                                        .init(color: .white.opacity(0.0), location: 1.0)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 1.2)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if showTip { toastOverlay }
                }
            }
        }
        .sheet(item: $selectedTutorialItem) { item in
            AutomationTutorialView(item: item)
        }
        .fullScreenCover(isPresented: $showHowToSetup) {
            howtoSETUP(
                activeTab: $activeTab,
                isDarkMode: $isDarkMode,
                onBack: { showHowToSetup = false }
            )
            .environmentObject(storeManager)
        }
        .onAppear {
            saveVersionLocally()
        }
    }
    
    
    
    // MARK: - Funciones
    
    func saveVersionLocally() {
        let suiteName = "group.com.gzalomoscoso.spotiactions"
        
        // Intentamos obtener la versión comercial (ej. 1.2.3)
        // Si no existe, usamos el número de compilación (build)
        // Si falla todo, queda en 0.0 para alertarnos
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                      ?? Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                      ?? "0.0"
        
        if let defaults = UserDefaults(suiteName: suiteName) {
            defaults.set(version, forKey: "current_app_version")
            defaults.synchronize()
            print("✅ Versión Real Detectada y Guardada: \(version)")
        } else {
            print("❌ Error de Configuración: App Group no encontrado")
        }
    }
    
    private func ejecutarShortcut() {
        // Desempaquetado seguro: si activeIndex es nil, no continúa.
        guard let index = activeIndex else { return }
        
        // Usamos 'index' que ya es de tipo Int (no opcional)
        UIPasteboard.general.string = String(format: "%03d", index)
        
        let shortcutName = "SpotiActions"
        if let encodedName = shortcutName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "shortcuts://run-shortcut?name=\(encodedName)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Subvistas

    // --- HEADER AJUSTADO PARA PEGARSE ARRIBA ---
       private var headerSection: some View {
           HStack(alignment: .center) {
               Menu {
 
                   Button(NSLocalizedString("support_url", comment: "")) { abrirLinkMenu(URL(string: "https://www.myiosapps.org/support.html")!) }

                   Button(NSLocalizedString("main_page", comment: "")) { abrirLinkMenu(URL(string: "https://www.myiosapps.org/SpotiActions.html")!) }

                   Button(NSLocalizedString("Tutorials", comment: "")) { showHowToSetup = true }

               } label: {
                   VStack(spacing: 0) {
                       Image(systemName: "gearshape")
                           .font(.system(size: 22))
                           .foregroundColor(Color("ColorHeaderView"))
                           .frame(width: 44, height: 30)
                       Text(NSLocalizedString("Menu", comment: "Settings"))
                           .font(.system(size: 10, weight: .bold))
                           .foregroundColor(Color("ColorHeaderView"))
                   }
                   .frame(width: 60)
               }
               Spacer()
               Text("SpotiActions")
                   .font(.system(size: 30, weight: .bold))
                   .foregroundStyle(LinearGradient(colors: [Color("ColorNaranja"), .red], startPoint: .top, endPoint: .bottom))
               Spacer()
               Button(action: { navigationState.currentView = .welcome }) {
                   VStack(spacing: 0) {
                       Image(systemName: "repeat.circle.fill")
                           .font(.system(size: 22))
                           .foregroundColor(Color("ColorHeaderView"))
                           .frame(width: 44, height: 30)
                       Text(NSLocalizedString("OnBoarding", comment: "replay"))
                           .font(.system(size: 10, weight: .bold))
                           .foregroundColor(Color("ColorHeaderView"))
                   }
                   .frame(width: 60)
               }
           }
           .padding(.horizontal)
           .padding(.top, 0) // ⬅️ Eliminado padding para pegar a la parte superior
       }


    func abrirLinkMenu(_ url: URL) { UIApplication.shared.open(url) }
    
    private var toastOverlay: some View {
        VStack {
            Spacer()
            Text(lastMessage)
                .font(.system(size: 14, weight: .bold))
                .padding()
                .background(Capsule().fill(Color.black.opacity(0.8)))
                .foregroundColor(.yellow)
        }
        .padding(.bottom, 30)
    }
}




// --- ACTUALIZACIÓN DE LABELCAPSULE PARA SOPORTAR COLORES DINÁMICOS ---
struct LabelCapsule: View {
    let text: String
    var icon: String? = nil
    let bgColor: Color
    let txtColor: Color
    
    var body: some View {
        HStack(spacing: 3) {
            if let icon = icon {
                Image(systemName: icon).font(.system(size: 9))
            }
            Text(text)
        }
        .font(.system(size: 11, weight: .medium))
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(bgColor)
        .foregroundColor(txtColor)
        .clipShape(Capsule())
    }
}


// Auxiliares de dibujo para mantener el código limpio
struct ActionRow<Content: View>: View {
    let icon: String?
    let iconColor: Color
    var isShortcut: Bool = false
    let content: Content
    
    init(icon: String?, iconColor: Color, isShortcut: Bool = false, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.iconColor = iconColor
        self.isShortcut = isShortcut
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 8) {
            if isShortcut {
                Image("ShortcutIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .cornerRadius(6)
            } else if let icon = icon {
                ZStack {
                    RoundedRectangle(cornerRadius: 6).fill(iconColor)
                    Image(systemName: icon).foregroundColor(.white).font(.system(size: 10, weight: .bold))
                }.frame(width: 20, height: 20)
            }
            
            HStack(spacing: 4) {
                content
            }
            .font(.system(size: 10, weight: .medium))
            // ⬇️ CAMBIA EL .system(size: 14) POR UNO MÁS PEQUEÑO (ej: 10)
        }
    }
}





import SwiftUI
import AVKit

struct AutomationTutorialView: View {
    let item: ShortcutItem
    
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "videosetup", withExtension: "mov")!)
    @State private var isVideoLoading = true
    @State private var isVideoPlaying = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        VStack(spacing: 20) {
            // --- HEADER ---
            HStack {
                Button(action: {
                    player.pause()
                    dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("BACK")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("ColorNaranja"))
                }
                Spacer()
                Text(NSLocalizedString("How to setup your automation", comment: ""))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
                // Espaciador para equilibrar el botón BACK
                Color.clear.frame(width: 60, height: 10)
            }
            .padding(.horizontal)
            .padding(.top, 10)

            // --- 1. CARD DE PREVIEW (Ajustado a la Imagen 2) ---
            ShortcutPreviewCard(playlistNumber: item.order)
                .padding(.horizontal)

            // --- CONTENEDOR DE VIDEO OPTIMIZADO (886x1490) ---
            ZStack {
                VideoPlayer(player: player)
                    .onAppear {
                        // 1. Configurar el loop infinito
                        player.actionAtItemEnd = .none

                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: .main
                        ) { _ in
                            player.seek(to: .zero)

                            if isVideoPlaying {
                                player.play()
                            }
                        }

                        // 2. NO reproducir automáticamente
                        player.pause()

                        // 3. Gestión del estado de carga
                        // Usamos un pequeño delay para que la transición visual sea suave
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isVideoLoading = false
                        }
                    }

                // Capa negra antes de reproducir
                if !isVideoPlaying {
                    Color.black.opacity(0.5)

                    Text(NSLocalizedString("Show me with a video instead", comment: ""))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .onTapGesture {
                            isVideoPlaying = true
                            player.play()
                        }
                }

                // Spinner de carga
                if isVideoLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .scaleEffect(1.5)
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(886/1490, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 40)

            Spacer()

            // --- 3. BOTÓN ÚNICO INFERIOR ---
            Button(action: {
                if let url = URL(string: "shortcuts://automations") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text(NSLocalizedString("Go to Automations", comment: ""))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("ColorNaranja"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.black)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 20)
        }
        .background(Color("ColorFondo")) // Asegúrate que este color sea casi negro
        .onDisappear {
            player.pause()
        }
    }
}

struct ShortcutPreviewCard: View {
    let playlistNumber: Int
    
    // Colores específicos de la interfaz de iOS Shortcuts
    private let shortcutsBlue = Color(red: 0.24, green: 0.62, blue: 0.93)
    private let capsuleBlueBackground = Color(red: 0.24, green: 0.62, blue: 0.93).opacity(0.12)
    private let shortcutsGray = Color(red: 0.55, green: 0.55, blue: 0.57)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Fila 1: Set Media Volume to 50%
            HStack(spacing: 8) {
                Image(systemName: "speaker.wave.3.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .frame(width: 22, height: 22)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                Text("Set").foregroundColor(.black)
                
                HStack(spacing: 4) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 10))
                    Text("Media")
                }
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(capsuleBlueBackground)
                .foregroundColor(shortcutsBlue)
                .clipShape(Capsule())
                
                Text("volume to").foregroundColor(.black)
                
                Text("50%")
                    .font(.system(size: 13, weight: .medium))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(capsuleBlueBackground)
                    .foregroundColor(shortcutsBlue)
                    .clipShape(Capsule())
            }
            
            // Fila 2: El número de la playlist
            HStack(spacing: 8) {
                Image(systemName: "number")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 22, height: 22)
                    .background(shortcutsGray)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                Text("\(playlistNumber)")
                    .font(.system(size: 13, weight: .medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(capsuleBlueBackground)
                    .foregroundColor(shortcutsBlue)
                    .clipShape(Capsule())
            }
            
            // Fila 3: Run SpotiActions (Usando ShortcutIcon)
            HStack(spacing: 8) {
                // Reemplazo solicitado: Uso del asset ShortcutIcon
                Image("ShortcutIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                
                Text("Run").foregroundColor(.black)
                
                HStack(spacing: 5) {
                    Image(systemName: "headphones")
                        .font(.system(size: 13, weight: .medium))
                    Text("SpotiActions")
                }
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.12))
                .foregroundColor(.orange)
                .clipShape(Capsule())
                
                Image(systemName: "chevron.right.circle")
                    .font(.system(size: 16))
                    .foregroundColor(shortcutsBlue.opacity(0.6))
            }
        }
        .font(.system(size: 15)) // Tamaño de fuente base para los "Set" y "Run"
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(28) // Bordes amplios como en la imagen
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}
