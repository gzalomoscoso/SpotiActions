import SwiftUI
import AVKit // Necesario para reproducir el video

// MARK: - 1. Modelo de Datos
struct ShortcutItem: Identifiable {
    let id = UUID()
    let order: Int
    let name: String
    let imageAsset: String
}

// MARK: - Componente de Botón Rectangular (Especificaciones Gonzalo)
struct ActionRectangularButton: View {
    let title: String?
    let subTitle: String?
    let systemImage: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                if let title = title {
                    Text(title)
                        .font(.system(size: 10, weight: .bold))
                }
                
                if let subTitle = subTitle {
                    Text(subTitle)
                        .font(.system(size: 24, weight: .light, design: .monospaced))
                        .foregroundColor(.orange  )
                }
                
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 24, weight: .bold))
                }
            }
            .foregroundColor(.white)
            .frame(width: 85, height: 60)
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

// MARK: - 2. Vista Principal
struct MainView: View {
    @Binding var activeTab: Int
    @Binding var isDarkMode: Bool
    
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var navigationState: NavigationState
    @Environment(\.dismiss) var dismiss // Para cerrar el modal actual
    
    @Binding var activeIndex: Int
    
    @State private var showHowToSetup: Bool = false
    @State private var selectedTutorialItem: ShortcutItem? = nil
    @State private var isShortcutMode: Bool = UserDefaults.standard.bool(forKey: "ShortcutPlayModeEnabled")
    @State private var showTip: Bool = false
    @State private var lastMessage: String = ""
    
    let allShortcuts: [ShortcutItem] = [
        ShortcutItem(order: 1, name: "Pop Rising", imageAsset: "cover01"),
        ShortcutItem(order: 2, name: "Liked Songs", imageAsset: "cover02"),
        ShortcutItem(order: 3, name: "Wake Up Gentle", imageAsset: "cover03"),
        ShortcutItem(order: 4, name: "Wake Up Happy", imageAsset: "cover04"),
        ShortcutItem(order: 5, name: "Top 100 Spotify", imageAsset: "cover05"),
        ShortcutItem(order: 6, name: "Crying myself to sleep", imageAsset: "cover06"),
        ShortcutItem(order: 7, name: "Modern 90s Vibes", imageAsset: "cover07"),
        ShortcutItem(order: 8, name: "ROCK is still amazing", imageAsset: "cover08"),
        ShortcutItem(order: 9, name: "Daily Mix 2", imageAsset: "cover09"),
        ShortcutItem(order: 10, name: "Intro to female indie rock", imageAsset: "cover10"),
        ShortcutItem(order: 11, name: "Irish 80's Hits", imageAsset: "cover11"),
        ShortcutItem(order: 12, name: "All Out 2010s", imageAsset: "cover12"),
        ShortcutItem(order: 13, name: "Happy Beats", imageAsset: "cover13"),
        ShortcutItem(order: 14, name: "Classic Road Trip", imageAsset: "cover14"),
        ShortcutItem(order: 15, name: "Energy Booster Rock", imageAsset: "cover15"),
        ShortcutItem(order: 16, name: "Monday Motivation", imageAsset: "cover16"),
        ShortcutItem(order: 17, name: "Good Vibes Friday Mix", imageAsset: "cover17"),
        ShortcutItem(order: 18, name: "Neo Soul and RnB", imageAsset: "cover18"),
        ShortcutItem(order: 19, name: "Old school Coldplay", imageAsset: "cover19"),
        ShortcutItem(order: 20, name: "This is Coldplay", imageAsset: "cover20"),
        ShortcutItem(order: 21, name: "Radio de Taylor Swift", imageAsset: "cover21"),
        ShortcutItem(order: 22, name: "This Is Taylor Swift", imageAsset: "cover22"),
        ShortcutItem(order: 23, name: "This Is The Weeknd", imageAsset: "cover23"),
        ShortcutItem(order: 24, name: "Today's Top Hits", imageAsset: "cover24"),
        ShortcutItem(order: 25, name: "RapCaviar", imageAsset: "cover25"),
        ShortcutItem(order: 26, name: "op de fiets", imageAsset: "cover26"),
        ShortcutItem(order: 27, name: "Heavy Lyrics Light Vibes", imageAsset: "cover27"),
        ShortcutItem(order: 28, name: "Fade", imageAsset: "cover28"),
        ShortcutItem(order: 29, name: "LDS Hymns violin/piano", imageAsset: "cover29"),
        ShortcutItem(order: 30, name: "Magnetismo", imageAsset: "cover30"),
        ShortcutItem(order: 31, name: "This Is Luis Miguel", imageAsset: "cover31"),
        ShortcutItem(order: 32, name: "This Is Lofi Girl", imageAsset: "cover32"),
        ShortcutItem(order: 33, name: "TikTok Viral 2026", imageAsset: "cover33"),
        ShortcutItem(order: 34, name: "Top 50: México", imageAsset: "cover34"),
        ShortcutItem(order: 35, name: "Top: Alemania", imageAsset: "cover35"),
        ShortcutItem(order: 36, name: "Top 50: Japón", imageAsset: "cover36"),
        ShortcutItem(order: 37, name: "Top 50: Argentina", imageAsset: "cover37"),
        ShortcutItem(order: 38, name: "AC⚡️DC", imageAsset: "cover38"),
        ShortcutItem(order: 39, name: "This Is AC/DC", imageAsset: "cover39"),
        ShortcutItem(order: 40, name: "Tribal Electrónica", imageAsset: "cover40")
    ]
    
