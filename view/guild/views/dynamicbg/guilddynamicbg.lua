local var0 = class("GuildDynamicBG")
local var1 = false
local var2 = false
local var3 = require("view.guild.views.DynamicBG.GuildDynamicBGConfig")

function var0.Ctor(arg0, arg1)
	arg0.mainScrollrect = arg1:Find("scrollrect")
	arg0.assistScrollrect = arg1:Find("scrollrect1")
	arg0.pathContainer = arg1:Find("scrollrect/content/path")
	arg0.nameTF = arg1:Find("name")
	arg0.commanderTag = arg1:Find("commander_tag")
	arg0.path = {}
	arg0.ships = {}
	arg0.furnitures = {}

	onScroll(nil, arg0.mainScrollrect, function(arg0)
		scrollTo(arg0.assistScrollrect, arg0.x / 2, arg0.y)
	end)
end

function var0.Init(arg0, arg1)
	arg0.shipVOs = arg1 or {}

	seriesAsync({
		function(arg0)
			arg0:InitPath()
			arg0()
		end,
		function(arg0)
			arg0:InitFurnitures(arg0)
		end,
		function(arg0)
			if var2 then
				arg0:AddDebugShip(arg0)
			else
				arg0:InitShips(arg0)
			end
		end
	}, function()
		if var1 then
			arg0:AddGridDebugView()
		end

		arg0:SortScene()
	end)
end

function var0.InitPath(arg0)
	local var0 = var3.gridCnt[1]
	local var1 = var3.gridCnt[2]
	local var2 = var3.cantWalkPos
	local var3 = Vector2(var3.gridSize[1], var3.gridSize[2])
	local var4 = Vector2(var3.gridStartPos[1], var3.gridStartPos[2])

	for iter0 = 0, var0 - 1 do
		arg0.path[iter0] = {}

		for iter1 = 0, var1 - 1 do
			local var5 = _.any(var2, function(arg0)
				return arg0[1] == iter0 and arg0[2] == iter1
			end)
			local var6 = GuildDynamicBgPathGrid.New({
				position = Vector2(iter0, iter1),
				canWalk = not var5,
				sizeDelta = var3,
				startPosOffset = var4
			})

			arg0.path[iter0][iter1] = var6
		end
	end
end

