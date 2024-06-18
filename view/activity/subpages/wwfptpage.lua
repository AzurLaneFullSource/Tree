local var0_0 = class("WWFPtPage", import(".TemplatePage.PtTemplatePage"))
local var1_0 = 6000

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)
	arg0_1.collectBtn = arg0_1:findTF("collect_btn", arg0_1.bg)
	arg0_1.taskRedDot = arg0_1:findTF("red_dot", arg0_1.collectBtn)
	arg0_1.resNumTF = arg0_1:findTF("res_num", arg0_1.collectBtn)
	arg0_1.title = arg0_1:findTF("title", arg0_1.bg)
	arg0_1.tags = arg0_1:findTF("tags", arg0_1.bg)
	arg0_1.convertBtn = arg0_1:findTF("convert_btn", arg0_1.bg)
	arg0_1.switchBtn = arg0_1:findTF("switch_btn", arg0_1.bg)
	arg0_1.switchRedDot = arg0_1:findTF("red_dot", arg0_1.switchBtn)
	arg0_1.paintings = {
		arg0_1:findTF("paintings/ninghai", arg0_1.bg),
		arg0_1:findTF("paintings/pinghai", arg0_1.bg)
	}
	arg0_1.anim = arg0_1:findTF("anim", arg0_1.bg)
	arg0_1.ninghaiTF = arg0_1:findTF("anim/panda_anim/ninghai", arg0_1.bg)
	arg0_1.pinghaiTF = arg0_1:findTF("anim/panda_anim/pinghai", arg0_1.bg)
	arg0_1.heartImages = arg0_1:findTF("hearts", arg0_1.bg)
	arg0_1.step2 = arg0_1:findTF("step2", arg0_1.bg)
	arg0_1.taskWindow = arg0_1:findTF("TaskWindow")
	arg0_1.closeBtn = arg0_1:findTF("panel/close_btn", arg0_1.taskWindow)
	arg0_1.maskBtn = arg0_1:findTF("mask", arg0_1.taskWindow)
	arg0_1.item = arg0_1:findTF("panel/scrollview/item", arg0_1.taskWindow)
	arg0_1.items = arg0_1:findTF("panel/scrollview/items", arg0_1.taskWindow)
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.typeImages = arg0_1:findTF("panel/tags", arg0_1.taskWindow)
	arg0_1.barImages = arg0_1:findTF("panel/bars", arg0_1.taskWindow)
	arg0_1.guide = arg0_1:findTF("Guide")
	arg0_1.guideTarget = arg0_1:findTF("target", arg0_1.guide)
	arg0_1.guideContent = arg0_1:findTF("dialogBox/content", arg0_1.guide)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.titleTxts = {
		i18n("wwf_bamboo_tip1"),
		i18n("wwf_bamboo_tip2")
	}
	arg0_2.resID = arg0_2.activity:getConfig("config_client").convertRes
	arg0_2.subActivities = arg0_2.activity:getConfig("config_client").ptActID
	arg0_2.taskList = arg0_2.activity:getConfig("config_data")

	arg0_2:initPtData()
	arg0_2:initTaskData()
	arg0_2:initLocalData()
end

function var0_0.initPtData(arg0_3)
	arg0_3.subPtDate = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.subActivities) do
		local var0_3 = getProxy(ActivityProxy):getActivityById(iter1_3)

		if arg0_3.subPtDate[iter1_3] then
			arg0_3.subPtDate[iter1_3]:Update(var0_3)
		else
			arg0_3.subPtDate[iter1_3] = ActivityPtData.New(var0_3)
		end
	end

	arg0_3.resNum = getProxy(PlayerProxy):getRawData():getResource(arg0_3.resID)
end

function var0_0.setPtActIndex(arg0_4)
	arg0_4.curActIndex = arg0_4.lastSelectIndex
	arg0_4.curSubActID = arg0_4.subActivities[arg0_4.curActIndex]

	local var0_4 = arg0_4.curActIndex == 1 and 2 or 1
	local var1_4 = arg0_4.subPtDate[arg0_4.curSubActID]:CanGetMorePt()
	local var2_4 = arg0_4.subPtDate[arg0_4.subActivities[var0_4]]:CanGetAward()

	if not var1_4 or var2_4 then
		arg0_4.curActIndex = var0_4
		arg0_4.curSubActID = arg0_4.subActivities[arg0_4.curActIndex]

		PlayerPrefs.SetInt("wwf_select_index_" .. arg0_4.playerId, arg0_4.lastSelectIndex)
		PlayerPrefs.Save()
	end
