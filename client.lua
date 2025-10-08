local talkingTo = nil

-- ========================
-- Version Checker
-- ========================
Citizen.CreateThread(function()
    local currentVersion = Config.Version
    local versionURL = "https://raw.githubusercontent.com/TRAPZY/npc-dialogue/main/version.txt" -- Remplace par ton repo

    PerformHttpRequest(versionURL, function(statusCode, response, headers)
        if statusCode == 200 then
            local latestVersion = response:gsub("%s+", "") -- retire les espaces et retours à la ligne
            if latestVersion ~= currentVersion then
                print("^1[NPC Dialogue] Une nouvelle version est disponible ! Version actuelle : "..currentVersion.." | Dernière version : "..latestVersion.."^0")
            else
                print("^2[NPC Dialogue] Vous utilisez la dernière version ("..currentVersion..")^0")
            end
        else
            print("^3[NPC Dialogue] Impossible de vérifier la dernière version.^0")
        end
    end)
end)

-- ========================
-- Spawn des PNJ
-- ========================
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

-- ========================
-- Ouvrir le dialogue
-- ========================
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

-- ========================
-- Quand le serveur envoie la réponse
-- ========================
RegisterNetEvent('TRAP_npcdialog:deliverResponse', function(pedId, response)
    print("DEBUG | deliverResponse reçu du serveur. PNJ id:", pedId, "response:", response)
    if talkingTo ~= pedId then return end
    lib.notify({
        title = 'PNJ',
        description = response,
        type = 'inform'
    })
end)
