local var0 = class("Monopoly3thReGame")
local var1 = 502041
local var2 = 502041
local var3
local var4
local var5 = 0.6
local var6 = 100
local var7 = "dafuweng_gold"
local var8 = "dafuweng_oil"
local var9 = "dafuweng_event"
local var10 = "dafuweng_walk"
local var11 = "stand"
local var12 = "dafuweng_stand"
local var13 = "dafuweng_jump"
local var14 = "dafuweng_run"
local var15 = "dafuweng_touch"
local var16 = 35

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._binder = arg1
	arg0._tf = arg2
	arg0._event = arg3
	arg0._configId = arg4

	arg0:initData()
	arg0:initUI()
	arg0:initEvent()
end

function var0.initData(arg0)
	arg0.leftCount = 0
	arg0.mapIds = pg.activity_event_monopoly[arg0._configId].map
	arg0.inAnimatedFlag = false
	arg0.lastBonusTimes = pg.activity_event_monopoly[arg0._configId].drop_times[1]
	arg0.randomMoveTiemr = Timer.New(function()
		arg0:checkPlayerRandomMove()
	end, 15, -1)
	arg0.awardsTimer = Timer.New(function()
		if arg0.awardTfs and #arg0.awardTfs > 0 then
			for iter0 = #arg0.awardTfs, 1, -1 do
				local var0 = arg0.awardTfs[iter0]
				local var1 = var0.anchoredPosition

				var1.y = var1.y + 3

				if var1.y >= 150 then
					Destroy(table.remove(arg0.awardTfs, iter0))
				else
					var0.anchoredPosition = var1
				end
			end
		end
	end, 0.0333333333333333, -1)

	arg0.awardsTimer:Start()
end

function var0.initUI(arg0)
	arg0.char = findTF(arg0._tf, "map/char")

	setActive(arg0.char, false)
	setText(findTF(arg0._tf, "desc"), i18n("monopoly3thre_tip"))

	arg0.btnStart = findTF(arg0._tf, "btnStart")
	arg0.btnAutoStart = findTF(arg0._tf, "btnAutoStart")

	setActive(arg0.btnStart, true)
	setActive(arg0.btnAutoStart, true)

	arg0.btnCancelAuto = findTF(arg0._tf, "btnCancelAuto")

	setActive(arg0.btnCancelAuto, false)

	arg0.btnHelp = findTF(arg0._tf, "btnHelp")
	arg0.btnRp = findTF(arg0._tf, "btnRp")
	arg0.commonAnim = findTF(arg0.btnRp, "rpAni"):GetComponent(typeof(Animator))
	arg0.labelLeftCountTip = findTF(arg0._tf, "countTip/labelLeftCountTip")
	arg0.labelLeftCount = findTF(arg0._tf, "countTip/labelLeftCount")
	arg0.labelDropShip = findTF(arg0._tf, "labelDropShip")
	arg0.labelLeftRpCount = findTF(arg0._tf, "labelLeftRpCount")
	arg0.cellPos = findTF(arg0._tf, "map/mask/posCell")
	arg0.tplCell = findTF(arg0._tf, "map/mask/posCell/tplCell")
	arg0.mapCells = {}
	arg0.curCellIndex = nil
	arg0.groundChildsList = {}
	arg0.groundMoveRate = {
		0.1,
		0.3,
		1
	}
	arg0.awardTf = findTF(arg0._tf, "awardTpl")
	arg0.awardParent = findTF(arg0.char, "award")

	for iter0 = 1, 3 do
		local var0 = findTF(arg0._tf, "map/mask/ground" .. iter0)
		local var1 = {}

		for iter1 = 1, var0.childCount do
			table.insert(var1, var0:GetChild(iter1 - 1))
		end

		table.insert(arg0.groundChildsList, var1)
	end

	local var2 = Ship.New({
		configId = var1,
		skin_id = var2
	}):getPrefab()

	PoolMgr.GetInstance():GetSpineChar(var2, true, function(arg0)
		arg0.model = arg0
		arg0.model.transform.localScale = Vector3.one
		arg0.model.transform.localPosition = Vector3.zero

		arg0.model.transform:SetParent(arg0.char, false)

		arg0.anim = arg0.model:GetComponent(typeof(SpineAnimUI))

		arg0:changeCharAction(var11, 0, nil)
		arg0:checkCharActive()
	end)
	arg0.randomMoveTiemr:Start()
