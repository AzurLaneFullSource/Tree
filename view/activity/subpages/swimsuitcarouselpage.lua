local var0 = class("SwimsuitCarouselPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0._tf:Find("AD")
	arg0.items = arg0.bg:Find("page/items")
	arg0.rtTask = arg0.bg:Find("page/task")
	arg0.countTF = arg0.rtTask:Find("count")
	arg0.rtAward = arg0.rtTask:Find("IconTpl")
end

function var0.OnDataSetting(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskList = arg0.activity:getConfig("config_data")
	arg0.totalCnt = #arg0.taskList
end

local var1 = 108
local var2 = 748

function var0.RefreshData(arg0)
	local var0 = pg.TimeMgr.GetInstance()

	arg0.unlockCnt = (var0:DiffDay(arg0.activity:getStartTime(), var0:GetServerTime()) + 1) * arg0.activity:getConfig("config_id")
	arg0.unlockCnt = math.min(arg0.unlockCnt, arg0.totalCnt)
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCnt and 0 or arg0.unlockCnt - arg0.usedCnt
end

function var0.OnFirstFlush(arg0)
	arg0.usedCnt = arg0.activity:getData1()

	arg0:RefreshData()

	arg0.index = #arg0.taskList

	for iter0 = 1, #arg0.taskList do
		if not arg0.taskProxy:getTaskVO(arg0.taskList[iter0]):isReceive() then
			arg0.index = iter0

			break
		end
	end

	for iter1 = 1, arg0.items.childCount do
		local var0 = arg0.items:GetChild(iter1 - 1)

		var0:GetComponent(typeof(LayoutElement)).preferredWidth = iter1 == arg0.index and var2 or var1

		setImageAlpha(var0:Find("window/Image"), iter1 == arg0.index and 0 or 1)
		setImageAlpha(var0:Find("window/main"), 1)
		onButton(arg0, var0, function()
			arg0:SelectPage(iter1)
		end, SFX_PANEL)
	end

	local var1 = arg0.taskProxy:getTaskVO(arg0.taskList[arg0.index])
	local var2 = {}

	var2.type, var2.id, var2.count = unpack(var1:getConfig("award_display")[1])

	updateDrop(arg0.rtAward, var2)
	onButton(arg0, arg0.rtAward:Find("get"), function()
		arg0:emit(ActivityMediator.ON_TASK_SUBMIT, arg0.taskProxy:getTaskVO(arg0.taskList[arg0.index]))
	end, SFX_CONFIRM)
	onButton(arg0, arg0.rtAward, function()
		arg0:emit(BaseUI.ON_DROP, var2)
	end)
end

function var0.OnUpdateFlush(arg0)
	local var0 = 0
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.taskList) do
		var1[iter1] = tobool(arg0.taskProxy:getFinishTaskById(iter1))

		if var1[iter1] then
			var0 = var0 + 1
		end

		setActive(arg0.items:GetChild(iter0 - 1):Find("window/got"), var1[iter1])
	end

	if arg0.usedCnt ~= var0 then
		arg0.usedCnt = var0

		local var2 = arg0.activity

		var2.data1 = arg0.usedCnt

		getProxy(ActivityProxy):updateActivity(var2)
	end

	arg0:RefreshData()
	setText(arg0.countTF, arg0.remainCnt)

	local var3 = var1[arg0.taskList[arg0.index]]

	setActive(arg0.rtAward:Find("got"), var3)
	setActive(arg0.rtAward:Find("get"), arg0.remainCnt > 0 and not var3)

	local var4 = arg0.activity:getConfig("config_client").story

	for iter2, iter3 in ipairs(arg0.taskList) do
		if arg0.taskProxy:getFinishTaskById(iter3) and checkExist(var4, {
			iter2
		}, {
			1
		}) then
			pg.NewStoryMgr.GetInstance():Play(var4[iter2][1])
		end
	end
end

function var0.SelectPage(arg0, arg1)
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
		local var2 = var0:Find("window/Image")
		local var3 = var0:Find("window/main")
		local var4 = var1.preferredWidth
		local var5 = iter2 == arg1 and var2 or var1

		if var4 ~= var5 then
			local var6 = math.abs(var5 - var4) / 2000

			table.insert(arg0.LTList, LeanTween.value(go(var0), var4, var5, var6):setEase(LeanTweenType.easeOutSine):setOnUpdate(System.Action_float(function(arg0)
				var1.preferredWidth = arg0
			end)).uniqueId)
			table.insert(arg0.LTList, LeanTween.alpha(var0:Find("window/Image"), iter2 == arg1 and 0 or 1, var6):setEase(LeanTweenType.easeOutSine).uniqueId)
		end
	end

	local var7 = arg0.taskProxy:getTaskVO(arg0.taskList[arg0.index])
	local var8 = {}

	var8.type, var8.id, var8.count = unpack(var7:getConfig("award_display")[1])

	updateDrop(arg0.rtAward, var8)

	local var9 = var7:isReceive()

	setActive(arg0.rtAward:Find("got"), var9)
	setActive(arg0.rtAward:Find("get"), arg0.remainCnt > 0 and not var9)
	setActive(arg0.rtTask, false)
	setActive(arg0.rtTask, true)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in ipairs(arg0.LTList or {}) do
		LeanTween.cancel(iter1)
	end
end

return var0
