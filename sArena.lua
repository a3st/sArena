sArenaMixin = {}
sArenaFrameMixin = {}

sArenaMixin.layouts = {}
sArenaMixin.defaultSettings = {
    profile = {
        currentLayout = "BlizzArena",
        classColors = true,
        showNames = true,
        statusText = {
            usePercentage = false,
            alwaysShow = true,
        },
        layoutSettings = {},
    }
}

sArenaMixin.iconPath = "Interface\\Addons\\sArena\\Textures\\UI-CLASSES-SQUARE.BLP"

sArenaMixin.classIcons = {
    -- UpperLeftx, UpperLefty, LowerLeftx, LowerLefty, UpperRightx, UpperRighty, LowerRightx, LowerRighty
    ["WARRIOR"] = { 0, 0, 0, 0.25, 0.25, 0, 0.25, 0.25 },
    ["ROGUE"] = { 0.5, 0, 0.5, 0.25, 0.75, 0, 0.75, 0.25 },
    ["DRUID"] = { 0.75, 0, 0.75, 0.25, 1, 0, 1, 0.25 },
    ["WARLOCK"] = { 0.75, 0.25, 0.75, 0.5, 1, 0.25, 1, 0.5 },
    ["HUNTER"] = { 0, 0.25, 0, 0.5, 0.25, 0.25, 0.25, 0.5 },
    ["PRIEST"] = { 0.5, 0.25, 0.5, 0.5, 0.75, 0.25, 0.75, 0.5 },
    ["PALADIN"] = { 0, 0.5, 0, 0.75, 0.25, 0.5, 0.25, 0.75 },
    ["SHAMAN"] = { 0.25, 0.25, 0.25, 0.5, 0.5, 0.25, 0.5, 0.5 },
    ["MAGE"] = { 0.25, 0, 0.25, 0.25, 0.5, 0, 0.5, 0.25 },
    ["DEATHKNIGHT"] = { 0.25, 0.5, 0.25, 0.75, 0.5, 0.5, 0.50, 0.75 }
}

local db
local emptyLayoutOptionsTable = {
    notice = {
        name = "The selected layout doesn't appear to have any settings.",
        type = "description",
    }
}
local blizzFrame

local function UpdateBlizzVisibility(instanceType)
    -- Hide Blizzard Arena Frames while in Arena
    if (InCombatLockdown()) then return end
    if (not IsAddOnLoaded("Blizzard_ArenaUI")) then return end
    if (IsAddOnLoaded("ElvUI")) then return end

    if (not blizzFrame) then
        blizzFrame = CreateFrame("Frame", nil, UIParent)
        blizzFrame:SetSize(1, 1)
        blizzFrame:SetPoint("RIGHT", UIParent, "RIGHT", 500, 0)
        blizzFrame:Hide()
    end

    for i = 1, 5 do
        local arenaFrame = _G["ArenaEnemyFrame" .. i]
        local prepFrame = _G["ArenaPrepFrame" .. i]

        arenaFrame:ClearAllPoints()
        prepFrame:ClearAllPoints()

        if (instanceType == "arena") then
            arenaFrame:SetParent(blizzFrame)
            arenaFrame:SetPoint("CENTER", blizzFrame, "CENTER")
            prepFrame:SetParent(blizzFrame)
            prepFrame:SetPoint("CENTER", blizzFrame, "CENTER")
        end
    end
end

-- Parent Frame

