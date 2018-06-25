---
title: "te-scala-introduccin-a-scala"
date:  2018-06-20T19:27:10-03:00
---


[[_TOC_]]


## Breve Intro

Scala es un lenguaje...

* **Con checkeos en tiempo de compilación**: el compilador antes de la ejecución de nuestros programas comprueba ciertas reglas de correctitud.
* **Con tipos explícitos: **es decir que nosotros explicitamos el tipo de las variables. Pero...
* **Con cierta inferencia de tipos: **en ciertos casos el compilador puede "inferir" el tipo de algunas variables, con lo cual es opcional especificarlo.
* Comprende varios **elementos del paradigma funcional.**

* Mantiene la idea de **imperatividad** de lenguajes de objetos como Java:
* **Que compila a JVM:** es decir que es compatible con otros programas y librerías Java.
* Tiene su propio compilador y SDK que necesitamos además de la JDK.

## Temas básicos

A continuación vamos a ver algunas cuestiones bien básicas del lenguaje.
### Sintaxis

En principio la sintaxis parece similar al lenguaje Java. Léase: llaves, punto y coma, etc.
Sin embargo acá van algunas diferencias:


Los tipos de las variables se escriben después del nombre, y luego de dos puntos


En java:
    


            unMetodo(**String unString**, **Integer numero**)


En scala:



            unMetodo(**unString : String**, **numero : Integer**)


#### Variables (y valores) locales

Las variables en scala se pueden declarar de dos tipos, como **mutables** o **inmutables.**

Se pueden ver como "variables" o "constantes". Para esto existen dos keywords: **var **y **val**






        var nombre : String = "World";
        println("Hello, " + nombre + "!");
**

**

Al ser una variable (es decir mutable) podemos hacer:



        var nombre : String = "World";
        **nombre = "PACO";**

        println("Hello, " + nombre + "!");

Por otro lado, si fuera una constante o **valor**, se escribiría así:





valnombre : String = "World";`
        println("Hello, " + nombre + "!");

Y en tal caso la linea *'nombre = "PACO"'* no compilaría. Ya que los valores no pueden modificarse (son referencias inmutables)
#### Elementos opcionales

A diferencia de java, varios elementos de la sintaxis son opcionales, de forma de escribir menos código, y que éste quede más conciso y legible (en teoría, ja!).
Al principio nos resulta dificil entender en qué casos es opcional escribir algo y en cuales otros no.
Lo mejor para eso, si uno viene del mundo java, es, en principio escribir todo, y de a poquito ir probando eliminar declaraciones, hasta hacerse una idea.


Siguiendo con el ejemplo anterior, los puntos y comas se pueden eliminar, si tenemos una expresión por linea:





        var nombre : String = "World"
        nombre = "PACO"
        println("Hello, " + nombre + "!")


Además, la variable "nombre" al estar siendo asignada a un string ("World"), el compilador puede concluir automáticamente que va a ser de tipo String, con lo cual no hace falta que declaremos el tipo.





        var nombre = "World"
        println("Hello, " + nombre + "!")
En cuanto a llamados a métodos, es posible eliminar los paréntesis, en el caso en que método no reciba parámetros.
        perro.ladrar()
Sería:
        perro.ladrar
Incluso, si encadenamos mensajes, se pueden eliminar los puntos. En este caso es un único mensaje, un único punto, pero quedaría:

        perro ladrar
### Definición de una clase

En su forma más simple una clase se ve muy similar a su par en java

        class Robot {
        }
Cuando no se especifica una superclase (igual que en java con **extends**) automáticamente esto quiere decir que la clase hereda de **AnyRef**.
La forma de especificar variables de instancia es también similar a java, pero teniendo en cuenta lo que ya vimos de **valores y variables **(y la inferencia de tipos)

        class Robot extends AnyRef {
 `**val **material = "acero"`
        }
O bien



        class Robot {
 `val material = "cobre"`
 `var nombre = "C3PO"`
        }


### Métodos

Acá es donde más variantes tenemos y donde más vamos a ver diferencias de sintaxis con Java.
Los métodos siempre se definen con la palabra reservada  def.





         def presentarse() {
          println("Soy " + nombre)
        }
En este caso estamos definiendo un método que no recibe parámetros y que tampoco retorna ningún valor. Si no declaramos el tipo de retorno, y tampoco utilizamos el símbolo igual ("="), que ya vamos a ver a continuación, el compilador interpreta esto como un método void.
En scala el tipo para **void ** es **Unit**

Si necesitamos un parámetro, se definiría así:

         def presentarseA(alguien : String) {
          println("Hola " + alguien + ", soy " + nombre)
        }
Si en cambio queremos hacer un método que nos retorne el string

         def decimeTuNombre() : String = {
 `  **return** "Soy " + nombre`
        }
En este caso estamos especificando el tipo de retorno del método, luego de los parámetros (a diferencia de java y C donde se escriben antes del nombre).
Otro detalle es que al retornar algo, el método se debe declarar con el símbolo "igual"
Ahora veamos cómo reducir un poco de código.
Podemos eliminar la palabra **return**. El compilador asume que el retorno es la última expresión del cuerpo del método.

 ` def decimeTuNombre() : String = 
 `  "Soy " + nombre`
 `}`
