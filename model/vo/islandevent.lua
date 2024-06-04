local var0 = class("IslandEvent", import(".BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.activity_map_event_data
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg1.id
end

function var0.CheckTrigger(arg0, arg1)
	if arg0:getConfig("type") == 2 then
		local var0 = underscore.detect(arg0:getConfig("params"), function(arg0)
			return arg0[1] == arg1
		end)

		assert(var0, string.format("event_%d without params option_%d", arg0.id, arg1))

		if var0[2] then
			local var1 = {}

			var1.type, var1.id, var1.count = unpack(var0[2])

			assert(var1.type == DROP_TYPE_RESOURCE or var1.type == DROP_TYPE_ITEM or var1.type > DROP_TYPE_USE_ACTIVITY_DROP, "error config cosume type")

			if var1:getOwnedCount() < var1.count then
				return false, i18n("common_no_item_1")
			end
		end
	end

	return true
end

function var0.AfterTrigger(arg0, arg1)
	if arg0:getConfig("type") == 2 then
		local var0 = underscore.detect(arg0:getConfig("params"), function(arg0)
			return arg0[1] == arg1
		end)

		if var0[2] then
			local var1, var2, var3 = unpack(var0[2])

			switch(var1, {
				[DROP_TYPE_RESOURCE] = function()
					local var0 = getProxy(PlayerProxy)
					local var1 = var0:getData()

					var1:consume({
						[id2res(var2)] = var3
					})
					var0:updatePlayer(var1)
				end,
				[DROP_TYPE_ITEM] = function()
					getProxy(BagProxy):removeItemById(var2, var3)
				end
			}, function()
				assert(var1 > DROP_TYPE_USE_ACTIVITY_DROP)

				local var0 = getProxy(ActivityProxy)
				local var1 = var0:getActivityById(pg.activity_drop_type[var1].activity_id)

				var1:addVitemNumber(var2, -var3)
				var0:updateActivity(var1)
			end)
		end
	end
end

return var0
