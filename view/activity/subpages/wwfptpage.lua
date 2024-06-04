local var0 = class("WWFPtPage", import(".TemplatePage.PtTemplatePage"))
local var1 = 6000

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.helpBtn = arg0:findTF("help_btn", arg0.bg)
	arg0.collectBtn = arg0:findTF("collect_btn", arg0.bg)
	arg0.taskRedDot = arg0:findTF("red_dot", arg0.collectBtn)
	arg0.resNumTF = arg0:findTF("res_num", arg0.collectBtn)
	arg0.title = arg0:findTF("title", arg0.bg)
	arg0.tags = arg0:findTF("tags", arg0.bg)
	arg0.convertBtn = arg0:findTF("convert_btn", arg0.bg)
	arg0.switchBtn = arg0:findTF("switch_btn", arg0.bg)
	arg0.switchRedDot = arg0:findTF("red_dot", arg0.switchBtn)
	arg0.paintings = {
		arg0:findTF("paintings/ninghai", arg0.bg),
		arg0:findTF("paintings/pinghai", arg0.bg)
	}
	arg0.anim = arg0:findTF("anim", arg0.bg)
	arg0.ninghaiTF = arg0:findTF("anim/panda_anim/ninghai", arg0.bg)
	arg0.pinghaiTF = arg0:findTF("anim/panda_anim/pinghai", arg0.bg)
	arg0.heartImages = arg0:findTF("hearts", arg0.bg)
	arg0.step2 = arg0:findTF("step2", arg0.bg)
	arg0.taskWindow = arg0:findTF("TaskWindow")
	arg0.closeBtn = arg0:findTF("panel/close_btn", arg0.taskWindow)
	arg0.maskBtn = arg0:findTF("mask", arg0.taskWindow)
	arg0.item = arg0:findTF("panel/scrollview/item", arg0.taskWindow)
	arg0.items = arg0:findTF("panel/scrollview/items", arg0.taskWindow)
	arg0.uilist = UIItemList.New(arg0.items, arg0.item)
	arg0.typeImages = arg0:findTF("panel/tags", arg0.taskWindow)
	arg0.barImages = arg0:findTF("panel/bars", arg0.taskWindow)
	arg0.guide = arg0:findTF("Guide")
	arg0.guideTarget = arg0:findTF("target", arg0.guide)
	arg0.guideContent = arg0:findTF("dialogBox/content", arg0.guide)
end

function var0.OnDataSetting(arg0)
	arg0.titleTxts = {
		i18n("wwf_bamboo_tip1"),
		i18n("wwf_bamboo_tip2")
	}
	arg0.resID = arg0.activity:getConfig("config_client").convertRes
	arg0.subActivities = arg0.activity:getConfig("config_client").ptActID
	arg0.taskList = arg0.activity:getConfig("config_data")

	arg0:initPtData()
	arg0:initTaskData()
	arg0:initLocalData()
end

function var0.initPtData(arg0)
	arg0.subPtDate = {}

	for iter0, iter1 in ipairs(arg0.subActivities) do
		local var0 = getProxy(ActivityProxy):getActivityById(iter1)

		if arg0.subPtDate[iter1] then
			arg0.subPtDate[iter1]:Update(var0)
		else
			arg0.subPtDate[iter1] = ActivityPtData.New(var0)
		end
	end

	arg0.resNum = getProxy(PlayerProxy):getRawData():getResource(arg0.resID)
end

function var0.setPtActIndex(arg0)
	arg0.curActIndex = arg0.lastSelectIndex
	arg0.curSubActID = arg0.subActivities[arg0.curActIndex]

	local var0 = arg0.curActIndex == 1 and 2 or 1
	local var1 = arg0.subPtDate[arg0.curSubActID]:CanGetMorePt()
	local var2 = arg0.subPtDate[arg0.subActivities[var0]]:CanGetAward()

	if not var1 or var2 then
		arg0.curActIndex = var0
		arg0.curSubActID = arg0.subActivities[arg0.curActIndex]

		PlayerPrefs.SetInt("wwf_select_index_" .. arg0.playerId, arg0.lastSelectIndex)
		PlayerPrefs.Save()
	end
end

function var0.setStep2Progress(arg0)
	local var0 = arg0.subPtDate[arg0.curSubActID].count

	setImageSprite(arg0.step2, arg0.heartImages:Find(tostring(arg0.curActIndex)):GetComponent(typeof(Image)).sprite)

	arg0.step2:GetComponent(typeof(Image)).fillAmount = var0 / var1
