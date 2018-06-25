---
title: "conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos"
date:  2018-06-20T19:27:10-03:00
---


Nota: actualizado a xtext 2.6
## Introducción

Este es el primer ejemplo bien sencillo que podemos hacer con XText. Una especie de "Hola Mundo".
En realidad vamos a hacer un lenguaje (DSL) que servirá para escribir "Saludos hola mundo".
### Creando un Nuevo Proyecto

Veamos como usar xtext para crear un minilenguaje de ejemplo (de hecho el que ya se crea por default):

* Creamos un nuevo proyecto de tipo xtext.
* Nos va a pedir que ingresemos varias cosas como el nombre y la extensión de archivos que queremos para nuestro lenguaje.
* Vemos que nos genera varios proyectos



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838829/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/xtext-saludos-proyectos.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-xtext-saludos-proyectos-png?attredirects=0)

* Todos son plug-ins de eclipse. Acá ya vemos que XText está bastante integrado a la arquitectura de eclipse.
* El proyecto más importante es **org.uqbar.paco.dsl.xtext.saludos**


 * Es decir, el que no tiene ningún prefijo (sdk, tests, ui).
 * **tests**: contiene los tests para nuestro DSL
 * **ui: **es el plugin que tiene al editor de texto, y otras vistas de eclipse. En general no vamos a tocar esto nosotros.

Acá podemos ver un poco la estructura del proyecto principal:



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838828/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/xtext-saludos-estructura-proyecto.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-xtext-saludos-estructura-proyecto-png?attredirects=0)
Los archivos más importantes son
* **SaludosDSL.xtext:** 

 * definición del lenguaje (**gramática** y modelo semántico).
 * Este es el archivo principal de nuestro lenguaje.
 * Acá vamos a meter mano para definir la sintaxis (gramática), pero además, indiréctamente los conceptos principales de nuestro lenguaje, que se van a traducir en un modelo de objetos (modelo semántico)
* **GenerateSaludosDSL.mwe2:** 

 * Workflow ejecutable para generación del modelo semántico.
 * Es un archivo de configuración de XText para nuestro lenguaje.
 * Para hacer cosas simples no hace falta modificarlo.
 * Si necesitamos agregar dependencias de nuestro lenguaje a otro, o bien customizar algunas cositas de xtext para nuestro lenguaje, debemos editarlo.
 * Es un archivo de texto "ejecutable".
 * **CADA VEZ QUE MODIFICAMOS EL ARCHIVO ".xtext" DEBEMOS VOLVER A EJECUTAR ESTE WORKFLOW !**

 * Cuando se ejecuta, lee nuestro .xtext y genera código en la carpeta src-gen



### Gramática en XText y modelo semántico


Analizamos un poco el archivo que contiene la gramática (el .xtext)



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838828/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/xtext-saludos-gramatica.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-xtext-saludos-gramatica-png?attredirects=0)

Vemos que:

* La **primera linea define un nombre**  (largo) para nuestra gramática.
* El "with" permite extender o "usar" elementos de un lenguaje ya definido. Como extender otro lenguaje. En nuestro caso Terminals nos dá ya elementos como "ID", o "STRING", tipos básicos que vamos a usar.
* La **segunda linea** indica a xtext que, en base a este archivo, deberá generar un modelo de objetos para los conceptos de nuestro lenguaje. E indica además un nombre (largo) para ese modelo de objetos (Como si fuera el package donde va a estar, o una URL).
* **Luego** viene **lo más interesante y es la definición de la gramática de nuestro archivo** (DSL).

#### Reglas de gramática

El cuerpo del archivo .xtext es un conjunto de **reglas **que definen la sintaxis de nuestro lenguaje.
Como si fuera una especie de "regular expresion" pero no ta complicada (mmmm ...)


Por ejemplo, si queremos que nuestro lenguaje permita escribir un solo saludo con esta forma:



        Hello World!


Tendríamos una sola reglas, y sería:



        Saludo:  'Hello World!';
La sintaxis es

        NombreDeRegla: 
            `    <CUERPO>`
        ;   

Entonces, cuando yo quiera escribir en mi DSL algo, Xtext va a buscar que lo que escribo cumpla con la regla definida.
En este caso solo me va a dejar escribir "Hello World!", y una única vez.
#### Variables

