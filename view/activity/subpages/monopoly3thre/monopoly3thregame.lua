local var0_0 = class("Monopoly3thReGame")
local var1_0 = 502041
local var2_0 = 502041
local var3_0
local var4_0
local var5_0 = 0.6
local var6_0 = 100
local var7_0 = "dafuweng_gold"
local var8_0 = "dafuweng_oil"
local var9_0 = "dafuweng_event"
local var10_0 = "dafuweng_walk"
local var11_0 = "stand"
local var12_0 = "dafuweng_stand"
local var13_0 = "dafuweng_jump"
local var14_0 = "dafuweng_run"
local var15_0 = "dafuweng_touch"
local var16_0 = 35

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1._event = arg3_1
	arg0_1._configId = arg4_1

	arg0_1:initData()
	arg0_1:initUI()
	arg0_1:initEvent()
end

function var0_0.initData(arg0_2)
	arg0_2.leftCount = 0
	arg0_2.mapIds = pg.activity_event_monopoly[arg0_2._configId].map
	arg0_2.inAnimatedFlag = false
	arg0_2.lastBonusTimes = pg.activity_event_monopoly[arg0_2._configId].drop_times[1]
	arg0_2.randomMoveTiemr = Timer.New(function()
		arg0_2:checkPlayerRandomMove()
	end, 15, -1)
	arg0_2.awardsTimer = Timer.New(function()
		if arg0_2.awardTfs and #arg0_2.awardTfs > 0 then
			for iter0_4 = #arg0_2.awardTfs, 1, -1 do
				local var0_4 = arg0_2.awardTfs[iter0_4]
				local var1_4 = var0_4.anchoredPosition

				var1_4.y = var1_4.y + 3

				if var1_4.y >= 150 then
					Destroy(table.remove(arg0_2.awardTfs, iter0_4))
				else
					var0_4.anchoredPosition = var1_4
				end
			end
		end
	end, 0.0333333333333333, -1)

	arg0_2.awardsTimer:Start()
end

function var0_0.initUI(arg0_5)
	arg0_5.char = findTF(arg0_5._tf, "map/char")

	setActive(arg0_5.char, false)
	setText(findTF(arg0_5._tf, "desc"), i18n("monopoly3thre_tip"))

	arg0_5.btnStart = findTF(arg0_5._tf, "btnStart")
	arg0_5.btnAutoStart = findTF(arg0_5._tf, "btnAutoStart")

	setActive(arg0_5.btnStart, true)
	setActive(arg0_5.btnAutoStart, true)

	arg0_5.btnCancelAuto = findTF(arg0_5._tf, "btnCancelAuto")

	setActive(arg0_5.btnCancelAuto, false)

	arg0_5.btnHelp = findTF(arg0_5._tf, "btnHelp")
	arg0_5.btnRp = findTF(arg0_5._tf, "btnRp")
	arg0_5.commonAnim = findTF(arg0_5.btnRp, "rpAni"):GetComponent(typeof(Animator))
	arg0_5.labelLeftCountTip = findTF(arg0_5._tf, "countTip/labelLeftCountTip")
	arg0_5.labelLeftCount = findTF(arg0_5._tf, "countTip/labelLeftCount")
	arg0_5.labelDropShip = findTF(arg0_5._tf, "labelDropShip")
	arg0_5.labelLeftRpCount = findTF(arg0_5._tf, "labelLeftRpCount")
	arg0_5.cellPos = findTF(arg0_5._tf, "map/mask/posCell")
	arg0_5.tplCell = findTF(arg0_5._tf, "map/mask/posCell/tplCell")
	arg0_5.mapCells = {}
	arg0_5.curCellIndex = nil
	arg0_5.groundChildsList = {}
	arg0_5.groundMoveRate = {
		0.1,
		0.3,
		1
	}
	arg0_5.awardTf = findTF(arg0_5._tf, "awardTpl")
	arg0_5.awardParent = findTF(arg0_5.char, "award")

	for iter0_5 = 1, 3 do
		local var0_5 = findTF(arg0_5._tf, "map/mask/ground" .. iter0_5)
		local var1_5 = {}

		for iter1_5 = 1, var0_5.childCount do
			table.insert(var1_5, var0_5:GetChild(iter1_5 - 1))
		end

		table.insert(arg0_5.groundChildsList, var1_5)
	end

	local var2_5 = Ship.New({
		configId = var1_0,
		skin_id = var2_0
	}):getPrefab()

	PoolMgr.GetInstance():GetSpineChar(var2_5, true, function(arg0_6)
		arg0_5.model = arg0_6
		arg0_5.model.transform.localScale = Vector3.one
		arg0_5.model.transform.localPosition = Vector3.zero

		arg0_5.model.transform:SetParent(arg0_5.char, false)

		arg0_5.anim = arg0_5.model:GetComponent(typeof(SpineAnimUI))

		arg0_5:changeCharAction(var11_0, 0, nil)
		arg0_5:checkCharActive()
	end)
	arg0_5.randomMoveTiemr:Start()
