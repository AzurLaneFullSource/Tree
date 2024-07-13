local var0_0 = class("NewYearsEveDinnerPage", import(".TemplatePage.SkinTemplatePage"))
local var1_0 = 3
local var2_0 = 2
local var3_0 = Vector2(760, -144)
local var4_0 = Vector2(370, -144)

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.roleTF = arg0_1:findTF("mask/role_pos", arg0_1.bg)
	arg0_1.effectNode = arg0_1:findTF("mofang_yanwu", arg0_1.bg)
	arg0_1.foodTF = arg0_1:findTF("food", arg0_1.bg)
	arg0_1.dialogTF = arg0_1:findTF("dialog", arg0_1.bg)
	arg0_1.rightPanel = arg0_1:findTF("right_panel", arg0_1.bg)
	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.rightPanel)
	arg0_1.titleFoodTF = arg0_1:findTF("menu_title/icon", arg0_1.rightPanel)
	arg0_1.cookBtn = arg0_1:findTF("cook_btn", arg0_1.rightPanel)
	arg0_1.cookProgress = arg0_1:findTF("progress", arg0_1.cookBtn)
	arg0_1.cookAwardTF = arg0_1:findTF("award", arg0_1.cookBtn)
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.cookActID = arg0_2.activity:getConfig("config_client").linkTaskPoolAct
	arg0_2.cookCfg = pg.activity_template[arg0_2.cookActID].config_client
	arg0_2.cookTaskIds = pg.activity_template[arg0_2.cookActID].config_data
	arg0_2.totalCookCnt = #arg0_2.cookTaskIds
	arg0_2.playerId = getProxy(PlayerProxy):getData().id
	arg0_2.randomSeed = arg0_2:GetRandomById()

	var0_0.super.OnDataSetting(arg0_2)
end

function var0_0.GetRandomById(arg0_3)
	local var0_3 = arg0_3.playerId
	local var1_3 = {}

	while #var1_3 < 7 do
		local var2_3 = var0_3 % 10

		var0_3 = math.floor(var0_3 / 10)

		if var0_3 == 0 then
			var0_3 = arg0_3.playerId
		end

		table.insert(var1_3, var2_3)
	end

	return var1_3
end

function var0_0.OnFirstFlush(arg0_4)
	var0_0.super.OnFirstFlush(arg0_4)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.sevenday_nianye.tip
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.cookBtn, function()
		if arg0_4.isMoving then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_nianye"))

			return
		end

		if arg0_4.isEffectPlaying then
			return
		end

		local var0_6 = arg0_4.taskProxy:getTaskVO(arg0_4.curTaskId)

		if var0_6:getTaskStatus() == 1 then
			setActive(arg0_4.effectNode, true)

			arg0_4.isEffectPlaying = true

			arg0_4:managedTween(LeanTween.delayedCall, function()
				arg0_4:emit(ActivityMediator.ON_TASK_SUBMIT, var0_6)
				setActive(arg0_4.effectNode, false)

				arg0_4.isEffectPlaying = false
			end, var2_0, nil)
		end
	end, SFX_PANEL)
	setActive(arg0_4:findTF("shine", arg0_4.cookBtn), false)
end

function var0_0.OnUpdateFlush(arg0_8)
	var0_0.super.OnUpdateFlush(arg0_8)

	arg0_8.cookAct = getProxy(ActivityProxy):getActivityById(arg0_8.cookActID)

	assert(arg0_8.cookAct and not arg0_8.cookAct:isEnd(), "自选任务池活动(type86)已结束")
	arg0_8:RefreshCookData()
	arg0_8:UpdateCookData()
	arg0_8:UpdateCookUI()
end

function var0_0.RefreshCookData(arg0_9)
	arg0_9.usedCnt = arg0_9.cookAct:getData1()

	local var0_9 = pg.TimeMgr.GetInstance()

	arg0_9.unlockCnt = (var0_9:DiffDay(arg0_9.cookAct:getStartTime(), var0_9:GetServerTime()) + 1) * arg0_9.cookAct:getConfig("config_id")
	arg0_9.unlockCnt = math.min(arg0_9.unlockCnt, arg0_9.totalCookCnt)
	arg0_9.remainCnt = arg0_9.usedCnt >= arg0_9.totalCookCnt and 0 or arg0_9.unlockCnt - arg0_9.usedCnt
end

