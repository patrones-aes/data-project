# Proyecto Modelos y Persistencia de Datos 🗃️

En este repositorio se encuentra la configuración de las bases de datos para el proyecto del curso. A continuación se presentan los comandos para ejecutar las bases de datos. Vale la pena resaltar que es necesario tener **Docker** y **Docker Compose** descargados.

Los siguientes pasos se ejecutan en la carpeta principal del proyecto:

Para montar las bases de datos se utiliza el comando:

Para Linux
```bash
chmod +x ./scripts/stop.sh
./scripts/start.sh
```

Para Windows
```batch
.\scripts\start.bat
```

Para bajar las bases de datos y borrar los volumenes se utiliza el comando

Para Linux
```bash
chmod +x ./scripts/stop.sh
./scripts/stop.sh
```

Para Windows
```batch
.\scripts\start.bat
```
