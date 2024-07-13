local var0_0 = class("BossRushBattleResultLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BattleResultBossRushUI"
end

function var0_0.Ctor(arg0_2, ...)
	var0_0.super.Ctor(arg0_2, ...)

	arg0_2.loader = AutoLoader.New()
end

function var0_0.GetAtalsName(arg0_3)
	return "ui/battleresult_atlas"
end

function var0_0.preload(arg0_4, arg1_4)
	arg0_4.loader:LoadBundle(arg0_4:GetAtalsName())
	existCall(arg1_4)
end

function var0_0.init(arg0_5)
	local var0_5 = arg0_5._tf:Find("main/Series")

	arg0_5.resultScroll = var0_5:Find("Scroll")
	arg0_5.resultList = var0_5:Find("Scroll/List")
	arg0_5.playerExp = var0_5:Find("playerExp")
	arg0_5.rightBottomPanel = var0_5:Find("rightBottomPanel")

	setText(arg0_5.rightBottomPanel:Find("confirmBtn/Text"), i18n("text_confirm"))
	setText(arg0_5.resultList:Find("Result/BG/Ships/resulttpl/result/Statistics/kill_count_label"), i18n("battle_result_kill_count"))
	setText(arg0_5.resultList:Find("Result/BG/Ships/resulttpl/result/Statistics/dmg_count_label"), i18n("battle_result_dmg"))
	setText(arg0_5.resultList:Find("Result/BG/commanderExp/commander_container"):GetChild(0):Find("empty/add/Text"), i18n("series_enemy_empty_commander_main"))
	setText(arg0_5.resultList:Find("Result/BG/commanderExp/commander_container"):GetChild(1):Find("empty/add/Text"), i18n("series_enemy_empty_commander_assistant"))
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

function var0_0.didEnter(arg0_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf, true, {
		lockGlobalBlur = true,
		groupName = LayerWeightConst.GROUP_COMBAT
	})

	local var0_6 = arg0_6.contextData.seriesData
	local var1_6 = var0_6:GetBattleStatistics()
	local var2_6 = var0_6:GetFinalResults()
	local var3_6 = var0_6:GetFleets()
	local var4_6 = var0_6:GetExpeditionIds()
	local var5_6 = var3_6[#var3_6]
	local var6_6 = var5_6:getTeamByName(TeamType.Submarine)
	local var7_6 = var5_6:GetRawCommanderIds()
	local var8_6 = {}
	local var9_6 = {}

	for iter0_6 = 1, #var4_6 do
		local var10_6 = var3_6[iter0_6]

		if var0_6:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var10_6 = var3_6[1]
		end

		local var11_6 = var2_6[iter0_6]
		local var12_6 = {
			index = iter0_6,
			oldShips = {},
			ships = {},
			oldCmds = {},
			cmds = {},
			mvp = var11_6 and var11_6.mvp or 0
		}
		local var13_6 = Clone(var12_6)

		table.Foreach(var10_6:getShipIds(), function(arg0_7, arg1_7)
			if iter0_6 <= #var2_6 then
				local var0_7 = var11_6.newShips[arg1_7]

				if var0_7 then
					table.insert(var12_6.ships, var0_7)

					var12_6.oldShips[arg1_7] = var11_6.oldShips[arg1_7]
				end
			else
				local var1_7 = getProxy(BayProxy):getShipById(arg1_7)

				table.insert(var12_6.ships, var1_7)

				var12_6.oldShips[arg1_7] = var1_7
			end
		end)
		table.Foreach(var6_6, function(arg0_8, arg1_8)
			if iter0_6 <= #var2_6 then
				local var0_8 = var11_6.newShips[arg1_8]

				if var0_8 then
					table.insert(var13_6.ships, var0_8)

					var13_6.oldShips[arg1_8] = var11_6.oldShips[arg1_8]
				end
			end
		end)

		local var14_6 = var10_6:GetRawCommanderIds()

		_.each({
			1,
			2
		}, function(arg0_9)
			local var0_9 = var14_6[arg0_9] or false

			if var0_9 then
				if iter0_6 <= #var2_6 then
					local var1_9 = var11_6.newCmds[var0_9]

					if var1_9 then
						table.insert(var12_6.cmds, var1_9)

						var12_6.oldCmds[var0_9] = var11_6.oldCmds[var0_9]
					end
				else
					local var2_9 = getProxy(CommanderProxy):getCommanderById(var0_9)

					table.insert(var12_6.cmds, var2_9)

					var12_6.oldCmds[var0_9] = var2_9
				end
			else
				table.insert(var12_6.cmds, false)
			end
		end)
		_.each({
			1,
			2
		}, function(arg0_10)
			local var0_10 = var7_6[arg0_10] or false

			if iter0_6 <= #var2_6 then
				if var0_10 then
					local var1_10 = var11_6.newCmds[var0_10]

					if var1_10 then
						table.insert(var13_6.cmds, var1_10)

						var13_6.oldCmds[var1_10.id] = var11_6.oldCmds[var0_10]
					else
						table.insert(var13_6.cmds, false)
					end
				else
					table.insert(var13_6.cmds, false)
				end
			end
		end)

		var8_6[iter0_6] = var12_6

		if next(var13_6.ships) then
			table.insert(var9_6, var13_6)
		end
	end

	local var15_6 = 0
	local var16_6 = 0

	local function var17_6(arg0_11, arg1_11, arg2_11)
		UIItemList.StaticAlign(arg0_11, arg0_11:GetChild(0), 2, function(arg0_12, arg1_12, arg2_12)
			if arg0_12 ~= UIItemList.EventUpdate then
				return
			end

			local var0_12 = arg2_11[arg1_12 + 1]
			local var1_12 = not var0_12

			setActive(arg2_12:Find("empty"), var1_12)
			setActive(arg2_12:Find("exp"), not var1_12)

			if var1_12 then
				return
			end

			local var2_12 = arg1_11[var0_12.id]
			local var3_12 = var0_12.exp

			GetImageSpriteFromAtlasAsync("commandericon/" .. var0_12:getPainting(), "", arg2_12:Find("exp/icon"))
			setText(arg2_12:Find("exp/name_text"), var0_12:getName())
			setText(arg2_12:Find("exp/lv_text"), "Lv." .. var0_12.level)

			local var4_12 = math.max(0, var2_12.expAdd or 0)

			setText(arg2_12:Find("exp/exp_text"), "+" .. var4_12)

			local var5_12
			local var6_12 = var0_12:isMaxLevel() and 1 or var3_12 / var0_12:getNextLevelExp()

			arg2_12:Find("exp/exp_progress"):GetComponent(typeof(Image)).fillAmount = var6_12
		end)
	end

	local function var18_6(arg0_13, arg1_13, arg2_13)
		setActive(arg0_13:Find("result/mvpBG"), arg1_13 == arg2_13)
	end

	local function var19_6(arg0_14, arg1_14, arg2_14, arg3_14)
		UIItemList.StaticAlign(arg0_14, arg0_14:GetChild(0), #arg1_14, function(arg0_15, arg1_15, arg2_15)
			if arg0_15 ~= UIItemList.EventUpdate then
				return
			end

			local var0_15 = arg1_14[arg1_15 + 1]
			local var1_15 = arg2_14[var0_15.id]

			setActive(arg2_15:Find("result/Exp"), true)
			setActive(arg2_15:Find("result/Statistics"), false)
			var18_6(arg2_15, var0_15.id, arg3_14)

			local var2_15 = arg0_6:findTF("result/mask/icon", arg2_15)
			local var3_15 = arg0_6:findTF("result/type", arg2_15)
			local var4_15 = GetSpriteFromAtlas("shiptype", shipType2print(var1_15:getShipType()))

			setImageSprite(var3_15, var4_15, true)
			setImageSprite(var2_15, LoadSprite("herohrzicon/" .. var1_15:getPainting()))

			local var5_15 = findTF(arg2_15, "result/stars")
			local var6_15 = findTF(arg2_15, "result/stars/star_tpl")
			local var7_15 = var1_15:getStar()
			local var8_15 = var1_15:getMaxStar()

			UIItemList.StaticAlign(var5_15, var6_15, var8_15, function(arg0_16, arg1_16, arg2_16)
				if arg0_16 ~= UIItemList.EventUpdate then
					return
				end

				local var0_16 = var8_15 - arg1_16

				SetActive(arg2_16:Find("empty"), var0_16 > var7_15)
				SetActive(arg2_16:Find("star"), var0_16 <= var7_15)
			end)
			setText(arg2_15:Find("result/Exp/Level"), "Lv." .. var0_15.level)
			setText(arg2_15:Find("result/Exp/name"), var0_15:getName())

			local var9_15 = arg2_15:Find("result/Exp/exp_text")
			local var10_15 = var1_15:getConfig("rarity")

			if var1_15.level < var0_15.level then
				local var11_15 = 0

				for iter0_15 = var1_15.level, var0_15.level - 1 do
					var11_15 = var11_15 + getExpByRarityFromLv1(var10_15, iter0_15)
				end

				setText(var9_15, "+" .. var11_15 + var0_15:getExp() - var1_15:getExp())
			else
				setText(var9_15, "+" .. (var1_15.expAdd or 0))
			end

			local var12_15 = arg0_6:findTF("result/Progress/progress_bar", arg2_15)
			local var13_15 = var0_15:getExp() / getExpByRarityFromLv1(var10_15, var0_15.level)

			var12_15:GetComponent(typeof(Image)).fillAmount = var13_15
		end)
	end

	local function var20_6(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
		arg4_17 = arg4_17 and arg4_17.statistics

		local var0_17 = 0

		if not arg4_17 then
			var0_17 = 10000
		elseif arg3_17 == 0 then
			var0_17 = 0

			for iter0_17, iter1_17 in pairs(arg2_17) do
				var0_17 = math.max(arg4_17[iter1_17.id].output, var0_17)
			end
		elseif arg3_17 > 0 then
			var0_17 = arg4_17[arg3_17].output
		end

		UIItemList.StaticAlign(arg0_17, arg0_17:GetChild(0), #arg1_17, function(arg0_18, arg1_18, arg2_18)
			if arg0_18 ~= UIItemList.EventUpdate then
				return
			end

			local var0_18 = arg1_17[arg1_18 + 1]
			local var1_18 = arg2_17[var0_18.id]

			setActive(arg2_18:Find("result/Statistics"), true)
			setActive(arg2_18:Find("result/Exp"), false)
			var18_6(arg2_18, var0_18.id, arg3_17)

			local var2_18 = arg0_6:findTF("result/mask/icon", arg2_18)
			local var3_18 = arg0_6:findTF("result/type", arg2_18)
			local var4_18 = GetSpriteFromAtlas("shiptype", shipType2print(var1_18:getShipType()))

			setImageSprite(var3_18, var4_18, true)
			setImageSprite(var2_18, LoadSprite("herohrzicon/" .. var1_18:getPainting()))

			local var5_18 = findTF(arg2_18, "result/stars")
			local var6_18 = findTF(arg2_18, "result/stars/star_tpl")
			local var7_18 = var1_18:getStar()
			local var8_18 = var1_18:getMaxStar()

			UIItemList.StaticAlign(var5_18, var6_18, var8_18, function(arg0_19, arg1_19, arg2_19)
				if arg0_19 ~= UIItemList.EventUpdate then
					return
				end

				local var0_19 = var8_18 - arg1_19

				SetActive(arg2_19:Find("empty"), var0_19 > var7_18)
				SetActive(arg2_19:Find("star"), var0_19 <= var7_18)
			end)

			local var9_18 = arg4_17 and arg4_17[var1_18.id].output or 0
			local var10_18 = arg4_17 and arg4_17[var1_18.id].kill_count or 0
			local var11_18 = arg0_6:findTF("result/Statistics/atk", arg2_18)

			setText(var11_18, 0)
			setText(var11_18, var9_18)

			local var12_18 = arg0_6:findTF("result/Statistics/killCount", arg2_18)

			setText(var12_18, 0)
			setText(var12_18, var10_18)

			local var13_18 = arg0_6:findTF("result/Progress/progress_bar", arg2_18)

			var13_18:GetComponent(typeof(Image)).fillAmount = 0

			local var14_18 = var9_18 / var0_17

			var13_18:GetComponent(typeof(Image)).fillAmount = var14_18
		end)
	end

	local function var21_6(arg0_20, arg1_20, arg2_20, arg3_20)
		arg2_20 = arg2_20 and arg2_20.statistics

		local var0_20 = arg0_20:Find("Title/Label")
		local var1_20 = arg0_20:Find("Title/Letter")
		local var2_20 = {
			"d",
			"c",
			"b",
			"a",
			"s"
		}
		local var3_20
		local var4_20
		local var5_20
		local var6_20
		local var7_20

		if arg2_20 then
			local var8_20 = var2_20[arg2_20._battleScore + 1]

			var6_20 = "letter_" .. var8_20
			var4_20 = "battlescore/battle_score_" .. var8_20 .. "/letter_" .. var8_20
			var7_20 = "label_" .. var8_20
			var5_20 = "battlescore/battle_score_" .. var8_20 .. "/label_" .. var8_20

			if arg2_20._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
				var7_20 = "label_flag_destroy"
				var5_20 = "battlescore/battle_score_c/label_flag_destroy"
			end
		else
			var6_20 = ""
			var7_20 = "label_none"
			var5_20 = "battlescore/grade_label_none"
		end

		eachChild(var0_20, function(arg0_21)
			setActive(arg0_21, arg0_21.name == var7_20)

			if arg0_21.name == var7_20 then
				arg0_6.loader:GetSprite(var5_20, "", arg0_21)
			end
		end)
		eachChild(var1_20, function(arg0_22)
			setActive(arg0_22, arg0_22.name == var6_20)

			if arg0_22.name == var6_20 then
				arg0_6.loader:GetSprite(var4_20, "", arg0_22)
			end
		end)

		local var9_20 = 0
		local var10_20 = not arg2_20 and 3 or arg2_20._battleScore > ys.Battle.BattleConst.BattleScore.C and 1 or 2
		local var11_20 = var1_0[var10_20]

		arg0_6.loader:GetSprite(arg0_6:GetAtalsName(), var11_20, arg0_20:Find("Title"))

		local var12_20 = var2_0[var10_20]

		setImageColor(arg0_20:Find("BG"), SummerFeastScene.TransformColor(var12_20))

		local var13_20 = pg.expedition_data_template[var4_6[arg3_20]]

		setText(arg0_20:Find("Title/Name"), var13_20.name)
		setText(arg0_20:Find("BG/FleetName/Text"), i18n("series_enemy_fleet_prefix", GetRomanDigit(arg1_20.index)))
		var17_6(arg0_20:Find("BG/commanderExp/commander_container"), arg1_20.oldCmds, arg1_20.cmds)
	end

	local function var22_6()
		local var0_23 = var16_6 == 1 and var9_6 or var8_6

		UIItemList.StaticAlign(arg0_6.resultList, arg0_6.resultList:GetChild(0), #var0_23, function(arg0_24, arg1_24, arg2_24)
			if arg0_24 ~= UIItemList.EventUpdate then
				return
			end

			local var0_24 = var0_23[arg1_24 + 1]
			local var1_24 = var1_6[var0_24.index]

			var21_6(arg2_24, var0_24, var1_24, var0_24.index)
			var19_6(arg2_24:Find("BG/Ships"), var0_24.ships, var0_24.oldShips, var0_24.mvp)
		end)
	end

	local function var23_6()
		local var0_25 = var16_6 == 1 and var9_6 or var8_6

		UIItemList.StaticAlign(arg0_6.resultList, arg0_6.resultList:GetChild(0), #var0_25, function(arg0_26, arg1_26, arg2_26)
			if arg0_26 ~= UIItemList.EventUpdate then
				return
			end

			local var0_26 = var0_25[arg1_26 + 1]
			local var1_26 = var1_6[var0_26.index]

			var21_6(arg2_26, var0_26, var1_26, var0_26.index)
			var20_6(arg2_26:Find("BG/Ships"), var0_26.ships, var0_26.oldShips, var0_26.mvp, var1_26)
		end)
	end

	local var24_6 = arg0_6.rightBottomPanel:Find("submarine")
	local var25_6 = arg0_6.rightBottomPanel:Find("main")

	setActive(var24_6, #var9_6 > 0)

	local function var26_6()
		setActive(var25_6, var16_6 == 1)
		setActive(var24_6, var16_6 == 0 and #var9_6 > 0)

		if var15_6 == 0 then
			var22_6()
		elseif var15_6 == 1 then
			var23_6()
		end
	end

	var26_6()
	;(function()
		local var0_28 = getProxy(PlayerProxy):getRawData()
		local var1_28 = _.reduce(var2_6, 0, function(arg0_29, arg1_29)
			return arg0_29 + arg1_29.playerExp.addExp
		end)

		setText(arg0_6._tf:Find("main/Series/playerExp/name_text"), var0_28.name)
		setText(arg0_6._tf:Find("main/Series/playerExp/lv_text"), "Lv." .. var0_28.level)
		setText(arg0_6._tf:Find("main/Series/playerExp/exp_text"), "+" .. var1_28)

		local var2_28 = arg0_6._tf:Find("main/Series/playerExp/exp_progress")
		local var3_28 = getConfigFromLevel1(pg.user_level, var0_28.level)

		var2_28:GetComponent(typeof(Image)).fillAmount = var0_28.exp / var3_28.exp_interval
	end)()
	onButton(arg0_6, arg0_6.rightBottomPanel:Find("statisticsBtn"), function()
		var15_6 = 1 - var15_6

		var26_6()
	end, SFX_PANEL)
	onButton(arg0_6, var24_6, function()
		var16_6 = 1

		var26_6()
	end, SFX_PANEL)
	onButton(arg0_6, var25_6, function()
		var16_6 = 0

		var26_6()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rightBottomPanel:Find("confirmBtn"), function()
		arg0_6:emit(BossRushBattleResultMediator.ON_SETTLE)
	end, SFX_PANEL)

	local var27_6 = arg0_6._tf:Find("main/Series/ArrowLeft")
	local var28_6 = arg0_6._tf:Find("main/Series/ArrowRight")

	Canvas.ForceUpdateCanvases()

	if arg0_6.resultScroll.rect.width >= arg0_6.resultList.rect.width then
		setActive(var27_6, false)
		setActive(var28_6, false)
	else
		setActive(var27_6, false)
		setActive(var28_6, true)
		onScroll(arg0_6, arg0_6.resultScroll, function(arg0_34)
			setActive(var27_6, arg0_34.x > 0.01)
			setActive(var28_6, arg0_34.x < 0.99)
		end)
	end
end

function var0_0.HideConfirmPanel(arg0_35)
	setActive(arg0_35.rightBottomPanel:Find("confirmBtn"), false)
end

function var0_0.onBackPressed(arg0_36)
	triggerButton(arg0_36.rightBottomPanel:Find("confirmBtn"))
end

function var0_0.willExit(arg0_37)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_37._tf)
	arg0_37.loader:Clear()
end

return var0_0
