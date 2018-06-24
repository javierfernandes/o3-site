---
title: "conceptos-object-based-languages-prototipos-en-javascript"
date:  2018-06-20T19:27:10-03:00
---


[[_TOC_]]


## Intro a Javascript
Quizás ya conozcan este lenguaje por el lado de la programación web. Quién no haya trabajado mucho en este lenguaje, al menos alguna vez vió algo de código, o bueno, al menos lo habrán escuchado nombrar.

Con la llegada y conquista de la arquitectura de aplicaciones web Javascript se convirtió en un lenguaje masivo y mainstream, ya que es parte del set de estandards de la programación web, junto a: **http, html, css**.

Es decir que los browsers o navegadores "entienden" y ejecutan código javascript.


### Características y Clasificación del Lenguaje
En primer término, decimos que JavaScript es un lenguaje de programación de **propósito general**. Es decir que con él, en principio, como lenguaje podríamos codificar cualquier tipo de aplicación y en forma completa *(Ver [DSLs](../conceptos-dsls-domainspecificlanguage))*

En cuanto a su [sistema de tipos](../conceptos-tipos-binding)  ...

#### **[]()Es dinámico
Es decir que los checkeos se realizan en tiempo de ejecución. En la misma forma en que lo hacen lenguajes como: smalltalk, ruby, groovy, etc.
```

var perro = new Perro();
        **perro.ladrar();`
```
 
Más adelante vamos a ver el tema objetos en javascript, pero digamos acá que la variable "perro"  es de tipo **Perro**, que no está definido en este ejemplo, para no meter ruido. Digamos que **Perro** no entiende ningún mensaje. 
Luego, al intentar enviarle el mensaje **ladrar** falla en tiempo de ejecución:

[![](https://sites.google.com/site/programacionhm/_/rsrc/1347717576399/conceptos/object-based-languages/prototipos-en-javascript/o3-jscript-dinamico.png)
](conceptos-object-based-languages-prototipos-en-javascript-o3-jscript-dinamico-png?attredirects=0)

Ojo que, recordamos, esto no quiere decir que sea un lenguaje **no compilado.**

El código javascript se compila !

Por si les interesa o sienten curiosidad acá va un ejemplo:
```

        **function** test() {
         var i = 3;
         print(i + 2);
        }
El bytecode generado al compilar esto sería:


        00000: **uint16** 3
        00003: **setvar** 0
        00006: **pop**

        00007: **name** "print"
        00010: **pushobj**

        00011: **getvar** 0
        00014: **uint16** 2
        00017: **add**

        00018: **call** 1
        00021: **pop**

        00022: **stop**


```

#### **[]()Es implícito
Dos puntos:

1. Al ser dinámico, **dos objetos van a ser polimórficos si entienden el mismo mensaje** que les estoy enviando. No hace falta que tengan un tipo en común (supertipo, o lo que sea). Igual que vimos en smalltalk. Es decir que el polimorfismo es **implícito.**


1. Además, las variables no son tipadas, ya que no hace checkeos en tiempo de compilación. Es decir que los tipos de las variables son **implícitos.**

Ejemplo:
 **

**

        **function** holaA(alguien) {
    var saludo = 'Hola ' + alguien;
    document.writeln(saludo);
}
 
Acá vemos dos variables:
* **Parámetros de la función**: el "alguien". 


 * vemos que no declara un tipo.
 * de hecho no declara nada más que el nombre.
* **Variable local:** llamada "saludo"

 * tampoco declara un tipo.
 * a diferencia del parámetro, hay que declarar el hecho de que es una variable local con el **keyword var.** 

## Funciones en JavaScript
JavaScript posee la idea de funciones como **first-class objects**. Es decir que las funciones son entidades principales del lenguaje, y se pueden manipular. Por ejemplo pasar como parámetro a otra función. Lo cual lo convierte en un lenguaje bastante poderoso. 
Pero además, al tener luego soporte para objetos, como vamos a ver, significa que es un lenguaje **multiparadigma, **ya que permite programar en funcional, objetos e imperativo.

Ejemplo de función simple, recursiva de factorial:
```


function factorial``(``n``)` `
 if`** `(``n==` `0``)` `
 return`** `1``;`
 `}`
 return n*`` factorial``(``n-` `1``)``;` 
        }

```

Ejemplo de función como parámetro:```

        **function** ejecutarNVeces(funcion, veces) {
         **for** (var i = 0; i < veces; i++) {
         funcion();
         }
        }

        var holaMundo = **function**() {
         document.writeln('Hola Mundo!');
        }

        ejecutarNVeces(holaMundo, 4);

```
O incluso se pueden pasar funciones "anónimas", es decir que no tienen un nombre. Algo así como un bloque de código, o lambda:


```

