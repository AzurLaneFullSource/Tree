local var0_0 = class("LevelEliteFleetPanel", import("..base.BasePanel"))
local var1_0 = {
	vanguard = 1,
	submarine = 3,
	main = 2
}

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)

	arg0_1.tfShipTpl = arg0_1:findTF("panel/shiptpl")
	arg0_1.tfEmptyTpl = arg0_1:findTF("panel/emptytpl")
	arg0_1.tfFleets = {
		[FleetType.Normal] = {
			arg0_1:findTF("panel/fleet/1"),
			arg0_1:findTF("panel/fleet/2")
		},
		[FleetType.Submarine] = {
			arg0_1:findTF("panel/sub/1")
		}
	}
	arg0_1.tfLimit = arg0_1:findTF("panel/limit")
	arg0_1.tfLimitTips = arg0_1:findTF("panel/limit_tip")
	arg0_1.tfLimitElite = arg0_1:findTF("panel/limit_elite")
	arg0_1.tfLimitContainer = arg0_1:findTF("panel/limit_elite/limit_list")
	arg0_1.tfLimitTpl = arg0_1:findTF("panel/limit_elite/condition")
	arg0_1.btnBack = arg0_1:findTF("panel/btnBack")
	arg0_1.btnGo = arg0_1:findTF("panel/start_button")
	arg0_1.btnAdHelp = arg0_1:findTF("panel/title/ADvalue/helpbtn")
	arg0_1.commanderBtn = arg0_1:findTF("panel/commander_btn")
	arg0_1.toggleMask = arg0_1:findTF("mask")

	setActive(arg0_1.tfShipTpl, false)
	setActive(arg0_1.tfEmptyTpl, false)
	setActive(arg0_1.tfLimitTpl, false)
	setActive(arg0_1.toggleMask, false)

	arg0_1.onConfirm = nil
	arg0_1.onCancel = nil
	arg0_1.onClick = nil
	arg0_1.onLongPressed = nil
	arg0_1.onEliteClear = nil
	arg0_1.onEliteRecommend = nil
end

function var0_0.set(arg0_2, arg1_2)
	arg0_2.chapter = arg1_2
	arg0_2.propetyLimitation = arg0_2.chapter:getConfig("property_limitation")
	arg0_2.eliteFleetList = arg0_2.chapter:getEliteFleetList()
	arg0_2.chapterADValue = arg0_2.chapter:getConfig("air_dominance")
	arg0_2.suggestionValue = math.max(arg0_2.chapter:getConfig("best_air_dominance"), 150)
	arg0_2.eliteCommanderList = arg0_2.chapter:getEliteFleetCommanders()
	arg0_2.typeLimitations = arg0_2.chapter:getConfig("limitation")

	onButton(arg0_2, arg0_2.btnGo, function()
		if arg0_2.onConfirm then
			arg0_2.onConfirm()
		end
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_2, arg0_2.btnAdHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0_2, arg0_2.btnBack, function()
		if arg0_2.onCancel then
			arg0_2.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2._tf, function()
		if arg0_2.onCancel then
			arg0_2.onCancel()
		end
	end, SFX_CANCEL)
	onToggle(arg0_2, arg0_2.commanderBtn, function(arg0_7)
		arg0_2.parent.contextData.EditingCommander = arg0_7

		arg0_2:flush()
	end, SFX_PANEL)
	triggerToggle(arg0_2.commanderBtn, arg0_2.parent.contextData.EditingCommander)
	setActive(arg0_2.commanderBtn, arg0_2.parent.openedCommanerSystem)
	arg0_2:flush()
end

function var0_0.clear(arg0_8)
	triggerToggle(arg0_8.commanderBtn, false)
end

function var0_0.flush(arg0_9)
	arg0_9:updateLimit()

	if OPEN_AIR_DOMINANCE and arg0_9.chapterADValue > 0 then
		setActive(arg0_9:findTF("panel/title/ADvalue"), true)
		arg0_9:updateFleetPanelADValue()
	else
		setActive(arg0_9:findTF("panel/title/ADvalue"), false)
	end

	arg0_9:updateFleets()
end

