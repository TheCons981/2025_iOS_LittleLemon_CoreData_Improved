//
// DisplayDish.swift



import SwiftUI


struct DishDetailView: View {
    private var dish:MenuItemStruct
    
    init(_ dish:MenuItemStruct) {
        self.dish = dish
    }
    
    var body: some View {
        HStack{
            Text(dish.title)
                .padding([.top, .bottom], 7)
            
            Spacer()
            
            Text(dish.formatPrice())
                .monospaced()
                .font(.callout)
        }
        .contentShape(Rectangle())
    }
}

struct DishDetailView_Previews: PreviewProvider {
    //static let context = PersistenceController.shared.container.viewContext
    //let dish = Dish(context: context)
    static var previews: some View {
        DishDetailView(oneDish())
    }
    static func oneDish() -> MenuItemStruct {
        //let dish = Dish(context: context)
        let dish = MenuItemStruct(id: 1, title: "Hummus", price: "10", size: "Extra Large");
        //dish.title = "Hummus"
        //dish.price = "10"
        //dish.size = "Extra Large"
        return dish
    }
}

