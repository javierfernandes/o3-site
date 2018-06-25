---
title: "conceptos-extension-methods"
date:  2018-06-20T19:27:10-03:00
---


[[_TOC_]]


## Introducción

"Extension methods" se refiere a la capacidad de agregar nuevos métodos, por ende comportamiento, a clases ya existentes, sin necesidad de modificar las clases originales o bien generar nuevas subclases de ellas.
Sin embargo, sí permitir usar estos nuevos métodos, como si fueran parte de la clase. Es decir poder mandarle un mensaje definido "en otro lado" a objetos de cierta clase.


A esta idea se la conoce por varios nombres:

* Extension Methods
* Loose Methods
* OpenClass
* Monkey Patching (algo más genérico)

## Extension Methods en XTend

Vamos a ver acá ejemplos concretos utilizando la implementación de extension methods de xtend, que permite variantes interesantes de diseño.


Existen varias formas de definir extension methods en xtend. Vamos desde lo más básico hasta los ejemplos más complejos pero poderosos.
### Static Extension Methods

A veces nos enojamos porque tal o cual clase que viene con el lenguaje, no tiene un método que necesitamos.
Por ejemplo, nos gustaría, dado un String que tiene varias "oraciones", obtener otra versión del String que convierta cada punto en "punto y aparte". Es decir que pase cada oración a una linea nueva.
Ej:

        "Hola. Mundo. Cruel"
Generaría:


        Hola.
        Mundo.
        Cruel


Entonces nos gustaría poder hacer




           "Hola. Mundo. Cruel".splitIntoLines()


En Java deberíamos caer en hacer un método **static**, como si fuera una función y llamarlo así:



        MisExtensionesDeString.splitIntoLines("Hola. Mundo. Cruel")


Es decir pasando el string como parámetro.


En xtend podemos codificar un método similar y luego utilizarlo como un extension method.





        **def static** String splitIntoLines(String s) {
 `s.replaceAll("\\.", ".\n")`
 `.replaceAll("\n ", "\n")` 
        }
 
        **def static** void main(String[] args) {
 `println("Hola.Como va ?. Todo bien?".splitIntoLines())`
        }


Como se ve acá, es un método **static **que recibe al string como parámetro. Xtend entonces, dada una variable de tipo String, nos permite llamarle a métodos que estén en esa clase (o superclase), pero también "busca" otros métodos que reciban ese tipo String como primer parámetro en la clase en la que estemos.
#### Import static extensions

En este ejemplo definimos el extension méthod en la misma clase en la que estamos.
Más interesante es tenerlo en una clase aparte que reuna todas las extensiones a los Strings. Así los podemos usar desde diferentes partes de nuestro sistema.





        class StringExtensions {
 
 `**def static** String splitIntoLines(String s) 
 `s.replaceAll("\\.", ".\n")`
 `.replaceAll("\n ", "\n")` 
 `}`
 
        }


Luego para usarlos:






        ***import static extension org.uqbar.xtend.extensions.estatic.separado.StringExtensions.****



        class Main {
 
 `// el main` 
 `def static void main(String[] args) 
 `println("Hola.Como va ?. Todo bien?".splitIntoLines())`
 `}`
 
        }


Tenemos que importar esos métodos como extensiones mediante el ***import static extension.***

***

***

### Extension Providers: extensiones como objetos

Muy lindo lo anterior, pero todos sabemos que los métodos statics son cosas bastante limitantes. Principalmente porque no pertenecen a ningún objeto, son como funciones. Con lo cual no podemos tener polimorfismo, por ejemplo.
Entonces sería interesante definir usar a las extensiones como objetos !
Y sí se puede.
Ya ahí **no hablamos de extension methods** como métodos sueltos**, **sino que** se agrupan en ExtensionProviders. **Es el nombre que le damos a una clase que define métodos que extienden a otras clases.
Nada loco, en nuestro caso podemos cambiar las extensiones de String a métodos de instancia (no static)
Agregamos otro, de paso..





        class StringExtensionProvider {
 
 ` def String splitIntoLines(String s) 
 `s.replaceAll("\\.", ".\n")`
 `.replaceAll("\n ", "\n")` 
 `}`
 
 ` def String firstCharUpperOnAllWords(String s) 
 `val stringbf = new StringBuffer();`
               `val m = Pattern.compile("([a-z])([a-z]*)", Pattern.CASE_INSENSITIVE).matcher(s);`
               `**while** (m.find) 
               `val rep = m.group(1).toUpperCase + m.group(2).toLowerCase`
                  `m.appendReplacement(stringbf, rep);`
               `}`
               `m.appendTail(stringbf).toString`
 `}`
 
        }


