---
title: "unsam-bitacoras-2011-clase5-12deabrilde2011-aspectos"
date:  2018-06-20T19:27:10-03:00
---


#### Introducción
Como parte de la unidad vamos a seguir viendo diferentes estratégias para romper con "la dictadura de la clase". Es decir, para definir comportamiento del sistema fuera de las formas tradicionales: la clase y su jerarquía (superclases).

La clase pasada vimos mixins y traits, como variantes a los modelos de jerarquía múltiple, simple y composición.
Vimos que la intención de los traits era la de reutilizar un cierto código, que de otra manera estaría disperso, cuando este aplica a varias jerarquías diferentes.

Todos estos modelos se refieren a la capacidad de construir la clase en base a componer métodos. Pero esta construcción es intencional, necesaria e interna, con lo cual cada clase que quiera reutilizar la lógica **debe ser modificada** desde ella misma. Por ejemplo, por cada subclase de Animal que querramos que tenga el trait TCuadrupedo, debemos modificar su declaración para incluirlo.

Lo anterior se explica, por el hecho de que en realidad la mayoría de los traits van a modelar comportamiento de negocio, que van a estar muy vinculados con la lógica de las clases y vice-versa. Salvo algunos casos, por más que sea funcionalidad "adicional", va a ser simplemente funcionalidad, que cada clase utilizará concientemente. Por esto, el trait mismo establece exigencias o un contrato por parte de la clase. Entonces, hay una colaboración entre ellas.
Esto demuestra que estos mecanismos si bien permiten aplicar a varias jerarquías, tienen un campo de acción limitado al diseño de nuestras clases y a su estructura (mensajes).

De esto surgen dos características:

* **acoplamiento:** las clases estan acopladas al trait (lo declaran y usan)
* **estatismo:** sería como el acoplamiento a la inversa, el trait requiere ciertas cosas de la clase. Entonces está acoplado al diseño, y a la estructura de las clases. Además estos traits no permiten meterse en el flujo dinámico de ejecución de la clase, salvo que ellas se lo deleguen (con mucha burocracia, algo así como template methods).


Entonces, este mecanismo, si bien útil, parece tener ciertas limitaciones:

* ¿Qué pasa si la funcionalidad a agregar no es simplemente agregar comportamiento o métodos, sino, requiere meterse en el medio de la ejecución de la lógica ya definida por las clases ? Ej: observer, fíjense que si bien se puede implementar con traits, este no es el que lanza los eventos, sino que cada clase debe encargarse de hacerlo.
* ¿Qué pasa si no quiero que mis clases si quiera sepan de la funcionalidad a agregar ?
* ¿Qué pasa si quiero afectar múltiples clases, de hecho quizás, sin saber cuales son esas clases o jerarquías ? Y que sea extensible a futuro (o sea, cuando alguien agregue otra clase o jerarquía ?
* ¿Qué pasa si quiero poder activar / desactivar la funcionalidad ?
Acá entra la idea de "aspecto".

#### Cross-cutting concerns
Todos los paradigmas utilizan la idea de abstracción y encapsulamiento, aunque en diferentes maneras. Y todos ellos intentan entonces modelar de forma cohesiva y encapsulada ciertos bloques de construcción. Es la vieja estratégica de "divide y conquistarás". 
Algunos ejemplos: procedimientos, funciones, módulos, clases, métodos, y hasta traits :)

¿Qué pasa cuando una funcionalidad de mi sistema atraviesa todas esas estructuras del lenguaje ?
Por ejemplo, en objetos, ¿qué pasa cuando se necesita agregar *la misma lógica a muchos métodos*?

A esa lógica o funcionalidad que atraviesa las estructuras del lenguaj se la llama **cross-cutting concern**.
(Fíjense que esta es una de las limitaciones que mencionamos a los traits.)

Un **aspecto**, es una herramienta para *modelar* y resolver estos cross-cutting concerns. Lo que se intenta es conseguir una unidad cohesiva, y encapsulada.

Consta, básicamente de 2 cosas:

1. La lógica a ejecutar, llamada **advice**

1. Dónde ejecutarla, en qué puntos del código y de la ejecución del sistema. A los puntos a los que les agrego comportamiento mediante aspectos se los denomina **joinpoints**. 
Por otro lado, un **pointcut** es una query que refiere a un conjunto determinado de joinpoints, a los que se le aplicará un advice.


En resumen, las ventajas de programar con aspectos (AOP) son:

* **Menos intrusivo** (pointcut + weaving), por lo menos que los de Pharo... se agregan transparentemente. Un Advice es como un glue method.

 * Los glue methods en Pharo están en la clase, en AspectJ están fuera de la clase.

* **Puede hacer más que agregar métodos**, nos dan más variantes, por ejemplo:

 * Puedo interceptar la asignación de una variable o la invocación de un método o constructor.

 * Trabajar con la estructura sintáctica del método o el flujo de ejecución.

