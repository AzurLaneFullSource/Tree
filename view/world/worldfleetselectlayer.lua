local var0_0 = class("WorldFleetSelectLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "WorldFleetSelect"
end

function var0_0.init(arg0_2)
	arg0_2.rtBg = arg0_2._tf:Find("bg")

	local var0_2 = nowWorld():GetRealm()

	eachChild(arg0_2.rtBg, function(arg0_3)
		setActive(arg0_3, arg0_3.name == tostring(var0_2))
	end)

	arg0_2.rtPanel = arg0_2._tf:Find("panel")
	arg0_2.rtShipTpl = arg0_2.rtPanel:Find("shiptpl")

	setActive(arg0_2.rtShipTpl, false)

	arg0_2.rtEmptyTpl = arg0_2.rtPanel:Find("emptytpl")

	setActive(arg0_2.rtEmptyTpl, false)

	arg0_2.rtScroll = arg0_2.rtPanel:Find("bg")
	arg0_2.rtContent = arg0_2.rtScroll:Find("content")
	arg0_2.rtFleets = {
		[FleetType.Normal] = arg0_2.rtContent:Find("fleet"),
		[FleetType.Submarine] = arg0_2.rtContent:Find("sub")
	}
	arg0_2.btnBack = arg0_2.rtPanel:Find("btnBack")
	arg0_2.btnGo = arg0_2.rtPanel:Find("start_button")
	arg0_2.commanderToggle = arg0_2.rtPanel:Find("commander_btn")
	arg0_2.formationToggle = arg0_2.rtPanel:Find("formation_btn")
	arg0_2.tfLimitTip = arg0_2.rtPanel:Find("limit_tip")

	setText(arg0_2.tfLimitTip:Find("Text"), i18n("world_fleet_choose"))

	arg0_2.tfLimitSub = arg0_2.rtPanel:Find("limit_world/limit_sub")

	setText(arg0_2.tfLimitSub:Find("Text"), i18n("ship_limit_notice"))

	arg0_2.tfLimitContainer = arg0_2.rtPanel:Find("limit_world/limit_list")
	arg0_2.tfLimitTpl = arg0_2.tfLimitContainer:Find("condition")

	arg0_2:buildCommanderPanel()
end

function var0_0.didEnter(arg0_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4.rtPanel)
	onButton(arg0_4, arg0_4.btnGo, function()
		local var0_5, var1_5 = arg0_4:CheckValid()

		if var0_5 then
			arg0_4:emit(WorldFleetSelectMediator.OnGO)
		else
			pg.TipsMgr.GetInstance():ShowTips(var1_5)
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnBack, function()
		arg0_4:closeView()
	end, SFX_CANCEL)

	local function var0_4(arg0_7)
		arg0_4.contextData.showCommander = arg0_7

		for iter0_7, iter1_7 in pairs(arg0_4.rtFleets) do
			for iter2_7 = 1, #arg0_4.contextData.fleets[iter0_7] do
				arg0_4:updateCommanderBtn(iter1_7:GetChild(iter2_7 - 1))
			end
		end
	end

	onToggle(arg0_4, arg0_4.commanderToggle, function(arg0_8)
		if arg0_8 then
			var0_4(arg0_8)
		end
	end, SFX_PANEL)
	onToggle(arg0_4, arg0_4.formationToggle, function(arg0_9)
		if arg0_9 then
			var0_4(not arg0_9)
		end
	end, SFX_PANEL)
	arg0_4:UpdateFleets()
	scrollTo(arg0_4.rtContent, nil, arg0_4.contextData.scrollY)

	arg0_4.contextData.showCommander = defaultValue(arg0_4.contextData.showCommander, true)

	triggerToggle(arg0_4.contextData.showCommander and arg0_4.commanderToggle or arg0_4.formationToggle, true)
	arg0_4:CheckWorldResetAward()
end

function var0_0.willExit(arg0_10)
	arg0_10.contextData.scrollY = GetComponent(arg0_10.rtContent, typeof(ScrollRect)).normalizedPosition.y

	pg.UIMgr.GetInstance():UnblurPanel(arg0_10.rtPanel, arg0_10._tf)
	arg0_10:destroyCommanderPanel()
end

function var0_0.onBackPressed(arg0_11)
	if arg0_11.levelCMDFormationView:isShowing() then
		arg0_11.levelCMDFormationView:ActionInvoke("Hide")
	else
		arg0_11:closeView()
	end
end

function var0_0.UpdateFleets(arg0_12)
	local var0_12 = arg0_12.contextData.fleets

	for iter0_12, iter1_12 in pairs(var0_12) do
		local var1_12 = arg0_12.rtFleets[iter0_12]
		local var2_12 = UIItemList.New(var1_12, var1_12:GetChild(0))

		var2_12:make(function(arg0_13, arg1_13, arg2_13)
			if arg0_13 == UIItemList.EventUpdate then
				arg0_12:UpdateFleet(arg2_13, iter0_12, arg1_13 + 1)
			end
		end)
		var2_12:align(#var0_12[iter0_12])
		setActive(var1_12, #var0_12[iter0_12] > 0)
	end

	arg0_12:updateEliteLimit()
end

function var0_0.IsPropertyLimitationSatisfy(arg0_14)
	local var0_14 = getProxy(BayProxy):getRawData()
	local var1_14 = pg.gameset.world_fleet_unlock_level.description
	local var2_14 = {}

	for iter0_14, iter1_14 in ipairs(var1_14) do
		var2_14[iter1_14[1]] = 0
	end

	local var3_14 = 0

	for iter2_14, iter3_14 in ipairs(arg0_14.contextData.fleets[FleetType.Normal]) do
		if arg0_14:GetTeamShipCount(iter3_14[TeamType.Main]) == 0 or arg0_14:GetTeamShipCount(iter3_14[TeamType.Vanguard]) == 0 then
			-- block empty
		else
			local var4_14 = {}
			local var5_14 = {}
			local var6_14 = 0

			for iter4_14, iter5_14 in ipairs(var1_14) do
				local var7_14, var8_14, var9_14, var10_14 = unpack(iter5_14)

				if string.sub(var7_14, 1, 5) == "fleet" then
					var4_14[var7_14] = 0
					var5_14[var7_14] = var10_14
				end
			end

			for iter6_14, iter7_14 in pairs(iter3_14) do
				for iter8_14 = 1, 3 do
					local var11_14 = iter7_14[iter8_14] and var0_14[iter7_14[iter8_14]]

					if var11_14 then
						var3_14 = var3_14 + 1
						var6_14 = var6_14 + 1

						local var12_14 = intProperties(var11_14:getProperties())

						for iter9_14, iter10_14 in pairs(var2_14) do
							if string.sub(iter9_14, 1, 5) == "fleet" then
								if iter9_14 == "fleet_totle_level" then
									var4_14[iter9_14] = var4_14[iter9_14] + var11_14.level
								end
							elseif iter9_14 == "level" then
								var2_14[iter9_14] = iter10_14 + var11_14.level
							else
								var2_14[iter9_14] = iter10_14 + var12_14[iter9_14]
							end
						end
					end
				end
			end

			for iter11_14, iter12_14 in pairs(var4_14) do
				if iter11_14 == "fleet_totle_level" and iter12_14 > var5_14[iter11_14] then
					var2_14[iter11_14] = var2_14[iter11_14] + 1
				end
			end
		end
	end

	local var13_14 = {}

	for iter13_14, iter14_14 in ipairs(var1_14) do
		local var14_14, var15_14, var16_14, var17_14 = unpack(iter14_14)

		if var14_14 == "level" and var3_14 > 0 then
			var2_14[var14_14] = math.ceil(var2_14[var14_14] / var3_14)
		end

		var13_14[iter13_14] = AttributeType.EliteConditionCompare(var15_14, var2_14[var14_14], var16_14) and 1 or 0
	end

	return var13_14, var2_14
end

function var0_0.updateEliteLimit(arg0_15)
	local var0_15 = pg.gameset.world_fleet_unlock_level.description

	if #var0_15 == 0 then
		return
	end

	local var1_15, var2_15 = arg0_15:IsPropertyLimitationSatisfy()
	local var3_15 = UIItemList.New(arg0_15.tfLimitContainer, arg0_15.tfLimitTpl)

	var3_15:make(function(arg0_16, arg1_16, arg2_16)
		arg1_16 = arg1_16 + 1

		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var0_15[arg1_16]
			local var1_16, var2_16, var3_16, var4_16 = unpack(var0_16)

			if var1_15[arg1_16] == 1 then
				arg2_16:Find("Text"):GetComponent(typeof(Text)).color = Color.New(1, 0.96078431372549, 0.501960784313725)
			else
				arg2_16:Find("Text"):GetComponent(typeof(Text)).color = Color.New(0.956862745098039, 0.301960784313725, 0.301960784313725)
			end

			local var5_16 = (AttributeType.EliteCondition2Name(var1_16, var4_16) .. AttributeType.eliteConditionCompareTip(var2_16) .. var3_16) .. "（" .. var2_15[var1_16] .. "）"

			setText(arg2_16:Find("Text"), var5_16)
		end
	end)
	var3_15:align(#var0_15)
end

function var0_0.updateCommanderBtn(arg0_17, arg1_17)
	local var0_17 = arg1_17:Find("btn_recom")
	local var1_17 = arg1_17:Find("btn_clear")
	local var2_17 = arg1_17:Find("commander")

	setActive(var0_17, not arg0_17.contextData.showCommander)
	setActive(var1_17, not arg0_17.contextData.showCommander)
	setActive(var2_17, arg0_17.contextData.showCommander)
end

function var0_0.UpdateFleet(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg1_18:Find("commander")

	arg0_18:updateCommanders(var0_18, arg2_18, arg3_18)

	local var1_18 = arg0_18.contextData.fleets[arg2_18][arg3_18]
	local var2_18 = (arg2_18 == FleetType.Submarine and 10 or 0) + arg3_18

	setText(arg1_18:Find("bg/name"), Fleet.DEFAULT_NAME[var2_18])

	if arg2_18 == FleetType.Normal then
		arg0_18:UpdateShips(arg1_18:Find(TeamType.Main), TeamType.Main, var1_18)
		arg0_18:UpdateShips(arg1_18:Find(TeamType.Vanguard), TeamType.Vanguard, var1_18)
		setActive(arg1_18:Find("selected"), arg0_18:GetTeamShipCount(var1_18[TeamType.Main]) > 0 and arg0_18:GetTeamShipCount(var1_18[TeamType.Vanguard]) > 0)
	elseif arg2_18 == FleetType.Submarine then
		arg0_18:UpdateShips(arg1_18:Find(TeamType.Submarine), TeamType.Submarine, var1_18)
		setActive(arg1_18:Find("selected"), arg0_18:GetTeamShipCount(var1_18[TeamType.Submarine]) > 0)
	end

	local var3_18 = arg1_18:Find("btn_recom")
	local var4_18 = arg1_18:Find("btn_clear")

	onButton(arg0_18, var3_18, function()
		arg0_18:RecommendFormation(arg2_18, arg3_18)
		arg0_18:UpdateFleet(arg1_18, arg2_18, arg3_18)
		arg0_18:updateEliteLimit()
	end, SFX_PANEL)
	onButton(arg0_18, var4_18, function()
		if arg0_18:GetTeamShipCount(var1_18[TeamType.Main]) > 0 or arg0_18:GetTeamShipCount(var1_18[TeamType.Vanguard]) > 0 or arg0_18:GetTeamShipCount(var1_18[TeamType.Submarine]) > 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("battle_preCombatLayer_clear_confirm"),
				onYes = function()
					var1_18[TeamType.Main] = {}
					var1_18[TeamType.Vanguard] = {}
					var1_18[TeamType.Submarine] = {}

					arg0_18:UpdateFleet(arg1_18, arg2_18, arg3_18)
					arg0_18:updateEliteLimit()
				end
			})
		end
	end, SFX_CANCEL)
end

function var0_0.updateCommanders(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = arg0_22.contextData.fleets[arg2_22][arg3_22]
	local var1_22 = Fleet.New({
		ship_list = {},
		commanders = var0_22.commanders
	})

	for iter0_22 = 1, 2 do
		local var2_22 = var1_22:getCommanderByPos(iter0_22)
		local var3_22 = arg1_22:Find("pos" .. iter0_22)
		local var4_22 = var3_22:Find("add")
		local var5_22 = var3_22:Find("info")

		setActive(var4_22, not var2_22)
		setActive(var5_22, var2_22)

		if var2_22 then
			local var6_22 = Commander.rarity2Frame(var2_22:getRarity())

			setImageSprite(var5_22:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6_22))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2_22:getPainting(), "", var5_22:Find("mask/icon"))
		else
			local var7_22 = 1

			while var0_22.commanders[var7_22] and var0_22.commanders[var7_22].pos ~= iter0_22 do
				var7_22 = var7_22 + 1
			end

			if var0_22.commanders[var7_22] then
				table.remove(var0_22.commanders, var7_22)
			end
		end

		onButton(arg0_22, var4_22, function()
			arg0_22:openCommanderPanel(var1_22, arg2_22, arg3_22)
		end, SFX_PANEL)
		onButton(arg0_22, var5_22, function()
			arg0_22:openCommanderPanel(var1_22, arg2_22, arg3_22)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateShips(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = getProxy(BayProxy)
	local var1_25 = arg3_25[arg2_25]
	local var2_25 = {}

	for iter0_25, iter1_25 in ipairs({
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}) do
		for iter2_25 = 1, 3 do
			local var3_25 = arg3_25[iter1_25][iter2_25] and var0_25:getShipById(arg3_25[iter1_25][iter2_25]) or nil

			table.insert(var2_25, var3_25)

			if not var3_25 then
				arg3_25[iter1_25][iter2_25] = nil
			end
		end
	end

	removeAllChildren(arg1_25)

	for iter3_25 = 1, 3 do
		local var4_25
		local var5_25

		if var1_25[iter3_25] then
			var4_25 = cloneTplTo(arg0_25.rtShipTpl, arg1_25, "ship_" .. var1_25[iter3_25])
			var5_25 = var0_25:getShipById(var1_25[iter3_25])

			updateShip(var4_25, var5_25)
		else
			var4_25 = cloneTplTo(arg0_25.rtEmptyTpl, arg1_25, "empty")

			setActive(var4_25:Find("ship_type"), false)
		end

		onButton(arg0_25, var4_25:Find("icon_bg"), function()
			arg0_25:emit(WorldFleetSelectMediator.OnSelectShip, arg2_25, var1_25, iter3_25)
		end, SFX_PANEL)

		local var6_25 = GetOrAddComponent(var4_25:Find("icon_bg"), typeof(UILongPressTrigger))

		pg.DelegateInfo.Add(arg0_25, var6_25.onLongPressed)
		var6_25.onLongPressed:RemoveAllListeners()
		var6_25.onLongPressed:AddListener(function()
			if not var5_25 then
				arg0_25:emit(WorldFleetSelectMediator.OnSelectShip, arg2_25, var1_25, iter3_25)
			else
				arg0_25:emit(WorldFleetSelectMediator.OnShipDetail, {
					shipId = var5_25.id,
					shipVOs = var2_25
				})
			end
		end)
	end
end

function var0_0.setCommanderPrefabs(arg0_28, arg1_28)
	arg0_28.commanderPrefabs = arg1_28
end

function var0_0.openCommanderPanel(arg0_29, arg1_29, arg2_29, arg3_29)
	arg0_29.levelCMDFormationView:setCallback(function(arg0_30)
		if arg0_30.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_29:emit(WorldFleetSelectMediator.OnCommanderSkill, arg0_30.skill)
		elseif arg0_30.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_29.contextData.eliteCommanderSelected = {
				fleetType = arg2_29,
				fleetIndex = arg3_29,
				pos = arg0_30.pos
			}

			arg0_29:emit(WorldFleetSelectMediator.OnSelectEliteCommander, arg2_29, arg3_29, arg0_30.pos)
			arg0_29:closeCommanderPanel()
		else
			arg0_29:emit(WorldFleetSelectMediator.OnCommanderFormationOp, {
				FleetType = LevelUIConst.FLEET_TYPE_WORLD,
				data = arg0_30,
				fleets = arg0_29.contextData.fleets,
				fleetType = arg2_29,
				fleetIndex = arg3_29
			})
		end
	end)
	arg0_29.levelCMDFormationView:Load()
	arg0_29.levelCMDFormationView:ActionInvoke("update", arg1_29, arg0_29.commanderPrefabs)
	arg0_29.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.closeCommanderPanel(arg0_31)
	arg0_31.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.updateCommanderFleet(arg0_32, arg1_32)
	if arg0_32.levelCMDFormationView:isShowing() then
		arg0_32.levelCMDFormationView:ActionInvoke("updateFleet", arg1_32)
	end
end

function var0_0.updateCommanderPrefab(arg0_33)
	if arg0_33.levelCMDFormationView:isShowing() then
		arg0_33.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_33.commanderPrefabs)
	end
end

function var0_0.buildCommanderPanel(arg0_34)
	arg0_34.levelCMDFormationView = LevelCMDFormationView.New(arg0_34._tf, arg0_34.event, arg0_34.contextData)
end

function var0_0.destroyCommanderPanel(arg0_35)
	arg0_35.levelCMDFormationView:Destroy()

	arg0_35.levelCMDFormationView = nil
end

function var0_0.CheckValid(arg0_36)
	for iter0_36, iter1_36 in pairs(arg0_36.contextData.fleets) do
		if iter0_36 == FleetType.Normal then
			for iter2_36, iter3_36 in ipairs(iter1_36) do
				if arg0_36:GetTeamShipCount(iter3_36[TeamType.Main]) == 0 or arg0_36:GetTeamShipCount(iter3_36[TeamType.Vanguard]) == 0 then
					return false, i18n("world_fleet_formation_not_valid", Fleet.DEFAULT_NAME[iter2_36])
				end
			end
		end
	end

	local var0_36, var1_36 = arg0_36:IsPropertyLimitationSatisfy()
	local var2_36 = 1

	for iter4_36, iter5_36 in ipairs(var0_36) do
		var2_36 = var2_36 * iter5_36
	end

	if var2_36 ~= 1 then
		return false, i18n("elite_disable_property_unsatisfied")
	end

	return true
end

function var0_0.GetTeamShipCount(arg0_37, arg1_37)
	local var0_37 = 0

	for iter0_37 = 1, 3 do
		if arg1_37[iter0_37] then
			var0_37 = var0_37 + 1
		end
	end

	return var0_37
end

function var0_0.RecommendFormation(arg0_38, arg1_38, arg2_38)
	local var0_38 = {
		[FleetType.Normal] = {
			TeamType.Main,
			TeamType.Vanguard
		},
		[FleetType.Submarine] = {
			TeamType.Submarine
		}
	}
	local var1_38 = {}

	for iter0_38, iter1_38 in pairs(arg0_38.contextData.fleets) do
		for iter2_38, iter3_38 in ipairs(iter1_38) do
			for iter4_38, iter5_38 in ipairs(var0_38[iter0_38]) do
				for iter6_38 = 1, 3 do
					local var2_38 = iter3_38[iter5_38][iter6_38]

					if var2_38 then
						table.insert(var1_38, var2_38)
					end
				end
			end
		end
	end

	local var3_38 = arg0_38.contextData.fleets[arg1_38][arg2_38]
	local var4_38 = getProxy(BayProxy)

	for iter7_38, iter8_38 in ipairs(var0_38[arg1_38]) do
		for iter9_38 = 1, 3 do
			if not var3_38[iter8_38][iter9_38] then
				local var5_38 = var4_38:getWorldRecommendShip(iter8_38, var1_38)

				if var5_38 then
					var3_38[iter8_38][iter9_38] = var5_38.id

					table.insert(var1_38, var5_38.id)
				end
			end
		end
	end
end

function var0_0.CheckWorldResetAward(arg0_39)
	local var0_39 = {}
	local var1_39 = nowWorld()
	local var2_39 = var1_39.resetAward

	if var2_39 and #var2_39 > 0 then
		local var3_39 = pg.gameset.world_resetting_story.description[1]

		if #var3_39 > 0 then
			table.insert(var0_39, function(arg0_40)
				pg.NewStoryMgr.GetInstance():Play(var3_39, arg0_40, true)
			end)
		end

		table.insert(var0_39, function(arg0_41)
			local var0_41

			var0_41 = {
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_WORLD_RESET,
				itemFunc = function(arg0_42)
					arg0_39:emit(var0_0.ON_DROP, arg0_42, function()
						pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_41)
					end)
				end,
				drops = var2_39,
				tipWord = i18n("world_recycle_item_transform"),
				onNo = arg0_41
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_41)
		end)
	end

	if var1_39.resetLimitTip then
		table.insert(var0_39, function(arg0_44)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("world_resource_fill")
			})
		end)
	end

	seriesAsync(var0_39, function()
		var1_39:ClearResetAward()
	end)
end

return var0_0
