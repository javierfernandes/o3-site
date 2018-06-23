---
title: "te-clojure"
date:  2018-06-20T19:27:10-03:00
---


## Descripción
Clojure es un dialecto de LISP. Con la particularidad de que está construido sobre la virtual machine de java JVM. Es decir que el código se compila a java bytecode que es ejecutado por la VM.
Esto entre otras cosas permite embeber código clojure dentro de una aplicación java, y vice-versa. Es decir que permite acceder a clases java desde closure.


## Átomos Y Listas

Como LISP es un lenguaje de proposito general y se base en conceptos muy muy simples que permiten construir sobre este lenguaje aplicaciones en diversos paradigmas. 
Si bien naturalmente se utiliza para trabajar con el **paradigma funcional**, en principio, por sus capacidades de metaprogramación permitiría implementar cualquier paradigma.

Los dos conceptos básicos o tipos de expresiones en clojure son:

* **Átomo: **que se podrían pensar como los tipos básicos de otros lenguajes. Como un número, un string, un caracter, etc.

* **Lista:** Un conjunto de elementos, que podrían ser átomos o listas a su vez.

Y eso es todo (casi).


### Ejemplos:
Un número:
```
        user=> 42 **42**

```
String:
```
        user=> "Hola Clojure!" "Hola Clojure!"` **

```
 
La expresión de tipo lista se escribe de esta forma:
```
        (1 2 3 4)
```
 
## Y el Código ?
Pero entonces donde está el comportamiento ?

Ahí está lo interesante!
En clojure (al igual que en LISP) el código y los datos se representan de la misma forma!
No hay distinción entre ellos.

Por ejemplo, si quisieramos utilizar una función **first(lista) -> elemento** es decir que dada una lista retorna el primer elemento, en otros lenguajes haríamos:

```
        **first**(["a" "b" "c"])

```
 Teniendo una construcción especial en el lenguaje **nombre_funcion ( argumentos )**


O en objetos:
```
        ["a" "b" "c"].first()
```
 
Con la construcción especial **variable.mensaje()**


En Clojure esta sintaxis especial no existe. Ya que las únicas expresiones son las listas y átomos.
Entonces tenemos que escribir la invocación a la función con esas dos herramientas.
Queda algo así...
```
        user=> (first ["a" "b" "c"])
"a"

```
Es decir que la invocación de la función **first** con la lista que contiene **"a", "b" **y **"c"**, se puede pensar a su vez como una lista, donde 

* el primer elemento es el **nombre de la función**

* los siguientes elementos son los **argumentos**.

Claro que acá el lenguaje al evaluar la lista, trata de forma especial el primer elemento, e intenta buscar una función para ese nombre, y ejecutarla. 
Una especie de **dispatching**.


## Manipulando Código
Juguemos un poco con manipular el código ya que se puede tratar como datos:

        user=> (rest [1 2 3])
(2 3)`**

        user=> '(rest [1 2 3])
(rest [1 2 3])`**

        user=> (first '(rest [1 2 3]))
rest`**


**rest** es una función que dada una lista retorna todos los elementos excepto el primero.
El operador comilla simple **'** retorna la lista que precede, sin evaluarla. Es decir, evita el dispatching. Y es lo que nos permite tratar el código como una estructura de datos.

En esto caso, dado una invocación a rest con una lista, estamos obteniendo el nombre de la función, **rest**. En este caso tenemos nosotros codificamos todas las lineas. Pero piensen que el poder de esto está en que la invocación podría llegar por parámetro, y ser cualquier cosa. Como **alto orden**.



## Definiendo Funciones
Cómo definimos entonces nuestras propias funciones ?
Adivinen con qué ?? ... átomos y listas!! 
De nuevo.. es lo único que hay en la sintaxis de Clojure.

Entonces, nuestra definición de función va a tener que ser expresada como una lista.

Definamos la **suma**. La función:

* Tiene un nombre: **suma**

* Recibe dos números como parámetros.
* Se define como a + b
Todo eso lo tenemos que escribir como una lista.

En clojure existe una función especial llamada **defn** que permite definir nuevas funciones.

Entonces la forma de declarar una nueva función es:

        user=> (defn sumar [numero otro] (+ numero otro))
#'user/sumar`**

        user=> (sumar 2 5)
7`**


Noten la sintaxis de defn es:
(defn nombreFuncion vectorArgumentos Cuerpo)