Como vemos no tiene nada de especial. Es una clase normal.


Para usar estas extensiones, **necesitamos declarar una instancia como extension**.





        class Main {
 
 `**extension** StringExtensionProvider = **new **StringExtensionProvider()`
 
** def static void main(String[] args) 
 `new Main().run`
 `}`
 
 ` def run() 
 `val s = "Hola mundo. Clase Nueva. De extension Methods"`
 `var r = s.splitIntoLines()`
 `println(r)`
 `}`
 
        }


La linea interesante acá es la que declara la extension.
Similar a una variable de instancia, estamos acá declarando que vamos a tener un objeto de tipo StringExtensionProvider, como una extensión.


Eso hace que en cualquier método de esta clase (Main), podamos usar las extensiones.


Además, en particular en este caso estamos nosotros instanciando a la extensión. Pero podría haber variantes a esto.
Lo único "requerido" al declarar una extension es:



        **extension** Tipo
 
La sintaxis completa sería:



        **extension** Tipo nombre = valor


Sin embargo **el nombre** (como si fuera un atributo) no es necesario porque justamente queremos usar sus métodos como extensiones para invocarlos sobre otros objetos (sobre un String, en nuestro caso).


El **valor no es necesario **porque podría suceder que alguien desde afuera nos dé la instancia particular.
#### Inyección de la extension

Por ejemplo en XText se usa mucho la **inyección de dependencias** sobre extensiones:




            @Inject
 extensionStringExtensionProvider`


Y luego solito el frameworks se encarga de setearnos una instancia.


Ojo, que si nadie setea una instancia, luego va a lanzar una **NullPointerException** al momento de llamar a un extension method.
#### Inyección manual con setters

