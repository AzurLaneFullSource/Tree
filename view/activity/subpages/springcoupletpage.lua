local var0_0 = class("SpringCoupletPage", import("...base.BaseActivityPage"))
local var1_0 = 7
local var2_0 = 7
local var3_0 = 7
local var4_0 = 400
local var5_0 = 72
local var6_0 = 1
local var7_0 = "ui/activityuipage/springcoupletpage_atlas"
local var8_0 = "couplete_activty_desc"
local var9_0 = "couplete_click_desc"
local var10_0 = "couplet_index_desc"
local var11_0 = "couplete_help"
local var12_0 = "couplete_drag_tip"
local var13_0 = "couplete_remind"
local var14_0 = "couplete_complete"
local var15_0 = "couplete_enter"
local var16_0 = "couplete_stay"
local var17_0 = "couplete_task"
local var18_0 = {
	"couplete_pass_1",
	"couplete_pass_2"
}
local var19_0 = {
	"couplete_fail_1",
	"couplete_fail_2"
}
local var20_0 = 20

function var0_0.OnInit(arg0_1)
	arg0_1.itemTpl = findTF(arg0_1._tf, "AD/itemTpl")
	arg0_1.iconTpl = findTF(arg0_1._tf, "AD/iconTpl")
	arg0_1.wordTpl = findTF(arg0_1._tf, "AD/wordTpl")
	arg0_1.itemContainer = findTF(arg0_1._tf, "AD/itemContainer")
	arg0_1.taskIcon = findTF(arg0_1._tf, "AD/task/icon")
	arg0_1.taskSlider = findTF(arg0_1._tf, "AD/task/Slider")
	arg0_1.taskBtnGet = findTF(arg0_1._tf, "AD/task/btnGet")
	arg0_1.taskBtnGot = findTF(arg0_1._tf, "AD/task/btnGot")
	arg0_1.taskBtnGo = findTF(arg0_1._tf, "AD/task/btnGo")
	arg0_1.taskDesc = findTF(arg0_1._tf, "AD/task/desc")
	arg0_1.taskCur = findTF(arg0_1._tf, "AD/task/cur")
	arg0_1.taskMax = findTF(arg0_1._tf, "AD/task/max")
	arg0_1.finalAward = findTF(arg0_1._tf, "AD/finalAward")
	arg0_1.charPos = findTF(arg0_1._tf, "AD/charPos")
	arg0_1.charClick = findTF(arg0_1.charPos, "click")
	arg0_1.btnConfirm = findTF(arg0_1._tf, "AD/btnConfirm")
	arg0_1.imgComplete = findTF(arg0_1._tf, "AD/imgComplete")
	arg0_1.charTip = findTF(arg0_1._tf, "AD/charTip")

	setActive(arg0_1.charTip, false)

	arg0_1.btnHelp = findTF(arg0_1._tf, "AD/btnHelp")
	arg0_1.remindDesc = findTF(arg0_1._tf, "AD/remindDesc")

	setText(arg0_1.remindDesc, i18n(var9_0))

	arg0_1.dragTip = findTF(arg0_1._tf, "AD/dragTip")

	setText(arg0_1.dragTip, i18n(var12_0))

	arg0_1.btnPre = findTF(arg0_1._tf, "AD/pre")
	arg0_1.btnNext = findTF(arg0_1._tf, "AD/next")
	arg0_1.activityDesc = findTF(arg0_1._tf, "AD/desc")

	setText(arg0_1.activityDesc, i18n(var8_0))

	arg0_1.coupletUpImg = GetComponent(findTF(arg0_1._tf, "AD/coupletUp/contents/img"), typeof(Image))
	arg0_1.coupletUpContents = findTF(arg0_1._tf, "AD/coupletUp/contents")
	arg0_1.coupletBottomContents = findTF(arg0_1._tf, "AD/coupletBottom/contents")
	arg0_1.coupletUpLock = findTF(arg0_1._tf, "AD/coupletUp/lock")
	arg0_1.coupletBottomLock = findTF(arg0_1._tf, "AD/coupletBottom/lock")
	arg0_1.awardIcon = tf(instantiate(arg0_1.iconTpl))
	arg0_1.awardIcon.anchoredPosition = Vector2(0, 0)

	setActive(arg0_1.awardIcon, true)
	setParent(arg0_1.awardIcon, arg0_1.taskIcon)

	arg0_1.countDesc = findTF(arg0_1._tf, "AD/countDesc")
	arg0_1.items = {}

	for iter0_1 = 1, var2_0 do
		local var0_1 = tf(instantiate(arg0_1.itemTpl))

		setActive(var0_1, true)
		setParent(var0_1, arg0_1.itemContainer)
		table.insert(arg0_1.items, var0_1)
	end

	arg0_1.coupletBottomWords = {}

	for iter1_1 = 1, var3_0 do
		local var1_1 = arg0_1:createWord(iter1_1, arg0_1.coupletBottomContents)

		arg0_1:addCoupletWordEvent(var1_1)
		table.insert(arg0_1.coupletBottomWords, var1_1)
	end

	arg0_1._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	arg0_1.timer = Timer.New(function()
		arg0_1:onTimer()
	end, 2, -1)

	arg0_1.timer:Start()
	onButton(arg0_1, arg0_1.btnConfirm, function()
		arg0_1:finishCouplete()
	end)
	onButton(arg0_1, arg0_1.btnPre, function()
		arg0_1.coupletIndex = arg0_1.coupletIndex - 1

		arg0_1:selectCoupletChange()
	end)
	onButton(arg0_1, arg0_1.btnNext, function()
		arg0_1.coupletIndex = arg0_1.coupletIndex + 1

		arg0_1:selectCoupletChange()
	end)
	onButton(arg0_1, arg0_1.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.couplete_help.tip
		})
	end)
	onButton(arg0_1, arg0_1.charClick, function()
		if not arg0_1.charClickCount then
			arg0_1.charClickCount = 0
		end

		arg0_1.charClickCount = arg0_1.charClickCount + 1

		if arg0_1.charClickCount % 3 == 0 and not arg0_1.coupletComplete and arg0_1.coupletUnLock then
			arg0_1:showTips(i18n(var13_0, i18n("couplete_pair_" .. arg0_1.coupletIndex)), true)
		end
	end)
	onButton(arg0_1, arg0_1.taskBtnGo, function()
		arg0_1:emit(ActivityMediator.ON_TASK_GO, arg0_1.taskVO)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.taskBtnGet, function()
		pg.m02:sendNotification(GAME.SUBMIT_TASK, {
			virtual = false,
			normal_submit = true,
			taskId = arg0_1.taskVO.id
		})
		arg0_1:showTips(i18n(var15_0), true)
	end, SFX_PANEL)

	local var2_1 = Ship.New({
		configId = 502011,
		skin_id = 502010
	}):getPrefab()

	PoolMgr.GetInstance():GetSpineChar(var2_1, true, function(arg0_10)
		arg0_1.model = arg0_10
		arg0_1.model.transform.localScale = Vector3(0.7, 0.7, 0.7)
		arg0_1.model.transform.localPosition = Vector3.zero

		arg0_1.model.transform:SetParent(findTF(arg0_1.charPos, "pos"), false)

		arg0_1.anim = arg0_1.model:GetComponent(typeof(SpineAnimUI))

		arg0_1.anim:SetAction("stand", 0)
	end)