function sArenaMixin:OnLoad()
    self:RegisterEvent("PLAYER_LOGIN")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function sArenaMixin:OnEvent(event)
    if (event == "PLAYER_LOGIN") then
        self:Initialize()
        self:UnregisterEvent("PLAYER_LOGIN")
    elseif (event == "PLAYER_ENTERING_WORLD") then
        local _, instanceType = IsInInstance()
        UpdateBlizzVisibility(instanceType)
        self:SetMouseState(true)

        if (instanceType == "arena") then
            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        else
            self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
    elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
        local _, combatEvent, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType =
            CombatLogGetCurrentEventInfo()

        for i = 1, 5 do
            local ArenaFrame = self["arena" .. i]

            if (sourceGUID == UnitGUID("arena" .. i)) then
                ArenaFrame:FindRacial(combatEvent, spellID)
            end

            if (ArenaFrame.specTexture == 134400 or ArenaFrame.specTexture == nil) then
                if (sourceGUID == UnitGUID("arena" .. i)) then
                    ArenaFrame:FindSpec(combatEvent, spellID)
                end
            end

            if (sourceGUID == UnitGUID("arena" .. i)) then
                ArenaFrame:FindTrinket(combatEvent, spellID)
            end

            if (destGUID == UnitGUID("arena" .. i)) then
                ArenaFrame:FindInterrupt(combatEvent, spellID)

                if (auraType == "DEBUFF") then
                    ArenaFrame:FindDR(combatEvent, spellID)
                end
            end
        end
    end
end

local function ChatCommand(input)
    if not input or input:trim() == "" then
        LibStub("AceConfigDialog-3.0"):Open("sArena")
    else
        LibStub("AceConfigCmd-3.0").HandleCommand("sArena", "sarena", "sArena", input)
    end
end

function sArenaMixin:Initialize()
    if (db) then return end

    self.db = LibStub("AceDB-3.0"):New("sArena3DB", self.defaultSettings, true)
    db = self.db

    db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    self.optionsTable.handler = self
    self.optionsTable.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("sArena", self.optionsTable)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("sArena")
    LibStub("AceConfigDialog-3.0"):SetDefaultSize("sArena", 700, 620)
    LibStub("AceConsole-3.0"):RegisterChatCommand("sarena", ChatCommand)

    self:SetLayout(nil, db.profile.currentLayout)
end

function sArenaMixin:RefreshConfig()
    self:SetLayout(nil, db.profile.currentLayout)
end

function sArenaMixin:SetLayout(_, layout)
    if (InCombatLockdown()) then return end

    layout = sArenaMixin.layouts[layout] and layout or "BlizzArena"

    db.profile.currentLayout = layout
    self.layoutdb = self.db.profile.layoutSettings[layout]

    for i = 1, 5 do
        local frame = self["arena" .. i]
        frame:ResetLayout()
        self.layouts[layout]:Initialize(frame)
        frame:UpdatePlayer()
    end

    self.optionsTable.args.layoutSettingsGroup.args = self.layouts[layout].optionsTable and
        self.layouts[layout].optionsTable or emptyLayoutOptionsTable
    LibStub("AceConfigRegistry-3.0"):NotifyChange("sArena")

    local _, instanceType = IsInInstance()
    if (instanceType ~= "arena" and self.arena1:IsShown()) then
        self:Test()
    end
end

function sArenaMixin:SetupDrag(frameToClick, frameToMove, settingsTable, updateMethod)
    frameToClick:HookScript("OnMouseDown", function()
        if (InCombatLockdown()) then return end

        if (IsShiftKeyDown() and IsControlKeyDown() and not frameToMove.isMoving) then
            frameToMove:StartMoving()
            frameToMove.isMoving = true
        end
    end)

    frameToClick:HookScript("OnMouseUp", function()
        if (InCombatLockdown()) then return end

        if (frameToMove.isMoving) then
            frameToMove:StopMovingOrSizing()
            frameToMove.isMoving = false

            local settings = db.profile.layoutSettings[db.profile.currentLayout]

            if (settingsTable) then
                settings = settings[settingsTable]
            end

            local parentX, parentY = frameToMove:GetParent():GetCenter()
            local frameX, frameY = frameToMove:GetCenter()
            local scale = frameToMove:GetScale()

            frameX = ((frameX * scale) - parentX) / scale
            frameY = ((frameY * scale) - parentY) / scale

            -- Round to 1 decimal place
            frameX = floor(frameX * 10 + 0.5) / 10
            frameY = floor(frameY * 10 + 0.5) / 10

            settings.posX, settings.posY = frameX, frameY
            self[updateMethod](self, settings)
            LibStub("AceConfigRegistry-3.0"):NotifyChange("sArena")
        end
    end)
