local var0 = class("PileGameController")

var0.STATE_IDLE = 0
var0.STATE_PREPARE = 1
var0.STATE_START = 2
var0.STATE_DROPING = 3
var0.STATE_STOP_DROP = 4
var0.STATE_SINK = 5
var0.STATE_SINK_DONE = 6
var0.STATE_STOP_SHAKE = 7
var0.STATE_END = 8
var0.STATE_EXIT = 9
var0.DROP_AREA_SAFE = 1
var0.DROP_AREA_WARN = 2
var0.DROP_AREA_DANGER = 3

function var0.Ctor(arg0)
	arg0.model = PileGameModel.New(arg0)
	arg0.view = PileGameView.New(arg0)
	arg0.state = var0.STATE_IDLE
	arg0.locked = false
	arg0.time = 0
	arg0.shakePositions = {}
end

function var0.SetUp(arg0, arg1, arg2)
	arg0.model:NetData(arg1)
	arg0.view:OnEnterGame(arg1)

	arg0.gameEndCb = arg2
end

function var0.StartGame(arg0)
	seriesAsync({
		function(arg0)
			arg0.locked = false

			arg0:OnInitGame()
			arg0.view:DoCurtain(arg0)

			if arg0.gameStateCallback then
				arg0.gameStateCallback(false)
			end
		end,
		function(arg0)
			arg0:OnPrepare(arg0)
		end,
		function(arg0)
			arg0.state = var0.STATE_PREPARE

			arg0.view:OnGameStart()
		end
	})
end

function var0.setGameStartCallback(arg0, arg1)
	arg0.gameStateCallback = arg1
end

function var0.ExitGame(arg0)
	arg0.locked = false
	arg0.shakePositions = {}
	arg0.state = var0.STATE_EXIT

	for iter0, iter1 in ipairs(arg0.model.items) do
		arg0.view:OnRemovePile(iter1)
	end

	if arg0.gameStateCallback then
		arg0.gameStateCallback(true)
	end

	arg0.model:Clear()
	arg0.view:OnGameExited()
end

function var0.Drop(arg0)
	if arg0.state == var0.STATE_START and not arg0.locked then
		arg0.state = var0.STATE_DROPING

		arg0:OnStartDrop()
	end
end

function var0.OnInitGame(arg0)
	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
	arg0.model:AddDeathLineRight()
	arg0.model:AddDeathLineLeft()
	arg0.model:AddSafeLineRight()
	arg0.model:AddSafeLineLeft()
	arg0.model:AddGround()
	arg0.view:InitSup(arg0.model)
end

function var0.OnPrepare(arg0, arg1)
	seriesAsync({
		function(arg0)
			arg0.view:UpdateScore(arg0.model.score)
			arg0.view:UpdateFailedCnt(arg0.model.maxFailedCnt, arg0.model.failedCnt)
			arg0()
		end,
		function(arg0)
			arg0.item = arg0.model:AddHeadPile()
			arg0.item.position = Vector3(0, -arg0.model.screen.y / 2, 0)

			arg0.view:AddPile(arg0.item, true, function()
				arg0.view:OnItemPositionChange(arg0.item)
				arg0()
			end)
		end,
		function(arg0)
			local var0 = arg0.item

			arg0.item = arg0.model:AddPileByRandom()
			arg0.item.position = Vector3(0, -arg0.model.screen.y / 2 + var0.sizeDelta.y, 0)

			arg0.view:AddPile(arg0.item, false, function()
				arg0.view:OnItemPositionChange(arg0.item)
				arg0()
			end)
		end
	}, arg1)
end

function var0.OnStartGame(arg0, arg1)
	local var0 = function()
		arg0.state = var0.STATE_SINK_DONE
		arg0.item = arg0.model:AddPileByRandom()

		arg0.view:AddPile(arg0.item, false, function()
			arg0.state = var0.STATE_START
		end)
	end

	if arg0.model:ShouldSink() then
		arg0.state = var0.STATE_SINK

		arg0:DoSink(var0)
	else
		var0()
	end

	arg0:RemoveLockTimer()

	if arg1 then
		arg0.locked = true
		arg0.lockTimer = Timer.New(function()
			arg0.locked = false
		end, PileGameConst.BAN_OP_TIME, 1)

		arg0.lockTimer:Start()
	end
