local interruptList = {
	-- Interrupts

	[38768] = 5, -- Kick (Rogue) R5
	[1769] = 5, -- Kick (Rogue) R4
	[1768] = 5, -- Kick (Rogue) R3
	[1767] = 5, -- Kick (Rogue) R2
	[1766] = 5, -- Kick (Rogue) R1

	[2139] = 8, -- Counterspell (Mage)

	[6552] = 4, -- Pummel (Warrior) R1
	[6554] = 4, -- Pummel (Warrior) R2

	[29704] = 6, -- Shield Bash (Warrior) R4
	[1672] = 6, -- Shield Bash (Warrior) R3
	[1671] = 6, -- Shield Bash (Warrior) R2
	[72] = 6, -- Shield Bash (Warrior) R1

	[19244] = 5, -- Spell Lock (Warlock) R1
	[19647] = 6, -- Spell Lock (Warlock) R2
	[24259] = 5, -- Spell Lock (Warlock) (?)

	-- [31117] = 5,  	-- Unstable Affliction - Silence 1
	-- [43523] = 5,	    -- Unstable Affliction - Silence 2

	[16979] = 4, -- Feral Charge (Druid)
	[19675] = 4, -- Feral Charge - Interrupt Effect

	[26679] = 3, -- Deadly Throw (Rogue)

	[57994] = 2, -- Wind Shear (Shaman)
};

