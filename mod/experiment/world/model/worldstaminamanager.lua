local var0 = class("WorldStaminaManager", import("...BaseEntity"))

var0.Fields = {
	staminaExchangeTimes = "number",
	staminaLastRecoverTime = "number",
	staminaExtra = "number",
	transform = "userdata",
	preSelectIndex = "number",
	updateTimer = "table",
	stamina = "number",
	UIMain = "userdata"
}
var0.EventUpdateStamina = "WorldStaminaManager.EventUpdateStamina"

function var0.Build(arg0)
	pg.DelegateInfo.New(arg0)

	arg0.UIMain = pg.UIMgr.GetInstance().OverlayMain

	local var0 = PoolMgr.GetInstance()

	var0:GetUI("WorldStaminaRecoverUI", true, function(arg0)
		if not arg0.UIMain then
			var0:ReturnUI("WorldStaminaRecoverUI", arg0)
		else
			arg0.transform = tf(arg0)

			setParent(arg0.transform, arg0.UIMain, false)
			setActive(arg0.transform, false)
			onButton(arg0, arg0.transform:Find("bg"), function()
				arg0:Hide()
			end, SFX_CANCEL)
			onButton(arg0, arg0.transform:Find("window/top/btnBack"), function()
				arg0:Hide()
			end, SFX_CANCEL)
			onButton(arg0, arg0.transform:Find("window/button_container/custom_button_2"), function()
				arg0:Hide()
			end, SFX_CANCEL)
		end
	end)
end

function var0.Setup(arg0, arg1)
	arg0.stamina = arg1[1]
	arg0.staminaExtra = arg1[2]
	arg0.staminaLastRecoverTime = arg1[3]
	arg0.staminaExchangeTimes = arg1[4]

	if not arg0.updateTimer then
		arg0.updateTimer = Timer.New(function()
			arg0:UpdateStamina()
		end, 1, -1)

		arg0.updateTimer:Start()
		arg0.updateTimer.func()
	end
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	if arg0.updateTimer then
		arg0.updateTimer:Stop()
	end

	if arg0.transform then
		PoolMgr.GetInstance():ReturnUI("WorldStaminaRecoverUI", go(arg0.transform))
	end

	arg0:Clear()
end

function var0.Reset(arg0)
	arg0.stamina = arg0:GetMaxStamina()
end

function var0.ChangeStamina(arg0, arg1, arg2)
	arg0.stamina = arg1
	arg0.staminaExtra = arg2

	arg0:DispatchEvent(var0.EventUpdateStamina)
end

function var0.UpdateStamina(arg0)
	local var0 = pg.gameset.world_movepower_recovery_interval.key_value
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = math.floor((var1 - arg0.staminaLastRecoverTime) / var0)

	if var2 > 0 then
		arg0.staminaLastRecoverTime = arg0.staminaLastRecoverTime + var2 * var0

		if arg0.stamina < arg0:GetMaxStamina() then
			arg0.stamina = math.min(arg0.stamina + var2, arg0:GetMaxStamina())

			arg0:DispatchEvent(var0.EventUpdateStamina)
		end
	end
end

function var0.CheckUpdateShow(arg0)
	if arg0:IsShowing() then
		arg0:Show()
	end
end

