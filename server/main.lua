-- Crete Globalstate object
CreteThread(function ()
    GlobalState.server3dText = {}
end)

-- Register Exports
exports('crete3dText', addText)

exports('update3dText', addText)

exports('delete3dText', addText)