Como en este caso el cuerpo del método es una única expresión, podemos evitar los paréntesis, que sirven para agrupar más de una expresión.
 ` def decimeTuNombre() : String = "Soy " + nombre`
Además, como dijimos en la introducción, Scala tiene inferencia de tipos. Puede "ver" que según el cuerpo del método, estamos retornando un String, con lo cual podría inferir el tipo de retorno del método (viendo también el símbolo "igual", se dá cuenta que es un método que retorna algo, así que debe tener un tipo).
Así infiere el tipo a String
         def decimeTuNombre() = "Soy " + nombre 
Finalmente, si quisieramos que este método siempre se llame sin usar los paréntesis (ya que no recibe parámetros), podemos eliminarlos de la declaración:
         def decimeTuNombre = "Soy " + nombre
Ojo al piojo que ahora este llamado **no compilaría**:
        robot.decimeTuNombre()
También ojo al piojo que ahora la declaración se parece mucho a la declaración de  una variable de instancia, pero no lo es ! Esto es un método que se va a estar ejecutando en cada llamado.
### Constructores locos
Otro punto donde difiere bastante de java y un poco de xtend.
El caso más simple es cuando una clase tiene un único constructor. Éste se puede escribir como parámetros en el mismo nombre de la clase.
En nuestro caso del robo







        class Robot(nombre:String) {
        

           def decimeTuNombre = "Soy " + nombre
        

        }


Como se vé acá, no hace falta declarar el atributo por un lado, y por otro lado escribir un constructor con un parámetro y asignarlo luego a la variable de instancia.
Todo se hace en menos pasos, con menos código y de forma más declarativa.
Simplemente decimos que el Robot tiene un atributo "nombre" y que éste se debe especificar al construirlo, así:



        val unRobot = new Robot("R2D2")
Con dos parámetros sería



        class Robotito(nombre:String, material : String) { ... }


Y cómo hacemos si en el constructor debemos realizar algún cálculo ? Por ejemplo, supongamos que tenemos un valor en el robot, su "código", que se autogenera en base al nombre y un número único.
Para eso, podemos escribir, lo que en java sería como el "cuerpo del constructor", es decir sus sentencias, en scala, como expresiones "sueltas", dentro de la clase.





        class Robotito(nombre:String, material : String) {
          val codigo = nombre.substring(0, 2) + System.currentTimeMillis
          
           def decimeTuNombre = "Soy " + nombre + " (" + codigo + ")"
        }


En la segunda linea estamos haciendo dos cosas. Por un lado definiendo una variable de instancia "codigo", y por otro, inicializando su valor en base a los parámetros que recibió el constructor (nombre, en este caso).


Por último, también se pueden tener múltiples constructores en Scala. Aunque hay que decidir uno de ellos como el "principal", y definirlo como vimos hasta ahora, como parámetros al nombre de la clase.
Los demás, se escriben como en xtend, o bien como métodos (?) con nombre "this".





        class Robotito(nombre:String, material : String) {
          val codigo = nombre.substring(0, 2) + System.currentTimeMillis
          
          **def this**(nombre:String) = {
            **this**(nombre, "acero")
          }
        }
O bien más conciso sin las llaves:





        class Robotito(nombre:String, material : String) {
        **  val** codigo = nombre.substring(0, 2) + System.currentTimeMillis
          
          **def this**(nombre:String) = **this**(nombre, "acero")
        }


Así, podríamos tener varios de estos constructores con "this".


Por último, existe el caso en el que nuestra clase hereda de otra que tiene un constructor. En Java/xtend escribíamos un nuevo constructor y luego dentro, invocábamos el de la superclase con super(...).
En scala tenemos ese se hace así:





        class C3PO extends Robotito("c3po", "cobre") {
            ...
        }


