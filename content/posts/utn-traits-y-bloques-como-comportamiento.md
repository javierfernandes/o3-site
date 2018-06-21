---
title: "utn-traits-y-bloques-como-comportamiento"
date:  2018-06-20T19:27:10-03:00
---


## []()Más sobre traits


Sobre el ejercicio de la [clase anterior](utn-ejemplos-de-clase) agregamos la posibilidad de que los atacantes y defensores puedan "descansar".
Arranquemos por la implementación en Defensor, cuando un defensor descansa, suma 10 de energía


        Defensor >> descansar
           self energia: self energy + 10


Por otro lado, cuando le decimos "descansar" al atacante, este ataca con el doble de energía en su próxima pelea



        Atacante >> descansar
         `   ``self descansado: true`

        Atacante >> atacar: unDefensor
            `self potentialOfensivoReal > unDefensor potencialDefensivo ifTrue: [`
            `    ``unDefensro recibirDanio: self potencialOfensivoReal - unDefensor potencialDefensivo`
            `self descansado: false`
            ]
        Atacante >> potencialOfensivoReal
            `^self potencialOfensivo * (self descansado ifTrue:[2] ifFalse:[1])`

Hasta acá todo muy bien, pero ahora, surge el problema de que Guerrero, como usa el trait Atacante, y el trait Defensor, estaría trayendo dos métodos iguales, por lo que surge un conflicto.
En Pharo, no hay una forma automática de resolver los conflictos, hay que resolverlos a mano.
Entonces, hay dos maneras de solucionar el problema, conocido como:
- Cancelación
- por Alias

Si por ejemplo quisieron que Guerrero tome el descansar del trait Defensor, y no el de Atacante, podríamos hacer, en la definición de la clase Guerrero:




        Object subclass: #Guerrero
            `uses: Atacante - {#descansar} + Defensor`

Con esto le decimos a la clase, que no quiero traer el método descansar de Atacante. Esto se llama cancelación, cancelo los métodos que no quiero. Esto no produce ninguna modificación en el trait, es decir, no tiene efecto de lado, solamente vale para Guerrero.

Ahora, vamos a nuestro caso real, nosotros queremos ambos métodos, ya que usará uno u otro dependiendo de si va a atacar, o va a defender. Entonces, lo primero que queremos hacer, es poder distinguir los dos métodos (que se llaman igual), para esto ponemos un alias, de esta manera ya podemos distinguir ambos métodos (ya que los voy a necesitar a los dos)



        Object subclass: #Guerrero
            `uses: Atacante @ {#descansarAtacante -> #descansar} + Defensor @ {#descansarDefensor -> #descansar}`


¿Con esto solucionamos el conflicto? No, todavía no, porque aún tenemos dos métodos distintos (que se llaman "descansar") que se están trayendo de dos trait distintos, y no dijimos como vamos a usar ese método (como va a ser el código). Sin embargo, a mi me interesan las dos versiones, pero no hay problema con eso porque con el alias me aseguré de que me estoy quedando con las dos opciones. Pero el método descansar sigue existiendo. Así que sólo nos queda definir ese método, para ahora sí, arreglar el conflicto:



        Guerrero >> descansar
            `self descansarAtacante.`
            `self descansarDefensor.`


Ahora sí!, con esto, pisamos el método descansar, quedó definido, y se resolvió el conflicto.
Recordemos que cuando pisamos un método de un trait, perdemos el comportamiento del método que estaba en el trait (diferente del super, que usamos cuando tenemos una super clase).
Esto que vimos, forma parte de lo que llamamos álgebra de traits.
En este [gráfico](utn-traits-y-bloques-como-comportamiento-Operaciones-de-Traits-png?attredirects=0) pueden ver mas en detalle, las operaciones que se pueden hacer con traits. Péguenle una mirada a ver si entienden todos los ejemplo. Es muy interesante.

Bien, ahora, a probar que todo esto funciona.
## []()Testing
Durante la clase se realizaron algunas pruebas unitarias
La idea de esto es básicamente, llevar el código que ponemos en un workspace para probar, a un método, en un clase especial que se llama TestCase, para tener este código disponible para probarlos siempre que quiera. A esto le llamamos test unitarios. 

Los nombres de los métodos deben empezar con la palabra "test".

