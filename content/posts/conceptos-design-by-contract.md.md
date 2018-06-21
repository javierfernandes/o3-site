## []()Introducción

### []()Qué es un contrato ?

Cuando diseñamos aplicaciones en el paradigma de objetos solemos utilizar un conjunto de herramientas conceptuales y lineamientos generales que son lo que denominamos luego "modelar o diseñar en objetos". Entre ellas, nombramos algunas aquí:

* **Abstracción y encapsulamiento:** un objeto utiliza o colabora con otro objeto enviando mensajes, sin saber cómo se implementan dichos mensajes internamente. Así desacoplándose de la implementación, lo cual nos provee mayor flexibilidad.
* **Polimorfismo:** dos o más objetos son intercambiables para un tercero. Es decir que entienden el mismo mensaje, aunque pueden tener implementaciones diferentes, es decir realizar diferentes acciones. Acá de nuevo, el tercer objeto "cliente" se abstrae de diferenciarlos.
* **Convention Over Configuration:** cuando en lugar de forzar al programador a configurar diversos aspectos del sistema, el sistema mismo tiene la inteligencia de resolver automáticamente esas configuraciones a través de convenciones. Por ejemplo podríamos pensar que un framework de UI infiere la clase de la página de edición de un objeto de dominio dado al agregarle el sufijo "Page" al nombre de su clase. Ej: Persona -> PersonaPage. etc.
* **Framework**: un framework es un conjunto de objetos (y/o clases) que resuelven cierta problemática de una aplicación y nos permite utilizarlo en nuestro dominio específico (o en cualquier dominio). Por ejemplo un framework de persistencia, un framework de UI, etc. A diferencia de una librería, en este caso el framework es quien tiene el control de ejecución y es quien llama a nuestros objetos para completar ciertas "partecitas" que se pueden personalizar para nuestra aplicación. Como por ejemplo archivos de mapeos de hibernate, converters, etc etc.

Y tenemos luego más herramientas un poco más específicas como la herencia (notar que hay lenguajes que no utilizan herencia, o el concepto de clase).
Pero con estos conceptos ya nos alcanza para introducir la idea de design by contracts.

En estos conceptos que enumeramos aparece una idea en común, que también nombramos mucho en las materias donde explicamos diseño. El concepto de **contrato.** 
Este concepto en general puede adoptar diversas formas. Ya vamos a ver que **Design By** **Contracts** es un caso particular.

Por ejemplo, al utilizar un framework tenemos que cumplir con cierto contrato. Que puede ser **implementar cierta interface en java**.** **O configurar cierto servlet en nuestra aplicación (ej fwk de UI).
En el ejemplo de convention over configuration teníamos que cumplir con el contrato de nombres de las clases, etc.

En el contexto del polimorfismo, cumplíamos el contrato al entender el mismo mensaje.

En general, **un contrato establece un acuerdo entre dos (o más) partes**. Si lo cumplimos el sistema va a tener una funcionalidad dada, o un comportamiento. De alguna forma **regula la interacción entre dos módulos de nuestra aplicación. **Entonces intercambiando un módulo por otro que cumple el mismo contrato debería ser transparente para el otro módulo. O al menos compatible.

### []()Contrato & Checkeos

La idea de contrato muchas veces va de la mano de los lenguajes fuertemente tipados y con checkeos estáticos.
Donde, a través de la declaración de tipos, el compilador checkea estos contratos que ya no son algo difuso o abstracto (como puede puede ser una convención de nombres) sino que están explícitamente modelados en el lenguaje. 

Entonces, en un lenguaje como java, para poder enviar un objeto a un mensaje no basta con saber que entienden un mismo mensaje, sino que tenemos que indicarle al compilador que cumplen con ese contrato. A través de un **tipo**, es decir con una **interface** en este caso.



## []()Contratos en Design By Contracts
Design By Contracts es una idea de Bertrand Meyer, creador del lenguaje de programación Eiffel, en la cual intenta aplicar la idea de contratos como un concepto **core** o principal de un lenguaje orientado a objetos.

Entonces si un objeto 

* se comunica con su exterior a partir de **mensajes**

* **provee ciertas funcionalidades**

* **puede contener estado**


No se puede ampliar la "metadata" de esta interfaz del objeto ? Es decir, no sería útil proveer al cliente de mi objeto con más información **declarativa** acerca de restricciones y condicionamientos ?
Obviamente siempre que no acople al cliente de detalles de implementación. No estamos hablando de implementación.

