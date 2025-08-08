-- Convert Sheet To Frames
-- A script to convert a sprite sheet into individual animation frames
-- Supports resizing to 16x16 or 32x32 pixels and configurable frame count

if app.apiVersion < 1 then
    return app.alert("This script requires Aseprite v1.2.10-beta3 or later")
end

-- Check if we have an active sprite
local sprite = app.activeSprite
if not sprite then
    return app.alert("No active sprite found. Please open a sprite sheet first.")
end

-- Get current frame and layer
local frame = app.activeFrame
local currentLayer = app.activeLayer
if not currentLayer then
    return app.alert("No active layer found.")
end

local currentCel = currentLayer:cel(frame)
if not currentCel then
    return app.alert("No cel found in the current layer and frame.")
end

local sourceImage = currentCel.image
local sourceWidth = sourceImage.width
local sourceHeight = sourceImage.height

-- Function to resize an image using nearest neighbor scaling
local function resizeImage(sourceImg, newWidth, newHeight)
    local resizedImg = Image(newWidth, newHeight, sprite.colorMode)
    
    local xRatio = sourceImg.width / newWidth
    local yRatio = sourceImg.height / newHeight
    
    for y = 0, newHeight - 1 do
        for x = 0, newWidth - 1 do
            local sourceX = math.floor(x * xRatio)
            local sourceY = math.floor(y * yRatio)
            
            -- Ensure we don't go out of bounds
            sourceX = math.min(sourceX, sourceImg.width - 1)
            sourceY = math.min(sourceY, sourceImg.height - 1)
            
            local pixelValue = sourceImg:getPixel(sourceX, sourceY)
            resizedImg:drawPixel(x, y, pixelValue)
        end
    end
    
    return resizedImg
end

-- Function to extract a portion of the source image
local function extractFrameImage(sourceImg, x, y, width, height)
    local frameImg = Image(width, height, sprite.colorMode)
    
    for py = 0, height - 1 do
        for px = 0, width - 1 do
            local sourceX = x + px
            local sourceY = y + py
            
            -- Check bounds
            if sourceX >= 0 and sourceX < sourceImg.width and 
               sourceY >= 0 and sourceY < sourceImg.height then
                local pixelValue = sourceImg:getPixel(sourceX, sourceY)
                frameImg:drawPixel(px, py, pixelValue)
            else
                -- Fill with transparent/background color if out of bounds
                frameImg:drawPixel(px, py, 0)
            end
        end
    end
    
    return frameImg
end

-- Create dialog for user input
local dlg = Dialog { title = "Convert Sheet To Frames" }

dlg:number {
    id = "frameCount",
    label = "Number of frames:",
    text = "4",
    decimals = 0
}

dlg:combobox {
    id = "targetSize",
    label = "Target size:",
    option = "32x32",
    options = { "16x16", "32x32" }
}

dlg:combobox {
    id = "sheetLayout",
    label = "Sheet layout:",
    option = "Horizontal",
    options = { "Horizontal", "Vertical", "Grid" }
}

dlg:number {
    id = "gridColumns",
    label = "Grid columns (if grid):",
    text = "2",
    decimals = 0,
    visible = false
}

dlg:separator()

dlg:check {
    id = "replaceCurrentSprite",
    label = "Replace current sprite",
    selected = true
}

dlg:check {
    id = "createNewSprite",
    label = "Create new sprite",
    selected = false
}

dlg:separator()

