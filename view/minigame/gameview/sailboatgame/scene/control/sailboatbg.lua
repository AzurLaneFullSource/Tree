local var0 = class("SailBoatBg")
local var1 = 1920
local var2 = 1080
local var3 = Vector2(1, 0)
local var4 = Vector2(-1, 0)
local var5 = Vector2(0, 1)
local var6 = Vector2(0, -1)
local var7

function var0.Ctor(arg0, arg1, arg2)
	var7 = SailBoatGameVo
	arg0._tf = arg1
	arg0._event = arg2
	arg0._layerBack = findTF(arg0._tf, "scene_background/content")
	arg0._layerMid = findTF(arg0._tf, "scene/content")
	arg0._layerTop = findTF(arg0._tf, "scene_front/content")
	arg0._layerContent = nil
	arg0._bgGrids = {}
	arg0._bgDic = {}
	arg0._bgPrepareGrids = {}
	arg0._bgTfPool = {}
	arg0._sceneWidth = var7.scene_width
	arg0._sceneHeight = var7.scene_height
end

function var0.setRuleData(arg0, arg1)
	arg0._bgTplName = arg1.tpl
	arg0._layerType = arg1.layer
	arg0._showType = arg1.show
	arg0._width = arg1.width
	arg0._height = arg1.height
	arg0._removeBound = arg1.remove_bound

	if arg0._layerType == SailBoatGameConst.bg_layer_back then
		arg0._layerContent = arg0._layerBack
	elseif arg0._layerType == SailBoatGameConst.bg_layer_mid then
		arg0._layerContent = arg0._layerMid
	elseif arg0._layerType == SailBoatGameConst.bg_layer_top then
		arg0._layerContent = arg0._layerTop
	end

	arg0._content = findTF(arg0._layerContent, arg1.content)
end

function var0.start(arg0)
	arg0:createGrid(0, 0, true)
	arg0:createGrid(0, 0, true)
	arg0:createGrid(0, 0, true)
	arg0:clear()
	arg0:createGrid(0, 0, true)
	arg0:updateGrid()
end

function var0.step(arg0)
	arg0:checkEmptyGrid()
	arg0:updateGrid()
end

function var0.updateGrid(arg0)
	for iter0 = #arg0._bgGrids, 1, -1 do
		local var0 = arg0._bgGrids[iter0]
		local var1 = var0.w
		local var2 = var0.h

		var0.anchoredPos.x = arg0._moveAmount.x + var0.pos.x
		var0.anchoredPos.y = arg0._moveAmount.y + var0.pos.y

		local var3 = false

		if math.abs(var0.anchoredPos.x) > arg0._removeBound.x or math.abs(var0.anchoredPos.y) > arg0._removeBound.y then
			if not var0.stop then
				var0.stop = true

				arg0:removeGrid(var0)
			end
		else
			var0.stop = false
		end

		if not var0.stop then
			if math.abs(var0.anchoredPos.x) < arg0._sceneWidth and math.abs(var0.anchoredPos.y) < arg0._sceneHeight then
				local var4 = arg0:checkPrepareCreate(var0)

				if #var4 > 0 then
					arg0:createPrepareGrid(var4)
				end
			end

			if var0.tf == nil then
				var0.tf = arg0:getBgTf()
				GetComponent(var0.tf, typeof(CanvasGroup)).alpha = 1
			end

			var0.tf.anchoredPosition = var0.anchoredPos
		end
	end

	for iter1 = #arg0._bgPrepareGrids, 1, -1 do
		local var5 = table.remove(arg0._bgPrepareGrids, iter1)

		table.insert(arg0._bgGrids, var5)
	end
end

function var0.checkEmptyGrid(arg0)
	return
end

function var0.checkPrepareCreate(arg0, arg1)
	local var0 = {}
	local var1 = arg1.w
	local var2 = arg1.h
	local var3 = arg1.anchoredPos
	local var4

	if var3.x + arg0._width / 2 < arg0._sceneWidth / 2 + var7.fill_offsetX then
		local var5 = arg0:checkPrepare(var1, var2, var3)

		if var5 then
			table.insert(var0, var5)
		end
	end

	if var3.x - arg0._width / 2 > -arg0._sceneWidth / 2 - var7.fill_offsetX then
		local var6 = arg0:checkPrepare(var1, var2, var4)

		if var6 then
			table.insert(var0, var6)
		end
	end

	if var3.y + arg0._height / 2 < arg0._sceneHeight / 2 + var7.fill_offsetY then
		local var7 = arg0:checkPrepare(var1, var2, var5)

		if var7 then
			table.insert(var0, var7)
		end
	end

	if var3.y - arg0._height / 2 > -arg0._sceneHeight / 2 - var7.fill_offsetY then
		local var8 = arg0:checkPrepare(var1, var2, var6)

		if var8 then
			table.insert(var0, var8)
		end
	end

	return var0
