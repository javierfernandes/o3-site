---
title: "te-pike"
date:  2018-06-20T19:27:10-03:00
---


### Descripción

Es un lenguaje con soporte multiparadigma: objetos, funcional e imperativo. Tiene tipado de variables **explícito** (fuertemente tipado). Es un lenguaje **dinámico**, sin embargo tiene características híbridas de tipado estático y dinámico.
Tiene un sistema de tipos flexible con las ventajas de agilidad y rapidez de los lenguajes dinámicos, pero a su vez la seguridad de los lenguajes estáticos.



### Ambiente de Trabajo

* **Interprete:**


 * Bajar la distribución de [http://pike.ida.liu.se/download/pub/pike/latest-stable/](http://pike.ida.liu.se/download/pub/pike/latest-stable/)
 * Descomprimir
 * ejecutar:

  * **sudo make install**

 * Eso debería compilar y dejar el binario del interprete en /usr/local/bin/pike
* **Eclipse plug-in**


 * Se puede bajar desde [http://hww3.riverweb.com/dist/pdt](http://hww3.riverweb.com/dist/pdt)
 * Moverlo a la carpeta "dropins" de un eclipse (3.7 por ejemplo)
 * Restartear/ejecutar eclipse.
 * El plugin se encuentra en fase de desarrollo por ahora se va a poder:

  * Crear un nuevo Proyecto Pike
  * Crear un nuevo archivo Pike
  * Usar un editor de texto para archivos Pike
  * No parece haber forma de ejecutar el interprete automáticamente, para esto

   * se puede crear un "External Tool Configuration.." con los siguientes datos:
   * **Location: **/usr/local/bin/pike
   * **Wworking directory: **${project_loc}
   * **Arguments:** ${resource_loc}
  * Luego para ejecutar:

   * seleccionar un archivo .pike en la vista "Navigator", y ejecutar el runner.
   * en consola se deberían reportar los errores y los mensajes de write()

 
### Referencias

* Homepage: [http://pike.ida.liu.se/](http://pike.ida.liu.se/)

* Plugin: [http://www.gotpike.org/PikeWiki/index.pike?page=PikeDevel/Eclipse](http://www.gotpike.org/PikeWiki/index.pike?page=PikeDevel/Eclipse)