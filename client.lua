local talkingTo = nil

-- Notification de version
RegisterNetEvent('TRAP_npcdialog:versionNotify')
AddEventHandler('TRAP_npcdialog:versionNotify', function(current, latest)
    lib.notify({
        title = 'NPC Dialogue',
        description = ('Nouvelle version disponible ! Votre version : %s | Dernière version : %s'):format(current, latest),
        type = 'error', -- rouge pour attirer l'attention
        position = 'top'
    })
end)

-- Spawn des PNJ
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
                name = 'TRAP_npcdialog_dialog_' .. pedData.id,
                icon = 'fa-solid fa-comment',
                label = 'Parler',
                onSelect = function()
                    openDialog(pedData)
                end
            }
        })
    end
end)

-- Ouvrir le dialogue
function openDialog(pedData)
    talkingTo = pedData.id
    print("DEBUG | Menu ox_lib ouvert pour PNJ id:", pedData.id)

    lib.registerContext({
        id = 'npc_dialog_' .. pedData.id,
        title = 'Discussion',
        options = {
            {
                title = pedData.text,
                description = ('Prix : %s$'):format(pedData.price),
                icon = 'fa-solid fa-hand-holding-usd',
                onSelect = function()
                    print("DEBUG | Bouton PAYER cliqué ! PNJ id:", pedData.id)
                    TriggerServerEvent('TRAP_npcdialog:attemptBuy', pedData.id)
                end
            },
            {
                title = 'Non merci',
                icon = 'fa-solid fa-xmark',
                onSelect = function()
                    print("DEBUG | Bouton ANNULER cliqué !")
                    talkingTo = nil
                    lib.hideContext()
                end
            }
        }
    })

    lib.showContext('npc_dialog_' .. pedData.id)
end

-- Quand le serveur envoie la réponse
RegisterNetEvent('TRAP_npcdialog:deliverResponse', function(pedId, response)
    print("DEBUG | deliverResponse reçu du serveur. PNJ id:", pedId, "response:", response)
    if talkingTo ~= pedId then return end
    lib.notify({
        title = 'PNJ',
        description = response,
        type = 'inform'
    })
end)
