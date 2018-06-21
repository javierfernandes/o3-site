---
title: "tps-2014-c1-tp---dsl-interno---agenda"
date:  2018-06-20T19:27:10-03:00
---


## []()Descripción del dominio

Queremos una herramienta que nos permita escribir nuestra **agenda de eventos**.
Para acotar, vamos a hacer que escribimos un solo día. Dentro de este, podemos definir **eventos** o items de la agenda.
Un evento tiene una hora de inicio (no importa la hora de fin).
Además tiene un nombre, que puede una frase.


Por último,  para un evento dado, puedo definir **recordatorios. **Éstos se ejecutan **1 hora antes** de la hora del evento.
Un recordatorio es una notificación al usuario. Y puede ser mediante uno de los siguientes medios:

* email
* sms
* llamada telefónica

## []()Ejecución y prueba

Para acotar el alcance del TP vamos a definir que:

* Las notificaciones en lugar de enviar mails, sms, etc, van generar un evento sobre un Listener. (esto nos va a permitir testear luego). La otra opción era que imprima en el sysout. Pero eso no nos permite luego testear y hacer asserts.
* La agenda no va a estar controlando el tiempo actual, en "tiempo real".
* En cambio debe permitirme ejecutarle un método


        **def** tick(horaActual, AgendaListener listener)


La semántica de este método es: desde afuera, le estoy diciendo a la agenda que son las "horaActual".
Y le paso un listener, para que, si se produce algún evento o notificación me avise a ese listener.


La interfaz **AgendaListener** podría ser:





        **interface** AgendaListener {
 `**def void** sucedio(ItemAgenda evento)`
 `**def void** seEnvioElMail(String mensaje)`
 `**def void** seEnvioElSMS(String mensaje)`
 `**def void** seHizoUnaLlamada(String mensaje)`
        }


## []()DSL

Una vez codificado y testeado el "motor" realizarle un DSL interno en Xtext, utilizando las herramientas vistas en clase: 

* extension methods (simples), 
* sobrecarga de operadores, 
* bloques, 
* var args,
* etc.