end

function var0_0.setStep2Progress(arg0_5)
	local var0_5 = arg0_5.subPtDate[arg0_5.curSubActID].count

	setImageSprite(arg0_5.step2, arg0_5.heartImages:Find(tostring(arg0_5.curActIndex)):GetComponent(typeof(Image)).sprite)

	arg0_5.step2:GetComponent(typeof(Image)).fillAmount = var0_5 / var1_0
end

function var0_0.initTaskData(arg0_6)
	arg0_6.taskProxy = getProxy(TaskProxy)
	arg0_6.curTask = {}
	arg0_6.todoTaskNum = 0

	for iter0_6, iter1_6 in ipairs(arg0_6.taskList) do
		local var0_6 = arg0_6.taskProxy:getTaskById(iter1_6) or arg0_6.taskProxy:getFinishTaskById(iter1_6)

		if var0_6 then
			table.insert(arg0_6.curTask, var0_6.id)

			if var0_6:getTaskStatus() == 0 then
				arg0_6.todoTaskNum = arg0_6.todoTaskNum + 1
			end
		end
	end
end

function var0_0.initLocalData(arg0_7)
	arg0_7.playerId = getProxy(PlayerProxy):getData().id
	arg0_7.isFirst = PlayerPrefs.GetInt("wwf_first_" .. arg0_7.playerId)

	if PlayerPrefs.GetInt("wwf_select_index_" .. arg0_7.playerId) == 0 then
		arg0_7.lastSelectIndex = 1
	else
		arg0_7.lastSelectIndex = PlayerPrefs.GetInt("wwf_select_index_" .. arg0_7.playerId)
	end

	arg0_7.showTaskRedDot = false

	local var0_7 = PlayerPrefs.GetInt("wwf_todo_task_num_" .. arg0_7.playerId)

	if (var0_7 == 0 and not arg0_7.todoTaskNum == 0 or var0_7 < arg0_7.todoTaskNum) and not arg0_7:isFinishAllAct() then
		arg0_7.showTaskRedDot = true
	end

	arg0_7.hasClickTask = false

	PlayerPrefs.SetInt("wwf_todo_task_num_" .. arg0_7.playerId, arg0_7.todoTaskNum)
	PlayerPrefs.Save()
end

