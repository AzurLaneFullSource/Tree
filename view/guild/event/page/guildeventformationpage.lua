local var0_0 = class("GuildEventFormationPage", import(".GuildEventBasePage"))

function var0_0.getUIName(arg0_1)
	return "GuildEventFormationUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.tpl = arg0_2._go:GetComponent("ItemList").prefabItem[0]
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.sendBtn = arg0_2:findTF("frame/btn")
	arg0_2.sendBtnGray = arg0_2:findTF("frame/btn/gray")
	arg0_2.slots = {
		arg0_2:findTF("frame/ship1"),
		arg0_2:findTF("frame/ship2")
	}
	arg0_2.items = {}
	arg0_2.cdTimer = {}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()

		arg0_3.contextData.editFleet = nil
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()

		arg0_3.contextData.editFleet = nil
	end, SFX_PANEL)
end

function var0_0.OnFleetUpdated(arg0_6, arg1_6)
	arg0_6.extraData.fleet = arg1_6

	arg0_6:UpdateSlots()
end

function var0_0.OnFleetFormationDone(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.slots) do
		arg0_7:RefreshCdTimer(iter0_7)
	end

	arg0_7:UpdateSendBtn()
end

function var0_0.OnShow(arg0_8)
	if not getProxy(GuildProxy).isFetchAssaultFleet then
		arg0_8:emit(GuildEventMediator.ON_GET_FORMATION)
	else
		arg0_8:UpdateSlots()
	end

	arg0_8:UpdateSendBtn()
end

function var0_0.UpdateSendBtn(arg0_9)
	local var0_9 = not arg0_9.contextData.editFleet or arg0_9.contextData.editFleet and not arg0_9.extraData.fleet:AnyShipChanged(arg0_9.contextData.editFleet)

	setActive(arg0_9.sendBtnGray, var0_9)

	if var0_9 then
		removeOnButton(arg0_9.sendBtn)

		return
	end

	onButton(arg0_9, arg0_9.sendBtn, function()
		if arg0_9.existBossBattle then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_formation_erro_in_boss_battle"))

			return
		end

		arg0_9:emit(GuildEventMediator.UPDATE_FORMATION)
	end, SFX_PANEL)
end

function var0_0.UpdateSlots(arg0_11)
	arg0_11.fleet = arg0_11.contextData.editFleet or arg0_11.extraData.fleet

	local var0_11 = arg0_11.fleet
	local var1_11 = arg0_11.guild:GetActiveEvent()
	local var2_11 = var1_11 and var1_11:GetBossMission()

	arg0_11.existBossBattle = var2_11 and var2_11:IsActive()

	for iter0_11, iter1_11 in ipairs(arg0_11.slots) do
		local var3_11 = arg0_11.fleet:GetShipByPos(iter0_11)

		arg0_11:UpdateSlot(iter0_11, iter1_11, var3_11)
		arg0_11:RefreshCdTimer(iter0_11)
	end
end

function var0_0.ShipIsBattle(arg0_12, arg1_12)
	return arg0_12.existBossBattle
end

function var0_0.UpdateSlot(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg0_13.guild
	local var1_13 = arg2_13:Find("ship")
	local var2_13 = arg2_13:Find("tag/tag")

	if arg3_13 then
		if not var1_13 then
			var1_13 = cloneTplTo(arg0_13.tpl, arg2_13)

			var1_13:SetAsFirstSibling()
		end

		local var3_13 = arg0_13.items[arg1_13] or DockyardShipItem.New(var1_13)

		var3_13:update(GuildAssaultShip.ConverteFromShip(arg3_13))

		var3_13.go.name = "ship"

		setActive(var2_13, arg0_13:ShipIsBattle(arg3_13))
	elseif var1_13 then
		setActive(var1_13, false)
		setActive(var2_13, false)
	else
		setActive(var2_13, false)
	end

	local var4_13 = arg3_13 and var1_13 or arg2_13

	onButton(arg0_13, var4_13, function()
		if not getProxy(GuildProxy):CanFormationPos(arg1_13) then
			return
		end

		if arg0_13.existBossBattle then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_formation_erro_in_boss_battle"))

			return
		end

		arg0_13:emit(GuildEventMediator.ON_SELECT_SHIP, arg1_13, arg3_13, arg0_13.fleet)
	end, SFX_PANEL)
end

function var0_0.RefreshCdTimer(arg0_15, arg1_15)
	local var0_15 = arg0_15.slots[arg1_15]
	local var1_15 = var0_15:Find("tag/timer")
	local var2_15 = var1_15:Find("Text"):GetComponent(typeof(Text))
	local var3_15 = var0_15:Find("tag/tag")
	local var4_15 = not getProxy(GuildProxy):CanFormationPos(arg1_15)

	setActive(var1_15, false)
	arg0_15:RemoveTimer(arg1_15)

	if var4_15 then
		arg0_15.cdTimer[arg1_15] = Timer.New(function()
			local var0_16 = getProxy(GuildProxy):GetNextCanFormationTime(arg1_15) - pg.TimeMgr.GetInstance():GetServerTime()

			if var0_16 > 0 then
				var2_15.text = pg.TimeMgr:GetInstance():DescCDTime(var0_16)
			else
				setActive(var1_15, false)
				setActive(var0_15:Find("tag"), isActive(var3_15))
			end
		end, 1, -1)

		arg0_15.cdTimer[arg1_15]:Start()
		arg0_15.cdTimer[arg1_15].func()
		setActive(var1_15, true)
	end

	setActive(var0_15:Find("tag"), isActive(var3_15) or var4_15)
end

function var0_0.RemoveTimer(arg0_17, arg1_17)
	if arg0_17.cdTimer[arg1_17] then
		arg0_17.cdTimer[arg1_17]:Stop()

		arg0_17.cdTimer[arg1_17] = nil
	end
end

function var0_0.OnDestroy(arg0_18)
	var0_0.super.OnDestroy(arg0_18)

	for iter0_18, iter1_18 in pairs(arg0_18.cdTimer) do
		arg0_18:RemoveTimer(iter0_18)
	end
end

return var0_0