end

function var0_0.initEvent(arg0_7)
	onButton(arg0_7._binder, arg0_7.btnAutoStart, function()
		setActive(arg0_7.btnCancelAuto, true)

		arg0_7.autoFlag = true

		arg0_7:start()
	end, SFX_PANEL)
	onButton(arg0_7._binder, arg0_7.btnCancelAuto, function()
		setActive(arg0_7.btnCancelAuto, false)

		arg0_7.autoFlag = false
	end, SFX_PANEL)
	onButton(arg0_7._binder, arg0_7.btnStart, function()
		arg0_7:start()
	end, SFX_PANEL)
	onButton(arg0_7._binder, arg0_7.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_3th.tip
		})
	end, SFX_PANEL)
	onButton(arg0_7._binder, arg0_7.char, function()
		if not arg0_7.model or arg0_7.inAnimatedFlag then
			return
		end

		if LeanTween.isTweening(go(arg0_7.cellPos)) then
			LeanTween.cancel(go(arg0_7.cellPos))
		end

		arg0_7:changeCharAction(var15_0, 1, function()
			arg0_7:changeCharAction(var11_0)
		end)
	end, SFX_PANEL)
	onButton(arg0_7._binder, arg0_7.btnRp, function()
		if arg0_7.leftAwardCnt > 0 then
			arg0_7._event:emit(Monopoly3thRePage.ON_AWARD)
		end
	end, SFX_PANEL)
end

function var0_0.addAwards(arg0_15, arg1_15)
	if not arg0_15.awardTfs then
		arg0_15.awardTfs = {}
	end

	for iter0_15 = 1, #arg1_15 do
		local var0_15 = arg1_15[iter0_15]
		local var1_15 = tf(instantiate(go(arg0_15.awardTf)))

		setParent(var1_15, arg0_15.awardParent)
		updateDrop(var1_15, var0_15)

		var1_15.anchoredPosition = Vector2(0, 0)

		setActive(var1_15, true)
		table.insert(arg0_15.awardTfs, var1_15)
	end
end

function var0_0.start(arg0_16)
	if arg0_16.inAnimatedFlag then
		return
	end

	if arg0_16.leftCount and arg0_16.leftCount <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

		if arg0_16.autoFlag and not arg0_16:checkLastBonus() then
			arg0_16.autoFlag = false

			setActive(arg0_16.btnCancelAuto, false)
			arg0_16:changeAnimeState(false, true)
		end

		return
	end

	arg0_16:changeAnimeState(true)
	arg0_16._event:emit(Monopoly3thRePage.ON_START, arg0_16.activity.id, function(arg0_17)
		if arg0_17 and arg0_17 > 0 then
			arg0_16.step = arg0_17

			arg0_16:updataUI()
			arg0_16:checkCharActive()
		end
	end)
end

function var0_0.checkPlayerRandomMove(arg0_18)
	if not arg0_18.model or arg0_18.inAnimatedFlag then
		return
	end

	if math.random() > 0.5 then
		local var0_18 = math.random(2, 4)
		local var1_18 = 300 * var0_18
		local var2_18 = var0_18 * 2
		local var3_18 = 0

		arg0_18:changeCharAction(var10_0, 0, nil)
		LeanTween.value(go(arg0_18.cellPos), 0, var1_18, var2_18):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0_19)
			arg0_18:updateMap(arg0_19 - var3_18)

			var3_18 = arg0_19
		end)):setOnComplete(System.Action(function()
			arg0_18:changeCharAction(var11_0, 0, nil)
		end))
	else
		arg0_18:changeCharAction(var12_0, 1, function()
			arg0_18:changeCharAction(var11_0)
		end)
	end