[Éste](https://docs.google.com/viewer?a=v&pid=sites&srcid=ZGVmYXVsdGRvbWFpbnx1dG5kZXNpZ258Z3g6MTAzMTk0NmQxOTFiYzU5Zg) de aquí es un apunte de testing obtenido de la página de Diseño de Sistemas. Los ejemplos están en otro lenguaje, pero el concepto es análogo. Para leer sobre tests unitarios en Pharo, recomendamos leer el capítulo 7 del libro "Pharo By Example", que se puede obtener en [http://pharobyexample.org/](http://pharobyexample.org/).

En la página de los [ejemplos de clase](utn-ejemplos-de-clase) repo encontrarán el código completo más los tests.

## []()Nuevo Requerimiento:
Algunos guerreros pueden formar parte de un ejército. Cuando un guerrero es atacado, el ejército puede tomar alguna acción. Ciertos ejércitos se retiran cuando detectan que más de la mitad de sus guerreros están lastimados. Otros ejércitos hacen que el guerrero descanse cuando recibe un daño y queda lastimado.

Resolvemos el nuevo requerimiento.
Aparece la clase Ejército. 
Ahora, en el caso de que un defensor quede lastimado, debería avisarle al Ejército, para que este decida que hacer (dependiento del tipo de Ejército en el que esté), para esto, necesitamos que un defensor, conozca al ejército al que pertenece.
Entonces, modificamos el método recibirDanio, para agregar este comportamiento.



        Defensor >> recibirDanio: danio
            `self energia: self energia - danio.`
            `self lastimado ifTrue:[`
            `    ``ejercito estoyLastimado: self.`
            `]`

¿Y cómo nos queda ejército? Habiamos dicho que teníamos dos tipos de ejércitos, entonces para solucionar esto, hago una herencia, donde se sobreescribe el método estoyLastimado:unGuerrero.

Pero, ¿que problemas tengo al hacer una herencia?
- La herencia la puedo usar para una sola subclasificación, por lo que , si existiera otra manera de subclasificar los ejércitos, ya no puedo.
- No puedo cambiar el tipo. Si un ejercito fue creado como un ejército que manda a sus guerreros a descansar y quiero que este cambie al otro tipo, no lo puedo hacer (al menos no dinámicamente). 

Está mal usar herencia acá? no, no está mal, pero tiene sus limitaciones que uno acepta cuando la usa. Además no es la única herramienta que tenemos para resolver el conflicto. Así que vamos a comenzar a "refactorizar" la solución para generar otro diseño que cumple con la misma funcionalidad, pero tiene otras cualidades, en particular no presentará las limitaciones de la herencia.

## []()Reemplazando herencia por composición.
Entonces, ahora hago que mi clase Ejército, tenga un atributo que indique que tipo de acción tomar cuando sus guerreros están lastimados, pongámosle lastimadoStrategy (es decir, la estrategia a seguir cuando un guerrero está lastimado). Este objeto, va a ser el que sabe que hay que hacer cuando algún guerrero está lastimado. Entonces ahora el método estoyLastimado:unGuerrero que estaba definido en cada subclase de Ejército (que ahora ya no son subclases de Ejercito), tiene que delegar este comportamiento en el objeto tipoEjército (que es un objeto que entiende el mensaje estoyLastimado:unGuerrero. Una alternativa interesante es pasarle al estrategy el ejercito receptor del mensaje. En ese caso el mensaje que entiende es: estoyLastimado: unGuerrero soy: unEjercito
*
*

        Ejercito >> estoyLastimado: unGuerrero
            `lastimadoStrategy estoyLastimado: unGuerrero soy:self`

Como ya no tengo subclases de ejércitos tengo que configurar cada instancia de ejército con el strategy correspondiente. Un posible lugar donde hacer esto es escribiendo distintos constructores en la clase Ejercito. Por ejemplo, un constructor para un ejército "protector" (llamábamos protector a la estrategia de mandar a descansar al guerrero lastimado)



        Ejercito class >> newProtector 
         |ejercito|
         ejercicio := Ejerctio new.
         ejercito lastimadoStrategy: ProtectorStrategy new.


        ProtectorStrategy >> estoyLastimado: unGerrero soy: unEjercito
         unGuerrero descansar 
Siempre que tengo una herencia, puedo extraer este comportamiento y convertirlo en una delegación. Es mecánico. 

Con la delegación que hicimos recién, lo que hicimos fue convertir un comportamiento en un objeto. Para esto creamos un objeto que se encargará de resolver dicho comportamiento. Y para esto, vamos a necesitar dos clases, una para cada tipo de acción (la de retirarse, y la de mandar a los soldados a descansar).
## []()Diseñando usando bloques
Antes vimos como hacer para llevar llevar un comportamiento a un objeto. Smalltalk nos propone una forma de escribir un objeto que representa un comportamiento sin necesidad de escribir una clase: los bloques. Vamos a modificar la solución para que el strategy del ejército sea un bloque en lugar de una instancia de una clase construida para tal fin.



        Ejercito class >> newProtector`    `
        |ejercito|
        ejercicio := Ejerctio new.
        ejercito lastimadoStrategy: [:unGuerrero | unGuerrero descansar].

Así nos quedaría la creación de un ejercito con la estrategia de mandar a los guerreros a descansar cuando se lastiman.
Ahora ya no necesito una clase para modelar el comportamiento, ahora en la variable, seteo directamente el código que se debería ejecutar.
Es decir, antes en la variable lastimadoStrategy me guardaba un objeto que era el que resolvía que hacer cuando le llegaba el mensaje estoyLastimado (cuando le mandan el mensaje estoyLastimado al ejército, este se lo mandaba a lastimadoStrategy, que era también una instancia de alguna de las clases según el tipo de estrategia), que entendía este mensaje. Ahora, lastimadoStrategy también es un objeto, pero es un bloque (ahora, ya no necesitamos las dos clases que representaban cada una una estrategia distinta), entonces, según el ejército que se esté creando, defino en esa variable, el comportamiento que quiero que tenga ese ejército. Y como es una variable, lo puedo cambiar en tiempo de ejecución, es decir, me quedé con la ventaja de poder cambiarlo, pero ahora resolví todo en una sola clase. Y sigo teniendo ese comportamiento en un objeto que lo resuelve.

Ahora digo, si leo



         `ejercito lastimadoStrategy: [:unGuerrero | unGuerrero descansar].`

Esto queda un poco feo, a decir verdad, vamos a hacer que quede un poquito mas expresivo:


         `ejercito cuandoUnGuerreroSeLastime: [:unGuerrero | unGuerrero descansar].`
Con esta simple modificación, ahora queda mas clase, que lo que hago es asignar un bloque de código, que se va a usar en algún momento, a una variable.

## []()Desacoplando Usando un Observer


Volvamos un poco al requerimiento, dice "Algunos guerreros pueden formar parte de un ejército". Esto no lo discutimos mucho antes, hicimos que los defensores, conocieran al ejército al que pertenece… pero en realidad, el concepto "Defensor" está en un trait. Por lo que, si queremos representar esto en UML, nos estaría quedando una flecha desde el trait Defensor, hasta Ejército (aunque, en la realidad, vamos a tener que agregar el atributo ejercito en Guerrero, porque me lo va a pedir el trait). 
Si el guerrero no pertenece a ningún ejército, bueno, con esta solución, no nos queda otra que poner la variable en nil, e ir verificandola cuando resulta que soy un defensor, y me lastimé. 

Por otro lado, otra cosa que podríamos agregar acá (que NO está en los requerimientos, pero lo vamos a pensar igual, ya que estamos practicando esto de buscar soluciones alternativas) es que pasa, si de pronto el guerrero, cuando se lastima, le avisa no sólo al ejército, sino también a enfermería, a sus compañeros, al jefe, etc... ? en este caso, si el defensor queda lastimado, habría que avisarle a todos ellos, ¿cómo modelo esto? Bueno, acá se me debería ocurrir, que como a todos les tengo que avisar lo mismo: "me lastimé", de alguna manera todos estos deben ser polimórficos. 

Esto es conocido como "evento", un objeto tira un evento, y hay otros objetos interesados en ese evento, por lo que, se quedan observando al objeto que tira el evento, para que cuando el evento sucede, estos hagan algo. En nuestro ejemplo, el guerrero tira el evento me lastimé, y sus observers, cuando se enteran, hacen algo con esta notificación.
(este es un conocidísimo y usadísimo patrón de diseño, llamado Observer, y es super recomendable que lean sobre este patrón, mas adelante, mas información sobre esto).

Que nos estaría faltando para agregar esto de los observers a nuestra solución? 
2 cosas: Cosa 1, ahora el guerrero ya no conoce al ejército, sino que tiene una colección de observers, y si se lastima, le avisa a todos ellos, por supuesto, el ejército es uno de ellos. 
Cosa 2, enemos que definir un contrato para que todos dos observers sean polimórificos, es decir, que mensaje les va a mandar el guerrero a todos sus observers, cuando se lastima.

La solución vendría quedándonos mas o menos así:


        Defensor >> recibirDanio: danio
            `self `energia: self energia - unDanio.`
``    self lastimado ifTrue: [`
            `    ``self observers do: [: observer | observer estoyLastimado: self]`
            `].`

Y en ejercito me queda, que cuando agrego un guerrero a la colección de guerreros, agrego el ejército como observer del guerrero


        Ejercito >> addGuerrero: unGuerrero
            `self guerreros add: unGuerrero`
            `unGuerrero addObserver: self`

Y cuando le llega el mensaje del evento que tira el guerrero, tengo que hacer:


        Ejercito >> estoyLastimado: unGuerrero
            self cuandoUnGuerreroSeLastime value: unGuerrero.

Donde el Ejército ya sabe que hacer en este caso, se acuerdan? el Ejército tenia una estrategia que podía variar para actuar, eso es lo que está guardado en la variable cuandoUnGuerreroSeLastime (que es un bloque).


Y, si el guerrero no pertenece a ningún ejército, entonces ejército, no será un observer de guerrero, ya que como el guerrero no pertenece a ningún ejército, no tiene nada que avisarle al ejército. Pero ahora, el guerrero, tiene una colección de "observers", entonces, no sabe bien a quien le está avisando y a quien no, por lo que, la solución quedó bastante mas desacoplada que cuando teníamos la variable "ejército" en la clase Guerrero. Ahora sólo sabe que tiene que notificar el evento, si a nadie le interesa (es decir, si la colección está vacía) entonces no se enterará nadie, pero el guerreró, ya no sabe tanto de lo que pasa cuando se lastima.
## []()Usando bloques como observers.
¿Que problema tiene esta solución? El problema de esta solución, es que ahora, todos aquellos objetos que quieran "enterarse" de que se lastimó un defensor, es decir, los observers, deben entender el método estoyLastimado: unGuerrero.
¿Se puede mejorar esto? Si, con los bloques! podemos hacer que los observers, en lugar de ser objetos que entienden el mensaje estoyLastimado:unGuerrero sea un bloque de código a ejecutar.

Entonces, cuando agrego un observer, (por ejemplo el ejército) me quedaría:



        Ejercito >> addGuerrero: unGuerrero
            `self guerreros add: unGuerrero.`
            `unGuerrero addObserver: cuandoUnGuerreroSeLastima`

Acá, en lugar de agregar el objeto ejército, agrego el código que este tiene que ejecutar.

Y entonces cuando un defensor se lastima hace:



        Defensor >> recibirDanio: danio
            self energia: self energia - unDanio.`
``    self lastimado ifTrue: [`
            `    ``self observers do: [: observer | observer value: self]`
            `]`

Es decir, ejecuta el bloque, con el que cada observer se agregó como observer. Entonces, recorro la colección de bloques, y los ejecuto, de esta manera, cada uno se agrega como observer, con el código que debe ejecutarse, por lo que, ahora ya no necesito que los objetos interesados en el guerrero sean polimórficos, cada uno se va a agregar con el código que sea que hay que ejecutar. El polimorfismo queda entre los bloques.


Entonces si por ejemplo tuvieramos una clase Enfermeria que lo que hace cuando se lastima un defensor es agregarlo en su lista de gente a curar, sería:




        enfermeria := Enfermeria new.
        unGuerrero addObserver: [:unGuerrero :enfermeria | enfermeria lastimados add:unGuerrero]
## []()Moviendo la característica de ser observable a un Trait
Ahora que le dimos mil vueltas a la solución, vamos con el último cambio. Vamos a decir que podríamos querer que haya mas de un objeto con la capacidad de ser observable (por ejemplo, un ejercitó podría tener observers en el caso de que se retire, o que gane una batalla, o una muralla podría notificar cuando se quedó sin energía, etc). Entonces, para poder hacer que esta característica pueda ser adquirida por mas de un objeto, vamos a hacer que Observable sea un Trait, y por ahora, como los únicos observables son los defensores, vamos a hacer que el trait Defensor use el trait Observable. Otra línea de pensamiento que me puede llevar a esto es entender que el concepto de observable y el de defensor son abstracciones distintas, y que me interesaría escribir el código respectivo en lugares distintos, más allá de que luego en el ambiente todos los defensores entiendan los mensajes de los observables.
Entonces, en el trait Observable nos queda el método notify, y observers (la colección de observers) como requerido.


        Observable >> notify
            `self observers do: [ :observer | observer value: self ]`


        Ejercito >> recibirDanio: unDanio
            `self energia: self energia - unDanio.`
            `self notify`

Y bueno, esta es la versión final, que pueden encontrar con la implementación completa [acá](utn-ejemplos-de-clase-JuegoEstrategia-st?attredirects=0&d=1).
Patrones de diseño
Durante la clase nombramos varios patrones de diseño, pero sin entrar demasiado en detalle. En la página de [Diseño de Sistemas](http://ddsutn.com.ar/material/apuntes-teoricos) hay un apuntes de patrones de diseño bastante interesantes como para que puedan investigar. También hay catálogos de patrones de diseño como [éste](http://sourcemaking.com/design_patterns).

Algunos que los patrones que vimos son el strategy, y el observer, y después nombramos otros como el Composite, Null Object y Template Method.