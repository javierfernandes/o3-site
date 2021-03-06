---
title: "Mixins"
date: 2019-04-04T17:51:17-03:00
toc: true
menu:
  sidebar:
    parent: Conceptos
    weight: 1
---


# Descripción

* Un **Mix-In** es una **subclase abstracta**: como una subclase que no está ligada a ninguna superclase.
* Se puede "aplicar" a cualquier superclase (can be "mixed-in")
* Se puede ver como una refactorización de la herencia hacia una [*"chain of resposibilities"*](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern) (CoR).

* En una herencia normal, cada clase (nodo) de la cadena, conoce exactamente a su siguiente (superclase). Por lo que la cadena es "rígida".
* Un mixin es un nodo que no conoce al siguiente en la cadena, aunque puede usarlo (como en el CoR de GoF). Por lo que se puede reutilizar y aplicar a diferentes "cadenas". Es decir que el dispatch de un mensaje a `super` desde un mixin, es **dinámico**.
* Otra forma de verlo, es que son como interfaces de Java/xtend pero que pueden definir estado y comportamiendo (implementaciones a los métodos)

# Concepto

* Cumplen el rol de la **reutilización** que cumple una clase, sin tener el rol de ser "generadores de instancias".
* Representan o modelan un cierto "feature" que puede ser reutilizado y aplicado a varias clases en diferentes jerarquías (vínculo con AOP)
* Generalmente se utilizan para roles o características de una clase, por ejemplo: *Observable*.
* No presentan el *problema del diamante* de la herencia múltiple, ya que el orden de composición actúa como técnica de resolución implícita, que depende de la **linearización**.

# Mixins en Scala

En Scala no existen las "interfaces" como en Java. En cambio posee otro mecanismo llamado **mixins**. Quizás sea algo confuso porque en el lenguaje se denominan "**traits**", que para nosotros es en realidad otro concepto que veremos en la materia implementado en Pharo Smalltalk.
La diferencia está en la forma en que se componen a las clases, y por ende la resolución de conflictos. Igual no se preocupen si por ahora no se entiende esta diferencia.


## Primer mixin simple (sobre una clase)

Un trait se define parecido a una clase, pero con el keyword `trait`. Es decir es un elemento que tiene un nombre y que puede definir métodos.

```scala
trait Volador {
   def volar() {
     // eventualmente vamos a tener una impl con más sentido
     println("Volaré oh oh...")
   }
}
```

Luego, se aplica a una clase. Si la clase no tiene una superclase **debemos** usar extends.

```scala
class Superheroe extends Volador {
  def pasarUnDia() {
   volar()
  }
}
```

En cambio, si la clase ya hereda de otra clase, se **debe** utilizar `with`

```scala
class Ave {}
class Golondrina extends Ave with Volador {
 def pasarUnDia() {
   volar()
 }
}
```

En ambos casos vemos que un método de la clase, está utilizando el `volar()` que se agrega con el mixin. Esa es una opción.

## El mixin define un tipo

Otra opción, es utilizar el método desde el cliente de los objetos.

```scala
val pepita = new Golondrina
pepita.volar
```

Estamos llamando directo al método `volar` que está definido en el mixin.
O sea que el mixin sirve para componer a la clase, incluso agregando mensajes públicos que luego utilizamos como clientes del objeto.
De acá se desprende además, que el Mixin, al igual que una clase, o una interface en Java, **define un Tipo**.

Ejemplo:


```scala
val voladores : List[Volador] = List(new Golondrina, new Superheroe)
voladores foreach { v => v volar }
```

Acá vemos que la lista es de tipo `Lista de Volador'es` (que es el mixin).

## Múltiples mixins

Como con las interfaces, podemos aplicar varios mixins a una clase.
Definimos otro trait

```scala
trait SeAlimenta {
  def comer() {
    println("Comiendo")
  }
}
```

Luego aplicamos ambos

```scala
class Golondrina extends Ave with Volador with SeAlimenta {
  def pasarUnDia() {
    volar()
    comer()
    volar()
  }
}
```

## Mixin sobre un Objeto

En Scala además de definir una clase, uno puede crear un objeto y ahí mismo "construir la clase". Algo así como una clase "anónima" en Java. Esa capacidad en el contexto de los mixins nos permite combinarlos sin necesidad de escribir una clase, cuando es simplememte un uso muy particular.
Y esto tiene sentido en cuanto empezamos a modelar muchos comportamientos como unidades combinables. Luego una instancia en particular surge de combinar varios mixins. 

