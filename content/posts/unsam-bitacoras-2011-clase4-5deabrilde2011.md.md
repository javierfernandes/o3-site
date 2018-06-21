Ya nos metemos de lleno en la unidad 2. Vamos a tocar un tema un poco más abstracto.

Lo importante en el paradigma de objetos son los mensajes y en la primera unidad pensamos mucho en eso: mensajes, polimorfismo, tipos. Ahora vamos a ver las diferentes formas de definir lo que hay del otro lado de los mensajes.


#### **[]()Clases
La forma tradicional de ponerle comportamiento a un objeto son las clases. Una clase tiene dos objetivos:

* Es una **unidad de creación**, sirve como molde para crear objetos. Cuando yo quiero crear un objeto lo hago (en la versión más simple) a partir de su clase. Para poder crear objetos entonces, estas clases tienen que ser "completas". No pueden definir un objeto a medias.
* Es una **unidad de reuso**; la clasificación, la subclasificación y la herencia son las formas tradicionales de evitar la repetición de código.
Vamos a analizar la forma de reutilizar código en objetos. Para ello podemos ver un ejemplo muy fácil, con animales. Si tenemos las clases Perro y Humano, ambas podrían ser subclases de Mamífero, que a su vez es subclase de Animal. En otra rama podemos tener Cocodrilo, que es subclase de Reptil y también depende de Animal. Si además queremos tener la característica "bípedo" o "cuadrúpedo" se complica modelarlo con herencia simple, ya que tenemos mamíferos bípedos y cuadrúpedos, y lo mismo podría pasar con los reptiles. 
En un lenguaje con herencia simple estoy obligado a elegir una única entre dos posibles jerarquías. Para el código asociado a la otra jerarquía no tengo una herramienta de reutilización.

¿Qué formas tenemos de solucionar este problema?

* La opción que parece más lógica, es la **herencia múltiple**, presente en lenguajes como C++ o Eiffel. Esto me permite tener más de una superclase y entonces reutilizar *código proveniente de diferentes lugares*. El problema de la herencia múltiple es que resulta en modelos a veces complejos, propio de las posibles colisiones entre métodos heredados de más de los múltiples padres.
* Una forma de solucionar esto es la *delegación*, sin embargo es un esquema muy manual y resulta a veces pesado hacerlo de esta manera.
* Un problema de la herencia simple es el **evil root**.
* Las **interfaces** de lenguajes como Java nos permiten definir polimorfismos independientes de la herencia, pero no nos permiten asociar código con ellas.

La raiz del problema es que estamos utilizando las clases para dos cosas. Como unidad de clasificación y creación por un lado; y como unidad de reuso del otro. Entonces surgieron alternativas a la clasificación y a la herencia que nos dan otros mecanismos de reutilización.

Porque como dijimos, *una clase para poder crear instancias debe definir un objeto "completo"*. *En cambio muchas veces lo que necesitamos es poder reutilizar un "pedazo de código" o un comportamiento específico, que define cierta característica de un objeto, pero que no lo define completamente*. Por ejemplo: Observable, Comparable, etc.

#### **[]()Mixins 
Los **mixins** tienen todas las características de una clase, sin definir una superclase, por eso a veces se los menciona como *subclases abstractas*. Son "pedazos de clases", pueden tener atributos y métodos, pero no tienen constructores ni superclase.

Al agregar un mixin en una clase, este pasa a formar parte de la cadena de resolución de métodos, es decir *forma parte de la cadena de herencia*. Al hacer esto proveen una forma de resolución de los conflictos implícita, que depende del orden en el que se agregan los mixins a la clase en cuestión.
Esto es verdaderamente una limitación ya que **la clase no tiene control sobre la composición de los mixins**.
Y por ejemplo combinado con la herencia, puede traer varios problemas (por ej: si heredamos de una clase que ya tiene mixins, desde nuestra clase no podemos controlar o cambiar esa composición).

Otro problema de los mixins es la posibilidad de tener estado, ya que los conflictos entre las variables pueden ser más complejos que los conflictos entre los métodos.

#### **[]()Traits
El concepto detrás de los traits es formar *unidades de composición*. En esta visión, una clase podría ser simplemente la composición de varios traits.  Y un trait, como unidad de reutilización, no requiere definir un objeto "completo".

Para llevar esto a cabo, las diferencias fundamentales con los mixins son:

* No pueden tener **estado**

* Se **componen** "en tiempo de diseño", o sea los métodos definidos en el trait pasan a formar parte integral de la clase, en tiempo de ejecución son indistinguibles los métodos del trait de los métodos de la clase. No existen en tiempo de ejecución.

* Los **conflictos** se resuelven explícitamente.

¿Qué puede hacer un trait?

* **Proveer** un conjunto de métodos que implementan un comportamiento.
* **Requerir**, que la clase (u otro trait) entienda mensajes que el trait envía.
* **Componer** otros traits.


Desde esta visión, una clase consiste de:

* Superclase
* Estado
* Traits
* Métodos 

La versión más radical dice "glue methods", es decir, únicamente métodos que juntan todo lo demás, el comportamiento no está en los métodos sino en los mixins y los métodos simplemente coordinan los diferentes traits.

### []()Ejemplos
Finalizada la parte teórica pasamos a ver algunos ejemplos en Pharo y Scala. 

#### **[]()Animales
Modelamos Animales que subclasivicamos en Mamíferos, Aves y Reptiles. Encontramos que algunas de sus características no podían ponerse en una jerarquía de herencia y las modelamos como traits:

* forma de reproducción (vivíparos, ovíparos) 

