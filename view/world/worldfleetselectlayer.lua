local var0 = class("WorldFleetSelectLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "WorldFleetSelect"
end

function var0.init(arg0)
	arg0.rtBg = arg0._tf:Find("bg")

	local var0 = nowWorld():GetRealm()

	eachChild(arg0.rtBg, function(arg0)
		setActive(arg0, arg0.name == tostring(var0))
	end)

	arg0.rtPanel = arg0._tf:Find("panel")
	arg0.rtShipTpl = arg0.rtPanel:Find("shiptpl")

	setActive(arg0.rtShipTpl, false)

	arg0.rtEmptyTpl = arg0.rtPanel:Find("emptytpl")

	setActive(arg0.rtEmptyTpl, false)

	arg0.rtScroll = arg0.rtPanel:Find("bg")
	arg0.rtContent = arg0.rtScroll:Find("content")
	arg0.rtFleets = {
		[FleetType.Normal] = arg0.rtContent:Find("fleet"),
		[FleetType.Submarine] = arg0.rtContent:Find("sub")
	}
	arg0.btnBack = arg0.rtPanel:Find("btnBack")
	arg0.btnGo = arg0.rtPanel:Find("start_button")
	arg0.commanderToggle = arg0.rtPanel:Find("commander_btn")
	arg0.formationToggle = arg0.rtPanel:Find("formation_btn")
	arg0.tfLimitTip = arg0.rtPanel:Find("limit_tip")

	setText(arg0.tfLimitTip:Find("Text"), i18n("world_fleet_choose"))

	arg0.tfLimitSub = arg0.rtPanel:Find("limit_world/limit_sub")

	setText(arg0.tfLimitSub:Find("Text"), i18n("ship_limit_notice"))

	arg0.tfLimitContainer = arg0.rtPanel:Find("limit_world/limit_list")
	arg0.tfLimitTpl = arg0.tfLimitContainer:Find("condition")

	arg0:buildCommanderPanel()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0.rtPanel)
	onButton(arg0, arg0.btnGo, function()
		local var0, var1 = arg0:CheckValid()

		if var0 then
			arg0:emit(WorldFleetSelectMediator.OnGO)
		else
			pg.TipsMgr.GetInstance():ShowTips(var1)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)

	local function var0(arg0)
		arg0.contextData.showCommander = arg0

		for iter0, iter1 in pairs(arg0.rtFleets) do
			for iter2 = 1, #arg0.contextData.fleets[iter0] do
				arg0:updateCommanderBtn(iter1:GetChild(iter2 - 1))
			end
		end
	end

	onToggle(arg0, arg0.commanderToggle, function(arg0)
		if arg0 then
			var0(arg0)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.formationToggle, function(arg0)
		if arg0 then
			var0(not arg0)
		end
	end, SFX_PANEL)
	arg0:UpdateFleets()
	scrollTo(arg0.rtContent, nil, arg0.contextData.scrollY)

	arg0.contextData.showCommander = defaultValue(arg0.contextData.showCommander, true)

	triggerToggle(arg0.contextData.showCommander and arg0.commanderToggle or arg0.formationToggle, true)
	arg0:CheckWorldResetAward()
end

function var0.willExit(arg0)
	arg0.contextData.scrollY = GetComponent(arg0.rtContent, typeof(ScrollRect)).normalizedPosition.y

	pg.UIMgr.GetInstance():UnblurPanel(arg0.rtPanel, arg0._tf)
	arg0:destroyCommanderPanel()
end

function var0.onBackPressed(arg0)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("Hide")
	else
		arg0:closeView()
	end
end

