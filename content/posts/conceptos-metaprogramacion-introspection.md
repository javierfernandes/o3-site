---
title: "conceptos-metaprogramacion-introspection"
date:  2018-06-20T19:27:10-03:00
---


Se refiere a poder obtener información acerca de los elementos de nuestro programa: clases, fields, métodos, funciones, predicados (en otros paradigmas).
La capacidad de introspection es la más común en los MOP's. Digamos que es la más "**simple**" de implementar, comparándolas con los otros tipos de reflection.
En objetos sería algo así como un API que permitiría **inspeccionar** otros objetos en los términos del lenguajes:

* ver de qué tipo es.
* para un tipo dado (clase) ver

 * sus fields: 

  * de ellos ver su nombre
  * su tipo
  * su visibilidad
 * sus métodos
* etc.


### Tipos de Introspection


* **Introspection estática:**


 * me permiten obtener información de las estructuras de mi programa. Independientemente de las instancias. Por ejemplo, con esto podría generar un diagrama de clases, o bien un javadoc. Ej: dada una clase generar su javadoc.
* **Introspection dinámica:**


 * me permite interactuar con el programa para que haga algo. Para eso interactuamos ya no con objetos que representen las clases, sino también con las instancias mismas. Por ejemplo enviarle un mensaje a un objeto.

### Ejemplos de introspection en diferentes lenguajes

#### **[]()
* [Introspection en Java](../conceptos-metaprogramacion-introspection-introspection-en-java)
* [Introspection en Javascript (lenguaje dinámico)](../conceptos-metaprogramacion-introspection-introspection-en-javascript)
* [Introspection en Self (mirrors)](../conceptos-metaprogramacion-introspection-introspection-en-self)




### 