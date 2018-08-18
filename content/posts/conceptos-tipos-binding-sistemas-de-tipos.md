---
title: "conceptos-tipos-binding-sistemas-de-tipos"
date:  2018-06-20T19:27:10-03:00
toc: true
---

Seguimos la presentación de Kim B. Bruce. *Foundations of Object-Oriented Languages: Types and Semantics*.
Otra fuente interesante: Martín Abadi and Luca Cardelli. *A theory of objects*.

### ¿Qué es un tipo?

* Conjunto de valores o "elementos de un conjunto", más...
* Conjunto de operaciones que puedo realizar sobre ellos.

Ej: 

* Números: 1, 2, pi,
* Los puedo: sumar, restar, dividir, etc..


#### ¿Y en objetos?

Los "valores" son los objetos, las "operaciones" son los mensajes. En objetos tenemos eso, objetos y mensajes.
Creemos que para pensar las implicancias del concepto de tipo en objetos, conviene pensar a los tipos más desde las operaciones que como conjuntos de valores.
Por lo tanto, vamos a asociar tipos con conjuntos de mensajes. Vamos a ver que en distintos lenguajes la definición y validación de tipos tienen distintas características.


La primer idea es matchear un tipo con una clase.Pero no es la única idea de tipos en OOP. Porque un objeto puede implementar **varios tipos**.


Sirve comparar tipo y clase en Smalltalk y en Java que son los dos lenguajes que conocemos, y también pensar en la defnición de polimorfismo ¿se está hablando de tipos o de clases ahí?.
[Este](../ClasesEjemplo-png?attredirects=0) es el ejemplo que usamos para explicar esto.

### ¿Para qué sirven los tipos?


Para muchas cosas.


**A los programadores** nos ayuda a ordenarnos las ideas. Asociando tipos con conjuntos de mensajes, podemos entender qué tipo va a tener el objeto asociado a una variable, y por lo tanto qué mensajes tiene sentido enviarle. También entendemos qué tipo esperamos del objeto que va a llegar como parámetro a un método.
Si tengo este código Scala


```scala

// Familia
var elPerro: Perro
        

// Cuidador
def administrar(p: Perro) = {
  // ...
}
```

entonces sé que 

* dentro de los métodos de Familia al objeto referenciado por elPerro les puedo enviar los mensajes reproducirse,  caminar y ladrar, 
* dentro del método adminstrar en Cuidador, al objeto que me llega por el parámetro p le puedo enviar esos mensajes
* el objeto que paso por parámetro al enviarle adminsitrar a un Cuidador , seguro, tiene que poder entender estos mensajes. En realidad, como está el código puesto, tiene que ser un `Perro`. Estas dos cosas ¿son lo mismo? Más adelante discutiremos esto.



**A los lenguajes de programación** le sirve la información de tipos para poder atajar posibles errores antes de que ocurran, estos son los chequeos estáticos de los que vamos a hablar también.
Un ejemplo que ya sabemos: en Scala, el método





        #Cuidador
         def administrar(p: Perro) = {
            p.nadar
        }



no compila, porque el lenguaje se puede dar cuenta de que el objeto que llegue por el parámetro, dado que es un Perro, *no puede garantizarse* que entienda el mensaje nadar.
Este es el **error de tipos** típico en objetos: le envío un mensaje a un objeto que no lo entiende.


