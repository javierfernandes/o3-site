[[_TOC_]]


## []()Ejemplo de DSL para Orden de Restaurant

Veamos un ejemplo, arrancando por un problema de dominio. Luego modelamos un programa en objetos que lo resuelve. Finalmente vemos cómo hacerle un DSL para generalizar la solución y poder utilizarla para varios escenarios distintos del dominio.
## []()Dominio
Para eso vamos a usar un dominio simple, un restaurant. Donde el sistema deberá poder tomar la orden de un cliente.
Por ahora la **orden** se refiere a la selección de los siguientes elementos:

* **Entrada:** con platos como 

 * Ensalada Mixta ( $10.50 )
 * Matambrito ( $15 )
 * Vitel Thone ( $16.50)
* **Plato principal:**


 * Milanesa con Papas Fritas ( $22** )**

 * Asado ( $23** )**

 * Ensalada Cesar ( $20** )**

 * Goulash ( $24** )**

* **Bebida:**


 * Gaseosa ( $10** )**

 * Vino ( $8 )
 * Cerveza ( $12 )
 * Agua ( $10 )

Luego de que el usuario selecciona alguna de estas opciones, se le deberá **calcular la cuenta**.

Un detalle importante es que la aplicación deberá **interactuar con el usuario a través de consola**, es decir que no hay una interfaz web, ni una aplicación de escritorio. 
Entonces, al iniciar la aplicación se deberá mostrar un mensaje de bienvenida y consultar al cliente si quiere que se le tome la orden.
En caso afirmativo se pasa a preguntar la selección del usuario para cada **item de la orden**.
Y finalmente se le **presentará al usuario la cuenta**.

Acá un ejemplo de cómo debería ser la interacción con el usuario por consola:



        Bienvenido!
        Puedo tomar su orden ? (s | n)
        s
        Entrada ? 
        (1) Ensalada Mixta $10.50
        (2) Matambrito $15
        (3) Vitel Tone $16.50
        1
        Plato ? 
        (1) Milanesa c/fritas $22
        (2) Asado $23
        (3) Ensalada Cesar $20
        (4) Goulash $24
        2
        Bebida ? 
        (1) Gaseosa $10
        (2) Vino $8
        (3) Cerveza $12
        (4) Agua $10
        2
        Calculando cuenta...
        41.50


## []()Primer Solución Imperativa

Como primer solución podemos pensar en un programa imperativo en Java, que va presentando la información por consola específica a cada paso y tomando las entradas del usuario.
Acá apenas una parte del programa:
Vemos una primer versión expresando el problema a través de utilizar un API cruda.
Ver **uqbar.dsl.restaurant.basicoapi.RestaurantBasicoApi**



 
        **public void** run() {
             reader = **new** BufferedReader(**new** InputStreamReader(System.in));


             // bienvenida
             System.out.println("Bienvenido!");


             // tomar su oden ?
             String input = **null**;
             **while** (input == **null**) {
                 System.out.println("Puedo tomar su orden?");
                 System.out.println("(s | n)");


                 **try** {
                     input = reader.readLine();
                 } **catch** (IOException e) {
                     **throw new** RuntimeException("Error al leer de la consola", e);
                 }
                 **if** (input.equals("n")) {
                     System.out.println("Chau!");
                     System.exit(0);
                 }
                 **else if** (input.equals("s")) {
                     // sigue !
                 }
                 **else** {
                     // escribio fruta, loopeamos de nuevo en el while
                     input = **null**;
                 }
             }


             // Entrada
             ItemRestaurant entrada = null;


             **while** (entrada == null) {
                 System.out.println("Entrada");
                 List<ItemRestaurant> entradas = Restaurant.getInstance().getEntradas();
                 **for** (int i = 0; i < entradas.size(); i++) {
                     ItemRestaurant item = entradas.get(i);
                     System.out.println("(" + i + ") " + item.getDescripcion() + " quot; + item.getPrecio());
 
                 }
                 **int** optionIndex = -1;
                 **try** {
                     input = reader.readLine();
                     optionIndex = Integer.valueOf(input);
                 } **catch** (IOException e) {
                     **throw new** RuntimeException("Error al leer de la consola", e);
                 }
                 **if** (optionIndex > 0 && optionIndex < entradas.size()) {
                     entrada = entradas.get(optionIndex);
                 }
             }
            ...

        } 
Como se ve acá. El dominio queda entremezclado con la lógica imperativa.
Además, si cambia el menu, o la interacción de la aplicación tenemos que reescribir bastante código.
Lo mismo sucede si queremos hacer un programa similar pero con pasos distintos.
Entonces veamos una solución mejor.
## []()Implementación Objetosa en Java (Motor)

Entonces empezamos a generalizar y a modelar con objetos más pequeños las interacciones de la aplicación.
Y así obtenemos un diseño de un "miniframework" o motor.


En este diagrama se pueden ver las clases principales del framework (click para ampliar)



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402153838805/conceptos/dsls/domainspecificlanguage/dsl---ejemplo-restaurante/cli-classes.png?height=215&width=400)
](conceptos-dsls-domainspecificlanguage-dsl---ejemplo-restaurante-cli-classes-png?attredirects=0)


