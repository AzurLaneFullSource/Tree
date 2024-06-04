local var0 = class("CollectionEventActivity", import(".Activity"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.collections = {}

	for iter0, iter1 in ipairs(arg1.collection_list) do
		local var0 = EventInfo.New(iter1)

		var0:SetActivityId(arg0.id)
		table.insert(arg0.collections, var0)
	end

	local var1 = arg0:getConfig("config_data")
	local var2 = arg0:getDayIndex()

	print("collection==============================", var2)

	if #arg0.collections == 0 and var2 > 0 and var2 <= #var1 then
		local var3 = var1[var2]

		if not table.contains(arg0.data1_list, var3) then
			table.insert(arg0.collections, EventInfo.New({
				finish_time = 0,
				over_time = 0,
				id = var3,
				ship_id_list = {},
				activity_id = arg0.id
			}))
		end
	end
end

function var0.getDayIndex(arg0)
	local var0 = arg0.data1
	local var1 = pg.TimeMgr.GetInstance()
	local var2 = var1:GetServerTime()

	return var1:DiffDay(var0, var2) + 1
end

function var0.GetCollectionList(arg0)
	return arg0.collections
end

return var0
