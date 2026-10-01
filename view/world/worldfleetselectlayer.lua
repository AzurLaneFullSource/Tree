local var0_0 = class("WorldFleetSelectLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "WorldFleetSelect"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"shiptype"
	}

	table.insertto(var0_2, arg0_2:getFleetSelectResList(arg1_2 and arg1_2.fleets))

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.insertFleetSelectRes(arg0_3, arg1_3, arg2_3)
	if noEmptyStr(arg2_3) and not table.contains(arg1_3, arg2_3) then
		table.insert(arg1_3, arg2_3)
	end
end

function var0_0.insertFleetSelectPrefixRes(arg0_4, arg1_4, arg2_4, arg3_4)
	if noEmptyStr(arg3_4) then
		arg0_4:insertFleetSelectRes(arg1_4, arg2_4 .. arg3_4)
	end
end

function var0_0.getShipIconResList(arg0_5, arg1_5)
	local var0_5 = {}
	local var1_5 = getProxy(BayProxy)

	for iter0_5, iter1_5 in pairs(arg1_5 or {}) do
		for iter2_5, iter3_5 in ipairs(iter1_5) do
			for iter4_5, iter5_5 in ipairs({
				TeamType.Main,
				TeamType.Vanguard,
				TeamType.Submarine
			}) do
				for iter6_5, iter7_5 in pairs(iter3_5[iter5_5] or {}) do
					local var2_5 = var1_5:getShipById(iter7_5)

					if var2_5 then
						arg0_5:insertFleetSelectPrefixRes(var0_5, "SquareIcon/", var2_5:getPainting())
					end
				end
			end
		end
	end

	return var0_5
end

function var0_0.getCommanderIconResList(arg0_6, arg1_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg1_6 or {}) do
		for iter2_6, iter3_6 in ipairs(iter1_6) do
			local var1_6 = Fleet.New({
				ship_list = {},
				commanders = iter3_6.commanders
			})

			for iter4_6, iter5_6 in pairs(var1_6:getCommanders()) do
				arg0_6:insertFleetSelectPrefixRes(var0_6, "CommanderHrz/", iter5_6:getPainting())
			end
		end
	end

	return var0_6
end

