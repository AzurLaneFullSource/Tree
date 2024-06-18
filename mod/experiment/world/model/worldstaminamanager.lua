local var0_0 = class("WorldStaminaManager", import("...BaseEntity"))

var0_0.Fields = {
	staminaExchangeTimes = "number",
	staminaLastRecoverTime = "number",
	staminaExtra = "number",
	transform = "userdata",
	preSelectIndex = "number",
	updateTimer = "table",
	stamina = "number",
	UIMain = "userdata"
}
var0_0.EventUpdateStamina = "WorldStaminaManager.EventUpdateStamina"

function var0_0.Build(arg0_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.UIMain = pg.UIMgr.GetInstance().OverlayMain

	local var0_1 = PoolMgr.GetInstance()

	var0_1:GetUI("WorldStaminaRecoverUI", true, function(arg0_2)
		if not arg0_1.UIMain then
			var0_1:ReturnUI("WorldStaminaRecoverUI", arg0_2)
		else
			arg0_1.transform = tf(arg0_2)

			setParent(arg0_1.transform, arg0_1.UIMain, false)
			setActive(arg0_1.transform, false)
			onButton(arg0_1, arg0_1.transform:Find("bg"), function()
				arg0_1:Hide()
			end, SFX_CANCEL)
			onButton(arg0_1, arg0_1.transform:Find("window/top/btnBack"), function()
				arg0_1:Hide()
			end, SFX_CANCEL)
			onButton(arg0_1, arg0_1.transform:Find("window/button_container/custom_button_2"), function()
				arg0_1:Hide()
			end, SFX_CANCEL)
		end
	end)
end

function var0_0.Setup(arg0_6, arg1_6)
	arg0_6.stamina = arg1_6[1]
	arg0_6.staminaExtra = arg1_6[2]
	arg0_6.staminaLastRecoverTime = arg1_6[3]
	arg0_6.staminaExchangeTimes = arg1_6[4]

	if not arg0_6.updateTimer then
		arg0_6.updateTimer = Timer.New(function()
			arg0_6:UpdateStamina()
		end, 1, -1)

		arg0_6.updateTimer:Start()
		arg0_6.updateTimer.func()
	end
end

function var0_0.Dispose(arg0_8)
	pg.DelegateInfo.Dispose(arg0_8)

	if arg0_8.updateTimer then
		arg0_8.updateTimer:Stop()
	end

	if arg0_8.transform then
		PoolMgr.GetInstance():ReturnUI("WorldStaminaRecoverUI", go(arg0_8.transform))
	end

	arg0_8:Clear()
end

function var0_0.Reset(arg0_9)
	arg0_9.stamina = arg0_9:GetMaxStamina()
end

function var0_0.ChangeStamina(arg0_10, arg1_10, arg2_10)
	arg0_10.stamina = arg1_10
	arg0_10.staminaExtra = arg2_10

	arg0_10:DispatchEvent(var0_0.EventUpdateStamina)
end

function var0_0.UpdateStamina(arg0_11)
	local var0_11 = pg.gameset.world_movepower_recovery_interval.key_value
	local var1_11 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_11 = math.floor((var1_11 - arg0_11.staminaLastRecoverTime) / var0_11)

	if var2_11 > 0 then
		arg0_11.staminaLastRecoverTime = arg0_11.staminaLastRecoverTime + var2_11 * var0_11

		if arg0_11.stamina < arg0_11:GetMaxStamina() then
			arg0_11.stamina = math.min(arg0_11.stamina + var2_11, arg0_11:GetMaxStamina())

			arg0_11:DispatchEvent(var0_0.EventUpdateStamina)
		end
	end
end

function var0_0.CheckUpdateShow(arg0_12)
	if arg0_12:IsShowing() then
		arg0_12:Show()
	end
end

function var0_0.Show(arg0_13)
	local var0_13 = arg0_13.transform:Find("window/world_stamina_panel")
	local var1_13 = pg.gameset.world_movepower_recovery_interval.key_value
	local var2_13 = string.format("%.2d:%.2d:%.2d", math.floor(var1_13 / 3600), math.floor(var1_13 % 3600 / 60), var1_13 % 60)

	setText(var0_13:Find("content/tip_bg/tip"), i18n("world_stamina_recover", var2_13))
	setText(var0_13:Find("content/tip_bg/stamina/value"), arg0_13:GetTotalStamina())

	local var3_13 = var0_13:Find("content/item_list")
	local var4_13 = var0_13:Find("item")

	setActive(var4_13, false)

	local var5_13 = arg0_13.transform:Find("window/button_container/custom_button_1")

	removeAllChildren(var3_13)

	local var6_13 = arg0_13:GetExchangeItems()

	for iter0_13, iter1_13 in ipairs(var6_13) do
		local var7_13 = cloneTplTo(var4_13, var3_13)

		updateDrop(var7_13:Find("IconTpl"), iter1_13.drop)
		setText(var7_13:Find("IconTpl/icon_bg/count"), iter1_13.drop.count and iter1_13.drop.count or "")
		setText(var7_13:Find("name/Text"), shortenString(getText(var7_13:Find("IconTpl/name")), 5))
		onToggle(arg0_13, var7_13, function(arg0_14)
			if arg0_14 then
				arg0_13.preSelectIndex = iter0_13

				if iter0_13 > 1 then
					setText(var0_13:Find("content/Text"), i18n("world_stamina_text2", iter1_13.name, iter1_13.stamina))
					onButton(arg0_13, var5_13, function()
						if iter1_13.drop.count == 0 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))
						else
							local var0_15 = nowWorld()
							local var1_15 = {}
							local var2_15 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

							if var0_15:CheckResetProgress() and PlayerPrefs.GetString("world_stamina_reset_tip", "") ~= var2_15 and var0_15:GetResetWaitingTime() < 259200 and arg0_13:GetTotalStamina() + iter1_13.stamina > arg0_13:GetMaxStamina() then
								PlayerPrefs.SetString("world_stamina_reset_tip", var2_15)
								table.insert(var1_15, function(arg0_16)
									pg.MsgboxMgr.GetInstance():ShowMsgBox({
										content = i18n("world_stamina_resetwarning", arg0_13:GetMaxStamina()),
										onYes = arg0_16
									})
								end)
							end

							seriesAsync(var1_15, function()
								pg.m02:sendNotification(GAME.WORLD_ITEM_USE, {
									count = 1,
									itemID = iter1_13.drop.id,
									args = {}
								})
							end)
						end
					end, SFX_CONFIRM)
				elseif iter0_13 == 1 then
					setText(var0_13:Find("content/Text"), i18n("world_stamina_text", iter1_13.cost, iter1_13.stamina, iter1_13.times, iter1_13.limit))
					onButton(arg0_13, var5_13, function()
						if iter1_13.drop.count < iter1_13.cost then
							pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_oil"))
						elseif iter1_13.times == 0 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))
						else
							local var0_18 = nowWorld()
							local var1_18 = {}
							local var2_18 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

							if var0_18:CheckResetProgress() and PlayerPrefs.GetString("world_stamina_reset_tip", "") ~= var2_18 and var0_18:GetResetWaitingTime() < 259200 and arg0_13:GetTotalStamina() + iter1_13.stamina > arg0_13:GetMaxStamina() then
								PlayerPrefs.SetString("world_stamina_reset_tip", var2_18)
								table.insert(var1_18, function(arg0_19)
									pg.MsgboxMgr.GetInstance():ShowMsgBox({
										content = i18n("world_stamina_resetwarning", arg0_13:GetMaxStamina()),
										onYes = arg0_19
									})
								end)
							end

							seriesAsync(var1_18, function()
								pg.m02:sendNotification(GAME.WORLD_STAMINA_EXCHANGE)
							end)
						end
					end, SFX_CONFIRM)
				end
			end
		end, SFX_PANEL)
	end

	if arg0_13.preSelectIndex then
		triggerToggle(var3_13:GetChild(arg0_13.preSelectIndex - 1), true)
	else
		local var8_13 = 1

		for iter2_13 = 2, #var6_13 do
			if var6_13[iter2_13].drop.count > 0 then
				var8_13 = iter2_13

				break
			end
		end

		triggerToggle(var3_13:GetChild(var8_13 - 1), true)
	end

	setActive(arg0_13.transform, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_13.transform, false)
