local var0_0 = class("ActivityBossSceneTemplate", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	error("Need Complete")
end

function var0_0.getGroupName(arg0_2)
	return "ActivityBossSceneTemplate"
end

var0_0.optionsPath = {
	"adapt/top/option"
}

function var0_0.init(arg0_3)
	arg0_3.mainTF = arg0_3:findTF("adapt")
	arg0_3.bg = arg0_3:findTF("bg")
	arg0_3.bottom = arg0_3:findTF("bottom", arg0_3.mainTF)
	arg0_3.hpBar = arg0_3:findTF("progress", arg0_3.bottom)
	arg0_3.barList = {}

	for iter0_3 = 1, 4 do
		arg0_3.barList[iter0_3] = arg0_3:findTF(iter0_3, arg0_3.hpBar)
	end

	arg0_3.progressDigit = arg0_3:findTF("digit", arg0_3.bottom)
	arg0_3.digitbig = arg0_3.progressDigit:Find("big")
	arg0_3.digitsmall = arg0_3.progressDigit:Find("small")
	arg0_3.left = arg0_3:findTF("left", arg0_3.mainTF)
	arg0_3.rankTF = arg0_3:findTF("rank", arg0_3.left)
	arg0_3.rankList = CustomIndexLayer.Clone2Full(arg0_3.rankTF:Find("layout"), 3)

	for iter1_3, iter2_3 in ipairs(arg0_3.rankList) do
		setActive(iter2_3, false)
	end

	arg0_3.right = arg0_3:findTF("right", arg0_3.mainTF)
	arg0_3.stageList = {}

	for iter3_3 = 1, 4 do
		arg0_3.stageList[iter3_3] = arg0_3:findTF(iter3_3, arg0_3.right)
	end

	arg0_3.stageSP = arg0_3:findTF("5", arg0_3.right)

	if not IsNil(arg0_3.stageSP) then
		setActive(arg0_3.stageSP, false)
	end

	arg0_3.awardFlash = arg0_3:findTF("ptaward/flash", arg0_3.right)
	arg0_3.awardBtn = arg0_3:findTF("ptaward/button", arg0_3.right)
	arg0_3.ptScoreTxt = arg0_3:findTF("ptaward/Text", arg0_3.right)
	arg0_3.top = arg0_3:findTF("top", arg0_3.mainTF)
	arg0_3.ticketNum = arg0_3:findTF("ticket/Text", arg0_3.top)
	arg0_3.helpBtn = arg0_3:findTF("help", arg0_3.top)

	onButton(arg0_3, arg0_3.top:Find("back_btn"), function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	setActive(arg0_3.top, false)
	setAnchoredPosition(arg0_3.top, {
		y = 1080
	})
	setActive(arg0_3.left, false)
	setAnchoredPosition(arg0_3.left, {
		x = -1920
	})
	setActive(arg0_3.right, false)
	setAnchoredPosition(arg0_3.right, {
		x = 1920
	})
	setActive(arg0_3.bottom, false)
	setAnchoredPosition(arg0_3.bottom, {
		y = -1080
	})
	arg0_3:buildCommanderPanel()
end

function var0_0.GetBonusWindow(arg0_5)
	if not arg0_5.bonusWindow then
		arg0_5.bonusWindow = ActivityBossPtAwardSubPanel.New(arg0_5)

		arg0_5.bonusWindow:Load()
	end

	return arg0_5.bonusWindow
end

function var0_0.DestroyBonusWindow(arg0_6)
	if arg0_6.bonusWindow then
		arg0_6.bonusWindow:Destroy()

		arg0_6.bonusWindow = nil
	end
end

function var0_0.GetFleetEditPanel(arg0_7)
	if not arg0_7.fleetEditPanel then
		arg0_7.fleetEditPanel = ActivityBossBattleFleetSelectSubPanel.New(arg0_7)

		arg0_7.fleetEditPanel:Load()
	end

	return arg0_7.fleetEditPanel
end

function var0_0.DestroyFleetEditPanel(arg0_8)
	if arg0_8.fleetEditPanel then
		arg0_8.fleetEditPanel:Destroy()

		arg0_8.fleetEditPanel = nil
	end
end

function var0_0.EnterAnim(arg0_9)
	setActive(arg0_9.top, true)
	setActive(arg0_9.left, true)
	setActive(arg0_9.right, true)
	setActive(arg0_9.bottom, true)
	arg0_9.mainTF:GetComponent("Animation"):Play("Enter_Animation")
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.awardBtn, function()
		arg0_10:ShowAwards()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help.tip
		})
	end, SFX_PANEL)
	arg0_10:UpdateDropItems()

	for iter0_10 = 1, #arg0_10.stageList - 1 do
		onButton(arg0_10, arg0_10.stageList[iter0_10], function()
			if arg0_10.contextData.activity:checkBattleTimeInBossAct() then
				arg0_10:ShowNormalFleet(iter0_10, true)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			end
		end, SFX_PANEL)
	end

	onButton(arg0_10, arg0_10.stageList[#arg0_10.stageList], function()
		if arg0_10.contextData.activity:checkBattleTimeInBossAct() then
			arg0_10:ShowEXFleet()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)

	if not IsNil(arg0_10.stageSP) then
		setActive(arg0_10.stageSP, arg0_10.contextData.spStageID)
		onButton(arg0_10, arg0_10.stageSP, function()
			if arg0_10.contextData.activity:checkBattleTimeInBossAct() then
				arg0_10:emit(ActivityBossMediatorTemplate.ONEN_BUFF_SELECT)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			end
		end, SFX_PANEL)
	end

	if arg0_10.contextData.editFleet then
		local var0_10 = arg0_10.contextData.editFleet

		if var0_10 <= #arg0_10.contextData.normalStageIDs then
			arg0_10:ShowNormalFleet(var0_10)
		elseif arg0_10.contextData.editFleet == #arg0_10.contextData.normalStageIDs + 1 then
			arg0_10:ShowEXFleet()
		elseif arg0_10.contextData.editFleet == #arg0_10.contextData.normalStageIDs + 2 then
			arg0_10:ShowSPFleet()
		end
	end

	arg0_10:EnterAnim()

	if arg0_10.contextData.msg then
		local var1_10 = arg0_10.contextData.msg.param

		switch(arg0_10.contextData.msg.type, {
			lastBonus = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox(var1_10)
			end,
			oil = function()
				if not ItemTipPanel.ShowOilBuyTip(var1_10) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))
				end
			end,
			shipCapacity = function()
				BeginStageCommand.DockOverload()
			end,
			energy = function()
				Fleet.EnergyCheck(_.map(_.values(var1_10.ships), function(arg0_20)
					return getProxy(BayProxy):getShipById(arg0_20)
				end), Fleet.DEFAULT_NAME_BOSS_ACT[var1_10.id], function(arg0_21)
					if arg0_21 then
						arg0_10:emit(PreCombatMediator.BEGIN_STAGE_PROXY, {
							curFleetId = var1_10.id
						})
					end
				end)
			end
		})

		arg0_10.contextData.msg = nil
	end
