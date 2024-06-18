local var0_0 = class("NewActivityBossResultStatisticsPage", import("..NewBattleResultStatisticsPage"))

function var0_0.UpdateCommanders(arg0_1, arg1_1)
	parallelAsync({
		function(arg0_2)
			var0_0.super.UpdateCommanders(arg0_1, arg0_2)
		end,
		function(arg0_3)
			arg0_1:LoadActivityBossRes(arg0_3)
		end
	}, arg1_1)
end

local function var1_0(arg0_4, arg1_4, arg2_4)
	local var0_4 = getProxy(ActivityProxy):RawGetActivityById(arg0_4)
	local var1_4 = var0_4:getConfig("config_id")
	local var2_4 = pg.activity_event_worldboss[var1_4]
	local var3_4 = var0_4:IsOilLimit(arg1_4)
	local var4_4 = 0
	local var5_4 = var2_4.use_oil_limit[arg2_4]
	local var6_4 = getProxy(FleetProxy):getActivityFleets()[arg0_4][arg2_4]:GetCostSum().oil

	if var3_4 and var5_4[1] > 0 then
		var6_4 = math.min(var6_4, var5_4[1])
	end

	return var4_4 + var6_4
end

local function var2_0(arg0_5, arg1_5)
	return (getProxy(ActivityProxy):RawGetActivityById(arg0_5):GetStageBonus(arg1_5))
end

function var0_0.GetTicketItemID(arg0_6, arg1_6)
	local var0_6 = getProxy(ActivityProxy):RawGetActivityById(arg1_6):getConfig("config_id")

	return pg.activity_event_worldboss[var0_6].ticket
end

function var0_0.GetTicketUseCount(arg0_7)
	return 1
end

function var0_0.GetOilCost(arg0_8)
	if not (pg.battle_cost_template[arg0_8.contextData.system].oil_cost > 0) then
		return 0
	end

	return var1_0(arg0_8.contextData.actId, arg0_8.contextData.stageId, arg0_8.contextData.mainFleetId)
end

function var0_0.InitActivityPanel(arg0_9, arg1_9)
	arg1_9:SetAsFirstSibling()

	arg0_9.playAgain = arg1_9:Find("playAgain")
	arg0_9.toggle = arg1_9:Find("playAgain/ticket/checkbox")

	local var0_9 = arg0_9:GetOilCost()
	local var1_9 = var2_0(arg0_9.contextData.actId, arg0_9.contextData.stageId)

	setActive(arg1_9:Find("playAgain/bonus"), var1_9 > 0)
	setActive(arg1_9:Find("playAgain/ticket"), var1_9 <= 0)
	setText(arg1_9:Find("playAgain/bonus/Text"), var1_9)

	if var1_9 <= 0 then
		arg0_9:UpdateTicket(arg1_9)
	end

	setText(arg1_9:Find("playAgain/Text"), var0_9)
	setText(arg1_9:Find("playAgain/Image"), i18n("re_battle"))
	setText(arg1_9:Find("playAgain/bonus/title"), i18n("expedition_extra_drop_tip"))
end

function var0_0.UpdateTicket(arg0_10, arg1_10)
	local var0_10 = arg0_10:GetTicketItemID(arg0_10.contextData.actId)
	local var1_10 = GetSpriteFromAtlas(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var0_10
	}):getIcon(), "")

	setImageSprite(arg1_10:Find("playAgain/ticket/icon"), var1_10)

	local var2_10 = getProxy(PlayerProxy):getRawData():getResource(var0_10)
	local var3_10 = arg0_10:GetTicketUseCount()
	local var4_10 = var2_10 > 0

	var2_10 = var2_10 < var3_10 and setColorStr(var2_10, COLOR_RED) or var2_10

	setText(arg1_10:Find("playAgain/ticket/Text"), var3_10 .. "/" .. var2_10)

	local var5_10 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1

	setToggleEnabled(arg0_10.toggle, var4_10)
	triggerToggle(arg0_10.toggle, var4_10 and var5_10)
end

function var0_0.LoadActivityBossRes(arg0_11, arg1_11)
	ResourceMgr.Inst:getAssetAsync("BattleResultItems/Activityboss", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_12)
		if arg0_11.exited then
			return
		end

		local var0_12 = Object.Instantiate(arg0_12, arg0_11.bottomPanel)

		arg0_11:InitActivityPanel(var0_12.transform)
		arg1_11()
	end), true, true)
end

function var0_0.RegisterEvent(arg0_13, arg1_13)
	var0_0.super.RegisterEvent(arg0_13, arg1_13)
	onToggle(arg0_13, arg0_13.toggle, function(arg0_14)
		getProxy(SettingsProxy):setActBossExchangeTicketTip(arg0_14 and 1 or 0)
	end, SFX_PANEL, SFX_CANCEL)
	onButton(arg0_13, arg0_13.playAgain, function()
		arg0_13:OnPlayAgain(arg1_13)
	end, SFX_PANEL)
end

function var0_0.IsLastBonus(arg0_16)
	return arg0_16.contextData.isLastBonus
end

function var0_0.NotEnoughOilCost(arg0_17)
	local var0_17 = arg0_17:GetOilCost()

	if var0_17 > getProxy(PlayerProxy):getRawData().oil then
		return true, var0_17
	end

	return false
end

function var0_0.NotEnoughShipBag(arg0_18)
	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		return true
	end

	return false
end

function var0_0.NotEnoughEnergy(arg0_19)
	local var0_19 = getProxy(FleetProxy):getActivityFleets()[arg0_19.contextData.actId][arg0_19.contextData.mainFleetId]

	if _.any(_.values(var0_19.ships), function(arg0_20)
		local var0_20 = getProxy(BayProxy):getShipById(arg0_20)

		return var0_20 and var0_20.energy == Ship.ENERGY_LOW
	end) then
		return true, var0_19
	end

	return false
end

function var0_0.NotEnoughTicket(arg0_21)
	if var2_0(arg0_21.contextData.actId, arg0_21.contextData.stageId) > 0 then
		return false
	end

	local var0_21 = arg0_21:GetTicketItemID(arg0_21.contextData.actId)
	local var1_21 = getProxy(PlayerProxy):getRawData():getResource(var0_21)
	local var2_21 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1

	if var1_21 > 0 and var2_21 then
		return true
	end

	return false
end

function var0_0.OnPlayAgain(arg0_22, arg1_22)
	if arg0_22:IsLastBonus() then
		arg0_22:PassMsgbox("lastBonus", {
			content = i18n("expedition_drop_use_out")
		}, arg1_22)

		return
	end

	local var0_22, var1_22 = arg0_22:NotEnoughOilCost()

	if var0_22 then
		arg0_22:PassMsgbox("oil", var1_22, arg1_22)

		return
	end

	if arg0_22:NotEnoughShipBag() then
		arg0_22:PassMsgbox("shipCapacity", nil, arg1_22)

		return
	end

	local var2_22, var3_22 = arg0_22:NotEnoughEnergy()

	if var2_22 then
		arg0_22:PassMsgbox("energy", var3_22, arg1_22)

		return
	end

	if arg0_22:NotEnoughTicket() then
		pg.m02:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
			stageId = arg0_22.contextData.stageId
		})

		return
	end

	arg0_22:emit(NewBattleResultMediator.REENTER_STAGE)
end

function var0_0.PassMsgbox(arg0_23, arg1_23, arg2_23, arg3_23)
	getProxy(ContextProxy):GetPrevContext(1).data.msg = {
		type = arg1_23,
		param = arg2_23
	}

	arg3_23()
end

return var0_0