Generalmente estas cuestiones cross-cutting se utilizan para cosas tecnológicas ("frameworkosas"):

* Objetos observables como los que le gustaban al Arena.
* Políticas de seguridad.
* Loggear todas las veces que pasa x cosa (para debug).
* Objetos transaccionales.
* Lazyness.

Para llevar estas ideas a la práctica vamos a usar un lenguaje que extiende al Java, denominado AspectJ.

#### Primer ejemplo: Loggeo
Algunos conceptos básicos de AspectJ:

* Defino un aspecto: 

        public aspect SysoutSimpleObservableAspect


* Luego un pointcut denominado fieldWrite, que atrapa todas las modificaciones a cualquier field de cualquier objeto de cualquier clase en el package examples.simple:

 
        pointcut fieldWrite(Object target, Object newValue) :  // Nombre y parámetros
            set(* examples.simple..*)    // Todos los fields de cualquier tipo en ese package                       
            && args(newValue)            // Capturo el nuevo valor del field
            && target(target)            // Capturo el objeto al que se le está modificando el field


Es importante ver que es declarativo, es decir target y newValue no son parámetros que "llegan" sino que son indentificadores que se vinculan con el nuevo valor del field y el objeto receptor, respectivamente.


* Luego queremos definir un advice, que se parece a un método con una cabecera especial:


        void around(Object target, Object newValue`) : fieldWrite(target, newValue) 
            ...                 `         // código que quiera agregar
    proceed(target, newValue    // se ejecuta el código original (*)
``    ...``                          // más código que se ejecuta después del field set.
 `
        }

La palabra clave around permite reemplazar el código original (en este caso la modificación de un field), por el código que nosotros querramos.

Para ser más estrictos, proceed no ejecuta el código original, porque puede haber más de un aspecto sobre el mismo joinpoint, entonces proceed pasa al siguiente aspecto en la *chain of responsibility*.


* También podemos ponerle variables al aspecto para guardar cualquier información que necesite para trabajar. Para eso también es importante definir el ciclo de vida del aspecto, el caso más simple es marcarlo como "singleton", lo que hace que tengamos una única instancia para toda la aplicación:


        public aspect SysoutSimpleObservableAspect isSingleton() {
            public int counter = 0;
            ...
        }   

Define una variable counter que será única para todas las veces que se utilice el aspecto. 

Otros scopes posibles son: perthis (por cada lugar desde donde se llama el código), pertarget (uno por cada objeto al que se accede).


* Otra variante es utilizar una annotation, en lugar de patrones por nombre:


        pointcut fieldWrite(...) : ... && target(@LoggeableAnnotation target);

Permite trabajar con fields (o lo que fuera) en clases que tengan la annotation @LoggeableAnnotation.


#### Segundo ejemplo: Mixins.
Para agregar un mixin debemos realizar dos pasos:

1. Desde el aspecto hacemos que la clase que nos interesa implemente una interfaz definida por nosotros:


            declare parents : @Observable * implements ObservableObjectSupport;

Esto hace que todas las clases anotadas con @Observable implementen la interfaz ObservableObjectSupport


1. En el aspecto definimos los métodos que proveen la implementación de esa interfaz, por ejemplo:


            public void ObservableObject.addPropertyChangeListener(String propertyName, PropertyChangeListener listener) {
                this.changeSupport.addPropertyChangeListener(propertyName, listener);
            }
            
            public void ObservableObject.removePropertyChangeListener(String propertyName, PropertyChangeListener listener) {
                this.changeSupport.removePropertyChangeListener(propertyName, listener);
            }
            
            public void ObservableObject.fieldChanged(String fieldName, Object oldValue, Object newValue) {
                this.changeSupport.firePropertyChange(fieldName, oldValue, newValue);
            }
También podemos agregar variables:


            private transient PropertyChangeSupport ObservableObject.changeSupport;




El resto del proceso es ya conocido, declaramos un pointcut y un Advice:


            pointcut fieldWrite(ObservableObjectSupport target, Object newValue) : 
                set(* *..*)
                && args(newValue) 
                && target(@Observable target)
                && !withincode(*.new(..))
                && within(@Observable *);

            void around(ObservableObjectSupport target, Object newValue) : fieldWrite(target, newValue) {
                String fieldName = thisJoinPoint.getSignature().getName();
                Object oldValue = Utils.getField(target, fieldName);

                proceed(target, newValue);

                if (oldValue != newValue) {
                    target.fieldChanged(fieldName, oldValue, newValue);
                }
            }


Se puede ver que desde el advice podemos mandarle mensajes al target que son los que agregamos mediante aspectos.

En el uso desde AspectJ, podemos utilizar la clase y mandarle también los mensajes de la interfaz que agregamos por aspectos, es decir que tiene el mismo comportamiento que una interfaz agregada de la forma tracicional (implements).


            public static void main(String[] args) {
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