end

function var0_0.OnShowFlush(arg0_11)
	arg0_11.tipStayIndex = var20_0

	if arg0_11.data1List and arg0_11.data2List and #arg0_11.data1List ~= #arg0_11.data2List then
		arg0_11:showTips(i18n(var15_0))
	elseif arg0_11.data1List and arg0_11.data2List and #arg0_11.data1List == #arg0_11.data2List and not arg0_11.coupletFinishAll then
		arg0_11:showTips(i18n(var17_0))
	elseif arg0_11.coupletFinishAll then
		arg0_11:showTips(i18n(var14_0))
	end
end

function var0_0.OnHideFlush(arg0_12)
	setActive(arg0_12.charTip, false)
end

function var0_0.OnDataSetting(arg0_13)
	if not arg0_13.coupletIds then
		arg0_13.coupletIds = arg0_13.activity:getConfig("config_client").couplet
		arg0_13.coupletDatas = {}

		for iter0_13 = 1, #arg0_13.coupletIds do
			local var0_13 = pg.activity_spring_couplets[arg0_13.coupletIds[iter0_13]]

			table.insert(arg0_13.coupletDatas, var0_13)
		end
	end

	arg0_13.taskProxy = getProxy(TaskProxy)

	local var1_13 = arg0_13.activity:getConfig("config_client").linkActID

	arg0_13.taskActivity = getProxy(ActivityProxy):getActivityById(var1_13)
	arg0_13.taskGroup = arg0_13.taskActivity:getConfig("config_data")
	arg0_13.tipStayIndex = var20_0

	return updateActivityTaskStatus(arg0_13.taskActivity)
