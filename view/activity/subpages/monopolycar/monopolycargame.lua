local var0 = class("MonopolyCarGame")
local var1 = 100
local var2 = 50
local var3 = "redcar"
local var4 = {
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
local var5 = 0.6
local var6 = "B-stand"
local var7 = "F-stand"
local var8 = "B-walk"
local var9 = "F-walk"
local var10 = "typeMoveUp"
local var11 = "typeMoveDown"
local var12 = "typeMoveLeft"
local var13 = "typeMoveRight"

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._binder = arg1
	arg0._tf = arg2
	arg0._event = arg3

	arg0:initData()
	arg0:initUI()
	arg0:initEvent()
end

function var0.initData(arg0)
	arg0.leftCount = 0
	arg0.inAnimatedFlag = false
	arg0.mapCells = {}

	local var0 = math.random(1, #var4)

	arg0.showSkinId = var4[var0]
end

function var0.initUI(arg0)
	arg0.tplMapCell = findTF(arg0._tf, "tplMapCell")
	arg0.mapContainer = findTF(arg0._tf, "mapContainer")
	arg0.char = findTF(arg0._tf, "mapContainer/char")
	arg0.showChar = findTF(arg0._tf, "showChar")

	setActive(arg0.char, false)

	arg0.btnStart = findTF(arg0._tf, "btnStart")
	arg0.btnHelp = findTF(arg0._tf, "btnHelp")
	arg0.btnRp = findTF(arg0._tf, "btnRp")
	arg0.commonAnim = findTF(arg0.btnRp, "rpAni"):GetComponent(typeof(Animator))
	arg0.labelLeftCountTip = findTF(arg0.btnStart, "labelLeftCountTip")

	setActive(arg0.labelLeftCountTip, false)

	arg0.labelLeftCount = findTF(arg0.btnStart, "labelLeftCount")
	arg0.labelDropShip = findTF(arg0._tf, "labelDropShip")
	arg0.labelLeftRpCount = findTF(arg0._tf, "labelLeftRpCount")
	arg0.rollStep = findTF(arg0._tf, "step")

	setActive(arg0.rollStep, false)

	arg0.mcTouzi = findTF(arg0._tf, "mcTouzi")
	arg0.imgTouzi = findTF(arg0._tf, "imgTouzi")

	setActive(arg0.mcTouzi, false)
	arg0:initMap()
	arg0:initChar()
end

function var0.initEvent(arg0)
	onButton(arg0._binder, arg0.btnStart, function()
		if arg0.inAnimatedFlag then
			return
		end

		if arg0.leftCount and arg0.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		arg0:changeAnimeState(true)
		setActive(arg0.btnStart, true)
		arg0._event:emit(MonopolyCarPage.ON_START, arg0.activity.id, function(arg0)
			if arg0 and arg0 > 0 then
				arg0:showRollAnimated(arg0)
			end
		end)
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_car.tip
		})
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.showChar, function()
		arg0._event:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0._binder, arg0.btnRp, function()
		if arg0.leftAwardCnt > 0 then
			arg0._event:emit(MonopolyCarPage.ON_AWARD)
		end
	end, SFX_PANEL)
end

