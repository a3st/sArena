function sArenaFrameMixin:FindTrinket(event, spellID)
    if (event ~= "SPELL_CAST_SUCCESS") then return end

    local trinket = self.Trinket

    if (spellID == 42292 or spellID == 59752) then
        trinket.Cooldown:SetCooldown(GetTime(), 120);
    end
end

function sArenaFrameMixin:UpdateTrinket()
    local unit = self.unit
    local fraction, _ = UnitFactionGroup(unit)

    if (fraction == "Alliance") then
        self.Trinket.Texture:SetTexture(133452)
    else
        self.Trinket.Texture:SetTexture(133453)
    end
end

function sArenaFrameMixin:ResetTrinket()
    self.Trinket.Texture:SetTexture(nil)
    self.Trinket.Cooldown:Clear()
end
