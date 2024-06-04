local var0 = class("EventPtBonus")

function var0.Ctor(arg0, arg1)
	arg0.tr = arg1
	arg0.resIcon = findTF(arg0.tr, "Image"):GetComponent(typeof(Image))
	arg0.resName = findTF(arg0.tr, "Text"):GetComponent(typeof(Text))

	setActive(arg0.tr, false)
	arg0:Update()
end

function var0.Update(arg0)
	local var0 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_EVENT)

	if var0 and var0:getConfig("config_client").shopActID then
		setActive(arg0.tr, true)
	end
end

return var0