function var0.showRollAnimated(arg0, arg1)
	local var0 = findTF(arg0.rollStep, "stepArrow")

	var0.localEulerAngles = Vector3(0, 0, 0)
	findTF(arg0.rollStep, "progress/bg"):GetComponent(typeof(Image)).fillAmount = 0.1
	findTF(arg0.rollStep, "select/bg"):GetComponent(typeof(Image)).fillAmount = 0.1

	setText(findTF(arg0.rollStep, "labelRoll"), "0")
	seriesAsync({
		function(arg0)
			LeanTween.value(go(arg0._tf), 1, 0, 0.2):setOnUpdate(System.Action_float(function(arg0)
				arg0.btnStart:GetComponent(typeof(CanvasGroup)).alpha = arg0
			end)):setOnComplete(System.Action(function()
				setActive(arg0.btnStart, false)

				arg0.btnStart:GetComponent(typeof(CanvasGroup)).alpha = 1

				arg0()
			end))
		end,
		function(arg0)
			LeanTween.value(go(arg0._tf), 0, 1, 0.2):setOnUpdate(System.Action_float(function(arg0)
				arg0.rollStep:GetComponent(typeof(CanvasGroup)).alpha = arg0

				setActive(arg0.rollStep, true)
			end)):setOnComplete(System.Action(function()
				arg0()
			end))
		end,
		function(arg0)
			local var0 = arg1 / 6 * 0.62
			local var1 = var0 / arg1
			local var2 = -arg1 * 31

			LeanTween.value(go(arg0._tf), 0, 1, 0.7 + arg1 / 5):setEase(LeanTweenType.easeOutCirc):setOnUpdate(System.Action_float(function(arg0)
				findTF(arg0.rollStep, "progress/bg"):GetComponent(typeof(Image)).fillAmount = var0 * arg0 + 0.13
				findTF(arg0.rollStep, "select/bg"):GetComponent(typeof(Image)).fillAmount = var1 * math.floor(arg0 / (1 / arg1)) + 0.17

				setText(findTF(arg0.rollStep, "labelRoll"), math.floor(arg0 / (1 / arg1)))

				local var0 = var2 * arg0 - 13

				var0.localEulerAngles = Vector3(0, 0, var0)
			end)):setOnComplete(System.Action(function()
				arg0()
			end))
		end,
		function(arg0)
			LeanTween.value(go(arg0._tf), 1, 0, 0.3):setOnComplete(System.Action(function()
				arg0()
			end))
		end,
		function(arg0)
			LeanTween.value(go(arg0._tf), 1, 0, 0.3):setOnUpdate(System.Action_float(function(arg0)
				arg0.rollStep:GetComponent(typeof(CanvasGroup)).alpha = arg0
			end)):setOnComplete(System.Action(function()
				setActive(arg0.rollStep, false)

				arg0.rollStep:GetComponent(typeof(CanvasGroup)).alpha = 1

				arg0()
			end))
		end
	}, function()
		setActive(arg0.mcTouzi, true)
		setActive(arg0.mcTouzi, false)

		arg0.useCount = arg0.useCount + 1
		arg0.step = arg1

		if arg0.step > 0 then
			local var0 = GetSpriteFromAtlas("ui/activityuipage/monopolycar_atlas", arg0.step)

			setActive(arg0.imgTouzi, true)

			arg0.imgTouzi:GetComponent(typeof(Image)).sprite = var0
		end

		arg0:updataUI()
		arg0:checkCharActive()
	end)
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

function var0.changeAnimeState(arg0, arg1)
	if arg1 then
		arg0.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		arg0.inAnimatedFlag = true

		arg0._event:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
	else
		arg0.inAnimatedFlag = false
		arg0.btnStart:GetComponent(typeof(Image)).raycastTarget = true

		setActive(arg0.imgTouzi, false)
		arg0._event:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
	end

	setActive(arg0.btnStart, not arg1)
end

function var0.initMap(arg0)
	local var0 = MonopolyCarConst.map_dic

	arg0.mapCells = {}

	for iter0 = 1, #var0 do
		local var1 = iter0 - 1
		local var2 = {
			x = -var1 * var1,
			y = -var1 * var2
		}
		local var3 = var0[iter0]

		for iter1 = 1, #var3 do
			local var4 = iter1 - 1
			local var5 = var3[iter1]

			if var5 > 0 then
				local var6 = cloneTplTo(arg0.tplMapCell, arg0.mapContainer, tostring(var5))
				local var7 = Vector2(var1 * var4 + var2.x, -var2 * var4 + var2.y)

				var6.localPosition = var7

				local var8 = pg.activity_event_monopoly_map[var5].icon
				local var9 = GetSpriteFromAtlas("ui/activityuipage/monopolycar_atlas", var8)

				findTF(var6, "image"):GetComponent(typeof(Image)).sprite = var9

				findTF(var6, "image"):GetComponent(typeof(Image)):SetNativeSize()

				local var10 = {
					col = var4,
					row = var1,
					mapId = var5,
					tf = var6,
					icon = var8,
					position = var7
				}

				table.insert(arg0.mapCells, var10)
			end
		end
	end

	table.sort(arg0.mapCells, function(arg0, arg1)
		return arg0.mapId < arg1.mapId
	end)
end

function var0.initChar(arg0)
	PoolMgr.GetInstance():GetSpineChar(var3, true, function(arg0)
		arg0.model = arg0
		arg0.model.transform.localScale = Vector3.one
		arg0.model.transform.localPosition = Vector3.zero

		arg0.model.transform:SetParent(arg0.char, false)

		arg0.anim = arg0.model:GetComponent(typeof(SpineAnimUI))

		arg0:checkCharActive()

		if arg0.pos then
			arg0:updataCharDirect(arg0.pos, false)
		end
	end)
	PoolMgr.GetInstance():GetSpineChar(arg0.showSkinId, true, function(arg0)
		arg0.showModel = arg0
		arg0.showModel.transform.localScale = Vector3.one
		arg0.showModel.transform.localPosition = Vector3.zero

		arg0.showModel.transform:SetParent(arg0.showChar, false)

		arg0.showAnim = arg0.showModel:GetComponent(typeof(SpineAnimUI))

		arg0.showAnim:SetAction("stand", 0)
	end)
end

