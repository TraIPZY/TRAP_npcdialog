local currentVersion = Config.Version
local versionURL = "https://raw.githubusercontent.com/TraIPZY/TRAP_npcdialog/refs/heads/main/version.txt"

-- Vérification de version
PerformHttpRequest(versionURL, function(statusCode, response, headers)
    if statusCode == 200 then
        local latestVersion = response:gsub("%s+", "")
        if latestVersion ~= currentVersion then
            print(("[NPC Dialogue] Nouvelle version disponible ! Version actuelle : %s | Dernière version : %s"):format(currentVersion, latestVersion))
            TriggerClientEvent('TRAP_npcdialog:versionNotify', -1, currentVersion, latestVersion)
        else
            print("[NPC Dialogue] Vous utilisez la dernière version (" .. currentVersion .. ")")
        end
    else
        print("[NPC Dialogue] Impossible de vérifier la dernière version.")
    end
end)

-- ===========================
-- Fonction : retirer du cash avec codem-inventory
-- ===========================
local function removeCashFromInventory(source, amount)
    local cashItem = exports['codem-inventory']:GetItemByName(source, "cash") -- Récupère l'item "cash"
    local quantity = cashItem and cashItem.amount or 0

    print(("DEBUG | Player %s a %s cash. Prix requis : %s"):format(source, quantity, amount))

    if quantity < amount then
        return false -- pas assez d'argent
    end

    exports['codem-inventory']:RemoveItem(source, "cash", amount)
    print(("DEBUG | Retrait de %s$ effectué pour le joueur %s."):format(amount, source))
    return true
end

-- ===========================
-- Événement principal d'achat
-- ===========================
RegisterNetEvent('TRAP_npcdialog:attemptBuy', function(pedId)
    local src = source
    print("DEBUG | Event attemptBuy reçu du joueur:", src, "pour pedId:", pedId)

    local pedCfg = nil
    for _, v in pairs(Config.Peds) do
        if v.id == pedId then
            pedCfg = v
            break
        end
    end

    if not pedCfg then
        print("DEBUG | PNJ introuvable pour pedId:", pedId)
        TriggerClientEvent(Config.NotifyEvent, src, { 
            title = "Erreur", 
            description = "PNJ introuvable.", 
            type = "error" 
        })
        return
    end

    local price = pedCfg.price or 0
    local response = pedCfg.response or "Merci pour votre achat !"

    if price > 0 then
        local ok = removeCashFromInventory(src, price)
        if not ok then
            print("DEBUG | Joueur n’a pas assez d’argent :", src)
            TriggerClientEvent(Config.NotifyEvent, src, { 
                title = "PNJ", 
                description = "Tu n’as pas assez d’argent.", 
                type = "error" 
            })
            return
        end
    end

    -- Paiement réussi → envoie de la réponse
    TriggerClientEvent('TRAP_npcdialog:deliverResponse', src, pedId, response)

    print("DEBUG | Réponse envoyée au client :", response)

    -- Optionnel : donner un item en plus de la réponse
    if Config.GiveItemWithResponse and Config.ItemToGive then
        exports['codem-inventory']:AddItem(src, Config.ItemToGive, 1)
        print("DEBUG | Item donné au joueur :", Config.ItemToGive)
    end
end)
