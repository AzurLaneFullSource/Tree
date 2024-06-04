local var0 = class("RollingBallGameView", import("..BaseMiniGameView"))
local var1 = "event:/ui/ddldaoshu2"
local var2 = "event:/ui/boat_drag"
local var3 = "event:/ui/break_out_full"
local var4 = "event:/ui/sx-good"
local var5 = "event:/ui/sx-perfect"
local var6 = "event:/ui/sx-jishu"
local var7 = "event:/ui/furnitrue_save"

function var0.getUIName(arg0)
	return "RollingBallGameUI"
end

function var0.init(arg0)
	local var0 = arg0:GetMGData()
	local var1 = arg0:GetMGHubData()

	arg0.tplScoreTip = findTF(arg0._tf, "tplScoreTip")
	arg0.tplRemoveEffect = findTF(arg0._tf, "sanxiaoxiaoshi")
	arg0.effectUI = findTF(arg0._tf, "effectUI")
	arg0.tplEffect = findTF(arg0._tf, "tplEffect")
	arg0.effectPoolTf = findTF(arg0._tf, "effectPool")
	arg0.effectPool = {}
	arg0.effectDatas = {}
	arg0.effectTargetPosition = findTF(arg0.effectUI, "effectTargetPos").localPosition
	arg0.rollingUI = findTF(arg0._tf, "rollingUI")
	arg0.rollingEffectUI = findTF(arg0._tf, "rollingEffectUI")
	arg0.tplGrid = findTF(arg0._tf, "tplRollingGrid")
	arg0.gridPoolTf = findTF(arg0._tf, "gridPool")
	arg0.gridsPool = {}
	arg0.gridDic = {}
	arg0.fillGridDic = {}
	arg0.startFlag = false

	local var2 = findTF(arg0.rollingUI, "dragAlphaGrid")

	arg0.dragAlphaGrid = RollingBallGrid.New(var2)

	setActive(arg0.dragAlphaGrid:getTf(), false)

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 0.0166666666666667, -1)

	for iter0 = 1, RollingBallConst.horizontal do
		arg0.gridDic[iter0] = {}
		arg0.fillGridDic[iter0] = {}

		for iter1 = 1, RollingBallConst.vertical do
			table.insert(arg0.gridDic[iter0], false)
		end
	end

	arg0.goodEffect = arg0:findTF("sanxiaoGood")
	arg0.greatEffect = arg0:findTF("sanxiaoGreat")
	arg0.perfectEffect = arg0:findTF("sanxiaoPerfect")
	arg0.caidaiTf = findTF(arg0._tf, "zhuanzhu_caidai")

	setActive(arg0.caidaiTf, false)

	arg0.startUI = findTF(arg0._tf, "startUI")

	onButton(arg0, findTF(arg0.startUI, "btnStart"), function()
		if not arg0.startFlag then
			setActive(arg0.startUI, false)
			arg0:gameStart()
		end
	end, SFX_CONFIRM)
	onButton(arg0, findTF(arg0.startUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_rollingBallGame.tip
		})
	end, SFX_CONFIRM)
	setActive(arg0.startUI, true)

	arg0.scoreUI = findTF(arg0._tf, "scoreUI")
	arg0.labelCurScore = findTF(arg0.scoreUI, "labelCur")
	arg0.labelHigh = findTF(arg0.scoreUI, "labelHigh")
	arg0.scoreNew = findTF(arg0.scoreUI, "new")

	onButton(arg0, findTF(arg0.scoreUI, "btnEnd"), function()
		setActive(arg0.scoreUI, false)
		setActive(arg0.startUI, true)
	end, SFX_CANCEL)
	setActive(arg0.scoreUI, false)

	arg0.downProgress = findTF(arg0._tf, "downProgress")
	arg0.downTimeSlider = findTF(arg0.downProgress, "Slider"):GetComponent(typeof(Slider))
	arg0.labelGameTime = findTF(arg0._tf, "labelGameTime")
	arg0.labelGameScore = findTF(arg0._tf, "labelGameScore")
	arg0.endLess = findTF(arg0._tf, "endLess")

	setActive(arg0.endLess, true)

	arg0.closeUI = findTF(arg0._tf, "closeUI")

	setActive(arg0.closeUI, false)
	onButton(arg0, findTF(arg0.closeUI, "btnOk"), function()
		if not arg0.countStart then
			arg0:closeView()
		end
	end, SFX_CONFIRM)
	onButton(arg0, findTF(arg0.closeUI, "btnCancel"), function()
		setActive(arg0.closeUI, false)
	end, SFX_CANCEL)

	arg0.overLight = findTF(arg0._tf, "overLight")

	setActive(arg0.overLight, false)
	onButton(arg0, findTF(arg0._tf, "btnClose"), function()
		if not arg0.startFlag then
			arg0:closeView()
		else
			setActive(arg0.closeUI, true)
		end
	end, SFX_CANCEL)
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.showScoreUI(arg0, arg1)
	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = var0 and #var0 > 0 and var0[1] or 0

	if var1 < arg1 then
		setActive(arg0.scoreNew, true)
	else
		setActive(arg0.scoreNew, false)
	end

	var1 = arg1 < var1 and var1 or arg1

	setActive(arg0.scoreUI, true)
	setText(arg0.labelCurScore, arg1)
	setText(arg0.labelHigh, var1)
	arg0:StoreDataToServer({
		var1
	})

	if arg0:getGameTimes() > 0 then
		arg0:SendSuccess(0)
	end
