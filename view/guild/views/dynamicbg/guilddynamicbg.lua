local var0_0 = class("GuildDynamicBG")
local var1_0 = false
local var2_0 = false
local var3_0 = require("view.guild.views.DynamicBG.GuildDynamicBGConfig")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.mainScrollrect = arg1_1:Find("scrollrect")
	arg0_1.assistScrollrect = arg1_1:Find("scrollrect1")
	arg0_1.pathContainer = arg1_1:Find("scrollrect/content/path")
	arg0_1.nameTF = arg1_1:Find("name")
	arg0_1.commanderTag = arg1_1:Find("commander_tag")
	arg0_1.path = {}
	arg0_1.ships = {}
	arg0_1.furnitures = {}

	onScroll(nil, arg0_1.mainScrollrect, function(arg0_2)
		scrollTo(arg0_1.assistScrollrect, arg0_2.x / 2, arg0_2.y)
	end)
end

function var0_0.Init(arg0_3, arg1_3)
	arg0_3.shipVOs = arg1_3 or {}

	seriesAsync({
		function(arg0_4)
			arg0_3:InitPath()
			arg0_4()
		end,
		function(arg0_5)
			arg0_3:InitFurnitures(arg0_5)
		end,
		function(arg0_6)
			if var2_0 then
				arg0_3:AddDebugShip(arg0_6)
			else
				arg0_3:InitShips(arg0_6)
			end
		end
	}, function()
		if var1_0 then
			arg0_3:AddGridDebugView()
		end

		arg0_3:SortScene()
	end)
end

function var0_0.InitPath(arg0_8)
	local var0_8 = var3_0.gridCnt[1]
	local var1_8 = var3_0.gridCnt[2]
	local var2_8 = var3_0.cantWalkPos
	local var3_8 = Vector2(var3_0.gridSize[1], var3_0.gridSize[2])
	local var4_8 = Vector2(var3_0.gridStartPos[1], var3_0.gridStartPos[2])

	for iter0_8 = 0, var0_8 - 1 do
		arg0_8.path[iter0_8] = {}

		for iter1_8 = 0, var1_8 - 1 do
			local var5_8 = _.any(var2_8, function(arg0_9)
				return arg0_9[1] == iter0_8 and arg0_9[2] == iter1_8
			end)
			local var6_8 = GuildDynamicBgPathGrid.New({
				position = Vector2(iter0_8, iter1_8),
				canWalk = not var5_8,
				sizeDelta = var3_8,
				startPosOffset = var4_8
			})

			arg0_8.path[iter0_8][iter1_8] = var6_8
		end
	end
end

function var0_0.GetRandomGrid(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10.path) do
		for iter2_10, iter3_10 in pairs(iter1_10) do
			if iter3_10:CanWalk() then
				table.insert(var0_10, iter3_10)
			end
		end
	end

	return var0_10[math.random(1, #var0_10)]
end

function var0_0.GetGrid(arg0_11, arg1_11, arg2_11)
	return arg0_11.path[arg1_11][arg2_11]
end

function var0_0.InitFurnitures(arg0_12, arg1_12)
	local function var0_12(arg0_13, arg1_13, arg2_13)
		GetOrAddComponent(arg1_13, typeof(RectTransform)).pivot = Vector2(0, 0)

		local var0_13 = arg0_12:GetGrid(arg0_13.position[1], arg0_13.position[2])

		assert(var0_13)

		local var1_13 = GuildDynamicFurniture.New({
			go = arg1_13,
			grid = var0_13,
			path = arg0_12.path,
			size = Vector2(arg0_13.size[1], arg0_13.size[2]),
			offset = Vector2(arg0_13.offset[1], arg0_13.offset[2]),
			mode = arg0_13.mode,
			interactionPosition = Vector2(arg0_13.interactionPosition[1], arg0_13.interactionPosition[2]),
			interactionDir = arg0_13.interactionDir
		})

		table.insert(arg0_12.furnitures, var1_13)
		arg2_13()
	end

	local var1_12 = {}
	local var2_12 = var3_0.furnitures

	for iter0_12, iter1_12 in ipairs(var2_12) do
		table.insert(var1_12, function(arg0_14)
			ResourceMgr.Inst:getAssetAsync("furnitrues/guild/" .. iter1_12.name, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_15)
				local var0_15 = Object.Instantiate(arg0_15, arg0_12.pathContainer)

				var0_12(iter1_12, var0_15, arg0_14)
			end), true, true)
		end)
	end

	seriesAsync(var1_12, arg1_12)
end