end

function var0_0.checkCountStory(arg0_22, arg1_22)
	local var0_22 = arg0_22.useCount
	local var1_22 = arg0_22.activity:getDataConfig("story") or {}
	local var2_22 = _.detect(var1_22, function(arg0_23)
		return arg0_23[1] == var0_22
	end)

	if var2_22 then
		pg.NewStoryMgr.GetInstance():Play(var2_22[2], arg1_22)
	else
		arg1_22()
	end
end

function var0_0.changeAnimeState(arg0_24, arg1_24, arg2_24)
	if arg1_24 then
		arg0_24.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0_24.btnAutoStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0_24.inAnimatedFlag = true
	else
		arg0_24.inAnimatedFlag = false
		arg0_24.btnStart:GetComponent(typeof(Image)).raycastTarget = true
		arg0_24.btnAutoStart:GetComponent(typeof(Image)).raycastTarget = true
	end

	if not arg1_24 and arg0_24.autoFlag then
		arg0_24:start()
		setActive(arg0_24.btnStart, false)
		setActive(arg0_24.btnAutoStart, false)
	else
		setActive(arg0_24.btnStart, not arg1_24)
		setActive(arg0_24.btnAutoStart, not arg1_24)
	end

	if not arg1_24 and not arg0_24.autoFlag and arg2_24 then
		arg0_24._event:emit(Monopoly3thRePage.ON_STOP, nil, function()
			return
		end)
	end
end

function var0_0.checkCharActive(arg0_26)
	if arg0_26.anim then
		if arg0_26.effectId and arg0_26.effectId > 0 then
			arg0_26:changeAnimeState(true)
			arg0_26:checkEffect(function()
				arg0_26:changeAnimeState(false)
				arg0_26:checkCharActive()
			end)
		elseif arg0_26.step and arg0_26.step > 0 then
			arg0_26:changeAnimeState(true)
			arg0_26:checkStep(function()
				arg0_26:changeAnimeState(false)
				arg0_26:checkCharActive()
			end)
		else
			arg0_26:checkLastBonus()
		end
	end
end

function var0_0.firstUpdata(arg0_29, arg1_29)
	arg0_29:activityDataUpdata(arg1_29)
	arg0_29:updataUI()
	arg0_29:updataChar()
	arg0_29:checkCharActive()
	arg0_29:checkLastBonus()

	if arg0_29.pos and arg0_29.pos > 0 then
		arg0_29:updateMap(arg0_29.pos * 1100 % 2500)
	end
end

function var0_0.updataActivity(arg0_30, arg1_30)
	arg0_30:activityDataUpdata(arg1_30)
	arg0_30:updataUI()
end

function var0_0.checkLastBonus(arg0_31)
	if (not arg0_31.lastBonusFlag or arg0_31.lastBonusFlag == 0) and arg0_31.useCount and arg0_31.useCount >= arg0_31.lastBonusTimes then
		arg0_31._event:emit(Monopoly3thRePage.MONOPOLY_OP_LAST, arg0_31.activity.id, function(arg0_32)
			arg0_31.lastBonusFlag = 1

			setActive(findTF(arg0_31.labelDropShip, "get"), false)
			setActive(findTF(arg0_31.labelDropShip, "got"), true)
			setActive(findTF(arg0_31.labelDropShip, "text"), false)

			if arg0_31.autoFlag then
				arg0_31:start()
			end
		end)

		return true
	end

	if arg0_31.lastBonusFlag == 1 then
		setActive(findTF(arg0_31.labelDropShip, "get"), false)
		setActive(findTF(arg0_31.labelDropShip, "got"), true)
		setActive(findTF(arg0_31.labelDropShip, "text"), false)
	end

	return false
end

