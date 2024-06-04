local var0 = class("TaskCommonPage", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "TaskListPage"
end

function var0.OnLoaded(arg0)
	arg0._scrllPanel = arg0:findTF("right_panel")
	arg0._scrollView = arg0._scrllPanel:GetComponent("LScrollRect")
end

function var0.OnInit(arg0)
	arg0.taskCards = {}

	function arg0._scrollView.onInitItem(arg0)
		arg0:onInitTask(arg0)
	end

	function arg0._scrollView.onUpdateItem(arg0, arg1)
		arg0:onUpdateTask(arg0, arg1)
	end
end

function var0.onInitTask(arg0, arg1)
	local var0 = TaskCard.New(arg1, arg0.contextData.viewComponent)

	arg0.taskCards[arg1] = var0
end

function var0.onUpdateTask(arg0, arg1, arg2)
	local var0 = arg0.taskCards[arg2]

	if not var0 then
		arg0:onInitTask(arg2)

		var0 = arg0.taskCards[arg2]
	end

	local var1 = arg0.taskVOs[arg1 + 1]

	var0:update(var1)
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0:Show()

	arg0.taskVOs = {}

	local var0 = arg0.contextData.taskVOsById

	for iter0, iter1 in pairs(var0) do
		if iter1:ShowOnTaskScene() and arg2[iter1:GetRealType()] then
			table.insert(arg0.taskVOs, iter1)
		end
	end

	if (arg1 == TaskScene.PAGE_TYPE_ALL or arg1 == TaskScene.PAGE_TYPE_ROUTINE) and TaskScene.IsPassScenario() and TaskScene.IsNewStyleTime() then
		local var1 = pg.gameset.daily_task_new.description
		local var2 = getProxy(TaskProxy)

		for iter2, iter3 in ipairs(var1) do
			if not (var2:getTaskById(iter3) or var2:getFinishTaskById(iter3)) then
				table.insert(arg0.taskVOs, Task.New({
					progress = 0,
					id = iter3
				}))
			end
		end
	end

	if arg1 == TaskScene.PAGE_TYPE_ALL or arg1 == TaskScene.PAGE_TYPE_ACT then
		local var3 = getProxy(AvatarFrameProxy):getAllAvatarFrame()

		for iter4, iter5 in ipairs(var3) do
			local var4 = iter5.tasks

			for iter6, iter7 in ipairs(var4) do
				table.insert(arg0.taskVOs, iter7)
			end
		end
	end

	arg0:Sort()
	arg0._scrollView:SetTotalCount(#arg0.taskVOs, -1)

	local var5 = arg0:GetSliderValue()

	if var5 > 0 then
		arg0._scrollView:ScrollTo(var5)
	end

	if arg3 then
		arg3(arg0.taskVOs)
	end
end

function var0.GetSliderValue(arg0)
	local var0 = -1

	if arg0.contextData.targetId then
		local var1

		for iter0, iter1 in ipairs(arg0.taskVOs) do
			if iter1.id == arg0.contextData.targetId then
				var1 = iter0 - 1

				break
			end
		end

		if var1 then
			var0 = arg0._scrollView:HeadIndexToValue(var1)
		end
	end

	return var0
end

function var0.Sort(arg0)
	local function var0(arg0, arg1, arg2)
		local function var0(arg0)
			for iter0, iter1 in ipairs(arg2) do
				if arg0 == iter1 then
					return iter0
				end
			end
		end

		return var0(arg0) < var0(arg1)
	end

	local function var1(arg0)
		return arg0:IsUrTask() and 1 or 0
	end

	local function var2(arg0)
		return arg0.configId or 0
	end

	local function var3(arg0, arg1)
		if arg0:GetRealType() == arg1:GetRealType() then
			if arg0:isAvatarTask() and arg1:isAvatarTask() then
				local var0 = var2(arg0)
				local var1 = var2(arg1)

				if var0 == var1 then
					return arg0.id < arg1.id
				else
					return var1 < var0
				end
			else
				return arg0.id < arg1.id
			end
		elseif arg0:getTaskStatus() == 0 then
			return var0(arg0:GetRealType(), arg1:GetRealType(), {
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
		elseif arg0:getTaskStatus() == 1 then
			return var0(arg0:GetRealType(), arg1:GetRealType(), {
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

	table.sort(arg0.taskVOs, function(arg0, arg1)
		if arg0:getTaskStatus() == arg1:getTaskStatus() then
			local var0 = arg0.id == 10302 and 1 or 0
			local var1 = arg1.id == 10302 and 1 or 0

			if var0 == var1 then
				local var2 = var1(arg0)
				local var3 = var1(arg1)

				if var2 == var3 then
					return var3(arg0, arg1)
				else
					return var3 < var2
				end
			else
				return var1 < var0
			end
		else
			return var0(arg0:getTaskStatus(), arg1:getTaskStatus(), {
				1,
				0,
				2,
				-1
			})
		end
	end)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.taskCards) do
		iter1:dispose()
	end
end

function var0.GetWaitToCheckList(arg0)
	local var0 = arg0.taskVOs or {}
	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		if iter1:getTaskStatus() == 1 and iter1:ShowOnTaskScene() then
			table.insert(var1, iter1)
		end
	end

	return var1
end

function var0.ExecuteOneStepSubmit(arg0)
	local var0 = arg0:GetWaitToCheckList()
	local var1
	local var2 = false
	local var3

	local function var4()
		var1, var2 = arg0:filterOverflowTaskVOList(var0)
		var1 = arg0:filterSubmitTaskVOList(var1, var3)
		var1 = arg0:filterChoiceTaskVOList(var1, var3)

		local var0 = {}

		for iter0 = #var1, 1, -1 do
			local var1 = var1[iter0]

			if var1:isAvatarTask() then
				if not var0[var1.actId] then
					var0[var1.actId] = {}
				end

				table.insert(var0[var1.actId], var1.id)
				table.remove(var1, iter0)
			end
		end

		for iter1, iter2 in pairs(var0) do
			if #iter2 > 0 then
				pg.m02:sendNotification(GAME.AVATAR_FRAME_AWARD, {
					act_id = iter1,
					task_ids = iter2,
					callback = function()
						var3()
					end
				})
				coroutine.yield()
			end
		end

		if #var1 > 0 then
			pg.m02:sendNotification(GAME.MERGE_TASK_ONE_STEP_AWARD, {
				resultList = var1
			})
		end
	end

	var3 = coroutine.wrap(var4)

	var3()

	if var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("award_overflow_tip"))

		var2 = false
	end
end

function var0.filterOverflowTaskVOList(arg0, arg1)
	local var0 = {}
	local var1 = getProxy(PlayerProxy):getData()
	local var2 = pg.gameset.urpt_chapter_max.description[1]
	local var3 = var1.gold
	local var4 = var1.oil
	local var5 = not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var2) or 0
	local var6 = pg.gameset.max_gold.key_value
	local var7 = pg.gameset.max_oil.key_value

	if LOCK_UR_SHIP or not pg.gameset.urpt_chapter_max.description[2] then
		local var8 = 0
	end

	local var9 = false

	for iter0, iter1 in pairs(arg1) do
		local var10 = iter1:judgeOverflow(var3, var4, var5)

		if not var10 then
			table.insert(var0, iter1)
		end

		if var10 then
			var9 = true
		end
	end

	return var0, var9
end

function var0.filterSubmitTaskVOList(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg1

	for iter0, iter1 in ipairs(var1) do
		if iter1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM or iter1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM or iter1:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
			local var2 = DROP_TYPE_ITEM

			if iter1:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
				var2 = DROP_TYPE_RESOURCE
			end

			local var3 = {
				type = var2,
				id = tonumber(iter1:getConfig("target_id")),
				count = iter1:getConfig("target_num")
			}

			local function var4()
				table.insert(var0, iter1)
				arg2()
			end

			local function var5()
				arg2()
			end

			local var6 = {
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("sub_item_warning"),
				items = {
					var3
				},
				onYes = var4,
				onNo = var5
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var6)
			coroutine.yield()
		else
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.filterChoiceTaskVOList(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg1

	for iter0, iter1 in ipairs(var1) do
		if iter1:isSelectable() then
			local var2 = iter1:getConfig("award_choice")
			local var3 = {}

			for iter2, iter3 in ipairs(var2) do
				var3[#var3 + 1] = {
					type = iter3[1],
					id = iter3[2],
					count = iter3[3],
					index = iter2
				}
			end

			local var4

			local function var5(arg0)
				var4 = arg0.index
			end

			local function var6()
				if not var4 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("no_item_selected_tip"))
				else
					local var0 = {}
					local var1 = var2[var4]

					for iter0, iter1 in ipairs(var1) do
						table.insert(var0, {
							type = iter1[1],
							id = iter1[2],
							number = iter1[3]
						})
					end

					iter1.choiceItemList = var0

					table.insert(var0, iter1)
					arg2()
				end
			end

			local function var7()
				arg2()
			end

			local var8 = {
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("select_award_warning"),
				items = var3,
				itemFunc = var5,
				onYes = var6,
				onNo = var7
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var8)
			coroutine.yield()
		else
			table.insert(var0, iter1)
		end
	end

	return var0
end

return var0
