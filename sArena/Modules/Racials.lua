local GetTime = GetTime

sArenaMixin.defaultSettings.profile.racialCategories = {
	["Human"] = true,
	["Scourge"] = true,
	["Gnome"] = true,
	["Dwarf"] = true,
	["Orc"] = true,
	["Tauren"] = true,
	["BloodElf"] = true,
	["Troll"] = true,
	["Draenei"] = false,
	["NightElf"] = false,
	["Goblin"] = false,
	["Worgen"] = false,
}

local racialSpells = {
	[20549] = 120, 		-- War Stomp
	[7744] = 120, 		-- Will of the Forsaken
	[20554] = 180, 		-- Berserking
	[20572] = 120, 		-- Blood Fury
	[58984] = 10, 		-- Shadowmeld
	[20589] = 105, 		-- Escape Artist
	[20594] = 180, 		-- Stoneform
	[59752] = 120, 		-- Will to Survive
	[26297] = 180, 		-- Berserking - Rogue
	[28880] = 180, 		-- Gift of the Naaru
	[26296] = 180, 		-- Berserking - Warr
	[33702] = 120, 		-- Blood Fury - Caster
	[25046] = 120, 		-- Arcane Torrent - Rogue
	[28730] = 120, 		-- Arcane Torrent
	[50613] = 120, 		-- Arcane Torrent - Death Knight
	[69070] = 120, 		-- Rocket Jump
	[69041] = 120, 		-- Rocket Barrage
	[68992] = 120, 		-- Darkflight
}

local racialData = {
	["Human"] = { texture = GetSpellTexture(59752), sharedCD = 120 },
	["Scourge"] = { texture = GetSpellTexture(7744), sharedCD = 45 },
	["Gnome"] = { texture = GetSpellTexture(20589) },
	["Dwarf"] = { texture = GetSpellTexture(20594) },
	["Orc"] = { texture = GetSpellTexture(20572) },
	["Tauren"] = { texture = GetSpellTexture(20549) },
	["BloodElf"] = { texture = GetSpellTexture(28730) },
	["Troll"] = { texture = GetSpellTexture(26296) },
	["Draenei"] = { texture = GetSpellTexture(28880) },
	["NightElf"] = { texture = GetSpellTexture(20580) },
	["Goblin"] = { texture = GetSpellTexture(69041) },
	["Worgen"] = { texture = GetSpellTexture(68992) },
}

local function GetRemainingCD(frame)
	local startTime, duration = frame:GetCooldownTimes()
	if (startTime == 0) then return 0 end

	local currTime = GetTime()

	return (startTime + duration) / 1000 - currTime
end

function sArenaFrameMixin:FindRacial(event, spellID)
	if (event ~= "SPELL_CAST_SUCCESS") then return end

	local duration = racialSpells[spellID]

	if (duration) then
		local currTime = GetTime()

		if (self.Racial.Texture:GetTexture()) then
			self.Racial.Cooldown:SetCooldown(currTime, duration)
		end
		local remainingCD = GetRemainingCD(self.Trinket.Cooldown)
		local sharedCD = racialData[self.race].sharedCD

		if (sharedCD and remainingCD < sharedCD) then
			self.Trinket.Cooldown:SetCooldown(currTime, sharedCD)
		end
	elseif ((spellID == 42292) and self.Racial.Texture:GetTexture()) then
		local remainingCD = GetRemainingCD(self.Racial.Cooldown)
		local sharedCD = racialData[self.race].sharedCD

		if (sharedCD and remainingCD < sharedCD) then
			self.Racial.Cooldown:SetCooldown(GetTime(), sharedCD)
		end
	end
end

function sArenaFrameMixin:UpdateRacial()
	if (not self.race) then
		self.race = select(2, UnitRace(self.unit))

		if (self.parent.db.profile.racialCategories[self.race]) then
			self.Racial.Texture:SetTexture(racialData[self.race].texture)
		end

		-- Detecting human & using placeholder trinket
		if self.race == "Human" then
			self.Trinket.Texture:SetTexture(133452)
		end
	end
end

function sArenaFrameMixin:ResetRacial()
	self.race = nil
	self.Racial.Texture:SetTexture(nil)
	self.Racial.Cooldown:Clear()
	self:UpdateRacial()
end
