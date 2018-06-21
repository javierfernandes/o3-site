---
title: "unsam-bitacoras-2011-clase6-19deabrilde2011-prototipos"
date:  2018-06-20T19:27:10-03:00
---


Vamos a ver una nueva forma de modelado con objetos, que también nos va a mostrar una alternativa a la programación tradicional orientada a objetos (asociando código a las clases). Como ya vimos existen múltiples problemas que no pueden ser atacados elegantemente mediante la clasificación y la herencia, al hacerlo nos vemos obligados a repetir código, hay porciones de código que no podemos reutilizar.


**Una desventaja de las clases es que muchas veces nos llevan a pensar en la estructura y no en el comportamiento**. Modelos como el UML colaboran para que nos focalicemos en los diagramas de clases y en la estructura.


Las clases no son la única forma de pensar la programación orientada a objetos.


#### **[]()Prototipos

En un ambiente de objetos basado en prototipos **lo único que existe en el sistema son objetos**, no hay clases. 


Existen ambientes como los de Smalltalk en los que todo es un objeto (incluyendo las clases) pero aquí todos los objetos son iguales, **no hay objetos "especiales"** (como las clases en Smalltalk.


La forma de crear un objeto es clonando (copiando) otro objeto ya existente. Un prototipo es un ejemplo de un objeto del cual puedo crear muchas copias. Estos prototipos nos permiten lograr todos los efectos que en los ambientes de objetos tradicionales son logrados por las clases, *y muchas más variantes *que en esos ambientes no estarían permitidas.


Una vez copiado el objeto no tiene nada que ver con el prototipo y puede ser modificado arbitrariamente.


Dado que no existe la noción de clases ni de herencia para la clasificación y/o reuso, necesitamos otros mecanismos para crear objetos y para compartir comportamiento:

* La **creación** se basa en la clonación de objetos (denominados **prototipos**).
* El mecanismo para compartir código se basa en **traits o mixins**.

El lenguaje que vamos a ver para ejemplificar esta idea se denomina **Self**.
#### **[]()¿Cómo se crean objetos si no tengo clases?

Hay dos formas de crea un objeto:

* **Clonando** un objeto ya existente
* Creando un objeto **"literal"** (similar a crear un objeto vacío).

#### **[]()¿Cómo se define el comportamiento?

El comportamiento y el estado (todo junto) de un objeto está dado por un conjunto de **slots**, que pueden ser de tres tipos:

* **"Data" slots**


 * **Constantes** (definidos con "=")
 * **Asignables** (definidos con "<-")
* **"Method" slots**


Todo lo que tiene el objeto son slots y todos los slots son intercambiables en cualquier momento, es decir, quien envía un mensaje no tiene por qué enterarse de si el slot que se está utilizando para resolver su mensaje es un data slot o un method slot.
#### **[]()Composición y reutilización

La forma de reutilización es a partir de lo que se denomina **parents** o **delegates**. Cuando un objeto recibe un mensaje que no entiende ese mensaje se reenvía a alguno de sus delegates, Para agregar un delegate a un objeto, en self se le agrega un slot que tenga sufijo "*".


**La estrategia para resolver conflictos es explícita**, es decir, si más de un delegate entiende un mensaje que llega a la cadena de delegación, entonces ese conflicto debe ser resuelto manualmente por el programador (utilizando un mecanismo similar al que se usaba para resolver conflictos entre los traits en Pharo).


No hay "super" (porque no hay herencia), pero en caso de necesitar invocar a un mensaje de un padre que se está sobreescribiendo en el propio objeto, esto se puede hacer mediante un **resend.**

**

**

**

**

También es muy importante el objeto **lobby**, que nos permite acceso a todos los objetos predefinidos del lenguaje (por ejemplo colecciones, strings, números). Es un objeto que es visible globalmente (está en la cadena de delegación de todos los objetos).


Algunos ejemplos básicos en Self

* `(). 
        Me devuelve un objeto sin slots


* (|a. b|)
        Un objeto con dos slots asignables a y b, que aparecen inicializados en nil.


* (|a = 42. b<-21. c = (error: 'no se puede')|)`
Me devuelve un objeto con un slot constante a = 42, uno variable b inicializado en 21 y un método en el slot c que manda el mensaje error:

Un problema que tenemos es que error: no es algo conocido, tenemos que agregarle un delegate que tenga el mensaje definido error:
El obejto más común con ese comportamiento tiene un nombre raro: oddball, y para agregar un parent podemos hacer así:

        (|
  parent* = traits oddball. 
  a = 42. 
  b<-21. 
  c = (error: 'no se puede')
|)

#### **[]()Un ejemplo un poco más complejo: Animales


* Para pensar este ejemplo arrancamos definiendo un objeto que representa a un pato, que entiende dos mensajes:

        caminar = (^ 'Camino con mis dos patas')
        nadar = (^ 'Nado un poco')

También le agregamos el delegate usual:

        parent* = traits oddball.` `


* A continuación queremos tener un cocodrilo, como tiene cosas en común con pato arrancamos copiándolo (le enviamos `clone`). Y modificamos el caminar:

        caminar = (^ 'Camino con mis **cuatro** patas')


* Pero el nadar es común, entonces podríamos tener ganas de crear un **trait**, creamos un objeto nuevo y movemos (botón derecho, "move") el método nadar a él. 

Luego ponemos ese nuevo objeto como parent de los dos anteriores (lo referenciamos mediante un slot llamado `acuatico*`)

Es muy interesante notar que **no se necesita una construcción especial para tener un trait**: *es simplemente un objeto* que pongo en mi cadena de delegación y tiene sólo el mensaje nadar (es importante que no tenga nada más). No hay diferencia entre los "objetos" y los "traits"


#### **[]()¿Por qué todas las ventanitas dicen "A slots object"?



Un problema que tenemos es que los tres objetos y los dos traits que creamos no tienen nombre, para eso tenemos varios pasos un poco burocráticos:

* Desde un shell (o algún objeto) agregar slots constantes denominados pato, perro y cocodrilo que referencien a los objetos que creamos antes.
* Agregar el objeto o shell al objeto globals (parent del lobby), con el nombre animales.
* Marcar  el slot animales como "creator" y a continuación lo mismo con los  objetos pato, perro y cocodrilo.

Al hacer eso podemos ver que cambiaron los nombres de las ventanas. Nuestro objeto o shell pasó a denominarse "animales" y los demás se llaman "animales pato", "animales perro" y "animales cocodrilo" respectivamente.