end

function var0.showCountStart(arg0, arg1)
	local var0 = findTF(arg0._tf, "count")

	setActive(var0, true)

	arg0.countIndex = 3
	arg0.countStart = true

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1)

	local function var1(arg0)
		local var0 = arg0.countIndex

		arg0.countIndex = arg0.countIndex - 1

		local var1 = findTF(var0, "show")
		local var2 = GetComponent(var1, typeof(CanvasGroup))

		seriesAsync({
			function(arg0)
				GetSpriteFromAtlasAsync("ui/rollingBallGame_atlas", "count_" .. var0, function(arg0)
					setImageSprite(var1, arg0, true)
				end)
				LeanTween.value(go(var1), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0)
					var2.alpha = arg0
				end)):setOnComplete(System.Action(function()
					arg0()
				end))
			end,
			function(arg0)
				LeanTween.value(go(var1), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0)
					var2.alpha = arg0
				end)):setOnComplete(System.Action(function()
					arg0()
				end))
			end
		}, arg0)
	end

	local var2 = {}

	for iter0 = 1, 3 do
		table.insert(var2, var1)
	end

	seriesAsync(var2, function()
		arg0.countStart = false

		setActive(var0, false)
		arg1()
	end)
end

function var0.gameStart(arg0)
	arg0.startFlag = true

	seriesAsync({
		function(arg0)
			arg0:showCountStart(arg0)
		end,
		function(arg0)
			arg0.moveDatas = {}
			arg0.selectGrid = nil
			arg0.selectEnterGrid = nil
			arg0.dragOffsetPos = Vector3(0, 0, 0)
			arg0.changeGridsDic = nil
			arg0.downTime = RollingBallConst.downTime
			arg0.comboAmount = 0
			arg0.stopFlag = false
			arg0.onBeginDragTime = nil

			if arg0:getGameTimes() > 0 then
				arg0.gameTime = RollingBallConst.gameTime
			else
				arg0.gameTime = RollingBallConst.finishGameTime
			end

			arg0.gameTimeReal = Time.realtimeSinceStartup
			arg0.gameTimeFlag = true

			setActive(arg0.endLess, false)

			arg0.gameScore = 0

			arg0:firstInitGrid()
			arg0:moveGridsBySelfPos(arg0.gridDic)
			arg0:timerStart()
		end
	}, nil)
end

function var0.gameStop(arg0)
	arg0:timerStop()
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var7)

	for iter0 = #arg0.effectDatas, 1, -1 do
		arg0:returnEffect(arg0.effectDatas[iter0].tf)
		table.remove(arg0.effectDatas, iter0)
	end

	for iter1 = 1, RollingBallConst.horizontal do
		for iter2 = 1, RollingBallConst.vertical do
			if arg0.gridDic[iter1][iter2] then
				arg0.gridDic[iter1][iter2]:setEventActive(false)
			end
		end
	end

	arg0:clearUI()
	arg0:showScoreUI(arg0.gameScore)
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.fallingGridDic(arg0)
	local function var0(arg0, arg1)
		for iter0 = arg1 + 1, RollingBallConst.vertical do
			if arg0.gridDic[arg0][iter0] then
				return iter0
			end
		end

		return 0
	end

	for iter0 = 1, RollingBallConst.horizontal do
		for iter1 = 1, RollingBallConst.vertical do
			if not arg0.gridDic[iter0][iter1] and RollingBallConst.vertical - iter1 > 0 then
				local var1 = var0(iter0, iter1)

				if var1 > 0 then
					local var2 = arg0.gridDic[iter0][var1]

					arg0.gridDic[iter0][var1] = false
					arg0.gridDic[iter0][iter1] = var2

					arg0.gridDic[iter0][iter1]:setPosData(iter0, iter1)
				end
			end
		end
	end
end

