local var0 = class("ApartmentProxy", import(".NetProxy"))

var0.UPDATE_APARTMENT = "ApartmentProxy.UPDATE_APARTMENT"
var0.UPDATE_GIFT_COUNT = "ApartmentProxy.UPDATE_GIFT_COUNT"

function var0.register(arg0)
	arg0.data = {}
	arg0.giftBag = setDefaultZeroMetatable({})
	arg0.giftGiveCount = setDefaultZeroMetatable({})
end

function var0.updateApartment(arg0, arg1)
	arg0.data[arg1.configId] = arg1:clone()

	arg0:sendNotification(var0.UPDATE_APARTMENT, arg1)
end

function var0.getApartment(arg0, arg1)
	return arg0.data[arg1] and arg0.data[arg1]:clone() or nil
end

function var0.getGiftCount(arg0, arg1)
	return arg0.giftBag[arg1]
end

function var0.changeGiftCount(arg0, arg1, arg2)
	assert(arg2 ~= 0)

	arg0.giftBag[arg1] = arg0.giftBag[arg1] + arg2

	arg0:sendNotification(var0.UPDATE_GIFT_COUNT, arg1)
end

function var0.addGiftGiveCount(arg0, arg1, arg2)
	arg0.giftGiveCount[arg1] = arg0.giftGiveCount[arg1] + arg2
end

function var0.isGiveGiftDone(arg0, arg1)
	return arg0.giftGiveCount[arg1] > 0
end

function var0.getGiftUnlockTalk(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(pg.dorm3d_dialogue_group.get_id_list_by_char_id[20220]) do
		local var0 = pg.dorm3d_dialogue_group[iter1]

		if var0.type == 401 and table.contains(var0.trigger_config, arg2) then
			return iter1
		end
	end
end

function var0.GetTimeIndex(arg0)
	local var0 = 3

	for iter0, iter1 in ipairs({
		7,
		16,
		20
	}) do
		if arg0 < iter1 then
			break
		else
			var0 = iter0
		end
	end

	return var0
end

return var0
