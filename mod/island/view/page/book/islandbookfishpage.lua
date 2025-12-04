local var0_0 = class("IslandBookFishPage", import(".IslandBookItemPage"))

function var0_0.getUIName(arg0_1)
	return "IslandBookFishUI"
end

function var0_0.GetIllustrationType(arg0_2)
	return IslandIllustration.TYPES.FISH
end

function var0_0.GetHelpTip(arg0_3)
	return i18n("island_guide_help_fish")
end

function var0_0.OnLoaded(arg0_4)
	var0_0.super.OnLoaded(arg0_4)

	arg0_4.weightTF = arg0_4.rightTF:Find("weight")
	arg0_4.minWeightTF = arg0_4.weightTF:Find("min")

	setText(arg0_4.minWeightTF:Find("Text"), i18n("island_guide_fish_min_weight"))

	arg0_4.maxWeightTF = arg0_4.weightTF:Find("max")

	setText(arg0_4.maxWeightTF:Find("Text"), i18n("island_guide_fish_max_weight"))
end

function var0_0.FlushRightPanel(arg0_5)
	var0_0.super.FlushRightPanel(arg0_5)

	if not arg0_5.showIllustration then
		return
	end

	local var0_5 = arg0_5.showIllustration:GetStatus() == IslandIllustration.STATUS.UNLOCK

	setActive(arg0_5.weightTF, var0_5)

	if not var0_5 then
		return
	end

	local var1_5 = arg0_5.showIllustration:GetLinkConfigID()
	local var2_5 = getProxy(IslandProxy):GetIsland():GetFishingAgency():GetFish(var1_5)

	setText(arg0_5.minWeightTF:Find("value"), var2_5:GetMinWeight() / 1000 .. "KG")
	setText(arg0_5.maxWeightTF:Find("value"), var2_5:GetMaxWeight() / 1000 .. "KG")
	setActive(arg0_5.minWeightTF:Find("Image"), var2_5:ReachMinCup())
	setActive(arg0_5.maxWeightTF:Find("Image"), var2_5:ReachMaxCup())
end

return var0_0
