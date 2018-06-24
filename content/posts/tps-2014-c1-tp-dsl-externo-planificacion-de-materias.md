---
title: "tps-2014-c1-tp-dsl-externo-planificacion-de-materias"
date:  2018-06-20T19:27:10-03:00
---


[[_TOC_]]


## Introducción

Queremos hacer un DSL que permita planificar un cuatrimestre de una carrera universitaria, ingresando:

* Cada profesor y su dedicación
* Las materias que se deben dictar y los recursos que necesitan (proyector, computadoras, etc)
* Las aulas disponibles y los recursos que ofrecen
* La planificación, es decir, la asignación de cada materia que se debe dictar con un aula, un horario y un profesor.



El programa tiene tres objetivos:

* Poder describir toda esta información de la forma más sencilla posible.
* Validar que la planificación cumple con todas las restricciones (se detallan más abajo).
* Obtener algunas estadísticas sobre asignación de aulas, etc (las estadísticas se las informaremos más adelante).

## Aclaraciones


1. A lo largo del enunciado van a encontrar ejemplos de cómo podría ser el DSL. Están sólo a modo de ejemplo, el DSL que ustedes definan no tiene por qué ser así, pueden definirle la sintaxis que ustedes quieran.
1. El enunciado pide una gran cantidad de validaciones. Estas validaciones pueden hacerse en el propio editor (vía @Check) o pueden hacerse en el *runtime*, es decir, durante la "ejecución" del programa. 

 * Lo obligatorio es que al menos una de las validaciones se haga en el editor, las demás quedan a su criterio.
 * Lo ideal sería que el propio editor tenga la mayor cantidad de validaciones posibles, así a medida que uno escribe le va informando de los problemas. 

## Descripción del dominio

Existen materias, profesores, y aulas. Cada una de estas entidades tiene características que influyen en la planificación.
### Profesor

Tiene un nombre, claro, pero además tiene una **dedicación**.
Los tipos de dedicaciones son:

* **SIMPLE**: sólo puede dar una materia por cuatrimestre.
* **SEMI**: debe dar 2 materias
* **EXCLUSIVA**: puede de 2 hasta 5 materias.

### Materia

Una materia tiene un nombre y una **carga horaria.**

La carga horaria es en cantidad de horas semanales.
Y además un **número de días** que se da a la semana.
Ejemplo:
 Algoritmos 1, es de 1 sólo día, de 4 horas.


Además, las materias tiene restricciones o **requisitos** de recursos. Es decir que para poder dictarse necesitan ciertos recursos, que condicionan el aula en la que se puede dictar.
### Recursos y Requisitos

Un recurso define una característica del aula.
Ejemplos de recursos (el usuario podría definir sus propios)

* **proyector**: el aula tiene proyector
* **máquina para el docente**

* **máquinas para alumnos**

* **internet**


### Aulas

Las aulas tienen un nombre, y pueden tener recursos.
No hace falta saber la "cantidad". Simplemente declaran que tiene.
Ej:  "Laboratorio de Electrónica 3, tiene: proyector, máquina para el docente, máquina para alumnos"  (internet a veces no funciona, pero bueno, no vamos a complicar el TP con esas cosas :P).
### Planificación

Entonces ahora sí, uno define una **planificación**, **para un año** y **un semestre específico**.
Ej: "Planificación 2014 semestre 1"


Dentro de ella se definen:

* qué materias se van a dictar.
* qué profesores se asignan a cada materia.
* los horarios semanales, por día.

### Asignación de horarios

Para cada día de la semana se asigna el horario de cada materia. Y además, en qué aula se dictará.
Ejemplo:


        Lunes
            18 a 22hs se dicta PHM en LabElectronica3
            14 a 18hs se dicta ALGO1 en LabElectronica4
        Martes
            .... etc


### Reglas y checkeos

Ya definimos a grandes rasgos todas las entidades y sus relaciones. Ya se pueden armar planificaciones. Sin embargo nos falta lo más importantes, la reglas de negocio, que restringirán todo esto. 
Es decir los checkeos que deberá hacer el lenguaje para ayudarnos a encontrar los problemas.
#### Carga horaria de docente

No puedo asignar a un docente a más materias de las que le corresponde su dedicación.
Por ejemplo si Leo Gassman tiene una SIMPLE, solo puedo asignarlo a una materia.
Si en la planificación de un semestre lo asigno a más de una materia, me debería tirar un error.




        leoGassman **tiene** SIMPLE


        PHM **dicatada por** leoGassman
        ALGO1 **dictada por** leoGassman // TIRA ERROR: solo puede dar 1 materia!! 



