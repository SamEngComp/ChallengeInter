# Objetivo

Pensando nesse projeto a longo prazo caso fosse para frente, quis demonstrar meu conhecimento básico em clean architecture, serparando 
e isolando cada camada, pelo menos até onde meu conhecimento vai 😅.

O fluxo é semelhante do apresentado abaixo:
- Separei os casos de uso: FetchUsers, FetchComments, FetchPhotos, FetchAlbums e FetchPosts.
- Os Remotes implementam os casos de uso e se conectam com AlamofireAdapter que por sua vez conecta com o Almofire
- A ideia é que o projeto não dependam do Alamofire e que cada camada seja separada uma da outra.
- Utilizei a ideia do MVP para camada de apresentação em que as UIViewControllers e UIViews fazem parte da view e todas 
as reposabilidades delas ficam com os presenters.

<img width="1743" alt="inter-clean" src="https://user-images.githubusercontent.com/54647194/131226447-5eb13cfc-1719-4afa-9d49-04c5ea8af21c.png">
