---
title: "conceptos-dsls-domainspecificlanguage-dsl---xtext"
date:  2018-06-20T19:27:10-03:00
---


[[_TOC_]]


## []()Qué es **XText **?

* Es un **framework** (o herramienta) **para la creación de lenguajes**.
* Hecho **en java**, conectado con otros **proyectos de eclipse** para desarrollo de **metamodelos** (EMF).

* Provee **soporte** para la creación de toda la infraestructura necesaria para desarrollar un lenguaje como:

 * **compiladores**

 * **intérpretes**


 * **editores y herramientas** de tipo IDE, a través de la integración con Eclipse.
* Se basa en **desarrollo iterativo**.

 * Construye toda la infraestructura.
 * Nos **permite refinar** diferentes aspectos del lenguaje **luego**: 


  * checkeos y validaciones, warnings & errors.
  * formatter para el editor de texto
  * syntax highlight & coloring
  * iconos e imágenes para cada entidad en el outline / editor
  * content assist (autocomplete)


## []()Gramática, Generadores e Inferrers

La forma en que trabajamos con XText para definir nuestro lenguaje se puede resumir así:

1. **Definimos una gramática:  **define la sintaxis y los elementos de nuestro lenguaje.
1. **Definimos qué hacer luego del parseo (procesamiento)**: ya sea generar código, o interpretar y ejecutar diréctamente.


[![](https://sites.google.com/site/programacionhm/_/rsrc/1402154799550/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext-overview.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-overview-png?attredirects=0)

### []()Gramática .xtext y modelo semántico

A diferencia de otras herramientas, la gramática de xtext define dos cosas:

* **Sintaxis del lenguaje: **es decir la "forma" del lenguaje en cuanto a texto: simbolos permitidos, dónde y cómo deben aparecer etc.
* **Modelo semántico: **en la forma de un conjunto de Clases Java representan los elementos de nuestro lenguaje.

Lo interesante es que los segundo, es decir ĺas clases del modelo semántico, se generan solas, a partir de la gramática.



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402156296899/conceptos/dsls/domainspecificlanguage/dsl---xtext/overview-conmodelosemantico.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-overview-conmodelosemantico-png?attredirects=0)Vemos acá un ejemplo de gramática:



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402156369545/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext-saludos-gramatica.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-saludos-gramatica-png?attredirects=0)

Esta gramática genera el siguiente modelo semántico:



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402156622087/conceptos/dsls/domainspecificlanguage/dsl---xtext/saludos-modelo.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-saludos-modelo-png?attredirects=0)

Luego XText automáticamente cuando parsea un archivo en nuestro lenguaje, genera un modelo de objetos instancias de estas clases.



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402157014999/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext-generainstanciasmodelo.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-generainstanciasmodelo-png?attredirects=0)
### []()Especificación de la Gramática .xtext

Éste archivo tiene su propia sintaxis y significado (semántica). Con lo cual sería largo y molesto escribir acá una especificación. Además ya existe en la documentació de xtext.
Así que para entender mejor todo lo que se puede hacer y cómo en la gramática, pueden ir a este link:


[http://www.eclipse.org/Xtext/documentation.html#grammarLanguage](http://www.eclipse.org/Xtext/documentation.html#grammarLanguage)

### []()Procesando el Modelo Semántico


Al procesar un archivo en nuestro DSL, podemos realizar alguna tarea. Un compilador por ejemplo genera código ejecutable.
XText se va a encargar de el pasero y checkeo de referencias, tipos, etc. Sin embargo, así solo, lo único que tenemos es un editor de texto. 
Entonces tenemos a grandes rasgos 3 opciones para procesar nuestro modelo:


![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/dsl---xtext/variantes.png)




* **Generador: **donde generamos código fuente en cualquier otro lenguaje, **a nivel de texto.**

* **JvmModelInferrer: **donde generamos código Java, pero a través de una API más rica.
* **Interprete en Java: **hacemos un programa complétamente nuestro en Java, que usa XText solo para parsear al modelo semántico. Luego nuestro programa hace lo que quiera con esos objetos. Por ejemplo podría ya ejecutar lógica.




A continuación vamos a ver las variantes.

### []()Generador

XText modela la idea de un **Generador**.
El objetivo del generador es, justamente a partir del input, generar "algo" como output.


Por lo general, una cosa que podemos hacer es **generar código fuente Java.** 



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/dsl---xtext/i-generator-o.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-i-generator-o-png?attredirects=0)



Luego podemos compilar normalmente con Java, y ejecutar en la JVM.



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/dsl---xtext/generador-java.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-generador-java-png?attredirects=0)

           
Un generador **es simplemente una clase en xtend**. Algo así como un Strategy, que implementa la interfaz IGenerator.



1. class MiGenerador implements IGenerator {
1.  override void doGenerate(Resource resource, IFileSystemAccess fsa) {
1.  for(e: resource.allContents.toIterable.filter(Model)) {
1.  ...
1.  }
1.  }
1. }



XText invoca su método doGenerate con dos parámetros:

* **resource: **representa el archivo de entrada que está procesando.
* **fileSystemAccess: **es un objeto que nos dá acceso al filesystem. Por ejemplo para crear nuevos archivos.




[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/dsl---xtext/generador-java-clase.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-generador-java-clase-png?attredirects=0)

Al invocar el siguiente código sobre el **resource, **xtend parsea el texto del archivo en base a nuestra gramática, y nos retorna una representación del contenido del archivo, como instancias de nuestro modelo.
En nuestro caso estamos pidiendo las instancias de **Model **que es la regla básica de nuestra gramática.
            
            resource.allContents.toIterable.filter(Model)

