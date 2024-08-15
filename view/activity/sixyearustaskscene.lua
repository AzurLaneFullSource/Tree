local var0_0 = class("SixYearUsTaskScene", import("view.base.BaseUI"))
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
	return "SixYearUsTaskPage"
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

			local var1_10, var2_10 = arg0_9:getTaskProgress(var0_10)
			local var3_10, var4_10 = arg0_9:getTaskTarget(var0_10)
			local var5_10 = math.min(var1_10, var3_10)

			setText(arg2_10:Find("frame/progress"), var2_10 .. "/" .. var4_10)

			arg2_10:Find("frame/slider"):GetComponent(typeof(Slider)).value = var5_10 / var3_10

			local var6_10 = arg2_10:Find("frame/awards")
			local var7_10 = var6_10:GetChild(0)

			arg0_9:updateAwards(var0_10:getConfig("award_display"), var6_10, var7_10)

			local var8_10 = arg2_10:Find("frame/go_btn")
			local var9_10 = arg2_10:Find("frame/get_btn")
			local var10_10 = arg2_10:Find("frame/got_btn")

			if var0_10:getTaskStatus() == 0 then
				setActive(var8_10, true)
				setActive(var9_10, false)
				setActive(var10_10, false)
			elseif var0_10:getTaskStatus() == 1 then
				setActive(var8_10, false)
				setActive(var9_10, true)
				setActive(var10_10, false)
			elseif var0_10:getTaskStatus() == 2 then
				setActive(var8_10, false)
				setActive(var9_10, false)
				setActive(var10_10, true)
			end

			onButton(arg0_9, var8_10, function()
				arg0_9:emit(SixYearUsTaskMediator.ON_TASK_GO, var0_10)
			end, SFX_PANEL)
			onButton(arg0_9, var9_10, function()
				arg0_9:checkAwardOverFlow({
					var0_10
				}, function()
					arg0_9:emit(SixYearUsTaskMediator.ON_TASK_SUBMIT, var0_10)
				end)
			end, SFX_PANEL)
		end
	end)
	arg0_9.UIlist:align(#arg1_9)

	if arg0_9.canGetAward then
		setActive(arg0_9.getBtn, true)
		onButton(arg0_9, arg0_9.getBtn, function()
			arg0_9:checkAwardOverFlow(arg0_9.canGetTaskVOs, function()
				arg0_9:emit(SixYearUsTaskMediator.ON_TASK_SUBMIT_ONESTEP, arg0_9.canGetTaskIds)
			end)
		end, SFX_PANEL)
	else
		setActive(arg0_9.getBtn, false)
		removeOnButton(arg0_9.getBtn)
	end
end

function var0_0.checkAwardOverFlow(arg0_16, arg1_16, arg2_16)
	local var0_16 = {}
	local var1_16 = {}

	for iter0_16, iter1_16 in pairs(arg1_16) do
		local var2_16 = iter1_16:getConfig("award_display")

		for iter2_16, iter3_16 in ipairs(var2_16) do
			local var3_16 = iter3_16
			local var4_16 = false

			for iter4_16, iter5_16 in pairs(var1_16) do
				if iter5_16[1] == var3_16[1] and iter5_16[2] == var3_16[2] then
					var4_16 = true
					iter5_16[3] = iter5_16[3] + var3_16[3]

					break
				end
			end

			if not var4_16 then
				table.insert(var1_16, {
					var3_16[1],
					var3_16[2],
					var3_16[3]
				})
			end
		end
	end

	local var5_16 = 0

	for iter6_16, iter7_16 in ipairs(var1_16) do
		if iter7_16[2] == var2_0 then
			var5_16 = iter7_16[3]
		end
	end

	local var6_16, var7_16 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_TOWN):IsOverGold(var5_16)
	local var8_16

	if var6_16 then
		var8_16 = {
			id = var2_0,
			type = DROP_TYPE_VITEM,
			count = "<color=#FF5C5CFF>" .. math.abs(var7_16) .. "</color>"
		}
	end

	local var9_16 = getProxy(PlayerProxy):getRawData()
	local var10_16 = pg.gameset.urpt_chapter_max.description[1]
	local var11_16 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var10_16)
	local var12_16, var13_16 = Task.StaticJudgeOverflow(var9_16.gold, var9_16.oil, var11_16, true, true, var1_16)

	var13_16 = var13_16 or {}

	if var8_16 then
		table.insert(var13_16, var8_16)
	end

	if var12_16 or var6_16 then
		table.insert(var0_16, function(arg0_17)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("award_max_warning"),
				items = var13_16,
				onYes = arg0_17
			})
		end)
	end

	seriesAsync(var0_16, arg2_16)
