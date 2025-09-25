local var0_0 = class("IslandCardDiyAgency", import(".IslandBaseAgency"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.data = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.image_list) do
		arg0_1.data[iter1_1.id] = IslandCardDiy.New(iter1_1)
	end

	local var0_1 = pg.island_set.island_card_photo_default.key_value_int

	if not arg0_1.data[var0_1] then
		arg0_1.data[var0_1] = IslandCardDiy.New({
			num = 1,
			id = var0_1
		})
	end
end

function var0_0.GetData(arg0_2)
	return arg0_2.data
end

function var0_0.GetIds(arg0_3)
	return underscore.keys(arg0_3.data)
end

function var0_0.AddCardDiy(arg0_4, arg1_4)
	if arg0_4.data[arg1_4.id] then
		arg0_4.data[arg1_4.id]:AddCount(arg1_4.num)
	else
		arg0_4.data[arg1_4.id] = IslandCardDiy.New(arg1_4)
	end
end

return var0_0
