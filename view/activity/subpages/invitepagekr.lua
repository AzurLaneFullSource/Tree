local var0_0 = class("InvitePageKR", import(".TemplatePage.LoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("AD")
	arg0_1.btnGroup = arg0_1.AD:Find("btn_list")
	arg0_1.btnClick = arg0_1.btnGroup:Find("click")
	arg0_1.btnGet = arg0_1.btnGroup:Find("get")
	arg0_1.btnGot = arg0_1.btnGroup:Find("got")
	arg0_1.redpoint = arg0_1.btnGroup:Find("red")
	arg0_1.showList = arg0_1.AD:Find("show_list")
	arg0_1.progress = arg0_1.showList:Find("progress")
	arg0_1.tabCount = tf(arg0_1.progress).childCount
	arg0_1.tabsList = {}

	table.insert(arg0_1.tabsList, arg0_1.progress:Find("item"))

	for iter0_1 = 1, 6 do
		table.insert(arg0_1.tabsList, arg0_1.progress:Find("item_" .. iter0_1))
	end

	arg0_1.award = arg0_1.showList:Find("award")
	arg0_1.gotAward = arg0_1.award:Find("got")
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.nday = arg0_2.activity.data1

	arg0_2:RefreshTab()
	warning("First是第几次签到" .. arg0_2.nday)
	onButton(arg0_2, arg0_2.btnClick, function()
		if arg0_2.activity:readyToAchieve() == false then
			return
		end

		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_2.activity.id
		})
	end, SFX_CONFIRM)
	onButton(arg0_2, arg0_2.btnGet, function()
		if arg0_2.activity:readyToAchieve() == false then
			return
		end

		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_2.activity.id
		})
	end, SFX_CONFIRM)
end

function var0_0.OnUpdateFlush(arg0_5)
	arg0_5.nday = arg0_5.activity.data1

	warning("update是第几次签到" .. arg0_5.nday)
	arg0_5:RefreshTab()

	local var0_5 = arg0_5.activity:readyToAchieve()

	setActive(arg0_5.redpoint, var0_5)
	setActive(arg0_5.btnClick, arg0_5.nday <= arg0_5.tabCount - 1)
	setGray(arg0_5.btnClick, not var0_5 and not finsh)
	setActive(arg0_5.btnGot, arg0_5.nday >= arg0_5.tabCount)
	setActive(arg0_5.gotAward, arg0_5.nday >= arg0_5.tabCount)
	arg0_5:lastDayShow(var0_5)
end

function var0_0.OnDestroy(arg0_6)
	return
end

function var0_0.lastDayShow(arg0_7, arg1_7)
	if arg0_7.nday == 6 and arg1_7 then
		setActive(arg0_7.tabsList[7], true)
		setActive(arg0_7.btnGet, true)

		return
	end

	setActive(arg0_7.btnGet, false)
end

function var0_0.RefreshTab(arg0_8)
	for iter0_8 = 1, arg0_8.tabCount do
		setActive(arg0_8.tabsList[iter0_8], iter0_8 <= arg0_8.nday)
	end
end

return var0_0
