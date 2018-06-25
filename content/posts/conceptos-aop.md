---
title: "conceptos-aop"
date:  2018-06-20T19:27:10-03:00
---


[[_TOC_]]


## Introducción

Para evitar arrancar dando definiciones teóricas que resulten difíciles de entender, vamos ir directo a tratar de explicar AOP (Aspect-Oriented Programming) con un ejemplo.


Supongamos que estamos trabajando en la interfaz de usuario de una aplicación. Como queremos trabajar con el patrón MVC, y estamos utilizando una arquitectura stand-alone de escritorio, es decir lo que se llama *"cliente pesado" *no tenemos ninguna restricción en cuanto al vínculo entre los elementos de la UI y nuestro modelo.


Nos gustaría que el modelo se actualice ante eventos de la vista, pero también que la vista se actualice ante eventos del modelo.
Entonces, una buena solución para esto es que nuestros objetos sean **Observables, **de modo de que los controles de la vista podrán registrarse como **Observer**'s para actualizarse ante eventos.
E igualmente mantenemos el desacoplamiento entre el modelo y la vista.


### Objetos Observables

Entonces la forma de hacer esto normalmente sería:

* Hago una interface **ObservableObject: **con comportamiento para registrar/deregistrar un observer.
* Hago que mis objetos implementen ObservableObject.
* Para no tener que repetir la lógica de la implementación, podría hacer una clase **ObservableObjectImpl:**


 * que implemente el **addObserver** y **removeObserver**

 * que implemente un **firePropertyChanged() ** que notifica a los observers. Para ser invocado desde cada subclase cuando se modifica una property

Vemos un poco de código acá entonces:


Supongamos que tenemos una clase **Conversor** que permite convertir de **kilómetros** a **millas**. Ambas son properties del objeto:





public classConversor``{

    private doublemillas;`
    private doublekilometros;`

    public voidconvertir() 
 this.setKilometros(this.getMillas() * 1.60934);`
            }
 
    public doublegetMillas() 
 return this.millas;`
            }


    public voidsetMillas(doublemillas) 
 this.millas = millas;`

            }

    public doublegetKilometros() 
 return this.kilometros;`
            }


    public voidsetKilometros(doublekilometros) 
 this.kilometros = kilometros;`
            }


        }


Y la interfaz observable:






        **public** **interface** ObservableObject {

        **    public** void** addPropertyChangeListener(String propertyName, PropertyChangeListener listener);
        

**    public** void removePropertyChangeListener(String propertyName, PropertyChangeListener listener);
        

}`


Acá tenemos la interface que utilizan los observers (listeners) para escuchar por cambios en el modelo.


