local var0_0 = class("SailBoatBg")
local var1_0 = 1920
local var2_0 = 1080
local var3_0 = Vector2(1, 0)
local var4_0 = Vector2(-1, 0)
local var5_0 = Vector2(0, 1)
local var6_0 = Vector2(0, -1)
local var7_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var7_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._layerBack = findTF(arg0_1._tf, "scene_background/content")
	arg0_1._layerMid = findTF(arg0_1._tf, "scene/content")
	arg0_1._layerTop = findTF(arg0_1._tf, "scene_front/content")
	arg0_1._layerContent = nil
	arg0_1._bgGrids = {}
	arg0_1._bgDic = {}
	arg0_1._bgPrepareGrids = {}
	arg0_1._bgTfPool = {}
	arg0_1._sceneWidth = var7_0.scene_width
	arg0_1._sceneHeight = var7_0.scene_height
end

function var0_0.setRuleData(arg0_2, arg1_2)
	arg0_2._bgTplName = arg1_2.tpl
	arg0_2._layerType = arg1_2.layer
	arg0_2._showType = arg1_2.show
	arg0_2._width = arg1_2.width
	arg0_2._height = arg1_2.height
	arg0_2._removeBound = arg1_2.remove_bound

	if arg0_2._layerType == SailBoatGameConst.bg_layer_back then
		arg0_2._layerContent = arg0_2._layerBack
	elseif arg0_2._layerType == SailBoatGameConst.bg_layer_mid then
		arg0_2._layerContent = arg0_2._layerMid
	elseif arg0_2._layerType == SailBoatGameConst.bg_layer_top then
		arg0_2._layerContent = arg0_2._layerTop
	end

	arg0_2._content = findTF(arg0_2._layerContent, arg1_2.content)
end

function var0_0.start(arg0_3)
	arg0_3:createGrid(0, 0, true)
	arg0_3:createGrid(0, 0, true)
	arg0_3:createGrid(0, 0, true)
	arg0_3:clear()
	arg0_3:createGrid(0, 0, true)
	arg0_3:updateGrid()
end

function var0_0.step(arg0_4)
	arg0_4:checkEmptyGrid()
	arg0_4:updateGrid()
end

function var0_0.updateGrid(arg0_5)
	for iter0_5 = #arg0_5._bgGrids, 1, -1 do
		local var0_5 = arg0_5._bgGrids[iter0_5]
		local var1_5 = var0_5.w
		local var2_5 = var0_5.h

		var0_5.anchoredPos.x = arg0_5._moveAmount.x + var0_5.pos.x
		var0_5.anchoredPos.y = arg0_5._moveAmount.y + var0_5.pos.y

		local var3_5 = false

		if math.abs(var0_5.anchoredPos.x) > arg0_5._removeBound.x or math.abs(var0_5.anchoredPos.y) > arg0_5._removeBound.y then
			if not var0_5.stop then
				var0_5.stop = true

				arg0_5:removeGrid(var0_5)
			end
		else
			var0_5.stop = false
		end

		if not var0_5.stop then
			if math.abs(var0_5.anchoredPos.x) < arg0_5._sceneWidth and math.abs(var0_5.anchoredPos.y) < arg0_5._sceneHeight then
				local var4_5 = arg0_5:checkPrepareCreate(var0_5)

				if #var4_5 > 0 then
					arg0_5:createPrepareGrid(var4_5)
				end
			end

			if var0_5.tf == nil then
				var0_5.tf = arg0_5:getBgTf()
				GetComponent(var0_5.tf, typeof(CanvasGroup)).alpha = 1
			end

			var0_5.tf.anchoredPosition = var0_5.anchoredPos
		end
	end

	for iter1_5 = #arg0_5._bgPrepareGrids, 1, -1 do
		local var5_5 = table.remove(arg0_5._bgPrepareGrids, iter1_5)

		table.insert(arg0_5._bgGrids, var5_5)
	end
end

function var0_0.checkEmptyGrid(arg0_6)
	return
end

function var0_0.checkPrepareCreate(arg0_7, arg1_7)
	local var0_7 = {}
	local var1_7 = arg1_7.w
	local var2_7 = arg1_7.h
	local var3_7 = arg1_7.anchoredPos
	local var4_7

	if var3_7.x + arg0_7._width / 2 < arg0_7._sceneWidth / 2 + var7_0.fill_offsetX then
		local var5_7 = arg0_7:checkPrepare(var1_7, var2_7, var3_0)

		if var5_7 then
			table.insert(var0_7, var5_7)
		end
	end

	if var3_7.x - arg0_7._width / 2 > -arg0_7._sceneWidth / 2 - var7_0.fill_offsetX then
		local var6_7 = arg0_7:checkPrepare(var1_7, var2_7, var4_0)

		if var6_7 then
			table.insert(var0_7, var6_7)
		end
	end

	if var3_7.y + arg0_7._height / 2 < arg0_7._sceneHeight / 2 + var7_0.fill_offsetY then
		local var7_7 = arg0_7:checkPrepare(var1_7, var2_7, var5_0)

		if var7_7 then
			table.insert(var0_7, var7_7)
		end
	end

	if var3_7.y - arg0_7._height / 2 > -arg0_7._sceneHeight / 2 - var7_0.fill_offsetY then
		local var8_7 = arg0_7:checkPrepare(var1_7, var2_7, var6_0)

		if var8_7 then
			table.insert(var0_7, var8_7)
		end
	end

	return var0_7
