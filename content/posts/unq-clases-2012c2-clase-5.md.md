### []()Introducción

En esta clase hablamos de lenguajes **[object-based](conceptos-object-based-languages)**, comparándolos con los lenguajes class-based que habíamos visto hasta ahora (no sólo en esta materia sino en todas las anteriores de programación con objetos). 


El lenguaje más viejo que implementa esta característica es [Self](te-self), y el más popular es [Javascript](conceptos-object-based-languages-prototipos-en-javascript). Nosotros vamos a utilizar un lenguaje muy nuevo llamado [Ioke](te-ioke) porque nos parece que tiene algunas características que lo hacen muy interesante (incluso varias ideas novedosas que van más allá de la programación object-based).


### []()Material


* [Object-Based Languages](conceptos-object-based-languages)

* [Ioke](te-ioke)

* Plugin de eclipse para Ioke (en desarrollo) [https://code.google.com/p/iokeclipse/](https://code.google.com/p/iokeclipse/)

### []()Ejemplos

En [http://svn2.xp-dev.com/svn/utn-tadp-projects/phm/trunk/ioke/](http://svn2.xp-dev.com/svn/utn-tadp-projects/phm/trunk/ioke/) van a encontrar los ejemplos que vimos en clase y muchos más. Los que primero conviene mirar son:

* **simpsons.ik**

Es el ejemplo más básico en el que se demuestra cómo definir objetos y asignarle slots.
* **delegación.ik
**Muestra como compartir código entre varios objetos.
* **simpsonsCompartiendoCodigo.ik
**Muestra cómo se puede emular el comportamiento de las clases, otra forma de compartir código.
* **simpsonsConstructores.ik
**Muestra cómo definir un mecanismo de inicialización, similar a lo que en un lenguaje class-based se logra con un constructor.
* **simpsons-metodosVsReferencias.ik
**Ejemplifica la diferencia entre un slot que contiene una referencia a otro objeto de un slot que contiene un método.
* mimics.ik
Ejemplo de un objeto con más de un mimic.



Algunos ejemplos un poco más avanzados:
* **package.ik
**Muestra cómo modelar packages utilizando los conceptos de Ioke.
* **strategy.ik
**Muestra cómo programar el patrón Strategy.
* **initialize.ik y namedParameters.ik
**Tiene ejemplos de uso de parámetros por nombre.