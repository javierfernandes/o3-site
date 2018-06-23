---
title: "conceptos-tipos-binding-repaso-objetos--smalltalk"
date:  2018-06-20T19:27:10-03:00
---


// **TODO:** refactorizar, esto lo tomamos de la bitácora del primer curso. Desacoplar de la clase y convertir en apunte teórico.


### Ambiente de Objetos
Básicamente todo es un objeto, y que existe el concepto de **"ambiente de ejecución"**, como una especie de mundo donde viven nuestros objetos todo el tiempo, que se persiste (perdura a lo largo del tiempo, luego de "cerrar" y volver a abrir el pharo).
Dimos mucha importancia a esta idea de **ambiente "vivo"**, que nos permite inspeccionar en cualquier momento el estado de los objetos, e interactuar con ellos.
Esto es importante, porque **rompe la idea de fases o ciclo de desarrollo tradicionales** que existe en lenguajes que provienen de la rama de ALGOL, como C, C++, java, etc, donde existe las fases de: escritura de código, compilación, empaquetado y ejecución.

Esto convierte al programador en un usuario más del ambiente, en la misma forma en que el usuario final también interactúa con los objetos (indirectamente a través de una UI, etc.).

Uno de los ambientes de objetos más fieles a esta teoría es el de [Pharo Smalltalk](te-smalltalk).

## Material

[Presentación](conceptos-tipos-binding) 

### 