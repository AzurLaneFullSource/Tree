local var0 = class("AddItemCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	assert(isa(var0, Drop), "should be an instance of Drop")
	var0:AddItemOperation()
	arg0:UpdateLinkActivity(var0)
end

function var0.UpdateLinkActivity(arg0, arg1)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_LINK_COLLECT)

	if var1 and not var1:isEnd() then
		local var2 = pg.activity_limit_item_guide.get_id_list_by_activity[var1.id]

		assert(var2, "activity_limit_item_guide not exist activity id: " .. var1.id)

		for iter0, iter1 in ipairs(var2) do
			local var3 = pg.activity_limit_item_guide[iter1]

			if arg1.type == var3.type and arg1.id == var3.drop_id then
				local var4 = var1:getKVPList(1, var3.id) + arg1.count

				var1:updateKVPList(1, var3.id, var4)
			end
		end

		var0:updateActivity(var1)
	end
end

return var0
