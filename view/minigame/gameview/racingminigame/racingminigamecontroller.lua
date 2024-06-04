local var0 = class("RacingMiniGameController")

function var0.Ctor(arg0, arg1, arg2)
	arg0.binder = arg1

	arg0:InitTimer()
	arg0:InitGameUI(arg2)
end

local function var1(arg0, arg1)
	local var0 = arg0:GetComponentsInChildren(typeof(Animator), true)

	for iter0 = 0, var0.Length - 1 do
		var0[iter0].speed = arg1
	end
end

local function var2(arg0, arg1)
	local var0 = arg0:GetComponentsInChildren(typeof(SpineAnimUI), true)

	for iter0 = 0, var0.Length - 1 do
		if IsNil(var0[iter0]) then
			-- block empty
		elseif arg1 then
			var0[iter0]:Pause()
		else
			var0[iter0]:Resume()
		end
	end
end

function var0.InitTimer(arg0)
	arg0.timer = Timer.New(function()
		arg0:OnTimer(RacingMiniGameConfig.TIME_INTERVAL)
	end, RacingMiniGameConfig.TIME_INTERVAL, -1)

	if IsUnityEditor and not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(function()
			if Input.GetKeyDown(KeyCode.W) then
				arg0.up = true
			end

			if Input.GetKeyUp(KeyCode.W) then
				arg0.up = false
			end

			if Input.GetKeyDown(KeyCode.S) then
				arg0.down = true
			end

			if Input.GetKeyUp(KeyCode.S) then
				arg0.down = false
			end

			if Input.GetKeyDown(KeyCode.Space) then
				arg0.boost = true
			end

			if Input.GetKeyUp(KeyCode.Space) then
				arg0.boost = false
			end
		end, arg0)

		UpdateBeat:AddListener(arg0.handle)
	end
end

