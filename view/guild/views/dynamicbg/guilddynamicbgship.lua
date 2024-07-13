local var0_0 = class("GuildDynamicBgShip")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1._go = arg1_1.go
	arg0_1._tf = tf(arg0_1._go)
	arg0_1.parent = arg0_1._tf.parent
	arg0_1.spineAnimUI = arg0_1._go:GetComponent("SpineAnimUI")
	arg0_1.path = arg1_1.path
	arg0_1.speed = 1
	arg0_1.stepCnt = 0
	arg0_1.scale = arg0_1._tf.localScale.x
	arg0_1.furnitures = arg1_1.furnitures
	arg0_1.interAction = nil
	arg0_1.interActionRatio = 10000 / GuildConst.MAX_DISPLAY_MEMBER_SHIP
	arg0_1.name = arg1_1.name
	arg0_1.isCommander = arg1_1.isCommander

	arg0_1:Init(arg1_1)
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2:SetPosition(arg1_2.grid, true)

	arg0_2.nameTF = arg0_2._tf:Find("name")
	arg0_2.nameTF.localScale = Vector3(1 / arg0_2.scale, 1 / arg0_2.scale, 1)
	arg0_2.nameTF.localPosition = Vector3(0, 300, 0)

	setText(arg0_2.nameTF, arg0_2.name)

	if arg0_2.isCommander then
		arg0_2.tagTF = arg0_2._tf:Find("tag")
		arg0_2.tagTF.localScale = Vector3(1 / arg0_2.scale, 1 / arg0_2.scale, 1)
		arg0_2.tagTF.localPosition = Vector3(0, 380, 0)
	end

	if not arg1_2.stand then
		arg0_2:AddRandomMove()
	end
end

function var0_0.SetOnMoveCallBack(arg0_3, arg1_3)
	arg0_3.callback = arg1_3
end

function var0_0.SetPosition(arg0_4, arg1_4, arg2_4)
	if arg0_4.exited then
		return
	end

	if arg0_4.grid then
		arg0_4.grid:UnlockAll()
	end

	arg0_4.grid = arg1_4

	if arg2_4 then
		local var0_4 = arg0_4.grid:GetCenterPosition()

		arg0_4._tf.localPosition = var0_4

		arg0_4:SetAction("stand2")
	end

	if arg0_4.callback then
		arg0_4.callback()
	end
end

function var0_0.AddRandomMove(arg0_5)
	arg0_5.stepCnt = math.random(1, 10)

	local var0_5 = math.random(1, 8)

	arg0_5.timer = Timer.New(function()
		arg0_5.timer:Stop()

		arg0_5.timer = nil

		arg0_5:StartMove()
	end, var0_5, 1)

	arg0_5.timer:Start()
end

function var0_0.IsCanWalkPonit(arg0_7, arg1_7)
	if not arg0_7.path[arg1_7.x] then
		return false
	end

	local var0_7 = arg0_7.path[arg1_7.x][arg1_7.y]

	if var0_7 then
		return var0_7:CanWalk()
	else
		return false
	end
end

