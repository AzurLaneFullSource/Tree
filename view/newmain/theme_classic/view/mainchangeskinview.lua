local var0_0 = class("MainChangeSkinView", import("...base.MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._changeSkinToggle = ChangeSkinToggle.New(findTF(arg1_1, "toggleUI"))
	arg0_1.inChange = false

	onButton(arg0_1, findTF(arg0_1._tf, "click"), function()
		if arg0_1.inChange then
			return
		end

		arg0_1.inChange = true

		local var0_2 = arg0_1._flagShip:getSkinId()
		local var1_2 = arg0_1._flagShip.id

		arg0_1.event:emit(NewMainMediator.CHANGE_SKIN_TOGGLE, {
			ship_id = var1_2,
			skin_id = var0_2
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
	local var1_5 = arg0_5._flagShip.id
	local var2_5 = ShipGroup.GetChangeSkinGroupId(var0_5)

	if not var2_5 then
		setActive(arg0_5._tf, false)
	else
		setActive(arg0_5._tf, true)
	end

	if arg0_5._changeSkinToggle and var2_5 and var2_5 > 0 then
		arg0_5._changeSkinToggle:setShipData(var0_5, var1_5)
	end
end

function var0_0.Dispose(arg0_6)
	var0_0.super.Dispose(arg0_6)
end

return var0_0