end

function sArenaMixin:SetMouseState(state)
    for i = 1, 5 do
        local frame = self["arena" .. i]
        frame.CastBar:EnableMouse(state)
        for i = 1, #self.drCategories do
            frame[self.drCategories[i]]:EnableMouse(state)
        end
        frame.SpecIcon:EnableMouse(state)
        frame.Trinket:EnableMouse(state)
        frame.Racial:EnableMouse(state)
    end
end

-- Arena Frames

local function ResetTexture(texturePool, t)
    if (texturePool) then
        t:SetParent(texturePool.parent)
    end

    t:SetTexture(nil)
    t:SetColorTexture(0, 0, 0, 0)
    t:SetVertexColor(1, 1, 1, 1)
    t:SetDesaturated()
    t:SetTexCoord(0, 1, 0, 1)
    t:ClearAllPoints()
    t:SetSize(0, 0)
    t:Hide()
end

function sArenaFrameMixin:OnLoad()
    local unit = "arena" .. self:GetID()
    self.parent = self:GetParent()

    RegisterUnitWatch(self, false)

    self:RegisterEvent("PLAYER_LOGIN")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("UNIT_NAME_UPDATE")
    self:RegisterEvent("ARENA_OPPONENT_UPDATE")
    self:RegisterUnitEvent("UNIT_HEALTH", unit)
    self:RegisterUnitEvent("UNIT_MAXHEALTH", unit)
    self:RegisterUnitEvent("UNIT_POWER_UPDATE", unit)
    self:RegisterUnitEvent("UNIT_MAXPOWER", unit)
    self:RegisterUnitEvent("UNIT_DISPLAYPOWER", unit)
    self:RegisterUnitEvent("UNIT_AURA", unit)

    self:RegisterForClicks("AnyUp")
    self:SetAttribute("*type1", "target")
    self:SetAttribute("*type2", "focus")
    self:SetAttribute("unit", unit)
    self.unit = unit

    CastingBarFrame_SetUnit(self.CastBar, unit, false, true)

    self.healthbar = self.HealthBar

    self.TexturePool = CreateTexturePool(self, "ARTWORK", nil, nil, ResetTexture)
end

function sArenaFrameMixin:OnEvent(event, eventUnit, arg1, arg2)
    local unit = self.unit

    if (eventUnit and eventUnit == unit) then
        if (event == "UNIT_NAME_UPDATE") then
            self.Name:SetText(GetUnitName(unit))
        elseif (event == "ARENA_OPPONENT_UPDATE") then
            self:UpdatePlayer(arg1)
        elseif (event == "UNIT_AURA") then
            self:FindAura()
        elseif (event == "UNIT_HEALTH") then
            self:SetLifeState()
            self:SetStatusText()
            local currentHealth = UnitHealth(unit)
            if (currentHealth ~= self.currentHealth) then
                self.HealthBar:SetValue(currentHealth)
                self.currentHealth = currentHealth
            end
        elseif (event == "UNIT_MAXHEALTH") then
            self.HealthBar:SetMinMaxValues(0, UnitHealthMax(unit))
            self.HealthBar:SetValue(UnitHealth(unit))
        elseif (event == "UNIT_POWER_UPDATE") then
            self:SetStatusText()
            self.PowerBar:SetValue(UnitPower(unit))
        elseif (event == "UNIT_MAXPOWER") then
            self.PowerBar:SetMinMaxValues(0, UnitPowerMax(unit))
            self.PowerBar:SetValue(UnitPower(unit))
        elseif (event == "UNIT_DISPLAYPOWER") then
            local _, powerType = UnitPowerType(unit)
            self:SetPowerType(powerType)
            self.PowerBar:SetMinMaxValues(0, UnitPowerMax(unit))
            self.PowerBar:SetValue(UnitPower(unit))
        end
    elseif (event == "PLAYER_LOGIN") then
        self:UnregisterEvent("PLAYER_LOGIN")

        if (not db) then
            self.parent:Initialize()
        end

        self:Initialize()
    elseif (event == "PLAYER_ENTERING_WORLD") then
        self.Name:SetText("")
        self.CastBar:Hide()
        self.specTexture = nil
        self.class = nil
        self.currentClassIconTexture = nil
        self.currentClassIconStartTime = 0
        self:UpdatePlayer()
        self:ResetTrinket()
        self:ResetRacial()
        self:ResetDR()
    elseif (event == "PLAYER_REGEN_ENABLED") then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
