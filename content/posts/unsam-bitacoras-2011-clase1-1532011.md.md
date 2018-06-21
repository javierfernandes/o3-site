Arrancamos 7:25 (gracias a un pequeño inconveniente con el hecho de que competimos con 2 otras materas :), viendo una intro a la materia. Definimos que ibamos a ver "herramientas", pero cognitivas, conceptos, que son los que perduran.

Hicimos referencia a este google site. 

Definimos que la forma de evaluación de la materia es puramente basada en las prácticas, con 3 Trabajos Prácticos:

1. Traits en smalltalk, con fecha de entrega 26/4
1. Reflection y Metaprogramación en java y en smalltalk, con fecha 24/5
1. TP a definir, con fecha 21/6

Les contamos que vamos a trabajar con [la Máquina Virtual de la materia](te-virtualmachine) que ya contiene todos entornos para trabajar sin perder tiempo en complejidad accidental de instalaciones y configuraciones.

Dijimos que en principio vamos a estar trabajando los martes. Los jueves los trataremos "on-demand", para despejar dudas, o si hace falta, para recuperar algún tema si nos atrasamos. La planificación de la materia está en [esta página](unsam-planificacion).

Mencionamos las unidades de la materia, que se encuentran en definidas en el [Temario](temario), y dimos una breve descripción de cada una.

Luego de toda esta introducción entramos ya en la **primer unidad** a las 7:40.

Arrancó Esteban contando, como introducción, los **orígenes de la OOP**, con simula y smalltalk. El concepto de encapsulamiento, que nos da capacidad de abstracción, con lo cual podemos separar los problemas en unidades "no tan" dependientes que permiten mayor flexibilidad ante cambios.

Vimos que las **clases** son **"una" forma de compartir código**, pero **no necesariamente la única**. A lo largo de la cursada de la materia, justamente vamos a ver qué limitaciones tiene, y qué otras formas existen para modelar esto, y salvar las limitaciones.

Hicimos hincapié en la importancia de los mensajes en el paradigma, y no tanto en las clases. Repasamos que el ambiente es básicamente un conjunto de objetos interactuando a través de mensajes.

Luego, a las 8 arrancamos con **Smalltalk**.

Vimos que básicamente todo es un objeto, y que existe el concepto de **"ambiente de ejecución"**, como una especie de mundo donde viven nuestros objetos todo el tiempo, que se persiste (perdura a lo largo del tiempo, luego de "cerrar" y volver a abrir el pharo).
Dimos mucha importancia a esta idea de **ambiente "vivo"**, que nos permite inspeccionar en cualquier momento el estado de los objetos, e interactuar con ellos.
Esto es importante, porque **rompe la idea de fases o ciclo de desarrollo tradicionales** que existe en lenguajes que provienen de la rama de ALGOL, como C, C++, java, etc, donde existe las fases de: escritura de código, compilación, empaquetado y ejecución.

Esto convierte al programador en un usuario más del ambiente, en la misma forma en que el usuario final también interactúa con los objetos (indirectamente a través de una UI, etc.).

Después arrancamos ya a jugar con **Pharo**. 
Vimos los diferentes browsers, que sirven para inspeccionar el ambiente: class browser, hierarchy browser, implementors, etc. Y evaluamos un poquito de código.

Luego, 8:20 nos metimos completamente a ver una **descripción del lenguaje**.

Vimos que tiene tipos, pero no así sus variables. Es decir que no se hacen checkeos de tipos, como hace por ejemplo el compilador de java. Entonces, los mensajes se evalúan dinámicamente, realmente se intenta enviar el mensaje, en tiempo de ejecución, y ahí se verá si el objeto lo entiende o no. De hecho, en caso de no entenderlo, tiene un mensaje propio llamado "doesNotUnderstand" que también se podría redefinir ! :)
Esto se llama **late binding** y vamos a profundizarlo en la [siguiente clase](conceptos-tipos-binding).

Contamos que al no existir tipado de variables ni checkeos, se tiene **polimorfismo, sin necesidad de interfaces** (en contraposición con java). Cuando dos objetos entienden el mismo mensaje (en tiempo de ejecución), se dice que son polimórficos, y ya.

Vimos que el objetivo de la **sintaxis** es de ser simple, y natural.

Smalltalk tiene **interface**** ricas** con muchísimos mensajes a diferencia de lenguajes como java.
Vimos que en smalltalk **no hay estructuras de control**, todo es un **mensaje**. Que "true" es un objeto boolean que entiende el mensaje "if". Los **operadores** como mayor ">", son mensajes, que retornan el objeto "true" o "false" (únicas instancias en el sistema).

Vimos que hay diferentes tipos de operadores: 

* **unarios:** mensaje sin parámetro 
* **binarios:** mensaje (aritmético o comparativo) + parámetro
* **keywords:** receptor + varios parámetros (con nombre). Ej: *unaCollection at: 3 put: elemento*.

Jugamos con la precedencia de los operadores (mensajes en realidad). Vimos que **NO hay precedencia matemática**, porque todo es un mensaje!
La **solución** es **utilizar paréntesis** para hacer explícita esa precedencia.
Los operadores unarios tienen precedencia sobre los operadores binarios.

Vimos que los **bloques**, **son** en realidad **objetos**! Se pueden manipular como cualquier otro objeto. Por ejemplo, se pueden pasar por parámetro, para ejecutarse luego.

Ya casi al final, vimos que las** colecciones,** obviamente también son objetos! Y las **vinculamos con los bloques**, ya que tienen muchos mensajes que se basan en el uso de estos, para operar sobre ellas. Esto nos da un gran poder en el manejo de colecciones y un alto nivel de declaratividad (que vamos a profundizar en la última unidad).
Básicamente el lenguaje no tiene sentencias de control, como for, while, do en java. En su lugar, esto se logra con mensajes y bloques en las colecciones.

Y por último vimos un sintax sugar llamado **"cascadeo de mensajes"**, que permite enviar sucesivos mensajes a un mismo receptor. A través del caracter "punto y coma" (;). Vimos el mensaje **"yourSelf"** que permite terminar las cascadas devolviendo el receptor.

Finalmente nos fuimos antes de que nos echaran o nos dejaran dentro de la facultad hasta el otro día :)


### []()Presentación

Se puede bajar la presentación que se usó aquí: 
[Unidad 1 - Esquemas de tipado](conceptos-tipos-binding)

### []()Referencias

Algunos **referencias** que hicimos:

* **Alan Kay:** quien inventó el concepto de OOP.

* **Dan Ingalls:** ingeniero que trabajó junto a Alan Kay en Smalltalk.
* **Simula 68:** primer lenguaje con un tinte objetoso.
* **Smalltalk** 72, 78 y 80

### []()Tareas

* Hacer andar la VM
* Jugar un poco con el Pharo
* (para dentro de 15 días) jugar con las colecciones de ST y comparar con CollectionUtils.