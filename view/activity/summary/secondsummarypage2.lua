local var0 = class("SecondSummaryPage2", import(".SummaryAnimationPage"))

function var0.OnInit(arg0)
	local var0 = Ship.New({
		configId = arg0.summaryInfoVO.flagShipId
	}):getPainting()

	setPaintingPrefabAsync(arg0._tf:Find("paint_panel/painting"), var0, "chuanwu")
	setText(arg0._tf:Find("window_1/name"), arg0.summaryInfoVO.name)
	setText(arg0._tf:Find("window_1/time/Text"), "「" .. arg0.summaryInfoVO.registerTime .. "」")
	setText(arg0._tf:Find("window_1/server/Text"), "「" .. arg0.summaryInfoVO.serverName .. "」")
	setText(arg0._tf:Find("window_1/day/Text"), arg0.summaryInfoVO.days)

	local var1 = arg0.summaryInfoVO:hasGuild()

	setActive(arg0._tf:Find("window_2/has_guild"), var1)
	setActive(arg0._tf:Find("window_2/without"), not var1)

	local var2 = arg0._tf:Find("window_2/" .. (var1 and "has_guild" or "without"))

	if var1 then
		setText(var2:Find("guild_name/Text"), "「" .. arg0.summaryInfoVO.guildName .. "」")
	end

	setText(var2:Find("chapter_name/Text"), "「" .. arg0.summaryInfoVO.chapterName .. "」")

	if arg0.summaryInfoVO.worldProgressTask > 0 then
		local var3 = pg.world_task_data[arg0.summaryInfoVO.worldProgressTask].name

		setText(var2:Find("world_name/Text"), "「" .. var3 .. "」")
	else
		setText(var2:Find("world_name/Text"), i18n("five_shujuhuigu"))
	end

	setText(arg0._tf:Find("window_3/count/Text"), arg0.summaryInfoVO.furnitureCount)
	setText(arg0._tf:Find("window_3/coin/Text"), arg0.summaryInfoVO.furnitureWorth)
	setText(arg0._tf:Find("window_4/collection/Text"), arg0.summaryInfoVO.collectionNum)
	setText(arg0._tf:Find("window_4/power/Text"), arg0.summaryInfoVO.powerRaw)
	setText(arg0._tf:Find("window_4/ship/Text"), arg0.summaryInfoVO.totalShipNum)
	setText(arg0._tf:Find("window_4/top_ship/Text"), arg0.summaryInfoVO.topShipNum)
	setText(arg0._tf:Find("window_4/best_ship/Text"), arg0.summaryInfoVO.bestShipNum)
end

return var0
