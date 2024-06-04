local var0 = class("ReturnerPage")

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0._event = arg2
	arg0.bg = arg0._tf:Find("bg"):GetComponent(typeof(Image))
	arg0.input = arg0._tf:Find("InputField")
	arg0.inputPlaceholder = arg0._tf:Find("InputField/Placeholder"):GetComponent(typeof(Text))
	arg0.confirmBtn = arg0._tf:Find("confim_btn")
	arg0.taskUIlist = UIItemList.New(arg0._tf:Find("task_list"), arg0._tf:Find("task_list/tpl"))
	arg0.totalProgress = arg0._tf:Find("total_progress"):GetComponent(typeof(Text))
	arg0.progress = arg0._tf:Find("progress"):GetComponent(typeof(Text))
	arg0.awrdOverviewBtn = arg0._tf:Find("award_overview")
	arg0.help = arg0._tf:Find("help")
	arg0.ptTxt = arg0._tf:Find("pt"):GetComponent(typeof(Text))
	arg0.matchBtn = arg0._tf:Find("match_btn")
	arg0.matchedBtn = arg0._tf:Find("matched_btn")

	arg0:Init()
end

function var0.Init(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.code ~= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("return_have_participated_in_act"))

			return
		end

		local var0 = getInputText(arg0.input)

		if not var0 or var0 == "" then
			return
		end

		if tonumber(var0) > 2147483647 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_notExist"))

			return
		end

		arg0._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			activity_id = arg0.activity.id,
			cmd = ActivityConst.RETURN_AWARD_OP_SET_RETRUNER,
			arg1 = tonumber(var0)
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.awrdOverviewBtn, function()
		arg0._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			cmd = ActivityConst.RETURN_AWARD_OP_SHOW_RETURNER_AWARD_OVERVIEW,
			arg1 = {
				tasklist = arg0.config.task_list,
				ptId = pg.activity_template_headhunting[arg0.activity.id].pt,
				totalPt = arg0.pt,
				index = arg0.taskIndex
			}
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.matchBtn, function()
		if arg0.code ~= 0 then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("returner_match_tip"),
			onYes = function()
				arg0._event:emit(ActivityMediator.RETURN_AWARD_OP, {
					activity_id = arg0.activity.id,
					cmd = ActivityConst.RETURN_AWARD_OP_MATCH
				})
			end
		})
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1)
	arg0.activity = arg1

	arg0:UpdateData()

	if arg0:ShouldAcceptTasks() then
		arg0:AcceptTasks()
	else
		arg0:UpdateTasks()
	end

	local var0 = arg0.code ~= 0

	if not var0 then
		arg0.inputPlaceholder.text = i18n("input_returner_code")
	else
		arg0.inputPlaceholder.text = arg0.code

		setInputText(arg0.input, "")
	end

	arg0.input:GetComponent(typeof(InputField)).interactable = not var0

	setActive(arg0.matchBtn, not var0)
	setActive(arg0.matchedBtn, var0)
end

function var0.ShouldAcceptTasks(arg0)
	if arg0.code == 0 then
		return false
	end

	if arg0.taskIndex == 0 then
		return true
	end

	local var0 = arg0.config.task_list
	local var1 = getProxy(TaskProxy)
	local var2 = _.all(var0[arg0.taskIndex], function(arg0)
		return var1:getFinishTaskById(arg0) ~= nil
	end)
	local var3 = _.all(var0[arg0.taskIndex], function(arg0)
		return var1:getTaskById(arg0) == nil and var1:getFinishTaskById(arg0) == nil
	end)
	local var4 = arg0.taskIndex == #var0

	local function var5()
		return arg0.day > arg0.taskIndex
	end

	return var3 or var2 and not var4 and var5()
end

function var0.AcceptTasks(arg0)
	arg0._event:emit(ActivityMediator.RETURN_AWARD_OP, {
		activity_id = arg0.activity.id,
		cmd = ActivityConst.RETURN_AWARD_OP_RETURNER_GET_AWARD
	})
end

function var0.UpdateData(arg0)
	local var0 = arg0.activity

	arg0.config = pg.activity_template_returnner[var0.id]
	arg0.code = var0.data2

	local var1 = pg.activity_template_headhunting[var0.id]

	arg0.pt = var0.data3
	arg0.taskIndex = var0.data4
	arg0.ptTxt.text = arg0.pt

	local var2 = pg.TimeMgr.GetInstance():GetServerTime()

	arg0.day = pg.TimeMgr.GetInstance():DiffDay(var0:getStartTime(), var2) + 1
end

local function var1(arg0, arg1, arg2)
	local var0 = arg2:getConfig("award_display")[1]

	updateDrop(arg1:Find("item"), {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	})
	setText(arg1:Find("desc"), arg2:getConfig("desc"))
	setFillAmount(arg1:Find("slider"), arg2:getProgress() / arg2:getConfig("target_num"))

	local var1 = arg1:Find("go")
	local var2 = arg1:Find("get")
	local var3 = arg1:Find("got")

	setActive(var1, not arg2:isFinish())
	setActive(var2, arg2:isFinish() and not arg2:isReceive())
	setActive(var3, arg2:isReceive())
	onButton(arg0, var1, function()
		arg0._event:emit(ActivityMediator.ON_TASK_GO, arg2)
	end, SFX_PANEL)
	onButton(arg0, var2, function()
		arg0._event:emit(ActivityMediator.ON_TASK_SUBMIT, arg2)
	end, SFX_PANEL)
end

function var0.UpdateTasks(arg0)
	local var0 = arg0.config.task_list
	local var1 = var0[arg0.taskIndex] or {}

	arg0.taskUIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]
			local var1 = getProxy(TaskProxy)
			local var2 = var1:getTaskById(var0) or var1:getFinishTaskById(var0)

			assert(var2)
			var1(arg0, arg2, var2)
		end
	end)
	arg0.taskUIlist:align(#var1)

	arg0.totalProgress.text = #var0
	arg0.progress.text = arg0.taskIndex
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	arg0.bg.sprite = nil
end

return var0