end

function var0_0.Hide(arg0_21)
	arg0_21.preSelectIndex = nil

	setActive(arg0_21.transform, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21.transform, arg0_21.UIMain)
end

function var0_0.IsShowing(arg0_22)
	return arg0_22.transform and isActive(arg0_22.transform) or false
end

function var0_0.GetStamina(arg0_23)
	return arg0_23.stamina
end

function var0_0.GetMaxStamina(arg0_24)
	return pg.gameset.world_movepower_maxvalue.key_value
end

function var0_0.GetExtraStamina(arg0_25)
	return arg0_25.staminaExtra
end

function var0_0.GetTotalStamina(arg0_26)
	return arg0_26:GetStamina() + arg0_26:GetExtraStamina()
end

function var0_0.GetStepStaminaCost(arg0_27)
	return pg.gameset.world_cell_cost_movepower.key_value
end

function var0_0.GetMaxMoveStep(arg0_28)
	return math.floor(arg0_28:GetTotalStamina() / arg0_28:GetStepStaminaCost())
end

function var0_0.ConsumeStamina(arg0_29, arg1_29)
	arg0_29.staminaExtra = arg0_29.staminaExtra - arg1_29

	if arg0_29.staminaExtra < 0 then
		arg0_29.stamina = arg0_29.stamina + arg0_29.staminaExtra
		arg0_29.staminaExtra = 0
	end

	assert(arg0_29.stamina >= 0, "out of stamina.")
	arg0_29:DispatchEvent(var0_0.EventUpdateStamina)
