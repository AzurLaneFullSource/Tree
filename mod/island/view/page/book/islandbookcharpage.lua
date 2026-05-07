local var0_0 = class("IslandBookCharPage", import(".IslandBookItemPage"))

function var0_0.getUIName(arg0_1)
	return "IslandBookCharUI"
end

function var0_0.GetIllustrationType(arg0_2)
	return IslandIllustration.TYPES.CHAR
end

function var0_0.GetHelpTip(arg0_3)
	return i18n("island_guide_help")
end

function var0_0.OnLoaded(arg0_4)
	var0_0.super.OnLoaded(arg0_4)

	arg0_4.starList = UIItemList.New(arg0_4.rightTF:Find("stars"), arg0_4.rightTF:Find("stars/tpl"))
end

function var0_0.FlushRightPanel(arg0_5)
	var0_0.super.FlushRightPanel(arg0_5)

	if not arg0_5.showIllustration then
		return
	end

	local var0_5 = arg0_5.showIllustration:GetStatus() == IslandIllustration.STATUS.UNLOCK
	local var1_5 = arg0_5.showIllustration:GetLinkConfigID()
	local var2_5 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var1_5)

	setText(arg0_5.rightTF:Find("level"), var0_5 and "Lv." .. var2_5:GetLevel() or "")
	setScrollTextWithSize(arg0_5.rightNameTF, arg0_5.rightTF:Find("scroll_name/Text"), arg0_5.showIllustration:GetName(), 11)

	local var3_5 = var2_5 and var2_5:GetBreakLevel() or 0

	arg0_5.starList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg1_6 + 1

			setActive(arg2_6:Find("Image"), var0_6 <= var3_5)
		end
	end)
	arg0_5.starList:align(arg0_5:GetShipBreakMaxLevel(var1_5))
end

function var0_0.GetShipBreakMaxLevel(arg0_7, arg1_7)
	return pg.island_chara_template[arg1_7].upgrade_level[2] + 1
end

return var0_0
