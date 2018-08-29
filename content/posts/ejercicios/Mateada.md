---
title: "Ejercicio: Mateada"
date: 2018-08-29T11:43:50-03:00
toc: true
---

# Enunciado

El enunciado del ejercicio está [acá](https://docs.google.com/document/d/1sy1rxT6oJg_CiCncDNzJFSjdHttGwIRsMkXb-XYK55E/)

# Resoluciones

La primer solución que surgió en clase, contemplando el enunciado justo HASTA que aparezcan los personajes especiales, es decir
sólo modelando al `Mateador` por defecto que toma, o pasa, sin hacer ningún truco, fue esta

## 3 empanadas (1 foreach)

```scala
class Cebador() {
  def iniciarPasada(mateadores: List[Mateador]) = {
    mateadores.foreach { m => m.recibirMate() }
  }
}
class Mateador {
  var matesTomadosEnPasada = 0
  def recibirMate() {
    matesTomadosEnPasada += 1
  }
}
```

Y los tests

```scala
import org.scalatest.{ FunSpec, Matchers }

class MateadaSpec extends FunSpec with Matchers {

  describe("pasada de mate") {

    it("en una ronda de 1 solo mateador toma") {
      val mateador = new Mateador()
      new Cebador().iniciarPasada(List(mateador))
      mateador.matesTomadosEnPasada should equal(1)
    }

    it("en una ronda de 2 mateadores, toman ambos, 1 unica vez") {
      val mateadores = List(new Mateador, new Mateador)
      new Cebador().iniciarPasada(mateadores)
      mateadores.forall { m => m.matesTomadosEnPasada == 1 } should equal(true)
    }
  }
}
```

Nos dimos cuenta que el `foreach` era suficiente, ya que cumplía con la idea de darle la oportunidad de tomar
una única vez a cada participante, y, a todos.
Esto nos evitaba resolver el problema de cómo saber si un Mateador ya tomó en la pasada o no.
Es que la "pasada" la modelamos como una recorrida de la lista con foreach

## Yo soy 'cola', tu pegamento (refTo monkey island)

Cuando ibamos a agregar los roles nos dimos cuenta que varios `Mateadores` necesitaban intervenir cuando el mate le tocaba a otro, para tomar ellos. Es decir que necesitábamos darle el "control del flujo" a los mateadores, o al menos poder intervenir en él.
Eso al final es lo que pasa en la realidad cuando pasamos algo por una "ronda"
En la solución anterior, si quieren verlo así lo que hacíamos era que el `Cebador` le diera el mate "directo" al que le correspondía. Tenía mucho más control.

Entonces se nos ocurrieron 2 opciones:

1. que cada mateador conociera al siguiente, de modo de poder delegarle el mate si el no va a tomar
2. cambiar el mensaje `recibirMate(mate)` de modo de que cada mateador reciba un objeto que le permita "continuar" la cadena.

Ese nuevo objeto en principio fue la lista de "mateadores a su derecha". Es decir, el resto, o "cola" de la lista.

La solución queda:

```scala
class Mate(mateadores : List[Mateador]) {
  var cebado = false
  // por qué usamos un Set ?
  var tomaronEnPasada = Set[Mateador]() 

  def cebar(): Unit = {
    cebado = true
  }
  def teTome(mateador : Mateador) : Unit = {
    tomaronEnPasada  = tomaronEnPasada + mateador
    cebado = false
  }
  def todosYaTomaron() = tomaronEnPasada.size == mateadores.size
  def tomeEnEstaPasada(mateador : Mateador) = tomaronEnPasada.contains(mateador)
}

class Cebador() {
  def iniciarPasada(mateadores: List[Mateador]) = {
    // por qué el mate necesita conocer a los mateadores
    var mate = new Mate(mateadores)
    while(!mate.todosYaTomaron()) {
      mate = mateadores.head.recibirMate(mate, mateadores.tail)
      mate.cebar()
    }
  }
}

class Mateador {
  var matesTomadosEnPasada = 0

  def recibirMate(mate: Mate, siguientes : List[Mateador]) : Mate = {
    matesTomadosEnPasada += 1;

    return if (mate.tomeEnEstaPasada(this)) {
      if (siguientes.isEmpty)
        mate
      else
        siguientes.head.recibirMate(mate, siguientes.tail)
    } else {
      mate.teTome(this)
      mate
    }
  }

}
```

Dejamos un par de preguntas en el código como comentario, ya que fueron "microdecisiones" que tuvimos que tomar durante la implementación.

### Chain Of Responsibility

Luego planteamos que usar una `List[Mateador]`, es decir una clase de Scala, es un poco limitando, o "bajo nivel", y si bien es "poderoso" porque permite a la impl de `Mateador`, acceder en forma cruda a la ronda, y por ejemplo poder saltear, etc.. también nos fuerza a repetir en cada impl el partir la lista en head y `siguientes.tail`. Es decir hacer el forwarding cada vez.

```scala
siguientes.head.recibirMate(mate, siguientes.tail)
```

Incluso, una cosa que no marcamos en clase es que hay una DUPLICACION. El `Cebador` que es quien arranca la pasada, también hace algo muy parecido

```scala
mate = mateadores.head.recibirMate(mate, mateadores.tail)
```

Y por último, cada `Mateador` hoy día también tiene que controlar si la lista que sigue está vacía, lo cual lo hace bastante molesto. Y podría considerarse parte de la lógica abstract de "forwardear".

Entonces un diseño más "explítico" sería modelar nuestro propio objeto que represente a la cadena.
Vamos a ver primero cómo queda el `Mateador`, que es lo que queremos simplificar.

```scala

class Mateador {
  var matesTomadosEnPasada = 0

  def recibirMate(mate: Mate, cadena: CadenaDeMate) : Mate = {
    matesTomadosEnPasada += 1;

    return if (mate.tomeEnEstaPasada(this)) {
      cadena.pasarMate(mate)
    } else {
      mate.teTome(this)
    }
  }

}
```

Como vemos queda mucho más sencillo, porque se abstrae de la propagación. Hace simplemente `cadena.pasarMate(mate`. Esto sigue permitiendo al tipo cambiar el mate (como requieren ciertos roles)

También simplificamos al `Cebador` y evitamos la duplicación. Este crea la cadena y le dice "arrancá"

```scala
class Cebador() {
  def iniciarPasada(mateadores: List[Mateador]) = {
    var mate = new Mate(mateadores)  // por qué el mate necesita conocer a los mateadores
    val cadena = new CadenaDeMate(mateadores)
    while(!mate.todosYaTomaron()) {
      mate.cebar()
      mate = cadena.pasarMate(mate)
    }
  }
}
```

Finalmente la impl de `CadenaDeMate` (que si entendimos como se usa y para qué sirve, es simplemente cuestión de impl)

```scala
class CadenaDeMate(mateadores: List[Mateador]) {
  var _restantes = mateadores

  def pasarMate(mate: Mate) : Mate = {
    if (_restantes.isEmpty) {
      return mate
    }
    val proximo :: otros = _restantes
    _restantes = otros
    return proximo.recibirMate(mate, this)
  }
}
```

Los tests debería continuar verde.

## Implementación de Personajes

```scala
// TODO
```
