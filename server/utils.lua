-- Function to add a 3D text to the client-side list
function addText(label, x, y, z, color, dist, scale, font)
    local textNum = #GlobalState.server3dText+1
    GlobalState.server3dText[textNum] = {
        label = label,
        coords = vector3(x, y, z),
        color = color or {r = 255, g = 255, b = 255},
        dist = dist or 5,
        scale = scale or 0.7,
        font = font or 0
    }
    return textNum
end

-- Function to update a 3D text in the client-side list
function updateText(textNum, x,y,z, color, dist, scale, font)
    if x and y and z then
        GlobalState.server3dText[textNum].coords = vector3(x, y, z)
    end
    if color then
        GlobalState.server3dText[textNum].color = color or {r = 255, g = 255, b = 255}
    end
    if dist then
        GlobalState.server3dText[textNum].dist = dist or 5
    end
    if scale then
        GlobalState.server3dText[textNum].scale = scale or 0.7
    end
    if font then
        GlobalState.server3dText[textNum].font = font or 0
    end
end

-- Function to delete a 3D text from the client-side list
function deleteText(textNum)
    GlobalState.server3dText[textNum] = {}
end