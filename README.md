# TrabajosEnGrupoGII
Repositorio para todos los trabajos en equipo de la universidad.

#INSTRUCCIONES BÁSICAS:

---

#  **Manual sin consola:**

## Pasos para Añadir Nuevas Carpetas y Archivos Manualmente (Sin Consola)

### 1. **Navegar al Directorio Correcto**
   - Si deseas agregar una nueva carpeta o archivo en un directorio específico, navega hasta ese directorio dentro del repositorio.

### 2. **Crear un Nuevo Archivo**
   - Haz clic en el botón **Add file**.
   - Selecciona **Create new file**.
   - Para crear un archivo dentro de una nueva carpeta, escribe el nombre de la carpeta seguido de una barra `/` y luego el nombre del archivo. Por ejemplo:
     ```
     nueva-carpeta/archivo.txt
     ```
      2.1 **Crear una Nueva carpeta**
      - Haz clic en el botón **Add file**.
      - Selecciona **Create new file**.
     ```
     nueva-carpeta/
     ```
     

### 3. **Editar el Contenido del Archivo**
   - Ingresa el contenido del archivo en el editor proporcionado por GitHub.

### 4. **Guardar el Archivo**
   - En la parte inferior de la página, añade un mensaje descriptivo en la sección **Commit changes**.
   - Selecciona si deseas guardar los cambios directamente en la rama principal (**main**) o en una nueva rama.
   - Haz clic en **Commit new file** para guardar el archivo.

### 5. **Subir Archivos Existentes**
   - Si deseas subir un archivo que ya tienes en tu computadora:
     1. Haz clic en **Add file**.
     2. Selecciona **Upload files**.
     3. Arrastra y suelta los archivos o selecciona los archivos desde tu computadora.
     4. Escribe un mensaje en la sección **Commit changes** y haz clic en **Commit changes**.

---

# ** MANUAL A TRAVÉS DE LA CONSOLA: **

## Pasos para Añadir Nuevas Carpetas y Archivos al Repositorio

### 1. **Clonar el Repositorio (si no lo tienes ya)**
   Si aún no tienes una copia local del repositorio, clónalo ejecutando el siguiente comando en tu terminal:
   ```bash
   git clone <URL-del-repositorio>
   ```
   Reemplaza `<URL-del-repositorio>` con la URL del repositorio.

### 2. **Navegar al Directorio del Repositorio**
   Cambia al directorio del repositorio clonado:
   ```bash
   cd <nombre-del-repositorio>
   ```

### 3. **Crear una Nueva Carpeta o Archivo**
   - Para crear una nueva **carpeta**:
     ```bash
     mkdir <nombre-de-la-carpeta>
     ```
   - Para crear un nuevo **archivo** dentro de una carpeta existente o la nueva:
     ```bash
     touch <ruta/nombre-del-archivo>
     ```
     Ejemplo:
     ```bash
     touch nueva-carpeta/archivo.txt
     ```

### 4. **Agregar los Nuevos Cambios al Índice**
   Una vez que hayas creado las carpetas o archivos, agrégalos al índice de Git:
   ```bash
   git add <ruta/nombre-del-archivo-o-carpeta>
   ```
   Para agregar todos los cambios a la vez:
   ```bash
   git add .
   ```

### 5. **Confirmar los Cambios**
   Realiza un commit con un mensaje que describa los cambios realizados:
   ```bash
   git commit -m "Añadir nueva carpeta y archivo: <descripción>"
   ```

### 6. **Enviar los Cambios al Repositorio Remoto**
   Sube tus cambios al repositorio remoto:
   ```bash
   git push origin <nombre-de-la-rama>
   ```
   Por lo general, la rama principal es `main`, pero verifica el nombre de la rama que estás usando.

### 7. **Crear un Pull Request (Opcional)**
   Si estás trabajando en una rama distinta y necesitas que tus cambios sean revisados antes de ser fusionados:
   - Ve al repositorio en GitHub.
   - Haz clic en el botón **Pull Request**.
   - Selecciona tu rama y crea la solicitud.

### Notas Adicionales:
- Asegúrate de estar siempre en la última versión de la rama en la que estás trabajando. Antes de realizar cambios, ejecuta:
  ```bash
  git pull origin <nombre-de-la-rama>
  ```
- Si tienes dudas, no olvides contactar al administrador del repositorio. ;)

