local var0_0 = class("Monopoly3thGame")
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
	arg0_2.inAnimatedFlag = false
	arg0_2.mapIds = pg.activity_event_monopoly[arg0_2._configId].map
	arg0_2.lastBonusTimes = pg.activity_event_monopoly[arg0_2._configId].drop_times[1]
	arg0_2.randomMoveTiemr = Timer.New(function()
		arg0_2:checkPlayerRandomMove()
	end, 15, -1)
end

function var0_0.initUI(arg0_4)
	arg0_4.char = findTF(arg0_4._tf, "map/char")

	setActive(arg0_4.char, false)

	arg0_4.btnStart = findTF(arg0_4._tf, "btnStart")
	arg0_4.btnHelp = findTF(arg0_4._tf, "btnHelp")
	arg0_4.btnRp = findTF(arg0_4._tf, "btnRp")
	arg0_4.commonAnim = findTF(arg0_4.btnRp, "rpAni"):GetComponent(typeof(Animator))
	arg0_4.labelLeftCountTip = findTF(arg0_4._tf, "countTip/labelLeftCountTip")
	arg0_4.labelLeftCount = findTF(arg0_4._tf, "countTip/labelLeftCount")
	arg0_4.labelDropShip = findTF(arg0_4._tf, "labelDropShip")
	arg0_4.labelLeftRpCount = findTF(arg0_4._tf, "labelLeftRpCount")
	arg0_4.cellPos = findTF(arg0_4._tf, "map/mask/posCell")
	arg0_4.tplCell = findTF(arg0_4._tf, "map/mask/posCell/tplCell")
	arg0_4.mapCells = {}
	arg0_4.curCellIndex = nil
	arg0_4.groundChildsList = {}
	arg0_4.groundMoveRate = {
		0.1,
		0.3,
		1
	}

	for iter0_4 = 1, 3 do
		local var0_4 = findTF(arg0_4._tf, "map/mask/ground" .. iter0_4)
		local var1_4 = {}

		for iter1_4 = 1, var0_4.childCount do
			table.insert(var1_4, var0_4:GetChild(iter1_4 - 1))
		end

		table.insert(arg0_4.groundChildsList, var1_4)
	end

	local var2_4 = Ship.New({
		configId = var1_0,
		skin_id = var2_0
	}):getPrefab()

	PoolMgr.GetInstance():GetSpineChar(var2_4, true, function(arg0_5)
		arg0_4.model = arg0_5
		arg0_4.model.transform.localScale = Vector3.one
		arg0_4.model.transform.localPosition = Vector3.zero

		arg0_4.model.transform:SetParent(arg0_4.char, false)

		arg0_4.anim = arg0_4.model:GetComponent(typeof(SpineAnimUI))

		arg0_4:changeCharAction(var11_0, 0, nil)
		arg0_4:checkCharActive()
	end)
	arg0_4.randomMoveTiemr:Start()
end

function var0_0.initEvent(arg0_6)
	onButton(arg0_6._binder, arg0_6.btnStart, function()
		if arg0_6.inAnimatedFlag then
			return
		end

		if arg0_6.leftCount and arg0_6.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		arg0_6:changeAnimeState(true)
		arg0_6._event:emit(Monopoly3thPage.ON_START, arg0_6.activity.id, function(arg0_8)
			if arg0_8 and arg0_8 > 0 then
				arg0_6.step = arg0_8

				arg0_6:updataUI()
				arg0_6:checkCharActive()
			end
		end)
	end, SFX_PANEL)
	onButton(arg0_6._binder, arg0_6.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_3th.tip
		})
	end, SFX_PANEL)
	onButton(arg0_6._binder, arg0_6.char, function()
		if not arg0_6.model or arg0_6.inAnimatedFlag then
			return
		end

		if LeanTween.isTweening(go(arg0_6.cellPos)) then
			LeanTween.cancel(go(arg0_6.cellPos))
		end

		arg0_6:changeCharAction(var15_0, 1, function()
			arg0_6:changeCharAction(var11_0)
		end)
	end, SFX_PANEL)
	onButton(arg0_6._binder, arg0_6.btnRp, function()
		if arg0_6.leftAwardCnt > 0 then
			arg0_6._event:emit(Monopoly3thPage.ON_AWARD)
		end
	end, SFX_PANEL)
