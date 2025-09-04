local var0_0 = class("IslandAwardDisplay4ShipSkillWindow", import(".IslandAwardDisplayWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplayForShipSkillUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.nameTxt = arg0_2:findTF("frame/bg/item/name"):GetComponent(typeof(Text))
	arg0_2.levelTxt = arg0_2:findTF("frame/bg/item/level"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("frame/bg/item/desc"):GetComponent(typeof(Text))
	arg0_2.iconTr = arg0_2:findTF("frame/bg/item/icon")
	arg0_2.uiNewStart = UIItemList.New(arg0_2:findTF("frame/bg/starts"), arg0_2:findTF("frame/bg/starts/tpl"))
end

function var0_0.Show(arg0_3, arg1_3)
	arg1_3.awards = {}

	var0_0.super.Show(arg0_3, arg1_3)

	arg0_3.title.text = i18n("island_unlock_skill")

	local var0_3 = arg1_3.skill

	arg0_3.nameTxt.text = var0_3:GetName()
	arg0_3.levelTxt.text = "[Lv." .. var0_3:GetLevel() .. "]"
	arg0_3.descTxt.text = var0_3:GetEffectDesc()

	GetImageSpriteFromAtlasAsync("island/IslandSkillIcon/" .. var0_3:GetIcon(), "", arg0_3.iconTr)
	arg0_3:UpdateBreakLevel(arg1_3.ship)
end

function var0_0.UpdateBreakLevel(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetBreakMaxLevel()

	arg0_4.uiNewStart:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			setActive(arg2_5:Find("Image"), arg1_5 < arg1_4:GetBreakLevel())
		end
	end)
	arg0_4.uiNewStart:align(var0_4)
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
