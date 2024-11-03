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
	"Counterattack"
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
	["Counterattack"] = true
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
	[49203] = "Incapacitate", 	-- Hungering Cold
	[2637]  = "Incapacitate", 	-- Hibernate
	[3355]  = "Incapacitate", 	-- Freezing Trap Effect
	[19386] = "Incapacitate", 	-- Wyvern Sting
	[118]   = "Incapacitate", 	-- Polymorph
	[28271] = "Incapacitate", 	-- Polymorph: Turtle
	[28272] = "Incapacitate", 	-- Polymorph: Pig
	[61721] = "Incapacitate", 	-- Polymorph: Rabbit
	[61780] = "Incapacitate", 	-- Polymorph: Turkey
	[61305] = "Incapacitate", 	-- Polymorph: Black Cat
	[20066] = "Incapacitate", 	-- Repentance
	[1776]  = "Incapacitate", 	-- Gouge
	[6770]  = "Incapacitate", 	-- Sap
	[710]   = "Incapacitate", 	-- Banish
	[9484]  = "Incapacitate", 	-- Shackle Undead
	[51514] = "Incapacitate", 	-- Hex
	[13327] = "Incapacitate", 	-- Reckless Charge (Rocket Helmet)
	[4064]  = "Incapacitate", 	-- Rough Copper Bomb
	[4065]  = "Incapacitate", 	-- Large Copper Bomb
	[4066]  = "Incapacitate", 	-- Small Bronze Bomb
	[4067]  = "Incapacitate", 	-- Big Bronze Bomb
	[4068]  = "Incapacitate", 	-- Iron Grenade
	[12421] = "Incapacitate", 	-- Mithril Frag Bomb
	[4069]  = "Incapacitate", 	-- Big Iron Bomb
	[12562] = "Incapacitate", 	-- The Big One
	[12543] = "Incapacitate", 	-- Hi-Explosive Bomb
	[19769] = "Incapacitate", 	-- Thorium Grenade
	[19784] = "Incapacitate", 	-- Dark Iron Bomb
	[30216] = "Incapacitate", 	-- Fel Iron Bomb
	[30461] = "Incapacitate", 	-- The Bigger One
	[30217] = "Incapacitate", 	-- Adamantite Grenade

	[47481] = "Stun",      -- Gnaw (Ghoul Pet)
	[5211]  = "Stun",      -- Bash
	[22570] = "Stun",      -- Maim
	[24394] = "Stun",      -- Intimidation
	[50519] = "Stun",      -- Sonic Blast
	[50518] = "Stun",      -- Ravage
	[44572] = "Stun",      -- Deep Freeze
	[853]   = "Stun",      -- Hammer of Justice
	[2812]  = "Stun",      -- Holy Wrath
	[408]   = "Stun",      -- Kidney Shot
	[1833]  = "Stun", 	   -- Cheap Shot
	[58861] = "Stun",      -- Bash (Spirit Wolves)
	[30283] = "Stun",      -- Shadowfury
	[12809] = "Stun",      -- Concussion Blow
	[60995] = "Stun",      -- Demon Charge
	[30153] = "Stun",      -- Pursuit
	[20253] = "Stun",      -- Intercept Stun
	[46968] = "Stun",      -- Shockwave
	[20549] = "Stun",      -- War Stomp (Racial)
	[85388] = "Stun",      -- Throwdown
	[90337] = "Stun",      -- Bad Manner (Hunter Pet Stun)
	[91800] = "Stun",	   -- Gnaw (DK Pet Stun)

	[16922] = "RandomStun", 	-- Celestial Focus (Starfire Stun)
	[28445] = "RandomStun", 	-- Improved Concussive Shot
	[12355] = "RandomStun", 	-- Impact
	[20170] = "RandomStun", 	-- Seal of Justice Stun
	[39796] = "RandomStun", 	-- Stoneclaw Stun
	[12798] = "RandomStun", 	-- Revenge Stun
	[5530]  = "RandomStun", 	-- Mace Stun Effect (Mace Specialization)
	[15283] = "RandomStun", 	-- Stunning Blow (Weapon Proc)
	[56]    = "RandomStun", 	-- Stun (Weapon Proc)
	[34510] = "RandomStun", 	-- Stormherald/Deep Thunder (Weapon Proc)

	[1513]  = "Fear",      -- Scare Beast
	[10326] = "Fear",      -- Turn Evil
	[8122]  = "Fear",      -- Psychic Scream
	[2094]  = "Fear",      -- Blind
	[5782]  = "Fear",      -- Fear
	[6358]  = "Fear",      -- Seduction (Succubus)
	[5484]  = "Fear",      -- Howl of Terror
	[5246]  = "Fear",      -- Intimidating Shout
	[5134]  = "Fear",      -- Flash Bomb Fear (Item)

	[339]   = "Root",      -- Entangling Roots
	[19975] = "Root",      -- Nature's Grasp
	[50245] = "Root",      -- Pin
	[33395] = "Root",      -- Freeze (Water Elemental)
	[122]   = "Root",      -- Frost Nova
	[39965] = "Root",      -- Frost Grenade (Item)
	[63685] = "Root",      -- Freeze (Frost Shock)

	[12494] = "RandomRoot", -- Frostbite
	[55080] = "RandomRoot", -- Shattered Barrier
	[58373] = "RandomRoot", -- Glyph of Hamstring
	[23694] = "RandomRoot", -- Improved Hamstring
	[47168] = "RandomRoot", -- Improved Wing Clip
	[19185] = "RandomRoot", -- Entrapment

	[53359] = "Disarm",    -- Chimera Shot (Scorpid)
	[50541] = "Disarm",    -- Clench
	[64058] = "Disarm",    -- Psychic Horror Disarm Effect
	[51722] = "Disarm",    -- Dismantle
	[676]   = "Disarm",    -- Disarm

	[47476] = "Silence",   -- Strangulate
	[34490] = "Silence",   -- Silencing Shot
	[35334] = "Silence",   -- Nether Shock (Rank 1)
	[44957] = "Silence",   -- Nether Shock (Rank 2)
	[18469] = "Silence",   -- Silenced - Improved Counterspell (Rank 1)
	[55021] = "Silence",   -- Silenced - Improved Counterspell (Rank 2)
	[15487] = "Silence",   -- Silence
	[1330]  = "Silence",   -- Garrote - Silence
	[18425] = "Silence",   -- Silenced - Improved Kick
	[24259] = "Silence",   -- Spell Lock
	[43523] = "Silence",   -- Unstable Affliction 1
	[31117] = "Silence",   -- Unstable Affliction 2
	[18498] = "Silence",   -- Silenced - Gag Order (Shield Slam)
	[50613] = "Silence",   -- Arcane Torrent (Racial, Runic Power)
	[28730] = "Silence",   -- Arcane Torrent (Racial, Mana)
	[25046] = "Silence",   -- Arcane Torrent (Racial, Energy)

	[64044] = "Horror",    -- Psychic Horror
	[6789]  = "Horror",    -- Death Coil

	[9005]  = "OpenerStun", -- Pounce

	[31661] = "Scatter",   -- Dragon's Breath
	[19503] = "Scatter",   -- Scatter Shot

	-- Spells that DR with itself only
	[33786] = "Cyclone",    	-- Cyclone
	[605]   = "MindControl", 	-- Mind Control
	[13181] = "MindControl", 	-- Gnomish Mind Control Cap
	[7922]  = "Charge",     	-- Charge Stun
	[19306] = "Counterattack", 	-- Counterattack
}
