---
title: "unq-clases-2012c2-clase-8"
date:  2018-06-20T19:27:10-03:00
---


### Material teórico

El material teórico de esta clase es continuación de la clase anterior: [https://sites.google.com/site/programacionhm/conceptos/metaprogramacion](../conceptos-metaprogramacion). En esta clase nos concentramos en la parte de **self-modification**.
### Ejemplos de self-modification en Pharo
Los ejemplos vistos en clase se pueden bajar de [http://ss3.gemstone.com/ss/uqbar](http://ss3.gemstone.com/ss/uqbar):

* En el package **Uqbar-MetaProgramming** van a encontrar la clase **SimpleExtractTraitRefactoring** y **SimpleExtractSuperclassRefactoring**, que ejemplifican la utilización de metaprogramación como una forma de automatizar refactors.
* En el package **Uqbar-Tools** encontrarán el **ScriptBuilder**, que permite a partir de un package generar un metaprograma que reconstruye este package. Esta utilidad es cómoda para probar otros metaprogramas y a su vez es un ejemplo interesante de metaprogramación.
* En el package **PACO-Prototyping** pueden encontrar el trait **TMetaProto**, que al agregarlo a una clase permite que esa clase pueda componerse con traits en el momento de la instanciación (como se hace por ejemplo en Scala). En la categoría **PACO-Prototyping-Metaprogramming-Test** hay ejemplos de uso de esta idea.

### Trabajo Práctico


El objetivo del trabajo práctico es hacer un refactoring en Pharo, que a partir de dos clases extraiga los componentes en común en una superclase. 

* Las entradas del programa son las dos clases que se deben analizar y el nombre de la superclase que se desee crear.
* Debe buscar componentes en común, esto es:

 * Variables de instancia con el mismo nombre.
 * Métodos iguales, es decir, con el mismo código fuente (`#getSource`).
* Y se deben hacer las siguientes modificaciones:

 * Crear una nueva clase con el nombre indicado y las variables comunes.
 * Mover los métodos de ambas clases a la nueva superclase.
 * Modificar las dos subclases originales, cambiándoles la superclase y eliminando las variables comunes (por razones técnicas, es necesario que estos dos pasos se hagan juntos. Es decir que al mismo tiempo cambiamos la herencia y eliminamos las variables.)
* Deben proveer algunos tests para verificar su código.

#### Forma de entrega
Por el formato de este TP, no conviene hacerlo en papel como los anteriores. Tenemos dos opciones:

* Para los que quieran, lo vemos durante la clase, personalmente. Creo que esto es lo mejor en la medida que nos alcance el tiempo.
* Como alternativa, me lo pueden mandar por mail, hacen fileout del package y me mandan el .st

#### Ayudas


* Pueden tomar como base el ejemplo visto en clase (instrucciones para bajarlo en el apartado anterior).
* Para testear, van a tenere que generar clases de prueba, que se van a romper en cada refactor. Para regenerar esas clases, les puede servir el `ScriptBuilder` que mostré en la última parte de la clase.
La documentación para utilizar el ScriptBuilder está aquí: [https://sites.google.com/site/proyectouqbar/nuestros-proyectos/script-builder](https://sites.google.com/site/proyectouqbar/software/script-builder)

#### Opcionales

Hay dos tareas interesantes con las que pueden jugar opcionalmente. La idea es que sean un poquito más desafiantes, involucran un poco de creatividad o de investigar cosas que no vimos en clase (y por eso son opcionales, si les resultan demasiado complejas simplemente ignórenlas).

* La primera es no utilizar el framework de reflection de Pharo directamente y en cambio utilizar el Refactoring Browser (que viene con el propio Pharo). Eso nos permitiría construir un refactor más "profesional". No tengo un tutorial de cómo hacer refactors de esta manera, así que les queda un poco como desafío, aunque obviamente estoy disponible para responder preguntas.

Como ayuda, pueden mirar los refactors que ya vienen con el Pharo (en el package `Refactoring-Core-Refactorings`) o el refactor que yo hice y que mostré en clase
Esto último se baja (via Monticello) ejecutando el siguiente script en un workspace:


        Gofer it squeaksource: 'DeRBIS'; package: 'ConfigurationOfDerbis'; load.
        (Smalltalk at: #ConfigurationOfDerbis) loadBleedingEdge

* La segunda es mejorar la idea de "dos métodos iguales", por ejemplo, si dos métodos difieren sólo en sus variables locales podríamos considerarlos iguales. Queda a iniciativa de ustedes proponer otras ideas que refinen el concepto de igualdad para métodos.