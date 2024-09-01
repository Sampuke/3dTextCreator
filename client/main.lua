-- FOR CHECKING IF PLAYER HAS LOADED IN TO THE GODDANM GAME

LOADED_IN = false



-- Global variables for storing created text, client-side text, and miscellaneous variables
local createdText, clientText, findShit = {}, {}, {}
local render, rendText = false, {}
-- Create a thread to handle rendering and updating 3D text
CreateThread(function()
    while LOADED_IN do
        local sleep = 1000
        local pC = GetEntityCoords(PlayerPedId())
        -- Iterate through server-side 3D text and add them to the render list if they are within range
        for i = 1, #GlobalState.server3dText do
            local textDistance = #(GlobalState.server3dText[i].coords- pC)
            if textDistance <= 30 then
                if textDistance <= GlobalState.server3dText[i].dist then
                    render = true
                    rendText[#rendText+1] = GlobalState.server3dText[i]
                end
            end
        end
        for i = 1, #clientText do
            -- Iterate through client-side 3D text and add them to the render list if they are within range
            local textDistance = #(clientText[i].coords- pC)
            if textDistance <= 30 then
                if textDistance <= clientText[i].dist then
                    render = true
                    rendText[#rendText+1] = clientText[i]
                end
            end
        end
        Wait(sleep)
    end
end)
-- Create a thread to render the 3D text
Citizen.CreateThread(function()
    while LOADED_IN do
        if render then
            for i = 1, #rendText do
                local text = rendText[i]
                local label = string.gsub(text.label,"\n", "~n~")
                local color = {}
                -- Check if color is a hexadecimal string and convert it to RGB
                if type(text.color) == "string" then
                    color = hexToRGB(text.color)
                else
                    color = {r = text.color[1], g = text.color[2], b = text.color[3], a = text.color[4] or 255}
                end
                Draw3DText(text.coords.x, text.coords.y, text.coords.z, text.scale, label, color)
            end
            Wait(0)
        end
        Wait(1500)
    end
end)
-- Registering Exports
exports('crete3dText', addText)

exports('update3dText', addText)

exports('delete3dText', addText)

-- Event handlers for esx player loading and unloading
AddEventHandler("esx:playerLoaded", function(playerData, isNew, skin)
    LOADED_IN = true
end)
AddEventHandler("esx:onPlayerLogout", function()
    LOADED_IN = false
end)

-- Event handlers for QBCore player loading and unloading
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    LOADED_IN = true
end)
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    LOADED_IN = false
end)