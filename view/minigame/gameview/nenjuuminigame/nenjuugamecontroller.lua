local var0_0 = class("NenjuuGameController")

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

function var0_0.InitTimer(arg0_3)
	arg0_3.timer = Timer.New(function()
		arg0_3:OnTimer(NenjuuGameConfig.TIME_INTERVAL)
	end, NenjuuGameConfig.TIME_INTERVAL, -1)

	if not arg0_3.handle then
		arg0_3.handle = UpdateBeat:CreateListener(arg0_3.Update, arg0_3)
	end

	UpdateBeat:AddListener(arg0_3.handle)
end

function var0_0.InitGameUI(arg0_5, arg1_5)
	arg0_5.rtViewport = arg1_5:Find("Viewport")
	arg0_5.rtMainContent = arg0_5.rtViewport:Find("MainContent")
	arg0_5.rtResource = arg1_5:Find("Resource")
	arg0_5.rtJoyStick = arg1_5:Find("Controller/bottom/joy_stick")

	local var0_5 = {
		"E",
		"S",
		"W",
		"N"
	}

	for iter0_5, iter1_5 in ipairs({
		"right",
		"down",
		"left",
		"up"
	}) do
		local var1_5 = arg0_5.rtJoyStick:Find(iter1_5):GetComponent(typeof(EventTriggerListener))

		var1_5:AddPointDownFunc(function()
			arg0_5.cacheInput = var0_5[iter0_5]
		end)
		var1_5:AddPointEnterFunc(function()
			if arg0_5.cacheInput and arg0_5.cacheInput ~= var0_5[iter0_5] then
				arg0_5.cacheInput = var0_5[iter0_5]
			end
		end)
		var1_5:AddPointUpFunc(function()
			if arg0_5.cacheInput then
				arg0_5.cacheInput = nil
			end
		end)
	end

	arg0_5.inPress = {}
	arg0_5.rtSkillButton = arg1_5:Find("Controller/bottom/skill_button")

	for iter2_5 = 0, 3 do
		local var2_5 = "Skill_" .. iter2_5
		local var3_5 = arg0_5.rtSkillButton:Find(var2_5):GetComponent(typeof(EventTriggerListener))

		var3_5:AddPointDownFunc(function()
			arg0_5.inPress[var2_5] = true
		end)
		var3_5:AddPointUpFunc(function()
			arg0_5.inPress[var2_5] = false
		end)
	end

	arg0_5.textTime = arg1_5:Find("Controller/top/panel/time/Text")
	arg0_5.textPoint = arg1_5:Find("Controller/top/panel/point/Text")
	arg0_5.rtCollection = arg1_5:Find("Controller/top/target")
end

function var0_0.Update(arg0_11)
	arg0_11:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_12)
	if IsUnityEditor then
		local var0_12 = {
			"E",
			"S",
			"W",
			"N"
		}
		local var1_12 = {
			"D",
			"S",
			"A",
			"W"
		}

		for iter0_12, iter1_12 in ipairs(var1_12) do
			if Input.GetKeyDown(KeyCode[iter1_12]) then
				arg0_12.cacheInput = var0_12[iter0_12]
			end

			if Input.GetKeyUp(KeyCode[iter1_12]) and arg0_12.cacheInput == var0_12[iter0_12] then
				arg0_12.cacheInput = nil
			end
		end
	end
end

