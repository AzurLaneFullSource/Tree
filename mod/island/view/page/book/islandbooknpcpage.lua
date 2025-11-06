local var0_0 = class("IslandBookNpcPage", import(".IslandBookItemPage"))

function var0_0.getUIName(arg0_1)
	return "IslandBookNpcUI"
end

function var0_0.GetIllustrationType(arg0_2)
	return IslandIllustration.TYPES.NPC
end

function var0_0.GetHelpTip(arg0_3)
	return i18n("island_guide_help_npc")
end

function var0_0.OnLoaded(arg0_4)
	var0_0.super.OnLoaded(arg0_4)

	arg0_4.postNameTF = arg0_4.rightTF:Find("post/Text")
end

function var0_0.FlushRightPanel(arg0_5)
	var0_0.super.FlushRightPanel(arg0_5)

	if not arg0_5.showIllustration then
		return
	end

	local var0_5 = arg0_5.showIllustration:getLinkConfig("group")
	local var1_5 = pg.island_npc_hud[var0_5].title

	setText(arg0_5.postNameTF, var1_5)
end

return var0_0
