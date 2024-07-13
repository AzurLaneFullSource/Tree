local var0_0 = class("ShipProfileSkinBtn")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.sctxt = arg0_1._tf:Find("mask/Text"):GetComponent("ScrollText")
	arg0_1.lockTF = arg0_1._tf:Find("lock")
	arg0_1.selected = arg0_1._tf:Find("selected")
	arg0_1.timelimitTF = arg0_1._tf:Find("timelimit")
	arg0_1.timelimitTxt = arg0_1._tf:Find("timelimit/Text"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.shipGroup = arg2_2

	local var0_2 = arg1_2.name

	arg0_2.sctxt:SetText(var0_2)

	arg0_2.unlock = arg1_2.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or arg3_2 or arg1_2.skin_type == ShipSkin.SKIN_TYPE_REMAKE and arg0_2.shipGroup.trans or arg1_2.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and arg0_2.shipGroup.married == 1

	setActive(arg0_2.lockTF, not arg0_2.unlock)
	arg0_2:AddTimer(arg1_2)
end

function var0_0.AddTimer(arg0_3, arg1_3)
	local var0_3 = getProxy(ShipSkinProxy):getSkinById(arg1_3.id)
	local var1_3 = var0_3 and var0_3:isExpireType() and not var0_3:isExpired()

	setActive(arg0_3.timelimitTF, var1_3)
	arg0_3:RemoveTimer()

	if var1_3 then
		arg0_3.timer = Timer.New(function()
			arg0_3.timelimitTxt.text = skinTimeStamp(var0_3:getRemainTime())
		end, 1, -1)

		arg0_3.timer:Start()
		arg0_3.timer.func()
	end
end

function var0_0.RemoveTimer(arg0_5)
	if arg0_5.timer then
		arg0_5.timer:Stop()

		arg0_5.timer = nil
	end
end

function var0_0.Shift(arg0_6)
	setActive(arg0_6.selected, true)
end

function var0_0.UnShift(arg0_7)
	setActive(arg0_7.selected, false)
end

function var0_0.Dispose(arg0_8)
	arg0_8:RemoveTimer()
end

return var0_0
