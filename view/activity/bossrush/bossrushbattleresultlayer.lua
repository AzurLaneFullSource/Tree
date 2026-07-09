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

function var0_0.preload(arg0_5, arg1_5)
	arg0_5.loader:LoadBundle(arg0_5:GetAtalsName())
	existCall(arg1_5)
end

function var0_0.init(arg0_6)
	local var0_6 = arg0_6._tf:Find("main/Series")

	arg0_6.resultScroll = var0_6:Find("Scroll")
	arg0_6.resultList = var0_6:Find("Scroll/List")
	arg0_6.playerExp = var0_6:Find("playerExp")
	arg0_6.rightBottomPanel = var0_6:Find("rightBottomPanel")

	setText(arg0_6.rightBottomPanel:Find("confirmBtn/Text"), i18n("text_confirm"))
	setText(arg0_6.resultList:Find("Result/BG/Ships/resulttpl/result/Statistics/kill_count_label"), i18n("battle_result_kill_count"))
	setText(arg0_6.resultList:Find("Result/BG/Ships/resulttpl/result/Statistics/dmg_count_label"), i18n("battle_result_dmg"))
	setText(arg0_6.resultList:Find("Result/BG/commanderExp/commander_container"):GetChild(0):Find("empty/add/Text"), i18n("series_enemy_empty_commander_main"))
	setText(arg0_6.resultList:Find("Result/BG/commanderExp/commander_container"):GetChild(1):Find("empty/add/Text"), i18n("series_enemy_empty_commander_assistant"))
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