end

function var0.initTaskData(arg0)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.curTask = {}
	arg0.todoTaskNum = 0

	for iter0, iter1 in ipairs(arg0.taskList) do
		local var0 = arg0.taskProxy:getTaskById(iter1) or arg0.taskProxy:getFinishTaskById(iter1)

		if var0 then
			table.insert(arg0.curTask, var0.id)

			if var0:getTaskStatus() == 0 then
				arg0.todoTaskNum = arg0.todoTaskNum + 1
			end
		end
	end
end

function var0.initLocalData(arg0)
	arg0.playerId = getProxy(PlayerProxy):getData().id
	arg0.isFirst = PlayerPrefs.GetInt("wwf_first_" .. arg0.playerId)

	if PlayerPrefs.GetInt("wwf_select_index_" .. arg0.playerId) == 0 then
		arg0.lastSelectIndex = 1
	else
		arg0.lastSelectIndex = PlayerPrefs.GetInt("wwf_select_index_" .. arg0.playerId)
	end

	arg0.showTaskRedDot = false

	local var0 = PlayerPrefs.GetInt("wwf_todo_task_num_" .. arg0.playerId)

	if (var0 == 0 and not arg0.todoTaskNum == 0 or var0 < arg0.todoTaskNum) and not arg0:isFinishAllAct() then
		arg0.showTaskRedDot = true
	end

	arg0.hasClickTask = false

	PlayerPrefs.SetInt("wwf_todo_task_num_" .. arg0.playerId, arg0.todoTaskNum)
	PlayerPrefs.Save()
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0.subPtDate[arg0.curSubActID].type,
			dropList = arg0.subPtDate[arg0.curSubActID].dropList,
			targets = arg0.subPtDate[arg0.curSubActID].targets,
			level = arg0.subPtDate[arg0.curSubActID].level,
			count = arg0.subPtDate[arg0.curSubActID].count,
			resId = arg0.subPtDate[arg0.curSubActID].resId
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		local var0 = {}
		local var1 = arg0.subPtDate[arg0.curSubActID]:GetAward()
		local var2 = getProxy(PlayerProxy):getData()

		if var1.type == DROP_TYPE_RESOURCE and var1.id == PlayerConst.ResGold and var2:GoldMax(var1.count) then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0
				})
			end)
		end

		local function var3()
			if not arg0.subPtDate[arg0.curSubActID]:CanGetNextAward() then
				triggerButton(arg0.switchBtn)
			end
		end

		seriesAsync(var0, function()
			local var0, var1 = arg0.subPtDate[arg0.curSubActID]:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.subPtDate[arg0.curSubActID]:GetId(),
				arg1 = var1,
				callback = var3
			})
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("wwf_bamboo_help")
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.convertBtn, function()
		if arg0.resNum <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("wwf_bamboo_tip3"))
			arg0:openTask()
		else
			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 5,
				activity_id = arg0.curSubActID,
				arg1 = arg0.resID
			})
			arg0:playSpineAni()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.switchBtn, function()
		if arg0.isSwitching then
			return
		end

		arg0.curActIndex = arg0.curActIndex == 1 and 2 or 1
		arg0.lastSelectIndex = arg0.curActIndex

		PlayerPrefs.SetInt("wwf_select_index_" .. arg0.playerId, arg0.lastSelectIndex)
		PlayerPrefs.Save()

		arg0.curSubActID = arg0.subActivities[arg0.curActIndex]

		arg0:OnUpdatePtAct()
		arg0:playPaintingAni()
		arg0:setStep2Progress()
	end, SFX_PANEL)
	onButton(arg0, arg0.collectBtn, function()
		arg0:openTask()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:closeTask()
	end, SFX_PANEL)
	onButton(arg0, arg0.maskBtn, function()
		arg0:closeTask()
	end, SFX_PANEL)
	onButton(arg0, arg0.guideTarget, function()
		setActive(arg0.guide, false)
		arg0:openTask()
		PlayerPrefs.SetInt("wwf_first_" .. arg0.playerId, 1)
		PlayerPrefs.Save()

		if #arg0.finishItemList > 0 then
			arg0:autoFinishTask()
		end
	end, SFX_PANEL)

	local var0 = "ninghai_7"
	local var1 = "pinghai_7"

	if not arg0.model1 then
		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetSpineChar(var0, true, function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0.prefab1 = var0
			arg0.model1 = arg0
			tf(arg0).localScale = Vector3(1, 1, 1)

			setParent(arg0, arg0.ninghaiTF)
			setActive(arg0, false)
		end)
	end

	if not arg0.model2 then
		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetSpineChar(var1, true, function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0.prefab2 = var1
			arg0.model2 = arg0
			tf(arg0).localScale = Vector3(1, 1, 1)

			setParent(arg0, arg0.pinghaiTF)
			setActive(arg0, false)
		end)
	end

	arg0:setPtActIndex()
	arg0:setStep2Progress()
	arg0:initTaskWindow()

	if arg0.isFirst == 0 then
		setActive(arg0.guide, true)
		setText(arg0.guideContent, i18n("wwf_guide_tip"))
	elseif #arg0.finishItemList > 0 then
		arg0:openTask()
		arg0:autoFinishTask()
	end
