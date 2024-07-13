local var0_0 = class("VotingResulitAwardPage", import(".TemplatePage.SkinMagazineTemplatePage"))

var0_0.EXPAND_WIDTH = 973
var0_0.CLOSE_WIDTH = 216
var0_0.DURATION_PARAMETER = 2500

function var0_0.OnInit(arg0_1)
	arg0_1.items = arg0_1._tf:Find("AD/items")
	arg0_1.dicLT = {}
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskList = arg0_2.activity:getConfig("config_data")
	arg0_2.totalCnt = #arg0_2.taskList
	arg0_2.usedCnt = underscore.reduce(arg0_2.taskList, 0, function(arg0_3, arg1_3)
		return arg0_3 + (arg0_2.taskProxy:getFinishTaskById(arg1_3) and 1 or 0)
	end)

	if arg0_2.activity:getData1() ~= arg0_2.usedCnt then
		local var0_2 = arg0_2.activity

		var0_2.data1 = arg0_2.usedCnt

		getProxy(ActivityProxy):updateActivity(var0_2)

		return true
	end

	local var1_2 = pg.TimeMgr.GetInstance()

	arg0_2.unlockCnt = (var1_2:DiffDay(arg0_2.activity:getStartTime(), var1_2:GetServerTime()) + 1) * arg0_2.activity:getConfig("config_id")
	arg0_2.unlockCnt = math.min(arg0_2.unlockCnt, arg0_2.totalCnt)
	arg0_2.remainCnt = arg0_2.usedCnt >= arg0_2.totalCnt and 0 or arg0_2.unlockCnt - arg0_2.usedCnt
end

function var0_0.OnFirstFlush(arg0_4)
	arg0_4.usedCnt = arg0_4.activity:getData1()

	for iter0_4, iter1_4 in ipairs(arg0_4.taskList) do
		local var0_4 = arg0_4.items:GetChild(iter0_4 - 1)

		onButton(arg0_4, var0_4:Find("close"), function()
			if arg0_4.index == iter0_4 then
				return
			end

			arg0_4:UpdateDisplay(iter0_4)
		end, SFX_PANEL)

		local var1_4 = arg0_4.taskProxy:getTaskVO(iter1_4)
		local var2_4 = Drop.Create(var1_4:getConfig("award_display")[1])

		for iter2_4, iter3_4 in ipairs({
			"close",
			"expand"
		}) do
			local var3_4 = var0_4:Find(iter3_4 .. "/IconTpl")

			updateDrop(var3_4, var2_4)
			setText(var3_4:Find("get/tip/Text"), i18n("voting_page_reward"))
			onButton(arg0_4, var3_4, function()
				arg0_4:emit(BaseUI.ON_DROP, var2_4)
			end, SFX_PANEL)
			onButton(arg0_4, var3_4:Find("get"), function()
				arg0_4:emit(ActivityMediator.ON_TASK_SUBMIT, var1_4)
			end, SFX_CONFIRM)
		end
	end

	arg0_4:UpdateDisplay(1)

	local var4_4 = arg0_4.activity:getConfig("config_client").firstStory

	if var4_4 then
		playStory(var4_4)
	end
end

function var0_0.OnUpdateFlush(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.taskList) do
		local var0_8 = arg0_8.taskProxy:getTaskVO(iter1_8)

		for iter2_8, iter3_8 in ipairs({
			"close",
			"expand"
		}) do
			local var1_8 = arg0_8.items:GetChild(iter0_8 - 1):Find(iter3_8 .. "/IconTpl")

			setActive(var1_8:Find("get"), arg0_8.remainCnt > 0 and not var0_8:isReceive())
			setActive(var1_8:Find("got"), var0_8:isReceive())
		end
	end
end

function var0_0.UpdateDisplay(arg0_9, arg1_9)
	arg0_9.index = arg1_9

	for iter0_9 = 1, #arg0_9.taskList do
		local var0_9 = arg0_9.items:GetChild(iter0_9 - 1)
		local var1_9 = var0_9:GetComponent(typeof(LayoutElement))

		setActive(var0_9:Find("expand/IconTpl"), iter0_9 == arg0_9.index)

		var1_9.flexibleWidth = iter0_9 == arg0_9.index and 1 or -1

		if iter0_9 == arg0_9.index then
			var1_9.preferredWidth = var0_0.EXPAND_WIDTH

			setActive(var0_9:Find("close"), false)
		else
			local var2_9 = {}

			if var1_9.preferredWidth ~= var0_0.CLOSE_WIDTH then
				if arg0_9.dicLT[iter0_9] then
					LeanTween.cancel(arg0_9.dicLT[iter0_9])

					arg0_9.dicLT[iter0_9] = nil
				end

				table.insert(var2_9, function(arg0_10)
					arg0_9.dicLT[iter0_9] = LeanTween.value(go(var0_9), var1_9.preferredWidth, arg0_9.CLOSE_WIDTH, math.abs(var1_9.preferredWidth - arg0_9.CLOSE_WIDTH) / arg0_9.DURATION_PARAMETER):setEase(LeanTweenType.easeOutSine):setOnUpdate(System.Action_float(function(arg0_11)
						var1_9.preferredWidth = arg0_11
					end)):setOnComplete(System.Action(arg0_10)).uniqueId
				end)
			end

			seriesAsync(var2_9, function()
				arg0_9.dicLT[iter0_9] = nil

				setActive(var0_9:Find("close"), true)
			end)
		end
	end
end

function var0_0.OnDestroy(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.dicLT) do
		LeanTween.cancel(iter1_13)
	end
end

return var0_0
