local var0 = class("SecondSummaryPage5", import(".SummaryAnimationPage"))

function var0.OnInit(arg0)
	setText(arg0._tf:Find("window_share_1/name"), arg0.summaryInfoVO.name)
	setText(arg0._tf:Find("window_share_1/time/Text"), "「" .. arg0.summaryInfoVO.registerTime .. "」")
	setText(arg0._tf:Find("window_share_1/day/Text"), arg0.summaryInfoVO.days)

	local var0 = arg0.summaryInfoVO:hasGuild()

	setActive(arg0._tf:Find("window_share_2/has_guild"), var0)
	setActive(arg0._tf:Find("window_share_2/without"), not var0)

	local var1 = var0 and arg0._tf:Find("window_share_2/has_guild") or arg0._tf:Find("window_share_2/without")

	if var0 then
		setText(var1:Find("guild_name/Text"), "「" .. arg0.summaryInfoVO.guildName .. "」")
	end

	setText(var1:Find("chapter_name/Text"), "「" .. arg0.summaryInfoVO.chapterName .. "」")
	setText(var1:Find("number/Text"), arg0.summaryInfoVO.proposeCount)
	setText(arg0._tf:Find("window_share_3/number/Text"), arg0.summaryInfoVO.medalCount)
	setText(arg0._tf:Find("window_share_3/count/Text"), arg0.summaryInfoVO.furnitureCount)
	setText(arg0._tf:Find("window_share_3/coin/Text"), arg0.summaryInfoVO.furnitureWorth)
	setText(arg0._tf:Find("window_share_3/collection/Text"), arg0.summaryInfoVO.collectionNum)
	setText(arg0._tf:Find("window_share_3/skin/Text"), arg0.summaryInfoVO.skinNum)
end

return var0
