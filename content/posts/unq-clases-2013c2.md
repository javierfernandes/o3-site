---
title: "unq-clases-2013c2"
date:  2018-06-20T19:27:10-03:00
---


Clase 5 - 9/9 **Contenido de la clase**


* Dos características típicas en los lenguajes OO más tradicionales:

 * Las clases tienen varios roles:

  * Definición del comportamiento de un objeto.
  * Definición de tipos
  * Creación de objetos
 * La única herramienta *automática* para compartir comportamiento es la herencia (más aún, herencia simple).
* La delegación no alcanza para solucionar esos problemas. Por ejemplo en presencia de estructuras tipo Template Method.
* Problemas de la herencia múltiple.

 * ¿Qué pasa si heredo métodos con la misma firma de dos o más superclases?
 * ¿Qué pasa si quiero combinar el comportamiento heredado de diferentes superclases?
 * ¿Cómo se resuelven los chequeos de tipos en las superclases abstractas?
 * ¿Qué pasa si quiero ponerle un comportamiento especial sólo a algunos objetos?
* Mixins

 * Sintaxis en Scala.
 * Linearización.
 * Super.
 * Ejemplo de los vehiculos.

**Ejemplos de código**

* [http://xp-dev.com/svn/uqbar/examples/paco/trunk/traits](http://xp-dev.com/svn/uqbar/examples/paco/trunk/typing/scala) contiene los ejemplos en los 4 lenguajes (scala, java, pharo y c++) 

**Material de Lectura**


* [Mixins](conceptos-mixins)

* Especificación de las reglas de [linearización en Scala](http://jim-mcbeath.blogspot.com.ar/2009/08/scala-class-linearization.html#rules).
* [Herencia múltiple y method resolution en Python](http://www.python.org/download/releases/2.3/mro/)

**Tarea para el Hogar**


* Comenzar con la entrega 2 del TP1
 Clase 4 - 2/9 **Contenido de la clase**


* Posibles clasificaciones para los sistemas de tipos en el paradigma de objetos.
* Casteos y Coerciones.
* Duck Typing.
* Comparación cualitativa de los sistemas de tipos en diferentes lenguajes.

**Ejemplos de código**

* [http://xp-dev.com/svn/uqbar/examples/paco/trunk/typing/scala](http://xp-dev.com/svn/uqbar/examples/paco/trunk/typing/scala) contiene los ejemplos en los 4 lenguajes (scala, java, pharo y c++) 

**Material de Lectura**


* [Sistemas de tipos](conceptos-tipos-binding-sistemas-de-tipos)


**Tarea para el Hogar**


* Terminar la primera parte del [TP1](unq-tps-2013c2) (ejercicios 1 y 3) y traerlo **andando** para la próxima clase.
* Coordinar por mail un horario para la entrega de TP.
* Sería bueno si pueden ir publicando el TP en un svn o git. Por ahora no lo vamos a exigir porque hasta donde yo puedo ver no es posible hacer commit desde el aula, entonces no tiene demasiada utilidad. Pero espero que tarde o temprano se pueda y ahí sí va a ser obligatorio tener un repositorio de código.
 Clase 3 - 26/8**Contenido de la clase**


* Introducción al Scala: clases, objetos, métodos, variables (var) y constantes (val).

 * Uso de variables públicas y/o accessors en Java vs. Scala, análisis desde el punto de vista del **binding**.
 * Funciones de orden superior.
* Double Dispatch
* Pattern mathching.
* Introducción a los sistemas de tipos. 
* Subtipado. Subsumption.
* Clasificación de los tipos según el momento de chequeo: chequeo estático o anterior a la ejecución, chequeo dinámico o durante la ejecución, ausencia de chequeo.

**Ejemplos de código**

* [http://xp-dev.com/svn/uqbar/examples/paco/trunk/dispatch/scala/rabufetti-scala](http://xp-dev.com/svn/uqbar/examples/paco/trunk/dispatch/scala/rabufetti-scala) contiene ejemplos sobre double dispatch y pattern matching.
* http://xp-dev.com/svn/uqbar/examples/paco/trunk/languages/scala contiene ejemplos introductorios al lenguaje Scala, en particular:

 * La clase `Pepita` :) tiene los ejemplos más básicos como para empezar
 * La clase `functions.HigherOrder` contiene ejemplos de manejo de colecciones utilizando bloques (o funciones de orden superior, como prefieran decirles).
 * Las clases `Expression*` tienen ejemplos variados de pattern matching, más complejos que los de Rabufetti.

**Material de Lectura**


* Material teórico sobre [Multiple Dispatch](conceptos-multiple-dispatch)
* [Sistemas de tipos](conceptos-tipos-binding-sistemas-de-tipos)


**Tarea para el Hogar**


* Continuar avanzando con el TP y mandar dudas.
* Asegurarse de tener forma de ejecutar código Scala en el aula, para poder entregar el TP.
Clase 2 - 19/8Feriado Nacional  Clase 1 - 12/8  
**Contenido de la clase**


* Introducción a la materia, de qué se trata, horaro de clase, [trabajos prácticos](unq-tps-2013c2) y criterios de evaluación
* Comenzamos con el material de la Unidad 1, que habla sobre [Tipos y Binding](-site-programacionhm-temario-unidad-1) 

**Ejemplos de código**

* El ejemplo lo pueden checkoutear con el svn de [acá](http://xp-dev.com/svn/uqbar/examples/paco/trunk/dispatch/xtend/). El ejemplo está hecho en XTend y Java, las intrucciones para armar un entorno con XTend son las mismas que para hacer andar [XText](te-xtext).

**Material de Lectura**


* Definiciones de las ideas de [Binding, Polimorfismo y Sobrecarga](http://uqbar-wiki.org/index.php?title=Binding%2C_polimorfismo_y_sobrecarga).
* Material teórico sobre [Multiple Dispatch](conceptos-multiple-dispatch)
* Otro [ejemplo](https://docs.google.com/document/d/1XWq9azqchoJZ7h8-hLcpA1Zj5T1UtvFtDKbpzxoQ-dw/edit#heading=h.gjdgxs).

**Tarea para el Hogar**


* Armar parejas de TP y mandarlas por mail.
* Preparar el entorno de [Scala](te-scala), tanto para poder trabajar en casa como en la Universidad (coordinar con el compañero de TP).
* Programar la primera parte del TP1 (ver la página de [Trabajos Prácticos](unq-tps-2013c2)), aprovechar para aprender Scala, venir con preguntas!
* Repasar el material de lectura y en particular el último ejemplo, que tiene un enunciado sobre el que vamos a trabajar la clase que viene.