end

function var0_0.checkPlayerRandomMove(arg0_13)
	if not arg0_13.model or arg0_13.inAnimatedFlag then
		return
	end

	if math.random() > 0.5 then
		local var0_13 = math.random(2, 4)
		local var1_13 = 300 * var0_13
		local var2_13 = var0_13 * 2
		local var3_13 = 0

		arg0_13:changeCharAction(var10_0, 0, nil)
		LeanTween.value(go(arg0_13.cellPos), 0, var1_13, var2_13):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0_14)
			arg0_13:updateMap(arg0_14 - var3_13)

			var3_13 = arg0_14
		end)):setOnComplete(System.Action(function()
			arg0_13:changeCharAction(var11_0, 0, nil)
		end))
	else
		arg0_13:changeCharAction(var12_0, 1, function()
			arg0_13:changeCharAction(var11_0)
		end)
	end
end

function var0_0.checkCountStory(arg0_17, arg1_17)
	local var0_17 = arg0_17.useCount
	local var1_17 = arg0_17.activity:getDataConfig("story") or {}
	local var2_17 = _.detect(var1_17, function(arg0_18)
		return arg0_18[1] == var0_17
	end)

	if var2_17 then
		pg.NewStoryMgr.GetInstance():Play(var2_17[2], arg1_17)
	else
		arg1_17()
	end
end

function var0_0.changeAnimeState(arg0_19, arg1_19)
	if arg1_19 then
		arg0_19.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0_19.inAnimatedFlag = true

		arg0_19._event:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
	else
		arg0_19.inAnimatedFlag = false
		arg0_19.btnStart:GetComponent(typeof(Image)).raycastTarget = true

		arg0_19._event:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
	end

	setActive(arg0_19.btnStart, not arg1_19)
end

function var0_0.checkCharActive(arg0_20)
	if arg0_20.anim then
		if arg0_20.effectId and arg0_20.effectId > 0 then
			arg0_20:changeAnimeState(true)
			arg0_20:checkEffect(function()
				arg0_20:changeAnimeState(false)
				arg0_20:checkCharActive()
			end)
		elseif arg0_20.step and arg0_20.step > 0 then
			arg0_20:changeAnimeState(true)
			arg0_20:checkStep(function()
				arg0_20:changeAnimeState(false)
				arg0_20:checkCharActive()
			end)
		else
			arg0_20:checkLastBonus()
		end
	end
end

function var0_0.firstUpdata(arg0_23, arg1_23)
	arg0_23:activityDataUpdata(arg1_23)
	arg0_23:updataUI()
	arg0_23:updataChar()
	arg0_23:checkCharActive()
	arg0_23:checkLastBonus()

	if arg0_23.pos and arg0_23.pos > 0 then
		arg0_23:updateMap(arg0_23.pos * 1100 % 2500)
	end
end

function var0_0.updataActivity(arg0_24, arg1_24)
	arg0_24:activityDataUpdata(arg1_24)
	arg0_24:updataUI()
end

function var0_0.checkLastBonus(arg0_25)
	if (not arg0_25.lastBonusFlag or arg0_25.lastBonusFlag == 0) and arg0_25.useCount and arg0_25.useCount >= arg0_25.lastBonusTimes then
		arg0_25._event:emit(Monopoly3thPage.MONOPOLY_OP_LAST, arg0_25.activity.id, function(arg0_26)
			arg0_25.lastBonusFlag = 1

			setActive(findTF(arg0_25.labelDropShip, "get"), false)
			setActive(findTF(arg0_25.labelDropShip, "got"), true)
			setActive(findTF(arg0_25.labelDropShip, "text"), false)
		end)
	end

	if arg0_25.lastBonusFlag == 1 then
		setActive(findTF(arg0_25.labelDropShip, "get"), false)
		setActive(findTF(arg0_25.labelDropShip, "got"), true)
		setActive(findTF(arg0_25.labelDropShip, "text"), false)
	end
