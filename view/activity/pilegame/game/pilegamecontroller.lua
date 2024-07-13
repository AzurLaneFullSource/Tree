local var0_0 = class("PileGameController")

var0_0.STATE_IDLE = 0
var0_0.STATE_PREPARE = 1
var0_0.STATE_START = 2
var0_0.STATE_DROPING = 3
var0_0.STATE_STOP_DROP = 4
var0_0.STATE_SINK = 5
var0_0.STATE_SINK_DONE = 6
var0_0.STATE_STOP_SHAKE = 7
var0_0.STATE_END = 8
var0_0.STATE_EXIT = 9
var0_0.DROP_AREA_SAFE = 1
var0_0.DROP_AREA_WARN = 2
var0_0.DROP_AREA_DANGER = 3

function var0_0.Ctor(arg0_1)
	arg0_1.model = PileGameModel.New(arg0_1)
	arg0_1.view = PileGameView.New(arg0_1)
	arg0_1.state = var0_0.STATE_IDLE
	arg0_1.locked = false
	arg0_1.time = 0
	arg0_1.shakePositions = {}
end

function var0_0.SetUp(arg0_2, arg1_2, arg2_2)
	arg0_2.model:NetData(arg1_2)
	arg0_2.view:OnEnterGame(arg1_2)

	arg0_2.gameEndCb = arg2_2
end

function var0_0.StartGame(arg0_3)
	seriesAsync({
		function(arg0_4)
			arg0_3.locked = false

			arg0_3:OnInitGame()
			arg0_3.view:DoCurtain(arg0_4)

			if arg0_3.gameStateCallback then
				arg0_3.gameStateCallback(false)
			end
		end,
		function(arg0_5)
			arg0_3:OnPrepare(arg0_5)
		end,
		function(arg0_6)
			arg0_3.state = var0_0.STATE_PREPARE

			arg0_3.view:OnGameStart()
		end
	})
end

function var0_0.setGameStartCallback(arg0_7, arg1_7)
	arg0_7.gameStateCallback = arg1_7
end

function var0_0.ExitGame(arg0_8)
	arg0_8.locked = false
	arg0_8.shakePositions = {}
	arg0_8.state = var0_0.STATE_EXIT

	for iter0_8, iter1_8 in ipairs(arg0_8.model.items) do
		arg0_8.view:OnRemovePile(iter1_8)
	end

	if arg0_8.gameStateCallback then
		arg0_8.gameStateCallback(true)
	end

	arg0_8.model:Clear()
	arg0_8.view:OnGameExited()
end

function var0_0.Drop(arg0_9)
	if arg0_9.state == var0_0.STATE_START and not arg0_9.locked then
		arg0_9.state = var0_0.STATE_DROPING

		arg0_9:OnStartDrop()
	end
end

function var0_0.OnInitGame(arg0_10)
	if not arg0_10.handle then
		arg0_10.handle = UpdateBeat:CreateListener(arg0_10.Update, arg0_10)
	end

	UpdateBeat:AddListener(arg0_10.handle)
	arg0_10.model:AddDeathLineRight()
	arg0_10.model:AddDeathLineLeft()
	arg0_10.model:AddSafeLineRight()
	arg0_10.model:AddSafeLineLeft()
	arg0_10.model:AddGround()
	arg0_10.view:InitSup(arg0_10.model)
end

function var0_0.OnPrepare(arg0_11, arg1_11)
	seriesAsync({
		function(arg0_12)
			arg0_11.view:UpdateScore(arg0_11.model.score)
			arg0_11.view:UpdateFailedCnt(arg0_11.model.maxFailedCnt, arg0_11.model.failedCnt)
			arg0_12()
		end,
		function(arg0_13)
			arg0_11.item = arg0_11.model:AddHeadPile()
			arg0_11.item.position = Vector3(0, -arg0_11.model.screen.y / 2, 0)

			arg0_11.view:AddPile(arg0_11.item, true, function()
				arg0_11.view:OnItemPositionChange(arg0_11.item)
				arg0_13()
			end)
		end,
		function(arg0_15)
			local var0_15 = arg0_11.item

			arg0_11.item = arg0_11.model:AddPileByRandom()
			arg0_11.item.position = Vector3(0, -arg0_11.model.screen.y / 2 + var0_15.sizeDelta.y, 0)

			arg0_11.view:AddPile(arg0_11.item, false, function()
				arg0_11.view:OnItemPositionChange(arg0_11.item)
				arg0_15()
			end)
		end
	}, arg1_11)
end