    var body: some View {
            ZStack {
                Color("ColorFondo").ignoresSafeArea()
                
                // ScrollViewReader es imprescindible para mover el scroll desde afuera
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        headerSection
                        
                        Spacer()
                        
                        // --- INDICADOR DE PUNTITOS (70% ANCHO) ---
                        //GeometryReader { geo in
                            //HStack(spacing: 4) {
                                //ForEach(allShortcuts.indices, id: \.self) { index in
                                    //Circle()
                                    //.fill(allShortcuts[index].order == activeIndex ? //Color.orange : Color.white.opacity(0.2))
                                    //.frame(width: allShortcuts[index].order == activeIndex ? //7 : 3.5)
                                    //  .contentShape(Rectangle()) // Facilita el toque
                                    //.onTapGesture {
                                            //let target = allShortcuts[index].order
                                            // 1. Actualizamos el índice (mueve el punto)
                                            //withAnimation(.spring(response: 0.4, //dampingFraction: 0.8)) {
                                                //activeIndex = target
                                                //}
                                            // 2. Forzamos el scroll (mueve el coverflow)
                                            //withAnimation(.spring()) {
                                                //proxy.scrollTo(target, anchor: .center)
                                                //}
                                            //  }
                                    //}
                                //}
                            //.frame(width: geo.size.width * 0.7)
                            //.frame(maxWidth: .infinity)
                            //}
                        //.frame(height: 20)
                        //.padding(.top, 20)
                        
                        // --- COVER FLOW ---
                        VStack(spacing: 0) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 1) {
                                    ForEach(allShortcuts) { item in
                                        VStack(spacing: 0) {
                                            // Imagen Principal
                                            Image(item.imageAsset)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 220, height: 220)
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 8)
                                            
                                            // Reflejo
                                            Image(item.imageAsset)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 220, height: 100)
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
                                        .id(item.order) // Vinculado a activeIndex
                                    }
                                }
                                .padding(.horizontal, 85)
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            // Este binding actualiza el punto cuando mueves el coverflow
                            .scrollPosition(id: .init(get: { activeIndex }, set: { activeIndex = $0 ?? 1 }))
                            .frame(height: 420)
                            .padding(.top, 10)
                        }
                        
                        Spacer()
                        
                        // --- BOTONES ---
                        if let currentItem = allShortcuts.first(where: { $0.order == activeIndex }) {
                            VStack(spacing: 25) {
                                Text(currentItem.name)
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(Color("Color1reverse"))
                                    .opacity(0.6)
                                
                                HStack(spacing: 25) {
                                    ActionRectangularButton(title: "PLAYLIST", subTitle: String(format: "%03d", currentItem.order), systemImage: nil) {
                                        // Acción Playlist
                                    }
                                    
                                    ActionRectangularButton(title: NSLocalizedString("SETUPTHISPLAYLIST", comment: ""), subTitle: "?", systemImage: nil) {
                                        selectedTutorialItem = currentItem
                                    }
                                    
                                    ActionRectangularButton(title: nil, subTitle: nil, systemImage: "headphones") {
                                        UIPasteboard.general.string = String(format: "%03d", activeIndex)
                                        let shortcutName = "SpotiActions"
                                        if let encodedName = shortcutName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                           let url = URL(string: "shortcuts://run-shortcut?name=\(encodedName)") {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                    }
                                }
                                
                                Rectangle()
                                    .fill(LinearGradient(colors: [.clear, .white.opacity(0.2), .clear], startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 320, height: 1)
                                    .padding(.top, 10)
                            }
                            .padding(.bottom, 40)
                        }
                        
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
        }
    
    
    
    
    // MARK: - Subvistas
    private var headerSection: some View {
        HStack(alignment: .center) {
            Menu {
                Button(NSLocalizedString("support_url", comment: "")) { abrirLinkMenu(URL(string: "https://www.myiosapps.org/support.html")!) }
                Button(NSLocalizedString("main_page", comment: "")) { abrirLinkMenu(URL(string: "https://www.myiosapps.org/spotiactions.html")!) }
                Button(NSLocalizedString("Tutorials", comment: "")) { showHowToSetup = true }
                Divider()
                Button(NSLocalizedString("get_welcomeback", comment: "")) { abrirLinkMenu(URL(string: "https://www.icloud.com/shortcuts/e26c47aad12d40f4965c98a693bb6bb3")!) }
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 22))
                        .foregroundColor(Color("Color1reverse"))
                        .frame(width: 44, height: 30)
                    Text(NSLocalizedString("Menu", comment: "Settings"))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color("Color1reverse"))
                }
                .frame(width: 60)
            }
            Spacer()
            Text("SpotiActions")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom))
            Spacer()
            Button(action: { navigationState.currentView = .welcome }) {
                VStack(spacing: 0) {
                    Image(systemName: "repeat.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color("Color1reverse"))
                        .frame(width: 44, height: 30)
                    Text(NSLocalizedString("OnBoarding", comment: "replay"))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color("Color1reverse"))
                }
                .frame(width: 60)
            }
        }
        .padding(.horizontal)
        .padding(.top, 5)
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







