local var0 = class("IslandProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.nodeDic = nil
	arg0.timeStamp = 0
end

function var0.CheckValid(arg0)
	local var0 = pg.TimeMgr.GetInstance()

	return arg0.nodeDic and var0:IsSameDay(arg0.timeStamp, var0:GetServerTime())
end

function var0.GetNodeDic(arg0)
	if arg0:CheckValid() then
		return arg0.nodeDic
	else
		return {}
	end
end

function var0.CheckAndRequest(arg0, arg1)
	local var0 = {}
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

	if var1 and not var1:isEnd() and not arg0:CheckValid() then
		table.insert(var0, function(arg0)
			arg0:sendNotification(GAME.REQUEST_NODE_LIST, {
				act_id = var1.id,
				callback = arg0
			})
		end)
	end

	seriesAsync(var0, arg1)
end

function var0.GetNode(arg0, arg1)
	return arg0.nodeDic[arg1]
end

function var0.GetNodeIds(arg0)
	local var0 = underscore.keys(arg0.nodeDic)

	table.sort(var0)

	return var0
end

return var0