end

function var0_0.UpdateView(arg0_22)
	arg0_22:UpdatePage()
	arg0_22:CheckStory()
end

function var0_0.CheckStory(arg0_23)
	local var0_23 = pg.NewStoryMgr.GetInstance()
	local var1_23 = arg0_23.contextData.activity:getConfig("config_client").story

	table.SerialIpairsAsync(var1_23, function(arg0_24, arg1_24, arg2_24)
		if arg0_23.contextData.bossHP < arg1_24[1] + ((arg0_24 == 1 or arg1_24[1] == 0) and 1 or 0) and not pg.NewStoryMgr.GetInstance():IsPlayed(arg1_24[2]) then
			var0_23:Play(arg1_24[2], arg2_24)

			return
		end

		arg2_24()
	end)
end

function var0_0.UpdatePage(arg0_25)
	local var0_25 = arg0_25.contextData.bossHP

	setText(arg0_25.digitbig, math.floor(var0_25 / 100))
	setText(arg0_25.digitsmall, string.format("%02d", var0_25 % 100) .. "%")

	local var1_25 = pg.TimeMgr.GetInstance()

	for iter0_25 = 1, 4 do
		local var2_25 = arg0_25.barList[iter0_25]

		setSlider(arg0_25:findTF("Slider", var2_25), 0, 2500, math.min(math.max(var0_25 - (iter0_25 - 1) * 2500, 0), 2500))

		local var3_25 = arg0_25.contextData.mileStones[5 - iter0_25]

		setActive(arg0_25:findTF("milestone/item", var2_25), not var3_25)
		setActive(arg0_25:findTF("milestone/time", var2_25), var3_25)

		if var3_25 then
			local var4_25 = var1_25:STimeDescC(arg0_25.contextData.mileStones[5 - iter0_25], "%m/%d/%H:%M")

			setText(arg0_25:findTF("milestone/time/Text", var2_25), var4_25)
		end
	end

	for iter1_25 = 1, #arg0_25.stageList - 1 do
		local var5_25 = arg0_25.contextData.normalStageIDs[iter1_25]
		local var6_25 = arg0_25.stageList[iter1_25]

		for iter2_25, iter3_25 in ipairs(arg0_25.contextData.ticketInitPools) do
			for iter4_25, iter5_25 in ipairs(iter3_25[1]) do
				if iter5_25 == var5_25 then
					local var7_25 = iter3_25[2]
					local var8_25 = arg0_25.contextData.stageTickets[var5_25] or 0

					setActive(var6_25:Find("Text"), var8_25 > 0)
					setText(var6_25:Find("Text"), string.format("%d/%d", var8_25, var7_25))
				end
			end
		end
	end

	setText(arg0_25.ptScoreTxt, arg0_25.contextData.ptData.count)
	setActive(arg0_25.awardFlash, arg0_25.contextData.ptData:CanGetAward())

	if arg0_25.bonusWindow and arg0_25.bonusWindow:IsShowing() then
		arg0_25.bonusWindow.buffer:UpdateView(arg0_25.contextData.ptData)
	end

	local var9_25 = arg0_25:GetEXTicket()

	setText(arg0_25.ticketNum, var9_25)
