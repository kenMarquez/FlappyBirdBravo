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
--aumenta la gravedad para que el pájaro caiga más rápido
bird.gravityScale = 2
--crea dos pipes que se mueven (posteriormente agregaré mas es solo para pruebas de colision)
--define un espacio entre pipes
local gap = h * 0.3
--pone dos pipes
pipedown = display.newImage("pipeDown.png",w,h+gap)
pipeup = display.newImage("pipeUp.png",w,-gap)
--le pone fisica a los pipes
physics.addBody( pipedown, "static" )
physics.addBody( pipeup, "static" )
--define velocidad de pipes
vel = -4
--mueve pipes


--pausa para que la física se active cuando se haga el primer
physics.pause()
paused = true


gnd1=display.newImage("ground.png", 0, h )
physics.addBody( gnd1, "static" )
gnd2=display.newImage("ground.png", 0, h )
physics.addBody( gnd2, "static" )
offset=-35
gnd2.x=gnd1.x+gnd1.width*0.5+gnd2.width*0.5+offset
--ground2=display.newImage("ground.png", w, h )

--ground1.y =ground1.height-ground1.height*0.5
local function moveground( event )
	if (paused == false) then
	gnd1.x = gnd1.x + vel
	gnd2.x = gnd2.x + vel
	pipedown.x = pipedown.x + vel
	pipeup.x = pipeup.x + vel
	end
	if(gnd1.x< -gnd1.width * 0.5) then
		gnd1.x = gnd2.x + gnd2.width*0.5 + gnd1.width*0.5+offset
	end
	if(gnd2.x< -gnd2.width * 0.5) then
		gnd2.x = gnd1.x + gnd1.width*0.5 + gnd2.width*0.5+offset
	end
end

Runtime:addEventListener( "enterFrame", moveground )