function var0.firstInitGrid(arg0)
	for iter0 = 1, RollingBallConst.horizontal do
		arg0.fillGridDic[iter0] = {}

		for iter1 = 1, RollingBallConst.vertical do
			if not arg0.gridDic[iter0][iter1] then
				local var0 = {}

				if iter0 > 2 and arg0.gridDic[iter0 - 2][iter1]:getType() == arg0.gridDic[iter0 - 1][iter1]:getType() then
					table.insert(var0, arg0.gridDic[iter0 - 2][iter1]:getType())
				end

				if iter1 > 2 and arg0.gridDic[iter0][iter1 - 2]:getType() == arg0.gridDic[iter0][iter1 - 1]:getType() then
					table.insert(var0, arg0.gridDic[iter0][iter1 - 2]:getType())
				end

				local var1 = arg0:createGrid(arg0:getRandomType(var0), iter0, iter1)

				arg0.gridDic[iter0][iter1] = var1

				arg0:setFillGridPosition(var1, iter0, #arg0.fillGridDic[iter0])
				table.insert(arg0.fillGridDic[iter0], var1)
			end
		end
	end
end

function var0.fillEmptyGrid(arg0)
	for iter0 = 1, RollingBallConst.horizontal do
		arg0.fillGridDic[iter0] = {}

		for iter1 = 1, RollingBallConst.vertical do
			if not arg0.gridDic[iter0][iter1] then
				local var0 = arg0:createGrid(arg0:getRandomType(), iter0, iter1)

				arg0.gridDic[iter0][iter1] = var0

				arg0:setFillGridPosition(var0, iter0, #arg0.fillGridDic[iter0])
				table.insert(arg0.fillGridDic[iter0], var0)
			end
		end
	end
end

function var0.setFillGridPosition(arg0, arg1, arg2, arg3)
	local var0 = (arg2 - 1) * RollingBallConst.grid_width
	local var1 = (RollingBallConst.vertical + arg3) * RollingBallConst.grid_height

	arg1:setPosition(var0, var1)
end

function var0.onTimer(arg0)
	for iter0 = #arg0.moveDatas, 1, -1 do
		local var0 = arg0.moveDatas[iter0]
		local var1 = var0.grid
		local var2 = var1:getPosition().x
		local var3 = var1:getPosition().y
		local var4 = var0.endX
		local var5 = var0.endY

		if var2 == var4 and var3 == var5 then
			var1:setEventActive(true)
			table.remove(arg0.moveDatas, iter0)
		else
			local var6
			local var7

			if math.abs(var4 - var2) < RollingBallConst.moveSpeed or var4 == var2 then
				var6 = var4 - var2
			elseif var2 < var4 then
				var6 = RollingBallConst.moveSpeed
			elseif var4 < var2 then
				var6 = -RollingBallConst.moveSpeed
			end

			if math.abs(var5 - var3) < RollingBallConst.moveSpeed or var3 == var5 then
				var7 = 0
				var3 = var5
			elseif var3 < var5 then
				var7 = RollingBallConst.moveSpeed
			elseif var5 < var3 then
				var7 = -RollingBallConst.moveSpeed
			end

			var1:setPosition(var2 + var6, var3 + var7)
		end
	end

	for iter1 = #arg0.effectDatas, 1, -1 do
		local var8 = arg0.effectDatas[iter1]
		local var9 = var8.tf.localPosition

		var8.ax = (arg0.effectTargetPosition.x - var9.x) * 0.002
		var8.ay = (arg0.effectTargetPosition.y - var9.y) * 0.002
		var8.vx = var8.vx + var8.ax
		var8.vy = var8.vy + var8.ay
		var9.x = var9.x + var8.vx
		var9.y = var9.y + var8.vy
		var8.tf.localPosition = var9

		if var9.x < arg0.effectTargetPosition.x then
			arg0:returnEffect(var8.tf)
			table.remove(arg0.effectDatas, iter1)
		end
	end

	if arg0.onBeginDragTime and arg0.downTime > 0 then
		local var10 = (Time.realtimeSinceStartup - arg0.onBeginDragTime) * 1000

		arg0.downTime = arg0.downTime - var10
		arg0.onBeginDragTime = Time.realtimeSinceStartup

		if arg0.downTime <= 0 then
			arg0.downTime = 0

			if arg0.selectGrid then
				local var11 = arg0.selectGrid

				var11:onEndDrag()
				arg0:onGridUp(var11)
				var11:addUpCallback(function(arg0, arg1)
					arg0:onGridUp(var11)
				end)
				var11:addDragCallback(function(arg0, arg1)
					arg0:onGridDrag(var11, arg0, arg1)
				end)
			end
		end
	end

	arg0.downTimeSlider.value = arg0.downTime / RollingBallConst.downTime

	if arg0.gameTimeFlag and arg0.gameTime > 0 and not isActive(arg0.closeUI) then
		local var12 = (Time.realtimeSinceStartup - arg0.gameTimeReal) * 1000

		arg0.gameTime = arg0.gameTime - var12

		if arg0.gameTime > 0 and arg0.gameTime <= 8000 and not isActive(arg0.overLight) then
			setActive(arg0.overLight, true)
		end

		if arg0.gameTime <= 0 then
			arg0.gameTime = 0

			setActive(arg0.overLight, false)

			arg0.stopFlag = true
		end
	end

	arg0.gameTimeReal = Time.realtimeSinceStartup

	local var13 = math.floor(arg0.gameTime / 60000)

	var13 = var13 < 10 and "0" .. var13 or var13

	local var14 = math.floor(arg0.gameTime % 60000 / 1000)

	var14 = var14 < 10 and "0" .. var14 or var14

	local var15 = math.floor(math.floor(arg0.gameTime % 1000) / 10)

	var15 = var15 < 10 and "0" .. var15 or var15

	setText(arg0.labelGameTime, var13 .. ":" .. var14 .. ":" .. var15)

	if #arg0.moveDatas == 0 then
		if arg0.stopFlag then
			arg0:gameStop()

			return
		end

		if arg0.checkSuccesFlag then
			arg0.checkSuccesFlag = false

			arg0:checkSuccessGrid()
		end

		if arg0.isMoveing then
			arg0.isMoveing = false
		end
	elseif not arg0.isMoveing then
		arg0.isMoveing = true
	end
end

function var0.moveGridsByChangeDic(arg0)
	arg0.moveDatas = {}

	for iter0 = 1, #arg0.changeGridsDic do
		local var0 = arg0.changeGridsDic[iter0]

		for iter1 = 1, #var0 do
			local var1 = var0[iter1]

			if var1.grid ~= arg0.selectGrid then
				arg0:moveGridToPos(var1.grid, var1.posX, var1.posY)
			end
		end
	end

	if #arg0.moveDatas > 0 then
		arg0:timerStart()
	end
end

function var0.moveGridsBySelfPos(arg0, arg1, arg2)
	arg0.moveDatas = {}

	for iter0 = 1, #arg1 do
		for iter1 = 1, #arg1[iter0] do
			local var0 = arg1[iter0][iter1]

			if var0 and var0 ~= arg2 then
				arg0:moveGridToPos(var0, var0:getPosData())
			end
		end
	end

	if #arg0.moveDatas > 0 then
		arg0:timerStart()
	end
end

function var0.moveGridToPos(arg0, arg1, arg2, arg3)
	local var0 = arg1:getPosition().x
	local var1 = arg1:getPosition().y
	local var2 = (arg2 - 1) * RollingBallConst.grid_width
	local var3 = (arg3 - 1) * RollingBallConst.grid_height

	if math.floor(var2) == math.floor(arg2) and math.floor(var3) == math.floor(arg3) then
		return
	end

	arg1:setEventActive(false)

	local var4 = {
		grid = arg1,
		endX = var2,
		endY = var3
	}

	table.insert(arg0.moveDatas, var4)
end

function var0.updateMoveGridDic(arg0)
	for iter0 = 1, #arg0.changeGridsDic do
		local var0 = arg0.changeGridsDic[iter0]

		for iter1 = 1, #var0 do
			local var1 = var0[iter1]

			if var1.grid then
				var1.grid:setPosData(var1.posX, var1.posY)
			end
		end
	end

	arg0:sortGridDic()
end

function var0.sortGridDic(arg0)
	local var0 = {}

	local function var1(arg0, arg1)
		for iter0 = 1, #var0 do
			local var0, var1 = var0[iter0]:getPosData()

			if var0 == arg0 and var1 == arg1 then
				return table.remove(var0, iter0)
			end
		end

		return nil
	end

	for iter0 = 1, #arg0.gridDic do
		for iter1 = 1, #arg0.gridDic[iter0] do
			local var2 = arg0.gridDic[iter0][iter1]
			local var3

			if var2 ~= iter0 or var3 ~= iter1 then
				table.insert(var0, arg0.gridDic[iter0][iter1])

				arg0.gridDic[iter0][iter1] = false
			end
		end
	end

	for iter2 = 1, #arg0.gridDic do
		for iter3 = 1, #arg0.gridDic[iter2] do
			if arg0.gridDic[iter2][iter3] == false then
				local var4 = var1(iter2, iter3)

				assert(var4 ~= nil, "异常，位置x:" .. iter2 .. "y:" .. iter3 .. "处珠子不存在，考虑是否在交换位置时设置了错误的格子数据")

				arg0.gridDic[iter2][iter3] = var4
			end
		end
	end
end

function var0.checkSuccessGrid(arg0)
	local var0

	arg0:updateRemoveFlag()

	arg0.gameTimeFlag = false

	local var1 = {}

	seriesAsync({
		function(arg0)
			for iter0 = 1, RollingBallConst.horizontal do
				for iter1 = 1, RollingBallConst.vertical do
					local var0 = arg0.gridDic[iter0][iter1]

					var0:setEventActive(false)

					if var0:getRemoveFlagV() or var0:getRemoveFlagH() then
						local var1 = var0:getRemoveId()
						local var2, var3 = var0:getPosData()

						if not var1[var1] then
							var1[var1] = {
								amount = 0,
								posList = {}
							}
						end

						var1[var1].amount = var1[var1].amount + 1

						table.insert(var1[var1].posList, {
							x = var2,
							y = var3
						})
						arg0:returnGrid(var0)

						arg0.gridDic[iter0][iter1] = false

						if not var0 then
							var0 = true
						end
					end
				end
			end

			arg0()
		end,
		function(arg0)
			if var0 then
				LeanTween.delayedCall(go(arg0.rollingUI), 0.7, System.Action(function()
					arg0()
				end))
				arg0:updateScore(var1)
				arg0:updateCombo()
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3)
			else
				arg0.comboAmount = 0

				arg0()
			end
		end,
		function(arg0)
			if not arg0.stopFlag then
				arg0:fallingGridDic()
				arg0:fillEmptyGrid()
				arg0:moveGridsBySelfPos(arg0.gridDic, nil)

				if var0 then
					arg0.checkSuccesFlag = true
				end
			end

			arg0()
		end
	}, function()
		arg0.gameTimeFlag = true
	end)
end

function var0.updateCombo(arg0)
	setActive(arg0.goodEffect, false)
	setActive(arg0.greatEffect, false)
	setActive(arg0.perfectEffect, false)

	if arg0.comboAmount == 2 then
		setActive(arg0.goodEffect, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4)
	elseif arg0.comboAmount == 3 then
		setActive(arg0.greatEffect, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4)
	elseif arg0.comboAmount >= 4 then
		setActive(arg0.perfectEffect, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5)
	end

	if arg0.comboAmount > 1 then
		if LeanTween.isTweening(go(arg0.caidaiTf)) then
			LeanTween.cancel(go(arg0.caidaiTf))
		end

		LeanTween.delayedCall(go(arg0.caidaiTf), 3, System.Action(function()
			setActive(arg0.caidaiTf, false)
		end))
		setActive(arg0.caidaiTf, true)
	end
end

function var0.updateScore(arg0, arg1)
	for iter0, iter1 in pairs(arg1) do
		arg0.comboAmount = arg0.comboAmount + 1
	end

	local var0 = 10 * arg0.comboAmount
	local var1 = 0

	for iter2, iter3 in pairs(arg1) do
		local var2
		local var3 = iter3.amount == 3 and 1 or iter3.amount == 4 and 1.5 or 2

		var1 = var1 + var0 * var3 * iter3.amount

		local var4 = var0 * var3

		for iter4 = 1, #iter3.posList do
			arg0:addGridScoreTip(iter3.posList[iter4], var4)
			arg0:addRemoveEffect(iter3.posList[iter4])
		end
	end

	LeanTween.delayedCall(go(arg0.labelGameScore), 0.7, System.Action(function()
		if LeanTween.isTweening(go(arg0.labelGameScore)) then
			LeanTween.cancel(go(arg0.labelGameScore))
		end

		local var0 = arg0.gameScore
		local var1 = arg0.gameScore + var1

		LeanTween.value(go(arg0.labelGameScore), var0, var1, 1.7):setOnUpdate(System.Action_float(function(arg0)
			setText(arg0.labelGameScore, math.floor(arg0))
		end)):setOnComplete(System.Action(function()
			setText(arg0.labelGameScore, var1)
		end))

		arg0.gameScore = var1

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6)
	end))