function var0_0.UpdateCookData(arg0_10)
	local var0_10 = 0

	arg0_10.receivedTasks = {}

	local var1_10 = underscore.rest(arg0_10.cookTaskIds, 1)

	for iter0_10, iter1_10 in ipairs(arg0_10.cookTaskIds) do
		local var2_10 = arg0_10.taskProxy:getTaskVO(iter1_10)

		if var2_10:isReceive() then
			table.insert(arg0_10.receivedTasks, var2_10)

			var0_10 = var0_10 + 1

			table.removebyvalue(var1_10, iter1_10)
		end
	end

	table.sort(arg0_10.receivedTasks, function(arg0_11, arg1_11)
		return arg0_11.submitTime < arg1_11.submitTime
	end)

	arg0_10.receivedTasks = underscore.map(arg0_10.receivedTasks, function(arg0_12)
		return arg0_12.id
	end)

	if arg0_10.usedCnt ~= var0_10 then
		arg0_10.usedCnt = var0_10

		local var3_10 = arg0_10.cookAct

		var3_10.data1 = arg0_10.usedCnt

		getProxy(ActivityProxy):updateActivity(var3_10)

		return
	end

	local var4_10 = arg0_10.remainCnt == 0 and arg0_10.usedCnt or arg0_10.usedCnt + 1

	if arg0_10.remainCnt == 0 then
		arg0_10.curTaskId = arg0_10.receivedTasks[#arg0_10.receivedTasks]
	else
		arg0_10.curTaskId = var1_10[arg0_10.randomSeed[var4_10] % #var1_10 + 1]
	end
end

function var0_0.UpdateCookUI(arg0_13)
	local var0_13 = arg0_13.remainCnt == 0 and arg0_13.usedCnt or arg0_13.usedCnt + 1

	setText(arg0_13.cookProgress, var0_13 .. "/" .. arg0_13.totalCookCnt)

	local var1_13 = arg0_13.taskProxy:getTaskVO(arg0_13.curTaskId)
	local var2_13 = var1_13:getConfig("award_display")[1]
	local var3_13 = {
		type = var2_13[1],
		id = var2_13[2],
		count = var2_13[3]
	}

	updateDrop(arg0_13.cookAwardTF, var3_13)

	local var4_13 = var1_13:getTaskStatus() == 2

	setActive(arg0_13:findTF("got", arg0_13.cookAwardTF), var4_13)
	setActive(arg0_13:findTF("icon_bg/count", arg0_13.cookAwardTF), var4_13)
	setText(arg0_13:findTF("Text", arg0_13.dialogTF), i18n(arg0_13.cookCfg[arg0_13.curTaskId][3]))

	local var5_13 = var4_13 and arg0_13.cookCfg[arg0_13.curTaskId][2] .. "_2" or "unknown"

	GetImageSpriteFromAtlasAsync("ui/activityuipage/NewYearsEveDinnerPage_atlas", arg0_13.cookCfg[arg0_13.curTaskId][2], arg0_13.foodTF, true)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/NewYearsEveDinnerPage_atlas", var5_13, arg0_13.titleFoodTF, true)

	arg0_13.prefabName = arg0_13.cookCfg[arg0_13.curTaskId][1]

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(arg0_13.prefabName, true, function(arg0_14)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_13.modelTf = tf(arg0_14)
		arg0_13.modelTf.localPosition = Vector3(0, 0, 0)
		arg0_13.modelTf.localScale = Vector3(1, 1, 1)

		arg0_13:ClearRole()
		setParent(arg0_13.modelTf, arg0_13.roleTF)
		arg0_13:PlayRoleAnim()
	end)
end

function var0_0.ClearRole(arg0_15)
	arg0_15.isMoving = false

	if LeanTween.isTweening(arg0_15.roleTF) then
		LeanTween.cancel(arg0_15.roleTF)
	end

	removeAllChildren(arg0_15.roleTF)
end

function var0_0.PlayRoleAnim(arg0_16)
	local var0_16 = arg0_16.taskProxy:getTaskVO(arg0_16.curTaskId):getTaskStatus() == 2
	local var1_16 = arg0_16.modelTf:GetComponent("SpineAnimUI")

	setActive(arg0_16.foodTF, false)
	setActive(arg0_16.dialogTF, false)
	setActive(arg0_16:findTF("shine", arg0_16.cookBtn), false)

	if var0_16 then
		setAnchoredPosition(arg0_16.roleTF, var4_0)
		var1_16:SetAction("normal", 0)
		setActive(arg0_16.foodTF, true)
		setActive(arg0_16.dialogTF, true)
		setActive(arg0_16:findTF("shine", arg0_16.cookBtn), not var0_16 and arg0_16.remainCnt > 0)
	else
		var1_16:SetAction("move", 0)

		arg0_16.isMoving = true

		setAnchoredPosition(arg0_16.roleTF, var3_0)
		arg0_16:managedTween(LeanTween.moveX, function()
			var1_16:SetAction("normal", 0)

			arg0_16.isMoving = false

			setActive(arg0_16.foodTF, var0_16)
			setActive(arg0_16.dialogTF, var0_16)
			setActive(arg0_16:findTF("shine", arg0_16.cookBtn), not var0_16 and arg0_16.remainCnt > 0)
		end, arg0_16.roleTF, var4_0.x, var1_0):setEase(LeanTweenType.linear)
	end
end

function var0_0.OnDestroy(arg0_18)
	if arg0_18.prefabName and arg0_18.modelTf then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_18.prefabName, arg0_18.modelTf.gameObject)

		arg0_18.prefabName = nil
		arg0_18.modelTf = nil
	end

	arg0_18:cleanManagedTween()
end

return var0_0