function var0_0.InitShips(arg0_16, arg1_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(arg0_16.shipVOs) do
		table.insert(var0_16, function(arg0_17)
			arg0_16:AddShip(iter1_16, arg0_17)
		end)
	end

	seriesAsync(var0_16, arg1_16)
end

function var0_0.AddShip(arg0_18, arg1_18, arg2_18)
	local function var0_18(arg0_19, arg1_19, arg2_19, arg3_19)
		tf(arg2_19):SetParent(arg0_18.pathContainer)

		tf(arg2_19).localScale = Vector3(0.5, 0.5, 1)

		local var0_19 = GuildDynamicBgShip.New({
			stand = arg0_19.stand,
			auto = arg0_19.auto,
			go = arg2_19,
			grid = arg1_19,
			path = arg0_18.path,
			furnitures = arg0_18.furnitures,
			name = arg0_19.name,
			isCommander = arg0_19.isCommander
		})

		var0_19:SetOnMoveCallBack(function()
			arg0_18:SortScene()
		end)
		table.insert(arg0_18.ships, var0_19)
		arg3_19()
	end

	local var1_18 = arg1_18:getPrefab()
	local var2_18 = arg0_18:GetRandomGrid()

	if not var2_18 then
		arg2_18()
	end

	var2_18:Lock()
	PoolMgr.GetInstance():GetSpineChar(var1_18, true, function(arg0_21)
		if IsNil(arg0_18.nameTF) then
			return
		end

		arg0_21.name = var1_18

		cloneTplTo(arg0_18.nameTF, arg0_21.transform, "name")

		if arg1_18.isCommander then
			cloneTplTo(arg0_18.commanderTag, arg0_21.transform, "tag")
		end

		var0_18(arg1_18, var2_18, arg0_21, arg2_18)
	end)
end

function var0_0.ExitShip(arg0_22, arg1_22)
	for iter0_22, iter1_22 in pairs(arg0_22.ships) do
		if iter1_22.name == arg1_22 then
			PoolMgr.GetInstance():ReturnSpineChar(iter1_22._go.name, iter1_22._go)
			iter1_22:Dispose()

			arg0_22.ships[iter0_22] = nil

			break
		end
	end
end

function var0_0.SortScene(arg0_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in pairs(arg0_23.ships) do
		table.insert(var0_23, {
			obj = iter1_23,
			position = iter1_23.grid.position
		})
	end

	for iter2_23, iter3_23 in pairs(arg0_23.furnitures) do
		table.insert(var0_23, {
			obj = iter3_23,
			position = iter3_23.grid.position
		})
	end

	table.sort(var0_23, function(arg0_24, arg1_24)
		if arg0_24.position.y == arg1_24.position.y then
			return arg0_24.position.x < arg1_24.position.x
		else
			return arg0_24.position.y > arg1_24.position.y
		end
	end)

	for iter4_23, iter5_23 in ipairs(var0_23) do
		iter5_23.obj:SetAsLastSibling()
	end
end

function var0_0.Dispose(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.ships) do
		PoolMgr.GetInstance():ReturnSpineChar(iter1_25._go.name, iter1_25._go)
		iter1_25:Dispose()
	end

	for iter2_25, iter3_25 in pairs(arg0_25.furnitures) do
		iter3_25:Dispose()
	end

	if var1_0 then
		if arg0_25.timer then
			arg0_25.timer:Stop()

			arg0_25.timer = nil
		end

		if arg0_25.timer1 then
			arg0_25.timer1:Stop()

			arg0_25.timer1 = nil
		end
	end
end

function var0_0.AddGridDebugView(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.path) do
		var0_26[iter0_26] = {}

		for iter2_26, iter3_26 in pairs(iter1_26) do
			local var1_26 = GameObject.New()

			SetParent(var1_26, arg0_26.pathContainer)

			local var2_26 = GetOrAddComponent(var1_26, typeof(RectTransform))
			local var3_26 = GetOrAddComponent(var1_26, typeof(Image))

			var2_26.sizeDelta = iter3_26.sizeDelta
			var2_26.pivot = Vector2(0, 0)
			var2_26.localPosition = iter3_26.localPosition
			var0_26[iter0_26][iter2_26] = var3_26
			var1_26.name = iter3_26.position.x .. "-" .. iter3_26.position.y

			setActive(var1_26, true)
		end
	end

	arg0_26.timer = Timer.New(function()
		for iter0_27, iter1_27 in pairs(arg0_26.path) do
			for iter2_27, iter3_27 in pairs(iter1_27) do
				local var0_27

				if iter3_27:IsLock() then
					var0_27 = Color.New(1, 0, 0, 0.3)
				elseif not iter3_27:CanWalk() then
					var0_27 = Color.New(0.5, 0.5, 0.5, 0.3)
				else
					var0_27 = Color.New(1, 1, 1, 0.3)
				end

				var0_26[iter0_27][iter2_27].color = var0_27
			end
		end
	end, 1, -1)

	arg0_26.timer:Start()
	arg0_26.timer.func()
end

function var0_0.AddDebugShip(arg0_28, arg1_28)
	local var0_28 = Ship.New({
		id = 0,
		configId = 301284,
		name = "001"
	})

	var0_28.stand = true
	arg0_28.shipVOs = {
		var0_28
	}

	arg0_28:InitShips(function()
		arg0_28.timer1 = Timer.New(function()
			if Input.GetKeyDown(KeyCode.A) then
				arg0_28.ships[1]:MoveLeft()
			end

			if Input.GetKeyDown(KeyCode.S) then
				arg0_28.ships[1]:MoveDown()
			end

			if Input.GetKeyDown(KeyCode.W) then
				arg0_28.ships[1]:MoveUp()
			end

			if Input.GetKeyDown(KeyCode.D) then
				arg0_28.ships[1]:MoveRight()
			end
		end, Time.deltaTime, -1)

		arg0_28.timer1:Start()
		arg0_28.timer1.func()
		arg1_28()
	end)
end

return var0_0