end

function var0_0.checkPrepare(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8, var1_8 = arg0_8:getDirecWH(arg1_8, arg2_8, arg3_8)
	local var2_8 = arg0_8:getGrid(var0_8, var1_8)
	local var3_8 = arg0_8:getPrepareGrid(var0_8, var1_8)

	assert(not var2_8 or not var3_8, "创建了两个相同位置的grid,请检查代码")

	if not var2_8 and not var3_8 then
		return {
			w = var0_8,
			h = var1_8
		}
	end

	return nil
end

function var0_0.getPrepareGrid(arg0_9, arg1_9, arg2_9)
	for iter0_9 = 1, #arg0_9._bgPrepareGrids do
		local var0_9 = arg0_9._bgPrepareGrids[iter0_9]

		if var0_9.w == arg1_9 and var0_9.h == arg2_9 then
			return var0_9
		end
	end

	return nil
end

function var0_0.createPrepareGrid(arg0_10, arg1_10)
	for iter0_10 = 1, #arg1_10 do
		local var0_10 = arg1_10[iter0_10]
		local var1_10 = arg0_10:createGrid(var0_10.w, var0_10.h, false)

		table.insert(arg0_10._bgPrepareGrids, var1_10)
	end
end

function var0_0.getDirecWH(arg0_11, arg1_11, arg2_11, arg3_11)
	return arg1_11 + arg3_11.x, arg2_11 + arg3_11.y
end

function var0_0.getGrid(arg0_12, arg1_12, arg2_12)
	for iter0_12 = 1, #arg0_12._bgGrids do
		local var0_12 = arg0_12._bgGrids[iter0_12]

		if var0_12.w == arg1_12 and var0_12.h == arg2_12 then
			return var0_12
		end
	end

	return nil
end

function var0_0.createGrid(arg0_13, arg1_13, arg2_13, arg3_13)
	if not arg0_13._bgDic[arg1_13] then
		arg0_13._bgDic[arg1_13] = {}
	end

	if arg0_13._bgDic[arg1_13][arg2_13] then
		print("已经存在的grid 无需创建")

		return
	end

	local var0_13 = {
		pos = Vector2(arg1_13 * arg0_13._width, arg2_13 * arg0_13._height),
		w = arg1_13,
		h = arg2_13,
		anchoredPos = Vector2(0, 0)
	}

	if arg3_13 then
		table.insert(arg0_13._bgGrids, var0_13)

		arg0_13._bgDic[var0_13.w][var0_13.h] = var0_13
	end

	return var0_13
end

function var0_0.removeGrid(arg0_14, arg1_14)
	if arg1_14.tf then
		local var0_14 = arg1_14.tf

		GetComponent(arg1_14.tf, typeof(CanvasGroup)).alpha = 0

		table.insert(arg0_14._bgTfPool, var0_14)

		arg1_14.tf = nil
	end

	arg0_14._bgDic[arg1_14.w][arg1_14.h] = nil
end

function var0_0.getBgTf(arg0_15)
	local var0_15

	if arg0_15._bgTfPool and #arg0_15._bgTfPool > 0 then
		var0_15 = table.remove(arg0_15._bgTfPool, 1)
	end

	if not var0_15 then
		var0_15 = var7_0.GetGameBgTf(arg0_15._bgTplName)

		setParent(var0_15, arg0_15._content)
	end

	return var0_15
end

function var0_0.stop(arg0_16)
	return
end

function var0_0.setMoveAmount(arg0_17, arg1_17)
	arg0_17._moveAmount = arg1_17
end

function var0_0.clear(arg0_18)
	arg0_18._moveAmount = Vector2(0, 0)

	for iter0_18 = #arg0_18._bgGrids, 1, -1 do
		local var0_18 = table.remove(arg0_18._bgGrids, iter0_18)

		if var0_18.tf then
			GetComponent(var0_18.tf, typeof(CanvasGroup)).alpha = 0

			table.insert(arg0_18._bgTfPool, var0_18.tf)
		end
	end

	for iter1_18 = #arg0_18._bgPrepareGrids, 1, -1 do
		local var1_18 = table.remove(arg0_18._bgPrepareGrids, iter1_18)

		GetComponent(var1_18.tf, typeof(CanvasGroup)).alpha = 0

		table.insert(arg0_18._bgTfPool, var1_18.tf)
	end

	arg0_18._bgDic = {}
end

function var0_0.dispose(arg0_19)
	return
end

return var0_0