Ahora, qué tenemos que hacer para que nuestro Conversor sea observable ?
La haremos heredar de la implementación de referencia para reutilizar el código:





        **public** class Conversor extends ObservableObjectImpl {
 `**private** **double** millas;`
 `**private** **double** kilometros;`


 `**public** void convertir() 
 `**this**.setKilometros(**this**.getMillas() * 1.60934);`
 `}`
 
 `**public** **double** getMillas() 
 `**return** **this**.millas;`
 `}`


 `**public** void setMillas(**double** millas) 
 `**this**.setFieldValue("millas", millas);`
 `}`


 `**public** **double** getKilometros() 
 `**return** **this**.kilometros;`
 `}`


 `**public** void setKilometros(**double** kilometros) 
 `**this**.setFieldValue("kilometros", kilometros);`
 `}`


        }
No vamos a mostrar la implementación de **ObservableObjectImpl** porque no aporta demasiado, pero confiemos en que implementa un registro de observers por properties, y la lógica para notificarlos con **setFieldValue.**



Cambios a las clases
Vemos acá que tuvimos que cambiar varias cosas de nuestra clase.

* Pasó a **implementar una interface**.
* Pasó a **heredar de otra clase**.
* Tuvimos que **tocar cada setter **a fin de notificar a los observers.


Quizás no parecerá tan grave si pensamos en este ejemplo acotado ahora, cuando proyectamos estos cambios a toda una aplicación, aparecen varios problemas.



### Problemas de la implementación "manual" o tradicional

* **Múltiples jerarquías**: si quiero hacer observable clases de múltiples jerarquías, tenemos que implementar la misma lógica en todas (una forma de evitar esto sería con traits como ya vimos, pero pocos lenguajes tienen traits)

* **Clases de terceros que no puedo modificar: **qué pasa si quiero hacer observable clases de una librería de terceros ?


 * **Wrappers o Decorators: **podría pensar en decorarlos, interceptando los setters para notificar., Peeeeeero:


  * **No podemos interceptar las modificaciones internas**. Asignaciones de variables internas.

  * **Problema de la identidad: **pierdo la identidad de los objetos originales, ya que ahora estan wrappeados.

  * Tengo que crear **decorators de muchas clases**.
  * Qué pasa **si no existe una interfaz** y la **clase es final** ?
  * Qué pasa con los **métodos** **final** que no puedo sobrescribir
* **Lógica dispersa y repetitiva.**


 * luego si quiero modificar la interfaz o implementación de Observable debo tocar en múltiples puntos.
 * posible punto de error, al tener que hacer las cosas de memoria.


Entonces aparece la idea de ***aspecto***.


## Qué es un aspecto ?
Este problema de la observabilidad de objetos es apenas un ejemplo de un tipo de problemática a resolver que aparece varias veces en una arquitectura.
Entonces ciertas personas decidieron repensar el paradigma teniendo en cuenta esta problemática.

E identificaron que en un sistema a veces aparecen ciertas **incumbencias  **que atraviesan nuestro diseño. Es decir que cortan transversalmente nuestro modelo de clases. Se denomina a esto **cross-cutting concerns **del inglés.

Para nuestro ejemplo, sería como pensar que **La observabilidad de nuestras clases es una característica transversal al modelo de objetos** (modelo de base de negocio)*

*
Entonces en este nuevo "paradigma" se identifican como entidades principales (así como los objetos y las clases son entidades principales en el paradigma de objetos) y se denominan **aspectos**.
 
 La idea de la programación orientada a aspectos intenta:
 
* resolver el problema de la duplicidad de código (código disperso)
* darle entidad, modelar esa "característica" (algo parecido a como lo hacíamos al definir un mixin o un trait).



### Diferencia con Traits & Mixins
Si bien algunos de los problemas que mencionamos acá se pueden **mitigar** con traits, como por ejemplo la observabilidad, hay otros que no. Y de hecho la observabilidad con traits no resuelve el hecho de tener que modificar las asignaciones a variables.

Veamos como quedaría el Conversor con un trait imaginario en java:



        **public** class Conversor extends AbstractConversor **with **ObservableTrait {
 `**private** **double** millas;`
 `**private** **double** kilometros;`


 `**public** void convertir() 
 `**this**.setKilometros(**this**.getMillas() * 1.60934);`
 `}`
 
 `**public** **double** getMillas() 
 `**return** **this**.millas;`
 `}`


 `**public** void setMillas(**double** millas) 
 `**this**.setFieldValue("millas", millas);`
 `}`


 `**public** **double** getKilometros() 
 `**return** **this**.kilometros;`
 `}`


 `**public** void setKilometros(**double** kilometros) 
 `**this**.setFieldValue("kilometros", kilometros);`
 `}`


        }
Fíjense que ahora nuestro conversor puede heredad de otra clase de dominio. Sin embargo reutilizamos el código del trait, evitando la duplicación.
Peeeero...

*El trait o mixin solo puede agregar métodos. No puede modificar el contenido de métodos propios de la clase. *

Entonces nos fuerza a tener que modificar las asignaciones a las variables de la misma forma.


Entonces acá vemos que lo que podemos hacer con traits/mixins tiene varias limitaciones.

**Un aspecto en cambio, abarca una granularidad más fina que un trait.** Si bien **ambos sirven para componer el contenido de una clase**, mientras que **el trait solo puede agregar o sobrescribir métodos**, un **aspecto** vamos a ver, **contempla modificar hasta lineas de código en una clase**.

