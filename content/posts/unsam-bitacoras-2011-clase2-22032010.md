---
title: "unsam-bitacoras-2011-clase2-22032010"
date:  2018-06-20T19:27:10-03:00
---


### []()Sistemas de Tipos


#### **[]()¿Qué es un tipo?

* conjunto de valores o "elementos de ese conjunto"
* conjunto de operaciones que puedo realizar sobre ellos

Ej: Números: 1, 2, pi,

Y en objetos ?
La primer idea es matchear un tipo con una clase.
Pero no es la única idea de tipos en OOP. Porque un objeto puede implementar **varios tipos**.

#### **[]()Sistema de tipos en Java:
Tipo las variables. Ej: Perro perro
Me agrega restricciones. Por ejemplo, Perro perro = new ArrayList<Object>(); 

Establece un contrato entre

* el que asigna la variable.
* el que luego la usa.

¿Con qué objeto?

1. Detectar errores
1. Como documentación o guía
1. En función del tipo, en algunos casos, puede cambiar el comportamiento (polimorfismo).


### []()Tipado-No Tipado, Débilmente/Fuertemente Tipado, Estático/Dinámico
Categorizaciones de lenguajes, ambiguas, o parciales.

Cuál es son las categorizaciones más precisas entonces ??

* **Checkeo**



 * Dinámico: no es que no hace checkeos, los hace al momento de ejecutar!


 * Estático: se hace en tiempo de compilación.

* **Tipado & polimorfismo
**



 * Explícito: en java tienen que tener un tipo en común
 * Implicito: en smalltalks solo deben entender el mismo mensaje (en runtime)

  * Existen lenguajes implícitos pero igualmente CON checkeos: Haskell, Scala, etc.

* Definiciones de Tipos:

 * **Nominales: **tienen que ser explícitos

 * **Estructurales** pueden explícitos o implícitos.
Ejemplo:
Puedo tener checkeos estructurales en scala (duck typing)

Ahora definimos los lenguajes según estos criterios:

* **Java:** Estático, Explícito y Nominal.
* **Smalltalk:** Dinamico, Implicito y Nominal.
* Haskell: Estático, Implícito (inferencia de tipos)


### []()Binding/Dispatch
Es la relación que se establece entre el envío de un mensaje y el momento en que se ejecuta. Nos interesa diferenciar en qué momento se produce, si se produce en tiempo de compilación lo llamamos *early binding*, si se produce en tiempo de ejecución lo llamamos *late binding*.

* Mismo mensaje a diferentes objetos

 * late
 * dinámico
 * polimórfico
 * method look-up, en cuanto al RECEPTOR

* Mensaje: mismo nombre, pero diferente parámetro

 * Estático
 * **Sobrecarga**

 * NO polimorfismo
 * NO method  look-up (porque no se hace en cuanto al PARAMETRO)
* Clases

 * En java los métodos de clase no tienen binding dinámicos (static)
 * En smalltalk las clases son objetos y sus métodos son polimórficos.


### []()Tareas:

* Pharo by example
* Comparar collection utils de java con smalltalk
* En la página de la [Unidad 1](conceptos-tipos-binding) hay algunos links con material para leer.