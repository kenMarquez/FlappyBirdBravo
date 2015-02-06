
	local composer = require( "composer" )
	local	scene = composer.newScene()

	local gameNetwork2 = require( "gameNetwork" )
	local playerName2

	local function loadLocalPlayerCallback( event )
	   playerName2 = event.data.alias
	   saveSettings()  --save player data locally using your own "saveSettings()" function
	end

	local function gameNetworkLoginCallback( event )
	   gameNetwork2.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
	   return true
	end

	local function gpgsInitCallback( event )
	   gameNetwork2.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
	end

	local function gameNetworkSetup()
	   if ( system.getInfo("platformName") == "Android" ) then
	      gameNetwork2.init( "google", gpgsInitCallback )
	   else
	      gameNetwork2.init( "gamecenter", gameNetworkLoginCallback )
	   end
	end

	------HANDLE SYSTEM EVENTS------
	local function systemEvents( event )
	   print("systemEvent " .. event.type)
	   if ( event.type == "applicationSuspend" ) then
	      print( "suspending..........................." )
	   elseif ( event.type == "applicationResume" ) then
	      print( "resuming............................." )
	   elseif ( event.type == "applicationExit" ) then
	      print( "exiting.............................." )
	   elseif ( event.type == "applicationStart" ) then
	      gameNetworkSetup()  --login to the network here
	   end
	   return true
	end

	Runtime:addEventListener( "system", systemEvents )
		




	composer.removeHidden()
	physics = require("physics")
	widget = require("widget")
	
	local ego =require("ego" )
	local saveFile = ego.saveFile
	local loadFile = ego.loadFile

	local function checkForFile ()
		if highscore == "empty" then
		highscore = 0
		saveFile("highscore.txt", highscore)
		print ("Highscore is", highscore)
			end
		end

		timer.performWithDelay( 0, checkForFile )
		highscore = loadFile ("highscore.txt")

		print ("Highscore is", highscore)


	function unlockMyAhievement( achivement  )				
					--myAchievement = "CgkIy6imvI0YEAIQAg"					
					gameNetwork2.request( "unlockAchievement",
					{
   					achievement = { identifier=achivement, percentComplete=100, showsCompletionBanner=true },
   					listener = achievementRequestCallback
					} )
			end
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
		if (not isdead) then
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


			--local vuelosound = audio.loadSound("sounds/vuelo.mp3")
			--audio.play(vuelosound)
			
			media.playSound( "vuelo.mp3" )

		  	
		  	transition.to( bird, { rotation=-25 , time=180, transition=easing.inOutSine } )
		 	transition.to( bird, { rotation=89,time=260 , delay=600,transition=easing.inOutSine } )    
			bird:setLinearVelocity(0,-245)
		end
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
			counScore =0;
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
		bird.gravityScale = 2.2
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
		reload = false

		--despliega un par de ground para estar en infinito movimiento y les añade física
		gnd1=display.newImage("ground.png", 0, h )
		physics.addBody( gnd1, "static" )
		gnd2=display.newImage("ground.png", 0, h )
		physics.addBody( gnd2, "static" )
		--define un offset para una buena continuidad entre los grounds
		offset=-0
		--coloca el segundo ground		
		gnd2.x = gnd1.x + gnd1.width * 0.5 + gnd2.width*0.5 + offset
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

		function scorepoints( event )
			if (displayscore ~= nil) then
				display.remove( displayscore )
			end
			if (displayhighscore ~= nil) then
				display.remove( displayhighscore )
			end

			displayscore = display.newText( tostring (score), w * 0.5 + 75, h*0.3 -18, "font", 14 )
			displayhighscore = display.newText( highscore, w * 0.5 + 75, h*0.3 + 25, "font", 14 )
		end

			displayscore = display.newText( tostring (score), w*0.5, h*0.1, "font", 30 )
		local function scoreupdate( event )
			display.remove( displayscore )
			if (displayhighscore ~= nil) then
				display.remove( displayhighscore )
			end

			if (not isdead) then
			displayscore = display.newText( tostring (score), w*0.5, h*0.1, "font", 30 )
			end
			if (pipedown1.x-pipedown2.width/3.1 <= bird.x and newpipe1) then
				--local punto = audio.loadSound("sounds/punto.mp3")
				--audio.play(punto)
				media.playSound( "punto.mp3" )
				newpipe1 = false
				score = score + 1
				
				if (score> tonumber(highscore)) then
					highscore = score
					saveFile("highscore.txt", highscore)
				end
				print(score)


			end

			if (pipedown2.x-pipedown2.width/2.8 <= bird.x and newpipe2) then
				--local punto = audio.loadSound("sounds/punto.mp3")
				--audio.play(punto)
				media.playSound( "punto.mp3" )

				newpipe2 = false
				score = score + 1
				if (score> tonumber(highscore)) then
					highscore = score
					saveFile("highscore.txt", highscore)
				end
				print(score)
			end


			if (score ==  1) then
				myAchievement = "CgkIy6imvI0YEAIQAg"					
				unlockMyAhievement(myAchievement)
				end
			if (score ==  5) then				
				myAchievement = "CgkIy6imvI0YEAIQAw"					
				unlockMyAhievement(myAchievement)
			end
			if (score ==  20) then				
				myAchievement = "CgkIy6imvI0YEAIQBA"					
				unlockMyAhievement(myAchievement)
			end
			if (score == 40 ) then				
				myAchievement = "CgkIy6imvI0YEAIQBQ"					
				unlockMyAhievement(myAchievement)
			end
			if (score == 50 ) then				
				myAchievement = "CgkIy6imvI0YEAIQBg"					
				unlockMyAhievement(myAchievement)
			end

		end

		local function Replay( event )

		if ( "ended" == event.phase ) then
		display.remove( button1 )
		display.remove( scoreboard)
		display.remove( gameover )

		bird.x = display.contentWidth/4
		bird.y = display.contentHeight/2
		bird:play() 
		bird:setLinearVelocity( 0, 0 )
		bird.rotation = 0
		isdead = false
		score = 0
		physics.pause( )
		paused = true
		bounceFlappy(bird)
		--coloca los pipes en alturas random
		pipedown1.x = w * 2
		pipedown1.y = math.random(minpipe, maxpipe)
		pipeup1.y = pipedown1.y - pipedown1.height * 0.5 - pipeup1.height * 0.5 - gap
		pipeup1.x=pipedown1.x
		--coloca el segundo par de pipes
		pipedown2.x = pipedown1.x + pipedown1.width * 4
		pipedown2.y = math.random(minpipe, maxpipe)
		pipeup2.y = pipedown2.y - pipedown2.height * 0.5 - pipeup2.height * 0.5 - gap
		pipeup2.x = pipedown2.x

		newpipe1 = true
		newpipe2 = true
		print( "Button was pressed and released" )

		splashImage = display.newImage("images/splash.png")
		splashImage:translate( w /2, h/2 )
		visibleSplash = true
		splashImage.alpha = 0
		bird:addEventListener("collision",bird)
		Runtime:removeEventListener( "enterFrame", scorepoints )
		local function addlisten( event )
			background:addEventListener("tap",myTapListener)
		end

		transition.to(splashImage,{time=150000,alpha=250})
		timer.performWithDelay( 100, addlisten )
		--background:addEventListener("tap",myTapListener)
			end
		end

		local function reloadmenu( event)
			button1 = widget.newButton
		{
		width = 104,
		height = 58,
		defaultFile = "images/replay.png",
		overFile = "images/replay2.png",
		onEvent = Replay
		}