function var0.updataCharDirect(arg0, arg1, arg2)
	if arg0.model then
		local var0 = arg0.mapCells[arg1].position
		local var1 = arg1 + 1 > #arg0.mapCells and 1 or arg1 + 1
		local var2 = arg0.mapCells[var1]
		local var3, var4 = arg0:getMoveType(arg0.mapCells[arg1].mapId, arg0.mapCells[var1].mapId, arg2)

		arg0.char.localScale = Vector3(var4, arg0.char.localScale.y, arg0.char.localScale.z)

		arg0.anim:SetActionCallBack(nil)
		arg0.anim:SetAction(var3, 0)
	end
end

function var0.getMoveType(arg0, arg1, arg2, arg3)
	local var0 = MonopolyCarConst.map_dic
	local var1 = {}
	local var2 = {}

	for iter0 = 1, #var0 do
		local var3 = var0[iter0]

		for iter1 = 1, #var3 do
			local var4 = var3[iter1]

			if var4 == arg1 then
				var1 = {
					x = iter1,
					y = iter0
				}
			end

			if var4 == arg2 then
				var2 = {
					x = iter1,
					y = iter0
				}
			end
		end
	end

	local var5
	local var6

	if var2.y > var1.y then
		var5 = arg3 and var9 or var7
		var6 = var5
	elseif var2.y < var1.y then
		var5 = arg3 and var8 or var6
		var6 = var5
	elseif var2.x > var1.x then
		var5 = arg3 and var9 or var7
		var6 = -var5
	elseif var2.x < var1.x then
		var5 = arg3 and var8 or var6
		var6 = -var5
	end

	return var5, var6
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
		end
	end
end

function var0.firstUpdata(arg0, arg1)
	arg0:activityDataUpdata(arg1)
	arg0:updataUI()
	arg0:updataChar()
	arg0:checkCharActive()
end

function var0.updataActivity(arg0, arg1)
	arg0:activityDataUpdata(arg1)
	arg0:updataUI()
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
	arg0.pos = arg0.activity.data2
	arg0.step = arg0.activity.data3
	arg0.effectId = arg0.activity.data4
end

