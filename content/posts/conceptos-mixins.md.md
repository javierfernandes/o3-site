[[_TOC_]]


## []()Descripción

* Un **Mix-In** es una **subclase abstracta**: como una subclase que no está ligada a ninguna superclase.

 * Se puede "aplicar" a cualquier superclase (can be "mixed-in")
* Se puede ver como una refactorización de la herencia hacia una [*"chain of resposibilities"*](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern).

 * En una herencia normal, cada clase (nodo) de la cadena, conoce exactamente a su siguiente (superclase). Por lo que la cadena es "rígida".
 * Un mixin es un nodo que no conoce está atado al siguiente en la cadena, aunque puede usarlo (como en el CoR de GoF). Por lo que se puede reutilizar y aplicar a diferentes "cadenas". Es decir que el dispatch de un mensaje a **super **desde un mixin, es **dinámico**.
* Otra forma de verlo, es que son como interfaces de Java/xtend pero que pueden definir estado y comportamiendo (implementaciones a los métodos)

### []()Concepto:

* Cumplen el rol de la **reutilización** que cumple una clase, sin tener el rol de ser "generadores de instancias".
* Representan o modelan un cierto "feature" que puede ser reutilizado y aplicado a varias clases en diferentes jerarquías (vínculo con AOP)
* Generalmente se utilizan para roles o características de una clase, por ejemplo: *Observable*.
* No presentan el *problema del diamante* de la herencia múltiple, ya que el orden de composición actúa como técnica de resolución implícita, que depende de la **linearización**.

## []()Mixins en Scala

En Scala no existen las "interfaces" como en Java. En cambio posee otro mecanismo llamado **mixins**. Quizás sea algo confuso porque en el lenguaje se denominan "**traits**", que para nosotros es en realidad otro concepto que veremos en la materia implementado en Pharo Smalltalk.
La diferencia está en la forma en que se componen a las clases, y por ende la resolución de conflictos. Igual no se preocupen si por ahora no se entiende esta diferencia.


### []()Primer mixin simple (sobre una clase)

Un trait se define parecido a una clase, pero con la el keyword "trait".





        **trait** Filosofo {
          **def** filosofar() {
            println("Consumo memoria, ergo existo")
          }
        }


Luego, se aplica a una clase. Si la clase no tiene una superclase **debemos** usar **extends**.





        **class** Socrates **extends **Filosofo {
 `**def **hablar() {`
 `  filosofar()`
 `}`
        }


En cambio, si la clase ya hereda de otra clase, se **debe** utilizar el **with.**




        **class** Persona
        **class** Platon **extends** Persona **with** Filosofo {
 `**def** hablar() {`
 `filosofar()`
 `}`
        }


En ambos casos vemos que un método de la clase, está utilizando el "filosofar()" que se agrega con el mixin. Esa es una opción.
### []()El mixin define un tipo

Otra opción, es utilizar el método desde el cliente de los objetos.



        **val** socrates = new Socrates
        socrates.filosofar


Estamos llamando directo al método "filosofar" que está definido en el mixin.
O sea que el mixin sirve para componer a la clase, incluso agregando mensajes públicos que luego utilizamos como clientes del objeto.
De acá se desprende además, que el Mixin, al igual que una clase, o una interface en Java, **define un Tipo.**

Ejemplo:



        **val** filosofos : **List[Filosofo]** = List(**new** Socrates, **new** Platon)
        filosofos foreach { f => f filosofar }
Acá vemos que la lista es de tipo Lista de Filosofos (que es el mixin).
### []()Mixin sobre un Objeto

En Scala además de definir una clase, uno puede crear un objeto y ahí mismo "construir la clase". Algo así como una clase "anónima" en java. Ésto viene un poco por el lado de los mixins. Para poder combinarlos sin tener que crear muchas clases.
Apliquemos el filósofo a un objeto cualquiera.





        **val** objeto = **new **Object() **with **Filosofo
        objeto.filosofar
 
A este object ahora, lo podemos tratar como un filósofo.
De paso mostramos que se pueden definir métodos ahí mismo abriendo llaves :





        **val** objeto = **new **Object() **with **Filosofo {
        **   def** hablar() {
              filosofar()
           }
        }


Esta habilidad de instanciar una clase y agregarle comportamiento ya existía en Java (para los que vienen de Java) y se llamaba "clases anónimas".
A nivel del lenguaje esto es similar a hacer dos cosas a la vez:

