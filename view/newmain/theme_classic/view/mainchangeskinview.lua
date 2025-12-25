local var0_0 = class("MainChangeSkinView", import("...base.MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._changeSkinToggle = ChangeSkinToggle.New(findTF(arg1_1, "toggleUI"))

	arg0_1._changeSkinToggle:SetAsmrTurnning(true)

	arg0_1.inChange = false
	arg0_1._parentTF = arg0_1._tf.parent
	arg0_1._anchoredPosition = arg0_1._tf.anchoredPosition

	onButton(arg0_1, findTF(arg0_1._tf, "click"), function()
		if arg0_1.inChange then
			return
		end

		if arg0_1._changeSkinToggle:IsAsmrSkin() then
			getProxy(SettingsProxy):setCharacterSetting(arg0_1._flagShip.id, SHIP_FLAG_L2D, true)
			getProxy(SettingsProxy):setCharacterSetting(arg0_1._flagShip.id, SHIP_FLAG_SP, true)
		end

		arg0_1.inChange = true

		arg0_1.event:emit(NewMainMediator.CHANGE_SKIN_TOGGLE, {
			skin_id = arg0_1._flagShip:getSkinId()
		})
	end, SFX_CONFIRM)
end

function var0_0.Init(arg0_3, arg1_3)
	arg0_3._flagShip = arg1_3

	arg0_3:updateUI()
end

function var0_0.Refresh(arg0_4, arg1_4)
	arg0_4.inChange = false
	arg0_4._flagShip = arg1_4

	arg0_4:updateUI()
end

function var0_0.updateUI(arg0_5)
	local var0_5 = arg0_5._flagShip:getSkinId()
	local var1_5 = ShipSkin.GetChangeSkinGroupId(var0_5)

	if not var1_5 then
		setActive(arg0_5._tf, false)
	else
		setActive(arg0_5._tf, true)
	end

	if arg0_5._changeSkinToggle and var1_5 and var1_5 > 0 then
		arg0_5._changeSkinToggle:setShipData(var0_5, arg0_5._flagShip:GetShipPhantomMark())
	end

	if arg0_5._asmrTurnningParent then
		if ShipSkin.GetChangeSkinCustomDataId(var0_5, "asmr") == 1 and true or false then
			setParent(arg0_5._tf, arg0_5._asmrTurnningParent)

			arg0_5._tf.anchoredPosition = Vector2(0, 0)
		else
			setParent(arg0_5._tf, arg0_5._parentTF)

			arg0_5._tf.anchoredPosition = arg0_5._anchoredPosition
		end
	end
end

function var0_0.SetAsmrTurnningParent(arg0_6, arg1_6)
	arg0_6._asmrTurnningParent = arg1_6
end

function var0_0.Dispose(arg0_7)
	var0_0.super.Dispose(arg0_7)

	arg0_7._asmrTurnningParent = nil
end

return var0_0
