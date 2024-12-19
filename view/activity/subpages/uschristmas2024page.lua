local var0_0 = class("USChristmas2024Page", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.item = arg0_1:findTF("item", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.bg)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.awardNum = arg0_1:findTF("awardNum", arg0_1.bg)
	arg0_1.linkBtn = arg0_1:findTF("linkBtn", arg0_1.bg)

	setActive(arg0_1.item, false)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.nday = 0
	arg0_2.activityTaskProxy = getProxy(ActivityTaskProxy)
	arg0_2.taskGroup = arg0_2.activity:getConfig("config_data")
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
	local var3_5
	local var4_5 = arg0_5.activityTaskProxy:getTaskById(arg0_5.activity.id)
	local var5_5 = arg0_5.activityTaskProxy:getFinishTaskById(arg0_5.activity.id)
	local var6_5 = false

	for iter0_5, iter1_5 in ipairs(var4_5) do
		if iter1_5.id == var2_5 then
			var3_5 = iter1_5

			break
		end
	end

	if not var3_5 then
		for iter2_5, iter3_5 in ipairs(var5_5) do
			if iter3_5.id == var2_5 then
				var3_5 = iter3_5
				var6_5 = true

				break
			end
		end
	end

	assert(var3_5, "without this task by id: " .. var2_5)

	local var7_5 = Drop.Create(var3_5:getConfig("award_display")[1])

	updateDrop(var1_5, var7_5)
	onButton(arg0_5, var1_5, function()
		arg0_5:emit(BaseUI.ON_DROP, var7_5)
	end, SFX_PANEL)

	local var8_5 = var3_5:getProgress()
	local var9_5 = var3_5:getConfig("target_num")

	setText(arg0_5:findTF("description", arg2_5), var3_5:getConfig("desc"))

	local var10_5, var11_5 = arg0_5:GetProgressColor()
	local var12_5

	var12_5 = var10_5 and setColorStr(var8_5, var10_5) or var8_5

	local var13_5

	var13_5 = var11_5 and setColorStr("/" .. var9_5, var11_5) or "/" .. var9_5

	setText(arg0_5:findTF("progressText", arg2_5), var12_5 .. var13_5)
	setSlider(arg0_5:findTF("progress", arg2_5), 0, var9_5, var8_5)

	local var14_5 = arg0_5:findTF("go_btn", arg2_5)
	local var15_5 = arg0_5:findTF("get_btn", arg2_5)
	local var16_5 = arg0_5:findTF("got_btn", arg2_5)
	local var17_5 = var3_5:getTaskStatus()

	setActive(var14_5, not var6_5 and var17_5 == 0)
	setActive(var15_5, not var6_5 and var17_5 == 1)
	setActive(var16_5, var6_5)
	onButton(arg0_5, var14_5, function()
		arg0_5:emit(ActivityMediator.ON_TASK_GO, var3_5)
	end, SFX_PANEL)
	onButton(arg0_5, var15_5, function()
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
			arg0_5:emit(ActivityMediator.ON_ACTIVITY_TASK_SUBMIT, {
				activityId = arg0_5.activity.id,
				id = var2_5
			})
		end)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_11)
	arg0_11.nday = arg0_11.activity:GetCurrentDay()

	local var0_11 = 0
	local var1_11 = arg0_11.activity:getConfig("config_client").link_act_id
	local var2_11 = getProxy(ActivityProxy):getActivityById(var1_11)

	if var2_11 then
		var0_11 = var2_11.data1
	end

	setText(arg0_11.awardNum, var0_11)
	onButton(arg0_11, arg0_11.linkBtn, function()
		Application.OpenURL(arg0_11.activity:getConfig("config_client").url)
	end, SFX_PANEL)
	arg0_11.uilist:align(#arg0_11.taskGroup[arg0_11.nday])
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