Ahora se va a entender en la siguiente sección con un ejemplo.

### []()Precondiciones
 
#### **[]()Ejemplo

Ya que el comportamiento es algo dinámico, a veces sucede que ciertos métodos son solo válidos bajo ciertas condiciones. 
Ejemplo:
Tenemos una **Pila** que entiende los mensajes push(objeto) y pop() para agregar y sacar un objeto de/a la pila respectivamente.


        **class** Stack
            `**void** push(objeto)`
            `objeto pop()`



No tiene sentido hacer un pop() de una pila vacía, verdad ?

Cómo solucionamos esto normalmente ?
Así...

**`class`**` Stack`

            `objeto pop() :**    if** **this** isEmpty **throw new** Exception *"Cannot pop on an empty stack!" 
                    *  **else **//... implementacion`

Como veran este **checkeo **entonces lo implementamos directamente dentro del código del método. A nivel lenguaje no hay diferencia entre este código y el del "else" es decir las lineas de código que hacen a la implementación **real** del método.

Esto quiere decir que el lenguaje no tiene modelada la idea de checkeos y de **precondiciones de métodos.**


Este ejemplo es eso, un caso de precondiciones de métodos.

La gente de Eiffel entendió que además de que **un mensaje podía recibir parámetros y retornar un valor, puede tener precondiciones.
Precondición es un hecho que debe cumplirse como requisito para poder ejecutar el método.**


Y como tal, forma parte del contrato del mensaje. Porque es algo que debería importarle al cliente de mi objeto. Ya que si no cumple con esta condicion la ejecución del método fallará.

Por ejemplo en Nice, un lenguaje que también implementa esta idea mediante assertions esto se implementaría así:


        **abstract class** Stack { 
        **  int** size();
        **  boolean** isFull();
        **  boolean** isEmpty();

          **void** push()
            **requires**

                 !isFull(**this**) : *"Cannot push on a full Stack!"*

        **  void** pop() 
**`      requires`**

                  !**this**.isEmpty() : *"Cannot pop on an empty Stack!"*

        }
Fíjense que los métodos, incluso los abstractos (como los definidos en una interface) incluyen los contratos de **precondiciones **con la keyword **requires.**

Podemos tener más de una precondicion separándolas por el caracter "coma".


En este caso estamos definiendo una clase abstracta (podría ser una interface). Y entonces mostramos una implementación de ejemplo:


        **class** StackImpl **extends** Stack {
            **int** currentCapability = 0;
            **int** maxCapability = 3;
            
            size() { 
                **return** **this.**currentCapability; 
            }
            isFull() { 
                **return** **this**.size() == maxCapability; 
            }
            isEmpty() { 
                **return** **this**.size() == 0; 
            }
            push() { 
                **this**.currentCapability++;
            }
            pop() { 
                **this**.currentCapability--;
            }
        }

### []()Postcondiciones
De la misma forma en que un método puede tener pre-condiciones que indican cuándo podrá ser invocado, también existen **post-condiciones** que indican las condiciones, que asegura el método, que se cumplirán, luego de la ejecución.

En el ejemplo anterior podríamos establecer el contrato de que luego del push() la pila no estará vacía.
Completamos entonces la definción de Stack con esto en nice


        
`**abstract class** Stack { `
        **  int** size();
        **  boolean** isFull();
        **  boolean** isEmpty() `**ensures** result == (**this**.size() == 0);`

          **void** push()
            **requires**

                 !isFull(**this**) : *"Cannot push on a full Stack!"*
**`    ensures`**

                 !**this**.isEmpty() : *"buffer must not be empty"*;

        **  void** pop() 
**`      requires`**

                  !**this**.isEmpty() : *"Cannot pop on an empty Stack!"*
**`      ensures`**

                  !**this**.isFull();
        }

Fíjense que ahora el método además de precondiciones con **requires** declara las postcondiciones con **ensures.**


Además agregamos un contrato que vinculo los métodos **size() **con **isEmpty() !
**Y el pop() asegurará que la pila no estará llena.

### []()Invariantes
Otro tipo de contrato que podría interesar al cliente de un objeto son las **invariantes.**

Como dijimos antes un objeto puede tener estado, y ese estado puede cambiar a lo largo de su ciclo de vida.
Sin embargo puede que **algunas cosas nunca cambien** como dice la frase.

