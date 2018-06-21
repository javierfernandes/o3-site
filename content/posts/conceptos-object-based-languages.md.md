## []()Introducción

Vamos a ver una nueva forma de modelado con objetos, que también nos va a mostrar una alternativa a la programación tradicional orientada a objetos (asociando código a las clases). Como ya vimos existen múltiples problemas que no pueden ser atacados elegantemente mediante la clasificación y la herencia (ver [Mixins](conceptos-mixins), [Traits](conceptos-traits) y [Aspectos](conceptos-aop)), al hacerlo nos vemos obligados a repetir código. Hay porciones de código que no podemos reutilizar.


Las clases no son la única forma de pensar la programación orientada a objetos. **Una desventaja de las clases es que muchas veces nos llevan a pensar en la estructura y no en el comportamiento**. Modelos como el UML colaboran para que nos focalicemos en los diagramas de clases (vista estática del sistema) y en la estructura.


## []()Ambientes sin Clases

Se denomina un ambiente object-based aquel en el que no hay clases y por lo tanto **todo el comportamiento de los objetos está definido en base a los propios objetos**. Lo único que existe en el sistema son objetos. 


Existen ambientes como los de Smalltalk en los que todo es un objeto (incluyendo las clases) pero aquí todos los objetos son iguales, **no hay objetos "especiales"** (como las clases en Smalltalk.



El comportamiento definido en los propios objetos nos permite lograr todos conceptos que en los ambientes tradicionales son logrados por las clases. Al poder definirle el comportamiento a cualquier objeto, podemos lograr que este se comporte como una clase, mixin o trait, podemos tener herencia simple o múltiple. Todos estos comportamientos son logrados simplemente dándole la forma adecuada a nuestros objetos; no necesitamos que el lenguaje provea nada especial para poder hacerlo. **De hecho, se pueden lograr* muchas más variantes *que en los ambientes tradicionales no serían posibles. **



#### **[]()¿Qué lenguajes incorporan estos conceptos?

El lenguaje más tradicional en el que se definió el concepto de object-based es **[Self](te-self)**. En su momento Self fue un proyecto revolucionario no sólo por su concepción sin clases sino por su virtual machine que incorporó ideas muy novedosas (que son las que permitieron que hoy en día muchos lenguajes utilicen VMs). Pero hoy en día el proyecto Self no tiene mucha actividad y hay otros lenguajes que lo han ido superando en diferentes aspectos. 


Desde hace varios hay un lenguaje muy popular que es object-based: [Javascript](conceptos-object-based-languages-prototipos-en-javascript). Nosotros vamos a utilizar un lenguaje muy nuevo llamado [Ioke](te-ioke) porque nos parece que tiene algunas características que lo hacen muy interesante (incluso varias ideas novedosas que van más allá de la programación object-based).


#### **[]()¿Y quién cumple la función de las clases si no existen ?

Dado que no existe la noción de clases ni de herencia para la clasificación y/o reuso, necesitamos otros mecanismos para crear objetos y para compartir comportamiento. Recordemos que las clases cumplen esas dos funciones, por un lado son creadoras de instancias, y por el otro permiten modelar abstracciones definiendo tipos y comportamientos compartidos entre las instancias de ese tipo.

Para eso en lenguajes de objetos sin clases:

* La **creación** se basa en la clonación de objetos (denominados **prototipos**).
* El mecanismo para compartir código se basa en la **delegación automática**, (y luego sobre ésta la idea de **traits o mixins**)

#### **[]()¿Cómo se crean objetos si no tengo clases?

La ausencia de clases obliga a pensar en otra forma de crear un objeto. En general existen dos formas:


* **Clonando** un objeto ya existente.
* Creando un objeto **"literal"** (similar a crear un objeto vacío, o como cuando escribimos un string en el código o un número).


La forma de crear un objeto es **clonando** (copiando) otro objeto ya existente. Un **prototipo** es un ejemplo de un objeto del cual puedo crear muchas copias. Así como el patron de diseño creacional [Prototype](http://www.oodesign.com/prototype-pattern.html).


Dependiendo del lenguaje, puede que esta idea de crear objetos según un prototipo esté bien explícita o no. Por ejemplo en ***Self*** uno **copia**/**clona** un objeto.Y una vez copiado el objeto no tiene nada que ver con el prototipo y puede ser modificado arbitrariamente (ambos, el prototipo y el nuevo objeto, sin que se alteren entre sí).

En cambio en ***Ioke*** no es necesario clonar/copiar, porque el mismo mecanismo para compartir comportamiento permite evitar esto.




#### **[]()¿Cómo se define el comportamiento?

Bien, vimos que copiando objetos yo podría reutilizar la definición de un objeto. Por ejemplo, primero creo un primero objeto Persona, le agrego todos sus slots, y finalmente para utilizarlo con personas concretas concretos, lo clono.
Esto copia el estado, pero también los métodos.
Entonces es un mecanismo algo "precario" para compartir código. Porque en realidad estamos "copiando" el código, y no compartiéndo una misma definición.
Entonces, existe un mecanismo más poderoso, llamado **delegación automática.**

La idea es que en lugar de copiar/clonar el objeto template u original, creamos uno nuevo, y le decimos *"vos te vas a comportar como él"*.
En nuestro ejemplo diríamos que el nuevo objeto, **"arturo"** supongamos, se comporta como una Persona. Que quiere decir que todo el comportamiento que tiene Persona va a estar disponible en este nuevo objeto.
Persona pasa a ser **parent** o **mimic **(depende el lenguaje el nombre que se le da) de Arturo.

Al enviarle el mensaje "caminarHacia(lugar)" a Arturo, si el mismo objeto Arturo no tiene un método, se va **delegar el mensaje** al objeto parent. Así, si Persona entiende caminarHacia, todos los objetos que lo tengan como parent/mimic van a poder reutilizarlo.
Porque el mensaje se va a ejecutar teniendo al objeto concreto como **contexto**.

A este mecanismo se lo conoce como **delegación automática.** Es lo que en lenguajes con clases hacemos al trabajar con composición y delegación en lugar de herencia. Con la diferencia de que en esos casos tenemos que codificar la delegación nosotros mismos. Y por otro lado no es tan poderosa, porque se "pierde" el contexto del objeto original que recibió el mensaje inicialmente.
## []()Ejemplos con lenguajes 


En un principio en la materia utilizábamos Self como lenguaje para explicar y mostrar estas ideas de objetos sin clases. Luego pasamos a Ioke que evita algunas complejidades de la interfaz gráfica de Self, y por otro lado tiene algunas ideas más modernas.
Así que en estas páginas de cada lenguaje se pueden ver estas ideas aplicadas:
* [Ioke](te-ioke)
* [Self](conceptos-object-based-languages-self)
* [Prototipos en JavaScript](conceptos-object-based-languages-prototipos-en-javascript)

## []()Otros lenguajes con prototipos




* Slate
* Io