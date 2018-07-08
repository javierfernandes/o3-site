---
title: "Ioke"
date:  2018-06-20T19:27:10-03:00
toc: true
---


## Descripción
Ioke es un lenguaje de programación **experimental** lo que quiere decir que su objetivo no es el de un lenguaje de nivel productivo. De hecho en el sitio del lenguaje el autor Ola Bini, lo describe como su lenguaje para probar ciertas ideas radicales.
Es un lenguaje de objetos, con checkeos en tiempo de ejecución y tipado implícito. A diferencia de smalltalk es un lenguaje sin clases, lo que se llama **prototipado**.

Si todo esto no se entiendo del todo, no importa, porque lo vamos a explicar a continuación.

## Setup del ambiente


* Simplemente bajamos un tar.gz / zip de [acá](http://ioke.org/download.html)
* Descomprimimos en donde querramos.
* El contenido de este paquete es:

```bash
.
├── bin (consola interactiva)
├── COPYING
├── dok  (documentación de referencia del lenguaje)
├── lib

├── LICENSE
├── LICENSE.kawa
├── README
└── share
```


## Primeros Pasos

Ejecutamos

```bash
  usuario@/opt/o3/lang/ioke/bin$ ./ioke
  iik>
```

A partir de acá ya estamos en la consola interactiva de ioke.

Para hacer el famoso "*Hola Mundo"* en ioke simplemente hacemos;

```bash
  iik> "hello world" println

  hello world
  +> nil
```

Lo cual envía el mensaje "println" al objeto "hello world"
Pero con eso no hacemos nada, asì que veamos más cositas.
Números y operadores...

```bash
  iik> **2+3**
  +> 5

  iik> **2*3+1**
  +> 7
```

Nuevamente lo que sucede aquí son mensajes.


```bash
  iik> aQuien = "al Mundo"
  +> "al Mundo"

  iik> "hola " + aQuien
  +> "hola al Mundo"
```

## Objetos & Celdas

En ioke todo es un **objeto. **Y los objetos pueden tener **celdas.**

Por ahora vamos decir que lo que difiere de smalltalk es la forma de crear un nuevo objeto, ya que es un lenguaje prototipado. Esto lo vamos a ver en la siguiente sección. Por ahora digamos que no vamos a construir un objeto a partir de un new sino a partir de otro objeto



```bash
  iik> persona = Origin mimic
  +>#<Origin:147545B>

  iik> persona nombre = "Arturo"
  +>`Arturo`
        
  iik> persona edad = 35
  +>`35`

  iik> persona edad
  +>`35`
```




Con la primer linea creamos un nuevo objeto **persona**. Origin mimic es la forma convencional de crear un nuevo objeto básico, digamos.
Luego en la segunda linea asignamos una celda llamada **nombre** a la persona con el valor de texto "Arturo".
Como **nombre** no existía como celda en el objeto, ioke automáticamente la crea
Luego agregamos otra celda **edad**.
Finalmente mandamos el mensaje **edad** a la persona, lo cual nos devolvió el contenido de la celda, el número 35.


Entonces acá vemos que una celda puede ser lo que en otros lenguajes llamamos una property o variable del objeto.


Además de eso, una celda puede contener un **comportamiento, **un **método:**

```bash
  iik> persona identificate = method("Hola, soy " + nombre + " y tengo " + edad + " años")
  +> #<DefaultMethod:135942C>
  
  iik> persona identificate
  +> Hola, soy Arturo y tengo 35 años
```

Al igual que con nombre y edad, acá estamos asignándole valor a una celda llamada **identificate** que como no existe en la persona, ioke la va a crear. La diferencia es que asignándola a un método.
Fíjense que el método no se define con una sintaxis especial como en otros lenguajes, sino que es, a su vez, el resultado de enviar el mensaje **method(...). **Es de hecho, la llamada a un método.
Esto es muy importante en ioke y en parte viene de otros lenguajes como LISP. Y nos lleva al siguiente tema a ver.


#### Ground, Mensajes y Contextos

La idea de mensajes y celdas es central en ioke.
Una pregunta que podría surgir del ejemplo anterior es ¿dónde están las variables? ¿es **persona** una variable?, ¿por qué no la declaramos de alguna forma, como en otros lenguajes se usa **var **(scala), o | variable | (smalltalk) ?


La respuesta es que **persona **en nuestro ejemplo **no es una variable**. De hecho no existen las variables locales.
Cuando hicimos *persona = Origin mimic *sucedió lo mismo que cuando hicimos *persona edad = 35*
Como la celda **persona**  no existía, se creó y se asignó al nuevo objeto que para nosotros representa a la persona.


¿Pero entonces a quíen pertenece esa celda? ¿Dónde se creó?


La respuesta es: a otro objeto. A uno particular que viene en el ambiente, llamado **Ground**.
Así como decíamos que todo es un objeto en ioke, también sucede que el concepto de **Mensaje **es igual de importante. Todo código que escribimos y ejecutamos se encuentra en un **contexto, **que es un objeto. Así todo lo que escribamos cómo "código" es en realidad el envío de un mensaje al contexto.


El objeto contexto default en ioke es el Ground.


Ejemplo:

```bash
  iik> blah
  * - couldn't find cell 'blah' on 'Ground' (Condition Error NoSuchCell)
         blah                                             [<init>:1:-1]
```


Como pueden ver acá, al ejecutar lo que escribimos "blah" se intentó resolver una celda con ese nombre en el contexto actual, el objeto **Ground.** Como no existe lanzó un error.


Entonces, lo que en otro lenguaje pensábamos como variables son en ioke en realidad **celdas del contexto.**

Existe un mensaje llamado **cells** que nos permite ver qué celdas tiene un objeto



```bash
   iik> Ground cells

   +> {kind=Ground, persona=#<Origin:FAC7C5>}
```

Ahí vemos dónde fue a parar nuestra "persona". Como todo mensaje se envía por defecto al ground, podríamos haber escrito simplemente "cells" en lugar de "Ground cells".


Ahora que entendemos esto veamos de nuevo la definición de un método

```bash
  iik> persona identificate = method("Hola, soy " + nombre + " y tengo " + edad + " años")
```

Si bien esto está expresado en una forma bastante declarativa, al ejecutarse se producen bastantes cosas:

* se envía el mensaje **persona** al **Ground, **lo cual retorna nuestro objeto
* Luego, ioke identifica una asignación por el signo =, con lo cual evalúa el lado derecho de la asignación, para eso
* se envía el mensaje **method**, nuevamente al objeto **Ground** que retorna un objeto que será el método.
* Finalmente ioke agrega una nueva celda **identificate **al objeto **persona** con el** **objeto método resultado del mensaje **method()**



## Mimics (o cómo compartir comportamiento)

Entonces hasta ahora vimos que:

* Todo es un objeto
* Un objeto tiene celdas que pueden ser:
 * valores
 * comportamiento
* Todo el código que escribimos son envíos de mensajes a objetos, que se resuelven buscándo una celda en el objeto y ejecutandola (devolviendo el valor o ejecutando el método)

¿ Pero entonces cómo hago para compartir código ? o para evitar tener que crear objetos y agregarle los métodos, valores, etc. manualmente.

En los lenguajes basados en clases, esta función la cumple la clase, ya que sirve como template para crear objetos.

A su vez, para compartir código entre diferentes clases, tenemos la herencia en lenguajes más tradicionales, y mixins, traits, etc. en algunos otros que ya vimos.


En un lenguaje sin clases, debe existir otra forma de **herencia** sin éstas, En ioke es a través de un mecanismo de **delegación automática, **como lo mencionamos [acá](../conceptos-object-based-languages)



Por ahora vamos a ver las dos cosas juntas: por un lado la creación de un nuevo objeto y por otro la vinculación con su delegado o parent, que acá se llama **Mimic**.


Un **Mimic **es simplemente un objeto que es utiilizado por otros para "imitarlo", para comportarse como él. Entonces él sirve como "modelo", en forma análoga a la función de las clases en un lenguaje con clases, con la diferencia de que no tiene nada de particular. Y ya vamos a ver que es mucho más poderoso al ser un objeto.



Entonces si seguimos con nuestro ejemplo anterior....

```bash
  iik> persona = Origin mimic 
  iik> persona nombre = ""
  iik> persona edad = 0
  iik> persona identificate = method("Hola, soy " + nombre + " y tengo " + edad + " años")
```

Y ahora queremos un nuevo objeto que sea una persona, podemos usar a **persona** como prototipo para crearlo.
En otros lenguajes como Self esto se llama **clonar.**

En ioke se dice **mimic**

```bash
  iik> arturo = persona mimic
  iik> luciana = persona mimic
```

Probemos...

```bash
  iik> arturo identificate
  +> Hola, soy  y tengo 0 años
```

Y ahora qué pasa si modificamos a estas personas ?

```bash
  iik> arturo nombre = "Arturo"
  iik> arturo edad = 31


  iik> luciana nombre = "Luciana"
  iik> luciana edad = 22


  iik> arturo identificate
  *+> Hola, soy Arturo y tengo 31 años*

  iik> luciana identificate
  +> Hola, soy Luciana y tengo 22 años
```

Y qué pasó con el objeto persona original ?

```bash
  iik> persona identificate
  *+> Hola, soy  y tengo 0 años*
```

Nada. No pasó absolutamente nada.
Con esto vemos un efecto importante de los prototipos. 


¿qué pasaría si en nuestro ejemplo ahora queremos agregarle una nueva responsabilidad/comportamiento a todas las personas ?

```ruby
  persona cumplirAnios = method(self edad++)`` 
  arturo cumplirAnios        
  arturo identificate
```

Esto produce: 

`Hola, soy Arturo y tengo 32 anios`

Es decir que al agregarle un nuevo comportamiento a **persona** todos los objetos que la tenían como Mimic pasaron a tenerlo.


## Creación de Objetos y Prototipos

En la introducción a lenguajes sin clases mencionamos que entonces los objetos se tenían que crear en base a otros objetos.

En [Self](../conceptos-object-based-languages-self) por ejemplo, esto se puede hacer clonando un objeto explícitamente.

En Ioke no es tan así. Si bien uno podría implementar un mensaje **copy** o **clone**, el lenguaje ya es un poco más amigable para eso. Y al hacer **mimic** estaremos construyendo un nuevo objeto que tiene como mimic al receptor. Como vimos en el ejemplo anterior con Arturo.

Ahora, también como vimos en el ejemplo anterior, el Mimic puede tener slots con estado, y al derivar dos objetos de ellos, estos estados no se entremezclan. En realidad esto ya lo vimos en el ejempo anterior, al tener dos objetos, Arturo y Luciana, derivados de Persona.
Cuando les asignamos nuevos valores a **nombre** y **edad** en lugar de modificar el valor de las celdas en **Persona** se crearon nuevos slots con los mismos nombres en cada objeto **Arturo** y **Luciana**.
En Self eso no hubiera pasado, y tendríamos problemas, porque estaríamos compartiendo los mismos atributos entre diferentes objetos.

Acá podemos ver que las celdas nombre y edad estan definidas en los dos lugares:
[![](https://sites.google.com/site/programacionhm/_/rsrc/1367099399598/te/ioke/Screenshot%20from%202013-04-27%2018%3A48%3A30.png)
](te-ioke-Screenshot%20from%202013-04-27%2018%3A48%3A30-png?attredirects=0)

### Mimics con estado y Constructores


Entonces por lo que vimos recién un mimic puede tener, además del comportamiento que queremos reutilizar, estado. Porque ioke ya hace la magia de "redefinirlo" en los objetos derivados.
Sin embargo, es molesto tener que escribir las asignaciones. Por lo que existe una forma de definir "constructores" que son símplemente métodos con el nombre **initialize**.
Entonces en un ejemplo utilizando la figura Rectángulo, en lugar de esto:

```ruby
Formas = Origin mimic

Formas Rectangulo = Origin mimic do(
  base = 0
  altura = 0
  area = method(base * altura)
  perimetro = method(2 * (base + altura))
)

r1 = Formas Rectangulo mimic
r1 base = 4
r1 altura = 3
```

Lo podemos definir como:

```ruby
Formas = Origin mimic

Formas Rectangulo = Origin mimic do(
  initialize = method(base, altura,
    self base = base
    self altura = altura
  )
  area = method(base * altura)
  perimetro = method(2 * (base + altura))
)

r1 = Formas Rectangulo mimic(4, 3)
r1 area
r1 perimetro
```

## Cambiando el Mimic en tiempo de ejecución

Dijimos que el mimic estaba entonces cumpliendo algunas de las funciones que cumplía la clase, en lenguajes con clases. Por un lado lo utilizamos para reutilizar comportamiendo y definición de estado, y por otro lado sirve como creador de instancias, con el mensaje **mimic**.

Además, vimos que tenía constructores !

Entonces, tal vez se pregunten cuál es la ventaja de complicarla eliminando las clases. Bueno, la ventaja es que acá son objetos y no un elemento especial.

Y podemos, dado un objeto, cambiarle su mimic en tiempo de ejecución. Lo que equivaldría a cambiarle al clase a un objeto. Porque en definitiva cambiamos el comportamiento que hereda.


Veamos para eso un ejemplo de vehículos.

//TODO


## Mixins
//TODO: intro contar mixins como convención, heredan de... y uno siempre crea un Origin mimic y manipula sus mimics agregando el mixin.


Un Vehiculo representa mi idea abstracta independiente de una instancia en particular.
En este ejemplo simplemente vamos a darle un comportamiento único, de trasladarse.


```ruby
  Vehiculo = Mixins mimic
  Vehiculo trasladarse = method("me muevo abstractamente" println)`**
```


Esta implementación default no tiene mucho sentido, porque va a depender de Vehículos más concretos.
Así que vamos a crear abstracciones (fíjense que no decimos **clases**) más particulares de Vehículo:

```ruby
Vehiculo Terrestre = Vehiculo mimic

Vehiculo Terrestre trasladarse = method("me muevo por la tierra" println)

Vehiculo Aereo = Vehiculo mimic

Vehiculo Aereo trasladarse = method("me muevo por el aire" println)
```


Y ahora sí, vamos a trabajar con una instancia particular de Vehículo, con un **objeto**. Vamos a hacer que tenga como mimic al Vehiculo Terrestre.

```ruby
miAuto = Origin mimic
miAuto mimic!(Vehiculo Terrestre) 
miAuto mimics

+> [ 
  Origin:
    ===                          = ===:method(...)
    eval                         = eval:method(...)
    kind                         = "Origin"
    mimic                        = theMacro:macro(...)
    print                        = print:method(...)
    println                      = println:method(...)
  , Origin Vehiculo Terrestre_0x6E1DEC:
    **kind**                     = "Origin Vehiculo Terrestre"
    trasladarse                  = trasladarse:method(...)
]
```

Acá ya vemos una particularidad. En lugar de derivar el objeto de Vehiculo Terrestre
Lo trasladamos !

```bash
  iik> miAuto trasladarse
  +> me muevo por la tierra
```

Ahora, como somos relocos queremos convertir nuestro auto en un avión, entonces eliminamos el mimic Vehiculo Terrestre y agregamos el Aereo

```bash
  iik> miAuto removeMimic!(Vehiculo Terrestre)
  iik> miAuto mimic!(Vehiculo Aereo)          
  iik> miAuto trasladarse
  +> `me muevo por el aire`
```

Listo, nuestro auto ya se comporta como un Vehículo Aereo, no es más un terrestre.



## Referencias

* [http://ioke.org/wiki/index.php/Guide](http://ioke.org/wiki/index.php/Guide)
* [http://mikael-amborn.blogspot.com/2009/07/prototype-based-programming-in-ioke.html](http://mikael-amborn.blogspot.com/2009/07/prototype-based-programming-in-ioke.html)

* [http://en.wikipedia.org/wiki/Homoiconicity](http://en.wikipedia.org/wiki/Homoiconicity)