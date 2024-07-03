sArenaMixin.drCategories = {
	"Incapacitate",
	"Stun",
	"RandomStun",
	"RandomRoot",
	"Root",
	"Disarm",
	"Fear",
	"Scatter",
	"Silence",
	"Horror",
	"MindControl",
	"Cyclone",
	"Charge",
	"OpenerStun",
	"CounterAttack"
}

sArenaMixin.defaultSettings.profile.drCategories = {
	["Incapacitate"] = true,
	["Stun"] = true,
	["RandomStun"] = true,
	["RandomRoot"] = true,
	["Root"] = true,
	["Disarm"] = true,
	["Fear"] = true,
	["Scatter"] = true,
	["Silence"] = true,
	["Horror"] = true,
	["MindControl"] = true,
	["Cyclone"] = true,
	["Charge"] = true,
	["OpenerStun"] = true,
	["CounterAttack"] = true
}

local drCategories = sArenaMixin.drCategories
local drList
-- Blizzard has dynamic diminishing timer for reset DR's (usually 15 to 20 seconds)
-- 20 seconds it's safe value but you can set lower
local drTime = 20
local severityColor = {
	[1] = { 0, 1, 0, 1 },
	[2] = { 1, 1, 0, 1 },
	[3] = { 1, 0, 0, 1 }
}

local GetTime = GetTime

function sArenaFrameMixin:FindDR(combatEvent, spellID)
	local category = drList[spellID]
	if (not category) then return end
	if (not self.parent.db.profile.drCategories[category]) then return end

	local frame = self[category]
	local currTime = GetTime()

	if (combatEvent == "SPELL_AURA_REMOVED" or combatEvent == "SPELL_AURA_BROKEN") then
		local startTime, startDuration = frame.Cooldown:GetCooldownTimes()
		startTime, startDuration = startTime / 1000, startDuration / 1000

		-- Was unable to reproduce bug where CC would break
		-- Instantly after appliction (Shatter pet nova) but DR timer didnt start on SPELL_AURA_APPLIED
		-- So on SPELL_AURA_BROKEN frame.Cooldown:GetCooldownTimes() gave 0.

		if not (startTime == 0 or startDuration == 0) then
			local newDuration = drTime / (1 - ((currTime - startTime) / startDuration))
			local newStartTime = drTime + currTime - newDuration

			frame:Show()
			frame.Cooldown:SetCooldown(newStartTime, newDuration)
		else
			frame:Show()
			frame.Cooldown:SetCooldown(currTime, drTime)
		end
		return
	elseif (combatEvent == "SPELL_AURA_APPLIED" or combatEvent == "SPELL_AURA_REFRESH") then
		local unit = self.unit

		for i = 1, 30 do
			local _, _, _, _, duration, _, _, _, _, _spellID = UnitAura(unit, i, "HARMFUL")

			if (not _spellID) then break end

			if (duration and spellID == _spellID) then
				frame:Show()
				frame.Cooldown:SetCooldown(currTime, duration + drTime)
				break
			end
		end
	end

	frame.Icon:SetTexture(select(3, GetSpellInfo(spellID)))
	frame.Border:SetVertexColor(unpack(severityColor[frame.severity]))

	frame.severity = frame.severity + 1
	if frame.severity > 3 then
		frame.severity = 3
	end
end

function sArenaFrameMixin:UpdateDRPositions()
	local layoutdb = self.parent.layoutdb
	local numActive = 0
	local frame, prevFrame
	local spacing = layoutdb.dr.spacing
	local growthDirection = layoutdb.dr.growthDirection

	for i = 1, #drCategories do
		frame = self[drCategories[i]]

		if (frame:IsShown()) then
			frame:ClearAllPoints()
			if (numActive == 0) then
				frame:SetPoint("CENTER", self, "CENTER", layoutdb.dr.posX, layoutdb.dr.posY)
			else
				if (growthDirection == 4) then
					frame:SetPoint("RIGHT", prevFrame, "LEFT", -spacing, 0)
				elseif (growthDirection == 3) then
					frame:SetPoint("LEFT", prevFrame, "RIGHT", spacing, 0)
				elseif (growthDirection == 1) then
					frame:SetPoint("TOP", prevFrame, "BOTTOM", 0, -spacing)
				elseif (growthDirection == 2) then
					frame:SetPoint("BOTTOM", prevFrame, "TOP", 0, spacing)
				end
			end
			numActive = numActive + 1
			prevFrame = frame
		end
	end