end

function var0.OnUpdateFlush(arg0)
	for iter0, iter1 in ipairs(arg0.subActivities) do
		local var0 = getProxy(ActivityProxy):getActivityById(iter1)

		if arg0.subPtDate[iter1] then
			arg0.subPtDate[iter1]:Update(var0)
		else
			arg0.subPtDate[iter1] = ActivityPtData.New(var0)
		end
	end

	arg0.resNum = getProxy(PlayerProxy):getRawData():getResource(arg0.resID)

	setText(arg0.resNumTF, arg0.resNum)
	arg0:OnUpdatePtAct()

	local var1 = arg0.curActIndex == 1 and 2 or 1

	GetOrAddComponent(arg0.paintings[arg0.curActIndex], typeof(CanvasGroup)).alpha = 1
	GetOrAddComponent(arg0.paintings[var1], typeof(CanvasGroup)).alpha = 0
end

function var0.OnUpdatePtAct(arg0)
	setText(arg0.title, arg0.titleTxts[arg0.curActIndex])
	eachChild(arg0.tags, function(arg0)
		setActive(arg0, tonumber(arg0.name) == arg0.curActIndex)
	end)

	local var0, var1, var2 = arg0.subPtDate[arg0.curSubActID]:GetLevelProgress()
	local var3, var4, var5 = arg0.subPtDate[arg0.curSubActID]:GetResProgress()

	eachChild(arg0.step, function(arg0)
		setActive(arg0, tonumber(arg0.name) < var0 and true or false)
	end)
	setText(arg0.progress, (var5 >= 1 and setColorStr(var3, "#94D979") or var3) .. "/" .. var4)

	local var6 = arg0.subPtDate[arg0.curSubActID]:GetAward()

	updateDrop(arg0.awardTF, var6)

	local var7 = arg0.subPtDate[arg0.curSubActID]:CanGetAward()
	local var8 = arg0.subPtDate[arg0.curSubActID]:CanGetNextAward()
	local var9 = arg0.subPtDate[arg0.curSubActID]:CanGetMorePt()

	setActive(arg0.convertBtn, not var7)
	setActive(arg0.getBtn, var7)
	setActive(arg0.gotBtn, not var8)
	setActive(arg0:findTF("10", arg0.step), not var8)
	setActive(arg0.switchRedDot, not var8 and not arg0:isFinishAllAct())
	setActive(arg0.taskRedDot, arg0.showTaskRedDot and not arg0.hasClickTask)
end

function var0.playPaintingAni(arg0)
	arg0.isSwitching = true

	local var0 = arg0.curActIndex
	local var1 = arg0.curActIndex == 1 and 2 or 1
	local var2 = arg0.paintings[var0]
	local var3 = arg0.paintings[var1]
	local var4 = GetOrAddComponent(var2, typeof(CanvasGroup))
	local var5 = GetOrAddComponent(var3, typeof(CanvasGroup))

	LeanTween.value(go(var3), 1, 0, 0.4):setOnUpdate(System.Action_float(function(arg0)
		var5.alpha = arg0
	end)):setOnComplete(System.Action(function()
		LeanTween.value(go(var2), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0)
			var4.alpha = arg0
		end)):setOnComplete(System.Action(function()
			arg0.isSwitching = false
		end))
	end))
end

