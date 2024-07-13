local var0_0 = class("AddItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	assert(isa(var0_1, Drop), "should be an instance of Drop")
	var0_1:AddItemOperation()
	arg0_1:UpdateLinkActivity(var0_1)
end

function var0_0.UpdateLinkActivity(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy)
	local var1_2 = var0_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_LINK_COLLECT)

	if var1_2 and not var1_2:isEnd() then
		local var2_2 = pg.activity_limit_item_guide.get_id_list_by_activity[var1_2.id]

		assert(var2_2, "activity_limit_item_guide not exist activity id: " .. var1_2.id)

		for iter0_2, iter1_2 in ipairs(var2_2) do
			local var3_2 = pg.activity_limit_item_guide[iter1_2]

			if arg1_2.type == var3_2.type and arg1_2.id == var3_2.drop_id then
				local var4_2 = var1_2:getKVPList(1, var3_2.id) + arg1_2.count

				var1_2:updateKVPList(1, var3_2.id, var4_2)
			end
		end

		var0_2:updateActivity(var1_2)
	end
end

return var0_0
