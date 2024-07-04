local specSpells = {
    -- WARRIOR
    [85730] = "Arms",          -- Deadly Calm
    [85388] = "Arms",          -- Throwdown
    [46924] = "Arms",          -- Bladestorm
    [12292] = "Fury",          -- Death Wish
    [85288] = "Fury",          -- Raging Blow
    [60970] = "Fury",          -- Heroic Fury
    [12809] = "Protection",    -- Concussion Blow
    [12975] = "Protection",    -- Last Stand
    [20243] = "Protection",    -- Devastate
    [46968] = "Protection",    -- Shockwave
    [50720] = "Protection",    -- Vigilance
    -- PALADIN
    [31850] = "Protection",    -- Ardent Defender
    [20925] = "Protection",    -- Holy Shield
    [70940] = "Protection",    -- Divine Guardian
    [53595] = "Protection",    -- Hammer of the Righteous
    [53600] = "Protection",    -- Shield of the Righteous
    [53563] = "Holy",          -- Beacon of Light
    [85222] = "Holy",          -- Light of Dawn
    [31821] = "Holy",          -- Aura Mastery
    [85696] = "Retribution",   -- Zealotry
    [53385] = "Retribution",   -- Divine Storm
    [20066] = "Retribution",   -- Repentance
    [85285] = "Retribution",   -- Sacred Shield
    -- ROGUE
    [79140] = "Assassination", -- Vendetta
    [14177] = "Assassination", -- Cold Blood
    [51690] = "Combat",        -- Killing Spree
    [84617] = "Combat",        -- Revealing Strike
    [13750] = "Combat",        -- Adrenaline Rush
    [14185] = "Subtlety",      -- Preparation
    [14183] = "Subtlety",      -- Premeditation
    [16511] = "Subtlety",      -- Hemorrhage
    [51713] = "Subtlety",      -- Shadow Dance
    -- PRIEST
    [47750] = "Discipline",    -- Penance
    [10060] = "Discipline",    -- Power Infusion
    [33206] = "Discipline",    -- Pain Suppression
    [34861] = "Holy",          -- Circle of Healing
    [14751] = "Holy",          -- Chakra
    [88684] = "Holy",          -- Holy Word: Serenity,
    [88625] = "Holy",          -- Holy Word: Sanctuary,
    [724]   = "Holy",          -- Lightwell
    [15487] = "Shadow",        -- Silence
    [34914] = "Shadow",        -- Vampiric Touch
    [64044] = "Shadow",        -- Horror
    [47585] = "Shadow",        -- Dispersion
    [15473] = "Shadow",        -- Shadow Form
    -- DEATHKNIGHT
    [48982] = "Blood",         -- Rune Tap
    [49028] = "Blood",         -- Dancing Rune Weapon
    [49222] = "Blood",         -- Blood Shield
    [49203] = "Frost",         -- Hungering Cold
    [51271] = "Frost",         -- Pillar of Frost
    [49184] = "Frost",         -- Howling Blast
    [51052] = "Unholy",        -- Anti-Magic Zone
    [49206] = "Unholy",        -- Summon Gargoyle
    [49016] = "Unholy",        -- Unholy Frenzy
    [63560] = "Unholy",        -- Dark Transformation
    -- MAGE
    [12043] = "Arcane",        -- Presence of Mind
    [31589] = "Arcane",        -- Slow
    [54646] = "Arcane",        -- Focus Magic
    [44457] = "Fire",          -- Living Bomb
    [31661] = "Fire",          -- Dragon's Breath
    [11129] = "Fire",          -- Combustion
    [11113] = "Fire",          -- Blast Wave
    [44572] = "Frost",         -- Deep Freeze
    [11426] = "Frost",         -- Ice Barrier
    [11958] = "Frost",         -- Cold Snap
    [12472] = "Frost",         -- Icy Veins
    -- WARLOCK
    [48181] = "Affliction",    -- Haunt
    [86121] = "Affliction",    -- Soul Swap
    [18223] = "Affliction",    -- Curse of Exhaustion
    [59672] = "Demonology",    -- Metamorphosis
    [71521] = "Demonology",    -- Hand of Gul'dan
    [47193] = "Demonology",    -- Demonic Empowerment
    [50796] = "Destruction",   -- Chaos Bolt
    [80240] = "Destruction",   -- Bane of Havoc
    [30283] = "Destruction",   -- Shadowfury
    [17877] = "Destruction",   -- Shadowburn
    -- SHAMAN
    [61882] = "Elemental",     -- Earthquake
    [16166] = "Elemental",     -- Elemental Mastery
    [51533] = "Enhancement",   -- Feral Spirit
    [30823] = "Enhancement",   -- Shamanistic Rage
    [17364] = "Enhancement",   -- Stormstrike
    [16188] = "Restoration",   -- Nature's Swiftness
    [16190] = "Restoration",   -- Mana Tide Totem
    [61295] = "Restoration",   -- Riptide
    [98008] = "Restoration",   -- Spirit Link Totem
    -- HUNTER
    [82726] = "Beast Mastery", -- Fervor
    [19574] = "Beast Mastery", -- Bestial Wrath
    [82692] = "Beast Mastery", -- Focus Fire
    [34490] = "Marksmanship",  -- Silencing Shot
    [53209] = "Marksmanship",  -- Chimera Shot
    [23989] = "Marksmanship",  -- Readiness
    [19306] = "Survival",      -- Counterattack
    [3674] = "Survival",       -- Black Arrow
    [19386] = "Survival",      -- Wyvern Sting
    -- DRUID
    [65797] = "Balance",       -- Starfall
    [6913]  = "Balance",       -- Force of Nature
    [93401] = "Balance",       -- Sunfire
    [50516] = "Balance",       -- Typhoon
    [24858] = "Balance",       -- Moonkin Form
    [49377] = "Feral",         -- Feral Charge
    [48566] = "Feral",         -- Mangle (Cat)
    [48564] = "Feral",         -- Mangle (Bear)
    [50334] = "Feral",         -- Berserk
    [80313] = "Feral",         -- Pulverize
    [18562] = "Restoration",   -- Swiftmend
    [17116] = "Restoration",   -- Nature's Swiftness
    [33891] = "Restoration",   -- Tree of Life
    [48438] = "Restoration"    -- Wild Growth
}

