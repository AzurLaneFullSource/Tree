local var0_0 = class("IslandEvent", import(".BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_map_event_data
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg1_2.id
end

function var0_0.CheckTrigger(arg0_3, arg1_3)
	if arg0_3:getConfig("type") == 2 then
		local var0_3 = underscore.detect(arg0_3:getConfig("params"), function(arg0_4)
			return arg0_4[1] == arg1_3
		end)

		assert(var0_3, string.format("event_%d without params option_%d", arg0_3.id, arg1_3))

		if var0_3[2] then
			local var1_3 = {}

			var1_3.type, var1_3.id, var1_3.count = unpack(var0_3[2])

			assert(var1_3.type == DROP_TYPE_RESOURCE or var1_3.type == DROP_TYPE_ITEM or var1_3.type > DROP_TYPE_USE_ACTIVITY_DROP, "error config cosume type")

			if var1_3:getOwnedCount() < var1_3.count then
				return false, i18n("common_no_item_1")
			end
		end
	end

	return true
end

function var0_0.AfterTrigger(arg0_5, arg1_5)
	if arg0_5:getConfig("type") == 2 then
		local var0_5 = underscore.detect(arg0_5:getConfig("params"), function(arg0_6)
			return arg0_6[1] == arg1_5
		end)

		if var0_5[2] then
			local var1_5, var2_5, var3_5 = unpack(var0_5[2])

			switch(var1_5, {
				[DROP_TYPE_RESOURCE] = function()
					local var0_7 = getProxy(PlayerProxy)
					local var1_7 = var0_7:getData()

					var1_7:consume({
						[id2res(var2_5)] = var3_5
					})
					var0_7:updatePlayer(var1_7)
				end,
				[DROP_TYPE_ITEM] = function()
					getProxy(BagProxy):removeItemById(var2_5, var3_5)
				end
			}, function()
				assert(var1_5 > DROP_TYPE_USE_ACTIVITY_DROP)

				local var0_9 = getProxy(ActivityProxy)
				local var1_9 = var0_9:getActivityById(pg.activity_drop_type[var1_5].activity_id)

				var1_9:addVitemNumber(var2_5, -var3_5)
				var0_9:updateActivity(var1_9)
			end)
		end
	end
end

return var0_0
