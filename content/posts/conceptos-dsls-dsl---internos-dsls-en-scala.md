---
title: "conceptos-dsls-dsl---internos-dsls-en-scala"
date:  2018-06-20T19:27:10-03:00
---


## Introducción

Acá vamos a ver una serie de "patterns" que pueden aparecer a la hora de hacer un DSL interno en Scala. Y también las diferentes variantes de cómo implementarlos. Dado que Scala tiene muchos features locos, aparecen las diferentes variantes.
Estos patterns entonces representan "pedacitos" de sintaxis dentro de un DSL. No nos enfocamos en un DSL completo.


## Keywords o Instrucciones

//TODO: Usando

* métodos:

 * heredados
 * con implicit class
 * parámetros:

  * 1 solo parámetro no necesita paréntesis
  * no necesita punto
  * N parámetros: modelado como métodos de 1 parametro encadenados.
* con object's y apply (ejemplo del LOGO)


## Dinamismo

//TODO: cómo permitir que el usuario del DSL escriba palabras propias sin caer en strings o
definir elementos de Scala como métodos, funciones, etc.

* Symbols
* Dynamic Objects

## Ejemplos


* [Baysick: Basic en Scala](http://blog.fogus.me/2009/03/26/baysick-a-scala-dsl-implementing-basic/)