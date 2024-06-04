local var0 = class("CheckCustomNameShip", import("model.vo.Ship"))

function var0.getName(arg0)
	if getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() then
		return arg0:GetDefaultName()
	else
		return var0.super.getName(arg0)
	end
end

return var0
