local var0 = class("InviterPage")

var0.REFRESH_TIME = 1800

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._event = arg2
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.ptTxt = arg0._tf:Find("pt_panel/slider/Text"):GetComponent(typeof(Text))
	arg0.phaseTotalTxt = arg0._tf:Find("pt_panel/total_progress"):GetComponent(typeof(Text))
	arg0.phaseTxt = arg0._tf:Find("pt_panel/progress"):GetComponent(typeof(Text))
	arg0.progress = arg0._tf:Find("pt_panel/slider")
	arg0.getBtn = arg0._tf:Find("pt_panel/get")
	arg0.awardTF = arg0._tf:Find("pt_panel/item")
	arg0.awardOverView = arg0._tf:Find("pt_panel/award_overview")
	arg0.bg = arg0._tf:Find("bg"):GetComponent(typeof(Image))
	arg0.returnerList = UIItemList.New(arg0._tf:Find("returners/content"), arg0._tf:Find("returners/content/tpl"))
	arg0.help = arg0._tf:Find("help")
	arg0.pushBtn = arg0._tf:Find("push_btn")
	arg0.pushedBtn = arg0._tf:Find("pushed_btn")
	arg0.pushDisBtn = arg0._tf:Find("push_btn_dis")
	arg0.codeTxt = arg0._tf:Find("code"):GetComponent(typeof(Text))
	arg0.taskLockPanel = arg0._tf:Find("task_lock_panel")
	arg0.taskPanel = arg0._tf:Find("task_panel")
	arg0.taskItemTF = arg0._tf:Find("task_panel/item")
	arg0.taskProgress = arg0._tf:Find("task_panel/progress")
	arg0.taskDesc = arg0._tf:Find("task_panel/desc")
	arg0.taskGoBtn = arg0._tf:Find("task_panel/go")
	arg0.taskGotBtn = arg0._tf:Find("task_panel/got")
	arg0.taskGetBtn = arg0._tf:Find("task_panel/get")
	arg0.taskProgressTxt = arg0._tf:Find("task_panel/p"):GetComponent(typeof(Text))

	arg0:Init()
end

function var0.Init(arg0)
	onButton(arg0, arg0.getBtn, function()
		arg0._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			activity_id = arg0.activity.id,
			cmd = ActivityConst.RETURN_AWARD_OP_GET_AWARD,
			arg1 = arg0.nextTarget
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.awardOverView, function()
		arg0._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			cmd = ActivityConst.RETURN_AWARD_OP_SHOW_AWARD_OVERVIEW,
			arg1 = {
				dropList = arg0.config.drop_client,
				targets = arg0.config.target,
				fetchList = arg0.fetchList,
				count = arg0.pt,
				resId = arg0.config.pt
			}
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.pushBtn, function()
		if arg0.isPush then
			return
		end

		if not arg0.returners or #arg0.returners >= 3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("returner_max_count"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("returner_push_tip"),
			onYes = function()
				arg0._event:emit(ActivityMediator.RETURN_AWARD_OP, {
					activity_id = arg0.activity.id,
					cmd = ActivityConst.RETURN_AWARD_OP_PUSH_UID,
					arg1 = arg0.code
				})
			end
		})
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1)
	arg0.activity = arg1

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	if not ActivityMainScene.FetchReturnersTime or var0 >= ActivityMainScene.FetchReturnersTime then
		ActivityMainScene.FetchReturnersTime = var0 + var0.REFRESH_TIME

		arg0._event:emit(ActivityMediator.RETURN_AWARD_OP, {
			activity_id = arg0.activity.id,
			cmd = ActivityConst.RETURN_AWARD_OP_GET_RETRUNERS
		})

		return
	end

	arg0:UpdateData()
	arg0:UpdateUI()
	arg0:UpdateReturners()
end

function var0.getTotalPt(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.returners) do
		var0 = var0 + iter1:getPt()
	end

	return var0 + arg1
end

