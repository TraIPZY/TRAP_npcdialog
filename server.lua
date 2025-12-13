local currentVersion = Config.Version
local versionURL = "https://raw.githubusercontent.com/TraIPZY/TRAP_npcdialog/main/version.txt"

-- 🧾 Vérification de version
PerformHttpRequest(versionURL, function(statusCode, response)
    if statusCode == 200 then
        local latestVersion = response:gsub("%s+", "")
        if latestVersion ~= currentVersion then
            print(("[TRAP NPC] ⚠️ Nouvelle version disponible : %s (actuelle : %s)"):format(latestVersion, currentVersion))
            TriggerClientEvent('TRAP_npcdialog:versionNotify', -1, currentVersion, latestVersion)
        else
            print(("[TRAP NPC] ✅ À jour (v%s)"):format(currentVersion))
        end
    else
        print("[TRAP NPC] ❌ Impossible de vérifier la version.")
    end
end)

-- 💰 Paiement et récompense
RegisterNetEvent('TRAP_npcdialog:attemptBuy', function(pedId)
    local src = source
    local pedCfg = nil

    for _, v in pairs(Config.Peds) do
        if v.id == pedId then
            pedCfg = v
            break
        end
    end

    if not pedCfg then
        TriggerClientEvent(Config.NotifyEvent, src, { title = "Erreur", description = "PNJ introuvable.", type = "error" })
        return
    end

    -- Vérifier argent
    local cash = exports.ox_inventory:GetItemCount(src, Config.PaymentItem)
    if cash < pedCfg.price then
        TriggerClientEvent(Config.NotifyEvent, src, { title = "PNJ", description = "T’as pas assez de cash sur toi.", type = "error" })
        return
    end

    -- Retirer l’argent
    exports.ox_inventory:RemoveItem(src, Config.PaymentItem, pedCfg.price)

    -- Donner les récompenses
    if pedCfg.rewards and #pedCfg.rewards > 0 then
        for _, reward in pairs(pedCfg.rewards) do
            exports.ox_inventory:AddItem(src, reward.item, reward.amount)
        end
    end

    -- Message du PNJ
    TriggerClientEvent('TRAP_npcdialog:deliverResponse', src, pedId, pedCfg.response)
end)





AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    print('^4████████╗██████╗  █████╗ ██████╗ ')
    print('^4╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗')
    print('^4   ██║   ██████╔╝███████║██████╔╝')
    print('^4   ██║   ██╔══██╗██╔══██║██╔═══╝ ')
    print('^4   ██║   ██║  ██║██║  ██║██║     ')
    print('^4   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ')
    print('^7')
    print('^6   Discord : https://discord.gg/rjjU2y93X7')
    print('^8   Créé par TRAPZY')
    print('^3   © TRAP Development')

end)
