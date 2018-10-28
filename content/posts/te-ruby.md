---
title: "Ruby"
date: 2018-10-28T16:29:30-03:00
menu:
  sidebar:
    parent: Tecnologías
---

# Instalación de Ruby y Rubymine

## En **Linux**

* Instalar Ruby desde el [sitio de downloads](https://www.ruby-lang.org/en/downloads/)
* Instalar RubyMine (IDE): con su cuenta de mail UNQ pueden obtener una licencia gratuita desde [aquí](https://www.jetbrains.com/shop/eform/students)

{{< youtube OyLoonEjfDY>}}


## En **Windows**

{{< youtube Y0G9hScWgAs>}}


# Scripts útiles

## Instalar ruby desde consola

```bash
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install ruby
```

## Ejecutar tests desde consola

Primero necesitamos que nuestro proyecto declare la dependencia a la gema `rspec` en un archivo `Gemfile`

```gemfile
source 'https://rubygems.org'

gem 'rspec'
```

Luego la instalamos con el comando `bundle`

```bash
bundle
```

Ahora si podemos ejecutar los tests con

```bash
bundle exec rspec ./spec
```

O bien el path a los specs que tengan.