* definir una clase nueva (aunque con otra sintaxis, y no le damos un nombre)
* Llamarle a new para instanciar

Vamos a volver sobre esto más adelante.

### []()Múltiples mixins

Como con las interfaces, podemos aplicar varios mixins a una clase.
Definimos otro trait



        **trait** Charlatan {
          **def** mentir() {
            println("Te conté que trabajé en hollywood ?")
          }
        }
Luego aplicamos ambos



        **class** JacoboWinograd **extends** Persona **with** Filosofo **with** Charlatan {
          **def** hablar() {
            filosofar()
            mentir()
            mentir()
          }
        }
### []()Mixin con estado

Un mixin en scala puede definir estado además de comportamiento.



        **trait** Sedentario {
          **var** viveEn : String
        }
En este caso definimos un atributo, con lo cual Scala genera además los getters y setters.





          **val** s = **new** Socrates with Sedentario
          s.viveEn = "Grecia"
### []()Mixin no puede tener parámetros (constructores)

A diferencia de las clases, no podemos hacer esto

        **

**



**`trait`**` Sedentario(`**`var`**` viveEn : String) {`


        }Es decir que un trait no puede tener constructores.
### []()Mixin abstracto (con requerimientos)

Un mixin puede definir un método abstracto. Esto quiere decir que al aplicarlo a una **construcción**, ésta debe implementar ese método, de otra forma no va a compilar.


Ojo acá que no decimos "aplicarlo a una **clase**", sino explícitamente **construcción**.
Porque ya vimos que un trait se puede aplicar al definir una clase, o al crear un objeto.


Ejemplo: hacemos un trait que sirve para aplicar la lógica de que un objeto puede ser alquilable. Va a tener como estado quien es el inquilino actual, y un método para ser alquilado. Luego podemos aplicarlo a cualquier clase que querramos que sea Alquilable





        **trait** Alquilable {
            **var** inquilino : Inquilino = **null**

            **def** alquilarA(inquilino : Inquilino) {
              inquilino debitar precioDeAlquiler
            }
            
            **def** precioDeAlquiler : Int
          }


Atenti que la lógica de alquilarA, le debita plata al inquilino. Pero cuanto ?? Eso depende del objeto que estemos alquilando. Entonces define un método abstracto "precioDeAlquiler". Esto quiere decir que ahora solo se puede aplicar este trait a una construcción que entienda ese mensaje.
Acá el código de Inquilino:



        **class** Inquilino(**var** saldo : Int) {
            **def** debitar(cuanto:Int) {
              saldo -= cuanto
            }
          }


Y ahora lo aplicamos a dos clases con implementaciones distintas:



        **  class** Pelicula **extends** Alquilable {
            **override def** precioDeAlquiler = 8
          }
          
          **class** JuegoPS3(**var** precio : Int) **extends** Alquilable {
            **override def** precioDeAlquiler = precio
          }


La pelicula devuelve un valor fijo, en cambio el juego de ps3 se configura con un atributo. Podríamos tener otras implementaciones distintas.
También podemos aplicarlo a un objeto





        **val** alqui = **new** Object **with** Alquilable {
            **override def** precioDeAlquiler = 43
        }
        alqui.alquilarA(**new** Inquilino(200))


Ya lo aplicamos a una clase y a un objeto. 
También podemos hacer que la implementación de "precioDeAlquiler" no esté en la clase, sino en otro mixin !





          **trait** Preciable {
          **  var** precioDeAlquiler : Int
          }
Representa a un objeto que tiene un precio (define un atributo y sus accesors)
Ahora lo usamos con cualquier cosa loca:





        **val** socratesEsclavoAlquilable = **new** Socrates **with** Preciable **with** Alquilable
        socratesEsclavoAlquilable.precioDeAlquiler = 200
        socratesEsclavoAlquilable.alquilarA(**new** Inquilino(1000))




## []()Mixins para herencias paralelas (Ejemplo de Aves)

Vamos a modelar las aves. Son animales cuyas extremidades delanteras son alas, que les permiten volar.







        **class** Ave {
        **  def** volar = println("volare oh oh")
        }


        **class** Gorrion extends Ave
        **class** Halcon extends Ave

