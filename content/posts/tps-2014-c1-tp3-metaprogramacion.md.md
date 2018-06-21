## []()Aclaraciones iniciales
En este TP vamos a desarrollar una librería o framework, es decir, una herramienta reutilizable independiente del dominio. El objetivo es que esa herramienta pueda ser utilizada en muchos dominios. Por eso es importante que el código específico de la herramienta no tenga relaciones con el dominio. 


Todos los dominios que se citan a continuación son sólo ejemplos. Pueden utilizar los ejemplos para probar su herramienta, pero la herramienta no puede ser dependiente del ejemplo.


Por eso su entrega debe consistir de tres partes:

* Código específico de la herramienta
* Un dominio que se utilizará para las pruebas
* Tests

## []()Requerimientos

### []()1 - Trait GenericEquals


Programar un traits de nombre `GenericEquals` con los siguientes métodos:
* Requiere el método `#keyProperties`, esperando que le entregen una lista de Strings, que representan un conjunto de nombres de variables de instancia.
* Provee el método `#=`, que tomando la lista de variables de `#keyProperties` determina si el objeto receptor es igual al recibido por parámetro.



Por ejemplo usado en la clase Soldado, definida así:




        Object subclass: #Soldado
           uses: GenericEquals
           instVarNames: 'posicion puntosDeVida'
           ...


y el método 




        >> keyProperties
           ^ #(puntosDeVida)


La siguiente porción de código debería evaluarse como verdadera:




        a := Soldado new posicion: 100@100; puntosDeVida: 100.
        b := Soldado new Posicion: 200@200; puntosDeVida: 100.
        a = b.


En cambio, si modificamos el método #keyProperties de la siguiente manera:

        




        >> keyProperties
           ^ #(posicion puntosDeVida)


La misma porción de código se evaluaría como falsa, dado que los dos Soldados tienen la misma cantidad de puntosDeVida pero no la misma posición.

### []()2 - Trait GenericPrint

Siguiendo el mismo esquema del ejercicio anterior, programar el trait `GenericToString`, con los métodos:

* Requiere `#keyProperties`
* Provee el `#printOn:` basándose en `#keyProperties`


Luego la siguiente porción de código:





        Soldado new posicion: 100@100; puntosDeVida: 100.



Al evaluarse deberían imprimir `Soldado(posicion = 100@100, puntosDeVida: 100)`, considerando la segunda versión de #keyProperties.
### []()3 - Refactor SimpleRenameProperty

Programar la clase RenameProperty que sea capaz de renombrar una variable de instancia y sus accessors consistentemente.


Por ejemplo si nuestra clase soldado tiene además de la variable `posicion` dos métodos:




        >> posicion
           ^ posicion


        >> posicion: nuevaPosicion
           posicion := nuevaPosicion


Se busca que renombre tanto la variable de instancia como los dos métodos `posicion` y `posicion:`.


**Nota: **Para simplificar, podemos considerar que ni la variable ni los métodos tienen referencias y por lo tanto con que el rename sea consistente es suficiente y no es necesario mirar dentro del código.


## []()Requerimientos Bonus

### []()1 - Refactor FullRenameProperty

Al refactor anterior agregarle la capacidad de buscar referencias a la variable y a los métodos renombrados, acotándolo al package.


### []()2 - Interfaz de usuario

Implementar alguno de los refactors de RenameProperty dentro del Refactoring Browser