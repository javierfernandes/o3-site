Arrancamos con java que es la API más nefasta.
Introducimos un modelo de objetos de ejemplo. El de una librería que presta libros.





        **public class** Libro {
          **private** String autor;
  `**private** String titulo;`
  `**private** Cliente cliente;`


  `**public** Libro(String autor, String titulo) {`
  `**this**.autor = autor;`
  `**this**.titulo = titulo;`
  `}`
 
  `**public** String getAutor() {`
  `**return this**.autor;`
  `}`
 
  `**public** String getTitulo() {`
  `**return this**.titulo;`
  `}`
 
  `**public** Cliente getCliente() {`
  `**return** this.cliente;`
  `}`
 
  `**public void** prestarA(Cliente cliente) {`
  `**if** (**this**.cliente != **null**) {`
  `**throw new** LibreriaException("Libro ya prestado a " + this.cliente.getNombre());`
  `}`
  `**this**.cliente = cliente;`
  `}`
 
        }


Como vemos esta clase es bastante simple. Tiene 3 variables de instancia, también llamadas **fields**. Getters para ellas, y un método **prestarA.**

**

**

Ahora veamos cómo desde java, a través del API de reflection podemos sacar mirar esta clase:





        **public static void **main(String[] args) {
          introspect(Libro.**class**, **new** PrintWriter(System.out));
        }


        **private static void** introspect(Class aClass, PrintWriter printer) {
 `printer.println("Un '" + aClass.getSimpleName() + "'");`
 `**for** (Field field : aClass.getDeclaredFields()) {`
 `printer.print("\ttiene ");`
 `printer.print(field.getName());`
 `printer.println(" de tipo " + field.getType().getSimpleName());`
 `}`
 `printer.flush();`
        }


Si ejecutamos este main vamos a ver este resultado:





        Un **Libro**

 `tiene **autor** de tipo **String**`
 `tiene **titulo** de tipo **String**`
 `tiene **cliente** de tipo **Cliente**`


#### **[]()Explicando el ejemplo

Vamos a comentar algunas cositas de este código de ejemplo más bien sencillo:

* El método que utiliza reflection (o que hace introspection) es el introspect(Class, PrintWriter).
* El main() simplemente lo utiliza pasándole una clase para probarlo, pero como recibe un Class, **nótese que el introspect() sirve para cualquier clase!**

* Al hacer **Libro.class **obtenemos un objeto de tipo **Class **que representa a la clase Libro.

 * Este se dice que es un metaobjeto, porque es un objeto que representa a otro del nivel de abstracción "inferior", de nuestro dominio.
 * Es parte del MOP de java, es decir del API de reflection.
* Para cualquier tipo de java (ya sea una clase, clase abstract, interface, annotation, enum, etc) puedo obtener su objeto Class a través de **".class"**

* A partir del objeto Class puedo hacer introspection y acceder a otros objetos que van a estar **reflejando **los diversos componentes de la clase. Por ejemplo: **Field, ****Method, **etc**.**


