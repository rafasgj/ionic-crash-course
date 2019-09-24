Ionic Crash Course
==================

Este repositório contém o material utilizado no Ionic Crash Course,
ministrado na Jornada Acadêmica da Escola Politécnica da PUC-RS, em
Julho de 2019.

## Scripts

O diretório `scripts` contém uma série de __scripts__ que auxiliam na
instalação e uso do Ionic:
    * *install.sh* instala os pacotes necessários ao desenvolvimento
    com o Ionic. Pode ser utilizado tanto em Linux quanto em macOS.
    * *android.sh* instala os pacotes necessários ao desenvolvimento
    para Android com o Ionic e pode ser utilizado tanto em Linux quanto em
    macOS. O __script__ não instala o Java JDK, porém tenta identificar a
    JVM instalada. Em Linux, também não é instalado o Gradle. No macOS, se
    o [Homebrew](https://brew.sh) estiver instalado, ele é utilizado para
    instalar o Gradle.
    * *functions.sh* contém algumas funções utilizadas pelos outros
    _scripts_.
    * *env.sx* é um __script__ que exporta as variáveis necessárias para
    o desenvolvimento com Ionic, e pode ser utilizado após a instalação
    para configurar o ambiente de desenvolvimento. Requer o uso do Bash,
    via __source__.
    * *create_ionic_avd.sh* cria um dispositivo virtual Android utilizando
    o Android Studio.

## Documentos

O diretório `docs` contém os _slides_ e imagens, apresentados no curso.
Todos os slides foram com o [KeynoteC](https://github.com/rafasgj/keynotec).

## Instalação

Execute `scripts/install.sh` e siga as instruções na tela. O uso desse
script supõe que você não possui o Android Studio instalado.