Ahora, este es un ejemplo bastante tonto. Entonces, vamos de a poco. Hagamos que el usuario pueda parametrizar el saludo, en lugar de que siempre escriba "World", que pueda poner su propio text.
Necesitamos decir algo así (en pseudo código)



        Un saludo es  `'Hello' UN_STRING '!"`


Donde definimos que ese algo que ingrese el usuario deberá ser de tipo String.
Esto se hace así en Xtext




        Saludo:
            'Hello' aQuien=STRING '!'
        ;

Parecido a lo que escribimos antes.
La diferencia es que, como seguramente después vamos a querer usar lo que escribió el usuario, para hacer algo con eso, le declaramos un nombre. Como si fuera un nombre de variable. En nuestro caso le pusimos "aQuien". Y de la derecha definimos el tipo que va tener.


Entonces, la sintaxis para definir una variable es



        nombreVariable=tipo

Esto sólo se puede hacer dentro de una regla !
Ahora nuestro DSL se puede usar así



        **Hello** "Juan" !

Acá se ve que los strings que ponemos sueltos dentro de una regla, solito los marca Xtext como keywords en negrita y bordó.

#### Variables para muchos valores (listas)

Supongamos que se puedan definir muchos "aQuien". Es decir así:



        **Hello** "Juan" "Maria" "Dios" !


Como puede ser variable la cantidad de "aQuien" que el usuario escribe, necesitamos guardarlos en una variable de tipo Lista.
Además, tenemos que indicar en la sintaxis que lo que va ir entre el 'Hello' y el '!' puede aparecer no una, sino muchas veces.
Esto se hace así entonces





        Saludo:
 `'Hello' (aQuien+=STRING)* '!';`


Hay dos cosas a notar:

1. No tenemos una asignación normal con un símbolo igual (=), sino un operador +=. Esto quiere decir que el STRING que aparezca, deberá "agregarse" a la lista apuntada por la variable "aQuien". No pisa, sino que agrega !
1. La parte del medio está envuelta entre paréntesis, y luego tiene un asterisco. Esto quiere decir que todo eso envuelto, puede aparecer en el archivo N veces. Es un modificador de cardinalidad. Hay algunos otros que ya vamos a ver.

Entonces eso se lee así:
           Solo puede aparecer un elemento de tipo STRING. Si aparece se agrega a la lista de "aQuien". A su vez, puede aparecer no uno, sino muchos de estos.
#### Referencia entre reglas

Nos falta una solo cosa para llegar al ejemplo original generado por xtext.
Recién hicimos que se pueda especificar una lista de STRINGs dentro de una regla.
Supongamos que queremos un lenguaje distinto a ese. Queremos poder escribir en un único archivo muchos Saludos, de la forma original. Ej:




        **Hello** Juan !
        **Hello** Alberto !
        **Hello** Maria !


Volvemos entonces a definir la regla **Saludo **como la teníamos antes (con una sola variable).
Y ahora definimos una nueva regla que será la principal para el archivo.
Decimos algo así como:
            `nuestro archivo es N veces la regla Saludos`
Y eso se hace así:





        Model:
 `(saludos+=Saludo)*;`
 
        Saludo:
 `'Hello' (aQuien+=STRING)* '!';`


La regla principal es la primera.
Fíjense que no tiene Strings sueltos. Símplemente dice "aquí pueden haber N instancias de la regla Saludo", que es la regla definida a continuación.
Y lo dice de la misma forma que vimos antes, con una variable de tipo lista. Y usa el nombre de la regla Saludo como el tipo de los elementos.


Para más información sobre el formato de la gramática ver la documentación de XText