end

function var0.initEvent(arg0)
	onButton(arg0._binder, arg0.btnAutoStart, function()
		setActive(arg0.btnCancelAuto, true)

		arg0.autoFlag = true

		arg0:start()
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnCancelAuto, function()
		setActive(arg0.btnCancelAuto, false)

		arg0.autoFlag = false
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnStart, function()
		arg0:start()
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_3th.tip
		})
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.char, function()
		if not arg0.model or arg0.inAnimatedFlag then
			return
		end

		if LeanTween.isTweening(go(arg0.cellPos)) then
			LeanTween.cancel(go(arg0.cellPos))
		end

		arg0:changeCharAction(var15, 1, function()
			arg0:changeCharAction(var11)
		end)
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnRp, function()
		if arg0.leftAwardCnt > 0 then
			arg0._event:emit(Monopoly3thRePage.ON_AWARD)
		end
	end, SFX_PANEL)
end

function var0.addAwards(arg0, arg1)
	if not arg0.awardTfs then
		arg0.awardTfs = {}
	end

	for iter0 = 1, #arg1 do
		local var0 = arg1[iter0]
		local var1 = tf(instantiate(go(arg0.awardTf)))

		setParent(var1, arg0.awardParent)
		updateDrop(var1, var0)

		var1.anchoredPosition = Vector2(0, 0)

		setActive(var1, true)
		table.insert(arg0.awardTfs, var1)
	end
end

function var0.start(arg0)
	if arg0.inAnimatedFlag then
		return
	end

	if arg0.leftCount and arg0.leftCount <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

		if arg0.autoFlag and not arg0:checkLastBonus() then
			arg0.autoFlag = false

			setActive(arg0.btnCancelAuto, false)
			arg0:changeAnimeState(false, true)
		end

		return
	end

	arg0:changeAnimeState(true)
	arg0._event:emit(Monopoly3thRePage.ON_START, arg0.activity.id, function(arg0)
		if arg0 and arg0 > 0 then
			arg0.step = arg0

			arg0:updataUI()
			arg0:checkCharActive()
		end
	end)
end

function var0.checkPlayerRandomMove(arg0)
	if not arg0.model or arg0.inAnimatedFlag then
		return
	end

	if math.random() > 0.5 then
		local var0 = math.random(2, 4)
		local var1 = 300 * var0
		local var2 = var0 * 2
		local var3 = 0

		arg0:changeCharAction(var10, 0, nil)
		LeanTween.value(go(arg0.cellPos), 0, var1, var2):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0)
			arg0:updateMap(arg0 - var3)

			var3 = arg0
		end)):setOnComplete(System.Action(function()
			arg0:changeCharAction(var11, 0, nil)
		end))
	else
		arg0:changeCharAction(var12, 1, function()
			arg0:changeCharAction(var11)
		end)
	end
end

function var0.checkCountStory(arg0, arg1)
	local var0 = arg0.useCount
	local var1 = arg0.activity:getDataConfig("story") or {}
	local var2 = _.detect(var1, function(arg0)
		return arg0[1] == var0
	end)

	if var2 then
		pg.NewStoryMgr.GetInstance():Play(var2[2], arg1)
	else
		arg1()
	end
end

function var0.changeAnimeState(arg0, arg1, arg2)
	if arg1 then
		arg0.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0.btnAutoStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0.inAnimatedFlag = true
	else
		arg0.inAnimatedFlag = false
		arg0.btnStart:GetComponent(typeof(Image)).raycastTarget = true
		arg0.btnAutoStart:GetComponent(typeof(Image)).raycastTarget = true
	end

	if not arg1 and arg0.autoFlag then
		arg0:start()
		setActive(arg0.btnStart, false)
		setActive(arg0.btnAutoStart, false)
	else
		setActive(arg0.btnStart, not arg1)
		setActive(arg0.btnAutoStart, not arg1)
	end

	if not arg1 and not arg0.autoFlag and arg2 then
		arg0._event:emit(Monopoly3thRePage.ON_STOP, nil, function()
			return
		end)
	end
end

