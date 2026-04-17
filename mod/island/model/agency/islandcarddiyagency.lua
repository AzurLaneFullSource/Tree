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

function var0_0.GetIdCount(arg0_4, arg1_4)
	return arg0_4.data[arg1_4] and arg0_4.data[arg1_4].count or 0
end

function var0_0.AddCardDiy(arg0_5, arg1_5)
	if arg0_5.data[arg1_5.id] then
		arg0_5.data[arg1_5.id]:AddCount(arg1_5.num)
	else
		arg0_5.data[arg1_5.id] = IslandCardDiy.New(arg1_5)
	end
end

return var0_0