function var0_0.InitMapConfig(arg0_13, arg1_13)
	arg0_13.pointRate = arg1_13.rate
	arg0_13.config = NenjuuGameConfig.GetStageConfig("Spring23Level_" .. arg1_13.index)

	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(pg.MiniGameTileMgr.GetInstance():getDataLayers("Spring23Game", "Spring23Level_" .. arg1_13.index)) do
		var0_13[iter1_13.name] = iter1_13
	end

	arg0_13.timeCount = arg0_13.config.extra_time[1]
	arg0_13.point = 0

	setText(arg0_13.textTime, string.format("%02d:%02ds", math.floor(arg0_13.timeCount / 60), math.floor(arg0_13.timeCount % 60)))
	setText(arg0_13.textPoint, arg0_13.point)
	eachChild(arg0_13.rtCollection, function(arg0_14)
		setActive(arg0_14, false)
	end)

	arg0_13.mapSize = NewPos(var0_13.floor.width, var0_13.floor.height)

	setSizeDelta(arg0_13.rtMainContent, arg0_13.mapSize * 32)

	local var1_13 = arg0_13.rtViewport.rect
	local var2_13 = arg0_13.rtMainContent.rect

	arg0_13.buffer = NewPos(math.max(var2_13.width + 192 - var1_13.width, 0), math.max(var2_13.height + 160 - var1_13.height, 0)) * 0.5

	for iter2_13, iter3_13 in ipairs(var0_13.floor.layer) do
		local var3_13 = NewPos((iter3_13.index - 1) % arg0_13.mapSize.x, math.floor((iter3_13.index - 1) / arg0_13.mapSize.x))

		arg0_13.plane[tostring(var3_13)] = iter3_13.item
	end

	local var4_13 = {
		["1_0"] = 0,
		["1_1"] = 5,
		["-1_0"] = 2,
		["0_-1"] = 3,
		["0_1"] = 1,
		["1_-1"] = 4,
		["-1_-1"] = 7,
		["-1_1"] = 6
	}

	for iter4_13 = 0, arg0_13.mapSize.y - 1 do
		for iter5_13 = 0, arg0_13.mapSize.x - 1 do
			local var5_13 = arg0_13.plane[iter5_13 .. "_" .. iter4_13] or "Snow"
			local var6_13 = arg0_13.rtResource:Find("plane/" .. var5_13)

			if not var6_13 then
				var6_13 = cloneTplTo(arg0_13.rtResource:Find("plane/Road"), arg0_13.rtMainContent:Find("plane"))

				setImageSprite(var6_13:Find("scale/Image"), getImageSprite(arg0_13.rtResource:Find("plane_sprite/" .. var5_13)))
			else
				var6_13 = cloneTplTo(var6_13, arg0_13.rtMainContent:Find("plane"))
			end

			if var6_13:Find("scale/Snow") then
				local function var7_13(arg0_15, arg1_15)
					return not arg0_13:InRange(NewPos(arg0_15, arg1_15)) or not arg0_13.plane[arg0_15 .. "_" .. arg1_15] or arg0_13.plane[arg0_15 .. "_" .. arg1_15] == "Snow"
				end

				for iter6_13 = -1, 1 do
					for iter7_13 = -1, 1 do
						if var7_13(iter5_13 + iter6_13, iter4_13 + iter7_13) and (iter6_13 == 0 or iter7_13 == 0 or not var7_13(iter5_13, iter4_13 + iter7_13) and not var7_13(iter5_13 + iter6_13, iter4_13)) then
							setActive(var6_13:Find("scale/Snow/" .. var4_13[iter6_13 .. "_" .. iter7_13]), true)
						end
					end
				end
			end
		end
	end

	for iter8_13, iter9_13 in ipairs(var0_13.item.layer) do
		local var8_13 = NewPos((iter9_13.index - 1) % arg0_13.mapSize.x, math.floor((iter9_13.index - 1) / arg0_13.mapSize.x))
		local var9_13 = arg0_13:CreateTarget({
			name = iter9_13.item,
			pos = var8_13
		})
	end

	for iter10_13, iter11_13 in ipairs(var0_13.character.layer) do
		local var10_13 = NewPos((iter11_13.index - 1) % arg0_13.mapSize.x, math.floor((iter11_13.index - 1) / arg0_13.mapSize.x))
		local var11_13 = {
			name = iter11_13.item,
			pos = var10_13
		}

		switch(var11_13.name, {
			FuShun = function()
				var11_13.level = arg1_13.FuShun.level
				var11_13.itemType = arg1_13.FuShun.item
				arg0_13.moveFuShun = arg0_13:CreateTarget(var11_13)
			end,
			Nenjuu = function()
				var11_13.abilitys = arg1_13.Nenjuu
				arg0_13.moveNenjuu = arg0_13:CreateTarget(var11_13)
			end
		})
	end

	arg0_13.wave = 0
	arg0_13.itemCount = 0
end