function var0.UpdateFleets(arg0)
	local var0 = arg0.contextData.fleets

	for iter0, iter1 in pairs(var0) do
		local var1 = arg0.rtFleets[iter0]
		local var2 = UIItemList.New(var1, var1:GetChild(0))

		var2:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				arg0:UpdateFleet(arg2, iter0, arg1 + 1)
			end
		end)
		var2:align(#var0[iter0])
		setActive(var1, #var0[iter0] > 0)
	end

	arg0:updateEliteLimit()
end

function var0.IsPropertyLimitationSatisfy(arg0)
	local var0 = getProxy(BayProxy):getRawData()
	local var1 = pg.gameset.world_fleet_unlock_level.description
	local var2 = {}

	for iter0, iter1 in ipairs(var1) do
		var2[iter1[1]] = 0
	end

	local var3 = 0

	for iter2, iter3 in ipairs(arg0.contextData.fleets[FleetType.Normal]) do
		if arg0:GetTeamShipCount(iter3[TeamType.Main]) == 0 or arg0:GetTeamShipCount(iter3[TeamType.Vanguard]) == 0 then
			-- block empty
		else
			local var4 = {}
			local var5 = {}
			local var6 = 0

			for iter4, iter5 in ipairs(var1) do
				local var7, var8, var9, var10 = unpack(iter5)

				if string.sub(var7, 1, 5) == "fleet" then
					var4[var7] = 0
					var5[var7] = var10
				end
			end

			for iter6, iter7 in pairs(iter3) do
				for iter8 = 1, 3 do
					local var11 = iter7[iter8] and var0[iter7[iter8]]

					if var11 then
						var3 = var3 + 1
						var6 = var6 + 1

						local var12 = intProperties(var11:getProperties())

						for iter9, iter10 in pairs(var2) do
							if string.sub(iter9, 1, 5) == "fleet" then
								if iter9 == "fleet_totle_level" then
									var4[iter9] = var4[iter9] + var11.level
								end
							elseif iter9 == "level" then
								var2[iter9] = iter10 + var11.level
							else
								var2[iter9] = iter10 + var12[iter9]
							end
						end
					end
				end
			end

			for iter11, iter12 in pairs(var4) do
				if iter11 == "fleet_totle_level" and iter12 > var5[iter11] then
					var2[iter11] = var2[iter11] + 1
				end
			end
		end
	end

	local var13 = {}

	for iter13, iter14 in ipairs(var1) do
		local var14, var15, var16, var17 = unpack(iter14)

		if var14 == "level" and var3 > 0 then
			var2[var14] = math.ceil(var2[var14] / var3)
		end

		var13[iter13] = AttributeType.EliteConditionCompare(var15, var2[var14], var16) and 1 or 0
	end

	return var13, var2
end

function var0.updateEliteLimit(arg0)
	local var0 = pg.gameset.world_fleet_unlock_level.description

	if #var0 == 0 then
		return
	end

	local var1, var2 = arg0:IsPropertyLimitationSatisfy()
	local var3 = UIItemList.New(arg0.tfLimitContainer, arg0.tfLimitTpl)

	var3:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1]
			local var1, var2, var3, var4 = unpack(var0)

			if var1[arg1] == 1 then
				arg2:Find("Text"):GetComponent(typeof(Text)).color = Color.New(1, 0.96078431372549, 0.501960784313725)
			else
				arg2:Find("Text"):GetComponent(typeof(Text)).color = Color.New(0.956862745098039, 0.301960784313725, 0.301960784313725)
			end

			local var5 = (AttributeType.EliteCondition2Name(var1, var4) .. AttributeType.eliteConditionCompareTip(var2) .. var3) .. "（" .. var2[var1] .. "）"

			setText(arg2:Find("Text"), var5)
		end
	end)
	var3:align(#var0)
end

function var0.updateCommanderBtn(arg0, arg1)
	local var0 = arg1:Find("btn_recom")
	local var1 = arg1:Find("btn_clear")
	local var2 = arg1:Find("commander")

	setActive(var0, not arg0.contextData.showCommander)
	setActive(var1, not arg0.contextData.showCommander)
	setActive(var2, arg0.contextData.showCommander)
end

function var0.UpdateFleet(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("commander")

	arg0:updateCommanders(var0, arg2, arg3)

	local var1 = arg0.contextData.fleets[arg2][arg3]
	local var2 = (arg2 == FleetType.Submarine and 10 or 0) + arg3

	setText(arg1:Find("bg/name"), Fleet.DEFAULT_NAME[var2])

	if arg2 == FleetType.Normal then
		arg0:UpdateShips(arg1:Find(TeamType.Main), TeamType.Main, var1)
		arg0:UpdateShips(arg1:Find(TeamType.Vanguard), TeamType.Vanguard, var1)
		setActive(arg1:Find("selected"), arg0:GetTeamShipCount(var1[TeamType.Main]) > 0 and arg0:GetTeamShipCount(var1[TeamType.Vanguard]) > 0)
	elseif arg2 == FleetType.Submarine then
		arg0:UpdateShips(arg1:Find(TeamType.Submarine), TeamType.Submarine, var1)
		setActive(arg1:Find("selected"), arg0:GetTeamShipCount(var1[TeamType.Submarine]) > 0)
	end

	local var3 = arg1:Find("btn_recom")
	local var4 = arg1:Find("btn_clear")

	onButton(arg0, var3, function()
		arg0:RecommendFormation(arg2, arg3)
		arg0:UpdateFleet(arg1, arg2, arg3)
		arg0:updateEliteLimit()
	end, SFX_PANEL)
	onButton(arg0, var4, function()
		if arg0:GetTeamShipCount(var1[TeamType.Main]) > 0 or arg0:GetTeamShipCount(var1[TeamType.Vanguard]) > 0 or arg0:GetTeamShipCount(var1[TeamType.Submarine]) > 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("battle_preCombatLayer_clear_confirm"),
				onYes = function()
					var1[TeamType.Main] = {}
					var1[TeamType.Vanguard] = {}
					var1[TeamType.Submarine] = {}

					arg0:UpdateFleet(arg1, arg2, arg3)
					arg0:updateEliteLimit()
				end
			})
		end
	end, SFX_CANCEL)