end

function var0_0.activityDataUpdata(arg0_27, arg1_27)
	arg0_27.activity = arg1_27

	local var0_27 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_27 = arg0_27.activity.data1

	arg0_27.totalCnt = math.ceil((var0_27 - var1_27) / 86400) * arg0_27.activity:getDataConfig("daily_time") + arg0_27.activity.data1_list[1]
	arg0_27.useCount = arg0_27.activity.data1_list[2]
	arg0_27.leftCount = arg0_27.totalCnt - arg0_27.useCount
	arg0_27.turnCnt = arg0_27.activity.data1_list[3] - 1
	arg0_27.leftDropShipCnt = 8 - arg0_27.turnCnt

	local var2_27 = arg0_27.activity.data2_list[2]

	arg0_27.advanceTotalCnt = #arg1_27:getDataConfig("reward")
	arg0_27.isAdvanceRp = arg0_27.advanceTotalCnt - var2_27 > 0

	local var3_27 = arg0_27.activity.data2_list[1]

	arg0_27.leftAwardCnt = var3_27 - var2_27
	arg0_27.advanceRpCount = math.max(0, math.min(var3_27, arg0_27.advanceTotalCnt) - var2_27)
	arg0_27.commonRpCount = math.max(0, var3_27 - arg0_27.advanceTotalCnt) - math.max(0, var2_27 - arg0_27.advanceTotalCnt)

	local var4_27 = arg1_27:getDataConfig("reward_time")

	arg0_27.nextredPacketStep = var4_27 - arg0_27.useCount % var4_27
	arg0_27.pos = arg0_27.activity.data2
	arg0_27.step = arg0_27.activity.data3 or 0
	arg0_27.effectId = arg0_27.activity.data4 or 0
	arg0_27.lastBonusFlag = arg0_27.activity.data2_list[3]
end

