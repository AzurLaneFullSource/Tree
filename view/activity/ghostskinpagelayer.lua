local var0_0 = class("GhostSkinPageLayer", import("view.base.BaseUI"))
local var1_0

function var0_0.getUIName(arg0_1)
	return "GhostSkinPageUI"
end

function var0_0.init(arg0_2)
	var1_0 = ActivityConst.GOASTSTORYACTIVITY_ID
	arg0_2.activity = getProxy(ActivityProxy):getActivityById(var1_0)
	arg0_2.story = arg0_2.activity:getConfig("config_client").story
	arg0_2.storyStateDic = {}
	arg0_2.item = arg0_2:findTF("task/item", arg0_2.bg)
	arg0_2.items = arg0_2:findTF("task/items", arg0_2.bg)
	arg0_2.uilist = UIItemList.New(arg0_2.items, arg0_2.item)

	setActive(arg0_2.item, false)
	onButton(arg0_2, arg0_2._tf:Find("des/itemDes"), function()
		local var0_3 = getProxy(ActivityProxy):getActivityById(var1_0).data1
		local var1_3 = {
			type = DROP_TYPE_VITEM,
			id = arg0_2.activity:getConfig("config_id"),
			count = var0_3
		}

		arg0_2:emit(BaseUI.ON_DROP, var1_3)
	end)
	arg0_2.uilist:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_2:UpdateTask(arg1_4, arg2_4)
		end
	end)

	arg0_2.taskProxy = getProxy(TaskProxy)

	arg0_2:OnUpdateFlush()
	arg0_2:UpdateItemView(arg0_2.activity)
	arg0_2:ShowMask(false)

	arg0_2.isPlaying = false

	arg0_2:InitStoryState()
	arg0_2:UpdateStoryView()
	arg0_2:DisplayBigTask()
	setText(arg0_2:findTF("task/taskAll/taskallReward/hasRewardText"), i18n("activity_1024_memory_get"))
end

function var0_0.OnUpdateFlush(arg0_5)
	arg0_5:UpdataTaskData()
	arg0_5.uilist:align(#arg0_5.taskGroup)
end

function var0_0.UpdataTaskData(arg0_6)
	arg0_6.taskGroup = {}

	local var0_6 = arg0_6.activity:getConfig("config_client")
	local var1_6 = #var0_6.group_1

	arg0_6.allCompleteCount = 0

	for iter0_6, iter1_6 in ipairs(var0_6.group_1) do
		local var2_6 = (arg0_6.taskProxy:getTaskById(iter1_6) or arg0_6.taskProxy:getFinishTaskById(iter1_6)):getTaskStatus()

		if var2_6 == 0 or var2_6 == 1 or iter0_6 == var1_6 then
			table.insert(arg0_6.taskGroup, iter1_6)

			local var3_6

			if iter0_6 == var1_6 and var2_6 == 2 then
				var3_6 = iter0_6
			else
				var3_6 = iter0_6 - 1
			end

			arg0_6.allCompleteCount = arg0_6.allCompleteCount + var3_6

			break
		end
	end

	local var4_6 = #var0_6.group_2

	for iter2_6, iter3_6 in ipairs(var0_6.group_2) do
		local var5_6 = (arg0_6.taskProxy:getTaskById(iter3_6) or arg0_6.taskProxy:getFinishTaskById(iter3_6)):getTaskStatus()

		if var5_6 == 0 or var5_6 == 1 or iter2_6 == var4_6 then
			table.insert(arg0_6.taskGroup, iter3_6)

			local var6_6

			if iter2_6 == var4_6 and var5_6 == 2 then
				var6_6 = iter2_6
			else
				var6_6 = iter2_6 - 1
			end

			arg0_6.allCompleteCount = arg0_6.allCompleteCount + var6_6

			break
		end
	end
end

function var0_0.UpdateTask(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7 + 1
	local var1_7 = arg0_7:findTF("item", arg2_7)
	local var2_7 = arg0_7.taskGroup[var0_7]
	local var3_7 = arg0_7.taskProxy:getTaskById(var2_7) or arg0_7.taskProxy:getFinishTaskById(var2_7)

	assert(var3_7, "without this task by id: " .. var2_7)

	local var4_7 = Drop.Create(var3_7:getConfig("award_display")[1])

	updateDrop(var1_7, var4_7)
	onButton(arg0_7, var1_7, function()
		arg0_7:emit(BaseUI.ON_DROP, var4_7)
	end, SFX_PANEL)

	local var5_7 = var3_7:getProgress()
	local var6_7 = var3_7:getConfig("target_num")

	if arg0_7.allCompleteCount == 8 then
		var5_7 = var6_7
	end

	local var7_7, var8_7 = arg0_7:GetProgressColor()
	local var9_7

	var9_7 = var7_7 and setColorStr(var5_7, var7_7) or var5_7

	local var10_7

	var10_7 = var8_7 and setColorStr("/" .. var6_7, var8_7) or "/" .. var6_7

	setActive(arg0_7:findTF("progressText", arg2_7), false)

	local var11_7 = var3_7:getConfig("desc") .. " (" .. var9_7 .. var10_7 .. ")"

	setText(arg0_7:findTF("description", arg2_7), var11_7)
	setSlider(arg0_7:findTF("progress", arg2_7), 0, var6_7, var5_7)

	local var12_7 = arg0_7:findTF("go_btn", arg2_7)
	local var13_7 = arg0_7:findTF("get_btn", arg2_7)
	local var14_7 = arg0_7:findTF("got_btn", arg2_7)
	local var15_7 = var3_7:getTaskStatus()

	if arg0_7.allCompleteCount == 8 then
		var15_7 = 2
	end

	setActive(var12_7, var15_7 == 0)
	setActive(var13_7, var15_7 == 1)
	setActive(var14_7, var15_7 == 2)
	onButton(arg0_7, var12_7, function()
		arg0_7:emit(ActivityMediator.ON_TASK_GO, var3_7)
	end, SFX_PANEL)
	onButton(arg0_7, var13_7, function()
		local var0_10 = {}
		local var1_10 = var3_7:getConfig("award_display")
		local var2_10 = getProxy(PlayerProxy):getRawData()
		local var3_10 = pg.gameset.urpt_chapter_max.description[1]
		local var4_10 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_10)
		local var5_10, var6_10 = Task.StaticJudgeOverflow(var2_10.gold, var2_10.oil, var4_10, true, true, var1_10)

		if var5_10 then
			table.insert(var0_10, function(arg0_11)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_10,
					onYes = arg0_11
				})
			end)
		end

		seriesAsync(var0_10, function()
			arg0_7:emit(GhostSkinMediator.ON_TASK_SUBMIT, var3_7)
		end)
	end, SFX_PANEL)

	local var16_7 = arg0_7.allCompleteCount < 8 and var15_7 == 1
	local var17_7 = arg0_7:findTF("reddot", arg2_7)

	setActive(var17_7, var16_7)
