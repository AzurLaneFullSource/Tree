local var0_0 = class("IslandProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.nodeDic = nil
	arg0_1.timeStamp = 0
end

function var0_0.CheckValid(arg0_2)
	local var0_2 = pg.TimeMgr.GetInstance()

	return arg0_2.nodeDic and var0_2:IsSameDay(arg0_2.timeStamp, var0_2:GetServerTime())
end

function var0_0.GetNodeDic(arg0_3)
	if arg0_3:CheckValid() then
		return arg0_3.nodeDic
	else
		return {}
	end
end

function var0_0.CheckAndRequest(arg0_4, arg1_4)
	local var0_4 = {}
	local var1_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

	if var1_4 and not var1_4:isEnd() and not arg0_4:CheckValid() then
		table.insert(var0_4, function(arg0_5)
			arg0_4:sendNotification(GAME.REQUEST_NODE_LIST, {
				act_id = var1_4.id,
				callback = arg0_5
			})
		end)
	end

	seriesAsync(var0_4, arg1_4)
end

function var0_0.GetNode(arg0_6, arg1_6)
	return arg0_6.nodeDic[arg1_6]
end

function var0_0.GetNodeIds(arg0_7)
	local var0_7 = underscore.keys(arg0_7.nodeDic)

	table.sort(var0_7)

	return var0_7
end

return var0_0
