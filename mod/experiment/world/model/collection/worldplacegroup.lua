local var0_0 = class("WorldPlaceGroup")
local var1_0 = pg.world_collection_place_group

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.config = var1_0[arg0_1.configId]

	assert(arg0_1.config, "config is missed")

	arg0_1.pacles = {}

	for iter0_1, iter1_1 in ipairs(arg0_1.config.group) do
		arg0_1.pacles[iter1_1] = WorldPlace.New({
			id = iter1_1,
			number = iter0_1
		})
	end
end

function var0_0.isUnlockAll(arg0_2)
	return _.all(_.values(arg0_2.pacles), function(arg0_3)
		return arg0_3:isUnlock()
	end)
end

function var0_0.existPlace(arg0_4, arg1_4)
	return _.any(_.values(arg0_4.pacles), function(arg0_5)
		return arg0_5.id == arg1_4
	end)
end

function var0_0.getPlace(arg0_6, arg1_6)
	assert(arg0_6.pacles[arg1_6])

	return arg0_6.pacles[arg1_6]
end

function var0_0.unlockPlace(arg0_7, arg1_7)
	assert(arg0_7.pacles[arg1_7])
	arg0_7.pacles[arg1_7]:setUnlock(true)
end

function var0_0.getPlaces(arg0_8)
	return arg0_8.pacles
end

function var0_0.getTitle(arg0_9)
	return arg0_9.config.title
end

function var0_0.getProgress(arg0_10)
	local var0_10 = 0

	for iter0_10, iter1_10 in pairs(arg0_10.pacles) do
		if iter1_10:isUnlock() then
			var0_10 = var0_10 + 1
		end
	end

	return var0_10
end

function var0_0.getTotalProgress(arg0_11)
	return table.getCount(arg0_11.pacles)
end

return var0_0
