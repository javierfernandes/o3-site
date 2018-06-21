### []()SQL
Structured-Query Language, conocido por todos, es un lenguaje sumamente poderoso para **consultas sobre base de datos relacionales**.
Es un lenguaje **"declarativo"**, en el sentido de que no le indicamos el **como** hacer la consulta, **sino el qué** queremos.

Ejemplo:

**            SELECT** ID, CIUDAD, PROVINCIA **FROM** ESTACION **WHERE** LATITUD** >** 39.7;

Algunas cosas para notar:

* No se puede construir una aplicación **solo con SQL** !
* Los **conceptos** del lenguaje son exclusivamente **de consulta**


 * SELECT, INSERT, UPDATE
 * FROM WHERE, 

 * ORDER BY, GROUP BY
 * SUM
 * etc.

* Y la **sintaxis** fue pensada **específicamente** **para** expresar **consultas**.


## []()Implementación en GPL's

Cómo implementaríamos esto en en un lenguaje imperativo ?
### []()En Java:






           Select<Estacion> select = **`new`**` Select<Estacion>();`


           List<String> projection = new ArrayList<String>();
           project.add("id");
           project.add("ciudad");
           project.add("provincia");


           select.setProject(projection);


           select.setFrom("estacion");


           Predicate<Estacion> condicion = **`new`**` Predicate<Estacion>() {`


                @Override
                **`public`** **`boolean`**` applies(Estacion e) {`
                    **`return`**` e.getLatitud() > 39.7;`
                }


           };


           select.setWhere(condicion);


           select.execute();


Como se ve necesitamos mucho código, pero ademas aparecen clases específicas:

* Select
* List y ArrayList
* Predice

Se hace dificil (más dificil que en la solución expresada en SQL) leerlo rápidamente y entender qué proyecta (select) y bajo qué condicion (where)
### []()DSL en Xtend (lenguaje sintácticamente más rico)

En un lenguaje más piola como XTend, usando:

* literales de listas #[ ... ]
* inferencia de tipos val a = ...
* setters automáticos ( a.setB(unB) =>  a.b = unB)
* y lo más importante, bloques !





           **val** select = **new** Select<Estacion>()
           select.project = #[ "id", "ciudad", "provincia" ]
           select.from = "estacion"
           select.where [ latitud > 39.7]
           select.execute()

Podría hacerse más conciso con:

* el operador **with**

* evitando paréntesis



        
  (**new** Select => [
               project = #[ "id", "ciudad", "provincia" ]
               from = "estacion"
               where [ latitud > 39.7 ]
           ]).execute
        



Usando un factory method con varargs, select(String...)




        
   (select("id", "ciudad", "provincia") => [
               from = "estacion"
               where [ Estacion e | e.latitud > 39.7]
           ]).execute
        



Si agregamos extension métodos, podemos llamar el select sobre la clase de dominio.
Además, podemos usar pequeños bloquecitos para expresar cada propiedad a seleccionar. Así tenemos checkeos en tiempo de compilación:





        Estacion.select( [id], [ciudad], [provincia] ) => [
 `where = [ latitud > 39.7]`
        ]
Además, se infiere el "from" en base a la clase Estacion.


Por último, podríamos utilizar la capacidad de XTend de redefinir operadores, para pasar a una sintaxis más orientada a símbolos que a palabras:

        (Estacion >>> [id] > [ciudad] > [provincia]) 
 `?: [ latitud > 39.7]`
Se lee como "De Estacion me quedo con las propiedades: id, ciudad y provincias, de los que cumplan que latitud > 39.7"
### []()DSL en Scala usando tipos estructurales

Muy bueno el DSL en xtend, pero carece de información de tipos sobre la respuesta de una proyección.
Por ejemplo en el caso en que hacemos select, no para traernos todo un objeto completo (instancia de una clase) sino sólo ciertos datos, no tengo forma de hacer eso en xtend más que caer en que el método me retorne una List<Collection<?>>.


Es decir:



        var resultados = Estacion.select( [id], [ciudad], [provincia] ) => [
 `where = [ latitud > 39.7]`
        ]
        println(resultados)
        

Donde eso imprime algo así:


        [ 
            [23, "Campana", "Buenos Aires"],
            [56, "Rio Cuarto", "Cordoba],
            [590, "Gualeguaychú", "Entre Ríos"] 
        ]


Sin embargo el tipo de "resultados" es List<Collection<?>>, ya que por cada "Estación" nos trajo un conjunto "suelto" de fields.


En Scala en cambio, podemos usar los tipos estructurales (no nominales o "duck typing") para definir un tipo. Al momento de armar la proyección (decir qué cosas queremos), lo decimos con un nuevo tipo estructural. Y de ese tipo serán los resultados.





        **var** resultados = project[{
                    **def** id: Int
                    **def** ciudad: String
                    **def** provincia : String

               }] {
            estaciones select { e =>
                e latitud > 39.7
            }
        }
        



Nótese que el método project recibe un tipo paramétrico entre corchetes, y luego un bloque que sería como nuestro "where".





        **class** Relation[+T] {
            **def** project[U >: T]): Relation[U]
            ...
        }


Nosotros le pasamos un nuevo tipo estructural que define: "algo que tenga id, ciudad y provincia" (con sus respectivos tipos.
Entonces el tipo de resultado va a ser en nuestro caso:



        List< { def id:Int ; def ciudad:String ; def provincia:String }>


Es decir una lista de esos objetos.
Así luego podemos iterar y tener checkeos



        resultados forEach { e => println(e.id + " " + e.ciudad + "(" + e.provincia + ")" }


Ejemplo basado en [éste paper](http://gilles.dubochet.ch/publications/2011_dubochet_phd.pdf)
### []()DSL Interno

Comparemos la cantidad de líneas de código y elementos "Extra" en la primer solución en java, respecto de estas últimas en XTend !
Todas estas variantes que vimos en XTend, son lo que se llaman "DSL's internos". Éste es un lenguaje especiamente diseñado para un dominio en particular (consultas en nuestro caso), pero utilizando un lenguaje GPL ya existente. De alguna forma "tuneamos" o forzamos un poquito el lenguaje "anfitrion", en este case XTend para llevarlo a que se parezca a un lenguaje "humano", más cercano al del dominio.
Obviamente, dependiendo de la potencia del lenguaje anfitrion vamos a poder implementar un mejor DSL.
En Java por ejemplo, es bastante limitado lo que podemos hacer.
### []()Comparaciones

Comparamos:

* qué pasa si tengo varias condiciones, o varias tablas ?
* empezar a imaginar la forma de interactuar con mis objetos como si fuera un **lenguaje** me permite:

 * **pensar en como combinar los diferentes conceptos de mi dominio**.
 * un API dificulta las combinaciones más complejas (a veces necesito introducir composites, strategies, lambdas, etc).
 * el DSL permite concentrarse en los conceptos y combinarlos fácilmente en forma más RICA.