local var0_0 = class("CatteryStyleCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.styleIcon = arg0_1._tf:Find("mask/icon"):GetComponent(typeof(Image))
	arg0_1.lockTF = findTF(arg0_1._tf, "lock")
	arg0_1.mark = findTF(arg0_1._tf, "mark")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.style = arg1_2
	arg0_2.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. arg1_2:getConfig("name"), "")

	local var0_2 = arg1_2:IsOwn()

	setActive(arg0_2.lockTF, not var0_2)
	setActive(arg0_2.mark, arg2_2)
end

function var0_0.Dispose(arg0_3)
	return
end

return var0_0
