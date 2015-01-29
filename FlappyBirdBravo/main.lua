-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local function myTapListener( event )
	physics.start()
    --code executed when the button is tapped
    print( "object tapped = "..tostring(event.target) )  --'event.target' is the tapped object
    --bird:applyForce(0,-500,bird.x,bird.y)
	bird:setLinearVelocity(0,-300)
    return true
end


physics = require("physics")
physics.start()

w = display.viewableContentWidth
h = display.viewableContentHeight

local background = display.newImageRect("bg.png",w*2,h*2)
background:addEventListener("tap",myTapListener)

 bird = display.newImage("bird1.png",100*0.5,100*0.5)
bird.x = 150
bird.y = 100
physics.addBody(bird,{density=1,friction=0.5,bounce=0.3})
bird.gravityScale = 2
physics.pause()





