local var0_0 = class("BossRushBattleResultLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BattleResultBossRushUI"
end

function var0_0.getGroupName(arg0_2)
	return "BattleScene"
end

function var0_0.Ctor(arg0_3, ...)
	var0_0.super.Ctor(arg0_3, ...)

	arg0_3.loader = AutoLoader.New()
end

function var0_0.GetAtalsName(arg0_4)
	return "ui/battleresult_atlas"
end

function var0_0.getResource(arg0_5)
	local var0_5 = var0_0.super.getResource(arg0_5)

	table.insert(var0_5, arg0_5:GetAtalsName())

	return var0_5
end

function var0_0.preload(arg0_6, arg1_6)
	arg0_6.loader:LoadBundle(arg0_6:GetAtalsName())
	existCall(arg1_6)
end

function var0_0.init(arg0_7)
	local var0_7 = arg0_7._tf:Find("main/Series")

	arg0_7.resultScroll = var0_7:Find("Scroll")
	arg0_7.resultList = var0_7:Find("Scroll/List")
	arg0_7.playerExp = var0_7:Find("playerExp")
	arg0_7.rightBottomPanel = var0_7:Find("rightBottomPanel")

	setText(arg0_7.rightBottomPanel:Find("confirmBtn/Text"), i18n("text_confirm"))
	setText(arg0_7.resultList:Find("Result/BG/Ships/resulttpl/result/Statistics/kill_count_label"), i18n("battle_result_kill_count"))
	setText(arg0_7.resultList:Find("Result/BG/Ships/resulttpl/result/Statistics/dmg_count_label"), i18n("battle_result_dmg"))
	setText(arg0_7.resultList:Find("Result/BG/commanderExp/commander_container"):GetChild(0):Find("empty/add/Text"), i18n("series_enemy_empty_commander_main"))
	setText(arg0_7.resultList:Find("Result/BG/commanderExp/commander_container"):GetChild(1):Find("empty/add/Text"), i18n("series_enemy_empty_commander_assistant"))
end

local var1_0 = {
	"sucess_title_bg",
	"fail_title_bg",
	"none_title_bg"
}
local var2_0 = {
	"1216207f",
	"48160d7f",
	"3c3c3c7f"
}

function var0_0.didEnter(arg0_8)
	arg0_8:BlurPanel(arg0_8._tf, {
		staticBlur = true,
		lockGlobalBlur = true
	})

	local var0_8 = arg0_8.contextData.seriesData
	local var1_8 = var0_8:GetBattleStatistics()
	local var2_8 = var0_8:GetFinalResults()
	local var3_8 = var0_8:GetExpeditionIds()
	local var4_8, var5_8 = var0_8:GetModeFleetIDs(var0_8:GetMode())
	local var6_8 = var0_8:GetFleets(var4_8)
	local var7_8 = var0_8:GetFleets(var5_8)[1]
	local var8_8 = var7_8:getTeamByName(TeamType.Submarine)
	local var9_8 = var7_8:GetRawCommanderIds()
	local var10_8 = {}
	local var11_8 = {}

	for iter0_8 = 1, #var3_8 do
		local var12_8 = var6_8[iter0_8] or var6_8[1]
		local var13_8 = var2_8[iter0_8]
		local var14_8 = {
			index = iter0_8,
			oldShips = {},
			ships = {},
			oldCmds = {},
			cmds = {},
			mvp = var13_8 and var13_8.mvp or 0
		}
		local var15_8 = Clone(var14_8)

		table.Foreach(var12_8:getShipIds(), function(arg0_9, arg1_9)
			if iter0_8 <= #var2_8 then
				local var0_9 = var13_8.newShips[arg1_9]

				if var0_9 then
					table.insert(var14_8.ships, var0_9)

					var14_8.oldShips[arg1_9] = var13_8.oldShips[arg1_9]
				end
			else
				local var1_9 = getProxy(BayProxy):getShipById(arg1_9)

				table.insert(var14_8.ships, var1_9)

				var14_8.oldShips[arg1_9] = var1_9
			end
		end)
		table.Foreach(var8_8, function(arg0_10, arg1_10)
			if iter0_8 <= #var2_8 then
				local var0_10 = var13_8.newShips[arg1_10]

				if var0_10 then
					table.insert(var15_8.ships, var0_10)

					var15_8.oldShips[arg1_10] = var13_8.oldShips[arg1_10]
				end
			end
		end)

		local var16_8 = var12_8:GetRawCommanderIds()

		_.each({
			1,
			2
		}, function(arg0_11)
			local var0_11 = var16_8[arg0_11] or false

			if var0_11 then
				if iter0_8 <= #var2_8 then
					local var1_11 = var13_8.newCmds[var0_11]

					if var1_11 then
						table.insert(var14_8.cmds, var1_11)

						var14_8.oldCmds[var0_11] = var13_8.oldCmds[var0_11]
					end
				else
					local var2_11 = getProxy(CommanderProxy):getCommanderById(var0_11)

					table.insert(var14_8.cmds, var2_11)

					var14_8.oldCmds[var0_11] = var2_11
				end
			else
				table.insert(var14_8.cmds, false)
			end
		end)
		_.each({
			1,
			2
		}, function(arg0_12)
			local var0_12 = var9_8[arg0_12] or false

			if iter0_8 <= #var2_8 then
				if var0_12 then
					local var1_12 = var13_8.newCmds[var0_12]

					if var1_12 then
						table.insert(var15_8.cmds, var1_12)

						var15_8.oldCmds[var1_12.id] = var13_8.oldCmds[var0_12]
					else
						table.insert(var15_8.cmds, false)
					end
				else
					table.insert(var15_8.cmds, false)
				end
			end
		end)

		var10_8[iter0_8] = var14_8

		if next(var15_8.ships) then
			table.insert(var11_8, var15_8)
		end
	end

	local var17_8 = 0
	local var18_8 = 0

	local function var19_8(arg0_13, arg1_13, arg2_13)
		UIItemList.StaticAlign(arg0_13, arg0_13:GetChild(0), 2, function(arg0_14, arg1_14, arg2_14)
			if arg0_14 ~= UIItemList.EventUpdate then
				return
			end

			local var0_14 = arg2_13[arg1_14 + 1]
			local var1_14 = not var0_14

			setActive(arg2_14:Find("empty"), var1_14)
			setActive(arg2_14:Find("exp"), not var1_14)

			if var1_14 then
				return
			end

			local var2_14 = arg1_13[var0_14.id]
			local var3_14 = var0_14.exp

			GetImageSpriteFromAtlasAsync("commandericon/" .. var0_14:getPainting(), "", arg2_14:Find("exp/icon"))
			setText(arg2_14:Find("exp/name_text"), var0_14:getName())
			setText(arg2_14:Find("exp/lv_text"), "Lv." .. var0_14.level)

			local var4_14 = math.max(0, var2_14.expAdd or 0)

			setText(arg2_14:Find("exp/exp_text"), "+" .. var4_14)

			local var5_14
			local var6_14 = var0_14:isMaxLevel() and 1 or var3_14 / var0_14:getNextLevelExp()

			arg2_14:Find("exp/exp_progress"):GetComponent(typeof(Image)).fillAmount = var6_14
		end)
	end

	local function var20_8(arg0_15, arg1_15, arg2_15)
		setActive(arg0_15:Find("result/mvpBG"), arg1_15 == arg2_15)
	end

	local function var21_8(arg0_16, arg1_16, arg2_16, arg3_16)
		UIItemList.StaticAlign(arg0_16, arg0_16:GetChild(0), #arg1_16, function(arg0_17, arg1_17, arg2_17)
			if arg0_17 ~= UIItemList.EventUpdate then
				return
			end

			local var0_17 = arg1_16[arg1_17 + 1]
			local var1_17 = arg2_16[var0_17.id]

			setActive(arg2_17:Find("result/Exp"), true)
			setActive(arg2_17:Find("result/Statistics"), false)
			var20_8(arg2_17, var0_17.id, arg3_16)

			local var2_17 = arg2_17:Find("result/mask/icon")
			local var3_17 = arg2_17:Find("result/type")
			local var4_17 = GetSpriteFromAtlas("shiptype", shipType2print(var1_17:getShipType()))

			setImageSprite(var3_17, var4_17, true)
			setImageSprite(var2_17, LoadSprite("herohrzicon/" .. var1_17:getPainting()))

			local var5_17 = findTF(arg2_17, "result/stars")
			local var6_17 = findTF(arg2_17, "result/stars/star_tpl")
			local var7_17 = var1_17:getStar()
			local var8_17 = var1_17:getMaxStar()

			UIItemList.StaticAlign(var5_17, var6_17, var8_17, function(arg0_18, arg1_18, arg2_18)
				if arg0_18 ~= UIItemList.EventUpdate then
					return
				end

				local var0_18 = var8_17 - arg1_18

				SetActive(arg2_18:Find("empty"), var0_18 > var7_17)
				SetActive(arg2_18:Find("star"), var0_18 <= var7_17)
			end)
			setText(arg2_17:Find("result/Exp/Level"), "Lv." .. var0_17.level)
			setText(arg2_17:Find("result/Exp/name"), var0_17:getName())

			local var9_17 = arg2_17:Find("result/Exp/exp_text")
			local var10_17 = var1_17:getConfig("rarity")

			if var1_17.level < var0_17.level then
				local var11_17 = 0

				for iter0_17 = var1_17.level, var0_17.level - 1 do
					var11_17 = var11_17 + getExpByRarityFromLv1(var10_17, iter0_17)
				end

				setText(var9_17, "+" .. var11_17 + var0_17:getExp() - var1_17:getExp())
			elseif var1_17.level == var1_17:getMaxLevel() then
				setText(var9_17, "+" .. 0)
			else
				setText(var9_17, "+" .. (var1_17.expAdd or 0))
			end

			local var12_17 = arg2_17:Find("result/Progress/progress_bar")
			local var13_17 = var0_17:getExp() / getExpByRarityFromLv1(var10_17, var0_17.level)

			var12_17:GetComponent(typeof(Image)).fillAmount = var13_17
		end)
	end

	local function var22_8(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
		arg4_19 = arg4_19 and arg4_19.statistics

		local var0_19 = 0

		if not arg4_19 then
			var0_19 = 10000
		elseif arg3_19 == 0 then
			var0_19 = 0

			for iter0_19, iter1_19 in pairs(arg2_19) do
				var0_19 = math.max(arg4_19[iter1_19.id].output, var0_19)
			end
		elseif arg3_19 > 0 then
			var0_19 = arg4_19[arg3_19].output
		end

		UIItemList.StaticAlign(arg0_19, arg0_19:GetChild(0), #arg1_19, function(arg0_20, arg1_20, arg2_20)
			if arg0_20 ~= UIItemList.EventUpdate then
				return
			end

			local var0_20 = arg1_19[arg1_20 + 1]
			local var1_20 = arg2_19[var0_20.id]

			setActive(arg2_20:Find("result/Statistics"), true)
			setActive(arg2_20:Find("result/Exp"), false)
			var20_8(arg2_20, var0_20.id, arg3_19)

			local var2_20 = arg2_20:Find("result/mask/icon")
			local var3_20 = arg2_20:Find("result/type")
			local var4_20 = GetSpriteFromAtlas("shiptype", shipType2print(var1_20:getShipType()))

			setImageSprite(var3_20, var4_20, true)
			setImageSprite(var2_20, LoadSprite("herohrzicon/" .. var1_20:getPainting()))

			local var5_20 = findTF(arg2_20, "result/stars")
			local var6_20 = findTF(arg2_20, "result/stars/star_tpl")
			local var7_20 = var1_20:getStar()
			local var8_20 = var1_20:getMaxStar()

			UIItemList.StaticAlign(var5_20, var6_20, var8_20, function(arg0_21, arg1_21, arg2_21)
				if arg0_21 ~= UIItemList.EventUpdate then
					return
				end

				local var0_21 = var8_20 - arg1_21

				SetActive(arg2_21:Find("empty"), var0_21 > var7_20)
				SetActive(arg2_21:Find("star"), var0_21 <= var7_20)
			end)

			local var9_20 = arg4_19 and arg4_19[var1_20.id].output or 0
			local var10_20 = arg4_19 and arg4_19[var1_20.id].kill_count or 0
			local var11_20 = arg2_20:Find("result/Statistics/atk")

			setText(var11_20, 0)
			setText(var11_20, var9_20)

			local var12_20 = arg2_20:Find("result/Statistics/killCount")

			setText(var12_20, 0)
			setText(var12_20, var10_20)

			local var13_20 = arg2_20:Find("result/Progress/progress_bar")

			var13_20:GetComponent(typeof(Image)).fillAmount = 0

			local var14_20 = var9_20 / var0_19

			var13_20:GetComponent(typeof(Image)).fillAmount = var14_20
		end)
	end

	local function var23_8(arg0_22, arg1_22, arg2_22, arg3_22)
		arg2_22 = arg2_22 and arg2_22.statistics

		local var0_22 = arg0_22:Find("Title/Label")
		local var1_22 = arg0_22:Find("Title/Letter")
		local var2_22 = {
			"d",
			"c",
			"b",
			"a",
			"s"
		}
		local var3_22
		local var4_22
		local var5_22
		local var6_22
		local var7_22

		if arg2_22 then
			local var8_22 = var2_22[arg2_22._battleScore + 1]

			var6_22 = "letter_" .. var8_22
			var4_22 = "battlescore/battle_score_" .. var8_22 .. "/letter_" .. var8_22
			var7_22 = "label_" .. var8_22
			var5_22 = "battlescore/battle_score_" .. var8_22 .. "/label_" .. var8_22

			if arg2_22._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
				var7_22 = "label_flag_destroy"
				var5_22 = "battlescore/battle_score_c/label_flag_destroy"
			end
		else
			var6_22 = ""
			var7_22 = "label_none"
			var5_22 = "battlescore/grade_label_none"
		end

		eachChild(var0_22, function(arg0_23)
			setActive(arg0_23, arg0_23.name == var7_22)

			if arg0_23.name == var7_22 then
				arg0_8.loader:GetSprite(var5_22, "", arg0_23)
			end
		end)
		eachChild(var1_22, function(arg0_24)
			setActive(arg0_24, arg0_24.name == var6_22)

			if arg0_24.name == var6_22 then
				arg0_8.loader:GetSprite(var4_22, "", arg0_24)
			end
		end)

		local var9_22 = 0
		local var10_22 = not arg2_22 and 3 or arg2_22._battleScore > ys.Battle.BattleConst.BattleScore.C and 1 or 2
		local var11_22 = var1_0[var10_22]

		arg0_8.loader:GetSprite(arg0_8:GetAtalsName(), var11_22, arg0_22:Find("Title"))

		local var12_22 = var2_0[var10_22]

		setImageColor(arg0_22:Find("BG"), SummerFeastScene.TransformColor(var12_22))

		local var13_22 = pg.expedition_data_template[var3_8[arg3_22]]

		setText(arg0_22:Find("Title/Name"), var13_22.name)
		setText(arg0_22:Find("BG/FleetName/Text"), i18n("series_enemy_fleet_prefix", GetRomanDigit(arg1_22.index)))
		var19_8(arg0_22:Find("BG/commanderExp/commander_container"), arg1_22.oldCmds, arg1_22.cmds)
	end

	local function var24_8()
		local var0_25 = var18_8 == 1 and var11_8 or var10_8

		UIItemList.StaticAlign(arg0_8.resultList, arg0_8.resultList:GetChild(0), #var0_25, function(arg0_26, arg1_26, arg2_26)
			if arg0_26 ~= UIItemList.EventUpdate then
				return
			end

			local var0_26 = var0_25[arg1_26 + 1]
			local var1_26 = var1_8[var0_26.index]

			var23_8(arg2_26, var0_26, var1_26, var0_26.index)
			warning("yzh----RefreshExps--")
			var21_8(arg2_26:Find("BG/Ships"), var0_26.ships, var0_26.oldShips, var0_26.mvp)
		end)
	end

	local function var25_8()
		local var0_27 = var18_8 == 1 and var11_8 or var10_8

		UIItemList.StaticAlign(arg0_8.resultList, arg0_8.resultList:GetChild(0), #var0_27, function(arg0_28, arg1_28, arg2_28)
			if arg0_28 ~= UIItemList.EventUpdate then
				return
			end

			local var0_28 = var0_27[arg1_28 + 1]
			local var1_28 = var1_8[var0_28.index]

			var23_8(arg2_28, var0_28, var1_28, var0_28.index)
			var22_8(arg2_28:Find("BG/Ships"), var0_28.ships, var0_28.oldShips, var0_28.mvp, var1_28)
		end)
	end

	local var26_8 = arg0_8.rightBottomPanel:Find("submarine")
	local var27_8 = arg0_8.rightBottomPanel:Find("main")

	setActive(var26_8, #var11_8 > 0)

	local function var28_8()
		setActive(var27_8, var18_8 == 1)
		setActive(var26_8, var18_8 == 0 and #var11_8 > 0)

		if var17_8 == 0 then
			var24_8()
		elseif var17_8 == 1 then
			var25_8()
		end
	end

	var28_8()
	;(function()
		local var0_30 = getProxy(PlayerProxy):getRawData()
		local var1_30 = _.reduce(var2_8, 0, function(arg0_31, arg1_31)
			return arg0_31 + arg1_31.playerExp.addExp
		end)

		setText(arg0_8._tf:Find("main/Series/playerExp/name_text"), var0_30.name)
		setText(arg0_8._tf:Find("main/Series/playerExp/lv_text"), "Lv." .. var0_30.level)
		setText(arg0_8._tf:Find("main/Series/playerExp/exp_text"), "+" .. var1_30)

		local var2_30 = arg0_8._tf:Find("main/Series/playerExp/exp_progress")
		local var3_30 = getConfigFromLevel1(pg.user_level, var0_30.level)

		var2_30:GetComponent(typeof(Image)).fillAmount = var0_30.exp / var3_30.exp_interval
	end)()
	onButton(arg0_8, arg0_8.rightBottomPanel:Find("statisticsBtn"), function()
		var17_8 = 1 - var17_8

		var28_8()
	end, SFX_PANEL)
	onButton(arg0_8, var26_8, function()
		var18_8 = 1

		var28_8()
	end, SFX_PANEL)
	onButton(arg0_8, var27_8, function()
		var18_8 = 0

		var28_8()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.rightBottomPanel:Find("confirmBtn"), function()
		arg0_8:emit(BossRushBattleResultMediator.ON_SETTLE)
	end, SFX_PANEL)

	local var29_8 = arg0_8._tf:Find("main/Series/ArrowLeft")
	local var30_8 = arg0_8._tf:Find("main/Series/ArrowRight")

	Canvas.ForceUpdateCanvases()

	if arg0_8.resultScroll.rect.width >= arg0_8.resultList.rect.width then
		setActive(var29_8, false)
		setActive(var30_8, false)
	else
		setActive(var29_8, false)
		setActive(var30_8, true)
		onScroll(arg0_8, arg0_8.resultScroll, function(arg0_36)
			setActive(var29_8, arg0_36.x > 0.01)
			setActive(var30_8, arg0_36.x < 0.99)
		end)
	end
end

function var0_0.HideConfirmPanel(arg0_37)
	setActive(arg0_37.rightBottomPanel:Find("confirmBtn"), false)
end

function var0_0.onBackPressed(arg0_38)
	triggerButton(arg0_38.rightBottomPanel:Find("confirmBtn"))
end

function var0_0.willExit(arg0_39)
	arg0_39:UnOverlayPanel(arg0_39._tf)
	arg0_39.loader:Clear()

	if arg0_39.contextData.OnClose then
		arg0_39.contextData.OnClose()
	end
end

return var0_0
