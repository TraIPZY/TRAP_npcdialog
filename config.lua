Config = {}

-- 📦 Version du script
Config.Version = "1.2"

-- 🔔 Notification (ox_lib)
Config.NotifyEvent = 'ox_lib:notify'

-- 💰 Paiement en cash (argent dans ox_inventory)
Config.PaymentItem = 'money'

-- 🧍 Configuration des PNJ
Config.Peds = {
    {
        id = 1,
        model = "s_m_m_highsec_01",
        coords = vector4(1728.2262, 6400.5591, 34.5595, 245.1664),
        price = 5000,
        text = "Yo… j’ai mis la main sur une clé de labo. Si tu la veux, va falloir payer 5000 $ en cash. J’te dirai où c’est une fois le fric posé.",
        response = "voilà tu as tout ce qu’il te faut....",
        rewards = { -- 🎁 Liste d’items à donner
            { item = "door_note_weed", amount = 1 },
            { item = "weed_door", amount = 1 }
        }
    },
    {
        id = 2,
        model = "a_m_m_hillbilly_01",
        coords = vector4(1728.2262, 6300.5591, 34.5595, 245.1664),
        price = 5000,
        text = "Yo… j’ai mis la main sur une clé de labo. Si tu la veux, va falloir payer 5000 $ en cash. J’te dirai où c’est une fois le fric posé.",
        response = "Le code du bunker, c’est 1983.",
        rewards = {
            { item = "door_note_lean", amount = 1 },
            { item = "lean_door", amount = 1 }
        }
    }
  --  {
  --      id = 3,
  --      model = "g_m_y_mexgang_01",
  --      coords = vector4(-1203.5, -1567.8, 4.2, 210.0),
  --      price = 1000,
  --      text = "J’ai de quoi t’intéresser… mais rien n’est gratuit.",
  --      response = "Le contact te retrouvera au motel dans 10 minutes.",
  --      rewards = {
  --          { item = "mystery_box", amount = 1 },
  --          { item = "gold_watch", amount = 2 }
  --      }
  --  }
}



