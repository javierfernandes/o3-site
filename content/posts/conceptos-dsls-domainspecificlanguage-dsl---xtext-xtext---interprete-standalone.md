---
title: "conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---interprete-standalone"
date:  2018-06-20T19:27:10-03:00
---


## []()Introducción

Un intérprete StandaAlone, es básicamente una aplicación java/xtend común, es decir un main(), que al ejecutarse hace dos cosas a grandes rasgos:

* **Parsear el texto al Modelo Semántico: **inicializa XText, y le pide que a partir del nombre del archivo que va a procesar (en nuestro DSL), XText haga todo el laburo de parsearlo, validarlo, etc, y pasarnos diréctamente los objetos de nuestro modelo semántico.
* **Hacer algo con el modelo semántico:** una vez con los objetos en la mano, hace algo con eso. Por ejemplo ejecutar una lógica de negocio e imprimir en otro archivo, o en consola, o conectarse a una BD, o a un sistema externo etc.

Éste último paso es "el runtime" es decir, es la lógica que hay que ejecutar.
Dependiendo del DSL y de nuestros requerimientos va a hacer diferentes cosas.


## []()Inicialización de XText y Parseo

La primer parte es la que en general es siempre igual en todos los intérpretes.








**`class`**` SaludosInterpreter {`
 
 **`def static void`**` main(String[] args) {`
 **`if`**` (args.isEmpty) {`
 **`throw new`**` RuntimeException("Debe invocar este interprete con la ruta completa a un archivo .salu2 como argumento!")`
 `}`
** ****`val`**` fileName = args.get(0)`
** ****`val`**` model = parsear(fileName)`
** ****`new`**` SaludosInterpreter().interpret(model)`
 `}`



 **`def static `**`parsear(String fileName) {`
          **`val`**` injector = new SaludosDSLStandaloneSetup().createInjectorAndDoEMFRegistration()`
 **`val`**` resourceSet = injector.getInstance(XtextResourceSet)`
 **`val`**` resource = resourceSet.createResource(URI.createURI(fileName))`
 
               resource.load(#{})


            `   ``validate(injector, resource)`


 **`return`**` resource.contents.get(0) `**`as`**` Model`
 `}`



            **def**** `static`**` validate(Injector injector, Resource resource) {` 
 `**val**`` validator = injector.getInstance(IResourceValidator)` 
 `**val**`` issues = validator.validate(resource, CheckMode.``ALL``, ``null``)` 
 `**if**`` (!issues.isEmpty) {` 
 `issues.forEach[println(``it``.toString)]` 
 `System.exit(-``1``)` 
 `}` 
           }
                

** ****`def`**` interpret(Model model) {`
**`      // ACA VA EL CODIGO DEL INTERPRETE`**

           }
        }


Lo que se hace ahí es:

* Se inicializa XText a través de la clase <MiDSL>StandaloneSetup
* Se le pide el componente de tipo **XtextResourceSet**, que sería algo así como un objeto que nos permite trabajar con archivos.
* Al resourceSet se le pide el objeto **Resource** que representa al archivo que queremos parsear.
* Luego **cargamos el resource** (acá se produce toda la magia de Xtext, el parseo, linkeo, etc.)
* Luego **ejecutamos las reglas de validación o checkeos**. Si falla alguna la mostramos y termina el programa.
* Finalmente le **pedimos el contenido**, que en realidad es una lista de objetos, pero nosotros sabemos que siempre en los DSL's de Xtext viene un sólo objeto cuyo tipo es la regla principal de nuestra gramática.

## []()Ejemplo de Saludos

El segmento de código que vimos recién pertence al ejemplo de los [Saludos](conceptos-dsls-domainspecificlanguage-dsl---xtext-dsl-en-xtext---saludos)
Acá la implementación del método que faltaba, el interpret().





 `**def** interpret(Model model) {`
 `model.saludos.forEach[s| s.imprimir]`
 `}`
 
 `**def dispatch** imprimir(Bienvenida saludo) {`
 `println('''Hola «saludo.AQuien.name» !!!''')`
 `}`
 
 `**def dispatch** imprimir(Despedida saludo) {`
 `println('''Chau «saludo.AQuien.name» !!!''')`
 `}`


## []()Ejecución del Intérprete

Ejecutar el intéprete que vimos no tiene nada del otro mundo, ya que es una main() normal de java.
La única particularidad (si se quiere) es que recibe como parámetro el nombre del archivo que queremos que interprete.
Entonces para ejecutarlo desde el eclipse tenemos que 

* crear una nueva "Run Configuration" (Run -> Run Configurations...)
* En "Java Application" botón derecho , New
* Seleccionar el proyecto, seleccionar el intérprete como clase "main".
* Luego en la segunda solapa "Arguments" introducir los argumentos que queremos que le lleguen al main como parámetro


[![](https://sites.google.com/site/programacionhm/_/rsrc/1403096818432/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---interprete-standalone/saludos-args.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---interprete-standalone-saludos-args-png?attredirects=0)

Luego acá vemos el un ejemplo de archivo de entrada:

[![](https://sites.google.com/site/programacionhm/_/rsrc/1403096890892/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---interprete-standalone/ejemplo-dsl.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---interprete-standalone-ejemplo-dsl-png?attredirects=0)

Y la correspondiente salida del intérprete en consola:

[![](https://sites.google.com/site/programacionhm/_/rsrc/1403096960763/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext---interprete-standalone/ejemplo-salida.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---interprete-standalone-ejemplo-salida-png?attredirects=0)

## []()Ejemplo de Mappings

Acá vemos otro intérprete también muy pavo para el ejemplo de [Mappings](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-dsl---orm-mappings)





        **class** MappingInterpreter {
 
 `**def static void** main(String[] args) {`
 `**val** fileName = "/opt/dev/data/workspace/runtime-EclipseXtext/dsl-mapping-examples/src/main/java/mapeos.mapping"`
 `**val** injector = new MappingDslStandaloneSetup().createInjectorAndDoEMFRegistration()`
 `**val** resourceSet = injector.getInstance(XtextResourceSet)`
 `**val** resource = resourceSet.createResource(URI.createURI(fileName))`
 `resource.load(#{})`
 `**val** module = resource.contents.get(0) as MappingModule`


 `interpret(module)`
 `}`
 
 `**def static** interpret(MappingModule module) {`
         `println('''El archivo tiene «module.mappings.size» mappings''')`
 `}`


        }


Imprime la cantidad de mapeos que declaró el usuario en ese archivo dado (que está hardcodeado, pero podría recibirlo por parámetro al main()).