---
title: "conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-dsl---orm-mappings"
date:  2018-06-20T19:27:10-03:00
---


## []()Nota: actualizado a xtext 2.6

## []()Introducción

Este DSL es parte de nuestros ejemplos de mapeo objeto relacional que usamos para "programación declarativa".


Vamos a usarlo de ejemplo acá para ver algunos features de xtext.


## []()Referencias a Tipos Java

En nuestro lenguaje queremos poder referenciar clases java. Y que, por ejemplo, el lenguaje checkee que la clase exista, y de hecho nos dé autocomplete.


Para eso tenemos que heredar de XBase el lenguaje base de XText que modela todos los elementos del lenguaje Java.


Agregamos esto a la gramática:





        grammar org.uqbar.paco.dsl.xtext.mapping.MappingDsl **with org.eclipse.xtext.xbase.Xbase**



        generate mappingDsl "http://www.uqbar.org/paco/dsl/xtext/mapping/MappingDsl"


        **import "http://www.eclipse.org/xtext/common/JavaVMTypes" as types**



La tercera linea importa el modelo semántico JavaVMTypes con el prefijo "types" que usaremos más adelante.


Luego podemos indicar referencias a tipos java en cualquier parte de nuestra gramática, usando la regla **JvmType.**

**

**




        Mapping:
          'map' **beanType=[types::JvmType|FQN]** (' to table ' table=STRING)? '{'
            (properties+=MappingProperty)+
          '}';


Esto quiere decir que la propiedad "beanType" tendrá una referencia a un objeto de tipo JvmType parte del paquete que importamos como "types" más arriba.
"|FQN" indica con qué criterio vamos a referenciar a esos objetos. FQN es fullyQualifiedName. Es decir el nombre completo.


Acá un ejemplo de uso:

[![](https://sites.google.com/site/programacionhm/_/rsrc/1402280866165/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext-dsl---orm-mappings/typeRef-autocomplete.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-dsl---orm-mappings-typeRef-autocomplete-png?attredirects=0)

## []()Imports

Escribir los nombres completos de las clases no tiene mucha onda. Entonces está bueno que agreguemos imports a nuestro lenguaje. Por suerte esto es algo bastante común en DSL's sobre xtext así que es bastante simple.
En la gramática





        MappingModule:
        **        (imports+=Import)***

                (mappings+=Mapping)*
        ;


        Import:
          'import' **importedNamespace**=ImportedFQN;


        ImportedFQN:
          FQN ('.*')?;


        FQN:
          ID ('.' ID)*;


Como se ve acá, las reglas son nuestras, pueden tener el nombre que querramos.
Lo único importante es que la propiedad de la regla del import tiene que tener un atributo con el nombre **importedNamespace**.
Con esa convención, xtext luego trata ese valor como un import y resuelve así los tipos que referenciemos. Además de que se mete en la resolución de otras referencias que hagamos dentro del archivo (como una especie de scope).


Ya podemos usar el DSL



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402281750947/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext-dsl---orm-mappings/typeRef-imports.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-dsl---orm-mappings-typeRef-imports-png?attredirects=0)

## []()Referencias a Properties

En nuestro DSL dentro de un mapping necesitamos hacer referencia a properties válidas. En lugar de usar Strings, queremos poder usar id's verdaderos. De modo de poder tener checkeos.
Para eso entonces tenemos que hacer varias cosas:
### []()Modificar la Gramática

Necesitamos declarar esto en la gramática. En la regla MappingProperty





        MappingProperty:
          **name=[types::JvmField|ID] **

           `('converter' converter=JvmTypeReference)? `
           `('column' column=STRING)? ;`


Acá se ve que tenemos referencia no a JvmType, sino a **JvmField**, que representa justamente a los fields de java.
### []()Customizando el Scope Provider

Para que resuelva la referencia adecuadamente de acuerdo al tipo declarado del mapping necesitamos customizar un punto de extensión de xtext llamado ScopeProvider.
Para eso primero vamos a hacer una clase que tenga la lógica para calcular el scope, dado un mapping (o una property). Lo hacemos como un extension provider:





        **class** MappingScopeExtensions {
 
 `**def** getScope(MappingProperty property) {`
 `property.mapping.scope`
 `}`
 
 `**def** getScope(Mapping mapping) {`
 `**val** JvmType containerType = mapping.beanType;`
 `**if** (containerType == **null** || containerType.eIsProxy)`
 `**return** IScope::NULLSCOPE`
 `**return** **new** MapBasedScope(containerType.fields.toMap[f | f.qName ])`
 `}`


 `// extension Methods`
        

            **def** mapping(MappingProperty property) {
 `property.eContainer **as** Mapping`
 `}`
 
 `**def** getFields(JvmType type) {` 
 `**val** fields = newArrayList`
 `collectFeatures(type, fields)`
 `fields`
 `}`
 
 `**def** void collectFeatures(JvmType containerType, List<JvmField> result) {`
 `**if** (containerType **instanceof** JvmDeclaredType) {`
 `containerType.superTypes`
 `.filter[type != **null**]`
 `.forEach[sup | collectFeatures(sup.type, result) ]`
 
 `containerType.members`
 `.filter(JvmField)`
 `.forEach[f | result.add(f)` `]`
 `}`
 `}`
 
 `**def** qName(JvmField f) {`
 `**return** QualifiedName.create(f.simpleName)`
 `}`


Los métodos importantes son los dos primeros.
Los demás son parte de la implementación. Recorre recursivamente todas las subclases del tipo declarado en el mapping, y va armando una lista de JvmFields.
Luego convierte esa lista en un mapa, con los fields como valores y su nombre como key.


Ahora sí, ya tenemos la lógica, tenemos que engancharla en xtext. Para:

* creamos un paquete "scoping"
* una clase **MappingScopeProvider **que extienda de **AbstractDeclarativeScopeProvider**

* agregamos los siguientes métodos




        **class** MappingScopeProvider **extends** AbstractDeclarativeScopeProvider {
 `@Inject **extension **MappingScopeExtensions`


 `**def **IScope scope_MappingProperty_name(MappingProperty property, EReference eRef) {`
 `property.mapping.scope`
 `}`
 
** **`**def** IScope scope_MappingProperty_name(Mapping mapping, EReference eRef) {`
 `mapping.scope`
 `}`


        }


Acá se ve que estamos usando la extensión que creamos antes.
Por otro lado, al heredar de **AbstractDeclarativeScopeProvider **la forma de definir scopes es por convención de nombres de los métodos que definamos.



                scope_Regla_propiedad


En nuestro caso queremos autocompleta la propiedad "**name**" de la regla **PropertyMapping**.
Luego tenemos dos parámetros, el objeto regla donde se está parado en estos momentos, como el "contexto", y un objeto EReference (ver documentación de xtext para más info).


En nuestro caso podemos definir el scope ya teniendo un Mapping (que define el beanType).

### []()Registrar (bindear) el ScopeProvider

Ya tenemos nuestro scope provider, ahora para que xtext lo use, necesitamos engancharlo en su startup, cuando crea todos los objetos y los conecta.
Para eso es importante la clase central de nuestro plugin **MappingDslRuntimeModule**



En esa clase vamos a poder sobre-escribir métodos para customizar diferentes puntos de extensión o "módulos" de Xtext.
Para eso es que tiene muchos métodos de la forma



        bind$COMPONENTE -> ClaseComponente


Ejemplos:

* bindIGrammarAccess
* bindISemanticSequencer
* bindISyntacticSequencer
* bindIParser
* bindLexer
* bindIFormatter
* **bindIScopeProvider**

* etc

sobrescribimos el que nos interesa para definir el scope provider





        @Override
        **public Class**<? **extends** org.eclipse.xtext.scoping.IScopeProvider> bindIScopeProvider() {
 `**return** MappingScopeProvider.**class**;`
        }


Y retornamos nuestra clase.


Listo !
Más o menos :S



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402322984832/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext-dsl---orm-mappings/cannotresolvejvmfield.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-dsl---orm-mappings-cannotresolvejvmfield-png?attredirects=0)

### []()Customizando XbaseBatchScopeProvider

Lo anterior funcionaría si estuvieramos customizando un DSL 100% nuestro que no use XBase. 
En nuestro caso las referencias son de hecho a objetos de XBase (JvmFields).
Entonces, por desgracia, hay una duplicación en el diseño (espero que algún día la arreglen), y en estos casos hay que redefinir 2 scope providers:

* bindIScopeProvider
* **bindXbaseBatchScopeProvider**


Y acá nos viene bien el haber definido el comportamiento en una clase aparte, porque la vamos a reutilizar:


Creamos una nueva clase:





        **class** MappingBatchScopeProvider **extends** XbaseBatchScopeProvider {
 `@Inject **extension** MappingScopeExtensions`


 `**override** IScope getScope(EObject context, EReference reference) {`
 `**if** (context **instanceof** MappingProperty && "name".equals(reference.name)) {`
 `(context **as** MappingProperty).scope`
 `} **else**`
 `**super**.getScope(context, reference)`
 `}`


        }


Esta super clase no es declarative así que tenemos que filtrar nosotros  "a mano" el contexto y la referencia.


Y luego, agregar esto a nuestro runtimeModule para que la use:





        @Override
        **public void** configureIScopeProviderDelegate(com.google.inject.Binder binder) {
 `binder.bind(org.eclipse.xtext.scoping.IScopeProvider.class)`
 `.annotatedWith(Names.named(AbstractDeclarativeScopeProvider.NAMED_DELEGATE))`
 `.to(NamespaceAwareScopeProvider.class);`
        }


        @Override
        **public** Class<? **extends** XbaseBatchScopeProvider> bindXbaseBatchScopeProvider() {
 `**return** MappingBatchScopeProvider.**class**;`
        }


Lo segundo es como ya vimos para que use nuestra clase.
Lo primero es un workaround medio oscuro que sirve para que el nuevo "bindXbaseBatchScopeProvider", use internamente a nuestro **MappingScopeProvider** que ya definimos antes.


Ahora sí !
### []()AutoComplete

Para el autocomplete no hay que hacer nada, si bien es un punto de extensión del proyecto ".ui", por default al haber definido el scope con los providers, el autocomplete usa a los scopeProviders, así que deberían ver esto:



[![](https://sites.google.com/site/programacionhm/_/rsrc/1402323115061/conceptos/dsls/domainspecificlanguage/dsl---xtext/xtext-dsl---orm-mappings/autocomplete.png)
](conceptos-dsls-domainspecificlanguage-dsl---xtext-xtext-dsl---orm-mappings-autocomplete-png?attredirects=0)