Ejecutémoslo con otra clase:



        introspect(String.**`class`**`,`` `**`new`**` ``PrintWriter(System.out));`


Resulta en:





        Un **String**

 `tiene **value** de tipo **char**[]`
 `tiene **offset** de tipo **int**`
 `tiene **count** de tipo **int**`
 `tiene **hash** de tipo **int**`
 `tiene **serialVersionUID** de tipo **long**`
 `tiene **serialPersistentFields** de tipo **ObjectStreamField**[]`
 `tiene **CASE_INSENSITIVE_ORDER** de tipo **Comparator**`


Como vemos nuestro código "funciona" con cualquier clase, incluso en este caso lo estamos usando con una clase del propio JDK, String.


Introspection de Instancias
Además de analizar la estructura de las clases, probáblemente lo más útil de introspection es poder trabajar con objetos, es decir, con las instancias de nuestras clases.
Para eso vamos a hacer algo similar al ejemplo anterior, pero con un nuevo método **introspectInstance()**

**

**

**



        **private static void** introspectInstance(Object anObject, PrintWriter printer) **throws** IllegalArgumentException,  llegalAccessException {


 `Class objectType = anObject.getClass();`
 `printer.println("Un " + objectType.getSimpleName() + "");`
 `**for **(Field field : objectType.getDeclaredFields()) {`
 `field.setAccessible(**true**);`
 `printer.print("\tcon ");`
 `printer.print(field.getName());`
 `printer.println(" = " + toString(field.get(anObject)));`
 `}`
 `printer.flush();`
        }
        


**public static void** main(String[] args) **throws** IllegalArgumentException, IllegalAccessException {
    introspectInstance(**new** Libro("Orson Scott Card", "El Juego de Ender"), **new **PrintWriter(System.out));
}**

**

**

Si ejecutamos el main con la instancia de libro ahí creada de ejemplo vemos:
**

**

**



        Un **Libro**

 `con **autor** = **Orson Scott Card**`
 `con **titulo** = **El Juego de Ender**`
 `con **cliente** = **null**`**

**

**

**Cosas a notar:**


* A diferencia del introspectType() que recibía un **Class** este nuevo método puede espera un **Object**, por lo cual le podemos pasar cualquier **instancia.**

* A partir de un Object podemos obtener su objeto del MOP **Class **con **obj.getClass()**.
* Luego estamos con el mismo objeto que utilizamos en el ejemplo anterior.
* Noten que a diferencia del ejemplo anterior para cada field estamos mostrando el valor de ese field para la instancia de Libro que estamos introspectando.

 * Eso se hace con **field.get(object)**

 * Esto es así porque el objeto Field de java es stateless respecto de las instancias. Es decir que le decimos "dame tu valor para esta instancia"

**

**

**

Otra cosa a notar que obviamos a propósito son las exception.
Si miran la firma del método introspect tiene una lista larga de **throws**.
Eso es porque, por decisión de diseño el API de reflection de java lanza infinitas exceptions checkeadas.
Acá como estamos mostrando un main() simplemente las propagamos, pero en una aplicación real probablemente tengamos que manejarlas en el lugar.
Ah, y cuanto más cosas usamos del API de reflection más larga se hace la lista de **exceptions que tira.**

**

**

#### **[]()Enviando mensajes por Reflection

Por último, vamos a ver otro ejemplo. **Ver** la estructura de las clases es una parte de reflection. Ver los valores de las intancias es otra aplicación. Pero la tercer aplicación que mostramos acá es otra parte muy utilizada e importante: interactuar con los objetos enviándoles mensajes.


Veamos un ejemplo:




        **public static void** main(String[] args) **throws** ... {
 `Libro libro = **new** Libro("Orson Scott Card", "El Juego de Ender");`
 `introspectInstance(libro, **new** PrintWriter(System.out));`
 
 `invokeMethod(libro, "prestarA", **new** Cliente("Lector Asiduo"));`
 `introspectInstance(libro, **new** PrintWriter(System.out));`
        }


La primer parte es igual al ejemplo anterior. Creamos un Libro, y lo mostramos por reflection.
Luego está lo nuevo. Estamos llamando al nuevo método **invokeMethod**. Este método tiene la siguiente firma:



        **protected static **Object invokeMethod(Object object, String methodName, Object... args)


Es decir que uno le pasa:

* un objeto cualquiera
* el nombre de un método perteneciente a ese objeto (ok, a su clase)
* objetos que queremos que le pase como argumentos al método.
* devuelve el resultado que devolvió la ejecución del método (si no es void)

Y el lo invoca por nosotros !


En este caso le estamos diciendo que invoque el método de la clase **Libro:**

**

**

**


        public void prestarA(Cliente cliente) {
 `if (this.cliente != null) {`
 `throw new LibreriaException("Libro ya prestado a " + this.cliente.getNombre());`
 `}`
 `this.cliente = cliente;`
        }**



Si ejecutamos este main() obtendremos:




        Un Libro
 `con autor = Orson Scott Card`
 `con titulo = El Juego de Ender`
 `con cliente = **null**`
        Un Libro
 `con autor = Orson Scott Card`
 `con titulo = El Juego de Ender`
 `con cliente = **Cliente:Lector Asiduo**`


Como verán la primera vez el libro no tenía cliente, y luego de invocarlo por reflection ya tiene asignado al cliente "Lector Asiduo".


Ahora sí mostramos el código del método **invokeMethod **que no incluimos inicialmente para que se entienda la intención del método, sin marearnos con la implementación de reflection de java que es "feucha".



        **protected static** Object invokeMethod(Object object, String methodName, Object... args) 
 `**throws** ` `SecurityException, `
 `NoSuchMethodException, `
                `IllegalArgumentException, `
 `IllegalAccessException, `
 `InvocationTargetException {`
 
  `Method method = object.getClass().getMethod(methodName, argumentTypes(args));``
    Object result = method.invoke(object, args);`
 `**return** result;`
        }


        **private static** Class[] argumentTypes(Object[] args) {
 `Class[] types = **new** Class[args.length];`
            **int** i = 0;
        **    for** (Object argument : args) {
 `types[i++] = argument.getClass();`
            }
        **    return** types;
        }
**

**

**

**

**Algunas cosas para notar:**


* Como mencionamos antes, vean que la cantidad de exceptions que tenemos que manejar crece terriblemente !
* Así como antes obteníamos los Fields, en este caso estamos obteniendo un **Method**

* A diferencia de antes estamos pidiendo uno en particular, el que nos dijeron que llamemos según **methodName** y los **args.**

* Para obtener un Method en java se necesita su nombre y los tipos de sus parámetros.
* Por eso necesitamos un método auxiliar para obtener un **Class[]**  a partir de los argumentos **Object[]**

* Una vez que tenemos el objeto **Method** lo invocamos pasándole como parámetro la instancia del objeto al igual que antes obteníamos el valor de un field.



En definitiva esto nos va a permitir escribir código que envíe mensajes a nuestros objetos sin siquiera conocerlos. Es decir que envía mensajes sin haberse compilado contra esas clases.
Esto le da a nuestro código un caracter dinámico y genérico. Por esto es que se utiliza mucho en frameworks

**