Ahora nuestro programa está separado en varias partes:

* **el framework de CLI** (command-line interface)
* **las clases de dominio:** OrdenDeRestaurant, ItemOrdenRestaurant, Restaurant, etc.
* **main():** que instancia las clases del framework y las vincula con las clases de dominio, según el flujo requerido.





        **public class** RestaurantBasicoApi {


            **public static void** main(String[] args) {
                ListStep<OrdenDeRestaurant> steps = **new** ListStep<OrdenDeRestaurant>();
                steps.addStep(**new** ShowMessageStep<OrdenDeRestaurant>("Bienvenido!"));


                DecisionStep<OrdenDeRestaurant> puedoTomarSuOrdenStep = **new **DecisionStep<OrdenDeRestaurant>("Puedo tomar su orden");


                ListStep<OrdenDeRestaurant> tomarOrdenSteps = **new** ListStep<OrdenDeRestaurant>();
                tomarOrdenSteps.addStep(**new** SelectStep<OrdenDeRestaurant>("entrada", "Entrada", Restaurant.getInstance().getEntradas()));
                tomarOrdenSteps.addStep(**new** SelectStep<OrdenDeRestaurant>("plato", "Plato", Restaurant.getInstance().getPlatos()));
                tomarOrdenSteps.addStep(**new** SelectStep<OrdenDeRestaurant>("bebida", "Bebidas", Restaurant.getInstance().getBebidas()));
                tomarOrdenSteps.addStep(**new** InvokeMethodStep("ordenar", "Calculando cuenta..."));
                tomarOrdenSteps.addStep(**new** ShowPropertyStep("cuenta"));


                puedoTomarSuOrdenStep.addOption("s", tomarOrdenSteps);
                puedoTomarSuOrdenStep.addOption("n", **new** ExitStep("Chau!"));
                steps.addStep(puedoTomarSuOrdenStep);


                steps.execute(**new** OrdenDeRestaurant());
            }


        }



Como vemos, esta solución es mucho mejor que la anterior.
El código más bien "configura" un conjunto de objetos, para declarar el "QUÉ",  pero no realiza comportamiento como leer o escribir en consola (el CÓMO).


Separamos la lógica general, de este caso particular. Construimos así un "motorcito" que sirve no solo para tomar una receta, sino que es algo más genérico, es como un "frameworkcito para interfaces por consola MVC".


Véase [Programación Declarativa](conceptos-declaratividad) para más teoría al respecto.




Sin embargo, nuestra especificación inicial del dominio queda algo difusa entre tantas lineas de código que son necesarias para usar nuestra API.