end

function var0_0.GetExchangeData(arg0_30)
	local var0_30 = pg.gameset.world_supply_value.description
	local var1_30 = pg.gameset.world_supply_price.description
	local var2_30 = var0_30[math.min(#var0_30, arg0_30.staminaExchangeTimes + 1)]
	local var3_30 = var1_30[math.min(#var1_30, arg0_30.staminaExchangeTimes + 1)]

	return var2_30[1], var3_30[3], #var1_30 - arg0_30.staminaExchangeTimes, #var1_30
end

function var0_0.GetExchangeItems(arg0_31)
	local var0_31 = nowWorld():GetInventoryProxy()
	local var1_31, var2_31, var3_31, var4_31 = arg0_31:GetExchangeData()
	local var5_31 = {
		{
			drop = Drop.New({
				id = PlayerConst.ResOil,
				type = DROP_TYPE_RESOURCE,
				count = getProxy(PlayerProxy):getRawData().oil
			}),
			cost = var2_31,
			stamina = var1_31,
			times = var3_31,
			limit = var4_31
		}
	}

	for iter0_31, iter1_31 in ipairs(pg.gameset.world_supply_itemlist.description) do
		local var6_31 = Drop.New({
			type = DROP_TYPE_WORLD_ITEM,
			id = iter1_31,
			count = var0_31:GetItemCount(iter1_31)
		})

		table.insert(var5_31, {
			cost = 1,
			drop = var6_31,
			name = var6_31:getConfig("name"),
			stamina = var6_31:getSubClass():getItemStaminaRecover()
		})
	end

	return var5_31
end

function var0_0.ExchangeStamina(arg0_32, arg1_32, arg2_32)
	arg0_32.stamina = arg0_32.stamina + arg1_32

	if arg2_32 then
		arg0_32.staminaExchangeTimes = arg0_32.staminaExchangeTimes + 1
	end

	arg0_32:DispatchEvent(var0_0.EventUpdateStamina)
	arg0_32:CheckUpdateShow()
end

function var0_0.GetDisplayStanima(arg0_33)
	return arg0_33:GetTotalStamina()
end

return var0_0
