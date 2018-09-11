---
title: "temario"
date: 2018-09-11T10:30:31-03:00
menu:
  sidebar:
    parent: Cursada
    weight: -1
---


# Temario de la Cursada

A continuación una lista de diapositivas a los temas que vemos en la materia


| Unidad	| Tema    |   Material  |	 Ejercicios / Ejemplos |
|---------|---------|-------------|------------------------|
| 0 | Sistemas de Tipos | [Intro a Sistemas de Tipos](https://docs.google.com/presentation/d/1F7wX_ScphEgGiN9wbDxvvru6G2c-UEG3H8mEbL8BdPg/), Generics (?) |
| 1 | Mixins | [Intro a Scala](https://docs.google.com/presentation/d/1ffuoM0n1x9RSjUwOudzUAXDeRTHFTYQ89Cf83Ls-Ju0/), Mixins [Presentacion](https://docs.google.com/presentation/d/1Tv0xU1wV6m7OHcCRbBJqciVW2TRYPz2JAq457IWBvBU/edit?usp=sharing) & [Apunte](../conceptos-mixins/) | [Mateada](https://docs.google.com/document/d/1sy1rxT6oJg_CiCncDNzJFSjdHttGwIRsMkXb-XYK55E), [Sin City](https://docs.google.com/document/d/1h2mVfFg81fJq6sGbGoQQWGfoKkSW8_un7Ydozaqi6ig) |
| 2 | Influencias de FP en OOP | [FP + OOP (scala)](https://docs.google.com/presentation/d/15OYGb2OtPmmtkHZayCHNiirlMvZh4XqMnTZXyqCSR8U/) |
| 3 | Metaprogramación | [Metaprogramación](https://docs.google.com/presentation/d/10P7XBI9gCB27vvWC5J294L-w22C8NG0tVMI7xbFTLeE/edit) |


# Temario Ampliado

Este es  un conjunto de apuntes más completo que incluye temas relacionados a los que vemos en la materia, pero que quizás no vemos en la cursada. Aunque lo vimos otras cursadas.
Sirve como referencia para entender mejor los temas

* **Conceptos Generales**: [Abstracciones y conceptos: visión general de la materia](../conceptos-abstracciones-y-conceptos-visin-general-de-la-materia). [¿Qué entendemos por programación orientada a objetos?](http://uqbar-wiki.org/index.php?title=%C2%BFQu%C3%A9_entendemos_por_Programaci%C3%B3n_Orientada_a_Objetos%3F)

* [**Esquemas de tipado**](../conceptos-tipos-binding): Definición de Tipo. Tipo en el paradigma de objetos. Checkeos. Tipado estático y dinámico. Fuertemente y débilmente tipado. Tipado Nominal, Estructural y Mixto. Duck typing.  Sistemas de checkeos de tipos opcionales. Dispatching & Binding. Late binding. Multiple dispatch (multimethods). Design By Contract.

* [Definiendo comportamiento más allá de las clases](../conceptos-metamodelos) Closures. Open Clases. [Mixins](conceptos-mixins) & [Traits.](../conceptos-traits) [Prototype-Oriented Programming](../conceptos-object-based-languages). [Aspect-Oriented Programming](../conceptos-aop) (AOP). Behavioural completeness. Revisión de los patrones de diseño.


* [**Reflexividad y metaprogramación**](../conceptos-unidad-3)

* [**Metraprogramación**](../conceptos-metaprogramacion): reflection, introspection, self-modification e intercession.  Meta-Objects. MOP. Bonus: [Mirrors.](../conceptos-mirrors)

* [**Programación Declarativa**](../conceptos-declaratividad) Concepto de declaratividad. Caracterísiticas. Implementaciones y ejemplos. Ventajas: abstracción, portabilidad, paralelismo. Relación con DSLs y metaprogramación. Lenguajes con características declarativas.

* [**Lenguajes Específicos de Dominio**](conceptos-dsls): Concepto de DSL. General Purpose Language vs Domain-Specific Language. Características. 
Objetivos de un DSL. Tipos de DSL: Compilados, interpretados; Traductores; Embebidos. Complejidades de creación de un DSL.
Modelo Semántico.
Gramática: concepto, relación con modelo semántico, proceso de diseño.
Validaciones y checkeos.
Procesamiento: Generadores de código, Intérprete (transformaciones modelo a modelo).
Editores de texto.
Ejemplos de DSL: SQL, pic2plot (diagramas de secuencia), comando linux sed, TCP/IP, Ruby on Rails.Comparación con un API java.
Construcción de un DSL con XText.
