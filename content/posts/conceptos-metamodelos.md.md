### []()Contenidos Teóricos

* [Mixins](conceptos-mixins) & [Traits](conceptos-traits)
* [Aspect-Oriented Programming](conceptos-aop)
* [Object-Based Languages (vs. class-based)](conceptos-object-based-languages)

 * Clonación
 
* Patrones de diseño en esta nueva perspectiva
* Bonus: 

 * Open classes
 * Subject Oriented Programming
 * Behavioural completeness

### []()Tecnologías

* Mixins: [Scala](te-scala)
* Traits: [Pharo](te-smalltalk)
* [AspectJ](te-aspectj)
* [Ioke](te-ioke)
* Bonus

 * [Herencia múltiple y method resolution en Python](http://www.python.org/download/releases/2.3/mro/)

 * [Self](te-self)
 * [Prototipos en JavaScript](conceptos-object-based-languages-prototipos-en-javascript)


### []()Bibliografía

* [Antero Taivalsaari. *The notion of Inheritance*](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.72.6812&rep=rep1&type=pdf)
* [Gilad Bracha. ](temario-goog_810575391)*[Mixin-based Inheritance](http://stephane.ducasse.free.fr/Teaching/CoursAnnecy/0506-Master/ForPresentations/p303-bracha.pdf)*
* [Stéphane Ducasse. ](http://scg.unibe.ch/archive/papers/Scha02bTraits.pdf)*[Traits: Composable Units of Behavior](http://scg.unibe.ch/archive/papers/Scha02bTraits.pdf)
*

### []()Ejemplos

//TODO Esta sección la podemos volar? (javi)
* Traits 


 * Colecciones con límite de tamaño y con validaciones.

 * Sin estado: Cuentas bancarias.

 * Autosuficientes: Docentes, alumnos y ayudantes.
 * Alquiler

 * Enumerables

* Aspectos

 * Objetos observables. Ver ejemplo de Arena.
 * Mixin de objetos persistentes. Behavioural completeness.
 * Objetos transaccionales.
 
* Comparar los patrones de diseño en presencia de diferentes elementos conceptuales:

 * Factory Methods y Abstract Factories en Smalltalk.
 * Strategies (en Self / Ioke)
 * Decorator (en Scala y Ioke)
* Analizar el impacto en la programación y el diseño de un entorno en el cual los objetos pueden ir mutando a lo largo de su ciclo de vida. Cómo se "diseña" en la presencia de estos conceptos.

 * Comparar con otros lenguajes como Python, Ruby, Groovy