Entonces, el frameworkcito está perfecto, me permite reutilizar código, tener extensibilidad (agregando nuevos Step's), tener una separación de modelo (OrdenDeRestaurant) y vista (lógica de prints y reads de consola).


Sin embargo usarlo es dificil, porque necesito:

* Conocer las clases concretas a instanciar
* Crear muchos objetos, configuralos y relacionarlos: la creación se hizo dificil ahora.

Entonces estaría bueno tener, por encima del frameworkcito, un lenguaje que me permita usarlo en forma más **declarativa** y abstrayéndome un poco de la implementación o detalles internos del framework. Es más, del lenguaje Java en sí. Acercarme más a la descripción del dominio inicial.
## []()Internal DSL en Java
Primero vamos a hacer un bosquejo de cómo nos gustaría que se exprese el dominio en un lenguaje **imaginario

**

        CLIBuilder [
                    **show** "Bienvenido!"
                    **decision **

                        "s": [
                              **select** "entrada" **label** "Entrada" **options** Restaurant.getInstance().getEntradas()
                              **select** "plato" **label** "Plato" **options** Restaurant.getInstance().getPlatos()
                              **select** "bebida" **label** "Bebida" **options** Restaurant.getInstance().getBebidas()
                              **invoke** "ordenar" **text** "Calculando cuenta..."
                              **show property** "cuenta"
                        ]
                        "n": **exit** "Chau!"
                ]
Como (espero) se pueda apreciar en este nuevo pseudo código, se ve una correspondencia bastante alta entre él y la descripción del dominio del problema.
Sin embargo, no se puede expresar de esta forma en el lenguaje java, así que vamos a tratar de ver cómo simulamos lo mejor posible ese lenguaje a través de las construcciones que tenemos en java (clases, métodos, parámetros, valores de retorno, etc.)

Aquí un ejemplo:


            CLIBuilder.builder(**list**()
        .with(**show**("Bienvenido!"))
        .with(**decision**("Puedo tomar su orden")
            .**option**("s", **list**()
                  .with(**select**("entrada", "Entrada", Restaurant.getInstance().getEntradas()))
                  .with(**select**("plato", "Plato", Restaurant.getInstance().getPlatos()))
                  .with(**select**("bebida", "Bebida", Restaurant.getInstance().getBebidas()))
                  .with(**invoke**("ordenar", "Calculando cuenta..."))
                  .with(**showProperty**("cuenta"))
            )
            .**option**("n", **exit**("Chau!"))
        )
    )
    .run(new OrdenDeRestaurant());
Como verán es bastante parecido al bosquejo, sin embargo con muchísimo más de ruido con los símbolos de java, como paréntesis, e invocaciones a métodos.

Esto es lo que se llama un **internal DSL.**

Es decir, creamos un lenguaje, que viene dado por la clase del builder, los builders intermedios de cada step y sus métodos.
Sin embargo, lo hicimos parados sobre un lenguaje GPL ya existente, en este caso Java.
Por esto es que se llama **interno**.
En nuestro caso es un DSL donde el "dominio" es "hacer interfaces por consola". Ojo porque no es un dsl para el negocio particular del restaurant.


## []()DSL en XTend

A diferencia de Java, XTend es un lenguaje mucho más amigable para hacer DSL's internos. Por varios motivos:

* Todo es una expresión (con lo cual puedo componer llamados y usos de expresiones)
* Tiene bloques ! Puedo pasar pedacitos de código por parámetro.
* Tiene inferencia de tipo
* Tiene muchos elementos opcionales (paréntesis, punto y coma, etc)
* Tiene sobrecarga de operadores (lo cual sirve para acortar las keywords del lenguaje)
* Tiene extension methods, lo cual nos permite agregarle mensajes a Strings y clases ya existenes, acercándose a la prosa.

Un ejemplo (que por ahora considero sirve, pero no es el ideal) es:





        **val** p = OrdenDeRestaurant.cli(
 `"Bienvenido".message,`
 
 `"Puedo tomar su orden" ?: #[`
 `"s" -> #[`
 `"Plato".select("plato").from[ Restaurant.getInstance().getEntradas() ],`
 `"Bebida".select("bebida").from[ Restaurant.getInstance().getEntradas() ],`
 `"Calculando cuenta...".invoke[ OrdenDeRestaurant o | o.ordenar ],`
 `"cuenta".show`
 `],`
 `"n" -> "Chau".exit`
 `]`
        )
 
        p.execute(**new** OrdenDeRestaurant)
## []()DSL en XML
El XML (Structured Markup Language) es en realidad un "metalenguaje", ya que solo define parte de la sintáxis de un lenguaje, por ejemplo:

* las unidades composicionales son los tags o etiquetas.
* Un tag puede tener 0 a N tags dentro.
* Un tag puede tener diferentes "atributos"
* Un documento XML tiene que tener un único tag raíz.
* Un tag puede o no tener contenido.
* Un tag siempre tiene que estar terminado

Sin embargo no especifica el **contenido** de los tags o atributos. Con lo cual no define una semántica o significado.
Cada uno puede definir su propio tipo de documento XML, donde sí especificará esos nombres de tags, y las relaciones, por ejemplo qué atributos puede tener el tag "cliente", y cardinalidad de elementos, etc.

Por otro lado el XML no es un lenguaje de programación. No es un lenguaje "imperativo", ya que no tenemos posibilidad de definir y asignar variables. Es por tanto un lenguaje declarativo. 


Eso lo hace un buen candidato para escribir un DSL para, por ejemplo, configuraciones de aplicaciones, o problemas específicos donde no se requiera gran nivel de expresividad de lógica compleja.

Acá vemos un supuesto DSL para nuestro ejemplo del restaurant, utilizando XML




        <flow>
            <show message=**"Bienvenido!"**/>
            <decision **"Puedo tomar su orden?"**>
                <on option=**"s"**>
            `    ``    ``    ``<select property=**"entrada"** label=**"Entrada"** options=**"beanshell:Restaurant.getInstance().getEntradas()"** />`
            `    ``    ``    ``<select property=**"plato"** label=**"Plato"** options=**"beanshell:Restaurant.getInstance().getPlatos()"** />`
            `    ``    ``    ``<select property=**"bebida"** label=**"Bebida"** options=**"beanshell:Restaurant.getInstance().getBebidas()"** />`
                        <invoke method=**"ordenar"** text=**"Calculando cuenta..."** />
                        <show property=**"cuenta"** />
                </on>
            `    ``<on option=**"n"**>`
                    <exit message=**"Adios!"**` />`
                </on>
            </decision>
        </flow>
 // TODO: mencionar el problema de cómo especificar la lista de opciones de la selección, y comportamientos custom (interacción con código java).
Al estar fuera del lenguaje