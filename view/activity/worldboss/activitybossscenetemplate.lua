local var0 = class("ActivityBossSceneTemplate", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	error("Need Complete")
end

var0.optionsPath = {
	"adapt/top/option"
}

function var0.init(arg0)
	arg0.mainTF = arg0:findTF("adapt")
	arg0.bg = arg0:findTF("bg")
	arg0.bottom = arg0:findTF("bottom", arg0.mainTF)
	arg0.hpBar = arg0:findTF("progress", arg0.bottom)
	arg0.barList = {}

	for iter0 = 1, 4 do
		arg0.barList[iter0] = arg0:findTF(iter0, arg0.hpBar)
	end

	arg0.progressDigit = arg0:findTF("digit", arg0.bottom)
	arg0.digitbig = arg0.progressDigit:Find("big")
	arg0.digitsmall = arg0.progressDigit:Find("small")
	arg0.left = arg0:findTF("left", arg0.mainTF)
	arg0.rankTF = arg0:findTF("rank", arg0.left)
	arg0.rankList = CustomIndexLayer.Clone2Full(arg0.rankTF:Find("layout"), 3)

	for iter1, iter2 in ipairs(arg0.rankList) do
		setActive(iter2, false)
	end

	arg0.right = arg0:findTF("right", arg0.mainTF)
	arg0.stageList = {}

	for iter3 = 1, 4 do
		arg0.stageList[iter3] = arg0:findTF(iter3, arg0.right)
	end

	arg0.stageSP = arg0:findTF("5", arg0.right)

	if not IsNil(arg0.stageSP) then
		setActive(arg0.stageSP, false)
	end

	arg0.awardFlash = arg0:findTF("ptaward/flash", arg0.right)
	arg0.awardBtn = arg0:findTF("ptaward/button", arg0.right)
	arg0.ptScoreTxt = arg0:findTF("ptaward/Text", arg0.right)
	arg0.top = arg0:findTF("top", arg0.mainTF)
	arg0.ticketNum = arg0:findTF("ticket/Text", arg0.top)
	arg0.helpBtn = arg0:findTF("help", arg0.top)

	onButton(arg0, arg0.top:Find("back_btn"), function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	setActive(arg0.top, false)
	setAnchoredPosition(arg0.top, {
		y = 1080
	})
	setActive(arg0.left, false)
	setAnchoredPosition(arg0.left, {
		x = -1920
	})
	setActive(arg0.right, false)
	setAnchoredPosition(arg0.right, {
		x = 1920
	})
	setActive(arg0.bottom, false)
	setAnchoredPosition(arg0.bottom, {
		y = -1080
	})
	arg0:buildCommanderPanel()
end

function var0.GetBonusWindow(arg0)
	if not arg0.bonusWindow then
		arg0.bonusWindow = ActivityBossPtAwardSubPanel.New(arg0)

		arg0.bonusWindow:Load()
	end

	return arg0.bonusWindow
end

function var0.DestroyBonusWindow(arg0)
	if arg0.bonusWindow then
		arg0.bonusWindow:Destroy()

		arg0.bonusWindow = nil
	end
end

function var0.GetFleetEditPanel(arg0)
	if not arg0.fleetEditPanel then
		arg0.fleetEditPanel = ActivityBossBattleFleetSelectSubPanel.New(arg0)

		arg0.fleetEditPanel:Load()
	end

	return arg0.fleetEditPanel
end

function var0.DestroyFleetEditPanel(arg0)
	if arg0.fleetEditPanel then
		arg0.fleetEditPanel:Destroy()

		arg0.fleetEditPanel = nil
	end
end

function var0.EnterAnim(arg0)
	setActive(arg0.top, true)
	setActive(arg0.left, true)
	setActive(arg0.right, true)
	setActive(arg0.bottom, true)
	arg0.mainTF:GetComponent("Animation"):Play("Enter_Animation")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.awardBtn, function()
		arg0:ShowAwards()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help.tip
		})
	end, SFX_PANEL)
	arg0:UpdateDropItems()

	for iter0 = 1, #arg0.stageList - 1 do
		onButton(arg0, arg0.stageList[iter0], function()
			if arg0.contextData.activity:checkBattleTimeInBossAct() then
				arg0:ShowNormalFleet(iter0, true)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			end
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.stageList[#arg0.stageList], function()
		if arg0.contextData.activity:checkBattleTimeInBossAct() then
			arg0:ShowEXFleet()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)

	if not IsNil(arg0.stageSP) then
		setActive(arg0.stageSP, arg0.contextData.spStageID)
		onButton(arg0, arg0.stageSP, function()
			if arg0.contextData.activity:checkBattleTimeInBossAct() then
				arg0:emit(ActivityBossMediatorTemplate.ONEN_BUFF_SELECT)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			end
		end, SFX_PANEL)
	end

	if arg0.contextData.editFleet then
		local var0 = arg0.contextData.editFleet

		if var0 <= #arg0.contextData.normalStageIDs then
			arg0:ShowNormalFleet(var0)
		elseif arg0.contextData.editFleet == #arg0.contextData.normalStageIDs + 1 then
			arg0:ShowEXFleet()
		elseif arg0.contextData.editFleet == #arg0.contextData.normalStageIDs + 2 then
			arg0:ShowSPFleet()
		end
	end

	arg0:EnterAnim()

	if arg0.contextData.msg then
		local var1 = arg0.contextData.msg.param

		switch(arg0.contextData.msg.type, {
			lastBonus = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox(var1)
			end,
			oil = function()
				if not ItemTipPanel.ShowOilBuyTip(var1) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))
				end
			end,
			shipCapacity = function()
				BeginStageCommand.DockOverload()
			end,
			energy = function()
				Fleet.EnergyCheck(_.map(_.values(var1.ships), function(arg0)
					return getProxy(BayProxy):getShipById(arg0)
				end), Fleet.DEFAULT_NAME_BOSS_ACT[var1.id], function(arg0)
					if arg0 then
						arg0:emit(PreCombatMediator.BEGIN_STAGE_PROXY, {
							curFleetId = var1.id
						})
					end
				end)
			end
		})

		arg0.contextData.msg = nil
	end
