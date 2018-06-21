---
title: "unq-clases-2012c2-clase-3"
date:  2018-06-20T19:27:10-03:00
---


### []()Introducción
En la clase de hoy arrancamos comparando los modelos de herencia simple y múltiple, analizando las ventajas y desventajas de cada uno. Para tratar de tomar lo mejor de ambos mundos aparecen dos modelos alternativos denominados [traits](conceptos-traits) y [mixins](conceptos-mixins). 



Para analizarlos vimos ejemplos de traits en Pharo y de mixins en Scala. (Cabe recordar que si bien Scala utiliza la palabra **trait**, conceptualmente son mixins).



### []()Traits vs. Mixins

Marcamos dos diferencias importantes entre ambos conceptos:

* En primer lugar, utilizan diferentes estrategias para la **resolución de conflictos**. Los traits proponen una **resolución explícita**, a cargo del programador y basada en las operaciones de suma, exclusión y *aliasing*. Los mixins en cambio utilizan una **resolución implícita** basada en el orden de composición.
* En segundo lugar, se diferencian por la **forma de composición**. Los traits utilizan un mecanismo denominado **flattening**, que permite que un método provisto por un trait tenga exáctamente el mismo efecto que si el código estuviera en la clase que lo usa. Los mixins por su lado utilizan otro mecanismo, denominado **linearization**, que define un *orden total* entre los mixins y superclases, permitiendo que todos participen del method lookup. Dicho de otra manera los traits no existen en runtime mientras que los mixins sí.

Si bien estas diferencias parecen sutiles, llevan a que los mixins y traits tengan diferentes interpretaciones en cuanto a lo que representan. Podemos ver a un trait como un *conjunto de métodos reutilizable,* mientras que un mixin se interpreta mejor como *una clase cuya superclase no está definida aún*. 


Es un error común suponer que la diferencia entre traits y mixins pasa por la capacidad para definir variables, ya que las definiciones más populares de traits no lo permiten. Sin embargo existen desarrollos de [traits con estado](http://scg.unibe.ch/archive/papers/Berg07aStatefulTraits.pdf).


Entre las implementaciones que elegimos también aparece otra diferencia interesante que es la posibilidad de aplicar un mixin directamente sobre un objeto al instanciarlo, cosa que Scala permite y Pharo no. Sin embargo eso depende mucho del lenguaje y para ambos conceptos existen tanto lenguajes que permiten la aplicación sobre una instancia como los que no. (En este sentido es interesante leer sobre [Talents](http://scg.unibe.ch/research/bifrost/talents).)
### []()Diseño con traits y/o mixins

Las interpretaciones que se hace de las herramientas lleva a diferentes estrategias para diseñar utilizando traits o mixins, citamos algunas ideas:

* Las visiones más arraigadas al diseño tradicional suponen priorizar las herramientas clásicas (clases y herencia simple) y utilizar traits o mixins sólo para evitar la repetición de código en los casos en los que la herencia simple resulta insuficiente.
* Otras visiones proponen utilizar los traits y mixins para modelar conceptos que puedan ser aplicados a distintas clases.
* En en [paper seminal de traits](http://scg.unibe.ch/archive/phd/schaerli-phd.pdf), Shaerli y Ducasse proponen poner todo el código de la aplicación en traits y utilizar las clases sólo para definir variables de instancia y *glue code.*

### []()Material de lectura 


Las lecturas más importantes son:
* [](conceptos-traits)[Traits](conceptos-traits)
* [Mixins](conceptos-mixins)

* [Paper seminal de traits](http://scg.unibe.ch/archive/phd/schaerli-phd.pdf), de Nathaniel Shaerli y Stéphane Ducasse
* [Paper seminal de Mixin-Based Inheritance](http://www.st.informatik.tu-darmstadt.de:8080/lehre/ss02/aose/Papiere/Thema1/flatt98classe.pdf), por Bracha y Cook.



Otras lecturas interesantes:
* [Otra definición de Mixins](http://www.st.informatik.tu-darmstadt.de:8080/lehre/ss02/aose/Papiere/Thema1/flatt98classe.pdf), de .Flatt, Krishnamurthi y Felleisen
* Paper de [traits con estado](http://scg.unibe.ch/archive/papers/Berg07aStatefulTraits.pdf) de Bergel, Ducasse, Nierstrasz y Wuyts.
* Una discusión sobre  [Composición vs. Mixins](http://stackoverflow.com/questions/3422606/mixins-vs-composition-in-scala)
* Otra discusión: [Traits vs Aspectos](http://blog.objectmentor.com/articles/2008/09/27/traits-vs-aspects-in-scala)
* Un antecedente a los mixins: [Flavors, de David Moon](http://dl.acm.org/citation.cfm?id=28698) (ese paper lamentablemente no se puede conseguir online gratuitamente, pero acá hay [otra publicación de David Moon sobre Flavors](ftp:-publications-ai-mit-edu-ai-publications-pdf-AIM-602-pdf)).
* Una extensión a la idea de traits: [Talents](http://scg.unibe.ch/research/bifrost/talents)

### []()Ejemplos


* En [http://xp-dev.com/svn/uqbar/examples/paco/trunk/traits](http://xp-dev.com/svn/uqbar/examples/paco/trunk/traits) hay ejemplos en Scala y en Pharo.