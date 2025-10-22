local talkingTo = nil

-- 🧾 Notification de version
RegisterNetEvent('TRAP_npcdialog:versionNotify', function(current, latest)
    lib.notify({
        title = 'NPC Dialogue',
        description = ('Nouvelle version dispo ! (%s → %s)'):format(current, latest),
        type = 'error'
    })
end)

-- 👤 Spawn PNJ + interaction
CreateThread(function()
    for _, pedData in pairs(Config.Peds) do
        local model = GetHashKey(pedData.model)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end

        local ped = CreatePed(4, model, pedData.coords.x, pedData.coords.y, pedData.coords.z - 1.0, pedData.coords.w, false, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'TRAP_npcdialog_' .. pedData.id,
                icon = 'fa-solid fa-comment',
                label = 'Parler',
                onSelect = function()
                    openDialog(pedData)
                end
            }
        })
    end
end)

-- 💬 Ouverture du dialogue
function openDialog(pedData)
    talkingTo = pedData.id
    lib.registerContext({
        id = 'npc_dialog_' .. pedData.id,
        title = 'Discussion',
        options = {
            {
                title = pedData.text,
                description = ('Prix : %s$'):format(pedData.price),
                icon = 'fa-solid fa-hand-holding-usd',
                onSelect = function()
                    TriggerServerEvent('TRAP_npcdialog:attemptBuy', pedData.id)
                end
            },
            {
                title = 'Non merci',
                icon = 'fa-solid fa-xmark',
                onSelect = function()
                    talkingTo = nil
                    lib.hideContext()
                end
            }
        }
    })
    lib.showContext('npc_dialog_' .. pedData.id)
end

-- 📜 Réception de la réponse du serveur
RegisterNetEvent('TRAP_npcdialog:deliverResponse', function(pedId, response)
    if talkingTo ~= pedId then return end
    lib.notify({
        title = 'Homme Mysterieux',
        description = response,
        type = 'inform'
    })
end)