end

function var0.UpdateView(arg0)
	arg0:UpdatePage()
	arg0:CheckStory()
end

function var0.CheckStory(arg0)
	local var0 = pg.NewStoryMgr.GetInstance()
	local var1 = arg0.contextData.activity:getConfig("config_client").story

	table.SerialIpairsAsync(var1, function(arg0, arg1, arg2)
		if arg0.contextData.bossHP < arg1[1] + ((arg0 == 1 or arg1[1] == 0) and 1 or 0) and not pg.NewStoryMgr:GetInstance():IsPlayed(arg1[2]) then
			var0:Play(arg1[2], arg2)

			return
		end

		arg2()
	end)
end

function var0.UpdatePage(arg0)
	local var0 = arg0.contextData.bossHP

	setText(arg0.digitbig, math.floor(var0 / 100))
	setText(arg0.digitsmall, string.format("%02d", var0 % 100) .. "%")

	local var1 = pg.TimeMgr.GetInstance()

	for iter0 = 1, 4 do
		local var2 = arg0.barList[iter0]

		setSlider(arg0:findTF("Slider", var2), 0, 2500, math.min(math.max(var0 - (iter0 - 1) * 2500, 0), 2500))

		local var3 = arg0.contextData.mileStones[5 - iter0]

		setActive(arg0:findTF("milestone/item", var2), not var3)
		setActive(arg0:findTF("milestone/time", var2), var3)

		if var3 then
			local var4 = var1:STimeDescC(arg0.contextData.mileStones[5 - iter0], "%m/%d/%H:%M")

			setText(arg0:findTF("milestone/time/Text", var2), var4)
		end
	end

	for iter1 = 1, #arg0.stageList - 1 do
		local var5 = arg0.contextData.normalStageIDs[iter1]
		local var6 = arg0.stageList[iter1]

		for iter2, iter3 in ipairs(arg0.contextData.ticketInitPools) do
			for iter4, iter5 in ipairs(iter3[1]) do
				if iter5 == var5 then
					local var7 = iter3[2]
					local var8 = arg0.contextData.stageTickets[var5] or 0

					setActive(var6:Find("Text"), var8 > 0)
					setText(var6:Find("Text"), string.format("%d/%d", var8, var7))
				end
			end
		end
	end

	setText(arg0.ptScoreTxt, arg0.contextData.ptData.count)
	setActive(arg0.awardFlash, arg0.contextData.ptData:CanGetAward())

	if arg0.bonusWindow and arg0.bonusWindow:IsShowing() then
		arg0.bonusWindow.buffer:UpdateView(arg0.contextData.ptData)
	end

	local var9 = arg0:GetEXTicket()

	setText(arg0.ticketNum, var9)
end

function var0.GetEXTicket(arg0)
	return getProxy(PlayerProxy):getRawData():getResource(arg0.contextData.TicketID)
