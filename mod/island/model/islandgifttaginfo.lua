local var0_0 = class("IslandGiftTagInfo")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.playerId = arg1_1.key
	arg0_1.endTime = arg1_1.value1
	arg0_1.giftCnt = arg1_1.value2
end

function var0_0.Flush(arg0_2, arg1_2, arg2_2)
	arg0_2.endTime = arg2_2
	arg0_2.giftCnt = arg1_2
end

function var0_0.ExistGift(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_3.giftCnt > 0 and var0_3 < arg0_3.endTime
end

return var0_0
