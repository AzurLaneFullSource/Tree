local var0 = class("NewYearsEveDinnerPage", import(".TemplatePage.SkinTemplatePage"))
local var1 = 3
local var2 = 2
local var3 = Vector2(760, -144)
local var4 = Vector2(370, -144)

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.roleTF = arg0:findTF("mask/role_pos", arg0.bg)
	arg0.effectNode = arg0:findTF("mofang_yanwu", arg0.bg)
	arg0.foodTF = arg0:findTF("food", arg0.bg)
	arg0.dialogTF = arg0:findTF("dialog", arg0.bg)
	arg0.rightPanel = arg0:findTF("right_panel", arg0.bg)
	arg0.helpBtn = arg0:findTF("help_btn", arg0.rightPanel)
	arg0.titleFoodTF = arg0:findTF("menu_title/icon", arg0.rightPanel)
	arg0.cookBtn = arg0:findTF("cook_btn", arg0.rightPanel)
	arg0.cookProgress = arg0:findTF("progress", arg0.cookBtn)
	arg0.cookAwardTF = arg0:findTF("award", arg0.cookBtn)
end

function var0.OnDataSetting(arg0)
	arg0.cookActID = arg0.activity:getConfig("config_client").linkTaskPoolAct
	arg0.cookCfg = pg.activity_template[arg0.cookActID].config_client
	arg0.cookTaskIds = pg.activity_template[arg0.cookActID].config_data
	arg0.totalCookCnt = #arg0.cookTaskIds
	arg0.playerId = getProxy(PlayerProxy):getData().id
	arg0.randomSeed = arg0:GetRandomById()

	var0.super.OnDataSetting(arg0)
end

function var0.GetRandomById(arg0)
	local var0 = arg0.playerId
	local var1 = {}

	while #var1 < 7 do
		local var2 = var0 % 10

		var0 = math.floor(var0 / 10)

		if var0 == 0 then
			var0 = arg0.playerId
		end

		table.insert(var1, var2)
	end

	return var1
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.sevenday_nianye.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.cookBtn, function()
		if arg0.isMoving then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_nianye"))

			return
		end

		if arg0.isEffectPlaying then
			return
		end

		local var0 = arg0.taskProxy:getTaskVO(arg0.curTaskId)

		if var0:getTaskStatus() == 1 then
			setActive(arg0.effectNode, true)

			arg0.isEffectPlaying = true

			arg0:managedTween(LeanTween.delayedCall, function()
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)
				setActive(arg0.effectNode, false)

				arg0.isEffectPlaying = false
			end, var2, nil)
		end
	end, SFX_PANEL)
	setActive(arg0:findTF("shine", arg0.cookBtn), false)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	arg0.cookAct = getProxy(ActivityProxy):getActivityById(arg0.cookActID)

	assert(arg0.cookAct and not arg0.cookAct:isEnd(), "自选任务池活动(type86)已结束")
	arg0:RefreshCookData()
	arg0:UpdateCookData()
	arg0:UpdateCookUI()
end

function var0.RefreshCookData(arg0)
	arg0.usedCnt = arg0.cookAct:getData1()

	local var0 = pg.TimeMgr.GetInstance()

	arg0.unlockCnt = (var0:DiffDay(arg0.cookAct:getStartTime(), var0:GetServerTime()) + 1) * arg0.cookAct:getConfig("config_id")
	arg0.unlockCnt = math.min(arg0.unlockCnt, arg0.totalCookCnt)
	arg0.remainCnt = arg0.usedCnt >= arg0.totalCookCnt and 0 or arg0.unlockCnt - arg0.usedCnt
end

