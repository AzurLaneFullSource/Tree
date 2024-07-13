local var0_0 = class("KindergartenScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "KindergartenUI"
end

function var0_0.init(arg0_2)
	arg0_2.mainAnim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.topUI = arg0_2:findTF("ui/top")

	local var0_2 = arg0_2:findTF("title/title_kinder", arg0_2.topUI)

	var0_2:GetComponent(typeof(Image)):SetNativeSize()

	arg0_2:findTF("FX/textmask", var0_2).localScale = {
		x = var0_2.rect.width,
		y = var0_2.rect.height
	}
	arg0_2.bottomUI = arg0_2:findTF("ui/bottom")
	arg0_2.paradiseBtn = arg0_2:findTF("paradise", arg0_2.bottomUI)
	arg0_2.paradiseValue = arg0_2:findTF("value/Text", arg0_2.paradiseBtn)
	arg0_2.adventureBtn = arg0_2:findTF("adventure", arg0_2.bottomUI)
	arg0_2.rightUI = arg0_2:findTF("ui/right")
	arg0_2.ptBtn = arg0_2:findTF("pt", arg0_2.rightUI)
	arg0_2.ptValue = arg0_2:findTF("value/Text", arg0_2.ptBtn)
	arg0_2.ptTip = arg0_2:findTF("tip", arg0_2.ptBtn)
	arg0_2.rankBtn = arg0_2:findTF("rank", arg0_2.rightUI)
	arg0_2.taskBtn = arg0_2:findTF("task", arg0_2.rightUI)
	arg0_2.taskTip = arg0_2:findTF("tip", arg0_2.taskBtn)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3:findTF("back", arg0_3.topUI), function()
		arg0_3:onBackPressed()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("home", arg0_3.topUI), function()
		arg0_3:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3:findTF("help", arg0_3.topUI), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip["202406_main_help"].tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.paradiseBtn, function()
		arg0_3:emit(KindergartenMediator.GO_SUBLAYER, Context.New({
			mediator = TongXinSpringMediator,
			viewComponent = TongXinSpringLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.adventureBtn, function()
		arg0_3:emit(KindergartenMediator.GO_SCENE, SCENE.BOSSRUSH_MAIN)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.ptBtn, function()
		arg0_3:emit(KindergartenMediator.GO_SUBLAYER, Context.New({
			mediator = ChildishnessSchoolPtMediator,
			viewComponent = ChildishnessSchoolPtPage
		}))
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.rankBtn, function()
		arg0_3:emit(KindergartenMediator.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.taskBtn, function()
		arg0_3:emit(KindergartenMediator.GO_SUBLAYER, Context.New({
			mediator = ChildishnessSchoolTaskMediator,
			viewComponent = ChildishnessSchoolTaskPage
		}))
	end, SFX_PANEL)

	local var0_3 = arg0_3.contextData.isBack and "anim_kinder_main_show" or "anim_kinder_main_in"

	arg0_3.mainAnim:Play(var0_3)
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_12)
	arg0_12:UpdatePt()
	arg0_12:UpdateTask()
end

function var0_0.UpdatePt(arg0_13)
	local var0_13 = getProxy(ActivityProxy):getActivityById(ActivityConst.ALVIT_PT_ACT_ID)

	if var0_13 and not var0_13:isEnd() then
		setActive(arg0_13.ptBtn, true)
		setActive(arg0_13.ptTip, var0_0.ShowPtTip(var0_13))
		setText(arg0_13.ptValue, var0_13.data1)
	else
		setActive(arg0_13.ptBtn, false)
	end
end

function var0_0.UpdateTask(arg0_14)
	local var0_14 = getProxy(ActivityProxy):getActivityById(ActivityConst.ALVIT_TASK_ACT_ID)

	if var0_14 and not var0_14:isEnd() then
		setActive(arg0_14.taskBtn, true)
		setActive(arg0_14.taskTip, var0_0.ShowTaskTip(var0_14))
	else
		setActive(arg0_14.taskBtn, false)
	end
end

function var0_0.UpdateParadise(arg0_15)
	local var0_15 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	if var0_15 and not var0_15:isEnd() then
		setActive(arg0_15.paradiseBtn, true)

		local var1_15 = #var0_15:GetAvaliableShipIds()
		local var2_15 = var0_15:GetTotalSlotCount()

		setText(arg0_15.paradiseValue, string.format("(%d/%d)", var1_15, var2_15))
	else
		setActive(arg0_15.paradiseBtn, false)
	end
end

function var0_0.onBackPressed(arg0_16)
	arg0_16:quickExitFunc()
end

function var0_0.ShowPtTip(arg0_17)
	local var0_17 = arg0_17 or getProxy(ActivityProxy):getActivityById(ActivityConst.ALVIT_PT_ACT_ID)

	return Activity.IsActivityReady(var0_17)
end

function var0_0.ShowTaskTip(arg0_18)
	local var0_18 = arg0_18 or getProxy(ActivityProxy):getActivityById(ActivityConst.ALVIT_TASK_ACT_ID)

	return Activity.IsActivityReady(var0_18)
end

function var0_0.IsShowMainTip()
	return var0_0.ShowPtTip() or var0_0.ShowTaskTip()
end

return var0_0
