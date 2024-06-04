local var0 = class("BossRushBattleResultLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "BattleResultBossRushUI"
end

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.loader = AutoLoader.New()
end

function var0.GetAtalsName(arg0)
	return "ui/battleresult_atlas"
end

function var0.preload(arg0, arg1)
	arg0.loader:LoadBundle(arg0:GetAtalsName())
	existCall(arg1)
end

function var0.init(arg0)
	local var0 = arg0._tf:Find("main/Series")

	arg0.resultScroll = var0:Find("Scroll")
	arg0.resultList = var0:Find("Scroll/List")
	arg0.playerExp = var0:Find("playerExp")
	arg0.rightBottomPanel = var0:Find("rightBottomPanel")

	setText(arg0.rightBottomPanel:Find("confirmBtn/Text"), i18n("text_confirm"))
	setText(arg0.resultList:Find("Result/BG/Ships/resulttpl/result/Statistics/kill_count_label"), i18n("battle_result_kill_count"))
	setText(arg0.resultList:Find("Result/BG/Ships/resulttpl/result/Statistics/dmg_count_label"), i18n("battle_result_dmg"))
	setText(arg0.resultList:Find("Result/BG/commanderExp/commander_container"):GetChild(0):Find("empty/add/Text"), i18n("series_enemy_empty_commander_main"))
	setText(arg0.resultList:Find("Result/BG/commanderExp/commander_container"):GetChild(1):Find("empty/add/Text"), i18n("series_enemy_empty_commander_assistant"))
end

local var1 = {
	"sucess_title_bg",
	"fail_title_bg",
	"none_title_bg"
}
local var2 = {
	"1216207f",
	"48160d7f",
	"3c3c3c7f"
}

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, true, {
		lockGlobalBlur = true,
		groupName = LayerWeightConst.GROUP_COMBAT
	})

	local var0 = arg0.contextData.seriesData
	local var1 = var0:GetBattleStatistics()
	local var2 = var0:GetFinalResults()
	local var3 = var0:GetFleets()
	local var4 = var0:GetExpeditionIds()
	local var5 = var3[#var3]
	local var6 = var5:getTeamByName(TeamType.Submarine)
	local var7 = var5:GetRawCommanderIds()
	local var8 = {}
	local var9 = {}

	for iter0 = 1, #var4 do
		local var10 = var3[iter0]

		if var0:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var10 = var3[1]
		end

		local var11 = var2[iter0]
		local var12 = {
			index = iter0,
			oldShips = {},
			ships = {},
			oldCmds = {},
			cmds = {},
			mvp = var11 and var11.mvp or 0
		}
		local var13 = Clone(var12)

		table.Foreach(var10:getShipIds(), function(arg0, arg1)
			if iter0 <= #var2 then
				local var0 = var11.newShips[arg1]

				if var0 then
					table.insert(var12.ships, var0)

					var12.oldShips[arg1] = var11.oldShips[arg1]
				end
			else
				local var1 = getProxy(BayProxy):getShipById(arg1)

				table.insert(var12.ships, var1)

				var12.oldShips[arg1] = var1
			end
		end)
		table.Foreach(var6, function(arg0, arg1)
			if iter0 <= #var2 then
				local var0 = var11.newShips[arg1]

				if var0 then
					table.insert(var13.ships, var0)

					var13.oldShips[arg1] = var11.oldShips[arg1]
				end
			end
		end)

		local var14 = var10:GetRawCommanderIds()

		_.each({
			1,
			2
		}, function(arg0)
			local var0 = var14[arg0] or false

			if var0 then
				if iter0 <= #var2 then
					local var1 = var11.newCmds[var0]

					if var1 then
						table.insert(var12.cmds, var1)

						var12.oldCmds[var0] = var11.oldCmds[var0]
					end
				else
					local var2 = getProxy(CommanderProxy):getCommanderById(var0)

					table.insert(var12.cmds, var2)

					var12.oldCmds[var0] = var2
				end
			else
				table.insert(var12.cmds, false)
			end
		end)
		_.each({
			1,
			2
		}, function(arg0)
			local var0 = var7[arg0] or false

			if iter0 <= #var2 then
				if var0 then
					local var1 = var11.newCmds[var0]

					if var1 then
						table.insert(var13.cmds, var1)

						var13.oldCmds[var1.id] = var11.oldCmds[var0]
					else
						table.insert(var13.cmds, false)
					end
				else
					table.insert(var13.cmds, false)
				end
			end
		end)

		var8[iter0] = var12

		if next(var13.ships) then
			table.insert(var9, var13)
		end
	end

	local var15 = 0
	local var16 = 0

	local function var17(arg0, arg1, arg2)
		UIItemList.StaticAlign(arg0, arg0:GetChild(0), 2, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = arg2[arg1 + 1]
			local var1 = not var0

			setActive(arg2:Find("empty"), var1)
			setActive(arg2:Find("exp"), not var1)

			if var1 then
				return
			end

			local var2 = arg1[var0.id]
			local var3 = var0.exp

			GetImageSpriteFromAtlasAsync("commandericon/" .. var0:getPainting(), "", arg2:Find("exp/icon"))
			setText(arg2:Find("exp/name_text"), var0:getName())
			setText(arg2:Find("exp/lv_text"), "Lv." .. var0.level)

			local var4 = math.max(0, var2.expAdd or 0)

			setText(arg2:Find("exp/exp_text"), "+" .. var4)

			local var5
			local var6 = var0:isMaxLevel() and 1 or var3 / var0:getNextLevelExp()

			arg2:Find("exp/exp_progress"):GetComponent(typeof(Image)).fillAmount = var6
		end)
	end

	local function var18(arg0, arg1, arg2)
		setActive(arg0:Find("result/mvpBG"), arg1 == arg2)
	end

	local function var19(arg0, arg1, arg2, arg3)
		UIItemList.StaticAlign(arg0, arg0:GetChild(0), #arg1, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = arg1[arg1 + 1]
			local var1 = arg2[var0.id]

			setActive(arg2:Find("result/Exp"), true)
			setActive(arg2:Find("result/Statistics"), false)
			var18(arg2, var0.id, arg3)

			local var2 = arg0:findTF("result/mask/icon", arg2)
			local var3 = arg0:findTF("result/type", arg2)
			local var4 = GetSpriteFromAtlas("shiptype", shipType2print(var1:getShipType()))

			setImageSprite(var3, var4, true)
			setImageSprite(var2, LoadSprite("herohrzicon/" .. var1:getPainting()))

			local var5 = findTF(arg2, "result/stars")
			local var6 = findTF(arg2, "result/stars/star_tpl")
			local var7 = var1:getStar()
			local var8 = var1:getMaxStar()

			UIItemList.StaticAlign(var5, var6, var8, function(arg0, arg1, arg2)
				if arg0 ~= UIItemList.EventUpdate then
					return
				end

				local var0 = var8 - arg1

				SetActive(arg2:Find("empty"), var0 > var7)
				SetActive(arg2:Find("star"), var0 <= var7)
			end)
			setText(arg2:Find("result/Exp/Level"), "Lv." .. var0.level)
			setText(arg2:Find("result/Exp/name"), var0:getName())

			local var9 = arg2:Find("result/Exp/exp_text")
			local var10 = var1:getConfig("rarity")

			if var1.level < var0.level then
				local var11 = 0

				for iter0 = var1.level, var0.level - 1 do
					var11 = var11 + getExpByRarityFromLv1(var10, iter0)
				end

				setText(var9, "+" .. var11 + var0:getExp() - var1:getExp())
			else
				setText(var9, "+" .. (var1.expAdd or 0))
			end

			local var12 = arg0:findTF("result/Progress/progress_bar", arg2)
			local var13 = var0:getExp() / getExpByRarityFromLv1(var10, var0.level)

			var12:GetComponent(typeof(Image)).fillAmount = var13
		end)
	end

	local function var20(arg0, arg1, arg2, arg3, arg4)
		arg4 = arg4 and arg4.statistics

		local var0 = 0

		if not arg4 then
			var0 = 10000
		elseif arg3 == 0 then
			var0 = 0

			for iter0, iter1 in pairs(arg2) do
				var0 = math.max(arg4[iter1.id].output, var0)
			end
		elseif arg3 > 0 then
			var0 = arg4[arg3].output
		end

		UIItemList.StaticAlign(arg0, arg0:GetChild(0), #arg1, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = arg1[arg1 + 1]
			local var1 = arg2[var0.id]

			setActive(arg2:Find("result/Statistics"), true)
			setActive(arg2:Find("result/Exp"), false)
			var18(arg2, var0.id, arg3)

			local var2 = arg0:findTF("result/mask/icon", arg2)
			local var3 = arg0:findTF("result/type", arg2)
			local var4 = GetSpriteFromAtlas("shiptype", shipType2print(var1:getShipType()))

			setImageSprite(var3, var4, true)
			setImageSprite(var2, LoadSprite("herohrzicon/" .. var1:getPainting()))

			local var5 = findTF(arg2, "result/stars")
			local var6 = findTF(arg2, "result/stars/star_tpl")
			local var7 = var1:getStar()
			local var8 = var1:getMaxStar()

			UIItemList.StaticAlign(var5, var6, var8, function(arg0, arg1, arg2)
				if arg0 ~= UIItemList.EventUpdate then
					return
				end

				local var0 = var8 - arg1

				SetActive(arg2:Find("empty"), var0 > var7)
				SetActive(arg2:Find("star"), var0 <= var7)
			end)

			local var9 = arg4 and arg4[var1.id].output or 0
			local var10 = arg4 and arg4[var1.id].kill_count or 0
			local var11 = arg0:findTF("result/Statistics/atk", arg2)

			setText(var11, 0)
			setText(var11, var9)

			local var12 = arg0:findTF("result/Statistics/killCount", arg2)

			setText(var12, 0)
			setText(var12, var10)

			local var13 = arg0:findTF("result/Progress/progress_bar", arg2)

			var13:GetComponent(typeof(Image)).fillAmount = 0

			local var14 = var9 / var0

			var13:GetComponent(typeof(Image)).fillAmount = var14
		end)
	end

	local function var21(arg0, arg1, arg2, arg3)
		arg2 = arg2 and arg2.statistics

		local var0 = arg0:Find("Title/Label")
		local var1 = arg0:Find("Title/Letter")
		local var2 = {
			"d",
			"c",
			"b",
			"a",
			"s"
		}
		local var3
		local var4
		local var5
		local var6
		local var7

		if arg2 then
			local var8 = var2[arg2._battleScore + 1]

			var6 = "letter_" .. var8
			var4 = "battlescore/battle_score_" .. var8 .. "/letter_" .. var8
			var7 = "label_" .. var8
			var5 = "battlescore/battle_score_" .. var8 .. "/label_" .. var8

			if arg2._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
				var7 = "label_flag_destroy"
				var5 = "battlescore/battle_score_c/label_flag_destroy"
			end
		else
			var6 = ""
			var7 = "label_none"
			var5 = "battlescore/grade_label_none"
		end

		eachChild(var0, function(arg0)
			setActive(arg0, arg0.name == var7)

			if arg0.name == var7 then
				arg0.loader:GetSprite(var5, "", arg0)
			end
		end)
		eachChild(var1, function(arg0)
			setActive(arg0, arg0.name == var6)

			if arg0.name == var6 then
				arg0.loader:GetSprite(var4, "", arg0)
			end
		end)

		local var9 = 0
		local var10 = not arg2 and 3 or arg2._battleScore > ys.Battle.BattleConst.BattleScore.C and 1 or 2
		local var11 = var1[var10]

		arg0.loader:GetSprite(arg0:GetAtalsName(), var11, arg0:Find("Title"))

		local var12 = var2[var10]

		setImageColor(arg0:Find("BG"), SummerFeastScene.TransformColor(var12))

		local var13 = pg.expedition_data_template[var4[arg3]]

		setText(arg0:Find("Title/Name"), var13.name)
		setText(arg0:Find("BG/FleetName/Text"), i18n("series_enemy_fleet_prefix", GetRomanDigit(arg1.index)))
		var17(arg0:Find("BG/commanderExp/commander_container"), arg1.oldCmds, arg1.cmds)
	end

	local function var22()
		local var0 = var16 == 1 and var9 or var8

		UIItemList.StaticAlign(arg0.resultList, arg0.resultList:GetChild(0), #var0, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = var0[arg1 + 1]
			local var1 = var1[var0.index]

			var21(arg2, var0, var1, var0.index)
			var19(arg2:Find("BG/Ships"), var0.ships, var0.oldShips, var0.mvp)
		end)
	end

	local function var23()
		local var0 = var16 == 1 and var9 or var8

		UIItemList.StaticAlign(arg0.resultList, arg0.resultList:GetChild(0), #var0, function(arg0, arg1, arg2)
			if arg0 ~= UIItemList.EventUpdate then
				return
			end

			local var0 = var0[arg1 + 1]
			local var1 = var1[var0.index]

			var21(arg2, var0, var1, var0.index)
			var20(arg2:Find("BG/Ships"), var0.ships, var0.oldShips, var0.mvp, var1)
		end)
	end

	local var24 = arg0.rightBottomPanel:Find("submarine")
	local var25 = arg0.rightBottomPanel:Find("main")

	setActive(var24, #var9 > 0)

	local function var26()
		setActive(var25, var16 == 1)
		setActive(var24, var16 == 0 and #var9 > 0)

		if var15 == 0 then
			var22()
		elseif var15 == 1 then
			var23()
		end
	end

	var26()
	;(function()
		local var0 = getProxy(PlayerProxy):getRawData()
		local var1 = _.reduce(var2, 0, function(arg0, arg1)
			return arg0 + arg1.playerExp.addExp
		end)

		setText(arg0._tf:Find("main/Series/playerExp/name_text"), var0.name)
		setText(arg0._tf:Find("main/Series/playerExp/lv_text"), "Lv." .. var0.level)
		setText(arg0._tf:Find("main/Series/playerExp/exp_text"), "+" .. var1)

		local var2 = arg0._tf:Find("main/Series/playerExp/exp_progress")
		local var3 = getConfigFromLevel1(pg.user_level, var0.level)

		var2:GetComponent(typeof(Image)).fillAmount = var0.exp / var3.exp_interval
	end)()
	onButton(arg0, arg0.rightBottomPanel:Find("statisticsBtn"), function()
		var15 = 1 - var15

		var26()
	end, SFX_PANEL)
	onButton(arg0, var24, function()
		var16 = 1

		var26()
	end, SFX_PANEL)
	onButton(arg0, var25, function()
		var16 = 0

		var26()
	end, SFX_PANEL)
	onButton(arg0, arg0.rightBottomPanel:Find("confirmBtn"), function()
		arg0:emit(BossRushBattleResultMediator.ON_SETTLE)
	end, SFX_PANEL)

	local var27 = arg0._tf:Find("main/Series/ArrowLeft")
	local var28 = arg0._tf:Find("main/Series/ArrowRight")

	Canvas.ForceUpdateCanvases()

	if arg0.resultScroll.rect.width >= arg0.resultList.rect.width then
		setActive(var27, false)
		setActive(var28, false)
	else
		setActive(var27, false)
		setActive(var28, true)
		onScroll(arg0, arg0.resultScroll, function(arg0)
			setActive(var27, arg0.x > 0.01)
			setActive(var28, arg0.x < 0.99)
		end)
	end
end

function var0.HideConfirmPanel(arg0)
	setActive(arg0.rightBottomPanel:Find("confirmBtn"), false)
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.rightBottomPanel:Find("confirmBtn"))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0.loader:Clear()
end

return var0
