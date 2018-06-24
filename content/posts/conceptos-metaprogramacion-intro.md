---
title: "conceptos-metaprogramacion-intro"
date:  2018-06-20T19:27:10-03:00
---


## 
Definición
**Metaprogramación: **es el proceso o la práctica por la cual *escribimos **programas** que **generan, ******manipulan o utilizan** otros programas*.**



### Ejemplos

* Un **compilador** se puede pensar como un programa que **genera otro programa**.
* Un **formateador de código** es un programa que **manipula otro programa**.
* Una **herramienta **como **javadoc** **utiliza nuestro programa** para generar su documentación.

### Para qué se usa la metaprogramación ?
En general la metaprogramación se utiliza más fuertemente en el desarrollo de frameworks.
Simplemente porque un framework va a resolver cierta problemática de una aplicación, pero no va a estar diseñador para ninguna en particular. Es decir, la idea de **framework** es que se va a poder aplicar y utilizar en diferentes dominios desconocidos para el creador del framework.
Entonces estos frameworks van a manipular objetos, sin conocerlos de antemano. 

Ejemplos:

* **ORM's como hibernate: **que van a encargarse de persistir las instancias de nuestras clases sin siquiera conocerlas de antemano.
* **Frameworks de UI**: que deberán saber mostras cualquier objeto.
* **Frameworks de Testing**, como JUnit suelen usar metaprogramación para analizar la clase de Test y encontrar los tests que se deben correr.
* **Otras herramientas:**


 * **javadoc: **es una herramienta como el compilador de java, que lee el código fuente y genera documentación html.
 * **code coverage:** herramientas que miden cuánto de nuestro código es realmente ejecutado al correr los tests, y cuales lineas no.

 * **analizadores de código:** que evalúan nuestro código y genera métrics o miden violaciones a reglas definidas. Como el estilo de código, complejidad ciclomática, etc. Por ejemplo para java existe [sonar](http://www.sonarsource.org/) que junto a maven automatizan y concrentran varias otras herramientas.


### Modelos y metamodelos

Así como todo programa construye un modelo para describir su dominio. El domino de un metaprograma es otro programa denominado programa objeto o base y tendrá un modelo que describe a ese programa, al que llamamos **metamodelo**.


En el siguiente ejemplo, nuestro dominio contiene diferentes tipos de animales, entre ellos perros y humanos. 


El programa describe las características de los elementos del dominio utilizando (por ejemplo) clases, métodos y atributos. Entonces, **el modelo contiene una clase Perro**, que modela a los perros en el domino. Y **el programa manipula instancias** de la clase Perro.


Un metaprograma tendrá a su vez un (meta)modelo que describe a su dominio, el programa base. Así como en el dominio hay animales concretos, los habitantes del "metadominio" (= programa base) serán los elementos del programa: por ejemplo, clases, atributos, métodos.
Entonces el metamodelo deberá tener clases que permitan describir esos conceptos, por ejemplo en el metamodelo de Java encontraremos las clases Class, Method, Field. Este metamodelo describe la estructura posible de un programa Java. En otro lenguaje, ese metamodelo tendría diferentes elementos.


Así como el programa manipula las instancias de las clases Perro o Animal, el metaprograma manipula las instancias de las clases que conforman el metamodelo (Class, Method, Field, o las que fueran).



[![](https://sites.google.com/site/programacionhm/_/rsrc/1368570507605/conceptos/metaprogramacion/metaprogramacion.png)
](conceptos-metaprogramacion-metaprogramacion-png?attredirects=0)

## Reflection

**Reflection: **es un caso particular de metaprogramación, donde "metaprogra**mamos**" en el mismo lenguaje en que están escritos (o vamos a escribir) los programas. Es decir, todo desde el mismo lenguaje. 

*Nota de color:* Inicialmente el lenguaje "pionero" en cuanto a reflection fue LISP.

### Ejemplos
El ejemplo más visible de esto es el caso de smalltalk, donde no existe una diferenciación entre IDE y nuestro programa. Ambos estan hechos en smalltalk, y de hecho viven en un mismo ambiente. Ambos estan construidos con objetos y pueden interactuar entre sí.

De hecho muchos componentes del "IDE" Pharo son elementos de metaprogramación, y utilizan reflection para **inspeccionar** nuestras clases y objetos.

### Tipos de reflection
Para esto, generalmente, es necesario contar con facilidades o herramientas específicas, digamos "soporte" del lenguaje.  Entonces reflection, además,  abarca los siguientes items que vamos a mencionar en esta lista:

* **[Introspection](introspection): **se refiere a la capacidad de un sistema, de analizarse a sí mismo. Algo así como la introspección humana, pero en términos de programa. Para eso, el lenguaje debe proveer ciertas herramientas, que le permitan al mismo programa, "ver" o "reflejar" cada uno de sus componentes.

* **[Self-Modification](../conceptos-metaprogramacion-self-modification): **es la capacidad de un programa de modificarse a sí mismo. Nuevamente esto requiere cierto soporte del lenguaje. Y las limitaciones van a depender de este soporte.

* **[Intercession](../conceptos-metaprogramacion-intercession): **es la capacidad de modificar la semántica del modelo que estamos manipulando, **desde** el mismo lenguaje.



### MOP: MetaObject Protocol

Un MOP es un framework de objetos que describe o modela un sistema de objetos. MOP sería el término correcto para lo que en java llamamos API de reflection.
En realidad el API de reflection de java es un caso de MOP.


Dependiendo de la implementación y del lenguaje, el MOP puede soportar o no los tipos de reflection que enumeramos arriba: introspection, self-modification & intercession.