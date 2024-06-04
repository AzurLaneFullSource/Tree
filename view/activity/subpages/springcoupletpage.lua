local var0 = class("SpringCoupletPage", import("...base.BaseActivityPage"))
local var1 = 7
local var2 = 7
local var3 = 7
local var4 = 400
local var5 = 72
local var6 = 1
local var7 = "ui/activityuipage/springcoupletpage_atlas"
local var8 = "couplete_activty_desc"
local var9 = "couplete_click_desc"
local var10 = "couplet_index_desc"
local var11 = "couplete_help"
local var12 = "couplete_drag_tip"
local var13 = "couplete_remind"
local var14 = "couplete_complete"
local var15 = "couplete_enter"
local var16 = "couplete_stay"
local var17 = "couplete_task"
local var18 = {
	"couplete_pass_1",
	"couplete_pass_2"
}
local var19 = {
	"couplete_fail_1",
	"couplete_fail_2"
}
local var20 = 20

function var0.OnInit(arg0)
	arg0.itemTpl = findTF(arg0._tf, "AD/itemTpl")
	arg0.iconTpl = findTF(arg0._tf, "AD/iconTpl")
	arg0.wordTpl = findTF(arg0._tf, "AD/wordTpl")
	arg0.itemContainer = findTF(arg0._tf, "AD/itemContainer")
	arg0.taskIcon = findTF(arg0._tf, "AD/task/icon")
	arg0.taskSlider = findTF(arg0._tf, "AD/task/Slider")
	arg0.taskBtnGet = findTF(arg0._tf, "AD/task/btnGet")
	arg0.taskBtnGot = findTF(arg0._tf, "AD/task/btnGot")
	arg0.taskBtnGo = findTF(arg0._tf, "AD/task/btnGo")
	arg0.taskDesc = findTF(arg0._tf, "AD/task/desc")
	arg0.taskCur = findTF(arg0._tf, "AD/task/cur")
	arg0.taskMax = findTF(arg0._tf, "AD/task/max")
	arg0.finalAward = findTF(arg0._tf, "AD/finalAward")
	arg0.charPos = findTF(arg0._tf, "AD/charPos")
	arg0.charClick = findTF(arg0.charPos, "click")
	arg0.btnConfirm = findTF(arg0._tf, "AD/btnConfirm")
	arg0.imgComplete = findTF(arg0._tf, "AD/imgComplete")
	arg0.charTip = findTF(arg0._tf, "AD/charTip")

	setActive(arg0.charTip, false)

	arg0.btnHelp = findTF(arg0._tf, "AD/btnHelp")
	arg0.remindDesc = findTF(arg0._tf, "AD/remindDesc")

	setText(arg0.remindDesc, i18n(var9))

	arg0.dragTip = findTF(arg0._tf, "AD/dragTip")

	setText(arg0.dragTip, i18n(var12))

	arg0.btnPre = findTF(arg0._tf, "AD/pre")
	arg0.btnNext = findTF(arg0._tf, "AD/next")
	arg0.activityDesc = findTF(arg0._tf, "AD/desc")

	setText(arg0.activityDesc, i18n(var8))

	arg0.coupletUpImg = GetComponent(findTF(arg0._tf, "AD/coupletUp/contents/img"), typeof(Image))
	arg0.coupletUpContents = findTF(arg0._tf, "AD/coupletUp/contents")
	arg0.coupletBottomContents = findTF(arg0._tf, "AD/coupletBottom/contents")
	arg0.coupletUpLock = findTF(arg0._tf, "AD/coupletUp/lock")
	arg0.coupletBottomLock = findTF(arg0._tf, "AD/coupletBottom/lock")
	arg0.awardIcon = tf(instantiate(arg0.iconTpl))
	arg0.awardIcon.anchoredPosition = Vector2(0, 0)

	setActive(arg0.awardIcon, true)
	setParent(arg0.awardIcon, arg0.taskIcon)

	arg0.countDesc = findTF(arg0._tf, "AD/countDesc")
	arg0.items = {}

	for iter0 = 1, var2 do
		local var0 = tf(instantiate(arg0.itemTpl))

		setActive(var0, true)
		setParent(var0, arg0.itemContainer)
		table.insert(arg0.items, var0)
	end

	arg0.coupletBottomWords = {}

	for iter1 = 1, var3 do
		local var1 = arg0:createWord(iter1, arg0.coupletBottomContents)

		arg0:addCoupletWordEvent(var1)
		table.insert(arg0.coupletBottomWords, var1)
	end

	arg0._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 2, -1)

	arg0.timer:Start()
	onButton(arg0, arg0.btnConfirm, function()
		arg0:finishCouplete()
	end)
	onButton(arg0, arg0.btnPre, function()
		arg0.coupletIndex = arg0.coupletIndex - 1

		arg0:selectCoupletChange()
	end)
	onButton(arg0, arg0.btnNext, function()
		arg0.coupletIndex = arg0.coupletIndex + 1

		arg0:selectCoupletChange()
	end)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.couplete_help.tip
		})
	end)
	onButton(arg0, arg0.charClick, function()
		if not arg0.charClickCount then
			arg0.charClickCount = 0
		end

		arg0.charClickCount = arg0.charClickCount + 1

		if arg0.charClickCount % 3 == 0 and not arg0.coupletComplete and arg0.coupletUnLock then
			arg0:showTips(i18n(var13, i18n("couplete_pair_" .. arg0.coupletIndex)), true)
		end
	end)
	onButton(arg0, arg0.taskBtnGo, function()
		arg0:emit(ActivityMediator.ON_TASK_GO, arg0.taskVO)
	end, SFX_PANEL)
	onButton(arg0, arg0.taskBtnGet, function()
		pg.m02:sendNotification(GAME.SUBMIT_TASK, {
			virtual = false,
			normal_submit = true,
			taskId = arg0.taskVO.id
		})
		arg0:showTips(i18n(var15), true)
	end, SFX_PANEL)

	local var2 = Ship.New({
		configId = 502011,
		skin_id = 502010
	}):getPrefab()

	PoolMgr.GetInstance():GetSpineChar(var2, true, function(arg0)
		arg0.model = arg0
		arg0.model.transform.localScale = Vector3(0.7, 0.7, 0.7)
		arg0.model.transform.localPosition = Vector3.zero

		arg0.model.transform:SetParent(findTF(arg0.charPos, "pos"), false)

		arg0.anim = arg0.model:GetComponent(typeof(SpineAnimUI))

		arg0.anim:SetAction("stand", 0)
	end)