#### Todas las materias deben estar asignadas

Si dentro de una planificación dije que se van a dar las materias A, B, y C, todas ellas deben estar en algún día planificadas.


        **planificacion** 2014 **semestre** 2 {
              **a dictar**: A, B **y** C
              **horarios** {
                    **lunes**:
                          18 **a** 22 A
                          18 **a** 22 B
              }
        }


        ERROR !! falta asignar un día y horario a la materia C 


#### Carga horaria de materia y días

Debe validar que la asignación respete la carga horaria de la materia y los días definidos.
Ej:

* **Algo3 de 2 días y 8 hs**: debe estar asignada a dos días de la planificación (ej "martes" y "jueves", y la suma de las horas debe dar 8.

#### Compatibilidad de Aula para Materia

La asignación de horarios también define el aula.
Hay que checkear que esa aula tenga todos los recursos que necesita la materia.


        materia PHM {
           requiere: proyector, maquinas
        }


Luego


        lunes {
            18 a 22 PHM en LabElectronica3
        }


LabElectronica3 debe tener proyector, y maquinas, por ejemplo. Si no las tuviera, marcaría un error !



#### Superposición de Materias en Aulas

No puedo asignar dos materias en horarios que se superpongan el mismo día, a la misma aula.



        lunes {
            18 a 22 PHM en LabElectronica3
            20 a 21:30  ALGO3 en LabElectronia3  // ERROR: aula ya ocupada por PHM!!!
        }
        

## Bonus 1 - Capacidad de Aulas e Inscriptos
Agregar la posibilidad de definirle capacidad máxima de alumnos a las aulas.


        **aula** LaboratorioElectronica3 {
            **capacidad** 30 **alumnos**

        }
        

        **aula** Sucucho {
            **capacidad** 8 **alumnos**


        }


Además, dada la planificación de un cuatrimestre se debe poder indicar cuántos inscriptos hay para esa materia.


        **planificación** 2014 **semestre** 2 {
            **a dictar **PHM **con** 22 **inscriptos en** LaboratorioElectronica3    // compila bien ! 22 < 30

            **a dictar PHM con** 22 **inscriptos en** Sucucho    ***// ERROR !! Sucucho solo se banca 8 alumnos ***!! 
        }


Es decir que el lenguaje debe checkear que la capacidad del aula supere la cantidad de inscriptos.
## Bonus 2 - Restricciones Horarias de Profesores

Agregar la posibilidad de que los profesores definan restricciones horarias.


Ej:


        **profesor** Fernandes {
            **no puede** Sabado
            **puede** Lunes **a** Viernes **de** 18 **a** 22
        }


        **profesor** Tesone {
           **puede** Sabado
           **puede** Lunes **de** 9 **a** 13
           puede Jueves **de** 14 **a** 18
        }


Luego estas restricciones se deberán tener en cuenta a la hora de asignar una materia a un horario.


        a dictar PHM por Fernandes


        Sabado {
             14 a 18hs PHM       // ERROR ! PHM la da Fernandes, que no puede los sabados !
        }


Dos variantes:

* Si se definen a la hora de declarar un profesor, aplican para todas las planificaciones (todos los cuatrimestres)
* Si se definen dentro de una planificación, entonces es una restricción "temporal", que solo aplica para ese cuatrimestre.




## Intérprete (backend / runtime)

La ejecución de estos archivos de DSL la vamos a hacer a través de un intérprete.
Para más información sobre cómo hacer uno, ver [ésta página](../conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext---interprete-standalone).


Básicamente va a ser una aplicación más bien sencilla (porque ya la primera parte del TP es bastante grande), que dado el conjunto de hechos declarados por el ususario sobre planificaciones, deberá presentar cierta información.
Para simplificarlo vamos a hacer que presente la información en consola.
Con lo cual, leer, procesa e imprime en consola.


Acá van los requerimientos:


* Saber cuál aula es la más utilizada.
* Saber, por planificación, en qué horarios no se dictan materias.
* Saber por turnos, el porcentaje de materias que se dictan en ese turno. Los turnos son: mañana (de 8 a 13), tarde (de 13 a 18) y noche (de 18 a 22). Ejemplo entonces:   2014-c1:  mañana 10% , tarde 30%, noche 60%
* Un listado de los profesores que indique todas las materias que está dictando, dictó o va a dictar en futuros cuatrimestres (en realidad esto quiere decir que, se deben tener en cuenta todas las planificaciones que estén declaradas en el archivo).