Tanto el gorrión como el halcón son aves, con lo que reutilizan el comportamiento de volar. Obviamente en un ejemplo real, además cada subclase debería tener un comportamiento adicional propio. Pero acá estamos tratando de simplificar un poco para no confundir.
Ahora, qué pasa con **el Pingüino** ? Es una ave, porque tiene alas en lugar de patas delanteras, sin embargo **no puede volar** !
Una solución entonces sería introducir una **clase intermedia**.


        **class** Ave
        **class** AveVoladora** extends** Ave {
        **  def** volar = println("volare oh oh")
        }
        **class** Gorrion **extends** AveVoladora
        **class** Halcon** extends** AveVoladora
        **class** Pinguino **extends** Ave  // el pinguino no vuela
Perfecto. Ahora, resulta que queremos **agregar al Pato**. Nos damos cuenta de que es una **ave voladora y** que además es **acuática, es decir que nada**

Una opción es agregar el método "nadar" a AveVoladora


**`class`**` ``AveVoladora`**` ``extends`**` ``Ave {`
**`  def`**` ``volar = println("volare oh oh")`
        **  def`**` ``nadar = println("nado nado nado")``
        }
Otra opción es agregar una clase intermedia **AveNadadora** que extienda de AveVoladora, que permitiría modelar la idea de aves voladoras que no sean nadadoras.


**`class`**` ``AveAcuatica`**` ``extends`**` ``AveVoladora {`
**`  def`**` ``nadar = println("nado nado nado")`
        }
Nos queda una jerarquía así
        Ave/
        ├── AveVoladora
        │   ├── AveAcuatica
        │   │   └── Pato
        │   ├── Gorrion
        │   └── Halcon
        └── Pinguino
Ahora, nos damos cuenta que **el Pingüino también es un excelente nadador**. Pero no podemos hacer que extienda de AveAcuática porque lo haríamos volador! Y el Pingüino no vuela !
Acá entonces vemos una limitación de la herencia simple.
Ahí es donde aparecen los mixins. Necesitamos modelar las habilidades de las aves, de forma que puedan ser combinadas en diferentes clases, atravesando la jerarquía!
En java esto se soluciona agregando una interfaz, que pueden implementar tanto el Pinguino, como al Pato. Pero la contra es que igualmente el código de la implementación lo tenemos que escribir duplicado en ambas clases.
En scala los (mal llamados) traits (que son mixins), nos permiten definir también el comportamiento y luego aplicarselo a cualquier clase.
Entonces hacemos los mixins:


        
**trait** Voladora {
          **def** volar = println("["+ this.getClass + "] volare oh oh")
        }
        **

**

        **trait** Nadadora {
            **def** nadar = println("["+ this.getClass + "] nado nado nado")
        }


Y ahora podemos aplicarlos al definir cualquier clase, como en java escribíamos el "implements"





        **class** Ave
        **class** Gorrion **extends** Ave **with** Voladora
        **class** Pinguino** extends** Ave** with** Nadadora
        **class** Pato **extends** Ave **with** Nadadora **with** Voladora
        




* El gorrión habíamos dicho que era un ave "normal" que volaba, así que le aplicamos el trait Voladora.
* El Pinguino no vuela, pero nada. Así que le aplicamos el trait Nadadora.
* El Pato tanto nada como vuela, por lo que le aplicamos los dos traits.

Veamos entonces un poquito de código que use a las aves.



        **object** TraitsDeAves {
          **def** main(args: Array[String]) {
 ` `` **val** nadadores = List(**new** TPinguino, **new** TPato)`
        

 ` `` nadadores foreach { n => n.nadar }`
          }
        }
La lista "nadadores" se infiere automáticamente al tipo del trait **List[Nadadora]. **Esto nos permite tratar a las aves, no importa su clase, como nadadoras. Igual que con una interface de java. Por eso luego en el foreach estamos haciendo que naden.
## []()Mixins con sobrescritura (override)

Hasta ahora veníamos trabajando con mixins que agregaban un nuevo comportamiento. En el sentido de agregar nuevos mensajes que hasta ahora la clase base no entendía.
Es común modelar con mixins otro caso en el que queremos que el mixin **modifique un comportamiento ya existente en la clase base.**

Eso en herencia simple sería sobrescribir un método de la superclase.


Bueno, en mixins es bastante similar.


