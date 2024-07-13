local var0_0 = class("ActivityBossSceneTemplate", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	error("Need Complete")
end

var0_0.optionsPath = {
	"adapt/top/option"
}

function var0_0.init(arg0_2)
	arg0_2.mainTF = arg0_2:findTF("adapt")
	arg0_2.bg = arg0_2:findTF("bg")
	arg0_2.bottom = arg0_2:findTF("bottom", arg0_2.mainTF)
	arg0_2.hpBar = arg0_2:findTF("progress", arg0_2.bottom)
	arg0_2.barList = {}

	for iter0_2 = 1, 4 do
		arg0_2.barList[iter0_2] = arg0_2:findTF(iter0_2, arg0_2.hpBar)
	end

	arg0_2.progressDigit = arg0_2:findTF("digit", arg0_2.bottom)
	arg0_2.digitbig = arg0_2.progressDigit:Find("big")
	arg0_2.digitsmall = arg0_2.progressDigit:Find("small")
	arg0_2.left = arg0_2:findTF("left", arg0_2.mainTF)
	arg0_2.rankTF = arg0_2:findTF("rank", arg0_2.left)
	arg0_2.rankList = CustomIndexLayer.Clone2Full(arg0_2.rankTF:Find("layout"), 3)

	for iter1_2, iter2_2 in ipairs(arg0_2.rankList) do
		setActive(iter2_2, false)
	end

	arg0_2.right = arg0_2:findTF("right", arg0_2.mainTF)
	arg0_2.stageList = {}

	for iter3_2 = 1, 4 do
		arg0_2.stageList[iter3_2] = arg0_2:findTF(iter3_2, arg0_2.right)
	end

	arg0_2.stageSP = arg0_2:findTF("5", arg0_2.right)

	if not IsNil(arg0_2.stageSP) then
		setActive(arg0_2.stageSP, false)
	end

	arg0_2.awardFlash = arg0_2:findTF("ptaward/flash", arg0_2.right)
	arg0_2.awardBtn = arg0_2:findTF("ptaward/button", arg0_2.right)
	arg0_2.ptScoreTxt = arg0_2:findTF("ptaward/Text", arg0_2.right)
	arg0_2.top = arg0_2:findTF("top", arg0_2.mainTF)
	arg0_2.ticketNum = arg0_2:findTF("ticket/Text", arg0_2.top)
	arg0_2.helpBtn = arg0_2:findTF("help", arg0_2.top)

	onButton(arg0_2, arg0_2.top:Find("back_btn"), function()
		arg0_2:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	setActive(arg0_2.top, false)
	setAnchoredPosition(arg0_2.top, {
		y = 1080
	})
	setActive(arg0_2.left, false)
	setAnchoredPosition(arg0_2.left, {
		x = -1920
	})
	setActive(arg0_2.right, false)
	setAnchoredPosition(arg0_2.right, {
		x = 1920
	})
	setActive(arg0_2.bottom, false)
	setAnchoredPosition(arg0_2.bottom, {
		y = -1080
	})
	arg0_2:buildCommanderPanel()
end

function var0_0.GetBonusWindow(arg0_4)
	if not arg0_4.bonusWindow then
		arg0_4.bonusWindow = ActivityBossPtAwardSubPanel.New(arg0_4)

		arg0_4.bonusWindow:Load()
	end

	return arg0_4.bonusWindow
end

function var0_0.DestroyBonusWindow(arg0_5)
	if arg0_5.bonusWindow then
		arg0_5.bonusWindow:Destroy()

		arg0_5.bonusWindow = nil
	end
end

function var0_0.GetFleetEditPanel(arg0_6)
	if not arg0_6.fleetEditPanel then
		arg0_6.fleetEditPanel = ActivityBossBattleFleetSelectSubPanel.New(arg0_6)

		arg0_6.fleetEditPanel:Load()
	end

	return arg0_6.fleetEditPanel
end

function var0_0.DestroyFleetEditPanel(arg0_7)
	if arg0_7.fleetEditPanel then
		arg0_7.fleetEditPanel:Destroy()

		arg0_7.fleetEditPanel = nil
	end
end

function var0_0.EnterAnim(arg0_8)
	setActive(arg0_8.top, true)
	setActive(arg0_8.left, true)
	setActive(arg0_8.right, true)
	setActive(arg0_8.bottom, true)
	arg0_8.mainTF:GetComponent("Animation"):Play("Enter_Animation")
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9.awardBtn, function()
		arg0_9:ShowAwards()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help.tip
		})
	end, SFX_PANEL)
	arg0_9:UpdateDropItems()

	for iter0_9 = 1, #arg0_9.stageList - 1 do
		onButton(arg0_9, arg0_9.stageList[iter0_9], function()
			if arg0_9.contextData.activity:checkBattleTimeInBossAct() then
				arg0_9:ShowNormalFleet(iter0_9, true)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			end
		end, SFX_PANEL)
	end

	onButton(arg0_9, arg0_9.stageList[#arg0_9.stageList], function()
		if arg0_9.contextData.activity:checkBattleTimeInBossAct() then
			arg0_9:ShowEXFleet()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)

	if not IsNil(arg0_9.stageSP) then
		setActive(arg0_9.stageSP, arg0_9.contextData.spStageID)
		onButton(arg0_9, arg0_9.stageSP, function()
			if arg0_9.contextData.activity:checkBattleTimeInBossAct() then
				arg0_9:emit(ActivityBossMediatorTemplate.ONEN_BUFF_SELECT)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			end
		end, SFX_PANEL)
	end

	if arg0_9.contextData.editFleet then
		local var0_9 = arg0_9.contextData.editFleet

		if var0_9 <= #arg0_9.contextData.normalStageIDs then
			arg0_9:ShowNormalFleet(var0_9)
		elseif arg0_9.contextData.editFleet == #arg0_9.contextData.normalStageIDs + 1 then
			arg0_9:ShowEXFleet()
		elseif arg0_9.contextData.editFleet == #arg0_9.contextData.normalStageIDs + 2 then
			arg0_9:ShowSPFleet()
		end
	end

	arg0_9:EnterAnim()

	if arg0_9.contextData.msg then
		local var1_9 = arg0_9.contextData.msg.param

		switch(arg0_9.contextData.msg.type, {
			lastBonus = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox(var1_9)
			end,
			oil = function()
				if not ItemTipPanel.ShowOilBuyTip(var1_9) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))
				end
			end,
			shipCapacity = function()
				BeginStageCommand.DockOverload()
			end,
			energy = function()
				Fleet.EnergyCheck(_.map(_.values(var1_9.ships), function(arg0_19)
					return getProxy(BayProxy):getShipById(arg0_19)
				end), Fleet.DEFAULT_NAME_BOSS_ACT[var1_9.id], function(arg0_20)
					if arg0_20 then
						arg0_9:emit(PreCombatMediator.BEGIN_STAGE_PROXY, {
							curFleetId = var1_9.id
						})
					end
				end)
			end
		})

		arg0_9.contextData.msg = nil
	end