function var0_0.OnFirstFlush(arg0_8)
	onButton(arg0_8, arg0_8.awardTF, function()
		arg0_8:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = arg0_8.subPtDate[arg0_8.curSubActID].type,
			dropList = arg0_8.subPtDate[arg0_8.curSubActID].dropList,
			targets = arg0_8.subPtDate[arg0_8.curSubActID].targets,
			level = arg0_8.subPtDate[arg0_8.curSubActID].level,
			count = arg0_8.subPtDate[arg0_8.curSubActID].count,
			resId = arg0_8.subPtDate[arg0_8.curSubActID].resId
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.getBtn, function()
		local var0_10 = {}
		local var1_10 = arg0_8.subPtDate[arg0_8.curSubActID]:GetAward()
		local var2_10 = getProxy(PlayerProxy):getData()

		if var1_10.type == DROP_TYPE_RESOURCE and var1_10.id == PlayerConst.ResGold and var2_10:GoldMax(var1_10.count) then
			table.insert(var0_10, function(arg0_11)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = arg0_11
				})
			end)
		end

		local function var3_10()
			if not arg0_8.subPtDate[arg0_8.curSubActID]:CanGetNextAward() then
				triggerButton(arg0_8.switchBtn)
			end
		end

		seriesAsync(var0_10, function()
			local var0_13, var1_13 = arg0_8.subPtDate[arg0_8.curSubActID]:GetResProgress()

			arg0_8:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_8.subPtDate[arg0_8.curSubActID]:GetId(),
				arg1 = var1_13,
				callback = var3_10
			})
		end)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("wwf_bamboo_help")
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.convertBtn, function()
		if arg0_8.resNum <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("wwf_bamboo_tip3"))
			arg0_8:openTask()
		else
			arg0_8:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 5,
				activity_id = arg0_8.curSubActID,
				arg1 = arg0_8.resID
			})
			arg0_8:playSpineAni()
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.switchBtn, function()
		if arg0_8.isSwitching then
			return
		end

		arg0_8.curActIndex = arg0_8.curActIndex == 1 and 2 or 1
		arg0_8.lastSelectIndex = arg0_8.curActIndex

		PlayerPrefs.SetInt("wwf_select_index_" .. arg0_8.playerId, arg0_8.lastSelectIndex)
		PlayerPrefs.Save()

		arg0_8.curSubActID = arg0_8.subActivities[arg0_8.curActIndex]

		arg0_8:OnUpdatePtAct()
		arg0_8:playPaintingAni()
		arg0_8:setStep2Progress()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.collectBtn, function()
		arg0_8:openTask()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.closeBtn, function()
		arg0_8:closeTask()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.maskBtn, function()
		arg0_8:closeTask()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.guideTarget, function()
		setActive(arg0_8.guide, false)
		arg0_8:openTask()
		PlayerPrefs.SetInt("wwf_first_" .. arg0_8.playerId, 1)
		PlayerPrefs.Save()

		if #arg0_8.finishItemList > 0 then
			arg0_8:autoFinishTask()
		end
	end, SFX_PANEL)

	local var0_8 = "ninghai_7"
	local var1_8 = "pinghai_7"

	if not arg0_8.model1 then
		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetSpineChar(var0_8, true, function(arg0_21)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0_8.prefab1 = var0_8
			arg0_8.model1 = arg0_21
			tf(arg0_21).localScale = Vector3(1, 1, 1)

			setParent(arg0_21, arg0_8.ninghaiTF)
			setActive(arg0_21, false)
		end)
	end

	if not arg0_8.model2 then
		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetSpineChar(var1_8, true, function(arg0_22)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0_8.prefab2 = var1_8
			arg0_8.model2 = arg0_22
			tf(arg0_22).localScale = Vector3(1, 1, 1)

			setParent(arg0_22, arg0_8.pinghaiTF)
			setActive(arg0_22, false)
		end)
	end

	arg0_8:setPtActIndex()
	arg0_8:setStep2Progress()
	arg0_8:initTaskWindow()

	if arg0_8.isFirst == 0 then
		setActive(arg0_8.guide, true)
		setText(arg0_8.guideContent, i18n("wwf_guide_tip"))
	elseif #arg0_8.finishItemList > 0 then
		arg0_8:openTask()
		arg0_8:autoFinishTask()
	end
end

function var0_0.OnUpdateFlush(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.subActivities) do
		local var0_23 = getProxy(ActivityProxy):getActivityById(iter1_23)

		if arg0_23.subPtDate[iter1_23] then
			arg0_23.subPtDate[iter1_23]:Update(var0_23)
		else
			arg0_23.subPtDate[iter1_23] = ActivityPtData.New(var0_23)
		end
	end

	arg0_23.resNum = getProxy(PlayerProxy):getRawData():getResource(arg0_23.resID)

	setText(arg0_23.resNumTF, arg0_23.resNum)
	arg0_23:OnUpdatePtAct()

	local var1_23 = arg0_23.curActIndex == 1 and 2 or 1

	GetOrAddComponent(arg0_23.paintings[arg0_23.curActIndex], typeof(CanvasGroup)).alpha = 1
	GetOrAddComponent(arg0_23.paintings[var1_23], typeof(CanvasGroup)).alpha = 0
end