En este caso estamos fijando los valores. Pero si queremos recibirlos también como parámetros, sería:




        class RobotitoFurioso(n:String, m: String) extends Robotito(n,m) {
            ...
        }
### Getters & Setters

En los ejemplos hasta ahora vimos como declarar variables de instancia dentro de una clase. Por la forma en la que lo hicimos serán accesibles desde afuera. Por ejemplo podríamos hacer esto:






          val r = new Robotito("R2D2", "acero")
          r.nombre = "23"
Si bien parece que estamos accediendo diréctamente a las variables de instancia, en realidad Scala genera internamente métodos getters y setters. De hecho cambia el nombre de la variable de instancia a "_nombre".
Igualmente es un detalle interno, lo importante es, cómo podemos nosotros incluir código en los getters y setters ?
Acá un ejemplo pavo donde nosotros definimos una nueva propiedad "color".

        class Robotito(nombre:String, material : String) {
          var codigo = nombre.substring(0, 2) + System.currentTimeMillis
          **private var** _color : String = "gris"
            
           def color = {
            _color
          }
           def color_= (nuevo:String) = {
            _color = nuevo
          }
        }
A la variable le damos un nombre con guión bajo, para que no conflictúe con los métodos. Además la hacemos **privada.**

Luego definimos dos métodos, el getter y setter respectivamente. 
El getter es bien sencillo.
El setter tiene una particularidad, no es un nombre "común", en cuanto a tener solo caracteres como "setColor" sería en Java, sino que hace uso de la capacidad de Scala de definir métodos cuyos nombres sean símbolos (una especie de sobre de símbolos).
En este caso queremos que se invoque este método cuando alguien escribe "color = ...".
Entre "color" y el símbolo "=" habría un espacio. Para representar esto en el nombre del setter, se usa el guión bajo (underscore)
Entonces
color_=     representa a     color = ...
Luego, como cualquier otro método recibe un parámetro entre paréntesis en la declaración.
Todo esto lo podemos achicar bastante con las cosas que ya vimos:
Y quedaría:

        **private var** _color : String = "gris"
         def color = _color
         def color_= (nuevo:String) = _color = nuevo
Hay que acostrumbrarse a todos esos símbolos "igual" :P
### Sobrescritura de métodos

En principio vamos a decir que la herencia funciona igual que en Java/xtend. Es decir que una clase puede heredar de una única clase. Después vamos a ver un complemento a esto, los traits.


Lo importante por ahora es que también funciona igual la sobrescritura de métodos y el dispatching.
La diferencia es que tenemos que explícitamente indicar que estamos sobrescribiendo un método con la palabra reservada **override**

**

**

Por ejemplo para sobrescribir el toString de nuestro Robotito





        class Robotito(nombre:String, material : String) {
           def decimeTuNombre = "Soy " + nombre
          
          override def toString() = decimeTuNombre
        }


### Cuestiones de Estilo

#### 1 archivo = N clases
Una diferencia con java, es que en un archivo .scala se puede definir más de una clase.
No es necesaria la restricción de 1 clase = 1 archivo.
Esto sumado a la capacidad de Scala para escribir lo mismo en menos lineas de código, hace posible que uno organize varias clases en un mismo archivo. Además de la categorización por paquetes.

#### Imports locos

Acá tenemos varias cositas.
Para empezar, el caracter para "importar todo", no es el asterisco, sino el guión bajo. O sea,



        **import** java.util._


También se puede escribir la sentencia "import" una sola vez, y luego separar los valores por comas
        **import** java.util._ , java.math, org.uqbar.arena_
Además podemos importar más de un elemento de un paquete en una sola linea


        **import** scala.collection.immutable.{Map, HashMap }


Y por otro lado, se pueden "renombrar" a dar un alias a una clase importada


        **import** java.util.{Collection => JavaCollection}
Así, ahora en lugar de usar Collection, podemos usar JavaCollection con el mismo efecto.
Por otro lado, como dentro de un archivo podemos tener varias clases, al declarar un import al nivel de archivo (arriba), estaríamos acoplando todas las clases a esa que importamos. Incluso si solo se utiliza para una única clase del paquete.
Por eso es que los imports se pueden ubicar en varios otros lugares, además del encabezado del archivo.
Se puede importar dentro de una clase:```

         class Rocket { **import** Rocket.fuel def canGoHomeAgain = fuel > 20 }
```

