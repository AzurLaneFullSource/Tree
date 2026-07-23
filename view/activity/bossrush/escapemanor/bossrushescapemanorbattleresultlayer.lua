local var0_0 = class("BossRushEscapeManorBattleResultLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BattleResultBossRushEscapeManorEXUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2._tf:Find("TotalScore/Desc"), i18n("series_enemy_total_score"))
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)

	local var0_3 = arg0_3.contextData.seriesData

	onButton(arg0_3, arg0_3._tf:Find("Confirm"), function()
		arg0_3:emit(BossRushBattleResultMediator.ON_SETTLE)
	end, SFX_PANEL)
	setText(arg0_3._tf:Find("Confirm/Text"), i18n("battle_result_confirm"))

	local var1_3 = var0_3 and var0_3:GetFinalResults() or {}
	local var2_3 = var0_3 and var0_3:GetEXScores()
	local var3_3 = 0

	arg0_3.retPaintings = {}

	_.each(_.range(#var2_3), function(arg0_5)
		local var0_5 = arg0_3._tf:Find("Paintings"):GetChild(arg0_5 - 1)
		local var1_5 = var0_5:Find("content/text")
		local var2_5 = var0_5:Find("content/desc")
		local var3_5 = var0_5:Find("mask/painting")

		setActive(var0_5, arg0_5 <= #var2_3)

		if arg0_5 > #var2_3 then
			return
		end

		setText(var1_5, var2_3[arg0_5])
		setText(var2_5, i18n("series_enemy_score") .. " ")

		var3_3 = var3_3 + var2_3[arg0_5]

		local var4_5 = (function()
			local var0_6 = var1_3[arg0_5]

			if not var0_6 then
				return
			end

			local var1_6 = (function()
				if var0_6.mvp ~= 0 then
					return var0_6.mvp
				end

				return var0_6.newShips[1] and var0_6.newShips[1].id or nil
			end)()

			if not var1_6 then
				return
			end

			local var2_6 = getProxy(BayProxy):RawGetShipById(var1_6)

			if not var2_6 then
				return
			end

			return var2_6:getPainting()
		end)() or "changdao"

		arg0_3:setPainting(var3_5, var4_5)
		table.insert(arg0_3.retPaintings, {
			var3_5,
			var4_5
		})
	end)
	setText(arg0_3._tf:Find("TotalScore/Text"), var3_3)
	arg0_3:loadUI()
end

function var0_0.setPainting(arg0_8, arg1_8, arg2_8, arg3_8)
	setPaintingPrefabAsync(arg1_8, arg2_8, "biandui", arg3_8)
end

function var0_0.retPainting(arg0_9, arg1_9, arg2_9)
	retPaintingPrefab(arg1_9, arg2_9)
end

function var0_0.onBackPressed(arg0_10)
	triggerButton(arg0_10._tf:Find("Confirm"))
end

function var0_0.willExit(arg0_11)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11._tf)

	if arg0_11.retPaintings and #arg0_11.retPaintings > 0 then
		for iter0_11, iter1_11 in ipairs(arg0_11.retPaintings) do
			arg0_11:retPainting(iter1_11[1], iter1_11[2])
		end
	end
end

function var0_0.loadUI(arg0_12)
	local var0_12 = getProxy(PlayerProxy):getRawData()
	local var1_12 = getProxy(UserProxy):getRawData()
	local var2_12 = getProxy(ServerProxy):getRawData()[var1_12 and var1_12.server or 0]
	local var3_12 = var0_12 and var0_12.name or ""
	local var4_12 = var2_12 and var2_12.name or ""
	local var5_12 = arg0_12._tf:Find("share")

	setText(var5_12:Find("name/value"), var3_12)
	setText(var5_12:Find("server"), i18n("zengke_series_serverinfo"))
	setText(var5_12:Find("server/value"), var4_12)
	setText(var5_12:Find("lv/value"), var0_12.level)
end

return var0_0