Si la extensión tuviera un nombre como si fuera un atributo podriamos cambiarla, por ejemplo con un setter:





        class Main {
 `**extension** StringExtensionProvider provider`
 
 `def static void main(String[] args) 
 `val main = new Main()`
 `main.provider = new StringExtensionProvider()`
 `main.run()`
 `}`
 
 `**def **run() 
 `println("Hola mundo. Clase Nueva. De extension Methods".splitIntoLines())`
 `}`
 
 ` def setProvider(StringExtensionProvider provider) 
 `**this**.provider = provider`
 `}`
        }
#### Providers que pasan por parámetro

Otra opción es recibir una extensión por parámetro a un método.
Esto acota el uso de las extensiones, solo a ese método.
Nuestro ejemplo:





        class Main {
 
 `def static void main(String[] args) 
 `val main = new Main()`
 `main.run(new StringExtensionProvider())`
 `}`
 
 ` def run(**extension** StringExtensionProvider provider) 
 `println("Hola mundo. Clase Nueva. De extension Methods".splitIntoLines())`
 `}`


        }


Acá vemos que el método run() recibe un parámetro **y lo quiere usar como un proveedor de extensiones.**.
Así solo podemos llamar a "splitIntoLines()" sobre String's dentro de este método.
## Patrones y diseño con Extension Methods

Ya vimos que cualquier método static o no, puede ser una extensión.
La mecánica es simplemente esa. Declaro las extensiones que quiero usar, y luego usos sus mensajes sobre las clases del primer parámetro de los métodos.


Ahora vamos a ver que con estos elementos podemos empezar a hacer diseños más interesantes.
### Diferentes Implementaciones de Providers (polimorfismo)

Si dijimos que los providers son en realidad clases normales, y métodos normales, entonces, uno se vería tentado a aplicar las mismas ideas de diseño. Por ejemplo la idea de tener una interfaz, y luego diferentes implementaciones de estos objetos.


Para eso vamos a cambiar de ejemplo, porque los Strings son muy pavos.
Breve descripción del dominio:

* Modela la idea de existen **Eventos** que suceden en nuestra realidad.
* Hay diferentes tipos de Eventos: Deporte, Cine, etc.
* A efectos de simplificar estos Eventos no tienen comportamiento, pero en una aplicación real podrían tenerlo.
* Queremos agregar el comportamiento para **publicar **estos eventos.
* Supongamos que no podemos o no queremos agregar este método diréctamente a las clases Evento.
* Sin embargo nos gustaría invocar este métod publicar() sobre estos mismos objetos.

Así que vamos a implementar el publicar() como un extension method en un provider, que vamos a decir que es un Medio:





        **interface** Medio {


 `**def void** publicar(Evento e)`
 
        }


Luego podemos tener dos implementaciones distintas:





        class MedioObjetivo **implements **Medio {
 `**override** publicar(Evento e) 
 `println("Informamos que sucedio' " + e)`
 `}`
        }

        class MedioSubjetivo **implements **Medio {
 
 `**override **publicar(Evento e) 
 `println(gustaONoGusta() + " que haya sucedido: " + e)`
 `}`
 ` def gustaONoGusta() 
 `**if** (new Random().nextBoolean) "Me gusta" **else** "No me gusta"`
 `}`
 
        }


Y podemos usar la extensión como antes:





        class Main {
 `**extension** Medio = *new MedioObjetivo*`
 
 `def static void main(String[] args) 
 `new Main().run`
 `}`
 
 ` def run() 
 `val eventos = #[ new EstrenoCine("El Hobbit"), new NotaDeportes("River Campeon") ]`
 
 `eventos.forEach[e | e**.publicar()** ]`
 `}`
 
        }


Como se ve, el tipo de la extensión, es la interfaz Medio. Eso hace que nuestro código no esté acoplado a una interfaz específica.
Luego, cambiando la instancia particular por new MedioSubjetivo, u otro Medio, podríamos hacer que se comporte distinto.


Es loco, porque **es polimorfismo, pero no en base a que cada receptor Evento se comporta distinto, sino porque cada provider se comporta distinto.**



En realidad, si entendemos las extensiones, no tiene nada de loco, porque en realidad el receptor no es el Evento, sino los providers. Distintos provider se comportan distinto. 
Ergo, es polimorfismo normal !


### Extensiones polimórficas

Retrocedamos un poco, para ver otro camino.
Entonces con extension methods yo puedo agregar nuevos métodos a clases ya existentes sin tocarlas.
Muy lindo.
Ahora, si yo pudiera meterle mano a las clases de una jerarquía, podría agregar un único método, y diferentes implementaciones, para tener polimorfimos, y así hacer que dos objetos se comporten de forma distinta ante un mismo mensaje.


Puedo hacer eso con extension methods ?
O sea, que se ejecuten cosas distintas, no en base a la clase del provider (lo que vimos en el punto anterior), sino en base al tipo concreto (en runtime) del receptor ?


Sí, si usamos [multiple dispatch](../conceptos-multiple-dispatch)


Ejemplo: tenemos una jerarquía de **Clientes**.





        **abstract class** Cliente {
        }


        class ClienteRaso {
        }


        class ClienteVIP {
        }


Queremos agregarle un método para **atender()** a estos clientes.
Sin tocar esas clases. O sea, como extension.
Y lo usamos así en un main()





        class Main {
 `**extension** AtencionAlClienteExtension = new AtencionAlClienteExtension`
 
 `def static void main(String[] args) 
 `new Main().run()`
 `}`
 
 `**def **run() 
 `val clientes = #[ new ClienteRaso, new ClienteVIP ]`
 `clientes.forEach[c| c.atender()]`
 `}`
 
        }


