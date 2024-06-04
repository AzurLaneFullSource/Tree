local var0 = class("VotingResulitAwardPage", import(".TemplatePage.SkinMagazineTemplatePage"))

var0.EXPAND_WIDTH = 973
var0.CLOSE_WIDTH = 216
var0.DURATION_PARAMETER = 2500

function var0.OnInit(arg0)
	arg0.items = arg0._tf:Find("AD/items")
	arg0.dicLT = {}
end

function var0.OnDataSetting(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskList = arg0.activity:getConfig("config_data")
	arg0.totalCnt = #arg0.taskList
	arg0.usedCnt = underscore.reduce(arg0.taskList, 0, function(arg0, arg1)
		return arg0 + (arg0.taskProxy:getFinishTaskById(arg1) and 1 or 0)
	end)

	if arg0.activity:getData1() ~= arg0.usedCnt then
		local var0 = arg0.activity

		var0.data1 = arg0.usedCnt

		getProxy(ActivityProxy):updateActivity(var0)

		return true
	end

	local var1 = pg.TimeMgr.GetInstance()

	arg0.unlockCnt = (var1:DiffDay(arg0.activity:getStartTime(), var1:GetServerTime()) + 1) * arg0.activity:getConfig("config_id")
	arg0.unlockCnt = math.min(arg0.unlockCnt, arg0.totalCnt)
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCnt and 0 or arg0.unlockCnt - arg0.usedCnt
end

function var0.OnFirstFlush(arg0)
	arg0.usedCnt = arg0.activity:getData1()

	for iter0, iter1 in ipairs(arg0.taskList) do
		local var0 = arg0.items:GetChild(iter0 - 1)

		onButton(arg0, var0:Find("close"), function()
			if arg0.index == iter0 then
				return
			end

			arg0:UpdateDisplay(iter0)
		end, SFX_PANEL)

		local var1 = arg0.taskProxy:getTaskVO(iter1)
		local var2 = Drop.Create(var1:getConfig("award_display")[1])

		for iter2, iter3 in ipairs({
			"close",
			"expand"
		}) do
			local var3 = var0:Find(iter3 .. "/IconTpl")

			updateDrop(var3, var2)
			setText(var3:Find("get/tip/Text"), i18n("voting_page_reward"))
			onButton(arg0, var3, function()
				arg0:emit(BaseUI.ON_DROP, var2)
			end, SFX_PANEL)
			onButton(arg0, var3:Find("get"), function()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var1)
			end, SFX_CONFIRM)
		end
	end

	arg0:UpdateDisplay(1)

	local var4 = arg0.activity:getConfig("config_client").firstStory

	if var4 then
		playStory(var4)
	end
end

function var0.OnUpdateFlush(arg0)
	for iter0, iter1 in ipairs(arg0.taskList) do
		local var0 = arg0.taskProxy:getTaskVO(iter1)

		for iter2, iter3 in ipairs({
			"close",
			"expand"
		}) do
			local var1 = arg0.items:GetChild(iter0 - 1):Find(iter3 .. "/IconTpl")

			setActive(var1:Find("get"), arg0.remainCnt > 0 and not var0:isReceive())
			setActive(var1:Find("got"), var0:isReceive())
		end
	end
end

function var0.UpdateDisplay(arg0, arg1)
	arg0.index = arg1

	for iter0 = 1, #arg0.taskList do
		local var0 = arg0.items:GetChild(iter0 - 1)
		local var1 = var0:GetComponent(typeof(LayoutElement))

		setActive(var0:Find("expand/IconTpl"), iter0 == arg0.index)

		var1.flexibleWidth = iter0 == arg0.index and 1 or -1

		if iter0 == arg0.index then
			var1.preferredWidth = var0.EXPAND_WIDTH

			setActive(var0:Find("close"), false)
		else
			local var2 = {}

			if var1.preferredWidth ~= var0.CLOSE_WIDTH then
				if arg0.dicLT[iter0] then
					LeanTween.cancel(arg0.dicLT[iter0])

					arg0.dicLT[iter0] = nil
				end

				table.insert(var2, function(arg0)
					arg0.dicLT[iter0] = LeanTween.value(go(var0), var1.preferredWidth, arg0.CLOSE_WIDTH, math.abs(var1.preferredWidth - arg0.CLOSE_WIDTH) / arg0.DURATION_PARAMETER):setEase(LeanTweenType.easeOutSine):setOnUpdate(System.Action_float(function(arg0)
						var1.preferredWidth = arg0
					end)):setOnComplete(System.Action(arg0)).uniqueId
				end)
			end

			seriesAsync(var2, function()
				arg0.dicLT[iter0] = nil

				setActive(var0:Find("close"), true)
			end)
		end
	end
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.dicLT) do
		LeanTween.cancel(iter1)
	end
end

return var0
