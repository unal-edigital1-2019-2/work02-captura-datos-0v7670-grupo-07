## ELECTRÓNICA DIGITAL 1 2019 -2 UNIVERSIDAD NACIONAL DE COLOMBIA 
## TRABAJO 02- diseño y prueba del HDL para la cámara OV7670
BYRON ADOLFO ERAZO CHALUPUD

JHON EDISON BOHORQUEZ MARTINEZ

## Introducción 
En este trabajo se realiza el diseño e implementación de la captura de datos de la cámara "captura_datos_downsampler" según la configuración 320x240 16b pixel. Además de esto se realiza la adaptación del bloque PLL, teniendo en cuenta que la señal de reloj viene de la FPGA Spartan 6 y la seleccionada por el grupo para la implementación del proyecto corresponde a la Artix 7, así como la adaptación de los datos para que se almacenen en la memoria, teniendo en cuenta que el formato debe ser RGB332. Una vez diseñado e implementado el bloque "captura_datos_dawnsampler", se procede a instanciarlo en el **test_cam.v** para probar la funcionalidad del diseño.

## Diseño e Implementación del Bloque captura_datos_downsampler.v
Para el diseño de este modulo se tienen en cuenta como señales de entrada las de sincronia que vienen de la camara (PCLK, D, VSYNC Y HREF) y las que van a DP_RAM (DP_RAM_regW, DP_RAM_addr_in, DP_RAM_data_in) como salidas.

![DIAGRAMA](./figs/1.png)


La señal PCLK, es la señal que indica cuando deben ser leído cada uno del byte de información, por lo que será la señal de control y a través de posedge cada vez que se produzca un flanco de subida esta deberá ejecutar el código que permita leer la información. Además de esto se debe adaptar del formato RGB565 de la salida de la camara al formato RGB332 el cuál tendrá un tamaño de 8 bits.
 </div>
 
 ![DIAGRAMA](./figs/21.png)

Para dicha adaptación se hace uso de los tres digitos más significativos del color rojo, tres del verde y dos del azul.

## Diseño del downsampler y transmisión al buffer de memoria
Como se explicó en el apartado anterior se tiene como señales de entradas las señales de sincronía del **Timing Generator** y las señal de entrada de datos, **D**, La cual tiene un longitud de 8bits y viene directamente de los pines del **DATA** del sensor y corresponden a los bits enviados por la cámara en cada ciclo de PCLK.

Las salidas del módulo **captura_down_sampler.v** serán las entradas del Buffer **BUFFER_DP_RAM** por lo que deberá contar con una entrada que indique la dirección de memoria en la que se escribe el dato y otra que indique cuando se escribe, por lo que el módulo contara con las siguientes señales de entrada:

**DP_RAM_addr_in:** Esta señal de memoria actualiza la posición de memoria con cada pixel recibido y de esta manera no se presente sobreescritura.

**DP_RAM_regW:** Se activa cuando se haya recibido el píxel completo, indicando cuando se puede escribir en memoria.

En el buffer se almacena una imagen completa, por lo que hay que reiniciar la posición de memoria, cada vez que recibe un fotograma, es decir cuando VSYNC cambia a nivel alto.

La siguiente parte se encarga de leer el pixel completo teniendo en cuenta la secuencia para el formato de color. Para controlar los cilos de escritura, habilitamos cont.

![DIAGRAMA](./figs/lectPixel.png)

Guardamos en la señal **DP_RAM_data_in**, la cual contiene el pixel completo en el formato RGB332.

Mediante el uso del evento de flanco **negedge** (flanco de bajada) y la condicional ~VSYNC y HREF en alto, actualiza la posición de memoria.

![DIAGRAMA](./figs/ActPmem.png)


Para diseñar e implementar la captura de datos según la configuración seleccionada en el Work01, se deberá adaptar los datos para que se almacene en la memoria el pixel con el formato RGB332. Según el esquema de trabajo una vez se tenga el diseño "captura_datos_downsampler" se deberá instanciar el bloqlue HDL en el test_cam.v y proceder a probar la funcionalidad del diseño. Para lo cual se debera analizar el proyecto propuesto ***test_cam.xise*** junto con la figura siguiente.  
![DIAGRAMA](./figs/test_cam2.png)
En la figura anterior se observa que se debe adicionar las señales de amarillo y el bloque ***captura_datos_downsampler*** para completar el el proyecto ***test_cam.xise***. Se adecuo el bloque azul ***PLL*** a la FPGA Artix7.  

**MATERIAL**   
Para realizar el trabajo se hace uso del siguiente material:   

