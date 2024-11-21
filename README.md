# tree-view-app

Este é um aplicativo Flutter responsável por montar uma árvore de componentes para empresas específicas. Ele permite a busca de localização, componentes da localização e ativos (como máquinas) de uma empresa. Os usuários podem filtrar os itens por nome e status, como ativos em status crítico ou sensores de energia.

## Funcionalidades

- **Busca por localização**: Os usuários podem buscar locais específicos dentro da estrutura da empresa.
- **Componentes da localização**: O app permite que você visualize os componentes de uma localização específica.
- **Ativos (Máquinas)**: É possível buscar ativos, como máquinas de uma empresa, e filtrar por nome ou status (por exemplo, ativos com sensores de energia ou status crítico).
- **Filtro avançado**: Filtros para ajudar a localizar ativos com status crítico ou sensores de energia.


## Bibliotecas Utilizadas

- **GetIt**:  
  Gerenciador de injeção de dependências

- **GoRouter**:  
  Usado para definir as rotas da aplicação, permitindo uma navegação fluida entre as páginas.
  
- **Flutter_BLoC**:  
  Gerencia o estado do aplicativo de maneira eficiente utilizando o padrão BLoC (Business Logic Component). Essa biblioteca permite que a lógica de negócios seja isolada da camada de apresentação (UI), tornando o código mais modular, testável e fácil de manter. Ao usar o BLoC, os estados do aplicativo são gerenciados de forma reativa, o que melhora a escalabilidade e a reusabilidade do código.

- **Sqflite_sqlcipher**:  
  Utilizado para armazenamento de dados local com segurança, criptografando o banco de dados para garantir a proteção das informações sensíveis.

- **Flutter Native Splash**:  
  Biblioteca para exibir uma tela de splash personalizada ao iniciar o aplicativo. O `flutter_native_splash` permite criar uma tela de inicialização que pode ser personalizada com a identidade visual da aplicação, sendo exibida enquanto os recursos iniciais do aplicativo estão sendo carregados ou enquanto o aplicativo está se conectando a serviços de backend.

- **Flutter_svg**:  
  Usado para exibir ícones e imagens em formato SVG no aplicativo. O formato SVG é um formato gráfico vetorial, o que significa que as imagens podem ser redimensionadas sem perda de qualidade. Essa biblioteca é útil para exibir ícones e gráficos escaláveis de maneira eficiente em diferentes resoluções de tela.

- **Dio**:  
  Biblioteca para chamadas HTTP no Flutter, permitindo a comunicação com APIs externas de forma eficiente. O Dio é uma ferramenta poderosa para fazer requisições HTTP, oferecendo funcionalidades como interceptadores, tratamento de erros, configurações de timeout e suporte para envio de dados multipart, entre outras funcionalidades avançadas que tornam a interação com APIs mais fácil e segura.



## Arquitetura

A arquitetura do aplicativo segue o padrão **Clean Architecture**, com separação clara de responsabilidades para facilitar a escalabilidade e a manutenção:

- **Repositories**:  
  A camada de repositórios é responsável pela lógica de acesso a dados. Aqui, você encontra as interfaces de comunicação com os serviços de backend e o banco de dados local.

- **Services**:  
  A camada de serviços neste contexto é uma abstracao das libs externas utilizada no projeto.

- **Pages**:  
  A camada de páginas contém as telas e widgets do aplicativo. Cada página representa uma interface do usuário (UI) que interage com os dados fornecidos pelos repositórios e serviços.

A divisão em camadas segue o princípio de **separação de responsabilidades**, onde cada camada é responsável por um aspecto distinto da aplicação. Isso ajuda na manutenção, escalabilidade e teste do código.

## Variáveis de Ambiente

Para configurar variáveis de ambiente (como URLs de APIs), foi utilizado o pacote **flutter_dotenv**. Um arquivo `.env.template` foi criado para armazenar as variáveis de ambiente necessárias, e você pode copiar esse arquivo para `.env` e preencher com os valores adequados.

Exemplo de variáveis no arquivo `.env`:
BASE_URL=https://api.exemplo.com 
DATABASE_PASSWORD=your_api_key


## Como Executar

1. **Clonar o repositório**:

   ```bash
   git clone https://github.com/usuario/tree-view-app.git
   cd tree-view-app
   flutter pub get
   ```

   Configurar as variáveis de ambiente:

2. 
Copie o arquivo .env.template para .env e preencha com as informações necessárias.

Rodar o aplicativo:

Para rodar o aplicativo no seu dispositivo ou emulador, execute o comando:
```bash
flutter run
```



[**APEX**] https://github.com/alineprado98/tree-view-app/blob/main/docs/apex.mp4


[**JAGUAR**] https://github.com/alineprado98/tree-view-app/blob/main/docs/jaguar.mp4


[**TOBIA**] https://github.com/alineprado98/tree-view-app/blob/main/docs/tobias.mp4




