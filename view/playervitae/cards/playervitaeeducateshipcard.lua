local var0_0 = class("PlayerVitaeEducateShipCard", import(".PlayerVitaeEducateBaseCard"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.paintingTr = arg1_1:Find("ship_icon/painting")
	arg0_1.nameTxt = arg1_1:Find("detail/name_bg/name_mask/name"):GetComponent("ScrollText")
end

function var0_0.Flush(arg0_2)
	arg0_2:Clear()
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:emit(PlayerVitaeMediator.ON_SEL_EDUCATE_CHAR)
	end, SFX_PANEL)

	local var0_2 = getProxy(PlayerProxy):getRawData()
	local var1_2 = VirtualEducateCharShip.New(var0_2:GetEducateCharacter())

	setPaintingPrefabAsync(arg0_2.paintingTr, var1_2:getPainting(), "biandui")
	arg0_2.nameTxt:SetText(i18n("secretary_special_name"))

	arg0_2.ship = var1_2
end

function var0_0.Clear(arg0_4)
	if arg0_4.ship then
		retPaintingPrefab(arg0_4.paintingTr, arg0_4.ship:getPainting())
	end

	removeOnButton(arg0_4._tf)
end

return var0_0
