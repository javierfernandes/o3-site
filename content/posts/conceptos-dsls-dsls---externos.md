---
title: "conceptos-dsls-dsls---externos"
date:  2018-06-20T19:27:10-03:00
---


## Descripción

Un DSL "externo" es lo que seguramente nosotros nos imaginamos cuando pensamos en la idea de "hacer un lenguaje propio". Es decir que, es un lenguaje complétamente propio a nivel de sintaxis. El código que escribimos en el no es en realidad código GPL de ningún tipo.


Esto permite tener completa libertad a la hora de definir la sintaxis.
Sin embargo, requiere más trabajo, ya que de alguna forma tenemos que construir un Parser, y luego algún tipo de runtime o backend, que sepa ejecutar ese código.
En esa parte existen diferentes variantes para evitarse tener que escribir una VM por completo, por ejemplo.


Así Scala por ejemplo, compila a JVM bytecode, y su runtime es la JVM.


## Ejemplos preliminares

Acá un par de ejemplos para darse una idea, todavía sin entrar en la implementación.
* [TCP / IP](conceptos-dsls-domainspecificlanguage-dsl---tcpip)
* CSS
* xorg.conf
* regular expressions.
* etc

## Construir un DSL externo con XText

En esta otra página van a encontrar información sobre cómo construir un DSL externo utilizando la herramienta de eclipse XText.
* [DSL con XText](conceptos-dsls-domainspecificlanguage-dsl---xtext)