function var0_0.CheckWave(arg0_18)
	if arg0_18.itemCount > 0 then
		return
	end

	if arg0_18.wave < #arg0_18.config.wave then
		arg0_18.wave = arg0_18.wave + 1

		local var0_18, var1_18, var2_18 = unpack(arg0_18.config.wave[arg0_18.wave])

		arg0_18.itemType = var0_18
		arg0_18.itemCount = var1_18

		local var3_18 = {}

		for iter0_18 = 0, arg0_18.mapSize.x - 1 do
			for iter1_18 = 0, arg0_18.mapSize.y - 1 do
				local var4_18 = NewPos(iter0_18, iter1_18)

				if arg0_18:Moveable(var4_18, true) and not arg0_18.hideMap[tostring(var4_18)] then
					table.insert(var3_18, var4_18)
				end
			end
		end

		for iter2_18 = 1, arg0_18.itemCount do
			local var5_18

			repeat
				var5_18 = math.random(#var3_18)

				local var6_18 = 0

				for iter3_18 = -1, 1 do
					for iter4_18 = -1, 1 do
						local var7_18 = var3_18[var5_18] + NewPos(iter3_18, iter4_18)

						if arg0_18:InRange(var7_18) and underscore.any(arg0_18.map[tostring(var7_18)], function(arg0_19)
							return arg0_19.class == NenjuuGameNameSpace.TargetItem
						end) then
							var6_18 = var6_18 + 1
						end
					end
				end
			until var6_18 < 7

			local var8_18 = table.remove(var3_18, var5_18)

			arg0_18:CreateTarget({
				name = var0_18,
				pos = var8_18,
				point = var2_18
			})
		end

		eachChild(arg0_18.rtCollection, function(arg0_20)
			setActive(arg0_20, arg0_20.name == arg0_18.itemType)
		end)
	else
		arg0_18.point = arg0_18.point + arg0_18.config.extra_time[2] * arg0_18.pointRate

		setText(arg0_18.textPoint, arg0_18.point)
		arg0_18:EndGame(true)
	end
end

function var0_0.InRange(arg0_21, arg1_21)
	return arg1_21.x >= 0 and arg1_21.x < arg0_21.mapSize.x and arg1_21.y >= 0 and arg1_21.y < arg0_21.mapSize.y
end

function var0_0.Moveable(arg0_22, arg1_22, arg2_22, arg3_22)
	if not arg0_22:InRange(arg1_22) then
		return false
	else
		return underscore.all(arg0_22.map[tostring(arg1_22)], function(arg0_23)
			return arg0_23:Moveable() or arg2_22 and arg0_23:BreakMoveable() or arg3_22 and isa(arg0_23, NenjuuGameNameSpace.TargetMove)
		end)
	end
end

function var0_0.CreateTarget(arg0_24, arg1_24)
	local var0_24, var1_24, var2_24 = NenjuuGameConfig.GetCreateConfig(arg1_24)

	if not var0_24 then
		return
	end

	local var3_24

	if arg1_24.parent then
		var3_24 = cloneTplTo(arg0_24.rtResource:Find(var1_24), arg1_24.parent)
	else
		var3_24 = cloneTplTo(arg0_24.rtResource:Find(var1_24), arg0_24.rtMainContent:Find(var2_24))
	end

	local var4_24 = var0_24.New(arg0_24, var3_24, arg1_24)

	if var4_24:InTimeLine() then
		table.insert(arg0_24.timeFlow, var4_24)
	end

	return var4_24
end

function var0_0.DestoryTarget(arg0_25, arg1_25)
	arg0_25.dirtyMap = true

	table.removebyvalue(arg0_25.map[tostring(arg1_25.pos)], arg1_25)

	if arg1_25:InTimeLine() then
		table.removebyvalue(arg0_25.timeFlow, arg1_25)
	end

	Destroy(arg1_25._tf)

	arg1_25 = nil
end

function var0_0.ResetGame(arg0_26)
	for iter0_26, iter1_26 in ipairs({
		"plane",
		"object",
		"effect",
		"character"
	}) do
		eachChild(arg0_26.rtMainContent:Find(iter1_26), function(arg0_27)
			Destroy(arg0_27)
		end)
	end

	arg0_26.map = setmetatable({}, {
		__index = function(arg0_28, arg1_28)
			arg0_28[arg1_28] = {}

			return arg0_28[arg1_28]
		end
	})
	arg0_26.hideMap = {}
	arg0_26.plane = {}
	arg0_26.cacheInput = nil
	arg0_26.timeQueue = {}
	arg0_26.timeFlow = {}
	arg0_26.moveFuShun = nil
	arg0_26.moveNenjuu = nil
	arg0_26.moveDoppel = nil
	arg0_26.wayfindCache = {}
end

function var0_0.ReadyGame(arg0_29, arg1_29)
	arg0_29:InitMapConfig(arg1_29)
	arg0_29:UpdateSkillButtons()
	arg0_29:PauseGame()
end

function var0_0.StartGame(arg0_30)
	arg0_30.isStart = true

	arg0_30:CheckWave()
	arg0_30:ResumeGame()
end

function var0_0.EndGame(arg0_31, arg1_31)
	arg0_31.isStart = false

	arg0_31:PauseGame()
	arg0_31.binder:openUI("result")
end

function var0_0.ResumeGame(arg0_32)
	arg0_32.isPause = false

	arg0_32.timer:Start()
	var1_0(arg0_32.rtMainContent, 1)
end

function var0_0.PauseGame(arg0_33)
	arg0_33.isPause = true

	arg0_33.timer:Stop()
	var1_0(arg0_33.rtMainContent, 0)
end

function var0_0.OnTimer(arg0_34, arg1_34)
	arg0_34.timeCount = arg0_34.timeCount - arg1_34

	setText(arg0_34.textTime, string.format("%02d:%02ds", math.floor(arg0_34.timeCount / 60), math.floor(arg0_34.timeCount % 60)))

	if arg0_34.timeCount <= 0 then
		arg0_34:EndGame()

		return
	end

	for iter0_34, iter1_34 in ipairs(arg0_34.timeFlow) do
		iter1_34:OnTimerUpdate(arg1_34)
	end

	for iter2_34, iter3_34 in ipairs(arg0_34.timeQueue) do
		iter3_34.time = iter3_34.time - arg1_34
	end

	table.sort(arg0_34.timeQueue, CompareFuncs({
		function(arg0_35)
			return -arg0_35.time
		end
	}))

	while #arg0_34.timeQueue > 0 and arg0_34.timeQueue[#arg0_34.timeQueue].time <= 0 do
		table.remove(arg0_34.timeQueue).func()
	end

	arg0_34:UpdateSkillButtons()
end

function var0_0.UpdateSkillButtons(arg0_36)
	for iter0_36, iter1_36 in ipairs(arg0_36.moveFuShun:CalcSkillCDs()) do
		local var0_36 = arg0_36.rtSkillButton:Find("Skill_" .. iter0_36 - 1)

		eachChild(var0_36:Find("icon"), function(arg0_37)
			setActive(arg0_37, arg0_37.name == iter1_36.icon)
		end)

		if not iter1_36.cd then
			setActive(var0_36:Find("cd"), false)
			setActive(var0_36:Find("lock"), true)
		elseif iter1_36.cd == true then
			setActive(var0_36:Find("cd"), true)
			setFillAmount(var0_36:Find("cd"), 1)
			setText(var0_36:Find("cd/Text"), "")
			setActive(var0_36:Find("lock"), false)
		elseif iter1_36.cd > 0 then
			setActive(var0_36:Find("cd"), true)
			setFillAmount(var0_36:Find("cd"), iter1_36.rate)
			setText(var0_36:Find("cd/Text"), math.ceil(iter1_36.cd) .. "s")
			setActive(var0_36:Find("lock"), false)
		else
			setActive(var0_36:Find("cd"), false)
			setActive(var0_36:Find("lock"), false)
		end
	end
end

function var0_0.GetCacheInput(arg0_38, arg1_38)
	if arg1_38 then
		local var0_38 = arg0_38.cacheInput

		arg0_38.cacheInput = nil

		return var0_38
	else
		return arg0_38.cacheInput
	end
end

function var0_0.GetPressInput(arg0_39, arg1_39)
	return arg0_39.inPress[arg1_39]
end

function var0_0.UpdateTargetPos(arg0_40, arg1_40, arg2_40, arg3_40)
	arg0_40.dirtyMap = true

	local var0_40 = arg1_40:GetSize()

	for iter0_40 = 0, var0_40.x - 1 do
		for iter1_40 = 0, var0_40.y - 1 do
			local var1_40 = NewPos(iter0_40, iter1_40)

			if arg2_40 then
				table.removebyvalue(arg0_40.map[tostring(arg2_40 + var1_40)], arg1_40)
			end

			table.insert(arg0_40.map[tostring(arg3_40 + var1_40)], arg1_40)
		end
	end

	if arg1_40.canHide then
		for iter2_40 = 0, var0_40.x - 1 do
			local var2_40 = arg3_40 + NewPos(iter2_40, -1)

			if arg0_40:InRange(var2_40) then
				arg0_40.hideMap[tostring(var2_40)] = true
			end
		end
	end
end

function var0_0.WindowFocrus(arg0_41, arg1_41)
	setAnchoredPosition(arg0_41.rtMainContent, {
		x = math.clamp(-arg1_41.x, -arg0_41.buffer.x, arg0_41.buffer.x),
		y = math.clamp(-arg1_41.y, -arg0_41.buffer.y - 16, arg0_41.buffer.y - 16)
	})
end

function var0_0.CheckIce(arg0_42, arg1_42)
	if not arg0_42:InRange(arg1_42) then
		return false
	else
		return underscore.detect(arg0_42.map[tostring(arg1_42)], function(arg0_43)
			return arg0_43.class == NenjuuGameNameSpace.TargetIce
		end)
	end
end

function var0_0.BuildIce(arg0_44, arg1_44)
	local var0_44

	local function var1_44()
		arg1_44.pos = arg1_44.pos + arg1_44.dirPos

		if arg0_44:Moveable(arg1_44.pos) then
			arg0_44:CreateTarget({
				name = "Ice",
				create = true,
				pos = arg1_44.pos
			})

			arg1_44.power = arg1_44.power - 1

			if arg1_44.power > 0 then
				table.insert(arg0_44.timeQueue, {
					time = 0.035,
					func = var1_44
				})
			end
		end
	end

	table.insert(arg0_44.timeQueue, {
		time = 0,
		func = var1_44
	})
end

function var0_0.BreakIce(arg0_46, arg1_46)
	arg1_46.power = arg1_46.power or math.max(arg0_46.mapSize.x, arg0_46.mapSize.y)

	local var0_46

	local function var1_46()
		arg1_46.pos = arg1_46.pos + arg1_46.dirPos

		if arg0_46:OnlyBreakIce(arg1_46.pos) then
			arg0_46:CreateTarget({
				name = "EF_Break_" .. arg1_46.dir,
				pos = arg1_46.pos
			})

			arg1_46.power = arg1_46.power - 1

			if arg1_46.power > 0 then
				table.insert(arg0_46.timeQueue, {
					time = 0.035,
					func = var1_46
				})
			end
		end
	end

	table.insert(arg0_46.timeQueue, {
		time = 0,
		func = var1_46
	})
end

function var0_0.OnlyBreakIce(arg0_48, arg1_48)
	local var0_48 = arg0_48:CheckIce(arg1_48)

	if var0_48 and not var0_48.isLost then
		var0_48:Break()

		return true
	else
		return false
	end
end

local var2_0 = {
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
local var3_0 = {
	E = 2,
	S = 3,
	N = 1,
	W = 4
}

function var0_0.BuildBomb(arg0_49, arg1_49)
	local var0_49 = 0

	for iter0_49 = 1, 2 do
		for iter1_49 = 1, 4 do
			local var1_49 = var2_0[(var3_0[arg1_49.dir] + iter1_49 + 2) % 4 + 1]

			for iter2_49 = -iter0_49, iter0_49 - 1 do
				var0_49 = var0_49 + 1

				local var2_49 = {
					iter0_49,
					iter2_49
				}
				local var3_49 = arg1_49.pos + NewPos(var1_49[1] * var2_49[iter1_49 % 2 + 1], var1_49[2] * var2_49[(iter1_49 + 1) % 2 + 1])

				if arg0_49:Moveable(var3_49, false, true) then
					table.insert(arg0_49.timeQueue, {
						time = (var0_49 - 1) * 0.015,
						func = function()
							arg0_49:CreateTarget({
								name = "Bomb",
								pos = var3_49
							})
						end
					})
				end
			end
		end
	end
end

function var0_0.CheckMelt(arg0_51, arg1_51)
	return string.split(arg0_51.plane[tostring(arg1_51)], "_")[2] == "warm"
end

function var0_0.ScareEnemy(arg0_52, arg1_52)
	for iter0_52, iter1_52 in ipairs({
		arg0_52.moveNenjuu,
		arg0_52.moveDoppel
	}) do
		local var0_52 = arg1_52.pos - iter1_52.realPos

		if math.abs(var0_52.x) + math.abs(var0_52.y) <= arg1_52.range then
			iter1_52:BeScare()
		end
	end
end

function var0_0.AttackCheck(arg0_53, arg1_53)
	local var0_53 = NewPos(-0.5, -0.5)
	local var1_53 = NewPos(0.5, 0.5)
	local var2_53 = arg1_53.dirPos.x + arg1_53.dirPos.y

	if arg1_53.dirPos.x == 0 then
		var0_53.y = var0_53.y + var2_53 * 0.5 + (var2_53 - 1) * 0
		var1_53.y = var1_53.y + var2_53 * 0.5 + (var2_53 + 1) * 0
	elseif arg1_53.dirPos.y == 0 then
		var0_53.x = var0_53.x + var2_53 * 0.5 + (var2_53 - 1) * 0
		var1_53.x = var1_53.x + var2_53 * 0.5 + (var2_53 + 1) * 0
	else
		assert(false)
	end

	local var3_53 = arg0_53.moveFuShun.realPos - arg1_53.pos

	return math.clamp(var3_53.x, var0_53.x, var1_53.x) == var3_53.x and math.clamp(var3_53.y, var0_53.y, var1_53.y) == var3_53.y
end

function var0_0.EnemyAttack(arg0_54, arg1_54)
	if arg0_54:AttackCheck(arg1_54) then
		arg0_54.moveFuShun:EnemyHit(arg1_54.pos)
	end
end

function var0_0.GetDecoyPos(arg0_55, arg1_55, arg2_55)
	local var0_55 = {}
	local var1_55 = NenjuuGameConfig.DECOY_RANGE

	for iter0_55 = -var1_55, var1_55 do
		for iter1_55 = -var1_55, var1_55 do
			local var2_55 = arg1_55 + NewPos(iter0_55, iter1_55)

			if arg0_55:Moveable(var2_55) then
				table.insert(var0_55, var2_55)
			end
		end
	end

	return var0_55[math.random(#var0_55)]
end

function var0_0.BuildDecoy(arg0_56, arg1_56)
	arg0_56:CreateTarget({
		name = "Decoy",
		pos = arg1_56
	})
end

local var4_0 = {
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

function var0_0.GetWayfindingMap(arg0_57, arg1_57, arg2_57)
	if not arg0_57.dirtyMap and arg0_57.wayfindCache[arg2_57] and (arg0_57.wayfindCache[arg2_57].inLantern and arg0_57.wayfindCache[arg2_57].inLantern > 0 or false) == (arg0_57.moveFuShun.inLantern and arg0_57.moveFuShun.inLantern > 0 or false) and arg0_57.wayfindCache[arg2_57].pos == arg0_57.moveFuShun.pos and arg0_57.wayfindCache[arg2_57].basePos == arg1_57 then
		return arg0_57.wayfindCache[arg2_57].map
	end

	arg0_57.dirtyMap = false

	local var0_57 = {}
	local var1_57 = arg0_57.moveFuShun.pos + arg0_57.moveFuShun:GetDirPos()

	if arg2_57 and arg0_57:InRange(var1_57) then
		table.insert(var0_57, var1_57)
	else
		table.insert(var0_57, arg0_57.moveFuShun.pos)
	end

	local var2_57 = {
		[tostring(var0_57[1])] = {
			value = 0,
			pos = var0_57[1]
		}
	}
	local var3_57 = 0

	while var3_57 < #var0_57 do
		var3_57 = var3_57 + 1

		local var4_57 = var0_57[var3_57]
		local var5_57 = var2_57[tostring(var4_57)].value + 1

		for iter0_57, iter1_57 in ipairs(var4_0) do
			local var6_57 = var4_57 + NewPos(unpack(iter1_57))

			if var6_57 == arg1_57 or arg0_57:Moveable(var6_57, not arg2_57) then
				local var7_57 = tostring(var6_57)

				if not var2_57[var7_57] then
					var2_57[var7_57] = {
						pos = var6_57,
						value = var5_57,
						last = var4_57
					}

					table.insert(var0_57, var6_57)
				elseif var5_57 < var2_57[var7_57].value then
					var2_57[var7_57].value = var5_57
					var2_57[var7_57].last = var4_57
				end
			end
		end
	end

	if arg0_57.moveFuShun.inLantern then
		local var8_57 = NenjuuGameConfig.LANTERN_RANGE

		for iter2_57 = -var8_57, var8_57 do
			for iter3_57 = -var8_57, var8_57 do
				local var9_57 = var2_57[tostring(arg0_57.moveFuShun.pos + NewPos(iter2_57, iter3_57))]

				if var9_57 then
					var9_57.lightValue = 1000 - var9_57.value
				end
			end
		end
	end

	arg0_57.wayfindCache[arg2_57] = {
		pos = arg0_57.moveFuShun.pos,
		inLantern = arg0_57.moveFuShun.inLantern,
		basePos = arg1_57,
		map = var2_57
	}

	return var2_57
end

function var0_0.GetTeleportTargetPos(arg0_58, arg1_58, arg2_58)
	local var0_58 = arg0_58.moveFuShun.pos - arg2_58
	local var1_58 = math.random(4)
	local var2_58 = {}

	for iter0_58, iter1_58 in pairs(arg1_58) do
		local var3_58 = iter1_58.pos - arg2_58

		table.insert(var2_58, {
			pos = iter1_58.pos,
			value = iter1_58.value,
			mDis = math.abs(var3_58.x) + math.abs(var3_58.y)
		})
	end

	table.sort(var2_58, CompareFuncs({
		function(arg0_59)
			return math.abs(arg0_59.value - var1_58)
		end,
		function(arg0_60)
			return arg0_60.mDis
		end
	}))

	return var2_58[1].pos
end

function var0_0.StealthCheck(arg0_61, arg1_61)
	local var0_61 = arg0_61.moveFuShun.pos - arg1_61

	return math.abs(var0_61.x) + math.abs(var0_61.y) < 10
end

function var0_0.BuildTeleportSign(arg0_62, arg1_62)
	arg0_62:CreateTarget({
		name = "SignWarp",
		pos = arg1_62.pos,
		time = arg1_62.time
	})
end

function var0_0.GetEnemyEffect(arg0_63, arg1_63)
	return arg0_63.moveNenjuu:CheckAbility(arg1_63)
end

function var0_0.BuildBlackHole(arg0_64)
	local var0_64 = {}

	for iter0_64 = 1, arg0_64.mapSize.x do
		for iter1_64 = 1, arg0_64.mapSize.y do
			local var1_64 = NewPos(iter0_64 - 1, iter1_64 - 1)

			if arg0_64:Moveable(var1_64, true) then
				table.insert(var0_64, var1_64)
			end
		end
	end

	local var2_64 = var0_64[math.random(#var0_64)]

	arg0_64:CreateTarget({
		time = 20,
		name = "BlackHole",
		pos = var2_64
	})
end

function var0_0.InBlackHoleRange(arg0_65, arg1_65, arg2_65)
	if arg2_65 then
		local var0_65 = arg0_65:InRange(arg1_65) and underscore.detect(arg0_65.map[tostring(arg1_65)], function(arg0_66)
			return arg0_66.class == NenjuuGameNameSpace.TargetBlackHole
		end)

		if var0_65 and not var0_65.isLost then
			var0_65:BeTrigger()

			return true
		else
			return false
		end
	else
		local var1_65 = NenjuuGameConfig.BLACK_HOLE_RANGE

		for iter0_65 = -var1_65, var1_65 do
			for iter1_65 = -var1_65, var1_65 do
				local var2_65 = arg1_65 + NewPos(iter0_65, iter1_65)

				if arg0_65:InRange(var2_65) and underscore.any(arg0_65.map[tostring(var2_65)], function(arg0_67)
					return arg0_67.class == NenjuuGameNameSpace.TargetBlackHole
				end) then
					return true
				end
			end
		end
	end
end

function var0_0.BuildDoppelgangers(arg0_68, arg1_68)
	for iter0_68 = -2, 2 do
		for iter1_68 = -2, 2 do
			local var0_68 = arg1_68 + NewPos(iter0_68, iter1_68)

			if arg0_68:Moveable(var0_68) then
				arg0_68.moveDoppel = arg0_68:CreateTarget({
					isDoppel = true,
					name = "Nenjuu_Doppelgangers",
					pos = var0_68,
					abilitys = {}
				})

				return
			end
		end
	end
end

function var0_0.EatItem(arg0_69, arg1_69)
	for iter0_69, iter1_69 in ipairs(arg0_69.map[tostring(arg1_69)]) do
		if iter1_69.class == NenjuuGameNameSpace.TargetItem then
			arg0_69:DestoryTarget(iter1_69)

			arg0_69.itemCount = arg0_69.itemCount - 1
			arg0_69.point = arg0_69.point + iter1_69.point * arg0_69.pointRate

			setText(arg0_69.textPoint, arg0_69.point)
			arg0_69.moveFuShun:PopPoint(iter1_69.point * arg0_69.pointRate)

			if arg0_69.itemCount == 0 then
				arg0_69:CheckWave()
			end
		end
	end
end

return var0_0
