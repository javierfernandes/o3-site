---
title: "Criterios de Evaluación"
date: 2018-09-07T11:54:45-03:00
---

# En cuanto al tema principal

A la hora de evaluar en general cualquier Trabajo Práctico de la materia vamos a tener en cuenta los siguientes aspectos de la solución/diseño implementado:

* **Compresión y dominio del tema central del TP:** poder fundamentar la decisión de su uso (o no uso) en ciertas partes del diseño. Ej usar mixins para modelar cierta problemática. O no, haber decidido usar herencia o composición y por qué !? El "por qué es fundamental !
* **Aplicación del tema central:** es decir haber podido "bajar" a un programa ejecutable los conceptos aprendidos. Esto quiere decir que si comprendiste "la idea general" (de mixins o FP, etc) pero no pudiste expresarlo en un programa, entonces hace falta práctica, ejercitación o bien despejar cierta duda de implementación. Es bastante común que esto también refleje una idea de compresión erronea (_"ahh.. creí que lo había entendido pero en realidad no"_)

# En cuanto al diseño en OOP en general

Ahora bien, como estamos en una materia OOP, no vamos a dejar de lado las buenas prácticas y modelado de objetos en general. Es decir que vamos a evaluar:

* **Separación consciente de responsabilidades**: de nuevo, decisiones de diseño, y poder fundamentar por qué así y por qué no de otra manera. Separamos responsabilidades entre objetos mediante delegación. 
* **Encapsulamiento del estado**.
* **Modelado centrado en el comportamiento**: pensamos en mensaje y no en manipulaciones de datos. Estas existen, pero están encapsuladas en los objetos.
* **Tell, don't ask**: delegación. Los objetos son "vagos", no queremos "sacarle" datos a otros objetos para tomar una decisión sobre esos datos. Preferimos "decirles" que lo hagan ellos. Ej en lugar de `if (usuario.esVip) usuario.cobrar(precio - 10) else usuario.cobrar(precio)` preferimos `usuario.cobrar(precio)` y correr esa decisión hacia el usuario. Luego podemos usar polimorfismo para modelar la idea de usuarios VIP, en lugar de que sea un "dato".
* **No duplicación de código**: porque demuestra dos capacidaddes fundamentales: a) el dominio y buen uso de las herramientas que disponemos para reutlizar código (herencia, composición, mixins, etc), b) la capacidad de abstracción, ya que para reutilizar tenemos que definir QUE es lo que reutilizamos, léase darle nombre, darle una responsabilidad, entradas, salidas, efectos, etc.
* **Diseño de abstracciones consistentes**: quizás sea repetitivo con la idea de tomar decisions conscientes (por enésima vez), pero un buen diseño es consistente, en cuanto a que no existe una forma de usarlo en la cual producirá efectos inesperados o bien producirá interpretaciones incorrectas. Un ejemplo concreto de esto es el "antipattern" de subir a la superclase o a una interface mensajes que sólo tienen sentido para una implementación en particular y que si los uso sobre otra produce un mal efecto o inesperado. Peor aún cuando hacemos esto con estado (variables de instancia sólo utilizadas por ciertas subclasses).
* **Patrones de Diseño**: los patrones de diseño no son más que ejemplos de todo lo que mencionamos (separación, tell dont ask, no duplicar, encontrar abstracciones, etc) para solucionar problemas recurrentes/comunes. Con lo cual es altamente probable que aparezcan en nuestros TPs. Entiéndase que no nos interesa evaluar un patrón en particular, si lo implementaron tal cual el libro, o que lo sepan de memoria. Todo lo contrario, el verdadero entendimiento del patrón de diseño se basa en comprender cómo utiliza las herramientas del paradigma+lenguaje para solucionar el problema. Con lo cual uno debería poder resolver un problema de esa forma aún sin conocer el patrón (idealmente, si se domina OOP)

# Uso de Colecciones

En cuanto al uso de colecciones, tenemos que entender que no escapan a las ideas de objetos que mencionamos antes. Una Lista en Scala es mucho más que un simple array en C. Entiende mensajes (y muuuuchos) ricos que modelan patrones de uso.
Acá algunos tips

