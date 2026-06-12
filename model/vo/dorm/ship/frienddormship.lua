local var0_0 = class("FriendDormShip", import(".DormShip"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.configId = arg1_1.tid
	arg0_1.skinId = arg1_1.skin_id
end

function var0_0.ToBayShip(arg0_2)
	return (Ship.New({
		energy = 100,
		id = arg0_2.id,
		configId = arg0_2.configId,
		skin_id = arg0_2.skinId
	}))
end

return var0_0