end

function var0_0.GetEXTicket(arg0_26)
	return getProxy(PlayerProxy):getRawData():getResource(arg0_26.contextData.TicketID)
end

function var0_0.ShowNormalFleet(arg0_27, arg1_27, arg2_27)
	if not arg0_27.contextData.actFleets[arg1_27] then
		arg0_27.contextData.actFleets[arg1_27] = arg0_27:CreateNewFleet(arg1_27)
	end

	if not arg0_27.contextData.actFleets[arg1_27 + 10] then
		arg0_27.contextData.actFleets[arg1_27 + 10] = arg0_27:CreateNewFleet(arg1_27 + 10)
	end

	local var0_27 = arg0_27.contextData.actFleets[arg1_27]

	if arg2_27 and #var0_27.ships <= 0 then
		for iter0_27 = #arg0_27.contextData.normalStageIDs, 1, -1 do
			local var1_27 = arg0_27.contextData.actFleets[iter0_27]

			if iter0_27 ~= arg1_27 and var1_27 and var1_27:isLegalToFight() == true then
				var0_27:updateShips(var1_27.ships)

				break
			end
		end
	end

	local var2_27 = arg0_27:GetFleetEditPanel()

	var2_27.buffer:SetSettings(1, 1, false)
	var2_27.buffer:SetFleets({
		arg0_27.contextData.actFleets[arg1_27],
		arg0_27.contextData.actFleets[arg1_27 + 10]
	})

	local var3_27 = arg0_27.contextData.useOilLimit[arg1_27]
	local var4_27 = arg0_27.contextData.normalStageIDs[arg1_27]

	if not arg0_27.contextData.activity:IsOilLimit(var4_27) then
		var3_27 = {
			0,
			0
		}
	end

	var2_27.buffer:SetOilLimit(var3_27)

	arg0_27.contextData.editFleet = arg1_27

	var2_27.buffer:UpdateView()
	var2_27.buffer:Show()
end

