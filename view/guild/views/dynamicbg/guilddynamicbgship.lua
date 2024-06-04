local var0 = class("GuildDynamicBgShip")

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0._go = arg1.go
	arg0._tf = tf(arg0._go)
	arg0.parent = arg0._tf.parent
	arg0.spineAnimUI = arg0._go:GetComponent("SpineAnimUI")
	arg0.path = arg1.path
	arg0.speed = 1
	arg0.stepCnt = 0
	arg0.scale = arg0._tf.localScale.x
	arg0.furnitures = arg1.furnitures
	arg0.interAction = nil
	arg0.interActionRatio = 10000 / GuildConst.MAX_DISPLAY_MEMBER_SHIP
	arg0.name = arg1.name
	arg0.isCommander = arg1.isCommander

	arg0:Init(arg1)
end

function var0.Init(arg0, arg1)
	arg0:SetPosition(arg1.grid, true)

	arg0.nameTF = arg0._tf:Find("name")
	arg0.nameTF.localScale = Vector3(1 / arg0.scale, 1 / arg0.scale, 1)
	arg0.nameTF.localPosition = Vector3(0, 300, 0)

	setText(arg0.nameTF, arg0.name)

	if arg0.isCommander then
		arg0.tagTF = arg0._tf:Find("tag")
		arg0.tagTF.localScale = Vector3(1 / arg0.scale, 1 / arg0.scale, 1)
		arg0.tagTF.localPosition = Vector3(0, 380, 0)
	end

	if not arg1.stand then
		arg0:AddRandomMove()
	end
end

function var0.SetOnMoveCallBack(arg0, arg1)
	arg0.callback = arg1
end

