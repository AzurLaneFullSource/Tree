local var0_0 = class("TaskCommonPage", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "TaskListPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2._scrllPanel = arg0_2:findTF("right_panel")
	arg0_2._scrollView = arg0_2._scrllPanel:GetComponent("LScrollRect")
end

function var0_0.OnInit(arg0_3)
	arg0_3.taskCards = {}

	function arg0_3._scrollView.onInitItem(arg0_4)
		arg0_3:onInitTask(arg0_4)
	end

	function arg0_3._scrollView.onUpdateItem(arg0_5, arg1_5)
		arg0_3:onUpdateTask(arg0_5, arg1_5)
	end
end

function var0_0.onInitTask(arg0_6, arg1_6)
	local var0_6 = TaskCard.New(arg1_6, arg0_6.contextData.viewComponent)

	arg0_6.taskCards[arg1_6] = var0_6
end

function var0_0.onUpdateTask(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.taskCards[arg2_7]

	if not var0_7 then
		arg0_7:onInitTask(arg2_7)

		var0_7 = arg0_7.taskCards[arg2_7]
	end

	local var1_7 = arg0_7.taskVOs[arg1_7 + 1]

	var0_7:update(var1_7)
end

function var0_0.Update(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8:Show()

	arg0_8.taskVOs = {}

	local var0_8 = arg0_8.contextData.taskVOsById

	for iter0_8, iter1_8 in pairs(var0_8) do
		if iter1_8:ShowOnTaskScene() and arg2_8[iter1_8:GetRealType()] then
			table.insert(arg0_8.taskVOs, iter1_8)
		end
	end

	if (arg1_8 == TaskScene.PAGE_TYPE_ALL or arg1_8 == TaskScene.PAGE_TYPE_ROUTINE) and TaskScene.IsPassScenario() and TaskScene.IsNewStyleTime() then
		local var1_8 = pg.gameset.daily_task_new.description
		local var2_8 = getProxy(TaskProxy)

		for iter2_8, iter3_8 in ipairs(var1_8) do
			if not (var2_8:getTaskById(iter3_8) or var2_8:getFinishTaskById(iter3_8)) then
				table.insert(arg0_8.taskVOs, Task.New({
					progress = 0,
					id = iter3_8
				}))
			end
		end
	end

	if arg1_8 == TaskScene.PAGE_TYPE_ALL or arg1_8 == TaskScene.PAGE_TYPE_ACT then
		local var3_8 = getProxy(AvatarFrameProxy):getAllAvatarFrame()

		for iter4_8, iter5_8 in ipairs(var3_8) do
			local var4_8 = iter5_8.tasks

			for iter6_8, iter7_8 in ipairs(var4_8) do
				table.insert(arg0_8.taskVOs, iter7_8)
			end
		end
	end

	arg0_8:Sort()
	arg0_8._scrollView:SetTotalCount(#arg0_8.taskVOs, -1)

	local var5_8 = arg0_8:GetSliderValue()

	if var5_8 > 0 then
		arg0_8._scrollView:ScrollTo(var5_8)
	end

	if arg3_8 then
		arg3_8(arg0_8.taskVOs)
	end
end

function var0_0.GetSliderValue(arg0_9)
	local var0_9 = -1

	if arg0_9.contextData.targetId then
		local var1_9

		for iter0_9, iter1_9 in ipairs(arg0_9.taskVOs) do
			if iter1_9.id == arg0_9.contextData.targetId then
				var1_9 = iter0_9 - 1

				break
			end
		end

		if var1_9 then
			var0_9 = arg0_9._scrollView:HeadIndexToValue(var1_9)
		end
	end

	return var0_9
end

function var0_0.Sort(arg0_10)
	local function var0_10(arg0_11, arg1_11, arg2_11)
		local function var0_11(arg0_12)
			for iter0_12, iter1_12 in ipairs(arg2_11) do
				if arg0_12 == iter1_12 then
					return iter0_12
				end
			end
		end

		return var0_11(arg0_11) < var0_11(arg1_11)
	end

	local function var1_10(arg0_13)
		return arg0_13:IsUrTask() and 1 or 0
	end

	local function var2_10(arg0_14)
		return arg0_14.configId or 0
	end

	local function var3_10(arg0_15, arg1_15)
		if arg0_15:GetRealType() == arg1_15:GetRealType() then
			if arg0_15:isAvatarTask() and arg1_15:isAvatarTask() then
				local var0_15 = var2_10(arg0_15)
				local var1_15 = var2_10(arg1_15)

				if var0_15 == var1_15 then
					return arg0_15.id < arg1_15.id
				else
					return var1_15 < var0_15
				end
			else
				return arg0_15.id < arg1_15.id
			end
		elseif arg0_15:getTaskStatus() == 0 then
			return var0_10(arg0_15:GetRealType(), arg1_15:GetRealType(), {
				26,
				36,
				6,
				3,
				4,
				13,
				5,
				2,
				1
			})
		elseif arg0_15:getTaskStatus() == 1 then
			return var0_10(arg0_15:GetRealType(), arg1_15:GetRealType(), {
				26,
				36,
				6,
				1,
				4,
				13,
				2,
				5,
				3
			})
		end
	end

	table.sort(arg0_10.taskVOs, function(arg0_16, arg1_16)
		if arg0_16:getTaskStatus() == arg1_16:getTaskStatus() then
			local var0_16 = arg0_16.id == 10302 and 1 or 0
			local var1_16 = arg1_16.id == 10302 and 1 or 0

			if var0_16 == var1_16 then
				local var2_16 = var1_10(arg0_16)
				local var3_16 = var1_10(arg1_16)

				if var2_16 == var3_16 then
					return var3_10(arg0_16, arg1_16)
				else
					return var3_16 < var2_16
				end
			else
				return var1_16 < var0_16
			end
		else
			return var0_10(arg0_16:getTaskStatus(), arg1_16:getTaskStatus(), {
				1,
				0,
				2,
				-1
			})
		end
	end)
end

function var0_0.OnDestroy(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.taskCards) do
		iter1_17:dispose()
	end
end

function var0_0.GetWaitToCheckList(arg0_18)
	local var0_18 = arg0_18.taskVOs or {}
	local var1_18 = {}

	for iter0_18, iter1_18 in pairs(var0_18) do
		if iter1_18:getTaskStatus() == 1 and iter1_18:ShowOnTaskScene() then
			table.insert(var1_18, iter1_18)
		end
	end

	return var1_18
end

function var0_0.ExecuteOneStepSubmit(arg0_19)
	local var0_19 = arg0_19:GetWaitToCheckList()
	local var1_19
	local var2_19 = false
	local var3_19

	local function var4_19()
		var1_19, var2_19 = arg0_19:filterOverflowTaskVOList(var0_19)
		var1_19 = arg0_19:filterSubmitTaskVOList(var1_19, var3_19)
		var1_19 = arg0_19:filterChoiceTaskVOList(var1_19, var3_19)

		local var0_20 = {}

		for iter0_20 = #var1_19, 1, -1 do
			local var1_20 = var1_19[iter0_20]

			if var1_20:isAvatarTask() then
				if not var0_20[var1_20.actId] then
					var0_20[var1_20.actId] = {}
				end

				table.insert(var0_20[var1_20.actId], var1_20.id)
				table.remove(var1_19, iter0_20)
			end
		end

		for iter1_20, iter2_20 in pairs(var0_20) do
			if #iter2_20 > 0 then
				pg.m02:sendNotification(GAME.AVATAR_FRAME_AWARD, {
					act_id = iter1_20,
					task_ids = iter2_20,
					callback = function()
						var3_19()
					end
				})
				coroutine.yield()
			end
		end

		if #var1_19 > 0 then
			pg.m02:sendNotification(GAME.MERGE_TASK_ONE_STEP_AWARD, {
				resultList = var1_19
			})
		end
	end

	var3_19 = coroutine.wrap(var4_19)

	var3_19()

	if var2_19 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("award_overflow_tip"))

		var2_19 = false
	end
end

function var0_0.filterOverflowTaskVOList(arg0_22, arg1_22)
	local var0_22 = {}
	local var1_22 = getProxy(PlayerProxy):getData()
	local var2_22 = pg.gameset.urpt_chapter_max.description[1]
	local var3_22 = var1_22.gold
	local var4_22 = var1_22.oil
	local var5_22 = not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var2_22) or 0
	local var6_22 = pg.gameset.max_gold.key_value
	local var7_22 = pg.gameset.max_oil.key_value

	if LOCK_UR_SHIP or not pg.gameset.urpt_chapter_max.description[2] then
		local var8_22 = 0
	end

	local var9_22 = false

	for iter0_22, iter1_22 in pairs(arg1_22) do
		local var10_22 = iter1_22:judgeOverflow(var3_22, var4_22, var5_22)

		if not var10_22 then
			table.insert(var0_22, iter1_22)
		end

		if var10_22 then
			var9_22 = true
		end
	end

	return var0_22, var9_22
end

function var0_0.filterSubmitTaskVOList(arg0_23, arg1_23, arg2_23)
	local var0_23 = {}
	local var1_23 = arg1_23

	for iter0_23, iter1_23 in ipairs(var1_23) do
		if iter1_23:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM or iter1_23:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM or iter1_23:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
			local var2_23 = DROP_TYPE_ITEM

			if iter1_23:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
				var2_23 = DROP_TYPE_RESOURCE
			end

			local var3_23 = {
				type = var2_23,
				id = tonumber(iter1_23:getConfig("target_id")),
				count = iter1_23:getConfig("target_num")
			}

			local function var4_23()
				table.insert(var0_23, iter1_23)
				arg2_23()
			end

			local function var5_23()
				arg2_23()
			end

			local var6_23 = {
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("sub_item_warning"),
				items = {
					var3_23
				},
				onYes = var4_23,
				onNo = var5_23
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var6_23)
			coroutine.yield()
		else
			table.insert(var0_23, iter1_23)
		end
	end

	return var0_23
end

function var0_0.filterChoiceTaskVOList(arg0_26, arg1_26, arg2_26)
	local var0_26 = {}
	local var1_26 = arg1_26

	for iter0_26, iter1_26 in ipairs(var1_26) do
		if iter1_26:isSelectable() then
			local var2_26 = iter1_26:getConfig("award_choice")
			local var3_26 = {}

			for iter2_26, iter3_26 in ipairs(var2_26) do
				var3_26[#var3_26 + 1] = {
					type = iter3_26[1],
					id = iter3_26[2],
					count = iter3_26[3],
					index = iter2_26
				}
			end

			local var4_26

			local function var5_26(arg0_27)
				var4_26 = arg0_27.index
			end

			local function var6_26()
				if not var4_26 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("no_item_selected_tip"))
				else
					local var0_28 = {}
					local var1_28 = var2_26[var4_26]

					for iter0_28, iter1_28 in ipairs(var1_28) do
						table.insert(var0_28, {
							type = iter1_28[1],
							id = iter1_28[2],
							number = iter1_28[3]
						})
					end

					iter1_26.choiceItemList = var0_28

					table.insert(var0_26, iter1_26)
					arg2_26()
				end
			end

			local function var7_26()
				arg2_26()
			end

			local var8_26 = {
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("select_award_warning"),
				items = var3_26,
				itemFunc = var5_26,
				onYes = var6_26,
				onNo = var7_26
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var8_26)
			coroutine.yield()
		else
			table.insert(var0_26, iter1_26)
		end
	end

	return var0_26
end

return var0_0
