---
title: "unsam-clases-clase5-12092011-aspect-orientedprogrammingaop"
date:  2018-06-20T19:27:10-03:00
---


## []()Aspectos Administrativos

Al principio de la clase vimos algunos aspectos (valga la redundancia) administrativos, respecto de los TP's.
Dijimos que la próxima clase ibamos a hacer la primer entrega y revisión del TP1.


Vimos que el segundo TP va a ser incluso más libre permitiendo elegir entre: Aspectos, Prototipos y Metaprogramación.


## []()AOP

Luego de lo administrativo arrancamos con el tema de la clase: aspectos.


Contamos que el concepto de aspectos es de modelar una lógica que atraviesa varias clases, métodos y/o jerarquías, llamada "cross-cutting concerns".
Implementar esta lógica "a mano" involucraría modificar y repetir código en cada uno de esos lugares.


Entonces un aspecto nos permite resolver problemas como: quiero que todos mis objetos sean observables; dado mis test-cases quiero poder analizar qué partes de mi código está siendo testeado (ejecutado) y qué partes no.


Esto último existe de hecho en varios lenguajes de programación y se llama **Code Coverage** (ej de herramientas [http://cobertura.sourceforge.net/](http://cobertura.sourceforge.net/))


### []()Conceptos de AOP: Join-Point, Point-cut y Advice

Vimos luego los conceptos **core **del dominio de la **programación orientada a aspectos.**

Si bien vamos a ver aspectos con una implementación para java llamada **AspectJ** estos conceptos son abstractos y forman parte de AOP. Con lo cual serán comunes a todos los frameworks de aspectos.
Dependiendo del framework se podrán definir de diferentes formas.



* **Join-point: **representa un punto en la ejecución del código de mi programa que resulta interesante. Es decir, en el cual me interesaría saber que está ejecutándose. Por ejemplo: la asignación de una variable de instancia, o el llamado a un método.
* **Point-Cut:** es un conjunto de **join-point**s a fin de poder definir un contexto más complejo. Es decir que se combinan, varios point-cuts, ejemplos: asignaciones de variables llamadas "blah" en mis clases del paquete *objetos3.ejemplos *y para las clases anotadas con @MeInteresa.
* **Advice**: dado un **pointcut, **es decir un contexto de un punto de ejecución, representa una manipulación de ese código. Por ejemplo, poder agregar código antes y después de ese punto (**around)**.

Luego vimos un ejemplo de la syntaxis de AspectJ para definir un aspecto para loggear llamadas a métodos.
Ese ejemplo está en la [página del site](conceptos-aop)


### []()Weaving

Luego surgió la pregunta natural de "cómo hace la magia ?" (de interceptar el código y manipularlo).
Acá surge otro concepto de la programación de aspectos, que es el **weaving**.


Weaving es el proceso que utilizan los fwks de aspectos de código para implementar aspectos, es decir para manipular el código. Para **combinar** **el código del aspecto con la lógica base **(de nuestro dominio o clases a aspectear).
De ahí que el nombre en inglés significa **tejer**.


Enumeramos un par de estratégias de weaving:

* **Compilación: **modificando el compilador y utilizando uno custom. Ej: aspectj, phantom.
* **Classloader:** una vez cargadas las clases en java no se pueden modificar. Sin embargo, las clases las carga un objeto llamado ClassLoader y uno podría hacer el suyo propio, para, justo antes de cargar la clase, modificar su bytecode. Ejemplo javassist, [Apache Commons BCEL](http://commons.apache.org/bcel/)
* **Interception**: decora los objetos para interceptar los llamados. Ej: Spring AOP, [Java Dynamic Proxies](http://download.oracle.com/javase/1.3/docs/guide/reflection/proxy.html).
* **Preprocesador / Generación de Código: **analizo el código como texto, antes de la compilación. Ej: [Annotation Processing Tool APT](http://download.oracle.com/javase/1.5.0/docs/guide/apt/GettingStarted.html).
* **Metaprogramación (?)**

* **Debugging Hooks**




#### **[]()Mock Objects

De pasada hablamos de **Mock Objects**. Que aparece cuando trabajamos en testcase y tenemos interfaces u objetos que queremos "mockear" es decir simular, a través de una nueva implementación dummy solo a fines de poder testear otra lógica. 
Ejemplo, cuando tengo que testear una lógica de negocio core, que eventualmente envía emails a través de un objeto de tipo **MailSender.**

Como en el testcase no voy a poder enviar mails, tengo que simular ese objeto de alguna forma.


La forma tradicional sería hacer una subclase de MailSender que no haga nada. Sería un **DummyMailSender**.


Ahora, hacer esto para muchas clases es bastante molesto, entonces aparecen los frameworks de MockObjects.
Estos frameworks permiten el mismo efecto pero sin la necesidad de crear una subclase.


Podemos mencionar dos fwks en java: [JMock](http://www.jmock.org/) y [Mockito](http://mockito.org/)


Estos proveen un API donde vamos a definir *"quiero un objeto que implemente MailSender, y que checkee que al ejecutarse el test le llamen al método ****enviarMail**** con el texto 'te mando un mail' como parámetro".*
El fwk se va a encargar de crear un proxy, es decir "simular" una subclase.
Quizás para esto utiliza un tipo de metaprogramación o proxies dinámicos como vimos que hacen algunos fwks de aspectos.


## []()Ejemplos en AspectJ

Luego nos metimos en directo a ver ejemplos en código de aspectj.


Vemos el primer ejemplo **simple **de objetos observables.


Luego vimos que el aspecto es de hecho un objeto, y que puedo obtenerlo y acceder a su estado o hasta invocarle métodos.


Después vimos que ese aspecto que es un objeto tiene un **ciclo de vida **que define cuando se va a crear la instancia del aspecto y cuanto va a vivir. Esto puedo definirlo a través de 

* **pertarget** para asignarlo a la instancia del objeto definido según un pointcut.
* **perthis: **




#### **[]()Ejemplo con Annotations

En segundo término vimos una forma alternativa de lograr el mismo resultado. Pero estableciendo un contrato entre los objetos a aspectear y el aspecto.
Acá el aspecto aplica solo a las clases anotadas con @Observable.
#### **[]()Ejemplo con Mixins

Vimos que define que los objetos anotados con @Observable ahora pasan a implementar una nueva interfaz.
Y el mismo aspecto le define las implementaciones de esos métodos, en forma parecida (conceptualmente) a la idea de **Open Class **que vimos en **Nice.**

**

**