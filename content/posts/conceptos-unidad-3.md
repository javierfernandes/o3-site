---
title: "conceptos-unidad-3"
date:  2018-06-20T19:27:10-03:00
---


***Duración:*** 2 clases

Ideas prácticas

* Metaprogramación y reflection.

 * no es posible asegurar:

  * todos los programas que andan pasaron por el sist. de tipos
  * no todos los programas que no andan no pasan por el sist. de tipos.
  * circulos
(andan  ( tipan y funcionan )   tipan)

* También podemos mostrar metaprogramacion en self

 * addSlot, removeSlot, decorateSlot
 * más heavy mover todos los slots de un objeto a uno nuevo, poner a ese nuevo como parent del original... eso nos da un lugar donde "sobreescribir" los slots que quieras, como un decorator.
* [Mirrors](conceptos-mirrors)
* Otra cosa que se podría dar es metaprogramación en prolog (si lo vieron antes con dodino).