Así, permite implementar y modelar casos más complejos y dinámicos que los traits.

### Ejemplos
Acá van algunos ejemplos*:
*
* Si quiero monitorear el uso de mis objetos. Ej: [Code Coverage](http://en.wikipedia.org/wiki/Code_coverage)

* Si quiero aplicar políticas de seguridad a nivel de objetos. Por ejemplo que ciertos servicios solo puedan ser invocados por ciertos roles de usuario.

* La funcionalidad de logging.

* La idea de "transaccionalidad".
* Los frameworks de persistencia proxean objetos para hacer lazy el acceso a la BD. Obviamente aplicable a cualquier tipo de objeto.
Como verán estos ejemplos son imposibles de implementar con un trait/mixin.
En particular el de la lógica de logging.

Podría querer tener lineas de logging en cualquier parte de mi código.

*

*
## Y entonces qué es un aspecto concretamente ?

Ok, con la definición y los ejemplos pero se puso un poco abstracto esto, cómo sería un aspecto entonces ?

Volvemos al ejemplo de la observabilidad de nuestro Conversor entonces.
Y tratamos de mapear a los conceptos que vimos.


* ***Aspecto:* **observabilidad de mis objetos.
* ***Puntos del código que nos interesan:*** asignaciones a variables de instancia.
* ***Modificación de código:*** 


 * luego de asignar la variable, si el nuevo valor es distinto del anterior, debería notificar a mis observers. Qué observers ? ah.. si eso nos lleva al siguiente item.
 * agregar la capacidad de que el objeto tenga observers:

  * **addObserver()**

  * **removeObserver()**

  * una **lista  **de objetos Observer
  * un método útil **firePropertyChanged()**


Y acá entonces tenemos la definición de nuestro aspecto.
Escribámosla en pseudo código (o nuestro propio DSL -ya vamos a ver en otra unidad qué significa esto-)


aspecto Observabilidad 

            luego de`** asignacion(x, viejo, nuevo) **agregar` {  `
            `    if (nuevo != viejo) 
            `       this.firePropertyChanged(x, viejo, nuevo)`
            `   }`
            `}`


 `    **agregar** 
 `       **private** Set<Observer> observers = new HashSet);`

 `       **public void** addObserver(Observer o) 
 `          **this**.observers.add(o);`
 `       }`

         **public void** removeObserver(Observer o) 
 `          **this.**observers.remove(o);`
 `       }`

 `       **public void** firePropertyChanged(String propertyName, Object oldValue, Object newValue) 
 `          **for** (Observer o : **this.**observers) 
 `             o.propertyChanged(propertyName, oldValue, newValue);`
 `          }`
 `       }`

 `    }`
            

        }

 Si tuvieramos una herramienta que entendiera esta definición y pudiera hacer toda la magia para combinar este código con el código original de la clase, entonces seríamos muy felices!