end

function var0_0.UpdateView(arg0_21)
	arg0_21:UpdatePage()
	arg0_21:CheckStory()
end

function var0_0.CheckStory(arg0_22)
	local var0_22 = pg.NewStoryMgr.GetInstance()
	local var1_22 = arg0_22.contextData.activity:getConfig("config_client").story

	table.SerialIpairsAsync(var1_22, function(arg0_23, arg1_23, arg2_23)
		if arg0_22.contextData.bossHP < arg1_23[1] + ((arg0_23 == 1 or arg1_23[1] == 0) and 1 or 0) and not pg.NewStoryMgr:GetInstance():IsPlayed(arg1_23[2]) then
			var0_22:Play(arg1_23[2], arg2_23)

			return
		end

		arg2_23()
	end)
end

function var0_0.UpdatePage(arg0_24)
	local var0_24 = arg0_24.contextData.bossHP

	setText(arg0_24.digitbig, math.floor(var0_24 / 100))
	setText(arg0_24.digitsmall, string.format("%02d", var0_24 % 100) .. "%")

	local var1_24 = pg.TimeMgr.GetInstance()

	for iter0_24 = 1, 4 do
		local var2_24 = arg0_24.barList[iter0_24]

		setSlider(arg0_24:findTF("Slider", var2_24), 0, 2500, math.min(math.max(var0_24 - (iter0_24 - 1) * 2500, 0), 2500))

		local var3_24 = arg0_24.contextData.mileStones[5 - iter0_24]

		setActive(arg0_24:findTF("milestone/item", var2_24), not var3_24)
		setActive(arg0_24:findTF("milestone/time", var2_24), var3_24)

		if var3_24 then
			local var4_24 = var1_24:STimeDescC(arg0_24.contextData.mileStones[5 - iter0_24], "%m/%d/%H:%M")

			setText(arg0_24:findTF("milestone/time/Text", var2_24), var4_24)
		end
	end

	for iter1_24 = 1, #arg0_24.stageList - 1 do
		local var5_24 = arg0_24.contextData.normalStageIDs[iter1_24]
		local var6_24 = arg0_24.stageList[iter1_24]

		for iter2_24, iter3_24 in ipairs(arg0_24.contextData.ticketInitPools) do
			for iter4_24, iter5_24 in ipairs(iter3_24[1]) do
				if iter5_24 == var5_24 then
					local var7_24 = iter3_24[2]
					local var8_24 = arg0_24.contextData.stageTickets[var5_24] or 0

					setActive(var6_24:Find("Text"), var8_24 > 0)
					setText(var6_24:Find("Text"), string.format("%d/%d", var8_24, var7_24))
				end
			end
		end
	end

	setText(arg0_24.ptScoreTxt, arg0_24.contextData.ptData.count)
	setActive(arg0_24.awardFlash, arg0_24.contextData.ptData:CanGetAward())

	if arg0_24.bonusWindow and arg0_24.bonusWindow:IsShowing() then
		arg0_24.bonusWindow.buffer:UpdateView(arg0_24.contextData.ptData)
	end

	local var9_24 = arg0_24:GetEXTicket()

	setText(arg0_24.ticketNum, var9_24)