function var0_0.checkStep(arg0_28, arg1_28)
	if arg0_28.step > 0 then
		arg0_28._event:emit(Monopoly3thPage.ON_MOVE, arg0_28.activity.id, function(arg0_29, arg1_29, arg2_29)
			arg0_28.step = arg0_29
			arg0_28.pos = arg1_29[#arg1_29]
			arg0_28.effectId = arg2_29

			seriesAsync({
				function(arg0_30)
					local var0_30 = var14_0

					arg0_28:moveCharWithPaths(arg1_29, var0_30, arg0_30)
				end,
				function(arg0_31)
					arg0_28:checkEffect(arg0_31)
				end
			}, function()
				if arg1_28 then
					arg1_28()
				end
			end)
		end)
	elseif arg1_28 then
		arg1_28()
	end
end

function var0_0.updataUI(arg0_33)
	setText(arg0_33.labelLeftRpCount, "" .. arg0_33.leftAwardCnt)
	LeanTween.delayedCall(go(arg0_33.btnRp), 1, System.Action(function()
		if arg0_33.commonAnim.isActiveAndEnabled then
			arg0_33.commonAnim:SetInteger("count", arg0_33.leftAwardCnt)
		end
	end))

	local var0_33 = arg0_33.lastBonusTimes - arg0_33.useCount

	if var0_33 > 0 then
		setText(findTF(arg0_33.labelDropShip, "text"), "" .. var0_33)
	end

	setText(arg0_33.labelLeftCountTip, arg0_33.nextredPacketStep)
	setText(arg0_33.labelLeftCount, arg0_33.leftCount)
end

function var0_0.updataChar(arg0_35)
	if not isActive(arg0_35.char) then
		SetActive(arg0_35.char, true)
		arg0_35.char:SetAsLastSibling()
	end
end

function var0_0.checkEffect(arg0_36, arg1_36)
	if arg0_36.effectId > 0 then
		local var0_36 = pg.activity_event_monopoly_event[arg0_36.effectId].story
		local var1_36 = arg0_36:getActionName(arg0_36.pos)

		seriesAsync({
			function(arg0_37)
				if var1_36 then
					arg0_36:changeCharAction(var1_36, 1, function()
						arg0_36:changeCharAction(var11_0, 0, nil)
						arg0_37()
					end)
				else
					arg0_37()
				end
			end,
			function(arg0_39)
				if var0_36 and tonumber(var0_36) ~= 0 then
					pg.NewStoryMgr.GetInstance():Play(var0_36, arg0_39, true, true)
				else
					arg0_39()
				end
			end,
			function(arg0_40)
				arg0_36:triggerEfect(arg0_40)
			end,
			function(arg0_41)
				arg0_36:checkCountStory(arg0_41)
			end
		}, arg1_36)
	elseif arg1_36 then
		arg1_36()
	end
end

function var0_0.triggerEfect(arg0_42, arg1_42)
	arg0_42._event:emit(Monopoly3thPage.ON_TRIGGER, arg0_42.activity.id, function(arg0_43, arg1_43)
		if arg0_43 and #arg0_43 >= 0 then
			arg0_42.effectId = arg1_43
			arg0_42.pos = arg0_43[#arg0_43]

			seriesAsync({
				function(arg0_44)
					arg0_42:moveCharWithPaths(arg0_43, var10_0, arg0_44)
				end
			}, function()
				arg1_42()
			end)
		end
	end)
end

function var0_0.moveCharWithPaths(arg0_46, arg1_46, arg2_46, arg3_46)
	if not arg1_46 or #arg1_46 <= 0 then
		if arg3_46 then
			arg3_46()
		end

		return
	end

	local var0_46 = {}

	table.insert(var0_46, function(arg0_47)
		local var0_47 = arg2_46 ~= var14_0 and 4 or 2
		local var1_47 = 1100
		local var2_47 = 0

		arg0_46:createCell(var1_47)
		arg0_46:changeCharAction(arg2_46, 0, nil)

		local var3_47 = var1_47 / (var0_47 / 0.6)
		local var4_47 = 0

		if LeanTween.isTweening(go(arg0_46.cellPos)) then
			LeanTween.cancel(go(arg0_46.cellPos))
		end

		LeanTween.value(go(arg0_46.cellPos), 0, var1_47, var0_47):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function(arg0_48)
			arg0_46:updateMap(arg0_48 - var2_47)

			var2_47 = arg0_48
		end)):setOnComplete(System.Action(function()
			arg0_47()
		end))
	end)
	table.insert(var0_46, function(arg0_50)
		arg0_46:changeCharAction(var11_0, 0, nil)
		arg0_50()
	end)
	seriesAsync(var0_46, arg3_46)
end

function var0_0.createCell(arg0_51, arg1_51)
	local var0_51 = arg0_51.mapIds[arg0_51.pos]
	local var1_51 = pg.activity_event_monopoly_map[var0_51].icon
	local var2_51 = tf(instantiate(go(arg0_51.tplCell)))

	var2_51.localPosition = Vector3(arg1_51, 0, 0)

	local var3_51 = GetSpriteFromAtlas("ui/activityuipage/monopoly3th_atlas", var1_51)

	findTF(var2_51, "icon"):GetComponent(typeof(Image)).sprite = var3_51

	findTF(var2_51, "icon"):GetComponent(typeof(Image)):SetNativeSize()
	setActive(var2_51, true)
	setParent(var2_51, arg0_51.cellPos)
	table.insert(arg0_51.mapCells, var2_51)
end

