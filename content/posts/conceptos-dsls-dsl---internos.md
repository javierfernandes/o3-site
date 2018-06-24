---
title: "conceptos-dsls-dsl---internos"
date:  2018-06-20T19:27:10-03:00
---


## Descripción

Un DSL interno es un lenguaje que depende de otro lenguaje GPL. Es decir que si bien "parece" un lenguaje propio, realmente es código GPL.
Mediante diferentes técnicas y herramientas se ocultan detalles y complejidades propias del DSL, y se reifican conceptos propios del DSL.
## Ejemplos preliminares

Para hacerse una idea de cómo es un DSL interno desde el punto de vista de quien lo usa.

* [Rails](../conceptos-dsls-domainspecificlanguage-dsl---rails)
* Mockito
* ...

Luego veremos desde el punto de vista de quien lo construye.
## Herramientas o features del lenguaje anfitrión

La capacidad que vamos a tener para poder implementar la sintaxis de nuestro DSL interno va a depender muchísimo, obviamente de la flexibilidad que nos provea el lenguaje GPL anfitrión.
Un lenguaje como java, por ejemplo, no resulta muy flexible ya que no tiene inferencia de tipos por ejemplo, con lo cual no puedo evitar la parte de declarar tipos en muchos lugares.


Acá vemos una lista de elementos de lenguajes que se pueden utilizar como técnicas combinadas para hacer un DSL interno:

* **Inferencia / implicits. **Ej:

 * Scala Implicits
 * Import statics de Java
 * Extension Methods
* **Patrones Creacionales:**


 * **Builder**

 * **Factory method**

* **Syntax Sugar**


 * operador "with" => en Xtend
 * Sobrecarga/redefinición de operadores
* **Extension methods**

* **Bloques / Closures**

* **Metaprogramación**


 * **Programación dinámica** (doesNotUnderstand  / missing_method)
 * **Self-modification**: para generar comportamiento (ej: métodos o atributos) dinámicamente, en base a una descripción del dominio.
 * **Proxy's dinámicos y Mocks**



## Técnicas específicas según GPL


* [DSL's en XTend](../conceptos-dsls-dsl---internos-dsls-internos-en-xtend)
* [DSL's en Scala](../conceptos-dsls-dsl---internos-dsls-en-scala)