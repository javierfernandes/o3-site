---
title: "conceptos-mirrors"
date:  2018-06-20T19:27:10-03:00
---


### Introducción
Mirrors se refiere a un conjunto de ideas de diseño aplicadas a la creación de un "framework" de reflection y metaprogramación para un lenguaje dado.
Algunas de estas ideas, no son más que aplicaciones directas de lineamientos ya conocidos de diseño de objetos o en general, como: encapsulamiento, separation of concerns, etc.

*Traducción:*
Imaginen que tiene que diseñar el API de reflection de un lenguaje. Estas personas analizaron las APIs existentes en distintos lenguajes, y utlizando principios de diseño generales, plantean un modelo de esa API, que tiene una serie de ventajas sobre los existentes.

La idea surge a partir de un paper de [Gilad Bracha](http://bracha.org/Site/Home.html) y David Ungar. Este último, uno de los creadores del lenguaje [Self](te-self).
De hecho, Self, tiene una implementación de mirrors para el manejo de reflection y metaprogramación.



### Intro a Metaprogramación
Antes de arrancar con mirrors conviene haber leído el apunte de [metaprogramación](conceptos-metaprogramacion).


### Ideas para el diseño de una API de reflection o metaprogramación

* **Encapsulamiento:**


 * Interfaz e implementación.
 * Permite tener diferentes implementaciones. Acá podrían existir varios motivos o aplicaciones, por ejemplo: aplicaciones distribuidas

* **Estratificación**


 * **modelo vs meta-nivel:** que no se mezclen

  * En **smalltalk** las clases tienen **dos roles** de diferentes niveles:

   * comportamiento **de aplicación** (métodos de clase)
   * comportamiento **de reflection** (obtener los métodos, etc).

  * object.getClass() FEO !!
  * object instanceof FEO !!
 * Permite desactivar/remover reflection (No me parece la ventaja principal)

* **Correspondencia Ontológica:**


 * Capacidad del API de reflejar todos los elementos del lenguaje en forma completa.


### 


### Correspondencia Ontológica

#### **[]()Correspondencia Temporal
 
* **Correspondencia Temporal:**


 * elementos del lenguaje en **tiempo de compilación (no ejecutables)
 **


  * Clases,
  * métodos
  * códigó en general
 
 * elementos del lenguaje en **tiempo de ejecución** **(ejecutables)**

 

  * ejecutar un método
  * obtener el valor de los fields
  * etc.
 * Estos elementos **deberían estar "separados"** en diferentes API's para poder ser utilizados independientemente.
 * Ejemplo radical, pre/post condiciones (como en Eiffel), permitirían a una interfaz de usuario validar parámetros o inputs sin siquiera ejecutar los métodos. Esa separación es sana, incluso validaciónes que no dependen de la instancia (digamos, como "de clase") permitirían realizar validaciones mucho antes de tiempo, sin necesidad de crear objetos inconsistentes o deshechables.
 

#### **[]()Correspondencia Estructural
 
* **Correspondencia Estructural:** Se refiere a la capacidad del API de modelar y reflejar todos los elementos del lenguaje:

 * **code: **elementos del lenguaje en **tiempo de compilación,** "el código"

  * Útil para manipular código, como debuggers, workspaces (como en smalltalk), compiladores, etc.
  * Útil para aplicar transformaciones (intercession) en la traducción a "computation". Ej: javassist.

 * **computation**: los elementos del lenguaje vivos en tiempo de ejecución.

  * para el tipo más común de reflection que manejamos.
 
 * Muchas veces no son iguales, y en tal caso debería existir un API para cada uno.

  * Ejemplo: javassist, AOP
* **VM Reflection vs High-Level Language (HLL) Reflection**


 * Separar en diferentes API's.
 * Que HHL reflection oculte detalles de implementación de VM reflection.

  * Ej: miembros sintéticos, inner classes y anónimas (conocen al $this de la enclosing instance)
 * Permite además tener varios lenguajes sobre una misma VM (ej: java). Cada lenguaje debería tener su API de reflection con su propia semántica.


### 


### Cosas interesantes a contar

* el hecho de que al usar nuestra propia API de reflection, podríamos

 * **adaptar conceptos** (semántica) **ya existentes** en el lenguaje, para que, no solo sean interpretados por las estructuras originales del lenguaje, sino también de **nuevas fuentes**. Ejemplo, para una clase de dominio "ServicioElectrio" obtengo su ClassMirror, le puedo pedir sus métodos, que serían MethodMirror. Este conjunto de métodos, podrían interpretarse de los métodos declarados y heradados en la clase java "ServicioElectrico", pero mi framework de reflection, podría no limitarse a eso, podría además obtener métodos definidos en otro lenguaje, como un lenguaje de scripting, o podría proveer la capacidad de definir **métodos externos** a la clase, por ejemplo como métodos static que reciban como primer argumento al ServicioElectrico (lo que sería el "this").
 * **agregar nuevos conceptos o semántica:**


  * por ejemplo, planteando la idea de que mis objetos no tienen métodos y fields, sino "propiedades" y "acciones".
  * agregando precondiciones sobre las "acciones", sobre sus parámetros, sobre la instancia misma, etc.
* **Otras características de los mirrors**:

 * son independientes del sistema de tipos
 * en general, el nivel de complejidad de los mirrors de un lenguaje dado, indica lo complejo que es el mismo.
* **Relación con AOP**: AOP está muy relacionado con estas ideas de diseño

 * depende de tener una MOP (meta-object protocol) o API que le permita manipular las estructuras de código en tiempo de compilación.
 * en particular, **aspectj,** 


  * define su propio lenguaje, con sus propias entidades (ente -> ontología -ciencia que estudia los entes-)
  * este lenguaje termina compilando al mismo lenguaje de la VM normal de java (bytecode)
  * sin embargo, aspectj provee además un API de reflection específica para su lenguaje (ej: **thisJoinPoint**)
  * Además, al participar en la compilación, permite, con su propio lenguaje definir transformaciones como el hacer que una clase implemente de una interface, agregar métodos, etc.