end

function var0.updateRemoveFlag(arg0)
	for iter0 = 1, RollingBallConst.horizontal do
		for iter1 = 1, RollingBallConst.vertical do
			local var0 = arg0.gridDic[iter0][iter1]

			arg0:checkGridRemove(var0, iter0, iter1)
		end
	end
end

function var0.checkGridRemove(arg0, arg1, arg2, arg3)
	if not arg1:getRemoveFlagH() and arg2 < RollingBallConst.horizontal - 1 then
		local var0 = 0
		local var1 = true
		local var2
		local var3 = {}

		for iter0 = arg2, RollingBallConst.horizontal do
			if arg1:getType() == arg0.gridDic[iter0][arg3]:getType() and var1 then
				var0 = var0 + 1

				table.insert(var3, arg0.gridDic[iter0][arg3])

				if arg0.gridDic[iter0][arg3]:getRemoveId() then
					var2 = arg0.gridDic[iter0][arg3]:getRemoveId()
				end
			else
				var1 = false
			end
		end

		if var0 and var0 >= 3 then
			var2 = var2 or arg0:getGridRemoveId()

			for iter1 = 1, #var3 do
				var3[iter1]:setRemoveFlagH(true, var2)
			end
		end
	end

	if not arg1:getRemoveFlagV() and arg3 < RollingBallConst.vertical - 1 then
		local var4 = 0
		local var5 = true
		local var6
		local var7 = {}

		for iter2 = arg3, RollingBallConst.vertical do
			if arg1:getType() == arg0.gridDic[arg2][iter2]:getType() and var5 then
				var4 = var4 + 1

				table.insert(var7, arg0.gridDic[arg2][iter2])

				if arg0.gridDic[arg2][iter2]:getRemoveId() then
					var6 = arg0.gridDic[arg2][iter2]:getRemoveId()
				end
			else
				var5 = false
			end
		end

		if var4 and var4 >= 3 then
			var6 = var6 or arg0:getGridRemoveId()

			for iter3 = 1, #var7 do
				var7[iter3]:setRemoveFlagV(true, var6)
			end
		end
	end
