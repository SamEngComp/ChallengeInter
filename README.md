# Objetivo

Realizar uma refatoração que melhore as técnicas de programação e arquitetura utilizando tecnologias mais atuais.

# O que deve ser entregue

O aplicativo funcionando exatamente como está na versão original. O comportamento e o visual não devem ser alterados.

Publique o resultado da sua refatoração em um repositório público aqui mesmo no GitHub e nos envie o link.

# O que gostaríamos que fossem utilizados

* Padrão de Arquitetura de Software
* Design Patterns
* View code
* Atenção ao ARC (Automatic Reference Counting)
* Data Binding
* Protocolos
* App funcionando nos diferentes tamanhos de devices

Não é neccessário entregar todos os pontos acima. Faça a refatoração de acordo com os conhecimentos prévios e adquiridos.

# Aplicação

Utilizamos um REST API público para realizar esse desafio, o [{JSON} Placeholder](https://jsonplaceholder.typicode.com).

O app lista alguns usuários, onde estes, possuem álbums de fotos e postagens.

Os álbums possuem uma lista de fotos onde cada uma tem sua tela de detalhes.
Já cada uma das postagens possuem alguns comentários.

## Endpoints

```
GET Users: https://jsonplaceholder.typicode.com/users
GET Albums by User: https://jsonplaceholder.typicode.com/albums?userId=id
GET Photos by Album: https://jsonplaceholder.typicode.com/photos?albumId=id
GET Posts by User: https://jsonplaceholder.typicode.com/posts?userId=id
GET Comments by Post: https://jsonplaceholder.typicode.com/comments?postId=id
``` 

![Gif app](app.gif)

Até breve! 