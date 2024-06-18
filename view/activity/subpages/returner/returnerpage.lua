local var0_0 = class("ReturnerPage")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1._event = arg2_1
	arg0_1.bg = arg0_1._tf:Find("bg"):GetComponent(typeof(Image))
	arg0_1.input = arg0_1._tf:Find("InputField")
	arg0_1.inputPlaceholder = arg0_1._tf:Find("InputField/Placeholder"):GetComponent(typeof(Text))
	arg0_1.confirmBtn = arg0_1._tf:Find("confim_btn")
	arg0_1.taskUIlist = UIItemList.New(arg0_1._tf:Find("task_list"), arg0_1._tf:Find("task_list/tpl"))
	arg0_1.totalProgress = arg0_1._tf:Find("total_progress"):GetComponent(typeof(Text))
	arg0_1.progress = arg0_1._tf:Find("progress"):GetComponent(typeof(Text))
	arg0_1.awrdOverviewBtn = arg0_1._tf:Find("award_overview")
	arg0_1.help = arg0_1._tf:Find("help")
	arg0_1.ptTxt = arg0_1._tf:Find("pt"):GetComponent(typeof(Text))
	arg0_1.matchBtn = arg0_1._tf:Find("match_btn")
	arg0_1.matchedBtn = arg0_1._tf:Find("matched_btn")

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.confirmBtn, function()
		if arg0_2.code ~= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("return_have_participated_in_act"))

			return
		end

		local var0_3 = getInputText(arg0_2.input)

		if not var0_3 or var0_3 == "" then
			return
		end

		if tonumber(var0_3) > 2147483647 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_notExist"))

			return
		end

		arg0_2._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			activity_id = arg0_2.activity.id,
			cmd = ActivityConst.RETURN_AWARD_OP_SET_RETRUNER,
			arg1 = tonumber(var0_3)
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.awrdOverviewBtn, function()
		arg0_2._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			cmd = ActivityConst.RETURN_AWARD_OP_SHOW_RETURNER_AWARD_OVERVIEW,
			arg1 = {
				tasklist = arg0_2.config.task_list,
				ptId = pg.activity_template_headhunting[arg0_2.activity.id].pt,
				totalPt = arg0_2.pt,
				index = arg0_2.taskIndex
			}
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.matchBtn, function()
		if arg0_2.code ~= 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("returner_match_tip"),
			onYes = function()
				arg0_2._event:emit(ActivityMediator.RETURN_AWARD_OP, {
					activity_id = arg0_2.activity.id,
					cmd = ActivityConst.RETURN_AWARD_OP_MATCH
				})
			end
		})
	end, SFX_PANEL)
end

function var0_0.Update(arg0_7, arg1_7)
	arg0_7.activity = arg1_7

	arg0_7:UpdateData()

	if arg0_7:ShouldAcceptTasks() then
		arg0_7:AcceptTasks()
	else
		arg0_7:UpdateTasks()
	end

	local var0_7 = arg0_7.code ~= 0

	if not var0_7 then
		arg0_7.inputPlaceholder.text = i18n("input_returner_code")
	else
		arg0_7.inputPlaceholder.text = arg0_7.code

		setInputText(arg0_7.input, "")
	end

	arg0_7.input:GetComponent(typeof(InputField)).interactable = not var0_7

	setActive(arg0_7.matchBtn, not var0_7)
	setActive(arg0_7.matchedBtn, var0_7)
end

function var0_0.ShouldAcceptTasks(arg0_8)
	if arg0_8.code == 0 then
		return false
	end

	if arg0_8.taskIndex == 0 then
		return true
	end

	local var0_8 = arg0_8.config.task_list
	local var1_8 = getProxy(TaskProxy)
	local var2_8 = _.all(var0_8[arg0_8.taskIndex], function(arg0_9)
		return var1_8:getFinishTaskById(arg0_9) ~= nil
	end)
	local var3_8 = _.all(var0_8[arg0_8.taskIndex], function(arg0_10)
		return var1_8:getTaskById(arg0_10) == nil and var1_8:getFinishTaskById(arg0_10) == nil
	end)
	local var4_8 = arg0_8.taskIndex == #var0_8

	local function var5_8()
		return arg0_8.day > arg0_8.taskIndex
	end

	return var3_8 or var2_8 and not var4_8 and var5_8()
end

function var0_0.AcceptTasks(arg0_12)
	arg0_12._event:emit(ActivityMediator.RETURN_AWARD_OP, {
		activity_id = arg0_12.activity.id,
		cmd = ActivityConst.RETURN_AWARD_OP_RETURNER_GET_AWARD
	})
end

function var0_0.UpdateData(arg0_13)
	local var0_13 = arg0_13.activity

	arg0_13.config = pg.activity_template_returnner[var0_13.id]
	arg0_13.code = var0_13.data2

	local var1_13 = pg.activity_template_headhunting[var0_13.id]

	arg0_13.pt = var0_13.data3
	arg0_13.taskIndex = var0_13.data4
	arg0_13.ptTxt.text = arg0_13.pt

	local var2_13 = pg.TimeMgr.GetInstance():GetServerTime()

	arg0_13.day = pg.TimeMgr.GetInstance():DiffDay(var0_13:getStartTime(), var2_13) + 1
end

local function var1_0(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg2_14:getConfig("award_display")[1]

	updateDrop(arg1_14:Find("item"), {
		type = var0_14[1],
		id = var0_14[2],
		count = var0_14[3]
	})
	setText(arg1_14:Find("desc"), arg2_14:getConfig("desc"))
	setFillAmount(arg1_14:Find("slider"), arg2_14:getProgress() / arg2_14:getConfig("target_num"))

	local var1_14 = arg1_14:Find("go")
	local var2_14 = arg1_14:Find("get")
	local var3_14 = arg1_14:Find("got")

	setActive(var1_14, not arg2_14:isFinish())
	setActive(var2_14, arg2_14:isFinish() and not arg2_14:isReceive())
	setActive(var3_14, arg2_14:isReceive())
	onButton(arg0_14, var1_14, function()
		arg0_14._event:emit(ActivityMediator.ON_TASK_GO, arg2_14)
	end, SFX_PANEL)
	onButton(arg0_14, var2_14, function()
		arg0_14._event:emit(ActivityMediator.ON_TASK_SUBMIT, arg2_14)
	end, SFX_PANEL)
end

function var0_0.UpdateTasks(arg0_17)
	local var0_17 = arg0_17.config.task_list
	local var1_17 = var0_17[arg0_17.taskIndex] or {}

	arg0_17.taskUIlist:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var1_17[arg1_18 + 1]
			local var1_18 = getProxy(TaskProxy)
			local var2_18 = var1_18:getTaskById(var0_18) or var1_18:getFinishTaskById(var0_18)

			assert(var2_18)
			var1_0(arg0_17, arg2_18, var2_18)
		end
	end)
	arg0_17.taskUIlist:align(#var1_17)

	arg0_17.totalProgress.text = #var0_17
	arg0_17.progress.text = arg0_17.taskIndex
end

function var0_0.Dispose(arg0_19)
	pg.DelegateInfo.Dispose(arg0_19)

	arg0_19.bg.sprite = nil
end

return var0_0
