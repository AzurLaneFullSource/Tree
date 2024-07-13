local var0_0 = class("SecondSummaryPage5", import(".SummaryAnimationPage"))

function var0_0.OnInit(arg0_1)
	setText(arg0_1._tf:Find("window_share_1/name"), arg0_1.summaryInfoVO.name)
	setText(arg0_1._tf:Find("window_share_1/time/Text"), "「" .. arg0_1.summaryInfoVO.registerTime .. "」")
	setText(arg0_1._tf:Find("window_share_1/day/Text"), arg0_1.summaryInfoVO.days)

	local var0_1 = arg0_1.summaryInfoVO:hasGuild()

	setActive(arg0_1._tf:Find("window_share_2/has_guild"), var0_1)
	setActive(arg0_1._tf:Find("window_share_2/without"), not var0_1)

	local var1_1 = var0_1 and arg0_1._tf:Find("window_share_2/has_guild") or arg0_1._tf:Find("window_share_2/without")

	if var0_1 then
		setText(var1_1:Find("guild_name/Text"), "「" .. arg0_1.summaryInfoVO.guildName .. "」")
	end

	setText(var1_1:Find("chapter_name/Text"), "「" .. arg0_1.summaryInfoVO.chapterName .. "」")
	setText(var1_1:Find("number/Text"), arg0_1.summaryInfoVO.proposeCount)
	setText(arg0_1._tf:Find("window_share_3/number/Text"), arg0_1.summaryInfoVO.medalCount)
	setText(arg0_1._tf:Find("window_share_3/count/Text"), arg0_1.summaryInfoVO.furnitureCount)
	setText(arg0_1._tf:Find("window_share_3/coin/Text"), arg0_1.summaryInfoVO.furnitureWorth)
	setText(arg0_1._tf:Find("window_share_3/collection/Text"), arg0_1.summaryInfoVO.collectionNum)
	setText(arg0_1._tf:Find("window_share_3/skin/Text"), arg0_1.summaryInfoVO.skinNum)
end

return var0_0
