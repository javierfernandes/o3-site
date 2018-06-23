---
title: "te-ruby"
date:  2018-06-20T19:27:10-03:00
---


## Ruby


* [http://ick.rubyforge.org/inside.html](http://ick.rubyforge.org/inside.html)

### Documentación de referencia


* [attr_reader, attr_writer & attr_accessor](http://stackoverflow.com/questions/4370960/what-is-attr-accessor-in-ruby)


### IDE

Un buen IDE para Ruby es el [RubyMine de JetBrains](http://www.jetbrains.com/ruby/download/index.html). No es libre ni gratuito, pero funciona bastante mejor que la mayoría de los IDEs que existen para Ruby, al menos al momento.


Contamos con una licencia educativa que pueden utilizar para la cursada, que está [aquí](te-ruby-RMLicense-zip?attredirects=0). La contraseña del ZIP es **paco.**

**

**

Una alternativa gratuita es el [Aptana Studio](http://aptana.com/products/studio3/download).
## Ruby On Rails

### Instalación

* Para instalar Ruby y Rails en Ubuntu: [https://help.ubuntu.com/community/RubyOnRails](https://help.ubuntu.com/community/RubyOnRails)
* Si encuentran algún problema con la instalación, tal vez esto ayude: [http://heatware.net/ruby-rails/solved-installing-sqlite3-ruby-gem-extconf-rb-mkmf-loaderror/](http://heatware.net/ruby-rails/solved-installing-sqlite3-ruby-gem-extconf-rb-mkmf-loaderror/).

### Ejemplos

Para generar una aplicación simple, acá hay un tutorial bastante sencillo: [http://guides.rubyonrails.org/getting_started.html](http://guides.rubyonrails.org/getting_started.html).


Algunos ejemplos de comandos útiles para trabajar con scaffolds, models y controlers:






        # Crear la base de datos
rake db:create

        

        # Crear un scaffold para un objeto Post
        ruby script/generate scaffold Post name:string title:string content:text


        

        # Crear un model para Comment
        ruby script/generate model Comment commenter:string body:text post:references


        

        ruby script/generate controller Comments




#Otro ejemplo, ordenes y clientes
ruby script/generate scaffold Order order_date:datetime order_number:integer customer_id:integer


ruby script/generate scaffold Customer name:string


        

        #Actualizar la base de datos
        rake db:migrate


        #Levantar el server
        ruby script/serve
#### **[]()
#### **[]()Información de referencia útil


* Guía sobre el uso de **asociaciones**: [http://guides.rubyonrails.org/association_basics.html](http://guides.rubyonrails.org/association_basics.html)
* Referencia de la clase **ActiveRecord**: [http://api.rubyonrails.org/classes/ActiveRecord/Base.html](http://api.rubyonrails.org/classes/ActiveRecord/Base.html). Es la clase base de la que extienden nuestros objetos de dominio y como tal es la que define gran parte del DSL.
* Manejo de **rutas**: [http://guides.rubyonrails.org/routing.html](http://guides.rubyonrails.org/routing.html)