**A los entornos de desarrollo** les sirve para asistir al escribir un programa. Si en Eclipse estoy escribiendo el método 






        #Cuidador
         def administrar(p: Perro) =     p.``}`



y después del "p." pulso Ctrl-Space, me abre una ventanita con las opciones de los mensajes que le puedo enviar a p. Eso lo puede hacer porque sabe que es un Perro, si no ¿cómo haría?




Subtipado


Un subtipo es ... lo que nos imaginamos a partir de pensar en clases / subclases, o interfaces / subinterfaces. 
Van distintas definiciones de cuándo vale decir que B es subtipo de A.

* desde las **operaciones**: si todos los mensajes que le puedo enviar a un (objeto con el tipo) A, seguro que también se los puedo enviar a un (objeto con el tipo) B.
* desde los **usos**: si a cualquiera que le puedo enviar un A, acepta un B.
* desde la **concepción**: si de cualquier B puedo decir que es un A.
Pensar en Mamifero y Perro, en cualquiera de las tres definiciones, da que Perro es subtipo de Mamifero. 


Para qué me sirve ... básicamente para habilitar polimorfismo.  Si a un método que espera un Mamifero no le puedo enviar un Perro o un Delfin ... kaput polimorphismus.
En realidad este es el tipo de polimorfismo típico de los objetos, el (justamente) polimorfismo por subtipado. Los que conocen programación funcional vieron otras formas de lograr polimorfismo.



#### Problemas de la relación de subtipado


Pensemos en clases que modelan Cuadrados y Rectángulos. ¿Cuál es la relación entre esos clases? ¿Alguna resulta ser subtipo de otra?


Si entendemos herencia como una relación “es un”, es cierto que un cuadrado “es un” rectángulo. Siguiendo ese principio Cuadrado debería  ser un subtipo de Rectángulo.


Sin embargo, los Rectángulos podrían tener métodos inadecuados para un Cuadrado, por ejemplo `stretch: (Integer × Integer) -> Void`. El método stretch recibe dos coeficientes y transforma a un rectángulo estirándolo en función de esos coeficientes. Esa operación no puede ser realizada por un Cuadrado.


Este problema se produce en muchos lenguajes orientados a objetos, ya que ***las ideas de clase y herencia concentran muchas de las herramientas de esos lenguajes***:

1. Las clases son la única forma de **definir el comportamiento de un objeto.**

2. Las clases son la única forma de **crear objetos.**

3. Las clases son la única forma de **definir tipos.**

4. La herencia es la única forma de **compartir comportamiento** que no requiere una codificación específica.
5. La herencia es la única forma de **definir subtipos.**


Y para colmo la herencia está restringida a "herencia simple", es decir, cada clase puede tener una única superclase. 


En algunos lenguajes como Java, la presencia de interfaces relaja un poco las ideas 3 y 5; sin embargo las clases y la herencia aún tienen una importancia grande. Sin duda es una mejora, pero todavía es una mejora pequeña. En esta materia vamos a ver más lenguajes que proponen más herramientas para solucionar estos problemas.


## Características de un Sistema de Tipos

Generalmente escuchamos (y NOS escuchamos) hablar de que tal o cual lenguaje es "tipado" y tal otro no. O que es "débilmente tipado", en contraposición a "fuertemente" tipado.También hablamos de lenguajes "**estáticos**", lenguajes "**dinámicos**". Y hasta de lenguajes **con o sin checkeos** (de tipos).

Si pensamos que un lenguaje se puede definir en base a una única de estas categorías, entonces estamos equivocados. Porque cada una de ellas describe diferentes **características de un lenguaje.**

Por lo tanto, a veces incluso confundimos las categorías y decimos que un lenguaje es dinámico, cuando en realidad queremos expresar la idea de que el los checkeos se hacen en runtime.

La idea de esta sección es plantear a modo de sugerencia, una categorización de los lenguajes en términos un poco más precisos. Describimos entonces los siguientes aspectos o características de un lenguaje:
### **Momento del checkeo**


Se refiere a la capacidad del lenguaje de verificar que una operación es válida para un objeto dado.
Distinguimos entre estas tres opciones:

1. **Chequeo estático**



 * Se realiza antes de la ejecución (por ejemplo, los realiza el compilador).
 * Ejemplos "puros": Haskell y Scala hacen todos sus chequeos en forma estática.
 * Ejemplos "impuros": Java y C hacen chequeos en forma estática, pero esto no es todo lo que pasa.
1. **Chequeo dinámico**



 * Se realiza durante la ejecución.


 * Al encontrarse un error de tipos durante la ejecución / evaluación, el lenguaje lo detecta y modela. 
 * Un ejemplo que conocemos todos es Smalltalk. El modelo de error de tipo es el DoesNotUnderstand.
 * Otros ejemplos: Python, Ruby.
1. **No chequea en ningún momento**


 * Al encontrarse un error de tipos durante la ejecución / evaluación, el lenguaje no lo detecta, y las consecuencias son impredecibles.

#### Casteo

Ponele que en un programa Java tenemos también paseadores, que en principio pueden pasear cualquier mamífero






        #Paseador

        **public** Mamifero getAnimal()



pero yo sé que Pepe, que es un paseador, solamente acepta pasear perros. Entonces le quiero decir al animal que pasea Pepe que ladre

        

        pepe.getAnimal().ladrar()
        



El chequeo estático de Java no me va a dejar hacer esto, como él no puede garantizar que a lo que devuelve pepe.getAnimal() le pueda enviar el mensaje ladrar()  va a detectar un posible error de tipos, y por lo tanto esta línea no va a compilar.
A veces pasa que el chequeo estático de un lenguaje restringe por demás, impide al programador hacer cosas que necesita. Java, y también otros lenguajes como Scala, C#, etc, dan un mecanismo que permite lograr que una expresión que "no debería compilar" sí compile. Esta característica es el **casteo**. 
El casteo consiste básicamente en decirle al compilador *"creeme que este objeto tiene el tipo que yo digo, aunque vos no te puedas dar cuenta"*. Para que el compilador de Java nos crea que lo que devuelve pepe.getAnimal() es un perro, casteo el resultado. 



        (Perro) pepe.getAnimal()





Java acepta que esta expresión es un perro, y por lo tanto me permite enviarle los mensajes específicos de x. Por lo tanto, esta línea



        ((Perro) pepe.getAnimal()).ladrar()





sí compila.
Ahora ¿qué pasa si yo me equivoqué y en realidad Pepe está paseando un gato? Auch, el compilador dejó pasar esta línea, entonces se va a tratar de evaluar, y va a saltar el error de tipos.
Para contemplar estos casos, en presencia de casteos, Java hace además, chequeo dinámico, no estático. El modelo del error de tipos detectado dinámicamente es la ClassCastException.


El lenguaje C también tiene esta característica. Pero con una diferencia: *si un casteo en C genera un error de tipos, en tiempo de ejecución no se hace chequeo dinámico*, y las consecuencias son imprevisibles. Por eso decimos que C tiene una parte de chequeo estático, y una parte en la que no se hace ningún chequeo.


**Nota importante:**

El caso del paseador de perros se puede solucionar en Java usando Generics (o su nombre más correcto en la teoría de tipos: "*tipos paramétricos*"), que es la misma característica que usamos para declarar una lista de perros como x, y por lo tanto enviarle el mensaje y a cada elemento.
Los Generics eliminan las necesidades de casteo más típicas de Java, pero no todas. Por eso siguen estando los casteos ... y por lo tanto la necesidad de mantener algo de chequeo dinámico en Java y C#.

#### Coerciones - parece parecido pero es otra cosa

Miremos este código Java:




        **double** n1 = 43.0;
        **float** n2 = n1;





la segunda línea no va a compilar. Como un double puede bancarse, en principio, valores más grandes que un float  entonces no puede garantizar qué valor va a ir a parar a n2.
Para forzar a que se acepte la segunda línea, hay que poner algo que tiene la misma sintaxis que el casteo.



        **float** n2 = (**float**) n1;





como tiene la misma sintaxis, y también responde a un caso en que el compilador no me permite hacer algo que quiero hacer, se puede pensar que es un caso más de casteo.
*No, no, no es así, lo que está pasando es otra cosa*.
Lo que estamos diciendo acá es "transformá el double en un float . Un double tiene una representación distinta a un float  acá el Java está haciendo una transformación de datos. A este tipo de transformaciones se las llama **coerciones**.
En un casteo no se hace ninguna transformación. En el ejemplo anterior, el animal que está paseando Pepe no se transforma en un perro por el casteo. Simplemente, si ese animal **es** un perro, entonces el código funciona sin problemas, y si no, se genera una ClassCastException. 


Cuánta información de tipos tengo que escribir


1. **Explícito**



 * Estoy obligado a proveer anotaciones de tipos, por ejemplo para las variables, para los parámetros y los valores de retorno de un método / procedimiento / función.
 * Java es un ejemplo típico en el que hay que indicar explícitamente el tipo de cada cosa: variable, parámetro, tipo de retorno de método.
1. **Implicito**



 * No requiere que proveamos información de tipos.


 * En lenguajes con chequeo estático en los que no se provee información de tipos, se trabaja con la idea de **inferencia**. Haskell hace mucho de inferencia de tipos, Scala también hace bastante, aunque menos.
 * Los lenguajes muy volcados al chequeo dinámico suelen ser implícitos. P.ej. Smalltalk.
 * [http://c2.com/cgi/wiki?ImplicitTyping](http://c2.com/cgi/wiki?ImplicitTyping)
En realidad no conviene pensar en "lenguajes absolutamente explícitos" o "absolutamente implícitos", sino más bien en la cantidad de información de tipos que debe proveer el programador. Si es mucha, entonces vamos a decir que el lenguaje es explícito. Si es poca, y en particular el lenguaje está pensado para minimizar la información de tipos que se escribe, entonces diremos que es implícito. Y también hay intermedios, como el caso de Scala.
Esta cuestión de no tomar las clasificaciones como un "boca vs river" vale para las tres clasificaciones que incluimos.


De hecho, todo lenguaje tiene algo de inferencia. Si la Familia tiene un getter para el perro, y escribo



        familiaLopez.getPerro().ladrar()
        



se está dando cuenta que a lo que devuelve familiaLopez.getPerro() se le puede enviar el mensaje ladrar()  Eso es una inferencia fácil (porque surge de la información que se indicó en el método getPerro()), pero inferencia al fin.
OJO que según qué literatura se lea, esto que contamos recién no se considera inferencia.


En el otro extremo, no conocemos ningún lenguaje basado en clases en el que, para crear un objeto, no sea necesario decir de qué clase tiene que ser. Eso no se puede inferir.

### Identificación de un tipo
Se refiere a la manera en la que se define qué tipo se espera del objeto que se espera, como parámetro de un método, o para ser asignado a una variable. Mencionamos estas dos formas.

1. **Nominal**



 * Al definir un tipo se le asigna un nombre que lo hace único. Dos tipos que coincidan en todo salvo en su nombre, son tipos distintos e incompatibles.
 * Para poder tener polimorfismo es necesario explicitar las relaciones entre los tipos.
1. **Estructural**



 * El tipo se identifica por sus características, por ejemplo, qué mensajes debe entender un objeto para ser de ese tipo.

 * Dos tipos que tienen las características esperadas son automáticamente polimórficos.
 * Asociado a la idea de [Duck Typing](http://c2.com/cgi/wiki?DuckTyping).
 * El tipado estructural se puede dar combinado con tipado implícito, y también con tipado explícito.




Qué permite el tipado estructural


Supongamos que en Java tenemos una clase o interface Organismo que tiene definido el mensaje reproducirse() y tenemos este código


        
#Paseador
**public** aplicarCuidados(Mamifero organismo) {
    organismo.reproducirse();
}

#En otro lado
Organismo unOrga = ...;
Paseador pepe = ...;
pepe.aplicarCuidadosEspeciales(unOrga);


la última línea no va a compilar, porque Mamifero y Organismo son dos tipos distintos.
Esto muestra que Java se maneja con *tipado nominal*: lo que distingue a un tipo es el nombre, no sus características.


En este caso el lenguaje nos impide hacer algo que podríamos querer hacer. En este caso el casteo no ayuda (¿por qué?).
Habilitar que se le pueda enviar un Organismo como parámetro a aplicarCuidados(organismo) no trae riesgos de errores de tipos: los dos tipos definen exactamente los mismos mensajes (en este caso uno solo que es reproducirse() . Decimos que estos tipos son **estructuralmente** equivalentes. 
La idea de tipado estructural permite que el lenguaje no trabe estos usos de la idea de polimorfismo.


#### Distintos casos de tipado estructural
En lenguajes con tipado dinámico e implícito, como Smalltalk o Ruby, el tipado es naturalmente estructural. Por ejemplo:



        #Titiretero


        darFuncion: titere
            titere` decir: 'Hola!'`
            titere` levantarBrazo`**

            titere` decir: 'Adios!'`
Nótese que no especifica de qué tipo es "titere", ya que no se declaran los tipos de las variables. Sin embargo, dentro del cuerpo del método le envía dos mensajes: decir y levantarBrazo. Estas son las características que se espera del títere en este método. 
**Implícitamente** se está definiendo que el objeto títere tiene que cumplir con el tipo que define estos dos mensajes. Este tipo  **no tiene nombre**, la especificación del tipo requerido no es nominal.

**A eso se le llama DuckTyping!**

El término proviene de una frase en inglés que dice: *"Si camina como pato y suena como pato.. entonces es un pato".*
Se hizo popular especialmente con un lenguaje relativamente nuevo, llamado **ruby**.


En lenguajes con tipado estático parece bastante más complicado, sin embargo es posible. Un ejemplo es le lenguaje Scala:
        **

**


def enElBosque( pato : { def cuack : def plumas }) = `
            print *`'Tengo un pato y pienso usarlo!!'`*
            pato.cuack()
            pato.plumas()
