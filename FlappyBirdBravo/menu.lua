	composer = require( "composer" )
	physics = require("physics")
	local scene = composer.newScene()

	---------------------------------------------------------------------------------
	-- All code outside of the listener functions will only be executed ONCE
	-- unless "composer.removeScene()" is called.
	---------------------------------------------------------------------------------

	-- local forward references should go here

	---------------------------------------------------------------------------------


	local function myTapListener( event )
		if (visibleSplash) then
			display.remove(splashImage)
			visibleSplash=false
		end
			display.remove(rectangulo)
				--inicia lla fisica, talvez esto debería de ejecutarse solo la primera vez
			physics.start()
			paused = false
			isdead = false
			bird:play()
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
			bird:setLinearVelocity(0,-200)
		  transition.to( bird, { rotation=-30 , time=220, transition=easing.inOutSine } )
		  transition.to( bird, { rotation=89,time=240 , delay=700,transition=easing.inOutSine } )    
			bird:setLinearVelocity(0,-245)
		    return true
		end

	-- "scene:create()"
	function scene:create( event )

	   local sceneGroup = self.view
	   w = display.contentWidth
	   h = display.contentHeight
	    --w = display.viewableContentWidth
		-- h = display.viewableContentHeight
		-- --carga la imagen de fondo
		background = display.newImageRect("images/background-night.png",w*2,h*2)
		background:addEventListener("tap",myTapListener)
		sceneGroup:insert( background )
		
	   -- Initialize the scene here.
	   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
	end

	-- "scene:show()"
	function scene:show( event )

	   local sceneGroup = self.view
	   local phase = event.phase

	   if ( phase == "will" ) then
	      -- Called when the scene is still off screen (but is about to come on screen).
	   elseif ( phase == "did" ) then
	      -- Called when the scene is now on screen.
	      -- Insert code here to make the scene come alive.
	      -- Example: start timers, begin animation, play audio, etc.   
		--carga la imagen de fondo	
			physics.start()

			splashImage = display.newImage("images/splash.png")
			splashImage:translate( w /2, h/2 )
			visibleSplash = true
			splashImage.alpha = 0
			--splashImage:setFillColor(255,255,255,0)
			transition.to(splashImage,{time=150000,alpha=250})
			
			-- local function listener( event )
	  --   	splashImage.alpha=255
			-- end
			-- timer.performWithDelay( 1000, listener )

			local sheetData2 = { width=40, height=27.5, numFrames=3, sheetContentWidth=40, sheetContentHeight=84 }
			local mySheet2 = graphics.newImageSheet( "images/bird2.png", sheetData2 )
			local runningSecuenceFly2 ={name="normalRun",start=1,count=3,time=550,loopCount,loopDirection="forward"}
			bird =display.newSprite(mySheet2,runningSecuenceFly2)
			bird.x = display.contentWidth/3.1  --center the sprite horizontally
			xposition = bird.x
			bird.y = display.contentHeight/1.85  --center the sprite vertically
			bird.xScale = 0.9 * bird.xScale
			bird.yScale = 0.9 * bird.yScale
			bird.isFixedRotation=true
			bird:play()  
			local function bounceFlappy(flappy, speed)
			    local function bounceFlappyDown(flappy)
			      transition.to( flappy, { y = flappy.y + 10 , time=300, transition=easing.inOutSine, onComplete=bounceFlappy } )
			    end
			    transition.to( flappy, { y = flappy.y - 10 , time=300, transition=easing.inOutSine, onComplete=bounceFlappyDown } )
			  end
			  bounceFlappy(bird)
			  physics.addBody(bird,{density=1,friction=0.5,bounce=0.3})

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

		newpipe1 = true
		newpipe2 = true


		local function moveground( event )
			bird.x = xposition
			if (bird.y < -bird.height*2) then
				bird.y = -bird.height*2
				bird:setLinearVelocity(0,0)
			end
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
				newpipe1 = true
			end
			
			if(pipedown2.x < -pipedown2.width * 0.5) then
				pipedown2.x = w + pipedown2.width
				pipedown2.y = math.random(minpipe, maxpipe)
				pipeup2.y = pipedown2.y - pipedown2.height * 0.5 - pipeup2.height * 0.5 - gap
				pipeup2.x = w + pipeup2.width
				newpipe2 = true
			end

		end


		Runtime:addEventListener( "enterFrame", moveground )

		score = 0
		displayscore = display.newText( tostring (score), w*0.5, h*0.1, "font", 24 )
		local function scoreupdate( event )
			display.remove( displayscore )
			displayscore = display.newText( tostring (score), w*0.5, h*0.1, "font", 24 )
			if (pipedown1.x < bird.x and newpipe1) then
				newpipe1 = false
				score = score + 1
				print(score)
			end

			if (pipedown2.x < bird.x and newpipe2) then
				newpipe2 = false
				score = score + 1
				print(score)
			end

		end

		local function birdcollision(self, event)
		   if event.phase == "began" then
		   		--background:setFillColor(255,255,255)
		   		
		   	if(not isdead) then

		   	   rectangulo = display.newRect(w*0.5,h*0.5,w*2,h*2)

		   	   rectangulo:setFillColor(255,255,255)
		       transition.to(rectangulo,{time=100,alpha=0 })

		       --composer.gotoScene("menu")

		   	end
		       isdead = true
		       bird:pause()
		   end
		end
		       
		bird.collision = birdcollision
		bird:addEventListener("collision",bird)

		Runtime:addEventListener( "enterFrame", scoreupdate )


			

	   end
	end

	-- "scene:hide()"
	function scene:hide( event )

	   local sceneGroup = self.view
	   local phase = event.phase

	   if ( phase == "will" ) then
	      -- Called when the scene is on screen (but is about to go off screen).
	      -- Insert code here to "pause" the scene.
	      -- Example: stop timers, stop animation, stop audio, etc.
	   elseif ( phase == "did" ) then
	      -- Called immediately after scene goes off screen.
	   end
	end

	-- "scene:destroy()"
	function scene:destroy( event )

	   local sceneGroup = self.view

	   -- Called prior to the removal of scene's view ("sceneGroup").
	   -- Insert code here to clean up the scene.
	   -- Example: remove display objects, save state, etc.
	end


	---------------------------------------------------------------------------------

	-- Listener setup
	scene:addEventListener( "create", scene )
	scene:addEventListener( "show", scene )
	scene:addEventListener( "hide", scene )
	scene:addEventListener( "destroy", scene )

	---------------------------------------------------------------------------------

	return scene


