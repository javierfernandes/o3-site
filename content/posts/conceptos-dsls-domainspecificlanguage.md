---
title: "conceptos-dsls-domainspecificlanguage"
date:  2018-06-20T19:27:10-03:00
---


## []()Introducción
En general cuando nos enfrentamos a un problema de programación aparecen varias actividades que trataremos de simplificar ampliamente acá:

1. **Entendimiento del problema/dominio**

1. **Formación conceptual de una solución**

1. **Implementación en un lenguaje de programación**

1. **Compilación, ejecución y pruebas.**


Normalmente trabajamos con un único paradigma de programación y unos pocos lenguajes. Estos lenguajes permiten expresar sobre ellos cualquier tipo de dominio, es decir que se utilizan para desarrollar cualquier tipo de aplicación.
Por esto es que se llaman **lenguajes de propósito general (GPL del inglés)**


En el proceso de **entendimiento del dominio** podríamos trabajar completamente abstractos del lenguaje de programación, simplemente tratando de relevar información  y requerimientos.
No vamos a entrar en detalles acá acerca de esta etapa, pero lo que nos interesa es que **se podría hacer una análisis del problema independiente del lenguaje de programación y hasta del paradigma.**


**Durante la formación conceptual de una solución** ya debemos pensar el dominio dentro de uno o varios paradigmas (en caso en que osemos desarrollar la solución con múltiples paradigmas), de acuerdo a nuestra experiencia, o lo que veamos que mejor se adapte a la problemática.
Por ejemplo, hay problemas que son inherentemente más fáciles de implementar en el paradigma lógico que en objetos, o funcional, etc.
Sin embargo, todavía podríamos pensar en una solución independiente del lenguaje.

Por ejemplo, en objetos es donde identificamos:

* objetos y clases.
* responsabilidades (mensajes).
* interacciones y colaboraciones.