end

function var0.OnShowFlush(arg0)
	arg0.tipStayIndex = var20

	if arg0.data1List and arg0.data2List and #arg0.data1List ~= #arg0.data2List then
		arg0:showTips(i18n(var15))
	elseif arg0.data1List and arg0.data2List and #arg0.data1List == #arg0.data2List and not arg0.coupletFinishAll then
		arg0:showTips(i18n(var17))
	elseif arg0.coupletFinishAll then
		arg0:showTips(i18n(var14))
	end
end

function var0.OnHideFlush(arg0)
	setActive(arg0.charTip, false)
end

function var0.OnDataSetting(arg0)
	if not arg0.coupletIds then
		arg0.coupletIds = arg0.activity:getConfig("config_client").couplet
		arg0.coupletDatas = {}

		for iter0 = 1, #arg0.coupletIds do
			local var0 = pg.activity_spring_couplets[arg0.coupletIds[iter0]]

			table.insert(arg0.coupletDatas, var0)
		end
	end

	arg0.taskProxy = getProxy(TaskProxy)

	local var1 = arg0.activity:getConfig("config_client").linkActID

	arg0.taskActivity = getProxy(ActivityProxy):getActivityById(var1)
	arg0.taskGroup = arg0.taskActivity:getConfig("config_data")
	arg0.tipStayIndex = var20

	return updateActivityTaskStatus(arg0.taskActivity)
end

function var0.onTimer(arg0)
	if arg0.tipStayIndex and arg0.tipStayIndex > 0 then
		arg0.tipStayIndex = arg0.tipStayIndex - 1
	elseif arg0.tipStayIndex == 0 then
		arg0.tipStayIndex = -1

		arg0:showTips(i18n(var16), true)
	end

	if arg0.charClickCount and arg0.charClickCount > 0 then
		arg0.charClickCount = arg0.charClickCount - 1
	end
end

