### []()Repaso de la [Clase 1](unq-clases-2012c2-clase-1)
La clase pasada establecimos la diferencia entre clase y tipo. Las clases nos permiten definir todo el comportamiento de un objeto: qué mensajes entiende, cómo reacciona frente a esos mensajes (a partir de métodos) y el estado interno de los objetos. El tipo sólo se refiere a lo que puedo hacer con el objeto, específicamente qué mensajes entiende. En muchos lenguajes, las clases definen tipos y eso puede llevar a confundir los conceptos. En Java hay dos formas de definir un tipo, a partir de una clase o a partir de una ***interface***.


También mencionamos las ideas de ***subtipado*** y **subsumption***, *dos ideas son fundamentales para la programación con objetos y estarán presentes en todos los sistemas de tipos que vamos a utilizar. La regla de subsumption permite que un objeto con un tipo más específico sea utilizado en un lugar donde se requiere un supertipo. Por este motivo, podemos decir que *un objeto tiene muchos tipos*. También mencionamos que al subsumir un objeto en un tipo más general conlleva una pérdida de información: en el contexto en el que el objeto es visto con el tipo general, algunos mensajes no estarán disponibles.


### []()Sistemas de tipos


Un sistema de tipos puede tener muchas utilidades. En esta materia nos vamos a concentrar en su capacidad para **detectar errores de programación**. [En este link](http://uqbar-wiki.org/index.php?title=Esquemas_de_Tipado#Sistemas_de_tipos) pueden encontrar información sobre otros usos del sistema de tipos. 


Los sistemas de tipos despiertan controversias y fanatismos. Existen los que cinchan a favor del chequeo estático de tipos y de su utilidad como herramienta para asegurar la correctitud de un programa y los que los consideran una herramienta burocrática que se interpone permanentemente a la hora de construir programas. 
Nuestro objetivo no es hacer un estudio pormenorizado de la teoría de tipos (que podría se una materia entera), pero sí formalizar algunos conceptos básicos y conocer algunas variantes en los sistemas de tipos.


El conocimiento informal de la idea de tipos lleva a la existencia de muchos mitos y confusiones. Posiblemente esto se debe a gran cantidad de literatura que se basa en el conocimiento de un único lenguaje, y no en un estudio teórico del tema. En criollo: no todos los sistemas de tipos son tan rígidos y burocráticos como el de Java.
A modo de ejemplo, otro mito afirma que la precedencia de operadores es incompatible con un lenguaje sin chequeo estático de tipos (o incluso con la idea de objeto-mensaje).


En ambientes informales se pueden escuchar muchos términos que resultan contradictorios o vagamente definidos, como lenguajes dinámicos, lenguajes tipados y no tipados, tipado fuerte y débil, lenguajes dinámicamente tipados, etc. 
### []()Categorización de los sistemas de tipos

Para ordenar mejor los diferentes esquemas de tipado que se utilizan en lenguajes orientados a objetos, vamos a establecer las siguientes categorías:

* Según el momento en el que se realiza el chequeo de tipos: **estático, dinámico o inexistente (no tipado)**.
* Según la forma en que se determina el tipo de una expresión o de una variable, el tipado puede ser **explícito o implícito**.
* Según la forma en que se establece la relación entre un objeto y su tipo, así como las relaciones de subtipado, el tipado puede ser **estructural o nominal**.

Los detalles sobre estas ideas los pueden encontrar en la página de [Sistemas de tipos](conceptos-tipos-binding-sistemas-de-tipos).