end

function sArenaFrameMixin:Initialize()
    self:SetMysteryPlayer()
    self.parent:SetupDrag(self, self.parent, nil, "UpdateFrameSettings")
    self.parent:SetupDrag(self.CastBar, self.CastBar, "castBar", "UpdateCastBarSettings")
    self.parent:SetupDrag(self[sArenaMixin.drCategories[1]], self[sArenaMixin.drCategories[1]], "dr", "UpdateDRSettings")
    self.parent:SetupDrag(self.SpecIcon, self.SpecIcon, "specIcon", "UpdateSpecIconSettings")
    self.parent:SetupDrag(self.Trinket, self.Trinket, "trinket", "UpdateTrinketSettings")
    self.parent:SetupDrag(self.Racial, self.Racial, "racial", "UpdateRacialSettings")
end

function sArenaFrameMixin:OnEnter()
    UnitFrame_OnEnter(self)

    self.HealthText:Show()
    self.PowerText:Show()
end

function sArenaFrameMixin:OnLeave()
    UnitFrame_OnLeave(self)

    self:UpdateStatusTextVisible()
end

function sArenaFrameMixin:UpdatePlayer(unitEvent)
    local unit = self.unit

    self:GetClass()
    self:FindAura()

    if ((unitEvent and unitEvent ~= "seen") or (UnitGUID(self.unit) == nil)) then
        self:SetMysteryPlayer()
        return
    end

    self:UpdateRacial()
    self:UpdateTrinket()

    -- Prevent castbar and other frames from intercepting mouse clicks during a match
    if (unitEvent == "seen") then
        self.parent:SetMouseState(false)
    end

    self.hideStatusText = false

    self.Name:SetText(GetUnitName(unit))
    self.Name:SetShown(db.profile.showNames)

    self:UpdateStatusTextVisible()
    self:SetStatusText()

    self:OnEvent("UNIT_MAXHEALTH", unit)
    self:OnEvent("UNIT_HEALTH", unit)
    self:OnEvent("UNIT_MAXPOWER", unit)
    self:OnEvent("UNIT_POWER_UPDATE", unit)
    self:OnEvent("UNIT_DISPLAYPOWER", unit)

    local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]

    if (color and db.profile.classColors) then
        self.HealthBar:SetStatusBarColor(color.r, color.g, color.b, 1.0)
    else
        self.HealthBar:SetStatusBarColor(0, 1.0, 0, 1.0)
    end
end

function sArenaFrameMixin:SetMysteryPlayer()
    local f = self.HealthBar
    f:SetMinMaxValues(0, 100)
    f:SetValue(100)
    f:SetStatusBarColor(0.5, 0.5, 0.5)

    f = self.PowerBar
    f:SetMinMaxValues(0, 100)
    f:SetValue(100)
    f:SetStatusBarColor(0.5, 0.5, 0.5)

    self.hideStatusText = true
    self:SetStatusText()

    self.DeathIcon:Hide()
end

function sArenaFrameMixin:GetClass()
    local _, instanceType = IsInInstance()

    if (instanceType ~= "arena") then
        self.specTexture = nil
        self.class = nil
    elseif (not self.class and UnitGUID(self.unit)) then
        _, self.class = UnitClass(self.unit)
        self.specTexture = 134400
        self:UpdateSpecIcon()
    end
end

local function ResetStatusBar(f)
    f:ClearAllPoints()
    f:SetSize(0, 0)
    f:SetScale(1)
end

