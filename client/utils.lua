-- Function to draw 3D text on the screen
function Draw3DText(x, y, z, scl, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.a)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Function to convert hexadecimal color to RGB
function hexToRGB(hex)
    hex = hex:gsub("#", "")
    return {
        r = tonumber(hex:sub(1, 2), 16),
        g = tonumber(hex:sub(3, 4), 16),
        b = tonumber(hex:sub(5, 6), 16),
        a = tonumber(hex:sub(7, 8), 16) or 255,
    }
end

-- Function to add a 3D text to the client-side list
function addText(label, x, y, z, color, dist, scale, font)
    local textNum = #clientText+1
    clientText[textNum] = {
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
        clientText[textNum].coords = vector3(x, y, z)
    end
    if color then
        clientText[textNum].color = color or {r = 255, g = 255, b = 255}
    end
    if dist then
        clientText[textNum].dist = dist or 5
    end
    if scale then
        clientText[textNum].scale = scale or 0.7
    end
    if font then
        clientText[textNum].font = font or 0
    end
end

-- Function to delete a 3D text from the client-side list
function deleteText(textNum)
    clientText[textNum] = {}
end