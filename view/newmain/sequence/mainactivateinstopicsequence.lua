local var0_0 = class("MainActivateInsTopicSequence")
local var1_0 = pg.activity_ins_chat_group
local var2_0 = pg.ship_data_group

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = {}
	local var1_1 = getProxy(InstagramChatProxy)
	local var2_1 = var1_1:GetNotActiveTopicIdsByType(1)
	local var3_1 = var1_1:GetNotActiveTopicIdsByType(2)
	local var4_1 = var1_1:GetNotActiveTopicIdsByType(3)
	local var5_1 = var1_1:GetNotActiveTopicIdsByType(4)
	local var6_1 = var1_1:GetNotActiveTopicIdsByType(5)
	local var7_1 = var1_1:GetNotActiveTopicIdsByType(6)
	local var8_1 = var1_1:GetNotActiveTopicIdsByType(7)
	local var9_1 = getProxy(CollectionProxy):getGroups()

	for iter0_1, iter1_1 in ipairs(var2_0.all) do
		local var10_1 = var2_0[iter1_1]

		if ShipGroup.getState(var10_1.code, var9_1[var10_1.group_type], false) == ShipGroup.STATE_UNLOCK then
			local var11_1 = var1_0.get_id_list_by_ship_group[var10_1.group_type]

			if var11_1 then
				for iter2_1, iter3_1 in ipairs(var11_1) do
					if var2_1 and _.contains(var2_1, iter3_1) then
						table.insert(var0_1, iter3_1)
					end

					if var3_1 and _.contains(var3_1, iter3_1) and var9_1[var10_1.group_type].maxIntimacy / 100 >= tonumber(var1_0[iter3_1].trigger_param) then
						table.insert(var0_1, iter3_1)
					end

					if var8_1 and _.contains(var8_1, iter3_1) and var9_1[var10_1.group_type].married == 1 then
						table.insert(var0_1, iter3_1)
					end
				end
			end
		end
	end

	if var4_1 then
		local var12_1 = pg.TimeMgr.GetInstance():GetServerTime()

		for iter4_1, iter5_1 in ipairs(var4_1) do
			if #var1_0[iter5_1].trigger_param == 1 then
				if var12_1 >= pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_0[iter5_1].trigger_param[1]) then
					table.insert(var0_1, iter5_1)
				end
			elseif #var1_0[iter5_1].trigger_param == 2 then
				local var13_1 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_0[iter5_1].trigger_param[1])
				local var14_1 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_0[iter5_1].trigger_param[2])

				if var13_1 <= var12_1 and var12_1 <= var14_1 then
					table.insert(var0_1, iter5_1)
				end
			end
		end
	end

	if var5_1 then
		for iter6_1, iter7_1 in ipairs(var5_1) do
			local var15_1 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(tonumber(var1_0[iter7_1].trigger_param))

			if pg.NewStoryMgr.GetInstance():IsPlayed(var15_1) then
				table.insert(var0_1, iter7_1)
			end
		end
	end

	if var6_1 then
		for iter8_1, iter9_1 in ipairs(var6_1) do
			if getProxy(ChapterProxy):getChapterById(tonumber(var1_0[iter9_1].trigger_param)):isClear() then
				table.insert(var0_1, iter9_1)
			end
		end
	end

	if var7_1 then
		local var16_1 = getProxy(TaskProxy)

		for iter10_1, iter11_1 in ipairs(var7_1) do
			if var16_1:getFinishTaskById(tonumber(var1_0[iter11_1].trigger_param)) then
				table.insert(var0_1, iter11_1)
			end
		end
	end

	if #var0_1 > 0 then
		var1_1:ActivateTopics(var0_1)
	end

	var1_1:UpdateAllChatBackGrounds()
	arg1_1()
end

function var0_0.ShowTip(arg0_2)
	return
end

return var0_0