Vemos que el parámetro "pato" no tiene definido un tipo a través de un nombre sino a  través de la especificación de su estructura, es decir, de los mensajes que entiende. Que son: **cuack** y **plumas**


Es interesante ver que el compilador realiza checkeos con esta información. Y no permitirá que le enviemos otro mensaje que no sea uno de esos. dentro del método.
Pero más interesante aún, que también checke cuando invocamos el mensaje "enElBosque(algo)" con algo, ese algo debe entender ambos mensajes.

Lo interesante de **la intersección de estos dos features** (checkeos + ducktyping), es que nos** provee** el nivel de abstracción y **desacoplamiento de las clases** (de sus nombres), y por lo tanto la **flexibilidad**, pero **al mismo tiempo**, seguir teniendo los **checkeos** y la validación del programa en tiempo de compilación.

### Estudio de algunos lenguajes
Ahora usemos los criterios que definimos para estudiar algunos lenguajes de programación juntando varios elementos que aparecieron.
#### Java

Momento del chequeoMayormente *estático*, pero *en presencia de chequeos se hace dinámico*. Modelo de error de tipos en chequeo dinámico: ClassCastException.Información de tipos que    hay que escribirMucha, está muy del lado *explícito*. 
En la "cultura Java" se considera esto una ventaja, se dice que facilita la comprensión de las interfaces y de los programas, para las personas que los tienen que usar y mantener. Identificación de tiposNominal. Lenguajes similaresC# (hasta donde sabemos)

