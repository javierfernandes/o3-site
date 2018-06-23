---
title: "conceptos-multiple-dispatch"
date:  2018-06-20T19:27:10-03:00
---


[[_TOC_]]


## Dispatch
Cuando vemos el paradigma de objetos se nos hace hincapié en la idea de polimorfismo. Que básicamente se refiere a la capacidad de dos (o más) objetos de responder a un mismo mensaje. Permitiendo a un tercer objeto, el cliente de ellos, abstraerse de las implementaciónes y sus diferencias.

#### **[]()Veamos un Ejemplo
Entonces, por ejemplo, podemos tener la idea de un objeto **Trabajador**, cuyos casos concretos pueden ser un **Artesano**, que generará adornos o artesanías como parte de su trabajo, o un **Zapatero**, que creará un zapato.

        **abstract class** Trabajador {
 `    trabajar``() {
         System.out.println("No hago nada!!");
     }
}`

        **class** Artesano extends Trabajador {
            trabajar`() {
         System.out.println("Hice un duendecito!");
     }`
        }

        **class** Zapatero extends Trabajador {
            trabajar`() {
         System.out.println("Hice un mocasín!");
     }`
        }

Y ahora el tercer objeto, el cliente, sería nuestro código de ejemplo que pone a trabajar a la gente :)

        Artesano artesano = new Artesano();
artesano.trabajar();

*Qué va a imprimir ???*

Y, ahora este otro ejemplo, asignamos el artesano a una variable de tipo Trabajador.

        Trabajador trabajador = new Artesano();
trabajador.trabajar();

*Qué va a imprimir en este caso entonces ??*

Tómense un momento para mirar bien, y pensar.

La respuesta es.. lo mismo. Va imprimir `"``Hice un duendecito!"`.
*Por qué ? si en el segundo ejemplo la variable es de tipo Trabajador ??*

Porque el método real que se ejecuta, no depende para nada del tipo de la variable, sino del tipo concreto del objeto que está asignado a ella, en el momento de ejecución (runtime).

A este mecanismo mágico se lo llama ***"dispatching"***.
Y se refiere a que la resolución dinámica del método a ejecutar.

### Single Dispatch

Es simplemente lo que acabamos de ver. El dispatching puede verse como un mecanismo de resolución de un método o función a utilizarse.

*De qué depende el dispatching que vimos ?
Qué depende que se ejecute uno u otro método ?*

El objeto receptor del mensaje. En nuestro caso el Artesano.

Como este dispatching depende de un solo objeto, se lo denomina "Single Dispatch".

*Pero cómo ? entonces se podría hacer un dispatching que dependa de más de un objeto ???*
Sí, y eso es justamente ***Multiple-Dispatch***, o también llamado ***Multi-methods***.***

***

### Multiple-Dispatch ó Multi-Methods

 Para enteder multiple-dispatch tenemos que hacer un switch y cambiar la noción que tenemos "objetosa" de los métodos.
Del ejemplo anterior, podríamos pensar que el método **trabajar**(), en lugar de estar definido dentro de una clase, podría estar definido fuera de ella, y recibir el objeto receptor, como parámetro.

Entonces se podría escribir/pensar como:

            trabajar`(``Artesano a``) {
         System.out.println("Hice un duendecito!");
     }`

            trabajar`(Zapatero`` z``) {
         System.out.println(``"Hice un mocasín!"``);
     }`

            trabajar`(Trabajador`` t``) {
        System.out.println("No hago nada!!");``
     }`

Cuando hacemos esta cambio de punto de vista, le estamos dando más importancia al concepto de método. Ahora pasa a ser un FirstClassObject (concepto primario del paradigma o lenguaje que estamos utilizando).

Más allá de eso, lo interesante de utilizar este modelo, es que ahora, el que era el receptor del mensaje deja de ser "especial", es un argumento que el método recibe. Y así como recibe un argumento, podría recibir más.
No hay diferencia entre el primer argumento, o el segundo, tercero, etc.

Este modelo permite generalizar el mecanismo de dispatching, en lugar de basándose en un receptor, podría basarse en todos los argumentos del método.

### Pongamoslo en un ejemplo
Resulta que todo trabajador necesita una materia prima para trabajar y convertir en un producto. Pero el resultado del trabajo no solo va a depender del trabajador, sino también del material que le demos para que trabaje.
Un Artesano, por ejemplo, puede hacer con cuero, un pequeño souvenir a modo de llavero. Mientras que un Zapatero hará un lindo zapato de cuero.
En cambio si proveemos al trabajador de goma, el Zapatero podrá hacer unas sandalias, mientras que el Artesano hará un juego para chicos para ubicar las letras.

Cómo resolvemos este problema que requiere de seleccionar el comportamiento en base a dos objetos ?

Veamos las 3 formas principales. De más "precaria" a más completa.

