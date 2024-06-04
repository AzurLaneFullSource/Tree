local var0 = class("LevelEliteFleetPanel", import("..base.BasePanel"))
local var1 = {
	vanguard = 1,
	submarine = 3,
	main = 2
}

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.tfShipTpl = arg0:findTF("panel/shiptpl")
	arg0.tfEmptyTpl = arg0:findTF("panel/emptytpl")
	arg0.tfFleets = {
		[FleetType.Normal] = {
			arg0:findTF("panel/fleet/1"),
			arg0:findTF("panel/fleet/2")
		},
		[FleetType.Submarine] = {
			arg0:findTF("panel/sub/1")
		}
	}
	arg0.tfLimit = arg0:findTF("panel/limit")
	arg0.tfLimitTips = arg0:findTF("panel/limit_tip")
	arg0.tfLimitElite = arg0:findTF("panel/limit_elite")
	arg0.tfLimitContainer = arg0:findTF("panel/limit_elite/limit_list")
	arg0.tfLimitTpl = arg0:findTF("panel/limit_elite/condition")
	arg0.btnBack = arg0:findTF("panel/btnBack")
	arg0.btnGo = arg0:findTF("panel/start_button")
	arg0.btnAdHelp = arg0:findTF("panel/title/ADvalue/helpbtn")
	arg0.commanderBtn = arg0:findTF("panel/commander_btn")
	arg0.toggleMask = arg0:findTF("mask")

	setActive(arg0.tfShipTpl, false)
	setActive(arg0.tfEmptyTpl, false)
	setActive(arg0.tfLimitTpl, false)
	setActive(arg0.toggleMask, false)

	arg0.onConfirm = nil
	arg0.onCancel = nil
	arg0.onClick = nil
	arg0.onLongPressed = nil
	arg0.onEliteClear = nil
	arg0.onEliteRecommend = nil
end