#### Smalltalk

Momento del chequeo*Dinámico*, modelo de error de tipos: DoesNotUnderstand.Información de tipos que  hay que escribirLa mínima posible, está muy del lado *implícito*.
La idea es minimizar la cantidad de "burocracia" en el código. El nombre del lenguaje es muy claro al respecto.Identificación de tiposNaturalmente *estructural *: no se le pone nombre a los tipos.Lenguajes similaresRuby (hasta donde sabemos)


#### Scala

Momento del chequeo*Estático*. La idea es brindar muchas herramientas desde el sistema de tipos para poder combinar chequeo estático con flexibilidad para aprovechar el polimorfismo. Una de estas ideas es permitir tipado estructural, otra la veremos más adelante.Información de tipos que  hay que escribir*Intermedio*. En varias ocasiones puede inferir tipos. en otras hay los tiene que proveer el programador.Identificación de tiposPermite que el programador combine tipado nominal en algunos lugares y estructural en otros, dentro del mismo programa.Lenguajes similaresno conocemos

#### Haskell

Momento del chequeo*Estático*. Muy preocupado desde la concepción por evitar errores de tipos. Da herramientas para permitir polimorfismo.Información de tipos que  hay que escribirMuy poca, está muy del lado *implícito*. Entre sus objetivos está aprovechar la inferencia de tipos todo lo que se pueda. En algunos (pocos) casos a la inferencia no le da la nafta, y el programador debe ayudarla poniendo algo de información de tipos.Identificación de tiposEn general *nominal*, hay *mecanismos de tipado estructural provistos* por el lenguaje (polimorfismo paramétrico).Lenguajes similaresno conocemos