end

function var0.RemoveLockTimer(arg0)
	if arg0.lockTimer then
		arg0.lockTimer:Stop()

		arg0.lockTimer = nil
	end
end

function var0.OnEndGame(arg0, arg1)
	arg0.state = var0.STATE_END
	arg0.time = 0
	arg0.shakePositions = {}
	arg0.locked = false

	local function var0()
		arg0.view:OnGameEnd(arg0.model.score, arg0.model.highestScore)

		if arg0.model.score > arg0.model.highestScore then
			arg0.model:UpdateHighestScore()
		end

		arg0.model.score = 0
	end

	if arg0.gameEndCb then
		arg0.gameEndCb(arg0.model.score, arg0.model.highestScore)
	end

	if arg1 then
		local var1 = arg0.model:GetFirstItem().position.x
		local var2 = arg0.item.position.x > 0 and 1 or 0

		arg0.view:OnCollapse(var1, var2, var0)
	else
		var0()
	end
end

function var0.Update(arg0)
	if arg0.state == var0.STATE_PREPARE then
		arg0:OnStartGame()
	elseif arg0.state == var0.STATE_START then
		arg0:Shuffling()
	elseif arg0.state == var0.STATE_DROPING then
		arg0:Droping()
	elseif arg0.state == var0.STATE_STOP_DROP then
		arg0:CheckCollide()
	end

	if #arg0.shakePositions > 0 then
		arg0:DoShake()
	end

	if arg0.state >= var0.STATE_START and arg0.state < var0.STATE_END then
		if arg0.time >= PileGameConst.PLAY_SPE_ACTION_TIME then
			arg0:PlaySpeAction()

			arg0.time = 0
		end

		arg0.time = arg0.time + Time.deltaTime
	end
end

function var0.PlaySpeAction(arg0)
	for iter0, iter1 in pairs(arg0.model.items) do
		if iter1 ~= arg0.item then
			arg0.view:PlaySpeAction(iter1)
		end
	end
end

function var0.StopShake(arg0)
	for iter0, iter1 in ipairs(arg0.shakePositions) do
		iter1[1].onTheMove = false
	end

	arg0.shakePositions = {}
end

function var0.CheckRock(arg0)
	local var0 = arg0.model:GetTailItem()

	if arg0.model:GetDropArea(var0) == var0.DROP_AREA_WARN then
		arg0.shakePositions = arg0.model:GetInitPos()
	end
end

function var0.DoShake(arg0)
	local var0 = Time.deltaTime * PileGameConst.SHAKE_SPEED
	local var1 = arg0.shakePositions[1][1].position

	for iter0, iter1 in ipairs(arg0.shakePositions) do
		local var2 = iter1[1]
		local var3 = iter1[2]
		local var4 = iter1[3]
		local var5 = Vector3(var3, var2.position.y, 0)
		local var6 = Vector3(var4, var2.position.y, 0)

		if var2.onTheMove == true then
			var2.position = Vector3.MoveTowards(var2.position, var5, var0)
		else
			var2.position = Vector3.MoveTowards(var2.position, var6, var0)
		end

		if var2.position.x == var6.x and var2.onTheMove == false then
			var2.onTheMove = true
		elseif var2.position.x == var5.x and var2.onTheMove == true then
			var2.onTheMove = false
		end

		arg0.view:OnItemPositionChange(var2)
	end

	local var7 = arg0.shakePositions[1][1].position

	if var7.x ~= var1.x then
		arg0.view:OnShake(var7.x - var1.x)
	end
end

