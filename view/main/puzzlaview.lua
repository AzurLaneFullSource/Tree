local var0_0 = class("PuzzlaView")
local var1_0 = 0.3
local var2_0 = 0
local var3_0 = 5
local var4_0 = 4
local var5_0 = 4
local var6_0 = {
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
local var7_0 = true
local var8_0 = {
	"BOTTOM",
	"TOP",
	"LEFT",
	"RIGHT"
}
local var9_0 = {
	TOP = 2,
	BOTTOM = 1,
	LEFT = 3,
	RIGHT = 4
}
local var10_0 = {
	BOTTOM = 2,
	TOP = 1,
	LEFT = 4,
	RIGHT = 3
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.showDesc = arg1_1.descs
	arg0_1.openlist = arg1_1.list
	arg0_1._go = arg1_1.go
	arg0_1._tf = tf(arg0_1._go)
	arg0_1.fetch = arg1_1.fetch

	arg0_1:load(arg1_1.bg, arg2_1)

	arg0_1.onFinish = nil
end

function var0_0.load(arg0_2, arg1_2, arg2_2)
	arg0_2.puzzlaWidth, arg0_2.puzzlaHeight = 0, 0
	arg0_2.startPosition = Vector2(0, 0)
	arg0_2.totalCount = var4_0 * var5_0
	arg0_2.pics = {}

	for iter0_2 = 1, arg0_2.totalCount do
		local var0_2 = "pic_" .. iter0_2

		arg0_2.pics[iter0_2] = GetSpriteFromAtlas("puzzla/" .. arg1_2, var0_2)
	end

	if #arg0_2.pics > 0 then
		local var1_2 = arg0_2.pics[1]

		arg0_2.puzzlaWidth = var1_2.rect.width * var4_0
		arg0_2.puzzlaHeight = var1_2.rect.height * var5_0
		arg0_2.startPosition = Vector2(arg0_2.puzzlaWidth / 2, arg0_2.puzzlaHeight / 2)

		arg0_2:init()
	end

	if arg2_2 then
		arg2_2()
	end
end

function var0_0.init(arg0_3)
	arg0_3.puzzlaItems = {}

	local var0_3 = 1

	for iter0_3 = 1, var4_0 do
		local var1_3 = {}

		for iter1_3 = 1, var5_0 do
			local var2_3 = table.contains(arg0_3.openlist, var0_3)
			local var3_3

			if not var2_3 and arg0_3.showDesc[var0_3] then
				var3_3 = arg0_3.showDesc[var0_3]
			end

			local var4_3 = arg0_3:createItem(arg0_3.pics[var0_3], Vector2(iter1_3, iter0_3), var0_3, var2_3, var3_3)
			local var5_3 = Vector2((iter1_3 - 1) * var4_3.width - arg0_3.startPosition.x, arg0_3.startPosition.y + (iter0_3 - 1) * var4_3.height * -1)

			var4_3:setLocalPosition(var5_3)
			table.insert(var1_3, var4_3)

			var0_3 = var0_3 + 1
		end

		table.insert(arg0_3.puzzlaItems, var1_3)
	end

	if arg0_3.fetch then
		arg0_3.blockEvent = true

		arg0_3:getBlockItem():setHightLight()

		return
	end

	if var7_0 and #var6_0 > 0 then
		arg0_3:disorganizePuzzla(var6_0)
	else
		arg0_3:disorganizePuzzla()
	end
end

function var0_0.createItem(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
	local var0_4 = GameObject(arg2_4.x .. "-" .. arg2_4.y)

	var0_4:AddComponent(typeof(Image))
	SetParent(var0_4, arg0_4._tf)

	local var1_4 = PuzzlaItem.New(var0_4, arg3_4, arg4_4, arg5_4)
	local var2_4 = arg3_4 == arg0_4.totalCount

	var1_4:update(arg1_4, arg2_4, var2_4)
	onButton(arg0_4, var1_4._go, function()
		if arg0_4.blockEvent then
			return
		end

		arg0_4:checkSurround(var1_4)
	end, SFX_PANEL)

	return var1_4
end

function var0_0.checkSurround(arg0_6, arg1_6)
	local var0_6 = arg1_6:getSurroundPosition()
	local var1_6 = arg0_6:getBlockItemByPositions(var0_6)

	if var1_6 then
		arg0_6:swop(arg1_6, var1_6)
	end
end

function var0_0.swop(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg2_7:getPosition()
	local var1_7 = arg1_7:getPosition()
	local var2_7 = arg2_7:getCurrIndex()
	local var3_7 = arg1_7:getCurrIndex()
	local var4_7 = arg2_7:getLocalPosition()
	local var5_7 = arg1_7:getLocalPosition()

	arg1_7:setPosition(var0_7, var2_7)
	arg2_7:setPosition(var1_7, var3_7)

	arg0_7.puzzlaItems[var0_7.y][var0_7.x], arg0_7.puzzlaItems[var1_7.y][var1_7.x] = arg1_7, arg2_7

	arg2_7:setLocalPosition(var5_7)
	arg1_7:setLocalPosition(var4_7)

	if arg0_7:isFinish() then
		arg0_7.blockEvent = true

		arg2_7:setHightLight()

		if arg0_7.onFinish then
			arg0_7.onFinish()
		end
	else
		arg2_7:setBlock()
	end
end

function var0_0.getBlockItemByPositions(arg0_8, arg1_8)
	local var0_8

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		if arg0_8:isValidPosition(iter1_8) and arg0_8:isBlockItem(iter1_8) then
			var0_8 = arg0_8:getItemByPosition(iter1_8)

			break
		end
	end

	return var0_8
end

function var0_0.isBlockItem(arg0_9, arg1_9)
	return arg0_9:getItemByPosition(arg1_9):isBlock()
end

function var0_0.getItemByPosition(arg0_10, arg1_10)
	assert(arg0_10.puzzlaItems[arg1_10.y], "position y" .. arg1_10.y)

	return arg0_10.puzzlaItems[arg1_10.y][arg1_10.x]
end

function var0_0.isValidPosition(arg0_11, arg1_11)
	if arg1_11.x > 0 and arg1_11.y > 0 and arg1_11.x <= var4_0 and arg1_11.y <= var5_0 then
		return true
	end

	return false
end

function var0_0.printTable(arg0_12)
	for iter0_12, iter1_12 in ipairs(arg0_12.puzzlaItems) do
		local var0_12 = ""

		for iter2_12, iter3_12 in ipairs(iter1_12) do
			var0_12 = var0_12 .. iter0_12 .. "-" .. iter2_12 .. "-" .. iter3_12:getCurrIndex() .. " "
		end

		print(var0_12)
	end
end

function var0_0.disorganizePuzzla(arg0_13, arg1_13)
	arg0_13.paths = {}

	local function var0_13()
		return
	end

	if arg1_13 and #arg1_13 > 0 then
		arg0_13:orderDisorganize(arg1_13, var2_0, function(arg0_15)
			arg0_13.paths = arg0_15

			var0_13()
		end)
	else
		for iter0_13 = 1, var3_0 do
			local var1_13 = arg0_13:disorganizeStep()

			table.insert(arg0_13.paths, var1_13)

			arg0_13.prevDir = var10_0[var1_13]
		end

		var0_13()
	end
end

function var0_0.disorganizeStep(arg0_16)
	local var0_16 = arg0_16:getBlockItem()

	local function var1_16(arg0_17)
		if arg0_16.prevDir then
			return arg0_16.prevDir == arg0_17
		end

		return false
	end

	local var2_16 = var0_16:getSurroundPosition()
	local var3_16 = {}

	for iter0_16, iter1_16 in ipairs(var2_16) do
		if arg0_16:isValidPosition(iter1_16) and not var1_16(iter0_16) then
			table.insert(var3_16, {
				pos = iter1_16,
				dir = var8_0[iter0_16]
			})
		end
	end

	local var4_16 = var3_16[math.random(1, #var3_16)]
	local var5_16 = arg0_16:getItemByPosition(var4_16.pos)

	arg0_16:swop(var5_16, var0_16)

	return var4_16.dir
end

function var0_0.printPaths(arg0_18)
	local var0_18 = ""

	for iter0_18, iter1_18 in ipairs(arg0_18.paths or {}) do
		var0_18 = var0_18 .. var9_0[iter1_18] .. ","
	end

	print(var0_18)
end

function var0_0.decodePuzzla(arg0_19, arg1_19)
	local var0_19 = {}

	for iter0_19, iter1_19 in ipairs(arg1_19 or {}) do
		local var1_19 = var10_0[iter1_19]
		local var2_19 = var8_0[var1_19]
		local var3_19 = var9_0[var2_19]

		table.insert(var0_19, 1, {
			dir = var2_19,
			index = var3_19
		})
	end

	return var0_19
end

function var0_0.aotuDecode(arg0_20)
	local var0_20 = arg0_20:decodePuzzla(arg0_20.paths)
	local var1_20 = {}

	for iter0_20, iter1_20 in ipairs(var0_20) do
		table.insert(var1_20, iter1_20.index)
	end

	arg0_20:revertPuzzla(var1_20)
end

function var0_0.printDecode(arg0_21)
	local var0_21 = arg0_21:decodePuzzla(arg0_21.paths)
	local var1_21 = ""

	for iter0_21, iter1_21 in ipairs(var0_21) do
		var1_21 = var1_21 .. " - " .. iter1_21.dir
	end

	print(var1_21)
end

function var0_0.revertPuzzla(arg0_22, arg1_22)
	arg0_22:orderDisorganize(arg1_22, var1_0)
end

function var0_0.getBlockItem(arg0_23)
	local var0_23

	for iter0_23, iter1_23 in ipairs(arg0_23.puzzlaItems) do
		for iter2_23, iter3_23 in ipairs(iter1_23) do
			if iter3_23:isBlock() then
				var0_23 = iter3_23

				break
			end
		end
	end

	return var0_23
end

function var0_0.orderDisorganize(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = {}

	arg0_24.blockEvent = true

	local var1_24 = arg0_24:getBlockItem()
	local var2_24 = {}

	local function var3_24(arg0_25)
		local var0_25 = var1_24:getSurroundPosition()[arg0_25]
		local var1_25 = arg0_24:getItemByPosition(var0_25)

		arg0_24:swop(var1_25, var1_24)
		table.insert(var0_24, var8_0[arg0_25])
	end

	for iter0_24, iter1_24 in ipairs(arg1_24) do
		table.insert(var2_24, function(arg0_26)
			if arg2_24 == 0 then
				var3_24(iter1_24)
				arg0_26()
			else
				arg0_24:removeTimer()

				arg0_24.delayTimer = Timer.New(function()
					arg0_24:removeTimer()
					var3_24(iter1_24)
					arg0_26()
				end, arg2_24, 1)

				arg0_24.delayTimer:Start()
			end
		end)
	end

	seriesAsync(var2_24, function()
		arg0_24.blockEvent = nil

		if arg3_24 then
			arg3_24(var0_24)
		end
	end)
end

function var0_0.isFinish(arg0_29)
	for iter0_29, iter1_29 in ipairs(arg0_29.puzzlaItems) do
		for iter2_29, iter3_29 in ipairs(iter1_29) do
			assert(isa(iter3_29, PuzzlaItem), "item should instance of PuzzlaItem")

			if not iter3_29:isRestoration() then
				return false
			end
		end
	end

	return true
end

function var0_0.removeTimer(arg0_30)
	if arg0_30.delayTimer then
		arg0_30.delayTimer:Stop()

		arg0_30.delayTimer = nil
	end
end

function var0_0.dispose(arg0_31)
	pg.DelegateInfo.Dispose(arg0_31)
	arg0_31:removeTimer()
end

return var0_0