Y de hecho podemos serlo, porque esto es justamente lo que hacen los **frameworks o implementaciones de aspectos**.
En particular nosotros vamos a ver uno para java que se llama [**AspectJ**](http://www.eclipse.org/aspectj/)

Pero agreguemos algunas definiciones teóricas a lo que vimos.


## Conceptos de un Aspecto

### Join-Point
Uno de los componentes que definimos de nuestro aspecto de observabilidad era **el punto que nos interesaba del código.** Es decir "las asignaciones a variables de instancia".
Este **punto de interés en el código** es lo que en la teoría de aspectos se denomia **join-point** y es uno de los componentes de un aspecto.


Representa un punto en el flujo de ejecución. Que suele ser interesante para definir en donde aplicar un cierto aspecto.

Existen diferentes "tipos" de join-points que se derivan del mismo paradigma (o bue, del metamodelo de java, en este caso):

* **Llamada** a métodos y constructores: 


 * código desde donde se llama a un método. 

 * No incluye llamados por reflection!
 * En aspectj es ***call()***

* **Ejecución** de métodos y constructores: 


 * ejecución efectiva del método, 

 * independientemente de quién lo llama (código o reflection).
 * En aspectj es ***execution()***

* **getters & setters**

* **handlers** de **excepciones**.
* **bloques de inicialización:** estáticos y dinámicos.
En nuestro pseudo código era:

    
 asignacion(x, viejo, nuevo)`

### Point-Cut
Supongamos que en nuestro ejemplo queremos aplicar el aspecto a un conjunto de clases nada más. Digamos solo a las clases del paquete **tpi.unq.objetos3.

**

aspecto Observabilidad 

            asignacion(x, viejo, nuevo) y si class en tpi.unq.objetos3``.*`

               luego`** agregar {  `
            `       if (nuevo != viejo) 
            `          this.firePropertyChanged(x, viejo, nuevo)`
            `      }`
            `   }`
            `...`
        }
Acá vemos que estamos combinando varios join-points, el de "asignación de variable" con el de "clase de package".

Los join-point entonces se pueden combinar con operadores lógicos:

* **&&**: and
* **||**: or
* **!**: negación

Cuando se combinan así para formar una condicón más complicada y se le asigna un nombre, se lo llama **point-cut**.
**

**

Entonces, un point-cut es un predicado o condición para la aplicación de un aspecto.
Contiene uno o varios joint-points combinados mediante operadores: "**&&**", "**||**" y "**!**"

Reformulamos nuestro ejemplo de lenguaje con esta idea:


aspecto Observabilidad 

            point-cut puntoAObservar = asignacion(x, viejo, nuevo) && class en tpi.unq.objetos3``.*`

            luego **de**puntoAObservar` agregar {  `
            `    if (nuevo != viejo) 
            `       this.firePropertyChanged(x, viejo, nuevo)`
            `    }`
            `}`
            `...`
        }

### Advice
Finalmente el último elemento que identificamos en nuestra definición del aspecto de observabilidad era que, cuando se cumpía la condición del punto **interesante**, que ahora podemos llamar **point-cut, **había que agregar código.

Esa acción a realizar ante un point es lo que se llama **advice**.
Que básicamente define la modificación al código que vamos a hacer en el contexto del point-cut.

En nuestro ejemplo sería:


aspecto Observabilidad 

            asignacion(x, viejo, nuevo) **&&** class en tpi.unq.objetos3``.*`

               luego`** agregar {  `
            `       if (nuevo != viejo) 
            `          this.firePropertyChanged(x, viejo, nuevo)`
            `      }`
            `   }`
            `...`
        }
Decimos dos cosas:

* Cuándo, o cómo respecto del código point-cut: "**luego**"
* Y el código a inyectar: el **if.**



Entonces, **advice **es un *comportamiento a ejecutar como parte del aspecto*, cuando matchea cierto point-cut.

En AspectJ existen diferentes "instrucciones" (o **cuándo**'s) que le podemos dar al fwk

* **before** : justo antes de proceder al joint-point (ej: justo antes de entrar al getter, o al constructor, etc)
* **after returning**: justo después del return de un método.
* **after throwing**: justo después de que lanza una exception.
* **after**: al salir de un método, sin importar si fue por exception o por flujo normal (return)
* **around**: cuando el flujo llega a ejecutar el join-point, permite que nuestra lógica pueda determinar si proceder o no.


### Weaving

Vimos entonces que por un lado podemos definir un **point-cut** y luego un **advice.** Con esas dos cosas estamos diciendo **cómo modificar el código** y **dónde/cuándo.**


Este comportamiento se "inyecta" a través del fwk de aop que estemos usando.
A esta "inyección" de comportamiento se la conoce como **"*advice weaving*"**. O simplemente **weaving.**


Más adelante vamos a ver algunas estratégias de weaving que usan ciertos frameworks para implementar esto que es básicamente la magia que hace posible AOP.

## 


## AspectJ

### Características de un aspecto en AspectJ

* Es un "**tipo**"* (recordemos sistemas de tipos de la unidad 1)*

* con

 * **lógica** a ejecutar: llamada "advice"
 * en ciertos **condiciones en el flujo de ejecución**: llamados "pointcuts"

* Puede tener 


 * **estado** **propio:** como variables de instancia (del aspecto). Que no van inyectarse en las clases a aspectear.

 * **y comportamiento** **propio**: como métodos del propio aspecto.

* Puede **extender**:

 * otros aspectos
 * clases
 * implementar interfaces


### Ejemplos


#### Primer ejemplo: Loggeo
Algunos conceptos básicos de AspectJ:

* Defino un aspecto: 

        **public** **aspect** SysoutSimpleObservableAspect


* Luego un pointcut denominado fieldWrite, que atrapa todas las modificaciones a cualquier field de cualquier objeto de cualquier clase en el package examples.simple:

 
        **pointcut** fieldWrite(Object target, Object newValue) :  // Nombre y parámetros
            **set**(* examples.simple..*)    // Todos los fields de cualquier tipo en ese package                       
            && **args**(newValue)            // Capturo el nuevo valor del field
            && **target**(target)            // Capturo el objeto al que se le está modificando el field


Es importante ver que es declarativo, es decir target y newValue no son parámetros que "llegan" sino que son indentificadores que se vinculan con el nuevo valor del field y el objeto receptor, respectivamente.


* Luego queremos definir un advice, que se parece a un método con una cabecera especial:


        void **around**(Object target, Object newValue`) : fieldWrite(target, newValue) 
            ...                 `         // código que quiera agregar
    **proceed**(target, newValue);  // se ejecuta el código original (*)
``    ...``                          // más código que se ejecuta después del field set.
 `
        }

