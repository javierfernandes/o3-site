[![Netlify Status](https://api.netlify.com/api/v1/badges/8542a785-82e3-4d36-bfc9-1276090ed89e/deploy-status)](https://app.netlify.com/sites/o3/deploys)

# o3-site

Sitio de Objetos 3 en Hugo.

Nota: 
El contenido no fue escrito desde cero. Lo que hicimos fue utilizar un script para exportar nuestro anterior "Google Site". Luego otro script para pasar de HTML a markdown. 
Y finalmente metimos eso en un sitio "hugo" y empezamos a migrar el contenido que necesitábamos.

Contamos esto porque en la migración las herramientas no son perfectas y rompieron bastante contenido en el formato MD.
Así que es bastante probable que todavía queden páginas por arreglar.

# Setup

Este sitio utiliza [Hugo](https://gohugo.io/getting-started/usage/) así que vas a necesitar el CLI instalado localmente.

# Deploy a la nube

Tenemos "continuous deployment". Cada push que se haga a `master` va a disparar un nuevo build y deploy automáticamente.
Para esto usamos [Netlify](https://www.netlify.com/)

# Ejecutar el sitio localmente

Para probar cambios localmente.
Es necesario primero inicializar el submodulo git con el theme que estamos utilizando para Hugo (minimo)

# `git submodule init`
# `git submodule update`
# `yarn start`


# Autoindexado

En un momento teníamos un hook que autoindexaba en cada commit el contenido para el buscador. Pero se empezó a romper y empiezan las clases :P Dejo acá el script

```js
  "husky": {
    "hooks": {
      "pre-commit": "yarn build-search-index && ./scripts/update-last-changed && git add ./public"
    }
  },
```
