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
    --El pajaro salta con velocidad  bird.rotation=-45
 --  transition.cancel()
	-- bird:setLinearVelocity(0,-300)
 --  transition.to( bird, { rotation=-35 , time=210, transition=easing.inOutSine } )
 --  transition.to( bird, { rotation=89 , time=250, delay=700,transition=easing.inOutSine } )    
	-- bird:setLinearVelocity(0,-300)
	transition.cancel()
	bird:setLinearVelocity(0,-205)
  transition.to( bird, { rotation=-31 , time=240, transition=easing.inOutSine } )
  transition.to( bird, { rotation=89,time=240 , delay=700,transition=easing.inOutSine } )    
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
local background = display.newImageRect("images/background-night.png",w*2,h*2)
background:addEventListener("tap",myTapListener)


--carga la imagen del pájaro
--corta el spriteSheet con las medidas de la imagen y crea la secuencia de los sprites
	
	local sheetData2 = { width=40, height=27.5, numFrames=3, sheetContentWidth=40, sheetContentHeight=84 }
	local mySheet2 = graphics.newImageSheet( "images/bird2.png", sheetData2 )
	local runningSecuenceFly2 ={name="normalRun",start=1,count=3,time=550,loopCount,loopDirection="forward"}
	bird =display.newSprite(mySheet2,runningSecuenceFly2)
	bird.x = display.contentWidth/3  --center the sprite horizontally
	bird.y = display.contentHeight/3  --center the sprite vertically
	bird.xScale = 0.9 * bird.xScale
	bird.yScale = 0.9 * bird.yScale

	bird:play()  

	--funcion que simula el salto de pajaro al principio
	  local function bounceFlappy(flappy, speed)
	    local function bounceFlappyDown(flappy)
	      transition.to( flappy, { y = flappy.y + 13 , time=300, transition=easing.inOutSine, onComplete=bounceFlappy } )
	    end
	    transition.to( flappy, { y = flappy.y - 13 , time=300, transition=easing.inOutSine, onComplete=bounceFlappyDown } )
	  end
	  bounceFlappy(bird)


--le añade dísica al´pájaro

physics.addBody(bird,{density=1,friction=0.5,bounce=0.3})

-- aumenta la gravaded para que el pájaro caiga más rápido
bird.gravityScale = 2
--define la distancia entre los pipes en funcion del tamaño del pájaro
--gap = bird.height * 2
gap = bird.height *4
--saca dos pares de pipes
pipedown1 = display.newImage("pipeDown.png",w * 2,h)
pipeup1 = display.newImage("pipeUp.png",w * 2,-gap)
pipedown2 = display.newImage("pipeDown.png",w * 4,h)
pipeup2 = display.newImage("pipeUp.png",w * 2,-gap)

--aumenta la gravedad para que el pájaro caiga más rápido
--bird.gravityScale = 2

vel = -4
--physics.addBody(bird,"static")
--les pone física a los pipes
physics.addBody( pipedown1, "static" )
physics.addBody( pipeup1, "static" )
physics.addBody( pipedown2, "static" )
physics.addBody( pipeup2, "static" )

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
pipedown1.x = w * 2
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
	pipedown1.x = pipedown1.x + vel
	pipeup1.x = pipedown1.x 
	pipedown2.x = pipedown2.x + vel
	pipeup2.x = pipedown2.x
	
	end
	if (not isdead) then
		gnd1.x = gnd1.x + vel
		gnd2.x = gnd2.x + vel
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