* `foreach`: este método es tal vez el más genérico, es "hacer algo con cada elemento". Por ende, es el más peligroso (idem la sentencia `for`). Con lo cual uno al usarlo debería SIEMPRE preguntarse si no existirá otro método más específico para lo que estoy haciendo. En particular te tiene que hacer mucho ruido si necestás declarar variables de instancia "por fuera" del foreach y luego mutarlas ahí dentro. Es muy probable que puedas reemplazar esta llamada por una de más alto nivel como un `map`, o `filter` o ambas juntas
* **Pipeline**: las colecciones ricas de OOP permiten pensar en forma inmutable y modelar la lógica sobre ellas como "transformaciones" que se encadenan. Por ejemplo, queremos obtener la menor edad de los mayores de 18 años. Lo podemos pensar como: 1) filtramos los que son > 18 2) mapeamos a una lista de edades 3) seleccionamos la mínima. Sería algo como `personas.filter(p => p.esMayor()).map(p => p.edad).min()`
* **Bloques en los métodos ricos (map, filter, minBy, maxBy, etc)**: éstos métodos nos sirven para transformar las colecciones lo cual es bueno como ya dijimos. En su uso no tenemos que olvidar la idea de "tell don't ask". Es decir que dentro de un filter no está bueno escribir un bloque enorme que le saca todos los "datos" al objeto para armar una condición, lo cual lo hace ilegible y omite modelar una abstracción como un mensaje. Ej filtrar personas en edad activa de trabajo (18 y 65, ponele). En lugar de `personas.filter(p => p.edad >= 18 && p.edad < 65 && p.puedeTrabajar === true)` preferimos `personas.filter(p => p.esTrabajadorActivo())` 

# En cuanto a la forma

Por último hay ciertos elementos "concretos" que exigimos en las entregas

* **TestsCases:** No queremos tests que testeen getters y setters, o funcionalidad trivial (criterio acá). Queremos testear comportamiento, y más aún colaboraciones. Tests demasiado unitarios (un único método, una única clase, etc) tienden a caer en testear lo trivial y escapar al testeo de las interacciones. Queremos tests que armen escenarios complejos del dominio, y prueben interacciones particulares. En los tests también hay que mantener los criterios de "buen código" que empleamos en el código base.
* **Formato de Código**: parece un detalle, pero el código es la forma en la que nos expresamos, y plasmamos las abstracciones que encontramos del problema. También es nuestro "espacio de trabajo" o elementos de trabajo. Como la caja de herramientas de un carpintero, mecánico etc. Si nuestro código no es consistente con el formato, cuesta mucho más su compresión, por un tema de percepción visual. Requiere un esfuerzo "extra" para ordenar los símbolos, las palabras, las sentencias, lo cual nos desvía de la compresión de la semántica del programa.
* **Separación de código**: evitar 1 único archivo enorme con todo el código. Separar en paquetes y/o archivos bajo un criterio consciente que haga más fácil su comprensión y extensibilidad.
* **Prolijidad, orden, comentarios, etc**: Similar a lo anterior, evitar código comentado (para eso usamos Git), evitar múltiples espacios inconsistentes colgados entre el código. Mantener un orden consistente (ej.. en las clases, variables de instancia primero, luego constructores, y luego métodos)

# En cuanto a la nota

La nota de la evaluación corresponde al análisis de todos estos criterios que mencionamos aquí arriba. Es evidente que no existe un algoritmo que pueda asignar una nota determinística dado un TP. De otra forma tendríamos un programa que corrija los TPs por nosotros. Y en un punto no sería necesario tener profesores a cargo de un curso. Con lo cual sí, la nota es subjetiva, como en toda materia, y depende del criterio del docente. Lo que sí debe estar bien definido (y por eso toda esta página enorme) son los lineamientos o lo que esperamos del TP. Luego habrá aspectos subjetivos de la evaluación que también se refieren a conductas en la presentación, evaluación y cursada en general. Ya que no somos máquinas sino personas sociables que interactuamos con otros a la hora de realizar los TPs, y luego en un trabajo "real". Por esto no podemos descuidar este tipo de cuestiones sino incluirlas.
Aclarado todo esto, siempre que sea haga desde el respeto y con el interés genuino de comprender los errores (y no de compararse o competir con otros), estamos abiertos a explicar y discutir los puntos que determinaron la nota.