function var0.playSpineAni(arg0)
	setActive(arg0.anim, true)

	local var0 = 0.4
	local var1 = arg0:findTF("panda_anim", arg0.anim)
	local var2 = arg0:findTF("heart_anim", arg0.anim)
	local var3 = GetOrAddComponent(var1, typeof(CanvasGroup))

	setActive(var1, true)

	var3.alpha = 1

	LeanTween.value(go(var1), 0, 1, var0):setOnUpdate(System.Action_float(function(arg0)
		var3.alpha = arg0
	end))

	local function var4()
		LeanTween.value(go(var1), 1, 0, var0):setOnUpdate(System.Action_float(function(arg0)
			var3.alpha = arg0
		end))
		LeanTween.scale(var1, Vector3(1, 0, 1), var0):setFrom(Vector3(1, 1, 1)):setOnComplete(System.Action(function()
			setActive(var1, false)
		end))
		setActive(var2, true)
		LeanTween.delayedCall(2, System.Action(function()
			setActive(var2, false)

			local var0 = arg0.step2:GetComponent(typeof(Image)).fillAmount
			local var1 = arg0.subPtDate[arg0.curSubActID].count

			LeanTween.value(go(arg0.step2), var0, var1 / var1, 1):setOnUpdate(System.Action_float(function(arg0)
				arg0.step2:GetComponent(typeof(Image)).fillAmount = arg0
			end)):setOnComplete(System.Action(function()
				setActive(arg0.anim, false)

				arg0.heartAni = false
			end))
		end))
	end

	local var5 = arg0.curActIndex == 1 and arg0.model1 or arg0.model2

	LeanTween.scale(var1, Vector3(1, 1, 1), var0):setFrom(Vector3(1, 0, 1)):setOnComplete(System.Action(function()
		setActive(var5, true)
		var5:GetComponent("SpineAnimUI"):SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				var5:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
				setActive(var5, false)
				var4()
			end
		end)
		var5:GetComponent("SpineAnimUI"):SetAction("event", 0)
	end))

	arg0.heartAni = false

	onButton(arg0, arg0.anim, function()
		if arg0.heartAni then
			return
		end

		var5:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		setActive(var5, false)

		arg0.heartAni = true

		var4()
	end, SFX_PANEL)
end

function var0.initTaskWindow(arg0)
	arg0.finishItemList = {}
	arg0.finishTaskVOList = {}

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0:findTF("item", arg2)
			local var2 = arg0.curTask[var0]
			local var3 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)

			assert(var3, "without this task by id: " .. var2)

			local var4 = var3:getConfig("award_display")[1]
			local var5 = {
				type = var4[1],
				id = var4[2],
				count = var4[3]
			}

			updateDrop(var1, var5)
			onButton(arg0, var1, function()
				arg0:emit(BaseUI.ON_DROP, var5)
			end, SFX_PANEL)

			local var6 = var3:getProgress()
			local var7 = var3:getConfig("target_num")

			setText(arg0:findTF("description", arg2), var3:getConfig("desc"))
			setText(arg0:findTF("progressText", arg2), var6 .. "/" .. var7)
			setSlider(arg0:findTF("progress", arg2), 0, var7, var6)

			local var8 = arg0:findTF("go_btn", arg2)
			local var9 = var3:getTaskStatus()

			if var9 == 1 then
				table.insert(arg0.finishItemList, arg2)
				table.insert(arg0.finishTaskVOList, var3)
			end

			setActive(arg0:findTF("finnal", arg2), var9 == 2)
			onButton(arg0, var8, function()
				arg0:emit(ActivityMediator.ON_TASK_GO, var3)
			end, SFX_PANEL)

			local var10 = var3:getConfig("type")

			setImageSprite(arg0:findTF("type", arg2), arg0.typeImages:Find(tostring(var10)):GetComponent(typeof(Image)).sprite, true)
			setImageSprite(arg0:findTF("progress/slider", arg2), arg0.barImages:Find(tostring(var10)):GetComponent(typeof(Image)).sprite)
		end
	end)
	arg0.uilist:align(#arg0.curTask)
	setActive(arg0.taskWindow, false)
end

function var0.closeTask(arg0)
	setActive(arg0.taskWindow, false)
end

function var0.openTask(arg0)
	if not arg0.curSubActID then
		arg0:setPtActIndex()
		arg0:setStep2Progress()
	end

	setActive(arg0.taskWindow, true)

	if arg0.showTaskRedDot then
		setActive(arg0.taskRedDot, false)
		getProxy(ActivityProxy):updateActivity(arg0.activity)
	end

	arg0.hasClickTask = true

	eachChild(arg0.items, function(arg0)
		if isActive(arg0:findTF("finnal", arg0)) then
			arg0:SetAsLastSibling()
		end
	end)
end

function var0.autoFinishTask(arg0)
	local var0 = 0.01
	local var1 = 0.5

	for iter0, iter1 in ipairs(arg0.finishItemList) do
		local var2 = GetOrAddComponent(iter1, typeof(CanvasGroup))

		arg0:managedTween(LeanTween.delayedCall, function()
			iter1:SetAsFirstSibling()
			LeanTween.value(go(iter1), 1, 0, var1):setOnUpdate(System.Action_float(function(arg0)
				var2.alpha = arg0
			end)):setOnComplete(System.Action(function()
				var2.alpha = 1

				setActive(arg0:findTF("finnal", iter1), true)
				iter1:SetAsLastSibling()
			end))
		end, var0, nil)

		var0 = var0 + var1 + 0.1
	end

	arg0:managedTween(LeanTween.delayedCall, function()
		pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg0.finishTaskVOList
		})
	end, var0, nil)
