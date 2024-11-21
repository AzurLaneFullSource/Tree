local var0_0 = class("ToLoveCollabTaskScene", import("view.base.BaseUI"))
local var1_0 = {
	{
		6,
		9004
	},
	{
		16,
		1006
	}
}
local var2_0 = 65011

function var0_0.getUIName(arg0_1)
	return "ToLoveCollabTaskPage"
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
		arg0_3:closeView()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.bg, function()
		arg0_3:closeView()
	end, SFX_PANEL)
	arg0_3:Show()
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.Show(arg0_6)
	arg0_6:UpdateTaskData()

	arg0_6.canGetTaskVOs = {}
	arg0_6.canGetTaskIds = {}

	arg0_6:sort(arg0_6.taskVOs)
	arg0_6:UpdateList(arg0_6.taskVOs)
	Canvas.ForceUpdateCanvases()
end

function var0_0.sort(arg0_7, arg1_7)
	local var0_7 = {}

	arg0_7.canGetAward = false

	for iter0_7, iter1_7 in pairs(arg1_7) do
		if iter1_7:getTaskStatus() == 1 then
			table.insert(var0_7, iter1_7)
			table.insert(arg0_7.canGetTaskVOs, iter1_7)
			table.insert(arg0_7.canGetTaskIds, iter1_7.id)

			arg0_7.canGetAward = true
		end
	end

	for iter2_7, iter3_7 in pairs(arg1_7) do
		if iter3_7:getTaskStatus() == 0 then
			table.insert(var0_7, iter3_7)
		end
	end

	for iter4_7, iter5_7 in pairs(arg1_7) do
		if iter5_7:getTaskStatus() == 2 then
			table.insert(var0_7, iter5_7)
		end
	end

	arg0_7.taskVOs = var0_7
end

function var0_0.UpdateList(arg0_8, arg1_8)
	arg0_8.UIlist:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg1_8[arg1_9 + 1]
			local var1_9, var2_9 = arg0_8:getTaskProgress(var0_9)
			local var3_9, var4_9 = arg0_8:getTaskTarget(var0_9)
			local var5_9 = math.min(var1_9, var3_9)

			setText(arg2_9:Find("frame/desc"), var0_9:getConfig("desc") .. " (" .. tostring(var5_9) .. "/" .. var4_9 .. ")")

			arg2_9:Find("frame/slider"):GetComponent(typeof(Slider)).value = var5_9 / var3_9

			local var6_9 = arg2_9:Find("frame/awards")
			local var7_9 = var6_9:GetChild(0)

			arg0_8:updateAwards(var0_9:getConfig("award_display"), var6_9, var7_9)

			local var8_9 = arg2_9:Find("frame/go_btn")
			local var9_9 = arg2_9:Find("frame/get_btn")
			local var10_9 = arg2_9:Find("frame/got_btn")
			local var11_9 = arg2_9:Find("frame/bg_go")
			local var12_9 = arg2_9:Find("frame/bg_get")
			local var13_9 = arg2_9:Find("frame/bg_got")

			setActive(var8_9, var0_9:getTaskStatus() == 0)
			setActive(var11_9, var0_9:getTaskStatus() == 0)
			setActive(var9_9, var0_9:getTaskStatus() == 1)
			setActive(var12_9, var0_9:getTaskStatus() == 1)
			setActive(var10_9, var0_9:getTaskStatus() == 2)
			setActive(var13_9, var0_9:getTaskStatus() == 2)
			onButton(arg0_8, var8_9, function()
				arg0_8:emit(ToLoveCollabTaskMediator.ON_TASK_GO, var0_9)
			end, SFX_PANEL)
			onButton(arg0_8, var9_9, function()
				arg0_8:checkAwardOverFlow({
					var0_9
				}, function()
					arg0_8:emit(ToLoveCollabTaskMediator.ON_TASK_SUBMIT, var0_9)
				end)
			end, SFX_PANEL)
		end
	end)
	arg0_8.UIlist:align(#arg1_8)

	if arg0_8.canGetAward then
		setActive(arg0_8.getBtn, true)
		onButton(arg0_8, arg0_8.getBtn, function()
			arg0_8:checkAwardOverFlow(arg0_8.canGetTaskVOs, function()
				arg0_8:emit(ToLoveCollabTaskMediator.ON_TASK_SUBMIT_ONESTEP, arg0_8.canGetTaskIds)
			end)
		end, SFX_PANEL)
	else
		setActive(arg0_8.getBtn, false)
		removeOnButton(arg0_8.getBtn)
	end
end

function var0_0.checkAwardOverFlow(arg0_15, arg1_15, arg2_15)
	local var0_15 = {}
	local var1_15 = {}

	for iter0_15, iter1_15 in pairs(arg1_15) do
		local var2_15 = iter1_15:getConfig("award_display")

		for iter2_15, iter3_15 in ipairs(var2_15) do
			local var3_15 = iter3_15
			local var4_15 = false

			for iter4_15, iter5_15 in pairs(var1_15) do
				if iter5_15[1] == var3_15[1] and iter5_15[2] == var3_15[2] then
					var4_15 = true
					iter5_15[3] = iter5_15[3] + var3_15[3]

					break
				end
			end

			if not var4_15 then
				table.insert(var1_15, {
					var3_15[1],
					var3_15[2],
					var3_15[3]
				})
			end
		end
	end

	local var5_15 = getProxy(PlayerProxy):getRawData()
	local var6_15 = pg.gameset.urpt_chapter_max.description[1]
	local var7_15 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var6_15)
	local var8_15, var9_15 = Task.StaticJudgeOverflow(var5_15.gold, var5_15.oil, var7_15, true, true, var1_15)

	if var8_15 then
		table.insert(var0_15, function(arg0_16)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var9_15,
				onYes = arg0_16
			})
		end)
	end

	seriesAsync(var0_15, arg2_15)