end

function var0_0.DisplayBigTask(arg0_13)
	local var0_13 = arg0_13.activity:getConfig("config_client").group_3[1]
	local var1_13 = arg0_13.taskProxy:getTaskById(var0_13) or arg0_13.taskProxy:getFinishTaskById(var0_13)

	assert(var1_13, "without this task by id: " .. var0_13)

	local var2_13 = arg0_13:findTF("task/allTaskItem")
	local var3_13 = Drop.Create(var1_13:getConfig("award_display")[1])

	updateDrop(var2_13, var3_13)
	onButton(arg0_13, var2_13, function()
		arg0_13:emit(BaseUI.ON_DROP, var3_13)
	end, SFX_PANEL)

	local var4_13 = var1_13:getTaskStatus()

	setActive(arg0_13:findTF("task/taskAll/taskallReward"), var4_13 == 2)
end

function var0_0.GetProgressColor(arg0_15)
	return nil
end

function var0_0.InitStoryState(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.story) do
		if checkExist(arg0_16.story, {
			iter0_16
		}, {
			1
		}) then
			local var0_16 = false
			local var1_16 = iter1_16[1]

			if pg.NewStoryMgr.GetInstance():IsPlayed(var1_16) then
				var0_16 = true
			end

			local var2_16 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var1_16)

			arg0_16.storyStateDic[var2_16] = var0_16
		end
	end
end

function var0_0.UpdateStoryView(arg0_17)
	local var0_17 = {
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8"
	}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		local var1_17 = arg0_17.story[iter0_17][1]
		local var2_17 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var1_17)
		local var3_17 = arg0_17.storyStateDic[var2_17]
		local var4_17 = arg0_17._tf:Find("frame/" .. iter1_17 .. "/locked")
		local var5_17 = arg0_17._tf:Find("frame/" .. iter1_17)

		setActive(var4_17, not var3_17)

		if var3_17 then
			onButton(arg0_17, var5_17, function()
				pg.NewStoryMgr.GetInstance():Play(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var2_17), nil, true)
			end)
		else
			onButton(arg0_17, var4_17, function()
				if getProxy(ActivityProxy):getActivityById(var1_0).data1 <= 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("activity_1024_memory"))

					return
				end

				pg.m02:sendNotification(GAME.ACTIVITY_UNLOCKSTORYT, {
					cmd = 1,
					activity_id = arg0_17.activity.id,
					arg1 = var2_17
				})
			end)
		end
	end
end

function var0_0.UpdateItemView(arg0_20, arg1_20)
	setText(arg0_20._tf:Find("des/count"), tostring(arg1_20.data1))
end