**function** ejecutarNVeces(funcion, veces) { **for** (var i = 0; i < veces; i++) { funcion(); } } ejecutarNVeces(**function**() { document.writeln('Hola Mundo!'); }, 4);
        

Nótese que estamos definiendo la función en el mismo lugar donde pasa por parámetro.
```

 
## Objetos en JavaScript
 Si bien javascript permite programar con funciones, también permite programar en objetos.


La pregunta entonces es, cómo creo un objeto ?


Las respuestas son varias. Hay varias formas.


Veamos la primera:


         **function** Animal(patas) {
            **this**.value = patas;
                
            **this**.correr = **function**() {
                document.writeln('CORRO con mis ' + this.value + ' patas!<br>');
            }
        }
        



Acá utilizamos un concepto especial de javascript, que es la **función constructor**.
Se podŕia pensar que estamos declarando una función, sin embargo, esta función tiene una semántica especial, va permitir:

* crear una nueva instancia con **new Animal()**

* dará acceso a la instancia actual con **this**


Esto se podría pensar como que estamos declarando una tipo de objeto o una *clase* Animal con:

* la variable de instancia **value**

* el método **correr()**


**

**

OpenClass en Javascript


En javascript además de poder declarar los miembros dentro de la función/clase, al igual que en self, un objeto tiene **slots, **y estos pueden modificarse desde cualquier lado.


Esto nos permite la idea de openclass, donde podemos agregarle miembros. Ejemplos




        Animal.*`prototype`*`.energia = 0;`


        Animal.*`prototype`*`.comer = function(alimento) 
            **this**.energia++;

        }


Acá estamos agregando dos miembros a Animal:
* una **variable de instancia** **energia** de tipo **int**.
* un **método** **comer** que incrementa la energía en una unidad.




Y qué es un prototype ??


Ahí se nos coló algo mágico, la property **prototype** de Animal.
Qué es eso ?


Acá viene la idea de prototipado.
En javascript todos los objetos de tipo **Function** tienen un prototipo. La idea de prototipo en este caso, sería como un **slot parent** en Self. Es decir que tendremos **delegación automática** hacia este objeto prototype.


Es decir que cualquier mensaje que nuestro objeto no entienda se va a delegar al prototipo.


Entonces, ahora si revisamos el código nuevamente, vemos que los miembros se los estamos agregando al prototipo en realidad y no al objeto.
### "Herencia" simple

A diferencia de Self donde podíamos tener múltiples **parent slots, **en javascript solo podemos tener un prototype. Y de hecho el slot siempre se llama **prototype** es un nombre fijo.


### Prototipos dinámicos

También al igual que en Self, el prototype de un objeto se puede cambiar en runtime.


Ejemplo:




functionAnimal(patas) 
           ` this.value = patas;`
               ` `
           ` this.correr =`` function() 
                document.writeln('CORRO con mis ' + this.value + ' patas!<br>');
            }
        }

function Gallina() 
        }
            
        Gallina.prototype = new Animal(2);`

var g = new Gallina(2);`
        g.correr();
En este ejemplo estamos asignando un objeto de tipo **Animal ** como prototype de la función constructor** Gallina.**

**Al crear instancias de Gallina van a tener como prototypo la misma instancia de Animal.
**




### Objetos Literales

La segunda forma de crear objetos en javascript es a través de literales de tipo Mapa.
Es decir que creamos un mapa, donde las keys son los nombres de los slots y los values sus valores. Que pueden ser valores constantes o literales o pueden ser function's, es decir, métodos.

        var Animal = {
           patas : 2,
           cantar : function() { document.writeln("Canto bajo la lluvia!"); }
        };

        Animalito.correr = **function**() { document.writeln("CORRO bajo la lluvia!"); }

        function Oso() {
        }

        Oso.*prototype* = Animalito;

        var oso = new Oso();

        document.writeln("Oso Patas:" + oso.patas);

Luego, podemos y combinar ambas formas.

## Temas Pendientes

### Algo de Historia y Demonización de JavaScript
  // TODO


## Interpretes y Ambiente de Trabajo

### Web
  // TODO

### No-Web

* [Google V8 Engine](http://code.google.com/p/v8/)
* [Node.js](http://nodejs.org/)
* [JSLibs](http://code.google.com/p/jslibs/)
* [SpiderMonkey](https://developer.mozilla.org/en/SpiderMonkey)



## Referencias

* [Introduction to Object-Oriented JavaScript](https://developer.mozilla.org/en/Introduction_to_Object-Oriented_JavaScript)
* [Finally Grasping Prototypal Object Oriented Programming in Javascript](http://blog.nategood.com/finally-grasping-prototypical-object-oriented)
* [How-to: Prototype Oriented Programming in JavaScript](http://agileculture.net/fvia/2009/03/27/how-to-prototype-oriented-programming-in-javascript/)