* jerarquías / traits (lógica común y reutilización.
* etc.
Luego tenemos que realmente implementar esta solución abstracta en los **pasos 3 y 4**, y para eso utilizamos un GPL.
Y acá va el problema:

* El mapeo de la solución conceptual con el lenguaje no es directo, no suele ser trivial.
* A veces no tenemos soporte del lenguaje para ciertas abstracciones de nuestro dominio:

 * Los ejemplos más simples son los patrones como singleton, delegación automática, etc.
* Estamos forzados a **adaptar el dominio y nuestra solución al lenguaje.**

Y eso es lo que hacemos siempre, adaptamos al lenguaje que tenemos "a mano".

Hé aquí un diagrama de este proceso que tomamos prestado de [JetBrains](http://www.onboard.jetbrains.com/articles/04/10/lop/2.html)


[![](http://www.onboard.jetbrains.com/articles/04/10/lop/img/figure1.png)
](http://www.onboard.jetbrains.com/articles/04/10/lop/img/figure1.png)

Eso nos lleva a que nuestra solución va a estar siempre de aquí en adelante expresada en un lenguaje que no es el más cercano al problema/dominio, sino más bien a un lenguaje de programación general.

Algunas consecuencias:

* **Legibilidad:**


 * nuestro código contendrá una mezcla entre conceptos de dominio (una Cuenta, un Cliente, etc) y palabras propias del lenguajes (keywords, como **public** **class**, **trait, **etc).
 * Quien se incorpore al proyecto o quiera revisar la solución deberá, naturalmente, hacer el proceso inverso, como una **ingeniería reversa,** a partir del código y de lo expresado en el GPL abstraerse para generar una representación mental del problema/dominio.
* **Flexibilidad** (cambios de requerimientos o dominio)

 * naturalmente solo podrán ser implementados por desarrolladores que entiendan no solo el dominio, sino además el GPL.
 * cada nuevo cambio deberá ser traducido nuevamente de **dominio hacia GPL**.

* **Duplicación:**


 * tendremos al menos dos representaciones de la solución, la mental (que muchas veces además se plasma en documentos de especificación y análisis) y la traducción/implementación en el GPL.


Estas consecuencias hacen que la programación dedique **la mayor parte del tiempo y esfuerzo en lidiar con los problemas de traducción e implementación de la solución al GPL.**


Entonces, una **vía alternativa** sería en pensar que **en lugar de adaptar nuestra solución a un lenguaje, podemos adaptar el lenguaje a nuestra solución**.
A esto se lo conoce como **Language-Oriented Programming **, desde el punto de vista de un nuevo "paradigma".
Y una de las prácticas es crear un nuevo lenguaje para expresar nuestra solución o una parte de la solución.
Esto es un **DSL**.

Aquí otro diagrama que muestra el nuevo proceso de desarrollo.


[![](http://www.onboard.jetbrains.com/articles/04/10/lop/img/figure2.png)
](http://www.onboard.jetbrains.com/articles/04/10/lop/img/figure2.png)
## []()DSL
DSL viene de las siglas en inglés "**D**omain-**S**pecific **L**anguage".

Un DSL es un lenguaje ideado para expresar cierta parte de un sistema. Por eso se dice que es un **lenguaje de propósito específico.** A diferencia de los **lenguajes de propósito general.

**Qué quiere decir esto ?

  **propósito general** **propósito específico****Abarca construir
** **la totalidad** de la aplicación
**una **parte** de la aplicación 
**Tipo de Aplicacíón**

**cualquiera**

**un solo tipo **

**Conceptos***generales*: función (en funcional), clase,     objeto, método (en OOP),         variable, predicado (en lógico),     etc. 
del (único) **dominio**

**Ejemplos**

C, Java, Smalltalk, Self, ADA, Haskell, Prolog, etc.
xpath, SQL, pic, sed


## []()Ejemplos de DSL
A continuación subpáginas con ejemplos de DSL's que posiblemente utilizamos

* [Ejemplo del Restaurante](conceptos-dsls-domainspecificlanguage-dsl---ejemplo-restaurante)
* [SQL](conceptos-dsls-domainspecificlanguage-dsl---sql)
* [Pic2Plot: diagramas de secuencia](conceptos-dsls-domainspecificlanguage-dsl---pic2plot-diagramas-de-secuencia)
* [Sed (linux Stream EDitor)](conceptos-dsls-domainspecificlanguage-dsl---sed)
* [Ruby on Rails](conceptos-dsls-domainspecificlanguage-dsl---rails)
* [Otros](ejemplos-extra-de-dsls)

### []()Para qué sirve un DSL ?

O dicho de otra forma, por qué debería yo hacer un DSL ?

Suponemos que con la comparación que ya vimos, aparecen varias razones. Pero vamos a enumerarlas acá para resumir:

* para **acercar la brecha** **entre** la descripción del problema en términos abstractos (descripción del **dominio**) **y la implementación** de la "computación" que lo resuelve / ejecuta.

 * **Facilitaría la comunicación** con gente no-técnica.
 * No programadores podrían entenderlo y escribirlo.
* para **esconder los detalles internos**



 * de la lógica común

 * o las construcciones propias del lenguaje
* para **configuraciones** de ciertas partes de la aplicación.
* para **expresar de forma declarativa** ciertas **reglas del negocio**, 


 * que se va a **separar** de la forma en que se **interprete y ejecute** esa regla. Ej: regular expressions.
* para la **creación de un grafo complejo de objetos **



 * problema que normalmente solucionamos con patrones creacionales, como factories, builders & prototypes.


## []()Tipos de DSL's
A grandes rasgos, podríamos catalogar los DSLs a través de las siguientes categorías. Existen autores que refinan mucho más a detalle la categorización, incluyendo nuevos tipos. A fines prácticos de explicar la idea general a nivel de programación, nosotros optamos por acotar esa categorización:

* **Externos:**


 * **Compilados** ó **Interpretados**


  * **Compilados:** traduce a lenguaje maquina ejecutable: puede ser assembler o un lenguaje ejecutable por una VM como java (bytecode en ese caso), etc.
  * **Interprete:** a medida que se va parseando (leyendo) el código expresado en el DSL, se va ejecutando, sin haber "generado" código ejecutable como paso intermedio.
 * **Traducidos**


  * Son los famosos generadores de código.
  * Si bien se podría trazar una analogía con los compiladores, ya que también generan código, la diferencia es que los traductores **generan código que no es "ejecutable"** de por sí, sino más bien código de otro lenguaje.
  * Ejemplo: generadores de código. a través de Java APT (annotation processing tool), o bien xtend.
* **Internos (o Embebidos):**


 * Se utiliza un lenguaje GPL, pero se lo usa de tal manera de "simular" o asemejarse lo mayor posible a un lenguaje propio del dominio.

 * Son syntax sugar y un diseño de API's especial, llamado Fluent Interfaces, se acerca de un lenguaje de dominio.

 * Aprovechar las características del lenguaje GPL existente, 
 * Evita tener que hacer un parser, compilador e interprete.

 * Ej: ruby

## []()Internal vs External DSLs

 **External 
****Internal 
** **Ventajas**

* Libertad absoluta sobre la sintaxis del lenguaje (solo limitada por capacidad de implementación del parser, etc), por eso..
* Mayor expresividad del dominio.


* Simplicidad de implementación: No requiere hacer un parser, compilador y runtime/VM/backend.
* Aprovecho herramientas del GPL, como IDE's, editores, refactors, debugers etc.
* Permite salvar carencias del DSL escribiendo código directo del GPL dentro.
 **Desventajas**

* Complejidad al tener que implementar el parser + compiler
* Disasociación del lenguaje "base" o de ejecución.
* Caemos fuera de las herramientas tradicionales, y perdemos soporte a nivel IDE (salvo, ahora con xtext)


* Encontramos limitaciones del lenguaje GPL en cuanto a customizar la sintaxis. 


## []()