La palabra clave **around** permite reemplazar el código original (en este caso la modificación de un field), por el código que nosotros querramos.

Para ser más estrictos, **proceed** no ejecuta el código original, porque puede haber más de un aspecto sobre el mismo **joinpoint**, entonces proceed pasa al siguiente aspecto en la *chain of responsibility*.


* También podemos ponerle variables al aspecto para guardar cualquier información que necesite para trabajar. Para eso también es importante definir el ciclo de vida del aspecto, el caso más simple es marcarlo como "singleton", lo que hace que tengamos una única instancia para toda la aplicación:


        **public** **aspect** SysoutSimpleObservableAspect **isSingleton**() {
            **public** **int** counter = 0;
            ...
        }   

Define una variable counter que será única para todas las veces que se utilice el aspecto. 

Otros scopes posibles son: **perthis** (por cada lugar desde donde se llama el código), **pertarget** (uno por cada objeto al que se accede).


* Otra variante es utilizar una annotation, en lugar de patrones por nombre:


        **pointcut** fieldWrite(...) : ... && **target**(@LoggeableAnnotation target);

Permite trabajar con fields (o lo que fuera) en clases que tengan la annotation @LoggeableAnnotation.


#### Segundo ejemplo: Mixins.
Para agregar un mixin debemos realizar dos pasos:

1. Desde el aspecto hacemos que la clase que nos interesa implemente una interfaz definida por nosotros:


            **declare** **parents** : @Observable * **implements** ObservableObjectSupport;

Esto hace que todas las clases anotadas con @Observable implementen la interfaz ObservableObjectSupport


1. En el aspecto definimos los métodos que proveen la implementación de esa interfaz, por ejemplo:


            **public** void ObservableObject.addPropertyChangeListener(String propertyName, PropertyChangeListener listener) {
                **this**.changeSupport.addPropertyChangeListener(propertyName, listener);
            }
            
            **public** void ObservableObject.removePropertyChangeListener(String propertyName, PropertyChangeListener listener) {
                **this**.changeSupport.removePropertyChangeListener(propertyName, listener);
            }
            
            **public** void ObservableObject.fieldChanged(String fieldName, Object oldValue, Object newValue) {
                **this**.changeSupport.firePropertyChange(fieldName, oldValue, newValue);
            }
