---
title: "conceptos-multiple-dispatch-dispatch-basado-en-valor"
date: 2018-09-01T18:42:46-03:00
---


## Dispatch Por Valor

Como vimos en la página relativa a Múltiple Dispatch, existen variantes al dispatch tradicional que permite el polimorfismo en base al receptor.

Una variante interesante implementada de Nice, es el **dispatch por valor**.
Se refiere a la **capacidad de hacer dispatching no solo por el tipo de los argumentos en runtime, sino también, por sus valores**.


Esto es algo muy común en lenguajes funcionales.

Ejemplo:

```scala
digitToString(digit, language) `
  throw new Exception("Couldn't convert "digit" to language "language);
}

digitToString(1, "english") = "one";
digitToString(2, "english") = "two";
digitToString(3, "english") = "three";

digitToString(1, "french") = "un";
digitToString(2, "french") = "deux";
digitToString(3, "french") = "trois";
```

Como verán en este ejemplo, *la declaración de los parámetros tiene valores, y no tipos*. Nice soporta este feature solo en forma acotada a los tipos básicos y no a objetos complejos. Aunque sería más que interesante, pensar en un lenguaje con soporte para expresarlo para objetos complejos.

## Relación con pattern matching

Los lenguajes funcionales hacen uso extensivamente de esta idea.
Ya que para una función podemos definir en realidad varias implementaciones, dependiendo de patrones sobre los parámetros de entrada. El famoso "pattern matching".
Por ejemplo en Haskell:

```haskell
lucky :: (Integral a) => a -> String  
lucky 7 = "LUCKY NUMBER SEVEN!"  
lucky x = "Sorry, you're out of luck, pal!"  
```

(ejemplo tomado de [acá](http://learnyouahaskell.com/syntax-in-functions))
Vemos que se define una "variante" de la función "lucky" si el parámetro de entrada es el valor 7.
