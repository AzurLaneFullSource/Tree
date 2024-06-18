local var0_0 = class("MonopolyCarGame")
local var1_0 = 100
local var2_0 = 50
local var3_0 = "redcar"
local var4_0 = {
	"gaoxiong_5",
	"aidang_5",
	"dafeng_5",
	"yuekegongjue_2",
	"weiershiqinwang_3",
	"xianghe_3",
	"ruihe_3",
	"ougen_5",
	"qiye_7"
}
local var5_0 = 0.6
local var6_0 = "B-stand"
local var7_0 = "F-stand"
local var8_0 = "B-walk"
local var9_0 = "F-walk"
local var10_0 = "typeMoveUp"
local var11_0 = "typeMoveDown"
local var12_0 = "typeMoveLeft"
local var13_0 = "typeMoveRight"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1._event = arg3_1

	arg0_1:initData()
	arg0_1:initUI()
	arg0_1:initEvent()
end

function var0_0.initData(arg0_2)
	arg0_2.leftCount = 0
	arg0_2.inAnimatedFlag = false
	arg0_2.mapCells = {}

	local var0_2 = math.random(1, #var4_0)

	arg0_2.showSkinId = var4_0[var0_2]
end

function var0_0.initUI(arg0_3)
	arg0_3.tplMapCell = findTF(arg0_3._tf, "tplMapCell")
	arg0_3.mapContainer = findTF(arg0_3._tf, "mapContainer")
	arg0_3.char = findTF(arg0_3._tf, "mapContainer/char")
	arg0_3.showChar = findTF(arg0_3._tf, "showChar")

	setActive(arg0_3.char, false)

	arg0_3.btnStart = findTF(arg0_3._tf, "btnStart")
	arg0_3.btnHelp = findTF(arg0_3._tf, "btnHelp")
	arg0_3.btnRp = findTF(arg0_3._tf, "btnRp")
	arg0_3.commonAnim = findTF(arg0_3.btnRp, "rpAni"):GetComponent(typeof(Animator))
	arg0_3.labelLeftCountTip = findTF(arg0_3.btnStart, "labelLeftCountTip")

	setActive(arg0_3.labelLeftCountTip, false)

	arg0_3.labelLeftCount = findTF(arg0_3.btnStart, "labelLeftCount")
	arg0_3.labelDropShip = findTF(arg0_3._tf, "labelDropShip")
	arg0_3.labelLeftRpCount = findTF(arg0_3._tf, "labelLeftRpCount")
	arg0_3.rollStep = findTF(arg0_3._tf, "step")

	setActive(arg0_3.rollStep, false)

	arg0_3.mcTouzi = findTF(arg0_3._tf, "mcTouzi")
	arg0_3.imgTouzi = findTF(arg0_3._tf, "imgTouzi")

	setActive(arg0_3.mcTouzi, false)
	arg0_3:initMap()
	arg0_3:initChar()
end

function var0_0.initEvent(arg0_4)
	onButton(arg0_4._binder, arg0_4.btnStart, function()
		if arg0_4.inAnimatedFlag then
			return
		end

		if arg0_4.leftCount and arg0_4.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		arg0_4:changeAnimeState(true)
		setActive(arg0_4.btnStart, true)
		arg0_4._event:emit(MonopolyCarPage.ON_START, arg0_4.activity.id, function(arg0_6)
			if arg0_6 and arg0_6 > 0 then
				arg0_4:showRollAnimated(arg0_6)
			end
		end)
	end, SFX_PANEL)
	onButton(arg0_4._binder, arg0_4.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_car.tip
		})
	end, SFX_PANEL)
	onButton(arg0_4._binder, arg0_4.showChar, function()
		arg0_4._event:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0_4._binder, arg0_4.btnRp, function()
		if arg0_4.leftAwardCnt > 0 then
			arg0_4._event:emit(MonopolyCarPage.ON_AWARD)
		end
	end, SFX_PANEL)
end

