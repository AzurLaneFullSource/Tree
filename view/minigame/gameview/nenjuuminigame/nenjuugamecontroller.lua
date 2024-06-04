local var0 = class("NenjuuGameController")

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

function var0.InitTimer(arg0)
	arg0.timer = Timer.New(function()
		arg0:OnTimer(NenjuuGameConfig.TIME_INTERVAL)
	end, NenjuuGameConfig.TIME_INTERVAL, -1)

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.InitGameUI(arg0, arg1)
	arg0.rtViewport = arg1:Find("Viewport")
	arg0.rtMainContent = arg0.rtViewport:Find("MainContent")
	arg0.rtResource = arg1:Find("Resource")
	arg0.rtJoyStick = arg1:Find("Controller/bottom/joy_stick")

	local var0 = {
		"E",
		"S",
		"W",
		"N"
	}

	for iter0, iter1 in ipairs({
		"right",
		"down",
		"left",
		"up"
	}) do
		local var1 = arg0.rtJoyStick:Find(iter1):GetComponent(typeof(EventTriggerListener))

		var1:AddPointDownFunc(function()
			arg0.cacheInput = var0[iter0]
		end)
		var1:AddPointEnterFunc(function()
			if arg0.cacheInput and arg0.cacheInput ~= var0[iter0] then
				arg0.cacheInput = var0[iter0]
			end
		end)
		var1:AddPointUpFunc(function()
			if arg0.cacheInput then
				arg0.cacheInput = nil
			end
		end)
	end

	arg0.inPress = {}
	arg0.rtSkillButton = arg1:Find("Controller/bottom/skill_button")

	for iter2 = 0, 3 do
		local var2 = "Skill_" .. iter2
		local var3 = arg0.rtSkillButton:Find(var2):GetComponent(typeof(EventTriggerListener))

		var3:AddPointDownFunc(function()
			arg0.inPress[var2] = true
		end)
		var3:AddPointUpFunc(function()
			arg0.inPress[var2] = false
		end)
	end

	arg0.textTime = arg1:Find("Controller/top/panel/time/Text")
	arg0.textPoint = arg1:Find("Controller/top/panel/point/Text")
	arg0.rtCollection = arg1:Find("Controller/top/target")
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if IsUnityEditor then
		local var0 = {
			"E",
			"S",
			"W",
			"N"
		}
		local var1 = {
			"D",
			"S",
			"A",
			"W"
		}

		for iter0, iter1 in ipairs(var1) do
			if Input.GetKeyDown(KeyCode[iter1]) then
				arg0.cacheInput = var0[iter0]
			end

			if Input.GetKeyUp(KeyCode[iter1]) and arg0.cacheInput == var0[iter0] then
				arg0.cacheInput = nil
			end
		end
	end
end