function var0_0.OnStartGame(arg0_17, arg1_17)
	local function var0_17()
		arg0_17.state = var0_0.STATE_SINK_DONE
		arg0_17.item = arg0_17.model:AddPileByRandom()

		arg0_17.view:AddPile(arg0_17.item, false, function()
			arg0_17.state = var0_0.STATE_START
		end)
	end

	if arg0_17.model:ShouldSink() then
		arg0_17.state = var0_0.STATE_SINK

		arg0_17:DoSink(var0_17)
	else
		var0_17()
	end

	arg0_17:RemoveLockTimer()

	if arg1_17 then
		arg0_17.locked = true
		arg0_17.lockTimer = Timer.New(function()
			arg0_17.locked = false
		end, PileGameConst.BAN_OP_TIME, 1)

		arg0_17.lockTimer:Start()
	end
end

function var0_0.RemoveLockTimer(arg0_21)
	if arg0_21.lockTimer then
		arg0_21.lockTimer:Stop()

		arg0_21.lockTimer = nil
	end
end

function var0_0.OnEndGame(arg0_22, arg1_22)
	arg0_22.state = var0_0.STATE_END
	arg0_22.time = 0
	arg0_22.shakePositions = {}
	arg0_22.locked = false

	local function var0_22()
		arg0_22.view:OnGameEnd(arg0_22.model.score, arg0_22.model.highestScore)

		if arg0_22.model.score > arg0_22.model.highestScore then
			arg0_22.model:UpdateHighestScore()
		end

		arg0_22.model.score = 0
	end

	if arg0_22.gameEndCb then
		arg0_22.gameEndCb(arg0_22.model.score, arg0_22.model.highestScore)
	end

	if arg1_22 then
		local var1_22 = arg0_22.model:GetFirstItem().position.x
		local var2_22 = arg0_22.item.position.x > 0 and 1 or 0

		arg0_22.view:OnCollapse(var1_22, var2_22, var0_22)
	else
		var0_22()
	end
end

function var0_0.Update(arg0_24)
	if arg0_24.state == var0_0.STATE_PREPARE then
		arg0_24:OnStartGame()
	elseif arg0_24.state == var0_0.STATE_START then
		arg0_24:Shuffling()
	elseif arg0_24.state == var0_0.STATE_DROPING then
		arg0_24:Droping()
	elseif arg0_24.state == var0_0.STATE_STOP_DROP then
		arg0_24:CheckCollide()
	end

	if #arg0_24.shakePositions > 0 then
		arg0_24:DoShake()
	end

	if arg0_24.state >= var0_0.STATE_START and arg0_24.state < var0_0.STATE_END then
		if arg0_24.time >= PileGameConst.PLAY_SPE_ACTION_TIME then
			arg0_24:PlaySpeAction()

			arg0_24.time = 0
		end

		arg0_24.time = arg0_24.time + Time.deltaTime
	end
end

function var0_0.PlaySpeAction(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.model.items) do
		if iter1_25 ~= arg0_25.item then
			arg0_25.view:PlaySpeAction(iter1_25)
		end
	end
end

function var0_0.StopShake(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.shakePositions) do
		iter1_26[1].onTheMove = false
	end

	arg0_26.shakePositions = {}
end

function var0_0.CheckRock(arg0_27)
	local var0_27 = arg0_27.model:GetTailItem()

	if arg0_27.model:GetDropArea(var0_27) == var0_0.DROP_AREA_WARN then
		arg0_27.shakePositions = arg0_27.model:GetInitPos()
	end
end

function var0_0.DoShake(arg0_28)
	local var0_28 = Time.deltaTime * PileGameConst.SHAKE_SPEED
	local var1_28 = arg0_28.shakePositions[1][1].position

	for iter0_28, iter1_28 in ipairs(arg0_28.shakePositions) do
		local var2_28 = iter1_28[1]
		local var3_28 = iter1_28[2]
		local var4_28 = iter1_28[3]
		local var5_28 = Vector3(var3_28, var2_28.position.y, 0)
		local var6_28 = Vector3(var4_28, var2_28.position.y, 0)

		if var2_28.onTheMove == true then
			var2_28.position = Vector3.MoveTowards(var2_28.position, var5_28, var0_28)
		else
			var2_28.position = Vector3.MoveTowards(var2_28.position, var6_28, var0_28)
		end

		if var2_28.position.x == var6_28.x and var2_28.onTheMove == false then
			var2_28.onTheMove = true
		elseif var2_28.position.x == var5_28.x and var2_28.onTheMove == true then
			var2_28.onTheMove = false
		end

		arg0_28.view:OnItemPositionChange(var2_28)
	end

	local var7_28 = arg0_28.shakePositions[1][1].position

	if var7_28.x ~= var1_28.x then
		arg0_28.view:OnShake(var7_28.x - var1_28.x)
	end
end