Ejemplo. Supongamos esta clase base muy simple con un comportamiento.




        **class** Persona {
            **var** edad = 0


            **def **envejecer() {
                edad += 1
            }
        }


Supongamos que tenemos varias subclases que hacen diferentes cosas, como un Carpintero, un Doctor, etc. Y sin embargo ahora queremos modelar la idea de diferentes "formas" de envejecer, y poder aplicárselas a todas esas clases.
Entonces, estamos forzados a modelarlo con mixins (y además está bueno :P)


Por ejemplo, un mixin para **EnvejeceElDoble **que haga que si a la persona le digo "envejece" esta envejezca 2 años en lugar de 1 !


Este mixin no va a agregar un nuevo método. Sino que tiene que redefinir el envejecer() !
Esto es importante porque no queremos que los que usen Persona le tengan que mandar un mensaje nuevo (como envejeceDoble()) diferente al original. Queremos que se mantenga el polimorfismo !!


Entonces uno está tentado a hacer esto (y más aún si viene de lenguajes sin checkeos estáticos)




        **trait** EnvejeceElDoble {
             **def** envejecer() {
                edad += 2
             }
        }


Sin embargo cuando quieran combinar este mixin con la clase Persona en una subclase, van a tener un error. Un "conflicto"




        **class** Carpintero **extends** Persona **with** EnvejeceElDoble {  
            *// ERROR ! conflicto entre Person.envejece() y EnvejeceElDoble.envejece()*
        }
Esto es porque si bien los métodos se llaman iguales para Scala (igual que pasaba en java) son métodos distintos. Porque nada le indica en lo que escribimos que **"la intención del EnvejeceElDoble.envejece() es sobrescribir Persona.envejece()".**

(Incluso este ejemplo va a fallar antes, el trait no va a compilar porque no conoce "edad")
Mentalmente estábamos pensando este para que "funcione" con Persona. Queríamos acceder a su "edad" y sobrescribir el "envejece". Sin embargo nunca se lo dijimos a Scala.
Entonces, la forma correcta de hacer esto es


**`trait`**` EnvejeceElDoble `**`*extends Persona* `**`{`
             **`*override* def`**` envejecer() {`
                edad += 2
             }
        }
        
Esto, si se quiere se puede pensar como que "este trait" se aplica a Personas. Eso nos permite saber que "this" va a ser una persona, entonces podemos acceder a su edad y sobrescribir cualquier método.



## []()Sobrescritura con Super

Una variante al mixin anterior es no tocar la edad diréctamente sino pensarlo como "hacer dos veces el comportamiento de envejecer". Lo cual lo hace más "extensible" (ya vamos a ver al combinar mixins).


Eso, se puede hacer igual que en una sobrescritura de clases, con "super"




**`trait`**` EnvejeceElDoble `**`*extends Persona* `**`{`
             **`*override* def`**` envejecer() {`
                super.envejecer()
                super.envejecer()
             }
        }
        




## []()Sobrescritura con Combinación (múltiples sobre-escrituras)

Vimos que un mixin se puede "meter" para sobrescribir un comportamiento de la clase base.
Pero también vimos antes que podíamos aplicar más de un mixin. 
Entonces el caso que sigue sería combinar estas dos cosas.


Pensamos otro mixin de envejecer: **Rejuvence.** Este mixin hace que la persona decremente su edad en lugar de incrementarla (como Benjamin Button :P).
La implementación es parecida a la anterior





**`trait`**` Rejuvenece ``**extends **Persona`` ``{`
             **`override`` def`**` envejecer() {`
*`    ``    ``  ``edad -= 1`*

             }
        }
        

Ahora qué pasa si los combinamos ?




        **class** Carpintero **extends** Persona **with** Rejuvenece **with** EnvejeceDoble {
        }


        **val** carpintero  = **new** Carpintero()
        carpintero`.envejecer()`
        carpintero.edad    // ??


Qué va a imprimir ?


Respuesta: - 2 !


Y si los invertimos ?



**class** Carpintero **extends** Persona **with** EnvejeceDoble **with** Rejuvenece {


Ahora: - 1


Esto es porque el orden importa ! En el mismo sentido en que en una herencia común se hace un method lookup buscando la implementación más concreta.
Acá se ve la característica principal del mecanismo de mixins que es **la "linearización".**

**

**

Si bien hasta ahora se parecía mucho a una herencia múltiple, los mixins garantizan que nunca hace una herencia de este tipo: 

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Diamond_inheritance.svg/220px-Diamond_inheritance.svg.png)
](https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Diamond_inheritance.svg/220px-Diamond_inheritance.svg.png)


