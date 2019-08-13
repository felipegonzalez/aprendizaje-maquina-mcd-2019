# Aprendizaje de Máquina (ITAM, Otoño 2019)

Notas y material para el curso de Aprendizaje de Máquina

- [Notas](https://trusting-payne-50ed4b.netlify.com). Estas notas son producidas
en un contenedor de [Docker](https://www.docker.com/products/docker-desktop) (con imagen base de [rocker *verse*](https://www.rocker-project.org), y unos
8G de memoria) construido con el Dockerfile del repositorio. Para trabajar en este contenedor.
- [Canal de Slack](https://join.slack.com/t/aprendizajeitam2019/shared_invite/enQtNzIyNzEyNTEyNTAwLWZkZDRmYmFhZjJhZWJhYmI2MTQ3NWIyN2E3ODhlMjhhNTZmNjE0MmY4NTJhM2EzZGQxMjMxYTNmYjVkYjM0ZmM)

### Trabajando con el contenedor

1. En el directorio donde está *Dockerfile*, correr:
```
docker build -t a-maquina .
```

2. Arranca el contendor (*mipass* puede ser lo que quieras, y sustituye la ruta del repositorio):

```
docker run --rm -p 8787:8787 -e PASSWORD=mipass -v ~/tu/carpeta/local:/home/rstudio/ma a-maquina
```

3. Abre en un navegador localhost:8787

Una vez que estés en tu sesión de rstudio en el navegador, puedes trabajar normalmente en rstudio. Los archivos que
guardes estarán en la carpeta de tu repositorio local aunque apagues el contenedor. Para correr las notas 
usa el script notas/\_build.sh en una terminal (en el directorio notas). Abre el archivo notas/\_book/index.html para ver tu copia local de las notas. Todos 
los ejercicios y tareas corren también en ese contenedor. Es opcional usarlo,
pero si tienes problemas de reproducibilidad puedes intentarlo.


### Contribuciones

En años anteriores han contribuido a este repositorio:

- Cinco o más commits: [AlejandraLLI](https://github.com/AlejandraLLI), [mkokotchikova](https://github.com/mkokotchikova)
- Menos de cinco commits: [FedericoGarza](https://github.com/FedericoGarza), [juanber91](https://github.com/juanber91), [MrFranciscoPaz](https://github.com/MrFranciscoPaz)
