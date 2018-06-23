---
title: "tps-2014-c1-tp1-mixins"
date:  2018-06-20T19:27:10-03:00
---


### Descripción del dominio

El objetivo de este TP es controlar la reserva de canchas de un complejo deportivo.


El complejo tiene canchas de tenis, paddle y fútbol. Cada tipo de cancha tiene un precio base al que luego se le sumarán algunos adicionales. El precio base es:

* Paddle: $100
* Tenis: $150
* Fútbol: $40 * la cantidad de jugadores, por ejemplo, una cancha de fútbol 5 (10 jugadores en total, es decir, 5 por equipo) vale $40 * 10 = $400 (independientemente de cuántos jueguen la cancha es para 10, no nos fijamos cuántos juegan). 



De cada cancha debemos guardar la información de las reservas que se realizaron. De cada reserva tenemos que saber:

* El día. (Si quieren, para simplificar podemos asumir que el día es simplemente un número entero, del 1 al 31, representando el día del mes, y asumiendo que sólo guardamos información de un mes. Si en cambio quieren ir un paso más allá, recomendamos utilizar Joda Time para manejar fechas.)
* Hora de inicio y finalización de la reserva (nuevamente, para simplificar, podemos manejar las horas como enteros).





Como se dijo, además de los precios básicos, hay algunos adicionales que puede tener cualquier cancha:

* Algunas canchas tienen luz. En esas canchas, jugar después de las 18 se cobra un 20% adicional. En las demás canchas no se puede jugar después de las 18.
* Algunas canchas tienen techo. El dueño es muy malo y los días de lluvia sube el precio un 10% de las canchas que tienen techo. Para saber qué días va a llover obviamente se fija en el pronóstico del tiempo, ustedes definan un objeto ServicioMeteorológico al cual poder preguntarle si un día va a llover o no.
* FInalmente, hay alguna canchas que tienen una pequeña tribuna. Esas canchas los fines de semana se usan para torneos y por eso se cobran el doble.

### Requerimientos

Sobre ese dominio debe ser posible:
1) Reservar una cancha para un día y horario específico. Antes se deberá validar si la reserva es posible (no se superpone con otra reserva, no es horario nocturno si la cancha no tiene techo). Si la reserva es posible se debe registrar en el sistema, si no es posible terminar con excepción. 


Atención: la reserva se hace siempre para una cancha específica, es decir, no se pide la posibilidad de pedir "quiero jugar al tenis mañana de 17 a 18" y que el sistema busque entre todas las canchas de tenis. En cambio, se pide "quiero reservar la cancha número 7, mañana de 17 a 18".


2) Obtener estadísticas del uso de las canchas:
a) Obtener todas las canchas que tengan reservas para un día determinado.
b) Obtener todas reservas para un día determinado.
c) Dado un día y horario, encontrar alguna cancha libre (una cancha cualquiera, no importa el deporte).
d) La cancha con más reservas.
e) La totalidad de la facturación del complejo (sumar los precios de todas las reservas para todas las canchas).
### Aclaraciones


* El objetivo de esta materia es programar con objetos, no utilicen las canchas y/o reservas como estructuras de datos. En cambio, traten de **delegar comportamiento** en esos objetos. 
* También esperamos que sigan prácticas básicas de programación, como **utilizar unit tests, evitar duplicaciones de código**, tener **código prolijo y legible**, etc.
* Luego, el objetivo específico de este TP es aprender a trabajar con **mixins**. Para aprobar el TP es indispensable usar adecuadamente este concepto. 
* Además esperamos que usen correctamente las colecciones de Scala y en particular los métodos que trabajan con **bloques**, tales como map, filter, find, exists, y forall (las familias de fold y reduce se pueden usar también, pero no las exigimos, for y foreach deben ser evitados siempre que sea posible usar una de las opciones de más alto nivel). 
* El TP nos da la oportunidad de además aprender y practicar otros temas intersantes, como aprender algunos features avanzados del lenguaje Scala, el framework de testing ScalaTest, y otras herramientas (como Joda Time). Valoraremos el aprovechamiento de esas herramientas, siempre y cuando no vayan en desmedro de los objetivos del TP.