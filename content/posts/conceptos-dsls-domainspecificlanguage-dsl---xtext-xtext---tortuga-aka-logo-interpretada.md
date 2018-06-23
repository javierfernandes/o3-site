---
title: "conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---tortuga-aka-logo-interpretada"
date:  2018-06-20T19:27:10-03:00
---


## Info del proyecto

* **XText version** 2.6
* SVN: [https://xp-dev.com/svn/uqbar/examples/paco/trunk/dsl/externos/xtext-2.6/tortuga/org.uqbar.paco.dsl.tortuga](https://xp-dev.com/svn/uqbar/examples/paco/trunk/dsl/externos/xtext-2.6/tortuga/org.uqbar.paco.dsl.tortuga)
* **Muestra:**


 * Lenguaje mediánamente complejo: Expresiones, Variables, Procedimientos, Parámetros
 * Interprete mediánamente complejo.
 * ScopeProvider
 * Customizaciones de UI

  * Run as
  * View
  * Boton ejecutar
  * íconos

## Descripción

Este DSL modela un lenguaje similar al LOGO (google "logo" :)), que era un lenguaje que se utilizaba para enseñar programación en las escuelas. El lenguaje sirve para darle instrucciones a una "tortuguita" que sería como "el cabezal" del gobstones. Esta tortuga dibuja. Entonces los comandos que tenemos son cosas como moverse adelante/atrás, girar a la izquierda/derecha, comenzar a dibujar, dejar de dibujar, etc.


Acá vemos un ejemplo que dibuja un cuadrado
![](https://sites.google.com/site/programacionhm/_/rsrc/1446556320083/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---tortuga-aka-logo-interpretada/Screen%20Shot%202015-11-03%20at%2010.09.10.png)




## Motor = Tortue

Ahora para este ejemplo necesitábamos implementar el **backend o runtime** que sería básicamente implementar el logo, además del lenguaje.
Entonces, en lugar de hacer eso de cero, estamos reutilizando una implementación de LOGO hecha en java, de código libre que se llama Tortue.
Entonces lo que hicimos nosotros fue construirle un DSL arriba. Este DSL tiene un intérprete que a medida que va "leyendo" el DSL va interactuando con las clases de Tortue. Hace una especie de "traducción" entre nuestro DSL y Tortue. O sea, una especie de "adapter" o nueva "cara" para el logo.


Sobre el lenguaje y su implementación

[Acá pueden ver una serie de 3 posts](http://blog.uqbar-project.org/2015/06/tutorial-language-development-with.html) que explican paso a paso cómo está hecho este DSL y el intérprete