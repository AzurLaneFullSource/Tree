local var0_0 = class("RollingBallGameView", import("..BaseMiniGameView"))
local var1_0 = "event:/ui/ddldaoshu2"
local var2_0 = "event:/ui/boat_drag"
local var3_0 = "event:/ui/break_out_full"
local var4_0 = "event:/ui/sx-good"
local var5_0 = "event:/ui/sx-perfect"
local var6_0 = "event:/ui/sx-jishu"
local var7_0 = "event:/ui/furnitrue_save"

function var0_0.getUIName(arg0_1)
	return "RollingBallGameUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2:GetMGData()
	local var1_2 = arg0_2:GetMGHubData()

	arg0_2.tplScoreTip = findTF(arg0_2._tf, "tplScoreTip")
	arg0_2.tplRemoveEffect = findTF(arg0_2._tf, "sanxiaoxiaoshi")
	arg0_2.effectUI = findTF(arg0_2._tf, "effectUI")
	arg0_2.tplEffect = findTF(arg0_2._tf, "tplEffect")
	arg0_2.effectPoolTf = findTF(arg0_2._tf, "effectPool")
	arg0_2.effectPool = {}
	arg0_2.effectDatas = {}
	arg0_2.effectTargetPosition = findTF(arg0_2.effectUI, "effectTargetPos").localPosition
	arg0_2.rollingUI = findTF(arg0_2._tf, "rollingUI")
	arg0_2.rollingEffectUI = findTF(arg0_2._tf, "rollingEffectUI")
	arg0_2.tplGrid = findTF(arg0_2._tf, "tplRollingGrid")
	arg0_2.gridPoolTf = findTF(arg0_2._tf, "gridPool")
	arg0_2.gridsPool = {}
	arg0_2.gridDic = {}
	arg0_2.fillGridDic = {}
	arg0_2.startFlag = false

	local var2_2 = findTF(arg0_2.rollingUI, "dragAlphaGrid")

	arg0_2.dragAlphaGrid = RollingBallGrid.New(var2_2)

	setActive(arg0_2.dragAlphaGrid:getTf(), false)

	arg0_2.timer = Timer.New(function()
		arg0_2:onTimer()
	end, 0.0166666666666667, -1)

	for iter0_2 = 1, RollingBallConst.horizontal do
		arg0_2.gridDic[iter0_2] = {}
		arg0_2.fillGridDic[iter0_2] = {}

		for iter1_2 = 1, RollingBallConst.vertical do
			table.insert(arg0_2.gridDic[iter0_2], false)
		end
	end

	arg0_2.goodEffect = arg0_2:findTF("sanxiaoGood")
	arg0_2.greatEffect = arg0_2:findTF("sanxiaoGreat")
	arg0_2.perfectEffect = arg0_2:findTF("sanxiaoPerfect")
	arg0_2.caidaiTf = findTF(arg0_2._tf, "zhuanzhu_caidai")

	setActive(arg0_2.caidaiTf, false)

	arg0_2.startUI = findTF(arg0_2._tf, "startUI")

	onButton(arg0_2, findTF(arg0_2.startUI, "btnStart"), function()
		if not arg0_2.startFlag then
			setActive(arg0_2.startUI, false)
			arg0_2:gameStart()
		end
	end, SFX_CONFIRM)
	onButton(arg0_2, findTF(arg0_2.startUI, "btnRule"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_rollingBallGame.tip
		})
	end, SFX_CONFIRM)
	setActive(arg0_2.startUI, true)

	arg0_2.scoreUI = findTF(arg0_2._tf, "scoreUI")
	arg0_2.labelCurScore = findTF(arg0_2.scoreUI, "labelCur")
	arg0_2.labelHigh = findTF(arg0_2.scoreUI, "labelHigh")
	arg0_2.scoreNew = findTF(arg0_2.scoreUI, "new")

	onButton(arg0_2, findTF(arg0_2.scoreUI, "btnEnd"), function()
		setActive(arg0_2.scoreUI, false)
		setActive(arg0_2.startUI, true)
	end, SFX_CANCEL)
	setActive(arg0_2.scoreUI, false)

	arg0_2.downProgress = findTF(arg0_2._tf, "downProgress")
	arg0_2.downTimeSlider = findTF(arg0_2.downProgress, "Slider"):GetComponent(typeof(Slider))
	arg0_2.labelGameTime = findTF(arg0_2._tf, "labelGameTime")
	arg0_2.labelGameScore = findTF(arg0_2._tf, "labelGameScore")
	arg0_2.endLess = findTF(arg0_2._tf, "endLess")

	setActive(arg0_2.endLess, true)

	arg0_2.closeUI = findTF(arg0_2._tf, "closeUI")

	setActive(arg0_2.closeUI, false)
	onButton(arg0_2, findTF(arg0_2.closeUI, "btnOk"), function()
		if not arg0_2.countStart then
			arg0_2:closeView()
		end
	end, SFX_CONFIRM)
	onButton(arg0_2, findTF(arg0_2.closeUI, "btnCancel"), function()
		setActive(arg0_2.closeUI, false)
	end, SFX_CANCEL)

	arg0_2.overLight = findTF(arg0_2._tf, "overLight")

	setActive(arg0_2.overLight, false)
	onButton(arg0_2, findTF(arg0_2._tf, "btnClose"), function()
		if not arg0_2.startFlag then
			arg0_2:closeView()
		else
			setActive(arg0_2.closeUI, true)
		end
	end, SFX_CANCEL)
end

function var0_0.getGameTimes(arg0_10)
	return arg0_10:GetMGHubData().count
end

function var0_0.showScoreUI(arg0_11, arg1_11)
	local var0_11 = arg0_11:GetMGData():GetRuntimeData("elements")
	local var1_11 = var0_11 and #var0_11 > 0 and var0_11[1] or 0

	if var1_11 < arg1_11 then
		setActive(arg0_11.scoreNew, true)
	else
		setActive(arg0_11.scoreNew, false)
	end

	var1_11 = arg1_11 < var1_11 and var1_11 or arg1_11

	setActive(arg0_11.scoreUI, true)
	setText(arg0_11.labelCurScore, arg1_11)
	setText(arg0_11.labelHigh, var1_11)
	arg0_11:StoreDataToServer({
		var1_11
	})

	if arg0_11:getGameTimes() > 0 then
		arg0_11:SendSuccess(0)
	end