local function ResetFontString(f)
    f:SetDrawLayer("OVERLAY", 1)
    f:SetJustifyH("CENTER")
    f:SetJustifyV("MIDDLE")
    f:SetTextColor(1, 0.82, 0, 1)
    f:SetShadowColor(0, 0, 0, 1)
    f:SetShadowOffset(1, -1)
    f:ClearAllPoints()
    f:Hide()
end

function sArenaFrameMixin:ResetLayout()
    self.currentClassIconTexture = nil
    self.currentClassIconStartTime = 0

    ResetTexture(nil, self.ClassIcon)
    ResetStatusBar(self.HealthBar)
    ResetStatusBar(self.PowerBar)
    ResetStatusBar(self.CastBar)
    self.CastBar:SetHeight(16)

    local f = self.Trinket
    f:ClearAllPoints()
    f:SetSize(0, 0)
    f.Texture:SetTexCoord(0, 1, 0, 1)

    f = self.Racial
    f:ClearAllPoints()
    f:SetSize(0, 0)
    f.Texture:SetTexCoord(0, 1, 0, 1)

    f = self.SpecIcon
    f:ClearAllPoints()
    f:SetSize(0, 0)
    f:SetScale(1)
    f.Texture:RemoveMaskTexture(f.Mask)
    f.Texture:SetTexCoord(0, 1, 0, 1)

    f = self.Name
    ResetFontString(f)
    f:SetDrawLayer("ARTWORK", 2)
    f:SetFontObject("SystemFont_Shadow_Small2")

    f = self.HealthText
    ResetFontString(f)
    f:SetDrawLayer("ARTWORK", 2)
    f:SetFontObject("Game10Font_o1")
    f:SetTextColor(1, 1, 1, 1)

    f = self.PowerText
    ResetFontString(f)
    f:SetDrawLayer("ARTWORK", 2)
    f:SetFontObject("Game10Font_o1")
    f:SetTextColor(1, 1, 1, 1)

    f = self.CastBar
    f.Icon:SetTexCoord(0, 1, 0, 1)

    self.TexturePool:ReleaseAll()
end

function sArenaFrameMixin:SetPowerType(powerType)
    local color = PowerBarColor[powerType]
    if color then
        self.PowerBar:SetStatusBarColor(color.r, color.g, color.b)
    end
end

function sArenaFrameMixin:SetLifeState()
    local unit = self.unit
    local isDead = UnitIsDeadOrGhost(unit) and not AuraUtil.FindAuraByName(GetSpellInfo(5384), unit, "HELPFUL")

    self.DeathIcon:SetShown(isDead)
    self.hideStatusText = isDead
    if (isDead) then
        self:ResetDR()
    end
end

function sArenaFrameMixin:SetStatusText(unit)
    if (self.hideStatusText) then
        self.HealthText:SetFontObject("Game10Font_o1")
        self.HealthText:SetText("")
        self.PowerText:SetFontObject("Game10Font_o1")
        self.PowerText:SetText("")
        return
    end

    if (not unit) then
        unit = self.unit
    end

    local hp = UnitHealth(unit)
    local hpMax = UnitHealthMax(unit)
    local pp = UnitPower(unit)
    local ppMax = UnitPowerMax(unit)

    if (db.profile.statusText.usePercentage) then
        self.HealthText:SetText(ceil((hp / hpMax) * 100) .. "%")
        self.PowerText:SetText(ceil((pp / ppMax) * 100) .. "%")
    else
        self.HealthText:SetText(AbbreviateLargeNumbers(hp))
        self.PowerText:SetText(AbbreviateLargeNumbers(pp))
    end
end

function sArenaFrameMixin:UpdateStatusTextVisible()
    self.HealthText:SetShown(db.profile.statusText.alwaysShow)
    self.PowerText:SetShown(db.profile.statusText.alwaysShow)
end