end

function var0_0.updateAwards(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = _.slice(arg1_18, 1, 3)

	for iter0_18 = arg2_18.childCount, #var0_18 - 1 do
		cloneTplTo(arg3_18, arg2_18)
	end

	local var1_18 = arg2_18.childCount

	for iter1_18 = 1, var1_18 do
		local var2_18 = arg2_18:GetChild(iter1_18 - 1)
		local var3_18 = iter1_18 <= #var0_18

		setActive(var2_18, var3_18)

		if var3_18 then
			local var4_18 = var0_18[iter1_18]
			local var5_18 = {
				type = var4_18[1],
				id = var4_18[2],
				count = var4_18[3]
			}

			updateDrop(arg0_18:findTF("mask", var2_18), var5_18)

			if var5_18.type == DROP_TYPE_EQUIPMENT_SKIN then
				setActive(arg0_18:findTF("specialFrame", var2_18), true)
			else
				setActive(arg0_18:findTF("specialFrame", var2_18), false)
			end

			onButton(arg0_18, var2_18, function()
				arg0_18:emit(BaseUI.ON_DROP, var5_18)
			end, SFX_PANEL)
		end
	end
end

function var0_0.UpdateTaskData(arg0_20)
	local var0_20 = getProxy(ActivityProxy):getActivityById(ActivityConst.SIX_YEAR_US_TASK_ACT_ID)
	local var1_20 = getProxy(ActivityProxy):getActivityById(ActivityConst.SIX_YEAR_US_TASK_2_ACT_ID)

	arg0_20.taskVOs = {}

	if var0_20 and not var0_20:isEnd() then
		local var2_20 = var0_20:getConfig("config_data")

		for iter0_20, iter1_20 in pairs(var2_20) do
			table.insert(arg0_20.taskVOs, getProxy(TaskProxy):getTaskVO(iter1_20))
		end
	end

	if var1_20 and not var1_20:isEnd() then
		local var3_20 = var1_20:getConfig("config_data")

		for iter2_20, iter3_20 in pairs(var3_20) do
			table.insert(arg0_20.taskVOs, getProxy(TaskProxy):getTaskVO(iter3_20))
		end
	end
end

function var0_0.getTaskProgress(arg0_21, arg1_21)
	for iter0_21, iter1_21 in ipairs(var1_0) do
		if iter1_21[1] == arg1_21:getConfig("type") and iter1_21[2] == arg1_21:getConfig("sub_type") then
			return arg1_21:getProgress() / 1000, string.format("%.2d", arg1_21:getProgress() / 1000)
		end
	end

	return arg1_21:getProgress(), tostring(arg1_21:getProgress())
end

function var0_0.getTaskTarget(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(var1_0) do
		if iter1_22[1] == arg1_22:getConfig("type") and iter1_22[2] == arg1_22:getConfig("sub_type") then
			return arg1_22:getConfig("target_num") / 1000, string.format("%.2d", arg1_22:getConfig("target_num") / 1000)
		end
	end

	return arg1_22:getConfig("target_num"), tostring(arg1_22:getConfig("target_num"))
end

function var0_0.willExit(arg0_23)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_23._tf)
end

return var0_0