function var0.checkCharActive(arg0)
	if arg0.anim then
		if arg0.effectId and arg0.effectId > 0 then
			arg0:changeAnimeState(true)
			arg0:checkEffect(function()
				arg0:changeAnimeState(false)
				arg0:checkCharActive()
			end)
		elseif arg0.step and arg0.step > 0 then
			arg0:changeAnimeState(true)
			arg0:checkStep(function()
				arg0:changeAnimeState(false)
				arg0:checkCharActive()
			end)
		else
			arg0:checkLastBonus()
		end
	end
end

function var0.firstUpdata(arg0, arg1)
	arg0:activityDataUpdata(arg1)
	arg0:updataUI()
	arg0:updataChar()
	arg0:checkCharActive()
	arg0:checkLastBonus()

	if arg0.pos and arg0.pos > 0 then
		arg0:updateMap(arg0.pos * 1100 % 2500)
	end
end

function var0.updataActivity(arg0, arg1)
	arg0:activityDataUpdata(arg1)
	arg0:updataUI()
end

function var0.checkLastBonus(arg0)
	if (not arg0.lastBonusFlag or arg0.lastBonusFlag == 0) and arg0.useCount and arg0.useCount >= arg0.lastBonusTimes then
		arg0._event:emit(Monopoly3thRePage.MONOPOLY_OP_LAST, arg0.activity.id, function(arg0)
			arg0.lastBonusFlag = 1

			setActive(findTF(arg0.labelDropShip, "get"), false)
			setActive(findTF(arg0.labelDropShip, "got"), true)
			setActive(findTF(arg0.labelDropShip, "text"), false)

			if arg0.autoFlag then
				arg0:start()
			end
		end)

		return true
	end

	if arg0.lastBonusFlag == 1 then
		setActive(findTF(arg0.labelDropShip, "get"), false)
		setActive(findTF(arg0.labelDropShip, "got"), true)
		setActive(findTF(arg0.labelDropShip, "text"), false)
	end

	return false
end

function var0.activityDataUpdata(arg0, arg1)
	arg0.activity = arg1

	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = arg0.activity.data1

	arg0.totalCnt = math.ceil((var0 - var1) / 86400) * arg0.activity:getDataConfig("daily_time") + arg0.activity.data1_list[1]
	arg0.useCount = arg0.activity.data1_list[2]
	arg0.leftCount = arg0.totalCnt - arg0.useCount
	arg0.turnCnt = arg0.activity.data1_list[3] - 1
	arg0.leftDropShipCnt = 8 - arg0.turnCnt

	local var2 = arg0.activity.data2_list[2]

	arg0.advanceTotalCnt = #arg1:getDataConfig("reward")
	arg0.isAdvanceRp = arg0.advanceTotalCnt - var2 > 0

	local var3 = arg0.activity.data2_list[1]

	arg0.leftAwardCnt = var3 - var2
	arg0.advanceRpCount = math.max(0, math.min(var3, arg0.advanceTotalCnt) - var2)
	arg0.commonRpCount = math.max(0, var3 - arg0.advanceTotalCnt) - math.max(0, var2 - arg0.advanceTotalCnt)

	local var4 = arg1:getDataConfig("reward_time")

	arg0.nextredPacketStep = var4 - arg0.useCount % var4

	if arg0.useCount >= var16 then
		arg0.nextredPacketStep = nil
	end

	arg0.pos = arg0.activity.data2
	arg0.step = arg0.activity.data3 or 0
	arg0.effectId = arg0.activity.data4 or 0
	arg0.lastBonusFlag = arg0.activity.data2_list[3]
end