end

function var0.checkPrepare(arg0, arg1, arg2, arg3)
	local var0, var1 = arg0:getDirecWH(arg1, arg2, arg3)
	local var2 = arg0:getGrid(var0, var1)
	local var3 = arg0:getPrepareGrid(var0, var1)

	assert(not var2 or not var3, "创建了两个相同位置的grid,请检查代码")

	if not var2 and not var3 then
		return {
			w = var0,
			h = var1
		}
	end

	return nil
end

function var0.getPrepareGrid(arg0, arg1, arg2)
	for iter0 = 1, #arg0._bgPrepareGrids do
		local var0 = arg0._bgPrepareGrids[iter0]

		if var0.w == arg1 and var0.h == arg2 then
			return var0
		end
	end

	return nil
end

function var0.createPrepareGrid(arg0, arg1)
	for iter0 = 1, #arg1 do
		local var0 = arg1[iter0]
		local var1 = arg0:createGrid(var0.w, var0.h, false)

		table.insert(arg0._bgPrepareGrids, var1)
	end
end

function var0.getDirecWH(arg0, arg1, arg2, arg3)
	return arg1 + arg3.x, arg2 + arg3.y
end

function var0.getGrid(arg0, arg1, arg2)
	for iter0 = 1, #arg0._bgGrids do
		local var0 = arg0._bgGrids[iter0]

		if var0.w == arg1 and var0.h == arg2 then
			return var0
		end
	end

	return nil
end

function var0.createGrid(arg0, arg1, arg2, arg3)
	if not arg0._bgDic[arg1] then
		arg0._bgDic[arg1] = {}
	end

	if arg0._bgDic[arg1][arg2] then
		print("已经存在的grid 无需创建")

		return
	end

	local var0 = {
		pos = Vector2(arg1 * arg0._width, arg2 * arg0._height),
		w = arg1,
		h = arg2,
		anchoredPos = Vector2(0, 0)
	}

	if arg3 then
		table.insert(arg0._bgGrids, var0)

		arg0._bgDic[var0.w][var0.h] = var0
	end

	return var0
end

function var0.removeGrid(arg0, arg1)
	if arg1.tf then
		local var0 = arg1.tf

		GetComponent(arg1.tf, typeof(CanvasGroup)).alpha = 0

		table.insert(arg0._bgTfPool, var0)

		arg1.tf = nil
	end

	arg0._bgDic[arg1.w][arg1.h] = nil
end

function var0.getBgTf(arg0)
	local var0

	if arg0._bgTfPool and #arg0._bgTfPool > 0 then
		var0 = table.remove(arg0._bgTfPool, 1)
	end

	if not var0 then
		var0 = var7.GetGameBgTf(arg0._bgTplName)

		setParent(var0, arg0._content)
	end

	return var0
end

function var0.stop(arg0)
	return
end

function var0.setMoveAmount(arg0, arg1)
	arg0._moveAmount = arg1
end

function var0.clear(arg0)
	arg0._moveAmount = Vector2(0, 0)

	for iter0 = #arg0._bgGrids, 1, -1 do
		local var0 = table.remove(arg0._bgGrids, iter0)

		if var0.tf then
			GetComponent(var0.tf, typeof(CanvasGroup)).alpha = 0

			table.insert(arg0._bgTfPool, var0.tf)
		end
	end

	for iter1 = #arg0._bgPrepareGrids, 1, -1 do
		local var1 = table.remove(arg0._bgPrepareGrids, iter1)

		GetComponent(var1.tf, typeof(CanvasGroup)).alpha = 0

		table.insert(arg0._bgTfPool, var1.tf)
	end

	arg0._bgDic = {}
end

function var0.dispose(arg0)
	return
end

return var0
