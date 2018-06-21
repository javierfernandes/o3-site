### []()Descripción
La idea de la materia es la de transmitir el conocimiento en cuanto a herramientas/conceptos moderna/os. En cuanto a modernas, nos referimos a herramientas que aún la industria, junto a los lenguajes mainstream, no han adoptado, por lo que estos temas no han alcanzado la luz en forma masiva.

Quizás el término "modernas" provenga por el hecho de que eventualmente, lenguajes mainstreams como java van incorporándolas, dando la sensación de ser features nuevos de la programación.

Ahora, el hecho de que los lenguajes masivos no contengan dichas herramientas, no quiere decir que no existan ya aplicaciones de las mismas.
Sin embargo, no existe un único lenguaje que contenga todos los conceptos que vamos a ver.

Y como cada lenguaje tiene su complejidad, ya por temas inherentes como la sintaxis, o el cambio de paradigma, etc. no queríamos obligarlos a tener que lidiar, además, con la instalación y configuración de cada lenguaje y ambiente de trabajo.

Por esto es que les vamos a dar una Virtual Machine ya operativa para cada uno de los lenguajes que vamos a manejar.


### []()Qué es una Virtual Machine ?
El concepto de **virtualización** (como se llama a esta práctica), se refiere básicamente, a poder "embeber" una máquina completa **virtual**, con su propio sistema operativo, su propia estructura de storage (discos rígidos), y memoria, dentro de otra máquina "real".

**En palabras más simples**: te permite simular una nueva PC corriendola dentro de la tuya. 

Se dice virtual, justamente porque no existe físicamente como tu PC normal, sino que se simula dentro de ésta. De hecho, para tu máquina real son simples archivos. Por ejemplo un archivo por cada "disco rígido virtual".

Se dice** "guest"** (invitado sería la traducción literal) a estas máquinas virtuales, ya que corren dentro de otra máquina real, llamada **"host"** system.
Se pueden compartir recursos entre ambas máquinas.

Existen varias tecnologías de virtualización. Entre las más conocidas estan: [VMWare](http://www.vmware.com/) y [Sun Virtual Box](http://www.virtualbox.org/)

### []()Cómo se va a distribuir la VM ?
Vamos a pasarles un **DVD** con el siguiente contenido.

* **phm-vm** : contiene los archivos de la VM en formato [OVF (Open Virtual Format)](http://en.wikipedia.org/wiki/Open_Virtualization_Format)

* **VirtualBox-4.0.2-69518-Win.exe**: distribución de la herramienta Sun Virtual Box para windows. Virtual box es necesario para poder "correr" la VM.
No distribuimos los binarios de virtualbox para otro tipo de sistema operativo que no sea windows.
Ustedes deberan averiguar cómo instalar un player de VM para su distribución de linux.


### []()Cómo **"instalo"** la VM ?

1. **Copiá el directorio con los archivos** de la VM a tu disco rígido.

1. **Instalate Sun Virtual Box**


 1. En windows usá el instalador que viene en el dvd
 1. En linux, depende de tu distribución. Por ejemplo en un ubuntu (u otra distribución basada en debian) podés hacer **sudo apt-get install virtualbox**

1. Una vez instalado, 


 1. **File->Import Appliance**

 1. Botón "Choose" y seleccionar el archivo "phm-1.0.ovf" de la carpeta previamente copiada.
1. Listo! Te debería aparecer un item en la lista de la izquierda con nombre "phm-1.0"
1. En "Settings" podés ajustarle varios parámetros como la memoria (en la preferencia "System")
1. Para bootear la VM seleccionala y apretá el botón "Start"
Listo, tu VM debería comenzar a bootear.
Pero ojo, mirá en la siguiente sección porque una vez que arranca vas a tener que hacer una tarea manual.

Cualquier duda podés checkear [esta página oficial](http://www.virtualbox.org/manual/ch01.html#ovf) de VirtualBox

### []()Qué tiene la VM ?
Básicamente es un linux ubuntu 10.10
Tiene 3 díscos montados de la siguiente forma

* **sda: **disco primario que contiene el ubuntu


 * **/**


 * **/home**

 * **/usr
**

* **sdb:**


 * **/opt :** acá esta todo el software instalado de la materia.

* **sdc:** una única partición de tipo **swap**



### []()Cuál es el software de PHM ?
Probablemente esta parte quede desactualizada a lo largo de las diferentes cursadas, lo mejor será que navegues un poco por la partición **/opt** que es donde instalaremos todo el soft.

Pero a modo ilustrativo la estructura y contenido es

**/opt**

|-- **java**

|   |-- eclipse-SDK-3.6.1-linux-gtk.tar.gz
|   `-- jvm
|-- **lang**    :   contiene las herramientas para trabajar con cada lenguaje/tecnología
|   |-- aspectj
|   |-- dsl
|   |-- lisp
|   |-- pharo
|   |-- scala
|   `-- self
        -- **workspaces** :  contiene una carpeta para cada tecnología con ejemplos de código. Es donde vas a poner tus proyectos.
    |-- aspectj
    |-- lisp
    |-- scala
    -- xtext


#### **[]()Nota:
La carpeta "workspaces" está versionada a través de subversion (svn). Es decir que esta carpeta fue checkouteada y es una working copy local que se puede actualizar con el contenido del servidor.
Esto nos permite a nosotros generar una única versión de la VM y luego ir agregándo ejemplos sin tener que redistribuir la VM nuevamente. Solo deben hacerse update de esta carpeta.
Por eso, al comenzar a usar la VM deben hacer esto:

* Abrir una consola "Applications->Accessories->Terminal" o CTRL+SHIFT+T
* cd /opt/workspaces
* svn up

Esto va a actualizar la working copy.

 
### []()Instrucciones básicas para el uso de la VM
 
* **usuario:** phm
* **contraseña:** phm

En el escritorio te vamos a dejar launchers para cada uno de los entornos de trabajo. Así que básicamente tenés que loggearte, hacer doble click y voilà !

Acá hay un screenshot de cómo se vería


[![](https://sites.google.com/site/programacionhm/_/rsrc/1298329919565/te/virtualmachine/phm-vm-desktop.png)
](te-virtualmachine-phm-vm-desktop-png?attredirects=0)

***NOTA:*** Si la VM te captura el mouse y/o teclado y querés volver el control a tu sistema guest, tenés que apretar la tecla "RIGHT CTRL"