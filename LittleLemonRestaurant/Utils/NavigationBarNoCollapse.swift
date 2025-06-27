//
//  NavigationBarNoCollapse.swift
//  LittleLemonRestaurant
//
//  Created by Andrea Consorti on 09/06/25.
//

import SwiftUI

struct NavigationBarNoCollapse: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let nav = controller.navigationController {
                // Disabilita il collapsing della navigation bar
                nav.navigationBar.prefersLargeTitles = true
                nav.navigationBar.sizeToFit()
                nav.hidesBarsOnSwipe = false
                nav.navigationBar.isTranslucent = false // evita il grigio
                nav.navigationBar.backgroundColor = .systemBackground
                if #available(iOS 15.0, *) {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor.systemBackground
                    nav.navigationBar.standardAppearance = appearance
                    nav.navigationBar.scrollEdgeAppearance = appearance
                }
            }
        }
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
