import SwiftUI


struct SettingsView: View {
    var body: some View {
        NavigationStack{
            List {
                NavigationLink(destination: AboutScreen()){
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