function var0_0.OnUpdatePtAct(arg0_24)
	setText(arg0_24.title, arg0_24.titleTxts[arg0_24.curActIndex])
	eachChild(arg0_24.tags, function(arg0_25)
		setActive(arg0_25, tonumber(arg0_25.name) == arg0_24.curActIndex)
	end)

	local var0_24, var1_24, var2_24 = arg0_24.subPtDate[arg0_24.curSubActID]:GetLevelProgress()
	local var3_24, var4_24, var5_24 = arg0_24.subPtDate[arg0_24.curSubActID]:GetResProgress()

	eachChild(arg0_24.step, function(arg0_26)
		setActive(arg0_26, tonumber(arg0_26.name) < var0_24 and true or false)
	end)
	setText(arg0_24.progress, (var5_24 >= 1 and setColorStr(var3_24, "#94D979") or var3_24) .. "/" .. var4_24)

	local var6_24 = arg0_24.subPtDate[arg0_24.curSubActID]:GetAward()

	updateDrop(arg0_24.awardTF, var6_24)

	local var7_24 = arg0_24.subPtDate[arg0_24.curSubActID]:CanGetAward()
	local var8_24 = arg0_24.subPtDate[arg0_24.curSubActID]:CanGetNextAward()
	local var9_24 = arg0_24.subPtDate[arg0_24.curSubActID]:CanGetMorePt()

	setActive(arg0_24.convertBtn, not var7_24)
	setActive(arg0_24.getBtn, var7_24)
	setActive(arg0_24.gotBtn, not var8_24)
	setActive(arg0_24:findTF("10", arg0_24.step), not var8_24)
	setActive(arg0_24.switchRedDot, not var8_24 and not arg0_24:isFinishAllAct())
	setActive(arg0_24.taskRedDot, arg0_24.showTaskRedDot and not arg0_24.hasClickTask)
end

function var0_0.playPaintingAni(arg0_27)
	arg0_27.isSwitching = true

	local var0_27 = arg0_27.curActIndex
	local var1_27 = arg0_27.curActIndex == 1 and 2 or 1
	local var2_27 = arg0_27.paintings[var0_27]
	local var3_27 = arg0_27.paintings[var1_27]
	local var4_27 = GetOrAddComponent(var2_27, typeof(CanvasGroup))
	local var5_27 = GetOrAddComponent(var3_27, typeof(CanvasGroup))

	LeanTween.value(go(var3_27), 1, 0, 0.4):setOnUpdate(System.Action_float(function(arg0_28)
		var5_27.alpha = arg0_28
	end)):setOnComplete(System.Action(function()
		LeanTween.value(go(var2_27), 0, 1, 0.4):setOnUpdate(System.Action_float(function(arg0_30)
			var4_27.alpha = arg0_30
		end)):setOnComplete(System.Action(function()
			arg0_27.isSwitching = false
		end))
	end))
end

function var0_0.playSpineAni(arg0_32)
	setActive(arg0_32.anim, true)

	local var0_32 = 0.4
	local var1_32 = arg0_32:findTF("panda_anim", arg0_32.anim)
	local var2_32 = arg0_32:findTF("heart_anim", arg0_32.anim)
	local var3_32 = GetOrAddComponent(var1_32, typeof(CanvasGroup))

	setActive(var1_32, true)

	var3_32.alpha = 1

	LeanTween.value(go(var1_32), 0, 1, var0_32):setOnUpdate(System.Action_float(function(arg0_33)
		var3_32.alpha = arg0_33
	end))

	local function var4_32()
		LeanTween.value(go(var1_32), 1, 0, var0_32):setOnUpdate(System.Action_float(function(arg0_35)
			var3_32.alpha = arg0_35
		end))
		LeanTween.scale(var1_32, Vector3(1, 0, 1), var0_32):setFrom(Vector3(1, 1, 1)):setOnComplete(System.Action(function()
			setActive(var1_32, false)
		end))
		setActive(var2_32, true)
		LeanTween.delayedCall(2, System.Action(function()
			setActive(var2_32, false)

			local var0_37 = arg0_32.step2:GetComponent(typeof(Image)).fillAmount
			local var1_37 = arg0_32.subPtDate[arg0_32.curSubActID].count

			LeanTween.value(go(arg0_32.step2), var0_37, var1_37 / var1_0, 1):setOnUpdate(System.Action_float(function(arg0_38)
				arg0_32.step2:GetComponent(typeof(Image)).fillAmount = arg0_38
			end)):setOnComplete(System.Action(function()
				setActive(arg0_32.anim, false)

				arg0_32.heartAni = false
			end))
		end))
	end

	local var5_32 = arg0_32.curActIndex == 1 and arg0_32.model1 or arg0_32.model2

	LeanTween.scale(var1_32, Vector3(1, 1, 1), var0_32):setFrom(Vector3(1, 0, 1)):setOnComplete(System.Action(function()
		setActive(var5_32, true)
		var5_32:GetComponent("SpineAnimUI"):SetActionCallBack(function(arg0_41)
			if arg0_41 == "finish" then
				var5_32:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
				setActive(var5_32, false)
				var4_32()
			end
		end)
		var5_32:GetComponent("SpineAnimUI"):SetAction("event", 0)
	end))

	arg0_32.heartAni = false

	onButton(arg0_32, arg0_32.anim, function()
		if arg0_32.heartAni then
			return
		end

		var5_32:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		setActive(var5_32, false)

		arg0_32.heartAni = true

		var4_32()
	end, SFX_PANEL)