function var0_0.DoSink(arg0_29, arg1_29)
	local var0_29 = {}

	for iter0_29 = 1, #arg0_29.model.items do
		table.insert(var0_29, function(arg0_30)
			local var0_30

			var0_30.position, var0_30 = arg0_29.model:GetNextPos(iter0_29), arg0_29.model.items[iter0_29]

			arg0_29.view:OnItemPositionChangeWithAnim(var0_30, arg0_30)
		end)
	end

	parallelAsync({
		function(arg0_31)
			seriesAsync(var0_29, arg0_31)
		end,
		function(arg0_32)
			local var0_32 = arg0_29.model:GetFirstItem()

			arg0_29.view:DoSink(var0_32.sizeDelta.y, arg0_32)
		end
	}, function()
		local var0_33 = arg0_29.model:RemoveFirstItem()

		arg0_29.view:OnRemovePile(var0_33)
		arg1_29()
	end)
end

function var0_0.Shuffling(arg0_34)
	local var0_34 = Time.deltaTime * arg0_34.item.speed
	local var1_34 = arg0_34.item.leftMaxPosition
	local var2_34 = arg0_34.item.rightMaxPosition

	if arg0_34.item.onTheMove == false then
		arg0_34.item.position = Vector3.MoveTowards(arg0_34.item.position, var2_34, var0_34)
	else
		arg0_34.item.position = Vector3.MoveTowards(arg0_34.item.position, var1_34, var0_34)
	end

	if arg0_34.item.position.x == var2_34.x and arg0_34.item.onTheMove == false then
		arg0_34.item.onTheMove = true
	elseif arg0_34.item.position.x == var1_34.x and arg0_34.item.onTheMove == true then
		arg0_34.item.onTheMove = false
	end

	arg0_34.view:OnItemPositionChange(arg0_34.item)
	arg0_34.view:OnItemIndexPositionChange(arg0_34.item)
end

function var0_0.OnStartDrop(arg0_35)
	local var0_35 = arg0_35.model:GetDropArea(arg0_35.item)

	if var0_35 then
		local var1_35 = arg0_35.model:CanDropOnPrev(arg0_35.item)

		arg0_35.view:OnStartDrop(arg0_35.item, var0_35, var1_35)
	end
end

function var0_0.Droping(arg0_36)
	local var0_36 = Time.deltaTime * arg0_36.item.dropSpeed

	arg0_36.item.onTheMove = false

	local var1_36 = arg0_36.model.ground.position.y - 100
	local var2_36 = Vector3(arg0_36.item.position.x, var1_36, 0)

	arg0_36.item.position = Vector3.MoveTowards(arg0_36.item.position, var2_36, var0_36)

	arg0_36.view:OnItemPositionChange(arg0_36.item)

	if arg0_36.model:IsOverTailItem(arg0_36.item) and #arg0_36.shakePositions > 0 then
		arg0_36:StopShake()
	end

	if arg0_36.model:IsStopDrop(arg0_36.item) then
		arg0_36.state = var0_0.STATE_STOP_DROP
	end
end

function var0_0.CheckCollide(arg0_37)
	local var0_37 = arg0_37.model:IsOnGround(arg0_37.item)
	local var1_37 = arg0_37.model:GetIndex() == 1
	local var2_37 = arg0_37.model:IsOverDeathLine(arg0_37.item)

	if var1_37 and var0_37 then
		arg0_37:OnStartGame(true)
	elseif not var1_37 and var0_37 then
		arg0_37.model:AddFailedCnt()
		arg0_37.view:UpdateFailedCnt(arg0_37.model.maxFailedCnt, arg0_37.model.failedCnt, true, arg0_37.item)
		arg0_37.model:RemoveTailItem()
		arg0_37.view:OnRemovePile(arg0_37.item)

		if arg0_37.model:IsMaxfailedCnt() then
			arg0_37:OnEndGame(false)
		else
			arg0_37:CheckRock()
			arg0_37:OnStartGame(true)
		end
	elseif not var0_37 and var2_37 then
		arg0_37:OnEndGame(true)
	elseif not var0_37 and not var2_37 then
		arg0_37.model:AddScore()

		if arg0_37.model:IsExceedingTheHighestScore() then
			arg0_37.view:OnExceedingTheHighestScore()
		end

		arg0_37.view:UpdateScore(arg0_37.model.score, arg0_37.item)
		arg0_37:CheckRock()
		arg0_37:OnStartGame(true)
	else
		assert(false, "Why is it running here?")
	end
end

function var0_0.onBackPressed(arg0_38)
	return arg0_38.view:onBackPressed()
end

function var0_0.Dispose(arg0_39)
	arg0_39.gameEndCb = nil
	arg0_39.locked = false

	if arg0_39.handle then
		UpdateBeat:RemoveListener(arg0_39.handle)
	end

	arg0_39:ExitGame()
	arg0_39.model:Dispose()
	arg0_39.view:Dispose()
	arg0_39:RemoveLockTimer()

	arg0_39.shakePositions = {}
end

return var0_0
