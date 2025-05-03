# Crea una imagen llamada main.img
printf '\364%509s\125\252' > main.img

# Crea un archivo llamado a.S y escribe la instrucción "hlt" en él
echo hlt > a.S

# Crea el archivo assembly a.S y generar un archivo objeto llamado a.o
as -o a.o a.S
