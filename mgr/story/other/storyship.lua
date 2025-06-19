local var0_0 = class("StoryShip", import("model.vo.Ship"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = 9999999999
	arg0_1.skinId = arg1_1.skin_id or 0
	arg0_1.noChangeSkin = true
end

return var0_0