end

function var0_0.onTimer(arg0_14)
	if arg0_14.tipStayIndex and arg0_14.tipStayIndex > 0 then
		arg0_14.tipStayIndex = arg0_14.tipStayIndex - 1
	elseif arg0_14.tipStayIndex == 0 then
		arg0_14.tipStayIndex = -1

		arg0_14:showTips(i18n(var16_0), true)
	end

	if arg0_14.charClickCount and arg0_14.charClickCount > 0 then
		arg0_14.charClickCount = arg0_14.charClickCount - 1
	end
end

function var0_0.OnFirstFlush(arg0_15)
	arg0_15:updateUI()
	arg0_15:finishAll()
end

function var0_0.OnUpdateFlush(arg0_16)
	arg0_16:updateUI()
end

function var0_0.updateUI(arg0_17)
	arg0_17.data1 = arg0_17.activity.data1
	arg0_17.data2 = arg0_17.activity.data2
	arg0_17.data3 = arg0_17.activity.data3
	arg0_17.data1List = arg0_17.activity.data1_list
	arg0_17.data2List = arg0_17.activity.data2_list
	arg0_17.data3List = arg0_17.activity.data3_list
	arg0_17.coupletFinishAll = false

	if arg0_17.data2List and #arg0_17.data2List == #arg0_17.coupletIds then
		arg0_17.coupletFinishAll = true
	end

	arg0_17.coupletIndex = 1

	for iter0_17 = #arg0_17.coupletIds, 1, -1 do
		local var0_17 = arg0_17.coupletIds[iter0_17]

		if table.contains(arg0_17.data1List, var0_17) and not table.contains(arg0_17.data2List, var0_17) then
			arg0_17.coupletIndex = iter0_17
		end

		local var1_17 = table.contains(arg0_17.data2List, var0_17) or false
		local var2_17 = table.contains(arg0_17.data1List, var0_17) or false
		local var3_17 = arg0_17.items[iter0_17]

		setActive(findTF(var3_17, "got"), var1_17 or false)
		setActive(findTF(var3_17, "bgMask"), not var2_17 or var1_17 or false)
		setActive(findTF(var3_17, "red"), var2_17)
		setActive(findTF(var3_17, "lock"), not var2_17 or false)

		if iter0_17 == 7 then
			setActive(findTF(arg0_17.finalAward, "lock"), not var2_17 or false)
			setActive(findTF(arg0_17.finalAward, "mask"), not var2_17 or var1_17 or false)
			setActive(findTF(arg0_17.finalAward, "got"), arg0_17.coupletFinishAll)
		end
	end

	arg0_17:selectCoupletChange()
	arg0_17:updateCoupletWord()
	arg0_17:updateTask()
end

function var0_0.finishAll(arg0_18)
	if #arg0_18.data2List == #arg0_18.coupletIds and #arg0_18.data2List == #arg0_18.data1List and arg0_18.activity.data1 == 0 then
		pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
			cmd = 1,
			actId = arg0_18.activity.id
		})
	end
end

