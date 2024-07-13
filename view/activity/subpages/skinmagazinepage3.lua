local var0_0 = class("SkinMagazinePage3", import("...base.BaseActivityPage"))

var0_0.EXPAND_WIDTH = 839
var0_0.CLOSE_WIDTH = 146
var0_0.DURATION_PARAMETER = 1500
var0_0.TIP_KEY = "SkinMagazinePage2_tip"

function var0_0.OnInit(arg0_1)
	arg0_1.items = arg0_1._tf:Find("AD/items")
	arg0_1.countTf = arg0_1._tf:Find("AD/task/count")
	arg0_1.awardTf = arg0_1._tf:Find("AD/task/IconTpl")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskList = arg0_2.activity:getConfig("config_data")
	arg0_2.totalCnt = #arg0_2.taskList
end

function var0_0.RefreshData(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance()

	arg0_3.unlockCnt = (var0_3:DiffDay(arg0_3.activity:getStartTime(), var0_3:GetServerTime()) + 1) * arg0_3.activity:getConfig("config_id")
	arg0_3.unlockCnt = math.min(arg0_3.unlockCnt, arg0_3.totalCnt)
	arg0_3.remainCnt = arg0_3.usedCnt >= arg0_3.totalCnt and 0 or arg0_3.unlockCnt - arg0_3.usedCnt
end

function var0_0.OnFirstFlush(arg0_4)
	arg0_4.usedCnt = arg0_4.activity:getData1()

	arg0_4:RefreshData()
	setText(arg0_4.awardTf:Find("get/tip/Text"), i18n(var0_0.TIP_KEY))

	arg0_4.index = #arg0_4.taskList

	for iter0_4 = 1, #arg0_4.taskList do
		if not arg0_4.taskProxy:getTaskVO(arg0_4.taskList[iter0_4]):isReceive() then
			arg0_4.index = iter0_4

			break
		end
	end

	for iter1_4 = 1, arg0_4.items.childCount do
		local var0_4 = arg0_4.items:GetChild(iter1_4 - 1)

		var0_4:GetComponent(typeof(LayoutElement)).preferredWidth = iter1_4 == arg0_4.index and var0_0.EXPAND_WIDTH or var0_0.CLOSE_WIDTH

		setImageAlpha(var0_4:Find("close"), iter1_4 == arg0_4.index and 0 or 1)
		onButton(arg0_4, var0_4, function()
			arg0_4:SelectItem(iter1_4)
		end, SFX_PANEL)
	end

	arg0_4:UpdateDrop()

	local var1_4 = arg0_4.activity:getConfig("config_client").firstStory

	if var1_4 then
		playStory(var1_4)
	end
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = 0
	local var1_6 = {}

	for iter0_6, iter1_6 in ipairs(arg0_6.taskList) do
		var1_6[iter1_6] = tobool(arg0_6.taskProxy:getFinishTaskById(iter1_6))

		if var1_6[iter1_6] then
			var0_6 = var0_6 + 1
		end

		setActive(arg0_6.items:GetChild(iter0_6 - 1):Find("got"), var1_6[iter1_6])
	end

	if arg0_6.usedCnt ~= var0_6 then
		arg0_6.usedCnt = var0_6

		local var2_6 = arg0_6.activity

		var2_6.data1 = arg0_6.usedCnt

		getProxy(ActivityProxy):updateActivity(var2_6)
	end

	arg0_6:RefreshData()
	setText(arg0_6.countTf, arg0_6.remainCnt)

	local var3_6 = var1_6[arg0_6.taskList[arg0_6.index]]

	setActive(arg0_6.awardTf:Find("got"), var3_6)
	setActive(arg0_6.awardTf:Find("get"), arg0_6.remainCnt > 0 and not var3_6)

	local var4_6 = arg0_6.activity:getConfig("config_client").story

	for iter2_6, iter3_6 in ipairs(arg0_6.taskList) do
		if arg0_6.taskProxy:getFinishTaskById(iter3_6) and checkExist(var4_6, {
			iter2_6
		}, {
			1
		}) then
			playStory(var4_6[iter2_6][1])
		end
	end
end

function var0_0.SelectItem(arg0_7, arg1_7)
	if arg0_7.index == arg1_7 then
		return
	end

	arg0_7.index = arg1_7

	for iter0_7, iter1_7 in ipairs(arg0_7.LTList or {}) do
		LeanTween.cancel(iter1_7)
	end

	arg0_7.LTList = {}

	for iter2_7 = 1, arg0_7.items.childCount do
		local var0_7 = arg0_7.items:GetChild(iter2_7 - 1)
		local var1_7 = var0_7:GetComponent(typeof(LayoutElement))
		local var2_7 = var1_7.preferredWidth
		local var3_7 = iter2_7 == arg1_7 and var0_0.EXPAND_WIDTH or var0_0.CLOSE_WIDTH

		if var2_7 ~= var3_7 then
			local var4_7 = math.abs(var3_7 - var2_7) / var0_0.DURATION_PARAMETER

			table.insert(arg0_7.LTList, LeanTween.value(go(var0_7), var2_7, var3_7, var4_7):setEase(LeanTweenType.easeOutSine):setOnUpdate(System.Action_float(function(arg0_8)
				var1_7.preferredWidth = arg0_8
			end)).uniqueId)
			table.insert(arg0_7.LTList, LeanTween.alpha(var0_7:Find("close"), iter2_7 == arg1_7 and 0 or 1, var4_7):setEase(LeanTweenType.easeOutSine).uniqueId)
		end
	end

	arg0_7:UpdateDrop()
end

function var0_0.UpdateDrop(arg0_9)
	local var0_9 = arg0_9.taskProxy:getTaskVO(arg0_9.taskList[arg0_9.index])
	local var1_9 = {}

	var1_9.type, var1_9.id, var1_9.count = unpack(var0_9:getConfig("award_display")[1])

	updateDrop(arg0_9.awardTf, var1_9)
	onButton(arg0_9, arg0_9.awardTf:Find("get"), function()
		arg0_9:emit(ActivityMediator.ON_TASK_SUBMIT, var0_9)
	end, SFX_CONFIRM)
	onButton(arg0_9, arg0_9.awardTf, function()
		arg0_9:emit(BaseUI.ON_DROP, var1_9)
	end)

	local var2_9 = var0_9:isReceive()

	setActive(arg0_9.awardTf:Find("got"), var2_9)
	setActive(arg0_9.awardTf:Find("get"), arg0_9.remainCnt > 0 and not var2_9)
end

function var0_0.OnDestroy(arg0_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.LTList or {}) do
		LeanTween.cancel(iter1_12)
	end
end

return var0_0