function var0.set(arg0, arg1)
	arg0.chapter = arg1
	arg0.propetyLimitation = arg0.chapter:getConfig("property_limitation")
	arg0.eliteFleetList = arg0.chapter:getEliteFleetList()
	arg0.chapterADValue = arg0.chapter:getConfig("air_dominance")
	arg0.suggestionValue = math.max(arg0.chapter:getConfig("best_air_dominance"), 150)
	arg0.eliteCommanderList = arg0.chapter:getEliteFleetCommanders()
	arg0.typeLimitations = arg0.chapter:getConfig("limitation")

	onButton(arg0, arg0.btnGo, function()
		if arg0.onConfirm then
			arg0.onConfirm()
		end
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0, arg0.btnAdHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(arg0, arg0.btnBack, function()
		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf, function()
		if arg0.onCancel then
			arg0.onCancel()
		end
	end, SFX_CANCEL)
	onToggle(arg0, arg0.commanderBtn, function(arg0)
		arg0.parent.contextData.EditingCommander = arg0

		arg0:flush()
	end, SFX_PANEL)
	triggerToggle(arg0.commanderBtn, arg0.parent.contextData.EditingCommander)
	setActive(arg0.commanderBtn, arg0.parent.openedCommanerSystem)
	arg0:flush()
end

function var0.clear(arg0)
	triggerToggle(arg0.commanderBtn, false)
end

function var0.flush(arg0)
	arg0:updateLimit()

	if OPEN_AIR_DOMINANCE and arg0.chapterADValue > 0 then
		setActive(arg0:findTF("panel/title/ADvalue"), true)
		arg0:updateFleetPanelADValue()
	else
		setActive(arg0:findTF("panel/title/ADvalue"), false)
	end

	arg0:updateFleets()
end

function var0.updateLimit(arg0)
	setActive(arg0.toggleMask, false)
	setActive(arg0.tfLimit, false)
	setActive(arg0.tfLimitTips, #arg0.propetyLimitation == 0)
	setActive(arg0.tfLimitElite, #arg0.propetyLimitation > 0)
	removeAllChildren(arg0.tfLimitContainer)

	if #arg0.propetyLimitation > 0 then
		local var0, var1 = arg0.chapter:IsPropertyLimitationSatisfy()

		for iter0, iter1 in ipairs(arg0.propetyLimitation) do
			local var2, var3, var4, var5 = unpack(iter1)
			local var6 = cloneTplTo(arg0.tfLimitTpl, arg0.tfLimitContainer)

			if var0[iter0] == 1 then
				arg0:findTF("Text", var6):GetComponent(typeof(Text)).color = Color.New(1, 0.96078431372549, 0.501960784313725)
			else
				arg0:findTF("Text", var6):GetComponent(typeof(Text)).color = Color.New(0.956862745098039, 0.301960784313725, 0.301960784313725)
			end

			setActive(var6, true)

			local var7 = (AttributeType.EliteCondition2Name(var2, var5) .. AttributeType.eliteConditionCompareTip(var3) .. var4) .. "（" .. var1[var2] .. "）"

			setText(arg0:findTF("Text", var6), var7)
		end

		setActive(arg0.tfLimitElite:Find("sub"), arg0.chapter:getConfig("submarine_num") > 0)
	end
end

function var0.updateFleetPanelADValue(arg0)
	local var0 = getProxy(BayProxy)
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.eliteFleetList) do
		local var2 = {}

		for iter2, iter3 in pairs(arg0.eliteCommanderList[iter0]) do
			var2[iter2] = getProxy(CommanderProxy):getCommanderById(iter3)
		end

		for iter4, iter5 in ipairs(iter1) do
			var1 = var1 + calcAirDominanceValue(var0:getShipById(iter5), var2)
		end
	end

	local var3 = math.floor(var1)
	local var4 = arg0:findTF("panel/title/ADvalue/Text")

	setText(var4, i18n("level_scene_title_word_5"))
	setText(arg0:findTF("Num1", var4), setColorStr(var3, var3 < arg0.suggestionValue and "#f1dc36" or COLOR_WHITE))
	setText(arg0:findTF("Num2", var4), arg0.suggestionValue)
end

function var0.initAddButton(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0.eliteFleetList[arg4]
	local var1 = {}
	local var2 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[arg0.parent.shipVOs[iter1]] = true

		if arg2 == arg0.parent.shipVOs[iter1]:getTeamType() then
			table.insert(var2, iter1)
		end
	end

	local var3 = findTF(arg1, arg2)

	removeAllChildren(var3)

	local var4 = 0
	local var5 = false
	local var6 = 0

	arg3 = Clone(arg3)

	table.sort(arg3, function(arg0, arg1)
		local var0 = type(arg0)
		local var1 = type(arg1)

		if var0 == var1 then
			return var1 < var0
		elseif arg1 == 0 or var1 == "string" and arg0 ~= 0 then
			return true
		else
			return false
		end
	end)

	local var7 = {}
	local var8 = {}

	for iter2 = 1, 3 do
		local var9
		local var10
		local var11
		local var12 = var2[iter2] and arg0.parent.shipVOs[var2[iter2]] or nil

		if var12 then
			for iter3, iter4 in ipairs(arg3) do
				if ShipType.ContainInLimitBundle(iter4, var12:getShipType()) then
					var10 = var12
					var11 = iter4

					table.remove(arg3, iter3)
					table.insert(var7, iter3)

					var5 = var5 or iter4 ~= 0

					break
				end
			end
		else
			var11 = arg3[1]

			table.remove(arg3, 1)
			table.insert(var7, 1)
		end

		if var11 == 0 then
			var6 = var6 + 1
		end

		local var13 = var10 and cloneTplTo(arg0.tfShipTpl, var3) or cloneTplTo(arg0.tfEmptyTpl, var3)

		table.insert(var8, var13)
		setActive(var13, true)

		if var10 then
			updateShip(var13, var10)
			setActive(arg0:findTF("event_block", var13), var10:getFlag("inEvent"))

			var1[var10] = true
		else
			var4 = var4 + 1
		end

		local var14 = findTF(var13, "icon_bg")

		setActive(arg0:findTF("ship_type", var13), true)

		if type(var11) == "number" then
			if var11 ~= 0 then
				local var15 = GetSpriteFromAtlas("shiptype", ShipType.Type2CNLabel(var11))

				setImageSprite(arg0:findTF("ship_type", var13), var15, true)
			else
				setActive(arg0:findTF("ship_type", var13), false)
			end
		elseif type(var11) == "string" then
			local var16 = GetSpriteFromAtlas("shiptype", ShipType.BundleType2CNLabel(var11))

			setImageSprite(arg0:findTF("ship_type", var13), var16, true)
		end

		setActive(arg0:findTF("ship_type", var13), not var10 and var11 ~= 0)

		local var17 = _.map(var0, function(arg0)
			return arg0.parent.shipVOs[arg0]
		end)

		table.sort(var17, function(arg0, arg1)
			return var1[arg0:getTeamType()] < var1[arg1:getTeamType()] or var1[arg0:getTeamType()] == var1[arg1:getTeamType()] and table.indexof(var0, arg0.id) < table.indexof(var0, arg1.id)
		end)

		local var18 = GetOrAddComponent(var14, typeof(UILongPressTrigger))

		var18.onReleased:RemoveAllListeners()
		var18.onLongPressed:RemoveAllListeners()
		var18.onReleased:AddListener(function()
			arg0.onClick({
				shipType = var11,
				fleet = var1,
				chapter = arg0.chapter,
				shipVO = var10,
				fleetIndex = arg4,
				teamType = arg2
			})
		end)
		var18.onLongPressed:AddListener(function()
			if not var10 then
				arg0.onClick({
					shipType = var11,
					fleet = var1,
					chapter = arg0.chapter,
					shipVO = var10,
					fleetIndex = arg4,
					teamType = arg2
				})
			else
				arg0.onLongPressed({
					shipId = var10.id,
					shipVOs = var17,
					chapter = arg0.chapter
				})
			end
		end)
	end

	for iter5 = 3, 1, -1 do
		var8[iter5]:SetSiblingIndex(var7[iter5] - 1)
	end

	if (var5 == true or var6 == 3) and var4 ~= 3 then
		return true
	else
		return false
	end
end

function var0.initCommander(arg0, arg1, arg2, arg3)
	local var0 = arg3:getEliteFleetCommanders()[arg1]

	for iter0 = 1, 2 do
		local var1 = var0[iter0]
		local var2

		if var1 then
			var2 = getProxy(CommanderProxy):getCommanderById(var1)
		end

		local var3 = arg2:Find("pos" .. iter0)
		local var4 = var3:Find("add")
		local var5 = var3:Find("info")

		setActive(var4, not var2)
		setActive(var5, var2)

		if var2 then
			local var6 = Commander.rarity2Frame(var2:getRarity())

			setImageSprite(var5:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2:getPainting(), "", var5:Find("mask/icon"))
		end

		local var7 = arg3:wrapEliteFleet(arg1)

		onButton(arg0, var4, function()
			arg0.parent:openCommanderPanel(var7, arg3.id, arg1)
		end, SFX_PANEL)
		onButton(arg0, var5, function()
			arg0.parent:openCommanderPanel(var7, arg3.id, arg1)
		end, SFX_PANEL)
	end
end

function var0.updateFleets(arg0)
	for iter0, iter1 in ipairs(arg0.tfFleets[FleetType.Normal]) do
		local var0 = arg0:findTF("btn_clear", iter1)
		local var1 = arg0:findTF("btn_recom", iter1)
		local var2 = arg0:findTF("btn_select", iter1)
		local var3 = arg0:findTF("blank", iter1)
		local var4 = arg0:findTF("commander", iter1)

		setActive(var2, false)
		setActive(findTF(iter1, "selected"), false)

		local var5 = iter0 <= arg0.chapter:getConfig("group_num")

		setActive(findTF(iter1, TeamType.Main), var5)
		setActive(findTF(iter1, TeamType.Vanguard), var5)
		setActive(var0, var5 and not arg0.contextData.EditingCommander)
		setActive(var1, var5 and not arg0.contextData.EditingCommander)
		setActive(var3, not var5)
		setActive(var4, var5 and arg0.contextData.EditingCommander)
		setText(arg0:findTF("bg/name", iter1), var5 and Fleet.DEFAULT_NAME[iter0] or "")

		if var5 then
			local var6 = arg0.typeLimitations[iter0]
			local var7 = var6[1]
			local var8 = var6[2]
			local var9 = arg0:initAddButton(iter1, TeamType.Main, var7, iter0)
			local var10 = arg0:initAddButton(iter1, TeamType.Vanguard, var8, iter0)

			arg0:initCommander(iter0, var4, arg0.chapter)

			if var9 and var10 then
				setActive(arg0:findTF("selected", iter1), true)
			end

			onButton(arg0, var0, function()
				if #arg0.eliteFleetList[iter0] ~= 0 then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("battle_preCombatLayer_clear_confirm"),
						onYes = function()
							arg0.onEliteClear({
								index = iter0,
								chapterVO = arg0.chapter
							})
						end
					})
				end
			end)
			onButton(arg0, var1, function()
				local var0 = #arg0.eliteFleetList[iter0]

				if var0 ~= 6 then
					if var0 ~= 0 then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("battle_preCombatLayer_auto_confirm"),
							onYes = function()
								arg0.onEliteRecommend({
									index = iter0,
									chapterVO = arg0.chapter
								})
							end
						})
					else
						arg0.onEliteRecommend({
							index = iter0,
							chapterVO = arg0.chapter
						})
					end
				end
			end)
		end
	end

	for iter2, iter3 in ipairs(arg0.tfFleets[FleetType.Submarine]) do
		local var11 = iter2 + 2
		local var12 = arg0:findTF("btn_clear", iter3)
		local var13 = arg0:findTF("btn_recom", iter3)
		local var14 = arg0:findTF("btn_select", iter3)
		local var15 = arg0:findTF("blank", iter3)
		local var16 = arg0:findTF("commander", iter3)

		setActive(var14, false)
		setActive(findTF(iter3, "selected"), false)
		setActive(findTF(iter3, TeamType.Submarine), iter2 <= arg0.chapter:getConfig("submarine_num"))
		setActive(var12, iter2 <= arg0.chapter:getConfig("submarine_num") and not arg0.contextData.EditingCommander)
		setActive(var13, iter2 <= arg0.chapter:getConfig("submarine_num") and not arg0.contextData.EditingCommander)
		setActive(var15, iter2 > arg0.chapter:getConfig("submarine_num"))
		setActive(var16, iter2 <= arg0.chapter:getConfig("submarine_num") and arg0.contextData.EditingCommander)
		setText(arg0:findTF("bg/name", iter3), iter2 <= arg0.chapter:getConfig("submarine_num") and Fleet.DEFAULT_NAME[Fleet.SUBMARINE_FLEET_ID + iter2 - 1] or "")
		arg0:initCommander(var11, var16, arg0.chapter)

		if iter2 <= arg0.chapter:getConfig("submarine_num") then
			if arg0:initAddButton(iter3, TeamType.Submarine, {
				0,
				0,
				0
			}, var11) then
				setActive(arg0:findTF("selected", iter3), true)
			end

			onButton(arg0, var12, function()
				if #arg0.eliteFleetList[var11] ~= 0 then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("battle_preCombatLayer_clear_confirm"),
						onYes = function()
							arg0.onEliteClear({
								index = var11,
								chapterVO = arg0.chapter
							})
						end
					})
				end
			end)
			onButton(arg0, var13, function()
				local var0 = #arg0.eliteFleetList[var11]

				if var0 ~= 3 then
					if var0 ~= 0 then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("battle_preCombatLayer_auto_confirm"),
							onYes = function()
								arg0.onEliteRecommend({
									index = var11,
									chapterVO = arg0.chapter
								})
							end
						})
					else
						arg0.onEliteRecommend({
							index = var11,
							chapterVO = arg0.chapter
						})
					end
				end
			end)
		end
	end
end

return var0