## Buscando el lenguaje perfecto

Ahora que podemos estudiar el tratamiento que hace un lenguaje de los tipos, pensemos cómo nos gustaría que fuera, en este aspecto, un lenguaje de programación ideal.


Veamos qué podría querer un programador que quiere trabajar lo menos posible

1. Que tenga chequeo **estático**, para no tener que preocuparme por los errores de tipos, que me los verifique el lenguaje.
1. Que el tipado sea **implícito**, para escribir menos código.
1. Que la identificación de tipos sea **estructural**, para que me permita aprovechar más el polimorfismo, lo que implica que tengo que preocuparme menos por cuándo voy a poder usar un objeto en un determinado contexto: si puedo el lenguaje me va a dejar sin que tenga que hacer nada, si no puedo me va a dar error de tipos en forma estática (porque ya pedí chequeo estático).

Como ya dijimos, no todo el mundo está de acuerdo con esta lista de deseos. 

* Un programador con una visión más "organizativa" (por llamarlo de alguna forma) podría preferir tipado explícito, e incluso identificación nominal.
La razón es que aunque el programa queda más largo, y tal vez más difícil de armar, al poner mucha información de tipos y ponerle un nombre a cada tipo que se está manejando, hay mucha documentación que queda dentro mismo del programa.
Esta visión tiene adeptos particularmente en proyectos grandes, por los que pasan muchos programadores.
* A un programador con mucha autoconfianza podría preocuparle poco que el chequeo sea estático, si igual él/ella sabe bien lo que está haciendo.

