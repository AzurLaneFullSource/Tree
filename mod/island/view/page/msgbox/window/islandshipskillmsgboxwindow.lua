local var0_0 = class("IslandShipSkillMsgboxWindow", import(".IslandBaseMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForShipSkill"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("close")
	arg0_2.nameTxt = arg0_2:findTF("name"):GetComponent(typeof(Text))
	arg0_2.levelTxt = arg0_2:findTF("level"):GetComponent(typeof(Text))
	arg0_2.descTxt = arg0_2:findTF("content/Text"):GetComponent(typeof(Text))
	arg0_2.iconTr = arg0_2:findTF("icon")

	setText(arg0_2._tf:Find("title"), i18n("island_skill_desc"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5)
	local var0_5 = arg0_5.settings.skill

	assert(var0_5)

	arg0_5.nameTxt.text = var0_5:GetName()
	arg0_5.descTxt.text = var0_5:GetEffectDesc()
	arg0_5.levelTxt.text = "[Lv." .. var0_5:GetLevel() .. "]"

	GetImageSpriteFromAtlasAsync("island/IslandSkillIcon/" .. var0_5:GetIcon(), "", arg0_5.iconTr)
end

function var0_0.OnHide(arg0_6)
	return
end

return var0_0