end

function var0.onGridDown(arg0, arg1)
	if arg0.isMoveing or arg0.selectGrid or #arg0.moveDatas > 0 then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2)

	arg0.selectGrid = arg1

	arg0.selectGrid:getTf():SetAsLastSibling()
end

function var0.onGridUp(arg0, arg1)
	arg0.selectGrid = nil

	if arg0.changeGridsDic then
		arg0:updateMoveGridDic()

		arg0.changeGridsDic = nil
	end

	arg0:clearDragAlpha()

	arg0.onBeginDragTime = nil

	arg0:moveGridsBySelfPos(arg0.gridDic, nil)

	arg0.checkSuccesFlag = true
	arg0.downTime = RollingBallConst.downTime
end

function var0.checkChangePos(arg0, arg1)
	local var0, var1 = arg1:getPosData()
	local var2, var3 = arg0.selectGrid:getPosData()

	if arg1 == arg0.selectGrid or var2 ~= var0 and var3 ~= var1 then
		arg0:moveGridsBySelfPos(arg0.gridDic, arg0.selectGrid)

		arg0.selectEnterGrid = nil
		arg0.changeGridsDic = nil
		arg0.changePosX, arg0.changePosY = nil
	else
		if arg0.changePosX == var0 and arg0.changePosY == var1 then
			return
		end

		arg0.changePosX, arg0.changePosY = var0, var1

		arg0:updateEnterGrid(arg0.changePosX, arg0.changePosY)
		arg0:moveGridsByChangeDic()
	end