Haciendo esta aclaración, volvamos a la lista de deseos del programador vago, y analicemos qué tan feliz lo hacen algunos lenguajes de los que ya hablamos.
**Java** sacrifica 2 y 3, para obtener 1. La concepción de Java esta más orientada al progamador "organizativo".
Como ya vimos, el chequeo estático de Java se queda corto, por el tema de los casteos. 
Para reducir el uso de casteos, se incorporaron los generics. Esto no fue gratis, porque los generics hacen que el lenguaje sea más difícil de entender, e introduce sus propios problemas. Igualmente, creemos que el balance es positivo, java gana más de lo que pierde al incorporar generics.
**Smalltalk** es al revés, te da 2 y 3, y no le importa nada 1. Está más pensado para el "programador con mucha autoconfianza". Hubo estudios para agregar inferencia de tipos a Smalltalk o lenguajes similares, y así ganar algo de chequeo estático, o al menos ayuda en el entorno de desarrollo. Hasta donde sabemos, es un tema muy complejo.
**Scala** quiere brindar todo lo que se pueda de 2 y 3, sin sacrificar 1. Creemos que es una evolución interesante.


¿Y las conclusiones? Las decide cada uno.



## Extras / Referencias

### Sistemas de Tipos Híbridos
Algunos lenguajes tiene caracteristicas de más de una categoria, de modo de poder aprovechar las ventajas de ambas.
Por ejemplo el lenguaje **Pike** tiene checkeos tanto estáticos como dinámicos, sin embargo es fuertemente tipado (explícito).

Es decir que nos fuerza a declarar tipos de las variables (explícitos) y con esos tipos hace checkeos en tiempo de compilación (estático).
Sin embargo permite cierto dinamismo en la declaración de los tipos.

#### Declaración de múltiples tipos (Tagged Unions)

Podemos declarar una variable con opciones de tipos
```
        **    int**|**string** w;

```

acá decimos que la variable w puede ser de tipo int ó de tipo string.
Y de la misma forma podemos aplicar esto a métodos:```
            array**(int**|**string|float****)** make_array**(int**|**string**|**float** x**)** `
             **return** ({ x });
            }