function var0_0.showRollAnimated(arg0_10, arg1_10)
	local var0_10 = findTF(arg0_10.rollStep, "stepArrow")

	var0_10.localEulerAngles = Vector3(0, 0, 0)
	findTF(arg0_10.rollStep, "progress/bg"):GetComponent(typeof(Image)).fillAmount = 0.1
	findTF(arg0_10.rollStep, "select/bg"):GetComponent(typeof(Image)).fillAmount = 0.1

	setText(findTF(arg0_10.rollStep, "labelRoll"), "0")
	seriesAsync({
		function(arg0_11)
			LeanTween.value(go(arg0_10._tf), 1, 0, 0.2):setOnUpdate(System.Action_float(function(arg0_12)
				arg0_10.btnStart:GetComponent(typeof(CanvasGroup)).alpha = arg0_12
			end)):setOnComplete(System.Action(function()
				setActive(arg0_10.btnStart, false)

				arg0_10.btnStart:GetComponent(typeof(CanvasGroup)).alpha = 1

				arg0_11()
			end))
		end,
		function(arg0_14)
			LeanTween.value(go(arg0_10._tf), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0_15)
				arg0_10.rollStep:GetComponent(typeof(CanvasGroup)).alpha = arg0_15

				setActive(arg0_10.rollStep, true)
			end)):setOnComplete(System.Action(function()
				arg0_14()
			end))
		end,
		function(arg0_17)
			local var0_17 = arg1_10 / 6 * 0.62
			local var1_17 = var0_17 / arg1_10
			local var2_17 = -arg1_10 * 31

			LeanTween.value(go(arg0_10._tf), 0, 1, 0.7 + arg1_10 / 5):setEase(LeanTweenType.easeOutCirc):setOnUpdate(System.Action_float(function(arg0_18)
				findTF(arg0_10.rollStep, "progress/bg"):GetComponent(typeof(Image)).fillAmount = var0_17 * arg0_18 + 0.13
				findTF(arg0_10.rollStep, "select/bg"):GetComponent(typeof(Image)).fillAmount = var1_17 * math.floor(arg0_18 / (1 / arg1_10)) + 0.17

				setText(findTF(arg0_10.rollStep, "labelRoll"), math.floor(arg0_18 / (1 / arg1_10)))

				local var0_18 = var2_17 * arg0_18 - 13

				var0_10.localEulerAngles = Vector3(0, 0, var0_18)
			end)):setOnComplete(System.Action(function()
				arg0_17()
			end))
		end,
		function(arg0_20)
			LeanTween.value(go(arg0_10._tf), 1, 0, 0.3):setOnComplete(System.Action(function()
				arg0_20()
			end))
		end,
		function(arg0_22)
			LeanTween.value(go(arg0_10._tf), 1, 0, 0.3):setOnUpdate(System.Action_float(function(arg0_23)
				arg0_10.rollStep:GetComponent(typeof(CanvasGroup)).alpha = arg0_23
			end)):setOnComplete(System.Action(function()
				setActive(arg0_10.rollStep, false)

				arg0_10.rollStep:GetComponent(typeof(CanvasGroup)).alpha = 1

				arg0_22()
			end))
		end
	}, function()
		setActive(arg0_10.mcTouzi, true)
		setActive(arg0_10.mcTouzi, false)

		arg0_10.useCount = arg0_10.useCount + 1
		arg0_10.step = arg1_10

		if arg0_10.step > 0 then
			local var0_25 = GetSpriteFromAtlas("ui/activityuipage/monopolycar_atlas", arg0_10.step)

			setActive(arg0_10.imgTouzi, true)

			arg0_10.imgTouzi:GetComponent(typeof(Image)).sprite = var0_25
		end

		arg0_10:updataUI()
		arg0_10:checkCharActive()
	end)
end

function var0_0.checkCountStory(arg0_26, arg1_26)
	local var0_26 = arg0_26.useCount
	local var1_26 = arg0_26.activity:getDataConfig("story") or {}
	local var2_26 = _.detect(var1_26, function(arg0_27)
		return arg0_27[1] == var0_26
	end)

	if var2_26 then
		pg.NewStoryMgr.GetInstance():Play(var2_26[2], arg1_26)
	else
		arg1_26()
	end
end

function var0_0.changeAnimeState(arg0_28, arg1_28)
	if arg1_28 then
		arg0_28.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0_28.inAnimatedFlag = true

		arg0_28._event:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
	else
		arg0_28.inAnimatedFlag = false
		arg0_28.btnStart:GetComponent(typeof(Image)).raycastTarget = true

		setActive(arg0_28.imgTouzi, false)
		arg0_28._event:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
	end

	setActive(arg0_28.btnStart, not arg1_28)
