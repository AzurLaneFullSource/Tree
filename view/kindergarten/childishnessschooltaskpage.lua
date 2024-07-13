local var0_0 = class("ChildishnessSchoolTaskPage", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChildishnessSchoolTaskPage"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2:findTF("bg")
	arg0_2.scrollPanel = arg0_2:findTF("window/panel")
	arg0_2.UIlist = UIItemList.New(arg0_2:findTF("window/panel/list"), arg0_2:findTF("window/panel/list/Tasktpl"))
	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")
	arg0_2.getBtn = arg0_2:findTF("window/btn_get")
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3.anim:Play("anim_kinder_schoolPT_out")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.bg, function()
		arg0_3.anim:Play("anim_kinder_schoolPT_out")
	end, SFX_PANEL)
	arg0_3:Show()

	arg0_3.anim = arg0_3._tf:GetComponent(typeof(Animation))
	arg0_3.animEvent = arg0_3.anim:GetComponent(typeof(DftAniEvent))

	arg0_3.animEvent:SetEndEvent(function()
		arg0_3:closeView()
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.Show(arg0_7)
	arg0_7:UpdateTaskData()

	arg0_7.canGetTaskVOs = {}
	arg0_7.canGetTaskIds = {}

	arg0_7:sort(arg0_7.taskVOs)
	arg0_7:UpdateList(arg0_7.taskVOs)
	Canvas.ForceUpdateCanvases()
end

function var0_0.sort(arg0_8, arg1_8)
	local var0_8 = {}

	arg0_8.canGetAward = false

	for iter0_8, iter1_8 in pairs(arg1_8) do
		if iter1_8:getTaskStatus() == 1 then
			table.insert(var0_8, iter1_8)
			table.insert(arg0_8.canGetTaskVOs, iter1_8)
			table.insert(arg0_8.canGetTaskIds, iter1_8.id)

			arg0_8.canGetAward = true
		end
	end

	for iter2_8, iter3_8 in pairs(arg1_8) do
		if iter3_8:getTaskStatus() == 0 then
			table.insert(var0_8, iter3_8)
		end
	end

	for iter4_8, iter5_8 in pairs(arg1_8) do
		if iter5_8:getTaskStatus() == 2 then
			table.insert(var0_8, iter5_8)
		end
	end

	arg0_8.taskVOs = var0_8
end

function var0_0.UpdateList(arg0_9, arg1_9)
	arg0_9.UIlist:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg1_9[arg1_10 + 1]

			setText(arg2_10:Find("frame/desc"), var0_10:getConfig("desc"))

			local var1_10 = var0_10:getProgress()
			local var2_10 = var0_10:getConfig("target_num")
			local var3_10 = math.min(var1_10, var2_10)

			setText(arg2_10:Find("frame/progress"), var3_10 .. "/" .. var2_10)

			arg2_10:Find("frame/slider"):GetComponent(typeof(Slider)).value = var3_10 / var2_10

			local var4_10 = arg2_10:Find("frame/awards")
			local var5_10 = var4_10:GetChild(0)

			arg0_9:updateAwards(var0_10:getConfig("award_display"), var4_10, var5_10)

			local var6_10 = arg2_10:Find("frame/go_btn")
			local var7_10 = arg2_10:Find("frame/get_btn")
			local var8_10 = arg2_10:Find("frame/got_btn")

			if var0_10:getTaskStatus() == 0 then
				setActive(var6_10, true)
				setActive(var7_10, false)
				setActive(var8_10, false)
			elseif var0_10:getTaskStatus() == 1 then
				setActive(var6_10, false)
				setActive(var7_10, true)
				setActive(var8_10, false)
			elseif var0_10:getTaskStatus() == 2 then
				setActive(var6_10, false)
				setActive(var7_10, false)
				setActive(var8_10, true)
			end

			onButton(arg0_9, var6_10, function()
				arg0_9:emit(ChildishnessSchoolTaskMediator.ON_TASK_GO, var0_10)
			end, SFX_PANEL)
			onButton(arg0_9, var7_10, function()
				arg0_9:emit(ChildishnessSchoolTaskMediator.ON_TASK_SUBMIT, var0_10)
			end, SFX_PANEL)
		end
	end)
	arg0_9.UIlist:align(#arg1_9)

	if arg0_9.canGetAward then
		setActive(arg0_9.getBtn, true)
		onButton(arg0_9, arg0_9.getBtn, function()
			local var0_13 = {}
			local var1_13 = {}

			for iter0_13, iter1_13 in pairs(arg0_9.canGetTaskVOs) do
				local var2_13 = iter1_13:getConfig("award_display")

				for iter2_13, iter3_13 in ipairs(var2_13) do
					local var3_13 = iter3_13
					local var4_13 = false

					for iter4_13, iter5_13 in pairs(var1_13) do
						if iter5_13[1] == var3_13[1] and iter5_13[2] == var3_13[2] then
							var4_13 = true
							iter5_13[3] = iter5_13[3] + var3_13[3]

							break
						end
					end

					if not var4_13 then
						table.insert(var1_13, var3_13)
					end
				end
			end

			local var5_13 = getProxy(PlayerProxy):getRawData()
			local var6_13 = pg.gameset.urpt_chapter_max.description[1]
			local var7_13 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var6_13)
			local var8_13, var9_13 = Task.StaticJudgeOverflow(var5_13.gold, var5_13.oil, var7_13, true, true, var1_13)

			if var8_13 then
				table.insert(var0_13, function(arg0_14)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = var9_13,
						onYes = arg0_14
					})
				end)
			end

			seriesAsync(var0_13, function()
				arg0_9:emit(ChildishnessSchoolTaskMediator.ON_TASK_SUBMIT_ONESTEP, ActivityConst.ALVIT_TASK_ACT_ID, arg0_9.canGetTaskIds)
			end)
		end, SFX_PANEL)
	else
		setActive(arg0_9.getBtn, false)
		removeOnButton(arg0_9.getBtn)
	end
end

function var0_0.updateAwards(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = _.slice(arg1_16, 1, 3)

	for iter0_16 = arg2_16.childCount, #var0_16 - 1 do
		cloneTplTo(arg3_16, arg2_16)
	end

	local var1_16 = arg2_16.childCount

	for iter1_16 = 1, var1_16 do
		local var2_16 = arg2_16:GetChild(iter1_16 - 1)
		local var3_16 = iter1_16 <= #var0_16

		setActive(var2_16, var3_16)

		if var3_16 then
			local var4_16 = var0_16[iter1_16]
			local var5_16 = {
				type = var4_16[1],
				id = var4_16[2],
				count = var4_16[3]
			}

			updateDrop(arg0_16:findTF("mask", var2_16), var5_16)

			if var5_16.type == DROP_TYPE_EQUIPMENT_SKIN then
				setActive(arg0_16:findTF("specialFrame", var2_16), true)
			else
				setActive(arg0_16:findTF("specialFrame", var2_16), false)
			end

			onButton(arg0_16, var2_16, function()
				arg0_16:emit(BaseUI.ON_DROP, var5_16)
			end, SFX_PANEL)
		end
	end
end

function var0_0.UpdateTaskData(arg0_18)
	local var0_18 = getProxy(ActivityProxy):getActivityById(ActivityConst.ALVIT_TASK_ACT_ID)

	arg0_18.taskVOs = {}

	local var1_18 = var0_18:getConfig("config_data")

	for iter0_18, iter1_18 in pairs(var1_18) do
		table.insert(arg0_18.taskVOs, getProxy(TaskProxy):getTaskVO(iter1_18))
	end
end

function var0_0.willExit(arg0_19)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_19._tf)
end

return var0_0
