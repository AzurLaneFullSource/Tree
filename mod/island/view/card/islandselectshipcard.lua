local var0_0 = class("IslandSelectShipCard")

var0_0.SHOW_TYPE = {
	PLACE = 1,
	RESTAURANT = 2
}
var0_0.SKILL_COLOR = {
	Color.NewHex("3DFF00"),
	Color.NewHex("808080")
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.selectedTF = arg0_1.tf:Find("selected")
	arg0_1.iconTF = arg0_1.tf:Find("icon")
	arg0_1.triedMaskTF = arg0_1.tf:Find("mask/tried")

	setText(arg0_1.triedMaskTF:Find("Text"), i18n("island_ship_no_energy"))

	arg0_1.workingMaskTF = arg0_1.tf:Find("mask/working")
	arg0_1.workingTextCom = arg0_1.workingMaskTF:Find("Text"):GetComponent("Text")
	arg0_1.followMaskTF = arg0_1.tf:Find("mask/follow")
	arg0_1.iconsTF = arg0_1.tf:Find("icons")
	arg0_1.skillTF = arg0_1.iconsTF:Find("skill/tpl")
	arg0_1.gradeTF = arg0_1.iconsTF:Find("grade")
	arg0_1.energySliderTF = arg0_1.tf:Find("energy_bar")
	arg0_1.energyTF = arg0_1.tf:Find("energy_bar/Text")
	arg0_1.nameTF = arg0_1.tf:Find("name")
	arg0_1.levelTF = arg0_1.tf:Find("level")
	arg0_1.attrTfList = {
		arg0_1.gradeTF:Find("SSS"),
		arg0_1.gradeTF:Find("SS"),
		arg0_1.gradeTF:Find("S"),
		arg0_1.gradeTF:Find("A"),
		arg0_1.gradeTF:Find("B"),
		arg0_1.gradeTF:Find("C"),
		arg0_1.gradeTF:Find("D"),
		arg0_1.gradeTF:Find("E")
	}
	arg0_1.skillInuse = arg0_1.iconsTF:Find("skill/skill_bright")
	arg0_1.skillUnuse = arg0_1.iconsTF:Find("skill/skill_dark")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, arg6_2)
	arg0_2.type = arg1_2
	arg0_2.ship = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg2_2)
	arg0_2.id = arg2_2
	arg0_2.attrType = arg3_2
	arg0_2.buildingId = arg4_2

	arg0_2:UpdateSelected(arg5_2)

	local var0_2 = IslandShip.StaticGetPrefab(arg0_2.id)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var0_2, "", arg0_2.iconTF)

	local var1_2 = arg0_2.ship:GetAttr(IslandShipAttr.ATTRS[arg0_2.attrType])
	local var2_2 = IslandProductTimeHelper.GetAttributeAddPercentByAttribute(arg2_2, arg0_2.attrType)

	var1_2 = var2_2 ~= 0 and math.floor(var1_2 * (1 + 0.01 * var2_2)) or var1_2

	local var3_2 = arg0_2.ship:GetAttrGradeByValue(var1_2)

	for iter0_2, iter1_2 in ipairs(arg0_2.attrTfList) do
		if iter1_2 ~= "" then
			local var4_2 = var3_2 == iter0_2

			setActive(iter1_2, var4_2)
		end
	end

	local var5_2 = arg0_2.ship:GetName()

	setText(arg0_2.nameTF, shortenString(arg0_2.ship:GetName(), 5))

	local var6_2 = arg0_2.ship:GetCurrentEnergy()
	local var7_2 = arg0_2.ship:GetMaxEnergy()

	setSlider(arg0_2.energySliderTF, 0, 1, var6_2 / var7_2)
	setText(arg0_2.energyTF, var6_2 .. "/" .. var7_2)
	arg0_2:UpdateFollowMask()

	if arg6_2 then
		local var8_2 = false

		for iter2_2, iter3_2 in pairs(arg6_2) do
			if arg0_2.id == iter3_2 then
				var8_2 = true
			end
		end

		if var8_2 then
			setActive(arg0_2.workingMaskTF, true)
		end
	end

	arg0_2:UpdateSkillEffective(arg0_2.type, arg0_2.buildingId)
end

function var0_0.UpdateFollowMask(arg0_3)
	local var0_3 = getProxy(IslandProxy):GetIsland():GetFollowerAgency():Following(arg0_3.ship.id)

	setActive(arg0_3.followMaskTF, var0_3)
	setActive(arg0_3.workingMaskTF, not var0_3 and not arg0_3.ship:IsDelegable())
end

function var0_0.UpdateSelected(arg0_4, arg1_4)
	arg0_4.selectedIds = arg1_4

	setActive(arg0_4.selectedTF, table.contains(arg0_4.selectedIds, arg0_4.id))
end

function var0_0.UpdateSkillEffective(arg0_5, arg1_5, arg2_5)
	local var0_5 = var0_0.GetSkillEffective(arg0_5.ship, arg1_5, arg2_5)

	setActive(arg0_5.skillInuse, var0_5)
	setActive(arg0_5.skillUnuse, not var0_5)
end

function var0_0.GetSkillEffective(arg0_6, arg1_6, arg2_6)
	if not arg1_6 or not arg2_6 then
		return false
	end

	local var0_6 = arg0_6:GetSkill()

	if var0_6:IsAllEffectiveType() then
		return true
	end

	if arg1_6 == var0_0.SHOW_TYPE.PLACE and var0_6:IsPlaceDefaultEffectiveType() then
		return true
	end

	if arg1_6 == var0_0.SHOW_TYPE.PLACE then
		return var0_6:IsEffectiveInPlace(arg2_6)
	elseif arg1_6 == var0_0.SHOW_TYPE.RESTAURANT then
		return var0_6:IsEffectiveInRest(arg2_6)
	end

	return false
end

function var0_0.Dispose(arg0_7)
	return
end

return var0_0