Es decir, nunca un clase D va a tener dos super classes (o traits). Porque esto lleva a conflictos.
En cambio, los mixins en forma estática (al momento de compilar el código, o de leerlo si se quiere) ya garantizan una herencia "lineal" ! donde cada nodo tiene un sólo padre.
De esta forma (de la derecha)

[![](http://julienrf.github.io/scala-lessons/course/Traits.png)
](http://julienrf.github.io/scala-lessons/course/Traits.png)

Entonces esto:
**class** Carpintero **extends** Persona **with** Rejuvenece **with** EnvejeceDoble {


Se lee así

* **defino una nueva clase Carpintero: **esta va a ir **abajo de todo**, porque tengo el control de sobrescribir lo que quiera. Es la "más concreta"
* **esta clase extiende de Persona: **esta clase va "arriba"  de Carpintero (y arriba de todo)
* **mezclo los mixins: **de acá el nombre. Los mixins se van a meter entra la super clase (Persona) y nuestra clase (Carpintero). En orden Derecha -> Izquierda  (dibujandolas desde Arriba -> Abajo)

Quedaría así



[![](https://sites.google.com/site/programacionhm/_/rsrc/1472914907297/conceptos/mixins/mixins-envejece1.png)
](conceptos-mixins-mixins-envejece1-png?attredirects=0)
Y entonces ahora aplican las mismas reglas de siempre en herencia simple !
Si le mando el mensaje "envejecer()" a Carpintero, cuál se va a ejecutar ?

1. **Doble** que llama a super
1. **Rejuvenecer** (es el super de Doble). Este resta en 1.
1. Luego, de nuevo **Doble** llama a super (recuerden que llama dos veces)
1. **Rejuvenecer** vuelve a restar 1
1. Termina, con edad = - 2

Ahora si invertimos la declaración como en el segundo ejemplo


**class** Carpintero **extends** Persona **with** EnvejeceDoble **with** Rejuvenece {



[![](https://sites.google.com/site/programacionhm/_/rsrc/1472915183440/conceptos/mixins/mixins-envejece2.fw.png)
](conceptos-mixins-mixins-envejece2-fw-png?attredirects=0)



Es fácil ver que el método que se va a ejecutar es el de Rejuvenecer (el más concreto, el "más abajo"). Y este método simplemente resta 1 a la edad y nunca llama a super ni nada.

Con la cual el resultado es edad = - 1


Entender la linearización es escencial para hacer cosas avanzadas con mixins, cosas poderosas, como estas que permiten sobrescribir y combinar mixins.


Más a continuación

## []()Linearización en Scala

Para terminar de entender cómo se resuelven los métodos y como se combinan los mixins, hay que entender el mecanismo de "linearización". 
O sea, los mixins (y esto es lo que los diferencia de los traits), no conforman un grafo de delegación, como en la herencia múltiple (que podría formar el famoso problema del diamante), sino que conforman una linea única, parecido a una herencia simple.
Para eso, los mixins se aplican en un orden.
Veamos un ejemplo
```
 class Animal 
```
```
 trait Furry extends Animal trait HasLegs extends Animal trait FourLegged extends HasLegs class Cat extends Animal with Furry with FourLegged
```
```
La clase Cat genera una linea de delegación así:
```
```

[![](https://www.artima.com/pins1ed/images/linearization.jpg)
](https://www.artima.com/pins1ed/images/linearization.jpg)
Las flechas oscuras representan la linearización. Las demás, las relaciones de herencia. Nótese que siempre se busca el camino más largo, por el lado de la derecha. Por ejemplo de HasLegs, no pasamos directo a Animal, sino que vamos a tratés de Furry.
La "linearización" o linea negra nos indica por dónde se va a resolver un llamado a "super"
## []()Stackable Traits Pattern

```

Es un "patron" de diseño que, a traves de traits, nos permite definir comportamiento que se va combinando, como "apilando", uno sobre otro, y redefiniendo comportamiento.
Veamos un ejemplo.
Tenemos una estructura tipo "cola". Para eso definimos una clase abstracta con el contrato de la misma y una implementación base que utiliza un ArrayBuffer.





        **abstract class** Cola {
          **def** get(): Int
          **def** put(i : Int)
          **def** size : Int
        }


        **class** ColaBasica **extends** Cola {
          **private val** buffer = ArrayBuffer[Int]()
          **override def** get() = buffer remove 0
          **override def** put(i:Int) { buffer += i }
          **override def** size = buffer size

        }
        

        

Esto se usaría así



        **val** c = **new** ColaBasica
        c put 3
        c put 10
        c put 1
        println(c get)
        println(c get)
        println(c get)


Ahora vamos a necesitar un par de "comportamientos", como "filtros" para aplicar a las colas y así modificar su comportamiento. 

* **Duplicador:** cuando se agrega un elemento, en realidad agrega el resultado de multiplicarlo por 2
* **Incrementador:** que agrega el número dado incrementado por 1.

Codificamos traits para estos. El primero



        **trait** Duplicador **extends** Cola {
          **abstract override def** put(i:Int) {
            **super**.put(2 * i)
          }
        }
El trait hereda de Cola, ya que la idea es que intercepte el llamado a put.
Ahora, el trait no va a implementar el put "completo", sino solo un agregado, pero va a necesitar utilizar una implementación **concreta**.
Sin embargo si miramos en Cola, el método es abstracto. Entonces por esto es que necesitamos marcarlo como **abstract override**. 
Lo que quiere decir con **abstract override** es que queremos sobrescribir la implementación que vaya a tener la clase sobre la que va a aplicar el trait. El efecto que va a tener esto es que **este trait sólo se va a poder aplicar a una subclase de Cola que ya tenga implementado el método put**.
Se usaría así:


         ` **val** duplicada = **new** ColaBasica **with** Duplicador`
         ` duplicada put 3`
         ` println(duplicada get)`
Lo cual imprime "6"
Acá vemos un diagrama:
[![](https://sites.google.com/site/programacionhm/_/rsrc/1394913368127/conceptos/mixins/mixins-cola-duplicador.png)
](conceptos-mixins-mixins-cola-duplicador-png?attredirects=0)
El eslabón más bajo dice "anónima" ya que estamos aplicando el mixin a un objeto. Esto genera una clase anónima.
La linearización queda:
* **Anónima -> Duplicador -> ColaBasica -> Cola**


Por esto es que al ejecutar "super" en Duplicador, se ejecuta el método de ColaBasica y no el de Cola.


Podríamos haber puesto solo "override" ?
Sí, claro. Querría decir que el trait está implementado el método put que era abstracto.
Peeeero, en su cuerpo no hubieramos podido usar el "super" (no compila!), porque claro, arriba está abstracto !, no podemos llamarlo.
Este caso podría servir para un trait que no hace nada en el put, Ejemplo, Cola Inmutable.


**`trait`**` ``Inmutable`` `**`extends`**` ``Cola {`
         ` `**`override def`**` ``put(i:Int) {`
           ` // no hace nada`
          }
        }
Veamos un ejemplo de cómo usar esto

          **val** inmutable = **new** ColaBasica **with **Inmutable
          inmutable put 3
          println("tamanio", inmutable size)
Al ejecutar este código, vamos a ver que el tamaño de la cola es 0. Porque en este caso se ejecutó el "put" del trait.
Otro caso. Si el método en Cola no fuera abstracto y tuviera una implementación, el trait Duplicador podría definir el método como **"override def" **e igual utilizar el **super**.

        **abstract class** Cola {
          `**def** put(i : Int) {`
            println("La Cola no hace nada al hacer put con " + i)
          }
        }
        **trait** Duplicador **extends **Cola {
          **override def** put(i:Int) {
            **super**.put(2 * i)
          }
        }
Y se usaría así:

        **val** duplicada = **new** ColaBasica **with** Duplicador
        duplicada put 3
        println("tamaño", duplicada size)
Cuando ejecutamos esto vemos que sí se insertó el elemento "6" en la cola, y que no se imprimió el mensaje de la implementación nueva, default de "Cola".
Esto quizás nos sorprenda un poco, porque si navegamos el "super.put(2*i)" nos va a llevar al la implementación de "Cola".
Sin embargo, lo que tenemos que entender es que, **el dispatch del "super" en realidad se hace en forma dinámica, y sobre la clase concreta sobre la que aplica el trait**.
En este caso la superclase va a ser ColaBasica, que implementa el put. Con lo cual, nunca se ejecuta la implementación de Cola.
La linearización de "**new ColaBasica with Duplicador**" es así:
* ****Anónima -> Duplicador -> **ColaBasica ->  Cola**


Implementamos ahora el Incrementador

        **trait** Incrementador **extends** Cola {
          **override def** put(i:Int) {
            **super**.put(i + 1)
          }
        }
Ahora podemos aplicar los dos traits

        **val** duplicadaConInc = **new** ColaBasica **with** Duplicador **with** Incrementador
        duplicadaConInc put 3
        println("+1, *2", duplicadaConInc get)Acá vemos que se puede aplicar más de un trait. Pero además que la ejecución de los métodos       depende del orden en que se hayan aplicado los traits. Se puede leer como de Derecha a Izquierda. 
[![](https://sites.google.com/site/programacionhm/_/rsrc/1394913779890/conceptos/mixins/mixins-colacondupeincrementador.png)
](conceptos-mixins-mixins-colacondupeincrementador-png?attredirects=0)En este caso la linearización es:
* **Anónima -> Incrementador -> Duplicador -> ColaBasica -> Cola**


El put se ejecuta así:
* **Incrementador**: super(3 +1)
* **Duplicador**:  super( 2 * 4)
* **ColaBasica**: buffer.put (8)

Lo cual termina agregando el 4 a la cola.
### []()Herencia de Traits

Un trait puede heredar de otro trait. En este caso aplica el mismo mecanismo de herencia que usamos cuando una clase hereda de otra.
Ejemplo:



        **trait** Cuatriplicador **extends** Duplicador {
          **override def** put(i:Int) {
            **super**.put(2 * i)
          }
        }
Este trait hereda del Duplicador, que también multiplica el "i" por 2.



        **val** cuatriplicados = **new** ColaBasica **with** Cuatriplicador
        cuatriplicados put 3
        println("*4", cuatriplicados get)


Esto va a imprimir 12. 
El diagrama quedaría:

[![](https://sites.google.com/site/programacionhm/_/rsrc/1394913821812/conceptos/mixins/mixins-cola-concuatriplicador.png)
](conceptos-mixins-mixins-cola-concuatriplicador-png?attredirects=0)
Por ende la linearización:

* **Anónima -> Cuatriplicador -> Duplicador -> ColaBasica -> Cola**


La ejecución es así.

1. Se ejecuta el "put" de Cuatriplicador. Este multiplica 3 * 2 = 6  y llama a super
1. Se ejecuta el método del trait heredado de Duplicador, que multiplica 6 * 2 y luego llama a super.
1. Se ejecuta finalmente el método de ColaBásica que agrega el 12 a la cola.

## []()Referencias / Bibliografía


* Especificación de las reglas de [linearización en Scala](http://jim-mcbeath.blogspot.com.ar/2009/08/scala-class-linearization.html#rules).
* [Paper seminal de Mixin-Based Inheritance](http://www.st.informatik.tu-darmstadt.de:8080/lehre/ss02/aose/Papiere/Thema1/flatt98classe.pdf), por Bracha y Cook.
* [Mixin-based Inheritance](conceptos-mixins-Paper%20-%20Bracha%2C%20Cook%20-%20Mixin-Based%20Inheritance-pdf?attredirects=0), por Bracha y Cook (otro link)
* [Otra definición de Mixins](http://www.st.informatik.tu-darmstadt.de:8080/lehre/ss02/aose/Papiere/Thema1/flatt98classe.pdf), de .Flatt, Krishnamurthi y Felleisen
* [Traits de Scala](https://www.artima.com/pins1ed/traits.html), Martin Odersky, Lex Spoon, and Bill Venners
* Un antecedente: [Flavors, de David Moon](http://dl.acm.org/citation.cfm?id=28698) (ese paper lamentablemente no se puede conseguir online gratuitamente, pero acá hay [otra publicación de David Moon sobre Flavors](ftp:-publications-ai-mit-edu-ai-publications-pdf-AIM-602-pdf)).

## []()Temas Relacionados
 
* [Traits](conceptos-traits)
* Chain of Responsibilities Pattern (?)

* Decorator Pattern (?)