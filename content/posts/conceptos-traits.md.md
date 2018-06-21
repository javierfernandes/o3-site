[[_TOC_]]


## []()Introducción

Surge como una respuesta al problema de la reutilización. Como una nueva opción a:
* Herencia simple.
* Herencia múltiple.
* Herencia basada en mixins.


### []()Herencia Simple:

* Duplicación de código entre jerarquías.
* Limitante: en la capacidad de abstracción y de reutilización de código.
* java "interfaces" resuelven el problema de subtipos y de la conceptualización (abstracción), pero no de la reutilización de código.

### []()Herencia Múltiple:

* Complejidad de implementación.
* Conflictos: metodos & fields. Problema del diamante.
* Acceso explícito a superclases:

 * para desambiguar conflictos.
 * vulnerabilidad de cambios en la jerarquía.
 * Acoplamiento.
* Capacidad de composición limitada: no soporta la capacidad de definir un componente que implemente y exportando un feature (metodo) pero a su vez utilize la implementación original de clases de diferentes jerarquías. (como permiten los mixins)


### []()Mixins:

* Se comportan bien aplicando un único mixin.
* Problemas de compatibilidad entre ellos al aplicar "muchos" mixins.

* Único Orden Composición:

 * los mixins *se combinan linealmente* (porque actúan sobre una jerarquía simple).
 * A veces no se puede planchar los mixins que quiero usar a un único "orden total".
* La clase que componemos *no tienen control sobre la composición* (herencia + mixins).    

## []()Traits
Aparece entronces la idea de **trait** para atacar estos problemas. Lo primero a notar es el contexto de solución en el cual aparecen los traits. La idea es atacar el problema de **reutilización de código**.
Identificamos que muchas veces repetimos código entre clases de diferentes jerarquías. Una opción que ya vimos arriba era, entonces, modificar el mecanismo de herencia.

Los traits en cambio, adoptan otro enfoque. Intentan encontrar otra forma de compartir código entre clases. Podemos pensar que este es un mecanismo para **componer** **una clase**.

Los traits aparecen como **pedacitos de código** que podemos introducir y combinar internamente en nuestra clase.

Solo cumplen la función de **unidad de reutilización** que cumplen las clases, pero no la de creadoras de instancia. Es decir que uno no puede instanciar un trait.
Pensemos los traits como los ladrillos que utilizamos para construir la clase internamente.

A diferencia del mixin, **no forma parte de la cadena de delegación**, como un elemento más, ya que en realidad la construcción no tiene sentido en tiempo de ejecución. Un trait simplemente sirve para construir una clase (agregar métodos, por ejemplo), pero no modifica el mecanismo de herencia.  Siguen siendo clases, solo que sus métodos se construyeron y combinaron (reutilizaron).

## []()Ejemplos Básicos

### []()Lenguaje Pharo
Para los ejemplos a continuación se va a utilizar el lenguaje Pharo.


Una características de los traits de Pharo es que **no pueden tener estado, **sólo definen método. Si el trait necesita estado, entonces este debe ponerse en la clase (ver la sección correspondiente para más detalles).


Otra limitación en comparación con los mixins de Scala es que un trait en Pharo no puede ser aplicado sobre un objeto, sólo a las clases.

## []()Primer trait simple

Un trait se define en el mismo panel donde se definen las clases, con la siguiente sintaxis:




        Trait named: #Filosofo
            uses: {}

            category: 'Paco-Examples-Traits'



Donde

* `Filosofo` es el nombre del trait
* `'Pharo-Traits-Examples'` es la categoría en la que se ubica el trait.
* La sección `uses: {} `permite definir un trait que a su vez use a otros traits, lo que se explicará más adelante.



Para definirle un método al trait es análogo a definirlo en una clase:


        Filosofo >> filosofar
            self logCr: 'Consumo memoria, ergo existo'


Para aprovechar el trait debemos definir una clase que lo use:






        Object subclass: #Socrates
 `uses: Filosofo`
 `instanceVariableNames: ''`
 `classVariableNames: ''`
 `poolDictionaries: ''`
 `category: 'Paco-Examples-Traits'`


Es decir, la clase Socrates usa al trait Filosofo. Una vez hecho eso, las instancias de Socrates entienden el mensaje `#filosofar`:




        socrates := Socrates new.
        socrates filosofar.
### []()Múltiples traits sobre una clase

Para aplicar más de un trait sobre una clase:





        Trait named: #Charlatan
            with: {}

            category: 'Paco-Examples-Traits'



        Charlatan>>mentir
            self logCr`: 'Te conté que trabajé en Hollywood?'`
        



        Object subclass: #Jacobo
 `uses: Charlatan + Filosofo`
 `instanceVariableNames: ''`
 `classVariableNames: ''`
 `poolDictionaries: ''`
 `category: 'Paco-Examples-Traits'`


La clase Jacobo tiene tanto los métodos de Filosofo como de Charlatan. siempre y cuando no haya *conflictos, *es decir mientras no definan ambos traits un método con el mismo nombre.  (La resolución de conflictos se explica más adelante.)
### []()Requerimientos de un trait (o trait abstracto)