[http://www.eclipse.org/Xtext/documentation.html#grammarLanguage](http://www.eclipse.org/Xtext/documentation.html#grammarLanguage)
### Generando el modelo semántico y ejecutando

Ejecutamos el workflow. Para esto tenemos dos opciones, que son equivalentes:
- hacer click derecho sobre el archivo .xtext (la gramática) y "Run as" as "Generate Xtext Artifacts"
- hacer click derecho sobre el archivo .mwe2 y "Run as" "MWE2 Workflow" , 


Vemos que esta acción genera bastante código:

* **en "src":**  genera código una única vez.
* **en "src-gen"**: Estará el código que regenerará cada vez que ejecutemos el workflow.

Acá están los archivos de src

[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838828/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/xtext-saludos-generado-src.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-xtext-saludos-generado-src-png?attredirects=0)Todas esas clases (en código xtend) son especies de Strategies que resuelven una problemática específica del lenguaje. Por ejemplo

* **SaludosDSLFormatter **es una clase que se encarga de formatear el código (cuando apretamos CTRL+SHIFT+F).
* **ScopeProvider: **permite especificar los scopes de los elementos de nuestro lenguaje. Por ejemplo, en java, desde un método puedo referenciar a sus parámetros, variables de instacia de la clase y variables locales. Podríamos definir nuestros propios scopes para nuestro lenguaje.
* **Validator: **permite especificar reglas de validacion que generen warnings o errors.
* etc.

Todas estas clases generadas son en realidad "esqueletos". No tienen nada. Pero están ahí para que agreguemos el código que querramos.


Por otro lado en "src-gen":

[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838828/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/xtext-saludos-generado-src-gen.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-xtext-saludos-generado-src-gen-png?attredirects=0)Acá hay mucho más código. Pero la idea es que no tenemos que tocarlo.
Se genera cada vez.
Lo más importante es lo que está expandido. Vemos ahí dos clases:
* Model
* Saludo

Fíjense que son los nombres de nuestras dos reglas !



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402162951507/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/saludos-modelo.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-saludos-modelo-png?attredirects=0)



Esto es porque xtext genera, a partir de la gramática, objetos para cada una de nuestras reglas.


### Ejecutamos el plugin

Para probar nuestro lenguaje vamos a usar un IDE, que, obviamente va a ser eclipse. Pero necesitamos levantar un eclipse nuevo, que tenga nuestros plugins. Porque uno de ellos es el que tiene el editor de texto.


Hay dos formas de levantar el entorno de prueba. 


Una es ir al proyecto, botón derecho y "Run As" como "Eclipse Application". Alguna vez nos apareció un popup con opciones, creemos que cualquiera que se elija está bien. 


La otra opción consiste en abrir el archivo "plugin.xml" de nuestro proyecto principal (en realidad de cualquiera de los tres)



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402163159672/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/saludos-run-pluginfile.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-saludos-run-pluginfile-png?attredirects=0)

Se abrirá un editor con varios tabs. En el primer tab a la derecha tenemos opciones para ejecutar o debuggear.



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402163302782/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/saludos-run-launch.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-saludos-run-launch-png?attredirects=0)


Al ejecutar esta acción, de cualquiera de las dos formas que describimos, se abre un segundo eclipse (sí va a estar un poco pesado :S)


Luego podemos crear un proyecto normal java, y dentro un archivo con nuestra extensión (File -> New -> File)


