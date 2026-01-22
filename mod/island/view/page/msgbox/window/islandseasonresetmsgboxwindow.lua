local var0_0 = class("IslandSeasonResetMsgBoxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForSeasonReset"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.emptyTF = arg0_2._tf:Find("info_empty")
	arg0_2.awardTF = arg0_2._tf:Find("info_award")

	setText(arg0_2._tf:Find("confirm/Text"), i18n("word_ok"))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)
	arg0_3:FlushResetInfo()
end

function var0_0.FlushBtn(arg0_4, arg1_4)
	setActive(arg0_4.cancelBtn, false)
	setActive(arg0_4.confirmBtn, true)
end

function var0_0.FlushResetInfo(arg0_5)
	local var0_5 = arg0_5.settings.body
	local var1_5 = var0_5.awards

	setActive(arg0_5.emptyTF, #var1_5 == 0)
	setActive(arg0_5.awardTF, #var1_5 > 0)

	local var2_5 = #var1_5 == 0 and arg0_5.emptyTF or arg0_5.awardTF
	local var3_5 = pg.island_season[var0_5.seasonId].name

	setText(var2_5:Find("reset/name/Text"), i18n("island_season_window_pt", var3_5))
	setText(var2_5:Find("reset/value/Text"), var0_5.pt)
	setText(var2_5:Find("rank/name/Text"), i18n("island_season_window_ranking"))
	setText(var2_5:Find("rank/value"), var0_5.rank > 0 and var0_5.rank or i18n("island_season_window_out"))

	if #var1_5 > 0 then
		setText(var2_5:Find("award/name/Text"), i18n("island_season_window_award"))
		UIItemList.StaticAlign(var2_5:Find("award/list"), var2_5:Find("award/list/tpl"), #var1_5, function(arg0_6, arg1_6, arg2_6)
			if arg0_6 == UIItemList.EventUpdate then
				updateCustomDrop(arg2_6, var1_5[arg1_6 + 1])
			end
		end)
	end
end

return var0_0
