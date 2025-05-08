local var0_0 = class("IslandSelectShipCard")

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

	setText(arg0_1.triedMaskTF:Find("Text"), i18n1("疲惫"))

	arg0_1.workingMaskTF = arg0_1.tf:Find("mask/working")

	setText(arg0_1.workingMaskTF:Find("Text"), i18n1("工作中"))

	arg0_1.iconsTF = arg0_1.tf:Find("icons")
	arg0_1.skillTF = arg0_1.iconsTF:Find("skill/tpl")
	arg0_1.gradeTF = arg0_1.iconsTF:Find("grade/Text")
	arg0_1.energySliderTF = arg0_1.tf:Find("energy_bar")
	arg0_1.energyTF = arg0_1.tf:Find("energy_bar/Text")
	arg0_1.nameTF = arg0_1.tf:Find("name")
	arg0_1.levelTF = arg0_1.tf:Find("level")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.ship = arg1_2
	arg0_2.id = arg0_2.ship.id
	arg0_2.attrType = arg2_2
	arg0_2.buildingId = arg3_2

	arg0_2:UpdateSelected(arg4_2)

	local var0_2 = IslandShip.StaticGetPrefab(arg0_2.id)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var0_2, "", arg0_2.iconTF)
	setImageColor(arg0_2.skillTF, arg1_2:IsMainSkillEffective(arg0_2.buildingId) and var0_0.SKILL_COLOR[1] or var0_0.SKILL_COLOR[2])
	setText(arg0_2.skillTF:Find("Text"), arg1_2:GetMainSkill())
	setText(arg0_2.gradeTF, arg1_2:GetAttr(IslandShipAttr.ATTRS[arg0_2.attrType]))

	local var1_2 = arg0_2.ship:GetName()

	setText(arg0_2.nameTF, arg0_2.ship:GetName())
	setText(arg0_2.levelTF, arg0_2.ship:GetLevel())

	local var2_2 = arg0_2.ship:GetEnergy()
	local var3_2 = arg0_2.ship:GetMaxEnergy()

	setSlider(arg0_2.energySliderTF, 0, 1, var2_2 / var3_2)
	setText(arg0_2.energyTF, var2_2 .. "/" .. var3_2)
	setActive(arg0_2.triedMaskTF, var2_2 == 0)
	setActive(arg0_2.workingMaskTF, arg1_2:GetState() == IslandShip.STATE_WORKING)
end

function var0_0.UpdateSelected(arg0_3, arg1_3)
	arg0_3.selectedId = arg1_3

	setActive(arg0_3.selectedTF, arg0_3.id == arg0_3.selectedId)
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
