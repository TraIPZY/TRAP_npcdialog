Config = {}
Config.Version = "1.0.0"

-- Notification (ox_lib)
Config.NotifyEvent = 'ox_lib:notify'

-- Donner un item après avoir payé (optionnel)
Config.GiveItemWithResponse = true
Config.ItemToGive = "door_code_note"

-- Configuration des PNJ
Config.Peds = {
    {
        id = 1,
        model = "s_m_m_highsec_01",
        coords = vector4(970.9645, -3130.1567, 5.9008, 127.7825),
        price = 500,
        text = "Yo... tu veux le code ? Ça va te coûter 500$ en cash.",
        response = "Le code de la porte est 4762. Oublie pas qui te l’a donné..."
    },
    {
        id = 2,
        model = "a_m_m_hillbilly_01",
        coords = vector4(1540.2, 6332.5, 24.0, 170.0),
        price = 250,
        text = "Héhé... j’peux t’le dire, mais faut payer.",
        response = "Le code du bunker, c’est 1983."
    }
}