function var0_0.ShowEXFleet(arg0_28)
	local var0_28 = #arg0_28.contextData.normalStageIDs + 1

	if not arg0_28.contextData.actFleets[var0_28] then
		arg0_28.contextData.actFleets[var0_28] = arg0_28:CreateNewFleet(var0_28)
	end

	if not arg0_28.contextData.actFleets[var0_28 + 10] then
		arg0_28.contextData.actFleets[var0_28 + 10] = arg0_28:CreateNewFleet(var0_28 + 10)
	end

	local var1_28 = arg0_28:GetFleetEditPanel()

	var1_28.buffer:SetSettings(1, 1, true)
	var1_28.buffer:SetFleets({
		arg0_28.contextData.actFleets[var0_28],
		arg0_28.contextData.actFleets[var0_28 + 10]
	})

	local var2_28 = arg0_28.contextData.useOilLimit[var0_28]
	local var3_28 = arg0_28.contextData.exStageID

	if not arg0_28.contextData.activity:IsOilLimit(var3_28) then
		var2_28 = {
			0,
			0
		}
	end

	var1_28.buffer:SetOilLimit(var2_28)

	arg0_28.contextData.editFleet = var0_28

	var1_28.buffer:UpdateView()
	var1_28.buffer:Show()
end

function var0_0.ShowSPFleet(arg0_29)
	local var0_29 = #arg0_29.contextData.normalStageIDs + 2

	if not arg0_29.contextData.actFleets[var0_29] then
		arg0_29.contextData.actFleets[var0_29] = arg0_29:CreateNewFleet(var0_29)
	end

	if not arg0_29.contextData.actFleets[var0_29 + 10] then
		arg0_29.contextData.actFleets[var0_29 + 10] = arg0_29:CreateNewFleet(var0_29 + 10)
	end

	local var1_29 = arg0_29:GetFleetEditPanel()

	var1_29.buffer:SetSettings(1, 1, false)
	var1_29.buffer:SetFleets({
		arg0_29.contextData.actFleets[var0_29],
		arg0_29.contextData.actFleets[var0_29 + 10]
	})

	local var2_29 = {
		0,
		0
	}

	var1_29.buffer:SetOilLimit(var2_29)

	arg0_29.contextData.editFleet = var0_29

	var1_29.buffer:UpdateView()
	var1_29.buffer:Show()
end

function var0_0.commitEdit(arg0_30)
	arg0_30:emit(arg0_30.contextData.mediatorClass.ON_COMMIT_FLEET)
end

function var0_0.commitCombat(arg0_31)
	if arg0_31.contextData.editFleet <= #arg0_31.contextData.normalStageIDs then
		arg0_31:emit(arg0_31.contextData.mediatorClass.ON_PRECOMBAT, arg0_31.contextData.editFleet)
	elseif arg0_31.contextData.editFleet == #arg0_31.contextData.normalStageIDs + 1 then
		arg0_31:emit(arg0_31.contextData.mediatorClass.ON_EX_PRECOMBAT, arg0_31.contextData.editFleet, false)
	elseif arg0_31.contextData.editFleet <= #arg0_31.contextData.normalStageIDs + 2 then
		arg0_31:emit(arg0_31.contextData.mediatorClass.ON_SP_PRECOMBAT, arg0_31.contextData.editFleet, false)
	end
end

function var0_0.commitTrybat(arg0_32)
	arg0_32:emit(arg0_32.contextData.mediatorClass.ON_EX_PRECOMBAT, arg0_32.contextData.editFleet, true)
end

function var0_0.updateEditPanel(arg0_33)
	if arg0_33.fleetEditPanel then
		arg0_33.fleetEditPanel.buffer:UpdateView()
	end
end

function var0_0.hideFleetEdit(arg0_34)
	if arg0_34.fleetEditPanel then
		arg0_34.fleetEditPanel.buffer:Hide()
	end

	if arg0_34.commanderFormationPanel then
		arg0_34.commanderFormationPanel.buffer:Close()
	end

	arg0_34.contextData.editFleet = nil
end

