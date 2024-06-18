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
	arg0_1.taskPanel = arg0_1._tf:Find("task_panel")
	arg0_1.taskItemTF = arg0_1._tf:Find("task_panel/item")
	arg0_1.taskProgress = arg0_1._tf:Find("task_panel/progress")
	arg0_1.taskDesc = arg0_1._tf:Find("task_panel/desc")
	arg0_1.taskGoBtn = arg0_1._tf:Find("task_panel/go")
	arg0_1.taskGotBtn = arg0_1._tf:Find("task_panel/got")
	arg0_1.taskGetBtn = arg0_1._tf:Find("task_panel/get")
	arg0_1.taskProgressTxt = arg0_1._tf:Find("task_panel/p"):GetComponent(typeof(Text))

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

	updateDrop(arg0_10.awardTF, {
		type = var0_10[1],
		id = var0_10[2],
		count = var0_10[3]
	})

	local var1_10 = pg.activity_template_headhunting[arg0_10.activity.id].tasklist

	arg0_10:UpdateTasks(var1_10)
end

function var0_0.getTask(arg0_11, arg1_11)
	local var0_11 = getProxy(TaskProxy)

	return var0_11:getTaskById(arg1_11) or var0_11:getFinishTaskById(arg1_11)
end

function var0_0.UpdateTasks(arg0_12, arg1_12)
	if arg0_12.isPush then
		local var0_12 = arg0_12.activity
		local var1_12 = var0_12:getDayIndex()
		local var2_12 = getProxy(TaskProxy)
		local var3_12 = 0

		for iter0_12 = #arg1_12, 1, -1 do
			if arg0_12:getTask(arg1_12[iter0_12]) then
				var3_12 = iter0_12

				break
			end
		end

		local var4_12 = arg0_12:getTask(arg1_12[var3_12])

		if (not var4_12 or var4_12:isReceive()) and var3_12 < var1_12 then
			if var3_12 == #arg1_12 and var4_12 and var4_12:isReceive() then
				arg0_12:UpdateTaskTF(var4_12)
			else
				arg0_12._event:emit(ActivityMediator.RETURN_AWARD_OP, {
					activity_id = var0_12.id,
					cmd = ActivityConst.RETURN_AWARD_OP_ACCEPT_TASK
				})
			end
		else
			assert(var4_12)
			arg0_12:UpdateTaskTF(var4_12)
		end
	else
		setActive(arg0_12.taskPanel, false)
		setActive(arg0_12.taskLockPanel, true)
	end
end

function var0_0.UpdateTaskTF(arg0_13, arg1_13)
	setActive(arg0_13.taskLockPanel, false)
	setActive(arg0_13.taskPanel, true)

	local var0_13 = arg1_13:isFinish()
	local var1_13 = arg1_13:isReceive()

	setActive(arg0_13.taskGoBtn, arg1_13 and not var0_13)
	setActive(arg0_13.taskGotBtn, arg1_13 and var1_13)
	setActive(arg0_13.taskGetBtn, arg1_13 and var0_13 and not var1_13)

	local var2_13 = arg1_13:getConfig("award_display")[1]

	updateDrop(arg0_13.taskItemTF, {
		type = var2_13[1],
		id = var2_13[2],
		count = var2_13[3]
	})
	setFillAmount(arg0_13.taskProgress, arg1_13:getProgress() / arg1_13:getConfig("target_num"))
	setText(arg0_13.taskDesc, arg1_13:getConfig("desc"))

	arg0_13.taskProgressTxt.text = arg1_13:getProgress() .. "/" .. arg1_13:getConfig("target_num")

	onButton(arg0_13, arg0_13.taskGoBtn, function()
		arg0_13._event:emit(ActivityMediator.ON_TASK_GO, arg1_13)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.taskGetBtn, function()
		arg0_13._event:emit(ActivityMediator.ON_TASK_SUBMIT, arg1_13)
	end, SFX_PANEL)
end

local function var1_0(arg0_16, arg1_16)
	LoadSpriteAsync("qicon/" .. arg1_16:getPainting(), function(arg0_17)
		if not IsNil(arg0_16) then
			arg0_16:GetComponent(typeof(Image)).sprite = arg0_17
		end
	end)
	UIItemList.New(arg0_16:Find("starts"), arg0_16:Find("starts/tpl")):align(arg1_16:getStar())
end

function var0_0.UpdateReturners(arg0_18)
	local var0_18 = arg0_18.returners

	arg0_18.returnerList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var0_18[arg1_19 + 1]

			if var0_19 then
				local var1_19 = var0_19:getIcon()
				local var2_19 = Ship.New({
					configId = var1_19
				})

				var1_0(arg2_19:Find("info/icon"), var2_19)
				setText(arg2_19:Find("info/name"), var0_19:getName())
				setText(arg2_19:Find("info/pt/Text"), var0_19:getPt())
			end

			setActive(arg2_19:Find("empty"), not var0_19)
			setActive(arg2_19:Find("info"), var0_19)
		end
	end)
	arg0_18.returnerList:align(2)
end

function var0_0.Dispose(arg0_20)
	pg.DelegateInfo.Dispose(arg0_20)

	arg0_20.bg.sprite = nil
end

return var0_0