function var0_0.updateLimit(arg0_10)
	setActive(arg0_10.toggleMask, false)
	setActive(arg0_10.tfLimit, false)
	setActive(arg0_10.tfLimitTips, #arg0_10.propetyLimitation == 0)
	setActive(arg0_10.tfLimitElite, #arg0_10.propetyLimitation > 0)
	removeAllChildren(arg0_10.tfLimitContainer)

	if #arg0_10.propetyLimitation > 0 then
		local var0_10, var1_10 = arg0_10.chapter:IsPropertyLimitationSatisfy()

		for iter0_10, iter1_10 in ipairs(arg0_10.propetyLimitation) do
			local var2_10, var3_10, var4_10, var5_10 = unpack(iter1_10)
			local var6_10 = cloneTplTo(arg0_10.tfLimitTpl, arg0_10.tfLimitContainer)

			if var0_10[iter0_10] == 1 then
				arg0_10:findTF("Text", var6_10):GetComponent(typeof(Text)).color = Color.New(1, 0.96078431372549, 0.501960784313725)
			else
				arg0_10:findTF("Text", var6_10):GetComponent(typeof(Text)).color = Color.New(0.956862745098039, 0.301960784313725, 0.301960784313725)
			end

			setActive(var6_10, true)

			local var7_10 = (AttributeType.EliteCondition2Name(var2_10, var5_10) .. AttributeType.eliteConditionCompareTip(var3_10) .. var4_10) .. "（" .. var1_10[var2_10] .. "）"

			setText(arg0_10:findTF("Text", var6_10), var7_10)
		end

		setActive(arg0_10.tfLimitElite:Find("sub"), arg0_10.chapter:getConfig("submarine_num") > 0)
	end
end

function var0_0.updateFleetPanelADValue(arg0_11)
	local var0_11 = getProxy(BayProxy)
	local var1_11 = 0

	for iter0_11, iter1_11 in ipairs(arg0_11.eliteFleetList) do
		local var2_11 = {}

		for iter2_11, iter3_11 in pairs(arg0_11.eliteCommanderList[iter0_11]) do
			var2_11[iter2_11] = getProxy(CommanderProxy):getCommanderById(iter3_11)
		end

		for iter4_11, iter5_11 in ipairs(iter1_11) do
			var1_11 = var1_11 + calcAirDominanceValue(var0_11:getShipById(iter5_11), var2_11)
		end
	end

	local var3_11 = math.floor(var1_11)
	local var4_11 = arg0_11:findTF("panel/title/ADvalue/Text")

	setText(var4_11, i18n("level_scene_title_word_5"))
	setText(arg0_11:findTF("Num1", var4_11), setColorStr(var3_11, var3_11 < arg0_11.suggestionValue and "#f1dc36" or COLOR_WHITE))
	setText(arg0_11:findTF("Num2", var4_11), arg0_11.suggestionValue)
end

function var0_0.initAddButton(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	local var0_12 = arg0_12.eliteFleetList[arg4_12]
	local var1_12 = {}
	local var2_12 = {}

	for iter0_12, iter1_12 in ipairs(var0_12) do
		var1_12[arg0_12.parent.shipVOs[iter1_12]] = true

		if arg2_12 == arg0_12.parent.shipVOs[iter1_12]:getTeamType() then
			table.insert(var2_12, iter1_12)
		end
	end

	local var3_12 = findTF(arg1_12, arg2_12)

	removeAllChildren(var3_12)

	local var4_12 = 0
	local var5_12 = false
	local var6_12 = 0

	arg3_12 = Clone(arg3_12)

	table.sort(arg3_12, function(arg0_13, arg1_13)
		local var0_13 = type(arg0_13)
		local var1_13 = type(arg1_13)

		if var0_13 == var1_13 then
			return var1_13 < var0_13
		elseif arg1_13 == 0 or var1_13 == "string" and arg0_13 ~= 0 then
			return true
		else
			return false
		end
	end)

	local var7_12 = {}
	local var8_12 = {}

	for iter2_12 = 1, 3 do
		local var9_12
		local var10_12
		local var11_12
		local var12_12 = var2_12[iter2_12] and arg0_12.parent.shipVOs[var2_12[iter2_12]] or nil

		if var12_12 then
			for iter3_12, iter4_12 in ipairs(arg3_12) do
				if ShipType.ContainInLimitBundle(iter4_12, var12_12:getShipType()) then
					var10_12 = var12_12
					var11_12 = iter4_12

					table.remove(arg3_12, iter3_12)
					table.insert(var7_12, iter3_12)

					var5_12 = var5_12 or iter4_12 ~= 0

					break
				end
			end
		else
			var11_12 = arg3_12[1]

			table.remove(arg3_12, 1)
			table.insert(var7_12, 1)
		end

		if var11_12 == 0 then
			var6_12 = var6_12 + 1
		end

		local var13_12 = var10_12 and cloneTplTo(arg0_12.tfShipTpl, var3_12) or cloneTplTo(arg0_12.tfEmptyTpl, var3_12)

		table.insert(var8_12, var13_12)
		setActive(var13_12, true)

		if var10_12 then
			updateShip(var13_12, var10_12)
			setActive(arg0_12:findTF("event_block", var13_12), var10_12:getFlag("inEvent"))

			var1_12[var10_12] = true
		else
			var4_12 = var4_12 + 1
		end

		local var14_12 = findTF(var13_12, "icon_bg")

		setActive(arg0_12:findTF("ship_type", var13_12), true)

		if type(var11_12) == "number" then
			if var11_12 ~= 0 then
				local var15_12 = GetSpriteFromAtlas("shiptype", ShipType.Type2CNLabel(var11_12))

				setImageSprite(arg0_12:findTF("ship_type", var13_12), var15_12, true)
			else
				setActive(arg0_12:findTF("ship_type", var13_12), false)
			end
		elseif type(var11_12) == "string" then
			local var16_12 = GetSpriteFromAtlas("shiptype", ShipType.BundleType2CNLabel(var11_12))

			setImageSprite(arg0_12:findTF("ship_type", var13_12), var16_12, true)
		end

		setActive(arg0_12:findTF("ship_type", var13_12), not var10_12 and var11_12 ~= 0)

		local var17_12 = _.map(var0_12, function(arg0_14)
			return arg0_12.parent.shipVOs[arg0_14]
		end)

		table.sort(var17_12, function(arg0_15, arg1_15)
			return var1_0[arg0_15:getTeamType()] < var1_0[arg1_15:getTeamType()] or var1_0[arg0_15:getTeamType()] == var1_0[arg1_15:getTeamType()] and table.indexof(var0_12, arg0_15.id) < table.indexof(var0_12, arg1_15.id)
		end)

		local var18_12 = GetOrAddComponent(var14_12, typeof(UILongPressTrigger))

		var18_12.onReleased:RemoveAllListeners()
		var18_12.onLongPressed:RemoveAllListeners()
		var18_12.onReleased:AddListener(function()
			arg0_12.onClick({
				shipType = var11_12,
				fleet = var1_12,
				chapter = arg0_12.chapter,
				shipVO = var10_12,
				fleetIndex = arg4_12,
				teamType = arg2_12
			})
		end)
		var18_12.onLongPressed:AddListener(function()
			if not var10_12 then
				arg0_12.onClick({
					shipType = var11_12,
					fleet = var1_12,
					chapter = arg0_12.chapter,
					shipVO = var10_12,
					fleetIndex = arg4_12,
					teamType = arg2_12
				})
			else
				arg0_12.onLongPressed({
					shipId = var10_12.id,
					shipVOs = var17_12,
					chapter = arg0_12.chapter
				})
			end
		end)
	end

	for iter5_12 = 3, 1, -1 do
		var8_12[iter5_12]:SetSiblingIndex(var7_12[iter5_12] - 1)
	end

	if (var5_12 == true or var6_12 == 3) and var4_12 ~= 3 then
		return true
	else
		return false
	end
end

function var0_0.initCommander(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg3_18:getEliteFleetCommanders()[arg1_18]

	for iter0_18 = 1, 2 do
		local var1_18 = var0_18[iter0_18]
		local var2_18

		if var1_18 then
			var2_18 = getProxy(CommanderProxy):getCommanderById(var1_18)
		end

		local var3_18 = arg2_18:Find("pos" .. iter0_18)
		local var4_18 = var3_18:Find("add")
		local var5_18 = var3_18:Find("info")

		setActive(var4_18, not var2_18)
		setActive(var5_18, var2_18)

		if var2_18 then
			local var6_18 = Commander.rarity2Frame(var2_18:getRarity())

			setImageSprite(var5_18:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6_18))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2_18:getPainting(), "", var5_18:Find("mask/icon"))
		end

		local var7_18 = arg3_18:wrapEliteFleet(arg1_18)

		onButton(arg0_18, var4_18, function()
			arg0_18.parent:openCommanderPanel(var7_18, arg3_18.id, arg1_18)
		end, SFX_PANEL)
		onButton(arg0_18, var5_18, function()
			arg0_18.parent:openCommanderPanel(var7_18, arg3_18.id, arg1_18)
		end, SFX_PANEL)
	end
end

function var0_0.updateFleets(arg0_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.tfFleets[FleetType.Normal]) do
		local var0_21 = arg0_21:findTF("btn_clear", iter1_21)
		local var1_21 = arg0_21:findTF("btn_recom", iter1_21)
		local var2_21 = arg0_21:findTF("btn_select", iter1_21)
		local var3_21 = arg0_21:findTF("blank", iter1_21)
		local var4_21 = arg0_21:findTF("commander", iter1_21)

		setActive(var2_21, false)
		setActive(findTF(iter1_21, "selected"), false)

		local var5_21 = iter0_21 <= arg0_21.chapter:getConfig("group_num")

		setActive(findTF(iter1_21, TeamType.Main), var5_21)
		setActive(findTF(iter1_21, TeamType.Vanguard), var5_21)
		setActive(var0_21, var5_21 and not arg0_21.contextData.EditingCommander)
		setActive(var1_21, var5_21 and not arg0_21.contextData.EditingCommander)
		setActive(var3_21, not var5_21)
		setActive(var4_21, var5_21 and arg0_21.contextData.EditingCommander)
		setText(arg0_21:findTF("bg/name", iter1_21), var5_21 and Fleet.DEFAULT_NAME[iter0_21] or "")

		if var5_21 then
			local var6_21 = arg0_21.typeLimitations[iter0_21]
			local var7_21 = var6_21[1]
			local var8_21 = var6_21[2]
			local var9_21 = arg0_21:initAddButton(iter1_21, TeamType.Main, var7_21, iter0_21)
			local var10_21 = arg0_21:initAddButton(iter1_21, TeamType.Vanguard, var8_21, iter0_21)

			arg0_21:initCommander(iter0_21, var4_21, arg0_21.chapter)

			if var9_21 and var10_21 then
				setActive(arg0_21:findTF("selected", iter1_21), true)
			end

			onButton(arg0_21, var0_21, function()
				if #arg0_21.eliteFleetList[iter0_21] ~= 0 then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("battle_preCombatLayer_clear_confirm"),
						onYes = function()
							arg0_21.onEliteClear({
								index = iter0_21,
								chapterVO = arg0_21.chapter
							})
						end
					})
				end
			end)
			onButton(arg0_21, var1_21, function()
				local var0_24 = #arg0_21.eliteFleetList[iter0_21]

				if var0_24 ~= 6 then
					if var0_24 ~= 0 then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("battle_preCombatLayer_auto_confirm"),
							onYes = function()
								arg0_21.onEliteRecommend({
									index = iter0_21,
									chapterVO = arg0_21.chapter
								})
							end
						})
					else
						arg0_21.onEliteRecommend({
							index = iter0_21,
							chapterVO = arg0_21.chapter
						})
					end
				end
			end)
		end
	end

	for iter2_21, iter3_21 in ipairs(arg0_21.tfFleets[FleetType.Submarine]) do
		local var11_21 = iter2_21 + 2
		local var12_21 = arg0_21:findTF("btn_clear", iter3_21)
		local var13_21 = arg0_21:findTF("btn_recom", iter3_21)
		local var14_21 = arg0_21:findTF("btn_select", iter3_21)
		local var15_21 = arg0_21:findTF("blank", iter3_21)
		local var16_21 = arg0_21:findTF("commander", iter3_21)

		setActive(var14_21, false)
		setActive(findTF(iter3_21, "selected"), false)
		setActive(findTF(iter3_21, TeamType.Submarine), iter2_21 <= arg0_21.chapter:getConfig("submarine_num"))
		setActive(var12_21, iter2_21 <= arg0_21.chapter:getConfig("submarine_num") and not arg0_21.contextData.EditingCommander)
		setActive(var13_21, iter2_21 <= arg0_21.chapter:getConfig("submarine_num") and not arg0_21.contextData.EditingCommander)
		setActive(var15_21, iter2_21 > arg0_21.chapter:getConfig("submarine_num"))
		setActive(var16_21, iter2_21 <= arg0_21.chapter:getConfig("submarine_num") and arg0_21.contextData.EditingCommander)
		setText(arg0_21:findTF("bg/name", iter3_21), iter2_21 <= arg0_21.chapter:getConfig("submarine_num") and Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID + iter2_21 - 1] or "")
		arg0_21:initCommander(var11_21, var16_21, arg0_21.chapter)

		if iter2_21 <= arg0_21.chapter:getConfig("submarine_num") then
			if arg0_21:initAddButton(iter3_21, TeamType.Submarine, {
				0,
				0,
				0
			}, var11_21) then
				setActive(arg0_21:findTF("selected", iter3_21), true)
			end

			onButton(arg0_21, var12_21, function()
				if #arg0_21.eliteFleetList[var11_21] ~= 0 then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("battle_preCombatLayer_clear_confirm"),
						onYes = function()
							arg0_21.onEliteClear({
								index = var11_21,
								chapterVO = arg0_21.chapter
							})
						end
					})
				end
			end)
			onButton(arg0_21, var13_21, function()
				local var0_28 = #arg0_21.eliteFleetList[var11_21]

				if var0_28 ~= 3 then
					if var0_28 ~= 0 then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("battle_preCombatLayer_auto_confirm"),
							onYes = function()
								arg0_21.onEliteRecommend({
									index = var11_21,
									chapterVO = arg0_21.chapter
								})
							end
						})
					else
						arg0_21.onEliteRecommend({
							index = var11_21,
							chapterVO = arg0_21.chapter
						})
					end
				end
			end)
		end
	end
end

return var0_0
