local var0_0 = class("GuildDynamicBgShip")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1._go = arg1_1.go
	arg0_1._tf = tf(arg0_1._go)
	arg0_1.parent = arg0_1._tf.parent
	arg0_1.path = arg1_1.path
	arg0_1.speed = 1
	arg0_1.stepCnt = 0
	arg0_1.scale = arg0_1._tf.localScale.x
	arg0_1.furnitures = arg1_1.furnitures
	arg0_1.interAction = nil
	arg0_1.interActionRatio = 10000 / GuildConst.MAX_DISPLAY_MEMBER_SHIP
	arg0_1.name = arg1_1.name
	arg0_1.isCommander = arg1_1.isCommander
	arg0_1.spineChar = arg1_1.char

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

function var0_0.GetMoveDir(arg0_8, arg1_8)
	if arg1_8.position.x < arg0_8.grid.position.x then
		return -1
	elseif arg1_8.position.x > arg0_8.grid.position.x then
		return 1
	end

	return arg0_8._tf.localScale.x < 0 and -1 or 1
end

function var0_0.StartMove(arg0_9)
	local var0_9 = arg0_9.grid:GetAroundGrids()
	local var1_9 = _.select(var0_9, function(arg0_10)
		return arg0_9:IsCanWalkPonit(arg0_10)
	end)

	if not var1_9 or #var1_9 == 0 then
		arg0_9:AddRandomMove()
	else
		arg0_9.stepCnt = arg0_9.stepCnt - 1

		local var2_9 = var1_9[math.random(1, #var1_9)]
		local var3_9 = arg0_9.path[var2_9.x][var2_9.y]
		local var4_9 = arg0_9:GetMoveDir(var3_9)

		arg0_9:UpdateShipDir(var4_9)
		arg0_9:MoveToGrid(var3_9)
	end
end

function var0_0.MoveToGrid(arg0_11, arg1_11)
	local function var0_11()
		arg0_11:SetAction("stand2")

		local var0_12 = math.random(3, 8)

		arg0_11.idleTimer = Timer.New(function()
			arg0_11.idleTimer:Stop()

			arg0_11.idleTimer = nil

			arg0_11:AddRandomMove()
		end, var0_12, 1)

		arg0_11.idleTimer:Start()
	end

	local function var1_11()
		if arg0_11.stepCnt ~= 0 then
			arg0_11:StartMove()

			return
		end

		local var0_14, var1_14 = arg0_11:CanInterAction(arg0_11.interActionRatio)

		if var0_14 then
			arg0_11:MoveToFurniture(var1_14)
		else
			var0_11()
		end
	end

	arg0_11:MoveNext(arg1_11, false, var1_11)
end

function var0_0.MoveNext(arg0_15, arg1_15, arg2_15, arg3_15)
	if not arg2_15 and not arg1_15:CanWalk() then
		return
	end

	if arg0_15.exited then
		return
	end

	arg1_15:Lock()
	arg0_15:SetAction("walk")

	local var0_15 = arg0_15:GetMoveDir(arg1_15)

	arg0_15:UpdateShipDir(var0_15)

	local var1_15 = arg1_15:GetCenterPosition()

	LeanTween.moveLocal(arg0_15._go, Vector3(var1_15.x, var1_15.y, 0), 1 / arg0_15.speed):setOnComplete(System.Action(function()
		if arg0_15.exited then
			return
		end

		arg0_15:SetPosition(arg1_15)
		arg3_15()
	end))
end

function var0_0.MoveLeft(arg0_17)
	local var0_17 = arg0_17.grid.position
	local var1_17 = Vector2(var0_17.x - 1, var0_17.y)
	local var2_17 = arg0_17.path[var1_17.x] and arg0_17.path[var1_17.x][var1_17.y]

	if var2_17 then
		arg0_17:MoveNext(var2_17, false, function()
			arg0_17:SetAction("stand2")
		end)
	end
end

function var0_0.MoveRight(arg0_19)
	local var0_19 = arg0_19.grid.position
	local var1_19 = Vector2(var0_19.x + 1, var0_19.y)
	local var2_19 = arg0_19.path[var1_19.x] and arg0_19.path[var1_19.x][var1_19.y]

	if var2_19 then
		arg0_19:MoveNext(var2_19, false, function()
			arg0_19:SetAction("stand2")
		end)
	end
end

function var0_0.MoveDown(arg0_21)
	local var0_21 = arg0_21.grid.position
	local var1_21 = Vector2(var0_21.x, var0_21.y - 1)
	local var2_21 = arg0_21.path[var1_21.x] and arg0_21.path[var1_21.x][var1_21.y]

	if var2_21 then
		arg0_21:MoveNext(var2_21, false, function()
			arg0_21:SetAction("stand2")
		end)
	end
end

function var0_0.MoveUp(arg0_23)
	local var0_23 = arg0_23.grid.position
	local var1_23 = Vector2(var0_23.x, var0_23.y + 1)
	local var2_23 = arg0_23.path[var1_23.x] and arg0_23.path[var1_23.x][var1_23.y]

	if var2_23 then
		arg0_23:MoveNext(var2_23, false, function()
			arg0_23:SetAction("stand2")
		end)
	end
end

function var0_0.SetAction(arg0_25, arg1_25)
	if arg0_25.actionName == arg1_25 then
		return
	end

	arg0_25.actionName = arg1_25

	arg0_25.spineChar:SetAction(arg1_25, 0)
	arg0_25:NorDirByFather()
end

function var0_0.SetAsLastSibling(arg0_26)
	arg0_26._tf:SetAsLastSibling()
end

function var0_0.MoveToFurniture(arg0_27, arg1_27)
	local var0_27 = arg1_27[1]
	local var1_27 = arg1_27[2]

	var0_27:Lock()

	for iter0_27, iter1_27 in ipairs(var1_27) do
		arg0_27.path[iter1_27.x][iter1_27.y]:Lock()
	end

	arg0_27:MoveByPath(var1_27, function()
		arg0_27:InterActionFurniture(var0_27)
	end)
end

function var0_0.UpdateNameAndTagDir(arg0_29, arg1_29)
	local var0_29 = 1 / arg0_29.scale * arg1_29

	if arg0_29.nameTF then
		arg0_29.nameTF.localScale = Vector3(var0_29, 1 / arg0_29.scale, 1)
	end

	if arg0_29.isCommander and arg0_29.tagTF then
		arg0_29.tagTF.localScale = Vector3(var0_29, 1 / arg0_29.scale, 1)
	end
end

function var0_0.UpdateShipDir(arg0_30, arg1_30)
	arg0_30._tf.localScale = Vector3(arg1_30 * arg0_30.scale, arg0_30.scale, arg0_30.scale)

	arg0_30:UpdateNameAndTagDir(arg1_30)
end

function var0_0.NorDirByFather(arg0_31)
	local var0_31 = arg0_31._tf.localScale.x < 0 and -1 or 1

	arg0_31:UpdateNameAndTagDir(var0_31)
end

function var0_0.InterActionFurniture(arg0_32, arg1_32)
	setParent(arg0_32._tf, arg1_32._tf)

	local var0_32 = arg1_32:GetInteractionDir()

	arg0_32:UpdateShipDir(var0_32)

	local var1_32 = arg1_32:GetInterActionPos()

	arg0_32._tf.anchoredPosition = var1_32

	local var2_32 = arg1_32:GetInterActionMode()
	local var3_32

	if GuildDynamicFurniture.INTERACTION_MODE_SIT == var2_32 then
		var3_32 = "sit"
	end

	assert(var3_32)
	arg0_32:SetAction(var3_32)
	arg0_32:UpdateShipDir(var0_32)
	arg0_32:CancelInterAction(arg1_32)
end

function var0_0.CancelInterAction(arg0_33, arg1_33)
	local var0_33 = math.random(15, 30)

	arg0_33.interActionTimer = Timer.New(function()
		arg0_33.interActionTimer:Stop()

		arg0_33.interActionTimer = nil

		arg1_33:Unlock()
		setParent(arg0_33._tf, arg0_33.parent)
		assert(arg0_33.grid)
		arg0_33:SetPosition(arg0_33.grid, true)
		arg0_33:NorDirByFather()
		arg0_33:AddRandomMove()
	end, var0_33, 1)

	arg0_33.interActionTimer:Start()
end

function var0_0.MoveByPath(arg0_35, arg1_35, arg2_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(arg1_35) do
		table.insert(var0_35, function(arg0_36)
			if arg0_35.exited then
				return
			end

			local var0_36 = arg0_35.path[iter1_35.x][iter1_35.y]

			arg0_35:MoveNext(var0_36, true, arg0_36)
		end)
	end

	seriesAsync(var0_35, arg2_35)
end

function var0_0.SearchPoint(arg0_37, arg1_37, arg2_37)
	local function var0_37(arg0_38, arg1_38, arg2_38, arg3_38)
		if _.any(arg0_38, function(arg0_39)
			return arg2_38 == arg0_39.point
		end) or _.any(arg1_38, function(arg0_40)
			return arg2_38 == arg0_40
		end) then
			return false
		end

		if arg0_37.path[arg2_38.x] then
			local var0_38 = arg0_37.path[arg2_38.x][arg2_38.y]

			return var0_38 and var0_38:CanWalk()
		end

		return false
	end

	local function var1_37(arg0_41)
		local var0_41 = {}

		table.insert(var0_41, Vector2(arg0_41.x + 1, arg0_41.y))
		table.insert(var0_41, Vector2(arg0_41.x - 1, arg0_41.y))
		table.insert(var0_41, Vector2(arg0_41.x, arg0_41.y + 1))
		table.insert(var0_41, Vector2(arg0_41.x, arg0_41.y - 1))

		return var0_41
	end

	local function var2_37(arg0_42, arg1_42, arg2_42)
		return math.abs(arg2_42.x - arg0_42.x) + math.abs(arg2_42.y - arg0_42.y) < math.abs(arg2_42.x - arg1_42.x) + math.abs(arg2_42.y - arg1_42.y)
	end

	local var3_37 = {}
	local var4_37 = {}
	local var5_37 = {}
	local var6_37

	table.insert(var3_37, {
		parent = 0,
		point = arg1_37
	})

	while #var3_37 > 0 do
		local var7_37 = table.remove(var3_37, 1)
		local var8_37 = var7_37.point

		if var8_37 == arg2_37 then
			var6_37 = var7_37

			break
		end

		table.insert(var4_37, var8_37)

		for iter0_37, iter1_37 in ipairs(var1_37(var8_37)) do
			if var0_37(var3_37, var4_37, iter1_37, arg2_37) then
				table.insert(var3_37, {
					point = iter1_37,
					parent = var7_37
				})
			else
				if iter1_37 == arg2_37 then
					var6_37 = var7_37

					break
				end

				table.insert(var4_37, iter1_37)
			end
		end

		table.sort(var3_37, function(arg0_43, arg1_43)
			return var2_37(arg0_43.point, arg1_43.point, arg2_37)
		end)
	end

	if var6_37 then
		while var6_37.parent ~= 0 do
			table.insert(var5_37, 1, var6_37.point)

			var6_37 = var6_37.parent
		end
	end

	return var5_37
end

function var0_0.CanInterAction(arg0_44, arg1_44)
	if arg1_44 < math.random(1, 10000) then
		return false
	end

	local var0_44 = {}

	for iter0_44, iter1_44 in ipairs(arg0_44.furnitures) do
		if not iter1_44:BeLock() then
			table.insert(var0_44, iter1_44)
		end
	end

	if #var0_44 == 0 then
		return false
	end

	local var1_44 = var0_44[math.random(1, #var0_44)]
	local var2_44 = var1_44:GetOccupyGrid()
	local var3_44 = 999999
	local var4_44
	local var5_44 = arg0_44.grid.position

	for iter2_44, iter3_44 in ipairs(var2_44) do
		local var6_44 = iter3_44.position
		local var7_44 = math.abs(var5_44.x - var6_44.x) + math.abs(var5_44.y - var6_44.y)

		if var7_44 < var3_44 then
			var3_44 = var7_44
			var4_44 = var6_44
		end
	end

	local var8_44 = arg0_44:SearchPoint(arg0_44.grid.position, var4_44)

	if not var8_44 or #var8_44 == 0 then
		return false
	end

	return true, {
		var1_44,
		var8_44
	}
end

function var0_0.Dispose(arg0_45)
	if arg0_45.timer then
		arg0_45.timer:Stop()

		arg0_45.timer = nil
	end

	if arg0_45.idleTimer then
		arg0_45.idleTimer:Stop()

		arg0_45.idleTimer = nil
	end

	if arg0_45.interActionTimer then
		arg0_45.interActionTimer:Stop()

		arg0_45.interActionTimer = nil
	end

	if not IsNil(arg0_45._go) and LeanTween.isTweening(arg0_45._go) then
		LeanTween.cancel(arg0_45._go)
	end

	if arg0_45.spineChar then
		arg0_45.spineChar:Dispose()

		arg0_45.spineChar = nil
	end

	Destroy(arg0_45.nameTF)

	if arg0_45.isCommander then
		Destroy(arg0_45.tagTF)
	end

	arg0_45.actionName = nil

	arg0_45:SetOnMoveCallBack()

	arg0_45.exited = true
end

return var0_0