```scala
val objeto = new Object() with Volador
objeto.volar
```
 
A este `object` ahora, lo podemos tratar como un `Volador`.
De paso mostramos que se pueden definir métodos ahí mismo abriendo llaves:

```scala
val objeto = new Object() with Volador {
  def pasarUnDia() {
    volar()
  }
}
```

Esta habilidad de instanciar una clase y agregarle comportamiento ya existía en Java y se llamaba "clases anónimas".
A nivel del lenguaje esto es similar a hacer dos cosas a la vez:

* Definir una clase nueva (aunque con otra sintaxis, y no le damos un nombre)
* Llamarle a `new` para instanciarla

Vamos a volver sobre esto más adelante.

## Mixin con estado

Un mixin en scala puede definir estado además de comportamiento.

```scala
trait ConEnergia {
  var energia : Int
}
```

En este caso definimos un atributo, con lo cual Scala genera además los getters y setters.

```scala
val a = new Ave with ConEnergia
a.energia = 100
```

## Mixin no puede tener parámetros (constructores)

A diferencia de las clases, no podemos hacer esto

```scala
trait ConEnergia(var energia : Int) 
```

> Es decir que un trait no puede tener constructores.

## Mixin abstracto (con requerimientos)

Un mixin puede definir un método abstracto. Esto quiere decir que al aplicarlo a una **construcción**, ésta debe implementar ese método, de otra forma no va a compilar.

Ojo acá que no decimos "aplicarlo a una **clase**", sino explícitamente **construcción**.
Porque ya vimos que un trait se puede aplicar al definir una clase, o al crear un objeto.

Entonces ahora sí podemos dejar de lado los prints y hacer una implementación más interesante de `Volador`. Al volar decimos que reduce la energia de si mismo en la cantidad de kilómetros volados.

```scala
trait Volador {
  def volar(kms: Int) {
    energia = energia - kms
  }

  // requerimientos
  def energia: Int
  def energia_=(nueva: Int) : Unit
}
```

Este trait está proveyendo el método `volar(kms)` que por definición del dominio lo que hace es "bajar" la energía según los kms. Para eso necesitamos dos requerimientos que no queremos incluir en este mixin, ya que queremos darle el lugar a quien lo usa a encargarse de su energia: a) obtener la energia actual (`energia`) y b) modificarla (`energia =`).

