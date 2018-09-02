---
title: "Lenguajes basados en Objetos - IO"
date: 2018-09-02T13:01:21-03:00
toc: true
---

# Links

Para trabajar en Io necesitamos 2 cosas

* [Io](https://iolanguage.org/): bajar el ejecutable de "binaries" e instalar.
* [VSCode plugin](https://marketplace.visualstudio.com/items?itemName=kennethceyer.io): recomendado instalar esta extensión para VSCode que nos da un mínimo de syntax highlight.

Luego para ejecutar un programa

```bash
io src/pepita.io
```

# Intro

# Paso a paso

Todos son objetos en Io, como en smalltalk. Al String le podemos decir println para imprimir en consola.

```io
"Hola Mundo" println
```

## Pepita (Objetos propiedades y métodos)

Vamos a crear a pepita

```io
Pepita := Object clone
```

El mensaje `::=` nos permite definir una "property" que tendrá una variable de instancia pero también el un setter.

```io
Pepita energia ::= 100
Pepita setEnergia(50)
```

Luego si imprimimos a Pepita veremos

```io
Io> Pepita
==>  Pepita_0x621c30:
  energia          = 50
  setEnergia       = method(...)
  type             = "Pepita"
```

Agregamos un método a `Pepita` para poder `volar`

```io
Pepita volar := method(kms,
  self setEnergia(energia - kms)
)
```

Luego lo usamos

```io
Io> Pepita volar(3)
==>  Pepita_0x621c30:
  energia          = 47
  setEnergia       = method(...)
  type             = "Pepita"
  volar            = method(kms, ...)
```