end

function var0_0.updateAwards(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = _.slice(arg1_17, 1, 3)

	for iter0_17 = arg2_17.childCount, #var0_17 - 1 do
		cloneTplTo(arg3_17, arg2_17)
	end

	local var1_17 = arg2_17.childCount

	for iter1_17 = 1, var1_17 do
		local var2_17 = arg2_17:GetChild(iter1_17 - 1)
		local var3_17 = iter1_17 <= #var0_17

		setActive(var2_17, var3_17)

		if var3_17 then
			local var4_17 = var0_17[iter1_17]
			local var5_17 = {
				type = var4_17[1],
				id = var4_17[2],
				count = var4_17[3]
			}

			updateDrop(arg0_17:findTF("mask", var2_17), var5_17)

			if var5_17.type == DROP_TYPE_EQUIPMENT_SKIN then
				setActive(arg0_17:findTF("specialFrame", var2_17), true)
			else
				setActive(arg0_17:findTF("specialFrame", var2_17), false)
			end

			onButton(arg0_17, var2_17, function()
				arg0_17:emit(BaseUI.ON_DROP, var5_17)
			end, SFX_PANEL)
		end
	end
end

function var0_0.UpdateTaskData(arg0_19)
	local var0_19 = getProxy(ActivityProxy):getActivityById(ActivityConst.TOLOVE_TASK_ID)

	arg0_19.taskVOs = {}

	if var0_19 and not var0_19:isEnd() then
		local var1_19 = var0_19:getConfig("config_data")

		for iter0_19, iter1_19 in pairs(var1_19) do
			table.insert(arg0_19.taskVOs, getProxy(TaskProxy):getTaskVO(iter1_19))
		end
	end
end

function var0_0.getTaskProgress(arg0_20, arg1_20)
	for iter0_20, iter1_20 in ipairs(var1_0) do
		if iter1_20[1] == arg1_20:getConfig("type") and iter1_20[2] == arg1_20:getConfig("sub_type") then
			return arg1_20:getProgress() / 1000, string.format("%.2d", arg1_20:getProgress() / 1000)
		end
	end

	return arg1_20:getProgress(), tostring(arg1_20:getProgress())
end

function var0_0.getTaskTarget(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(var1_0) do
		if iter1_21[1] == arg1_21:getConfig("type") and iter1_21[2] == arg1_21:getConfig("sub_type") then
			return arg1_21:getConfig("target_num") / 1000, string.format("%.2d", arg1_21:getConfig("target_num") / 1000)
		end
	end

	return arg1_21:getConfig("target_num"), tostring(arg1_21:getConfig("target_num"))
end

function var0_0.willExit(arg0_22)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_22._tf)
end

return var0_0
