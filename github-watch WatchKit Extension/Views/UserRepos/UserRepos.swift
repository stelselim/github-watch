import SwiftUI

struct UserRepos: View {
    @EnvironmentObject var repoInteractor: RealRepoInteractor
    let username: String
    @State var loading = false
    @State var repos: [Repo] = []
    @State var canFetchMore = true

    init(username: String) {
        self.username = username
        
    }
    
    func fetchUserRepos(){
        loading = true
        repoInteractor.requestReposOfUser(username: username, completed: { myRepos in
            if let myRepos = myRepos {
                DispatchQueue.main.async {
                    repos += myRepos
                    if myRepos.isEmpty {
                        canFetchMore = false
                    }
                    loading = false
                }
            } else {
                DispatchQueue.main.async {
                    loading = false
                }
            }
        })
    }

    var body: some View {
        ScrollView {
            Text("\(username)").bold()
            Divider().padding(.vertical, 4)
            ForEach(repos, id: \.id) { repo in
                NavigationLink(destination: RepoView(repo: repo)) {
                    MiniRepoView(repo: repo)
                }
            }
            if repos.count > 0 && canFetchMore{
                BottomNavRow(buttonClick: fetchUserRepos, loading: $loading)
            }
        }
        .padding(.horizontal, 2)
        .onAppear(perform: {
            repoInteractor.resetPage()
            fetchUserRepos()
        })
    }
}

struct UserRepos_Previews: PreviewProvider {
    static var previews: some View {
        UserRepos(username: "iberatkaya")
    }
}