end

function var0_0.initMap(arg0_29)
	local var0_29 = MonopolyCarConst.map_dic

	arg0_29.mapCells = {}

	for iter0_29 = 1, #var0_29 do
		local var1_29 = iter0_29 - 1
		local var2_29 = {
			x = -var1_29 * var1_0,
			y = -var1_29 * var2_0
		}
		local var3_29 = var0_29[iter0_29]

		for iter1_29 = 1, #var3_29 do
			local var4_29 = iter1_29 - 1
			local var5_29 = var3_29[iter1_29]

			if var5_29 > 0 then
				local var6_29 = cloneTplTo(arg0_29.tplMapCell, arg0_29.mapContainer, tostring(var5_29))
				local var7_29 = Vector2(var1_0 * var4_29 + var2_29.x, -var2_0 * var4_29 + var2_29.y)

				var6_29.localPosition = var7_29

				local var8_29 = pg.activity_event_monopoly_map[var5_29].icon
				local var9_29 = GetSpriteFromAtlas("ui/activityuipage/monopolycar_atlas", var8_29)

				findTF(var6_29, "image"):GetComponent(typeof(Image)).sprite = var9_29

				findTF(var6_29, "image"):GetComponent(typeof(Image)):SetNativeSize()

				local var10_29 = {
					col = var4_29,
					row = var1_29,
					mapId = var5_29,
					tf = var6_29,
					icon = var8_29,
					position = var7_29
				}

				table.insert(arg0_29.mapCells, var10_29)
			end
		end
	end

	table.sort(arg0_29.mapCells, function(arg0_30, arg1_30)
		return arg0_30.mapId < arg1_30.mapId
	end)
end

function var0_0.initChar(arg0_31)
	PoolMgr.GetInstance():GetSpineChar(var3_0, true, function(arg0_32)
		arg0_31.model = arg0_32
		arg0_31.model.transform.localScale = Vector3.one
		arg0_31.model.transform.localPosition = Vector3.zero

		arg0_31.model.transform:SetParent(arg0_31.char, false)

		arg0_31.anim = arg0_31.model:GetComponent(typeof(SpineAnimUI))

		arg0_31:checkCharActive()

		if arg0_31.pos then
			arg0_31:updataCharDirect(arg0_31.pos, false)
		end
	end)
	PoolMgr.GetInstance():GetSpineChar(arg0_31.showSkinId, true, function(arg0_33)
		arg0_31.showModel = arg0_33
		arg0_31.showModel.transform.localScale = Vector3.one
		arg0_31.showModel.transform.localPosition = Vector3.zero

		arg0_31.showModel.transform:SetParent(arg0_31.showChar, false)

		arg0_31.showAnim = arg0_31.showModel:GetComponent(typeof(SpineAnimUI))

		arg0_31.showAnim:SetAction("stand", 0)
	end)
end

function var0_0.updataCharDirect(arg0_34, arg1_34, arg2_34)
	if arg0_34.model then
		local var0_34 = arg0_34.mapCells[arg1_34].position
		local var1_34 = arg1_34 + 1 > #arg0_34.mapCells and 1 or arg1_34 + 1
		local var2_34 = arg0_34.mapCells[var1_34]
		local var3_34, var4_34 = arg0_34:getMoveType(arg0_34.mapCells[arg1_34].mapId, arg0_34.mapCells[var1_34].mapId, arg2_34)

		arg0_34.char.localScale = Vector3(var4_34, arg0_34.char.localScale.y, arg0_34.char.localScale.z)

		arg0_34.anim:SetActionCallBack(nil)
		arg0_34.anim:SetAction(var3_34, 0)
	end
end