end

function var0.ShowNormalFleet(arg0, arg1, arg2)
	if not arg0.contextData.actFleets[arg1] then
		arg0.contextData.actFleets[arg1] = arg0:CreateNewFleet(arg1)
	end

	if not arg0.contextData.actFleets[arg1 + 10] then
		arg0.contextData.actFleets[arg1 + 10] = arg0:CreateNewFleet(arg1 + 10)
	end

	local var0 = arg0.contextData.actFleets[arg1]

	if arg2 and #var0.ships <= 0 then
		for iter0 = #arg0.contextData.normalStageIDs, 1, -1 do
			local var1 = arg0.contextData.actFleets[iter0]

			if iter0 ~= arg1 and var1 and var1:isLegalToFight() == true then
				var0:updateShips(var1.ships)

				break
			end
		end
	end

	local var2 = arg0:GetFleetEditPanel()

	var2.buffer:SetSettings(1, 1, false)
	var2.buffer:SetFleets({
		arg0.contextData.actFleets[arg1],
		arg0.contextData.actFleets[arg1 + 10]
	})

	local var3 = arg0.contextData.useOilLimit[arg1]
	local var4 = arg0.contextData.normalStageIDs[arg1]

	if not arg0.contextData.activity:IsOilLimit(var4) then
		var3 = {
			0,
			0
		}
	end

	var2.buffer:SetOilLimit(var3)

	arg0.contextData.editFleet = arg1

	var2.buffer:UpdateView()
	var2.buffer:Show()
end

function var0.ShowEXFleet(arg0)
	local var0 = #arg0.contextData.normalStageIDs + 1

	if not arg0.contextData.actFleets[var0] then
		arg0.contextData.actFleets[var0] = arg0:CreateNewFleet(var0)
	end

	if not arg0.contextData.actFleets[var0 + 10] then
		arg0.contextData.actFleets[var0 + 10] = arg0:CreateNewFleet(var0 + 10)
	end

	local var1 = arg0:GetFleetEditPanel()

	var1.buffer:SetSettings(1, 1, true)
	var1.buffer:SetFleets({
		arg0.contextData.actFleets[var0],
		arg0.contextData.actFleets[var0 + 10]
	})

	local var2 = arg0.contextData.useOilLimit[var0]
	local var3 = arg0.contextData.exStageID

	if not arg0.contextData.activity:IsOilLimit(var3) then
		var2 = {
			0,
			0
		}
	end

	var1.buffer:SetOilLimit(var2)

	arg0.contextData.editFleet = var0

	var1.buffer:UpdateView()
	var1.buffer:Show()
end

function var0.ShowSPFleet(arg0)
	local var0 = #arg0.contextData.normalStageIDs + 2

	if not arg0.contextData.actFleets[var0] then
		arg0.contextData.actFleets[var0] = arg0:CreateNewFleet(var0)
	end

	if not arg0.contextData.actFleets[var0 + 10] then
		arg0.contextData.actFleets[var0 + 10] = arg0:CreateNewFleet(var0 + 10)
	end

	local var1 = arg0:GetFleetEditPanel()

	var1.buffer:SetSettings(1, 1, false)
	var1.buffer:SetFleets({
		arg0.contextData.actFleets[var0],
		arg0.contextData.actFleets[var0 + 10]
	})

	local var2 = {
		0,
		0
	}

	var1.buffer:SetOilLimit(var2)

	arg0.contextData.editFleet = var0

	var1.buffer:UpdateView()
	var1.buffer:Show()
end

function var0.commitEdit(arg0)
	arg0:emit(arg0.contextData.mediatorClass.ON_COMMIT_FLEET)
end

function var0.commitCombat(arg0)
	if arg0.contextData.editFleet <= #arg0.contextData.normalStageIDs then
		arg0:emit(arg0.contextData.mediatorClass.ON_PRECOMBAT, arg0.contextData.editFleet)
	elseif arg0.contextData.editFleet == #arg0.contextData.normalStageIDs + 1 then
		arg0:emit(arg0.contextData.mediatorClass.ON_EX_PRECOMBAT, arg0.contextData.editFleet, false)
	elseif arg0.contextData.editFleet <= #arg0.contextData.normalStageIDs + 2 then
		arg0:emit(arg0.contextData.mediatorClass.ON_SP_PRECOMBAT, arg0.contextData.editFleet, false)
	end
end

function var0.commitTrybat(arg0)
	arg0:emit(arg0.contextData.mediatorClass.ON_EX_PRECOMBAT, arg0.contextData.editFleet, true)
