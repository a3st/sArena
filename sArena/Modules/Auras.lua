local interruptList = {
	[1766] = 5, 	-- Kick (Rogue)
	[2139] = 8, 	-- Counterspell (Mage)
	[6552] = 4, 	-- Pummel (Warrior)
	[33871] = 8, 	-- Shield Bash (Warrior)
	[24259] = 3, 	-- Spell Lock (Warlock)
	[43523] = 5,	-- Unstable Affliction (Warlock)
	[16979] = 4, 	-- Feral Charge (Druid)
	[26679] = 6, 	-- Deadly Throw (Rogue)
	[57994] = 2, 	-- Wind Shear (Shaman)
};

local auraList = tInvert({
	-- Higher up = higher priority

	-- Stun
	33786, 		-- Cyclone
	58861, 		-- Bash (Spirit Wolves)
	5211, 		-- Bash
	6789, 		-- Death Coil
	1833, 		-- Cheap Shot
	7922, 		-- Charge Stun
	12809, 		-- Concussion Blow
	44572, 		-- Deep Freeze
	60995, 		-- Demon Charge
	47481, 		-- Gnaw
	853, 		-- Hammer of Justice
	85388, 		-- Throwdown
	90337, 		-- Bad Manner
	20253, 		-- Intercept
	30153, 		-- Pursuit
	24394, 		-- Intimidation
	408, 		-- Kidney Shot
	22570, 		-- Maim
	9005, 		-- Pounce
	64058, 		-- Psychic Horror
	6572, 		-- Ravage
	30283, 		-- Shadowfury
	46968, 		-- Shockwave
	39796, 		-- Stoneclaw Stun
	20549, 		-- War Stomp

	-- Silences
	25046, 		-- Arcane Torrent
	1330, 		-- Garrote
	15487, 		-- Silence
	18498, 		-- Silenced - Gag Order
	18469, 		-- Silenced - Improved Counterspell
	55021, 		-- Silenced - Improved Counterspell
	18425, 		-- Silenced - Improved Kick
	34490, 		-- Silencing Shot
	24259, 		-- Spell Lock
	47476, 		-- Strangulate
	43523, 		-- Unstable Affliction

	-- Stun Procs
	34510, 		-- Stun
	20170, 		-- Seal of Justice
	12355, 		-- Impact
	23454, 		-- Stun

	-- Disorient / Incapacitate / Fear / Charm
	2094, 		-- Blind
	31661, 		-- Dragon's Breath
	5782, 		-- Fear
	3355, 		-- Freezing Trap - Effect
	1776, 		-- Gouge
	51514, 		-- Hex
	2637, 		-- Hibernate
	5484, 		-- Howl of Terror
	49203, 		-- Hungering Cold
	5246, 		-- Intimdating Shout
	605, 		-- Mind Control
	118, 		-- Polymorph
	28271, 		-- Polymorph: Turtle
	28272, 		-- Polymorph: Pig
	61721,		-- Polymorph: Rabbit
	61780,		-- Polymorph: Turkey
	61305,		-- Polymorph: Black Cat
	8122, 		-- Psychic Scream
	20066, 		-- Repentance
	6770, 		-- Sap
	1513, 		-- Scare Beast
	19503, 		-- Scatter Shot
	6358, 		-- Seduction
	9484, 		-- Shackle Undead
	1090, 		-- Sleep
	10326, 		-- Turn Evil
	19386, 		-- Wyvern Sting
	88625, 		-- Chastise
	710, 		-- Banish

	-- Immunities
	46924, 		-- Bladestorm
	19263, 		-- Deterence
	47585, 		-- Dispersion
	642, 		-- Divine Shield
	498, 		-- Divine Protection
	45438, 		-- Ice Block
	34692, 		-- The Beast Within
	26064, 		-- Shell Shield
	19574, 		-- Bestial Wrath
	1022, 		-- Hand of Protection
	3169, 		-- Invulnerability
	20230, 		-- Retaliation
	16621, 		-- Self Invulnerability
	92681, 		-- Phase Shift
	20594, 		-- Stoneform
	31224, 		-- Cloak of Shadows
	27827, 		-- Spirit of Redemption

	-- Anti CCs
	48707, 		-- Anti-Magic Shell
	23920, 		-- Spell Reflection
	8178, 		-- Grounding Totem Effect
	6940, 		-- Hand of Sacrifice
	5384, 		-- Feign Death
	34471, 		-- The Beast Within

	-- Disarms
	676, 		-- Disarm
	15752, 		-- Disarm
	14251, 		-- Riposte
	51722, 		-- Dismantle

	-- Roots
	339, 		-- Entangling Roots
	19975, 		-- Entangling Roots (Nature's Grasp talent)

	25999, 		-- Boar Charge
	4167, 		-- Web
	122, 		-- Frost Nova
	33395, 		-- Freeze (Water Elemental)
	19306, 		-- Counterattack

	-- Root Proc
	35963, 		-- Improved Wing Clip
	19185, 		-- Entrapment
	23694, 		-- Improved Hamstring

	-- Refreshments
	22734, 		-- Drink
	28612, 		-- Cojured Food
	33717, 		-- Cojured Food

	-- Offensive Buffs
	13750, 		-- Adrenaline Rush
	12042, 		-- Arcane Power
	31884, 		-- Avenging Wrath
	34936, 		-- Backlash
	50334, 		-- Berserk
	2825, 		-- Bloodlust
	14177, 		-- Cold Blood
	12292, 		-- Death Wish
	16166, 		-- Elemental Mastery
	12051, 		-- Evocation
	18708, 		-- Fel Domination
	12472, 		-- Icy Veins
	29166, 		-- Innervate
	32182, 		-- Heroism
	51690, 		-- Killing Spree
	47241, 		-- Metamorphasis
	17941, 		-- Shadow Trance
	10060, 		-- Power Infusion
	12043, 		-- Presence of Mind
	3045, 		-- Rapid Fire
	1719, 		-- Recklessness
	51713, 		-- Shadow Dance

	-- Defensive Buffs
	3411, 		-- Intervene
	53476, 		-- Intervene (Hunter Pet)
	871, 		-- Shield Wall
	33206, 		-- Pain Suppresion
	47788, 		-- Guardian Spirit
	47000, 		-- Improved Blink
	5277, 		-- Evasion
	30823, 		-- Shamanistic Rage
	18499, 		-- Berserker Rage
	55694, 		-- Enraged Regeneration
	31842, 		-- Divine Favor
	31821, 		-- Aura Mastery
	1044, 		-- Hand of Freedom
	22812, 		-- Barkskin
	16188, 		-- Nature's Swiftness
	48792, 		-- Icebound Fortitude
	50461,  	-- Anti-Magic Zone
	47484, 		-- Huddle

	-- Miscellaneous
	41425, 		-- Hypothermia
	66, 		-- Invisibility
	6346, 		-- Fear Ward
	2457, 		-- Battle Stance
	2458, 		-- Berserker Stance
	71, 		-- Defensive Stance
})

function sArenaFrameMixin:FindInterrupt(event, spellID)
	local interruptDuration = interruptList[spellID]

	if (not interruptDuration) then return end
	if (event ~= "SPELL_INTERRUPT" and event ~= "SPELL_CAST_SUCCESS") then return end

	local unit = self.unit
	local _, _, _, _, _, _, notInterruptable = UnitChannelInfo(unit)

	if (event == "SPELL_INTERRUPT" or notInterruptable == false) then
		self.currentInterruptSpellID = spellID
		self.currentInterruptDuration = interruptDuration
		self.currentInterruptExpirationTime = GetTime() + interruptDuration
		self.currentInterruptTexture = GetSpellTexture(spellID)
		self:FindAura()
		C_Timer.After(interruptDuration, function()
			self.currentInterruptSpellID = nil
			self.currentInterruptDuration = 0
			self.currentInterruptExpirationTime = 0
			self.currentInterruptTexture = nil
			self:FindAura()
		end)
	end
end

function sArenaFrameMixin:UpdateClassIcon()
	if (self.currentAuraSpellID and self.currentAuraDuration > 0 and self.currentClassIconStartTime ~= self.currentAuraStartTime) then
		self.ClassIconCooldown:SetCooldown(self.currentAuraStartTime, self.currentAuraDuration)
		self.currentClassIconStartTime = self.currentAuraStartTime
	elseif (self.currentAuraDuration == 0) then
		self.ClassIconCooldown:Clear()
		self.currentClassIconStartTime = 0
	end

	local texture = self.currentAuraSpellID and self.currentAuraTexture or self.class and "class" or 134400

	if (self.currentClassIconTexture == texture) then return end

	self.currentClassIconTexture = texture

	-- Could do SetPortraitTexture() since its hooked anyway in my other addon
	if (texture == "class") then
		self.ClassIcon:SetTexture(sArenaMixin.iconPath, true);
		self.ClassIcon:SetTexCoord(unpack(sArenaMixin.classIcons[self.class]));
		return
	end
	self.ClassIcon:SetTexCoord(0, 1, 0, 1)
	self.ClassIcon:SetTexture(texture)
end

function sArenaFrameMixin:FindAura()
	local unit = self.unit
	local currentSpellID, currentDuration, currentExpirationTime, currentTexture = nil, 0, 0, nil

	if (self.currentInterruptSpellID) then
		currentSpellID = self.currentInterruptSpellID
		currentDuration = self.currentInterruptDuration
		currentExpirationTime = self.currentInterruptExpirationTime
		currentTexture = self.currentInterruptTexture
	end

	for i = 1, 2 do
		local filter = (i == 1 and "HELPFUL" or "HARMFUL")

		for n = 1, 30 do
			local _, texture, _, _, duration, expirationTime, _, _, _, spellID = UnitAura(unit, n, filter)

			if (not spellID) then break end

			if (auraList[spellID]) then
				if (not currentSpellID or auraList[spellID] < auraList[currentSpellID]) then
					currentSpellID = spellID

					currentDuration = duration
					currentExpirationTime = expirationTime
					currentTexture = texture
				end
			end
		end
	end

	if (currentSpellID) then
		self.currentAuraSpellID = currentSpellID
		self.currentAuraStartTime = currentExpirationTime - currentDuration
		self.currentAuraDuration = currentDuration
		self.currentAuraTexture = currentTexture
	else
		self.currentAuraSpellID = nil
		self.currentAuraStartTime = 0
		self.currentAuraDuration = 0
		self.currentAuraTexture = nil
	end

	self:UpdateClassIcon()
end
