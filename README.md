# SW

## Visão Geral

Este projeto é uma aplicação Flutter estruturada com arquitetura **MVVM**, **OAuth 2.0** para autenticação, consumo de API via **Dio**, gerenciamento de estado com **Provider** e **injeção de dependências com GetIt**.

---

## Tecnologias e Práticas Adotadas

| Tecnologia         | Descrição                                                                 |
|--------------------|---------------------------------------------------------------------------|
| **Flutter 3.27.4** | Base do projeto, multiplataforma, com canal _stable_.                     |
| **Dart 3.6.2**     | Linguagem principal.                                                      | 
| **MVVM**           | Arquitetura que separa apresentação, lógica e domínio de forma limpa.     |
| **OAuth 2.0**      | Autenticação segura com refresh automático via `TokenStorage`.            |
| **Secure Storage** | Tokens armazenados com segurança usando `flutter_secure_storage`.         |
| **Provider**       | Gerenciamento de estado leve e escalável.                                 |

---

## Como Rodar o Projeto

### 1. Requisitos
- Flutter SDK **3.27.4** instalado ([instalar Flutter](https://docs.flutter.dev/get-started/install))
- Dart SDK **3.6.2** incluído no Flutter
- Android Studio ou VS Code
- Emulador Android ou dispositivo físico com modo desenvolvedor
- CocoaPods (para iOS): `sudo gem install cocoapods`

### 2. Configurar dependências do projeto

```bash
flutter pub get
```

### 3. Rodar o projeto

```bash
flutter run
```

### 4. Plataformas suportadas

```bash
flutter run -d emulator   # Android
flutter run -d ios        # iOS (com Xcode configurado)
```

---

## Estrutura do Projeto

```bash
lib/
├── core/
│   ├── auth/             # Autenticação OAuth e storage seguro
│   └── di/               # Injeçao de dependencias
├── data/                 # Implementações de repositórios e modelos
├── domain/              # Entidades, repositórios abstratos e use cases
├── presentation/         # Views (UI) e ViewModels (lógica de apresentação)
└── main.dart             # Entry point do app
```

---

## Autenticação

- O token de acesso (`access_token`) e o token de renovação (`refresh_token`) são armazenados de forma segura via `flutter_secure_storage`.
- Quando a API retorna erro 401, o token é automaticamente renovado com `refresh_token`.

---

## Chamadas de API

- **GET** `/orders` — Lista de pedidos
- **POST** `/orders` — Criação de novo pedido
- **PUT** `/orders/{id}` — Marcar pedido como concluído

---