function var0_0.getMoveType(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = MonopolyCarConst.map_dic
	local var1_35 = {}
	local var2_35 = {}

	for iter0_35 = 1, #var0_35 do
		local var3_35 = var0_35[iter0_35]

		for iter1_35 = 1, #var3_35 do
			local var4_35 = var3_35[iter1_35]

			if var4_35 == arg1_35 then
				var1_35 = {
					x = iter1_35,
					y = iter0_35
				}
			end

			if var4_35 == arg2_35 then
				var2_35 = {
					x = iter1_35,
					y = iter0_35
				}
			end
		end
	end

	local var5_35
	local var6_35

	if var2_35.y > var1_35.y then
		var5_35 = arg3_35 and var9_0 or var7_0
		var6_35 = var5_0
	elseif var2_35.y < var1_35.y then
		var5_35 = arg3_35 and var8_0 or var6_0
		var6_35 = var5_0
	elseif var2_35.x > var1_35.x then
		var5_35 = arg3_35 and var9_0 or var7_0
		var6_35 = -var5_0
	elseif var2_35.x < var1_35.x then
		var5_35 = arg3_35 and var8_0 or var6_0
		var6_35 = -var5_0
	end

	return var5_35, var6_35
end

function var0_0.checkCharActive(arg0_36)
	if arg0_36.anim then
		if arg0_36.effectId and arg0_36.effectId > 0 then
			arg0_36:changeAnimeState(true)
			arg0_36:checkEffect(function()
				arg0_36:changeAnimeState(false)
				arg0_36:checkCharActive()
			end)
		elseif arg0_36.step and arg0_36.step > 0 then
			arg0_36:changeAnimeState(true)
			arg0_36:checkStep(function()
				arg0_36:changeAnimeState(false)
				arg0_36:checkCharActive()
			end)
		end
	end
end

function var0_0.firstUpdata(arg0_39, arg1_39)
	arg0_39:activityDataUpdata(arg1_39)
	arg0_39:updataUI()
	arg0_39:updataChar()
	arg0_39:checkCharActive()
end

function var0_0.updataActivity(arg0_40, arg1_40)
	arg0_40:activityDataUpdata(arg1_40)
	arg0_40:updataUI()
end

function var0_0.activityDataUpdata(arg0_41, arg1_41)
	arg0_41.activity = arg1_41

	local var0_41 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_41 = arg0_41.activity.data1

	arg0_41.totalCnt = math.ceil((var0_41 - var1_41) / 86400) * arg0_41.activity:getDataConfig("daily_time") + arg0_41.activity.data1_list[1]
	arg0_41.useCount = arg0_41.activity.data1_list[2]
	arg0_41.leftCount = arg0_41.totalCnt - arg0_41.useCount
	arg0_41.turnCnt = arg0_41.activity.data1_list[3] - 1
	arg0_41.leftDropShipCnt = 8 - arg0_41.turnCnt

	local var2_41 = arg0_41.activity.data2_list[2]

	arg0_41.advanceTotalCnt = #arg1_41:getDataConfig("reward")
	arg0_41.isAdvanceRp = arg0_41.advanceTotalCnt - var2_41 > 0

	local var3_41 = arg0_41.activity.data2_list[1]

	arg0_41.leftAwardCnt = var3_41 - var2_41
	arg0_41.advanceRpCount = math.max(0, math.min(var3_41, arg0_41.advanceTotalCnt) - var2_41)
	arg0_41.commonRpCount = math.max(0, var3_41 - arg0_41.advanceTotalCnt) - math.max(0, var2_41 - arg0_41.advanceTotalCnt)

	local var4_41 = arg1_41:getDataConfig("reward_time")

	arg0_41.nextredPacketStep = var4_41 - arg0_41.useCount % var4_41
	arg0_41.pos = arg0_41.activity.data2
	arg0_41.step = arg0_41.activity.data3
	arg0_41.effectId = arg0_41.activity.data4
end

function var0_0.checkStep(arg0_42, arg1_42)
	if arg0_42.step > 0 then
		arg0_42._event:emit(MonopolyCarPage.ON_MOVE, arg0_42.activity.id, function(arg0_43, arg1_43, arg2_43)
			arg0_42.step = arg0_43
			arg0_42.pos = arg1_43[#arg1_43]
			arg0_42.effectId = arg2_43

			seriesAsync({
				function(arg0_44)
					local var0_44

					arg0_42:moveCharWithPaths(arg1_43, var0_44, arg0_44)
				end,
				function(arg0_45)
					arg0_42:checkEffect(arg0_45)
				end
			}, function()
				if arg1_42 then
					arg1_42()
				end
			end)
		end)
	elseif arg1_42 then
		arg1_42()
	end
end

function var0_0.updataUI(arg0_47)
	setText(arg0_47.labelLeftRpCount, "" .. arg0_47.leftAwardCnt)
	arg0_47.commonAnim:SetInteger("count", arg0_47.leftAwardCnt)
	setText(arg0_47.labelDropShip, "" .. arg0_47.turnCnt + 1)
	setText(arg0_47.labelLeftCountTip, i18n("monopoly_left_count"))
	setText(arg0_47.labelLeftCount, arg0_47.leftCount)
end

function var0_0.updataChar(arg0_48)
	local var0_48 = arg0_48.mapCells[arg0_48.pos]

	arg0_48.char.localPosition = var0_48.position

	if not isActive(arg0_48.char) then
		SetActive(arg0_48.char, true)
		arg0_48.char:SetAsLastSibling()
	end

	if arg0_48.model then
		arg0_48:updataCharDirect(arg0_48.pos, false)
	end
end

function var0_0.checkEffect(arg0_49, arg1_49)
	if arg0_49.effectId > 0 then
		local var0_49 = arg0_49.mapCells[arg0_49.pos]
		local var1_49 = pg.activity_event_monopoly_event[arg0_49.effectId].story

		seriesAsync({
			function(arg0_50)
				if var1_49 and tonumber(var1_49) ~= 0 then
					pg.NewStoryMgr.GetInstance():Play(var1_49, arg0_50, true, true)
				else
					arg0_50()
				end
			end,
			function(arg0_51)
				arg0_49:triggerEfeect(arg0_51)
			end,
			function(arg0_52)
				arg0_49:checkCountStory(arg0_52)
			end
		}, arg1_49)
	elseif arg1_49 then
		arg1_49()
	end
end

function var0_0.triggerEfeect(arg0_53, arg1_53)
	arg0_53._event:emit(MonopolyCarPage.ON_TRIGGER, arg0_53.activity.id, function(arg0_54, arg1_54)
		if arg0_54 and #arg0_54 >= 0 then
			arg0_53.effectId = arg1_54
			arg0_53.pos = arg0_54[#arg0_54]

			seriesAsync({
				function(arg0_55)
					arg0_53:moveCharWithPaths(arg0_54, nil, arg0_55)
				end
			}, function()
				arg1_53()
			end)
		end
	end)
end

function var0_0.moveCarWithPaths(arg0_57, arg1_57, arg2_57, arg3_57)
	if not arg1_57 or #arg1_57 <= 0 then
		if arg3_57 then
			arg3_57()
		end

		return
	end

	local var0_57 = {}
	local var1_57 = arg0_57.char.localPosition
	local var2_57 = {}
	local var3_57 = {}

	for iter0_57 = 1, #arg1_57 do
		if arg0_57:checkPathTurn(arg1_57[iter0_57]) then
			table.insert(var2_57, arg0_57.mapCells[arg1_57[iter0_57]].position)
			table.insert(var3_57, arg1_57[iter0_57])
		elseif iter0_57 == #arg1_57 then
			table.insert(var2_57, arg0_57.mapCells[arg1_57[iter0_57]].position)
			table.insert(var3_57, arg1_57[iter0_57])
		end
	end

	arg0_57.speedX = 0
	arg0_57.speedY = 0
	arg0_57.baseSpeed = 6
	arg0_57.baseASpeed = 0.1

	if not arg0_57.timer then
		arg0_57.timer = Timer.New(function()
			arg0_57:toMoveCar()
		end, 0.0166666666666667, -1)

		arg0_57.timer:Start()
	end

	for iter1_57 = 1, #var2_57 do
		table.insert(var0_57, function(arg0_59)
			arg0_57.moveComplete = arg0_59
			arg0_57.stopOnEnd = false
			arg0_57.targetPosition = var2_57[iter1_57]
			arg0_57.targetPosIndex = var3_57[iter1_57]
			arg0_57.moveX = arg0_57.targetPosition.x - arg0_57.char.localPosition.x
			arg0_57.moveY = arg0_57.targetPosition.y - arg0_57.char.localPosition.y
			arg0_57.baseSpeedX = arg0_57.baseSpeed * (arg0_57.moveX / math.abs(arg0_57.moveX))
			arg0_57.baseASpeedX = arg0_57.baseASpeed * (arg0_57.moveX / math.abs(arg0_57.moveX))
			arg0_57.baseSpeedY = math.abs(arg0_57.baseSpeedX) / (math.abs(arg0_57.moveX) / arg0_57.moveY)
			arg0_57.baseASpeedY = math.abs(arg0_57.baseASpeedX) / (math.abs(arg0_57.moveX) / arg0_57.moveY)

			if iter1_57 == 1 then
				arg0_57.speedX = 0
				arg0_57.speedY = 0
			else
				arg0_57.speedX = arg0_57.baseSpeedX
				arg0_57.speedY = arg0_57.baseSpeedY
			end
		end)
	end

	table.insert(var0_57, function(arg0_60)
		arg0_57.moveComplete = nil

		arg0_57:updataCharDirect(arg1_57[#arg1_57], false)
		arg0_60()
	end)
	table.insert(var0_57, function(arg0_61)
		LeanTween.value(go(arg0_57._tf), 1, 0, 0.1):setOnComplete(System.Action(function()
			arg0_61()
		end))
	end)
	seriesAsync(var0_57, arg3_57)
end

function var0_0.toMoveCar(arg0_63)
	if not arg0_63.targetPosition then
		return
	end

	local var0_63 = math.abs(arg0_63.targetPosition.x - arg0_63.char.localPosition.x)
	local var1_63 = math.abs(arg0_63.targetPosition.y - arg0_63.char.localPosition.y)

	if var0_63 <= 6.5 and var1_63 <= 6.5 then
		arg0_63.targetPosition = nil

		if arg0_63.moveComplete then
			arg0_63:updataCharDirect(arg0_63.targetPosIndex, true)
			arg0_63.moveComplete()
		end
	end

	arg0_63.speedX = math.abs(arg0_63.speedX + arg0_63.baseASpeedX) > math.abs(arg0_63.baseSpeedX) and arg0_63.baseSpeedX or arg0_63.speedX + arg0_63.baseASpeedX
	arg0_63.speedY = math.abs(arg0_63.speedY + arg0_63.baseASpeedY) > math.abs(arg0_63.baseSpeedY) and arg0_63.baseSpeedY or arg0_63.speedY + arg0_63.baseASpeedY

	local var2_63 = arg0_63.char.localPosition

	arg0_63.char.localPosition = Vector3(var2_63.x + arg0_63.speedX, var2_63.y + arg0_63.speedY, 0)
end

function var0_0.checkPathTurn(arg0_64, arg1_64)
	local var0_64 = arg1_64 + 1 > #arg0_64.mapCells and 1 or arg1_64 + 1
	local var1_64 = arg1_64 - 1 < 1 and #arg0_64.mapCells or arg1_64 - 1

	if arg0_64.mapCells[var0_64].col == arg0_64.mapCells[var1_64].col or arg0_64.mapCells[var0_64].row == arg0_64.mapCells[var1_64].row then
		return false
	end

	return true
end

function var0_0.moveCharWithPaths(arg0_65, arg1_65, arg2_65, arg3_65)
	arg0_65:moveCarWithPaths(arg1_65, arg2_65, arg3_65)

	do return end

	if not arg1_65 or #arg1_65 <= 0 then
		if arg3_65 then
			arg3_65()
		end

		return
	end

	local var0_65 = {}
	local var1_65 = arg1_65[1] - 1 < 1 and #arg0_65.mapCells or arg1_65[1] - 1

	for iter0_65 = 1, #arg1_65 do
		local var2_65 = arg0_65.mapCells[arg1_65[iter0_65]]

		table.insert(var0_65, function(arg0_66)
			arg0_65:updataCharDirect(var1_65, true)

			var1_65 = arg1_65[iter0_65]

			local var0_66 = 0.35

			LeanTween.moveLocal(go(arg0_65.char), var2_65.tf.localPosition, var0_66):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
				arg0_66()
			end))
		end)

		if iter0_65 == #arg1_65 then
			table.insert(var0_65, function(arg0_68)
				arg0_65:updataCharDirect(arg1_65[iter0_65], false)
				arg0_68()
			end)
		end
	end

	seriesAsync(var0_65, arg3_65)
end

function var0_0.dispose(arg0_69)
	PoolMgr.GetInstance():ReturnSpineChar(var3_0, arg0_69.model)
	PoolMgr.GetInstance():ReturnSpineChar(arg0_69.showSkinId, arg0_69.showModel)
end

return var0_0