end

function var0.onGridBeginDrag(arg0, arg1, arg2, arg3)
	if arg0.isMoveing or not arg0.selectGrid or arg1 ~= arg0.selectGrid then
		return
	end

	arg0.onBeginDragTime = Time.realtimeSinceStartup
	arg0.downTime = RollingBallConst.downTime

	local var0 = arg0.selectGrid:getTf()
	local var1, var2 = arg0.selectGrid:getPosData()
	local var3 = arg0.selectGrid:getType()

	arg0:setDragAlpha(var1, var2, var3)

	arg0.changePosX, arg0.changePosY = nil
	arg0.dragOffsetPos.x = arg3.position.x - var0.transform.localPosition.x
	arg0.dragOffsetPos.y = arg3.position.y - var0.transform.localPosition.y
end

function var0.onGridDrag(arg0, arg1, arg2, arg3)
	if not arg0.selectGrid or arg1 ~= arg0.selectGrid then
		return
	end

	if not arg0.uiCam then
		arg0.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	local var0 = arg0.uiCam:ScreenToWorldPoint(arg3.position)
	local var1 = arg0.rollingUI:InverseTransformPoint(var0)
	local var2 = var1.x - RollingBallConst.grid_width / 2
	local var3 = var1.y - RollingBallConst.grid_height / 2

	if var2 < 0 then
		var2 = 0
	end

	if var3 < 0 then
		var3 = 0
	end

	if var2 > (RollingBallConst.horizontal - 1) * RollingBallConst.grid_width then
		var2 = (RollingBallConst.horizontal - 1) * RollingBallConst.grid_width
	end

	if var3 > (RollingBallConst.vertical - 1) * RollingBallConst.grid_height then
		var3 = (RollingBallConst.vertical - 1) * RollingBallConst.grid_height
	end

	arg0.selectGrid:changePosition(var2, var3)

	local var4 = arg0:getGridByPosition(arg0.selectGrid:getPosition())

	if var4 and var4 ~= arg0.selectGrid then
		local var5, var6 = var4:getPosData()
		local var7, var8 = arg0.selectGrid:getPosData()
		local var9 = var5 - var7
		local var10 = var6 - var8

		if math.abs(var9) + math.abs(var10) == 1 then
			arg0:updateMove(var5, var6)
		elseif math.abs(var9) > math.abs(var10) then
			if var9 > 0 then
				var5 = var7 + 1
			end

			if var9 < 0 then
				var5 = var7 - 1
			end

			arg0:updateMove(var5, var8)
		else
			if var10 > 0 then
				var6 = var8 + 1
			end

			if var10 < 0 then
				var6 = var8 - 1
			end

			arg0:updateMove(var7, var6)
		end
	end
end

function var0.updateMove(arg0, arg1, arg2)
	if arg1 > RollingBallConst.horizontal or arg2 > RollingBallConst.vertical then
		return
	end

	arg0:changeDragGrid(arg1, arg2)
	arg0:updateMoveGridDic()

	arg0.changeGridsDic = nil

	arg0:moveGridsBySelfPos(arg0.gridDic, arg0.selectGrid)
	arg0:setDragAlpha(arg1, arg2, arg0.selectGrid:getType())
end

function var0.getGridByPosition(arg0, arg1)
	local var0 = math.floor((arg1.x + RollingBallConst.grid_width / 2) / RollingBallConst.grid_width) + 1
	local var1 = math.floor((arg1.y + RollingBallConst.grid_height / 2) / RollingBallConst.grid_height) + 1

	if var0 >= 1 and var0 <= RollingBallConst.horizontal and var1 >= 1 and var1 <= RollingBallConst.vertical then
		return arg0.gridDic[var0][var1]
	end

	return nil
end