Un trait puede utilizar métodos que no implementa. En ese caso, el trait *requiere *que la clase en la que ese trait se usa, esté definido el método correspondiente.


Por ejemplo el trait a continuación requiere que se implemente un método #precio.






        Trait named: #Alquilable
            with: {}

            category: 'Paco-Examples-Traits'



        Alquilable >> alquilarA: unInquilino
            unInquilino cobrar: self precio.


Como se ve, el trait envía el mensaje #precio a self, pero no lo implementa. Decimos entonces que ese es un ***requerimiento*** del trait. Un *método requerido* es similar a un método abstracto.


En Pharo no hay una forma de definir un método requerido, por lo tanto se suele implementar de la siguiente manera:




        Alquilable >> precio
            self requirement



Esta implementación es sólo para documentación y en caso de no sobreescribirse el método precio tiraría una excepción al ser invocada.


Puede pasar que un requerimiento de un trait sea implementado por la clase que lo usa o por otro trait, por ejemplo:




        Trait named #Gratuito
            with: {}

            category:  'Paco-Examples-Traits'



        Gratuito >> precio
            ^ 0



Con esas definiciones de Alquilable y Gratuito, podemos definir:




        class BicicletaPublica
            uses: Alquilable + Gratuito

 `instanceVariableNames: ''`
 `classVariableNames: ''`
 `poolDictionaries: ''`
 `category: 'Paco-Examples-Traits'`


### []()Manejo del estado

Como se dijo, Pharo, por una cuestión de simplificar la implementación, no permite que los traits definan estado. 


La forma de administrar esta limitación es utilizando requerimientos. Cuando un trait requiere recordar un valor, lo accede a través de mensajes **accessors y mutators** (a veces mencionados como *getters y setters).*
*
*
La clase usuaria del trait (que obviamente sí puede definir estado) es responsable de proveer la implementación de esos mensajes. Con frecuencia las implementaciones serán respectivamente accessor y mutator a alguna variable de instancia, pero el mecanismo no lo exige.


Para ejemplificar el comportamiento extendemos el trait Alquilable para recordar el inquilino:




        Alquilable >> alquilarA: unInquilino
 `self estaDisponible`
 `ifTrue: [ `
 `unInquilino debitar: self precio.`
 `self inquilino: unInquilino.`
 ` ] `
 `ifFalse: [ self error: 'No esta disponible' ]`


        Alquilable >> estaDisponible
            ^ self inquilino isNil



        Alquilable >> devolver
            ^ self inquilino: nil





Luego, nuestra definicion de bicicleta puede cambiar a:






        class BicicletaPublica
            uses: Alquilable + Gratuito

 `instanceVariableNames: 'inquilino'`
 `classVariableNames: ''`
 `poolDictionaries: ''`
 `category: 'Paco-Examples-Traits'`


        BicicletaPublica >> inquilino
            ^ inquilino


        BicicletaPublica >> inquilno: nuevoInquilino
            inquilino := nuevoInquilino


De esta forma nuestro trait Alquilable establece tres requerimientos:

* precio (provisto por el trait Gratuito)
* inquilino e
* inquilino: (ambos provistos por la clase BicicletaPublica.



Nótese que no hay ninguna diferencia entre los tres requerimientos, el trait no distingue si precio es implementado como un accessor a una variable de instancia o cualquier otro método arbitrario.
Por ejemplo, el mismo trait Alquilable podría ser utilizado por otra bicicleta con precio:








        class **`Bicicleta`**

            uses: **`Alquilable`**


 `instanceVariableNames: 'inquilino`**`, precio`**`'`
 `classVariableNames: ''`
 `poolDictionaries: ''`
 `category: 'Paco-Examples-Traits'`


        Bicicleta >> inquilino
            ^ inquilino


        Bicicleta >> inquilno: nuevoInquilino
            inquilino := nuevoInquilino


``**Bicicleta >> precio**``
        **    ^ precio`
**`
        **

**

``**Bicicleta >> precio: nuevoPrecio**``
``**    precio := nuevoPrecio**`
        

        En este caso, los tres requerimientos son resueltos por accessors y mutators a variables de intancia de la clase.
## []()Apuntes de Clase (TODO: refactorizar)

Diferencias entre traits de pharo respecto de los mixins de Scala:



* No se pueden aplicar a objetos:

 * Solo sirven para construir clases.
* No tienen estado

 * se implementa con getters y setters como requerimientos
* Los requerimientos pueden ser implícitos.

 * Luego fallará con Message Not Understood
* No trabaja con **Linearización**, sino con **Flattening.**


**

**

### []()**Flattening**


Funciona como si copiara los mètodos del trait a la clase a la que aplicamos.
Para el ejemplo de Scala que teníamos

class Pato extends Ave with Nadadora with Voladora


Ave:
 - ponerHuevos()


Voladora:
 - volar()
Nadadora
  - nadar()


Pato
  - mandarseUna


// hacer un dibujito de la linearizacion vs flattening


Flat de Pato queda


Ave
-----
ponerHuevos


A
 |
 |
 |
Pato
-----------
volar                     <---- "copiados"
nadar                     <---- "copiados"
mandarseUna






***Problemas:***


1. Si existe màs de un mètodo con el mismo nombre en algun lugar de la jerarquia (Pato, o Nadadora, Voladora, etc). Es decir "conflictos"
1. Si uso super() tengo problemas.



El modelo linearizado se caracteriza por tener una ùnica estrategia para resolver mètodos (es decir que si hay conflicto, se resuelve automàticamente). En el camino, además, gané el "super", porque al existir un "orden"  de la linearización, lo puedo usar.


En cambio el flattening no resuelve conflicto automaticamente, yo lo tengo que hacer manualmente.
Además no hay un orden ni muchas clases/traits que se encadenen. Con lo cual perdí esa capacidad (por ejemplo de redefinir y reutilizar igualmente el comportamiento original).


### []()**Caracterización de los "conflictos"**



* Clase vs Trait
* Trait vs Trait
* Superclase vs Trait

#### **[]()**Clase/trait**


Agregamos el "mandarseUna" en "Voladora". => conflicto entre Pato y Voladora.
En mixin no pasa nada. Gana el de pato, que sobrescribe.
En pharo: gana la clase, porque solo se copian los mètodos de los traits que no están tambièn definidos en la clase a la que voy a aplicar.
Ojo, que el efecto es que perdemos la implementaciòn "mandarseUna" que venía de "Voladora".


#### **[]()**Superclase/trait**


Para generar el conflicto, aagergamos "ponerHuevos" al trait Voladora.
En la linearización se agrega a la "anonima". Sigue la misma regla.  Gana el del mixin (sobrescribe el de Ave). Incluso estan los dos, asi que lo puedo usar. con "super".


En traits pasa lo mismo. Se copia el mètodo del trait al Pato. Gana ese. Pero sigue estando accesible el del Ave.


#### **[]()Trait/trait

Ponemos "nadar" en Voladora.
En la lineraización quedan todos los mètodos, uno en cada anònima. Gana el ùltimo mixin aplicado (Voladora). Que sobrescribe al mètodo de Nadadora. Puedo reutilizarlo con super.


En flattening y en particular en la impl de Pharo, nos fuerza a nosotros a resolverlo "a mano".


Para eso, existe un **algebra de traits**.


### []()Algebra de Traits (operaciones)

Son operaciones que puedo hacer sobre los traits.
Tiene 3 operaciones:

* **Suma: **


 * t1 + t2 = t3
 * No resuelve conflictos ! t3 puede tener conflictos !
* **Resta:**


 * Me permite resolver conflictos.
 * t1 - { s1 }
 * Donde t1 es un trait y s1 es el nombre de un selector.
 * Esto genera un nuevo trait que es como el "t1" pero descartando el método "s1"
* **Alias: **


 * ***REVISAR: está bien esto Nico ?***

 * Permite agregar un mètodo del trait con otro nombre
 * t1 @ { #s_nuevo -> #s_original }
 * Ojo que igual agrega el mètodo original, asì que si tenìa conflicto, se mantiene el conflicto.
 * Para resolver conflicto se usa en conjunto con la resta y ahí sí, me permite además tener acceso a los mètodos originales.



Ejemplo de resta:




Persona subclass: #JacoboWinograd`
            uses: Filosofo - { #filosofar } + Charlatan




#### **[]()Operaciones sobre traits



[![](https://sites.google.com/site/programacionhm/_/rsrc/1346699905526/conceptos/traits/TraitOperations.png)
](conceptos-traits-TraitOperations-png?attredirects=0)
### []()Herencia de Traits

### []()Un trait puede heredar de otro trait ? Sì, un trait tiene el "uses" al declararlo.


* Mismas reglas, el trait le gana a sus propios traits aplicados.
* Ahora, para el que lo usa, es lo mismo saber que está usando un único thread, o si ese heredabad e otros.
* En realidad el que usa este trait va a estar usando un unico trait que ya se contruyó una única vez.


### []()**Discusión Linearizado vs Aplanado.**


La diferencia màs característica es que en la linearizacion la resolucion de conflictos es automática. En el aplanado,  es manual.
*Ventajas:*

* **Automatico**: me olvido de resolverlo, si entiendo la mecánica.

* **Manual**: me permite hacer más cosas

## []()Para leer

* [Paper seminal de traits](http://scg.unibe.ch/archive/phd/schaerli-phd.pdf), de Nathaniel Shaerli y Stéphane Ducasse
* [Traits: Composable Units of Behaviour](http://scg.unibe.ch/archive/papers/Scha03aTraits.pdf), de Nathanael Schärli, Stéphane Ducasse, Oscar Nierstrasz, and Andrew P. Black
* [Traits vs Aspectos](http://blog.objectmentor.com/articles/2008/09/27/traits-vs-aspects-in-scala)
* [Traits en PHP](http://www.php.net/manual/es/language.oop5.traits.php)

## []()Temas Relacionados


* [Perl6 tiene una idea similar llamada "Roles"](http://en.wikipedia.org/wiki/Perl_6#Roles)

### []()