local var0_0 = class("ConsumeGemSignInPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.rtLogin = arg0_1._tf:Find("AD/login")
	arg0_1.shopBtn = arg0_1._tf:Find("shop")
	arg0_1.getAllBtn = arg0_1._tf:Find("get_all")
	arg0_1.getAllBtnEnb = arg0_1._tf:Find("get_all/Text")
	arg0_1.helpBtn = arg0_1._tf:Find("help")
	arg0_1.uiTargetList = UIItemList.New(arg0_1._tf:Find("AD/targets"), arg0_1._tf:Find("AD/targets/task"))
	arg0_1.sliderTr = arg0_1._tf:Find("AD/slider/Image")
	arg0_1.ptTxt = arg0_1._tf:Find("AD/Text")

	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ConsumeGem_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.shopBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NEW_SHOP)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.getAllBtn, function()
		local var0_4 = arg0_1:CollectCanGetAwards()

		if #var0_4 <= 0 then
			return
		end

		local var1_4 = {}

		for iter0_4, iter1_4 in ipairs(var0_4) do
			table.insert(var1_4, function(arg0_5)
				arg0_1:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = arg0_1.consumeGemAct.id,
					arg1 = iter1_4,
					callback = arg0_5
				})
			end)
		end

		seriesAsync(var1_4)
	end, SFX_PANEL)

	arg0_1.itemWid = 118
end

function var0_0.CollectCanGetAwards(arg0_6)
	local var0_6 = {}
	local var1_6 = arg0_6.consumeGemAct.data1
	local var2_6 = arg0_6.consumeGemAct.data1_list

	for iter0_6, iter1_6 in ipairs(arg0_6.targets) do
		if iter1_6 <= var1_6 and not table.contains(var2_6, iter1_6) then
			table.insert(var0_6, iter1_6)
		end
	end

	return var0_6
end

function var0_0.OnDataSetting(arg0_7)
	arg0_7.nday = arg0_7.activity.data3
	arg0_7.taskProxy = getProxy(TaskProxy)
	arg0_7.taskGroup = arg0_7.activity:getConfig("config_data")

	local var0_7 = arg0_7.activity:getConfig("config_client").link_act

	arg0_7.consumeGemAct = getProxy(ActivityProxy):getActivityById(var0_7)
	arg0_7.targets = arg0_7.consumeGemAct:getDataConfig("target")
	arg0_7.drops = arg0_7.consumeGemAct:getDataConfig("drop_client")

	return updateActivityTaskStatus(arg0_7.activity)
end

function var0_0.OnFirstFlush(arg0_8)
	arg0_8:FlushSignInAct()
	arg0_8:FlushTargetPtAct()
	arg0_8:Hx4Channel()
end

function var0_0.FlushTargetPtAct(arg0_9)
	arg0_9.pt = arg0_9.consumeGemAct.data1
	arg0_9.gotList = arg0_9.consumeGemAct.data1_list

	setText(arg0_9.ptTxt, arg0_9.pt)

	local var0_9 = arg0_9:CollectCanGetAwards()

	setActive(arg0_9.getAllBtnEnb, #var0_9 > 0)

	local var1_9 = 0

	arg0_9.uiTargetList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_9.targets[arg1_10 + 1]
			local var1_10 = Drop.Create(arg0_9.drops[arg1_10 + 1])

			setText(arg2_10:Find("day/Text"), var0_10)

			local var2_10 = table.contains(arg0_9.gotList, var0_10)

			setActive(arg2_10:Find("task_1/got"), var2_10)

			local var3_10 = not var2_10 and var0_10 <= arg0_9.pt

			setActive(arg2_10:Find("get"), var3_10)
			setActive(arg2_10:Find("task_1/lock"), var0_10 > arg0_9.pt)
			setActive(arg2_10:Find("dot1/Image_1"), var3_10)

			if var2_10 then
				var1_9 = arg1_10 + 1
			end

			onButton(arg0_9, arg2_10:Find("get"), function()
				arg0_9:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = arg0_9.consumeGemAct.id,
					arg1 = var0_10
				})
			end, SFX_CONFIRM)
			updateDrop(arg2_10:Find("task_1/IconTpl"), var1_10)
			onButton(arg0_9, arg2_10, function()
				arg0_9:emit(BaseUI.ON_DROP, var1_10)
			end, SFX_PANEL)
		end
	end)
	arg0_9.uiTargetList:align(#arg0_9.targets)

	local var2_9 = arg0_9.itemWid * 0.5 + (var1_9 - 1) * arg0_9.itemWid

	arg0_9.sliderTr.sizeDelta = Vector2(var2_9, arg0_9.sliderTr.sizeDelta.y)
end

function var0_0.FlushSignInAct(arg0_13)
	local var0_13 = {
		"task",
		"task_1",
		"task_2"
	}

	for iter0_13, iter1_13 in ipairs(arg0_13.taskGroup) do
		local var1_13 = iter1_13[1]
		local var2_13 = arg0_13.taskProxy:getTaskVO(var1_13) or Task.New({
			id = var1_13
		})
		local var3_13 = arg0_13.rtLogin:Find(var0_13[iter0_13])

		setText(var3_13:Find("day/Text"), "DAY" .. iter0_13)

		local var4_13 = Drop.Create(var2_13:getConfig("award_display")[1])

		updateDrop(var3_13:Find("IconTpl"), var4_13)
		onButton(arg0_13, var3_13:Find("get"), function()
			arg0_13:emit(ActivityMediator.ON_TASK_SUBMIT, var2_13)
		end, SFX_CONFIRM)
		onButton(arg0_13, var3_13, function()
			arg0_13:emit(BaseUI.ON_DROP, var4_13)
		end, SFX_PANEL)
	end
end

function var0_0.OnUpdateFlush(arg0_16)
	arg0_16:UpdateSignInAct()
	arg0_16:UpdateTargetPtAct()
end

function var0_0.UpdateSignInAct(arg0_17)
	local var0_17 = false
	local var1_17 = {
		"task",
		"task_1",
		"task_2"
	}

	for iter0_17, iter1_17 in ipairs(arg0_17.taskGroup) do
		local var2_17 = iter1_17[1]
		local var3_17 = arg0_17.taskProxy:getTaskVO(var2_17) or Task.New({
			id = var2_17
		})
		local var4_17 = arg0_17.rtLogin:Find(var1_17[iter0_17])
		local var5_17 = var3_17:isReceive()

		setActive(var4_17:Find("got"), var5_17 or iter0_17 < arg0_17.nday)

		local var6_17 = not var0_17 and not var5_17 and iter0_17 == arg0_17.nday

		setActive(var4_17:Find("get"), var6_17)

		var0_17 = var0_17 or var6_17
	end
end

function var0_0.UpdateTargetPtAct(arg0_18)
	arg0_18:FlushTargetPtAct()
end

local function var1_0(arg0_19)
	local var0_19 = pg.SdkMgr.GetInstance():GetChannelUIDIncludeHarmony()

	return (arg0_19._tf:Find("AD/rw_mask/rw_1/hx_ch" .. var0_19))
end

function var0_0.Hx4Channel(arg0_20)
	local var0_20 = var1_0(arg0_20)

	if not IsNil(var0_20) then
		setActive(var0_20, HXSet.isHx())
	end
end

return var0_0