end

function var0_0.GetEXTicket(arg0_25)
	return getProxy(PlayerProxy):getRawData():getResource(arg0_25.contextData.TicketID)
end

function var0_0.ShowNormalFleet(arg0_26, arg1_26, arg2_26)
	if not arg0_26.contextData.actFleets[arg1_26] then
		arg0_26.contextData.actFleets[arg1_26] = arg0_26:CreateNewFleet(arg1_26)
	end

	if not arg0_26.contextData.actFleets[arg1_26 + 10] then
		arg0_26.contextData.actFleets[arg1_26 + 10] = arg0_26:CreateNewFleet(arg1_26 + 10)
	end

	local var0_26 = arg0_26.contextData.actFleets[arg1_26]

	if arg2_26 and #var0_26.ships <= 0 then
		for iter0_26 = #arg0_26.contextData.normalStageIDs, 1, -1 do
			local var1_26 = arg0_26.contextData.actFleets[iter0_26]

			if iter0_26 ~= arg1_26 and var1_26 and var1_26:isLegalToFight() == true then
				var0_26:updateShips(var1_26.ships)

				break
			end
		end
	end

	local var2_26 = arg0_26:GetFleetEditPanel()

	var2_26.buffer:SetSettings(1, 1, false)
	var2_26.buffer:SetFleets({
		arg0_26.contextData.actFleets[arg1_26],
		arg0_26.contextData.actFleets[arg1_26 + 10]
	})

	local var3_26 = arg0_26.contextData.useOilLimit[arg1_26]
	local var4_26 = arg0_26.contextData.normalStageIDs[arg1_26]

	if not arg0_26.contextData.activity:IsOilLimit(var4_26) then
		var3_26 = {
			0,
			0
		}
	end

	var2_26.buffer:SetOilLimit(var3_26)

	arg0_26.contextData.editFleet = arg1_26

	var2_26.buffer:UpdateView()
	var2_26.buffer:Show()
end

