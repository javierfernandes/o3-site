---
title: "unsam-bitacoras-2011-clase3-29032011"
date:  2018-06-20T19:27:10-03:00
---


En esta clase continuamos con algunos puntos que nos habían quedado de las clases anteriores.

## Duck Typing
En la primer parte de la clase, continuamos el tema de Sistemas de Tipos. Específicamente vimos la idea de **duck typing en un lenguaje con checkeos en tiempos de compilación**, como **scala**.

*Scala* es un lenguaje que vamos a usar para varios ejemplos, que se compila y se ejecuta sobre la VM de Java. Tiene varios features interesantes que vamos a ir viendo para diferentes conceptos de la materia, pero hoy nos interesa el Duck Typing.

Vimos **ducktyping en general**, **a nivel de métodos**, definiendo un mensaje que espera recibir un parámetro definido por "entiendo el mensaje 'quack' y 'feathers'".

def inTheForest( duck : { def quack ; def feathers }) =  ...

Esta es una definición de tipos *"alternativa"* a la tradicional que usamos generalmente en lenguajes como java. Donde declaramos los tipos de las variables a través de un **nombre** de tipo *(de clase, interface, enum, annotation, etc... -uff cada versión de java se agregan más cosas ;))*. Y donde se asocian los tipos entonces, directamente a las clases.

Esta forma tradicional se llama **nominal**. Recordamos que en java, otra forma de salvar el polimorfismo es mediante las interfaces. Esto sigue siendo, igualmente **nominal.**


En cambio duck typing es básicamente una forma de declarar un tipo a través de definir la estructura (los mensajes que debe entender). Esta otra forma se denomina **estructural.

**Como segundo ejemplo vimos la implementación del **ejemplo **de código **de los animales** que habiamos utilizado la clase pasada, tanto en java como en smalltalk, pero en este caso **con duck typing**.
Vimos que scala también tiene generics en sus colecciones, y que los ducktypings también se pueden usar en esos generics.

Como **conclusión** vimos que este feature **no es exclusivo de lenguajes "dinámicos"** como smalltalk, o sin checkeos, y que **por el contrario** **pueden convivir en un lenguaje **fuertemente tipado, o mejor dicho **con checkeos en tiempo de compilación,** estáticos.
Entonces encontramos dos **diferencias** entre el tipado estructural de** Scala** y lo que teníamos en **Smalltalk:**


* Es **explícito**

* Se **chequea** en **tiempo de compilación.**



Lo interesante de **la intersección de estos dos features** (checkeos + ducktyping), es que nos** provee** el nivel de abstracción y **desacoplamiento de las clases** (de sus nombres), y por lo tanto la **flexibilidad**, pero **al mismo tiempo**, seguir teniendo los **checkeos** y la validación del programa en tiempo de compilación.

Finalmente, comentamos la idea de que este tipo de concepto, feature y/o herramienta, como varias otras que vamos a ver durante la materia, son en definitiva, todavía inmaduras, o novedosas, en el sentido de que aún no es claro su impacto o el resultado de experiencias a nivel masivo, o en el desarrollo de grandes sistemas de la industria.
 Esperemos ver a futuro como evoluciona esto, o aún mejor, si es posible hagamos nuestra propia experiencia probando, experimentando y analizando los resultados de nuestros propios sistemas utilizandolos :)



## TDD
Como segunda parte de la clase vimos el concepto de Test-Driven Development.
Que es básicamente una práctica que viene del mundo smalltalk, y bastante relacionada con las buenas prácticas de XP (extremme programming), que se refiere a la idea de:

* **comenzar** a implementar un nuevo requerimiento (user story, feature, etc.) **a través de escribir el testcase** *(definición de lo que debería hacer el sistema)*
* tratar de ***llegar al verde** ***lo más rápido posible**. Porque significa que ya tengo mi requerimiento implementado y funcionando de acuerdo a lo esperado.
* en el paso anterior lo importante es tener algo "andando", el famoso *"make it work"*. Una vez verde, ya nos pondremos a diseñar, y a modificar la implementación, para que se ajuste a nuestras buenas prácticas de diseño. Y esta es la segunda parte de la frase "make it right". Acá entra la idea de **refactoring**.
* Y luego el ciclo se repite.
Luego de las diapositivas, vimos un ejemplo práctico de TDD en smalltalk.

Otra cosa interesante de hacer los testcases primero es que, *en primera instancia **usamos** nuestras clases **antes de implementarlas***, entonces nos ayuda a concentrarnos en la interfaz, y no en la implementación de nuestras clases.

El punto de incluir TDD en esta materia, no era explicar esta práctica completamente, sino ver cómo se implementa en un lenguaje dinámico como smalltalk, donde uno puede ir construyendo desde el test, y a medida que se va ejecutando, ir creando y completando la aplicación. En otros lenguajes con checkeos nos va forzando a escribir mucho más código inicialmente, antes de correr el test.

Los slides de TDD se pueden descargar de acá: [Unidad 1 - Esquemas de tipado](../conceptos-tipos-binding)

## Bloques y Colecciones
Vimos un ejemplo simple en smalltalk utilizando el mensaje "collect"

#(1 2 3 4 5).collect: [n | n^2]  

Este mensaje devuelve una nueva collection que contiene cada elemento de la original "transformado" utilizando el bloque enviado como parámetro.

Vimos que Java no tiene bloques, pero lo más parecido que podemos hacer son clases anónimas. 
Y que existe una librería útil, del proyecto jakarta de apache, llamada collection-utils que "imita" estos features.

Aunque, no son mensajes a la lista, sino un método static, como una función.

Un bloque, se parece a una función.

Luego comparamos un poco los ejemplos de collect:

* en smalltalk
* en java con jakarta collection-utils
* en java con otra implementación de collection-utils + generics
Y en este caso en java vimos que empiezan a aparecer "problemas" o incomodidades con el hecho de tener tipos explícitos (no tener inferencia), en las variables, en la declaración de la clase anónima, en la declaración de los generics, etc.
Esto incrementa la cantidad de código considerablemente, y por ende, reduce la claridad.

Vimos que la idea de closure se refiere a la capacidad de los bloques de hacer referencia a un scope más amplio que él mismo, y por ejemplo hacer referencias a las variables disponibles en el scope del método donde lo crearon. Y no de quien lo está ejecutando (recuerden que los bloques se pasan como cualquier otro objeto, como parámetro).