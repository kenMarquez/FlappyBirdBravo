local composer = require( "composer" )
scene = composer.newScene()




-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   	   	w = display.contentWidth
	   	h = display.contentHeight
		background = display.newImageRect("images/background-night.png",w*2,h*2)		
		sceneGroup:insert( background )  

end


function moveground( event )
	gnd1.x = gnd1.x + vel
	gnd2.x = gnd2.x + vel			
		--si los grounds se salen, vuelvan a aparecer a un lado del otro
	if(gnd1.x< -gnd1.width * 0.5) then
		gnd1.x = gnd2.x + gnd2.width*0.5 + gnd1.width*0.5+offset
	end
	if(gnd2.x< -gnd2.width * 0.5) then
		gnd2.x = gnd1.x + gnd1.width*0.5 + gnd2.width*0.5+offset
	end
	--si los pipes se salen aparecen al final
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then

   			-- imagen de flappy bird titulo
      		splashImage = display.newImage("images/logo.png")
			splashImage:translate( w /2, h/3.9)						
			splashImage.xScale = 0.146 * splashImage.xScale
			splashImage.yScale = 0.146 * splashImage.yScale
			splashImage.alpha = 0			
			transition.to(splashImage,{time=150000,alpha=250})
			-- imagen play

			
			play = display.newImage("images/play_button.png");
			function  play:touch( event )				
				composer.removeScene( "inicio" )

				composer.gotoScene( "menu","fade", 300 )
				--composer.newScene("menu")

			end

			play:translate(w/2,h/1.6)
			play.xScale = play.xScale * 1
			play.yScale = play.yScale * 1
			play:addEventListener("touch", play)

			--bird
			local sheetData2 = { width=40, height=27.5, numFrames=3, sheetContentWidth=40, sheetContentHeight=84 }
			local mySheet2 = graphics.newImageSheet( "images/bird2.png", sheetData2 )
			local runningSecuenceFly2 ={name="normalRun",start=1,count=3,time=600,loopCount,loopDirection="forward"}
			bird =display.newSprite(mySheet2,runningSecuenceFly2)
			bird.x = display.contentWidth/2  --center the sprite horizontally
			xposition = bird.x
			bird.y = display.contentHeight/2.3  --center the sprite vertically
			bird.xScale = 0.9 * bird.xScale
			bird.yScale = 0.9 * bird.yScale
			bird.isFixedRotation=true
			bird:play()  
			local function bounceFlappy(flappy, speed)
			    local function bounceFlappyDown(flappy)
			      transition.to( flappy, { y = flappy.y + 7 , time=450, transition=easing.inOutSine, onComplete=bounceFlappy } )
			    end
			    transition.to( flappy, { y = flappy.y - 7 , time=450, transition=easing.inOutSine, onComplete=bounceFlappyDown } )
			end
			bounceFlappy(bird)
			vel = -4

			offset=-0

			gnd1 =display.newImage("ground.png", 0, h )
			physics.addBody( gnd1, "static" )

			gnd2 =display.newImage("ground.png", 0, h )
			physics.addBody( gnd2, "static" )
			gnd2.x = gnd1.x + gnd1.width * 0.5 + gnd2.width*0.5 + offset				

			
		Runtime:addEventListener( "enterFrame", moveground )

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
   		physics.remove(gnd1)
   		physics.remove(gnd2)
   		transition.cancel()
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view
   print("destroy")

   physics.stop()   
   Runtime._functionListeners = nil
   display.remove(bird)
   display.remove(play)
   display.remove(splashImage)	  
   


end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