Acá va un ejemplo de DSL. No quiere decir que deban hacerlo exáctamente igual. Es sólo para guiarse:





 `**val** agenda = agenda(`


 `14.h - "Inicia Objetos 3",`
 
            18.h - "Fin objetos3" => [
        `remindMe > "Escribir Bitacora".via.email`
 `],`
 
            19.h - "Llegada a casa" => [
 `remindMe > "Enviar enunciado de TP" . via . sms`
 `],`
 
            21.h - "Cena" => [
 `remindMe > "Lavarse Las Manos" . via . phoneCall`
 `remindMe > "Poner la mesa" . via . email`
 `]`
        

 `)`
        

            val listenerDeTest = crearListener()


          (13.h >> 20.h).forEach[h| agenda.tick(h, listenerDeTest)]


Luego debería poder hacer asserts. Por ejemplo:

* sucedieron 3 eventos (no abarcamos el último de las 21)
* 2 reminders: 1 por email y otro por sms
* etc.

## []()Alternativas de DSL

El ejemplo anterior hacía bastante uso de símbolos operadores. Eso quizás no les agrade mucho o les complique un poco. Entonces, no es necesario usar operadores por todos lados, podrían si quieren usar métodos con nombres. Lo importante es terminar con un DSL que sea expresivo





        agenda => [
 `at (15.hs).I.should("Have dinner") => [`
            `    ``    ``    remindMe("Wash your hands").via(SMS)`

                ]

            at (18.hs).an("After Office") => [
                  callMeWith("Remeber after office!")

            ]
        ]
U otras variantes. 
Lo importante es que experimenten, y sea una tarea creativa, el diseñar el lenguaje cómo más les guste. Probando como "torcer" XTend.
## []()Nota sobre la forma de trabajo

Atenti, porque si bien estamos haciendo un DSL, nuestro motor es el que realmente tiene el comportamiento.
Entonces, hay que ver al DSL como una mera "capa" encima del motor, para poder construir y conectar los objetos de forma más simple, o más linda "sintácticamente".


Ahora, hacer el DSL no es sencillo. Entonces es indispensable, separar errores del DSL, respecto de errores del motor.


Más aún cuando nuestro dominio tiene lógica, como por ejemplo manejo de fechas, u horas, como en nuestro caso.
Entonces, antes de empezar a hacer el DSL, uno debería primero construir su motor, y testearle complétamente.
Así, cuando luego le hagamos el DSL y se produzca un error nos va a resultar más fácil ver si el problema está en el motor (hay un test para ese caso?) o bien hicimos algo en el DSL.


Esto es complétamente necesario si quieren encarar el bonus 3) que agregar minutos.
Porque el manejo de minutos y horas, en formato decimal (ya sea double o BigDecimal), tiene infinitos trucos que nos conviene probar independientemente del DSL.
## []()Bonus

### []()1) Bloques reminders


Agregar un tipo de reminder nuevo que me permite escribir un pedazo de código que quiero que se ejecute
Ej:





 `23.h - "A dormir" => [`
 `remindMe > [ println("Cerrar con llave") ]`
 `]`

### []()2) Reminders Configurables


Agregar la posibilidad de configurarle parámetros específicos a cada reminder. Por ejemplo

* **Al SMS** configurarle un número de destino.
* **Al llamado**: idem 
* **Al mail:**


 * dirección de mail destino
 * Asunto del mail



Sólo por mostrar un ejemplo:





 `18.h - "Fin objetos3" => [`
 `remindMe > "Escribir Bitacora".via(email => [`
 `target = "javi@gmail.com"`
 `subject = "Fin Objetos 3"`
 `])`
 `]`


O bien:





        18.h - "Fin objetos3" => [
                remindMe > "Escribir Bitacora".via.email[to="j@gmail.com" subject="Fin OBJ3"]
        ]





### []()3) Soporte para Minutos (SUPER POWER!)

Modificar motor y DSL para que soporte manejar horas con minutos.
Para simplificar vamos a asumir que la mayor precisión de trabajo serán 5 minutos.
No puedo/debo configurar un evento, por ejemplo a las 19:33
Pero sí podría 19:30 y 19:35


En el motor, pueden asumir que siempre que les llamen a tick(...) recibiran una hora entre las 0:00 y las 23.55
Con todos los valores intermedios de a 5 minutos.
Ej:
   0:00, 0:05, 0:10, 0:15 .......   15:25,  15: 30,   15:35, .... etc


En este caso ***cambiamos los tiempos de los reminders: ahora se ejecutan 5 minutos antes del evento***

***

***

Ejemplo de sintaxis:






            `14.h - "Inicia Objetos 3",`
 **`18/25.h`**` ``- "Fin objetos3" => [`
 `remindMe > "Escribir Bitacora".via.email`
 `]``,`
 **`19/30.h`**` ``- "Llegada a casa" => [`
 `remindMe > "Enviar enunciado de TP" . via . sms`
 `]`


Otros bosquejos de sintaxis posibles:


* 21/15.h
* 21%15.h
* (21.h + 15.m)

Muchísimo cuidado porque manejar tiempos y en especial cualquier número con decimales es bastante complicado. Si los opero por ejemplo para dividirlos o calcular el módulo y son **double** van a empezar a arrastrar un error de redondeo por falta de precisión.
Ej:
        **    val** numero = 12.4d
            val fraccion = numero % 1
            println(fraccion)

Debería imprimir la parte decimal del número, o sea "0.4", 
En cambio imprime:
 `0.400000000000000**36**`
Entonces, opciones:
1. Modelar con sus propias clases la idea de Hora y Minuto, y PuntoEnTiempo. Y agregar responsabilidades para que se sepan comparar, y agregar 5 minutos por ejemplo, Y que maneje el hecho de que 55 minutos + 5 dan 1hora. Una forma sería trabajar internamente todo con Int's ahí dentro.
1. La otra opción es trabajar con BigDecimal, que permite especificar una "precision".
         Ej:
         `    ``    ``**new** BigDecimal(23, **new** MathContext(2)).`
        El segundo parámetro es la precisión. Es decir la cantidad de lugares a la derecha de la coma.
        En xtend se puede crear con un literal así:
                     `23.0bd`

        Pero ojo, porque

                     `println(19.3bd == 19.30bd) `
                     => false !! Atenti al cero que falta en el de la izquierda !
        

          `    ``    ``println(19.30bd == 19.30bd)`
                    => true !


          Entonces, si quiero asegurarme de compararlos pero que no tome en cuenta los ceros de la derecha

             `19.3bd**.stripTrailingZeros()** == 19.30bd.currentTime**.stripTrailingZeros()**`