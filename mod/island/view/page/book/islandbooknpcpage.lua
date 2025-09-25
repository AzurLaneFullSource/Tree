local var0_0 = class("IslandBookNpcPage", import(".IslandBookItemPage"))

function var0_0.getUIName(arg0_1)
	return "IslandBookNpcUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.postNameTF = arg0_2.rightTF:Find("post/Text")
end

function var0_0.GetIllustrationType(arg0_3)
	return IslandIllustration.TYPES.NPC
end

function var0_0.FlushRightPanel(arg0_4)
	var0_0.super.FlushRightPanel(arg0_4)

	if not arg0_4.showIllustration then
		return
	end

	local var0_4 = arg0_4.showIllustration:getLinkConfig("group")
	local var1_4 = pg.island_npc_hud[var0_4].title

	setText(arg0_4.postNameTF, var1_4)
end

return var0_0