Más información sobre packages e imports en [éste enlace externo](http://booksites.artima.com/programming_in_scala_2ed/examples/html/ch13.html)
## Temas avanzados

### Definición de Objetos (en lugar de clases)

A diferencia de Java, en Scala no existen los métodos de clase o estáticos (static). Sin embargo posee la idea de definir "objetos" además (en lugar de) clases.





        **object** Pepita {
        var energia = 20
        def volar(metros : Int) = energia -= metros * 3
        }


Se puede pensar esto como que estamos definiendo una especie de Singleton, es decir una clase (porque estamos definiendo una atributo y un método), pero que tiene una única instancia accesible.
Luego usamos a este objeto:





        Pepita.volar(23)
        println(Pepita.energia)


O podemos asignarlo a una variable





        var pep = Pepita
        pep.volar(23)
        println(pep.energia)


Como se ve acá Pepita es una objeto y no una clase.
Algunas cuestiones extra sobre estos objetos:

* Como cuando definimos una clase, pueden extender de otras clases.
* No pueden tener constructores con parámetros (porque nadie los construye explícitamente, scala se encarga de contruir el objeto una sóla vez).



### Tipos estructurales (aka ducktyping)

Scala posee la idea de "tipos estructurales". Es decir que además de poder definir un tipo mediante un nombre (por ejemplo, codificando una clase con el nombre Golondrina), podemos definir un tipo mediante su estructura. Por ejemplo definimos un tipo como "todos los objetos que entienden el mensaje *volar"**

*Luego, podemos aplicar los tipos estructurales a cualquier elemento que tengamos que tipar, como una variable local, o un parámetro, o una atributo, etc.
Por ejemplo, 




        **abstract class** Animal {
        **    var** energia = 100

        **    def** come(comida : Comida) : Unit = {
                energia -= comida.energia
            }
        }


Si queremos usar tipos nominales, para que el método "comé" pueda recibir objetos de cualquier clase, definidos como "que entiendan el mensaje 'energia'", quedaría así:





         def come(comida : {  def energia : Int }) : Unit = {
            energia -= comida.energia
        }

Fíjense que reemplazamos "Comida", por "{ def energia : Int }".
Podríamos requerir que entienda más de un mensaje, especificándolos entre las llaves.
Ahora podemos llamar a come, pasándole cualquier objeto que entienda ese mensaje, no importa su clase.
Lo interesante es que el lenguaje sigue haciendo el checkeo en tiempo de compilación.
### Cómo crear una aplicación
Al no tener métodos estáticos la forma de hacer un "main" es con objetos, como sigue:





        **object** Hello {
        def main(args : Array[String]) : Unit = {
            println("Hello")
         `  }`
        }

Una variante a esto es crear un objeto que extienda de App




        **object** Pepita1 extends App {


            println("hola pepita")


        }

## Colecciones
Existen dos grandes familias de colecciones en Scala: 


* las mutables: del paquete scala.collection.mutable
* y las inmutables: del paquete scala.collection.immutable
En parte por influencia del paradigma funcional.

La colección de referencia para las inmutables es el **scala.collection.immutable.List**

De las mutables el **ArrayBuffer**

Ambas son colecciones secuenciadas (**Seq**).

Podemos construir una lista de la siguiente forma



        var lista = List(1,2,3)

Acá estamos creando una lista con 3 elementos, los números 1, 2 y 3.
La variable lista se infiere al tipo List[Int], es decir lista de Int's.
Con esto vemos que scala también tiene tipos paramétricos (lo que en java llamamos "generics"), pero el símbolo que se usa son los corchetes y no el menor/mayor.



* Java:

 * List<Animal>
* Scala

 * List[Animal]
Noten también que no hace falta el "new". 

La linea anterior es equivalente a:



        var lista : List[Int] = List(1,2,3)

Además, existen otras formas de definir una lista.
Por un lado hay que saber que "Nil" es un objeto (singleton) especial que representa a la lista vacía (e inmutable).
Con lo cual podemos "crear" una lista vacía así:



        var listaVacia = Nil

Por otro lado, las listas entienden el mensaje "::" (dos veces dos puntos), lo cual retorna una nueva lista concatenando un elemento en la cabeza y otra lista como cola. El "::" asocia a derecha. Con esto podemos definir una lista por extensión



        var igualALaPrimera = 1 :: 2 :: 3 :: Nil
var igualALaPrimeraBis = 1 :: (2 :: (3 :: Nil))  // asociando explicitamente

Usando ":::" (tres veces dos puntos) se concatenan listas, ponele




        val otraMas = List(1,2) ::: List(3)
        


***Nota sobre inmutabilidad:***


Cuidado cuando hablamos de inmutabilidad de colecciones, respecto de mutabilidad/inmutabilidad de referencias.
Ya vimos antes que podemos declarar referencias mutables con var e inmutables con val.
Por otro lado ahora vemos que hay colecciones mutables e inmutables.
Entonces:



        var numeros = List(1,2,3)

Quiere decir que, el objeto lista al que apuntamos con la variable "numeros" es inmutable. No se le pueden agregar o eliminar elementos.
En cambio la referencia sí es mutable. Con lo cual lo que sí podemos hacer es, hacerla apuntar a otra lista distinta.

Si queremos que sea una constante, es decir que siempre apunte a la misma lista



        val numeros = List(1,2,3)

Podríamos tener en otro caso, un valor (referencia inmutable) pero que apunta a un objeto mutable



        val numeros = ArrayBuffer(1,2,3)



### Jerarquía de Colecciones

La jerarquía de colecciones de Scala es bastante completa/ja. Y hace uso extensivo del concepto de **Mixins **que vamos a ver en la materia.
Acá un diagrama a modo esquemático de las "interfaces" **genéricas, comunes** a colecciones mutables e inmutables:



[![](http://docs.scala-lang.org/resources/images/collections.png)
](http://docs.scala-lang.org/resources/images/collections.png)



Y acá las mutables:





[![](http://docs.scala-lang.org/resources/images/collections.mutable.png)
](http://docs.scala-lang.org/resources/images/collections.mutable.png)Y acá el de las **inmutables**

**

**


[![](http://docs.scala-lang.org/resources/images/collections.immutable.png)
](http://docs.scala-lang.org/resources/images/collections.immutable.png)
Más info [acá](http://docs.scala-lang.org/overviews/collections/overview.html)

### Algunos métodos de las colecciones
El foreach es un método similar al "do" de Smalltalk, que permite ejecutar una lógica con cada uno de los elementos de la colección.
Para esto recibe como parámetro un "bloque" que opera con un elemento





        val donald = new Pato
        val pepita = new Golondrina
            
        val animales : List[Animal] = List(donald, pepita)


        animales.foreach { a : Animal => a.vola(20)}

Noten que los bloques se definen como:

{ parametros => código }

Ahora, como Scala tiene inferencia de tipos, y la lista ya tiene la información del tipo de los elementos (Animal), podemos evitarlo en el bloque:



        animales.foreach { a => a.vola(20) }

Podemos también evitar el punto y los paréntesis, porque el mensaje recibe un solo parámetro



        animales foreach { a => a vola 20 }

Por último, cuando un bloque recibe un único parámetro, y lo utiliza una única vez en su código, no hace falta que le demos un nombre al parámetro, podemos usar el guión bajo para identificarlo. Quedando así



        animales.foreach { _ vola 20 }

Que es lo mismo que



        animales.foreach { _.vola(20) }

Otros mensajes similares para operar con colecciones



        animales filter { a => a.energia > 0 }

Filter es similar al detect de smalltalk. Retorna una nueva colección que contiene solo aquellos elementos que cumplen con la condición del bloque. En este caso el bloque recibe un elemento y debe retornar un Boolean.




        animales map { a => a.energia }

El "map" es similar al "collect" de smalltalk. Retorna una nueva colección, resultado de aplicar el bloque a cada elemento. El bloque recibe un elemento y retorna otro objeto, que puede ser de cualquier tipo.
En este caso, estamos generando una nueva colección con las energías de los animales (Int).


Otros métodos útiles:
* **exists** (similar al anySatisfy)
* **forall** (similar al allSatisfy)
* **count**

* **find**

* **groupBy**

Ojo porque también existe el **collect** y **detect**, pero tienen otro significado.



## Links interesantes a temas aún más avanzados


* [Option's, Some y None](http://danielwestheide.com/blog/2012/12/19/the-neophytes-guide-to-scala-part-5-the-option-type.html)
* [Futures & Promises](http://danielwestheide.com/blog/2013/01/09/the-neophytes-guide-to-scala-part-8-welcome-to-the-future.html) y [más](http://danielwestheide.com/blog/2013/01/16/the-neophytes-guide-to-scala-part-9-promises-and-futures-in-practice.html)
* [Iteratee's, Enumerators, y Enumeratee's](http://mandubian.com/2012/08/27/understanding-play2-iteratees-for-normal-humans/)