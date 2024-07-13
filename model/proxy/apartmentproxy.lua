local var0_0 = class("ApartmentProxy", import(".NetProxy"))

var0_0.UPDATE_APARTMENT = "ApartmentProxy.UPDATE_APARTMENT"
var0_0.UPDATE_GIFT_COUNT = "ApartmentProxy.UPDATE_GIFT_COUNT"

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.giftBag = setDefaultZeroMetatable({})
	arg0_1.giftGiveCount = setDefaultZeroMetatable({})
end

function var0_0.updateApartment(arg0_2, arg1_2)
	arg0_2.data[arg1_2.configId] = arg1_2:clone()

	arg0_2:sendNotification(var0_0.UPDATE_APARTMENT, arg1_2)
end

function var0_0.getApartment(arg0_3, arg1_3)
	return arg0_3.data[arg1_3] and arg0_3.data[arg1_3]:clone() or nil
end

function var0_0.getGiftCount(arg0_4, arg1_4)
	return arg0_4.giftBag[arg1_4]
end

function var0_0.changeGiftCount(arg0_5, arg1_5, arg2_5)
	assert(arg2_5 ~= 0)

	arg0_5.giftBag[arg1_5] = arg0_5.giftBag[arg1_5] + arg2_5

	arg0_5:sendNotification(var0_0.UPDATE_GIFT_COUNT, arg1_5)
end

function var0_0.addGiftGiveCount(arg0_6, arg1_6, arg2_6)
	arg0_6.giftGiveCount[arg1_6] = arg0_6.giftGiveCount[arg1_6] + arg2_6
end

function var0_0.isGiveGiftDone(arg0_7, arg1_7)
	return arg0_7.giftGiveCount[arg1_7] > 0
end

function var0_0.getGiftUnlockTalk(arg0_8, arg1_8, arg2_8)
	for iter0_8, iter1_8 in ipairs(pg.dorm3d_dialogue_group.get_id_list_by_char_id[20220]) do
		local var0_8 = pg.dorm3d_dialogue_group[iter1_8]

		if var0_8.type == 401 and table.contains(var0_8.trigger_config, arg2_8) then
			return iter1_8
		end
	end
end

function var0_0.GetTimeIndex(arg0_9)
	local var0_9 = 3

	for iter0_9, iter1_9 in ipairs({
		7,
		16,
		20
	}) do
		if arg0_9 < iter1_9 then
			break
		else
			var0_9 = iter0_9
		end
	end

	return var0_9
end

return var0_0