Entonces podríamos repensar el diagrama así (aunque no exáctamente el orden o flujo de ejecución)



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/dsl---xtext/generador-modelo.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-generador-modelo-png?attredirects=0)


#### **[]()Ejemplo de IGenerator

Ver en la documentación de XText [http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration](http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration)


### []()JVM Inferrer

Como vimos un generator permite generar código de cualquier lenguaje (genera texto), y además, en forma bastante rápida/simple.


Sin embargo, justamente el hecho de generar solo "texto" hace que nos perdamos una abstracción. La idea de qué cosas generamos, y que pueden compilar o no, tener errores etc.
Además, cuando el lenguaje crece y tenemos que generar bastante código, o bien necesitamos empezar a reutilizar, o modelar la idea de inferencia de tipos, etc. El generador se queda muy corto.


Por eso ya hace un tiempo XText introdujo otra opción que es implementar un **JvmModelInferrer**.


Al igual que el generador, es simplemente una clase xtend, tipo Strategy. Pero objetivo, más particular, es: **a partir del modelo semántico (parseado del dsl), generar un modelo de objetos que representa el código Java a generar**.



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/dsl---xtext/inferrer.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-inferrer-png?attredirects=0)

Entonces no generamos código diréctamente en forma de texto, sino que creamos objetos, de clases que ya vienen en XText que representan todos los elementos del lenguaje Java. Una especie de API de metaprogramación pero a nivel de código.


Acá un ejemplo de **IJvmModelInferrer **sin código:



1. class DomainmodelJvmModelInferrer implements IJvmModelInferrer {
1.  override void infer(EObject model, IJvmDeclaredTypeAcceptor acceptor, boolean preIndexPhase) {
1.  ...
1.  }
1. }

        
Algunas cosas a notar:

* No trabaja a nivel de archivos. 
* El **primer parámetro** "model" que recibe, es el objeto raíz de nuestro modelo semántico. O sea, luego del parseo.
* El segundo parámetro, el "acceptor", es un objeto que nos permite registrarle nuevas clases Java que querramos generar. No en forma de archivos, sino con una API propia de xtend que modela las clases.

Al usar un inferrer estamos de alguna forma declarando un "mapeo" entre nuestros objetos del DSL y los elementos de Java. Con lo cual, XText puede hacer cosas como mantener esa relación y darnos un debugger para nuestro DSL !! :)
### []()

#### **[]()Ejemplo de JvmModelInferrer

Ver ejemplo en la documentación de XText  [http://www.eclipse.org/Xtext/documentation.html#_8](http://www.eclipse.org/Xtext/documentation.html#_8)

### []()DSL's Interpretados

Un lenguaje interpretado, no genera código (ni en forma de strings, ni con una API), sino que es un programa que ejecuto pasándole como entrada el nombre de un archivo escrito en nuestro DSL y el diréctamente toma eso como entrada y **hace algo**, es decir que se ejecuta.
Qué hace ? Bueno, depende del DSL, claro.


A ese "programa", se lo denomina "Intérprete".



[![](https://sites.google.com/site/programacionhm/_/rsrc/1403097339407/conceptos/dsls/domainspecificlanguage/dsl---xtext/interpreter.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-interpreter-png?attredirects=0)
Acá se ve que se invierte el control, en lugar de que XText nos use a nosotros (como en el caso del Generador o Inferrer), en este caso nosotros, el intérprete, somos el programa principal que se ejecuta, y usamos a XText para que parsée y nos genere los objetos del modelo semántico. Luego con esos objetos hacemos algo.


Lo importante es que trabaja diréctamente sobre los objetos instancias de nuestro modelo semántico (o AST).
Con lo cual,  vamos a tener la restricción de que el intérprete tiene que estar hecho en Java / Xtend, porque nuestras clases del modelo ya están en ese lenguaje.


En [éste link](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---interprete-standalone) se muestra el ejemplo más básico de cómo hacer un intérprete para XText.


Un segundo ejemplo, el de [La Tortuga](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---tortuga-aka-logo-interpretada), implementa un intérprete, pero dentro de eclipse, como un plugin, ya que lo que hace es graficar en una vista de eclipse (como el Logo).
Cambia un poco la forma en que el intérprete llama a XText para que haga el parseo y nos de el modelo semántico.
## []()Ejemplos en XText


* [Hola Mundo's](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos): 

 * primer ejemplo, intro a xtext, gramática, etc
 * checkeos y quick fix
 * **Generator**

* [ORM Mappings](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-dsl---orm-mappings)

 * Gramática un poquito más compleja
 * Referencias a clases Java y Fields.
 * Validaciones
 * **JvmInferrer**

* [Tortuga](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---tortuga-aka-logo-interpretada) (aka Logo)

 * Lenguajecito más complejo (expresiones, valores, procedimientos, etc)
 * Con una vista en el IDE y Menu + Botón "Run"
 * **Interpretado**

* [DSL para pedidos HTTP](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---http)

## []()Extendiendo diferentes aspectos del DSL de XText


* Checkeos: ver [Saludos](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos)
* QuickFixes: ver [Saludos](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos)
* [Formatter](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---formatter) (formateo de código)
* [**Embebiendo Código XBase** (XTend) en nuestro DSL](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---embebiendo-xbase-en-nuestro-dsl)
* [LabelProvider (textos e íconos en el IDE).](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---labelprovider---iconos-y-textos)