function sArenaMixin:Test()
    local _, instanceType = IsInInstance()
    if (InCombatLockdown() or instanceType == "arena") then return end

    local currTime = GetTime()

    for i = 1, 5 do
        if (i == 1) then
            local frame = self["arena" .. i]
            UnregisterUnitWatch(frame, false)
            frame:Show()
            frame:SetAlpha(1)

            frame.HealthBar:SetMinMaxValues(0, 100)
            frame.HealthBar:SetValue(100)

            frame.PowerBar:SetMinMaxValues(0, 100)
            frame.PowerBar:SetValue(100)

            frame.ClassIcon:SetTexture(self.iconPath, true);
            frame.ClassIcon:SetTexCoord(unpack(self.classIcons["HUNTER"]));

            frame.SpecIcon:Show()
            frame.SpecIcon.Texture:SetTexture(132222)

            frame.ClassIconCooldown:SetCooldown(GetTime(), math.random(20, 60))
            frame.Name:SetText("arena" .. i)
            frame.Name:SetShown(db.profile.showNames)

            frame.Trinket.Texture:SetTexture(133453)
            frame.Trinket.Cooldown:SetCooldown(currTime, math.random(20, 60))

            frame.Racial.Texture:SetTexture(136225)
            frame.Racial.Cooldown:SetCooldown(currTime, math.random(20, 60))

            local color = RAID_CLASS_COLORS["HUNTER"]
            if (db.profile.classColors) then
                frame.HealthBar:SetStatusBarColor(color.r, color.g, color.b, 1)
            else
                frame.HealthBar:SetStatusBarColor(0, 1, 0, 1)
            end
            frame.PowerBar:SetStatusBarColor(0, 0, 1, 1)

            for n = 1, 5 do
                local drFrame = frame[self.drCategories[n]]

                drFrame.Icon:SetTexture(136071)
                drFrame:Show()
                drFrame.Cooldown:SetCooldown(currTime, n == 1 and 60 or math.random(20, 50))

                if (n == 1) then
                    drFrame.Border:SetVertexColor(1, 0, 0, 1)
                else
                    drFrame.Border:SetVertexColor(0, 1, 0, 1)
                end
            end

            frame.CastBar.fadeOut = nil
            frame.CastBar:Show()
            frame.CastBar:SetAlpha(1)
            frame.CastBar.Icon:SetTexture(135130)
            frame.CastBar.Text:SetText("Aimed Shot")
            frame.CastBar:SetStatusBarColor(1, 0.7, 0, 1)

            frame.hideStatusText = false
            frame:SetStatusText("player")
            frame:UpdateStatusTextVisible()
        elseif (i == 2) then
            local frame = self["arena" .. i]
            UnregisterUnitWatch(frame, false)
            frame:Show()
            frame:SetAlpha(1)

            frame.HealthBar:SetMinMaxValues(0, 100)
            frame.HealthBar:SetValue(100)

            frame.PowerBar:SetMinMaxValues(0, 100)
            frame.PowerBar:SetValue(100)

            frame.ClassIcon:SetTexture(self.iconPath, true);
            frame.ClassIcon:SetTexCoord(unpack(self.classIcons["SHAMAN"]));

            frame.SpecIcon:Show()
            frame.SpecIcon.Texture:SetTexture(136048)

            frame.ClassIconCooldown:SetCooldown(GetTime(), math.random(20, 60))
            frame.Name:SetText("arena" .. i)
            frame.Name:SetShown(db.profile.showNames)

            frame.Trinket.Texture:SetTexture(133453)
            frame.Trinket.Cooldown:SetCooldown(currTime, math.random(20, 60))

            frame.Racial.Texture:SetTexture(135923)
            frame.Racial.Cooldown:SetCooldown(currTime, math.random(20, 60))

            local color = RAID_CLASS_COLORS["SHAMAN"]
            if (db.profile.classColors) then
                frame.HealthBar:SetStatusBarColor(color.r, color.g, color.b, 1)
            else
                frame.HealthBar:SetStatusBarColor(0, 1, 0, 1)
            end
            frame.PowerBar:SetStatusBarColor(0, 0, 1, 1)

            for n = 1, 5 do
                local drFrame = frame[self.drCategories[n]]

                drFrame.Icon:SetTexture(136175)
                drFrame:Show()
                drFrame.Cooldown:SetCooldown(currTime, n == 1 and 60 or math.random(20, 50))

                if (n == 1) then
                    drFrame.Border:SetVertexColor(1, 0, 0, 1)
                else
                    drFrame.Border:SetVertexColor(0, 1, 0, 1)
                end
            end

            frame.CastBar.fadeOut = nil
            frame.CastBar:Show()
            frame.CastBar:SetAlpha(1)
            frame.CastBar.Icon:SetTexture(136015)
            frame.CastBar.Text:SetText("Chain Lightning")
            frame.CastBar:SetStatusBarColor(1, 0.7, 0, 1)

            frame.hideStatusText = false
            frame:SetStatusText("player")
            frame:UpdateStatusTextVisible()
        elseif (i == 3) then
            local frame = self["arena" .. i]
            UnregisterUnitWatch(frame, false)
            frame:Show()
            frame:SetAlpha(1)

            frame.HealthBar:SetMinMaxValues(0, 100)
            frame.HealthBar:SetValue(100)

            frame.PowerBar:SetMinMaxValues(0, 100)
            frame.PowerBar:SetValue(100)

            frame.ClassIcon:SetTexture(self.iconPath, true);
            frame.ClassIcon:SetTexCoord(unpack(self.classIcons["DRUID"]));

            frame.SpecIcon:Show()
            frame.SpecIcon.Texture:SetTexture(136041)

            frame.ClassIconCooldown:SetCooldown(GetTime(), math.random(20, 60))
            frame.Name:SetText("arena" .. i)
            frame.Name:SetShown(db.profile.showNames)

            frame.Trinket.Texture:SetTexture(133453)
            frame.Trinket.Cooldown:SetCooldown(currTime, math.random(20, 60))

            frame.Racial.Texture:SetTexture(132089)
            frame.Racial.Cooldown:SetCooldown(currTime, math.random(20, 60))

            local color = RAID_CLASS_COLORS["DRUID"]
            if (db.profile.classColors) then
                frame.HealthBar:SetStatusBarColor(color.r, color.g, color.b, 1)
            else
                frame.HealthBar:SetStatusBarColor(0, 1, 0, 1)
            end
            frame.PowerBar:SetStatusBarColor(0, 0, 1, 1)

            for n = 1, 5 do
                local drFrame = frame[self.drCategories[n]]

                drFrame.Icon:SetTexture(132298)
                drFrame:Show()
                drFrame.Cooldown:SetCooldown(currTime, n == 1 and 60 or math.random(20, 50))

                if (n == 1) then
                    drFrame.Border:SetVertexColor(1, 0, 0, 1)
                else
                    drFrame.Border:SetVertexColor(0, 1, 0, 1)
                end
            end

            frame.CastBar.fadeOut = nil
            frame.CastBar:Show()
            frame.CastBar:SetAlpha(1)
            frame.CastBar.Icon:SetTexture(136085)
            frame.CastBar.Text:SetText("Regrowth")
            frame.CastBar:SetStatusBarColor(1, 0.7, 0, 1)

            frame.hideStatusText = false
            frame:SetStatusText("player")
            frame:UpdateStatusTextVisible()
        elseif (i == 4) then
            local frame = self["arena" .. i]
            UnregisterUnitWatch(frame, false)
            frame:Show()
            frame:SetAlpha(1)

            frame.HealthBar:SetMinMaxValues(0, 100)
            frame.HealthBar:SetValue(100)

            frame.PowerBar:SetMinMaxValues(0, 100)
            frame.PowerBar:SetValue(100)

            frame.ClassIcon:SetTexture(self.iconPath, true);
            frame.ClassIcon:SetTexCoord(unpack(self.classIcons["WARLOCK"]));

            frame.SpecIcon:Show()
            frame.SpecIcon.Texture:SetTexture(136145)

            frame.ClassIconCooldown:SetCooldown(GetTime(), math.random(20, 60))
            frame.Name:SetText("arena" .. i)
            frame.Name:SetShown(db.profile.showNames)

            frame.Trinket.Texture:SetTexture(133453)
            frame.Trinket.Cooldown:SetCooldown(currTime, math.random(20, 60))

            frame.Racial.Texture:SetTexture(136090)
            frame.Racial.Cooldown:SetCooldown(currTime, math.random(20, 60))

            local color = RAID_CLASS_COLORS["WARLOCK"]
            if (db.profile.classColors) then
                frame.HealthBar:SetStatusBarColor(color.r, color.g, color.b, 1)
            else
                frame.HealthBar:SetStatusBarColor(0, 1, 0, 1)
            end
            frame.PowerBar:SetStatusBarColor(0, 0, 1, 1)

            for n = 1, 5 do
                local drFrame = frame[self.drCategories[n]]

                drFrame.Icon:SetTexture(132298)
                drFrame:Show()
                drFrame.Cooldown:SetCooldown(currTime, n == 1 and 60 or math.random(20, 50))

                if (n == 1) then
                    drFrame.Border:SetVertexColor(1, 0, 0, 1)
                else
                    drFrame.Border:SetVertexColor(0, 1, 0, 1)
                end
            end

            frame.CastBar.fadeOut = nil
            frame.CastBar:Show()
            frame.CastBar:SetAlpha(1)
            frame.CastBar.Icon:SetTexture(136147)
            frame.CastBar.Text:SetText("Howl of Terror")
            frame.CastBar:SetStatusBarColor(1, 0.7, 0, 1)

            frame.hideStatusText = false
            frame:SetStatusText("player")
            frame:UpdateStatusTextVisible()
        else
            local frame = self["arena" .. i]
            UnregisterUnitWatch(frame, false)
            frame:Show()
            frame:SetAlpha(1)

            frame.HealthBar:SetMinMaxValues(0, 100)
            frame.HealthBar:SetValue(100)

            frame.PowerBar:SetMinMaxValues(0, 100)
            frame.PowerBar:SetValue(100)

            frame.ClassIcon:SetTexture(self.iconPath, true);
            frame.ClassIcon:SetTexCoord(unpack(self.classIcons["WARRIOR"]));

            frame.SpecIcon:Show()
            frame.SpecIcon.Texture:SetTexture(132355)

            frame.ClassIconCooldown:SetCooldown(GetTime(), math.random(20, 60))
            frame.Name:SetText("arena" .. i)
            frame.Name:SetShown(db.profile.showNames)

            frame.Trinket.Texture:SetTexture(133453)
            frame.Trinket.Cooldown:SetCooldown(currTime, math.random(20, 60))

            frame.Racial.Texture:SetTexture(132309)
            frame.Racial.Cooldown:SetCooldown(currTime, math.random(20, 60))

            local color = RAID_CLASS_COLORS["WARRIOR"]
            if (db.profile.classColors) then
                frame.HealthBar:SetStatusBarColor(color.r, color.g, color.b, 1)
            else
                frame.HealthBar:SetStatusBarColor(0, 1, 0, 1)
            end
            frame.PowerBar:SetStatusBarColor(170 / 255, 10 / 255, 10 / 255)

            for n = 1, 5 do
                local drFrame = frame[self.drCategories[n]]

                drFrame.Icon:SetTexture(132298)
                drFrame:Show()
                drFrame.Cooldown:SetCooldown(currTime, n == 1 and 60 or math.random(20, 50))

                if (n == 1) then
                    drFrame.Border:SetVertexColor(1, 0, 0, 1)
                else
                    drFrame.Border:SetVertexColor(0, 1, 0, 1)
                end
            end

            frame.CastBar.fadeOut = nil
            frame.CastBar:Show()
            frame.CastBar:SetAlpha(1)
            frame.CastBar.Icon:SetTexture(132340)
            frame.CastBar.Text:SetText("Slam")
            frame.CastBar:SetStatusBarColor(1, 0.7, 0, 1)

            frame.hideStatusText = false
            frame:SetStatusText("player")
            frame:UpdateStatusTextVisible()
        end
    end
end
