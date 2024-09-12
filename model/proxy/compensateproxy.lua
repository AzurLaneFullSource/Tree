local var0_0 = class("CompensateProxy", import(".NetProxy"))

var0_0.Compensate_Remove = "CompensateProxy Compensate_Remove"
var0_0.All_Compensate_Remove = "CompensateProxy All_Compensate_Remove"
var0_0.UPDATE_ATTACHMENT_COUNT = "CompensateProxy UPDATE_ATTACHMENT_COUNT"

function var0_0.register(arg0_1)
	arg0_1.data = {}

	arg0_1:on(30101, function(arg0_2)
		arg0_1:unpdateLatestTime(arg0_2.max_timestamp)
		arg0_1:unpdateUnreadCount(arg0_2.number)
		arg0_1:SetDirty(true)
	end)
end

function var0_0.RefreshRewardList(arg0_3, arg1_3)
	arg0_3.data = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		arg0_3.data[iter1_3.id] = iter1_3
	end
end

function var0_0.GetAllRewardList(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in pairs(arg0_4.data) do
		if iter1_4.timestamp - pg.TimeMgr.GetInstance():GetServerTime() > 0 then
			table.insert(var0_4, iter1_4)
		end
	end

	return var0_4
end

function var0_0.GetCompensateAttachments(arg0_5, arg1_5)
	local var0_5 = {}
	local var1_5 = arg0_5.data[arg1_5]

	if not var1_5.attachFlag then
		for iter0_5, iter1_5 in ipairs(var1_5.attachments) do
			table.insert(var0_5, Clone(iter1_5))
		end
	end

	return PlayerConst.MergeSameDrops(var0_5)
end

function var0_0.DealMailOperation(arg0_6, arg1_6)
	if arg0_6.data[arg1_6] then
		arg0_6.data[arg1_6]:setAttachFlag(true)
	end
end

function var0_0.timeCall(arg0_7)
	return {
		[ProxyRegister.SecondCall] = function(arg0_8)
			local var0_8

			for iter0_8, iter1_8 in pairs(arg0_7.data) do
				if iter1_8:isEnd() then
					if var0_8 == nil then
						var0_8 = {}
					end

					table.insert(var0_8, iter0_8)
				end
			end

			if var0_8 ~= nil then
				for iter2_8, iter3_8 in ipairs(var0_8) do
					arg0_7.data[iter3_8] = nil
				end

				arg0_7:sendNotification(var0_0.Compensate_Remove)
			end

			if arg0_7.max_timestamp ~= 0 and arg0_7.max_timestamp - pg.TimeMgr.GetInstance():GetServerTime() < 0 then
				arg0_7.max_timestamp = 0

				arg0_7:sendNotification(var0_0.All_Compensate_Remove)
			end
		end
	}
end

function var0_0.unpdateLatestTime(arg0_9, arg1_9)
	arg0_9.max_timestamp = arg1_9
end

function var0_0.unpdateUnreadCount(arg0_10, arg1_10)
	arg0_10._existUnreadCount = arg1_10

	arg0_10:sendNotification(var0_0.UPDATE_ATTACHMENT_COUNT)
end

function var0_0.IsDirty(arg0_11)
	return arg0_11.isDirty
end

function var0_0.SetDirty(arg0_12, arg1_12)
	arg0_12.isDirty = arg1_12
end

function var0_0.hasRewardCount(arg0_13)
	local var0_13 = arg0_13.max_timestamp - pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_13._existUnreadCount > 0 and var0_13 > 0
end

return var0_0