end

function var0.canFinishTask(arg0, arg1)
	local var0 = false

	for iter0, iter1 in pairs(arg0) do
		if (arg1:getTaskById(iter1) or arg1:getFinishTaskById(iter1)):getTaskStatus() == 1 then
			var0 = true

			break
		end
	end

	return var0
end

function var0.canAddProgress(arg0, arg1)
	local var0 = false

	for iter0, iter1 in pairs(arg1) do
		local var1, var2, var3 = iter1:GetResProgress()

		if arg0 >= var2 - var1 and iter1:CanGetNextAward() then
			var0 = true

			break
		end
	end

	return var0
end

function var0.canGetPtAward(arg0)
	local var0 = false

	for iter0, iter1 in pairs(arg0) do
		if iter1:CanGetAward() then
			var0 = true

			break
		end
	end

	return var0
end

function var0.isFinishAllAct(arg0)
	local var0 = true

	for iter0, iter1 in pairs(arg0.subPtDate) do
		if iter1:CanGetNextAward() then
			var0 = false

			break
		end
	end

	return var0
end

function var0.isNewTask(arg0)
	local var0 = getProxy(PlayerProxy):getData().id
	local var1 = PlayerPrefs.GetInt("wwf_todo_task_num_" .. var0)

	if var1 == 0 and not arg0 == 0 or var1 < arg0 then
		return true
	else
		return false
	end
end

function var0.IsShowRed()
	local var0 = pg.activity_template[ActivityConst.WWF_TASK_ID]
	local var1 = var0.config_client.convertRes
	local var2 = var0.config_client.ptActID
	local var3 = var0.config_data
	local var4 = {}

	for iter0, iter1 in ipairs(var2) do
		local var5 = getProxy(ActivityProxy):getActivityById(iter1)

		if var4[iter1] then
			var4[iter1]:Update(var5)
		else
			var4[iter1] = ActivityPtData.New(var5)
		end
	end

	local var6 = getProxy(PlayerProxy):getRawData():getResource(var1)
	local var7 = getProxy(TaskProxy)
	local var8 = {}
	local var9 = 0

	for iter2, iter3 in ipairs(var3) do
		local var10 = var7:getTaskById(iter3) or var7:getFinishTaskById(iter3)

		if var10 then
			table.insert(var8, var10.id)

			if var10:getTaskStatus() == 0 then
				var9 = var9 + 1
			end
		end
	end

	if (function()
		local var0 = true

		for iter0, iter1 in pairs(var4) do
			if iter1:CanGetNextAward() then
				var0 = false

				break
			end
		end

		return var0
	end)() then
		return false
	else
		return var0.canFinishTask(var8, var7) or var0.canGetPtAward(var4) or var0.canAddProgress(var6, var4) or var0.isNewTask(var9)
	end

	return false
end

function var0.OnDestroy(arg0)
	if arg0.prefab1 and arg0.model1 then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefab1, arg0.model1)

		arg0.prefab1 = nil
		arg0.model1 = nil
	end

	if arg0.prefab2 and arg0.model2 then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefab2, arg0.model2)

		arg0.prefab2 = nil
		arg0.model2 = nil
	end

	arg0:cleanManagedTween()
end

return var0
