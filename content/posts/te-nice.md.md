## []()Plugin de eclipse

### []()Instalación
// TODO

### []()Uso
Para crear un nuevo proyecto y trabajar con el tenemos que seguir los siguientes pasos:

* File->New... (o CTRL+N), "Nice Project"
* Darle un nombre. Finish.
Luego, Nice se basa en la idea de paquetes. En realidad el concepto de paquete es más poderoso que el paquete de java. Pero por ahora no vamos a hablar de eso en la materia, pueden mirar la documentación de Nice en el sitio si les interesa.
A efectos prácticos, antes de crear un archivo de código .nice, tenemos que crear el paquete que es simplemente una carpeta dentro del proyecto.

* File->New... (o CTRL+N), "Folder"
* Seleccionar el proyecto como padre de la carpeta
* Asignar un nombre, por ejemplo "objetos3"

Ahora ya podemos crear un archivo .nice

* File->New... , "Nice Source File"
* Seleccionar la carpeta del paquete como parent.

* Darle un nombre.
Ahí ya podemos tirar algo de código.
Ejemplo:

        **class** Paloma {}

        **void** piar(Paloma p) {
            System.out.println("pio pio!");
        }

        **void** main(String[] args) {
            Paloma p = **new** Paloma()
            p.piar();
        }

Ahora la pregunta del millón.. cómo ejecutamos esto ??

De hecho el proyecto debería estar con un error relativo a que no tiene declarado un package "main".
Entonces, vamos a declarar nuestro nuevo paquete como el "main package".

* botón derecho sobre el proyecto, "Properties" (o ALT+ENTER)
* "Nice Project Properties" de la izquierda.
* En el panel de la derecha, ingresar en "Main Package" el nombre de nuestro package/carpeta. En nuestro ejemplo sería "objetos3"
* Si desean pueden modificar el nombre del jar que se va a generar al compilar cambiando el textbox de "compiled jar name".
Recuerden que nice compila a javabyte code.

Ahora para ver si tomó los cambios vamos a hacer una tareas medio defensivas:

* Seleccionar el proyecto.
* En el menú "Project" -> Clean, OK. Con eso debería recompilar.

* Luego seleccionar el proyecto nuevamente, y apretar F5 para que refresque el contenido.
Deberían ver que ahora aparecen más archivos en su proyecto.


**`nice-ejemplo`**

        |-- nice
        |   -- lang`
        |       |-- AssertionFailed.class
        |       |-- dispatch.class
        |       |-- Enum.class
        |       |-- NiceComparator.class
        |       |-- NiceThread.class
        |       |-- NonReclosableOutputStream.class
        |       |-- Range.class
        |       |-- RangeIterator.class
        |       |-- Ref.class
        |       |-- StringBufferForIterator.class
        |       -- StringForIterator.class`
        |-- *nice-ejemplo.jar*
**``-- objetos3`**

            |-- dispatch.class
            |-- fun.class
**`    |-- objetos3.nice`**

            |-- package.nicei
            -- Paloma.class`
En negrita estan los archivos y carpetas que nosotros creamos explícitamente.
Todo lo demás fue autogenerado.

Noten que en la raíz del proyecto hay un **"nice-ejemplo.jar"**. Ese es el resultado de la compilación de nuestro archivo. Es decir que nice compila a bytecode y empaqueta todo en un .jar.

Entonces para ejecutar nuestro main, básicamente tenemos que ejecutar java con ese jar.

Para hacerlo desde el eclipse

* Primero tenemos que indicarle a eclipse que este es un **proyecto java**. Porque hasta ahora era solo un proyecto de tipo **nice.**


 * Para eso tenemos que editar el archivo **.project **(punto project) del proyecto.
 * Lo pueden hacer desde el filesystem (una consola),
 * O desde el eclipse no se va a ver en la vista porque está oculto, pero pueden buscarlo con **CTRL+SHIFT+R** (de resource) que sirve para buscar cualquier archivo. 


  * Y tipean .project
  * Seleccionan el que correponde a su proyecto.
 * Van a ver que es un **XML**

 * Tienen que agregar un nuevo tag a la sección de "natures", para que quede así

        <natures>
                <nature>net.sf.nice.nice_nature</nature>
**`        <nature>org.eclipse.jdt.core.javanature</nature>`**

            </natures>
Acá la linea en negrita.

Ahora sí, ya podemos hacer un runner.


* **Botón derecho** sobre el **proyecto.**

* **Run As.. -> Run Configurations...**

* Seleccionar** Java Application**, botón derecho, **New**

* Va a crear una nueva entrada.
* Seleccionar **Project **a través de **Browse **y elegir nuestro proyecto (si no era java proyecto no iba a aparecer acá)
* Ir a la solapa **Classpath**


 * Tenemos que agregar el jar que genera el compilador al classpath
 * Seleccionar **User Entries**

 * Y a la derecha **Add Jar**

 * Seleccionar el jar que vimos que estaba dentro de nuestro proyecto.
 * **Apply**

 * Volver a la solapa **Main**

* Ahora sí** **podemos indicar cual es la **clase main**

* Tipear el nombre de nuestro paquete (objetos3) + ".dispatch".

 * Ejemplo: **objetos3.dispatch**

* **Apply**

* **Run**

Listo, deberían ver en la consola:


        pio pio!
A partir de ahora este runner va a quedar guardado, así que lo van a poder ejecutar nuevamente con un click.
O con F11.