function var0_0.updateTask(arg0_19)
	arg0_19.nday = arg0_19.taskActivity.data3

	local var0_19 = arg0_19.taskGroup[arg0_19.nday][1]
	local var1_19 = arg0_19.taskProxy:getTaskById(var0_19) or arg0_19.taskProxy:getFinishTaskById(var0_19)

	arg0_19.taskVO = var1_19

	local var2_19 = var1_19:getConfig("award_display")[1]
	local var3_19 = {
		type = var2_19[1],
		id = var2_19[2],
		count = var2_19[3]
	}

	updateDrop(arg0_19.awardIcon, var3_19)
	onButton(arg0_19, arg0_19.taskIcon, function()
		arg0_19:emit(BaseUI.ON_DROP, var3_19)
	end, SFX_PANEL)

	local var4_19 = var1_19:getConfig("desc")

	setText(arg0_19.taskDesc, var4_19)

	local var5_19 = var1_19:getTaskStatus()

	setActive(arg0_19.taskBtnGo, var5_19 == 0)
	setActive(arg0_19.taskBtnGet, var5_19 == 1)
	setActive(arg0_19.taskBtnGot, var5_19 == 2)

	local var6_19 = var1_19:getProgress()
	local var7_19 = var1_19:getConfig("target_num")

	setSlider(arg0_19.taskSlider, 0, var7_19, var6_19)
	setText(arg0_19.taskCur, var6_19)
	setText(arg0_19.taskMax, "/" .. var7_19)
end

function var0_0.finishCouplete(arg0_21)
	if arg0_21.coupletUnLock and not arg0_21.coupletComplete then
		local var0_21 = arg0_21.coupletIds[arg0_21.coupletIndex]
		local var1_21 = arg0_21.coupletDatas[arg0_21.coupletIndex].repeated_jp

		for iter0_21 = 1, #arg0_21.coupletBottomWords do
			local var2_21 = arg0_21.coupletBottomWords[iter0_21]
			local var3_21 = false

			if var2_21.index == var2_21.swapIndex then
				var3_21 = true
			elseif PLATFORM_CODE == PLATFORM_JP and var1_21 and #var1_21 > 0 then
				for iter1_21 = 1, #var1_21 do
					local var4_21 = var1_21[iter1_21]

					if table.contains(var4_21, var2_21.index) and table.contains(var4_21, var2_21.swapIndex) then
						var3_21 = true
					end
				end
			end

			if not var3_21 then
				arg0_21:showTips(var19_0, true)

				return
			end
		end

		if table.contains(arg0_21.data1List, var0_21) and not table.contains(arg0_21.activity.data2_list, var0_21) then
			local var5_21

			if #arg0_21.activity.data2_list == #arg0_21.coupletIds - 1 then
				function var5_21(arg0_22)
					arg0_21:emit(ActivityMediator.NEXT_DISPLAY_AWARD, arg0_22)
					arg0_21:finishAll()
				end

				arg0_21:showTips(i18n(var14_0), true)
			else
				arg0_21:showTips(var18_0, true)
			end

			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = var0_21,
				actId = arg0_21.activity.id,
				awardCallback = var5_21
			})
		end
	elseif not arg0_21.coupletUnLock then
		-- block empty
	elseif arg0_21.coupletComplete then
		-- block empty
	end
end

function var0_0.selectCoupletChange(arg0_23)
	if arg0_23.coupletIndex > var1_0 then
		arg0_23.coupletIndex = 1
	end

	if arg0_23.coupletIndex <= 0 then
		arg0_23.coupletIndex = var1_0
	end

	local var0_23 = arg0_23.coupletIds[arg0_23.coupletIndex]

	arg0_23.coupletComplete = table.contains(arg0_23.data2List, var0_23) or false
	arg0_23.coupletUnLock = table.contains(arg0_23.data1List, var0_23) or false

	if not arg0_23.coupletUnLock then
		arg0_23.btnConfirm:GetComponent("UIGrayScale").enabled = true
		arg0_23.btnConfirm:GetComponent("Image").raycastTarget = false

		setActive(arg0_23.imgComplete, false)
		setActive(arg0_23.btnConfirm, true)
	elseif arg0_23.coupletComplete then
		setActive(arg0_23.imgComplete, true)
		setActive(arg0_23.btnConfirm, false)
	else
		arg0_23.btnConfirm:GetComponent("UIGrayScale").enabled = false
		arg0_23.btnConfirm:GetComponent("Image").raycastTarget = true

		setActive(arg0_23.imgComplete, false)
		setActive(arg0_23.btnConfirm, true)
	end

	arg0_23:updateCoupletWord()
