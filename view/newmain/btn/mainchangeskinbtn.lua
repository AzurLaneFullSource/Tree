local var0 = class("MainChangeSkinBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainScene.ON_CHANGE_SKIN)
end

function var0.Flush(arg0, arg1)
	arg0:UpdateChangeSkinBtn()
end

function var0.UpdateChangeSkinBtn(arg0)
	local var0

	if getProxy(SettingsProxy):IsOpenRandomFlagShip() then
		var0 = _.select(getProxy(SettingsProxy):GetRandomFlagShipList(), function(arg0)
			return getProxy(BayProxy):RawGetShipById(arg0) ~= nil
		end)
	else
		var0 = getProxy(PlayerProxy):getRawData().characters
	end

	local var1 = getProxy(SettingsProxy):GetFlagShipDisplayMode()
	local var2 = var1 == FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR and 0 or #var0

	if getProxy(PlayerProxy):getRawData():ExistEducateChar() and var1 ~= FlAG_SHIP_DISPLAY_ONLY_SHIP then
		var2 = var2 + 1
	end

	setActive(arg0._tf, var2 > 1)
end

return var0