end

function var0.updateEditPanel(arg0)
	if arg0.fleetEditPanel then
		arg0.fleetEditPanel.buffer:UpdateView()
	end
end

function var0.hideFleetEdit(arg0)
	if arg0.fleetEditPanel then
		arg0.fleetEditPanel.buffer:Hide()
	end

	if arg0.commanderFormationPanel then
		arg0.commanderFormationPanel.buffer:Close()
	end

	arg0.contextData.editFleet = nil
end

function var0.openShipInfo(arg0, arg1, arg2)
	local var0 = arg0.contextData.actFleets[arg2]
	local var1 = {}
	local var2 = getProxy(BayProxy)

	for iter0, iter1 in ipairs(var0 and var0.ships or {}) do
		table.insert(var1, var2:getShipById(iter1))
	end

	arg0:emit(arg0.contextData.mediatorClass.ON_FLEET_SHIPINFO, {
		shipId = arg1,
		shipVOs = var1
	})
end

function var0.setCommanderPrefabs(arg0, arg1)
	arg0.commanderPrefabs = arg1
end

function var0.openCommanderPanel(arg0, arg1, arg2)
	local var0 = arg0.contextData.activityID

	arg0.levelCMDFormationView:setCallback(function(arg0)
		if arg0.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			arg0:emit(ActivityBossMediatorTemplate.ON_COMMANDER_SKILL, arg0.skill)
		elseif arg0.type == LevelUIConst.COMMANDER_OP_ADD then
			arg0.contextData.eliteCommanderSelected = {
				fleetIndex = arg2,
				cmdPos = arg0.pos,
				mode = arg0.curMode
			}

			arg0:emit(ActivityBossMediatorTemplate.ON_SELECT_COMMANDER, arg2, arg0.pos)
		else
			arg0:emit(ActivityBossMediatorTemplate.COMMANDER_FORMATION_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_ACTIVITY,
				data = arg0,
				fleetId = arg1.id,
				actId = var0
			})
		end
	end)
	arg0.levelCMDFormationView:Load()
	arg0.levelCMDFormationView:ActionInvoke("update", arg1, arg0.commanderPrefabs)
	arg0.levelCMDFormationView:ActionInvoke("Show")
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

function var0.closeCommanderPanel(arg0)
	if arg0.levelCMDFormationView:isShowing() then
		arg0.levelCMDFormationView:ActionInvoke("Hide")
	end
end

function var0.buildCommanderPanel(arg0)
	arg0.levelCMDFormationView = LevelCMDFormationView.New(arg0._tf, arg0.event, arg0.contextData)
end

function var0.destroyCommanderPanel(arg0)
	arg0.levelCMDFormationView:Destroy()

	arg0.levelCMDFormationView = nil
end

function var0.ShowAwards(arg0)
	local var0 = arg0:GetBonusWindow()

	var0.buffer:UpdateView(arg0.contextData.ptData)
	var0.buffer:Show()
end

function var0.CreateNewFleet(arg0, arg1)
	return TypedFleet.New({
		id = arg1,
		ship_list = {},
		commanders = {},
		fleetType = arg1 > 10 and FleetType.Submarine or FleetType.Normal
	})
end

function var0.UpdateRank(arg0, arg1)
	arg1 = arg1 or {}

	for iter0 = 1, #arg0.rankList do
		local var0 = arg0.rankList[iter0]

		setActive(var0, iter0 <= #arg1)

		if iter0 <= #arg1 then
			local var1 = var0:Find("Text")

			setText(var1, tostring(arg1[iter0].name))
		end
	end
end

function var0.UpdateDropItems(arg0)
	for iter0, iter1 in ipairs(arg0.contextData.DisplayItems or {}) do
		local var0 = arg0:findTF("milestone/item", arg0.barList[iter0])
		local var1 = Drop.New({
			type = arg0.contextData.DisplayItems[5 - iter0][1],
			id = arg0.contextData.DisplayItems[5 - iter0][2],
			count = arg0.contextData.DisplayItems[5 - iter0][3]
		})

		onButton(arg0, var0, function()
			arg0:emit(var0.ON_DROP, var1)
		end, SFX_PANEL)
	end
end

function var0.onBackPressed(arg0)
	if arg0.bonusWindow and arg0.bonusWindow:IsShowing() then
		arg0.bonusWindow.buffer:Hide()

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	arg0:DestroyBonusWindow()
	arg0:DestroyFleetEditPanel()
	arg0:destroyCommanderPanel()
end

return var0
