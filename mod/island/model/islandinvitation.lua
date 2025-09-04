local var0_0 = class("IslandInvitation", import(".IslandItem"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.shipId = arg1_1

	local var0_1 = pg.island_chara_template[arg1_1].invite_item

	var0_0.super.Ctor(arg0_1, {
		time = 0,
		num = 1,
		id = var0_1
	})
end

function var0_0.GetShipName(arg0_2)
	return pg.island_chara_template[arg0_2.shipId].name
end

return var0_0
