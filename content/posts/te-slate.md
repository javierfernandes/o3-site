---
title: "te-slate"
date:  2018-06-20T19:27:10-03:00
---


***Ambiente de Trabajo
***

1. *Compilar la VM* de Slate:

 1. Requiere tener instalado un cliente de Mercurial o GIT para checkoutear los fuentes.
```
sudo apt-get install mercurial
```

 1. O en Windows ver [este link](http://mercurial.selenic.com/wiki/WindowsInstall)
 1. Checkout de los fuentes *(clone del repositorio)**:* 
```
hg clone https://slate-language.googlecode.com/hg/ slate-language
```

 1. Compilando la VM:```
cd slate-language ; make
```

 1. Esto debería dar como resultado un file llamado "slate" en la misma carpeta de tipo ejecutable. Un paso opcional sería instalar la vm en su distribución en forma global, para que luego pueda utilizarla cualquier usuario, y accesible desde cualquier lado con el comando "slate". Para eso:
```
sudo make install
```

1. *Ejecutar la VM con la imagen* base de slate:

 1. Bajar la imagen de [acá](http://code.google.com/p/slate-language/downloads/list)  por ejemplo la más actual hoy (19/12/2010) es [esta](http://code.google.com/p/slate-language/downloads/detail?name=slate.little.32.2010-11-15.image.bz2&can=2&q=).```
wget http://slate-language.googlecode.com/files/slate.little.32.2010-11-15.image.bz2
```

 1. Descomprimir:
```
bunzip2 slate.little.32.2010-11-15.image.bz2
```

 1. Ejecutar 
```
./slate -i slate.little.32.2010-11-15.image
```

 1. ```
Listo, deberían ver un prompt como:
Old Memory size: 419430400 bytes
New Memory size: 5242880 bytes
Image size: 10884724 bytes
Nil
slate[1]>
```