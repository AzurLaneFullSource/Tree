local var0_0 = class("InviterPage")

var0_0.REFRESH_TIME = 1800

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._event = arg2_1
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.ptTxt = arg0_1._tf:Find("pt_panel/slider/Text"):GetComponent(typeof(Text))
	arg0_1.phaseTotalTxt = arg0_1._tf:Find("pt_panel/total_progress"):GetComponent(typeof(Text))
	arg0_1.phaseTxt = arg0_1._tf:Find("pt_panel/progress"):GetComponent(typeof(Text))
	arg0_1.progress = arg0_1._tf:Find("pt_panel/slider")
	arg0_1.getBtn = arg0_1._tf:Find("pt_panel/get")
	arg0_1.awardTF = arg0_1._tf:Find("pt_panel/item")
	arg0_1.awardOverView = arg0_1._tf:Find("pt_panel/award_overview")
	arg0_1.bg = arg0_1._tf:Find("bg"):GetComponent(typeof(Image))
	arg0_1.returnerList = UIItemList.New(arg0_1._tf:Find("returners/content"), arg0_1._tf:Find("returners/content/tpl"))
	arg0_1.help = arg0_1._tf:Find("help")
	arg0_1.pushBtn = arg0_1._tf:Find("push_btn")
	arg0_1.pushedBtn = arg0_1._tf:Find("pushed_btn")
	arg0_1.pushDisBtn = arg0_1._tf:Find("push_btn_dis")
	arg0_1.codeTxt = arg0_1._tf:Find("code"):GetComponent(typeof(Text))
	arg0_1.taskLockPanel = arg0_1._tf:Find("task_lock_panel")

	setText(arg0_1.taskLockPanel:Find("Text"), i18n("word_sell_lock"))

	arg0_1.taskPanel = arg0_1._tf:Find("task_panel")
	arg0_1.taskItemTF = arg0_1._tf:Find("task_panel/item")
	arg0_1.taskProgress = arg0_1._tf:Find("task_panel/progress")
	arg0_1.taskDesc = arg0_1._tf:Find("task_panel/desc")
	arg0_1.taskGoBtn = arg0_1._tf:Find("task_panel/go")
	arg0_1.taskGotBtn = arg0_1._tf:Find("task_panel/got")
	arg0_1.taskGetBtn = arg0_1._tf:Find("task_panel/get")
	arg0_1.taskProgressTxt = arg0_1._tf:Find("task_panel/p"):GetComponent(typeof(Text))

	setText(arg0_1._tf:Find("pt_panel/title"), i18n("activity_return_reward_pt"))
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.getBtn, function()
		arg0_2._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			activity_id = arg0_2.activity.id,
			cmd = ActivityConst.RETURN_AWARD_OP_GET_AWARD,
			arg1 = arg0_2.nextTarget
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.awardOverView, function()
		arg0_2._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			cmd = ActivityConst.RETURN_AWARD_OP_SHOW_AWARD_OVERVIEW,
			arg1 = {
				blur = true,
				dropList = arg0_2.config.drop_client,
				targets = arg0_2.config.target,
				fetchList = arg0_2.fetchList,
				count = arg0_2.pt,
				resId = arg0_2.config.pt
			}
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.pushBtn, function()
		if arg0_2.isPush then
			return
		end

		if not arg0_2.returners or #arg0_2.returners >= 3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("returner_max_count"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("returner_push_tip"),
			onYes = function()
				arg0_2._event:emit(ActivityMediator.RETURN_AWARD_OP, {
					activity_id = arg0_2.activity.id,
					cmd = ActivityConst.RETURN_AWARD_OP_PUSH_UID,
					arg1 = arg0_2.code
				})
			end
		})
	end, SFX_PANEL)
end