Y esos hecho podrían ser interesantes para el cliente.
Esto es lo que se llama invariante: es decir, una condición o un predicate que debe ser cierto siempre para un objeto. Como un estado "consistente".
Entonces, el entorno (VM) va a checkear estas invariantes ante cada invocación a un método de nuestro objeto.

Ejemplo:

El tamaño de una pila **size()** siempre será >= 0

**`
class`**` Stack `**` create`[]()** 
 []()`    **make **`**`    invariant`** 
 []()`        size >= 0`
 **[]()` end`**` -- class ACCOUNT `


### []()Contratos & Herencia
Y cómo se lleva la idea de contratos ante el mecanismo de herencia ?
Bien, gracias!

Básicamente, aplican las mismas ideas y conceptos que en la herencia de comportamiento. Las precondiciones, postcondiciones e invariantes se herendan de clase a subclase.

Sin embargo existen algunos condicionamientos, para garantizar el **principio de intercambiabilidad**. Que se pueden resumir en la siguiente frase:
*
**"Require no more, and promise no less"***


Es decir que la subclase no puede agregar nuevos requerimientos o precondiciones. Porque entonces si alguien trata una subclase **Perro** como un **Animal, **y quiere invocarle al método **comer(Comida c)**, Perro.comer()  debería ser compatible con Animal.comer()

Y lo mismo aplica para las post codiciones. Una subclase no puede asegurar menos cosas que lo establecido en el contrato de la superclase.
Podemos compararlo con los contratos legales !

### []()


### []()Qué gano con esto ?

Estos contratos se ejecutan en tiempo de ejecución, y no en tiempo de compilación. Es decir que, tranquilamente, como vimos más arriba, podríamos no necesitar de soporte del lenguaje para implementarlos. Podríamos nosotros mismos implementar los checkeos en el cuerpo mismo del método.

Entonces, la pregunta es, por qué preferiría tener soporte nativo del lenguaje para esto ?

Por varios motivos, aunque sutiles, igualmente importantes.

#### **[]()Reificación

En primer lugar, al tenerlo, estamos reconociendo las precondiciones, postcondiciones e invariantes como elementos de nuestro paradigma, tan importantes como los otros elementos (objeto, mensaje, etc). Es decir que estos conceptos pasan a estar **reificados,** plasmados en el lenguaje mismo como first-class objects

#### **[]()Declaratividad
Ya veremos más adelante de qué se trata la declaratividad en las siguientes unidades. 
Lo interesante en este caso es que, si el lenguaje me provee soporte nativo, nosotros **no vamos a tener que codificar la lógica de la ejecución de los checkeos**, en su lugar, **solo definiremos las condiciones, como predicados, independientes de la ejecución**. 
La VM será la encargada de ejecutar la lógica asociada a las condiciones, en el momento que corresponda.

Ahora que **desacoplamos la declaración de las condiciones, de la ejecución**, es decir del código que la ejecuta, podríamos pensar que estas condiciones se pueden usar/ejecutar en diferentes momentos, o por diferentes objetos cliente.

#### **[]()Capacidades de Metaprogramación
Además, con el soporte nativo, la declaratividad y la reificación, **desacoplamos las condiciones del cuerpo del método**.
Antes, cuando las teníamos dentro del cuerpo, para ejecutar los checkeos debíamos ejecutar el método. No podíamos separarlas.
En cambio **ahora,** si el lenguaje provee soporte, y modela estos conceptos en su API de reflection, nosotros **podremos ejecutar las precondiciones antes de ejecutar el método,** por ejemplo, para saber si ese método será ejecutable, y en caso de no serlo, deshabilitar el botón asociado a el en una interfaz de usuario, por ejemplo.

#### **[]()Expresividad y Claridad
Un poco como consequencia de estos motivos que mencionamos, ganamos claridad en nuestro código y legibilidad.
Como no tenemos código mezclado:

* cuerpo de mensaje + pre/post condiciones
* condiciones + lógica de ejecución

Logramos separar los conceptos (Ver [Separation Of Concerns](conceptos) en Conceptos).

El código ahora expresa más rápidamente la intención (Principio de "*Intention Revealing*").



***


// TODO: revisar esto

### []()Implementaciones
Java con OVal Framework: http://oval.sourceforge.net/userguide.html#d4e237



 * Ej en scala : http://blog.m1key.me/2010/02/programming-scala-design-by-contract.html

 * Eiffel (por su puesto)
 * nice contracts
 * Ruby con handshake (http://handshake.rubyforge.org/)