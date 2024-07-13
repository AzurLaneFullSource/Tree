local var0_0 = class("SkinTemplatePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.dayTF = arg0_1:findTF("day", arg0_1.bg)
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)

	setActive(arg0_1.item, false)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.nday = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.activity:getConfig("config_data")

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.uilist:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateTask(arg1_4, arg2_4)
		end
	end)
end

function var0_0.UpdateTask(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5 + 1
	local var1_5 = arg0_5:findTF("item", arg2_5)
	local var2_5 = arg0_5.taskGroup[arg0_5.nday][var0_5]
	local var3_5 = arg0_5.taskProxy:getTaskById(var2_5) or arg0_5.taskProxy:getFinishTaskById(var2_5)

	assert(var3_5, "without this task by id: " .. var2_5)

	local var4_5 = Drop.Create(var3_5:getConfig("award_display")[1])

	updateDrop(var1_5, var4_5)
	onButton(arg0_5, var1_5, function()
		arg0_5:emit(BaseUI.ON_DROP, var4_5)
	end, SFX_PANEL)

	local var5_5 = var3_5:getProgress()
	local var6_5 = var3_5:getConfig("target_num")

	setText(arg0_5:findTF("description", arg2_5), var3_5:getConfig("desc"))

	local var7_5, var8_5 = arg0_5:GetProgressColor()
	local var9_5

	var9_5 = var7_5 and setColorStr(var5_5, var7_5) or var5_5

	local var10_5

	var10_5 = var8_5 and setColorStr("/" .. var6_5, var8_5) or "/" .. var6_5

	setText(arg0_5:findTF("progressText", arg2_5), var9_5 .. var10_5)
	setSlider(arg0_5:findTF("progress", arg2_5), 0, var6_5, var5_5)

	local var11_5 = arg0_5:findTF("go_btn", arg2_5)
	local var12_5 = arg0_5:findTF("get_btn", arg2_5)
	local var13_5 = arg0_5:findTF("got_btn", arg2_5)
	local var14_5 = var3_5:getTaskStatus()

	setActive(var11_5, var14_5 == 0)
	setActive(var12_5, var14_5 == 1)
	setActive(var13_5, var14_5 == 2)
	onButton(arg0_5, var11_5, function()
		arg0_5:emit(ActivityMediator.ON_TASK_GO, var3_5)
	end, SFX_PANEL)
	onButton(arg0_5, var12_5, function()
		local var0_8 = {}
		local var1_8 = var3_5:getConfig("award_display")
		local var2_8 = getProxy(PlayerProxy):getRawData()
		local var3_8 = pg.gameset.urpt_chapter_max.description[1]
		local var4_8 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_8)
		local var5_8, var6_8 = Task.StaticJudgeOverflow(var2_8.gold, var2_8.oil, var4_8, true, true, var1_8)

		if var5_8 then
			table.insert(var0_8, function(arg0_9)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_8,
					onYes = arg0_9
				})
			end)
		end

		seriesAsync(var0_8, function()
			arg0_5:emit(ActivityMediator.ON_TASK_SUBMIT, var3_5)
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_11)
	arg0_11.nday = arg0_11.activity.data3

	arg0_11:PlayStory()

	if arg0_11.dayTF then
		setText(arg0_11.dayTF, tostring(arg0_11.nday))
	end

	arg0_11.uilist:align(#arg0_11.taskGroup[arg0_11.nday])
end

function var0_0.PlayStory(arg0_12)
	local var0_12 = arg0_12.activity:getConfig("config_client").story

	if checkExist(var0_12, {
		arg0_12.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_12[arg0_12.nday][1])
	end
end

function var0_0.OnDestroy(arg0_13)
	eachChild(arg0_13.items, function(arg0_14)
		Destroy(arg0_14)
	end)
end

function var0_0.GetProgressColor(arg0_15)
	return nil
end

return var0_0
