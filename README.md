# Objetivo

Pensando nesse projeto como curto prazo e com pouca chance de continuar, optei por fazer uma serpação mínima 
das camadas, utilizei o MVP + Coordinator para isso 😅.

O fluxo é semelhante do apresentado abaixo:
- Separei alguns protocolos Service para separar os Presenters das requisições e que facilita os tests.
- Os Remotes implementam os Services e se conectam com o Almofire, a ideia é que a Camada de apresentação não dependa do Alamofire.
- Utilizei o MVP, pois  as UIViewControllers e UIViews fazem parte da view e todas as reponsabilidades delas ficam com os presenters.


### Extra
- Fiz um projeto semelhante a este, mas com mais separção entre as camadas, tento demonstrar o pouco do meu conhecimento sobre clean architecture
- Link: https://github.com/SamEngComp/ChallengeInter/tree/InterChallenge-clean-architecture ou Só mudar para a branch ChallengeInter-clean-architecture

<img width="1715" alt="inter-mvp" src="https://user-images.githubusercontent.com/54647194/131229635-0caf2f17-7fd4-4f03-a4a3-4841df394e0f.png">
