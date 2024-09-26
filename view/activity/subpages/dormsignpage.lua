local var0_0 = class("DormSignPage", import("view.base.BaseActivityPage"))

function var0_0.getUIName(arg0_1)
	return "DormSignPage"
end

function var0_0.OnInit(arg0_2)
	arg0_2.bg = arg0_2:findTF("AD")
	arg0_2.items = arg0_2:findTF("items", arg0_2.bg)
	arg0_2.uilist = UIItemList.New(arg0_2.items, arg0_2:findTF("tpl", arg0_2.items))
	arg0_2.goBtn = arg0_2:findTF("btn_go", arg0_2.bg)
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
			local var2_8 = arg0_7:findTF("item", arg2_8)
			local var3_8 = Drop.Create(arg0_7.taskConfig[var1_8].award_display[1])

			if var0_8 > 1 then
				updateDrop(var2_8, var3_8)
			end

			onButton(arg0_7, arg2_8, function()
				if arg0_7.taskDic[var1_8] and arg0_7.taskDic[var1_8]:getTaskStatus() == 1 and not arg0_7.taskDic[var1_8]:isOver() then
					arg0_7:emit(ActivityMediator.ON_ACTIVITY_TASK_SUBMIT, {
						activityId = arg0_7.activity.id,
						id = var1_8
					})
				else
					arg0_7:emit(BaseUI.ON_DROP, var3_8)
				end
			end, SFX_PANEL)
		elseif arg0_8 == UIItemList.EventUpdate then
			local var4_8 = arg1_8 + 1
			local var5_8 = arg0_7.taskGroup[var4_8]
			local var6_8 = arg0_7.taskDic[var5_8]

			setActive(arg0_7:findTF("got", arg2_8), var6_8 and var6_8:isOver())
			setActive(arg0_7:findTF("tip", arg2_8), var6_8 and var6_8:getTaskStatus() == 1 and not var6_8:isOver())
		end
	end)
	onButton(arg0_7, arg0_7.goBtn, function()
		arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.DORM3DSELECT)
	end, SFX_PANEL)
	setActive(arg0_7.goBtn:Find("tip"), var0_0.IsShowGoRed())
	PlayerPrefs.SetString("DormSignPage", var0_0.GetDate())
end

function var0_0.OnUpdateFlush(arg0_11)
	arg0_11:UpdateTaskData()
	arg0_11.uilist:align(#arg0_11.taskGroup)
end

function var0_0.GetDate()
	return pg.TimeMgr.GetInstance():STimeDescC(pg.TimeMgr.GetInstance():GetServerTime(), "%Y/%m/%d")
end

function var0_0.IsShowRed()
	return var0_0.IsShowGoRed() or var0_0.IsShowAwardRed()
end

function var0_0.IsShowGoRed()
	return PlayerPrefs.GetString("DormSignPage", "") ~= var0_0.GetDate()
end

function var0_0.IsShowAwardRed()
	local var0_15 = getProxy(ActivityTaskProxy):getTaskById(ActivityConst.DORM_SIGN_ID)

	return _.any(var0_15, function(arg0_16)
		return arg0_16:getTaskStatus() == 1
	end)
end

return var0_0