end

function var0_0.showCountStart(arg0_12, arg1_12)
	local var0_12 = findTF(arg0_12._tf, "count")

	setActive(var0_12, true)

	arg0_12.countIndex = 3
	arg0_12.countStart = true

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0)

	local function var1_12(arg0_13)
		local var0_13 = arg0_12.countIndex

		arg0_12.countIndex = arg0_12.countIndex - 1

		local var1_13 = findTF(var0_12, "show")
		local var2_13 = GetComponent(var1_13, typeof(CanvasGroup))

		seriesAsync({
			function(arg0_14)
				GetSpriteFromAtlasAsync("ui/rollingBallGame_atlas", "count_" .. var0_13, function(arg0_15)
					setImageSprite(var1_13, arg0_15, true)
				end)
				LeanTween.value(go(var1_13), 0, 1, 0.5):setOnUpdate(System.Action_float(function(arg0_16)
					var2_13.alpha = arg0_16
				end)):setOnComplete(System.Action(function()
					arg0_14()
				end))
			end,
			function(arg0_18)
				LeanTween.value(go(var1_13), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_19)
					var2_13.alpha = arg0_19
				end)):setOnComplete(System.Action(function()
					arg0_18()
				end))
			end
		}, arg0_13)
	end

	local var2_12 = {}

	for iter0_12 = 1, 3 do
		table.insert(var2_12, var1_12)
	end

	seriesAsync(var2_12, function()
		arg0_12.countStart = false

		setActive(var0_12, false)
		arg1_12()
	end)
end

function var0_0.gameStart(arg0_22)
	arg0_22.startFlag = true

	seriesAsync({
		function(arg0_23)
			arg0_22:showCountStart(arg0_23)
		end,
		function(arg0_24)
			arg0_22.moveDatas = {}
			arg0_22.selectGrid = nil
			arg0_22.selectEnterGrid = nil
			arg0_22.dragOffsetPos = Vector3(0, 0, 0)
			arg0_22.changeGridsDic = nil
			arg0_22.downTime = RollingBallConst.downTime
			arg0_22.comboAmount = 0
			arg0_22.stopFlag = false
			arg0_22.onBeginDragTime = nil

			if arg0_22:getGameTimes() > 0 then
				arg0_22.gameTime = RollingBallConst.gameTime
			else
				arg0_22.gameTime = RollingBallConst.finishGameTime
			end

			arg0_22.gameTimeReal = Time.realtimeSinceStartup
			arg0_22.gameTimeFlag = true

			setActive(arg0_22.endLess, false)

			arg0_22.gameScore = 0

			arg0_22:firstInitGrid()
			arg0_22:moveGridsBySelfPos(arg0_22.gridDic)
			arg0_22:timerStart()
		end
	}, nil)
end

function var0_0.gameStop(arg0_25)
	arg0_25:timerStop()
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var7_0)

	for iter0_25 = #arg0_25.effectDatas, 1, -1 do
		arg0_25:returnEffect(arg0_25.effectDatas[iter0_25].tf)
		table.remove(arg0_25.effectDatas, iter0_25)
	end

	for iter1_25 = 1, RollingBallConst.horizontal do
		for iter2_25 = 1, RollingBallConst.vertical do
			if arg0_25.gridDic[iter1_25][iter2_25] then
				arg0_25.gridDic[iter1_25][iter2_25]:setEventActive(false)
			end
		end
	end

	arg0_25:clearUI()
	arg0_25:showScoreUI(arg0_25.gameScore)
end

function var0_0.timerStart(arg0_26)
	if not arg0_26.timer.running then
		arg0_26.timer:Start()
	end
end

function var0_0.timerStop(arg0_27)
	if arg0_27.timer.running then
		arg0_27.timer:Stop()
	end
end

function var0_0.fallingGridDic(arg0_28)
	local function var0_28(arg0_29, arg1_29)
		for iter0_29 = arg1_29 + 1, RollingBallConst.vertical do
			if arg0_28.gridDic[arg0_29][iter0_29] then
				return iter0_29
			end
		end

		return 0
	end

	for iter0_28 = 1, RollingBallConst.horizontal do
		for iter1_28 = 1, RollingBallConst.vertical do
			if not arg0_28.gridDic[iter0_28][iter1_28] and RollingBallConst.vertical - iter1_28 > 0 then
				local var1_28 = var0_28(iter0_28, iter1_28)

				if var1_28 > 0 then
					local var2_28 = arg0_28.gridDic[iter0_28][var1_28]

					arg0_28.gridDic[iter0_28][var1_28] = false
					arg0_28.gridDic[iter0_28][iter1_28] = var2_28

					arg0_28.gridDic[iter0_28][iter1_28]:setPosData(iter0_28, iter1_28)
				end
			end
		end
	end
end