function var0.Show(arg0)
	local var0 = arg0.transform:Find("window/world_stamina_panel")
	local var1 = pg.gameset.world_movepower_recovery_interval.key_value
	local var2 = string.format("%.2d:%.2d:%.2d", math.floor(var1 / 3600), math.floor(var1 % 3600 / 60), var1 % 60)

	setText(var0:Find("content/tip_bg/tip"), i18n("world_stamina_recover", var2))
	setText(var0:Find("content/tip_bg/stamina/value"), arg0:GetTotalStamina())

	local var3 = var0:Find("content/item_list")
	local var4 = var0:Find("item")

	setActive(var4, false)

	local var5 = arg0.transform:Find("window/button_container/custom_button_1")

	removeAllChildren(var3)

	local var6 = arg0:GetExchangeItems()

	for iter0, iter1 in ipairs(var6) do
		local var7 = cloneTplTo(var4, var3)

		updateDrop(var7:Find("IconTpl"), iter1.drop)
		setText(var7:Find("IconTpl/icon_bg/count"), iter1.drop.count and iter1.drop.count or "")
		setText(var7:Find("name/Text"), shortenString(getText(var7:Find("IconTpl/name")), 5))
		onToggle(arg0, var7, function(arg0)
			if arg0 then
				arg0.preSelectIndex = iter0

				if iter0 > 1 then
					setText(var0:Find("content/Text"), i18n("world_stamina_text2", iter1.name, iter1.stamina))
					onButton(arg0, var5, function()
						if iter1.drop.count == 0 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))
						else
							local var0 = nowWorld()
							local var1 = {}
							local var2 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

							if var0:CheckResetProgress() and PlayerPrefs.GetString("world_stamina_reset_tip", "") ~= var2 and var0:GetResetWaitingTime() < 259200 and arg0:GetTotalStamina() + iter1.stamina > arg0:GetMaxStamina() then
								PlayerPrefs.SetString("world_stamina_reset_tip", var2)
								table.insert(var1, function(arg0)
									pg.MsgboxMgr.GetInstance():ShowMsgBox({
										content = i18n("world_stamina_resetwarning", arg0:GetMaxStamina()),
										onYes = arg0
									})
								end)
							end

							seriesAsync(var1, function()
								pg.m02:sendNotification(GAME.WORLD_ITEM_USE, {
									count = 1,
									itemID = iter1.drop.id,
									args = {}
								})
							end)
						end
					end, SFX_CONFIRM)
				elseif iter0 == 1 then
					setText(var0:Find("content/Text"), i18n("world_stamina_text", iter1.cost, iter1.stamina, iter1.times, iter1.limit))
					onButton(arg0, var5, function()
						if iter1.drop.count < iter1.cost then
							pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_oil"))
						elseif iter1.times == 0 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))
						else
							local var0 = nowWorld()
							local var1 = {}
							local var2 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")

							if var0:CheckResetProgress() and PlayerPrefs.GetString("world_stamina_reset_tip", "") ~= var2 and var0:GetResetWaitingTime() < 259200 and arg0:GetTotalStamina() + iter1.stamina > arg0:GetMaxStamina() then
								PlayerPrefs.SetString("world_stamina_reset_tip", var2)
								table.insert(var1, function(arg0)
									pg.MsgboxMgr.GetInstance():ShowMsgBox({
										content = i18n("world_stamina_resetwarning", arg0:GetMaxStamina()),
										onYes = arg0
									})
								end)
							end

							seriesAsync(var1, function()
								pg.m02:sendNotification(GAME.WORLD_STAMINA_EXCHANGE)
							end)
						end
					end, SFX_CONFIRM)
				end
			end
		end, SFX_PANEL)
	end

	if arg0.preSelectIndex then
		triggerToggle(var3:GetChild(arg0.preSelectIndex - 1), true)
	else
		local var8 = 1

		for iter2 = 2, #var6 do
			if var6[iter2].drop.count > 0 then
				var8 = iter2

				break
			end
		end

		triggerToggle(var3:GetChild(var8 - 1), true)
	end

	setActive(arg0.transform, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.transform, false)
end

function var0.Hide(arg0)
	arg0.preSelectIndex = nil

	setActive(arg0.transform, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.transform, arg0.UIMain)
end

function var0.IsShowing(arg0)
	return arg0.transform and isActive(arg0.transform) or false
end

function var0.GetStamina(arg0)
	return arg0.stamina
end

function var0.GetMaxStamina(arg0)
	return pg.gameset.world_movepower_maxvalue.key_value
end

function var0.GetExtraStamina(arg0)
	return arg0.staminaExtra
end

function var0.GetTotalStamina(arg0)
	return arg0:GetStamina() + arg0:GetExtraStamina()
end

function var0.GetStepStaminaCost(arg0)
	return pg.gameset.world_cell_cost_movepower.key_value
end

function var0.GetMaxMoveStep(arg0)
	return math.floor(arg0:GetTotalStamina() / arg0:GetStepStaminaCost())
end

function var0.ConsumeStamina(arg0, arg1)
	arg0.staminaExtra = arg0.staminaExtra - arg1

	if arg0.staminaExtra < 0 then
		arg0.stamina = arg0.stamina + arg0.staminaExtra
		arg0.staminaExtra = 0
	end

	assert(arg0.stamina >= 0, "out of stamina.")
	arg0:DispatchEvent(var0.EventUpdateStamina)
end

function var0.GetExchangeData(arg0)
	local var0 = pg.gameset.world_supply_value.description
	local var1 = pg.gameset.world_supply_price.description
	local var2 = var0[math.min(#var0, arg0.staminaExchangeTimes + 1)]
	local var3 = var1[math.min(#var1, arg0.staminaExchangeTimes + 1)]

	return var2[1], var3[3], #var1 - arg0.staminaExchangeTimes, #var1
end

function var0.GetExchangeItems(arg0)
	local var0 = nowWorld():GetInventoryProxy()
	local var1, var2, var3, var4 = arg0:GetExchangeData()
	local var5 = {
		{
			drop = Drop.New({
				id = PlayerConst.ResOil,
				type = DROP_TYPE_RESOURCE,
				count = getProxy(PlayerProxy):getRawData().oil
			}),
			cost = var2,
			stamina = var1,
			times = var3,
			limit = var4
		}
	}

	for iter0, iter1 in ipairs(pg.gameset.world_supply_itemlist.description) do
		local var6 = Drop.New({
			type = DROP_TYPE_WORLD_ITEM,
			id = iter1,
			count = var0:GetItemCount(iter1)
		})

		table.insert(var5, {
			cost = 1,
			drop = var6,
			name = var6:getConfig("name"),
			stamina = var6:getSubClass():getItemStaminaRecover()
		})
	end

	return var5
end

function var0.ExchangeStamina(arg0, arg1, arg2)
	arg0.stamina = arg0.stamina + arg1

	if arg2 then
		arg0.staminaExchangeTimes = arg0.staminaExchangeTimes + 1
	end

	arg0:DispatchEvent(var0.EventUpdateStamina)
	arg0:CheckUpdateShow()
end

function var0.GetDisplayStanima(arg0)
	return arg0:GetTotalStamina()
end

return var0