function var0.updateEnterGrid(arg0, arg1, arg2)
	local var0, var1 = arg0.selectGrid:getPosData()

	arg0.changeGridsDic = {}

	for iter0 = 1, #arg0.gridDic do
		arg0.changeGridsDic[iter0] = {}

		for iter1 = 1, #arg0.gridDic[iter0] do
			if iter0 ~= var0 and iter1 ~= var1 then
				table.insert(arg0.changeGridsDic[iter0], {
					grid = arg0.gridDic[iter0][iter1],
					posX = iter0,
					posY = iter1
				})
			elseif iter0 == var0 and iter1 == var1 then
				table.insert(arg0.changeGridsDic[iter0], {
					grid = arg0.gridDic[iter0][iter1],
					posX = arg1,
					posY = arg2
				})
			elseif iter0 == var0 then
				if var1 < iter1 and iter1 <= arg2 then
					table.insert(arg0.changeGridsDic[iter0], {
						grid = arg0.gridDic[iter0][iter1],
						posX = iter0,
						posY = iter1 - 1
					})
				elseif iter1 < var1 and arg2 <= iter1 then
					table.insert(arg0.changeGridsDic[iter0], {
						grid = arg0.gridDic[iter0][iter1],
						posX = iter0,
						posY = iter1 + 1
					})
				else
					table.insert(arg0.changeGridsDic[iter0], {
						grid = arg0.gridDic[iter0][iter1],
						posX = iter0,
						posY = iter1
					})
				end
			elseif iter1 == var1 then
				if var0 < iter0 and iter0 <= arg1 then
					table.insert(arg0.changeGridsDic[iter0], {
						grid = arg0.gridDic[iter0][iter1],
						posX = iter0 - 1,
						posY = iter1
					})
				elseif iter0 < var0 and arg1 <= iter0 then
					table.insert(arg0.changeGridsDic[iter0], {
						grid = arg0.gridDic[iter0][iter1],
						posX = iter0 + 1,
						posY = iter1
					})
				else
					table.insert(arg0.changeGridsDic[iter0], {
						grid = arg0.gridDic[iter0][iter1],
						posX = iter0,
						posY = iter1
					})
				end
			end
		end
	end
end

function var0.changeDragGrid(arg0, arg1, arg2)
	local var0, var1 = arg0.selectGrid:getPosData()

	arg0.changeGridsDic = {}

	for iter0 = 1, #arg0.gridDic do
		arg0.changeGridsDic[iter0] = {}

		for iter1 = 1, #arg0.gridDic[iter0] do
			if iter0 == arg1 and iter1 == arg2 then
				table.insert(arg0.changeGridsDic[iter0], {
					grid = arg0.gridDic[iter0][iter1],
					posX = var0,
					posY = var1
				})
			elseif iter0 == var0 and iter1 == var1 then
				table.insert(arg0.changeGridsDic[iter0], {
					grid = arg0.gridDic[iter0][iter1],
					posX = arg1,
					posY = arg2
				})
			else
				table.insert(arg0.changeGridsDic[iter0], {
					grid = arg0.gridDic[iter0][iter1],
					posX = iter0,
					posY = iter1
				})
			end
		end
	end
end

function var0.createGrid(arg0, arg1, arg2, arg3)
	local var0
	local var1 = #arg0.gridsPool

	if #arg0.gridsPool > 0 then
		var0 = table.remove(arg0.gridsPool, 1)
	else
		var0 = RollingBallGrid.New(tf(Instantiate(arg0.tplGrid)))

		var0:addDownCallback(function(arg0, arg1)
			arg0:onGridDown(var0)
		end)
		var0:addUpCallback(function(arg0, arg1)
			arg0:onGridUp(var0)
		end)
		var0:addBeginDragCallback(function(arg0, arg1)
			arg0:onGridBeginDrag(var0, arg0, arg1)
		end)
		var0:addDragCallback(function(arg0, arg1)
			arg0:onGridDrag(var0, arg0, arg1)
		end)
		setActive(var0:getTf(), true)
	end

	var0:setParent(arg0.rollingUI)
	var0:setType(arg1)
	var0:setPosData(arg2, arg3)

	return var0
end

function var0.setDragAlpha(arg0, arg1, arg2, arg3)
	local var0 = (arg1 - 1) * RollingBallConst.grid_width
	local var1 = (arg2 - 1) * RollingBallConst.grid_height

	arg0.dragAlphaGrid:setPosition(var0, var1)
	arg0.dragAlphaGrid:setType(arg3)
	setActive(arg0.dragAlphaGrid:getTf(), true)
end

function var0.clearDragAlpha(arg0)
	setActive(arg0.dragAlphaGrid:getTf(), false)
end

function var0.returnGrid(arg0, arg1)
	arg0:removeGrid(arg1)
	arg1:clearData()
	arg1:setParent(arg0.gridPoolTf)
	arg1:setEventActive(false)
	table.insert(arg0.gridsPool, arg1)
end

function var0.removeGrid(arg0, arg1)
	local var0, var1 = arg1:getPosData()

	if not arg0.gridDic[var0][var1] then
		arg0.gridDic[var0][var1] = false
	end
end