#### **[]()Emulando Multiple-dispatching a pulmón (con if instanceof's)
        **class** Artesano extends Trabajador {
            trabajar`(Material material) {
         **if** (material **instanceof** Cuero) {
            **return** new Llavero((Cuero) material);
        }
        **else** **if** (material **instanceof** Goma) {
``            **return** new Juego((Goma) material);`
                }
        **else** {
            **throw** new NoConozcoElMaterialException(material);
        }
     }
        }

        **class** Zapatero extends Trabajador {
            `trabajar``(Material material) {
         **if** (material **instanceof** Cuero) {
             **return** new ZapatoCuero((Cuero) material);
         }
         **else** **if** (material **instanceof** Goma) {
            **return** new Sandalia((Goma) material);`
 `        }
         **else** {
             **throw** new NoConozcoElMaterialException(material);
         }
     }`
        }

Como vemos es bastante nefasto. Y además, si agregamos un nuevo material, deberemos ir a modificar cada uno de los métodos trabajar de cada trabajador, para agregar una nueva condición al if.
Lo peor de esta solución es que nos fuerza a preguntarle al material "sos cuero ? sos goma ? sos ... ".
 
#### **[]()Emulando Multiple-dispatching con Double Dispatch

Double dispatch, intenta resolver la selección del método, utilizando polimorfismo. Específicamente resuelve el problema de andar preguntando.
En lugar de que el trabajador le pregunte de qué clase es al material, le va a llamar a un método diciéndole "decime vos quien sos, llamándome a diferentes métodos".

Vemos la clase trabajador como quedaría...

        **abstract class** Trabajador {
 `    trabajar``(Material material) {
        material.decimeQuienSos(this);
     }`
        
    **abstract** trabajar`Cuero(Cuero cuero);`
            **abstract** trabajar`Goma(Goma goma);`
        **    abstract** trabajar`Material(Material material);`

 `}`

Y la jerarquía de materiales:

        **abstract class** Material {
 `    decimeQuienSos``(Trabajador trabajador) `
        trabajador.trabajarMaterial(this);
     }`
 `}`

        **abstract class** Cuero {
 `    decimeQuienSos``(Trabajador trabajador) `
         trabajador.trabajarCuero(this);
     }`
 `}`

        **abstract class** Goma {
 `    decimeQuienSos``(Trabajador trabajador) `
         trabajador.trabajarGoma(this);
     }`
 `}`

Finalmente, los trabajadores particulares:

        **class** Artesano extends Trabajador {
             trabajar`Cuero(Cuero cuero) {
       **return** new Llavero((Cuero) material);`
            }
 `    trabajar``Goma(Goma goma) {
``        **return** new Juego((Goma) material);`
            }
 `**    **trabajar``Material(Material material) {
       **throw** new NoConozcoElMaterialException(material);`
            }
 `}`

        **class** Zapatero extends Trabajador {
 `     trabajar``Cuero(Cuero cuero) {
        **return** new ZapatoCuero((Cuero) material);`
 `    }
 ` `    trabajar``Goma(Goma goma) {
       **return** new Sandalia((Goma) material);`
 `    }
 ` `**    **trabajar``Material(Material material) {
        **throw** new NoConozcoElMaterialException(material);`
 `    }
 ` `}`

Como habrán notado, acá no hacen falta if's, ni andar preguntando por la clase del objeto.
Porque cada clase de material se encarga de redefinir el método decimeQuienSos() para llamar de vuelta al trabajador, pero al método particular para ella.

Como hay un doble llamado: primero del trabajador al material, y este luego de vuelta al trabajador, se denomina double-dispatch.
En realidad, conceptualmente se dice double-dispatch porque este mecanismo termina seleccionando el método a ejecutar en base a dos argumentos/objetos.

Esta solución, si bien es factible, solo es posible para dispatching de 2 argumentos,  y no de N.
Para N, aparece la solución más interesante....


#### **[]()Multiple-dispatch con Multi-methods

 Para realmente evitar tanto los if's como la burocracía del doble llamado del double-dispatch, el enfoque más "prolijo" y poderoso es que, el lenguaje soporte multi-methods directamente.

La idea sería entonces, simplemente escribir varios métodos con mismo nombre pero diferente tipo de parámetro, y que el lenguaje se ocupe automáticamente de hacer la selección, no solo en base al primer argumento, sino también a los demás.

En nuestro caso, ni Java ni smalltalk soportan este concepto, por lo que vamos a mostrarlo con otro lenguaje llamado "Nice" (Ver referencias al final de la página).

Nice es un lenguaje bastante parecido a java, con mucho features interesantes e influencia del paradigma funcional.
Además, compila a bytecode de java, con lo cual eso completamente compatible y puede ser embebido en una aplicación java.

Definimos primero entonces las clases y las jerarquías

        **class** Trabajador {}
        **class** Artesano extends Trabajador {}
        **class** Zapatero extends Trabajador {}

        **class** Material {}
        **class** Cuero extends Material {}
        **class** Goma extends Material {}

Luego podemos declarar la firma del método trabajar

        **String** trabajar(Trabajador t, Material m);

Y ahora probamos con la implementación más básica:

        trabajar(Trabajador t, Material m) = *"Trabajador no sabe que hacer con material"*;

Si ejecutamos el siguiente código:

        **void** main(String[] args) {
            Trabajador t = new Artesano();
            Material m = new Cuero();
            System.out.println(t.trabajar(m));
        }

Obtendremos como salida:
*"Trabajador no sabe que hacer con material"*

Ahora agregamos más implementaciones del método (multi-methods):

        trabajar(Artesano a, Cuero c) = *"Te hago un llavero!"*;
        trabajar(Artesano a, Goma c) = *"Te hago un jueguito!"*;
        trabajar(Zapatero z, Cuero c) = *"Te hago un mocasin!"*;
        trabajar(Zapatero z, Goma c) = *"Te hago una sandalia!"*;

Si ejecutamos el mismo ejemplo ahora obtendremos:

*"Te hago un llavero!"*

Y así, dependiendo el tipo real de los objetos que pasamos como parámetro, la VM seleccionará el método a ejecutar.


***Nota: ***

En este ejemplo declaramos los métodos "fuera de la clase" como si se trataran de [Extension Methods](conceptos-extension-methods).
Sin embargo podríamos haber definido los múlti-methods en las propias clases Artesano y Zapatero, de esta forma:


        **class** Trabajador {
            String trabajar(Material m) = *"Trabajador no sabe que hacer con material"*;
        }

        **class** Artesano extends Trabajador {
            trabajar(Cuero c) = *"Te hago un llavero!"*;
            trabajar(Goma c) = *"Te hago un jueguito!"*;
        }

        **class** Zapatero extends Trabajador {
            trabajar(Cuero c) = *"Te hago un mocasin!"*;
            trabajar(Goma c) = *"Te hago una sandalia!"*;
        }


## Multiple Dispatch en XTend

Xtend también soporta múltiple dispatch. Para eso los métodos se deben marcar con el keyword "dispatch". Todos los que formen parte del multimethod.
No hace falta declarar la firma del método original (el que será visible para el usuario del método).
Xtend lo infiere buscando la clase común entre las distintas definiciones.
Ejemplo:




class Zapatero extends Trabajador 



 `**def dispatch** trabajar(Cuero c) 
 `"Te hago un mocasin!"` 
 `}`
 
 `**def dispatch** trabajar(Goma g) 
            `    "Te hago una sandalia"`

 `}`
        }


Acá con CTRL+O, se puede ver a la derecha en el tooltip de eclipse cómo xtend interpreta a estos dos métodos como "variantes" de un único método, que infirió, utilizando Material, superclase de ambos (Cuero y Goma), como tipo del parámetro.



[![](https://sites.google.com/site/programacionhm/_/rsrc/1400874886454/conceptos/multiple-dispatch/xtendmultimethods.png)
](conceptos-multiple-dispatch-xtendmultimethods-png?attredirects=0)

Y si agregamos un tercer multimethod que reciba una Collection ? Es decir una clase que no está en la jerarquía de Material.





        **class** Zapatero {


 `**def dispatch** trabajar(Cuero c) { "Te hago un mocasin!" }`
 `**def dispatch** trabajar(Goma g) { "Te hago una sandalia" }`
 `**def dispatch** trabajar(Collection<Material> c) { "Uh.. cuanto laburo!" }`
        }


Infiere a Object !

[![](https://sites.google.com/site/programacionhm/_/rsrc/1400875137106/conceptos/multiple-dispatch/xtendmultimethod2.png)
](conceptos-multiple-dispatch-xtendmultimethod2-png?attredirects=0)Lo cual es lógico porque Object es la única superclase que tienen en común.
El problema es que ahora podemos causar un error en tiempo de ejecución porque puede recibir cualquier Object.
Si ejecutamos esto:



        **class** Blah {
 `**def static void** main(String[] args) 
 `new Zapatero().trabajar("unString")`
 `}`
        }