function var0_0.getFleetSelectResList(arg0_7, arg1_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in ipairs(arg0_7:getShipIconResList(arg1_7)) do
		arg0_7:insertFleetSelectRes(var0_7, iter1_7)
	end

	for iter2_7, iter3_7 in ipairs(arg0_7:getCommanderIconResList(arg1_7)) do
		arg0_7:insertFleetSelectRes(var0_7, iter3_7)
	end

	return var0_7
end

function var0_0.downloadFleetSelectResList(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8:getFleetSelectResList(arg1_8)

	SplitPackConst.DownloadByLuaArr(var0_8, function()
		if arg0_8.exited then
			return
		end

		return existCall(arg2_8)
	end)
end

function var0_0.init(arg0_10)
	arg0_10.rtBg = arg0_10._tf:Find("bg")

	local var0_10 = nowWorld():GetRealm()

	eachChild(arg0_10.rtBg, function(arg0_11)
		setActive(arg0_11, arg0_11.name == tostring(var0_10))
	end)

	arg0_10.rtPanel = arg0_10._tf:Find("panel")
	arg0_10.rtShipTpl = arg0_10.rtPanel:Find("shiptpl")

	setActive(arg0_10.rtShipTpl, false)

	arg0_10.rtEmptyTpl = arg0_10.rtPanel:Find("emptytpl")

	setActive(arg0_10.rtEmptyTpl, false)

	arg0_10.rtScroll = arg0_10.rtPanel:Find("bg")
	arg0_10.rtContent = arg0_10.rtScroll:Find("content")
	arg0_10.rtFleets = {
		[FleetType.Normal] = arg0_10.rtContent:Find("fleet"),
		[FleetType.Submarine] = arg0_10.rtContent:Find("sub")
	}
	arg0_10.btnBack = arg0_10.rtPanel:Find("btnBack")
	arg0_10.btnGo = arg0_10.rtPanel:Find("start_button")
	arg0_10.commanderToggle = arg0_10.rtPanel:Find("commander_btn")
	arg0_10.formationToggle = arg0_10.rtPanel:Find("formation_btn")
	arg0_10.tfLimitTip = arg0_10.rtPanel:Find("limit_tip")

	setText(arg0_10.tfLimitTip:Find("Text"), i18n("world_fleet_choose"))

	arg0_10.tfLimitSub = arg0_10.rtPanel:Find("limit_world/limit_sub")

	setText(arg0_10.tfLimitSub:Find("Text"), i18n("ship_limit_notice"))

	arg0_10.tfLimitContainer = arg0_10.rtPanel:Find("limit_world/limit_list")
	arg0_10.tfLimitTpl = arg0_10.tfLimitContainer:Find("condition")

	arg0_10:buildCommanderPanel()
end

function var0_0.didEnter(arg0_12)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12.rtPanel)
	onButton(arg0_12, arg0_12.btnGo, function()
		local var0_13, var1_13 = arg0_12:CheckValid()

		if var0_13 then
			arg0_12:emit(WorldFleetSelectMediator.OnGO)
		else
			pg.TipsMgr.GetInstance():ShowTips(var1_13)
		end
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.btnBack, function()
		arg0_12:closeView()
	end, SFX_CANCEL)

	local function var0_12(arg0_15)
		arg0_12.contextData.showCommander = arg0_15

		for iter0_15, iter1_15 in pairs(arg0_12.rtFleets) do
			for iter2_15 = 1, #arg0_12.contextData.fleets[iter0_15] do
				arg0_12:updateCommanderBtn(iter1_15:GetChild(iter2_15 - 1))
			end
		end
	end

	onToggle(arg0_12, arg0_12.commanderToggle, function(arg0_16)
		if arg0_16 then
			var0_12(arg0_16)
		end
	end, SFX_PANEL)
	onToggle(arg0_12, arg0_12.formationToggle, function(arg0_17)
		if arg0_17 then
			var0_12(not arg0_17)
		end
	end, SFX_PANEL)
	arg0_12:UpdateFleets()
	scrollTo(arg0_12.rtContent, nil, arg0_12.contextData.scrollY)

	arg0_12.contextData.showCommander = defaultValue(arg0_12.contextData.showCommander, true)

	triggerToggle(arg0_12.contextData.showCommander and arg0_12.commanderToggle or arg0_12.formationToggle, true)
	seriesAsync({
		function(arg0_18)
			arg0_12:CheckWorldDelegateAward(arg0_18)
		end,
		function(arg0_19)
			arg0_12:CheckWorldResetAward(arg0_19)
		end
	}, function()
		return
	end)
end

function var0_0.willExit(arg0_21)
	arg0_21.contextData.scrollY = GetComponent(arg0_21.rtContent, typeof(ScrollRect)).normalizedPosition.y

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21.rtPanel, arg0_21._tf)
	arg0_21:destroyCommanderPanel()
end

function var0_0.onBackPressed(arg0_22)
	if arg0_22.levelCMDFormationView:isShowing() then
		arg0_22.levelCMDFormationView:ActionInvoke("Hide")
	else
		arg0_22:closeView()
	end
end

function var0_0.UpdateFleets(arg0_23, arg1_23)
	arg0_23:downloadFleetSelectResList(arg0_23.contextData.fleets, function()
		arg0_23:UpdateFleetsAfterResDownload()

		return existCall(arg1_23)
	end)
end