[![](https://sites.google.com/site/programacionhm/_/rsrc/1402163584249/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/saludos-ejemplo-editor.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-saludos-ejemplo-editor-png?attredirects=0)

### El Generador 
Implementamos el generador entonces en xtend. Para eso primero tenemos una primer parte de código que se encarga de, dado el archivo que estamos procesando, obtener su nombre, sacando la extensión, etc.
Y así "inferir" el nombre de la clase java a generar.
Luego usamos los "RichStrings" o "templates" de xtend para no escribir tantos strings sueltos.



class SaludosDSLGenerator **implements** IGenerator {
         
            **override void** doGenerate(Resource resource, IFileSystemAccess fsa) {
         val model = resource.allContents.head as Model
         **val fileName = resource.URI.lastSegment`
         **val className = fileName.until(".").firstUpper`
         
         fsa.generateFile(className + ".java", model.generateJavaClass(className))
            }
         
             def generateJavaClass(Model m, String className) '''
         public class «className» {
         public static void main(String[] args) {
         «**FOR** saludo : m.saludos »
         System.out.println("Hola «saludo.AQuien» !!!");
         «**ENDFOR**»
         }
         }
            '''
            ....
        }



## Checkeos & Validaciones
Otro punto de extensión de xtext es escribir validaciones semánticas en la clase Validator que nos genera.
Acá una validación sobre las Despedida's





        class SaludosDSLValidator extends **AbstractSaludosDSLValidator {


          @Check
          **def **soloSeDespideAQuienSeDioLaBienvenida(Despedida despedida) {
          **if** (despedida.bienvenida == **null**) {
          error("Para despedir, primero debe dar la bienvenida", despedida, SaludosDSLPackage.Literals.SALUDO__AQUIEN)
          }
          **if **(despedida.bienvenida.estaDespuesDe(despedida)) {
 `error("La despedida va DESPUES de la bienvenida!", despedida, SaludosDSLPackage.Literals.SALUDO__AQUIEN)`
          }
          }
        }


Esto código usa a su vez extension methods que le agregamos al modelo semántico:





         def bienvenida(Despedida despedida) {
 `despedida.model.saludos.filter(Bienvenida).findFirst[AQuien == despedida.AQuien]`
        }


         def model(Saludo saludo) {
 `saludo.eContainer as Model`
        }
 
         def estaDespuesDe(Saludo a, Saludo b) {
 `a.posicion > b.posicion`
        }
 
         def posicion(Saludo s) {
 `s.model.saludos.indexOf(s)`
        }



## Quick Fixes

Ahora vamos a ver cómo extender un poquito la parte del IDE que nos genera (el editor).
En particular, ya que detectamos un error con los checkeos anteriores, está bueno que le demos un "quick fix" al usuario, que los arregle solito.


Entonces para vamos a agregar un QuickFix para el caso en que el usuario escribió una despedida a una persona, pero le falta escribir la bienvenida.
El quickfix será "agregar la bienvenida".


Para eso tenemos ya un template en el proyecto ".ui".
La clase **SaludosDSLQuickfixProvider.**

**

**

Pero antes que nada necesitamos cambiar el código del checkeo, para que cuando notifica un error, le asigne un ID.



        error("Para despedir, primero debe dar la bienvenida", despedida, SaludosDSLPackage.Literals.SALUDO__AQUIEN, **DESPEDIDA_SIN_BIENVENIDA**)

El último parámetro es un String, que definimos nosotros.
En este caso hicimos una constante en la misma clase.





        class SaludosDSLValidator extends AbstractSaludosDSLValidator {
** `public static final String DESPEDIDA_SIN_BIENVENIDA = "DESPEDIDA_SIN_BIENVENIDA"`**



Luego, en la clase **SaludosDSLQuickFixProvider **cada método es una quickfix, anotado con la annotation **@Fix**

**

**

**

**



        class SaludosDSLQuickfixProvider extends DefaultQuickfixProvider {



 `**@Fix(SaludosDSLValidator.DESPEDIDA_SIN_BIENVENIDA)
 `def capitalizeName(Issue issue, IssueResolutionAcceptor acceptor) 
 `acceptor.accept(issue, 'Crear Bienvenida', 'Agregar Bienvenida.', null, new ISemanticModification() 
 `override apply(EObject element, IModificationContext context) throws Exception 
 `val despedida = element as Despedida`
 `val aQuien = despedida.AQuien.name`
 `context.xtextDocument.replace(element.before, element.node.length, "Hola " + aQuien + " ! " + element.node.text)`
 `}`
 `})`
 `}`
**

**

Fíjense que el parámetro a la annotation @Fix debe ser el ID del error que sabe "arreglar". Entonces ahí usamos la constante antes definida.


Es un poquito más dificil de entender el código porque trabaja más a nivel de "texto".
Sí tenemos el objeto del modelo semántico (en nuestro caso la Despedida).


Este método está usando unos extensions methods que definimos más abajo en la misma clase, para ayudarnos a, dado un elemento semántico obtener la posición en el texto de donde se parseó, etc.





        **def static** before(EObject element) {
 `element.node.offset`
        }


         def **static** after(EObject element) {
 `element.node.endOffset`
        }
 
         def **static **node(EObject element) {
 `NodeModelUtils.findActualNodeFor(element)`
        }


Esto ahora se ve así:



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402435902316/conceptos/dsls/domainspecificlanguage/dsl---xtext/dsl-en-xtext---saludos/saludos-quickfix.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos-saludos-quickfix-png?attredirects=0)