dlg:button {
    id = "ok",
    text = "Convert",
    onclick = function()
        local data = dlg.data
        
        -- Validate input
        local frameCount = math.max(1, math.floor(data.frameCount))
        local targetSize = data.targetSize == "16x16" and 16 or 32
        local sheetLayout = data.sheetLayout
        local gridColumns = math.max(1, math.floor(data.gridColumns))
        
        -- Calculate frame dimensions based on layout
        local frameWidth, frameHeight
        
        if sheetLayout == "Horizontal" then
            frameWidth = math.floor(sourceWidth / frameCount)
            frameHeight = sourceHeight
        elseif sheetLayout == "Vertical" then
            frameWidth = sourceWidth
            frameHeight = math.floor(sourceHeight / frameCount)
        else -- Grid
            local gridRows = math.ceil(frameCount / gridColumns)
            frameWidth = math.floor(sourceWidth / gridColumns)
            frameHeight = math.floor(sourceHeight / gridRows)
        end
        
        if frameWidth <= 0 or frameHeight <= 0 then
            app.alert("Invalid frame dimensions. Check your frame count and sheet layout.")
            return
        end
        
        -- Create or use sprite for animation
        local animSprite
        if data.createNewSprite then
            animSprite = Sprite(targetSize, targetSize, sprite.colorMode)
            animSprite:setPalette(sprite.palettes[1])
        elseif data.replaceCurrentSprite then
            animSprite = sprite
            -- Clear existing frames except the first
            while #animSprite.frames > 1 do
                animSprite:deleteFrame(animSprite.frames[#animSprite.frames])
            end
            -- Resize sprite to target size
            animSprite:resize(targetSize, targetSize)
        else
            app.alert("Please select either 'Replace current sprite' or 'Create new sprite'.")
            return
        end
        
        -- Start transaction for undo
        app.transaction("Convert Sheet To Frames", function()
            -- Create animation frames
            for i = 1, frameCount do
                local frameX, frameY
                
                if sheetLayout == "Horizontal" then
                    frameX = (i - 1) * frameWidth
                    frameY = 0
                elseif sheetLayout == "Vertical" then
                    frameX = 0
                    frameY = (i - 1) * frameHeight
                else -- Grid
                    local col = (i - 1) % gridColumns
                    local row = math.floor((i - 1) / gridColumns)
                    frameX = col * frameWidth
                    frameY = row * frameHeight
                end
                
                -- Extract frame from source image
                local frameImg = extractFrameImage(sourceImage, frameX, frameY, frameWidth, frameHeight)
                
                -- Resize to target size if needed
                if frameWidth ~= targetSize or frameHeight ~= targetSize then
                    frameImg = resizeImage(frameImg, targetSize, targetSize)
                end
                
                -- Create frame in animation sprite
                local animFrame
                if i == 1 then
                    -- Use first frame
                    animFrame = animSprite.frames[1]
                else
                    -- Create new frame
                    animFrame = animSprite:newEmptyFrame(i)
                end
                
                -- Create or get layer for animation
                local animLayer
                if data.createNewSprite then
                    if i == 1 then
                        animLayer = animSprite:newLayer()
                        animLayer.name = "Animation"
                    else
                        animLayer = animSprite.layers[1]
                    end
                else
                    animLayer = animSprite.layers[1] or animSprite:newLayer()
                end
                
                -- Create cel with the frame image
                local position = Point(0, 0)
                animSprite:newCel(animLayer, animFrame, frameImg, position)
            end
        end)
        
        -- Refresh the display
        app.refresh()
        
        local message = string.format("Successfully converted %d frames to %dx%d animation!", 
                                    frameCount, targetSize, targetSize)
        app.alert(message)
        
        dlg:close()
    end
}

dlg:button {
    id = "cancel",
    text = "Cancel",
    onclick = function()
        dlg:close()
    end
}

-- Update dialog visibility based on layout selection
dlg:modify {
    id = "sheetLayout",
    onchange = function()
        local isGrid = dlg.data.sheetLayout == "Grid"
        dlg:modify {
            id = "gridColumns",
            visible = isGrid
        }
    end
}

-- Update checkboxes to be mutually exclusive
dlg:modify {
    id = "replaceCurrentSprite",
    onchange = function()
        if dlg.data.replaceCurrentSprite then
            dlg:modify {
                id = "createNewSprite",
                selected = false
            }
        end
    end
}

dlg:modify {
    id = "createNewSprite",
    onchange = function()
        if dlg.data.createNewSprite then
            dlg:modify {
                id = "replaceCurrentSprite",
                selected = false
            }
        end
    end
}

-- Show the dialog
dlg:show { wait = false }