El chiste sería que **c.atender()** debería ejecutar cosas distintas dependiendo de si es un ClienteRaso o ClienteVIP.


Entonces nuestra extension puede usar multimethods, uno para cada tipo del parámetro:





        class AtencionAlClienteExtension {
 
 def dispatch atender(ClienteRaso raso) 
 `println("ClienteRaso: Lo hacemos hacer la cosa y esperar")`
 `}`
 
 def dispatch atender(ClienteVIP vip) 
 `println("ClienteVIP: Lo atendemos inmediatamente y le damos un Martini y un habano")`
 `}`
 
        }
Si bien escribimos dos métodos, en realidad xtend genera uno solo, infiriendo la clase común que tienen, como Cliente
        def atender(Cliente c)
Luego solo hace el dispatch en base al tipo de c.
Listo, **combinando extension methods con multiple dispatch conseguimos agregar métodos polimórficos a clases ya existentes sin tocarlas !**

### Extensiones doblemente polimórficas

Por último, cómo podríamos resolver el caso en que:

* queremos **agregar un nuevo método a una jerarquía** ya existente de **Evento**'s (volvemos al ejemplo de los Medios)
* queremos tener **distintos comportamientos, según el Evento**. O sea: si es Deporte que se haga una cosa, si es EstrenoCine, que se haga otra.
* además, **poder cambiar todo ese conjunto de nuevos comportamientos**, como ya lo hicimos antes, **cambiando la clase concreta del provider de las extensiones**.

Esto se puede hacer, agregando multiple dispatch a nuestros providers que ya vimos (MedioObjetivo y MedioSubjetivo).





        
**interface **Medio {
 **def void **publicar(Evento e)
}


        class MedioObjetivo **implements** Medio {
 
 `**def dispatch **publicar(EstrenoCine e) 
 `println("Se estrenó: " + e)` 
 `}`
 
 def dispatch publicar(NotaDeportes e) 
 `println("En el orden de los deportes: " + e)`
 `}`
 
        }



        class MedioSubjetivo **implements** Medio {
 `**def dispatch **publicar(EstrenoCine e) 
 `println("Excelente el estreno de: " + e)` 
 `}`
 
 def dispatch publicar(NotaDeportes e) 
 `println("Aburridisimo el partide de: " + e)`
 `}` 
        }


Luego:





        class Main {
 `**extension** Medio = new MedioObjetivo`
        // `extension Medio = new MedioSubjetivo`
 
 `**def static void **main(String[] args) 
 `new Main().run`
 `}`
 
 `**def **run() 
 `val eventos = #[ new EstrenoCine("El Hobbit"), new NotaDeportes("River Campeon") ]`
 
 `eventos.forEach[e | e.publicar() ]`
 `}`
        }


Cambiando la instanciación del provider cambiamos las implementaciones.
## Código Fuente de Ejemplos

Están en el SVN de la materia:
[https://xp-dev.com/svn/uqbar/examples/paco/trunk/languages/xtend/xtend-examples](https://xp-dev.com/svn/uqbar/examples/paco/trunk/languages/xtend/xtend-examples)

## Extension Methods en Scala

Scala merece una página propia para explicar sus mecanismos para extender clases.
Así que pasen por acá y vean:
[Extensiones a clases con Scala Implicits](../conceptos-extension-methods-extensiones-a-clases-con-scala-implicits)
## Extension Methods en otras tecnologías


* [Kotlin](https://gist.github.com/exallium/181c6561014e1daaef4a#file-ext-kt)
* [Nice](http://nice.sourceforge.net/)
* C# **extension methods**

* [Gosu **enhancements**](http://gosu-lang.org/docs.html#getting-started)
* **Implicits** en scala
* Groovy


 * [Categories en groovy](http://groovy.dzone.com/articles/metaprogramming-groovy-i) 
 * [Expando Meta Classes](http://groovy.codehaus.org/ExpandoMetaClass)