function var0_0.activityDataUpdata(arg0_33, arg1_33)
	arg0_33.activity = arg1_33

	local var0_33 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_33 = arg0_33.activity.data1

	arg0_33.totalCnt = math.ceil((var0_33 - var1_33) / 86400) * arg0_33.activity:getDataConfig("daily_time") + arg0_33.activity.data1_list[1]
	arg0_33.useCount = arg0_33.activity.data1_list[2]
	arg0_33.leftCount = arg0_33.totalCnt - arg0_33.useCount
	arg0_33.turnCnt = arg0_33.activity.data1_list[3] - 1
	arg0_33.leftDropShipCnt = 8 - arg0_33.turnCnt

	local var2_33 = arg0_33.activity.data2_list[2]

	arg0_33.advanceTotalCnt = #arg1_33:getDataConfig("reward")
	arg0_33.isAdvanceRp = arg0_33.advanceTotalCnt - var2_33 > 0

	local var3_33 = arg0_33.activity.data2_list[1]

	arg0_33.leftAwardCnt = var3_33 - var2_33
	arg0_33.advanceRpCount = math.max(0, math.min(var3_33, arg0_33.advanceTotalCnt) - var2_33)
	arg0_33.commonRpCount = math.max(0, var3_33 - arg0_33.advanceTotalCnt) - math.max(0, var2_33 - arg0_33.advanceTotalCnt)

	local var4_33 = arg1_33:getDataConfig("reward_time")

	arg0_33.nextredPacketStep = var4_33 - arg0_33.useCount % var4_33

	if arg0_33.useCount >= var16_0 then
		arg0_33.nextredPacketStep = nil
	end

	arg0_33.pos = arg0_33.activity.data2
	arg0_33.step = arg0_33.activity.data3 or 0
	arg0_33.effectId = arg0_33.activity.data4 or 0
	arg0_33.lastBonusFlag = arg0_33.activity.data2_list[3]
end

