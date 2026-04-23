local var0_0 = class("CollectionEventActivity", import(".Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.collections = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.collection_list) do
		local var0_1 = EventInfo.New(iter1_1)

		var0_1:SetActivityId(arg0_1.id)
		table.insert(arg0_1.collections, var0_1)
	end
end

function var0_0.getDayIndex(arg0_2)
	local var0_2 = arg0_2.data1
	local var1_2 = pg.TimeMgr.GetInstance()
	local var2_2 = var1_2:GetServerTime()

	return var1_2:DiffDay(var0_2, var2_2) + 1
end

function var0_0.GetCollectionList(arg0_3)
	local var0_3 = arg0_3:getConfig("config_data")
	local var1_3 = arg0_3:getDayIndex()

	arg0_3.collections = underscore.filter(arg0_3.collections, function(arg0_4)
		if table.contains(arg0_3:getData1List(), arg0_4.id) then
			return false
		end

		if table.indexof(var0_3, arg0_4.id) < var1_3 and arg0_4:GetState() < EventInfo.StateActive then
			return false
		end

		return true
	end)

	if #arg0_3.collections == 0 and var0_3[var1_3] and not table.contains(arg0_3:getData1List(), var0_3[var1_3]) then
		local var2_3 = EventInfo.New({
			finish_time = 0,
			over_time = 0,
			id = var0_3[var1_3],
			ship_id_list = {},
			activity_id = arg0_3.id
		})

		table.insert(arg0_3.collections, var2_3)
	end

	return arg0_3.collections
end

return var0_0