function var0_0.ShowEXFleet(arg0_27)
	local var0_27 = #arg0_27.contextData.normalStageIDs + 1

	if not arg0_27.contextData.actFleets[var0_27] then
		arg0_27.contextData.actFleets[var0_27] = arg0_27:CreateNewFleet(var0_27)
	end

	if not arg0_27.contextData.actFleets[var0_27 + 10] then
		arg0_27.contextData.actFleets[var0_27 + 10] = arg0_27:CreateNewFleet(var0_27 + 10)
	end

	local var1_27 = arg0_27:GetFleetEditPanel()

	var1_27.buffer:SetSettings(1, 1, true)
	var1_27.buffer:SetFleets({
		arg0_27.contextData.actFleets[var0_27],
		arg0_27.contextData.actFleets[var0_27 + 10]
	})

	local var2_27 = arg0_27.contextData.useOilLimit[var0_27]
	local var3_27 = arg0_27.contextData.exStageID

	if not arg0_27.contextData.activity:IsOilLimit(var3_27) then
		var2_27 = {
			0,
			0
		}
	end

	var1_27.buffer:SetOilLimit(var2_27)

	arg0_27.contextData.editFleet = var0_27

	var1_27.buffer:UpdateView()
	var1_27.buffer:Show()
end

function var0_0.ShowSPFleet(arg0_28)
	local var0_28 = #arg0_28.contextData.normalStageIDs + 2

	if not arg0_28.contextData.actFleets[var0_28] then
		arg0_28.contextData.actFleets[var0_28] = arg0_28:CreateNewFleet(var0_28)
	end

	if not arg0_28.contextData.actFleets[var0_28 + 10] then
		arg0_28.contextData.actFleets[var0_28 + 10] = arg0_28:CreateNewFleet(var0_28 + 10)
	end

	local var1_28 = arg0_28:GetFleetEditPanel()

	var1_28.buffer:SetSettings(1, 1, false)
	var1_28.buffer:SetFleets({
		arg0_28.contextData.actFleets[var0_28],
		arg0_28.contextData.actFleets[var0_28 + 10]
	})

	local var2_28 = {
		0,
		0
	}

	var1_28.buffer:SetOilLimit(var2_28)

	arg0_28.contextData.editFleet = var0_28

	var1_28.buffer:UpdateView()
	var1_28.buffer:Show()
end

function var0_0.commitEdit(arg0_29)
	arg0_29:emit(arg0_29.contextData.mediatorClass.ON_COMMIT_FLEET)
end

function var0_0.commitCombat(arg0_30)
	if arg0_30.contextData.editFleet <= #arg0_30.contextData.normalStageIDs then
		arg0_30:emit(arg0_30.contextData.mediatorClass.ON_PRECOMBAT, arg0_30.contextData.editFleet)
	elseif arg0_30.contextData.editFleet == #arg0_30.contextData.normalStageIDs + 1 then
		arg0_30:emit(arg0_30.contextData.mediatorClass.ON_EX_PRECOMBAT, arg0_30.contextData.editFleet, false)
	elseif arg0_30.contextData.editFleet <= #arg0_30.contextData.normalStageIDs + 2 then
		arg0_30:emit(arg0_30.contextData.mediatorClass.ON_SP_PRECOMBAT, arg0_30.contextData.editFleet, false)
	end
end

function var0_0.commitTrybat(arg0_31)
	arg0_31:emit(arg0_31.contextData.mediatorClass.ON_EX_PRECOMBAT, arg0_31.contextData.editFleet, true)
end

function var0_0.updateEditPanel(arg0_32)
	if arg0_32.fleetEditPanel then
		arg0_32.fleetEditPanel.buffer:UpdateView()
	end
end

function var0_0.hideFleetEdit(arg0_33)
	if arg0_33.fleetEditPanel then
		arg0_33.fleetEditPanel.buffer:Hide()
	end

	if arg0_33.commanderFormationPanel then
		arg0_33.commanderFormationPanel.buffer:Close()
	end

	arg0_33.contextData.editFleet = nil
end