function var0_0.checkStep(arg0_34, arg1_34)
	if arg0_34.step > 0 then
		arg0_34._event:emit(Monopoly3thRePage.ON_MOVE, arg0_34.activity.id, function(arg0_35, arg1_35, arg2_35)
			arg0_34.step = arg0_35
			arg0_34.pos = arg1_35[#arg1_35]
			arg0_34.effectId = arg2_35

			seriesAsync({
				function(arg0_36)
					local var0_36 = var14_0

					arg0_34:moveCharWithPaths(arg1_35, var0_36, arg0_36)
				end,
				function(arg0_37)
					arg0_34:checkEffect(arg0_37)
				end
			}, function()
				if arg1_34 then
					arg1_34()
				end
			end)
		end)
	elseif arg1_34 then
		arg1_34()
	end
end

function var0_0.updataUI(arg0_39)
	setText(arg0_39.labelLeftRpCount, "" .. arg0_39.leftAwardCnt)

	if LeanTween.isTweening(go(arg0_39.btnRp)) then
		LeanTween.cancel(go(arg0_39.btnRp))
	end

	LeanTween.delayedCall(go(arg0_39.btnRp), 1, System.Action(function()
		if arg0_39.commonAnim.isActiveAndEnabled then
			arg0_39.commonAnim:SetInteger("count", arg0_39.leftAwardCnt)
		end
	end))

	local var0_39 = arg0_39.lastBonusTimes - arg0_39.useCount

	if var0_39 > 0 then
		setText(findTF(arg0_39.labelDropShip, "text"), "" .. var0_39)
	end

	if arg0_39.nextredPacketStep and arg0_39.nextredPacketStep ~= 0 then
		setText(arg0_39.labelLeftCountTip, arg0_39.nextredPacketStep)
		setActive(arg0_39.labelLeftCountTip, true)
		setActive(findTF(arg0_39._tf, "countTip/ad"), true)
		setActive(findTF(arg0_39._tf, "countTip/adB"), false)
	else
		setText(arg0_39.labelLeftCountTip, "")
		setActive(arg0_39.labelLeftCountTip, false)
		setActive(findTF(arg0_39._tf, "countTip/ad"), false)
		setActive(findTF(arg0_39._tf, "countTip/adB"), true)
	end

	setText(arg0_39.labelLeftCount, arg0_39.leftCount)
end

function var0_0.updataChar(arg0_41)
	if not isActive(arg0_41.char) then
		SetActive(arg0_41.char, true)
		arg0_41.char:SetAsLastSibling()
	end
end

function var0_0.checkEffect(arg0_42, arg1_42)
	if arg0_42.effectId > 0 then
		local var0_42 = pg.activity_event_monopoly_event[arg0_42.effectId].story
		local var1_42 = arg0_42:getActionName(arg0_42.pos)

		seriesAsync({
			function(arg0_43)
				if var1_42 then
					arg0_42:changeCharAction(var1_42, 1, function()
						arg0_42:changeCharAction(var11_0, 0, nil)
						arg0_43()
					end)
				else
					arg0_43()
				end
			end,
			function(arg0_45)
				if var0_42 and tonumber(var0_42) ~= 0 then
					pg.NewStoryMgr.GetInstance():Play(var0_42, arg0_45, true, true)
				else
					arg0_45()
				end
			end,
			function(arg0_46)
				arg0_42:triggerEfect(arg0_46)
			end,
			function(arg0_47)
				arg0_42:checkCountStory(arg0_47)
			end
		}, arg1_42)
	elseif arg1_42 then
		arg1_42()
	end
end

function var0_0.triggerEfect(arg0_48, arg1_48)
	arg0_48._event:emit(Monopoly3thRePage.ON_TRIGGER, arg0_48.activity.id, function(arg0_49, arg1_49)
		if arg0_49 and #arg0_49 >= 0 then
			arg0_48.effectId = arg1_49
			arg0_48.pos = arg0_49[#arg0_49]

			seriesAsync({
				function(arg0_50)
					arg0_48:moveCharWithPaths(arg0_49, var10_0, arg0_50)
				end
			}, function()
				arg1_48()
			end)
		end
	end)
end

function var0_0.moveCharWithPaths(arg0_52, arg1_52, arg2_52, arg3_52)
	if not arg1_52 or #arg1_52 <= 0 then
		if arg3_52 then
			arg3_52()
		end

		return
	end

	local var0_52 = {}

	table.insert(var0_52, function(arg0_53)
		local var0_53 = arg2_52 ~= var14_0 and 4 or 2
		local var1_53 = 1100
		local var2_53 = 0

		arg0_52:createCell(var1_53)
		arg0_52:changeCharAction(arg2_52, 0, nil)

		local var3_53 = var1_53 / (var0_53 / 0.6)
		local var4_53 = 0

		if LeanTween.isTweening(go(arg0_52.cellPos)) then
			LeanTween.cancel(go(arg0_52.cellPos))
		end

		LeanTween.value(go(arg0_52.cellPos), 0, var1_53, var0_53):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0_54)
			arg0_52:updateMap(arg0_54 - var2_53)

			var2_53 = arg0_54
		end)):setOnComplete(System.Action(function()
			arg0_53()
		end))
	end)
	table.insert(var0_52, function(arg0_56)
		arg0_52:changeCharAction(var11_0, 0, nil)
		arg0_56()
	end)
	seriesAsync(var0_52, arg3_52)
end

function var0_0.createCell(arg0_57, arg1_57)
	local var0_57 = arg0_57.mapIds[arg0_57.pos]
	local var1_57 = pg.activity_event_monopoly_map[var0_57].icon
	local var2_57 = tf(instantiate(go(arg0_57.tplCell)))

	var2_57.localPosition = Vector3(arg1_57, 0, 0)

	local var3_57 = GetSpriteFromAtlas("ui/activityuipage/monopoly3thre_atlas", var1_57)

	findTF(var2_57, "icon"):GetComponent(typeof(Image)).sprite = var3_57

	findTF(var2_57, "icon"):GetComponent(typeof(Image)):SetNativeSize()
	setActive(var2_57, true)
	setParent(var2_57, arg0_57.cellPos)
	table.insert(arg0_57.mapCells, var2_57)
end