import SwiftUI
import AVKit

struct AutomationTutorialView: View {
    let item: ShortcutItem
    
    // Player persistente durante el ciclo de vida de la vista
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "videosetup", withExtension: "mov")!)
    @State private var isVideoLoading = true // Estado para el indicador de carga
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    player.pause() // Detener audio al salir
                    dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("BACK")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.orange)
                }
                Spacer()
                Text(NSLocalizedString("How to setup your automation", comment: ""))
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color("Color1reverse"))
                Spacer()
                Color.clear.frame(width: 50, height: 10)
            }
            .padding()
            .background(Color("ColorFondo"))

            Spacer()

            // Contenedor de Video con Indicador de Carga
            ZStack {
                VideoPlayer(player: player)
                    .onAppear {
                        // Configurar Loop
                        player.actionAtItemEnd = .none
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: .main
                        ) { _ in
                            player.seek(to: .zero)
                            player.play()
                        }
                        
                        // Detectar cuando el video está listo para reproducir
                        player.currentItem?.addObserver(NSObject(), forKeyPath: "status", options: [.new], context: nil)
                        
                        player.play()
                        
                        // Simulamos o detectamos carga rápida
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isVideoLoading = false
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(880/1772, contentMode: .fit)
                    .cornerRadius(12)
                
                // Spinner de carga
                if isVideoLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .scaleEffect(1.5)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Botones inferiores
            HStack(spacing: 15) {
                // BOTÓN IZQUIERDO
                Button(action: {
                    player.pause() // Detener audio
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.spring()) {
                            navigationState.currentView = .howToSetup
                        }
                    }
                }) {
                    Text("Playlist\n#\(item.order)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color("ColorFondo"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }

                // BOTÓN DERECHO
                Button(action: {
                    if let url = URL(string: "shortcuts://automations") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text(NSLocalizedString("BotonDER", comment: ""))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
        }
        .background(Color("ColorFondo"))
        // CRÍTICO: Detener video cuando la vista desaparece por completo
        .onDisappear {
            player.pause()
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
    }
}
