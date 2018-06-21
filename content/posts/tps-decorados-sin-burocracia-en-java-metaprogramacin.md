---
title: "tps-decorados-sin-burocracia-en-java-metaprogramacin"
date:  2018-06-20T19:27:10-03:00
---


## []()Introducción - Decorator Pattern


Como vimos en los lenguajes basados pura y exclusívamente en objetos la delegación es un mecanismo bastante poderoso. En esos lenguajes era automático, y vimos entonces que hacer un "decorator" por ejemplo era bastante trivial, agregando un nuevo parent object que solo interceptaba los mensajes que le interesaban.
En un lenguaje como Java cambiarle el comportamiento ante un mensaje a un objeto requiere implementar un decorator. Un decorator se utilizar para "envolver" a un objeto y así, ahora los clientes que antes usaban al original van a utilizar el nuestro que se antepone en el medio de los llamados.
El decorator "envuelve" al original, ocupa su lugar. Por esto debe implementar una interfaz común a él. Ahora, él pasa a recibir todos los mensajes, y puede en algunos símplemente delegárselos al original, pero lo interesante es que estando en el medio podría: no llamar al original y hacer otra cosa; o llamar al original pero haciendo alguna transformación a los parámetros o al resultado.
Así es que cambia el comportamiento.
Veamos un ejemplo:
* Dado un Iterator cualquier, me gustaría poder decorarlo para que se salte elementos, por ejemplo dando uno sí, uno no. Solo los pares.

 * La interfaz común acá es **Iterator**

 * Ergo, nuestra clase va a "envolver" a un **Iterator**

 * Y como tiene que tomar su lugar, también va a implementar **Iterator** (se hace pasar por el original)

Acá podemos ver como se usaría en un main():

            `    ``List<Integer> numeros = Arrays.asList(10, 20, 30, 40, 50, 60);`
                
                System.out.println("Original:");
                Iterator<Integer> numerosIterator = numeros.iterator(); 
                **while**(numerosIterator.hasNext()) {
                    System.out.println(numerosIterator.next());
                }
                
                System.out.println("Salteado:");
*`        numerosIterator = **new** SalteaIteratorDecorator<Integer>(numeros.iterator());  `*<<--- ACA DECORAMOS!
                **while**(numerosIterator.hasNext()) {
                    System.out.println(numerosIterator.next());
                }

Esto imprime:

        Original:
        10
        20
        30
        40
        50
        60
        Salteado:
        20
        40
        60
 Lo interesante es que esta clase decoratora ahora la podemos aplicar a cualquier List.
 Acá va una implementación de ejemplo:
 
 
        **public class** SalteaIteratorDecorator<E> **implements** Iterator<E> {
            **private** Iterator<E> decoratee;
            **private** E siguiente;

            **public** SalteaIteratorDecorator(Iterator<E> decoratee) {
                **this.**decoratee = decoratee;
                **this.**agarrarElSiguiente();
            }

            @Override
            **public boolean** hasNext() {
                **return** this.siguiente != null;
            }

            @Override
            **public** E next() {
                E actual = **this.**siguiente;
                **this.**siguiente = null;
                agarrarElSiguiente();
                **return** actual;
            }

            **protected void** agarrarElSiguiente() {
                **if** (**this.**decoratee.hasNext()) {
                    //saltea
                    **this.**decoratee.next(); 
                }
                if (**this.**decoratee.hasNext()) {
                    **this**.siguiente = **this.**decoratee.next(); 
                }
            }

            @Override
            **public void** remove() {
                **throw new** UnsupportedOperationException();
            }

        }
 
Por si no se entiende, este decorator es como que se "anticipa", y ya sabe (cachea) el "siguiente" elemento a devolver. Cuando le piden next() el lo devuelve, pero también ya se trae el próximo.
 
Esto está hecho así, porque para poder implementar el hasNext() no podemos símplemente delegarle al decorado, porque éste podría tener 1 más, pero no 2 más. En ese caso nosotros deberíamos responder false (nuestro decorator).
 Entonces, lo más fácil es que siempre esté adelantado. En cualquier momento cuando intenta avanzar dos posiciones y no tiene más, deja en null "siguiente", que significa que no hay más.

## []()Ventajas