function var0.UpdateData(arg0)
	local var0 = arg0.activity

	arg0.isPush = var0.data2_list[1] == 1
	arg0.code = getProxy(PlayerProxy):getRawData().id
	arg0.fetchList = var0.data1_list
	arg0.config = pg.activity_template_headhunting[var0.id]
	arg0.targets = arg0.config.target
	arg0.nextIndex = -1

	for iter0 = 1, #arg0.targets do
		local var1 = arg0.targets[iter0]

		if not table.contains(arg0.fetchList, var1) then
			arg0.nextIndex = iter0

			break
		end
	end

	if arg0.nextIndex == -1 then
		arg0.fetchIndex = #arg0.targets
		arg0.nextIndex = #arg0.targets
	else
		arg0.fetchIndex = math.max(arg0.nextIndex - 1, 0)
	end

	arg0.drops = arg0.config.drop_client
	arg0.nextDrops = arg0.config.drop_client[arg0.nextIndex]
	arg0.nextTarget = arg0.targets[arg0.nextIndex]
	arg0.returners = var0:getClientList()

	local var2 = var0.data3

	arg0.pt = arg0:getTotalPt(var2)

	setActive(arg0.pushBtn, not arg0.isPush and #arg0.returners < 3)
	setActive(arg0.pushedBtn, arg0.isPush)
	setActive(arg0.pushDisBtn, not arg0.isPush and #arg0.returners >= 3)
end

function var0.UpdateUI(arg0)
	arg0.codeTxt.text = arg0.code
	arg0.ptTxt.text = arg0.pt .. "/" .. arg0.nextTarget

	setActive(arg0.getBtn, arg0.fetchIndex ~= #arg0.targets and arg0.pt >= arg0.nextTarget)

	arg0.phaseTxt.text = arg0.fetchIndex
	arg0.phaseTotalTxt.text = #arg0.targets

	setFillAmount(arg0.progress, arg0.pt / arg0.nextTarget)

	local var0 = arg0.nextDrops

	updateDrop(arg0.awardTF, {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	})

	local var1 = pg.activity_template_headhunting[arg0.activity.id].tasklist

	arg0:UpdateTasks(var1)
end

function var0.getTask(arg0, arg1)
	local var0 = getProxy(TaskProxy)

	return var0:getTaskById(arg1) or var0:getFinishTaskById(arg1)
end

function var0.UpdateTasks(arg0, arg1)
	if arg0.isPush then
		local var0 = arg0.activity
		local var1 = var0:getDayIndex()
		local var2 = getProxy(TaskProxy)
		local var3 = 0

		for iter0 = #arg1, 1, -1 do
			if arg0:getTask(arg1[iter0]) then
				var3 = iter0

				break
			end
		end

		local var4 = arg0:getTask(arg1[var3])

		if (not var4 or var4:isReceive()) and var3 < var1 then
			if var3 == #arg1 and var4 and var4:isReceive() then
				arg0:UpdateTaskTF(var4)
			else
				arg0._event:emit(ActivityMediator.RETURN_AWARD_OP, {
					activity_id = var0.id,
					cmd = ActivityConst.RETURN_AWARD_OP_ACCEPT_TASK
				})
			end
		else
			assert(var4)
			arg0:UpdateTaskTF(var4)
		end
	else
		setActive(arg0.taskPanel, false)
		setActive(arg0.taskLockPanel, true)
	end
end

function var0.UpdateTaskTF(arg0, arg1)
	setActive(arg0.taskLockPanel, false)
	setActive(arg0.taskPanel, true)

	local var0 = arg1:isFinish()
	local var1 = arg1:isReceive()

	setActive(arg0.taskGoBtn, arg1 and not var0)
	setActive(arg0.taskGotBtn, arg1 and var1)
	setActive(arg0.taskGetBtn, arg1 and var0 and not var1)

	local var2 = arg1:getConfig("award_display")[1]

	updateDrop(arg0.taskItemTF, {
		type = var2[1],
		id = var2[2],
		count = var2[3]
	})
	setFillAmount(arg0.taskProgress, arg1:getProgress() / arg1:getConfig("target_num"))
	setText(arg0.taskDesc, arg1:getConfig("desc"))

	arg0.taskProgressTxt.text = arg1:getProgress() .. "/" .. arg1:getConfig("target_num")

	onButton(arg0, arg0.taskGoBtn, function()
		arg0._event:emit(ActivityMediator.ON_TASK_GO, arg1)
	end, SFX_PANEL)
	onButton(arg0, arg0.taskGetBtn, function()
		arg0._event:emit(ActivityMediator.ON_TASK_SUBMIT, arg1)
	end, SFX_PANEL)
end

local function var1(arg0, arg1)
	LoadSpriteAsync("qicon/" .. arg1:getPainting(), function(arg0)
		if not IsNil(arg0) then
			arg0:GetComponent(typeof(Image)).sprite = arg0
		end
	end)
	UIItemList.New(arg0:Find("starts"), arg0:Find("starts/tpl")):align(arg1:getStar())
end

function var0.UpdateReturners(arg0)
	local var0 = arg0.returners

	arg0.returnerList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			if var0 then
				local var1 = var0:getIcon()
				local var2 = Ship.New({
					configId = var1
				})

				var1(arg2:Find("info/icon"), var2)
				setText(arg2:Find("info/name"), var0:getName())
				setText(arg2:Find("info/pt/Text"), var0:getPt())
			end

			setActive(arg2:Find("empty"), not var0)
			setActive(arg2:Find("info"), var0)
		end
	end)
	arg0.returnerList:align(2)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	arg0.bg.sprite = nil
end

return var0