function var0_0.openShipInfo(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.contextData.actFleets[arg2_34]
	local var1_34 = {}
	local var2_34 = getProxy(BayProxy)

	for iter0_34, iter1_34 in ipairs(var0_34 and var0_34.ships or {}) do
		table.insert(var1_34, var2_34:getShipById(iter1_34))
	end

	arg0_34:emit(arg0_34.contextData.mediatorClass.ON_FLEET_SHIPINFO, {
		shipId = arg1_34,
		shipVOs = var1_34
	})
end

function var0_0.setCommanderPrefabs(arg0_35, arg1_35)
	arg0_35.commanderPrefabs = arg1_35
end

function var0_0.openCommanderPanel(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36.contextData.activityID

	arg0_36.levelCMDFormationView:setCallback(function(arg0_37)
		if arg0_37.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0_36:emit(ActivityBossMediatorTemplate.ON_COMMANDER_SKILL, arg0_37.skill)
		elseif arg0_37.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0_36.contextData.eliteCommanderSelected = {
				fleetIndex = arg2_36,
				cmdPos = arg0_37.pos,
				mode = arg0_36.curMode
			}

			arg0_36:emit(ActivityBossMediatorTemplate.ON_SELECT_COMMANDER, arg2_36, arg0_37.pos)
		else
			arg0_36:emit(ActivityBossMediatorTemplate.COMMANDER_FORMATION_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_ACTIVITY,
				data = arg0_37,
				fleetId = arg1_36.id,
				actId = var0_36
			})
		end
	end)
	arg0_36.levelCMDFormationView:Load()
	arg0_36.levelCMDFormationView:ActionInvoke("update", arg1_36, arg0_36.commanderPrefabs)
	arg0_36.levelCMDFormationView:ActionInvoke("Show")
end

function var0_0.updateCommanderFleet(arg0_38, arg1_38)
	if arg0_38.levelCMDFormationView:isShowing() then
		arg0_38.levelCMDFormationView:ActionInvoke("updateFleet", arg1_38)
	end
end

function var0_0.updateCommanderPrefab(arg0_39)
	if arg0_39.levelCMDFormationView:isShowing() then
		arg0_39.levelCMDFormationView:ActionInvoke("updatePrefabs", arg0_39.commanderPrefabs)
	end
end

function var0_0.closeCommanderPanel(arg0_40)
	if arg0_40.levelCMDFormationView:isShowing() then
		arg0_40.levelCMDFormationView:ActionInvoke("Hide")
	end
end

function var0_0.buildCommanderPanel(arg0_41)
	arg0_41.levelCMDFormationView = LevelCMDFormationView.New(arg0_41._tf, arg0_41.event, arg0_41.contextData)
end

function var0_0.destroyCommanderPanel(arg0_42)
	arg0_42.levelCMDFormationView:Destroy()

	arg0_42.levelCMDFormationView = nil
end

function var0_0.ShowAwards(arg0_43)
	local var0_43 = arg0_43:GetBonusWindow()

	var0_43.buffer:UpdateView(arg0_43.contextData.ptData)
	var0_43.buffer:Show()
end

function var0_0.CreateNewFleet(arg0_44, arg1_44)
	return TypedFleet.New({
		id = arg1_44,
		ship_list = {},
		commanders = {},
		fleetType = arg1_44 > 10 and FleetType.Submarine or FleetType.Normal
	})
end

function var0_0.UpdateRank(arg0_45, arg1_45)
	arg1_45 = arg1_45 or {}

	for iter0_45 = 1, #arg0_45.rankList do
		local var0_45 = arg0_45.rankList[iter0_45]

		setActive(var0_45, iter0_45 <= #arg1_45)

		if iter0_45 <= #arg1_45 then
			local var1_45 = var0_45:Find("Text")

			setText(var1_45, tostring(arg1_45[iter0_45].name))
		end
	end
end

function var0_0.UpdateDropItems(arg0_46)
	for iter0_46, iter1_46 in ipairs(arg0_46.contextData.DisplayItems or {}) do
		local var0_46 = arg0_46:findTF("milestone/item", arg0_46.barList[iter0_46])
		local var1_46 = Drop.New({
			type = arg0_46.contextData.DisplayItems[5 - iter0_46][1],
			id = arg0_46.contextData.DisplayItems[5 - iter0_46][2],
			count = arg0_46.contextData.DisplayItems[5 - iter0_46][3]
		})

		onButton(arg0_46, var0_46, function()
			arg0_46:emit(var0_0.ON_DROP, var1_46)
		end, SFX_PANEL)
	end
end

function var0_0.onBackPressed(arg0_48)
	if arg0_48.bonusWindow and arg0_48.bonusWindow:IsShowing() then
		arg0_48.bonusWindow.buffer:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_48)
end

function var0_0.willExit(arg0_49)
	arg0_49:DestroyBonusWindow()
	arg0_49:DestroyFleetEditPanel()
	arg0_49:destroyCommanderPanel()
end

return var0_0
