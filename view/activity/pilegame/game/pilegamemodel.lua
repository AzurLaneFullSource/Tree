local var0_0 = class("PileGameModel")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.controller = arg1_1
	arg0_1.items = {}
	arg0_1.level = 0
	arg0_1.score = 0
	arg0_1.failedCnt = 0
	arg0_1.deathLine = Vector2(0, 0)
	arg0_1.safeLine = Vector2(0, 0)
	arg0_1.highestScore = 0
	arg0_1.screen = Vector2(0, 0)
	arg0_1.maxFailedCnt = PileGameConst.MAX_FAILED_CNT
end

function var0_0.NetData(arg0_2, arg1_2)
	arg0_2.highestScore = arg1_2.highestScore or 0
	arg0_2.screen = Vector2(arg1_2.screen.x, arg1_2.screen.y)
end

function var0_0.UpdateHighestScore(arg0_3)
	if arg0_3.score > arg0_3.highestScore then
		arg0_3.highestScore = arg0_3.score
	end
end

function var0_0.RandomPile(arg0_4)
	local var0_4 = math.random(1, #PileGameConst.Prefabs)

	return PileGameConst.Prefabs[var0_4]
end

function var0_0.AddHeadPile(arg0_5)
	local var0_5 = PileGameConst.HEAD

	return arg0_5:AddPile(var0_5)
end

function var0_0.AddPileByRandom(arg0_6)
	local var0_6 = arg0_6:RandomPile()

	return arg0_6:AddPile(var0_6)
end

function var0_0.AddPile(arg0_7, arg1_7)
	arg0_7.level = arg0_7.level + 1

	local var0_7 = arg0_7:GetSpeed()
	local var1_7 = {
		onTheMove = false,
		gname = arg1_7.name,
		name = arg0_7.level,
		position = Vector3(0, PileGameConst.START_Y, 0),
		leftMaxPosition = Vector3(-PileGameConst.MAX_SLIDE_DISTANCE, PileGameConst.START_Y, 0),
		rightMaxPosition = Vector3(PileGameConst.MAX_SLIDE_DISTANCE, PileGameConst.START_Y, 0),
		speed = var0_7,
		dropSpeed = PileGameConst.DROP_SPEED,
		sizeDelta = Vector2(arg1_7.size[1], arg1_7.size[2]),
		pivot = PileGameConst.ITEM_PIVOT,
		collider = {
			offset = Vector2(arg1_7.boundary[1], arg1_7.boundary[2]),
			sizeDelta = Vector2(arg1_7.boundary[3], arg1_7.boundary[4])
		},
		speActionCount = arg1_7.speActionCount or 0
	}

	table.insert(arg0_7.items, var1_7)

	return var1_7
end

function var0_0.GetSpeed(arg0_8)
	local var0_8 = PileGameConst.SLIDE_SPEED
	local var1_8 = PileGameConst.SLIDE_GROWTH[1]
	local var2_8 = PileGameConst.SLIDE_GROWTH[2]

	return var0_8 * (1 + math.floor(arg0_8.level / var1_8) * var2_8)
end

function var0_0.AddGround(arg0_9)
	arg0_9.ground = {
		position = Vector3(0, -arg0_9.screen.y / 2, 0),
		pivot = PileGameConst.GROUND_PIVOT,
		sizeDelta = PileGameConst.GROUND_SIZE
	}
end

function var0_0.AddDeathLineRight(arg0_10)
	arg0_10.deathLine.x = -PileGameConst.DEATH_LINE_DISTANCE
end

function var0_0.AddDeathLineLeft(arg0_11)
	arg0_11.deathLine.y = PileGameConst.DEATH_LINE_DISTANCE
end

function var0_0.AddSafeLineRight(arg0_12)
	arg0_12.safeLine.x = -PileGameConst.SAFE_LINE_DISTANCE
end

function var0_0.AddSafeLineLeft(arg0_13)
	arg0_13.safeLine.y = PileGameConst.SAFE_LINE_DISTANCE
end

function var0_0.IsStopDrop(arg0_14, arg1_14)
	local var0_14 = arg0_14:IsOnGround(arg1_14)
	local var1_14 = arg0_14:OnPrevItem(arg1_14)

	return var0_14 or var1_14
end

function var0_0.IsOnGround(arg0_15, arg1_15)
	return arg1_15.position.y <= arg0_15.ground.position.y
end

function var0_0.GetIndex(arg0_16)
	return #arg0_16.items
end

function var0_0.OnPrevItem(arg0_17, arg1_17)
	local var0_17 = #arg0_17.items - 1

	if var0_17 > 0 then
		local var1_17 = arg0_17.items[var0_17]

		return arg0_17:IsOverlap(arg1_17, var1_17)
	end
end

function var0_0.IsOverTailItem(arg0_18, arg1_18)
	local var0_18 = arg0_18.items[#arg0_18.items - 1]

	if var0_18 then
		return arg0_18:IsOverItem(arg1_18, var0_18)
	end

	return false
end

function var0_0.IsOverItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = Vector2(arg1_19.position.x + (0.5 - arg1_19.pivot.x) * arg1_19.sizeDelta.x + arg1_19.collider.offset.x, arg1_19.position.y + (0.5 - arg1_19.pivot.y) * arg1_19.sizeDelta.y + arg1_19.collider.offset.y)

	return arg2_19.position.y + (0.5 - arg2_19.pivot.y) * arg2_19.sizeDelta.y + arg2_19.collider.offset.y + arg2_19.collider.sizeDelta.y / 2 >= var0_19.y - arg1_19.collider.sizeDelta.y / 2
end

function var0_0.IsOverlap(arg0_20, arg1_20, arg2_20)
	if arg0_20:IsOverItem(arg1_20, arg2_20) then
		local var0_20 = Vector2(arg1_20.position.x + (0.5 - arg1_20.pivot.x) * arg1_20.sizeDelta.x + arg1_20.collider.offset.x, arg1_20.position.y + (0.5 - arg1_20.pivot.y) * arg1_20.sizeDelta.y + arg1_20.collider.offset.y)
		local var1_20 = arg2_20.position.x + (0.5 - arg2_20.pivot.x) * arg2_20.sizeDelta.x + arg2_20.collider.offset.x
		local var2_20 = Vector2(var1_20 - arg2_20.collider.sizeDelta.x / 2, var1_20 + arg2_20.collider.sizeDelta.x / 2)

		return var0_20.x >= var2_20.x and var0_20.x <= var2_20.y
	end
end

function var0_0.CanDropOnPrev(arg0_21, arg1_21)
	local var0_21 = #arg0_21.items - 1

	if var0_21 > 0 then
		local var1_21 = Vector2(arg1_21.position.x + (0.5 - arg1_21.pivot.x) * arg1_21.sizeDelta.x + arg1_21.collider.offset.x, arg1_21.position.y + (0.5 - arg1_21.pivot.y) * arg1_21.sizeDelta.y + arg1_21.collider.offset.y)
		local var2_21 = arg0_21.items[var0_21]
		local var3_21 = var2_21.position.x + (0.5 - var2_21.pivot.x) * var2_21.sizeDelta.x + var2_21.collider.offset.x
		local var4_21 = Vector2(var3_21 - var2_21.collider.sizeDelta.x / 2, var3_21 + var2_21.collider.sizeDelta.x / 2)

		return var1_21.x >= var4_21.x and var1_21.x <= var4_21.y
	end
end

function var0_0.AddFailedCnt(arg0_22)
	arg0_22.failedCnt = arg0_22.failedCnt + 1
end

function var0_0.RemoveTailItem(arg0_23)
	table.remove(arg0_23.items, #arg0_23.items)
end

function var0_0.AddScore(arg0_24)
	arg0_24.score = arg0_24.score + 1
end

function var0_0.IsMaxfailedCnt(arg0_25)
	return arg0_25.maxFailedCnt == arg0_25.failedCnt
end

function var0_0.IsOverDeathLine(arg0_26, arg1_26)
	local var0_26 = arg1_26.position.x
	local var1_26 = var0_26 - arg1_26.collider.sizeDelta.x / 2 <= arg0_26.deathLine.x
	local var2_26 = var0_26 + arg1_26.collider.sizeDelta.x / 2 >= arg0_26.deathLine.y

	return var1_26 or var2_26
end

function var0_0.ShouldSink(arg0_27)
	return arg0_27:GetIndex() == PileGameConst.SINK_LEVEL + 1
end

function var0_0.GetPrevItem(arg0_28, arg1_28)
	arg1_28 = arg1_28 - 1

	return arg0_28.items[arg1_28]
end

function var0_0.GetNextPos(arg0_29, arg1_29)
	local var0_29 = arg0_29.items[arg1_29]
	local var1_29 = arg0_29:GetPrevItem(arg1_29)
	local var2_29 = 0

	if var1_29 then
		var2_29 = var1_29.position.y + var1_29.sizeDelta.y
	else
		var2_29 = var0_29.position.y - var0_29.sizeDelta.y
	end

	return Vector3(var0_29.position.x, var2_29, 0)
end

function var0_0.IsExceedingTheHighestScore(arg0_30)
	return arg0_30.score - arg0_30.highestScore == 1
end

function var0_0.RemoveFirstItem(arg0_31)
	return table.remove(arg0_31.items, 1)
end

function var0_0.GetFirstItem(arg0_32)
	return arg0_32.items[1]
end

function var0_0.GetTailItem(arg0_33)
	return arg0_33.items[#arg0_33.items]
end

function var0_0.GetDropArea(arg0_34, arg1_34)
	local var0_34
	local var1_34 = arg1_34.position.x - arg1_34.collider.sizeDelta.x / 2
	local var2_34 = arg1_34.position.x + arg1_34.collider.sizeDelta.x / 2

	if var1_34 <= arg0_34.deathLine.x or var2_34 >= arg0_34.deathLine.y then
		var0_34 = PileGameController.DROP_AREA_DANGER
	elseif var1_34 <= arg0_34.safeLine.x or var2_34 >= arg0_34.safeLine.y then
		var0_34 = PileGameController.DROP_AREA_WARN
	else
		var0_34 = PileGameController.DROP_AREA_SAFE
	end

	return var0_34
end

function var0_0.GetInitPos(arg0_35)
	local var0_35 = {}
	local var1_35 = PileGameConst.SHAKE_DIS + arg0_35.score * PileGameConst.SHAKE_DIS_RATIO

	for iter0_35, iter1_35 in ipairs(arg0_35.items) do
		table.insert(var0_35, {
			iter1_35,
			iter1_35.position.x - var1_35,
			iter1_35.position.x + var1_35
		})
	end

	return var0_35
end

function var0_0.Clear(arg0_36)
	arg0_36.level = 0
	arg0_36.score = 0
	arg0_36.failedCnt = 0
	arg0_36.items = {}
end

function var0_0.Dispose(arg0_37)
	arg0_37:Clear()
end

return var0_0