local specIcons = {
    ["DRUID"] = {
        ["Balance"] = select(3, GetSpellInfo(8921)),     -- Moonfire
        ["Feral"] = select(3, GetSpellInfo(27545)),      -- Cat Form
        ["Restoration"] = select(3, GetSpellInfo(5185)), -- Healing Touch
    },
    ["DEATHKNIGHT"] = {
        ["Unholy"] = select(3, GetSpellInfo(48265)), -- Unholy Presence
        ["Blood"] = select(3, GetSpellInfo(48263)),  -- Blood Presence
        ["Frost"] = select(3, GetSpellInfo(48266)),  -- Frost Presence
    },
    ["HUNTER"] = {
        ["Beast Mastery"] = select(3, GetSpellInfo(19590)), -- Bestial Discipline
        ["Marksmanship"] = select(3, GetSpellInfo(19416)),  -- Efficiency
        ["Survival"] = select(3, GetSpellInfo(80325)),      -- Camouflage
    },
    ["MAGE"] = {
        ["Arcane"] = select(3, GetSpellInfo(1459)), -- Arcane Intellect
        ["Fire"] = select(3, GetSpellInfo(133)),    -- Fireball
        ["Frost"] = select(3, GetSpellInfo(116)),   -- Frostbolt
    },
    ["PALADIN"] = {
        ["Holy"] = select(3, GetSpellInfo(635)),         -- Holy Light
        ["Retribution"] = select(3, GetSpellInfo(7294)), -- Retribution Aura
        ["Protection"] = select(3, GetSpellInfo(32828)), -- Protection Aura
    },
    ["PRIEST"] = {
        ["Discipline"] = select(3, GetSpellInfo(17)),   -- Power Word: Fortitude
        ["Shadow"] = select(3, GetSpellInfo(589)),      -- Shadow Word: Pain
        ["Holy"] = select(3, GetSpellInfo(635)),        -- Holy Light
    },
    ["ROGUE"] = {
        ["Assassination"] = select(3, GetSpellInfo(1329)), -- Mutilate (Eviscerate? 2098)
        ["Combat"] = select(3, GetSpellInfo(53)),          -- Backstab
        ["Subtlety"] = select(3, GetSpellInfo(1784)),      -- Stealth
    },
    ["SHAMAN"] = {
        ["Elemental"] = select(3, GetSpellInfo(403)),   -- Lightning Bolt
        ["Enhancement"] = select(3, GetSpellInfo(324)), -- Lightning Shield
        ["Restoration"] = select(3, GetSpellInfo(331)), -- Healing Wave
    },
    ["WARLOCK"] = {
        ["Affliction"] = select(3, GetSpellInfo(6789)),     -- Death Coil
        ["Demonology"] = select(3, GetSpellInfo(18699)),    -- Sense Demons
        ["Destruction"] = select(3, GetSpellInfo(39273)),   -- Rain of Fire
    },
    ["WARRIOR"] = {
        ["Arms"] = select(3, GetSpellInfo(12294)),    -- Mortal Strike
        ["Fury"] = select(3, GetSpellInfo(12325)),    -- Inner Rage
        ["Protection"] = select(3, GetSpellInfo(71)), -- Defensive Stance
    }
}

function sArenaFrameMixin:UpdateSpecIcon()
    self.SpecIcon.Texture:SetTexture(self.specTexture)
end

function sArenaFrameMixin:FindSpec(combatEvent, spellID)
    if (
            not (combatEvent == "SPELL_CAST_START" or
                combatEvent == "SPELL_CAST_SUCCESS" or
                combatEvent == "SPELL_CAST_FAILED" or
                combatEvent == "SPELL_PERIODIC_CAST_START" or
                combatEvent == "SPELL_PERIODIC_SUCCESS" or
                combatEvent == "SPELL_HEAL" or
                combatEvent == "SPELL_PERIODIC_HEAL" or
                combatEvent == "SPELL_AURA_APPLIED" or
                combatEvent == "SPELL_AURA_REMOVED" or
                combatEvent == "SPELL_AURA_REFRESH" or
                combatEvent == "SPELL_AURA_BROKEN" or
                combatEvent == "SPELL_PERIODIC_AURA_APPLIED" or
                combatEvent == "SPELL_PERIODIC_AURA_REMOVED" or
                combatEvent == "SPELL_PERIODIC_AURA_REFRESH" or
                combatEvent == "SPELL_PERIODIC_AURA_BROKEN"
            )
        ) then
        return
    end

    if (specSpells[spellID]) then
        self.specTexture = specIcons[self.class][specSpells[spellID]]
        self:UpdateSpecIcon()
    end
end
