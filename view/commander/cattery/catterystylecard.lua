local var0 = class("CatteryStyleCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.styleIcon = arg0._tf:Find("mask/icon"):GetComponent(typeof(Image))
	arg0.lockTF = findTF(arg0._tf, "lock")
	arg0.mark = findTF(arg0._tf, "mark")
end

function var0.Update(arg0, arg1, arg2)
	arg0.style = arg1
	arg0.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. arg1:getConfig("name"), "")

	local var0 = arg1:IsOwn()

	setActive(arg0.lockTF, not var0)
	setActive(arg0.mark, arg2)
end

function var0.Dispose(arg0)
	return
end

return var0
