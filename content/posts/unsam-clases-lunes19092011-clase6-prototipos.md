---
title: "unsam-clases-lunes19092011-clase6-prototipos"
date:  2018-06-20T19:27:10-03:00
---


## []()Introducción

Arrancamos contando que Self es un lenguaje de los '90 con ideas muy interesantes, que si bien no es directamente conocido, tiene detrás muchas ideas interesantes que la industria fue incorporando, como la idea de VM [HotSpot](http://en.wikipedia.org/wiki/HotSpot).


Contamos que Self era algo complicado de mostrar, no por el lenguaje en sí, ya que es muy poderoso, y tiene ideas muy interesantes, sino más bien por su entorno de desarrollo, que ha quedado obsoleto y es bastante complejo de utilizar. Esto es el **morphic**. 


## []()Self entonces

Basta de historia y manos a la obra !


Abrimos una imagen, pero antes algo de conceptos del lenguaje.


En Self solo hay objetos, en un sentido un poco más estricto que en smalltalk. Por ejemplo en smalltalk las clases son objetos **especiales**.
Vimos la idea de slots: data slot o method slot.


La interacción entre los objetos de mi sistema es enviando mensajes.


Qué rol cumplen las clases en un lenguaje basado en clases ?

* **instanciación**

* herencia (lo interesante de la herencia lo abstraemos como el siguiente punto)
* **reutilización de código.**


 * **entre objetos:** como la que me dá una clase naturalmente.
 * **entre conjuntos similares de objetos**: es el tipo de reutilización que nos da la herencia, traits, mixins.
* tipado (en self no nos molesta porque no tiene checkeo de tipos).

### []()Instanciación

La forma de resolver la instanciación sin clases es a través de dos mecanismos:

* la **clonación** de un objeto particular llamado **prototipo.**

* la creación de un **objeto literal:**


 * ej en smalltalk: 'hola', 1, [:a | a+1], $a, #x

Vimos un ejemplo entonces en self.


Creamos el objeto más simple 



        ().


**Get it** lo devuelve y lo muestra. Es un objeto sin slots.
**Do it** ejecuta


Vemos que el botoncito "E" sirve para abrir un pequeño **workspace **para trabajar con ese objeto.


Veamos un objeto un poco más interesante.



        (| altura = 10. base = 10|).


Ahora sí a este objeto le podemos preguntar **self altura ** y **self base.**



Vemos que el 10, es un solo objeto.


Definamos otro objeto "parecido"...



        (| altura = 10. base **<-** 5|).


En este caso **altura** tiene el valor **constante ** mientras que **base** es un **slot variable**, inicializado en el valor 5.


Ahora en su workspace podemos hacer...



        self base: 4

Luego modificamos el objeto agregándole un slot.
Botón derecho "Add slot"


Y le agregamos un slot 



        superficie = (base * altura)


### []()Como reutilizamos ?

Los objetos pueden tener un tipo especial de slot de delegación (**parent**).
Cualquier mensaje que el objeto no entienda lo va a delegar automáticamente.


A través del parent traits cloneable hacemos que nuestro rectágulo sea cloneable


Usamos el clone para crear un clone.
Pero luego vemos que si modificamos el objeto original no se actualiza el clonado.


Entonces, para poder compartir código entre objetos vamos a crear un parent.


Creamos un nuevo objeto literal ().
Botón derecho Move y movemos los slots al nuevo objeto que va a ser nuestro parent.


Luego a los rectángulos le agregamos el slot **parent*** apuntando al objetito que creamos.
Este objeto parent no es un rectángulo, porque no tiene los slots de **base **y **altura,** sino que va a ser una especia de **trait rectangulo.**

**

**

Con esta técnica se *emula *la idea de clase.


Por qué tenemos dos objetos y no tenemos la base y la altura ? porque la base son slots constantes, valores, que no quiere compartir. 
Nuestro trait sería la clase, y nuestra instancia sería el objeto concreto.


### []()Comparación con Herencia

Al tener slots **parent** aparece la idea de que sería parecido a la herencia. Y de hecho, recién mencionamos que la forma de reutilizar comportamiento *emulaba** **las clases.*
*En realidad contamos esto, para introducir el lenguaje, comparándolo con lo que ya conocemos (Clases). Pero realmente no tiene sentido trabajar en un lenguaje prototipado, para pensar en imitar la forma de trabajar con clases.*
*
Estaríamos perdiendo el poder agregado que nos dá un lenguaje puro de objetos.*
*
*
*Entre las diferencias con la herencia vemos que ésta última es una relación entre clases, mientras que el mecanismo de delegación de self es entre objetos.*
*No hay nada especial en la forma de compartir código en Self, más que relaciones entre objetos y la delegación automática. *
*
*
### []()Más con traits

Luego le agregamos un factory method a nuestro trait. nuevoConBaseAltura


### []()Make Creator

Creamos un nuevo slot en el lobby llamado **figuras** y lo marcamos (botón derecho) como creator (Make creator). Ahora el título de la ventan de nuestro objeto pasa a llamarse "figuras".


Esto marca algo importante de paradigma de objetos puro, que es que nuestros objetos no tienen nombre per se. En un esquema de clases las clases tienen nombre, en objetos puro no hay clases, ergo, no hay nombres.


### []()Modificando Parent slots

Por último vimos que modificando el parent de un objeto estaríamos cambiándole su comportamiento completamente. Sería lo análogo a cambiarle la clase a un objeto (o superclase) en tiempo de ejecución.


## []()Prototipos con Javascript

Luego jugamos un poco en javascript con objetos, prototipos y funciones.