end

function var0_0.initTaskWindow(arg0_43)
	arg0_43.finishItemList = {}
	arg0_43.finishTaskVOList = {}

	arg0_43.uilist:make(function(arg0_44, arg1_44, arg2_44)
		if arg0_44 == UIItemList.EventUpdate then
			local var0_44 = arg1_44 + 1
			local var1_44 = arg0_43:findTF("item", arg2_44)
			local var2_44 = arg0_43.curTask[var0_44]
			local var3_44 = arg0_43.taskProxy:getTaskById(var2_44) or arg0_43.taskProxy:getFinishTaskById(var2_44)

			assert(var3_44, "without this task by id: " .. var2_44)

			local var4_44 = var3_44:getConfig("award_display")[1]
			local var5_44 = {
				type = var4_44[1],
				id = var4_44[2],
				count = var4_44[3]
			}

			updateDrop(var1_44, var5_44)
			onButton(arg0_43, var1_44, function()
				arg0_43:emit(BaseUI.ON_DROP, var5_44)
			end, SFX_PANEL)

			local var6_44 = var3_44:getProgress()
			local var7_44 = var3_44:getConfig("target_num")

			setText(arg0_43:findTF("description", arg2_44), var3_44:getConfig("desc"))
			setText(arg0_43:findTF("progressText", arg2_44), var6_44 .. "/" .. var7_44)
			setSlider(arg0_43:findTF("progress", arg2_44), 0, var7_44, var6_44)

			local var8_44 = arg0_43:findTF("go_btn", arg2_44)
			local var9_44 = var3_44:getTaskStatus()

			if var9_44 == 1 then
				table.insert(arg0_43.finishItemList, arg2_44)
				table.insert(arg0_43.finishTaskVOList, var3_44)
			end

			setActive(arg0_43:findTF("finnal", arg2_44), var9_44 == 2)
			onButton(arg0_43, var8_44, function()
				arg0_43:emit(ActivityMediator.ON_TASK_GO, var3_44)
			end, SFX_PANEL)

			local var10_44 = var3_44:getConfig("type")

			setImageSprite(arg0_43:findTF("type", arg2_44), arg0_43.typeImages:Find(tostring(var10_44)):GetComponent(typeof(Image)).sprite, true)
			setImageSprite(arg0_43:findTF("progress/slider", arg2_44), arg0_43.barImages:Find(tostring(var10_44)):GetComponent(typeof(Image)).sprite)
		end
	end)
	arg0_43.uilist:align(#arg0_43.curTask)
	setActive(arg0_43.taskWindow, false)
end

function var0_0.closeTask(arg0_47)
	setActive(arg0_47.taskWindow, false)
end

function var0_0.openTask(arg0_48)
	if not arg0_48.curSubActID then
		arg0_48:setPtActIndex()
		arg0_48:setStep2Progress()
	end

	setActive(arg0_48.taskWindow, true)

	if arg0_48.showTaskRedDot then
		setActive(arg0_48.taskRedDot, false)
		getProxy(ActivityProxy):updateActivity(arg0_48.activity)
	end

	arg0_48.hasClickTask = true

	eachChild(arg0_48.items, function(arg0_49)
		if isActive(arg0_48:findTF("finnal", arg0_49)) then
			arg0_49:SetAsLastSibling()
		end
	end)
end

function var0_0.autoFinishTask(arg0_50)
	local var0_50 = 0.01
	local var1_50 = 0.5

	for iter0_50, iter1_50 in ipairs(arg0_50.finishItemList) do
		local var2_50 = GetOrAddComponent(iter1_50, typeof(CanvasGroup))

		arg0_50:managedTween(LeanTween.delayedCall, function()
			iter1_50:SetAsFirstSibling()
			LeanTween.value(go(iter1_50), 1, 0, var1_50):setOnUpdate(System.Action_float(function(arg0_52)
				var2_50.alpha = arg0_52
			end)):setOnComplete(System.Action(function()
				var2_50.alpha = 1

				setActive(arg0_50:findTF("finnal", iter1_50), true)
				iter1_50:SetAsLastSibling()
			end))
		end, var0_50, nil)

		var0_50 = var0_50 + var1_50 + 0.1
	end

	arg0_50:managedTween(LeanTween.delayedCall, function()
		pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg0_50.finishTaskVOList
		})
	end, var0_50, nil)
