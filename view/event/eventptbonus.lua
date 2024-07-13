local var0_0 = class("EventPtBonus")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tr = arg1_1
	arg0_1.resIcon = findTF(arg0_1.tr, "Image"):GetComponent(typeof(Image))
	arg0_1.resName = findTF(arg0_1.tr, "Text"):GetComponent(typeof(Text))

	setActive(arg0_1.tr, false)
	arg0_1:Update()
end

function var0_0.Update(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_EVENT)

	if var0_2 and var0_2:getConfig("config_client").shopActID then
		setActive(arg0_2.tr, true)
	end
end

return var0_0