function var0.checkStep(arg0, arg1)
	if arg0.step > 0 then
		arg0._event:emit(Monopoly3thRePage.ON_MOVE, arg0.activity.id, function(arg0, arg1, arg2)
			arg0.step = arg0
			arg0.pos = arg1[#arg1]
			arg0.effectId = arg2

			seriesAsync({
				function(arg0)
					local var0 = var14

					arg0:moveCharWithPaths(arg1, var0, arg0)
				end,
				function(arg0)
					arg0:checkEffect(arg0)
				end
			}, function()
				if arg1 then
					arg1()
				end
			end)
		end)
	elseif arg1 then
		arg1()
	end
end

function var0.updataUI(arg0)
	setText(arg0.labelLeftRpCount, "" .. arg0.leftAwardCnt)

	if LeanTween.isTweening(go(arg0.btnRp)) then
		LeanTween.cancel(go(arg0.btnRp))
	end

	LeanTween.delayedCall(go(arg0.btnRp), 1, System.Action(function()
		if arg0.commonAnim.isActiveAndEnabled then
			arg0.commonAnim:SetInteger("count", arg0.leftAwardCnt)
		end
	end))

	local var0 = arg0.lastBonusTimes - arg0.useCount

	if var0 > 0 then
		setText(findTF(arg0.labelDropShip, "text"), "" .. var0)
	end

	if arg0.nextredPacketStep and arg0.nextredPacketStep ~= 0 then
		setText(arg0.labelLeftCountTip, arg0.nextredPacketStep)
		setActive(arg0.labelLeftCountTip, true)
		setActive(findTF(arg0._tf, "countTip/ad"), true)
		setActive(findTF(arg0._tf, "countTip/adB"), false)
	else
		setText(arg0.labelLeftCountTip, "")
		setActive(arg0.labelLeftCountTip, false)
		setActive(findTF(arg0._tf, "countTip/ad"), false)
		setActive(findTF(arg0._tf, "countTip/adB"), true)
	end

	setText(arg0.labelLeftCount, arg0.leftCount)
end

function var0.updataChar(arg0)
	if not isActive(arg0.char) then
		SetActive(arg0.char, true)
		arg0.char:SetAsLastSibling()
	end
end

function var0.checkEffect(arg0, arg1)
	if arg0.effectId > 0 then
		local var0 = pg.activity_event_monopoly_event[arg0.effectId].story
		local var1 = arg0:getActionName(arg0.pos)

		seriesAsync({
			function(arg0)
				if var1 then
					arg0:changeCharAction(var1, 1, function()
						arg0:changeCharAction(var11, 0, nil)
						arg0()
					end)
				else
					arg0()
				end
			end,
			function(arg0)
				if var0 and tonumber(var0) ~= 0 then
					pg.NewStoryMgr.GetInstance():Play(var0, arg0, true, true)
				else
					arg0()
				end
			end,
			function(arg0)
				arg0:triggerEfect(arg0)
			end,
			function(arg0)
				arg0:checkCountStory(arg0)
			end
		}, arg1)
	elseif arg1 then
		arg1()
	end
end

function var0.triggerEfect(arg0, arg1)
	arg0._event:emit(Monopoly3thRePage.ON_TRIGGER, arg0.activity.id, function(arg0, arg1)
		if arg0 and #arg0 >= 0 then
			arg0.effectId = arg1
			arg0.pos = arg0[#arg0]

			seriesAsync({
				function(arg0)
					arg0:moveCharWithPaths(arg0, var10, arg0)
				end
			}, function()
				arg1()
			end)
		end
	end)
end

function var0.moveCharWithPaths(arg0, arg1, arg2, arg3)
	if not arg1 or #arg1 <= 0 then
		if arg3 then
			arg3()
		end

		return
	end

	local var0 = {}

	table.insert(var0, function(arg0)
		local var0 = arg2 ~= var14 and 4 or 2
		local var1 = 1100
		local var2 = 0

		arg0:createCell(var1)
		arg0:changeCharAction(arg2, 0, nil)

		local var3 = var1 / (var0 / 0.6)
		local var4 = 0

		if LeanTween.isTweening(go(arg0.cellPos)) then
			LeanTween.cancel(go(arg0.cellPos))
		end

		LeanTween.value(go(arg0.cellPos), 0, var1, var0):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0)
			arg0:updateMap(arg0 - var2)

			var2 = arg0
		end)):setOnComplete(System.Action(function()
			arg0()
		end))
	end)
	table.insert(var0, function(arg0)
		arg0:changeCharAction(var11, 0, nil)
		arg0()
	end)
	seriesAsync(var0, arg3)
end

