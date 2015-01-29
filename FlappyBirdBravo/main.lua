-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- funcion que se ejecuta cuando se hace tap
local function myTapListener( event )
	--inicia lla fisica, talvez esto debería de ejecutarse solo la primera vez
	physics.start()
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
physics.addBody( pipedown, "kinematic" )
physics.addBody( pipeup, "kinematic" )
--define velocidad de pipes
local vel = -100
--mueve pipes
pipedown:setLinearVelocity( vel, 0)
pipeup:setLinearVelocity( vel, 0)

--pausa para que la física se active cuando se haga el primer
physics.pause()