end

function var0.updateCommanders(arg0, arg1, arg2, arg3)
	local var0 = arg0.contextData.fleets[arg2][arg3]
	local var1 = Fleet.New({
		ship_list = {},
		commanders = var0.commanders
	})

	for iter0 = 1, 2 do
		local var2 = var1:getCommanderByPos(iter0)
		local var3 = arg1:Find("pos" .. iter0)
		local var4 = var3:Find("add")
		local var5 = var3:Find("info")

		setActive(var4, not var2)
		setActive(var5, var2)

		if var2 then
			local var6 = Commander.rarity2Frame(var2:getRarity())

			setImageSprite(var5:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var6))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var2:getPainting(), "", var5:Find("mask/icon"))
		else
			local var7 = 1

			while var0.commanders[var7] and var0.commanders[var7].pos ~= iter0 do
				var7 = var7 + 1
			end

			if var0.commanders[var7] then
				table.remove(var0.commanders, var7)
			end
		end

		onButton(arg0, var4, function()
			arg0:openCommanderPanel(var1, arg2, arg3)
		end, SFX_PANEL)
		onButton(arg0, var5, function()
			arg0:openCommanderPanel(var1, arg2, arg3)
		end, SFX_PANEL)
	end
end

function var0.UpdateShips(arg0, arg1, arg2, arg3)
	local var0 = getProxy(BayProxy)
	local var1 = arg3[arg2]
	local var2 = {}

	for iter0, iter1 in ipairs({
		TeamType.Vanguard,
		TeamType.Main,
		TeamType.Submarine
	}) do
		for iter2 = 1, 3 do
			local var3 = arg3[iter1][iter2] and var0:getShipById(arg3[iter1][iter2]) or nil

			table.insert(var2, var3)

			if not var3 then
				arg3[iter1][iter2] = nil
			end
		end
	end

	removeAllChildren(arg1)

	for iter3 = 1, 3 do
		local var4
		local var5

		if var1[iter3] then
			var4 = cloneTplTo(arg0.rtShipTpl, arg1, "ship_" .. var1[iter3])
			var5 = var0:getShipById(var1[iter3])

			updateShip(var4, var5)
		else
			var4 = cloneTplTo(arg0.rtEmptyTpl, arg1, "empty")

			setActive(var4:Find("ship_type"), false)
		end

		onButton(arg0, var4:Find("icon_bg"), function()
			arg0:emit(WorldFleetSelectMediator.OnSelectShip, arg2, var1, iter3)
		end, SFX_PANEL)

		local var6 = GetOrAddComponent(var4:Find("icon_bg"), typeof(UILongPressTrigger))

		pg.DelegateInfo.Add(arg0, var6.onLongPressed)
		var6.onLongPressed:RemoveAllListeners()
		var6.onLongPressed:AddListener(function()
			if not var5 then
				arg0:emit(WorldFleetSelectMediator.OnSelectShip, arg2, var1, iter3)
			else
				arg0:emit(WorldFleetSelectMediator.OnShipDetail, {
					shipId = var5.id,
					shipVOs = var2
				})
			end
		end)
	end
end

function var0.setCommanderPrefabs(arg0, arg1)
	arg0.commanderPrefabs = arg1
end

