local var0_0 = class("SecondSummaryPage2", import(".SummaryAnimationPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = Ship.New({
		configId = arg0_1.summaryInfoVO.flagShipId
	}):getPainting()

	setPaintingPrefabAsync(arg0_1._tf:Find("paint_panel/painting"), var0_1, "chuanwu")
	setText(arg0_1._tf:Find("window_1/name"), arg0_1.summaryInfoVO.name)
	setText(arg0_1._tf:Find("window_1/time/Text"), "「" .. arg0_1.summaryInfoVO.registerTime .. "」")
	setText(arg0_1._tf:Find("window_1/server/Text"), "「" .. arg0_1.summaryInfoVO.serverName .. "」")
	setText(arg0_1._tf:Find("window_1/day/Text"), arg0_1.summaryInfoVO.days)

	local var1_1 = arg0_1.summaryInfoVO:hasGuild()

	setActive(arg0_1._tf:Find("window_2/has_guild"), var1_1)
	setActive(arg0_1._tf:Find("window_2/without"), not var1_1)

	local var2_1 = arg0_1._tf:Find("window_2/" .. (var1_1 and "has_guild" or "without"))

	if var1_1 then
		setText(var2_1:Find("guild_name/Text"), "「" .. arg0_1.summaryInfoVO.guildName .. "」")
	end

	setText(var2_1:Find("chapter_name/Text"), "「" .. arg0_1.summaryInfoVO.chapterName .. "」")

	if arg0_1.summaryInfoVO.worldProgressTask > 0 then
		local var3_1 = pg.world_task_data[arg0_1.summaryInfoVO.worldProgressTask].name

		setText(var2_1:Find("world_name/Text"), "「" .. var3_1 .. "」")
	else
		setText(var2_1:Find("world_name/Text"), i18n("five_shujuhuigu"))
	end

	setText(arg0_1._tf:Find("window_3/count/Text"), arg0_1.summaryInfoVO.furnitureCount)
	setText(arg0_1._tf:Find("window_3/coin/Text"), arg0_1.summaryInfoVO.furnitureWorth)
	setText(arg0_1._tf:Find("window_4/collection/Text"), arg0_1.summaryInfoVO.collectionNum)
	setText(arg0_1._tf:Find("window_4/power/Text"), arg0_1.summaryInfoVO.powerRaw)
	setText(arg0_1._tf:Find("window_4/ship/Text"), arg0_1.summaryInfoVO.totalShipNum)
	setText(arg0_1._tf:Find("window_4/top_ship/Text"), arg0_1.summaryInfoVO.topShipNum)
	setText(arg0_1._tf:Find("window_4/best_ship/Text"), arg0_1.summaryInfoVO.bestShipNum)
end

return var0_0
