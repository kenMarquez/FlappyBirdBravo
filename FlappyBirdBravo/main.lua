-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- funcion que se ejecuta cuando se hace tap
local function myTapListener( event )
	--inicia lla fisica, talvez esto debería de ejecutarse solo la primera vez
	physics.start()
	paused = false
    --code executed when the button is tapped
    print( "object tapped = "..tostring(event.target) )  --'event.target' is the tapped object
    --bird:applyForce(0,-500,bird.x,bird.y)
    --El pajaro salta con velocidad
	bird:setLinearVelocity(0,-300)
    return true
end

--carga el paquete de física
physics = require("physics")
--inicia el paquete
physics.start()
--toma ancho y alto del display
w = display.viewableContentWidth
h = display.viewableContentHeight
--carga la imagen de fondo
local background = display.newImageRect("bg.png",w*2,h*2)
background:addEventListener("tap",myTapListener)
--carga la imagen del pájaro
 bird = display.newImage("bird1.png",100*0.5,100*0.5)
 --coloca el pájar en esas coordenadas
bird.x = 150
bird.y = 100
--le añade dísica al´pájaro
physics.addBody(bird,{density=1,friction=0.5,bounce=0.3})

-- aumenta la gravaded para que el pájaro caiga más rápido
bird.gravityScale = 2
--define la distancia entre los pipes en funcion del tamaño del pájaro
gap = bird.height * 4

--saca dos pares de pipes
pipedown1 = display.newImage("pipeDown.png",w * 2,h)
pipeup1 = display.newImage("pipeUp.png",w * 2,-gap)
pipedown2 = display.newImage("pipeDown.png",w * 2,h)
pipeup2 = display.newImage("pipeUp.png",w * 2,-gap)

--les pone física a los pipes
physics.addBody( pipedown1, "static" )
physics.addBody( pipeup1, "static" )
physics.addBody( pipedown2, "static" )
physics.addBody( pipeup2, "static" )

--define la velocidad de vuelo
vel = -4

--pone el juego en pausa
physics.pause()
paused = true
isdead = false

--despliega un par de ground para estar en infinito movimiento y les añade física
gnd1=display.newImage("ground.png", 0, h )
physics.addBody( gnd1, "static" )
gnd2=display.newImage("ground.png", 0, h )
physics.addBody( gnd2, "static" )
--define un offset para una buena continuidad entre los grounds
offset=-0
--coloca el segundo ground
gnd2.x=gnd1.x+gnd1.width*0.5+gnd2.width*0.5+offset
--define la distancia maxima y minima de los pipes
maxpipe = h + pipedown1.height * 0.5 - gnd1.height
minpipe = pipedown1.height * 0.5 + gap

--coloca los pipes en alturas random
pipedown1.y = math.random(minpipe, maxpipe)
pipeup1.y = pipedown1.y - pipedown1.height * 0.5 - pipeup1.height * 0.5 - gap
--coloca el segundo par de pipes
pipedown2.x = pipedown1.x + pipedown1.width * 4
pipedown2.y = math.random(minpipe, maxpipe)
pipeup2.y = pipedown2.y - pipedown2.height * 0.5 - pipeup2.height * 0.5 - gap
pipeup2.x = pipedown2.x


local function moveground( event )
	--sino esta en pausa o muerto el ground se mueve
	if (not paused  and not isdead ) then
	gnd1.x = gnd1.x + vel
	gnd2.x = gnd2.x + vel
	pipedown1.x = pipedown1.x + vel
	pipeup1.x = pipedown1.x 
	pipedown2.x = pipedown2.x + vel
	pipeup2.x = pipedown2.x
	
	end
	--si los grounds se salen, vuelvan a aparecer a un lado del otro
	if(gnd1.x< -gnd1.width * 0.5) then
		gnd1.x = gnd2.x + gnd2.width*0.5 + gnd1.width*0.5+offset
	end
	if(gnd2.x< -gnd2.width * 0.5) then
		gnd2.x = gnd1.x + gnd1.width*0.5 + gnd2.width*0.5+offset
	end
	--si los pipes se salen aparecen al final
	if(pipedown1.x < -pipedown1.width * 0.5) then
		pipedown1.x = w + pipedown1.width
		pipedown1.y = math.random(minpipe, maxpipe)
		pipeup1.y = pipedown1.y - pipedown1.height * 0.5 - pipeup1.height * 0.5 - gap
		pipeup1.x = w + pipeup1.width
	end
	
	if(pipedown2.x < -pipedown2.width * 0.5) then
		pipedown2.x = w + pipedown2.width
		pipedown2.y = math.random(minpipe, maxpipe)
		pipeup2.y = pipedown2.y - pipedown2.height * 0.5 - pipeup2.height * 0.5 - gap
		pipeup2.x = w + pipeup2.width
	end

end

Runtime:addEventListener( "enterFrame", moveground )