function var0_0.didEnter(arg0_7)
	arg0_7:BlurPanel(arg0_7._tf, {
		staticBlur = true,
		lockGlobalBlur = true
	})

	local var0_7 = arg0_7.contextData.seriesData
	local var1_7 = var0_7:GetBattleStatistics()
	local var2_7 = var0_7:GetFinalResults()
	local var3_7 = var0_7:GetExpeditionIds()
	local var4_7, var5_7 = var0_7:GetModeFleetIDs(var0_7:GetMode())
	local var6_7 = var0_7:GetFleets(var4_7)
	local var7_7 = var0_7:GetFleets(var5_7)[1]
	local var8_7 = var7_7:getTeamByName(TeamType.Submarine)
	local var9_7 = var7_7:GetRawCommanderIds()
	local var10_7 = {}
	local var11_7 = {}

	for iter0_7 = 1, #var3_7 do
		local var12_7 = var6_7[iter0_7] or var6_7[1]
		local var13_7 = var2_7[iter0_7]
		local var14_7 = {
			index = iter0_7,
			oldShips = {},
			ships = {},
			oldCmds = {},
			cmds = {},
			mvp = var13_7 and var13_7.mvp or 0
		}
		local var15_7 = Clone(var14_7)

		table.Foreach(var12_7:getShipIds(), function(arg0_8, arg1_8)
			if iter0_7 <= #var2_7 then
				local var0_8 = var13_7.newShips[arg1_8]

				if var0_8 then
					table.insert(var14_7.ships, var0_8)

					var14_7.oldShips[arg1_8] = var13_7.oldShips[arg1_8]
				end
			else
				local var1_8 = getProxy(BayProxy):getShipById(arg1_8)

				table.insert(var14_7.ships, var1_8)

				var14_7.oldShips[arg1_8] = var1_8
			end
		end)
		table.Foreach(var8_7, function(arg0_9, arg1_9)
			if iter0_7 <= #var2_7 then
				local var0_9 = var13_7.newShips[arg1_9]

				if var0_9 then
					table.insert(var15_7.ships, var0_9)

					var15_7.oldShips[arg1_9] = var13_7.oldShips[arg1_9]
				end
			end
		end)

		local var16_7 = var12_7:GetRawCommanderIds()

		_.each({
			1,
			2
		}, function(arg0_10)
			local var0_10 = var16_7[arg0_10] or false

			if var0_10 then
				if iter0_7 <= #var2_7 then
					local var1_10 = var13_7.newCmds[var0_10]

					if var1_10 then
						table.insert(var14_7.cmds, var1_10)

						var14_7.oldCmds[var0_10] = var13_7.oldCmds[var0_10]
					end
				else
					local var2_10 = getProxy(CommanderProxy):getCommanderById(var0_10)

					table.insert(var14_7.cmds, var2_10)

					var14_7.oldCmds[var0_10] = var2_10
				end
			else
				table.insert(var14_7.cmds, false)
			end
		end)
		_.each({
			1,
			2
		}, function(arg0_11)
			local var0_11 = var9_7[arg0_11] or false

			if iter0_7 <= #var2_7 then
				if var0_11 then
					local var1_11 = var13_7.newCmds[var0_11]

					if var1_11 then
						table.insert(var15_7.cmds, var1_11)

						var15_7.oldCmds[var1_11.id] = var13_7.oldCmds[var0_11]
					else
						table.insert(var15_7.cmds, false)
					end
				else
					table.insert(var15_7.cmds, false)
				end
			end
		end)

		var10_7[iter0_7] = var14_7

		if next(var15_7.ships) then
			table.insert(var11_7, var15_7)
		end
	end

	local var17_7 = 0
	local var18_7 = 0

	local function var19_7(arg0_12, arg1_12, arg2_12)
		UIItemList.StaticAlign(arg0_12, arg0_12:GetChild(0), 2, function(arg0_13, arg1_13, arg2_13)
			if arg0_13 ~= UIItemList.EventUpdate then
				return
			end

			local var0_13 = arg2_12[arg1_13 + 1]
			local var1_13 = not var0_13

			setActive(arg2_13:Find("empty"), var1_13)
			setActive(arg2_13:Find("exp"), not var1_13)

			if var1_13 then
				return
			end

			local var2_13 = arg1_12[var0_13.id]
			local var3_13 = var0_13.exp

			GetImageSpriteFromAtlasAsync("commandericon/" .. var0_13:getPainting(), "", arg2_13:Find("exp/icon"))
			setText(arg2_13:Find("exp/name_text"), var0_13:getName())
			setText(arg2_13:Find("exp/lv_text"), "Lv." .. var0_13.level)

			local var4_13 = math.max(0, var2_13.expAdd or 0)

			setText(arg2_13:Find("exp/exp_text"), "+" .. var4_13)

			local var5_13
			local var6_13 = var0_13:isMaxLevel() and 1 or var3_13 / var0_13:getNextLevelExp()

			arg2_13:Find("exp/exp_progress"):GetComponent(typeof(Image)).fillAmount = var6_13
		end)
	end

	local function var20_7(arg0_14, arg1_14, arg2_14)
		setActive(arg0_14:Find("result/mvpBG"), arg1_14 == arg2_14)
	end

	local function var21_7(arg0_15, arg1_15, arg2_15, arg3_15)
		UIItemList.StaticAlign(arg0_15, arg0_15:GetChild(0), #arg1_15, function(arg0_16, arg1_16, arg2_16)
			if arg0_16 ~= UIItemList.EventUpdate then
				return
			end

			local var0_16 = arg1_15[arg1_16 + 1]
			local var1_16 = arg2_15[var0_16.id]

			setActive(arg2_16:Find("result/Exp"), true)
			setActive(arg2_16:Find("result/Statistics"), false)
			var20_7(arg2_16, var0_16.id, arg3_15)

			local var2_16 = arg2_16:Find("result/mask/icon")
			local var3_16 = arg2_16:Find("result/type")
			local var4_16 = GetSpriteFromAtlas("shiptype", shipType2print(var1_16:getShipType()))

			setImageSprite(var3_16, var4_16, true)
			setImageSprite(var2_16, LoadSprite("herohrzicon/" .. var1_16:getPainting()))

			local var5_16 = findTF(arg2_16, "result/stars")
			local var6_16 = findTF(arg2_16, "result/stars/star_tpl")
			local var7_16 = var1_16:getStar()
			local var8_16 = var1_16:getMaxStar()

			UIItemList.StaticAlign(var5_16, var6_16, var8_16, function(arg0_17, arg1_17, arg2_17)
				if arg0_17 ~= UIItemList.EventUpdate then
					return
				end

				local var0_17 = var8_16 - arg1_17

				SetActive(arg2_17:Find("empty"), var0_17 > var7_16)
				SetActive(arg2_17:Find("star"), var0_17 <= var7_16)
			end)
			setText(arg2_16:Find("result/Exp/Level"), "Lv." .. var0_16.level)
			setText(arg2_16:Find("result/Exp/name"), var0_16:getName())

			local var9_16 = arg2_16:Find("result/Exp/exp_text")
			local var10_16 = var1_16:getConfig("rarity")

			if var1_16.level < var0_16.level then
				local var11_16 = 0

				for iter0_16 = var1_16.level, var0_16.level - 1 do
					var11_16 = var11_16 + getExpByRarityFromLv1(var10_16, iter0_16)
				end

				setText(var9_16, "+" .. var11_16 + var0_16:getExp() - var1_16:getExp())
			else
				setText(var9_16, "+" .. (var1_16.expAdd or 0))
			end

			local var12_16 = arg2_16:Find("result/Progress/progress_bar")
			local var13_16 = var0_16:getExp() / getExpByRarityFromLv1(var10_16, var0_16.level)

			var12_16:GetComponent(typeof(Image)).fillAmount = var13_16
		end)
	end

	local function var22_7(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
		arg4_18 = arg4_18 and arg4_18.statistics

		local var0_18 = 0

		if not arg4_18 then
			var0_18 = 10000
		elseif arg3_18 == 0 then
			var0_18 = 0

			for iter0_18, iter1_18 in pairs(arg2_18) do
				var0_18 = math.max(arg4_18[iter1_18.id].output, var0_18)
			end
		elseif arg3_18 > 0 then
			var0_18 = arg4_18[arg3_18].output
		end

		UIItemList.StaticAlign(arg0_18, arg0_18:GetChild(0), #arg1_18, function(arg0_19, arg1_19, arg2_19)
			if arg0_19 ~= UIItemList.EventUpdate then
				return
			end

			local var0_19 = arg1_18[arg1_19 + 1]
			local var1_19 = arg2_18[var0_19.id]

			setActive(arg2_19:Find("result/Statistics"), true)
			setActive(arg2_19:Find("result/Exp"), false)
			var20_7(arg2_19, var0_19.id, arg3_18)

			local var2_19 = arg2_19:Find("result/mask/icon")
			local var3_19 = arg2_19:Find("result/type")
			local var4_19 = GetSpriteFromAtlas("shiptype", shipType2print(var1_19:getShipType()))

			setImageSprite(var3_19, var4_19, true)
			setImageSprite(var2_19, LoadSprite("herohrzicon/" .. var1_19:getPainting()))

			local var5_19 = findTF(arg2_19, "result/stars")
			local var6_19 = findTF(arg2_19, "result/stars/star_tpl")
			local var7_19 = var1_19:getStar()
			local var8_19 = var1_19:getMaxStar()

			UIItemList.StaticAlign(var5_19, var6_19, var8_19, function(arg0_20, arg1_20, arg2_20)
				if arg0_20 ~= UIItemList.EventUpdate then
					return
				end

				local var0_20 = var8_19 - arg1_20

				SetActive(arg2_20:Find("empty"), var0_20 > var7_19)
				SetActive(arg2_20:Find("star"), var0_20 <= var7_19)
			end)

			local var9_19 = arg4_18 and arg4_18[var1_19.id].output or 0
			local var10_19 = arg4_18 and arg4_18[var1_19.id].kill_count or 0
			local var11_19 = arg2_19:Find("result/Statistics/atk")

			setText(var11_19, 0)
			setText(var11_19, var9_19)

			local var12_19 = arg2_19:Find("result/Statistics/killCount")

			setText(var12_19, 0)
			setText(var12_19, var10_19)

			local var13_19 = arg2_19:Find("result/Progress/progress_bar")

			var13_19:GetComponent(typeof(Image)).fillAmount = 0

			local var14_19 = var9_19 / var0_18

			var13_19:GetComponent(typeof(Image)).fillAmount = var14_19
		end)
	end

	local function var23_7(arg0_21, arg1_21, arg2_21, arg3_21)
		arg2_21 = arg2_21 and arg2_21.statistics

		local var0_21 = arg0_21:Find("Title/Label")
		local var1_21 = arg0_21:Find("Title/Letter")
		local var2_21 = {
			"d",
			"c",
			"b",
			"a",
			"s"
		}
		local var3_21
		local var4_21
		local var5_21
		local var6_21
		local var7_21

		if arg2_21 then
			local var8_21 = var2_21[arg2_21._battleScore + 1]

			var6_21 = "letter_" .. var8_21
			var4_21 = "battlescore/battle_score_" .. var8_21 .. "/letter_" .. var8_21
			var7_21 = "label_" .. var8_21
			var5_21 = "battlescore/battle_score_" .. var8_21 .. "/label_" .. var8_21

			if arg2_21._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
				var7_21 = "label_flag_destroy"
				var5_21 = "battlescore/battle_score_c/label_flag_destroy"
			end
		else
			var6_21 = ""
			var7_21 = "label_none"
			var5_21 = "battlescore/grade_label_none"
		end

		eachChild(var0_21, function(arg0_22)
			setActive(arg0_22, arg0_22.name == var7_21)

			if arg0_22.name == var7_21 then
				arg0_7.loader:GetSprite(var5_21, "", arg0_22)
			end
		end)
		eachChild(var1_21, function(arg0_23)
			setActive(arg0_23, arg0_23.name == var6_21)

			if arg0_23.name == var6_21 then
				arg0_7.loader:GetSprite(var4_21, "", arg0_23)
			end
		end)

		local var9_21 = 0
		local var10_21 = not arg2_21 and 3 or arg2_21._battleScore > ys.Battle.BattleConst.BattleScore.C and 1 or 2
		local var11_21 = var1_0[var10_21]

		arg0_7.loader:GetSprite(arg0_7:GetAtalsName(), var11_21, arg0_21:Find("Title"))

		local var12_21 = var2_0[var10_21]

		setImageColor(arg0_21:Find("BG"), SummerFeastScene.TransformColor(var12_21))

		local var13_21 = pg.expedition_data_template[var3_7[arg3_21]]

		setText(arg0_21:Find("Title/Name"), var13_21.name)
		setText(arg0_21:Find("BG/FleetName/Text"), i18n("series_enemy_fleet_prefix", GetRomanDigit(arg1_21.index)))
		var19_7(arg0_21:Find("BG/commanderExp/commander_container"), arg1_21.oldCmds, arg1_21.cmds)
	end

	local function var24_7()
		local var0_24 = var18_7 == 1 and var11_7 or var10_7

		UIItemList.StaticAlign(arg0_7.resultList, arg0_7.resultList:GetChild(0), #var0_24, function(arg0_25, arg1_25, arg2_25)
			if arg0_25 ~= UIItemList.EventUpdate then
				return
			end

			local var0_25 = var0_24[arg1_25 + 1]
			local var1_25 = var1_7[var0_25.index]

			var23_7(arg2_25, var0_25, var1_25, var0_25.index)
			var21_7(arg2_25:Find("BG/Ships"), var0_25.ships, var0_25.oldShips, var0_25.mvp)
		end)
	end

	local function var25_7()
		local var0_26 = var18_7 == 1 and var11_7 or var10_7

		UIItemList.StaticAlign(arg0_7.resultList, arg0_7.resultList:GetChild(0), #var0_26, function(arg0_27, arg1_27, arg2_27)
			if arg0_27 ~= UIItemList.EventUpdate then
				return
			end

			local var0_27 = var0_26[arg1_27 + 1]
			local var1_27 = var1_7[var0_27.index]

			var23_7(arg2_27, var0_27, var1_27, var0_27.index)
			var22_7(arg2_27:Find("BG/Ships"), var0_27.ships, var0_27.oldShips, var0_27.mvp, var1_27)
		end)
	end

	local var26_7 = arg0_7.rightBottomPanel:Find("submarine")
	local var27_7 = arg0_7.rightBottomPanel:Find("main")

	setActive(var26_7, #var11_7 > 0)

	local function var28_7()
		setActive(var27_7, var18_7 == 1)
		setActive(var26_7, var18_7 == 0 and #var11_7 > 0)

		if var17_7 == 0 then
			var24_7()
		elseif var17_7 == 1 then
			var25_7()
		end
	end

	var28_7()
	;(function()
		local var0_29 = getProxy(PlayerProxy):getRawData()
		local var1_29 = _.reduce(var2_7, 0, function(arg0_30, arg1_30)
			return arg0_30 + arg1_30.playerExp.addExp
		end)

		setText(arg0_7._tf:Find("main/Series/playerExp/name_text"), var0_29.name)
		setText(arg0_7._tf:Find("main/Series/playerExp/lv_text"), "Lv." .. var0_29.level)
		setText(arg0_7._tf:Find("main/Series/playerExp/exp_text"), "+" .. var1_29)

		local var2_29 = arg0_7._tf:Find("main/Series/playerExp/exp_progress")
		local var3_29 = getConfigFromLevel1(pg.user_level, var0_29.level)

		var2_29:GetComponent(typeof(Image)).fillAmount = var0_29.exp / var3_29.exp_interval
	end)()
	onButton(arg0_7, arg0_7.rightBottomPanel:Find("statisticsBtn"), function()
		var17_7 = 1 - var17_7

		var28_7()
	end, SFX_PANEL)
	onButton(arg0_7, var26_7, function()
		var18_7 = 1

		var28_7()
	end, SFX_PANEL)
	onButton(arg0_7, var27_7, function()
		var18_7 = 0

		var28_7()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.rightBottomPanel:Find("confirmBtn"), function()
		arg0_7:emit(BossRushBattleResultMediator.ON_SETTLE)
	end, SFX_PANEL)

	local var29_7 = arg0_7._tf:Find("main/Series/ArrowLeft")
	local var30_7 = arg0_7._tf:Find("main/Series/ArrowRight")

	Canvas.ForceUpdateCanvases()

	if arg0_7.resultScroll.rect.width >= arg0_7.resultList.rect.width then
		setActive(var29_7, false)
		setActive(var30_7, false)
	else
		setActive(var29_7, false)
		setActive(var30_7, true)
		onScroll(arg0_7, arg0_7.resultScroll, function(arg0_35)
			setActive(var29_7, arg0_35.x > 0.01)
			setActive(var30_7, arg0_35.x < 0.99)
		end)
	end
end

function var0_0.HideConfirmPanel(arg0_36)
	setActive(arg0_36.rightBottomPanel:Find("confirmBtn"), false)
end

function var0_0.onBackPressed(arg0_37)
	triggerButton(arg0_37.rightBottomPanel:Find("confirmBtn"))
end

function var0_0.willExit(arg0_38)
	arg0_38:UnOverlayPanel(arg0_38._tf)
	arg0_38.loader:Clear()

	if arg0_38.contextData.OnClose then
		arg0_38.contextData.OnClose()
	end
end

return var0_0
