local var0 = class("SkinAtlasBgView")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0._go = arg1.gameObject
	arg0.isSpecialBg = false
	arg0.isloading = false
end

function var0.getUIName(arg0)
	return arg0.__cname
end

function var0.Init(arg0, arg1, arg2, arg3)
	arg0.ship = arg1

	arg0:ClearSpecailBg()

	local var0 = arg0:getShipBgPrint(arg2)

	arg0:SetSpecailBg(var0, arg3)
end

function var0.getShipBgPrint(arg0, arg1)
	local var0 = arg0.ship

	if not arg1 then
		return var0:rarity2bgPrintForGet()
	else
		return var0:getShipBgPrint()
	end
end

function var0.SetSpecailBg(arg0, arg1, arg2)
	arg0.isloading = true

	pg.DynamicBgMgr.GetInstance():LoadBg(arg0, arg1, arg0._tf.parent, arg0._tf, function(arg0)
		arg0.isSpecialBg = true
		arg0.isloading = false
		arg0.transform.localPosition = Vector3(0, 0, 200)

		if arg2 then
			arg2()
		end
	end, function()
		arg0.isloading = false

		if arg2 then
			arg2()
		end
	end)
end

function var0.ClearSpecailBg(arg0)
	if arg0.isSpecialBg then
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0:getUIName())

		arg0.isSpecialBg = false
	end
end

function var0.IsLoading(arg0)
	return arg0.isloading
end

function var0.Clear(arg0)
	arg0:ClearSpecailBg()
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