Va a fallar en runtime con este mensaje





        Exception in thread "main" java.lang.IllegalArgumentException: Unhandled parameter types: [unString]
 `at org.uqbar.xtend.extensions.doblepolimorfismo.Zapatero.trabajar(Zapatero.java:31)`
 `at org.uqbar.xtend.extensions.doblepolimorfismo.Blah.main(Blah.java:9)`
## Variantes y temas adicionales


* [Dispatch por valor](conceptos-multiple-dispatch-dispatch-basado-en-valor)
* [Multimethods en un Clojure (dialecto de LISP)](conceptos-multiple-dispatch-multimethods-en-clojure-lisp)
* [**Slate**:](http://slatelanguage.org/) un lenguaje basado en prototipos con multimethods.

### Bibliografía / Papers:


* ["Prototypes with Multiple-Dispatch", ](http://files.slatelanguage.org/doc/pmd/pmd.pdf)

* ["Object-Oriented Multi-Methods in Cecil", Craig Chambers, 1992](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.9991&rep=rep1&type=pdf)
* ["Inheritance is not Subtyping",](http://www.cs.utexas.edu/%7Ewcook/papers/InheritanceSubtyping90/CookPOPL90.pdf) William R. Cook
* ["Efficient Multimethods in a Single Dispatch Language"](http://www.laputan.org/reflection/ecoop-multimethods.pdf) , Brian Foote, Ralph E. Johnson and James Noble