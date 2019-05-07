-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


display.setStatusBar(display.HiddenStatusBar)
 
centerX = display.contentWidth * .5
centerY = display.contentHeight * .5


---background
local background = display.newImageRect( "assets/bg.png", 570, 355 )
background.x = display.contentCenterX
background.y = display.contentCenterY
background.id = "background" 


-- Gravity

local physics = require( "physics" )

physics.start()
physics.setGravity( 45, 100 ) -- ( x, y )
--physics.setDrawMode( "hybrid" )


---ground
local theGround = display.newImageRect( "assets/land.png", 600, 120 )
theGround.x = display.contentCenterX
theGround.y = display.contentHeight 
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.0 
    } )


------ninja-------

----Doing nothing
local ninjaSheetOptionsIdle =
{
    width = 58,
    height = 109,
    numFrames = 10
}
local sheetIdleNinja = graphics.newImageSheet( "assets/ninjaBoyIdle.png", ninjaSheetOptionsIdle )
--sheetIdleninjaContentWidth = 232
--sheetIdleninjaContentHeight = 329
--sheetIdleNinja.xScale = 232/928
--sheetIdleNinja.yScale = 329/1317

----jump attack
local ninjaSheetOptionsThrow =
{
    width = 94,
    height = 112,
    numFrames = 10
}
local sheetNinjaThrow = graphics.newImageSheet( "assets/ninjaBoyThrow.png", ninjaSheetOptionsThrow )
--sheetNinjaThrowContentWidth = 471
--sheetNinjaThrowContentHeight = 225

-- sequences table
local sequence_data2 = {
    -- consecutive frames sequence
    {
        name = "ninja idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleninja
    },
    {
        name = "throw",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetNinjaThrow
    }
}

----ninja position and resolution 
local ninja = display.newSprite( sheetIdleNinja, sequence_data2 )
ninja.x = display.contentCenterX - 200
ninja.y = display.contentCenterY
--ninja.xScale = 100/100
--ninja.yScale = 120/120
ninja.id = "the character"
physics.addBody( ninja, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.0 
    } )
ninja.isFixedRotation = true

ninja:play()

-- After a short time, swap the sequence to 'seq2' which uses the second image sheet
local function ninjaSwapSheet()
    ninja:setSequence( "throw" )
    ninja:play()
    print("throw")
end

timer.performWithDelay( 2000, ninjaSwapSheet )


---Knight -----------------

----Doing nothing
local sheetOptionsIdle =
{
    width = 146,
    height = 176,
    numFrames = 10
}
local sheetIdleKnight = graphics.newImageSheet( "assets/knightIdle.png", sheetOptionsIdle )
--sheetIdleKnightContentWidth = 734
--sheetIdleKnightContentHeight = 353
--sheetIdleKnight.xScale = 734/2935
--sheetIdleKnight.yScale = 353/1414

----walking
local sheetOptionsDead =
{
    width = 236,
    height = 187,
    numFrames = 10
}
local sheetDeadKnight = graphics.newImageSheet( "assets/knightDead.png", sheetOptionsDead )
--sheetDeadKnightContentWidth = 472
--sheetDeadKnightContentHeight = 939
---sheetDeadKnight.xScale = 472/1888
--sheetDeadKnight.yScale = 939/3755


-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleKnight
    },
    {
        name = "dead",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetDeadKnight
    }
}

----knight position and resolution 
local knight = display.newSprite( sheetIdleKnight, sequence_data )
knight.x = display.contentCenterX + 200
knight.y = display.contentCenterY
knight.xScale = 700/587
knight.yScale = 800/707
knight.id = "knight"
physics.addBody( knight, "dynamic", { 
    density = 1.5, 
    friction = 0.5, 
    bounce = 0.0 
    } )

knight:play()

-- After a short time, swap the sequence to 'seq2' which uses the second image sheet
local function swapSheet()
    knight:setSequence( "dead" )
    knight:play()
    print("dead")
end

timer.performWithDelay( 2000, swapSheet )

-- if character falls off the end of the world, respawn back to where it came from
function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if knight.y > display.contentHeight + 500 then
        knight.x = display.contentCenterX - 200
        knight.y = display.contentCenterY
    end

    if ninja.y > display.contentHeight + 500 then
        ninja.x = display.contentCenterX 
        ninja.y = display.contentCenterY
    end
end

Runtime:addEventListener( "enterFrame", checkCharacterPosition )




-------------Controls and shooting and stuff

local playerBullets = {} -- Table that holds the players Bullets