* su forma de desplazarse (bípedos, cuadrúpedos, acuáticos). 

En este ejemplo pudimos ver:

* Que los traits nos permitían **modelar características** independientemente de la jerarquía de clases, que luego podemos asociar a todas las clases que quisiéramos. Tener traits nos agrega una nueva forma de abstraer y de conceptualizar, que se agrega a las clases, la herencia, etc.

* Que nos permitían entonces **reutilizar el código**, a partir de ponerle el mismo trait en todas las clases que compartieran esa característica. Por ejemplo TAcuático lo podemos asociar a las clases Delfin, Cocodrilo y Pato, que están en diferentes lugares de la jerarquía.
* Que podemos **componer nuestras clases asociándole muchos mixins**, por ejemplo a la clase Pato le asociamos los traits TBipedo y TAcuatico.
* Que **la composición se realiza en *tiempo de diseño***. Esto quiere decir que una vez asociado un trait a una clase, los métodos que estaban en el trait son indistinguibles de los métodos de la clase, en tiempo de ejecución los traits *no existen*.
Y luego vimos algunas reglas para definir cómo se componen los métodos en caso de conflictos:

* En la clase puedo sobreescribir los métodos que me vienen de los traits.
* Los métodos en los traits tienen preponderancia ("pisan") sobre los de las superclases
* Si tengo el mismo mensaje en dos traits se produce un conflicto que hay que resolver sí o sí.

* Puedo cancelar métodos: - {#caminar}
* O agregar un alias: @{#correr -> #caminar}

Algo a tener en cuenta: si bien el nombre que se le da en Scala es "trait", se parece más a lo que en la teoría llamamos "mixin".

Alquileres
Teníamos muchas cosas que se podían alquilar y no están en la misma jerarquía: Bicicleta, Auto, DVD, etc. Entonces pusimos el comportamiento en un trait TAlquilable que define el comportamiento necesario para alquilar un objeto cualquiera. 

El trait define el comportamiento alquilarA: unArrendatario, que se implementa:





        alquilarA: unArrendatario
            self estaAlquilado 
               ifFalse:` [ `
                   `unArrendatario debitar: self precio. `
                   self arrendatario: unArrendatario ]
               ifTrue: [ self error: 'Ya está alquilado' ]

        estaAlquilado
            ^self arrendatario isNil

La dificultad nueva que aparece con este trait, es que este necesita almacenar en algún lado a quién le alquiló el objeto (el arrendatario) y como dijimos los traits no pueden definir estado. Entonces ese estado deberá estar en la clase a la que se agrega el trait. 

¿Cómo se logra eso? Verán que el trait envía tres mensajes que no están definidos en el trait: #arrendatario, #arrendatario: y #precio. Decimos que el trait **requiere** estos mensajes, esto quiere decir que el contexto en el cual agreguemos este trait deberá proveer implementaciones para esos mensajes. 

Este concepto se puede asociar a la idea de un método abstracto. En Pharo se los suele definir como `#required`:


        arrendatario
            self required

        arrendatario:
            self required

        precio
            self required



A continuación implementamos el mismo código en Scala. La principal diferencia que notamos es que los traits/mixins de Scala sí permiten tener estado, entonces el trait puede ya acordarse del arrendatario sin requerir nada del objeto. 

Otra diferencia (sutil) es que acá el chequeo de tipos va a verificar que la clase a la que le agreguemos el mixin va a chequear tipos y no va a compilar si no cumplimos el requerimiento (#precioAlquiler).

El código del mixin nos queda:

        trait Alquilable {
            var inquilino : Inquilino = null
            
            // restriccion sobre la clase en que se va a aplicar
            def precioAlquiler : Int

            def alquilar (inquilino : Inquilino) = {
                if (!(this disponible)) {
                    error("Este objeto '" + this + "' ya esta alquilado a: " + this.inquilino)
                }
                inquilino debitar(this precioAlquiler)
                this inquilino = inquilino
            }
            
            def disponible = this.inquilino == null     
        }

Finalmente la diferencia en Scala es que **los mixins se pueden agregar tanto a las clases como a los objetos**. Agregarlo a las clases es parecido a lo que hacemos en Pharo:
        class Automovil (marca : String, modelo : String) extends Vehiculo with Alquilable {
            `def precioAlquiler : Int = 25 `
        }

Pero también lo podemos asociar a los objetos:

        var miBicicleta = new Bicicleta with Alquilable


#### **[]()Múltiples mixins
En el último ejemplo definimos múltiples mixins sobre la clase Ball y eso nos permitió ver cómo al componerlos de diferente manera cambiaba el comportamiento. Esto nos muestra que los mixins se meten en la jerarquía de herencia, a diferencia de los traits.

Por lo tanto las dos líneas siguientes producen comportamientos distintos:
 
           val myBall = new Ball with Shiny with Red
           val anotherBall = new Ball with Red with Shiny

Para que esto funcione tenemos que ver cómo hace un mixin para llamar al método que está sobreescribiendo (super):

        trait Red extends Ball {
            override def properties() = super.properties ::: List("red")    
        }

La diferencia concreta es:

* Entre dos traits con el mismo mensaje se produce un conflicto, que hay que resolver a mano.
* Entre dos mixins con el mismo mensaje, uno sobreescribe al otro y el comportamiento depende del orden en que se agreguen.

Si en un mixin usamos super, eso va a llamar al siguiente mixin en la cadena de delegación, en cambio si en un trait hacemos super va a buscar en los métodos de la superclase, ignorando otros traits en esta clase.