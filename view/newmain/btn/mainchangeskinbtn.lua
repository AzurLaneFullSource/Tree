local var0_0 = class("MainChangeSkinBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	arg0_1:emit(NewMainScene.ON_CHANGE_SKIN)
end

function var0_0.Flush(arg0_2, arg1_2)
	arg0_2:UpdateChangeSkinBtn()
end

function var0_0.UpdateChangeSkinBtn(arg0_3)
	local var0_3

	if getProxy(SettingsProxy):IsOpenRandomFlagShip() then
		var0_3 = _.select(getProxy(SettingsProxy):GetRandomFlagShipList(), function(arg0_4)
			return getProxy(BayProxy):RawGetShipById(arg0_4) ~= nil
		end)
	else
		var0_3 = getProxy(PlayerProxy):getRawData().characters
	end

	local var1_3 = getProxy(SettingsProxy):GetFlagShipDisplayMode()
	local var2_3 = var1_3 == FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR and 0 or #var0_3

	if getProxy(PlayerProxy):getRawData():ExistEducateChar() and var1_3 ~= FlAG_SHIP_DISPLAY_ONLY_SHIP then
		var2_3 = var2_3 + 1
	end

	setActive(arg0_3._tf, var2_3 > 1)
end

return var0_0