function var0.DoSink(arg0, arg1)
	local var0 = {}

	for iter0 = 1, #arg0.model.items do
		table.insert(var0, function(arg0)
			local var0

			var0.position, var0 = arg0.model:GetNextPos(iter0), arg0.model.items[iter0]

			arg0.view:OnItemPositionChangeWithAnim(var0, arg0)
		end)
	end

	parallelAsync({
		function(arg0)
			seriesAsync(var0, arg0)
		end,
		function(arg0)
			local var0 = arg0.model:GetFirstItem()

			arg0.view:DoSink(var0.sizeDelta.y, arg0)
		end
	}, function()
		local var0 = arg0.model:RemoveFirstItem()

		arg0.view:OnRemovePile(var0)
		arg1()
	end)
end

function var0.Shuffling(arg0)
	local var0 = Time.deltaTime * arg0.item.speed
	local var1 = arg0.item.leftMaxPosition
	local var2 = arg0.item.rightMaxPosition

	if arg0.item.onTheMove == false then
		arg0.item.position = Vector3.MoveTowards(arg0.item.position, var2, var0)
	else
		arg0.item.position = Vector3.MoveTowards(arg0.item.position, var1, var0)
	end

	if arg0.item.position.x == var2.x and arg0.item.onTheMove == false then
		arg0.item.onTheMove = true
	elseif arg0.item.position.x == var1.x and arg0.item.onTheMove == true then
		arg0.item.onTheMove = false
	end

	arg0.view:OnItemPositionChange(arg0.item)
	arg0.view:OnItemIndexPositionChange(arg0.item)
end

function var0.OnStartDrop(arg0)
	local var0 = arg0.model:GetDropArea(arg0.item)

	if var0 then
		local var1 = arg0.model:CanDropOnPrev(arg0.item)

		arg0.view:OnStartDrop(arg0.item, var0, var1)
	end
end

function var0.Droping(arg0)
	local var0 = Time.deltaTime * arg0.item.dropSpeed

	arg0.item.onTheMove = false

	local var1 = arg0.model.ground.position.y - 100
	local var2 = Vector3(arg0.item.position.x, var1, 0)

	arg0.item.position = Vector3.MoveTowards(arg0.item.position, var2, var0)

	arg0.view:OnItemPositionChange(arg0.item)

	if arg0.model:IsOverTailItem(arg0.item) and #arg0.shakePositions > 0 then
		arg0:StopShake()
	end

	if arg0.model:IsStopDrop(arg0.item) then
		arg0.state = var0.STATE_STOP_DROP
	end
end

function var0.CheckCollide(arg0)
	local var0 = arg0.model:IsOnGround(arg0.item)
	local var1 = arg0.model:GetIndex() == 1
	local var2 = arg0.model:IsOverDeathLine(arg0.item)

	if var1 and var0 then
		arg0:OnStartGame(true)
	elseif not var1 and var0 then
		arg0.model:AddFailedCnt()
		arg0.view:UpdateFailedCnt(arg0.model.maxFailedCnt, arg0.model.failedCnt, true, arg0.item)
		arg0.model:RemoveTailItem()
		arg0.view:OnRemovePile(arg0.item)

		if arg0.model:IsMaxfailedCnt() then
			arg0:OnEndGame(false)
		else
			arg0:CheckRock()
			arg0:OnStartGame(true)
		end
	elseif not var0 and var2 then
		arg0:OnEndGame(true)
	elseif not var0 and not var2 then
		arg0.model:AddScore()

		if arg0.model:IsExceedingTheHighestScore() then
			arg0.view:OnExceedingTheHighestScore()
		end

		arg0.view:UpdateScore(arg0.model.score, arg0.item)
		arg0:CheckRock()
		arg0:OnStartGame(true)
	else
		assert(false, "Why is it running here?")
	end
end

function var0.onBackPressed(arg0)
	return arg0.view:onBackPressed()
end

function var0.Dispose(arg0)
	arg0.gameEndCb = nil
	arg0.locked = false

	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	arg0:ExitGame()
	arg0.model:Dispose()
	arg0.view:Dispose()
	arg0:RemoveLockTimer()

	arg0.shakePositions = {}
end

return var0