local auraList = tInvert({
	-- Higher up = higher priority

	-- CCs (new list)
	-- Stun
	33786, -- Cyclone

	58861, -- Bash (spirit wolves)
	5211, -- Bash
	6798, -- Bash R2
	8983, -- Bash R3

	47860, -- Death Coil
	27223, -- Death Coil R4
	17926, -- Death Coil R3
	17925, -- Death Coil R2
	6789, -- Death Coil R1

	1833, -- Cheap Shot
	7922, -- Charge Stun
	1833, -- Cheap Shot
	12809, -- Concussion Blow

	44572, -- Deep Freeze
	60995, -- Demon Charge

	47481, -- Gnaw

	853, -- Hammer of Justice
	10308, -- Hammer of Justice R4
	5589, -- Hammer of Justice R3
	5588, -- Hammer of Justice R2

	48817, -- Holy Wrath

	47995, -- Intercept
	20253, -- Intercept
	30153, -- Intercept
	25274, -- Intercept Stun
	30195, -- Intercept (Felguard) Rank 2
	30197, -- Intercept (Felguard) Rank 3

	24394, -- Intimidation
	19577, -- Intimidation ?

	405, -- Kidney Shot
	8643, -- Kidney Shot
	49802, -- Maim
	22570, -- Maim

	9005, -- Pounce
	49803, -- Pounce
	27006, -- Pounce
	9827, -- Pounce
	9823, -- Pounce


	64058, -- Psychic Horror
	64044, -- Psychic Horror

	53562, -- Ravage
	12798, -- Revenge Stun

	30283, -- Shadowfury
	30414, -- Shadowfury R3
	30413, -- Shadowfury R2
	30283, -- Shadowfury R1
	46968, -- Shockwave

	16922, -- Starfire Stun
	39796, -- Stoneclaw Stun
	20170, -- Stun

	20549, -- War Stomp
	19482, -- War Stomp

	-- Silences

	25046, -- Arcane Torrent
	50613, -- Arcane Torrent
	28730, -- Arcane Torrent

	1330, -- Garrote - silence

	15487, -- Silence
	18498, -- Silenced - gag order
	18469, -- Silenced - Improved Counterspell
	55021, -- Silenced - Improved Counterspell
	18425, -- Silenced - Improved Kick
	63529, -- Silenced - Shield of the Templar

	34490, -- Silencing Shot
	24259, -- Spell Lock
	47476, -- Strangulate

	43523, -- Unstable Affliction Silence


	-- Stun Procs

	34510, -- Stormheral Stun
	5530, -- Mace Specialization
	19410, -- Improved Concussive Shot
	28445, -- Improved Concussive Shot
	20170, -- Seal of Justice Stun
	18093, -- Pyroclasm ???
	16922, -- Starfire Stun
	15269, -- Blackout
	12355, -- Impact
	23454, -- Brutal Earthstorm Diamond

	-- Disorient / Incapacitate / Fear / Charm

	2094, -- Blind

	51722, -- Dismantle

	42950, -- Dragon's Breath
	33043, -- Dragon's Breath R4
	33042, -- Dragon's Breath R3
	33041, -- Dragon's Breath R2
	31661, -- Dragon's Breath R1

	6215, -- Fear R3
	6213, -- Fear R2
	5782, -- Fear R1

	60210, -- Freezing Arrow Effect
	14309, -- Freezing Trap -Effect R3
	14308, -- Freezing Trap - Effect R2
	3355, -- Freezing Trap - Effect R1

	1776, -- Gouge
	38764, -- Gouge R6
	11286, -- Gouge R5
	11285, -- Gouge R4
	8629, -- Gouge R3
	1777, -- Gouge R2
	51514, -- Hex
	2637, -- Hibernate
	18658, -- Hibernate R3
	18657, -- Hibernate R2
	2637, -- Hibernate R1

	5484, -- Howl of Terror
	49203, -- Hungering Cold

	5246, -- Intimdating Shout
	20511, -- Intimidating Shout??

	605, -- Mind Control
	118, -- Polymorph
	12826, -- Polymorph R4
	12825, -- Polymorph R3
	12824, -- Polymorph R2
	28271, -- Polymorph: Turtle
	28272, -- Polymorph: Pig

	8122, -- Psychic Scream
	10890, -- Phychic Scream R4
	10888, -- Phychic Scream R3
	8124, -- Phychic Scream R2

	20066, -- Repentance
	2070, -- Sap
	51724, -- Sap
	11297, -- Sap R3
	6770, -- Sap R1

	1513, -- Scare Beast
	19503, -- Scatter Shot

	6358, -- Seduction
	9484, -- Shackle Undead

	1090, -- Sleep

	10326, -- Turn Evil

	49012, -- Wyvern Sting
	19386, -- Wyvern Sting
	27068, -- Wyvern Sting R4
	24133, -- Wyvern Sting R3
	24132, -- Wyvern Sting R2
	19386, -- Wyvern Sting R1

	-- Immunities
	46924, -- Bladestorm
	19262, -- Deterence
	47585, -- Dispersion
	1020, -- Divine Shield R2
	642, -- Divine Shield R1
	5573, -- Divine Protection KEKW
	498, -- Divine Protection KEKW

	45438, -- Ice Block
	34692, -- The Beast Within
	26064, -- Shell Shield (damage taken reduced 50%) (Turtle)
	19574, -- Bestial Wrath1
	18574, -- Bestial Wrath2
	1022, -- Hand of Protection
	3169, -- Invulnerability

	20230, -- Retaliation
	16621, -- Self Invulnerability

	4511, -- Phase Shift

	20594, -- Stoneform (dwarf racial)

	31224, -- Cloak of Shadows

	27827, --Spirit of Redemption


	-- Interrupts

	38768, -- Kick (Rogue) R5
	1769, -- Kick (Rogue) R4
	1768, -- Kick (Rogue) R3
	1767, -- Kick (Rogue) R2
	1766, -- Kick (Rogue) R1

	2139, -- Counterspell (Mage)
	18469, -- Counterspell - Silenced
	29443, -- Counterspell

	6552, -- Pummel (Warrior) R1
	6554, -- Pummel (Warrior) R2
	26090, -- Pummel (pet?)
	13491, -- Pummel

	29704, -- Shield Bash (Warrior) R4
	1672, -- Shield Bash (Warrior) R3
	1671, -- Shield Bash (Warrior) R2
	72, -- Shield Bash (Warrior) R1

	19647, -- Spell Lock (Warlock) R2
	19244, -- Spell Lock - Effect
	24259, -- Spell Lock (Warlock) R1
	31117, -- Unstable Affliction - Silence 1
	43523, -- Unstable Affliction - Silence 2

	22570, -- Maim
	47528, -- Mind Freeze

	19675, -- Feral Charge (old?)
	16979, -- Feral Charge

	34490, -- Silencing Shot - Effect
	18498, -- Shield Bash - Silenced (Improved Shield Bash talent)

	26679, -- Deadly Throw - Interrupt
	1330, -- Garrote - Silence


	-- Anti CCs
	48707, -- Anti-Magic Shell
	23920, -- Spell Reflection
	8178, -- Grounding Totem Effect
	6940, -- Hand of Sacrifice
	54748, -- Burning Determination
	5384, -- Hunter: Feign Death
	34471, -- The Beast Within



	-- Disarms
	676, -- Disarm (Warrior)
	15752, -- Disarm
	14251, -- Riposte
	51722, -- Dismantle

	-- Roots
	53308, -- Entangling roots
	26989, -- Entangling roots R7
	9853, -- Entangling roots R6
	9852, -- Entangling roots R5
	5196, -- Entangling roots R4
	5195, -- Entangling roots R3
	1062, -- Entangling roots R2
	339, -- Entangling roots R1

	19975, -- Entangling Roots R1 (Nature's Grasp talent)
	19974, -- Entangling Roots R2 (Nature's Grasp talent)
	19973, -- Entangling Roots R3 (Nature's Grasp talent)
	19972, -- Entangling Roots R4 (Nature's Grasp talent)
	19971, -- Entangling Roots R5 (Nature's Grasp talent)
	19970, -- Entangling Roots R6 (Nature's Grasp talent)
	27010, -- Entangling Roots R7 (Nature's Grasp talent)

	25999, -- Boar Charge (Boar)
	4167, -- Web R1
	4168, -- Web R2
	4169, -- Web R3

	27088, -- Frost Nova R5
	10230, -- Frost Nova R4
	6131, -- Frost Nova R3
	865, -- Frost Nova R2
	122, -- Frost Nova R1

	33395, -- Freeze (Water Elemental)

	48999, -- Counterattack
	19306, -- Counterattack R1

	44047, -- Chastise R6
	44046, -- Chastise R5
	44045, -- Chastise R4
	44044, -- Chastise R3
	44043, -- Chastise R2
	44041, -- Chastise R1

	-- Root Proc

	19229, -- Improved Wing Clip
	19185, -- Entrapment
	12494, -- Frostbite
	23694, -- Improved Hamstring


	-- Refreshments
	22734, -- Drink
	32453, -- Star's Tears
	34062, -- Conjured Manna Biscuit
	30703, -- Conjured Mountain Spring Water
	22018, -- Conjured Glacier Water
	28612, -- Cojured Food
	33717, -- Cojured Food




	-- Offensive Buffs

	13750, -- Adrenaline Rush
	12042, -- Arcane Power
	31884, -- Avenging Wrath
	34936, -- Backlash
	50334, -- Berserk
	18574, -- Bestial Wrath (higher in prio as well)
	2825, -- Bloodlust
	28682, -- Combustion
	14177, -- Cold Blood
	12292, -- Death Wish
	16166, -- Elemental Mastery

	12051, -- Evocation
	18708, -- Fel Domination
	12472, -- Icy Veins
	29166, -- Innervate

	32182, -- Heroism
	51690, -- Killing Spree
	47241, -- Metamorphasis
	17941, -- Nightfall
	10060, -- Power Infusion
	12043, -- Presence of Mind

	3045, -- Rapid Fire
	1719, -- Recklessness

	51713, -- Shadow Dance

	53201, -- Starfall
	53199, -- Starfall (rank 1)



	-- Defensive Buffs

	3411, -- Intervene
	53476, -- Hunter Pet Intervene

	871, -- Shield Wall
	33206, -- Pain Suppresion
	47788, -- Guardian Spirit

	46989, -- Improved Blink R2
	47000, -- Improved Blink R1

	26669, -- Evasion R2
	5277, -- Evasion R1


	30823, -- Shamanistic Rage


	18499, -- Berserker Rage
	55694, -- Enraged Regeneration


	20216, -- Divine Favor
	31821, -- Aura Mastery
	1044, -- Hand of Freedom


	22812, -- Barkskin
	16188, -- Nature's Swiftness
	17116, -- Nature's Swiftness 2


	19263, -- Deterrance

	48792, -- Icebound Fortitude
	48707, -- Anti-Magic Shell
	--50461,  -- Anti-Magic Zone (placed higher)
	47484, -- Huddle


	-- Miscellaneous

	41425, -- Hypothermia
	66, -- Invisibility fade effect
	22734, -- Drink
	6346, -- Fear Ward
	2457, -- Battle Stance
	2458, -- Berserker Stance
	71, -- Defensive Stance
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
