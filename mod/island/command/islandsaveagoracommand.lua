local var0_0 = class("IslandSaveAgoraCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().list
	local var1_1, var2_1, var3_1 = arg0_1:GetChangeList(var0_1)
	local var4_1 = arg0_1:Serialize(var1_1)
	local var5_1 = arg0_1:Serialize(var2_1)
	local var6_1 = arg0_1:Serialize(var3_1)

	if #var4_1 == 0 and #var5_1 == 0 and #var6_1 == 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21307, {
		update_list = var4_1,
		delete_list = var5_1,
		add_list = var6_1
	}, 21308, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetAgoraAgency():UpdatePlacedList(var0_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.Serialize(arg0_3, arg1_3)
	return _.map(arg1_3, function(arg0_4)
		return {
			id = arg0_4.id,
			x = arg0_4.position.x,
			y = arg0_4.position.y,
			dir = arg0_4.dir
		}
	end)
end

function var0_0.GetChangeList(arg0_5, arg1_5)
	local var0_5 = getProxy(IslandProxy):GetIsland():GetAgoraAgency():GetPlacedList()
	local var1_5 = _.select(arg1_5, function(arg0_6)
		return not arg0_5:HasItem(arg0_6, var0_5)
	end)
	local var2_5 = _.select(var0_5, function(arg0_7)
		return not arg0_5:HasItem(arg0_7, arg1_5)
	end)

	return _.select(arg1_5, function(arg0_8)
		return not arg0_5:HasItem(arg0_8, var1_5) and not arg0_5:HasItem(arg0_8, var2_5) and arg0_5:HasChange(arg0_8, var0_5)
	end), var2_5, var1_5
end

function var0_0.HasItem(arg0_9, arg1_9, arg2_9)
	for iter0_9, iter1_9 in ipairs(arg2_9) do
		if iter1_9.id == arg1_9.id then
			return true
		end
	end

	return false
end

function var0_0.HasChange(arg0_10, arg1_10, arg2_10)
	local var0_10

	for iter0_10, iter1_10 in ipairs(arg2_10) do
		if iter1_10.id == arg1_10.id then
			var0_10 = iter1_10

			break
		end
	end

	return not arg1_10:IsSame(var0_10)
end

return var0_0