function var0.createCell(arg0, arg1)
	local var0 = arg0.mapIds[arg0.pos]
	local var1 = pg.activity_event_monopoly_map[var0].icon
	local var2 = tf(instantiate(go(arg0.tplCell)))

	var2.localPosition = Vector3(arg1, 0, 0)

	local var3 = GetSpriteFromAtlas("ui/activityuipage/monopoly3thre_atlas", var1)

	findTF(var2, "icon"):GetComponent(typeof(Image)).sprite = var3

	findTF(var2, "icon"):GetComponent(typeof(Image)):SetNativeSize()
	setActive(var2, true)
	setParent(var2, arg0.cellPos)
	table.insert(arg0.mapCells, var2)
end

function var0.updateMap(arg0, arg1)
	for iter0 = 1, #arg0.mapCells do
		local var0 = arg0.mapCells[iter0].anchoredPosition

		var0.x = var0.x - arg1
		arg0.mapCells[iter0].anchoredPosition = var0
	end

	if #arg0.mapCells > 0 and arg0.mapCells[1].anchoredPosition.x < -1000 then
		local var1 = table.remove(arg0.mapCells, 1)

		Destroy(var1)
	end

	for iter1 = 1, #arg0.groundChildsList do
		local var2 = arg0.groundMoveRate[iter1]
		local var3 = arg0.groundChildsList[iter1]

		for iter2 = #var3, 1, -1 do
			local var4 = var3[iter2]

			var4.anchoredPosition = Vector3(var4.anchoredPosition.x - arg1 * var2, var4.anchoredPosition.y, var4.anchoredPosition.z)
		end
	end

	for iter3 = 1, #arg0.groundChildsList do
		local var5 = arg0.groundChildsList[iter3]

		for iter4 = #var5, 1, -1 do
			local var6 = var5[iter4]

			if var6.anchoredPosition.x <= -var6.sizeDelta.x and #var5 > 1 then
				local var7 = table.remove(var5, iter4)

				var7.anchoredPosition = Vector3(var5[#var5].anchoredPosition.x + var5[#var5].sizeDelta.x, var6.anchoredPosition.y, var6.anchoredPosition.z)

				table.insert(var5, var7)
			end
		end
	end
end

function var0.changeCharAction(arg0, arg1, arg2, arg3)
	if arg0.actionName == arg1 and arg0.actionName ~= var13 then
		return
	end

	arg0.actionName = arg1

	arg0.anim:SetActionCallBack(nil)
	arg0.anim:SetAction(arg1, 0)
	arg0.anim:SetActionCallBack(function(arg0)
		if arg0 == "finish" then
			if arg2 == 1 then
				arg0.anim:SetActionCallBack(nil)
				arg0.anim:SetAction(var11, 0)
			end

			if arg3 then
				arg3()
			end
		end
	end)

	if arg2 ~= 1 and arg3 then
		arg3()
	end
end

function var0.getActionName(arg0, arg1)
	local var0 = arg0.mapIds[arg1]
	local var1 = pg.activity_event_monopoly_map[var0].icon

	if var1 == "icon_1" then
		return var9
	elseif var1 == "icon_2" then
		return var7
	elseif var1 == "icon_3" then
		return nil
	elseif var1 == "icon_4" then
		return var9
	elseif var1 == "icon_5" then
		return var8
	elseif var1 == "icon_6" then
		return var9
	end

	return var9
end

function var0.onHide(arg0)
	return
end

function var0.dispose(arg0)
	if arg0.model then
		PoolMgr.GetInstance():ReturnSpineChar(var1, arg0.model)
	end

	for iter0 = #arg0.mapCells, 1, -1 do
		Destroy(arg0.mapCells[iter0])
	end

	arg0.mapCells = {}

	if arg0.randomMoveTiemr then
		if arg0.randomMoveTiemr.running then
			arg0.randomMoveTiemr:Stop()
		end

		arg0.randomMoveTiemr = nil
	end

	if LeanTween.isTweening(go(arg0.btnRp)) then
		LeanTween.cancel(go(arg0.btnRp))
	end

	if LeanTween.isTweening(go(arg0.cellPos)) then
		LeanTween.cancel(go(arg0.cellPos))
	end

	if arg0.awardsTimer then
		if arg0.awardsTimer.running then
			arg0.awardsTimer:Stop()
		end

		arg0.awardsTimer = nil
	end

	if arg0.awardTfs and #arg0.awardTfs > 0 then
		for iter1 = #arg0.awardTfs, 1, -1 do
			Destroy(table.remove(arg0.awardTfs, iter1))
		end
	end
end

return var0
