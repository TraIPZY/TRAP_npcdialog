===========================
TRAP_npcdialog
ESX + Codem Inventory
===========================

Author: TRAPZY
License: MIT

Description:
-------------
TRAP_npcdialog is an interactive NPC dialogue system.
Players can talk to NPCs, pay with cash or items via Codem Inventory,
and receive custom responses. Compatible with ox_lib and ox_target.
Includes a version checker to notify players when a new version is available.

Features:
---------
- Interactive dialogues with NPCs
- Payment in cash or items
- In-game notifications for transactions and dialogues
- Version checker from GitHub

Installation:
-------------
1. Copy or clone the folder into resources/[your-folder]/
2. Add to server.cfg:
   ensure TRAP_npcdialog
3. Configure NPCs in config.lua and set the script version:
   Config.Version = "1.0.0"

Example config.lua:
------------------
Config.Peds = {
    {
        id = 1,
        model = 'a_m_m_business_01',
        coords = vector4(215.76, -810.12, 29.73, 90.0),
        text = 'Hello, how can I help you?',
        price = 100,
        response = "Thank you for your purchase!",
        item = 'bread', -- optional
    },
    {
        id = 2,
        model = 'a_m_m_skater_01',
        coords = vector4(300.12, -580.24, 43.29, 180.0),
        text = 'Hey! Want to buy something?',
        price = 50,
        response = "Here’s your item!",
        item = 'water',
    },
}

Notes:
------
- Version checker uses GitHub raw URL
- Players must manually update to apply a new version
- Notifications require ox_lib