function var0_0.Update(arg0_7, arg1_7)
	arg0_7.activity = arg1_7

	local var0_7 = pg.TimeMgr.GetInstance():GetServerTime()

	if not ActivityMainScene.FetchReturnersTime or var0_7 >= ActivityMainScene.FetchReturnersTime then
		ActivityMainScene.FetchReturnersTime = var0_7 + var0_0.REFRESH_TIME

		arg0_7._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			activity_id = arg0_7.activity.id,
			cmd = ActivityConst.RETURN_AWARD_OP_GET_RETRUNERS
		})

		return
	end

	arg0_7:UpdateData()
	arg0_7:UpdateUI()
	arg0_7:UpdateReturners()
end

function var0_0.getTotalPt(arg0_8, arg1_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in ipairs(arg0_8.returners) do
		var0_8 = var0_8 + iter1_8:getPt()
	end

	return var0_8 + arg1_8
end

function var0_0.UpdateData(arg0_9)
	local var0_9 = arg0_9.activity

	arg0_9.isPush = var0_9.data2_list[1] == 1
	arg0_9.code = getProxy(PlayerProxy):getRawData().id
	arg0_9.fetchList = var0_9.data1_list
	arg0_9.config = pg.activity_template_headhunting[var0_9.id]
	arg0_9.targets = arg0_9.config.target
	arg0_9.nextIndex = -1

	for iter0_9 = 1, #arg0_9.targets do
		local var1_9 = arg0_9.targets[iter0_9]

		if not table.contains(arg0_9.fetchList, var1_9) then
			arg0_9.nextIndex = iter0_9

			break
		end
	end

	if arg0_9.nextIndex == -1 then
		arg0_9.fetchIndex = #arg0_9.targets
		arg0_9.nextIndex = #arg0_9.targets
	else
		arg0_9.fetchIndex = math.max(arg0_9.nextIndex - 1, 0)
	end

	arg0_9.drops = arg0_9.config.drop_client
	arg0_9.nextDrops = arg0_9.config.drop_client[arg0_9.nextIndex]
	arg0_9.nextTarget = arg0_9.targets[arg0_9.nextIndex]
	arg0_9.returners = var0_9:getClientList()

	local var2_9 = var0_9.data3

	arg0_9.pt = arg0_9:getTotalPt(var2_9)

	setActive(arg0_9.pushBtn, not arg0_9.isPush and #arg0_9.returners < 3)
	setActive(arg0_9.pushedBtn, arg0_9.isPush)
	setActive(arg0_9.pushDisBtn, not arg0_9.isPush and #arg0_9.returners >= 3)
end

function var0_0.UpdateUI(arg0_10)
	arg0_10.codeTxt.text = arg0_10.code
	arg0_10.ptTxt.text = arg0_10.pt .. "/" .. arg0_10.nextTarget

	setActive(arg0_10.getBtn, arg0_10.fetchIndex ~= #arg0_10.targets and arg0_10.pt >= arg0_10.nextTarget)

	arg0_10.phaseTxt.text = arg0_10.fetchIndex
	arg0_10.phaseTotalTxt.text = #arg0_10.targets

	setFillAmount(arg0_10.progress, arg0_10.pt / arg0_10.nextTarget)

	local var0_10 = arg0_10.nextDrops
	local var1_10 = {
		type = var0_10[1],
		id = var0_10[2],
		count = var0_10[3]
	}

	updateDrop(arg0_10.awardTF, var1_10)
	onButton(arg0_10, arg0_10.awardTF, function()
		arg0_10._event:emit(BaseUI.ON_DROP, var1_10)
	end, SFX_PANEL)

	local var2_10 = pg.activity_template_headhunting[arg0_10.activity.id].tasklist

	arg0_10:UpdateTasks(var2_10)
end

function var0_0.getTask(arg0_12, arg1_12)
	local var0_12 = getProxy(TaskProxy)

	return var0_12:getTaskById(arg1_12) or var0_12:getFinishTaskById(arg1_12)
end

function var0_0.UpdateTasks(arg0_13, arg1_13)
	if arg0_13.isPush then
		local var0_13 = arg0_13.activity
		local var1_13 = var0_13:getDayIndex()
		local var2_13 = getProxy(TaskProxy)
		local var3_13 = 0

		for iter0_13 = #arg1_13, 1, -1 do
			if arg0_13:getTask(arg1_13[iter0_13]) then
				var3_13 = iter0_13

				break
			end
		end

		local var4_13 = arg0_13:getTask(arg1_13[var3_13])

		if (not var4_13 or var4_13:isReceive()) and var3_13 < var1_13 then
			if var3_13 == #arg1_13 and var4_13 and var4_13:isReceive() then
				arg0_13:UpdateTaskTF(var4_13)
			else
				arg0_13._event:emit(ActivityMediator.RETURN_AWARD_OP, {
					activity_id = var0_13.id,
					cmd = ActivityConst.RETURN_AWARD_OP_ACCEPT_TASK
				})
			end
		else
			assert(var4_13)
			arg0_13:UpdateTaskTF(var4_13)
		end
	else
		setActive(arg0_13.taskPanel, false)
		setActive(arg0_13.taskLockPanel, true)
	end
end

function var0_0.UpdateTaskTF(arg0_14, arg1_14)
	setActive(arg0_14.taskLockPanel, false)
	setActive(arg0_14.taskPanel, true)

	local var0_14 = arg1_14:isFinish()
	local var1_14 = arg1_14:isReceive()

	setActive(arg0_14.taskGoBtn, arg1_14 and not var0_14)
	setActive(arg0_14.taskGotBtn, arg1_14 and var1_14)
	setActive(arg0_14.taskGetBtn, arg1_14 and var0_14 and not var1_14)

	local var2_14 = arg1_14:getConfig("award_display")[1]
	local var3_14 = {
		type = var2_14[1],
		id = var2_14[2],
		count = var2_14[3]
	}

	updateDrop(arg0_14.taskItemTF, var3_14)
	onButton(arg0_14, arg0_14.taskItemTF, function()
		arg0_14._event:emit(BaseUI.ON_DROP, var3_14)
	end, SFX_PANEL)
	setFillAmount(arg0_14.taskProgress, arg1_14:getProgress() / arg1_14:getConfig("target_num"))
	setText(arg0_14.taskDesc, arg1_14:getConfig("desc"))

	arg0_14.taskProgressTxt.text = arg1_14:getProgress() .. "/" .. arg1_14:getConfig("target_num")

	onButton(arg0_14, arg0_14.taskGoBtn, function()
		arg0_14._event:emit(ActivityMediator.ON_TASK_GO, arg1_14)
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.taskGetBtn, function()
		arg0_14._event:emit(ActivityMediator.ON_TASK_SUBMIT, arg1_14)
	end, SFX_PANEL)
end

local function var1_0(arg0_18, arg1_18)
	LoadSpriteAsync("qicon/" .. arg1_18:getPainting(), function(arg0_19)
		if not IsNil(arg0_18) then
			arg0_18:GetComponent(typeof(Image)).sprite = arg0_19
		end
	end)
	UIItemList.New(arg0_18:Find("starts"), arg0_18:Find("starts/tpl")):align(arg1_18:getStar())
end

function var0_0.UpdateReturners(arg0_20)
	local var0_20 = arg0_20.returners

	arg0_20.returnerList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = var0_20[arg1_21 + 1]

			if var0_21 then
				local var1_21 = var0_21:getIcon()
				local var2_21 = Ship.New({
					configId = var1_21
				})

				var1_0(arg2_21:Find("info/icon"), var2_21)
				setText(arg2_21:Find("info/name"), var0_21:getName())
				setText(arg2_21:Find("info/pt/Text"), var0_21:getPt())
			end

			setActive(arg2_21:Find("empty"), not var0_21)
			setActive(arg2_21:Find("info"), var0_21)
		end
	end)
	arg0_20.returnerList:align(2)
end

function var0_0.Dispose(arg0_22)
	pg.DelegateInfo.Dispose(arg0_22)

	arg0_22.bg.sprite = nil
end

return var0_0