```
Este método **make_array** recibe un parámetro llamado **x** que puede ser o bien **int** ó, **string**, ó **float**. Y retorna un objeto de tipo **array** de elementos de tipo **int**, **string, **o** float**.
El cuerpo del método crea un array con el único element **x**.

#### Variables de tipo Mixto

En el extremo del dinamismo, podemos declarar variables de tipo **mixed** que significa **de cualquier tipo**.
Si hacemos todo nuestro sistema con variables de tipo mixto, estariamos utilizando el lenguaje como uno puramente **dinámico** e **implícito**.
Porque claro, cuando decimos que una variable es **mixed** el compilador ya no puede hacer ningún tipo de checko.

```
        **    mixed** x;
            array**(mixed****)** build_array(**mixed** x) { **

        return** ({ x }); 
    }
```
Otro ejemplo:

        **    int** main() {
                **mixed** ent = 2;
                **int** len = sizeof(ent);   // size of es una función que recibe un string
            }

*Cuál es la diferencia con declarar la variable como Object en java ?*

Que en java, al intentar compilar este código fallaría. Ni siquiera comenzaría a ejecutarse.
En cambio, en **pike** este código compila sin ningún error. Sin embargo falla al ejecutarse.
Quiere decir que en java el checkeo se hizo en el momento de compilación (**estático**), pero en pike se hizo en tiempo de ejecución (**dinámico**).
#### Option Types en Nice
En lenguajes imperativos con asignaciones de variables, obviamente aparece el concepto de **null, nil, **o como se llame según el lenguaje, que se refiere a que en un momento dado, la variable puede no estar referenciando a un objeto.

También, por esto, sucede que suele ser un error bastante común intentar enviarle un mensaje a una variable sin referenciar. En java es el famoso **NullPointerException.** En smalltalk simplemente va a decir que el objeto **nil **no entiende el mensaje que le estamos enviando.

En nice se puede incluir dentro de la declaración de tipos, información relativa a si la variable **puede o no, ser null**. En forma declarativa.

A esto lo llaman **Option Types**. Y se denota por el simbolo **? delante del tipo.**

Lo interesante, es que **el compilador hace checkeos** !!! Y tiene un tipo de **inferencia de nulidad**.
**

**Ejemplo**:

**

        class Persona {
            **?String** nombre;
        }

        void imprimirNombre(String nombre) {
            println(name);
        }
Esto indica que una Persona **puede o no, tener nombre**.
En cambio el método **imprimirNombre** recibe un String, que **no puede ser null.**


Qué pasa al querer utilizarlo ?


void main(String[] args) 
            Person p = new Person(name: "blah");`
            let name = p.name;`
            printName(name);
        }
Mmm... no compila !

**    Arguments (?java.lang.String) do not fit:  nice.lang.void printName(String name)**


Ok, dice que ?String no es lo mismo que String.
Pero, hará solo un checkeo de tipos, considerando que por ser "?" es distinto y ya ?

Qué pasa si agregamos un **if** por **null** ??`
        

void main(String[] args) 
            Person p = new Person(name: "blah");
            **let** name = p.name;
            **if** (name != null) {                       
                printName(name);                  
            }
        }
Ahora compila !!!

Es decir que el compilador es un poco más inteligente de lo que creíamos. Utilizar inferencia, para darse cuenta que en este caso la variable **name** no es nula (por el if), entonces por más que sea de tipo ?String, y sabe que referencia a un String, por lo cual la invocación al método es válida.


### **Checkeos estáticos Opcionales de tipos en Cecil. Signatures & Methods**



* [http://www.cs.washington.edu/research/projects/cecil/www/cecil.html](http://www.cs.washington.edu/research/projects/cecil/www/cecil.html)
* [http://www.cs.washington.edu/research/projects/cecil/www/Release/doc-cecil-lang/cecil-spec.ps](http://www.cs.washington.edu/research/projects/cecil/www/Release/doc-cecil-lang/cecil-spec.ps)