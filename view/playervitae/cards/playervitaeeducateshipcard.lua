local var0 = class("PlayerVitaeEducateShipCard", import(".PlayerVitaeEducateBaseCard"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.paintingTr = arg1:Find("ship_icon/painting")
	arg0.nameTxt = arg1:Find("detail/name_bg/name_mask/name"):GetComponent("ScrollText")
end

function var0.Flush(arg0)
	arg0:Clear()
	onButton(arg0, arg0._tf, function()
		arg0:emit(PlayerVitaeMediator.ON_SEL_EDUCATE_CHAR)
	end, SFX_PANEL)

	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = VirtualEducateCharShip.New(var0:GetEducateCharacter())

	setPaintingPrefabAsync(arg0.paintingTr, var1:getPainting(), "biandui")
	arg0.nameTxt:SetText(i18n("secretary_special_name"))

	arg0.ship = var1
end

function var0.Clear(arg0)
	if arg0.ship then
		retPaintingPrefab(arg0.paintingTr, arg0.ship:getPainting())
	end

	removeOnButton(arg0._tf)
end

return var0
