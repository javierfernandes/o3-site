---
title: "te-smalltalk"
date:  2018-06-20T19:27:10-03:00
---


Vamos a utilizar un dialecto de Smalltalk llamado Pharo. 
Para instalar Pharo Smalltalk recomiendo seguir las instrucciones de [esta página](http://pdep.com.ar/Home/software/software-pharo) (ignoren todo lo que diga "Object Browser", eso no nos aplica a nosotros).

#### Breve introducción al Pharo Smalltalk


(Esta intro es producto de las notas de una clase, sirve como repaso de lo visto en el aula. 
Para el que nunca vio Smalltalk y se perdió la explicación... le va a resultar un poco escueto.)



Para comenzar a jugar con ***Pharo* **conviene familiarizarse con los diferentes browsers, que sirven para inspeccionar el ambiente: class browser, hierarchy browser, implementors, etc. También podemos abrir un workspace y evaluar un poquito de código.


Una particularidad de Pharo es que **las variables no tienen tipo**, es decir que no se hacen checkeos de tipos, como hace por ejemplo el compilador de java. En todo momento puedo mandarle cualquier mensaje a cualquier objeto y recién en el momento de ejecución se verá si el objeto lo entiende o no. De hecho, en caso de no entenderlo, tiene un mensaje propio llamado `doesNotUnderstand` que también se podría redefinir.
Al no existir chequeos *estáticos*, se tiene **polimorfismo ****sin necesidad de explicitar una interfaz o una superclase en común**, como pasa por ejemplo en Java. El único requerimiento para poder tratar polimórficamente a dos objetos es que ambos entiendan el mensaje que les queremos mandar.

Smalltalk plantea el objetivo de tener una **sintaxis simple que intenta emular el lenguaje natural**, minimizando la utilización de símbolos especiales (como llaves) y poniendo énfasis en la legibilidad.
A diferencia de otros lenguajes, como Java, Smalltalk tiene **interfaces**** ricas**, es decir que las clases tienden a entender muchos mensajes. Por ejemplo, las colecciones ordenadas entienden los mensajes first, second, etc; esos mensajes no son indispensables porque su comportamiento pueden ser emulado como at: 1, at: 2, etc. Esto es consistente con la política de incrementar la legibilidad.

Hay diferentes tipos de mensajes: 

* **unarios:** mensaje sin parámetro (nombre con letras)
* **binarios:** mensaje (con símbolos no alfabéticos) + parámetro
* **keywords o mensajes de palabra clave:** receptor + varios parámetros (con nombre). Ej: *unaCollection at: 3 put: elemento*.


Los mensajes unarios tienen mayor precedencia que los binarios, y estos que los de palabra clave. Sin embargo **NO hay precedencia matemática**, y si evaluamos una expresión como 3 + 4 * 5 encontraremos que nos da 60 y no 23 como normalmente esperamos. Para solucionar esto es necesario utilizar paréntesis.
**No hay estructuras de control**, todo es un **mensaje**; `true` es un objeto boolean que entiende el mensaje `ifTrue:`. También los **operadores** como `>`, son mensajes, que retornan el objeto `true` o `false`. 
De la misma manera, no hay estructuras repetitivas, en cambio se utilizan mensajes. Por ejemplo, existen múltiples mensajes que permiten operar con el conjunto de objetos en una colección, como ser `do:`, `allSatisfy:`, `anySatisfy:`, `collect:`, `select:`, `reject:` entre otros. 
Todos estos mensajes reciben bloques por parámetro, que representan las acciones a realizar. Los bloques, por supuesto, son objetos y se pueden manipular como cualquier otro objeto; por ejemplo, se pueden pasar por parámetro, para ejecutarse luego.

Por último destacamos un syntactic sugar denominado **"cascadeo de mensajes"**, que permite enviar sucesivos mensajes a un mismo receptor a través del caracter "punto y coma" (;). Vimos el mensaje **"yourself"** que permite terminar las cascadas devolviendo el receptor.