* Pantalla con entrada VGA y cuya resolución sea 640x480.
* FPGA que cuenta con puerto VGA.
* Cable VGA.
* Plantilla del proyecto sugerido [WP02](https://classroom.github.com/g/fTcztVJQ) .
* Datasheet de la cámara OV7670.


## Desarrollo

El paquete de trabajo debe desarrollar el siguiente bloque funcional:

![CAPTURADATOS](./figs/cajacapturadatos.png)

Para lo cual, la captura de datos debe ser acorde al funcionamiento de la cámara. para ello debe analizar la siguiente gráfica:

![CAPTURADATOS](./figs/cajacapturadatos2.PNG)


**1. Diseñar el sistema digital de captura de los pixeles de la cámara. No es necesario incluir las señales de control  Xclk, pwdn y reset, estas están descritas en el top del proyecto.**  

para desarrolar el software que permita ella captura de datos de la camara se debe tener encuenta las senales involucradas en el proceso  D[7:0], PCLK, VSYNC y HREF.
Los datos generador por estas señales  se almmacenan en un registro de 8 bits, ya que se va utilizar el formato RGB 332 se debe instanciar  la direccion donde se almacena cada pixel que se crea por las señales de entrada que vienen de la camara,PCLK   el cual permite que los datos se almacenen de manera sincronica entre la camara y la memoria. HREF  transmision de informacion de pixeles, VSYNC idica el inicio y la terminacion de la captura de datos 

![Specifications](./figs/2.PNG)



2. Diseñar el downsampler y transmitir la información al buffer de memoria. Recuerde la memoria se ha diseñado para almacenar el pixel en formato RGB332, y almacenar 3 bit para el color Rojo y Verde y 2 bit para el color Azul. Si usted, por ejemplo, selecciona el formato RGB565 de la cámara debe convertir los 5 bit de rojo en 3 bit.

***RECUEDE: Es necesario documentar el módulo diseñado con los respectivos diagramas funcionales y estructurales y registrar la información en README.md ***

Una vez clone el repositorio, en su computador de la plantilla del proyecto [WP02](https://classroom.github.com/g/fTcztVJQ), realizar lo siguiente: 

3. Revisar si el bloque PLL, `clk_32MHZ_to_25M_24M.v` (diagrama azul de la figura 1), propuesto en el bloque test_cam.v, cumple con las necesidades de reloj de entrada y salida para la plataforma utilizada. Recuerde el sistema requiere además de los 32, 50 o 100 Mhz de entrada, generar dos señales de reloj de 25Mhz y 24 Mhz para la pantalla VGA y la Cámara respectivamente. En este sentido, el archivo `clk_32MHZ_to_25M_24M.v` se encuentran en el interior de la carpeta `hdl/scr/PLL`, se debe modificar. 

acontinuacion se uestra el poceso para la genracion del archivo clk_32MHZ_to_25M_24M.v´

1) en n el IDE de ISE debe utilizar tools -> Core Generator buscar clocking wizard.
en la priera pagina desplegada cabiamos unicamente en source a global clock 

![Specifications](./figs/clock1.png)


![Specifications](./figs/clock2.png)


2. en la segunda pagina creamos las señales de 24 y 25  MHz

![Specifications](./figs/clock3.png)

3) en las siguientes ventanas solo damos siguiente


![Specifications](./figs/clock4.png)


4) damos click en generar y se crea las señales del reloj el cual replazaos en la carpeta PLL

![Specifications](./figs/clock5.png)



![Specifications](./figs/2.PNG)

 	* Remplazar en el proyecto **test_cam.xise**, el archivo `clk_32MHZ_to_25M_24M.v` por el generado pro ustedes.
 	* Cambiar los datos necesarios en el archivo `test_cam.v` para instanciar el nuevo PLL.
 	* Documentar en README.md el proceso realizado.




### Implementación 

Al culminar los hitos anteriores deben:

1. Crear el archivo UCF.

para la implementacion del archivo UCF se tuvo encuenta  las variables declaras para entraada y salida en el test_cam.v tales como: la señales del reloj clk y rst. se define CAM_PCLK como señal de entrada, se activa los puertos VGA, y las entradas de la camara en los  puertos pmode Header de la FPGA 



Se declararan las salidas del puerto VGA: los puertos para el pixel; que son 12 debido a que la pantalla recibe formato RGB 444; otro puerto para VGA_Hsync_n y otro para VGA_Vsync_n. 

2. Realizar el test de la pantalla. Programar la FPGA con el bitstream del proyecto y no conectar la cámara. ¿Qué espera visualizar?, ¿Es correcto este resultado ?

se espera visualizar los datos almacendos en el archivo image.men  el cual conforma  lineas veritcales de colores ( Blanco FF  Rojo E0,Verde 1, Azul 03) efectivaente como se uestra a continuacion

![Specifications](./figs/foto3.png)

![Specifications](./figs/foto2.png)


3. Configure la cámara en test por medio del bus I2C con ayuda de Arduino. ¿Es correcto el resultado? ¿Cada cuánto se refresca el buffer de memoria ?

 en la inforacion de la camara ov7670 se detalla que es capaz de enviar 30 cuadros por segundo y ddepndiendo del tamaño este sera mas rapido  o lento, para una configuracion de tamaño 320 x240 pixeles esta termina un frame cada 33.3 ms ya que la cámara termina de completar  76.800 pixeles. 

4. ¿Qué falta implementar para tener el control de la toma de fotos ?

un boton que permita controlar cuando se caprura una sola fotografia

***RECUEDE: Es necesario documentar la implementación y registrar la información en README.md, lo puede hacer con ayuda de imágenes o videos***