function var0.SetPosition(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	if arg0.grid then
		arg0.grid:UnlockAll()
	end

	arg0.grid = arg1

	if arg2 then
		local var0 = arg0.grid:GetCenterPosition()

		arg0._tf.localPosition = var0

		arg0:SetAction("stand2")
	end

	if arg0.callback then
		arg0.callback()
	end
end

function var0.AddRandomMove(arg0)
	arg0.stepCnt = math.random(1, 10)

	local var0 = math.random(1, 8)

	arg0.timer = Timer.New(function()
		arg0.timer:Stop()

		arg0.timer = nil

		arg0:StartMove()
	end, var0, 1)

	arg0.timer:Start()
end

function var0.IsCanWalkPonit(arg0, arg1)
	if not arg0.path[arg1.x] then
		return false
	end

	local var0 = arg0.path[arg1.x][arg1.y]

	if var0 then
		return var0:CanWalk()
	else
		return false
	end
end

function var0.StartMove(arg0)
	local var0 = arg0.grid:GetAroundGrids()
	local var1 = _.select(var0, function(arg0)
		return arg0:IsCanWalkPonit(arg0)
	end)

	if not var1 or #var1 == 0 then
		arg0:AddRandomMove()
	else
		arg0.stepCnt = arg0.stepCnt - 1

		local var2 = var1[math.random(1, #var1)]
		local var3 = arg0.path[var2.x][var2.y]

		arg0:MoveToGrid(var3)
	end
end

function var0.MoveToGrid(arg0, arg1)
	local function var0()
		arg0:SetAction("stand2")

		local var0 = math.random(3, 8)

		arg0.idleTimer = Timer.New(function()
			arg0.idleTimer:Stop()

			arg0.idleTimer = nil

			arg0:AddRandomMove()
		end, var0, 1)

		arg0.idleTimer:Start()
	end

	local function var1()
		if arg0.stepCnt ~= 0 then
			arg0:StartMove()

			return
		end

		local var0, var1 = arg0:CanInterAction(arg0.interActionRatio)

		if var0 then
			arg0:MoveToFurniture(var1)
		else
			var0()
		end
	end

	arg0:MoveNext(arg1, false, var1)
end

function var0.MoveNext(arg0, arg1, arg2, arg3)
	if not arg2 and not arg1:CanWalk() then
		return
	end

	if arg0.exited then
		return
	end

	arg1:Lock()
	arg0:SetAction("walk")

	local var0 = arg1.position.x < arg0.grid.position.x and -1 or 1

	arg0:UpdateShipDir(var0)

	local var1 = arg1:GetCenterPosition()

	LeanTween.moveLocal(arg0._go, Vector3(var1.x, var1.y, 0), 1 / arg0.speed):setOnComplete(System.Action(function()
		if arg0.exited then
			return
		end

		arg0:SetPosition(arg1)
		arg3()
	end))
end

function var0.MoveLeft(arg0)
	local var0 = arg0.grid.position
	local var1 = Vector2(var0.x - 1, var0.y)
	local var2 = arg0.path[var1.x] and arg0.path[var1.x][var1.y]

	if var2 then
		arg0:MoveNext(var2, false, function()
			arg0:SetAction("stand2")
		end)
	end
end

function var0.MoveRight(arg0)
	local var0 = arg0.grid.position
	local var1 = Vector2(var0.x + 1, var0.y)
	local var2 = arg0.path[var1.x] and arg0.path[var1.x][var1.y]

	if var2 then
		arg0:MoveNext(var2, false, function()
			arg0:SetAction("stand2")
		end)
	end
end

function var0.MoveDown(arg0)
	local var0 = arg0.grid.position
	local var1 = Vector2(var0.x, var0.y - 1)
	local var2 = arg0.path[var1.x] and arg0.path[var1.x][var1.y]

	if var2 then
		arg0:MoveNext(var2, false, function()
			arg0:SetAction("stand2")
		end)
	end
end

function var0.MoveUp(arg0)
	local var0 = arg0.grid.position
	local var1 = Vector2(var0.x, var0.y + 1)
	local var2 = arg0.path[var1.x] and arg0.path[var1.x][var1.y]

	if var2 then
		arg0:MoveNext(var2, false, function()
			arg0:SetAction("stand2")
		end)
	end
end

function var0.SetAction(arg0, arg1)
	if arg0.actionName == arg1 then
		return
	end

	arg0.actionName = arg1

	arg0.spineAnimUI:SetAction(arg1, 0)
end

function var0.SetAsLastSibling(arg0)
	arg0._tf:SetAsLastSibling()
end

function var0.MoveToFurniture(arg0, arg1)
	local var0 = arg1[1]
	local var1 = arg1[2]

	var0:Lock()

	for iter0, iter1 in ipairs(var1) do
		arg0.path[iter1.x][iter1.y]:Lock()
	end

	arg0:MoveByPath(var1, function()
		arg0:InterActionFurniture(var0)
	end)
end

function var0.UpdateShipDir(arg0, arg1)
	arg0._tf.localScale = Vector3(arg1 * arg0.scale, arg0.scale, arg0.scale)

	local var0 = 1 / arg0.scale * arg1

	arg0.nameTF.localScale = Vector3(var0, arg0.nameTF.localScale.y, 1)

	if arg0.isCommander then
		arg0.tagTF.localScale = Vector3(var0, arg0.tagTF.localScale.y, 1)
	end
end

function var0.InterActionFurniture(arg0, arg1)
	setParent(arg0._tf, arg1._tf)

	local var0 = arg1:GetInteractionDir()

	arg0:UpdateShipDir(var0)

	local var1 = arg1:GetInterActionPos()

	arg0._tf.anchoredPosition = var1

	local var2 = arg1:GetInterActionMode()
	local var3

	if GuildDynamicFurniture.INTERACTION_MODE_SIT == var2 then
		var3 = "sit"
	end

	assert(var3)
	arg0:SetAction(var3)
	arg0:CancelInterAction(arg1)
end

function var0.CancelInterAction(arg0, arg1)
	local var0 = math.random(15, 30)

	arg0.interActionTimer = Timer.New(function()
		arg0.interActionTimer:Stop()

		arg0.interActionTimer = nil

		arg1:Unlock()
		setParent(arg0._tf, arg0.parent)
		assert(arg0.grid)
		arg0:SetPosition(arg0.grid, true)
		arg0:AddRandomMove()
	end, var0, 1)

	arg0.interActionTimer:Start()
end

function var0.MoveByPath(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var0, function(arg0)
			if arg0.exited then
				return
			end

			local var0 = arg0.path[iter1.x][iter1.y]

			arg0:MoveNext(var0, true, arg0)
		end)
	end

	seriesAsync(var0, arg2)
end

function var0.SearchPoint(arg0, arg1, arg2)
	local function var0(arg0, arg1, arg2, arg3)
		if _.any(arg0, function(arg0)
			return arg2 == arg0.point
		end) or _.any(arg1, function(arg0)
			return arg2 == arg0
		end) then
			return false
		end

		if arg0.path[arg2.x] then
			local var0 = arg0.path[arg2.x][arg2.y]

			return var0 and var0:CanWalk()
		end

		return false
	end

	local function var1(arg0)
		local var0 = {}

		table.insert(var0, Vector2(arg0.x + 1, arg0.y))
		table.insert(var0, Vector2(arg0.x - 1, arg0.y))
		table.insert(var0, Vector2(arg0.x, arg0.y + 1))
		table.insert(var0, Vector2(arg0.x, arg0.y - 1))

		return var0
	end

	local function var2(arg0, arg1, arg2)
		return math.abs(arg2.x - arg0.x) + math.abs(arg2.y - arg0.y) < math.abs(arg2.x - arg1.x) + math.abs(arg2.y - arg1.y)
	end

	local var3 = {}
	local var4 = {}
	local var5 = {}
	local var6

	table.insert(var3, {
		parent = 0,
		point = arg1
	})

	while #var3 > 0 do
		local var7 = table.remove(var3, 1)
		local var8 = var7.point

		if var8 == arg2 then
			var6 = var7

			break
		end

		table.insert(var4, var8)

		for iter0, iter1 in ipairs(var1(var8)) do
			if var0(var3, var4, iter1, arg2) then
				table.insert(var3, {
					point = iter1,
					parent = var7
				})
			else
				if iter1 == arg2 then
					var6 = var7

					break
				end

				table.insert(var4, iter1)
			end
		end

		table.sort(var3, function(arg0, arg1)
			return var2(arg0.point, arg1.point, arg2)
		end)
	end

	if var6 then
		while var6.parent ~= 0 do
			table.insert(var5, 1, var6.point)

			var6 = var6.parent
		end
	end

	return var5
end

function var0.CanInterAction(arg0, arg1)
	if arg1 < math.random(1, 10000) then
		return false
	end

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.furnitures) do
		if not iter1:BeLock() then
			table.insert(var0, iter1)
		end
	end

	if #var0 == 0 then
		return false
	end

	local var1 = var0[math.random(1, #var0)]
	local var2 = var1:GetOccupyGrid()
	local var3 = 999999
	local var4
	local var5 = arg0.grid.position

	for iter2, iter3 in ipairs(var2) do
		local var6 = iter3.position
		local var7 = math.abs(var5.x - var6.x) + math.abs(var5.y - var6.y)

		if var7 < var3 then
			var3 = var7
			var4 = var6
		end
	end

	local var8 = arg0:SearchPoint(arg0.grid.position, var4)

	if not var8 or #var8 == 0 then
		return false
	end

	return true, {
		var1,
		var8
	}
end

function var0.Dispose(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	if arg0.idleTimer then
		arg0.idleTimer:Stop()

		arg0.idleTimer = nil
	end

	if arg0.interActionTimer then
		arg0.interActionTimer:Stop()

		arg0.interActionTimer = nil
	end

	if not IsNil(arg0._go) and LeanTween.isTweening(arg0._go) then
		LeanTween.cancel(arg0._go)
	end

	Destroy(arg0.nameTF)

	if arg0.isCommander then
		Destroy(arg0.tagTF)
	end

	arg0.actionName = nil

	arg0:SetOnMoveCallBack()

	arg0.exited = true
end

return var0
