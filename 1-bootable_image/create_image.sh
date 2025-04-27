# Crear un archivo llamado main.img y escribir una secuencia específica de bytes
printf '\364%509s\125\252' > main.img

# Crear un archivo llamado a.S y escribir la instrucción "hlt" en él
echo hlt > a.S

# Ensamblar el archivo a.S y generar un archivo objeto llamado a.o
as -o a.o a.S
