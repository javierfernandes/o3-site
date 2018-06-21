* [TP3 - DSLs](tp-dsl-externo-planificacion-de-conferencia)

### []()Aclaraciones TP1 - Mixines
El enunciado está en la sección de archivos, nombre TP1-CENSO-ECONOMICO.PDF.

* Nota del 21/08/14: OJO, por ahora subimos solamente la parte 1 del enunciado. El resto, próximamente.
* Nota del 24/08/14: Recién subí la versión 4 del enunciado, con algunos cambios menores adicionales, que apuntan sobre todo a aclarar qué forma tiene que tener el objeto que responda a los items a) a i). 
Sigue estando la parte 1, nada más.

Algunos tips para la parte 1. Hay ejemplos de estos comentarios en el fuente Animal.scala.

* Al pasarle parametros a una clase, pónganles val o var, una de las dos. Si no se le pone ni var ni val compila, pero al implementar el TP tuve problemas, creo que porque los declara protected, aunque no estoy seguro.
* Si al declarar una subclase, se incluye un parámetro de la clase que viene heredado, la propiedad de ser val o var se hereda, no hace falta ponerlo de nuevo en la subclase. El valor por defecto no se hereda, ese hay que repetirlo.
P.ej., en la clase Perro en el Animal.scala, peso es val y nombre es var (pueden probar cambiar el peso de perrito en el test, les va a tirar error). Pero los valores por defecto los tuve que repetir. También se pueden cambiar, como hice en la clase Gato.
* Truco que les puede venir bien para una herencia que conviene tener :D. Si en una clase abstracta incluyen una característica abstracta, para lo cual alcanza con ponerla como def y no poner ninguna definición, entonces en una subclase, ese def se puede redefinir como val o como var.
P.ej. pesoDeLosMusculos está abstracto en Animal, implementado como un val en Perro, y como un método en Gato.
* Int/Int da Int, no da "con coma". Ver los tests.