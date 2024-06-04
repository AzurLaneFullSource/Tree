local var0 = class("WorldPlaceGroup")
local var1 = pg.world_collection_place_group

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
	arg0.config = var1[arg0.configId]

	assert(arg0.config, "config is missed")

	arg0.pacles = {}

	for iter0, iter1 in ipairs(arg0.config.group) do
		arg0.pacles[iter1] = WorldPlace.New({
			id = iter1,
			number = iter0
		})
	end
end

function var0.isUnlockAll(arg0)
	return _.all(_.values(arg0.pacles), function(arg0)
		return arg0:isUnlock()
	end)
end

function var0.existPlace(arg0, arg1)
	return _.any(_.values(arg0.pacles), function(arg0)
		return arg0.id == arg1
	end)
end

function var0.getPlace(arg0, arg1)
	assert(arg0.pacles[arg1])

	return arg0.pacles[arg1]
end

function var0.unlockPlace(arg0, arg1)
	assert(arg0.pacles[arg1])
	arg0.pacles[arg1]:setUnlock(true)
end

function var0.getPlaces(arg0)
	return arg0.pacles
end

function var0.getTitle(arg0)
	return arg0.config.title
end

function var0.getProgress(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.pacles) do
		if iter1:isUnlock() then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.getTotalProgress(arg0)
	return table.getCount(arg0.pacles)
end

return var0