A diferencia de la herencia yo puedo decorar y "des"decorar un objeto en runtime. En cambio si yo hacía una subclase de un Iterador que sobrescribía el comportamiento, toda instancia de esa clase iba a ser siempre un iterador "salteador", y no podría yo agregar/sacar ese comportamiendo en runtime.

Otro ventaja del decorator es que yo ahora lo puedo aplicar para meterle este comportamiendo a cualquier Iterator. Si usaba herencia y tenía varias clases de Iterators que quería "saltear" hubiera tenido que subclasear cada una repitiendo código.


## []()Problema del Decorator (Burocracia!)


Pero no todo es alegria con el Decorator. Al menos no en lenguajes con checkeos de tipos. Lo malo es que a veces queremos solo "interceptar" un único método, por ejemplo el add() o dos métodos, add() y addAll() de un List. Pero como nuestro decorator tiene que implementar List, nos tira encima toda la burocracia y el trabajo de tener que implementar todos los métodos de List, que son varios.

Como no queremos hacer nada con ellos, todos van a ser bastante parecidos. Van a delegar el llamado al **decoratee **(objeto decorado).

Eso es "burocracia", o más bien un embole.

Si después se agrega un método a la interfaz (ok, a List no se puede, pero si fuera una nuestra), deberíamos tocar todos los decorators para agregarles ese método nuevo.


## []()Enunciado del TP

Entonces dicho todo esto, y luego de esta larga introducción, la intención del TP es implementar un mecanismo genérico que nos permita decorar un objeto para interceptar ciertos métodos, sin necesidad de la burocracia de tener que implementar todos los otros métodos.
Este mecanismo se debe poder utilizar para decorar:
* Cualquier objeto
* Con cualquier interceptor/decorador

Para esto vamos a utilizar un mecanismo bastante mágico de Java que se llama **Dynamic Proxies. **Esto permite crear un proxy que implementa las interfaces que nosotros digamos. En realidad nos da un objeto que es como una cáscara vacía. Implementa todas las interfaces, pero no sabe hacer nada, porque no existe el código que las implemente. En su lugar, lo que sucede es que para crear este objeto, necesitamos nosotros especificar otro objetito que implemente la interface **InvocationHandler. **Ésta interface es muy simple y define un único método:
        **public** Object invoke(Object proxy, Method method, Object[] args) `**throws** Throwable;`
El chiste es que, cada vez que alguien le envíe un mensaje al proxy (al objeto ese tipo cáscara), él, solito, como no sabe hacer nada, nos va a llamar a éste método del handler. Que sería como decir: 

*`"Che, me llamaron (proxy) a éste método (method), con todos estos argumentos (args), y yo soy un proxy, no se hacer nada, así que encargate vos de hacer lo que quieras".`*
Pueden ver un ejemplo de uso de este mecanismo [acá](http://java.dzone.com/articles/power-proxies-java)
Ojo porque si bien eso se parece a lo que queremos hacer, no es lo mismo. En ese ejemplo ellos interceptan el "add()" de una lista, para no agregar nada. Acá utilizan entonces los proxies para hacer una cosa particular, está como hardcodeada. 

En cambio nosotros queremos que hagan:
* Construyan una implementación de InvocationHandler genérica
* que sirva para decorar cualquier objeto, con cualquier otro objeto
* Éste "Interceptor" o "Decorador" no queremos que tenga la burocracia así que:

 * no deberá implementar la interfaz, por ejemplo, "List".
 * Entonces cómo hacemos que el proxy lo pueda llamar ??

  * Definimos una convención, a continuación:


### []()Convención de Uso
Si yo quiero decorar un **List** para hacer algo solo en el método add():

* Creo una clase
* Agrego el método tal cual está definido en la interfaz.
* Pero eso no me alcanza, porque necesito acceso a la lista original, por ejemplo si quiero ante el add multiplicar el elemento por 2 y luego agregarlo en la original. Entonces modifico el método, para que reciba como primer parámetro al decorado.

Acá el ejemplo para el interceptor que multiplica:
Dado el método add de List:
        **public boolean** add(E e);

Nuestro interceptor será:
        **public class** MultiplicaListInterceptor {
        
    **public boolean** add(List decoratee, Object e) {
                **return** decoratee.add(((Integer) e) * 2);
            }

        }
### []()TestCase

Les pasamos ***acá adjunto ***un test case con pruebas que deberá pasar su interceptor. Deberán modificar el método **crearInterceptor** para allí instanciar su propia clase!