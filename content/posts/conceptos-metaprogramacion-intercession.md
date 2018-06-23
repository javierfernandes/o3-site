---
title: "conceptos-metaprogramacion-intercession"
date:  2018-06-20T19:27:10-03:00
---


## Intercession

Se refiere a poder modificar las características de los elementos de nuestro programa.
Esta capacidad no es para nada frecuente en MOPs. Un ejemplo de esto es el MOP de CLOS (Common Lisp Object System, que sería la extensión a LISP para trabajar con objetos).


TODO: ejemplo en CLOS.


### Intercession en JavaScript
Javascript no posee soporte para **intercession** estandard a nivel lenguaje. 

Sin embargo, una implementación particular, **spidermonkey** permite un tipo particular de intercession, la intercepción de acceso a propiedades, basándose en la idea del **doesNotUnderstand** de Smalltalk. En realidad este feature no es único de smalltalk y se lo denomina comúnmente [Dynamic Reception](http://martinfowler.com/dslCatalog/dynamicReception.html). Por ejemplo en ruby el método se llama **method_missing**



        **function** makeProxy(o) {
            **return** {
                __noSuchMethod__: **function**(prop, args) {
                    **return** o[prop].apply(o,args);
                }
            };
        }

Como verán esto es un factory method, que dado un objeto **"o**"** **retorna un proxy a este. 
Dentro del método se crea un objeto** **con la **literal**, es decir, como un mapa.
Donde se define se sobrescribe el método especial **__noSuchMethod___**.
En esta implementación el método delega al objeto **o**.

El chiste sería que uno podría hacer otras cosas.