Esto se puede escribir más brevemente en scala usando [Abstract Fields](https://alvinalexander.com/scala/scala-traits-how-to-use-abstract-concrete-fields).

```scala
trait Volador {
  def volar(kms: Int) {
    energia = energia - kms
  }

  // requerimientos (mismo efecto que el ej anterior)
  var energia: Int
}
```

Y ahora lo aplicamos a dos clases con implementaciones distintas:

```scala

class Ave extends Volador {
  // implícitamente está definiendo el "getter y setter"
  var energia: Int = 100
}
    
class Colectivo[T] {
  var energia = 5000
}

class BichoConEnergiaColectiva(colectivo: Colectivo[BichoConEnergiaColectiva]) extends Volador {
  // comparten una única energia dada por "colectivo"
  override def energia = colectivo.energia
  override def energia_=(nueva : Int) {
    colectivo.energia = nueva
  }
}
```
También podemos aplicarlo a un objeto

```scala
val superman = new Object with Volador {
  // un número fijo muy grande
  override def energia = 1000000000
  override def energia_=(nueva:Int) {
    // nadie le puede cambiar la energia a un superheroe
  }
}
superman.volar()
```

Ahora si revisamos los ejemplos tanto `Ave` como `Colectivo` terminan implementado la idea de que "tienen energia" (obtener y modificar). Es apenas una linea en el mundo scala (`var energia = 100` y `var eneriga = 5000`), pero no quita la repetición y que nos está faltando una abstracción ahí.
En realidad ya tenemos esa abstracción, era un mixin de los ejemplos anteriores `ConEnergia`.

```scala
trait ConEnergia {
  var energia : Int = 100
}
```

Así que podemos refactorizar `Ave` y `Colectivo` para que hereden esta lógica

```scala
class Ave extends ConEnergia with Volador

class Colectivo[T] extends ConEnergia {
  energia = 5000
}
```

Incluso como ahora tanto `Volador` como `ConEnergia` son mixins, se pueden combinar y aplicar en cualquier clase u objeto en conjunto para darnos la funcionalidad completa de `volar(kms)`.

```scala
val elGatoVolador = new Gato with ConEnergia with Volador
elGatoVolador.volar(33)
```

Nótese que el "requerimiento" de `Volador` de tener energia, lo está cumplimentando otro trait, `ConEnergia`.

Como resumen acá las diferentes opciones que uno tiene para implementar los requerimientos abstractos de traits:

* con un método en **la clase donde lo estoy combinando**
* con un método **ya heredado por una superclase** (este no lo vimos)
* con un método **definido en el objeto** donde estamos combiando el mixin
* con un método aportado por **otro mixin**

## Mixins para herencias paralelas (Voladores vs Nadadores)

Vamos a modelar un problema bastante común en objetos y que no tiene solución en la herencia simple.
Seguimos con las aves. Como ya vimos sabían volar.

```scala
class Ave extends ConEnergia with Volador

class Gorrion extends Ave
class Halcon extends Ave
```

Tanto el `Gorrión` como el `Halcón` son aves, con lo que reutilizan el comportamiento de `volar()`. Obviamente en un ejemplo real, además cada subclase debería tener un comportamiento adicional propio. Pero acá estamos tratando de simplificar un poco para no confundir.
Ahora, qué pasa con **el Pingüino** ? Es una ave, porque tiene alas en lugar de patas delanteras, sin embargo **no puede volar** !

Una solución entonces sería introducir una **clase intermedia**.

```scala
class Ave extends ConEnergia

class AveVoladora extends Ave with Volador

class Gorrion extends AveVoladora
class Halcon extends AveVoladora
class Pinguino extends Ave  // el pinguino no vuela
```

Perfecto. Ahora, resulta que queremos **agregar al Pato**. Nos damos cuenta de que es una **ave voladora y** que además es **acuática, es decir que nada**

Una opción es agregar el método "nadar" a AveVoladora

```scala
class AveVoladora extends Ave with Volador {
  def nadar(metros : Int) = {
    energia -= metros * 1.3
  }
}
```

Otra opción es agregar una clase intermedia `AveNadadora` que extienda de `AveVoladora`, que permitiría modelar la idea de aves voladoras que no sean nadadoras.

```scala
class AveAcuatica extends AveVoladora {
  def nadar(metros : Int) = {
    energia -= metros * 1.3
  }
}
```

Nos queda una jerarquía así

```bash
Ave/
  ├── AveVoladora
  │   ├── AveAcuatica
  │   │   └── Pato
  │   ├── Gorrion
  │   └── Halcon
  └── Pinguino
```

Ahora, nos damos cuenta que **el Pingüino también es un excelente nadador**. Pero no podemos hacer que extienda de `AveAcuática` porque lo haríamos volador! Y el Pingüino no vuela !
Acá entonces vemos una limitación de la herencia simple.
Ahí es donde aparecen los mixins. Necesitamos modelar las habilidades de las aves, de forma que puedan ser combinadas en diferentes clases, atravesando la jerarquía!
En Java esto se soluciona agregando una interfaz, que pueden implementar tanto el `Pinguino`, como al `Pato`. Pero la contra es que igualmente el código de la implementación lo tenemos que escribir duplicado en ambas clases.
En scala los (mal llamados) traits (que son mixins), nos permiten definir también el comportamiento y luego aplicarselo a cualquier clase.
Entonces hacemos los mixins:

```scala
trait Voladora {
   // ya lo teníamos modelado
}

trait Nadadora {
   def nadar(metros : Int) = {
    energia -= metros * 1.3
  }
}
```

Y ahora podemos aplicarlos al definir cualquier clase, como en Java escribíamos el "implements"

```scala
class Ave extends ConEnergia
class Gorrion extends Ave with Voladora
class Pinguino extends Ave with Nadadora
class Pato extends Ave with Nadadora with Voladora
```

* El `Gorrión` habíamos dicho que era un ave "normal" que volaba, así que le aplicamos el trait `Voladora`.
* El `Pinguino` no vuela, pero nada. Así que le aplicamos el trait `Nadadora`.
* El `Pato` tanto nada como vuela, por lo que le aplicamos los dos traits.

Veamos entonces un poquito de código que use a las aves.

```scala
object PruebaConAves {
  def main(args: Array[String]) {
    val nadadores = List(new Pinguino, new Pato)
    nadadores foreach { n => n.nadar }
  }
}
```

La lista "nadadores" se infiere automáticamente al tipo del trait `List[Nadadora]`. Esto nos permite tratar a las aves, no importa su clase, como nadadoras. Igual que con una interface de Java. Por eso luego en el foreach estamos haciendo que naden.

## Mixins con sobrescritura (override)

Hasta ahora veníamos trabajando con mixins que agregaban un nuevo comportamiento. En el sentido de agregar nuevos mensajes que hasta ahora la clase base no entendía.
Es común modelar con mixins otro caso en el que queremos que el mixin **modifique un comportamiento ya existente en la clase base.**

Eso en herencia simple sería sobrescribir un método de la superclase.

Bueno, en mixins es bastante similar.

Ejemplo. Supongamos esta clase base muy simple con un comportamiento.

```scala
class Persona {
  var edad = 0
            
  def envejecer() {
    edad += 1
  }
}
```

Supongamos que tenemos varias subclases que hacen diferentes cosas, como un Carpintero, un Doctor, etc. Y sin embargo ahora queremos modelar la idea de diferentes "formas" de envejecer, y poder aplicárselas a todas esas clases.
Entonces, estamos forzados a modelarlo con mixins (y además está bueno :P)

Por ejemplo, un mixin para `EnvejeceElDoble` que haga que si a la persona le digo "envejece" esta envejezca 2 años en lugar de 1 !

Este mixin no va a agregar un nuevo método sino que tiene que redefinir `envejecer()`.
Esto es importante porque no queremos que los que usen Persona le tengan que mandar un mensaje nuevo (como `envejeceDoble()`) diferente al original. Queremos que se mantenga el polimorfismo!

Entonces uno está tentado a hacer esto (y más aún si viene de lenguajes sin checkeos estáticos)

```scala
trait EnvejeceElDoble {
  def envejecer() {
    edad += 2
  }
}
```

Sin embargo cuando quieran combinar este mixin con la clase `Persona` en una subclase, van a tener un error. Un "conflicto".

```scala
class Carpintero extends Persona with EnvejeceElDoble {  
  // ERROR ! conflicto entre Person.envejece() y EnvejeceElDoble.envejece()*
}
```

Esto es porque si bien los métodos se llaman iguales para Scala (igual que pasaba en java) son métodos distintos. Porque nada le indica en lo que escribimos que **"la intención del EnvejeceElDoble.envejece() es sobrescribir Persona.envejece()".**

(Incluso este ejemplo va a fallar antes, el trait no va a compilar porque no conoce "edad")
Mentalmente estábamos pensando este para que "funcione" con Persona. Queríamos acceder a su "edad" y sobrescribir el "envejece". Sin embargo nunca se lo dijimos a Scala.
Entonces, la forma correcta de hacer esto es

```scala
trait EnvejeceElDoble extends Persona 
  override def envejecer() 
    edad += 2
  }
}
```

Esto, si se quiere se puede pensar como que "este trait" se aplica a Personas. Eso nos permite saber que `this` va a ser una persona, entonces podemos acceder a su edad y sobrescribir cualquier método.

## Sobrescritura con Super

Una variante al mixin anterior es no tocar la edad diréctamente sino pensarlo como "hacer dos veces el comportamiento de envejecer". Lo cual lo hace más "extensible" (ya vamos a ver al combinar mixins).


Eso, se puede hacer igual que en una sobrescritura de clases, con `super`

```scala
trait EnvejeceElDoble extends Persona 
  override def envejecer() 
    super.envejecer()
    super.envejecer()
  }
}
```      

## Sobrescritura con Combinación (múltiples sobre-escrituras)

Vimos que un mixin se puede "meter" para sobrescribir un comportamiento de la clase base.
Pero también vimos antes que podíamos aplicar más de un mixin. 
Entonces el caso que sigue sería combinar estas dos cosas.

Pensamos otro mixin de envejecer: `Rejuvence` Este mixin hace que la persona decremente su edad en lugar de incrementarla (como Benjamin Button :P).
La implementación es parecida a la anterior

```scala
trait Rejuvenece extends Persona
  override def envejecer() 
    edad -= 1
  }
}
```   

Ahora qué pasa si los combinamos ?

```scala
class Carpintero extends Persona with Rejuvenece with EnvejeceDoble {
}

val carpintero  = new Carpintero()
carpintero.envejecer()
carpintero.edad    // ??
```

Qué va a imprimir ?

Respuesta: - 2 !

Y si los invertimos ?

```scala
class Carpintero extends Persona with EnvejeceDoble with Rejuvenece {
```

Ahora: - 1

Esto es porque el orden importa. En el mismo sentido en que en una herencia común se hace un method-lookup buscando la implementación más concreta.
Acá se ve la característica principal del mecanismo de mixins que es **la "linearización"**.

Si bien hasta ahora se parecía mucho a una herencia múltiple los mixins garantizan que nunca hace una herencia de este tipo: 

![Herencia en diamante: La clase D especializa de B y C al mismo tiempo. B y C especializan A.](/images/herencia-en-diamante.png)


Es decir, nunca una clase `D` va a tener dos super clases (o traits) porque esto conlleva conflictos. En cambio, los mixins en forma estática (al momento de compilar el código, o de leerlo si se quiere) ya garantizan una herencia "lineal" donde cada nodo tiene un sólo padre.


![Herencia linearizada: D "especializa" C. C "especializa" B. B "especializa" A.](/images/herencia-linealizada.png)


Entonces esto:

```scala
class Carpintero extends Persona with Rejuvenece with EnvejeceDoble {
```

Se lee así

* **defino una nueva clase Carpintero:** esta va a ir **abajo de todo**, porque tengo el control de sobrescribir lo que quiera. Es la "más concreta"
* **esta clase extiende de Persona:** esta clase va "arriba"  de Carpintero (y arriba de todo)
* **mezclo los mixins:** de acá el nombre. Los mixins se van a meter entre la super clase (`Persona`) y nuestra clase (`Carpintero`). En orden de derecha a izquierda  (dibujandolas desde arriba hacia abajo)

Quedaría así

![Carpintero "especializa" EnvejeceElDoble. EnvejeceElDoble "especializa" Rejuvenece. Rejuvece "especializa" Persona](https://sites.google.com/site/programacionhm/_/rsrc/1472914907297/conceptos/mixins/mixins-envejece1.png)

Y entonces ahora aplican las mismas reglas de siempre en herencia simple !
Si le mando el mensaje "envejecer()" a Carpintero, cuál se va a ejecutar ?

1. `Doble` que llama a super
2. `Rejuvenecer` (el super de Doble) resta en 1.
3. Luego `Doble` vuelve a llamar a super (recuerden que lo llamaba dos veces).
4. `Rejuvenecer` vuelve a restar 1.
5. El valor final de `edad` es ahora `-2`.

Ahora si invertimos la declaración como en el segundo ejemplo

```scala
class Carpintero extends Persona with EnvejeceDoble with Rejuvenece
```

Terminamos con algo similar a esto:

![Carpintero "especializa" Rejuvenece. Rejuvenece "especializa" EnvejeceElDoble. EnvejeceElDoble "especializa" Persona](https://sites.google.com/site/programacionhm/_/rsrc/1472915183440/conceptos/mixins/mixins-envejece2.fw.png)

Es fácil ver que el método que se va a ejecutar es el de `Rejuvenecer` (el más concreto, el "más abajo"). Este método simplemente resta 1 a la edad y nunca llama a super con lo cual valor final para `edad` es `-1`.

Resumiendo: Los mixins (y esto es lo que los diferencia de los traits) no conforman un grafo de delegación, como en la herencia múltiple, sino que gracias a la linearlización conforman una linea única de forma parecida a una herencia simple.

### Otro ejemplo

```scala
class Animal 

trait Peludo extends Animal
trait ConPatas extends Animal
trait ConCuatroPatas extends ConPatas

class Gato extends Animal with Peludo with ConCuatroPatas
```

La clase `Gato` genera una linea de delegación así:

![A la izquiera la relación formal de herencia (Peludo y ConPatas extienden Animal. ConCuatroPatas extiende ConPatas. Gato extiende Animal, Peludo y ConCuatroPatas; A la derecha la linearización, yendo de lo más particular a lo más general: Gato → ConCuatroPatas → ConPatas → Peludo → Animal)](/images/mixins-animales.png)

A la izquierda vemos las relaciones formales de herencia. A la derecha la linearización de los traits. El method-lookup, o sea la búsqueda de un método por el cuál atender un mensaje, ocurre siempre por este ultimo camino. Por ejemplo de `ConPatas` no pasamos directo a `Animal` sino que vamos a tratés de `Peludo`.

La "linearización" nos indica por dónde se va a resolver un llamado a `super`.

# Stackable Traits Pattern

Es un "patron" de diseño que, a traves de traits, nos permite definir comportamiento que se va combinando, como "apilando", uno sobre otro, y redefiniendo comportamiento.
Veamos un ejemplo:

Tenemos una estructura tipo cola de enteros. Para eso definimos una clase abstracta con el contrato de la misma y una implementación base que utiliza un `ArrayBuffer` tras bambalinas.


```scala
abstract class Cola {
  def get(): Int
  def put(i : Int)
  def size : Int
}
```


```scala
class ColaBasica extends Cola {
  private val buffer = ArrayBuffer[Int]()
  override def get() = buffer remove 0
  override def put(i:Int) { buffer += i }
  override def size = buffer size
}
``` 

Esto se usaría así

```scala
val c = new ColaBasica
c put 3
c put 10
c put 1
println(c get)
println(c get)
println(c get)
```

Ahora vamos a necesitar agregar un par de comportamientos que modifiquen el funcionamiento de una cola. 

* _**Duplicador:**_ cuando se agrega un elemento en realidad agrega el resultado de multiplicarlo por 2
* _**Incrementador:**_ que agrega el número dado incrementado por 1.

Codificamos mixins para estos. El primero:

```scala
trait Duplicador extends Cola {
  abstract override def put(i:Int) {
    super.put(2 * i)
  }
}
```

El mixin hereda de `Cola` ya que la idea es que intercepte el llamado a `put`.
`Duplicador` no va a implementar el put completo sino solo un agregado y por eso va a necesitar delegar en una implementación **concreta** (por medio de `super`). 

Sin embargo si miramos en `Cola` el método `put` es abstracto! Por esto es que necesitamos marcar en el mixin `Duplicador` el método `put` como `abstract override`. Eso quiere decir que vamos a querer sobrescribir una implementación concreta. El efecto de eso es que **el mixin sólo va a poder ser aplicado a una subclase de Cola que ya tenga implementado el método put**.

Se usaría así:

```scala
val duplicada = new ColaBasica with Duplicador
duplicada put 3
println(duplicada get) // imprime 6
```

Lo cual imprime "6".

Acá vemos un diagrama:

![La clase anónima que creamos extiende ColaBasica y Duplicador. ColaBasica y Duplicador extienden Cola](/images/mixins-duplicador.png)


El eslabón más bajo dice "anónima" ya que estamos aplicando el mixin a un objeto. Esto genera una clase anónima.

La linearización queda:

```bash
Anónima → Duplicador → ColaBasica → Cola
```

Por esto es que al ejecutar `super.put(...)` en `Duplicador` se ejecuta el método de `ColaBasica` y no el de `Cola`. 

Podríamos haber puesto solo `override`?
Sí, claro. Querría decir que el trait está implementado el método put que era abstracto. Pero al hacer esto, en su cuperpo, no hubieramos podido usar el `super.put` sin obtener un error de compliación porque el método de arriba, el de `Cola`, es abstracto. Un `override` simple podría servir para un mixin que no delegase en el `put` de `Cola`. Por ejemplo, una cola `Inmutable`.

```scala
trait Inmutable extends Cola {
  override def put(i:Int) 
    // no hace nada, no llama a super.put(...)
  }
}
```

Veamos un ejemplo de cómo usar esto

```scala
val inmutable = new ColaBasica with Inmutable
inmutable put 3
println("tamaño", inmutable size) // imprime 0
```

Al ejecutar este código, vamos a ver que el tamaño de la cola es 0 porque `Inmutable` sobrescribió el `put` de `ColaBasica` y previno la inserción.

Ahora, si el método en `Cola` no fuera abstracto y tuviera una implementación el trait `Duplicador` podría definir el método como `override def` e igual utilizar el `super`.

```scala
abstract class Cola {
  def put(i : Int) 
    println("La Cola no hace nada al hacer put con " + i)
  }
}
trait Duplicador extends Cola {
  override def put(i:Int) {
    super.put(2 * i)
  }
}
```

Y se usaría así:

```scala
val duplicada = new ColaBasica with Duplicador
duplicada put 3
println("tamaño", duplicada size)
```

Cuando ejecutamos esto vemos que sí se insertó el elemento "6" en la cola y que no se imprimió el mensaje "de error" default de `Cola`.
Esto quizás nos desconcierte un poco porque si navegamos el `super.put(2*i)` de `Duplicador` nos va a llevar al la implementación de `Cola`.
Sin embargo lo que tenemos que entender es que, **el dispatch del "super" en realidad se hace en forma dinámica y sobre la clase concreta sobre la que aplica el mixin**.
En este caso la superclase va a ser `ColaBasica` que implementa el `put` con lo cual nunca se ejecuta la implementación de `Cola`.

La linearización de `new ColaBasica with Duplicador` es así:

```bash
Anónima → Duplicador → ColaBasica → Cola
```

Implementamos ahora el mixin `Incrementador`:

```scala
trait Incrementador extends Cola {
  override def put(i:Int) {
    super.put(i + 1)
  }
}
```

Ahora podemos aplicar los dos mixins:

```scala
val duplicadaConInc = new ColaBasica with Duplicador with Incrementador
duplicadaConInc put 3
println("+1, *2", duplicadaConInc get) // Imprime 8
```
        
Acá vemos que se puede aplicar más de un mixin. Pero además que la ejecución de los métodos depende del orden en que se hayan aplicado los mismos. Se puede leer como de derecha a izquierda. 

![La clase anónima que creamos ahora extiende ColaBasica, Duplicador e Incrementador. ColaBasica, Duplicador e Incrementador extienden Cola](/images/mixins-incrementador.png)

La nueva linearización quedaría de esta forma:

```bash
Anónima → Incrementador → Duplicador → ColaBasica → Cola
```

Un put se ejecuta así:

1. `Incrementador`: super.put(**3** + 1)
2. `Duplicador`:  super.put(2 * **4**)
3. `ColaBasica`: buffer.put(**8**)

Lo cual termina agregando el 4 a la cola.

## Herencia de Traits

Un mixin puede heredar de otro mixin. En este caso aplica el mismo mecanismo de herencia que usamos cuando una clase hereda de otra.

Ejemplo:

```scala
trait Cuatriplicador extends Duplicador {
  override def put(i:Int) {
    super.put(2 * i)
  }
}
```

Este mixin hereda de `Duplicador` que también multiplica el parámetro `i` por 2.

```scala
val cuatriplicados = new ColaBasica with Cuatriplicador
cuatriplicados put 3
println("*4", cuatriplicados get) // Imprime 12
```

Esto va a imprimir 12. 
El diagrama quedaría:

![La clase anónima que creamos ahora extiende ColaBasica y Cuatriplicador. Cuatriplicador extiende Duplicador. Duplicador y ColaBasica extienden Cola](/images/mixins-cuatriplicador.png)

```bash
Anónima → Cuatriplicador → Duplicador → ColaBasica → Cola
```

La ejecución es así:

1. `Cuatriplicador`: super.put(2 * **3**)
2. `Duplicador`: super.put(2 * **6**)
3. `ColaBasica`: buffer.put(**12**)

# Resolución de Conflictos

Ver [este post](../conceptos-mixins-conflictos-con-traits-de-scala)


# Referencias / Bibliografía

* Especificación de las reglas de [linearización en Scala](http://jim-mcbeath.blogspot.com.ar/2009/08/scala-class-linearization.html#rules).
* [Paper seminal de Mixin-Based Inheritance](http://www.st.informatik.tu-darmstadt.de:8080/lehre/ss02/aose/Papiere/Thema1/flatt98classe.pdf), por Bracha y Cook.
* [Mixin-based Inheritance](http://www.bracha.org/oopsla90.pdf), por Bracha y Cook (otro link)
* [Otra definición de Mixins](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.23.8118&rep=rep1&type=pdf), de .Flatt, Krishnamurthi y Felleisen
* [Traits de Scala](https://www.artima.com/pins1ed/traits.html), Martin Odersky, Lex Spoon, and Bill Venners
* Un antecedente: [Flavors, de David Moon](https://dl.acm.org/citation.cfm?id=28698) (ese paper lamentablemente no se puede conseguir online gratuitamente, pero acá hay [otra publicación de David Moon sobre Flavors](ftp://publications.ai.mit.edu/ai-publications/pdf/AIM-602.pdf)).

# Temas Relacionados
 
* [Traits](../conceptos-traits)
* Chain of Responsibilities Pattern (?)
* Decorator Pattern (?)
