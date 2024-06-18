local var0_0 = class("CollectionEventActivity", import(".Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.collections = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.collection_list) do
		local var0_1 = EventInfo.New(iter1_1)

		var0_1:SetActivityId(arg0_1.id)
		table.insert(arg0_1.collections, var0_1)
	end

	local var1_1 = arg0_1:getConfig("config_data")
	local var2_1 = arg0_1:getDayIndex()

	print("collection==============================", var2_1)

	if #arg0_1.collections == 0 and var2_1 > 0 and var2_1 <= #var1_1 then
		local var3_1 = var1_1[var2_1]

		if not table.contains(arg0_1.data1_list, var3_1) then
			table.insert(arg0_1.collections, EventInfo.New({
				finish_time = 0,
				over_time = 0,
				id = var3_1,
				ship_id_list = {},
				activity_id = arg0_1.id
			}))
		end
	end
end

function var0_0.getDayIndex(arg0_2)
	local var0_2 = arg0_2.data1
	local var1_2 = pg.TimeMgr.GetInstance()
	local var2_2 = var1_2:GetServerTime()

	return var1_2:DiffDay(var0_2, var2_2) + 1
end

function var0_0.GetCollectionList(arg0_3)
	return arg0_3.collections
end

return var0_0