function var0_0.updateMap(arg0_52, arg1_52)
	for iter0_52 = 1, #arg0_52.mapCells do
		local var0_52 = arg0_52.mapCells[iter0_52].anchoredPosition

		var0_52.x = var0_52.x - arg1_52
		arg0_52.mapCells[iter0_52].anchoredPosition = var0_52
	end

	if #arg0_52.mapCells > 0 and arg0_52.mapCells[1].anchoredPosition.x < -1000 then
		local var1_52 = table.remove(arg0_52.mapCells, 1)

		Destroy(var1_52)
	end

	for iter1_52 = 1, #arg0_52.groundChildsList do
		local var2_52 = arg0_52.groundMoveRate[iter1_52]
		local var3_52 = arg0_52.groundChildsList[iter1_52]

		for iter2_52 = #var3_52, 1, -1 do
			local var4_52 = var3_52[iter2_52]

			var4_52.anchoredPosition = Vector3(var4_52.anchoredPosition.x - arg1_52 * var2_52, var4_52.anchoredPosition.y, var4_52.anchoredPosition.z)
		end
	end

	for iter3_52 = 1, #arg0_52.groundChildsList do
		local var5_52 = arg0_52.groundChildsList[iter3_52]

		for iter4_52 = #var5_52, 1, -1 do
			local var6_52 = var5_52[iter4_52]

			if var6_52.anchoredPosition.x <= -var6_52.sizeDelta.x and #var5_52 > 1 then
				local var7_52 = table.remove(var5_52, iter4_52)

				var7_52.anchoredPosition = Vector3(var5_52[#var5_52].anchoredPosition.x + var5_52[#var5_52].sizeDelta.x, var6_52.anchoredPosition.y, var6_52.anchoredPosition.z)

				table.insert(var5_52, var7_52)
			end
		end
	end
end

function var0_0.changeCharAction(arg0_53, arg1_53, arg2_53, arg3_53)
	if arg0_53.actionName == arg1_53 and arg0_53.actionName ~= var13_0 then
		return
	end

	arg0_53.actionName = arg1_53

	arg0_53.anim:SetActionCallBack(nil)
	arg0_53.anim:SetAction(arg1_53, 0)
	arg0_53.anim:SetActionCallBack(function(arg0_54)
		if arg0_54 == "finish" then
			if arg2_53 == 1 then
				arg0_53.anim:SetActionCallBack(nil)
				arg0_53.anim:SetAction(var11_0, 0)
			end

			if arg3_53 then
				arg3_53()
			end
		end
	end)

	if arg2_53 ~= 1 and arg3_53 then
		arg3_53()
	end
end

function var0_0.getActionName(arg0_55, arg1_55)
	local var0_55 = arg0_55.mapIds[arg1_55]
	local var1_55 = pg.activity_event_monopoly_map[var0_55].icon

	if var1_55 == "icon_1" then
		return var9_0
	elseif var1_55 == "icon_2" then
		return var7_0
	elseif var1_55 == "icon_3" then
		return nil
	elseif var1_55 == "icon_4" then
		return var9_0
	elseif var1_55 == "icon_5" then
		return var8_0
	elseif var1_55 == "icon_6" then
		return var9_0
	end

	return var9_0
end

function var0_0.dispose(arg0_56)
	if arg0_56.model then
		PoolMgr.GetInstance():ReturnSpineChar(var1_0, arg0_56.model)
	end

	if arg0_56.randomMoveTiemr then
		if arg0_56.randomMoveTiemr.running then
			arg0_56.randomMoveTiemr:Stop()
		end

		arg0_56.randomMoveTiemr = nil
	end

	if LeanTween.isTweening(go(arg0_56.btnRp)) then
		LeanTween.cancel(go(arg0_56.btnRp))
	end

	if LeanTween.isTweening(go(arg0_56.cellPos)) then
		LeanTween.cancel(go(arg0_56.cellPos))
	end
end

return var0_0
