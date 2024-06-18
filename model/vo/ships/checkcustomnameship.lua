local var0_0 = class("CheckCustomNameShip", import("model.vo.Ship"))

function var0_0.getName(arg0_1)
	if getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() then
		return arg0_1:GetDefaultName()
	else
		return var0_0.super.getName(arg0_1)
	end
end

return var0_0