function var0.OnFirstFlush(arg0)
	arg0:updateUI()
	arg0:finishAll()
end

function var0.OnUpdateFlush(arg0)
	arg0:updateUI()
end

function var0.updateUI(arg0)
	arg0.data1 = arg0.activity.data1
	arg0.data2 = arg0.activity.data2
	arg0.data3 = arg0.activity.data3
	arg0.data1List = arg0.activity.data1_list
	arg0.data2List = arg0.activity.data2_list
	arg0.data3List = arg0.activity.data3_list
	arg0.coupletFinishAll = false

	if arg0.data2List and #arg0.data2List == #arg0.coupletIds then
		arg0.coupletFinishAll = true
	end

	arg0.coupletIndex = 1

	for iter0 = #arg0.coupletIds, 1, -1 do
		local var0 = arg0.coupletIds[iter0]

		if table.contains(arg0.data1List, var0) and not table.contains(arg0.data2List, var0) then
			arg0.coupletIndex = iter0
		end

		local var1 = table.contains(arg0.data2List, var0) or false
		local var2 = table.contains(arg0.data1List, var0) or false
		local var3 = arg0.items[iter0]

		setActive(findTF(var3, "got"), var1 or false)
		setActive(findTF(var3, "bgMask"), not var2 or var1 or false)
		setActive(findTF(var3, "red"), var2)
		setActive(findTF(var3, "lock"), not var2 or false)

		if iter0 == 7 then
			setActive(findTF(arg0.finalAward, "lock"), not var2 or false)
			setActive(findTF(arg0.finalAward, "mask"), not var2 or var1 or false)
			setActive(findTF(arg0.finalAward, "got"), arg0.coupletFinishAll)
		end
	end

	arg0:selectCoupletChange()
	arg0:updateCoupletWord()
	arg0:updateTask()
end

function var0.finishAll(arg0)
	if #arg0.data2List == #arg0.coupletIds and #arg0.data2List == #arg0.data1List and arg0.activity.data1 == 0 then
		pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
			cmd = 1,
			actId = arg0.activity.id
		})
	end
end

function var0.updateTask(arg0)
	arg0.nday = arg0.taskActivity.data3

	local var0 = arg0.taskGroup[arg0.nday][1]
	local var1 = arg0.taskProxy:getTaskById(var0) or arg0.taskProxy:getFinishTaskById(var0)

	arg0.taskVO = var1

	local var2 = var1:getConfig("award_display")[1]
	local var3 = {
		type = var2[1],
		id = var2[2],
		count = var2[3]
	}

	updateDrop(arg0.awardIcon, var3)
	onButton(arg0, arg0.taskIcon, function()
		arg0:emit(BaseUI.ON_DROP, var3)
	end, SFX_PANEL)

	local var4 = var1:getConfig("desc")

	setText(arg0.taskDesc, var4)

	local var5 = var1:getTaskStatus()

	setActive(arg0.taskBtnGo, var5 == 0)
	setActive(arg0.taskBtnGet, var5 == 1)
	setActive(arg0.taskBtnGot, var5 == 2)

	local var6 = var1:getProgress()
	local var7 = var1:getConfig("target_num")

	setSlider(arg0.taskSlider, 0, var7, var6)
	setText(arg0.taskCur, var6)
	setText(arg0.taskMax, "/" .. var7)
end

function var0.finishCouplete(arg0)
	if arg0.coupletUnLock and not arg0.coupletComplete then
		local var0 = arg0.coupletIds[arg0.coupletIndex]
		local var1 = arg0.coupletDatas[arg0.coupletIndex].repeated_jp

		for iter0 = 1, #arg0.coupletBottomWords do
			local var2 = arg0.coupletBottomWords[iter0]
			local var3 = false

			if var2.index == var2.swapIndex then
				var3 = true
			elseif PLATFORM_CODE == PLATFORM_JP and var1 and #var1 > 0 then
				for iter1 = 1, #var1 do
					local var4 = var1[iter1]

					if table.contains(var4, var2.index) and table.contains(var4, var2.swapIndex) then
						var3 = true
					end
				end
			end

			if not var3 then
				arg0:showTips(var19, true)

				return
			end
		end

		if table.contains(arg0.data1List, var0) and not table.contains(arg0.activity.data2_list, var0) then
			local var5

			if #arg0.activity.data2_list == #arg0.coupletIds - 1 then
				function var5(arg0)
					arg0:emit(ActivityMediator.NEXT_DISPLAY_AWARD, arg0)
					arg0:finishAll()
				end

				arg0:showTips(i18n(var14), true)
			else
				arg0:showTips(var18, true)
			end

			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = var0,
				actId = arg0.activity.id,
				awardCallback = var5
			})
		end
	elseif not arg0.coupletUnLock then
		-- block empty
	elseif arg0.coupletComplete then
		-- block empty
	end