--d-pad
local dPad = display.newImageRect( "assets/d-pad.png", 75, 75 )
dPad.x = 50
dPad.y = display.contentHeight - 80
dPad.alpha = 0.50
dPad.id = "d-pad"

--to go up
local upArrow = display.newImageRect( "assets/upArrow.png", 19, 14 )
upArrow.x = 50
upArrow.y = display.contentCenterY + 53
upArrow.id = "up arrow"


--to go down
local downArrow = display.newImageRect( "assets/downArrow.png", 19, 14 )
downArrow.x = 50
downArrow.y = display.contentCenterY + 108
downArrow.id = "down arrow"

--to go left
local leftArrow = display.newImageRect( "assets/leftArrow.png", 14, 19 )
leftArrow.x = 22
leftArrow.y = display.contentCenterY + 80
leftArrow.id = "left arrow"

-- to go right
local rightArrow = display.newImageRect( "assets/rightArrow.png", 14, 19 )
rightArrow.x = 78
rightArrow.y = display.contentCenterY + 80
rightArrow.id = "right arrow"

---jump

local jumpButton = display.newImageRect( "assets/jumpButton.png", 19, 19 )
jumpButton.x = 50
jumpButton.y = display.contentCenterY + 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5
 

--shoot
local rightShootButton = display.newImageRect ( "assets/rightShoot.png", 50, 50 )
rightShootButton.x = 440
rightShootButton.y = display.contentCenterY 
rightShootButton.id = "rightShootButton"
rightShootButton.alpha = 0.5

local leftShootButton = display.newImageRect ( "assets/leftShoot.png", 50, 50 )
leftShootButton.x = 100
leftShootButton.y = display.contentCenterY 
leftShootButton.id = "leftShootButton"
leftShootButton.alpha = 0.5
  -----functions

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

function checkPlayerBulletsOutOfBounds()
    -- check if any bullets have gone off the screen
    local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end


function rightShootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleRightBullet = display.newImageRect ( "assets/rightKunai.png", 30, 5 )
        aSingleRightBullet.x = ninja.x
        aSingleRightBullet.y = ninja.y
        aSingleRightBullet.id = "a single bullet"
        physics.addBody( aSingleRightBullet, "dynamic", {
            density = 3.0, 
            friction = 0.5, 
            bounce = 0.3 
            } )
        -- Make the object a "bullet" type object
        aSingleRightBullet.isBullet = true
        aSingleRightBullet.gravityScale = 2
        aSingleRightBullet.id = "bullet"
        aSingleRightBullet:setLinearVelocity( 1000, 0 )
          

        table.insert(playerBullets,aSingleRightBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

function leftShootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleLeftBullet = display.newImageRect ( "assets/leftKunai.png", 30, 5 )
        aSingleLeftBullet.x = ninja.x
        aSingleLeftBullet.y = ninja.y
        aSingleLeftBullet.id = "a single bullet"
        physics.addBody( aSingleLeftBullet, "dynamic", {
            density = 3.0, 
            friction = 0.5, 
            bounce = 0.3 
            } )
        -- Make the object a "bullet" type object
        aSingleLeftBullet.isBullet = true
        aSingleLeftBullet.gravityScale = 2
        aSingleLeftBullet.id = "bullet"
        aSingleLeftBullet:setLinearVelocity( -1000, 0 )
          

        table.insert(playerBullets,aSingleLeftBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

function upArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( ninja, { 
            x = 0, -- move 0 in the x direction 
            y = -30, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function downArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( ninja, { 
            x = 0, -- move 0 in the x direction 
            y = 30, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( ninja, { 
            x = -30, -- move 0 in the x direction 
            y = 0, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( ninja, { 
            x = 30, -- move 0 in the x direction 
            y = 0, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        ninja:setLinearVelocity( 0, -250 )
    end

    return true
end

-- if character falls off the end of the world, respawn back to where it came from
function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if ninja.y > display.contentHeight + 500 then
        ninja.x = display.contentCenterX - 200
        ninja.y = display.contentCenterY
    end
end




---event listeners
upArrow:addEventListener( "touch", upArrow )
downArrow:addEventListener( "touch", downArrow )
leftArrow:addEventListener( "touch", leftArrow )
rightArrow:addEventListener( "touch", rightArrow )
jumpButton:addEventListener( "touch", jumpButton )

rightShootButton:addEventListener( "touch", rightShootButton )
leftShootButton:addEventListener( "touch", leftShootButton )


Runtime:addEventListener( "enterFrame", checkCharacterPosition )

Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )

---ninja.collision = characterCollision
--ninja:addEventListener( "collision" )
