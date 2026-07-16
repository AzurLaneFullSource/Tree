local var0_0 = class("AuctionGameActivity", import("model.vo.Activity"))

function var0_0.readyToAchieve(arg0_1)
	if arg0_1:isEnd() then
		return false
	end

	return arg0_1:GetPreorderTip() or arg0_1:GetOpenPreorderTip() or arg0_1:GetTaskTip() or arg0_1:GetAllLocationTip() or arg0_1:GetReliefTip()
end

function var0_0.GetPreorderTip(arg0_2)
	local var0_2 = getProxy(AuctionGameBaseProxy)
	local var1_2 = var0_2:GetPreorderState()
	local var2_2 = var0_2:GetPreorderTimestamp()
	local var3_2 = pg.TimeMgr.GetInstance():GetServerTime()

	if var1_2 == 1 then
		return false
	end

	if pg.TimeMgr.GetInstance():IsSameDay(var3_2, arg0_2.stopTime) then
		return false
	end

	local var4_2 = getProxy(PlayerProxy):getRawData().id
	local var5_2 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")

	return PlayerPrefs.GetString(string.format("AUCTION_GAME_PREORDER_%s_%s", var4_2, arg0_2.id)) ~= var5_2
end

function var0_0.SetPreorderTip(arg0_3)
	if getProxy(AuctionGameBaseProxy):GetPreorderState() == 1 then
		return
	end

	local var0_3 = getProxy(PlayerProxy):getRawData().id
	local var1_3 = pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")

	PlayerPrefs.SetString(string.format("AUCTION_GAME_PREORDER_%s_%s", var0_3, arg0_3.id), var1_3)
end

function var0_0.GetOpenPreorderTip(arg0_4)
	local var0_4 = getProxy(AuctionGameBaseProxy)
	local var1_4 = var0_4:GetPreorderState()
	local var2_4 = var0_4:GetPreorderTimestamp()
	local var3_4 = pg.TimeMgr.GetInstance():GetServerTime()

	if var1_4 == 1 and var2_4 <= var3_4 then
		return true
	end

	return false
end

function var0_0.GetTaskTip(arg0_5)
	local var0_5 = arg0_5:getConfig("config_client").taskActID
	local var1_5 = getProxy(ActivityProxy):getActivityById(var0_5)

	return var1_5 and var1_5:readyToAchieve()
end

function var0_0.GetAllLocationTip(arg0_6)
	for iter0_6, iter1_6 in ipairs(pg.auction_session.all) do
		if pg.auction_session[iter1_6].game_type ~= 0 and arg0_6:GetLocationTip(iter1_6) then
			return true
		end
	end

	return false
end

function var0_0.GetLocationTip(arg0_7, arg1_7)
	local var0_7 = pg.auction_session[arg1_7]
	local var1_7 = getProxy(PlayerProxy):getRawData().id

	return PlayerPrefs.GetInt(string.format("AUCTION_GAME_LOCATION_%s_%s_%s", var1_7, arg0_7.id, arg1_7), 0) == 0 and AuctionGameTools.GetCurrencyCnt() >= var0_7.threshold
end

function var0_0.SetLocationTip(arg0_8, arg1_8)
	local var0_8 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(string.format("AUCTION_GAME_LOCATION_%s_%s_%s", var0_8, arg0_8.id, arg1_8), 1)
end

function var0_0.GetReliefTip(arg0_9)
	local var0_9 = getProxy(AuctionGameBaseProxy)

	if var0_9.gold < pg.gameset.auction_relief_payment_limit.key_value and var0_9.reliefCnt < pg.gameset.auction_relief_payment_count.key_value then
		return true
	end

	return false
end

return var0_0
