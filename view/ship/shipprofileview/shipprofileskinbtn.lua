local var0 = class("ShipProfileSkinBtn")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.sctxt = arg0._tf:Find("mask/Text"):GetComponent("ScrollText")
	arg0.lockTF = arg0._tf:Find("lock")
	arg0.selected = arg0._tf:Find("selected")
	arg0.timelimitTF = arg0._tf:Find("timelimit")
	arg0.timelimitTxt = arg0._tf:Find("timelimit/Text"):GetComponent(typeof(Text))
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0.shipGroup = arg2

	local var0 = arg1.name

	arg0.sctxt:SetText(var0)

	arg0.unlock = arg1.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or arg3 or arg1.skin_type == ShipSkin.SKIN_TYPE_REMAKE and arg0.shipGroup.trans or arg1.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and arg0.shipGroup.married == 1

	setActive(arg0.lockTF, not arg0.unlock)
	arg0:AddTimer(arg1)
end

function var0.AddTimer(arg0, arg1)
	local var0 = getProxy(ShipSkinProxy):getSkinById(arg1.id)
	local var1 = var0 and var0:isExpireType() and not var0:isExpired()

	setActive(arg0.timelimitTF, var1)
	arg0:RemoveTimer()

	if var1 then
		arg0.timer = Timer.New(function()
			arg0.timelimitTxt.text = skinTimeStamp(var0:getRemainTime())
		end, 1, -1)

		arg0.timer:Start()
		arg0.timer.func()
	end
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Shift(arg0)
	setActive(arg0.selected, true)
end

function var0.UnShift(arg0)
	setActive(arg0.selected, false)
end

function var0.Dispose(arg0)
	arg0:RemoveTimer()
end

return var0