function var0.InitMapConfig(arg0, arg1)
	arg0.pointRate = arg1.rate
	arg0.config = NenjuuGameConfig.GetStageConfig("Spring23Level_" .. arg1.index)

	local var0 = {}

	for iter0, iter1 in ipairs(pg.MiniGameTileMgr.GetInstance():getDataLayers("Spring23Game", "Spring23Level_" .. arg1.index)) do
		var0[iter1.name] = iter1
	end

	arg0.timeCount = arg0.config.extra_time[1]
	arg0.point = 0

	setText(arg0.textTime, string.format("%02d:%02ds", math.floor(arg0.timeCount / 60), math.floor(arg0.timeCount % 60)))
	setText(arg0.textPoint, arg0.point)
	eachChild(arg0.rtCollection, function(arg0)
		setActive(arg0, false)
	end)

	arg0.mapSize = NewPos(var0.floor.width, var0.floor.height)

	setSizeDelta(arg0.rtMainContent, arg0.mapSize * 32)

	local var1 = arg0.rtViewport.rect
	local var2 = arg0.rtMainContent.rect

	arg0.buffer = NewPos(math.max(var2.width + 192 - var1.width, 0), math.max(var2.height + 160 - var1.height, 0)) * 0.5

	for iter2, iter3 in ipairs(var0.floor.layer) do
		local var3 = NewPos((iter3.index - 1) % arg0.mapSize.x, math.floor((iter3.index - 1) / arg0.mapSize.x))

		arg0.plane[tostring(var3)] = iter3.item
	end

	local var4 = {
		["1_0"] = 0,
		["1_1"] = 5,
		["-1_0"] = 2,
		["0_-1"] = 3,
		["0_1"] = 1,
		["1_-1"] = 4,
		["-1_-1"] = 7,
		["-1_1"] = 6
	}

	for iter4 = 0, arg0.mapSize.y - 1 do
		for iter5 = 0, arg0.mapSize.x - 1 do
			local var5 = arg0.plane[iter5 .. "_" .. iter4] or "Snow"
			local var6 = arg0.rtResource:Find("plane/" .. var5)

			if not var6 then
				var6 = cloneTplTo(arg0.rtResource:Find("plane/Road"), arg0.rtMainContent:Find("plane"))

				setImageSprite(var6:Find("scale/Image"), getImageSprite(arg0.rtResource:Find("plane_sprite/" .. var5)))
			else
				var6 = cloneTplTo(var6, arg0.rtMainContent:Find("plane"))
			end

			if var6:Find("scale/Snow") then
				local function var7(arg0, arg1)
					return not arg0:InRange(NewPos(arg0, arg1)) or not arg0.plane[arg0 .. "_" .. arg1] or arg0.plane[arg0 .. "_" .. arg1] == "Snow"
				end

				for iter6 = -1, 1 do
					for iter7 = -1, 1 do
						if var7(iter5 + iter6, iter4 + iter7) and (iter6 == 0 or iter7 == 0 or not var7(iter5, iter4 + iter7) and not var7(iter5 + iter6, iter4)) then
							setActive(var6:Find("scale/Snow/" .. var4[iter6 .. "_" .. iter7]), true)
						end
					end
				end
			end
		end
	end

	for iter8, iter9 in ipairs(var0.item.layer) do
		local var8 = NewPos((iter9.index - 1) % arg0.mapSize.x, math.floor((iter9.index - 1) / arg0.mapSize.x))
		local var9 = arg0:CreateTarget({
			name = iter9.item,
			pos = var8
		})
	end

	for iter10, iter11 in ipairs(var0.character.layer) do
		local var10 = NewPos((iter11.index - 1) % arg0.mapSize.x, math.floor((iter11.index - 1) / arg0.mapSize.x))
		local var11 = {
			name = iter11.item,
			pos = var10
		}

		switch(var11.name, {
			FuShun = function()
				var11.level = arg1.FuShun.level
				var11.itemType = arg1.FuShun.item
				arg0.moveFuShun = arg0:CreateTarget(var11)
			end,
			Nenjuu = function()
				var11.abilitys = arg1.Nenjuu
				arg0.moveNenjuu = arg0:CreateTarget(var11)
			end
		})
	end

	arg0.wave = 0
	arg0.itemCount = 0
end

