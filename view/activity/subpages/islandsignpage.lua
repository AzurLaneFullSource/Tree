local var0_0 = class("IslandSignPage", import("view.base.BaseActivityPage"))

function var0_0.getUIName(arg0_1)
	return "IslandSignPage"
end

function var0_0.OnInit(arg0_2)
	arg0_2.uilist = UIItemList.New(arg0_2.uiItemsTf, arg0_2.uiItemTf)
	arg0_2.uiGotList = UIItemList.New(arg0_2.uiItemsGetTf, arg0_2.uiGotItemTf)

	setText(arg0_2.uiText, i18n("island_sign_text"))
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.actTaskProxy = getProxy(ActivityTaskProxy)
	arg0_3.taskGroup = underscore.flatten(arg0_3.activity:getConfig("config_data"))
	arg0_3.taskConfig = pg.task_data_template
end

function var0_0.UpdateTaskData(arg0_4)
	arg0_4.taskVOs = arg0_4.actTaskProxy:getTaskById(arg0_4.activity.id)
	arg0_4.finishTaksVOs = arg0_4.actTaskProxy:getFinishTaskById(arg0_4.activity.id)
	arg0_4.taskDic = {}

	_.each(arg0_4.taskVOs, function(arg0_5)
		arg0_4.taskDic[arg0_5.id] = arg0_5
	end)
	_.each(arg0_4.finishTaksVOs, function(arg0_6)
		arg0_4.taskDic[arg0_6.id] = arg0_6
	end)
end

function var0_0.OnFirstFlush(arg0_7)
	arg0_7.uilist:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventInit then
			local var0_8 = arg1_8 + 1
			local var1_8 = arg0_7.taskGroup[var0_8]
			local var2_8 = Drop.Create(arg0_7.taskConfig[var1_8].award_display[1])

			if var0_8 < 7 then
				local var3_8 = arg2_8:Find("item")

				updateDrop(var3_8, var2_8)
			end

			onButton(arg0_7, arg2_8, function()
				arg0_7:emit(BaseUI.ON_DROP, var2_8)
			end, SFX_PANEL)
		end
	end)
	arg0_7.uiGotList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg1_10 + 1
			local var1_10 = arg0_7.taskGroup[var0_10]
			local var2_10 = arg0_7.taskDic[var1_10]

			setActive(arg2_10:Find("get_bg"), var2_10 and var2_10:isOver())
			setActive(arg2_10:Find("tip"), var2_10 and var2_10:getTaskStatus() == 0 and not var2_10:isOver())
		end
	end)

	local var0_7 = arg0_7:GetCanReceiveTaskList()

	setActive(arg0_7.uiGoBtn:Find("tip"), #var0_7 > 0)
	onButton(arg0_7, arg0_7.uiGoBtn, function()
		if arg0_7.liveAreaPage == nil then
			arg0_7.liveAreaPage = MainLiveAreaPage.New(arg0_7._parentTf, arg0_7.event)
		end

		arg0_7.liveAreaPage:ExecuteAction("Show", true, function()
			local var0_12 = arg0_7:GetCanReceiveTaskList()

			if #var0_12 > 0 then
				arg0_7:emit(ActivityMediator.ON_ACTIVITY_TASK_LIST_SUBMIT, {
					activityId = arg0_7.activity.id,
					ids = var0_12
				})
			end
		end)
	end, SFX_PANEL)
	PlayerPrefs.SetString("IslandSignPage", var0_0.GetDate())
end

function var0_0.OnUpdateFlush(arg0_13)
	arg0_13:UpdateTaskData()
	arg0_13.uilist:align(#arg0_13.taskGroup)
	arg0_13.uiGotList:align(#arg0_13.taskGroup)

	local var0_13 = arg0_13:GetCanReceiveTaskList()

	setActive(arg0_13.uiGoBtn:Find("tip"), #var0_13 > 0)
end

function var0_0.GetDate()
	return pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
end

function var0_0.IsShowRed()
	return var0_0.IsShowAwardRed()
end

function var0_0.IsShowGoRed()
	return PlayerPrefs.GetString("IslandSignPage", "") ~= var0_0.GetDate()
end

function var0_0.IsShowAwardRed()
	local var0_17 = getProxy(ActivityTaskProxy):getTaskById(ActivityConst.ISLAND_SIGN_ID)

	return _.any(var0_17, function(arg0_18)
		return arg0_18:getTaskStatus() == 0
	end)
end

function var0_0.GetCanReceiveTaskList(arg0_19)
	local var0_19 = getProxy(ActivityTaskProxy):getTaskById(ActivityConst.ISLAND_SIGN_ID)
	local var1_19 = {}

	for iter0_19, iter1_19 in pairs(var0_19) do
		if iter1_19:getTaskStatus() == 0 then
			table.insert(var1_19, iter1_19.id)
		end
	end

	return var1_19
end

function var0_0.Destroy(arg0_20)
	if arg0_20.liveAreaPage then
		arg0_20.liveAreaPage:Destroy()

		arg0_20.liveAreaPage = nil
	end

	var0_0.super.Destroy(arg0_20)
end

function var0_0.onBackPressed(arg0_21)
	if arg0_21.liveAreaPage and arg0_21.liveAreaPage:GetLoaded() and arg0_21.liveAreaPage:isShowing() then
		arg0_21.liveAreaPage:Hide()

		return true
	end

	return false
end

return var0_0
