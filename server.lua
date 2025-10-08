ESX = exports["es_extended"]:getSharedObject()

-- ===========================
-- Mode debug pour tester le flow
-- ===========================
local function removeCashFromInventory(source, amount)
    -- DEBUG : toujours accepter le paiement
    print("DEBUG | Simule le retrait cash pour", source, "montant", amount)
    return true
end

-- ===========================
-- Mode réel codem-inventory
-- Décommenter et adapter selon ton export exact
-- ===========================

local function removeCashFromInventory(source, amount)
    -- récupère l'item "cash"
    local cashItem = exports['codem-inventory']:GetItemByName(source, "cash")
    local quantity = cashItem and cashItem.amount or 0

    print("DEBUG | Player cash pour ID", source, ":", quantity)

    if quantity < amount then
        return false
    end

    -- retire le cash
    exports['codem-inventory']:RemoveItem(source, "cash", amount)
    print("DEBUG | Retrait cash effectué :", amount)
    return true
end



RegisterNetEvent('TRAP_npcdialog:attemptBuy', function(pedId)
    local src = source
    print("DEBUG | Event attemptBuy reçu ! Joueur:", src, " pedId:", pedId)

    local pedCfg = nil
    for _, v in pairs(Config.Peds) do
        if v.id == pedId then
            pedCfg = v
            break
        end
    end

    if not pedCfg then
        print("DEBUG | PNJ introuvable pour pedId:", pedId)
        TriggerClientEvent(Config.NotifyEvent, src, { title = "Erreur", description = "PNJ introuvable.", type = "error" })
        return
    end

    local price = pedCfg.price or 0
    if price > 0 then
        local ok = removeCashFromInventory(src, price)
        if not ok then
            print("DEBUG | Joueur n'a pas assez de cash :", src)
            TriggerClientEvent(Config.NotifyEvent, src, { title = "PNJ", description = "Tu n’as pas assez de cash sur toi.", type = "error" })
            return
        end
    end

    -- Paiement réussi → envoie de la réponse
    local theResponse = pedCfg.response or "Rien à te dire."
    print("DEBUG | Réponse envoyée au client :", theResponse)
    TriggerClientEvent('TRAP_npcdialog:deliverResponse', src, pedId, theResponse)

    -- Optionnel : donner un item
    if Config.GiveItemWithResponse and Config.ItemToGive then
        exports['codem-inventory']:AddItem(src, Config.ItemToGive, 1)
        print("DEBUG | Item donné au joueur :", Config.ItemToGive)
    end
end)