function var0_0.UpdataStoryState(arg0_21, arg1_21)
	local var0_21 = arg1_21.storyId

	arg0_21.storyStateDic[var0_21] = true

	local var1_21 = 0

	for iter0_21, iter1_21 in ipairs(arg0_21.story) do
		local var2_21 = iter1_21[1]

		if pg.NewStoryMgr.GetInstance():StoryName2StoryId(var2_21) == var0_21 then
			var1_21 = iter0_21
		end
	end

	local var3_21 = {
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8"
	}

	for iter2_21, iter3_21 in ipairs(var3_21) do
		if iter2_21 == var1_21 then
			local var4_21 = arg0_21.storyStateDic[var0_21]
			local var5_21 = arg0_21._tf:Find("frame/" .. iter3_21 .. "/locked")
			local var6_21 = arg0_21._tf:Find("frame/" .. iter3_21)
			local var7_21 = var5_21:GetComponent(typeof(Animation))
			local var8_21 = var7_21:GetClip("anim_GhostSkin_unlock_1").length

			var7_21:Play("anim_GhostSkin_unlock_1")
			arg0_21:ShowMask(true)

			arg0_21.isPlaying = true

			onDelayTick(function()
				arg0_21.isPlaying = false

				setActive(var5_21, not var4_21)
				arg0_21:ShowMask(false)
				pg.NewStoryMgr.GetInstance():Play(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var0_21), function()
					arg0_21:ShouldRewardAll(false)
				end)
			end, var8_21)
			onButton(arg0_21, var6_21, function()
				pg.NewStoryMgr.GetInstance():Play(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var0_21), nil, true)
			end)
		end
	end
end

function var0_0.ShouldRewardAll(arg0_25, arg1_25)
	local function var0_25()
		for iter0_26, iter1_26 in pairs(arg0_25.storyStateDic) do
			if iter1_26 == false then
				return false
			end
		end

		return true
	end

	local function var1_25()
		if not arg1_25 then
			return true
		end

		local var0_27 = arg0_25.activity:getConfig("config_client").group_3[1]
		local var1_27 = arg0_25.taskProxy:getTaskById(var0_27) or arg0_25.taskProxy:getFinishTaskById(var0_27)

		assert(var1_27, "without this task by id: " .. var0_27)

		if var1_27:getTaskStatus() == 1 then
			return true
		end

		return false
	end

	if var0_25() and var1_25() then
		local var2_25 = {}
		local var3_25 = arg0_25.activity:getConfig("config_client").group_3[1]
		local var4_25 = arg0_25.taskProxy:getTaskById(var3_25) or arg0_25.taskProxy:getFinishTaskById(var3_25)
		local var5_25 = var4_25:getConfig("award_display")
		local var6_25 = getProxy(PlayerProxy):getRawData()
		local var7_25 = pg.gameset.urpt_chapter_max.description[1]
		local var8_25 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var7_25)
		local var9_25, var10_25 = Task.StaticJudgeOverflow(var6_25.gold, var6_25.oil, var8_25, true, true, var5_25)

		if var9_25 then
			table.insert(var2_25, function(arg0_28)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var10_25,
					onYes = arg0_28
				})
			end)
		end

		seriesAsync(var2_25, function()
			arg0_25:emit(GhostSkinMediator.ON_TASK_SUBMIT, var4_25)
		end)
	end
end

function var0_0.didEnter(arg0_30)
	onButton(arg0_30, arg0_30._tf:Find("title/back"), function()
		arg0_30:onBackPressed()
	end, SFX_PANEL)
	arg0_30:ShouldRewardAll(true)
end

function var0_0.ShowMask(arg0_32, arg1_32)
	local var0_32 = arg0_32._tf:Find("mask")

	GetOrAddComponent(var0_32, typeof(CanvasGroup)).blocksRaycasts = arg1_32
end

function var0_0.onBackPressed(arg0_33)
	if arg0_33.isPlaying then
		return
	end

	arg0_33.super.onBackPressed(arg0_33)
end

function var0_0.IsShowRed()
	local var0_34 = getProxy(TaskProxy)
	local var1_34 = getProxy(ActivityProxy):getActivityById(ActivityConst.GOASTSTORYACTIVITY_ID):getConfig("config_client")
	local var2_34 = 0
	local var3_34 = false

	for iter0_34, iter1_34 in ipairs(var1_34.group_1) do
		local var4_34 = var0_34:getTaskById(iter1_34) or var0_34:getFinishTaskById(iter1_34)

		if var4_34 then
			local var5_34 = var4_34:getTaskStatus()

			if var5_34 == 2 then
				var2_34 = var2_34 + 1
			elseif var5_34 == 1 then
				var3_34 = true
			end
		end
	end

	for iter2_34, iter3_34 in ipairs(var1_34.group_2) do
		local var6_34 = var0_34:getTaskById(iter3_34) or var0_34:getFinishTaskById(iter3_34)

		if var6_34 then
			local var7_34 = var6_34:getTaskStatus()

			if var7_34 == 2 then
				var2_34 = var2_34 + 1
			elseif var7_34 == 1 then
				var3_34 = true
			end
		end
	end

	return var2_34 < 8 and var3_34
end

return var0_0