function var0.checkStep(arg0, arg1)
	if arg0.step > 0 then
		arg0._event:emit(MonopolyCarPage.ON_MOVE, arg0.activity.id, function(arg0, arg1, arg2)
			arg0.step = arg0
			arg0.pos = arg1[#arg1]
			arg0.effectId = arg2

			seriesAsync({
				function(arg0)
					local var0

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
	arg0.commonAnim:SetInteger("count", arg0.leftAwardCnt)
	setText(arg0.labelDropShip, "" .. arg0.turnCnt + 1)
	setText(arg0.labelLeftCountTip, i18n("monopoly_left_count"))
	setText(arg0.labelLeftCount, arg0.leftCount)
end

function var0.updataChar(arg0)
	local var0 = arg0.mapCells[arg0.pos]

	arg0.char.localPosition = var0.position

	if not isActive(arg0.char) then
		SetActive(arg0.char, true)
		arg0.char:SetAsLastSibling()
	end

	if arg0.model then
		arg0:updataCharDirect(arg0.pos, false)
	end
end

function var0.checkEffect(arg0, arg1)
	if arg0.effectId > 0 then
		local var0 = arg0.mapCells[arg0.pos]
		local var1 = pg.activity_event_monopoly_event[arg0.effectId].story

		seriesAsync({
			function(arg0)
				if var1 and tonumber(var1) ~= 0 then
					pg.NewStoryMgr.GetInstance():Play(var1, arg0, true, true)
				else
					arg0()
				end
			end,
			function(arg0)
				arg0:triggerEfeect(arg0)
			end,
			function(arg0)
				arg0:checkCountStory(arg0)
			end
		}, arg1)
	elseif arg1 then
		arg1()
	end
end

function var0.triggerEfeect(arg0, arg1)
	arg0._event:emit(MonopolyCarPage.ON_TRIGGER, arg0.activity.id, function(arg0, arg1)
		if arg0 and #arg0 >= 0 then
			arg0.effectId = arg1
			arg0.pos = arg0[#arg0]

			seriesAsync({
				function(arg0)
					arg0:moveCharWithPaths(arg0, nil, arg0)
				end
			}, function()
				arg1()
			end)
		end
	end)
end

function var0.moveCarWithPaths(arg0, arg1, arg2, arg3)
	if not arg1 or #arg1 <= 0 then
		if arg3 then
			arg3()
		end

		return
	end

	local var0 = {}
	local var1 = arg0.char.localPosition
	local var2 = {}
	local var3 = {}

	for iter0 = 1, #arg1 do
		if arg0:checkPathTurn(arg1[iter0]) then
			table.insert(var2, arg0.mapCells[arg1[iter0]].position)
			table.insert(var3, arg1[iter0])
		elseif iter0 == #arg1 then
			table.insert(var2, arg0.mapCells[arg1[iter0]].position)
			table.insert(var3, arg1[iter0])
		end
	end

	arg0.speedX = 0
	arg0.speedY = 0
	arg0.baseSpeed = 6
	arg0.baseASpeed = 0.1

	if not arg0.timer then
		arg0.timer = Timer.New(function()
			arg0:toMoveCar()
		end, 0.0166666666666667, -1)

		arg0.timer:Start()
	end

	for iter1 = 1, #var2 do
		table.insert(var0, function(arg0)
			arg0.moveComplete = arg0
			arg0.stopOnEnd = false
			arg0.targetPosition = var2[iter1]
			arg0.targetPosIndex = var3[iter1]
			arg0.moveX = arg0.targetPosition.x - arg0.char.localPosition.x
			arg0.moveY = arg0.targetPosition.y - arg0.char.localPosition.y
			arg0.baseSpeedX = arg0.baseSpeed * (arg0.moveX / math.abs(arg0.moveX))
			arg0.baseASpeedX = arg0.baseASpeed * (arg0.moveX / math.abs(arg0.moveX))
			arg0.baseSpeedY = math.abs(arg0.baseSpeedX) / (math.abs(arg0.moveX) / arg0.moveY)
			arg0.baseASpeedY = math.abs(arg0.baseASpeedX) / (math.abs(arg0.moveX) / arg0.moveY)

			if iter1 == 1 then
				arg0.speedX = 0
				arg0.speedY = 0
			else
				arg0.speedX = arg0.baseSpeedX
				arg0.speedY = arg0.baseSpeedY
			end
		end)
	end

	table.insert(var0, function(arg0)
		arg0.moveComplete = nil

		arg0:updataCharDirect(arg1[#arg1], false)
		arg0()
	end)
	table.insert(var0, function(arg0)
		LeanTween.value(go(arg0._tf), 1, 0, 0.1):setOnComplete(System.Action(function()
			arg0()
		end))
	end)
	seriesAsync(var0, arg3)
end

function var0.toMoveCar(arg0)
	if not arg0.targetPosition then
		return
	end

	local var0 = math.abs(arg0.targetPosition.x - arg0.char.localPosition.x)
	local var1 = math.abs(arg0.targetPosition.y - arg0.char.localPosition.y)

	if var0 <= 6.5 and var1 <= 6.5 then
		arg0.targetPosition = nil

		if arg0.moveComplete then
			arg0:updataCharDirect(arg0.targetPosIndex, true)
			arg0.moveComplete()
		end
	end

	arg0.speedX = math.abs(arg0.speedX + arg0.baseASpeedX) > math.abs(arg0.baseSpeedX) and arg0.baseSpeedX or arg0.speedX + arg0.baseASpeedX
	arg0.speedY = math.abs(arg0.speedY + arg0.baseASpeedY) > math.abs(arg0.baseSpeedY) and arg0.baseSpeedY or arg0.speedY + arg0.baseASpeedY

	local var2 = arg0.char.localPosition

	arg0.char.localPosition = Vector3(var2.x + arg0.speedX, var2.y + arg0.speedY, 0)
end

function var0.checkPathTurn(arg0, arg1)
	local var0 = arg1 + 1 > #arg0.mapCells and 1 or arg1 + 1
	local var1 = arg1 - 1 < 1 and #arg0.mapCells or arg1 - 1

	if arg0.mapCells[var0].col == arg0.mapCells[var1].col or arg0.mapCells[var0].row == arg0.mapCells[var1].row then
		return false
	end

	return true
end

function var0.moveCharWithPaths(arg0, arg1, arg2, arg3)
	arg0:moveCarWithPaths(arg1, arg2, arg3)

	do return end

	if not arg1 or #arg1 <= 0 then
		if arg3 then
			arg3()
		end

		return
	end

	local var0 = {}
	local var1 = arg1[1] - 1 < 1 and #arg0.mapCells or arg1[1] - 1

	for iter0 = 1, #arg1 do
		local var2 = arg0.mapCells[arg1[iter0]]

		table.insert(var0, function(arg0)
			arg0:updataCharDirect(var1, true)

			var1 = arg1[iter0]

			local var0 = 0.35

			LeanTween.moveLocal(go(arg0.char), var2.tf.localPosition, var0):setEase(LeanTweenType.linear):setOnComplete(System.Action(function()
				arg0()
			end))
		end)

		if iter0 == #arg1 then
			table.insert(var0, function(arg0)
				arg0:updataCharDirect(arg1[iter0], false)
				arg0()
			end)
		end
	end

	seriesAsync(var0, arg3)
end

function var0.dispose(arg0)
	PoolMgr.GetInstance():ReturnSpineChar(var3, arg0.model)
	PoolMgr.GetInstance():ReturnSpineChar(arg0.showSkinId, arg0.showModel)
end

return var0
