import SwiftUI
import UIKit

struct HeaderView: View {
    let W: CGFloat
    let H: CGFloat
    @Binding var isDarkMode: Bool
    var isShortcutMode: Binding<Bool>? = nil


    var title: String = NSLocalizedString("app_title", comment: "")
    var showBack: Bool = false
    var showGear: Bool = true
    let bgColors: [Color]
    var onBack: (() -> Void)? = nil
    var onShowOnboarding: (() -> Void)? = nil
    
    @State private var restoreMessage: String? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            bgColors.first?.ignoresSafeArea(edges: .top)
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 0)
                }

            VStack(spacing: 0) {
                // --- HStack HEADER ---
                HStack(alignment: .center) {
                    // IZQUIERDA — back + gear
                    HStack(spacing: 12) {
                        if showBack {
                            Button(action: { onBack?() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .medium))
                                    Text(NSLocalizedString("back", comment: ""))
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(8)
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(Color("ColorHeaderView"))
                        }

                        if showGear {
                            Menu {
                                Button(NSLocalizedString("support_url", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.myiosapps.org/support.html")!)
                                }

                                Button(NSLocalizedString("main_page", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.myiosapps.org/spotiactions.html")!)
                                }

                                Button(NSLocalizedString("suggest_song", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://patreon.com/gonzalomoscoso?utm_medium=unknown&utm_source=join_link&utm_campaign=creatorshare_creator&utm_content=copyLink")!)
                                }

                                Divider()

                                Button(NSLocalizedString("get_welcomeback", comment: "")) {
                                    abrirLinkMenu(URL(string: "https://www.icloud.com/shortcuts/e26c47aad12d40f4965c98a693bb6bb3")!)
                                }
                            } label: {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("Color1reverse"))
                                    .padding(10)
                            }
                        }
                    }
                    .frame(width: 80, alignment: .leading)

                    Spacer()
                    
                    // CENTRO — título
                    Text(title)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("ColorNaranja"))
                        .multilineTextAlignment(.center)
                    
                    Spacer()

                    // DERECHA — toggle play/install mode
                    if let isShortcutMode {
                        Button(action: {
                            isShortcutMode.wrappedValue.toggle()
                            UserDefaults.standard.set(
                                isShortcutMode.wrappedValue,
                                forKey: "ShortcutPlayModeEnabled"
                            )
                        }) {
                            Image(systemName: isShortcutMode.wrappedValue
                                  ? "play.circle.fill"
                                  : "square.and.arrow.down.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("Color1reverse"))
                                .padding(10)
                        }
                        .frame(width: 80, alignment: .trailing)
                    } else {
                        Spacer()
                            .frame(width: 80)
                    }

                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
    }
}