function var0_0.firstInitGrid(arg0_30)
	for iter0_30 = 1, RollingBallConst.horizontal do
		arg0_30.fillGridDic[iter0_30] = {}

		for iter1_30 = 1, RollingBallConst.vertical do
			if not arg0_30.gridDic[iter0_30][iter1_30] then
				local var0_30 = {}

				if iter0_30 > 2 and arg0_30.gridDic[iter0_30 - 2][iter1_30]:getType() == arg0_30.gridDic[iter0_30 - 1][iter1_30]:getType() then
					table.insert(var0_30, arg0_30.gridDic[iter0_30 - 2][iter1_30]:getType())
				end

				if iter1_30 > 2 and arg0_30.gridDic[iter0_30][iter1_30 - 2]:getType() == arg0_30.gridDic[iter0_30][iter1_30 - 1]:getType() then
					table.insert(var0_30, arg0_30.gridDic[iter0_30][iter1_30 - 2]:getType())
				end

				local var1_30 = arg0_30:createGrid(arg0_30:getRandomType(var0_30), iter0_30, iter1_30)

				arg0_30.gridDic[iter0_30][iter1_30] = var1_30

				arg0_30:setFillGridPosition(var1_30, iter0_30, #arg0_30.fillGridDic[iter0_30])
				table.insert(arg0_30.fillGridDic[iter0_30], var1_30)
			end
		end
	end
end

function var0_0.fillEmptyGrid(arg0_31)
	for iter0_31 = 1, RollingBallConst.horizontal do
		arg0_31.fillGridDic[iter0_31] = {}

		for iter1_31 = 1, RollingBallConst.vertical do
			if not arg0_31.gridDic[iter0_31][iter1_31] then
				local var0_31 = arg0_31:createGrid(arg0_31:getRandomType(), iter0_31, iter1_31)

				arg0_31.gridDic[iter0_31][iter1_31] = var0_31

				arg0_31:setFillGridPosition(var0_31, iter0_31, #arg0_31.fillGridDic[iter0_31])
				table.insert(arg0_31.fillGridDic[iter0_31], var0_31)
			end
		end
	end
end

function var0_0.setFillGridPosition(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = (arg2_32 - 1) * RollingBallConst.grid_width
	local var1_32 = (RollingBallConst.vertical + arg3_32) * RollingBallConst.grid_height

	arg1_32:setPosition(var0_32, var1_32)
end

function var0_0.onTimer(arg0_33)
	for iter0_33 = #arg0_33.moveDatas, 1, -1 do
		local var0_33 = arg0_33.moveDatas[iter0_33]
		local var1_33 = var0_33.grid
		local var2_33 = var1_33:getPosition().x
		local var3_33 = var1_33:getPosition().y
		local var4_33 = var0_33.endX
		local var5_33 = var0_33.endY

		if var2_33 == var4_33 and var3_33 == var5_33 then
			var1_33:setEventActive(true)
			table.remove(arg0_33.moveDatas, iter0_33)
		else
			local var6_33
			local var7_33

			if math.abs(var4_33 - var2_33) < RollingBallConst.moveSpeed or var4_33 == var2_33 then
				var6_33 = var4_33 - var2_33
			elseif var2_33 < var4_33 then
				var6_33 = RollingBallConst.moveSpeed
			elseif var4_33 < var2_33 then
				var6_33 = -RollingBallConst.moveSpeed
			end

			if math.abs(var5_33 - var3_33) < RollingBallConst.moveSpeed or var3_33 == var5_33 then
				var7_33 = 0
				var3_33 = var5_33
			elseif var3_33 < var5_33 then
				var7_33 = RollingBallConst.moveSpeed
			elseif var5_33 < var3_33 then
				var7_33 = -RollingBallConst.moveSpeed
			end

			var1_33:setPosition(var2_33 + var6_33, var3_33 + var7_33)
		end
	end

	for iter1_33 = #arg0_33.effectDatas, 1, -1 do
		local var8_33 = arg0_33.effectDatas[iter1_33]
		local var9_33 = var8_33.tf.localPosition

		var8_33.ax = (arg0_33.effectTargetPosition.x - var9_33.x) * 0.002
		var8_33.ay = (arg0_33.effectTargetPosition.y - var9_33.y) * 0.002
		var8_33.vx = var8_33.vx + var8_33.ax
		var8_33.vy = var8_33.vy + var8_33.ay
		var9_33.x = var9_33.x + var8_33.vx
		var9_33.y = var9_33.y + var8_33.vy
		var8_33.tf.localPosition = var9_33

		if var9_33.x < arg0_33.effectTargetPosition.x then
			arg0_33:returnEffect(var8_33.tf)
			table.remove(arg0_33.effectDatas, iter1_33)
		end
	end

	if arg0_33.onBeginDragTime and arg0_33.downTime > 0 then
		local var10_33 = (Time.realtimeSinceStartup - arg0_33.onBeginDragTime) * 1000

		arg0_33.downTime = arg0_33.downTime - var10_33
		arg0_33.onBeginDragTime = Time.realtimeSinceStartup

		if arg0_33.downTime <= 0 then
			arg0_33.downTime = 0

			if arg0_33.selectGrid then
				local var11_33 = arg0_33.selectGrid

				var11_33:onEndDrag()
				arg0_33:onGridUp(var11_33)
				var11_33:addUpCallback(function(arg0_34, arg1_34)
					arg0_33:onGridUp(var11_33)
				end)
				var11_33:addDragCallback(function(arg0_35, arg1_35)
					arg0_33:onGridDrag(var11_33, arg0_35, arg1_35)
				end)
			end
		end
	end

	arg0_33.downTimeSlider.value = arg0_33.downTime / RollingBallConst.downTime

	if arg0_33.gameTimeFlag and arg0_33.gameTime > 0 and not isActive(arg0_33.closeUI) then
		local var12_33 = (Time.realtimeSinceStartup - arg0_33.gameTimeReal) * 1000

		arg0_33.gameTime = arg0_33.gameTime - var12_33

		if arg0_33.gameTime > 0 and arg0_33.gameTime <= 8000 and not isActive(arg0_33.overLight) then
			setActive(arg0_33.overLight, true)
		end

		if arg0_33.gameTime <= 0 then
			arg0_33.gameTime = 0

			setActive(arg0_33.overLight, false)

			arg0_33.stopFlag = true
		end
	end

	arg0_33.gameTimeReal = Time.realtimeSinceStartup

	local var13_33 = math.floor(arg0_33.gameTime / 60000)

	var13_33 = var13_33 < 10 and "0" .. var13_33 or var13_33

	local var14_33 = math.floor(arg0_33.gameTime % 60000 / 1000)

	var14_33 = var14_33 < 10 and "0" .. var14_33 or var14_33

	local var15_33 = math.floor(math.floor(arg0_33.gameTime % 1000) / 10)

	var15_33 = var15_33 < 10 and "0" .. var15_33 or var15_33

	setText(arg0_33.labelGameTime, var13_33 .. ":" .. var14_33 .. ":" .. var15_33)

	if #arg0_33.moveDatas == 0 then
		if arg0_33.stopFlag then
			arg0_33:gameStop()

			return
		end

		if arg0_33.checkSuccesFlag then
			arg0_33.checkSuccesFlag = false

			arg0_33:checkSuccessGrid()
		end

		if arg0_33.isMoveing then
			arg0_33.isMoveing = false
		end
	elseif not arg0_33.isMoveing then
		arg0_33.isMoveing = true
	end
end

function var0_0.moveGridsByChangeDic(arg0_36)
	arg0_36.moveDatas = {}

	for iter0_36 = 1, #arg0_36.changeGridsDic do
		local var0_36 = arg0_36.changeGridsDic[iter0_36]

		for iter1_36 = 1, #var0_36 do
			local var1_36 = var0_36[iter1_36]

			if var1_36.grid ~= arg0_36.selectGrid then
				arg0_36:moveGridToPos(var1_36.grid, var1_36.posX, var1_36.posY)
			end
		end
	end

	if #arg0_36.moveDatas > 0 then
		arg0_36:timerStart()
	end
end

function var0_0.moveGridsBySelfPos(arg0_37, arg1_37, arg2_37)
	arg0_37.moveDatas = {}

	for iter0_37 = 1, #arg1_37 do
		for iter1_37 = 1, #arg1_37[iter0_37] do
			local var0_37 = arg1_37[iter0_37][iter1_37]

			if var0_37 and var0_37 ~= arg2_37 then
				arg0_37:moveGridToPos(var0_37, var0_37:getPosData())
			end
		end
	end

	if #arg0_37.moveDatas > 0 then
		arg0_37:timerStart()
	end
end

function var0_0.moveGridToPos(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = arg1_38:getPosition().x
	local var1_38 = arg1_38:getPosition().y
	local var2_38 = (arg2_38 - 1) * RollingBallConst.grid_width
	local var3_38 = (arg3_38 - 1) * RollingBallConst.grid_height

	if math.floor(var2_38) == math.floor(arg2_38) and math.floor(var3_38) == math.floor(arg3_38) then
		return
	end

	arg1_38:setEventActive(false)

	local var4_38 = {
		grid = arg1_38,
		endX = var2_38,
		endY = var3_38
	}

	table.insert(arg0_38.moveDatas, var4_38)
end

function var0_0.updateMoveGridDic(arg0_39)
	for iter0_39 = 1, #arg0_39.changeGridsDic do
		local var0_39 = arg0_39.changeGridsDic[iter0_39]

		for iter1_39 = 1, #var0_39 do
			local var1_39 = var0_39[iter1_39]

			if var1_39.grid then
				var1_39.grid:setPosData(var1_39.posX, var1_39.posY)
			end
		end
	end

	arg0_39:sortGridDic()
end

function var0_0.sortGridDic(arg0_40)
	local var0_40 = {}

	local function var1_40(arg0_41, arg1_41)
		for iter0_41 = 1, #var0_40 do
			local var0_41, var1_41 = var0_40[iter0_41]:getPosData()

			if var0_41 == arg0_41 and var1_41 == arg1_41 then
				return table.remove(var0_40, iter0_41)
			end
		end

		return nil
	end

	for iter0_40 = 1, #arg0_40.gridDic do
		for iter1_40 = 1, #arg0_40.gridDic[iter0_40] do
			local var2_40 = arg0_40.gridDic[iter0_40][iter1_40]
			local var3_40

			if var2_40 ~= iter0_40 or var3_40 ~= iter1_40 then
				table.insert(var0_40, arg0_40.gridDic[iter0_40][iter1_40])

				arg0_40.gridDic[iter0_40][iter1_40] = false
			end
		end
	end

	for iter2_40 = 1, #arg0_40.gridDic do
		for iter3_40 = 1, #arg0_40.gridDic[iter2_40] do
			if arg0_40.gridDic[iter2_40][iter3_40] == false then
				local var4_40 = var1_40(iter2_40, iter3_40)

				assert(var4_40 ~= nil, "异常，位置x:" .. iter2_40 .. "y:" .. iter3_40 .. "处珠子不存在，考虑是否在交换位置时设置了错误的格子数据")

				arg0_40.gridDic[iter2_40][iter3_40] = var4_40
			end
		end
	end
end

function var0_0.checkSuccessGrid(arg0_42)
	local var0_42

	arg0_42:updateRemoveFlag()

	arg0_42.gameTimeFlag = false

	local var1_42 = {}

	seriesAsync({
		function(arg0_43)
			for iter0_43 = 1, RollingBallConst.horizontal do
				for iter1_43 = 1, RollingBallConst.vertical do
					local var0_43 = arg0_42.gridDic[iter0_43][iter1_43]

					var0_43:setEventActive(false)

					if var0_43:getRemoveFlagV() or var0_43:getRemoveFlagH() then
						local var1_43 = var0_43:getRemoveId()
						local var2_43, var3_43 = var0_43:getPosData()

						if not var1_42[var1_43] then
							var1_42[var1_43] = {
								amount = 0,
								posList = {}
							}
						end

						var1_42[var1_43].amount = var1_42[var1_43].amount + 1

						table.insert(var1_42[var1_43].posList, {
							x = var2_43,
							y = var3_43
						})
						arg0_42:returnGrid(var0_43)

						arg0_42.gridDic[iter0_43][iter1_43] = false

						if not var0_42 then
							var0_42 = true
						end
					end
				end
			end

			arg0_43()
		end,
		function(arg0_44)
			if var0_42 then
				LeanTween.delayedCall(go(arg0_42.rollingUI), 0.7, System.Action(function()
					arg0_44()
				end))
				arg0_42:updateScore(var1_42)
				arg0_42:updateCombo()
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_0)
			else
				arg0_42.comboAmount = 0

				arg0_44()
			end
		end,
		function(arg0_46)
			if not arg0_42.stopFlag then
				arg0_42:fallingGridDic()
				arg0_42:fillEmptyGrid()
				arg0_42:moveGridsBySelfPos(arg0_42.gridDic, nil)

				if var0_42 then
					arg0_42.checkSuccesFlag = true
				end
			end

			arg0_46()
		end
	}, function()
		arg0_42.gameTimeFlag = true
	end)
end

function var0_0.updateCombo(arg0_48)
	setActive(arg0_48.goodEffect, false)
	setActive(arg0_48.greatEffect, false)
	setActive(arg0_48.perfectEffect, false)

	if arg0_48.comboAmount == 2 then
		setActive(arg0_48.goodEffect, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4_0)
	elseif arg0_48.comboAmount == 3 then
		setActive(arg0_48.greatEffect, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4_0)
	elseif arg0_48.comboAmount >= 4 then
		setActive(arg0_48.perfectEffect, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_0)
	end

	if arg0_48.comboAmount > 1 then
		if LeanTween.isTweening(go(arg0_48.caidaiTf)) then
			LeanTween.cancel(go(arg0_48.caidaiTf))
		end

		LeanTween.delayedCall(go(arg0_48.caidaiTf), 3, System.Action(function()
			setActive(arg0_48.caidaiTf, false)
		end))
		setActive(arg0_48.caidaiTf, true)
	end
end

function var0_0.updateScore(arg0_50, arg1_50)
	for iter0_50, iter1_50 in pairs(arg1_50) do
		arg0_50.comboAmount = arg0_50.comboAmount + 1
	end

	local var0_50 = 10 * arg0_50.comboAmount
	local var1_50 = 0

	for iter2_50, iter3_50 in pairs(arg1_50) do
		local var2_50
		local var3_50 = iter3_50.amount == 3 and 1 or iter3_50.amount == 4 and 1.5 or 2

		var1_50 = var1_50 + var0_50 * var3_50 * iter3_50.amount

		local var4_50 = var0_50 * var3_50

		for iter4_50 = 1, #iter3_50.posList do
			arg0_50:addGridScoreTip(iter3_50.posList[iter4_50], var4_50)
			arg0_50:addRemoveEffect(iter3_50.posList[iter4_50])
		end
	end

	LeanTween.delayedCall(go(arg0_50.labelGameScore), 0.7, System.Action(function()
		if LeanTween.isTweening(go(arg0_50.labelGameScore)) then
			LeanTween.cancel(go(arg0_50.labelGameScore))
		end

		local var0_51 = arg0_50.gameScore
		local var1_51 = arg0_50.gameScore + var1_50

		LeanTween.value(go(arg0_50.labelGameScore), var0_51, var1_51, 1.7):setOnUpdate(System.Action_float(function(arg0_52)
			setText(arg0_50.labelGameScore, math.floor(arg0_52))
		end)):setOnComplete(System.Action(function()
			setText(arg0_50.labelGameScore, var1_51)
		end))

		arg0_50.gameScore = var1_51

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6_0)
	end))
end

function var0_0.updateRemoveFlag(arg0_54)
	for iter0_54 = 1, RollingBallConst.horizontal do
		for iter1_54 = 1, RollingBallConst.vertical do
			local var0_54 = arg0_54.gridDic[iter0_54][iter1_54]

			arg0_54:checkGridRemove(var0_54, iter0_54, iter1_54)
		end
	end
end

function var0_0.checkGridRemove(arg0_55, arg1_55, arg2_55, arg3_55)
	if not arg1_55:getRemoveFlagH() and arg2_55 < RollingBallConst.horizontal - 1 then
		local var0_55 = 0
		local var1_55 = true
		local var2_55
		local var3_55 = {}

		for iter0_55 = arg2_55, RollingBallConst.horizontal do
			if arg1_55:getType() == arg0_55.gridDic[iter0_55][arg3_55]:getType() and var1_55 then
				var0_55 = var0_55 + 1

				table.insert(var3_55, arg0_55.gridDic[iter0_55][arg3_55])

				if arg0_55.gridDic[iter0_55][arg3_55]:getRemoveId() then
					var2_55 = arg0_55.gridDic[iter0_55][arg3_55]:getRemoveId()
				end
			else
				var1_55 = false
			end
		end

		if var0_55 and var0_55 >= 3 then
			var2_55 = var2_55 or arg0_55:getGridRemoveId()

			for iter1_55 = 1, #var3_55 do
				var3_55[iter1_55]:setRemoveFlagH(true, var2_55)
			end
		end
	end

	if not arg1_55:getRemoveFlagV() and arg3_55 < RollingBallConst.vertical - 1 then
		local var4_55 = 0
		local var5_55 = true
		local var6_55
		local var7_55 = {}

		for iter2_55 = arg3_55, RollingBallConst.vertical do
			if arg1_55:getType() == arg0_55.gridDic[arg2_55][iter2_55]:getType() and var5_55 then
				var4_55 = var4_55 + 1

				table.insert(var7_55, arg0_55.gridDic[arg2_55][iter2_55])

				if arg0_55.gridDic[arg2_55][iter2_55]:getRemoveId() then
					var6_55 = arg0_55.gridDic[arg2_55][iter2_55]:getRemoveId()
				end
			else
				var5_55 = false
			end
		end

		if var4_55 and var4_55 >= 3 then
			var6_55 = var6_55 or arg0_55:getGridRemoveId()

			for iter3_55 = 1, #var7_55 do
				var7_55[iter3_55]:setRemoveFlagV(true, var6_55)
			end
		end
	end
end

function var0_0.onGridDown(arg0_56, arg1_56)
	if arg0_56.isMoveing or arg0_56.selectGrid or #arg0_56.moveDatas > 0 then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)

	arg0_56.selectGrid = arg1_56

	arg0_56.selectGrid:getTf():SetAsLastSibling()
end

function var0_0.onGridUp(arg0_57, arg1_57)
	arg0_57.selectGrid = nil

	if arg0_57.changeGridsDic then
		arg0_57:updateMoveGridDic()

		arg0_57.changeGridsDic = nil
	end

	arg0_57:clearDragAlpha()

	arg0_57.onBeginDragTime = nil

	arg0_57:moveGridsBySelfPos(arg0_57.gridDic, nil)

	arg0_57.checkSuccesFlag = true
	arg0_57.downTime = RollingBallConst.downTime
end

function var0_0.checkChangePos(arg0_58, arg1_58)
	local var0_58, var1_58 = arg1_58:getPosData()
	local var2_58, var3_58 = arg0_58.selectGrid:getPosData()

	if arg1_58 == arg0_58.selectGrid or var2_58 ~= var0_58 and var3_58 ~= var1_58 then
		arg0_58:moveGridsBySelfPos(arg0_58.gridDic, arg0_58.selectGrid)

		arg0_58.selectEnterGrid = nil
		arg0_58.changeGridsDic = nil
		arg0_58.changePosX, arg0_58.changePosY = nil
	else
		if arg0_58.changePosX == var0_58 and arg0_58.changePosY == var1_58 then
			return
		end

		arg0_58.changePosX, arg0_58.changePosY = var0_58, var1_58

		arg0_58:updateEnterGrid(arg0_58.changePosX, arg0_58.changePosY)
		arg0_58:moveGridsByChangeDic()
	end
end

function var0_0.onGridBeginDrag(arg0_59, arg1_59, arg2_59, arg3_59)
	if arg0_59.isMoveing or not arg0_59.selectGrid or arg1_59 ~= arg0_59.selectGrid then
		return
	end

	arg0_59.onBeginDragTime = Time.realtimeSinceStartup
	arg0_59.downTime = RollingBallConst.downTime

	local var0_59 = arg0_59.selectGrid:getTf()
	local var1_59, var2_59 = arg0_59.selectGrid:getPosData()
	local var3_59 = arg0_59.selectGrid:getType()

	arg0_59:setDragAlpha(var1_59, var2_59, var3_59)

	arg0_59.changePosX, arg0_59.changePosY = nil
	arg0_59.dragOffsetPos.x = arg3_59.position.x - var0_59.transform.localPosition.x
	arg0_59.dragOffsetPos.y = arg3_59.position.y - var0_59.transform.localPosition.y
end

function var0_0.onGridDrag(arg0_60, arg1_60, arg2_60, arg3_60)
	if not arg0_60.selectGrid or arg1_60 ~= arg0_60.selectGrid then
		return
	end

	if not arg0_60.uiCam then
		arg0_60.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	local var0_60 = arg0_60.uiCam:ScreenToWorldPoint(arg3_60.position)
	local var1_60 = arg0_60.rollingUI:InverseTransformPoint(var0_60)
	local var2_60 = var1_60.x - RollingBallConst.grid_width / 2
	local var3_60 = var1_60.y - RollingBallConst.grid_height / 2

	if var2_60 < 0 then
		var2_60 = 0
	end

	if var3_60 < 0 then
		var3_60 = 0
	end

	if var2_60 > (RollingBallConst.horizontal - 1) * RollingBallConst.grid_width then
		var2_60 = (RollingBallConst.horizontal - 1) * RollingBallConst.grid_width
	end

	if var3_60 > (RollingBallConst.vertical - 1) * RollingBallConst.grid_height then
		var3_60 = (RollingBallConst.vertical - 1) * RollingBallConst.grid_height
	end

	arg0_60.selectGrid:changePosition(var2_60, var3_60)

	local var4_60 = arg0_60:getGridByPosition(arg0_60.selectGrid:getPosition())

	if var4_60 and var4_60 ~= arg0_60.selectGrid then
		local var5_60, var6_60 = var4_60:getPosData()
		local var7_60, var8_60 = arg0_60.selectGrid:getPosData()
		local var9_60 = var5_60 - var7_60
		local var10_60 = var6_60 - var8_60

		if math.abs(var9_60) + math.abs(var10_60) == 1 then
			arg0_60:updateMove(var5_60, var6_60)
		elseif math.abs(var9_60) > math.abs(var10_60) then
			if var9_60 > 0 then
				var5_60 = var7_60 + 1
			end

			if var9_60 < 0 then
				var5_60 = var7_60 - 1
			end

			arg0_60:updateMove(var5_60, var8_60)
		else
			if var10_60 > 0 then
				var6_60 = var8_60 + 1
			end

			if var10_60 < 0 then
				var6_60 = var8_60 - 1
			end

			arg0_60:updateMove(var7_60, var6_60)
		end
	end
end

function var0_0.updateMove(arg0_61, arg1_61, arg2_61)
	if arg1_61 > RollingBallConst.horizontal or arg2_61 > RollingBallConst.vertical then
		return
	end

	arg0_61:changeDragGrid(arg1_61, arg2_61)
	arg0_61:updateMoveGridDic()

	arg0_61.changeGridsDic = nil

	arg0_61:moveGridsBySelfPos(arg0_61.gridDic, arg0_61.selectGrid)
	arg0_61:setDragAlpha(arg1_61, arg2_61, arg0_61.selectGrid:getType())
end

function var0_0.getGridByPosition(arg0_62, arg1_62)
	local var0_62 = math.floor((arg1_62.x + RollingBallConst.grid_width / 2) / RollingBallConst.grid_width) + 1
	local var1_62 = math.floor((arg1_62.y + RollingBallConst.grid_height / 2) / RollingBallConst.grid_height) + 1

	if var0_62 >= 1 and var0_62 <= RollingBallConst.horizontal and var1_62 >= 1 and var1_62 <= RollingBallConst.vertical then
		return arg0_62.gridDic[var0_62][var1_62]
	end

	return nil
end

function var0_0.updateEnterGrid(arg0_63, arg1_63, arg2_63)
	local var0_63, var1_63 = arg0_63.selectGrid:getPosData()

	arg0_63.changeGridsDic = {}

	for iter0_63 = 1, #arg0_63.gridDic do
		arg0_63.changeGridsDic[iter0_63] = {}

		for iter1_63 = 1, #arg0_63.gridDic[iter0_63] do
			if iter0_63 ~= var0_63 and iter1_63 ~= var1_63 then
				table.insert(arg0_63.changeGridsDic[iter0_63], {
					grid = arg0_63.gridDic[iter0_63][iter1_63],
					posX = iter0_63,
					posY = iter1_63
				})
			elseif iter0_63 == var0_63 and iter1_63 == var1_63 then
				table.insert(arg0_63.changeGridsDic[iter0_63], {
					grid = arg0_63.gridDic[iter0_63][iter1_63],
					posX = arg1_63,
					posY = arg2_63
				})
			elseif iter0_63 == var0_63 then
				if var1_63 < iter1_63 and iter1_63 <= arg2_63 then
					table.insert(arg0_63.changeGridsDic[iter0_63], {
						grid = arg0_63.gridDic[iter0_63][iter1_63],
						posX = iter0_63,
						posY = iter1_63 - 1
					})
				elseif iter1_63 < var1_63 and arg2_63 <= iter1_63 then
					table.insert(arg0_63.changeGridsDic[iter0_63], {
						grid = arg0_63.gridDic[iter0_63][iter1_63],
						posX = iter0_63,
						posY = iter1_63 + 1
					})
				else
					table.insert(arg0_63.changeGridsDic[iter0_63], {
						grid = arg0_63.gridDic[iter0_63][iter1_63],
						posX = iter0_63,
						posY = iter1_63
					})
				end
			elseif iter1_63 == var1_63 then
				if var0_63 < iter0_63 and iter0_63 <= arg1_63 then
					table.insert(arg0_63.changeGridsDic[iter0_63], {
						grid = arg0_63.gridDic[iter0_63][iter1_63],
						posX = iter0_63 - 1,
						posY = iter1_63
					})
				elseif iter0_63 < var0_63 and arg1_63 <= iter0_63 then
					table.insert(arg0_63.changeGridsDic[iter0_63], {
						grid = arg0_63.gridDic[iter0_63][iter1_63],
						posX = iter0_63 + 1,
						posY = iter1_63
					})
				else
					table.insert(arg0_63.changeGridsDic[iter0_63], {
						grid = arg0_63.gridDic[iter0_63][iter1_63],
						posX = iter0_63,
						posY = iter1_63
					})
				end
			end
		end
	end
end

function var0_0.changeDragGrid(arg0_64, arg1_64, arg2_64)
	local var0_64, var1_64 = arg0_64.selectGrid:getPosData()

	arg0_64.changeGridsDic = {}

	for iter0_64 = 1, #arg0_64.gridDic do
		arg0_64.changeGridsDic[iter0_64] = {}

		for iter1_64 = 1, #arg0_64.gridDic[iter0_64] do
			if iter0_64 == arg1_64 and iter1_64 == arg2_64 then
				table.insert(arg0_64.changeGridsDic[iter0_64], {
					grid = arg0_64.gridDic[iter0_64][iter1_64],
					posX = var0_64,
					posY = var1_64
				})
			elseif iter0_64 == var0_64 and iter1_64 == var1_64 then
				table.insert(arg0_64.changeGridsDic[iter0_64], {
					grid = arg0_64.gridDic[iter0_64][iter1_64],
					posX = arg1_64,
					posY = arg2_64
				})
			else
				table.insert(arg0_64.changeGridsDic[iter0_64], {
					grid = arg0_64.gridDic[iter0_64][iter1_64],
					posX = iter0_64,
					posY = iter1_64
				})
			end
		end
	end
end

function var0_0.createGrid(arg0_65, arg1_65, arg2_65, arg3_65)
	local var0_65
	local var1_65 = #arg0_65.gridsPool

	if #arg0_65.gridsPool > 0 then
		var0_65 = table.remove(arg0_65.gridsPool, 1)
	else
		var0_65 = RollingBallGrid.New(tf(Instantiate(arg0_65.tplGrid)))

		var0_65:addDownCallback(function(arg0_66, arg1_66)
			arg0_65:onGridDown(var0_65)
		end)
		var0_65:addUpCallback(function(arg0_67, arg1_67)
			arg0_65:onGridUp(var0_65)
		end)
		var0_65:addBeginDragCallback(function(arg0_68, arg1_68)
			arg0_65:onGridBeginDrag(var0_65, arg0_68, arg1_68)
		end)
		var0_65:addDragCallback(function(arg0_69, arg1_69)
			arg0_65:onGridDrag(var0_65, arg0_69, arg1_69)
		end)
		setActive(var0_65:getTf(), true)
	end

	var0_65:setParent(arg0_65.rollingUI)
	var0_65:setType(arg1_65)
	var0_65:setPosData(arg2_65, arg3_65)

	return var0_65
end

function var0_0.setDragAlpha(arg0_70, arg1_70, arg2_70, arg3_70)
	local var0_70 = (arg1_70 - 1) * RollingBallConst.grid_width
	local var1_70 = (arg2_70 - 1) * RollingBallConst.grid_height

	arg0_70.dragAlphaGrid:setPosition(var0_70, var1_70)
	arg0_70.dragAlphaGrid:setType(arg3_70)
	setActive(arg0_70.dragAlphaGrid:getTf(), true)
end

function var0_0.clearDragAlpha(arg0_71)
	setActive(arg0_71.dragAlphaGrid:getTf(), false)
end

function var0_0.returnGrid(arg0_72, arg1_72)
	arg0_72:removeGrid(arg1_72)
	arg1_72:clearData()
	arg1_72:setParent(arg0_72.gridPoolTf)
	arg1_72:setEventActive(false)
	table.insert(arg0_72.gridsPool, arg1_72)
end

function var0_0.removeGrid(arg0_73, arg1_73)
	local var0_73, var1_73 = arg1_73:getPosData()

	if not arg0_73.gridDic[var0_73][var1_73] then
		arg0_73.gridDic[var0_73][var1_73] = false
	end
end

function var0_0.getRandomType(arg0_74, arg1_74)
	if arg1_74 then
		local var0_74 = {}

		for iter0_74 = 1, RollingBallConst.grid_type_amount do
			if not table.contains(arg1_74, iter0_74) then
				table.insert(var0_74, iter0_74)
			end
		end

		return var0_74[math.random(1, #var0_74)]
	end

	return math.random(1, RollingBallConst.grid_type_amount)
end

function var0_0.addGridScoreTip(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg1_75.x
	local var1_75 = arg1_75.y
	local var2_75 = arg0_75:getScoreTip()
	local var3_75 = (var0_75 - 1) * RollingBallConst.grid_width
	local var4_75 = (var1_75 - 1) * RollingBallConst.grid_height

	var2_75.localPosition = Vector3(var3_75, var4_75, 0)

	setText(findTF(var2_75, "text"), "+" .. arg2_75)
	LeanTween.moveLocalY(go(var2_75), var4_75 + 30, 0.5):setOnComplete(System.Action(function()
		arg0_75:returnScoreTip(var2_75)
	end))
end

function var0_0.addRemoveEffect(arg0_77, arg1_77)
	local var0_77 = arg1_77.x
	local var1_77 = arg1_77.y
	local var2_77 = arg0_77:getRemoveEffect()
	local var3_77 = (var0_77 - 1) * RollingBallConst.grid_width
	local var4_77 = (var1_77 - 1) * RollingBallConst.grid_height

	var2_77.localPosition = Vector3(var3_77 + 50, var4_77 + 50, -350)

	LeanTween.delayedCall(go(var2_77), 0.7, System.Action(function()
		arg0_77:returnRemoveEffect(var2_77)
	end))
end

function var0_0.getRemoveEffect(arg0_79)
	if not arg0_79.removeEffectPool then
		arg0_79.removeEffectPool = {}
		arg0_79.removeEffects = {}
	end

	local var0_79

	if #arg0_79.removeEffectPool > 1 then
		var0_79 = table.remove(arg0_79.removeEffectPool, #arg0_79.removeEffectPool)
	else
		var0_79 = tf(Instantiate(arg0_79.tplRemoveEffect))

		setParent(var0_79, arg0_79.rollingEffectUI, false)
		table.insert(arg0_79.removeEffects, var0_79)
	end

	setActive(var0_79, true)

	return var0_79
end

function var0_0.returnRemoveEffect(arg0_80, arg1_80)
	setActive(arg1_80, false)
	table.insert(arg0_80.removeEffectPool, arg1_80)
end

function var0_0.getScoreTip(arg0_81)
	if not arg0_81.scoreTipPool then
		arg0_81.scoreTipPool = {}
		arg0_81.scoreTips = {}
	end

	local var0_81

	if #arg0_81.scoreTipPool > 1 then
		var0_81 = table.remove(arg0_81.scoreTipPool, #arg0_81.scoreTipPool)
	else
		var0_81 = tf(Instantiate(arg0_81.tplScoreTip))

		setParent(var0_81, arg0_81.rollingEffectUI, false)
		table.insert(arg0_81.scoreTips, var0_81)
	end

	setActive(var0_81, true)

	return var0_81
end

function var0_0.returnScoreTip(arg0_82, arg1_82)
	setActive(arg1_82, false)
	table.insert(arg0_82.scoreTipPool, arg1_82)
end

function var0_0.addEffect(arg0_83, arg1_83)
	local var0_83 = arg0_83.effectUI:InverseTransformPoint(arg1_83)
	local var1_83 = arg0_83:getEffect()

	setParent(var1_83, arg0_83.effectUI, false)
	setActive(var1_83, true)

	var1_83.localPosition = var0_83

	table.insert(arg0_83.effectDatas, {
		vy = 2,
		ay = 0,
		vx = 2,
		ax = 0,
		tf = var1_83
	})
end

function var0_0.clearUI(arg0_84)
	arg0_84.moveDatas = {}
	arg0_84.startFlag = false
	arg0_84.stopFlag = false

	setText(arg0_84.labelGameScore, "0000")
	setText(arg0_84.labelGameTime, "")
	setActive(arg0_84.endLess, true)

	arg0_84.downTimeSlider.value = 1

	setActive(arg0_84.closeUI, false)
	setActive(arg0_84.overLight, false)
	arg0_84:clearDragAlpha()

	for iter0_84 = #arg0_84.effectDatas, 1, -1 do
		local var0_84 = arg0_84.effectDatas[iter0_84].tf

		arg0_84:returnEffect(var0_84)
		table.remove(arg0_84.effectDatas, iter0_84)
	end

	for iter1_84 = 1, RollingBallConst.horizontal do
		for iter2_84 = 1, RollingBallConst.vertical do
			if arg0_84.gridDic[iter1_84][iter2_84] then
				arg0_84:returnGrid(arg0_84.gridDic[iter1_84][iter2_84])

				arg0_84.gridDic[iter1_84][iter2_84] = false
			end
		end
	end
end

function var0_0.getEffect(arg0_85)
	if #arg0_85.effectPool > 0 then
		return table.remove(arg0_85.effectPool, #arg0_85.effectPool)
	end

	return (tf(Instantiate(arg0_85.tplEffect)))
end

function var0_0.returnEffect(arg0_86, arg1_86)
	SetParent(arg1_86, arg0_86.effectPoolTf, false)
	table.insert(arg0_86.effectPool, arg1_86)
end

function var0_0.getGridRemoveId(arg0_87)
	if not arg0_87.removeId then
		arg0_87.removeId = 0
	end

	arg0_87.removeId = arg0_87.removeId + 1

	return tostring(arg0_87.removeId)
end

function var0_0.onBackPressed(arg0_88)
	if not arg0_88.startFlag then
		arg0_88:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.willExit(arg0_89)
	if arg0_89.timer and arg0_89.timer.running then
		arg0_89.timer:Stop()
	end

	if LeanTween.isTweening(go(arg0_89.caidaiTf)) then
		LeanTween.cancel(go(arg0_89.caidaiTf))
	end

	if LeanTween.isTweening(go(arg0_89.labelGameScore)) then
		LeanTween.cancel(go(arg0_89.labelGameScore))
	end

	if LeanTween.isTweening(go(arg0_89.rollingUI)) then
		LeanTween.cancel(go(arg0_89.rollingUI))
	end

	if arg0_89.scoreTips then
		for iter0_89 = 1, #arg0_89.scoreTips do
			if LeanTween.isTweening(go(arg0_89.scoreTips[iter0_89])) then
				LeanTween.cancel(go(arg0_89.scoreTips[iter0_89]))
			end
		end
	end

	if arg0_89.removeEffects then
		for iter1_89 = 1, #arg0_89.removeEffects do
			if LeanTween.isTweening(go(arg0_89.removeEffects[iter1_89])) then
				LeanTween.cancel(go(arg0_89.removeEffects[iter1_89]))
			end
		end
	end

	arg0_89.timer = nil
end

return var0_0
