local createdText, clientText, findShit = {}, {}, {}
local render, rendText = false, {}
LoadedIn = false
CreateThread(function()
    while loadedIn do
        local sleep = 1000
        local pC = GetEntityCoords(PlayerPedId())
        for i = 1, #GlobalState.server3dText do
            local textcoords = #(GlobalState.server3dText[i].coords- pC)
            if textcoords <= 30 then
                if textcoords <= GlobalState.server3dText[i].dist then
                    render = true
                    rendText[#rendText+1] = GlobalState.server3dText[i]
                end
            end
        end
        for i = 1, #clientText do
            local textcoords = #(clientText[i].coords- pC)
            if textcoords <= 30 then
                if textcoords <= clientText[i].dist then
                    render = true
                    rendText[#rendText+1] = clientText[i]
                end
            end
        end
        Wait(sleep)
    end
end)
local function Draw3DText(x, y, z, scl, text, color)
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
local function hexToRGB(hex)
    hex = hex:gsub("#", "")
    return {
        r = tonumber(hex:sub(1, 2), 16),
        g = tonumber(hex:sub(3, 4), 16),
        b = tonumber(hex:sub(5, 6), 16),
        a = tonumber(hex:sub(7, 8), 16) or 255,
    }
end
Citizen.CreateThread(function()
    while loadedIn do
        if render then
            for i = 1, #rendText do
                local text = rendText[i]
                local label = string.gsub(text.label,"\n", "~n~")
                local color = {}
                if type(text.color) == "string" then
                    color = hexToRGB(text.color)
                else
                    color = {r = text.color[1], g = text.color[2], b = text.color[3], a = text.color[4] or 255}
                end
                Draw3DText(text.coords.x, text.coords.y, text.coords.z, text.scale, label, color)
            end
        end
        Wait(5)
    end
end)

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

function deleteText(textNum)
    clientText[textNum] = {}
end

AddEventHandler("esx:playerLoaded", function(playerData, isNew, skin)
    loadedIn = true
end)
AddEventHandler("esx:onPlayerLogout", function()
    loadedIn = false
end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    loadedIn = true
end)
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    loadedIn = false
end)