//
//  ContentView.swift
//  FloatingTabBar
//
//  Created by Adrian Suryo Abiyoga on 23/01/25.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var activeTab: TabModel = .home
    @State private var isTabBarHidden: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if #available(iOS 18, *) {
                    TabView(selection: $activeTab) {
                        Tab.init(value: .home) {
                            HomeView()
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                        Tab.init(value: .search) {
                            Text("Search")
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                        Tab.init(value: .notifications) {
                            Text("Notifications")
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                        Tab.init(value: .settings) {
                            Text("Settings")
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                } else {
                    TabView(selection: $activeTab) {
                        HomeView()
                            .tag(TabModel.home)
                            .overlay {
                                if !isTabBarHidden {
                                    HideTabBar {
                                        isTabBarHidden = true
                                    }
                                }
                            }
                        
                        Text("Search")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.primary.opacity(0.07))
                            .tag(TabModel.search)
                        
                        Text("Notifications")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.primary.opacity(0.07))
                            .tag(TabModel.notifications)
                        
                        Text("Settings")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.primary.opacity(0.07))
                            .tag(TabModel.settings)
                    }
                }
            }
            
            CustomTabBar(activeTab: $activeTab)
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            Text("Home")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Floating Tab Bar")
                .background(Color.primary.opacity(0.07))
                /// To Cover the floating tab bar
                .safeAreaPadding(.bottom, 60)
        }
    }
}

/// A Helper View to hide tab bar in iOS 17 Devices.
struct HideTabBar: UIViewRepresentable {
    init(result: @escaping () -> Void) {
        UITabBar.appearance().isHidden = true
        self.result = result
    }
    
    var result: () -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let tabController = view.tabController {
                UITabBar.appearance().isHidden = false
                tabController.tabBar.isHidden = true
                result()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {  }
}

extension UIView {
    var tabController: UITabBarController? {
        if let controller = sequence(first: self, next: {
            $0.next
        }).first(where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }
        
        return nil
    }
}

#Preview {
    ContentView()
}