function var0.InitGameUI(arg0, arg1)
	arg0.rtViewport = arg1:Find("Viewport")
	arg0.bgSingleSize = arg0.rtViewport.rect.width
	arg0.rtBgContent = arg0.rtViewport:Find("BgContent")
	arg0.rtMainContent = arg0.rtViewport:Find("MainContent")
	arg0.singleHeight = arg0.rtMainContent.rect.height / 3
	arg0.rtRes = arg1:Find("Resource")
	arg0.rtController = arg1:Find("Controller")

	for iter0, iter1 in ipairs({
		"up",
		"down",
		"boost"
	}) do
		local var0 = GetOrAddComponent(arg0.rtController:Find("bottom/btn_" .. iter1), typeof(EventTriggerListener))

		var0:AddPointDownFunc(function()
			arg0[iter1] = true
		end)
		var0:AddPointUpFunc(function()
			arg0[iter1] = false
		end)
	end

	if RacingMiniGameConfig.BOOST_BUTTON_TYPE_CHANGE then
		RemoveComponent(arg0.rtController:Find("bottom/btn_boost"), typeof(EventTriggerListener))
		onButton(arg0.binder, arg0.rtController:Find("bottom/btn_boost"), function()
			if not arg0.target.isBlock then
				local var0 = RacingMiniGameConfig.M_LIST
				local var1 = RacingMiniGameConfig.S_LIST

				arg0.enginePower = math.clamp(arg0.enginePower + RacingMiniGameConfig.BOOST_RATE[2], var0[1], var0[#var0])

				if arg0.target.state == "base" then
					arg0.target:Show("accel")
				end
			end
		end)
	end

	arg0.rtTime = arg0.rtController:Find("top/time")

	setText(arg0.rtTime:Find("Text/plus"), "+" .. RacingMiniGameConfig.ITEM_ADD_TIME .. "s")
	arg0.rtTime:Find("Text/plus"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0.rtTime:Find("Text/plus"), false)
	end)

	arg0.rtDis = arg0.rtController:Find("top/dis")
	arg0.rtPower = arg0.rtController:Find("bottom/speed")
	arg0.rtFriend = arg0.rtController:Find("top/friend")
	arg0.queue = {}
end

function var0.ResetGame(arg0)
	arg0.timeCount = 0
	arg0.timeAll = RacingMiniGameConfig.ALL_TIME

	if arg0.target then
		arg0.target:Clear()

		arg0.target = nil
	end

	while #arg0.queue > 0 do
		arg0.queue[#arg0.queue]:Clear()
	end

	arg0.enginePower = 0
	arg0.chargeDis = 0
	arg0.disCount = 0
	arg0.rateDic = {}
	arg0.itemCountDic = {}
end

function var0.ReadyGame(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData()

	arg0.rankData = underscore.filter(arg1, function(arg0)
		return arg0.player_id ~= var0.id
	end)

	table.sort(arg0.rankData, CompareFuncs({
		function(arg0)
			return arg0.score
		end
	}))

	arg0.target = RacingMiniNameSpace.Motorcycle.New(cloneTplTo(arg0.rtRes:Find("qiye_minigame"), arg0.rtMainContent:Find(-2)), NewPos(0, 0), arg0)

	table.insert(arg0.queue, RacingMiniNameSpace.StartMark.New(cloneTplTo(arg0.rtRes:Find("start_mark"), arg0.rtMainContent:Find(-2)), NewPos(550, 0), arg0))
	arg0:UpdateDisplay()
	onNextTick(function()
		arg0:PauseGame()
	end)
end

function var0.StartGame(arg0)
	arg0.isStart = true

	arg0:ResumeGame()
end

function var0.EndGame(arg0, arg1)
	arg0.isStart = false

	arg0:PauseGame()

	arg0.result = arg1 or 0
	arg0.point = arg0.disCount / 20
	arg0.point = arg0.point - arg0.point % 0.01

	arg0.binder:openUI("result")
end

function var0.ResumeGame(arg0)
	arg0.isPause = false

	arg0.timer:Start()
	var1(arg0.rtViewport, 1)
	var2(arg0.rtViewport, false)
end

function var0.PauseGame(arg0)
	arg0.isPause = true

	arg0.timer:Stop()
	var1(arg0.rtViewport, 0)
	var2(arg0.rtViewport, true)
end

local function var3(arg0, arg1)
	local var0 = arg1.pos - arg0.pos
	local var1 = {}

	for iter0 = 1, 2 do
		var1[iter0] = {}
		var1[iter0][1] = arg0.colliderSize[iter0][1] - arg1.colliderSize[iter0][2]
		var1[iter0][2] = arg0.colliderSize[iter0][2] - arg1.colliderSize[iter0][1]
	end

	return var1[1][1] < var0.x and var0.x < var1[1][2] and var1[2][1] < var0.y and var0.y < var1[2][2]
end

function var0.OnTimer(arg0, arg1)
	arg0.timeCount = arg0.timeCount + arg1

	if arg0.timeCount > arg0.timeAll then
		arg0:EndGame(1)

		return
	end

	if arg0.target.invincibleTime then
		arg0.target:UpdateInvincibility(arg1)
	end

	local var0 = NewPos(0, 0)
	local var1 = arg0:GetSpeed(RacingMiniGameConfig.BOOST_RATE[not arg0.target.isBlock and arg0.boost and 2 or 1] * arg1)

	var0.x = var1 * arg1

	if not arg0.target.isBlock then
		if var1 > 0 then
			if arg0.up then
				var0.y = var0.y + 1
			end

			if arg0.down then
				var0.y = var0.y - 1
			end

			var0.y = var0.y * arg0.singleHeight / RacingMiniGameConfig.Y_COVER_TIME * (arg0.target.isVertigo and RacingMiniGameConfig.Y_OBSTACLE_REDUCE or 1) * arg1

			if arg0.target.state == "base" and arg0.boost then
				arg0.target:Show("accel")
			end
		elseif not arg0.target.isVertigo and arg0.target.state ~= "base" then
			arg0.target:Show("base")
		end
	end

	arg0.target:UpdatePos(var0 * NewPos(0, 1), arg0.singleHeight)
	setParent(arg0.target.rt, arg0.rtMainContent:Find(math.clamp(math.floor((arg0.target.pos.y + arg0.singleHeight) * 3 / 2 / arg0.singleHeight) - 1, -1, 1) - 1))

	local var2 = 1

	while var2 <= #arg0.queue do
		local var3 = arg0.queue[var2]

		var3:UpdatePos(var0 * NewPos(-1, 0))

		if not var3.isTriggered and var3.colliderSize and var3(var3, arg0.target) then
			var3:Trigger(arg0.target)
		end

		if var3.pos.x < -arg0.bgSingleSize then
			var3:Clear()
		else
			var2 = var2 + 1
		end
	end

	local var4 = arg0.rtBgContent.anchoredPosition.x - var0.x

	if var4 < -arg0.bgSingleSize / 2 then
		var4 = var4 + arg0.bgSingleSize
	end

	setAnchoredPosition(arg0.rtBgContent, {
		x = var4
	})

	arg0.chargeDis = arg0.chargeDis - var0.x

	if arg0.chargeDis <= 0 then
		arg0:CreateNewObject()
	end

	arg0.disCount = arg0.disCount + var0.x

	arg0:UpdateDisplay()
end

function var0.UpdateDisplay(arg0)
	local var0 = arg0.timeAll - arg0.timeCount

	setText(arg0.rtTime:Find("Text"), string.format("%02d:%02ds", math.floor(var0), math.floor((var0 - math.floor(var0)) * 100)))

	local var1 = arg0.disCount / 20

	setText(arg0.rtDis, string.format("%.2fm", var1 - var1 % 0.01))

	local var2 = RacingMiniGameConfig.BUOY_POWER_LIST
	local var3 = RacingMiniGameConfig.BUOY_POS_LIST
	local var4

	for iter0, iter1 in ipairs(var2) do
		if iter1 >= arg0.enginePower then
			var4 = iter0

			break
		end
	end

	setAnchoredPosition(arg0.rtPower:Find("range/buoy"), {
		x = var4 > 1 and var3[var4 - 1] + (arg0.enginePower - var2[var4 - 1]) / (var2[var4] - var2[var4 - 1]) * (var3[var4] - var3[var4 - 1]) or 0
	})

	if arg0.target.isVertigo then
		var4 = 1
	end

	for iter2, iter3 in ipairs(arg0.target.effectList) do
		setActive(iter3, var4 - 1 == iter2)
	end

	local var5 = RacingMiniGameConfig.FRIEND_DIS_LIST

	arg0.friendIndex = defaultValue(arg0.friendIndex, 1)

	while arg0.friendIndex < #var5 and var5[arg0.friendIndex + 1] < arg0.disCount / 20 do
		arg0.friendIndex = arg0.friendIndex + 1
		arg0.friendDirty = true
	end

	if arg0.friendDirty then
		arg0.friendDirty = false

		while #arg0.rankData > 0 and arg0.rankData[1].score / 100 < var5[arg0.friendIndex] do
			table.remove(arg0.rankData, 1)
		end

		local var6

		for iter4, iter5 in ipairs(arg0.rankData) do
			if arg0.friendIndex == #var5 or iter5.score / 100 < var5[arg0.friendIndex + 1] then
				var6 = iter4
			else
				break
			end
		end

		setActive(arg0.rtFriend, var6)

		if var6 then
			arg0.friendInfo = arg0.rankData[math.random(var6)]
		else
			arg0.friendInfo = nil
		end

		if arg0.friendInfo then
			setText(arg0.rtFriend:Find("Text"), arg0.friendInfo.name)
			setText(arg0.rtFriend:Find("point"), string.format("%.2fm", arg0.friendInfo.score / 100))
		end
	end
end

local var4 = {
	TrafficCone = "roadblocks",
	Mire = "mire",
	Roadblock = "roadblocks",
	SpeedBumps = "speed_bumps",
	Bomb = "roadblocks",
	MoreTime = "more_time",
	Invincibility = "invincibility"
}

function var0.CreateNewObject(arg0)
	local var0

	for iter0, iter1 in ipairs(RacingMiniGameConfig.FIELD_CONFIG) do
		if arg0.timeCount < iter1.time then
			break
		else
			var0 = iter1
		end
	end

	local var1 = {}
	local var2 = 0

	for iter2 = -1, 1 do
		arg0.rateDic[iter2] = defaultValue(arg0.rateDic[iter2], 0)

		local var3 = math.random() / (2 - iter2)
		local var4

		if var3 < arg0.rateDic[iter2] then
			var2 = var2 + 1
			var1[iter2] = true
		else
			var1[iter2] = false
		end
	end

	if var2 == 3 then
		var1[math.random(3) - 2] = false
	end

	for iter3 = -1, 1 do
		if var1[iter3] then
			classCfg = var0.obstacle_distribution
		else
			classCfg = var0.item_distribution
		end

		rate = math.random()

		local var5 = 0
		local var6 = 0

		for iter4, iter5 in ipairs(classCfg) do
			var6 = var6 + iter5[2]
		end

		local var7

		for iter6, iter7 in ipairs(classCfg) do
			var5 = var5 + iter7[2]

			if var5 > rate * var6 then
				var7 = iter7[1]

				break
			end
		end

		if var7 and superof(RacingMiniNameSpace[var7], RacingMiniNameSpace.Item) then
			if defaultValue(arg0.itemCountDic[var7], 0) < defaultValue(var0.item_create_limit[var7], 0) then
				arg0.itemCountDic[var7] = defaultValue(arg0.itemCountDic[var7], 0) + 1
			else
				var7 = nil
			end
		end

		if var7 then
			local var8 = RacingMiniNameSpace[var7].New(cloneTplTo(arg0.rtRes:Find(var4[var7]), arg0.rtMainContent:Find(iter3)), NewPos(arg0.bgSingleSize * 1.5 + arg0.chargeDis, iter3 * arg0.singleHeight), arg0)

			table.insert(arg0.queue, var8)

			arg0.rateDic[iter3] = arg0.rateDic[iter3] * var0.continue_reduce
		else
			arg0.rateDic[iter3] = arg0.rateDic[iter3] + var0.bye_plus
		end
	end

	arg0.chargeDis = arg0.chargeDis + var0.recharge_dis
end

function var0.GetSpeed(arg0, arg1)
	local var0
	local var1 = RacingMiniGameConfig.M_LIST
	local var2 = RacingMiniGameConfig.S_LIST

	for iter0 = 1, #var1 - 1 do
		if var1[iter0 + 1] > arg0.enginePower then
			var0 = var2[iter0] + (arg0.enginePower - var1[iter0]) / (var1[iter0 + 1] - var1[iter0]) * (var2[iter0 + 1] - var2[iter0])

			break
		end
	end

	var0 = var0 or var2[#var2]
	arg0.enginePower = math.clamp(arg0.enginePower + arg1, var1[1], var1[#var1])

	return var0 * 10
end

function var0.AddTime(arg0, arg1)
	arg0.timeAll = arg0.timeAll + arg1

	setActive(arg0.rtTime:Find("Text/plus"), true)
end

function var0.SetEnginePower(arg0, arg1)
	arg0.enginePower = math.min(arg0.enginePower, arg1)
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end
end

return var0