end

function var0_0.updateCoupletWord(arg0_24)
	local var0_24 = GetSpriteFromAtlas(var7_0, "couplet_" .. arg0_24.coupletIndex .. "_list")

	setImageSprite(arg0_24.coupletUpImg, var0_24)
	setActive(arg0_24.coupletUpContents, arg0_24.coupletUnLock)
	setActive(arg0_24.coupletUpLock, not arg0_24.coupletUnLock)

	local var1_24 = {}

	if not arg0_24.coupletComplete then
		for iter0_24 = 1, var3_0 do
			table.insert(var1_24, iter0_24)
		end
	end

	for iter1_24 = 1, #arg0_24.coupletBottomWords do
		local var2_24 = arg0_24.coupletBottomWords[iter1_24]
		local var3_24

		if #var1_24 > 0 then
			var3_24 = table.remove(var1_24, math.random(1, #var1_24))
		else
			var3_24 = iter1_24
		end

		var2_24.swapIndex = var3_24
		var2_24.tf.anchoredPosition = arg0_24:getWordPosition(var3_24)

		setImageSprite(findTF(var2_24.tf, "img"), GetSpriteFromAtlas(var7_0, "couplet_" .. arg0_24.coupletIndex .. "_" .. var2_24.index), true)

		local var4_24 = false
		local var5_24 = arg0_24.coupletDatas[arg0_24.coupletIndex].repeated_jp

		if var2_24.index == var2_24.swapIndex then
			var4_24 = var2_24.index == var2_24.swapIndex
		elseif PLATFORM_CODE == PLATFORM_JP and var5_24 and #var5_24 > 0 then
			for iter2_24 = 1, #var5_24 do
				local var6_24 = var5_24[iter2_24]

				if table.contains(var6_24, var2_24.index) and table.contains(var6_24, var2_24.swapIndex) then
					var4_24 = true
				end
			end
		end

		setActive(findTF(var2_24.tf, "bgOn"), var4_24)
		GetComponent(findTF(var2_24.tf, "bgOn"), typeof(Image)):SetNativeSize()
		GetComponent(findTF(var2_24.tf, "bgOff"), typeof(Image)):SetNativeSize()
	end

	setActive(arg0_24.coupletBottomContents, arg0_24.coupletUnLock)
	setActive(arg0_24.coupletBottomLock, not arg0_24.coupletUnLock)
	setText(arg0_24.countDesc, i18n(var10_0, arg0_24.coupletIndex))
end

function var0_0.addCoupletWordEvent(arg0_25, arg1_25)
	local var0_25 = arg1_25.event
	local var1_25 = arg1_25.tf
	local var2_25 = arg1_25.parent

	var0_25:AddBeginDragFunc(function(arg0_26, arg1_26)
		if arg0_25.coupletUnLock and not arg0_25.coupletComplete and not arg0_25.swapWord then
			arg0_25.swapWord = arg1_25
		end
	end)
	var0_25:AddDragFunc(function(arg0_27, arg1_27)
		if arg0_25.swapWord then
			local var0_27 = arg1_27.position

			var0_27.y = var0_27.y

			local var1_27 = arg0_25._uiCamera:ScreenToWorldPoint(var0_27)
			local var2_27 = arg0_25:getWordByPosition(var1_27)

			if var2_27 and arg0_25.swapWord ~= var2_27 then
				local var3_27 = var2_27.swapIndex

				var2_27.swapIndex = arg0_25.swapWord.swapIndex
				arg0_25.swapWord.swapIndex = var3_27

				arg0_25:tweenWord(arg0_25.swapWord)
				arg0_25:tweenWord(var2_27)
			end
		end
	end)
	var0_25:AddDragEndFunc(function(arg0_28, arg1_28)
		arg0_25.swapWord = nil
	end)
end

function var0_0.createWord(arg0_29, arg1_29, arg2_29)
	local var0_29 = tf(instantiate(arg0_29.wordTpl))

	setParent(var0_29, arg2_29)
	setActive(var0_29, true)

	var0_29.anchoredPosition = arg0_29:getWordPosition(arg1_29)

	local var1_29 = GetComponent(var0_29, typeof(EventTriggerListener))

	return {
		tf = var0_29,
		index = arg1_29,
		swapIndex = arg1_29,
		event = var1_29,
		parent = arg2_29
	}
end

function var0_0.getWordByPosition(arg0_30, arg1_30)
	local var0_30 = arg0_30.coupletBottomContents:InverseTransformPoint(arg1_30)

	if math.abs(var0_30.x) < var4_0 / 2 then
		local var1_30 = math.floor(math.abs((var0_30.y - var5_0 / 2) / var5_0)) + 1

		for iter0_30 = 1, #arg0_30.coupletBottomWords do
			if arg0_30.coupletBottomWords[iter0_30].swapIndex == var1_30 then
				return arg0_30.coupletBottomWords[iter0_30]
			end
		end
	end
end

function var0_0.getWordPosition(arg0_31, arg1_31)
	local var0_31 = (arg1_31 - 1) % var6_0
	local var1_31 = math.floor((arg1_31 - 1) / var6_0)

	return Vector2(var0_31 * var4_0, -var1_31 * var5_0)
end

function var0_0.tweenWord(arg0_32, arg1_32)
	local var0_32 = arg1_32.swapIndex
	local var1_32 = arg0_32:getWordPosition(var0_32)

	if LeanTween.isTweening(go(arg1_32.tf)) then
		LeanTween.cancel(go(arg1_32.tf))
	end

	LeanTween.value(go(arg1_32.tf), arg1_32.tf.anchoredPosition.y, var1_32.y, 0.1):setOnUpdate(System.Action_float(function(arg0_33)
		arg1_32.tf.anchoredPosition = Vector2(arg1_32.tf.anchoredPosition.x, arg0_33)
	end)):setOnComplete(System.Action(function()
		local var0_34 = false
		local var1_34 = arg0_32.coupletDatas[arg0_32.coupletIndex].repeated_jp

		if arg1_32.index == arg1_32.swapIndex then
			var0_34 = arg1_32.index == arg1_32.swapIndex
		elseif PLATFORM_CODE == PLATFORM_JP and var1_34 and #var1_34 > 0 then
			for iter0_34 = 1, #var1_34 do
				local var2_34 = var1_34[iter0_34]

				if table.contains(var2_34, arg1_32.index) and table.contains(var2_34, arg1_32.swapIndex) then
					var0_34 = true
				end
			end
		end

		setActive(findTF(arg1_32.tf, "bgOn"), var0_34)
	end))
end

function var0_0.clearTween(arg0_35)
	for iter0_35 = 1, #arg0_35.coupletBottomWords do
		local var0_35 = arg0_35.coupletBottomWords[iter0_35]

		if LeanTween.isTweening(go(var0_35.tf)) then
			LeanTween.cancel(go(var0_35.tf))
		end
	end
end

function var0_0.showTips(arg0_36, arg1_36, arg2_36)
	if type(arg1_36) == "table" then
		if arg1_36 and #arg1_36 > 0 then
			arg0_36.tipTime = Time.realtimeSinceStartup

			local var0_36 = i18n(arg1_36[math.random(1, #arg1_36)])

			setText(findTF(arg0_36.charTip, "text"), var0_36)
			setActive(arg0_36.charTip, false)
			setActive(arg0_36.charTip, true)
		end
	else
		arg0_36.tipTime = Time.realtimeSinceStartup

		setText(findTF(arg0_36.charTip, "text"), arg1_36)
		setActive(arg0_36.charTip, false)
		setActive(arg0_36.charTip, true)
	end
end

function var0_0.OnDestroy(arg0_37)
	if arg0_37.timer then
		arg0_37.timer:Stop()

		arg0_37.timer = nil
	end

	if arg0_37.model then
		PoolMgr.GetInstance():ReturnSpineChar(502011, arg0_37.model)
	end

	arg0_37:clearTween()
end

return var0_0