function var0_0.UpdateFleetsAfterResDownload(arg0_25)
	local var0_25 = arg0_25.contextData.fleets

	for iter0_25, iter1_25 in pairs(var0_25) do
		local var1_25 = arg0_25.rtFleets[iter0_25]
		local var2_25 = UIItemList.New(var1_25, var1_25:GetChild(0))

		var2_25:make(function(arg0_26, arg1_26, arg2_26)
			if arg0_26 == UIItemList.EventUpdate then
				arg0_25:UpdateFleet(arg2_26, iter0_25, arg1_26 + 1)
			end
		end)
		var2_25:align(#var0_25[iter0_25])
		setActive(var1_25, #var0_25[iter0_25] > 0)
	end

	arg0_25:updateEliteLimit()
end

function var0_0.IsPropertyLimitationSatisfy(arg0_27)
	local var0_27 = getProxy(BayProxy):getRawData()
	local var1_27 = pg.gameset.world_fleet_unlock_level.description
	local var2_27 = {}

	for iter0_27, iter1_27 in ipairs(var1_27) do
		var2_27[iter1_27[1]] = 0
	end

	local var3_27 = 0

	for iter2_27, iter3_27 in ipairs(arg0_27.contextData.fleets[FleetType.Normal]) do
		if arg0_27:GetTeamShipCount(iter3_27[TeamType.Main]) == 0 or arg0_27:GetTeamShipCount(iter3_27[TeamType.Vanguard]) == 0 then
			-- block empty
		else
			local var4_27 = {}
			local var5_27 = {}
			local var6_27 = 0

			for iter4_27, iter5_27 in ipairs(var1_27) do
				local var7_27, var8_27, var9_27, var10_27 = unpack(iter5_27)

				if string.sub(var7_27, 1, 5) == "fleet" then
					var4_27[var7_27] = 0
					var5_27[var7_27] = var10_27
				end
			end

			for iter6_27, iter7_27 in pairs(iter3_27) do
				for iter8_27 = 1, 3 do
					local var11_27 = iter7_27[iter8_27] and var0_27[iter7_27[iter8_27]]

					if var11_27 then
						var3_27 = var3_27 + 1
						var6_27 = var6_27 + 1

						local var12_27 = intProperties(var11_27:getProperties())

						for iter9_27, iter10_27 in pairs(var2_27) do
							if string.sub(iter9_27, 1, 5) == "fleet" then
								if iter9_27 == "fleet_totle_level" then
									var4_27[iter9_27] = var4_27[iter9_27] + var11_27.level
								end
							elseif iter9_27 == "level" then
								var2_27[iter9_27] = iter10_27 + var11_27.level
							else
								var2_27[iter9_27] = iter10_27 + var12_27[iter9_27]
							end
						end
					end
				end
			end

			for iter11_27, iter12_27 in pairs(var4_27) do
				if iter11_27 == "fleet_totle_level" and iter12_27 > var5_27[iter11_27] then
					var2_27[iter11_27] = var2_27[iter11_27] + 1
				end
			end
		end
	end

	local var13_27 = {}

	for iter13_27, iter14_27 in ipairs(var1_27) do
		local var14_27, var15_27, var16_27, var17_27 = unpack(iter14_27)

		if var14_27 == "level" and var3_27 > 0 then
			var2_27[var14_27] = math.ceil(var2_27[var14_27] / var3_27)
		end

		var13_27[iter13_27] = AttributeType.EliteConditionCompare(var15_27, var2_27[var14_27], var16_27) and 1 or 0
	end

	return var13_27, var2_27
end

function var0_0.updateEliteLimit(arg0_28)
	local var0_28 = pg.gameset.world_fleet_unlock_level.description

	if #var0_28 == 0 then
		return
	end

	local var1_28, var2_28 = arg0_28:IsPropertyLimitationSatisfy()
	local var3_28 = UIItemList.New(arg0_28.tfLimitContainer, arg0_28.tfLimitTpl)

	var3_28:make(function(arg0_29, arg1_29, arg2_29)
		arg1_29 = arg1_29 + 1

		if arg0_29 == UIItemList.EventUpdate then
			local var0_29 = var0_28[arg1_29]
			local var1_29, var2_29, var3_29, var4_29 = unpack(var0_29)

			if var1_28[arg1_29] == 1 then
				arg2_29:Find("Text"):GetComponent(typeof(Text)).color = Color.New(1, 0.96078431372549, 0.501960784313725)
			else
				arg2_29:Find("Text"):GetComponent(typeof(Text)).color = Color.New(0.956862745098039, 0.301960784313725, 0.301960784313725)
			end

			local var5_29 = (AttributeType.EliteCondition2Name(var1_29, var4_29) .. AttributeType.eliteConditionCompareTip(var2_29) .. var3_29) .. "（" .. var2_28[var1_29] .. "）"

			setText(arg2_29:Find("Text"), var5_29)
		end
	end)
	var3_28:align(#var0_28)
end

function var0_0.updateCommanderBtn(arg0_30, arg1_30)
	local var0_30 = arg1_30:Find("btn_recom")
	local var1_30 = arg1_30:Find("btn_clear")
	local var2_30 = arg1_30:Find("commander")

	setActive(var0_30, not arg0_30.contextData.showCommander)
	setActive(var1_30, not arg0_30.contextData.showCommander)
	setActive(var2_30, arg0_30.contextData.showCommander)
end

function var0_0.UpdateFleet(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = arg1_31:Find("commander")

	arg0_31:updateCommanders(var0_31, arg2_31, arg3_31)

	local var1_31 = arg0_31.contextData.fleets[arg2_31][arg3_31]
	local var2_31 = (arg2_31 == FleetType.Submarine and 10 or 0) + arg3_31

	setText(arg1_31:Find("bg/name"), Fleet.DEFAULT_NAME[var2_31])

	if arg2_31 == FleetType.Normal then
		arg0_31:UpdateShips(arg1_31:Find(TeamType.Main), TeamType.Main, var1_31)
		arg0_31:UpdateShips(arg1_31:Find(TeamType.Vanguard), TeamType.Vanguard, var1_31)
		setActive(arg1_31:Find("selected"), arg0_31:GetTeamShipCount(var1_31[TeamType.Main]) > 0 and arg0_31:GetTeamShipCount(var1_31[TeamType.Vanguard]) > 0)
	elseif arg2_31 == FleetType.Submarine then
		arg0_31:UpdateShips(arg1_31:Find(TeamType.Submarine), TeamType.Submarine, var1_31)
		setActive(arg1_31:Find("selected"), arg0_31:GetTeamShipCount(var1_31[TeamType.Submarine]) > 0)
	end

	local var3_31 = arg1_31:Find("btn_recom")
	local var4_31 = arg1_31:Find("btn_clear")

	onButton(arg0_31, var3_31, function()
		arg0_31:RecommendFormation(arg2_31, arg3_31)
		arg0_31:downloadFleetSelectResList(arg0_31.contextData.fleets, function()
			arg0_31:UpdateFleet(arg1_31, arg2_31, arg3_31)
			arg0_31:updateEliteLimit()
		end)
	end, SFX_PANEL)
	onButton(arg0_31, var4_31, function()
		if arg0_31:GetTeamShipCount(var1_31[TeamType.Main]) > 0 or arg0_31:GetTeamShipCount(var1_31[TeamType.Vanguard]) > 0 or arg0_31:GetTeamShipCount(var1_31[TeamType.Submarine]) > 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("battle_preCombatLayer_clear_confirm"),
				onYes = function()
					var1_31[TeamType.Main] = {}
					var1_31[TeamType.Vanguard] = {}
					var1_31[TeamType.Submarine] = {}

					arg0_31:UpdateFleet(arg1_31, arg2_31, arg3_31)
					arg0_31:updateEliteLimit()
				end
			})
		end
	end, SFX_CANCEL)
end

function var0_0.updateCommanders(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = arg0_36.contextData.fleets[arg2_36][arg3_36]
	local var1_36 = Fleet.New({
		ship_list = {},
		commanders = var0_36.commanders
	})

	for iter0_36 = 1, 2 do
		local var2_36 = var1_36:getCommanderByPos(iter0_36)
		local var3_36 = arg1_36:Find("pos" .. iter0_36)
		local var4_36 = var3_36:Find("add")
		local var5_36 = var3_36:Find("info")

		setActive(var4_36, not var2_36)
		setActive(var5_36, var2_36)

		if var2_36 then
			local var6_36 = Commander.rarity2Frame(var2_36:getRarity())

			setImageSprite(var5_36:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6_36))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2_36:getPainting(), "", var5_36:Find("mask/icon"))
		else
			local var7_36 = 1

			while var0_36.commanders[var7_36] and var0_36.commanders[var7_36].pos ~= iter0_36 do
				var7_36 = var7_36 + 1
			end

			if var0_36.commanders[var7_36] then
				table.remove(var0_36.commanders, var7_36)
			end
		end

		onButton(arg0_36, var4_36, function()
			arg0_36:openCommanderPanel(var1_36, arg2_36, arg3_36)
		end, SFX_PANEL)
		onButton(arg0_36, var5_36, function()
			arg0_36:openCommanderPanel(var1_36, arg2_36, arg3_36)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateShips(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = getProxy(BayProxy)
	local var1_39 = arg3_39[arg2_39]
	local var2_39 = {}

	for iter0_39, iter1_39 in ipairs({
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}) do
		for iter2_39 = 1, 3 do
			local var3_39 = arg3_39[iter1_39][iter2_39] and var0_39:getShipById(arg3_39[iter1_39][iter2_39]) or nil

			table.insert(var2_39, var3_39)

			if not var3_39 then
				arg3_39[iter1_39][iter2_39] = nil
			end
		end
	end

	removeAllChildren(arg1_39)

	for iter3_39 = 1, 3 do
		local var4_39
		local var5_39

		if var1_39[iter3_39] then
			var4_39 = cloneTplTo(arg0_39.rtShipTpl, arg1_39, "ship_" .. var1_39[iter3_39])
			var5_39 = var0_39:getShipById(var1_39[iter3_39])

			updateShip(var4_39, var5_39)
		else
			var4_39 = cloneTplTo(arg0_39.rtEmptyTpl, arg1_39, "empty")

			setActive(var4_39:Find("ship_type"), false)
		end

		onButton(arg0_39, var4_39:Find("icon_bg"), function()
			arg0_39:emit(WorldFleetSelectMediator.OnSelectShip, arg2_39, var1_39, iter3_39)
		end, SFX_PANEL)

		local var6_39 = GetOrAddComponent(var4_39:Find("icon_bg"), typeof(UILongPressTrigger))

		pg.DelegateInfo.Add(arg0_39, var6_39.onLongPressed)
		var6_39.onLongPressed:RemoveAllListeners()
		var6_39.onLongPressed:AddListener(function()
			if not var5_39 then
				arg0_39:emit(WorldFleetSelectMediator.OnSelectShip, arg2_39, var1_39, iter3_39)
			else
				arg0_39:emit(WorldFleetSelectMediator.OnShipDetail, {
					shipId = var5_39.id,
					shipVOs = var2_39
				})
			end
		end)
	end
end

function var0_0.setCommanderPrefabs(arg0_42, arg1_42)
	arg0_42.commanderPrefabs = arg1_42
end

function var0_0.openCommanderPanel(arg0_43, arg1_43, arg2_43, arg3_43)
	arg0_43.levelCMDFormationView:setCallback(function(arg0_44)
		if arg0_44.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_43:emit(WorldFleetSelectMediator.OnCommanderSkill, arg0_44.skill)
		elseif arg0_44.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_43.contextData.eliteCommanderSelected = {
				fleetType = arg2_43,
				fleetIndex = arg3_43,
				pos = arg0_44.pos
			}

			arg0_43:emit(WorldFleetSelectMediator.OnSelectEliteCommander, arg2_43, arg3_43, arg0_44.pos)
			arg0_43:closeCommanderPanel()
		else
			arg0_43:emit(WorldFleetSelectMediator.OnCommanderFormationOp, {
				FleetType = LevelUIConst.FLEET_TYPE_WORLD,
				data = arg0_44,
				fleets = arg0_43.contextData.fleets,
				fleetType = arg2_43,
				fleetIndex = arg3_43
			})
		end
	end)
	arg0_43.levelCMDFormationView:Load()
	arg0_43.levelCMDFormationView:ActionInvoke("update", arg1_43, arg0_43.commanderPrefabs)
	arg0_43.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.closeCommanderPanel(arg0_45)
	arg0_45.levelCMDFormationView:ActionInvoke("Hide")
end

function var0_0.updateCommanderFleet(arg0_46, arg1_46)
	if arg0_46.levelCMDFormationView:isShowing() then
		arg0_46.levelCMDFormationView:ActionInvoke("updateFleet", arg1_46)
	end
end

function var0_0.updateCommanderPrefab(arg0_47)
	if arg0_47.levelCMDFormationView:isShowing() then
		arg0_47.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_47.commanderPrefabs)
	end
end

function var0_0.buildCommanderPanel(arg0_48)
	arg0_48.levelCMDFormationView = LevelCMDFormationView.New(arg0_48._tf, arg0_48.event, arg0_48.contextData)
end

function var0_0.destroyCommanderPanel(arg0_49)
	arg0_49.levelCMDFormationView:Destroy()

	arg0_49.levelCMDFormationView = nil
end

function var0_0.CheckValid(arg0_50)
	for iter0_50, iter1_50 in pairs(arg0_50.contextData.fleets) do
		if iter0_50 == FleetType.Normal then
			for iter2_50, iter3_50 in ipairs(iter1_50) do
				if arg0_50:GetTeamShipCount(iter3_50[TeamType.Main]) == 0 or arg0_50:GetTeamShipCount(iter3_50[TeamType.Vanguard]) == 0 then
					return false, i18n("world_fleet_formation_not_valid", Fleet.DEFAULT_NAME[iter2_50])
				end
			end
		end
	end

	local var0_50, var1_50 = arg0_50:IsPropertyLimitationSatisfy()
	local var2_50 = 1

	for iter4_50, iter5_50 in ipairs(var0_50) do
		var2_50 = var2_50 * iter5_50
	end

	if var2_50 ~= 1 then
		return false, i18n("elite_disable_property_unsatisfied")
	end

	return true
end

function var0_0.GetTeamShipCount(arg0_51, arg1_51)
	local var0_51 = 0

	for iter0_51 = 1, 3 do
		if arg1_51[iter0_51] then
			var0_51 = var0_51 + 1
		end
	end

	return var0_51
end

function var0_0.RecommendFormation(arg0_52, arg1_52, arg2_52)
	local var0_52 = {
		[FleetType.Normal] = {
			TeamType.Main,
			TeamType.Vanguard
		},
		[FleetType.Submarine] = {
			TeamType.Submarine
		}
	}
	local var1_52 = {}

	for iter0_52, iter1_52 in pairs(arg0_52.contextData.fleets) do
		for iter2_52, iter3_52 in ipairs(iter1_52) do
			for iter4_52, iter5_52 in ipairs(var0_52[iter0_52]) do
				for iter6_52 = 1, 3 do
					local var2_52 = iter3_52[iter5_52][iter6_52]

					if var2_52 then
						table.insert(var1_52, var2_52)
					end
				end
			end
		end
	end

	local var3_52 = arg0_52.contextData.fleets[arg1_52][arg2_52]
	local var4_52 = getProxy(BayProxy)

	for iter7_52, iter8_52 in ipairs(var0_52[arg1_52]) do
		for iter9_52 = 1, 3 do
			if not var3_52[iter8_52][iter9_52] then
				local var5_52 = var4_52:getWorldRecommendShip(iter8_52, var1_52)

				if var5_52 then
					var3_52[iter8_52][iter9_52] = var5_52.id

					table.insert(var1_52, var5_52.id)
				end
			end
		end
	end
end

function var0_0.CheckWorldDelegateAward(arg0_53, arg1_53)
	if getProxy(WorldProxy):GetDelegateAward() then
		getProxy(WorldProxy):RemoveDelegateAward()
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_auto_plan_error_tip4"))
	end

	arg1_53()
end

function var0_0.CheckWorldResetAward(arg0_54, arg1_54)
	local var0_54 = {}
	local var1_54 = nowWorld()
	local var2_54 = var1_54.resetAward

	if var2_54 and #var2_54 > 0 then
		local var3_54 = pg.gameset.world_resetting_story.description[1]

		if #var3_54 > 0 then
			table.insert(var0_54, function(arg0_55)
				pg.NewStoryMgr.GetInstance():Play(var3_54, arg0_55, true)
			end)
		end

		table.insert(var0_54, function(arg0_56)
			local var0_56

			var0_56 = {
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_WORLD_RESET,
				itemFunc = function(arg0_57)
					arg0_54:emit(var0_0.ON_DROP, arg0_57, function()
						pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_56)
					end)
				end,
				drops = var2_54,
				tipWord = i18n("world_recycle_item_transform"),
				onNo = arg0_56
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_56)
		end)
	end

	if var1_54.resetLimitTip then
		table.insert(var0_54, function(arg0_59)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("world_resource_fill")
			})
		end)
	end

	seriesAsync(var0_54, function()
		var1_54:ClearResetAward()
		arg1_54()
	end)
end

return var0_0