end

function sArenaFrameMixin:ResetDR()
	for i = 1, #drCategories do
		self[drCategories[i]].Cooldown:Clear()
		--DR frames would somehow persist through several games, showing just icon and no DR, havent found the cause
		self[drCategories[i]]:Hide()
	end
end

drList = {
	[49203] = "Incapacitate", -- Hungering Cold
	[2637]  = "Incapacitate", -- Hibernate (Rank 1)
	[18657] = "Incapacitate", -- Hibernate (Rank 2)
	[18658] = "Incapacitate", -- Hibernate (Rank 3)
	[60210] = "Incapacitate", -- Freezing Arrow Effect (Rank 1)
	[3355]  = "Incapacitate", -- Freezing Trap Effect (Rank 1)
	[14308] = "Incapacitate", -- Freezing Trap Effect (Rank 2)
	[14309] = "Incapacitate", -- Freezing Trap Effect (Rank 3)
	[19386] = "Incapacitate", -- Wyvern Sting (Rank 1)
	[24132] = "Incapacitate", -- Wyvern Sting (Rank 2)
	[24133] = "Incapacitate", -- Wyvern Sting (Rank 3)
	[27068] = "Incapacitate", -- Wyvern Sting (Rank 4)
	[49011] = "Incapacitate", -- Wyvern Sting (Rank 5)
	[49012] = "Incapacitate", -- Wyvern Sting (Rank 6)
	[118]   = "Incapacitate", -- Polymorph (Rank 1)
	[12824] = "Incapacitate", -- Polymorph (Rank 2)
	[12825] = "Incapacitate", -- Polymorph (Rank 3)
	[12826] = "Incapacitate", -- Polymorph (Rank 4)
	[28271] = "Incapacitate", -- Polymorph: Turtle
	[28272] = "Incapacitate", -- Polymorph: Pig
	[61721] = "Incapacitate", -- Polymorph: Rabbit
	[61780] = "Incapacitate", -- Polymorph: Turkey
	[61305] = "Incapacitate", -- Polymorph: Black Cat
	[20066] = "Incapacitate", -- Repentance
	[1776]  = "Incapacitate", -- Gouge
	[6770]  = "Incapacitate", -- Sap (Rank 1)
	[2070]  = "Incapacitate", -- Sap (Rank 2)
	[11297] = "Incapacitate", -- Sap (Rank 3)
	[51724] = "Incapacitate", -- Sap (Rank 4)
	[710]   = "Incapacitate", -- Banish (Rank 1)
	[18647] = "Incapacitate", -- Banish (Rank 2)
	[9484]  = "Incapacitate", -- Shackle Undead (Rank 1)
	[9485]  = "Incapacitate", -- Shackle Undead (Rank 2)
	[10955] = "Incapacitate", -- Shackle Undead (Rank 3)
	[51514] = "Incapacitate", -- Hex
	[13327] = "Incapacitate", -- Reckless Charge (Rocket Helmet)
	[4064]  = "Incapacitate", -- Rough Copper Bomb
	[4065]  = "Incapacitate", -- Large Copper Bomb
	[4066]  = "Incapacitate", -- Small Bronze Bomb
	[4067]  = "Incapacitate", -- Big Bronze Bomb
	[4068]  = "Incapacitate", -- Iron Grenade
	[12421] = "Incapacitate", -- Mithril Frag Bomb
	[4069]  = "Incapacitate", -- Big Iron Bomb
	[12562] = "Incapacitate", -- The Big One
	[12543] = "Incapacitate", -- Hi-Explosive Bomb
	[19769] = "Incapacitate", -- Thorium Grenade
	[19784] = "Incapacitate", -- Dark Iron Bomb
	[30216] = "Incapacitate", -- Fel Iron Bomb
	[30461] = "Incapacitate", -- The Bigger One
	[30217] = "Incapacitate", -- Adamantite Grenade

	[47481] = "Stun",      -- Gnaw (Ghoul Pet)
	[5211]  = "Stun",      -- Bash (Rank 1)
	[6798]  = "Stun",      -- Bash (Rank 2)
	[8983]  = "Stun",      -- Bash (Rank 3)
	[22570] = "Stun",      -- Maim (Rank 1)
	[49802] = "Stun",      -- Maim (Rank 2)
	[24394] = "Stun",      -- Intimidation
	[50519] = "Stun",      -- Sonic Blast (Pet Rank 1)
	[53564] = "Stun",      -- Sonic Blast (Pet Rank 2)
	[53565] = "Stun",      -- Sonic Blast (Pet Rank 3)
	[53566] = "Stun",      -- Sonic Blast (Pet Rank 4)
	[53567] = "Stun",      -- Sonic Blast (Pet Rank 5)
	[53568] = "Stun",      -- Sonic Blast (Pet Rank 6)
	[50518] = "Stun",      -- Ravage (Pet Rank 1)
	[53558] = "Stun",      -- Ravage (Pet Rank 2)
	[53559] = "Stun",      -- Ravage (Pet Rank 3)
	[53560] = "Stun",      -- Ravage (Pet Rank 4)
	[53561] = "Stun",      -- Ravage (Pet Rank 5)
	[53562] = "Stun",      -- Ravage (Pet Rank 6)
	[44572] = "Stun",      -- Deep Freeze
	[853]   = "Stun",      -- Hammer of Justice (Rank 1)
	[5588]  = "Stun",      -- Hammer of Justice (Rank 2)
	[5589]  = "Stun",      -- Hammer of Justice (Rank 3)
	[10308] = "Stun",      -- Hammer of Justice (Rank 4)
	[2812]  = "Stun",      -- Holy Wrath (Rank 1)
	[10318] = "Stun",      -- Holy Wrath (Rank 2)
	[27139] = "Stun",      -- Holy Wrath (Rank 3)
	[48816] = "Stun",      -- Holy Wrath (Rank 4)
	[48817] = "Stun",      -- Holy Wrath (Rank 5)
	[408]   = "Stun",      -- Kidney Shot (Rank 1)
	[8643]  = "Stun",      -- Kidney Shot (Rank 2)
	[1833]  = "Stun", 	   -- Cheap Shot
	[58861] = "Stun",      -- Bash (Spirit Wolves)
	[30283] = "Stun",      -- Shadowfury (Rank 1)
	[30413] = "Stun",      -- Shadowfury (Rank 2)
	[30414] = "Stun",      -- Shadowfury (Rank 3)
	[47846] = "Stun",      -- Shadowfury (Rank 4)
	[47847] = "Stun",      -- Shadowfury (Rank 5)
	[12809] = "Stun",      -- Concussion Blow
	[60995] = "Stun",      -- Demon Charge
	[30153] = "Stun",      -- Intercept (Felguard Rank 1)
	[30195] = "Stun",      -- Intercept (Felguard Rank 2)
	[30197] = "Stun",      -- Intercept (Felguard Rank 3)
	[47995] = "Stun",      -- Intercept (Felguard Rank 4)
	[20253] = "Stun",      -- Intercept Stun (Rank 1)
	[20614] = "Stun",      -- Intercept Stun (Rank 2)
	[20615] = "Stun",      -- Intercept Stun (Rank 3)
	[25273] = "Stun",      -- Intercept Stun (Rank 4)
	[25274] = "Stun",      -- Intercept Stun (Rank 5)
	[46968] = "Stun",      -- Shockwave
	[20549] = "Stun",      -- War Stomp (Racial)
	[85388] = "Stun",      -- Throwdown
	[90337] = "Stun",      -- Bad Manner (Hunter Pet Stun)

	[16922] = "RandomStun", -- Celestial Focus (Starfire Stun)
	[28445] = "RandomStun", -- Improved Concussive Shot
	[12355] = "RandomStun", -- Impact
	[20170] = "RandomStun", -- Seal of Justice Stun
	[39796] = "RandomStun", -- Stoneclaw Stun
	[12798] = "RandomStun", -- Revenge Stun
	[5530]  = "RandomStun", -- Mace Stun Effect (Mace Specialization)
	[15283] = "RandomStun", -- Stunning Blow (Weapon Proc)
	[56]    = "RandomStun", -- Stun (Weapon Proc)
	[34510] = "RandomStun", -- Stormherald/Deep Thunder (Weapon Proc)

	[1513]  = "Fear",      -- Scare Beast (Rank 1)
	[14326] = "Fear",      -- Scare Beast (Rank 2)
	[14327] = "Fear",      -- Scare Beast (Rank 3)
	[10326] = "Fear",      -- Turn Evil
	[8122]  = "Fear",      -- Psychic Scream (Rank 1)
	[8124]  = "Fear",      -- Psychic Scream (Rank 2)
	[10888] = "Fear",      -- Psychic Scream (Rank 3)
	[10890] = "Fear",      -- Psychic Scream (Rank 4)
	[2094]  = "Fear",      -- Blind
	[5782]  = "Fear",      -- Fear (Rank 1)
	[6213]  = "Fear",      -- Fear (Rank 2)
	[6215]  = "Fear",      -- Fear (Rank 3)
	[6358]  = "Fear",      -- Seduction (Succubus)
	[5484]  = "Fear",      -- Howl of Terror (Rank 1)
	[17928] = "Fear",      -- Howl of Terror (Rank 2)
	[5246]  = "Fear",      -- Intimidating Shout
	[5134]  = "Fear",      -- Flash Bomb Fear (Item)

	[339]   = "Root",      -- Entangling Roots (Rank 1)
	[1062]  = "Root",      -- Entangling Roots (Rank 2)
	[5195]  = "Root",      -- Entangling Roots (Rank 3)
	[5196]  = "Root",      -- Entangling Roots (Rank 4)
	[9852]  = "Root",      -- Entangling Roots (Rank 5)
	[9853]  = "Root",      -- Entangling Roots (Rank 6)
	[26989] = "Root",      -- Entangling Roots (Rank 7)
	[53308] = "Root",      -- Entangling Roots (Rank 8)
	[19975] = "Root",      -- Nature's Grasp (Rank 1)
	[19974] = "Root",      -- Nature's Grasp (Rank 2)
	[19973] = "Root",      -- Nature's Grasp (Rank 3)
	[19972] = "Root",      -- Nature's Grasp (Rank 4)
	[19971] = "Root",      -- Nature's Grasp (Rank 5)
	[19970] = "Root",      -- Nature's Grasp (Rank 6)
	[27010] = "Root",      -- Nature's Grasp (Rank 7)
	[53312] = "Root",      -- Nature's Grasp (Rank 8)
	[50245] = "Root",      -- Pin (Rank 1)
	[53544] = "Root",      -- Pin (Rank 2)
	[53545] = "Root",      -- Pin (Rank 3)
	[53546] = "Root",      -- Pin (Rank 4)
	[53547] = "Root",      -- Pin (Rank 5)
	[53548] = "Root",      -- Pin (Rank 6)
	[33395] = "Root",      -- Freeze (Water Elemental)
	[122]   = "Root",      -- Frost Nova (Rank 1)
	[865]   = "Root",      -- Frost Nova (Rank 2)
	[6131]  = "Root",      -- Frost Nova (Rank 3)
	[10230] = "Root",      -- Frost Nova (Rank 4)
	[27088] = "Root",      -- Frost Nova (Rank 5)
	[42917] = "Root",      -- Frost Nova (Rank 6)
	[39965] = "Root",      -- Frost Grenade (Item)
	[63685] = "Root",      -- Freeze (Frost Shock)

	[12494] = "RandomRoot", -- Frostbite
	[55080] = "RandomRoot", -- Shattered Barrier
	[58373] = "RandomRoot", -- Glyph of Hamstring
	[23694] = "RandomRoot", -- Improved Hamstring
	[47168] = "RandomRoot", -- Improved Wing Clip
	[19185] = "RandomRoot", -- Entrapment

	[53359] = "Disarm",    -- Chimera Shot (Scorpid)
	[50541] = "Disarm",    -- Snatch (Rank 1)
	[53537] = "Disarm",    -- Snatch (Rank 2)
	[53538] = "Disarm",    -- Snatch (Rank 3)
	[53540] = "Disarm",    -- Snatch (Rank 4)
	[53542] = "Disarm",    -- Snatch (Rank 5)
	[53543] = "Disarm",    -- Snatch (Rank 6)
	[64058] = "Disarm",    -- Psychic Horror Disarm Effect
	[51722] = "Disarm",    -- Dismantle
	[676]   = "Disarm",    -- Disarm

	[47476] = "Silence",   -- Strangulate
	[34490] = "Silence",   -- Silencing Shot
	[35334] = "Silence",   -- Nether Shock 1 -- TODO: verify
	[44957] = "Silence",   -- Nether Shock 2 -- TODO: verify
	[18469] = "Silence",   -- Silenced - Improved Counterspell (Rank 1)
	[55021] = "Silence",   -- Silenced - Improved Counterspell (Rank 2)
	[63529] = "Silence",   -- Silenced - Shield of the Templar
	[15487] = "Silence",   -- Silence
	[1330]  = "Silence",   -- Garrote - Silence
	[18425] = "Silence",   -- Silenced - Improved Kick
	[24259] = "Silence",   -- Spell Lock
	[43523] = "Silence",   -- Unstable Affliction 1
	[31117] = "Silence",   -- Unstable Affliction 2
	[18498] = "Silence",   -- Silenced - Gag Order (Shield Slam)
	[74347] = "Silence",   -- Silenced - Gag Order (Heroic Throw?)
	[50613] = "Silence",   -- Arcane Torrent (Racial, Runic Power)
	[28730] = "Silence",   -- Arcane Torrent (Racial, Mana)
	[25046] = "Silence",   -- Arcane Torrent (Racial, Energy)

	[64044] = "Horror",    -- Psychic Horror
	[6789]  = "Horror",    -- Death Coil (Rank 1)
	[17925] = "Horror",    -- Death Coil (Rank 2)
	[17926] = "Horror",    -- Death Coil (Rank 3)
	[27223] = "Horror",    -- Death Coil (Rank 4)
	[47859] = "Horror",    -- Death Coil (Rank 5)
	[47860] = "Horror",    -- Death Coil (Rank 6)

	[9005]  = "OpenerStun", -- Pounce (Rank 1)
	[9823]  = "OpenerStun", -- Pounce (Rank 2)
	[9827]  = "OpenerStun", -- Pounce (Rank 3)
	[27006] = "OpenerStun", -- Pounce (Rank 4)
	[49803] = "OpenerStun", -- Pounce (Rank 5)

	[31661] = "Scatter",   -- Dragon's Breath (Rank 1)
	[33041] = "Scatter",   -- Dragon's Breath (Rank 2)
	[33042] = "Scatter",   -- Dragon's Breath (Rank 3)
	[33043] = "Scatter",   -- Dragon's Breath (Rank 4)
	[42949] = "Scatter",   -- Dragon's Breath (Rank 5)
	[42950] = "Scatter",   -- Dragon's Breath (Rank 6)
	[19503] = "Scatter",   -- Scatter Shot

	-- Spells that DR with itself only
	[33786] = "Cyclone",    	-- Cyclone
	[605]   = "MindControl", 	-- Mind Control
	[13181] = "MindControl", 	-- Gnomish Mind Control Cap
	[7922]  = "Charge",     	-- Charge Stun
	[19306] = "CounterAttack", 	-- CounterAttack 1
	[20909] = "CounterAttack", 	-- CounterAttack 2
	[20910] = "CounterAttack", 	-- CounterAttack 3
	[27067] = "CounterAttack", 	-- CounterAttack 4
	[48998] = "CounterAttack", 	-- CounterAttack 5
	[48999] = "CounterAttack" 	-- CounterAttack 6
}
