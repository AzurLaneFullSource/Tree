local var0 = class("NewActivityBossResultStatisticsPage", import("..NewBattleResultStatisticsPage"))

function var0.UpdateCommanders(arg0, arg1)
	parallelAsync({
		function(arg0)
			var0.super.UpdateCommanders(arg0, arg0)
		end,
		function(arg0)
			arg0:LoadActivityBossRes(arg0)
		end
	}, arg1)
end

local function var1(arg0, arg1, arg2)
	local var0 = getProxy(ActivityProxy):RawGetActivityById(arg0)
	local var1 = var0:getConfig("config_id")
	local var2 = pg.activity_event_worldboss[var1]
	local var3 = var0:IsOilLimit(arg1)
	local var4 = 0
	local var5 = var2.use_oil_limit[arg2]
	local var6 = getProxy(FleetProxy):getActivityFleets()[arg0][arg2]:GetCostSum().oil

	if var3 and var5[1] > 0 then
		var6 = math.min(var6, var5[1])
	end

	return var4 + var6
end

local function var2(arg0, arg1)
	return (getProxy(ActivityProxy):RawGetActivityById(arg0):GetStageBonus(arg1))
end

function var0.GetTicketItemID(arg0, arg1)
	local var0 = getProxy(ActivityProxy):RawGetActivityById(arg1):getConfig("config_id")

	return pg.activity_event_worldboss[var0].ticket
end

function var0.GetTicketUseCount(arg0)
	return 1
end

function var0.GetOilCost(arg0)
	if not (pg.battle_cost_template[arg0.contextData.system].oil_cost > 0) then
		return 0
	end

	return var1(arg0.contextData.actId, arg0.contextData.stageId, arg0.contextData.mainFleetId)
end

function var0.InitActivityPanel(arg0, arg1)
	arg1:SetAsFirstSibling()

	arg0.playAgain = arg1:Find("playAgain")
	arg0.toggle = arg1:Find("playAgain/ticket/checkbox")

	local var0 = arg0:GetOilCost()
	local var1 = var2(arg0.contextData.actId, arg0.contextData.stageId)

	setActive(arg1:Find("playAgain/bonus"), var1 > 0)
	setActive(arg1:Find("playAgain/ticket"), var1 <= 0)
	setText(arg1:Find("playAgain/bonus/Text"), var1)

	if var1 <= 0 then
		arg0:UpdateTicket(arg1)
	end

	setText(arg1:Find("playAgain/Text"), var0)
	setText(arg1:Find("playAgain/Image"), i18n("re_battle"))
	setText(arg1:Find("playAgain/bonus/title"), i18n("expedition_extra_drop_tip"))
end

function var0.UpdateTicket(arg0, arg1)
	local var0 = arg0:GetTicketItemID(arg0.contextData.actId)
	local var1 = GetSpriteFromAtlas(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var0
	}):getIcon(), "")

	setImageSprite(arg1:Find("playAgain/ticket/icon"), var1)

	local var2 = getProxy(PlayerProxy):getRawData():getResource(var0)
	local var3 = arg0:GetTicketUseCount()
	local var4 = var2 > 0

	var2 = var2 < var3 and setColorStr(var2, COLOR_RED) or var2

	setText(arg1:Find("playAgain/ticket/Text"), var3 .. "/" .. var2)

	local var5 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1

	setToggleEnabled(arg0.toggle, var4)
	triggerToggle(arg0.toggle, var4 and var5)
end

function var0.LoadActivityBossRes(arg0, arg1)
	ResourceMgr.Inst:getAssetAsync("BattleResultItems/Activityboss", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited then
			return
		end

		local var0 = Object.Instantiate(arg0, arg0.bottomPanel)

		arg0:InitActivityPanel(var0.transform)
		arg1()
	end), true, true)
end

function var0.RegisterEvent(arg0, arg1)
	var0.super.RegisterEvent(arg0, arg1)
	onToggle(arg0, arg0.toggle, function(arg0)
		getProxy(SettingsProxy):setActBossExchangeTicketTip(arg0 and 1 or 0)
	end, SFX_PANEL, SFX_CANCEL)
	onButton(arg0, arg0.playAgain, function()
		arg0:OnPlayAgain(arg1)
	end, SFX_PANEL)
end

function var0.IsLastBonus(arg0)
	return arg0.contextData.isLastBonus
end

function var0.NotEnoughOilCost(arg0)
	local var0 = arg0:GetOilCost()

	if var0 > getProxy(PlayerProxy):getRawData().oil then
		return true, var0
	end

	return false
end

function var0.NotEnoughShipBag(arg0)
	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		return true
	end

	return false
end

function var0.NotEnoughEnergy(arg0)
	local var0 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.actId][arg0.contextData.mainFleetId]

	if _.any(_.values(var0.ships), function(arg0)
		local var0 = getProxy(BayProxy):getShipById(arg0)

		return var0 and var0.energy == Ship.ENERGY_LOW
	end) then
		return true, var0
	end

	return false
end

function var0.NotEnoughTicket(arg0)
	if var2(arg0.contextData.actId, arg0.contextData.stageId) > 0 then
		return false
	end

	local var0 = arg0:GetTicketItemID(arg0.contextData.actId)
	local var1 = getProxy(PlayerProxy):getRawData():getResource(var0)
	local var2 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1

	if var1 > 0 and var2 then
		return true
	end

	return false
end

function var0.OnPlayAgain(arg0, arg1)
	if arg0:IsLastBonus() then
		arg0:PassMsgbox("lastBonus", {
			content = i18n("expedition_drop_use_out")
		}, arg1)

		return
	end

	local var0, var1 = arg0:NotEnoughOilCost()

	if var0 then
		arg0:PassMsgbox("oil", var1, arg1)

		return
	end

	if arg0:NotEnoughShipBag() then
		arg0:PassMsgbox("shipCapacity", nil, arg1)

		return
	end

	local var2, var3 = arg0:NotEnoughEnergy()

	if var2 then
		arg0:PassMsgbox("energy", var3, arg1)

		return
	end

	if arg0:NotEnoughTicket() then
		pg.m02:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
			stageId = arg0.contextData.stageId
		})

		return
	end

	arg0:emit(NewBattleResultMediator.REENTER_STAGE)
end

function var0.PassMsgbox(arg0, arg1, arg2, arg3)
	getProxy(ContextProxy):GetPrevContext(1).data.msg = {
		type = arg1,
		param = arg2
	}

	arg3()
end

return var0
