local var0_0 = class("SwimsuitCarouselPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.items = arg0_1.bg:Find("page/items")
	arg0_1.rtTask = arg0_1.bg:Find("page/task")
	arg0_1.countTF = arg0_1.rtTask:Find("count")
	arg0_1.rtAward = arg0_1.rtTask:Find("IconTpl")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskList = arg0_2.activity:getConfig("config_data")
	arg0_2.totalCnt = #arg0_2.taskList
end

local var1_0 = 108
local var2_0 = 748

function var0_0.RefreshData(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance()

	arg0_3.unlockCnt = (var0_3:DiffDay(arg0_3.activity:getStartTime(), var0_3:GetServerTime()) + 1) * arg0_3.activity:getConfig("config_id")
	arg0_3.unlockCnt = math.min(arg0_3.unlockCnt, arg0_3.totalCnt)
	arg0_3.remainCnt = arg0_3.usedCnt >= arg0_3.totalCnt and 0 or arg0_3.unlockCnt - arg0_3.usedCnt
end

function var0_0.OnFirstFlush(arg0_4)
	arg0_4.usedCnt = arg0_4.activity:getData1()

	arg0_4:RefreshData()

	arg0_4.index = #arg0_4.taskList

	for iter0_4 = 1, #arg0_4.taskList do
		if not arg0_4.taskProxy:getTaskVO(arg0_4.taskList[iter0_4]):isReceive() then
			arg0_4.index = iter0_4

			break
		end
	end

	for iter1_4 = 1, arg0_4.items.childCount do
		local var0_4 = arg0_4.items:GetChild(iter1_4 - 1)

		var0_4:GetComponent(typeof(LayoutElement)).preferredWidth = iter1_4 == arg0_4.index and var2_0 or var1_0

		setImageAlpha(var0_4:Find("window/Image"), iter1_4 == arg0_4.index and 0 or 1)
		setImageAlpha(var0_4:Find("window/main"), 1)
		onButton(arg0_4, var0_4, function()
			arg0_4:SelectPage(iter1_4)
		end, SFX_PANEL)
	end

	local var1_4 = arg0_4.taskProxy:getTaskVO(arg0_4.taskList[arg0_4.index])
	local var2_4 = {}

	var2_4.type, var2_4.id, var2_4.count = unpack(var1_4:getConfig("award_display")[1])

	updateDrop(arg0_4.rtAward, var2_4)
	onButton(arg0_4, arg0_4.rtAward:Find("get"), function()
		arg0_4:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_4.taskProxy:getTaskVO(arg0_4.taskList[arg0_4.index]))
	end, SFX_CONFIRM)
	onButton(arg0_4, arg0_4.rtAward, function()
		arg0_4:emit(BaseUI.ON_DROP, var2_4)
	end)
end

function var0_0.OnUpdateFlush(arg0_8)
	local var0_8 = 0
	local var1_8 = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.taskList) do
		var1_8[iter1_8] = tobool(arg0_8.taskProxy:getFinishTaskById(iter1_8))

		if var1_8[iter1_8] then
			var0_8 = var0_8 + 1
		end

		setActive(arg0_8.items:GetChild(iter0_8 - 1):Find("window/got"), var1_8[iter1_8])
	end

	if arg0_8.usedCnt ~= var0_8 then
		arg0_8.usedCnt = var0_8

		local var2_8 = arg0_8.activity

		var2_8.data1 = arg0_8.usedCnt

		getProxy(ActivityProxy):updateActivity(var2_8)
	end

	arg0_8:RefreshData()
	setText(arg0_8.countTF, arg0_8.remainCnt)

	local var3_8 = var1_8[arg0_8.taskList[arg0_8.index]]

	setActive(arg0_8.rtAward:Find("got"), var3_8)
	setActive(arg0_8.rtAward:Find("get"), arg0_8.remainCnt > 0 and not var3_8)

	local var4_8 = arg0_8.activity:getConfig("config_client").story

	for iter2_8, iter3_8 in ipairs(arg0_8.taskList) do
		if arg0_8.taskProxy:getFinishTaskById(iter3_8) and checkExist(var4_8, {
			iter2_8
		}, {
			1
		}) then
			pg.NewStoryMgr.GetInstance():Play(var4_8[iter2_8][1])
		end
	end
end

function var0_0.SelectPage(arg0_9, arg1_9)
	if arg0_9.index == arg1_9 then
		return
	end

	arg0_9.index = arg1_9

	for iter0_9, iter1_9 in ipairs(arg0_9.LTList or {}) do
		LeanTween.cancel(iter1_9)
	end

	arg0_9.LTList = {}

	for iter2_9 = 1, arg0_9.items.childCount do
		local var0_9 = arg0_9.items:GetChild(iter2_9 - 1)
		local var1_9 = var0_9:GetComponent(typeof(LayoutElement))
		local var2_9 = var0_9:Find("window/Image")
		local var3_9 = var0_9:Find("window/main")
		local var4_9 = var1_9.preferredWidth
		local var5_9 = iter2_9 == arg1_9 and var2_0 or var1_0

		if var4_9 ~= var5_9 then
			local var6_9 = math.abs(var5_9 - var4_9) / 2000

			table.insert(arg0_9.LTList, LeanTween.value(go(var0_9), var4_9, var5_9, var6_9):setEase(LeanTweenType.easeOutSine):setOnUpdate(System.Action_float(function(arg0_10)
				var1_9.preferredWidth = arg0_10
			end)).uniqueId)
			table.insert(arg0_9.LTList, LeanTween.alpha(var0_9:Find("window/Image"), iter2_9 == arg1_9 and 0 or 1, var6_9):setEase(LeanTweenType.easeOutSine).uniqueId)
		end
	end

	local var7_9 = arg0_9.taskProxy:getTaskVO(arg0_9.taskList[arg0_9.index])
	local var8_9 = {}

	var8_9.type, var8_9.id, var8_9.count = unpack(var7_9:getConfig("award_display")[1])

	updateDrop(arg0_9.rtAward, var8_9)

	local var9_9 = var7_9:isReceive()

	setActive(arg0_9.rtAward:Find("got"), var9_9)
	setActive(arg0_9.rtAward:Find("get"), arg0_9.remainCnt > 0 and not var9_9)
	setActive(arg0_9.rtTask, false)
	setActive(arg0_9.rtTask, true)
end

function var0_0.OnDestroy(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.LTList or {}) do
		LeanTween.cancel(iter1_11)
	end
end

return var0_0
