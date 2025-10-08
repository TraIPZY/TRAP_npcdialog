local currentVersion = Config.Version
local versionURL = "https://raw.githubusercontent.com/TraIPZY/TRAP_npcdialog/refs/heads/main/version.txt"

-- Vérification de la version côté serveur
PerformHttpRequest(versionURL, function(statusCode, response, headers)
    if statusCode == 200 then
        local latestVersion = response:gsub("%s+", "")
        if latestVersion ~= currentVersion then
            print("[NPC Dialogue] Nouvelle version disponible ! Version actuelle : " .. currentVersion .. " | Dernière version : " .. latestVersion)
            TriggerClientEvent('TRAP_npcdialog:versionNotify', -1, currentVersion, latestVersion)
        else
            print("[NPC Dialogue] Vous utilisez la dernière version (" .. currentVersion .. ")")
        end
    else
        print("[NPC Dialogue] Impossible de vérifier la dernière version")
    end
end)

-- Exemple d'événement serveur pour le paiement
RegisterNetEvent('TRAP_npcdialog:attemptBuy', function(pedId)
    local src = source
    -- Ici ton code pour gérer le paiement via codem-inventory
    -- Ex : vérifier l'argent ou l'item, retirer le paiement, etc.
    TriggerClientEvent('TRAP_npcdialog:deliverResponse', src, pedId, "Merci pour votre achat !")
end)