También podemos agregar variables:


            **private** **transient** PropertyChangeSupport ObservableObject.changeSupport;




El resto del proceso es ya conocido, declaramos un pointcut y un Advice:


            **pointcut** fieldWrite(ObservableObjectSupport target, Object newValue) : 
                **set**(* *..*)
                && **args**(newValue) 
                && **target**(@Observable target)
                && !**withincode**(*.new(..))
                && **within**(@Observable *);

            void **around**(ObservableObjectSupport target, Object newValue) : fieldWrite(target, newValue) {
                String fieldName = **thisJoinPoint**.getSignature().getName();
                Object oldValue = Utils.getField(target, fieldName);

                **proceed**(target, newValue);

                if (oldValue != newValue) {
                    target.fieldChanged(fieldName, oldValue, newValue);
                }
            }


Se puede ver que desde el advice podemos mandarle mensajes al target que son los que agregamos mediante aspectos.

En el uso desde AspectJ, podemos utilizar la clase y mandarle también los mensajes de la interfaz que agregamos por aspectos, es decir que tiene el mismo comportamiento que una interfaz agregada de la forma tracicional (implements).


            **public** **static** void main(String[] args) {
                ObservableTestObject object = new ObservableTestObject();
                
                // Agrego un listener...
        //Este mensaje fue agregado por el aspecto!
        object.**addPropertyChangeListener**("name", new PropertyChangeListener()
            ...`
                });
                
                // El setName dispara la llamada al property listener.
        object.setName("nuevoNombre");
            }


Un detalle técnico es que tenemos dos interfaces: ObservableObject, que es la que usa el dominio y ObservableObjectSupport, que la extiende y que nos permite utilizar el objeto desde el aspecto.





***


## Estrategias de Weaving


Weaving es el proceso que utilizan los fwks de aspectos de código para implementar aspectos, es decir para manipular el código. Para **combinar** **el código del aspecto con la lógica base **(de nuestro dominio o clases a aspectear).
De ahí que el nombre en inglés significa **tejer**.


Enumeramos un par de estratégias de weaving:
* **Compilación: **modificando el compilador y utilizando uno custom. Ej: aspectj, phantom.
* **Classloader:** una vez cargadas las clases en java no se pueden modificar. Sin embargo, las clases las carga un objeto llamado ClassLoader y uno podría hacer el suyo propio, para, justo antes de cargar la clase, modificar su bytecode. Ejemplo javassist, [asm](http://asm.ow2.org/),  [Apache Commons BCEL 
](http://commons.apache.org/bcel/)
* **Interception**: decora los objetos para interceptar los llamados. Ej: Spring AOP, [Java Dynamic Proxies](http://download.oracle.com/javase/1.3/docs/guide/reflection/proxy.html).
* **Preprocesador / Generación de Código: **analizo el código como texto, antes de la compilación. Ej: [Annotation Processing Tool APT](http://download.oracle.com/javase/1.5.0/docs/guide/apt/GettingStarted.html).
* **Metaprogramación (?)**

* **Debugging Hooks**



## Metaprogramación & Reflection en Aspectos
AspectJ provee un API de reflection extendida a los conceptos de aspectos.
Permite accederlas desde los aspectos de forma de:

* poder obtener información del contexto de ejecución actual. Ej:


 * el método actual
 * la clase actual
 * la firma y los valores de los parámetros
 * etc.
* de esto surge la capacidad de hacer aspectos reutilizables o genéricos (capacidad de metaprogramación)

// TODO: ejemplo de "loggear la firma del método en el acceso a setters". Usar **thisJoinPoint**



## Cuándo usar Aspectos ?

* Cuando detectamos cierta lógica / requerimiento / funcionalidad / **responsabilidad** que no pertenece a un único punto en una única jerarquía, sino que **afecta varias clases**, en diversas jerarquías.
* Cuando además, **queremos encapsular** esa lógica, y desacoplarla de las clases. Por ejemplo para:

 * **No acoplar todas las clases** a componentes que se deben usar desde el aspecto (ej: fwk de logging, o cualquier otra clase que usemos, que si cambia, deberíamos modificar en cada punto)
 * poder **activar y desactivar** esta lógica fácilmente.

* Cuando queremos **diseñar y encontrar abstracciones, o reutilizar código entre diferentes implementaciones de esa lógica**: Por ejemplo, usando herencia de aspectos.
* Cuando queremos **reutilizar** esa lógica en diferentes proyectos o dominios.


## Aspectos en Lenguajes Dinámicos ?

#### Esta idea de aspectos, aplica igualmente a lenguajes con checkeos dinámicos ?
Y.. sí. En realidad la idea de aspectos poco tiene que ver con el momento de los checkeos. De hecho aparecen más inconvenientes o burocracia cuando implementamos aspectos en leguajes con checkeos estáticos que en uno dinámico.
Por ejemplo, si ya programador de mi sistema ya se que estoy haciendo todos mis objetos observables a partir de un aspecto, y que entonces van a entender el mensaje **addObserver** entonces simplemente envío ese mensaje en las partes de mi código que lo necesiten. En un lenguaje dinámico, no hay diferencia entre ese envío del mensaje y cualquier otro mensaje declarado en la clase misma.
En un lenguaje con checkeos estáticos, en principio, sería dificil, porque el compilador quiere tener control sobre todo lo que hacemos, entonces por más que nosotros sepamos en que en runtime a una instancia de la clase **Boton **se la va a hacer observable, mientras compilamos, el compilador no sabe eso, entonces va a fallar.

AspectJ nos oculta esto, o bueno, lo soluciona, porque se toma el atrevimiento de cambiar el compilador :)
Entonces haces las magias que ya vimos.

En fín. El punto es que aspectos es en sí una idea justamente para agregar dinamismo a nuestro sistema. Para entonces es compatible con lenguajes dinámicos tranquilamente.


#### Qué tan "especial" es en lenguajes dinámicos ? 
Los lenguajes dinámicos como smalltalk o self, suelen proveernos un gran poder de reflection, introspection e intercession, es decir que nos permiten modificar dinámicamente la estructura de una clase (u objeto), entonces, el concepto de aspectos realmente no parece tener nada de especial, porque están al alcance de la mano, a través de la metaprogramación.

En lenguajes estáticos como java, hacen falta magias como aspectj o alterar el lenguaje nativo de la VM (bytecode)

//TODO: ejemplo en ruby con aquarium http://aquarium.rubyforge.org/

```

        class `ServiceTracer`
 include`** `Aquarium``::``DSL`
 before`** `:calls_to` `=>` `:all_methods``,` `:in_types` `=>` `/``Service$``/` `do` `|``join_point``,` `object``,` `*``args``|`
 log`** `"``Entering:#{join_point.target_type.name}``#``#{join_point.method_name}``: object =#{object}``, args =#{args}``"` 
 end`**

 after`** `:calls_to` `=>` `:all_methods``,` `:in_types` `=>` `/``Service$``/` `do` `|``join_point``,` `object``,` `*``args``|`
 log`** `"``Leaving:#{join_point.target_type.name}``#``#{join_point.method_name}``: object =#{object}``, args =#{args}``"` 
         **end**

        end


```

## Vínculo con Otros Conceptos


### CSS


Los que hayan cursado la materia construcción de interfaces de usuario, o conozca programación web, y en particular CSS ([cascading style sheets](http://en.wikipedia.org/wiki/Cascading_Style_Sheets)) van a encontrar que la idea o concepto es similar.
Con CSS's definimos la parte estética de nuestras páginas html sin necesidad de repetir estas definiciones de estilos en cada página. Y dejando el html "puro", solo con tags de contenido de información en lugar de info de apariencia.
En este caso el **weaving** sería el proceso que hace el browser para combinar el css con el html y así generar la página.
[![](https://sites.google.com/site/programacionhm/_/rsrc/1316201422538/conceptos/aop/html-css-website.gif)
](conceptos-aop-css-website-gif?attredirects=0)
Al igual que en aspectj el lenguaje de CSS es **declarativo** y por lo tanto es bastante poderoso.
Los **join-point** y **point-cuts** se definen como las reglas de matcheo del css.
Ej:```

        **h1** ` `color``:` `white``;`` }`
        **.miLink** ` `color``:`` blue``;`` }`
        **#alert** ` `color``:` `red`` }

````
        **body a.miLink** ` `color``:`` blue``;`` `}
```


```

Utiliza diferentes estrategias de matcheo:
* **Por tipo de tag:** ej "h1", va a matchear con todos los tags html <h1>
* **Por attributo class**: Ej: ".miLink", ya no matchea por el tipo de tag, sino por su atributo **class="miLink" **en este caso. Esto permite desacoplar la definición del tipo de tag.
* **Por id**: Ej "#alert", matchea por el atributo **id** del tag. Ej: <a id="alert"> , o <span id=alert>
El último ejemplo sería una combinación de varias reglas que quiere decir: todos los tags de tipo anchor con class miLink, es decir,  <a class=miLink> que esten como tags hijos de un tag <body>

El **advice **en este caso serían las definiciones de valores de atributos como **color : white**.

***Nota:***

Al hablar de CSS estamos trazando una analogía conceptual. Esto **no quiere decir que usar CSS sea programar con aspectos. **Usar aspectos en la programación en objetos por ejemplo con aspect es una cosa y programar html con CSS es otra.

El punto más importante de trazar esta analogía es contar que la idea más general detrás de aspectos es algo interesante que puede aplicarse a otros dominios, o mismo a un nivel más básico a sus propios diseños.

Y la idea es de hecho lo que contamos a continuación: Separation Of Concerns.


### Separation Of Concerns
AOP o Aspectos es considerado de hecho como un caso particular de un concepto más general llamado **separation of concerns**.
Esto se refiere, como cuando en objetos distribuimos responsabilidades, para no tener god objects o código spaghetti todo mezclado. O como cuando utilizamos el patrón MVC para separar la complejidad de la vista del modelo, o mismo como vimos acá cuando separamos la estética del HTML con CSS's.

Todos son casos de separación de incumbencias. Es decir, la idea es tratar de dividir nuestro sistema e implementar las funcionalidades por separado, en forma cohesiva dentro de ellas, pero desacopladas entre ellas. Y luego que el software resulte de la composición de esas incumbencias.
Tratando de eliminar la duplicidad.

Aspectos ataca los concerns que atraviezan varias clases de diversas jerarquías.


### Subject-Oriented Programming

Otra idea de [separation of concerns](http://en.wikipedia.org/wiki/Separation_of_concerns) muy interesante, aunque con menos auge actualmente es la de **Subject-Oriented Programming **([wikipedia](http://en.wikipedia.org/wiki/Subject-oriented_programming))
En este caso, SoP, ataca la problemática que aparece cuando un mismo tipo u objeto tiene diferentes comportamientos dependientes del contexto o sujeto.
Por ejemplo: un objeto Auto puede tener diferentes comportamientos en el sistema de Rentas de la nación, que en el sistema de inventarios de una fábrica de autos, o el de un estacionamiento.
Como hacer entonces, si esos diferentes sujetos o contextos están en el mismo sistema, y quiero evitar acoplamientos entre ellos, pero necesito que una instancia de Auto sea compartida entre ellos ? es decir, que no se pierda la identidad del objeto.

SoP permite definir algo así como "vistas" o **subjetivas** de las clases, como en nuestro caso del Auto, para cada contexto.
La clase base Auto tendrá el comportamiento **intrínseco **al auto, que aplicaría en todos los contextos. Mientras que las subjetivas tendrían características **extrínsecas** aportadas por el dominio particular o módulo.

Así, logramos **separar **esta incumbencia. 

 
## Tecnologías para programar con Aspectos


* [AspectJ](../te-aspectj)

* [Phantom](http://pleiad.cl/research/software/phantom)