function var0_0.openShipInfo(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg0_35.contextData.actFleets[arg2_35]
	local var1_35 = {}
	local var2_35 = getProxy(BayProxy)

	for iter0_35, iter1_35 in ipairs(var0_35 and var0_35.ships or {}) do
		table.insert(var1_35, var2_35:getShipById(iter1_35))
	end

	arg0_35:emit(arg0_35.contextData.mediatorClass.ON_FLEET_SHIPINFO, {
		shipId = arg1_35,
		shipVOs = var1_35
	})
end

function var0_0.setCommanderPrefabs(arg0_36, arg1_36)
	arg0_36.commanderPrefabs = arg1_36
end

function var0_0.openCommanderPanel(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37.contextData.activityID

	arg0_37.levelCMDFormationView:setCallback(function(arg0_38)
		if arg0_38.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_37:emit(ActivityBossMediatorTemplate.ON_COMMANDER_SKILL, arg0_38.skill)
		elseif arg0_38.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_37.contextData.eliteCommanderSelected = {
				fleetIndex = arg2_37,
				cmdPos = arg0_38.pos,
				mode = arg0_37.curMode
			}

			arg0_37:emit(ActivityBossMediatorTemplate.ON_SELECT_COMMANDER, arg2_37, arg0_38.pos)
		else
			arg0_37:emit(ActivityBossMediatorTemplate.COMMANDER_FORMATION_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_ACTIVITY,
				data = arg0_38,
				fleetId = arg1_37.id,
				actId = var0_37
			})
		end
	end)
	arg0_37.levelCMDFormationView:Load()
	arg0_37.levelCMDFormationView:ActionInvoke("update", arg1_37, arg0_37.commanderPrefabs)
	arg0_37.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderFleet(arg0_39, arg1_39)
	if arg0_39.levelCMDFormationView:isShowing() then
		arg0_39.levelCMDFormationView:ActionInvoke("updateFleet", arg1_39)
	end
end

function var0_0.updateCommanderPrefab(arg0_40)
	if arg0_40.levelCMDFormationView:isShowing() then
		arg0_40.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_40.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_41)
	if arg0_41.levelCMDFormationView:isShowing() then
		arg0_41.levelCMDFormationView:ActionInvoke("Hide")
	end
end

function var0_0.buildCommanderPanel(arg0_42)
	arg0_42.levelCMDFormationView = LevelCMDFormationView.New(arg0_42._tf, arg0_42.event, arg0_42.contextData)
end

function var0_0.destroyCommanderPanel(arg0_43)
	arg0_43.levelCMDFormationView:Destroy()

	arg0_43.levelCMDFormationView = nil
end

function var0_0.ShowAwards(arg0_44)
	local var0_44 = arg0_44:GetBonusWindow()

	var0_44.buffer:UpdateView(arg0_44.contextData.ptData)
	var0_44.buffer:Show()
end

function var0_0.CreateNewFleet(arg0_45, arg1_45)
	return TypedFleet.New({
		id = arg1_45,
		ship_list = {},
		commanders = {},
		fleetType = arg1_45 > 10 and FleetType.Submarine or FleetType.Normal
	})
end

function var0_0.UpdateRank(arg0_46, arg1_46)
	arg1_46 = arg1_46 or {}

	for iter0_46 = 1, #arg0_46.rankList do
		local var0_46 = arg0_46.rankList[iter0_46]

		setActive(var0_46, iter0_46 <= #arg1_46)

		if iter0_46 <= #arg1_46 then
			local var1_46 = var0_46:Find("Text")

			setText(var1_46, tostring(arg1_46[iter0_46].name))
		end
	end
end

function var0_0.UpdateDropItems(arg0_47)
	for iter0_47, iter1_47 in ipairs(arg0_47.contextData.DisplayItems or {}) do
		local var0_47 = arg0_47:findTF("milestone/item", arg0_47.barList[iter0_47])
		local var1_47 = Drop.New({
			type = arg0_47.contextData.DisplayItems[5 - iter0_47][1],
			id = arg0_47.contextData.DisplayItems[5 - iter0_47][2],
			count = arg0_47.contextData.DisplayItems[5 - iter0_47][3]
		})

		onButton(arg0_47, var0_47, function()
			arg0_47:emit(var0_0.ON_DROP, var1_47)
		end, SFX_PANEL)
	end
end

function var0_0.onBackPressed(arg0_49)
	if arg0_49.bonusWindow and arg0_49.bonusWindow:IsShowing() then
		arg0_49.bonusWindow.buffer:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_49)
end

function var0_0.willExit(arg0_50)
	arg0_50:DestroyBonusWindow()
	arg0_50:DestroyFleetEditPanel()
	arg0_50:destroyCommanderPanel()
end

return var0_0
