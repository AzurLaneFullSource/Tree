local var0_0 = class("SkinAtlasBgView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1._go = arg1_1.gameObject
	arg0_1.isSpecialBg = false
	arg0_1.isloading = false
end

function var0_0.getUIName(arg0_2)
	return arg0_2.__cname
end

function var0_0.Init(arg0_3, arg1_3, arg2_3, arg3_3)
	arg0_3.ship = arg1_3

	arg0_3:ClearSpecailBg()

	local var0_3 = arg0_3:getShipBgPrint(arg2_3)

	arg0_3:SetSpecailBg(var0_3, arg3_3)
end

function var0_0.getShipBgPrint(arg0_4, arg1_4)
	local var0_4 = arg0_4.ship

	if not arg1_4 then
		return var0_4:rarity2bgPrintForGet()
	else
		return var0_4:getShipBgPrint()
	end
end

function var0_0.SetSpecailBg(arg0_5, arg1_5, arg2_5)
	arg0_5.isloading = true

	pg.DynamicBgMgr.GetInstance():LoadBg(arg0_5, arg1_5, arg0_5._tf.parent, arg0_5._tf, function(arg0_6)
		arg0_5.isSpecialBg = true
		arg0_5.isloading = false
		arg0_6.transform.localPosition = Vector3(0, 0, 200)

		if arg2_5 then
			arg2_5()
		end
	end, function()
		arg0_5.isloading = false

		if arg2_5 then
			arg2_5()
		end
	end)
end

function var0_0.ClearSpecailBg(arg0_8)
	if arg0_8.isSpecialBg then
		pg.DynamicBgMgr.GetInstance():ClearBg(arg0_8:getUIName())

		arg0_8.isSpecialBg = false
	end
end

function var0_0.IsLoading(arg0_9)
	return arg0_9.isloading
end

function var0_0.Clear(arg0_10)
	arg0_10:ClearSpecailBg()
end

function var0_0.Dispose(arg0_11)
	arg0_11:Clear()
end

return var0_0
