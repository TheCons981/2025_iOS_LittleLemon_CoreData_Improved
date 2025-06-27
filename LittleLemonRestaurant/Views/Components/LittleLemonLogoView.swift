import SwiftUI

struct LittleLemonLogoView: View {
    var body: some View {
        Image("littleLemon")
            .resizable()
            .scaledToFit()
            //.frame(width: 120)
            .padding([.leading, .trailing], 70)
            .padding([.top, .bottom], 8)
    }
}

struct LittleLemonLogoView_Previews: PreviewProvider {
    static var previews: some View {
        LittleLemonLogoView()
    }
}


