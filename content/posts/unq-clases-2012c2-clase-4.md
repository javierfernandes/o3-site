---
title: "unq-clases-2012c2-clase-4"
date:  2018-06-20T19:27:10-03:00
---


### Introducción

Arrancamos motivando el concepto de aspecto siguiendo el ejemplo de [Objetos Observables](conceptos-aop#TOC-Objetos-Observables) que nos llevó a pensar en la necesidad de **herramientas que nos permitan modelar conceptos transversales a la jerarquía de clases.** 


A menudo vemos que los ejemplos motivadores pasan por encontrar problemas que no pueden resolverse si *código duplicado.* El motivo es que entendemos que nos vemos obligados a escribir dos veces lo mismo simplemente porque no tenemos una herramienta para expresar esa idea en un único lugar y luego utilizarla. 
Si bien hay muchas maneras de lidiar con los problemas que supone la duplicación de código, muchas veces la duplicación esconde un motivo más profundo, que es la **imposibilidad de nuestras herramientas de modelado de capturar un determinado concepto como un elemento del modelo**.


Acá van algunos ejemplos*:
*
* Si quiero monitorear el uso de mis objetos. Ej: [Code Coverage](http://en.wikipedia.org/wiki/Code_coverage)

* Si quiero aplicar políticas de seguridad a nivel de objetos. Por ejemplo que ciertos servicios solo puedan ser invocados por ciertos roles de usuario.

* La funcionalidad de logging.

* La idea de "transaccionalidad".
* Los frameworks de persistencia proxean objetos para hacer lazy el acceso a la BD. Obviamente aplicable a cualquier tipo de objeto.

### Conceptos de Programación Orientada a Aspectos: Join-Point, Point-cut y Advice

Vimos luego los conceptos **core **del dominio de la **programación orientada a aspectos.**

Si bien vamos a ver aspectos con una implementación para java llamada **AspectJ** estos conceptos son abstractos y forman parte de AOP. Con lo cual serán comunes a todos los frameworks de aspectos.

* **Join-point: **representa un punto en la ejecución del código de mi programa que resulta interesante. Es decir, en el cual me interesaría saber que está ejecutándose. Por ejemplo: la asignación de una variable de instancia, o el llamado a un método.
* **Point-Cut:** es un conjunto de **join-point**s a fin de poder definir un contexto más complejo. Es decir que se combinan, varios point-cuts, ejemplos: asignaciones de variables llamadas "blah" en mis clases del paquete *objetos3.ejemplos *y para las clases anotadas con @MeInteresa.
* **Advice**: dado un **pointcut, **es decir un contexto de un punto de ejecución, representa una manipulación de ese código. Por ejemplo, poder agregar código antes y después de ese punto (**around)**.

Luego vimos un ejemplo de la syntaxis de AspectJ para definir un aspecto para loggear llamadas a métodos.
Ese ejemplo está en la [página del site](conceptos-aop)
### Weaving

Luego surgió la pregunta natural de "cómo hace la magia ?" (de interceptar el código y manipularlo).
Acá surge otro concepto de la programación de aspectos, que es el **weaving**.


Weaving es el proceso que utilizan los fwks de aspectos de código para implementar aspectos, es decir para manipular el código. Para **combinar** **el código del aspecto con la lógica base **(de nuestro dominio o clases a aspectear).
De ahí que el nombre en inglés significa **tejer**.


Enumeramos un par de estratégias de weaving:

* **Compilación: **modificando el compilador y utilizando uno custom. Ej: aspectj, phantom.
* **Classloader:** una vez cargadas las clases en java no se pueden modificar. Sin embargo, las clases las carga un objeto llamado ClassLoader y uno podría hacer el suyo propio, para, justo antes de cargar la clase, modificar su bytecode. Ejemplo javassist, [Apache Commons BCEL](http://commons.apache.org/bcel/)
* **Interception**: decora los objetos para interceptar los llamados. Ej: Spring AOP, [Java Dynamic Proxies](http://download.oracle.com/javase/1.3/docs/guide/reflection/proxy.html).
* **Preprocesador / Generación de Código: **analizo el código como texto, antes de la compilación. Ej: [Annotation Processing Tool APT](http://download.oracle.com/javase/1.5.0/docs/guide/apt/GettingStarted.html).
* **Metaprogramación (?)**

* **Debugging Hooks**


### Ejemplos en AspectJ

Luego nos metimos en directo a ver ejemplos en código de aspectj.
Vemos el primer ejemplo **simple **de objetos observables.


Luego vimos que el aspecto es de hecho un objeto, y que puedo obtenerlo y acceder a su estado o hasta invocarle métodos.
Mencionamos que ese aspecto que es un objeto tiene un **ciclo de vida **que define cuando se va a crear la instancia del aspecto y cuanto va a vivir. Esto puedo definirlo a través de **pertarget** y **perthis**. 


#### **[]()Ejemplo con Annotations

En segundo término vimos una forma alternativa de lograr el mismo resultado. Pero estableciendo un contrato entre los objetos a aspectear y el aspecto.
Acá el aspecto aplica solo a las clases anotadas con @Observable.
#### **[]()Ejemplo con Mixins

Vimos que define que los objetos anotados con @Observable ahora pasan a implementar una nueva interfaz.
Y el mismo aspecto le define las implementaciones de esos métodos, en forma parecida (conceptualmente) a la idea de **Open Class **que vimos en **Nice.**

**

**

### Material

* Página de la materia con teoría de [Programación Orientada a Aspectos](conceptos-aop)
* Página de la materia sobre la herramienta [AspectJ](te-aspectj)
* [Paper seminal de Gregor Kiczales](http://cseweb.ucsd.edu/~wgg/CSE218/aop-ecoop97.pdf) que introduce el concepto de AOP
* Una [introducción a AspectJ](http://www.dtic.mil/cgi-bin/GetTRDoc?AD=ADA417906), también de Gregor Kickzales y el resto del equipo en el Xerox PARC.


Los ejemplos vistos en clase se pueden encontrar en [http://xp-dev.com/svn/uqbar/examples/paco/trunk/aop/aspectj](http://xp-dev.com/svn/uqbar/examples/paco/trunk/aop/aspectj).