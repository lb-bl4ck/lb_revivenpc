Config                      = {}
Config.Locale               = GetConvar('esx:locale', 'en')
Config.pedModel             = `s_m_m_doctor_01`     -- Change the ped model - See https://docs.fivem.net/docs/game-references/ped-models/
Config.enableBlips          = true
Config.blipSprite           = 280
Config.blipColor            = 2
Config.drawDistance         = 20 -- Changes the distance at which the ped spawns
Config.revivePrice          = 3000
Config.healPrice            = 500
Config.allowBankPayment     = true
Config.pedMedics            = {
    -- Add as many as you want
    -- vector4(x, y, z, heading)
    vector4(307.3178, -583.7087, 42.2841, 166.9109),
    vector4(1827.3035, 3679.7698, 33.2710, 302.8912)
}