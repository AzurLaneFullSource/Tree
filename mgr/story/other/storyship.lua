local var0 = class("StoryShip", import("model.vo.Ship"))

function var0.Ctor(arg0, arg1)
	arg0.configId = 9999999999
	arg0.skinId = arg1.skin_id or 0
end

return var0