function var0.UpdateCookData(arg0)
	local var0 = 0

	arg0.receivedTasks = {}

	local var1 = underscore.rest(arg0.cookTaskIds, 1)

	for iter0, iter1 in ipairs(arg0.cookTaskIds) do
		local var2 = arg0.taskProxy:getTaskVO(iter1)

		if var2:isReceive() then
			table.insert(arg0.receivedTasks, var2)

			var0 = var0 + 1

			table.removebyvalue(var1, iter1)
		end
	end

	table.sort(arg0.receivedTasks, function(arg0, arg1)
		return arg0.submitTime < arg1.submitTime
	end)

	arg0.receivedTasks = underscore.map(arg0.receivedTasks, function(arg0)
		return arg0.id
	end)

	if arg0.usedCnt ~= var0 then
		arg0.usedCnt = var0

		local var3 = arg0.cookAct

		var3.data1 = arg0.usedCnt

		getProxy(ActivityProxy):updateActivity(var3)

		return
	end

	local var4 = arg0.remainCnt == 0 and arg0.usedCnt or arg0.usedCnt + 1

	if arg0.remainCnt == 0 then
		arg0.curTaskId = arg0.receivedTasks[#arg0.receivedTasks]
	else
		arg0.curTaskId = var1[arg0.randomSeed[var4] % #var1 + 1]
	end
end

function var0.UpdateCookUI(arg0)
	local var0 = arg0.remainCnt == 0 and arg0.usedCnt or arg0.usedCnt + 1

	setText(arg0.cookProgress, var0 .. "/" .. arg0.totalCookCnt)

	local var1 = arg0.taskProxy:getTaskVO(arg0.curTaskId)
	local var2 = var1:getConfig("award_display")[1]
	local var3 = {
		type = var2[1],
		id = var2[2],
		count = var2[3]
	}

	updateDrop(arg0.cookAwardTF, var3)

	local var4 = var1:getTaskStatus() == 2

	setActive(arg0:findTF("got", arg0.cookAwardTF), var4)
	setActive(arg0:findTF("icon_bg/count", arg0.cookAwardTF), var4)
	setText(arg0:findTF("Text", arg0.dialogTF), i18n(arg0.cookCfg[arg0.curTaskId][3]))

	local var5 = var4 and arg0.cookCfg[arg0.curTaskId][2] .. "_2" or "unknown"

	GetImageSpriteFromAtlasAsync("ui/activityuipage/NewYearsEveDinnerPage_atlas", arg0.cookCfg[arg0.curTaskId][2], arg0.foodTF, true)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/NewYearsEveDinnerPage_atlas", var5, arg0.titleFoodTF, true)

	arg0.prefabName = arg0.cookCfg[arg0.curTaskId][1]

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(arg0.prefabName, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.modelTf = tf(arg0)
		arg0.modelTf.localPosition = Vector3(0, 0, 0)
		arg0.modelTf.localScale = Vector3(1, 1, 1)

		arg0:ClearRole()
		setParent(arg0.modelTf, arg0.roleTF)
		arg0:PlayRoleAnim()
	end)
end

function var0.ClearRole(arg0)
	arg0.isMoving = false

	if LeanTween.isTweening(arg0.roleTF) then
		LeanTween.cancel(arg0.roleTF)
	end

	removeAllChildren(arg0.roleTF)
end

function var0.PlayRoleAnim(arg0)
	local var0 = arg0.taskProxy:getTaskVO(arg0.curTaskId):getTaskStatus() == 2
	local var1 = arg0.modelTf:GetComponent("SpineAnimUI")

	setActive(arg0.foodTF, false)
	setActive(arg0.dialogTF, false)
	setActive(arg0:findTF("shine", arg0.cookBtn), false)

	if var0 then
		setAnchoredPosition(arg0.roleTF, var4)
		var1:SetAction("normal", 0)
		setActive(arg0.foodTF, true)
		setActive(arg0.dialogTF, true)
		setActive(arg0:findTF("shine", arg0.cookBtn), not var0 and arg0.remainCnt > 0)
	else
		var1:SetAction("move", 0)

		arg0.isMoving = true

		setAnchoredPosition(arg0.roleTF, var3)
		arg0:managedTween(LeanTween.moveX, function()
			var1:SetAction("normal", 0)

			arg0.isMoving = false

			setActive(arg0.foodTF, var0)
			setActive(arg0.dialogTF, var0)
			setActive(arg0:findTF("shine", arg0.cookBtn), not var0 and arg0.remainCnt > 0)
		end, arg0.roleTF, var4.x, var1):setEase(LeanTweenType.linear)
	end
end

function var0.OnDestroy(arg0)
	if arg0.prefabName and arg0.modelTf then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.prefabName, arg0.modelTf.gameObject)

		arg0.prefabName = nil
		arg0.modelTf = nil
	end

	arg0:cleanManagedTween()
end

return var0