function var0_0.StartMove(arg0_8)
	local var0_8 = arg0_8.grid:GetAroundGrids()
	local var1_8 = _.select(var0_8, function(arg0_9)
		return arg0_8:IsCanWalkPonit(arg0_9)
	end)

	if not var1_8 or #var1_8 == 0 then
		arg0_8:AddRandomMove()
	else
		arg0_8.stepCnt = arg0_8.stepCnt - 1

		local var2_8 = var1_8[math.random(1, #var1_8)]
		local var3_8 = arg0_8.path[var2_8.x][var2_8.y]

		arg0_8:MoveToGrid(var3_8)
	end
end

function var0_0.MoveToGrid(arg0_10, arg1_10)
	local function var0_10()
		arg0_10:SetAction("stand2")

		local var0_11 = math.random(3, 8)

		arg0_10.idleTimer = Timer.New(function()
			arg0_10.idleTimer:Stop()

			arg0_10.idleTimer = nil

			arg0_10:AddRandomMove()
		end, var0_11, 1)

		arg0_10.idleTimer:Start()
	end

	local function var1_10()
		if arg0_10.stepCnt ~= 0 then
			arg0_10:StartMove()

			return
		end

		local var0_13, var1_13 = arg0_10:CanInterAction(arg0_10.interActionRatio)

		if var0_13 then
			arg0_10:MoveToFurniture(var1_13)
		else
			var0_10()
		end
	end

	arg0_10:MoveNext(arg1_10, false, var1_10)
end

function var0_0.MoveNext(arg0_14, arg1_14, arg2_14, arg3_14)
	if not arg2_14 and not arg1_14:CanWalk() then
		return
	end

	if arg0_14.exited then
		return
	end

	arg1_14:Lock()
	arg0_14:SetAction("walk")

	local var0_14 = arg1_14.position.x < arg0_14.grid.position.x and -1 or 1

	arg0_14:UpdateShipDir(var0_14)

	local var1_14 = arg1_14:GetCenterPosition()

	LeanTween.moveLocal(arg0_14._go, Vector3(var1_14.x, var1_14.y, 0), 1 / arg0_14.speed):setOnComplete(System.Action(function()
		if arg0_14.exited then
			return
		end

		arg0_14:SetPosition(arg1_14)
		arg3_14()
	end))
end

function var0_0.MoveLeft(arg0_16)
	local var0_16 = arg0_16.grid.position
	local var1_16 = Vector2(var0_16.x - 1, var0_16.y)
	local var2_16 = arg0_16.path[var1_16.x] and arg0_16.path[var1_16.x][var1_16.y]

	if var2_16 then
		arg0_16:MoveNext(var2_16, false, function()
			arg0_16:SetAction("stand2")
		end)
	end
end

function var0_0.MoveRight(arg0_18)
	local var0_18 = arg0_18.grid.position
	local var1_18 = Vector2(var0_18.x + 1, var0_18.y)
	local var2_18 = arg0_18.path[var1_18.x] and arg0_18.path[var1_18.x][var1_18.y]

	if var2_18 then
		arg0_18:MoveNext(var2_18, false, function()
			arg0_18:SetAction("stand2")
		end)
	end
end

function var0_0.MoveDown(arg0_20)
	local var0_20 = arg0_20.grid.position
	local var1_20 = Vector2(var0_20.x, var0_20.y - 1)
	local var2_20 = arg0_20.path[var1_20.x] and arg0_20.path[var1_20.x][var1_20.y]

	if var2_20 then
		arg0_20:MoveNext(var2_20, false, function()
			arg0_20:SetAction("stand2")
		end)
	end
end

function var0_0.MoveUp(arg0_22)
	local var0_22 = arg0_22.grid.position
	local var1_22 = Vector2(var0_22.x, var0_22.y + 1)
	local var2_22 = arg0_22.path[var1_22.x] and arg0_22.path[var1_22.x][var1_22.y]

	if var2_22 then
		arg0_22:MoveNext(var2_22, false, function()
			arg0_22:SetAction("stand2")
		end)
	end
end

function var0_0.SetAction(arg0_24, arg1_24)
	if arg0_24.actionName == arg1_24 then
		return
	end

	arg0_24.actionName = arg1_24

	arg0_24.spineAnimUI:SetAction(arg1_24, 0)
end

function var0_0.SetAsLastSibling(arg0_25)
	arg0_25._tf:SetAsLastSibling()
end

function var0_0.MoveToFurniture(arg0_26, arg1_26)
	local var0_26 = arg1_26[1]
	local var1_26 = arg1_26[2]

	var0_26:Lock()

	for iter0_26, iter1_26 in ipairs(var1_26) do
		arg0_26.path[iter1_26.x][iter1_26.y]:Lock()
	end

	arg0_26:MoveByPath(var1_26, function()
		arg0_26:InterActionFurniture(var0_26)
	end)
end

function var0_0.UpdateShipDir(arg0_28, arg1_28)
	arg0_28._tf.localScale = Vector3(arg1_28 * arg0_28.scale, arg0_28.scale, arg0_28.scale)

	local var0_28 = 1 / arg0_28.scale * arg1_28

	arg0_28.nameTF.localScale = Vector3(var0_28, arg0_28.nameTF.localScale.y, 1)

	if arg0_28.isCommander then
		arg0_28.tagTF.localScale = Vector3(var0_28, arg0_28.tagTF.localScale.y, 1)
	end
end

function var0_0.InterActionFurniture(arg0_29, arg1_29)
	setParent(arg0_29._tf, arg1_29._tf)

	local var0_29 = arg1_29:GetInteractionDir()

	arg0_29:UpdateShipDir(var0_29)

	local var1_29 = arg1_29:GetInterActionPos()

	arg0_29._tf.anchoredPosition = var1_29

	local var2_29 = arg1_29:GetInterActionMode()
	local var3_29

	if GuildDynamicFurniture.INTERACTION_MODE_SIT == var2_29 then
		var3_29 = "sit"
	end

	assert(var3_29)
	arg0_29:SetAction(var3_29)
	arg0_29:CancelInterAction(arg1_29)
end

function var0_0.CancelInterAction(arg0_30, arg1_30)
	local var0_30 = math.random(15, 30)

	arg0_30.interActionTimer = Timer.New(function()
		arg0_30.interActionTimer:Stop()

		arg0_30.interActionTimer = nil

		arg1_30:Unlock()
		setParent(arg0_30._tf, arg0_30.parent)
		assert(arg0_30.grid)
		arg0_30:SetPosition(arg0_30.grid, true)
		arg0_30:AddRandomMove()
	end, var0_30, 1)

	arg0_30.interActionTimer:Start()
end

function var0_0.MoveByPath(arg0_32, arg1_32, arg2_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in ipairs(arg1_32) do
		table.insert(var0_32, function(arg0_33)
			if arg0_32.exited then
				return
			end

			local var0_33 = arg0_32.path[iter1_32.x][iter1_32.y]

			arg0_32:MoveNext(var0_33, true, arg0_33)
		end)
	end

	seriesAsync(var0_32, arg2_32)
end

function var0_0.SearchPoint(arg0_34, arg1_34, arg2_34)
	local function var0_34(arg0_35, arg1_35, arg2_35, arg3_35)
		if _.any(arg0_35, function(arg0_36)
			return arg2_35 == arg0_36.point
		end) or _.any(arg1_35, function(arg0_37)
			return arg2_35 == arg0_37
		end) then
			return false
		end

		if arg0_34.path[arg2_35.x] then
			local var0_35 = arg0_34.path[arg2_35.x][arg2_35.y]

			return var0_35 and var0_35:CanWalk()
		end

		return false
	end

	local function var1_34(arg0_38)
		local var0_38 = {}

		table.insert(var0_38, Vector2(arg0_38.x + 1, arg0_38.y))
		table.insert(var0_38, Vector2(arg0_38.x - 1, arg0_38.y))
		table.insert(var0_38, Vector2(arg0_38.x, arg0_38.y + 1))
		table.insert(var0_38, Vector2(arg0_38.x, arg0_38.y - 1))

		return var0_38
	end

	local function var2_34(arg0_39, arg1_39, arg2_39)
		return math.abs(arg2_39.x - arg0_39.x) + math.abs(arg2_39.y - arg0_39.y) < math.abs(arg2_39.x - arg1_39.x) + math.abs(arg2_39.y - arg1_39.y)
	end

	local var3_34 = {}
	local var4_34 = {}
	local var5_34 = {}
	local var6_34

	table.insert(var3_34, {
		parent = 0,
		point = arg1_34
	})

	while #var3_34 > 0 do
		local var7_34 = table.remove(var3_34, 1)
		local var8_34 = var7_34.point

		if var8_34 == arg2_34 then
			var6_34 = var7_34

			break
		end

		table.insert(var4_34, var8_34)

		for iter0_34, iter1_34 in ipairs(var1_34(var8_34)) do
			if var0_34(var3_34, var4_34, iter1_34, arg2_34) then
				table.insert(var3_34, {
					point = iter1_34,
					parent = var7_34
				})
			else
				if iter1_34 == arg2_34 then
					var6_34 = var7_34

					break
				end

				table.insert(var4_34, iter1_34)
			end
		end

		table.sort(var3_34, function(arg0_40, arg1_40)
			return var2_34(arg0_40.point, arg1_40.point, arg2_34)
		end)
	end

	if var6_34 then
		while var6_34.parent ~= 0 do
			table.insert(var5_34, 1, var6_34.point)

			var6_34 = var6_34.parent
		end
	end

	return var5_34
end

function var0_0.CanInterAction(arg0_41, arg1_41)
	if arg1_41 < math.random(1, 10000) then
		return false
	end

	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(arg0_41.furnitures) do
		if not iter1_41:BeLock() then
			table.insert(var0_41, iter1_41)
		end
	end

	if #var0_41 == 0 then
		return false
	end

	local var1_41 = var0_41[math.random(1, #var0_41)]
	local var2_41 = var1_41:GetOccupyGrid()
	local var3_41 = 999999
	local var4_41
	local var5_41 = arg0_41.grid.position

	for iter2_41, iter3_41 in ipairs(var2_41) do
		local var6_41 = iter3_41.position
		local var7_41 = math.abs(var5_41.x - var6_41.x) + math.abs(var5_41.y - var6_41.y)

		if var7_41 < var3_41 then
			var3_41 = var7_41
			var4_41 = var6_41
		end
	end

	local var8_41 = arg0_41:SearchPoint(arg0_41.grid.position, var4_41)

	if not var8_41 or #var8_41 == 0 then
		return false
	end

	return true, {
		var1_41,
		var8_41
	}
end

function var0_0.Dispose(arg0_42)
	if arg0_42.timer then
		arg0_42.timer:Stop()

		arg0_42.timer = nil
	end

	if arg0_42.idleTimer then
		arg0_42.idleTimer:Stop()

		arg0_42.idleTimer = nil
	end

	if arg0_42.interActionTimer then
		arg0_42.interActionTimer:Stop()

		arg0_42.interActionTimer = nil
	end

	if not IsNil(arg0_42._go) and LeanTween.isTweening(arg0_42._go) then
		LeanTween.cancel(arg0_42._go)
	end

	Destroy(arg0_42.nameTF)

	if arg0_42.isCommander then
		Destroy(arg0_42.tagTF)
	end

	arg0_42.actionName = nil

	arg0_42:SetOnMoveCallBack()

	arg0_42.exited = true
end

return var0_0