function var0_0.updateMap(arg0_58, arg1_58)
	for iter0_58 = 1, #arg0_58.mapCells do
		local var0_58 = arg0_58.mapCells[iter0_58].anchoredPosition

		var0_58.x = var0_58.x - arg1_58
		arg0_58.mapCells[iter0_58].anchoredPosition = var0_58
	end

	if #arg0_58.mapCells > 0 and arg0_58.mapCells[1].anchoredPosition.x < -1000 then
		local var1_58 = table.remove(arg0_58.mapCells, 1)

		Destroy(var1_58)
	end

	for iter1_58 = 1, #arg0_58.groundChildsList do
		local var2_58 = arg0_58.groundMoveRate[iter1_58]
		local var3_58 = arg0_58.groundChildsList[iter1_58]

		for iter2_58 = #var3_58, 1, -1 do
			local var4_58 = var3_58[iter2_58]

			var4_58.anchoredPosition = Vector3(var4_58.anchoredPosition.x - arg1_58 * var2_58, var4_58.anchoredPosition.y, var4_58.anchoredPosition.z)
		end
	end

	for iter3_58 = 1, #arg0_58.groundChildsList do
		local var5_58 = arg0_58.groundChildsList[iter3_58]

		for iter4_58 = #var5_58, 1, -1 do
			local var6_58 = var5_58[iter4_58]

			if var6_58.anchoredPosition.x <= -var6_58.sizeDelta.x and #var5_58 > 1 then
				local var7_58 = table.remove(var5_58, iter4_58)

				var7_58.anchoredPosition = Vector3(var5_58[#var5_58].anchoredPosition.x + var5_58[#var5_58].sizeDelta.x, var6_58.anchoredPosition.y, var6_58.anchoredPosition.z)

				table.insert(var5_58, var7_58)
			end
		end
	end
end

function var0_0.changeCharAction(arg0_59, arg1_59, arg2_59, arg3_59)
	if arg0_59.actionName == arg1_59 and arg0_59.actionName ~= var13_0 then
		return
	end

	arg0_59.actionName = arg1_59

	arg0_59.anim:SetActionCallBack(nil)
	arg0_59.anim:SetAction(arg1_59, 0)
	arg0_59.anim:SetActionCallBack(function(arg0_60)
		if arg0_60 == "finish" then
			if arg2_59 == 1 then
				arg0_59.anim:SetActionCallBack(nil)
				arg0_59.anim:SetAction(var11_0, 0)
			end

			if arg3_59 then
				arg3_59()
			end
		end
	end)

	if arg2_59 ~= 1 and arg3_59 then
		arg3_59()
	end
end

function var0_0.getActionName(arg0_61, arg1_61)
	local var0_61 = arg0_61.mapIds[arg1_61]
	local var1_61 = pg.activity_event_monopoly_map[var0_61].icon

	if var1_61 == "icon_1" then
		return var9_0
	elseif var1_61 == "icon_2" then
		return var7_0
	elseif var1_61 == "icon_3" then
		return nil
	elseif var1_61 == "icon_4" then
		return var9_0
	elseif var1_61 == "icon_5" then
		return var8_0
	elseif var1_61 == "icon_6" then
		return var9_0
	end

	return var9_0
end

function var0_0.onHide(arg0_62)
	return
end

function var0_0.dispose(arg0_63)
	if arg0_63.model then
		PoolMgr.GetInstance():ReturnSpineChar(var1_0, arg0_63.model)
	end

	for iter0_63 = #arg0_63.mapCells, 1, -1 do
		Destroy(arg0_63.mapCells[iter0_63])
	end

	arg0_63.mapCells = {}

	if arg0_63.randomMoveTiemr then
		if arg0_63.randomMoveTiemr.running then
			arg0_63.randomMoveTiemr:Stop()
		end

		arg0_63.randomMoveTiemr = nil
	end

	if LeanTween.isTweening(go(arg0_63.btnRp)) then
		LeanTween.cancel(go(arg0_63.btnRp))
	end

	if LeanTween.isTweening(go(arg0_63.cellPos)) then
		LeanTween.cancel(go(arg0_63.cellPos))
	end

	if arg0_63.awardsTimer then
		if arg0_63.awardsTimer.running then
			arg0_63.awardsTimer:Stop()
		end

		arg0_63.awardsTimer = nil
	end

	if arg0_63.awardTfs and #arg0_63.awardTfs > 0 then
		for iter1_63 = #arg0_63.awardTfs, 1, -1 do
			Destroy(table.remove(arg0_63.awardTfs, iter1_63))
		end
	end
end

return var0_0
