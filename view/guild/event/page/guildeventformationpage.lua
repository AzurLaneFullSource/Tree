local var0 = class("GuildEventFormationPage", import(".GuildEventBasePage"))

function var0.getUIName(arg0)
	return "GuildEventFormationUI"
end

function var0.OnLoaded(arg0)
	arg0.tpl = arg0._go:GetComponent("ItemList").prefabItem[0]
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.sendBtn = arg0:findTF("frame/btn")
	arg0.sendBtnGray = arg0:findTF("frame/btn/gray")
	arg0.slots = {
		arg0:findTF("frame/ship1"),
		arg0:findTF("frame/ship2")
	}
	arg0.items = {}
	arg0.cdTimer = {}
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()

		arg0.contextData.editFleet = nil
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()

		arg0.contextData.editFleet = nil
	end, SFX_PANEL)
end

function var0.OnFleetUpdated(arg0, arg1)
	arg0.extraData.fleet = arg1

	arg0:UpdateSlots()
end

function var0.OnFleetFormationDone(arg0)
	for iter0, iter1 in ipairs(arg0.slots) do
		arg0:RefreshCdTimer(iter0)
	end

	arg0:UpdateSendBtn()
end

function var0.OnShow(arg0)
	if not getProxy(GuildProxy).isFetchAssaultFleet then
		arg0:emit(GuildEventMediator.ON_GET_FORMATION)
	else
		arg0:UpdateSlots()
	end

	arg0:UpdateSendBtn()
end

function var0.UpdateSendBtn(arg0)
	local var0 = not arg0.contextData.editFleet or arg0.contextData.editFleet and not arg0.extraData.fleet:AnyShipChanged(arg0.contextData.editFleet)

	setActive(arg0.sendBtnGray, var0)

	if var0 then
		removeOnButton(arg0.sendBtn)

		return
	end

	onButton(arg0, arg0.sendBtn, function()
		if arg0.existBossBattle then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_formation_erro_in_boss_battle"))

			return
		end

		arg0:emit(GuildEventMediator.UPDATE_FORMATION)
	end, SFX_PANEL)
end

function var0.UpdateSlots(arg0)
	arg0.fleet = arg0.contextData.editFleet or arg0.extraData.fleet

	local var0 = arg0.fleet
	local var1 = arg0.guild:GetActiveEvent()
	local var2 = var1 and var1:GetBossMission()

	arg0.existBossBattle = var2 and var2:IsActive()

	for iter0, iter1 in ipairs(arg0.slots) do
		local var3 = arg0.fleet:GetShipByPos(iter0)

		arg0:UpdateSlot(iter0, iter1, var3)
		arg0:RefreshCdTimer(iter0)
	end
end

function var0.ShipIsBattle(arg0, arg1)
	return arg0.existBossBattle
end

function var0.UpdateSlot(arg0, arg1, arg2, arg3)
	local var0 = arg0.guild
	local var1 = arg2:Find("ship")
	local var2 = arg2:Find("tag/tag")

	if arg3 then
		if not var1 then
			var1 = cloneTplTo(arg0.tpl, arg2)

			var1:SetAsFirstSibling()
		end

		local var3 = arg0.items[arg1] or DockyardShipItem.New(var1)

		var3:update(GuildAssaultShip.ConverteFromShip(arg3))

		var3.go.name = "ship"

		setActive(var2, arg0:ShipIsBattle(arg3))
	elseif var1 then
		setActive(var1, false)
		setActive(var2, false)
	else
		setActive(var2, false)
	end

	local var4 = arg3 and var1 or arg2

	onButton(arg0, var4, function()
		if not getProxy(GuildProxy):CanFormationPos(arg1) then
			return
		end

		if arg0.existBossBattle then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_formation_erro_in_boss_battle"))

			return
		end

		arg0:emit(GuildEventMediator.ON_SELECT_SHIP, arg1, arg3, arg0.fleet)
	end, SFX_PANEL)
end

function var0.RefreshCdTimer(arg0, arg1)
	local var0 = arg0.slots[arg1]
	local var1 = var0:Find("tag/timer")
	local var2 = var1:Find("Text"):GetComponent(typeof(Text))
	local var3 = var0:Find("tag/tag")
	local var4 = not getProxy(GuildProxy):CanFormationPos(arg1)

	setActive(var1, false)
	arg0:RemoveTimer(arg1)

	if var4 then
		arg0.cdTimer[arg1] = Timer.New(function()
			local var0 = getProxy(GuildProxy):GetNextCanFormationTime(arg1) - pg.TimeMgr.GetInstance():GetServerTime()

			if var0 > 0 then
				var2.text = pg.TimeMgr:GetInstance():DescCDTime(var0)
			else
				setActive(var1, false)
				setActive(var0:Find("tag"), isActive(var3))
			end
		end, 1, -1)

		arg0.cdTimer[arg1]:Start()
		arg0.cdTimer[arg1].func()
		setActive(var1, true)
	end

	setActive(var0:Find("tag"), isActive(var3) or var4)
end

function var0.RemoveTimer(arg0, arg1)
	if arg0.cdTimer[arg1] then
		arg0.cdTimer[arg1]:Stop()

		arg0.cdTimer[arg1] = nil
	end
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	for iter0, iter1 in pairs(arg0.cdTimer) do
		arg0:RemoveTimer(iter0)
	end
end

return var0