function var0.GetRandomGrid(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.path) do
		for iter2, iter3 in pairs(iter1) do
			if iter3:CanWalk() then
				table.insert(var0, iter3)
			end
		end
	end

	return var0[math.random(1, #var0)]
end

function var0.GetGrid(arg0, arg1, arg2)
	return arg0.path[arg1][arg2]
end

function var0.InitFurnitures(arg0, arg1)
	local function var0(arg0, arg1, arg2)
		GetOrAddComponent(arg1, typeof(RectTransform)).pivot = Vector2(0, 0)

		local var0 = arg0:GetGrid(arg0.position[1], arg0.position[2])

		assert(var0)

		local var1 = GuildDynamicFurniture.New({
			go = arg1,
			grid = var0,
			path = arg0.path,
			size = Vector2(arg0.size[1], arg0.size[2]),
			offset = Vector2(arg0.offset[1], arg0.offset[2]),
			mode = arg0.mode,
			interactionPosition = Vector2(arg0.interactionPosition[1], arg0.interactionPosition[2]),
			interactionDir = arg0.interactionDir
		})

		table.insert(arg0.furnitures, var1)
		arg2()
	end

	local var1 = {}
	local var2 = var3.furnitures

	for iter0, iter1 in ipairs(var2) do
		table.insert(var1, function(arg0)
			ResourceMgr.Inst:getAssetAsync("furnitrues/guild/" .. iter1.name, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				local var0 = Object.Instantiate(arg0, arg0.pathContainer)

				var0(iter1, var0, arg0)
			end), true, true)
		end)
	end

	seriesAsync(var1, arg1)
end

function var0.InitShips(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.shipVOs) do
		table.insert(var0, function(arg0)
			arg0:AddShip(iter1, arg0)
		end)
	end

	seriesAsync(var0, arg1)
end

function var0.AddShip(arg0, arg1, arg2)
	local function var0(arg0, arg1, arg2, arg3)
		tf(arg2):SetParent(arg0.pathContainer)

		tf(arg2).localScale = Vector3(0.5, 0.5, 1)

		local var0 = GuildDynamicBgShip.New({
			stand = arg0.stand,
			auto = arg0.auto,
			go = arg2,
			grid = arg1,
			path = arg0.path,
			furnitures = arg0.furnitures,
			name = arg0.name,
			isCommander = arg0.isCommander
		})

		var0:SetOnMoveCallBack(function()
			arg0:SortScene()
		end)
		table.insert(arg0.ships, var0)
		arg3()
	end

	local var1 = arg1:getPrefab()
	local var2 = arg0:GetRandomGrid()

	if not var2 then
		arg2()
	end

	var2:Lock()
	PoolMgr.GetInstance():GetSpineChar(var1, true, function(arg0)
		if IsNil(arg0.nameTF) then
			return
		end

		arg0.name = var1

		cloneTplTo(arg0.nameTF, arg0.transform, "name")

		if arg1.isCommander then
			cloneTplTo(arg0.commanderTag, arg0.transform, "tag")
		end

		var0(arg1, var2, arg0, arg2)
	end)
end

function var0.ExitShip(arg0, arg1)
	for iter0, iter1 in pairs(arg0.ships) do
		if iter1.name == arg1 then
			PoolMgr.GetInstance():ReturnSpineChar(iter1._go.name, iter1._go)
			iter1:Dispose()

			arg0.ships[iter0] = nil

			break
		end
	end
end

function var0.SortScene(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.ships) do
		table.insert(var0, {
			obj = iter1,
			position = iter1.grid.position
		})
	end

	for iter2, iter3 in pairs(arg0.furnitures) do
		table.insert(var0, {
			obj = iter3,
			position = iter3.grid.position
		})
	end

	table.sort(var0, function(arg0, arg1)
		if arg0.position.y == arg1.position.y then
			return arg0.position.x < arg1.position.x
		else
			return arg0.position.y > arg1.position.y
		end
	end)

	for iter4, iter5 in ipairs(var0) do
		iter5.obj:SetAsLastSibling()
	end
end

function var0.Dispose(arg0)
	for iter0, iter1 in pairs(arg0.ships) do
		PoolMgr.GetInstance():ReturnSpineChar(iter1._go.name, iter1._go)
		iter1:Dispose()
	end

	for iter2, iter3 in pairs(arg0.furnitures) do
		iter3:Dispose()
	end

	if var1 then
		if arg0.timer then
			arg0.timer:Stop()

			arg0.timer = nil
		end

		if arg0.timer1 then
			arg0.timer1:Stop()

			arg0.timer1 = nil
		end
	end
end

function var0.AddGridDebugView(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.path) do
		var0[iter0] = {}

		for iter2, iter3 in pairs(iter1) do
			local var1 = GameObject.New()

			SetParent(var1, arg0.pathContainer)

			local var2 = GetOrAddComponent(var1, typeof(RectTransform))
			local var3 = GetOrAddComponent(var1, typeof(Image))

			var2.sizeDelta = iter3.sizeDelta
			var2.pivot = Vector2(0, 0)
			var2.localPosition = iter3.localPosition
			var0[iter0][iter2] = var3
			var1.name = iter3.position.x .. "-" .. iter3.position.y

			setActive(var1, true)
		end
	end

	arg0.timer = Timer.New(function()
		for iter0, iter1 in pairs(arg0.path) do
			for iter2, iter3 in pairs(iter1) do
				local var0

				if iter3:IsLock() then
					var0 = Color.New(1, 0, 0, 0.3)
				elseif not iter3:CanWalk() then
					var0 = Color.New(0.5, 0.5, 0.5, 0.3)
				else
					var0 = Color.New(1, 1, 1, 0.3)
				end

				var0[iter0][iter2].color = var0
			end
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.AddDebugShip(arg0, arg1)
	local var0 = Ship.New({
		id = 0,
		configId = 301284,
		name = "001"
	})

	var0.stand = true
	arg0.shipVOs = {
		var0
	}

	arg0:InitShips(function()
		arg0.timer1 = Timer.New(function()
			if Input.GetKeyDown(KeyCode.A) then
				arg0.ships[1]:MoveLeft()
			end

			if Input.GetKeyDown(KeyCode.S) then
				arg0.ships[1]:MoveDown()
			end

			if Input.GetKeyDown(KeyCode.W) then
				arg0.ships[1]:MoveUp()
			end

			if Input.GetKeyDown(KeyCode.D) then
				arg0.ships[1]:MoveRight()
			end
		end, Time.deltaTime, -1)

		arg0.timer1:Start()
		arg0.timer1.func()
		arg1()
	end)
end

return var0