end

function var0.selectCoupletChange(arg0)
	if arg0.coupletIndex > var1 then
		arg0.coupletIndex = 1
	end

	if arg0.coupletIndex <= 0 then
		arg0.coupletIndex = var1
	end

	local var0 = arg0.coupletIds[arg0.coupletIndex]

	arg0.coupletComplete = table.contains(arg0.data2List, var0) or false
	arg0.coupletUnLock = table.contains(arg0.data1List, var0) or false

	if not arg0.coupletUnLock then
		arg0.btnConfirm:GetComponent("UIGrayScale").enabled = true
		arg0.btnConfirm:GetComponent("Image").raycastTarget = false

		setActive(arg0.imgComplete, false)
		setActive(arg0.btnConfirm, true)
	elseif arg0.coupletComplete then
		setActive(arg0.imgComplete, true)
		setActive(arg0.btnConfirm, false)
	else
		arg0.btnConfirm:GetComponent("UIGrayScale").enabled = false
		arg0.btnConfirm:GetComponent("Image").raycastTarget = true

		setActive(arg0.imgComplete, false)
		setActive(arg0.btnConfirm, true)
	end

	arg0:updateCoupletWord()
end

function var0.updateCoupletWord(arg0)
	local var0 = GetSpriteFromAtlas(var7, "couplet_" .. arg0.coupletIndex .. "_list")

	setImageSprite(arg0.coupletUpImg, var0)
	setActive(arg0.coupletUpContents, arg0.coupletUnLock)
	setActive(arg0.coupletUpLock, not arg0.coupletUnLock)

	local var1 = {}

	if not arg0.coupletComplete then
		for iter0 = 1, var3 do
			table.insert(var1, iter0)
		end
	end

	for iter1 = 1, #arg0.coupletBottomWords do
		local var2 = arg0.coupletBottomWords[iter1]
		local var3

		if #var1 > 0 then
			var3 = table.remove(var1, math.random(1, #var1))
		else
			var3 = iter1
		end

		var2.swapIndex = var3
		var2.tf.anchoredPosition = arg0:getWordPosition(var3)

		setImageSprite(findTF(var2.tf, "img"), GetSpriteFromAtlas(var7, "couplet_" .. arg0.coupletIndex .. "_" .. var2.index), true)

		local var4 = false
		local var5 = arg0.coupletDatas[arg0.coupletIndex].repeated_jp

		if var2.index == var2.swapIndex then
			var4 = var2.index == var2.swapIndex
		elseif PLATFORM_CODE == PLATFORM_JP and var5 and #var5 > 0 then
			for iter2 = 1, #var5 do
				local var6 = var5[iter2]

				if table.contains(var6, var2.index) and table.contains(var6, var2.swapIndex) then
					var4 = true
				end
			end
		end

		setActive(findTF(var2.tf, "bgOn"), var4)
		GetComponent(findTF(var2.tf, "bgOn"), typeof(Image)):SetNativeSize()
		GetComponent(findTF(var2.tf, "bgOff"), typeof(Image)):SetNativeSize()
	end

	setActive(arg0.coupletBottomContents, arg0.coupletUnLock)
	setActive(arg0.coupletBottomLock, not arg0.coupletUnLock)
	setText(arg0.countDesc, i18n(var10, arg0.coupletIndex))
end

function var0.addCoupletWordEvent(arg0, arg1)
	local var0 = arg1.event
	local var1 = arg1.tf
	local var2 = arg1.parent

	var0:AddBeginDragFunc(function(arg0, arg1)
		if arg0.coupletUnLock and not arg0.coupletComplete and not arg0.swapWord then
			arg0.swapWord = arg1
		end
	end)
	var0:AddDragFunc(function(arg0, arg1)
		if arg0.swapWord then
			local var0 = arg1.position

			var0.y = var0.y

			local var1 = arg0._uiCamera:ScreenToWorldPoint(var0)
			local var2 = arg0:getWordByPosition(var1)

			if var2 and arg0.swapWord ~= var2 then
				local var3 = var2.swapIndex

				var2.swapIndex = arg0.swapWord.swapIndex
				arg0.swapWord.swapIndex = var3

				arg0:tweenWord(arg0.swapWord)
				arg0:tweenWord(var2)
			end
		end
	end)
	var0:AddDragEndFunc(function(arg0, arg1)
		arg0.swapWord = nil
	end)
end

function var0.createWord(arg0, arg1, arg2)
	local var0 = tf(instantiate(arg0.wordTpl))

	setParent(var0, arg2)
	setActive(var0, true)

	var0.anchoredPosition = arg0:getWordPosition(arg1)

	local var1 = GetComponent(var0, typeof(EventTriggerListener))

	return {
		tf = var0,
		index = arg1,
		swapIndex = arg1,
		event = var1,
		parent = arg2
	}
end

function var0.getWordByPosition(arg0, arg1)
	local var0 = arg0.coupletBottomContents:InverseTransformPoint(arg1)

	if math.abs(var0.x) < var4 / 2 then
		local var1 = math.floor(math.abs((var0.y - var5 / 2) / var5)) + 1

		for iter0 = 1, #arg0.coupletBottomWords do
			if arg0.coupletBottomWords[iter0].swapIndex == var1 then
				return arg0.coupletBottomWords[iter0]
			end
		end
	end
end

function var0.getWordPosition(arg0, arg1)
	local var0 = (arg1 - 1) % var6
	local var1 = math.floor((arg1 - 1) / var6)

	return Vector2(var0 * var4, -var1 * var5)
end

function var0.tweenWord(arg0, arg1)
	local var0 = arg1.swapIndex
	local var1 = arg0:getWordPosition(var0)

	if LeanTween.isTweening(go(arg1.tf)) then
		LeanTween.cancel(go(arg1.tf))
	end

	LeanTween.value(go(arg1.tf), arg1.tf.anchoredPosition.y, var1.y, 0.1):setOnUpdate(System.Action_float(function(arg0)
		arg1.tf.anchoredPosition = Vector2(arg1.tf.anchoredPosition.x, arg0)
	end)):setOnComplete(System.Action(function()
		local var0 = false
		local var1 = arg0.coupletDatas[arg0.coupletIndex].repeated_jp

		if arg1.index == arg1.swapIndex then
			var0 = arg1.index == arg1.swapIndex
		elseif PLATFORM_CODE == PLATFORM_JP and var1 and #var1 > 0 then
			for iter0 = 1, #var1 do
				local var2 = var1[iter0]

				if table.contains(var2, arg1.index) and table.contains(var2, arg1.swapIndex) then
					var0 = true
				end
			end
		end

		setActive(findTF(arg1.tf, "bgOn"), var0)
	end))
end

function var0.clearTween(arg0)
	for iter0 = 1, #arg0.coupletBottomWords do
		local var0 = arg0.coupletBottomWords[iter0]

		if LeanTween.isTweening(go(var0.tf)) then
			LeanTween.cancel(go(var0.tf))
		end
	end
end

function var0.showTips(arg0, arg1, arg2)
	if type(arg1) == "table" then
		if arg1 and #arg1 > 0 then
			arg0.tipTime = Time.realtimeSinceStartup

			local var0 = i18n(arg1[math.random(1, #arg1)])

			setText(findTF(arg0.charTip, "text"), var0)
			setActive(arg0.charTip, false)
			setActive(arg0.charTip, true)
		end
	else
		arg0.tipTime = Time.realtimeSinceStartup

		setText(findTF(arg0.charTip, "text"), arg1)
		setActive(arg0.charTip, false)
		setActive(arg0.charTip, true)
	end
end

function var0.OnDestroy(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	if arg0.model then
		PoolMgr.GetInstance():ReturnSpineChar(502011, arg0.model)
	end

	arg0:clearTween()
end

return var0
