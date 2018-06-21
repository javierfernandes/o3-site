---
title: "tps-2014-c1-tp2---aspectos---monitored"
date:  2018-06-20T19:27:10-03:00
---


## []()Condiciones Generales

Se pide:

* Realizar un programa que cumpla con los requerimientos especificados en la Sección II, aplicando las ideas de Programación Orientada a Aspectos utilizando el Framework AspectJ. 
* El código de los aspectos debe ser independiente del dominio. Los unicos puntos de relación entre el aspecto y el dominio ser:

 * La annotation *@Monitored*
 * De ser necesario, se puede filtrar el alcance del aspecto al package dominio
* El programa debe ser testeado utilizando JUnit.


Para todos los ejemplos a continuaci ́n se considera la siguiente clase *Persona*:





        **package** dominio;
        

        **public class** Persona {
            **private** String nombre ;
            
            @Monitored
            **public** String getNombre() {
                **return this**.nombre ;
            }
            
            @Monitored
            **public void** setNombre(String nombre) {
                **this**.nombre = nombre;
            }
        }
## []()Requerimientos Específicos


### []()Ejercicio 1

Construir un aspecto que contabilice la cantidad de veces que se llama un método determinado. Para seleccionar los métodos a utilizar se utiliza una annotation denominada *@Monitored*



A continuación se presenta un ejemplo de una clase de dominio y un test a realizar:





        public class ContadorLlamadasTest {
            
            @Test
            public void sampleTest () {
                Persona p1 = new Persona();
                p1.getNombre();
                p1.setNombre(" Nico ");
                p1.setNombre(" Carlos ");
                Persona p2 = new Persona();
                int llamadas_p1_getNombre =
                    ContadorLlamadasAspect.aspectOf().cantLlamadas(p1, "getNombre");
                int llamadas_p1_setNombre =
                    ContadorLlamadasAspect.aspectOf().cantLlamadas(p1, "setNombre");
                int llamadas_p2_setNombre =
                    ContadorLlamadasAspect.aspectOf().cantLlamadas(p2, "setNombre");
                assertEquals(llamadas_p1_getNombre , ) ;
                assertEquals(llamadas_p1_setNombre , 2) ;
                assertEquals(llamadas_p2_setNombre , 0) ;
            }
        }


### []()Ejercicio 2


Monitorear los valores de una variable de instancia, asignándole a cada variable un validador y tirando una
excepción en caso de que el valor no se cumpla.
A continuación se muestra un posible test:








**`public class`**` ValidarStringNoVacio `**`implements`**` Validador<String> {`
            **`public void`**` validar (String valor) {`
                **`return`**` valor.size > 0;`
            }
        }




**`public class`**` NombreNoVacioTest {`
            
            @Test
            **`public void`**` noDebePermitirNombresVacios () {`
                Persona p1 = new Persona();
                ValidadorAspect.aspectOf()
                     .agregarValidador(p1, "nombre", new ValidarStringNoVacio());
                p1.setNombre("Nico");
                assertEquals("Nico", p1.getNombre()); // Se asigna `el nombre correctamente`
                **`try`**` {`
                    p1.setNombre("");
                    fail("Debera haber tirado excepcion al asignarle un nombre vacio);
                }
                **`catch`**` (ValorInvalidoException e) {`
                    assertEquals("Nico", p1.getNombre()); // El nombre no cambio
                }
            }
        }



## []()Ejercicios  Bonus

### []()Ejercicio 3


Definir el aspecto del ejercicio 1 como pertarget de forma de tener una instancia del aspecto por cada objeto
afectado. Luego de esa modificaci ́n en el test, las sentencias del tipo:



        ContadorLlamadasAspect.aspectOf().cantLlamadas(p1, "getNombre");


pasará tener la forma:



        ContadorLlamadasAspect.aspectOf(p1).cantLlamadas("getNombre");


### []()Ejercicio 4


Siguiendo la técnica utilizada en el ejemplo ObservableByMixinAspect (*1) , agregar los métodos necesarios a las clases de dominio (en este ejemplo Persona), de forma de poder utilizarlas de la siguiente manera:






        **public class** NombreNoVacioTest {
            
            @Test
            **public void** noDebePermitirNombresVacios() {
                Persona p1 = new Persona();
                p1.agregarValidador("nombre", new ValidarStringNoVacio());
                // ... el resto del test sin cambios
            }
        }





*1:  El ejemplo lo pueden checkoutear de 
[https://xp-dev.com/svn/uqbar/examples/paco/trunk/aop/aspectj/examples/](https://xp-dev.com/svn/uqbar/examples/paco/trunk/aop/aspectj/examples/)






## []()