function var0.CheckWave(arg0)
	if arg0.itemCount > 0 then
		return
	end

	if arg0.wave < #arg0.config.wave then
		arg0.wave = arg0.wave + 1

		local var0, var1, var2 = unpack(arg0.config.wave[arg0.wave])

		arg0.itemType = var0
		arg0.itemCount = var1

		local var3 = {}

		for iter0 = 0, arg0.mapSize.x - 1 do
			for iter1 = 0, arg0.mapSize.y - 1 do
				local var4 = NewPos(iter0, iter1)

				if arg0:Moveable(var4, true) and not arg0.hideMap[tostring(var4)] then
					table.insert(var3, var4)
				end
			end
		end

		for iter2 = 1, arg0.itemCount do
			local var5

			repeat
				var5 = math.random(#var3)

				local var6 = 0

				for iter3 = -1, 1 do
					for iter4 = -1, 1 do
						local var7 = var3[var5] + NewPos(iter3, iter4)

						if arg0:InRange(var7) and underscore.any(arg0.map[tostring(var7)], function(arg0)
							return arg0.class == NenjuuGameNameSpace.TargetItem
						end) then
							var6 = var6 + 1
						end
					end
				end
			until var6 < 7

			local var8 = table.remove(var3, var5)

			arg0:CreateTarget({
				name = var0,
				pos = var8,
				point = var2
			})
		end

		eachChild(arg0.rtCollection, function(arg0)
			setActive(arg0, arg0.name == arg0.itemType)
		end)
	else
		arg0.point = arg0.point + arg0.config.extra_time[2] * arg0.pointRate

		setText(arg0.textPoint, arg0.point)
		arg0:EndGame(true)
	end
end

function var0.InRange(arg0, arg1)
	return arg1.x >= 0 and arg1.x < arg0.mapSize.x and arg1.y >= 0 and arg1.y < arg0.mapSize.y
end

function var0.Moveable(arg0, arg1, arg2, arg3)
	if not arg0:InRange(arg1) then
		return false
	else
		return underscore.all(arg0.map[tostring(arg1)], function(arg0)
			return arg0:Moveable() or arg2 and arg0:BreakMoveable() or arg3 and isa(arg0, NenjuuGameNameSpace.TargetMove)
		end)
	end
end

function var0.CreateTarget(arg0, arg1)
	local var0, var1, var2 = NenjuuGameConfig.GetCreateConfig(arg1)

	if not var0 then
		return
	end

	local var3

	if arg1.parent then
		var3 = cloneTplTo(arg0.rtResource:Find(var1), arg1.parent)
	else
		var3 = cloneTplTo(arg0.rtResource:Find(var1), arg0.rtMainContent:Find(var2))
	end

	local var4 = var0.New(arg0, var3, arg1)

	if var4:InTimeLine() then
		table.insert(arg0.timeFlow, var4)
	end

	return var4
end

function var0.DestoryTarget(arg0, arg1)
	arg0.dirtyMap = true

	table.removebyvalue(arg0.map[tostring(arg1.pos)], arg1)

	if arg1:InTimeLine() then
		table.removebyvalue(arg0.timeFlow, arg1)
	end

	Destroy(arg1._tf)

	arg1 = nil
end

function var0.ResetGame(arg0)
	for iter0, iter1 in ipairs({
		"plane",
		"object",
		"effect",
		"character"
	}) do
		eachChild(arg0.rtMainContent:Find(iter1), function(arg0)
			Destroy(arg0)
		end)
	end

	arg0.map = setmetatable({}, {
		__index = function(arg0, arg1)
			arg0[arg1] = {}

			return arg0[arg1]
		end
	})
	arg0.hideMap = {}
	arg0.plane = {}
	arg0.cacheInput = nil
	arg0.timeQueue = {}
	arg0.timeFlow = {}
	arg0.moveFuShun = nil
	arg0.moveNenjuu = nil
	arg0.moveDoppel = nil
	arg0.wayfindCache = {}
end

function var0.ReadyGame(arg0, arg1)
	arg0:InitMapConfig(arg1)
	arg0:UpdateSkillButtons()
	arg0:PauseGame()
end

function var0.StartGame(arg0)
	arg0.isStart = true

	arg0:CheckWave()
	arg0:ResumeGame()
end

function var0.EndGame(arg0, arg1)
	arg0.isStart = false

	arg0:PauseGame()
	arg0.binder:openUI("result")
end

function var0.ResumeGame(arg0)
	arg0.isPause = false

	arg0.timer:Start()
	var1(arg0.rtMainContent, 1)
end

function var0.PauseGame(arg0)
	arg0.isPause = true

	arg0.timer:Stop()
	var1(arg0.rtMainContent, 0)
end

function var0.OnTimer(arg0, arg1)
	arg0.timeCount = arg0.timeCount - arg1

	setText(arg0.textTime, string.format("%02d:%02ds", math.floor(arg0.timeCount / 60), math.floor(arg0.timeCount % 60)))

	if arg0.timeCount <= 0 then
		arg0:EndGame()

		return
	end

	for iter0, iter1 in ipairs(arg0.timeFlow) do
		iter1:OnTimerUpdate(arg1)
	end

	for iter2, iter3 in ipairs(arg0.timeQueue) do
		iter3.time = iter3.time - arg1
	end

	table.sort(arg0.timeQueue, CompareFuncs({
		function(arg0)
			return -arg0.time
		end
	}))

	while #arg0.timeQueue > 0 and arg0.timeQueue[#arg0.timeQueue].time <= 0 do
		table.remove(arg0.timeQueue).func()
	end

	arg0:UpdateSkillButtons()
end

function var0.UpdateSkillButtons(arg0)
	for iter0, iter1 in ipairs(arg0.moveFuShun:CalcSkillCDs()) do
		local var0 = arg0.rtSkillButton:Find("Skill_" .. iter0 - 1)

		eachChild(var0:Find("icon"), function(arg0)
			setActive(arg0, arg0.name == iter1.icon)
		end)

		if not iter1.cd then
			setActive(var0:Find("cd"), false)
			setActive(var0:Find("lock"), true)
		elseif iter1.cd == true then
			setActive(var0:Find("cd"), true)
			setFillAmount(var0:Find("cd"), 1)
			setText(var0:Find("cd/Text"), "")
			setActive(var0:Find("lock"), false)
		elseif iter1.cd > 0 then
			setActive(var0:Find("cd"), true)
			setFillAmount(var0:Find("cd"), iter1.rate)
			setText(var0:Find("cd/Text"), math.ceil(iter1.cd) .. "s")
			setActive(var0:Find("lock"), false)
		else
			setActive(var0:Find("cd"), false)
			setActive(var0:Find("lock"), false)
		end
	end
end

function var0.GetCacheInput(arg0, arg1)
	if arg1 then
		local var0 = arg0.cacheInput

		arg0.cacheInput = nil

		return var0
	else
		return arg0.cacheInput
	end
end

function var0.GetPressInput(arg0, arg1)
	return arg0.inPress[arg1]
end

function var0.UpdateTargetPos(arg0, arg1, arg2, arg3)
	arg0.dirtyMap = true

	local var0 = arg1:GetSize()

	for iter0 = 0, var0.x - 1 do
		for iter1 = 0, var0.y - 1 do
			local var1 = NewPos(iter0, iter1)

			if arg2 then
				table.removebyvalue(arg0.map[tostring(arg2 + var1)], arg1)
			end

			table.insert(arg0.map[tostring(arg3 + var1)], arg1)
		end
	end

	if arg1.canHide then
		for iter2 = 0, var0.x - 1 do
			local var2 = arg3 + NewPos(iter2, -1)

			if arg0:InRange(var2) then
				arg0.hideMap[tostring(var2)] = true
			end
		end
	end
end

function var0.WindowFocrus(arg0, arg1)
	setAnchoredPosition(arg0.rtMainContent, {
		x = math.clamp(-arg1.x, -arg0.buffer.x, arg0.buffer.x),
		y = math.clamp(-arg1.y, -arg0.buffer.y - 16, arg0.buffer.y - 16)
	})
end

function var0.CheckIce(arg0, arg1)
	if not arg0:InRange(arg1) then
		return false
	else
		return underscore.detect(arg0.map[tostring(arg1)], function(arg0)
			return arg0.class == NenjuuGameNameSpace.TargetIce
		end)
	end
end

function var0.BuildIce(arg0, arg1)
	local var0

	local function var1()
		arg1.pos = arg1.pos + arg1.dirPos

		if arg0:Moveable(arg1.pos) then
			arg0:CreateTarget({
				name = "Ice",
				create = true,
				pos = arg1.pos
			})

			arg1.power = arg1.power - 1

			if arg1.power > 0 then
				table.insert(arg0.timeQueue, {
					time = 0.035,
					func = var1
				})
			end
		end
	end

	table.insert(arg0.timeQueue, {
		time = 0,
		func = var1
	})
end

function var0.BreakIce(arg0, arg1)
	arg1.power = arg1.power or math.max(arg0.mapSize.x, arg0.mapSize.y)

	local var0

	local function var1()
		arg1.pos = arg1.pos + arg1.dirPos

		if arg0:OnlyBreakIce(arg1.pos) then
			arg0:CreateTarget({
				name = "EF_Break_" .. arg1.dir,
				pos = arg1.pos
			})

			arg1.power = arg1.power - 1

			if arg1.power > 0 then
				table.insert(arg0.timeQueue, {
					time = 0.035,
					func = var1
				})
			end
		end
	end

	table.insert(arg0.timeQueue, {
		time = 0,
		func = var1
	})
end

function var0.OnlyBreakIce(arg0, arg1)
	local var0 = arg0:CheckIce(arg1)

	if var0 and not var0.isLost then
		var0:Break()

		return true
	else
		return false
	end
end

local var2 = {
	{
		1,
		-1
	},
	{
		1,
		1
	},
	{
		-1,
		1
	},
	{
		-1,
		-1
	}
}
local var3 = {
	E = 2,
	S = 3,
	N = 1,
	W = 4
}

function var0.BuildBomb(arg0, arg1)
	local var0 = 0

	for iter0 = 1, 2 do
		for iter1 = 1, 4 do
			local var1 = var2[(var3[arg1.dir] + iter1 + 2) % 4 + 1]

			for iter2 = -iter0, iter0 - 1 do
				var0 = var0 + 1

				local var2 = {
					iter0,
					iter2
				}
				local var3 = arg1.pos + NewPos(var1[1] * var2[iter1 % 2 + 1], var1[2] * var2[(iter1 + 1) % 2 + 1])

				if arg0:Moveable(var3, false, true) then
					table.insert(arg0.timeQueue, {
						time = (var0 - 1) * 0.015,
						func = function()
							arg0:CreateTarget({
								name = "Bomb",
								pos = var3
							})
						end
					})
				end
			end
		end
	end
end

function var0.CheckMelt(arg0, arg1)
	return string.split(arg0.plane[tostring(arg1)], "_")[2] == "warm"
end

function var0.ScareEnemy(arg0, arg1)
	for iter0, iter1 in ipairs({
		arg0.moveNenjuu,
		arg0.moveDoppel
	}) do
		local var0 = arg1.pos - iter1.realPos

		if math.abs(var0.x) + math.abs(var0.y) <= arg1.range then
			iter1:BeScare()
		end
	end
end

function var0.AttackCheck(arg0, arg1)
	local var0 = NewPos(-0.5, -0.5)
	local var1 = NewPos(0.5, 0.5)
	local var2 = arg1.dirPos.x + arg1.dirPos.y

	if arg1.dirPos.x == 0 then
		var0.y = var0.y + var2 * 0.5 + (var2 - 1) * 0
		var1.y = var1.y + var2 * 0.5 + (var2 + 1) * 0
	elseif arg1.dirPos.y == 0 then
		var0.x = var0.x + var2 * 0.5 + (var2 - 1) * 0
		var1.x = var1.x + var2 * 0.5 + (var2 + 1) * 0
	else
		assert(false)
	end

	local var3 = arg0.moveFuShun.realPos - arg1.pos

	return math.clamp(var3.x, var0.x, var1.x) == var3.x and math.clamp(var3.y, var0.y, var1.y) == var3.y
end

function var0.EnemyAttack(arg0, arg1)
	if arg0:AttackCheck(arg1) then
		arg0.moveFuShun:EnemyHit(arg1.pos)
	end
end

function var0.GetDecoyPos(arg0, arg1, arg2)
	local var0 = {}
	local var1 = NenjuuGameConfig.DECOY_RANGE

	for iter0 = -var1, var1 do
		for iter1 = -var1, var1 do
			local var2 = arg1 + NewPos(iter0, iter1)

			if arg0:Moveable(var2) then
				table.insert(var0, var2)
			end
		end
	end

	return var0[math.random(#var0)]
end

function var0.BuildDecoy(arg0, arg1)
	arg0:CreateTarget({
		name = "Decoy",
		pos = arg1
	})
end

local var4 = {
	{
		1,
		0
	},
	{
		0,
		1
	},
	{
		-1,
		0
	},
	{
		0,
		-1
	}
}

function var0.GetWayfindingMap(arg0, arg1, arg2)
	if not arg0.dirtyMap and arg0.wayfindCache[arg2] and (arg0.wayfindCache[arg2].inLantern and arg0.wayfindCache[arg2].inLantern > 0 or false) == (arg0.moveFuShun.inLantern and arg0.moveFuShun.inLantern > 0 or false) and arg0.wayfindCache[arg2].pos == arg0.moveFuShun.pos and arg0.wayfindCache[arg2].basePos == arg1 then
		return arg0.wayfindCache[arg2].map
	end

	arg0.dirtyMap = false

	local var0 = {}
	local var1 = arg0.moveFuShun.pos + arg0.moveFuShun:GetDirPos()

	if arg2 and arg0:InRange(var1) then
		table.insert(var0, var1)
	else
		table.insert(var0, arg0.moveFuShun.pos)
	end

	local var2 = {
		[tostring(var0[1])] = {
			value = 0,
			pos = var0[1]
		}
	}
	local var3 = 0

	while var3 < #var0 do
		var3 = var3 + 1

		local var4 = var0[var3]
		local var5 = var2[tostring(var4)].value + 1

		for iter0, iter1 in ipairs(var4) do
			local var6 = var4 + NewPos(unpack(iter1))

			if var6 == arg1 or arg0:Moveable(var6, not arg2) then
				local var7 = tostring(var6)

				if not var2[var7] then
					var2[var7] = {
						pos = var6,
						value = var5,
						last = var4
					}

					table.insert(var0, var6)
				elseif var5 < var2[var7].value then
					var2[var7].value = var5
					var2[var7].last = var4
				end
			end
		end
	end

	if arg0.moveFuShun.inLantern then
		local var8 = NenjuuGameConfig.LANTERN_RANGE

		for iter2 = -var8, var8 do
			for iter3 = -var8, var8 do
				local var9 = var2[tostring(arg0.moveFuShun.pos + NewPos(iter2, iter3))]

				if var9 then
					var9.lightValue = 1000 - var9.value
				end
			end
		end
	end

	arg0.wayfindCache[arg2] = {
		pos = arg0.moveFuShun.pos,
		inLantern = arg0.moveFuShun.inLantern,
		basePos = arg1,
		map = var2
	}

	return var2
end

function var0.GetTeleportTargetPos(arg0, arg1, arg2)
	local var0 = arg0.moveFuShun.pos - arg2
	local var1 = math.random(4)
	local var2 = {}

	for iter0, iter1 in pairs(arg1) do
		local var3 = iter1.pos - arg2

		table.insert(var2, {
			pos = iter1.pos,
			value = iter1.value,
			mDis = math.abs(var3.x) + math.abs(var3.y)
		})
	end

	table.sort(var2, CompareFuncs({
		function(arg0)
			return math.abs(arg0.value - var1)
		end,
		function(arg0)
			return arg0.mDis
		end
	}))

	return var2[1].pos
end

function var0.StealthCheck(arg0, arg1)
	local var0 = arg0.moveFuShun.pos - arg1

	return math.abs(var0.x) + math.abs(var0.y) < 10
end

function var0.BuildTeleportSign(arg0, arg1)
	arg0:CreateTarget({
		name = "SignWarp",
		pos = arg1.pos,
		time = arg1.time
	})
end

function var0.GetEnemyEffect(arg0, arg1)
	return arg0.moveNenjuu:CheckAbility(arg1)
end

function var0.BuildBlackHole(arg0)
	local var0 = {}

	for iter0 = 1, arg0.mapSize.x do
		for iter1 = 1, arg0.mapSize.y do
			local var1 = NewPos(iter0 - 1, iter1 - 1)

			if arg0:Moveable(var1, true) then
				table.insert(var0, var1)
			end
		end
	end

	local var2 = var0[math.random(#var0)]

	arg0:CreateTarget({
		time = 20,
		name = "BlackHole",
		pos = var2
	})
end

function var0.InBlackHoleRange(arg0, arg1, arg2)
	if arg2 then
		local var0 = arg0:InRange(arg1) and underscore.detect(arg0.map[tostring(arg1)], function(arg0)
			return arg0.class == NenjuuGameNameSpace.TargetBlackHole
		end)

		if var0 and not var0.isLost then
			var0:BeTrigger()

			return true
		else
			return false
		end
	else
		local var1 = NenjuuGameConfig.BLACK_HOLE_RANGE

		for iter0 = -var1, var1 do
			for iter1 = -var1, var1 do
				local var2 = arg1 + NewPos(iter0, iter1)

				if arg0:InRange(var2) and underscore.any(arg0.map[tostring(var2)], function(arg0)
					return arg0.class == NenjuuGameNameSpace.TargetBlackHole
				end) then
					return true
				end
			end
		end
	end
end

function var0.BuildDoppelgangers(arg0, arg1)
	for iter0 = -2, 2 do
		for iter1 = -2, 2 do
			local var0 = arg1 + NewPos(iter0, iter1)

			if arg0:Moveable(var0) then
				arg0.moveDoppel = arg0:CreateTarget({
					isDoppel = true,
					name = "Nenjuu_Doppelgangers",
					pos = var0,
					abilitys = {}
				})

				return
			end
		end
	end
end

function var0.EatItem(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.map[tostring(arg1)]) do
		if iter1.class == NenjuuGameNameSpace.TargetItem then
			arg0:DestoryTarget(iter1)

			arg0.itemCount = arg0.itemCount - 1
			arg0.point = arg0.point + iter1.point * arg0.pointRate

			setText(arg0.textPoint, arg0.point)
			arg0.moveFuShun:PopPoint(iter1.point * arg0.pointRate)

			if arg0.itemCount == 0 then
				arg0:CheckWave()
			end
		end
	end
end

return var0
