---
title: "te-jvm-bytecode"
date:  2018-06-20T19:27:10-03:00
---


## Introducción
JVM bytecode es el formato binario de código ejecutable por la máquina virtual de java.
Algo así como el famoso lenguaje máquina "assembler", pero para la VM de java.

Podemos ver el bytecode al abrir un archivo .class
Por supuesto va a ser completamente inentendible. Entonces, para esto podemos usar un plugin de eclipse como [este](http://andrei.gmxhome.de/bytecode/index.html).


### OpCode's e Instrucciones
Este lenguaje (porque en definitiva es un lenguaje, si bien de bajo nivel y binario, es un lenguaje) consta básicamente de **instrucciones**, cada instrucción tiene un código que la identifica llamado **opcode** y opcionalmente parámetros.
El **opcode** se expresa en forma de bytes, pero existe una convención de nombres cortos para poder hacer más legible el bytecode.

Entonces, veamos un ejemplo. El siguiente código que suma dos valores:


            **public void** sumar() {
                **int** a = 2;
                **int** b = 3;
                **int** resultado = a + b;
            }
Se traduce al siguiente bytecode:


iconst_2`**

        **istore** 1
iconst_3`**

        **istore** 2

        **iload** 1
i**load** 2`
iadd`**

        **istore** 3
return`**


        **maxstack** 2
        **maxlocals** 4
Acá vemos un par de cosas.
Cada linea tiene una instrucción con su respectivo **opcode** en formato "legible".


* **iconst_X: **declara una constante con el valor **x **y pone su valor en el **stack**


* **istore Y**: guarda el valor del stack en una variable local identificada por **Y**


 * En nuestro caso se declaran las dos constantes 2, y 3 y se asignan a variables locales 1 y 2 respectivamente
* **iload:** se utiliza para cargar en el stack el valor de una variable, en nuestro caso se carga el valor de 1 y 2.
* **iadd:** luego esta operación especial sirve para sumar dos **integers **(de ahí su nombre que empieza con la i)

 * los operandos tienen que estar previamente seteados en el **stack**

 * esto además guarda el resultado en el stack
* luego nuevamente istore 3 guarde el valor del stack en una nueva variable local 3. En nuestro ejemplo este valor es el resultado de la suma.
* **return** no hace falta explicar esto.
* **maxstack & maxlocals**: 



### Stack-Oriented model
Como vimos en el ejemplo anterior aparece la idea de **stack.** Esto es importante de al menos mencionar, la JVM y su bytecode está diseñada en base a un stack y no de registros. Como es por ejemplo el modelo de assembler.
Este modelo está relacionado con la idea del modelo de objetos (llamadas a métodos).

En realidad es un  tema de bastante bajo nivel, pero digamos que esto le permite a la VM poder ejecutar más eficientemente en procesadores que no tienen un conjunto de registros extendidos.

A nivel práctico esto quiere decir que la mayoría de las instrucciones operan sobre el stack, por ejemplo en nuestro caso la suma obtiene los operandos *popeandolos**  ***del stack.
Quiere decir que nos vamos a hartar de ver manipulación del stack cuando veamos bytecodes.
Esto hace al bytecode un poco más dificil de leer y más verborrágico.



### Hola Mundo (invokevirtual)
Veamos como se traduce el famoso hola mundo de esto:

`

        **public class** HelloWorld `
         **public static void** main(String[] args) {
         System.out.println("Hello, world!");
         }
        }
```
A bytecode:


        **getstatic** java/lang/System.out : Ljava/io/PrintStream;
        **ldc** "Hello, world!"
        **invokevirtual** java/io/PrintStream.println(Ljava/lang/String;)V
return`**

Donde:

* **gestatic:** accede a la variable de instancia **out** de **System** y mete la referencia en el stack
* **ldc: **apila en el stack el string "Hello, world!"
* **invokevirtual**: invoca el método identificado por la interfaz **PrintStream**, y firma **println(String):void** consumiendo de la pila:

 * el último elemento agregado (el string) como parámetro.
 * el anterior, como el receptor.

### Invoke*
Existen varios opcode para la invocación de métodos:

* **invokevirtual**

* **invokestatic**

* **invokeinterface**

* **invokespecial**

* **invokedynamic **(nuevo en java7)


#### invokevirtual
Como ya vimos en el ejemplo de "Hola Mundo", el **invokevirtual** se utiliza para invocar métodos haciéndo uso del mecanismo de dispatching dinámico para localizar y ejecutar la implementación del método de acuerdo a la clase concreta del receptor.
Este dispatching se hace sobre la jerarquía de la clase.

Algo importante a tener en cuenta es que esta instrucción se utiliza para invocar métodos de instancia declarados en clases y no en **interfaces**. Para este último caso existe la instrucción **invokeinterface**.


#### invokeinterface
 Bastante similar al **invokevirtual** se utiliza para invocar un método, declarado en una **interface**.** **De nuevo se ejecutará el dispatching dinámico sobre el receptor.
Veamos un ejemplo:
```

        void test(Enumeration enum) {
         **boolean** x = enum.hasMoreElements();
         ...
        }


En este caso Enumeration es una **interface** y estamos invocando el método **hasMoreElements()
**Esto se traduce al siguiente bytecode:


        **aload_1** *; agrega la variable local 1 (el argumento al método)** en la pila*
        **invokeinterface** java/util/Enumeration/hasMoreElements()Z 1 
        **istore_2** ; *guarda el resultado en la variable local 2 (la x)*

```

#### invokespecial

Se utiliza para invocar un método puntual, sin realizar dispatching dinámico. Es decir para invocar métodos "no-virtuales". En java decimos que todos los métodos son virtuales por default, porque generalmente el bytecode que escribimos se traduce a instrucciones **invokevirtual** y/o **invokeinterface**. En otros lenguajes como C# se da lo contrario y hay que especificar qué métodos queremos que sean virtuales.
En fin, volviendo a java, el tema es que hay ciertas invocaciones especiales donde no hay dispatching. Estos son los casos:

* invocaciones a **constructores de la superclase**:

 * **super()**

 * **super(arg1, arg2)**

* invocaciones a **métodos privados**: ya que no se pueden redefinir en subclases, ni tampoco pueden estar sobrescribiendo métodos de la superclase. No hay dispatching.
* invocaciones a métodos de la superclase:

 * Ej: **super.toString()**


#### invokestatic
 Se utiliza para invocar métodos **static**. Obviamente no hay dispatching.


#### invokedynamic
Es una instrucción nueva en la JVM versión 7, que muchos lenguajes están esperando, porque permitirá invocar un método en forma dinámica, es decir, con dispatching, pero sin necesidad de especificar la clase que lo declara y la firma del método.
Esto va a dar el soporte necesario para lenguajes dinámicos que hoy en día igualmente se construyen sobre la JVM pero con muchas limitaciones o con "truquitos" para evadir la naturaleza estática y los checkeos de java. Muchas veces esto causa un pérdida considerable de performance de estos lenguajes o consumo de memoria.
 
 
## Referencias

* ["Java Bytecode Fundamentals"](http://arhipov.blogspot.com/2011/01/java-bytecode-fundamentals.html)
* ["Java Bytecode Fundaments: Using objects and calling Methods"](http://www.zeroturnaround.com/blog/java-bytecode-fundamentals-using-objects-and-calling-methods/)


 * [Java Virtual Machine Online Instruction Reference](http://cs.au.dk/%7Emis/dOvs/jvmspec/ref-Java.html)

 * [Java Virtual Machine Specification](http://java.sun.com/docs/books/vmspec/2nd-edition/html/Concepts.doc.html#32983)

* ["Java Bytecode: Understanding bytecode makes you a better programmer"](http://www.ibm.com/developerworks/ibm/library/it-haggar_bytecode/)