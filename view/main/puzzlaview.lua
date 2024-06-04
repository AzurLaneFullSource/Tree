local var0 = class("PuzzlaView")
local var1 = 0.3
local var2 = 0
local var3 = 5
local var4 = 4
local var5 = 4
local var6 = {
	3,
	3,
	2,
	4,
	2,
	4,
	2,
	3,
	1,
	3,
	2,
	4,
	1,
	4,
	1,
	3,
	2,
	2,
	3,
	1,
	4,
	1,
	1,
	3,
	3,
	2,
	4,
	4,
	2,
	2,
	3,
	1,
	4,
	1,
	1,
	3,
	2,
	4,
	2,
	4,
	2,
	3,
	3,
	3,
	1,
	4,
	2,
	3,
	1,
	4,
	1,
	3,
	1,
	4,
	2,
	2,
	3,
	1,
	1,
	4,
	2,
	4,
	2,
	3,
	3,
	1,
	4,
	2,
	2,
	3,
	1,
	4,
	4,
	2,
	4,
	1,
	1,
	1,
	3,
	3,
	3,
	2,
	4,
	4,
	2,
	2,
	4,
	1,
	1,
	1,
	3,
	3,
	2,
	4,
	4,
	1,
	3,
	2,
	2,
	2,
	1,
	1,
	1,
	4
}
local var7 = true
local var8 = {
	"BOTTOM",
	"TOP",
	"LEFT",
	"RIGHT"
}
local var9 = {
	TOP = 2,
	BOTTOM = 1,
	LEFT = 3,
	RIGHT = 4
}
local var10 = {
	BOTTOM = 2,
	TOP = 1,
	LEFT = 4,
	RIGHT = 3
}

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.showDesc = arg1.descs
	arg0.openlist = arg1.list
	arg0._go = arg1.go
	arg0._tf = tf(arg0._go)
	arg0.fetch = arg1.fetch

	arg0:load(arg1.bg, arg2)

	arg0.onFinish = nil
end

function var0.load(arg0, arg1, arg2)
	arg0.puzzlaWidth, arg0.puzzlaHeight = 0, 0
	arg0.startPosition = Vector2(0, 0)
	arg0.totalCount = var4 * var5
	arg0.pics = {}

	for iter0 = 1, arg0.totalCount do
		local var0 = "pic_" .. iter0

		arg0.pics[iter0] = GetSpriteFromAtlas("puzzla/" .. arg1, var0)
	end

	if #arg0.pics > 0 then
		local var1 = arg0.pics[1]

		arg0.puzzlaWidth = var1.rect.width * var4
		arg0.puzzlaHeight = var1.rect.height * var5
		arg0.startPosition = Vector2(arg0.puzzlaWidth / 2, arg0.puzzlaHeight / 2)

		arg0:init()
	end

	if arg2 then
		arg2()
	end
end

function var0.init(arg0)
	arg0.puzzlaItems = {}

	local var0 = 1

	for iter0 = 1, var4 do
		local var1 = {}

		for iter1 = 1, var5 do
			local var2 = table.contains(arg0.openlist, var0)
			local var3

			if not var2 and arg0.showDesc[var0] then
				var3 = arg0.showDesc[var0]
			end

			local var4 = arg0:createItem(arg0.pics[var0], Vector2(iter1, iter0), var0, var2, var3)
			local var5 = Vector2((iter1 - 1) * var4.width - arg0.startPosition.x, arg0.startPosition.y + (iter0 - 1) * var4.height * -1)

			var4:setLocalPosition(var5)
			table.insert(var1, var4)

			var0 = var0 + 1
		end

		table.insert(arg0.puzzlaItems, var1)
	end

	if arg0.fetch then
		arg0.blockEvent = true

		arg0:getBlockItem():setHightLight()

		return
	end

	if var7 and #var6 > 0 then
		arg0:disorganizePuzzla(var6)
	else
		arg0:disorganizePuzzla()
	end
end

