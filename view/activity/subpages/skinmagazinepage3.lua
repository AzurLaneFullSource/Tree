local var0 = class("SkinMagazinePage3", import("...base.BaseActivityPage"))

var0.EXPAND_WIDTH = 839
var0.CLOSE_WIDTH = 146
var0.DURATION_PARAMETER = 1500
var0.TIP_KEY = "SkinMagazinePage2_tip"

function var0.OnInit(arg0)
	arg0.items = arg0._tf:Find("AD/items")
	arg0.countTf = arg0._tf:Find("AD/task/count")
	arg0.awardTf = arg0._tf:Find("AD/task/IconTpl")
end

function var0.OnDataSetting(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskList = arg0.activity:getConfig("config_data")
	arg0.totalCnt = #arg0.taskList
end

function var0.RefreshData(arg0)
	local var0 = pg.TimeMgr.GetInstance()

	arg0.unlockCnt = (var0:DiffDay(arg0.activity:getStartTime(), var0:GetServerTime()) + 1) * arg0.activity:getConfig("config_id")
	arg0.unlockCnt = math.min(arg0.unlockCnt, arg0.totalCnt)
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCnt and 0 or arg0.unlockCnt - arg0.usedCnt
end

function var0.OnFirstFlush(arg0)
	arg0.usedCnt = arg0.activity:getData1()

	arg0:RefreshData()
	setText(arg0.awardTf:Find("get/tip/Text"), i18n(var0.TIP_KEY))

	arg0.index = #arg0.taskList

	for iter0 = 1, #arg0.taskList do
		if not arg0.taskProxy:getTaskVO(arg0.taskList[iter0]):isReceive() then
			arg0.index = iter0

			break
		end
	end

	for iter1 = 1, arg0.items.childCount do
		local var0 = arg0.items:GetChild(iter1 - 1)

		var0:GetComponent(typeof(LayoutElement)).preferredWidth = iter1 == arg0.index and var0.EXPAND_WIDTH or var0.CLOSE_WIDTH

		setImageAlpha(var0:Find("close"), iter1 == arg0.index and 0 or 1)
		onButton(arg0, var0, function()
			arg0:SelectItem(iter1)
		end, SFX_PANEL)
	end

	arg0:UpdateDrop()

	local var1 = arg0.activity:getConfig("config_client").firstStory

	if var1 then
		playStory(var1)
	end
end

function var0.OnUpdateFlush(arg0)
	local var0 = 0
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.taskList) do
		var1[iter1] = tobool(arg0.taskProxy:getFinishTaskById(iter1))

		if var1[iter1] then
			var0 = var0 + 1
		end

		setActive(arg0.items:GetChild(iter0 - 1):Find("got"), var1[iter1])
	end

	if arg0.usedCnt ~= var0 then
		arg0.usedCnt = var0

		local var2 = arg0.activity

		var2.data1 = arg0.usedCnt

		getProxy(ActivityProxy):updateActivity(var2)
	end

	arg0:RefreshData()
	setText(arg0.countTf, arg0.remainCnt)

	local var3 = var1[arg0.taskList[arg0.index]]

	setActive(arg0.awardTf:Find("got"), var3)
	setActive(arg0.awardTf:Find("get"), arg0.remainCnt > 0 and not var3)

	local var4 = arg0.activity:getConfig("config_client").story

	for iter2, iter3 in ipairs(arg0.taskList) do
		if arg0.taskProxy:getFinishTaskById(iter3) and checkExist(var4, {
			iter2
		}, {
			1
		}) then
			playStory(var4[iter2][1])
		end
	end
end

function var0.SelectItem(arg0, arg1)
	if arg0.index == arg1 then
		return
	end

	arg0.index = arg1

	for iter0, iter1 in ipairs(arg0.LTList or {}) do
		LeanTween.cancel(iter1)
	end

	arg0.LTList = {}

	for iter2 = 1, arg0.items.childCount do
		local var0 = arg0.items:GetChild(iter2 - 1)
		local var1 = var0:GetComponent(typeof(LayoutElement))
		local var2 = var1.preferredWidth
		local var3 = iter2 == arg1 and var0.EXPAND_WIDTH or var0.CLOSE_WIDTH

		if var2 ~= var3 then
			local var4 = math.abs(var3 - var2) / var0.DURATION_PARAMETER

			table.insert(arg0.LTList, LeanTween.value(go(var0), var2, var3, var4):setEase(LeanTweenType.easeOutSine):setOnUpdate(System.Action_float(function(arg0)
				var1.preferredWidth = arg0
			end)).uniqueId)
			table.insert(arg0.LTList, LeanTween.alpha(var0:Find("close"), iter2 == arg1 and 0 or 1, var4):setEase(LeanTweenType.easeOutSine).uniqueId)
		end
	end

	arg0:UpdateDrop()
end

function var0.UpdateDrop(arg0)
	local var0 = arg0.taskProxy:getTaskVO(arg0.taskList[arg0.index])
	local var1 = {}

	var1.type, var1.id, var1.count = unpack(var0:getConfig("award_display")[1])

	updateDrop(arg0.awardTf, var1)
	onButton(arg0, arg0.awardTf:Find("get"), function()
		arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)
	end, SFX_CONFIRM)
	onButton(arg0, arg0.awardTf, function()
		arg0:emit(BaseUI.ON_DROP, var1)
	end)

	local var2 = var0:isReceive()

	setActive(arg0.awardTf:Find("got"), var2)
	setActive(arg0.awardTf:Find("get"), arg0.remainCnt > 0 and not var2)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in ipairs(arg0.LTList or {}) do
		LeanTween.cancel(iter1)
	end
end

return var0