end

function var0_0.canFinishTask(arg0_55, arg1_55)
	local var0_55 = false

	for iter0_55, iter1_55 in pairs(arg0_55) do
		if (arg1_55:getTaskById(iter1_55) or arg1_55:getFinishTaskById(iter1_55)):getTaskStatus() == 1 then
			var0_55 = true

			break
		end
	end

	return var0_55
end

function var0_0.canAddProgress(arg0_56, arg1_56)
	local var0_56 = false

	for iter0_56, iter1_56 in pairs(arg1_56) do
		local var1_56, var2_56, var3_56 = iter1_56:GetResProgress()

		if arg0_56 >= var2_56 - var1_56 and iter1_56:CanGetNextAward() then
			var0_56 = true

			break
		end
	end

	return var0_56
end

function var0_0.canGetPtAward(arg0_57)
	local var0_57 = false

	for iter0_57, iter1_57 in pairs(arg0_57) do
		if iter1_57:CanGetAward() then
			var0_57 = true

			break
		end
	end

	return var0_57
end

function var0_0.isFinishAllAct(arg0_58)
	local var0_58 = true

	for iter0_58, iter1_58 in pairs(arg0_58.subPtDate) do
		if iter1_58:CanGetNextAward() then
			var0_58 = false

			break
		end
	end

	return var0_58
end

function var0_0.isNewTask(arg0_59)
	local var0_59 = getProxy(PlayerProxy):getData().id
	local var1_59 = PlayerPrefs.GetInt("wwf_todo_task_num_" .. var0_59)

	if var1_59 == 0 and not arg0_59 == 0 or var1_59 < arg0_59 then
		return true
	else
		return false
	end
end

function var0_0.IsShowRed()
	local var0_60 = pg.activity_template[ActivityConst.WWF_TASK_ID]
	local var1_60 = var0_60.config_client.convertRes
	local var2_60 = var0_60.config_client.ptActID
	local var3_60 = var0_60.config_data
	local var4_60 = {}

	for iter0_60, iter1_60 in ipairs(var2_60) do
		local var5_60 = getProxy(ActivityProxy):getActivityById(iter1_60)

		if var4_60[iter1_60] then
			var4_60[iter1_60]:Update(var5_60)
		else
			var4_60[iter1_60] = ActivityPtData.New(var5_60)
		end
	end

	local var6_60 = getProxy(PlayerProxy):getRawData():getResource(var1_60)
	local var7_60 = getProxy(TaskProxy)
	local var8_60 = {}
	local var9_60 = 0

	for iter2_60, iter3_60 in ipairs(var3_60) do
		local var10_60 = var7_60:getTaskById(iter3_60) or var7_60:getFinishTaskById(iter3_60)

		if var10_60 then
			table.insert(var8_60, var10_60.id)

			if var10_60:getTaskStatus() == 0 then
				var9_60 = var9_60 + 1
			end
		end
	end

	if (function()
		local var0_61 = true

		for iter0_61, iter1_61 in pairs(var4_60) do
			if iter1_61:CanGetNextAward() then
				var0_61 = false

				break
			end
		end

		return var0_61
	end)() then
		return false
	else
		return var0_0.canFinishTask(var8_60, var7_60) or var0_0.canGetPtAward(var4_60) or var0_0.canAddProgress(var6_60, var4_60) or var0_0.isNewTask(var9_60)
	end

	return false
end

function var0_0.OnDestroy(arg0_62)
	if arg0_62.prefab1 and arg0_62.model1 then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_62.prefab1, arg0_62.model1)

		arg0_62.prefab1 = nil
		arg0_62.model1 = nil
	end

	if arg0_62.prefab2 and arg0_62.model2 then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_62.prefab2, arg0_62.model2)

		arg0_62.prefab2 = nil
		arg0_62.model2 = nil
	end

	arg0_62:cleanManagedTween()
end

return var0_0