function var0.createItem(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = GameObject(arg2.x .. "-" .. arg2.y)

	var0:AddComponent(typeof(Image))
	SetParent(var0, arg0._tf)

	local var1 = PuzzlaItem.New(var0, arg3, arg4, arg5)
	local var2 = arg3 == arg0.totalCount

	var1:update(arg1, arg2, var2)
	onButton(arg0, var1._go, function()
		if arg0.blockEvent then
			return
		end

		arg0:checkSurround(var1)
	end, SFX_PANEL)

	return var1
end

function var0.checkSurround(arg0, arg1)
	local var0 = arg1:getSurroundPosition()
	local var1 = arg0:getBlockItemByPositions(var0)

	if var1 then
		arg0:swop(arg1, var1)
	end
end

function var0.swop(arg0, arg1, arg2)
	local var0 = arg2:getPosition()
	local var1 = arg1:getPosition()
	local var2 = arg2:getCurrIndex()
	local var3 = arg1:getCurrIndex()
	local var4 = arg2:getLocalPosition()
	local var5 = arg1:getLocalPosition()

	arg1:setPosition(var0, var2)
	arg2:setPosition(var1, var3)

	arg0.puzzlaItems[var0.y][var0.x], arg0.puzzlaItems[var1.y][var1.x] = arg1, arg2

	arg2:setLocalPosition(var5)
	arg1:setLocalPosition(var4)

	if arg0:isFinish() then
		arg0.blockEvent = true

		arg2:setHightLight()

		if arg0.onFinish then
			arg0.onFinish()
		end
	else
		arg2:setBlock()
	end
end

function var0.getBlockItemByPositions(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg1) do
		if arg0:isValidPosition(iter1) and arg0:isBlockItem(iter1) then
			var0 = arg0:getItemByPosition(iter1)

			break
		end
	end

	return var0
end

function var0.isBlockItem(arg0, arg1)
	return arg0:getItemByPosition(arg1):isBlock()
end

function var0.getItemByPosition(arg0, arg1)
	assert(arg0.puzzlaItems[arg1.y], "position y" .. arg1.y)

	return arg0.puzzlaItems[arg1.y][arg1.x]
end

function var0.isValidPosition(arg0, arg1)
	if arg1.x > 0 and arg1.y > 0 and arg1.x <= var4 and arg1.y <= var5 then
		return true
	end

	return false
end

function var0.printTable(arg0)
	for iter0, iter1 in ipairs(arg0.puzzlaItems) do
		local var0 = ""

		for iter2, iter3 in ipairs(iter1) do
			var0 = var0 .. iter0 .. "-" .. iter2 .. "-" .. iter3:getCurrIndex() .. " "
		end

		print(var0)
	end
end

function var0.disorganizePuzzla(arg0, arg1)
	arg0.paths = {}

	local function var0()
		return
	end

	if arg1 and #arg1 > 0 then
		arg0:orderDisorganize(arg1, var2, function(arg0)
			arg0.paths = arg0

			var0()
		end)
	else
		for iter0 = 1, var3 do
			local var1 = arg0:disorganizeStep()

			table.insert(arg0.paths, var1)

			arg0.prevDir = var10[var1]
		end

		var0()
	end
end

function var0.disorganizeStep(arg0)
	local var0 = arg0:getBlockItem()

	local function var1(arg0)
		if arg0.prevDir then
			return arg0.prevDir == arg0
		end

		return false
	end

	local var2 = var0:getSurroundPosition()
	local var3 = {}

	for iter0, iter1 in ipairs(var2) do
		if arg0:isValidPosition(iter1) and not var1(iter0) then
			table.insert(var3, {
				pos = iter1,
				dir = var8[iter0]
			})
		end
	end

	local var4 = var3[math.random(1, #var3)]
	local var5 = arg0:getItemByPosition(var4.pos)

	arg0:swop(var5, var0)

	return var4.dir
end

function var0.printPaths(arg0)
	local var0 = ""

	for iter0, iter1 in ipairs(arg0.paths or {}) do
		var0 = var0 .. var9[iter1] .. ","
	end

	print(var0)
end

function var0.decodePuzzla(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1 or {}) do
		local var1 = var10[iter1]
		local var2 = var8[var1]
		local var3 = var9[var2]

		table.insert(var0, 1, {
			dir = var2,
			index = var3
		})
	end

	return var0
end

function var0.aotuDecode(arg0)
	local var0 = arg0:decodePuzzla(arg0.paths)
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, iter1.index)
	end

	arg0:revertPuzzla(var1)
end

function var0.printDecode(arg0)
	local var0 = arg0:decodePuzzla(arg0.paths)
	local var1 = ""

	for iter0, iter1 in ipairs(var0) do
		var1 = var1 .. " - " .. iter1.dir
	end

	print(var1)
end

function var0.revertPuzzla(arg0, arg1)
	arg0:orderDisorganize(arg1, var1)
end

function var0.getBlockItem(arg0)
	local var0

	for iter0, iter1 in ipairs(arg0.puzzlaItems) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3:isBlock() then
				var0 = iter3

				break
			end
		end
	end

	return var0
end

function var0.orderDisorganize(arg0, arg1, arg2, arg3)
	local var0 = {}

	arg0.blockEvent = true

	local var1 = arg0:getBlockItem()
	local var2 = {}

	local function var3(arg0)
		local var0 = var1:getSurroundPosition()[arg0]
		local var1 = arg0:getItemByPosition(var0)

		arg0:swop(var1, var1)
		table.insert(var0, var8[arg0])
	end

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var2, function(arg0)
			if arg2 == 0 then
				var3(iter1)
				arg0()
			else
				arg0:removeTimer()

				arg0.delayTimer = Timer.New(function()
					arg0:removeTimer()
					var3(iter1)
					arg0()
				end, arg2, 1)

				arg0.delayTimer:Start()
			end
		end)
	end

	seriesAsync(var2, function()
		arg0.blockEvent = nil

		if arg3 then
			arg3(var0)
		end
	end)
end

function var0.isFinish(arg0)
	for iter0, iter1 in ipairs(arg0.puzzlaItems) do
		for iter2, iter3 in ipairs(iter1) do
			assert(isa(iter3, PuzzlaItem), "item should instance of PuzzlaItem")

			if not iter3:isRestoration() then
				return false
			end
		end
	end

	return true
end

function var0.removeTimer(arg0)
	if arg0.delayTimer then
		arg0.delayTimer:Stop()

		arg0.delayTimer = nil
	end
end

function var0.dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:removeTimer()
end

return var0
