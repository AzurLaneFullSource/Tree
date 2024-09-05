local var0_0 = class("DreamSignPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.lockNamed = PLATFORM_CODE == PLATFORM_CH and LOCK_NAMED
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.signTF = arg0_1:findTF("sign", arg0_1.bg)
	arg0_1.items = arg0_1:findTF("items", arg0_1.signTF)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1:findTF("tpl", arg0_1.items))
	arg0_1.signBtn = arg0_1:findTF("get", arg0_1.signTF)
	arg0_1.goBtn = arg0_1:findTF("go", arg0_1.signTF)
	arg0_1.lock = arg0_1:findTF("lock", arg0_1.signTF)
	arg0_1.countText = arg0_1:findTF("count", arg0_1.signBtn)
	arg0_1.signRed = arg0_1:findTF("tip", arg0_1.signBtn)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.nday = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = underscore.flatten(arg0_2.activity:getConfig("config_data"))
	arg0_2.taskConfig = pg.task_data_template

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	arg0_3.uilist:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventInit then
			local var0_4 = arg1_4 + 1
			local var1_4 = arg0_3.taskGroup[var0_4]
			local var2_4 = arg0_3:findTF("item_mask/item", arg2_4)
			local var3_4 = Drop.Create(arg0_3.taskConfig[var1_4].award_display[1])

			updateDrop(var2_4, var3_4)
			onButton(arg0_3, arg2_4, function()
				arg0_3:emit(BaseUI.ON_DROP, var3_4)
			end, SFX_PANEL)
		elseif arg0_4 == UIItemList.EventUpdate then
			local var4_4 = arg1_4 + 1
			local var5_4 = arg0_3.taskGroup[var4_4]
			local var6_4 = arg0_3.taskProxy:getTaskById(var5_4) or arg0_3.taskProxy:getFinishTaskById(var5_4)

			setActive(arg0_3:findTF("got", arg2_4), var4_4 < arg0_3.nday or var6_4 and var6_4:getTaskStatus() == 2)
		end
	end)
	onButton(arg0_3, arg0_3.signBtn, function()
		if not arg0_3.remainCnt or arg0_3.remainCnt <= 0 then
			return
		end

		seriesAsync({
			function(arg0_7)
				local var0_7 = arg0_3.activity:getConfig("config_client").story

				if checkExist(var0_7, {
					arg0_3.nday
				}, {
					1
				}) then
					pg.NewStoryMgr.GetInstance():Play(var0_7[arg0_3.nday][1], arg0_7)
				else
					arg0_7()
				end
			end,
			function(arg0_8)
				if arg0_3.curTaskVO:getTaskStatus() == 1 then
					arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.curTaskVO, arg0_8)
				else
					arg0_8()
				end
			end
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.goBtn, function()
		if arg0_3:IsLock() then
			return
		end

		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.DREAMLAND)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_10)
	arg0_10.nday = arg0_10.activity.data3

	local var0_10 = arg0_10.taskGroup[arg0_10.nday]

	arg0_10.curTaskVO = arg0_10.taskProxy:getTaskById(var0_10) or arg0_10.taskProxy:getFinishTaskById(var0_10)
	arg0_10.remainCnt = math.min(arg0_10.activity:getDayIndex(), #arg0_10.taskGroup) - arg0_10.nday

	if arg0_10.curTaskVO:getTaskStatus() == 1 then
		arg0_10.remainCnt = arg0_10.remainCnt + 1
	end

	local var1_10 = arg0_10:IsFinishSign()

	setActive(arg0_10.signBtn, not var1_10)
	setActive(arg0_10.goBtn, var1_10)
	setActive(arg0_10.lock, var1_10 and arg0_10:IsLock())
	setActive(arg0_10.signRed, arg0_10.remainCnt > 0)
	setText(arg0_10.countText, i18n("liner_sign_cnt_tip") .. arg0_10.remainCnt)
	arg0_10.uilist:align(#arg0_10.taskGroup)
end

function var0_0.IsFinishSign(arg0_11)
	local var0_11 = arg0_11.taskGroup[#arg0_11.taskGroup]
	local var1_11 = arg0_11.taskProxy:getTaskById(var0_11) or arg0_11.taskProxy:getFinishTaskById(var0_11)

	return var1_11 and var1_11:getTaskStatus() == 2
end

function var0_0.IsLock(arg0_12)
	local var0_12 = getProxy(ActivityProxy):getActivityById(ActivityConst.DREAMLAND_JP_ID)

	return not var0_12 or var0_12:isEnd()
end

return var0_0