function var0.getRandomType(arg0, arg1)
	if arg1 then
		local var0 = {}

		for iter0 = 1, RollingBallConst.grid_type_amount do
			if not table.contains(arg1, iter0) then
				table.insert(var0, iter0)
			end
		end

		return var0[math.random(1, #var0)]
	end

	return math.random(1, RollingBallConst.grid_type_amount)
end

function var0.addGridScoreTip(arg0, arg1, arg2)
	local var0 = arg1.x
	local var1 = arg1.y
	local var2 = arg0:getScoreTip()
	local var3 = (var0 - 1) * RollingBallConst.grid_width
	local var4 = (var1 - 1) * RollingBallConst.grid_height

	var2.localPosition = Vector3(var3, var4, 0)

	setText(findTF(var2, "text"), "+" .. arg2)
	LeanTween.moveLocalY(go(var2), var4 + 30, 0.5):setOnComplete(System.Action(function()
		arg0:returnScoreTip(var2)
	end))
end

function var0.addRemoveEffect(arg0, arg1)
	local var0 = arg1.x
	local var1 = arg1.y
	local var2 = arg0:getRemoveEffect()
	local var3 = (var0 - 1) * RollingBallConst.grid_width
	local var4 = (var1 - 1) * RollingBallConst.grid_height

	var2.localPosition = Vector3(var3 + 50, var4 + 50, -350)

	LeanTween.delayedCall(go(var2), 0.7, System.Action(function()
		arg0:returnRemoveEffect(var2)
	end))
end

function var0.getRemoveEffect(arg0)
	if not arg0.removeEffectPool then
		arg0.removeEffectPool = {}
		arg0.removeEffects = {}
	end

	local var0

	if #arg0.removeEffectPool > 1 then
		var0 = table.remove(arg0.removeEffectPool, #arg0.removeEffectPool)
	else
		var0 = tf(Instantiate(arg0.tplRemoveEffect))

		setParent(var0, arg0.rollingEffectUI, false)
		table.insert(arg0.removeEffects, var0)
	end

	setActive(var0, true)

	return var0
end

function var0.returnRemoveEffect(arg0, arg1)
	setActive(arg1, false)
	table.insert(arg0.removeEffectPool, arg1)
end

function var0.getScoreTip(arg0)
	if not arg0.scoreTipPool then
		arg0.scoreTipPool = {}
		arg0.scoreTips = {}
	end

	local var0

	if #arg0.scoreTipPool > 1 then
		var0 = table.remove(arg0.scoreTipPool, #arg0.scoreTipPool)
	else
		var0 = tf(Instantiate(arg0.tplScoreTip))

		setParent(var0, arg0.rollingEffectUI, false)
		table.insert(arg0.scoreTips, var0)
	end

	setActive(var0, true)

	return var0
end

function var0.returnScoreTip(arg0, arg1)
	setActive(arg1, false)
	table.insert(arg0.scoreTipPool, arg1)
end

function var0.addEffect(arg0, arg1)
	local var0 = arg0.effectUI:InverseTransformPoint(arg1)
	local var1 = arg0:getEffect()

	setParent(var1, arg0.effectUI, false)
	setActive(var1, true)

	var1.localPosition = var0

	table.insert(arg0.effectDatas, {
		vy = 2,
		ay = 0,
		vx = 2,
		ax = 0,
		tf = var1
	})
end

function var0.clearUI(arg0)
	arg0.moveDatas = {}
	arg0.startFlag = false
	arg0.stopFlag = false

	setText(arg0.labelGameScore, "0000")
	setText(arg0.labelGameTime, "")
	setActive(arg0.endLess, true)

	arg0.downTimeSlider.value = 1

	setActive(arg0.closeUI, false)
	setActive(arg0.overLight, false)
	arg0:clearDragAlpha()

	for iter0 = #arg0.effectDatas, 1, -1 do
		local var0 = arg0.effectDatas[iter0].tf

		arg0:returnEffect(var0)
		table.remove(arg0.effectDatas, iter0)
	end

	for iter1 = 1, RollingBallConst.horizontal do
		for iter2 = 1, RollingBallConst.vertical do
			if arg0.gridDic[iter1][iter2] then
				arg0:returnGrid(arg0.gridDic[iter1][iter2])

				arg0.gridDic[iter1][iter2] = false
			end
		end
	end
end

function var0.getEffect(arg0)
	if #arg0.effectPool > 0 then
		return table.remove(arg0.effectPool, #arg0.effectPool)
	end

	return (tf(Instantiate(arg0.tplEffect)))
end

function var0.returnEffect(arg0, arg1)
	SetParent(arg1, arg0.effectPoolTf, false)
	table.insert(arg0.effectPool, arg1)
end

function var0.getGridRemoveId(arg0)
	if not arg0.removeId then
		arg0.removeId = 0
	end

	arg0.removeId = arg0.removeId + 1

	return tostring(arg0.removeId)
end

function var0.onBackPressed(arg0)
	if not arg0.startFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	end
end

function var0.willExit(arg0)
	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	if LeanTween.isTweening(go(arg0.caidaiTf)) then
		LeanTween.cancel(go(arg0.caidaiTf))
	end

	if LeanTween.isTweening(go(arg0.labelGameScore)) then
		LeanTween.cancel(go(arg0.labelGameScore))
	end

	if LeanTween.isTweening(go(arg0.rollingUI)) then
		LeanTween.cancel(go(arg0.rollingUI))
	end

	if arg0.scoreTips then
		for iter0 = 1, #arg0.scoreTips do
			if LeanTween.isTweening(go(arg0.scoreTips[iter0])) then
				LeanTween.cancel(go(arg0.scoreTips[iter0]))
			end
		end
	end

	if arg0.removeEffects then
		for iter1 = 1, #arg0.removeEffects do
			if LeanTween.isTweening(go(arg0.removeEffects[iter1])) then
				LeanTween.cancel(go(arg0.removeEffects[iter1]))
			end
		end
	end

	arg0.timer = nil
end

return var0