function var0.openCommanderPanel(arg0, arg1, arg2, arg3)
	arg0.levelCMDFormationView:setCallback(function(arg0)
		if arg0.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0:emit(WorldFleetSelectMediator.OnCommanderSkill, arg0.skill)
		elseif arg0.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0.contextData.eliteCommanderSelected = {
				fleetType = arg2,
				fleetIndex = arg3,
				pos = arg0.pos
			}

			arg0:emit(WorldFleetSelectMediator.OnSelectEliteCommander, arg2, arg3, arg0.pos)
			arg0:closeCommanderPanel()
		else
			arg0:emit(WorldFleetSelectMediator.OnCommanderFormationOp, {
				FleetType = LevelUIConst.FLEET_TYPE_WORLD,
				data = arg0,
				fleets = arg0.contextData.fleets,
				fleetType = arg2,
				fleetIndex = arg3
			})
		end
	end)
	arg0.levelCMDFormationView:Load()
	arg0.levelCMDFormationView:ActionInvoke("update", arg1, arg0.commanderPrefabs)
	arg0.levelCMDFormationView:ActionInvoke("Show")
end

function var0.closeCommanderPanel(arg0)
	arg0.levelCMDFormationView:ActionInvoke("Hide")
end

function var0.updateCommanderFleet(arg0, arg1)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("updateFleet", arg1)
	end
end

function var0.updateCommanderPrefab(arg0)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0.commanderPrefabs)
	end
end

function var0.buildCommanderPanel(arg0)
	arg0.levelCMDFormationView = LevelCMDFormationView.New(arg0._tf, arg0.event, arg0.contextData)
end

function var0.destroyCommanderPanel(arg0)
	arg0.levelCMDFormationView:Destroy()

	arg0.levelCMDFormationView = nil
end

function var0.CheckValid(arg0)
	for iter0, iter1 in pairs(arg0.contextData.fleets) do
		if iter0 == FleetType.Normal then
			for iter2, iter3 in ipairs(iter1) do
				if arg0:GetTeamShipCount(iter3[TeamType.Main]) == 0 or arg0:GetTeamShipCount(iter3[TeamType.Vanguard]) == 0 then
					return false, i18n("world_fleet_formation_not_valid", Fleet.DEFAULT_NAME[iter2])
				end
			end
		end
	end

	local var0, var1 = arg0:IsPropertyLimitationSatisfy()
	local var2 = 1

	for iter4, iter5 in ipairs(var0) do
		var2 = var2 * iter5
	end

	if var2 ~= 1 then
		return false, i18n("elite_disable_property_unsatisfied")
	end

	return true
end

function var0.GetTeamShipCount(arg0, arg1)
	local var0 = 0

	for iter0 = 1, 3 do
		if arg1[iter0] then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.RecommendFormation(arg0, arg1, arg2)
	local var0 = {
		[FleetType.Normal] = {
			TeamType.Main,
			TeamType.Vanguard
		},
		[FleetType.Submarine] = {
			TeamType.Submarine
		}
	}
	local var1 = {}

	for iter0, iter1 in pairs(arg0.contextData.fleets) do
		for iter2, iter3 in ipairs(iter1) do
			for iter4, iter5 in ipairs(var0[iter0]) do
				for iter6 = 1, 3 do
					local var2 = iter3[iter5][iter6]

					if var2 then
						table.insert(var1, var2)
					end
				end
			end
		end
	end

	local var3 = arg0.contextData.fleets[arg1][arg2]
	local var4 = getProxy(BayProxy)

	for iter7, iter8 in ipairs(var0[arg1]) do
		for iter9 = 1, 3 do
			if not var3[iter8][iter9] then
				local var5 = var4:getWorldRecommendShip(iter8, var1)

				if var5 then
					var3[iter8][iter9] = var5.id

					table.insert(var1, var5.id)
				end
			end
		end
	end
end

function var0.CheckWorldResetAward(arg0)
	local var0 = {}
	local var1 = nowWorld()
	local var2 = var1.resetAward

	if var2 and #var2 > 0 then
		local var3 = pg.gameset.world_resetting_story.description[1]

		if #var3 > 0 then
			table.insert(var0, function(arg0)
				pg.NewStoryMgr.GetInstance():Play(var3, arg0, true)
			end)
		end

		table.insert(var0, function(arg0)
			local var0

			var0 = {
				hideYes = true,
				hideNo = true,
				type = MSGBOX_TYPE_WORLD_RESET,
				itemFunc = function(arg0)
					arg0:emit(var0.ON_DROP, arg0, function()
						pg.MsgboxMgr.GetInstance():ShowMsgBox(var0)
					end)
				end,
				drops = var2,
				tipWord = i18n("world_recycle_item_transform"),
				onNo = arg0
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var0)
		end)
	end

	if var1.resetLimitTip then
		table.insert(var0, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("world_resource_fill")
			})
		end)
	end

	seriesAsync(var0, function()
		var1:ClearResetAward()
	end)
end

return var0
