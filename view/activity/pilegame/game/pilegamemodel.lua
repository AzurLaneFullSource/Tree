local var0 = class("PileGameModel")

function var0.Ctor(arg0, arg1)
	arg0.controller = arg1
	arg0.items = {}
	arg0.level = 0
	arg0.score = 0
	arg0.failedCnt = 0
	arg0.deathLine = Vector2(0, 0)
	arg0.safeLine = Vector2(0, 0)
	arg0.highestScore = 0
	arg0.screen = Vector2(0, 0)
	arg0.maxFailedCnt = PileGameConst.MAX_FAILED_CNT
end

function var0.NetData(arg0, arg1)
	arg0.highestScore = arg1.highestScore or 0
	arg0.screen = Vector2(arg1.screen.x, arg1.screen.y)
end

function var0.UpdateHighestScore(arg0)
	if arg0.score > arg0.highestScore then
		arg0.highestScore = arg0.score
	end
end

function var0.RandomPile(arg0)
	local var0 = math.random(1, #PileGameConst.Prefabs)

	return PileGameConst.Prefabs[var0]
end

function var0.AddHeadPile(arg0)
	local var0 = PileGameConst.HEAD

	return arg0:AddPile(var0)
end

function var0.AddPileByRandom(arg0)
	local var0 = arg0:RandomPile()

	return arg0:AddPile(var0)
end

function var0.AddPile(arg0, arg1)
	arg0.level = arg0.level + 1

	local var0 = arg0:GetSpeed()
	local var1 = {
		onTheMove = false,
		gname = arg1.name,
		name = arg0.level,
		position = Vector3(0, PileGameConst.START_Y, 0),
		leftMaxPosition = Vector3(-PileGameConst.MAX_SLIDE_DISTANCE, PileGameConst.START_Y, 0),
		rightMaxPosition = Vector3(PileGameConst.MAX_SLIDE_DISTANCE, PileGameConst.START_Y, 0),
		speed = var0,
		dropSpeed = PileGameConst.DROP_SPEED,
		sizeDelta = Vector2(arg1.size[1], arg1.size[2]),
		pivot = PileGameConst.ITEM_PIVOT,
		collider = {
			offset = Vector2(arg1.boundary[1], arg1.boundary[2]),
			sizeDelta = Vector2(arg1.boundary[3], arg1.boundary[4])
		},
		speActionCount = arg1.speActionCount or 0
	}

	table.insert(arg0.items, var1)

	return var1
end

function var0.GetSpeed(arg0)
	local var0 = PileGameConst.SLIDE_SPEED
	local var1 = PileGameConst.SLIDE_GROWTH[1]
	local var2 = PileGameConst.SLIDE_GROWTH[2]

	return var0 * (1 + math.floor(arg0.level / var1) * var2)
end

function var0.AddGround(arg0)
	arg0.ground = {
		position = Vector3(0, -arg0.screen.y / 2, 0),
		pivot = PileGameConst.GROUND_PIVOT,
		sizeDelta = PileGameConst.GROUND_SIZE
	}
end

function var0.AddDeathLineRight(arg0)
	arg0.deathLine.x = -PileGameConst.DEATH_LINE_DISTANCE
end

function var0.AddDeathLineLeft(arg0)
	arg0.deathLine.y = PileGameConst.DEATH_LINE_DISTANCE
end

function var0.AddSafeLineRight(arg0)
	arg0.safeLine.x = -PileGameConst.SAFE_LINE_DISTANCE
end

function var0.AddSafeLineLeft(arg0)
	arg0.safeLine.y = PileGameConst.SAFE_LINE_DISTANCE
end

function var0.IsStopDrop(arg0, arg1)
	local var0 = arg0:IsOnGround(arg1)
	local var1 = arg0:OnPrevItem(arg1)

	return var0 or var1
end

function var0.IsOnGround(arg0, arg1)
	return arg1.position.y <= arg0.ground.position.y
end

function var0.GetIndex(arg0)
	return #arg0.items
end

function var0.OnPrevItem(arg0, arg1)
	local var0 = #arg0.items - 1

	if var0 > 0 then
		local var1 = arg0.items[var0]

		return arg0:IsOverlap(arg1, var1)
	end
end

function var0.IsOverTailItem(arg0, arg1)
	local var0 = arg0.items[#arg0.items - 1]

	if var0 then
		return arg0:IsOverItem(arg1, var0)
	end

	return false
end

function var0.IsOverItem(arg0, arg1, arg2)
	local var0 = Vector2(arg1.position.x + (0.5 - arg1.pivot.x) * arg1.sizeDelta.x + arg1.collider.offset.x, arg1.position.y + (0.5 - arg1.pivot.y) * arg1.sizeDelta.y + arg1.collider.offset.y)

	return arg2.position.y + (0.5 - arg2.pivot.y) * arg2.sizeDelta.y + arg2.collider.offset.y + arg2.collider.sizeDelta.y / 2 >= var0.y - arg1.collider.sizeDelta.y / 2
end

function var0.IsOverlap(arg0, arg1, arg2)
	if arg0:IsOverItem(arg1, arg2) then
		local var0 = Vector2(arg1.position.x + (0.5 - arg1.pivot.x) * arg1.sizeDelta.x + arg1.collider.offset.x, arg1.position.y + (0.5 - arg1.pivot.y) * arg1.sizeDelta.y + arg1.collider.offset.y)
		local var1 = arg2.position.x + (0.5 - arg2.pivot.x) * arg2.sizeDelta.x + arg2.collider.offset.x
		local var2 = Vector2(var1 - arg2.collider.sizeDelta.x / 2, var1 + arg2.collider.sizeDelta.x / 2)

		return var0.x >= var2.x and var0.x <= var2.y
	end
end

function var0.CanDropOnPrev(arg0, arg1)
	local var0 = #arg0.items - 1

	if var0 > 0 then
		local var1 = Vector2(arg1.position.x + (0.5 - arg1.pivot.x) * arg1.sizeDelta.x + arg1.collider.offset.x, arg1.position.y + (0.5 - arg1.pivot.y) * arg1.sizeDelta.y + arg1.collider.offset.y)
		local var2 = arg0.items[var0]
		local var3 = var2.position.x + (0.5 - var2.pivot.x) * var2.sizeDelta.x + var2.collider.offset.x
		local var4 = Vector2(var3 - var2.collider.sizeDelta.x / 2, var3 + var2.collider.sizeDelta.x / 2)

		return var1.x >= var4.x and var1.x <= var4.y
	end
end

function var0.AddFailedCnt(arg0)
	arg0.failedCnt = arg0.failedCnt + 1
end

function var0.RemoveTailItem(arg0)
	table.remove(arg0.items, #arg0.items)
end

function var0.AddScore(arg0)
	arg0.score = arg0.score + 1
end

function var0.IsMaxfailedCnt(arg0)
	return arg0.maxFailedCnt == arg0.failedCnt
end

function var0.IsOverDeathLine(arg0, arg1)
	local var0 = arg1.position.x
	local var1 = var0 - arg1.collider.sizeDelta.x / 2 <= arg0.deathLine.x
	local var2 = var0 + arg1.collider.sizeDelta.x / 2 >= arg0.deathLine.y

	return var1 or var2
end

function var0.ShouldSink(arg0)
	return arg0:GetIndex() == PileGameConst.SINK_LEVEL + 1
end

function var0.GetPrevItem(arg0, arg1)
	arg1 = arg1 - 1

	return arg0.items[arg1]
end

function var0.GetNextPos(arg0, arg1)
	local var0 = arg0.items[arg1]
	local var1 = arg0:GetPrevItem(arg1)
	local var2 = 0

	if var1 then
		var2 = var1.position.y + var1.sizeDelta.y
	else
		var2 = var0.position.y - var0.sizeDelta.y
	end

	return Vector3(var0.position.x, var2, 0)
end

function var0.IsExceedingTheHighestScore(arg0)
	return arg0.score - arg0.highestScore == 1
end

function var0.RemoveFirstItem(arg0)
	return table.remove(arg0.items, 1)
end

function var0.GetFirstItem(arg0)
	return arg0.items[1]
end

function var0.GetTailItem(arg0)
	return arg0.items[#arg0.items]
end

function var0.GetDropArea(arg0, arg1)
	local var0
	local var1 = arg1.position.x - arg1.collider.sizeDelta.x / 2
	local var2 = arg1.position.x + arg1.collider.sizeDelta.x / 2

	if var1 <= arg0.deathLine.x or var2 >= arg0.deathLine.y then
		var0 = PileGameController.DROP_AREA_DANGER
	elseif var1 <= arg0.safeLine.x or var2 >= arg0.safeLine.y then
		var0 = PileGameController.DROP_AREA_WARN
	else
		var0 = PileGameController.DROP_AREA_SAFE
	end

	return var0
end

function var0.GetInitPos(arg0)
	local var0 = {}
	local var1 = PileGameConst.SHAKE_DIS + arg0.score * PileGameConst.SHAKE_DIS_RATIO

	for iter0, iter1 in ipairs(arg0.items) do
		table.insert(var0, {
			iter1,
			iter1.position.x - var1,
			iter1.position.x + var1
		})
	end

	return var0
end

function var0.Clear(arg0)
	arg0.level = 0
	arg0.score = 0
	arg0.failedCnt = 0
	arg0.items = {}
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
