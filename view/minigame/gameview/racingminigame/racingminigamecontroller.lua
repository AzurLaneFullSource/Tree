local var0_0 = class("RacingMiniGameController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg1_1

	arg0_1:InitTimer()
	arg0_1:InitGameUI(arg2_1)
end

local function var1_0(arg0_2, arg1_2)
	local var0_2 = arg0_2:GetComponentsInChildren(typeof(Animator), true)

	for iter0_2 = 0, var0_2.Length - 1 do
		var0_2[iter0_2].speed = arg1_2
	end
end

local function var2_0(arg0_3, arg1_3)
	local var0_3 = arg0_3:GetComponentsInChildren(typeof(SpineAnimUI), true)

	for iter0_3 = 0, var0_3.Length - 1 do
		if IsNil(var0_3[iter0_3]) then
			-- block empty
		elseif arg1_3 then
			var0_3[iter0_3]:Pause()
		else
			var0_3[iter0_3]:Resume()
		end
	end
end

function var0_0.InitTimer(arg0_4)
	arg0_4.timer = Timer.New(function()
		arg0_4:OnTimer(RacingMiniGameConfig.TIME_INTERVAL)
	end, RacingMiniGameConfig.TIME_INTERVAL, -1)

	if IsUnityEditor and not arg0_4.handle then
		arg0_4.handle = UpdateBeat:CreateListener(function()
			if Input.GetKeyDown(KeyCode.W) then
				arg0_4.up = true
			end

			if Input.GetKeyUp(KeyCode.W) then
				arg0_4.up = false
			end

			if Input.GetKeyDown(KeyCode.S) then
				arg0_4.down = true
			end

			if Input.GetKeyUp(KeyCode.S) then
				arg0_4.down = false
			end

			if Input.GetKeyDown(KeyCode.Space) then
				arg0_4.boost = true
			end

			if Input.GetKeyUp(KeyCode.Space) then
				arg0_4.boost = false
			end
		end, arg0_4)

		UpdateBeat:AddListener(arg0_4.handle)
	end
end

function var0_0.InitGameUI(arg0_7, arg1_7)
	arg0_7.rtViewport = arg1_7:Find("Viewport")
	arg0_7.bgSingleSize = arg0_7.rtViewport.rect.width
	arg0_7.rtBgContent = arg0_7.rtViewport:Find("BgContent")
	arg0_7.rtMainContent = arg0_7.rtViewport:Find("MainContent")
	arg0_7.singleHeight = arg0_7.rtMainContent.rect.height / 3
	arg0_7.rtRes = arg1_7:Find("Resource")
	arg0_7.rtController = arg1_7:Find("Controller")

	for iter0_7, iter1_7 in ipairs({
		"up",
		"down",
		"boost"
	}) do
		local var0_7 = GetOrAddComponent(arg0_7.rtController:Find("bottom/btn_" .. iter1_7), typeof(EventTriggerListener))

		var0_7:AddPointDownFunc(function()
			arg0_7[iter1_7] = true
		end)
		var0_7:AddPointUpFunc(function()
			arg0_7[iter1_7] = false
		end)
	end

	if RacingMiniGameConfig.BOOST_BUTTON_TYPE_CHANGE then
		RemoveComponent(arg0_7.rtController:Find("bottom/btn_boost"), typeof(EventTriggerListener))
		onButton(arg0_7.binder, arg0_7.rtController:Find("bottom/btn_boost"), function()
			if not arg0_7.target.isBlock then
				local var0_10 = RacingMiniGameConfig.M_LIST
				local var1_10 = RacingMiniGameConfig.S_LIST

				arg0_7.enginePower = math.clamp(arg0_7.enginePower + RacingMiniGameConfig.BOOST_RATE[2], var0_10[1], var0_10[#var0_10])

				if arg0_7.target.state == "base" then
					arg0_7.target:Show("accel")
				end
			end
		end)
	end

	arg0_7.rtTime = arg0_7.rtController:Find("top/time")

	setText(arg0_7.rtTime:Find("Text/plus"), "+" .. RacingMiniGameConfig.ITEM_ADD_TIME .. "s")
	arg0_7.rtTime:Find("Text/plus"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0_7.rtTime:Find("Text/plus"), false)
	end)

	arg0_7.rtDis = arg0_7.rtController:Find("top/dis")
	arg0_7.rtPower = arg0_7.rtController:Find("bottom/speed")
	arg0_7.rtFriend = arg0_7.rtController:Find("top/friend")
	arg0_7.queue = {}
end

function var0_0.ResetGame(arg0_12)
	arg0_12.timeCount = 0
	arg0_12.timeAll = RacingMiniGameConfig.ALL_TIME

	if arg0_12.target then
		arg0_12.target:Clear()

		arg0_12.target = nil
	end

	while #arg0_12.queue > 0 do
		arg0_12.queue[#arg0_12.queue]:Clear()
	end

	arg0_12.enginePower = 0
	arg0_12.chargeDis = 0
	arg0_12.disCount = 0
	arg0_12.rateDic = {}
	arg0_12.itemCountDic = {}
end

function var0_0.ReadyGame(arg0_13, arg1_13)
	local var0_13 = getProxy(PlayerProxy):getRawData()

	arg0_13.rankData = underscore.filter(arg1_13, function(arg0_14)
		return arg0_14.player_id ~= var0_13.id
	end)

	table.sort(arg0_13.rankData, CompareFuncs({
		function(arg0_15)
			return arg0_15.score
		end
	}))

	arg0_13.target = RacingMiniNameSpace.Motorcycle.New(cloneTplTo(arg0_13.rtRes:Find("qiye_minigame"), arg0_13.rtMainContent:Find(-2)), NewPos(0, 0), arg0_13)

	table.insert(arg0_13.queue, RacingMiniNameSpace.StartMark.New(cloneTplTo(arg0_13.rtRes:Find("start_mark"), arg0_13.rtMainContent:Find(-2)), NewPos(550, 0), arg0_13))
	arg0_13:UpdateDisplay()
	onNextTick(function()
		arg0_13:PauseGame()
	end)
end

function var0_0.StartGame(arg0_17)
	arg0_17.isStart = true

	arg0_17:ResumeGame()
end

function var0_0.EndGame(arg0_18, arg1_18)
	arg0_18.isStart = false

	arg0_18:PauseGame()

	arg0_18.result = arg1_18 or 0
	arg0_18.point = arg0_18.disCount / 20
	arg0_18.point = arg0_18.point - arg0_18.point % 0.01

	arg0_18.binder:openUI("result")
end

function var0_0.ResumeGame(arg0_19)
	arg0_19.isPause = false

	arg0_19.timer:Start()
	var1_0(arg0_19.rtViewport, 1)
	var2_0(arg0_19.rtViewport, false)
end

function var0_0.PauseGame(arg0_20)
	arg0_20.isPause = true

	arg0_20.timer:Stop()
	var1_0(arg0_20.rtViewport, 0)
	var2_0(arg0_20.rtViewport, true)
end

local function var3_0(arg0_21, arg1_21)
	local var0_21 = arg1_21.pos - arg0_21.pos
	local var1_21 = {}

	for iter0_21 = 1, 2 do
		var1_21[iter0_21] = {}
		var1_21[iter0_21][1] = arg0_21.colliderSize[iter0_21][1] - arg1_21.colliderSize[iter0_21][2]
		var1_21[iter0_21][2] = arg0_21.colliderSize[iter0_21][2] - arg1_21.colliderSize[iter0_21][1]
	end

	return var1_21[1][1] < var0_21.x and var0_21.x < var1_21[1][2] and var1_21[2][1] < var0_21.y and var0_21.y < var1_21[2][2]
end

function var0_0.OnTimer(arg0_22, arg1_22)
	arg0_22.timeCount = arg0_22.timeCount + arg1_22

	if arg0_22.timeCount > arg0_22.timeAll then
		arg0_22:EndGame(1)

		return
	end

	if arg0_22.target.invincibleTime then
		arg0_22.target:UpdateInvincibility(arg1_22)
	end

	local var0_22 = NewPos(0, 0)
	local var1_22 = arg0_22:GetSpeed(RacingMiniGameConfig.BOOST_RATE[not arg0_22.target.isBlock and arg0_22.boost and 2 or 1] * arg1_22)

	var0_22.x = var1_22 * arg1_22

	if not arg0_22.target.isBlock then
		if var1_22 > 0 then
			if arg0_22.up then
				var0_22.y = var0_22.y + 1
			end

			if arg0_22.down then
				var0_22.y = var0_22.y - 1
			end

			var0_22.y = var0_22.y * arg0_22.singleHeight / RacingMiniGameConfig.Y_COVER_TIME * (arg0_22.target.isVertigo and RacingMiniGameConfig.Y_OBSTACLE_REDUCE or 1) * arg1_22

			if arg0_22.target.state == "base" and arg0_22.boost then
				arg0_22.target:Show("accel")
			end
		elseif not arg0_22.target.isVertigo and arg0_22.target.state ~= "base" then
			arg0_22.target:Show("base")
		end
	end

	arg0_22.target:UpdatePos(var0_22 * NewPos(0, 1), arg0_22.singleHeight)
	setParent(arg0_22.target.rt, arg0_22.rtMainContent:Find(math.clamp(math.floor((arg0_22.target.pos.y + arg0_22.singleHeight) * 3 / 2 / arg0_22.singleHeight) - 1, -1, 1) - 1))

	local var2_22 = 1

	while var2_22 <= #arg0_22.queue do
		local var3_22 = arg0_22.queue[var2_22]

		var3_22:UpdatePos(var0_22 * NewPos(-1, 0))

		if not var3_22.isTriggered and var3_22.colliderSize and var3_0(var3_22, arg0_22.target) then
			var3_22:Trigger(arg0_22.target)
		end

		if var3_22.pos.x < -arg0_22.bgSingleSize then
			var3_22:Clear()
		else
			var2_22 = var2_22 + 1
		end
	end

	local var4_22 = arg0_22.rtBgContent.anchoredPosition.x - var0_22.x

	if var4_22 < -arg0_22.bgSingleSize / 2 then
		var4_22 = var4_22 + arg0_22.bgSingleSize
	end

	setAnchoredPosition(arg0_22.rtBgContent, {
		x = var4_22
	})

	arg0_22.chargeDis = arg0_22.chargeDis - var0_22.x

	if arg0_22.chargeDis <= 0 then
		arg0_22:CreateNewObject()
	end

	arg0_22.disCount = arg0_22.disCount + var0_22.x

	arg0_22:UpdateDisplay()
end

function var0_0.UpdateDisplay(arg0_23)
	local var0_23 = arg0_23.timeAll - arg0_23.timeCount

	setText(arg0_23.rtTime:Find("Text"), string.format("%02d:%02ds", math.floor(var0_23), math.floor((var0_23 - math.floor(var0_23)) * 100)))

	local var1_23 = arg0_23.disCount / 20

	setText(arg0_23.rtDis, string.format("%.2fm", var1_23 - var1_23 % 0.01))

	local var2_23 = RacingMiniGameConfig.BUOY_POWER_LIST
	local var3_23 = RacingMiniGameConfig.BUOY_POS_LIST
	local var4_23

	for iter0_23, iter1_23 in ipairs(var2_23) do
		if iter1_23 >= arg0_23.enginePower then
			var4_23 = iter0_23

			break
		end
	end

	setAnchoredPosition(arg0_23.rtPower:Find("range/buoy"), {
		x = var4_23 > 1 and var3_23[var4_23 - 1] + (arg0_23.enginePower - var2_23[var4_23 - 1]) / (var2_23[var4_23] - var2_23[var4_23 - 1]) * (var3_23[var4_23] - var3_23[var4_23 - 1]) or 0
	})

	if arg0_23.target.isVertigo then
		var4_23 = 1
	end

	for iter2_23, iter3_23 in ipairs(arg0_23.target.effectList) do
		setActive(iter3_23, var4_23 - 1 == iter2_23)
	end

	local var5_23 = RacingMiniGameConfig.FRIEND_DIS_LIST

	arg0_23.friendIndex = defaultValue(arg0_23.friendIndex, 1)

	while arg0_23.friendIndex < #var5_23 and var5_23[arg0_23.friendIndex + 1] < arg0_23.disCount / 20 do
		arg0_23.friendIndex = arg0_23.friendIndex + 1
		arg0_23.friendDirty = true
	end

	if arg0_23.friendDirty then
		arg0_23.friendDirty = false

		while #arg0_23.rankData > 0 and arg0_23.rankData[1].score / 100 < var5_23[arg0_23.friendIndex] do
			table.remove(arg0_23.rankData, 1)
		end

		local var6_23

		for iter4_23, iter5_23 in ipairs(arg0_23.rankData) do
			if arg0_23.friendIndex == #var5_23 or iter5_23.score / 100 < var5_23[arg0_23.friendIndex + 1] then
				var6_23 = iter4_23
			else
				break
			end
		end

		setActive(arg0_23.rtFriend, var6_23)

		if var6_23 then
			arg0_23.friendInfo = arg0_23.rankData[math.random(var6_23)]
		else
			arg0_23.friendInfo = nil
		end

		if arg0_23.friendInfo then
			setText(arg0_23.rtFriend:Find("Text"), arg0_23.friendInfo.name)
			setText(arg0_23.rtFriend:Find("point"), string.format("%.2fm", arg0_23.friendInfo.score / 100))
		end
	end
end

local var4_0 = {
	TrafficCone = "roadblocks",
	Mire = "mire",
	Roadblock = "roadblocks",
	SpeedBumps = "speed_bumps",
	Bomb = "roadblocks",
	MoreTime = "more_time",
	Invincibility = "invincibility"
}

function var0_0.CreateNewObject(arg0_24)
	local var0_24

	for iter0_24, iter1_24 in ipairs(RacingMiniGameConfig.FIELD_CONFIG) do
		if arg0_24.timeCount < iter1_24.time then
			break
		else
			var0_24 = iter1_24
		end
	end

	local var1_24 = {}
	local var2_24 = 0

	for iter2_24 = -1, 1 do
		arg0_24.rateDic[iter2_24] = defaultValue(arg0_24.rateDic[iter2_24], 0)

		local var3_24 = math.random() / (2 - iter2_24)
		local var4_24

		if var3_24 < arg0_24.rateDic[iter2_24] then
			var2_24 = var2_24 + 1
			var1_24[iter2_24] = true
		else
			var1_24[iter2_24] = false
		end
	end

	if var2_24 == 3 then
		var1_24[math.random(3) - 2] = false
	end

	for iter3_24 = -1, 1 do
		if var1_24[iter3_24] then
			classCfg = var0_24.obstacle_distribution
		else
			classCfg = var0_24.item_distribution
		end

		rate = math.random()

		local var5_24 = 0
		local var6_24 = 0

		for iter4_24, iter5_24 in ipairs(classCfg) do
			var6_24 = var6_24 + iter5_24[2]
		end

		local var7_24

		for iter6_24, iter7_24 in ipairs(classCfg) do
			var5_24 = var5_24 + iter7_24[2]

			if var5_24 > rate * var6_24 then
				var7_24 = iter7_24[1]

				break
			end
		end

		if var7_24 and superof(RacingMiniNameSpace[var7_24], RacingMiniNameSpace.Item) then
			if defaultValue(arg0_24.itemCountDic[var7_24], 0) < defaultValue(var0_24.item_create_limit[var7_24], 0) then
				arg0_24.itemCountDic[var7_24] = defaultValue(arg0_24.itemCountDic[var7_24], 0) + 1
			else
				var7_24 = nil
			end
		end

		if var7_24 then
			local var8_24 = RacingMiniNameSpace[var7_24].New(cloneTplTo(arg0_24.rtRes:Find(var4_0[var7_24]), arg0_24.rtMainContent:Find(iter3_24)), NewPos(arg0_24.bgSingleSize * 1.5 + arg0_24.chargeDis, iter3_24 * arg0_24.singleHeight), arg0_24)

			table.insert(arg0_24.queue, var8_24)

			arg0_24.rateDic[iter3_24] = arg0_24.rateDic[iter3_24] * var0_24.continue_reduce
		else
			arg0_24.rateDic[iter3_24] = arg0_24.rateDic[iter3_24] + var0_24.bye_plus
		end
	end

	arg0_24.chargeDis = arg0_24.chargeDis + var0_24.recharge_dis
end

function var0_0.GetSpeed(arg0_25, arg1_25)
	local var0_25
	local var1_25 = RacingMiniGameConfig.M_LIST
	local var2_25 = RacingMiniGameConfig.S_LIST

	for iter0_25 = 1, #var1_25 - 1 do
		if var1_25[iter0_25 + 1] > arg0_25.enginePower then
			var0_25 = var2_25[iter0_25] + (arg0_25.enginePower - var1_25[iter0_25]) / (var1_25[iter0_25 + 1] - var1_25[iter0_25]) * (var2_25[iter0_25 + 1] - var2_25[iter0_25])

			break
		end
	end

	var0_25 = var0_25 or var2_25[#var2_25]
	arg0_25.enginePower = math.clamp(arg0_25.enginePower + arg1_25, var1_25[1], var1_25[#var1_25])

	return var0_25 * 10
end

function var0_0.AddTime(arg0_26, arg1_26)
	arg0_26.timeAll = arg0_26.timeAll + arg1_26

	setActive(arg0_26.rtTime:Find("Text/plus"), true)
end

function var0_0.SetEnginePower(arg0_27, arg1_27)
	arg0_27.enginePower = math.min(arg0_27.enginePower, arg1_27)
end

function var0_0.willExit(arg0_28)
	if arg0_28.handle then
		UpdateBeat:RemoveListener(arg0_28.handle)
	end
end

return var0_0
