[[_TOC_]]


## []()Intro

Scala no posee un feature específico que se llame extension methods. Es decir que no tiene soporte directo o un mecanismo como veníamos viendo en XTend o en Nice.
Sin embargo tiene un conjunto de features asociados que se llaman **implicits.**

Estos implicits son todo un mundo para aprender. Pero vamos a ver acá cómo utilizarlos de modo de emular las ideas de "Extender el comportamiento de clases sin modificarlas diréctamente".


Previo a explicar cómo implementar extensiones, necesitamos entender algunas cositas locas de Scala

## []()Features de Scala

### []()Métodos Implicits en Scala

Un **implicit method**, se puede pensar como una función que recibe un objeto de un tipo, y retorna otro, generalmente de otro tipo. Así, es como una **conversión**.
Por ejemplo esta sabe converitr de Integer a Millas
        **implicit def** integerAMillas(n : Int) : Millas = {
        **    new** Millas(n)
        }
Luego, es **implícito**, porque desde otra parte de mi código, puedo importar este método, y en cualquier parte del código que requiere un objeto de tipo Milla, puedo pasar/usar uno de tipo Integer. Scala automática (e implícitamente) va a convertir de Integer a Millas por nosotros, llamando a nuestro implicit method.
Ej:

**`class`**` ``Auto {`
**`    var`**` ``millasRecorridas : Millas = _`
        }



**`def`**` ``main(args : Array[String]) : Unit = {`
           ` `**`val`**` ``auto = new Auto`
            auto.millasRecorridas =` `*`23`*
        }

La última linea asigna el Int 23 a las millas. Eso es posible, solo porque estamos usando la conversión implicit que definimos antes. Sino no compilaría.
Fíjense que en ScalaIDE, se puede ver subrayado y un ícono a la izquierda para todos los lugares donde el compilador de scala está usando un implicit.

[![](https://sites.google.com/site/programacionhm/_/rsrc/1400876905470/conceptos/extension-methods/extensiones-a-clases-con-scala-implicits/scalaimplicits.png)
](conceptos-extension-methods-extensiones-a-clases-con-scala-implicits-scalaimplicits-png?attredirects=0)




## []()Extensiones a través de Implicits

### []()Implicit Method con un nuevo Tipo Anónimo

Ahora sí, utilizando implicit methods, definimos un método que recibe a la Persona por parámetro y retorna un nuevo objeto que entiende nuevos métodos. En este caso uno solo "cantar", que sería la extensión.

        **implicit** **def** cantarWrapper(p: Persona) =
            **new** {
              **def** cantar = println("Soy " + p + " y canto!!")
            }
        
**def** main(args : Array[String]) : **Unit** = {
            `**var** persona = **new** Persona`
            persona.*cantar*
        }
        
También vemos acá que en scala se pueden definir métodos dentro de otros métodos.
Esto permite, que el cantar, por ejemplo, utilice a la instancia de la persona. Es decir a la instancia que está tratando de "extender".


Una particularidad que tiene esta forma, es que estamos usando los implicit methods, que generalmente se utilizan para convertir entre dos tipos, con un fin distinto.
Recuerden que convierten:



        TIPO_A => implicit method => TIPO_B


Para nuestro fin, no es necesario tener un TIPO_B. En realidad lo que nos interesa es que ese tipo_b tenga nuestros nuevos métodos.
Por eso no tenemos una clase **PersonaExtendida** o una clase PersonaExtensions, o **PersonaExtensionProvider **como tendríamos en XTend. 
Hacemos uso acá de la idea de crear  nuevas clases inline en scala, como si fueran clases anónimas.





        **def** main(args : Array[String]) : Unit = {
           ` **val** objetoLoco = **new** {`
             `**def** imprimirAlgo() = println("algo")`
             `**def** imprimirOtraCosa() = println("otra cosa")`
            }
            objetoLoco.imprimirAlgo()
            objetoLoco.imprimirOtraCosa()
        }


### []()Extensiones a través de Implicit Class

La segunda forma de extender una clase, a diferencia de la anterior, es definiendo una nueva clase. Una especie de "Decorator" de la clase original que queremos extender.
Y, declarándola además como **implicit **(a la clase, no hace falta a sus métodos)





        **  implicit class** PersonaCantante(p: Persona) {
** **`**  def** cantarOpera() {`
 `    println("O sole mio!!!")`
 `  }`
** **`**  def** cantarPayada() {`
 `    println("Aro aro aro!")`
 `  }`
          } 


Luego:





        **def** main(args : Array[String]) : Unit = {
            **var** persona = new Persona


            *persona*.cantarOpera()
            *persona*.cantarPayada()
        }


Al igual que con los implicit methods, acá Scala automáticamente sabe que tenemos importada una implicit class, que recibe a una Persona.
Entonces, nos permite enviarle mensajes definidos tanto Persona, como en esta implicit class PersonaCantate.
Al momento de ejecutar, probáblemente genere una nueva instancia de PersonaCantante, pasándole como parámetro a la persona, y luego ejecutará el método.


***Nota:* **todas las implicit classes deber recibir por parámetro a un objeto de la clase que van a "decorar".
### []()Implicit Method + Clase Provider Regular

Este caso es una variante de los anteriores.
Podríamos definir la clase provider como una clase normal, sin que sea implicit, y luego tener sí un método implicit que haga la conversión de Persona a PersonaCantante.





        **  class** PersonaCantante(p: Persona) {
 `  **def **cantarOpera() {`
 `    println("O sole mio!!!")`
 `  }`
 `  **def** cantarPayada() {`
 `    println("Aro aro aro!")`
 `  }`
          }



          **implicit def** personaACantante(p:Persona) = {
          **  new** PersonaCantante(p)
          }


Luego se utilizar de la misma forma que el ejemplo anterior.