-- Center the button
		button1.x = display.contentCenterX
		button1.y = display.contentCenterY+ 20
		background:removeEventListener("tap",myTapListener)
		Runtime:addEventListener( "enterFrame", scorepoints )
		--timer.performWithDelay( 10, scorepoints )

		end

		local function loadscore( event )
			scoreboard = display.newImage("images/scoreboard1.png")
			scoreboard:translate( w * 0.5, h  )
			displayscoreboard = true
			
			--timer.performWithDelay( 1000, scorepoints )
			--displayscore = display.newText( tostring (score), w*0.5 , h*0.3, native.systemFont, 24 )
			transition.to(scoreboard,{y = h * 0.4 , time = 500, delay = 0, transition = easing.inOutSine, onComplete=reloadmenu})
		end


		local function birdcollision(self, event)
		   if event.phase == "began" then		   		
		   		bird:removeEventListener("collision",bird)

		   	local function  secondSound( event )
		   		
				media.playSound( "caida.mp3" )
		   	end
		   		
		   	if(not isdead) then		   				
				media.playSound( "golpe.mp3" )
				print(gnd1.y)
				print(bird.y)
				altura = gnd1.y-gnd1.height+3
				print(altura)
				if ( bird.y < altura) then
					timer.performWithDelay(500,secondSound)
				end
		   	   rectangulo = display.newRect(w*0.5,h*0.5,w*2,h*2)

		   	   rectangulo:setFillColor(255,255,255)
		       transition.to(rectangulo,{time=100,alpha=0 })

   		       gameover = display.newImage("images/gameover.png")
				gameover:translate( w /2, gameover.height * 0.5)
				displaygameover = true
				local function bouncegameover( event )
					transition.to( gameover, { y = gameover.y + 20  , time=300, transition=easing.inOutSine, onComplete=loadscore} )
				end
				transition.to( gameover, { y = gameover.y - 30 , time=300, transition=easing.inOutSine, onComplete=bouncegameover } )
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


