import SwiftUI


struct SettingsView: View {
    var body: some View {
        NavigationStack{
            List {
                NavigationLink(destination: AboutView()){
                    Text("About")
                }
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .leading
            )
        }
    };
    
}

#Preview {
    SettingsView()
}
