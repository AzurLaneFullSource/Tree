local var0_0 = class("ActivityRemasterProxy", import("model.proxy.NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.actTimeID = 0
	arg0_1.activeActID = 0
	arg0_1.remasterActList = {}

	for iter0_1, iter1_1 in ipairs(pg.activity_re.all) do
		arg0_1.remasterActList[iter1_1] = ActivityRemasterData.New({
			id = iter1_1
		})
	end

	arg0_1:on(11213, function(arg0_2)
		arg0_1.actTimeID = arg0_2.activity_re_timer_id
		arg0_1.activeActID = arg0_2.activity_re_id

		for iter0_2, iter1_2 in ipairs(arg0_2.finish_re_id) do
			arg0_1:SetRemasterDataFinish(iter1_2)
		end
	end)
end

function var0_0.CanActiveRemaster(arg0_3, arg1_3)
	local var0_3 = arg0_3:GetReamsterData(arg1_3)

	if not var0_3 then
		return false
	end

	if var0_3:IsSpecial() then
		return true
	end

	if var0_3:IsFinish() then
		return false
	end

	return true
end

function var0_0.ActiveActivity(arg0_4, arg1_4, arg2_4)
	arg0_4.activeActID = arg1_4
	arg0_4.actTimeID = arg2_4

	arg0_4:SetRemasterDataFinish(arg1_4)
end

function var0_0.SetRemasterDataFinish(arg0_5, arg1_5)
	local var0_5 = arg0_5:GetReamsterData(arg1_5)

	if var0_5 then
		var0_5:MarkFinish()
	end
end

function var0_0.GetActivaingReamsterData(arg0_6)
	return arg0_6:GetReamsterData(arg0_6.activeActID)
end

function var0_0.GetRemasterActList(arg0_7)
	return arg0_7.remasterActList
end

function var0_0.GetReamsterData(arg0_8, arg1_8)
	return arg0_8.remasterActList[arg1_8]
end

function var0_0.InActTime(arg0_9)
	for iter0_9, iter1_9 in ipairs(pg.activity_re_timer.all) do
		local var0_9 = pg.activity_re_timer[iter1_9]

		if pg.TimeMgr.GetInstance():inTime(var0_9.timer) then
			return true, iter1_9
		end
	end

	return false, arg0_9.actTimeID
end

function var0_0.GetActiveActID(arg0_10)
	return arg0_10.activeActID
end

function var0_0.IsActivating(arg0_11)
	if not arg0_11.activeActID or arg0_11.activeActID == 0 then
		return false
	end

	if not arg0_11.actTimeID or arg0_11.actTimeID == 0 then
		return false
	end

	local var0_11 = pg.activity_re_timer[arg0_11.actTimeID]

	if not var0_11 then
		return false
	end

	return (pg.TimeMgr.GetInstance():inTime(var0_11.timer))
end

function var0_0.IsShowTime(arg0_12)
	if not arg0_12.activeActID or arg0_12.activeActID == 0 then
		return false
	end

	if not arg0_12.actTimeID or arg0_12.actTimeID == 0 then
		return false
	end

	local var0_12 = arg0_12:GetReamsterData(arg0_12.activeActID):GetActList()
	local var1_12 = getProxy(ActivityProxy)
	local var2_12 = 0

	for iter0_12, iter1_12 in ipairs(var0_12) do
		local var3_12 = var1_12:RawGetActivityById(iter1_12)

		if var3_12 and var2_12 < var3_12.stopTime then
			var2_12 = var3_12.stopTime
		end
	end

	if var2_12 <= 0 then
		return false
	end

	return var2_12 > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.ShouldShowActiveBtn(arg0_13)
	return getProxy(ActivityRemasterProxy):InActTime() and not getProxy(ActivityRemasterProxy):IsActivating()
end

function var0_0.GetBanners(arg0_14)
	if not arg0_14:IsActivating() then
		return {}
	end

	local var0_14 = pg.activity_re[arg0_14.activeActID]

	if not var0_14 then
		return {}
	end

	local var1_14 = {}

	for iter0_14, iter1_14 in ipairs(var0_14.act_time or {}) do
		local var2_14 = iter1_14[1]
		local var3_14 = iter1_14[2]
		local var4_14 = iter1_14[3] or 0

		if var4_14 > 0 then
			table.insert(var1_14, var4_14)
		end
	end

	return var1_14
end

function var0_0.GetShopBanner(arg0_15)
	if not arg0_15:ExistShopBanner() then
		return nil
	end

	local var0_15 = pg.shop_banner_template.all
	local var1_15 = var0_15[#var0_15]
	local var2_15 = pg.shop_banner_template[var1_15]
	local var3_15 = Clone(var2_15)

	var3_15.pic = "shopbanner_remaster/" .. arg0_15.activeActID
	var3_15.param = {
		"scene shop",
		{
			warp = "activity"
		}
	}
	var3_15.relation_param = ""
	var3_15.name = "banner_small3"
	var3_15.time = "always"
	var3_15.time_lable = 0
	var3_15.type = 2

	return var3_15
end

function var0_0.ExistShopBanner(arg0_16)
	if not arg0_16.activeActID or arg0_16.activeActID == 0 then
		return false
	end

	if not arg0_16.actTimeID or arg0_16.actTimeID == 0 then
		return false
	end

	local var0_16 = arg0_16:GetReamsterData(arg0_16.activeActID)

	if not var0_16 then
		return false
	end

	local var1_16 = getProxy(ActivityProxy)

	for iter0_16, iter1_16 in ipairs(var0_16:GetActList()) do
		local var2_16 = var1_16:RawGetActivityById(iter1_16)

		if var2_16 and not var2_16:isEnd() and var2_16:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SHOP then
			return true
		end
	end

	return false
end

function var0_0.remove(arg0_17)
	return
end

return var0_0
