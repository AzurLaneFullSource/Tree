ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleMap")

var0_0.Battle.BattleMap = var1_0
var1_0.__name = "BattleMap"

local var2_0 = pg.map_data

var1_0.LAYERS = {
	"close",
	"mid",
	"long",
	"sky",
	"sea"
}

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = GameObject.New("scenes")
	arg0_1.mapLayerCtrls = {}
	arg0_1.seaAnimList = {}

	local var0_1 = pg.map_data[arg1_1]

	assert(var0_1, "找不到地图: " .. arg1_1)

	for iter0_1, iter1_1 in ipairs(var1_0.LAYERS) do
		local var1_1 = GameObject.New(iter1_1 .. "Layer")

		setParent(var1_1, arg0_1._go, false)

		if iter1_1 ~= "sky" then
			local var2_1 = GetOrAddComponent(var1_1, "MapLayerCtrl")

			var2_1.leftBorder = var0_1.range_left
			var2_1.rightBorder = var0_1.range_right
			var2_1.speedToLeft = var0_1[iter1_1 .. "_speed"] or 0
			var2_1.speedScaler = 1

			table.insert(arg0_1.mapLayerCtrls, var2_1)
		end

		local var3_1 = arg0_1.GetMapResNames(arg1_1, iter1_1)
		local var4_1 = string.split(var0_1[iter1_1 .. "_pos"], ";")
		local var5_1 = string.split(var0_1[iter1_1 .. "_scale"], ";")

		for iter2_1, iter3_1 in ipairs(var3_1) do
			local var6_1 = var0_0.Battle.BattleResourceManager.GetInstance():InstMap(iter3_1)

			tf(var6_1).localScale = string2vector3(var5_1[iter2_1])

			setParent(var6_1, var1_1, false)

			tf(var6_1).localPosition = string2vector3(var4_1[iter2_1])

			local var7_1 = var6_1:GetComponent(typeof(SeaAnim))

			if var7_1 then
				table.insert(arg0_1.seaAnimList, var7_1)
			end

			local var8_1 = var6_1:GetComponent(typeof(Renderer))

			if var8_1 then
				var8_1.sortingOrder = -1500
			end
		end

		if iter1_1 == "sea" then
			arg0_1._buffer = var1_1.transform:Find("gelidai(Clone)")

			if arg0_1._buffer then
				arg0_1._bufferRenderer = arg0_1._buffer:GetComponent("SpriteRenderer")
				arg0_1._bufferRenderer.color = Color.New(1, 1, 1, 0)
				arg0_1._bufferRenderer.sortingOrder = -1500
			end
		end
	end

	arg0_1:UpdateSpeedScaler()

	return arg0_1._go
end

function var1_0.ShiftSurface(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	if arg0_2._shiftTimer then
		return
	end

	local var0_2 = arg1_2
	local var1_2

	if arg2_2 < arg1_2 then
		var1_2 = -1
	elseif arg1_2 < arg2_2 then
		var1_2 = 1
	else
		return
	end

	local function var2_2()
		if (arg2_2 - var0_2) * var1_2 > 0 then
			var0_0.Battle.BattleVariable.AppendMapFactor("seaSurfaceShift", var0_2)
			arg0_2:updateSeaSpeed()
			arg0_2:UpdateSpeedScaler()

			var0_2 = var0_2 + var1_2
		else
			pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_2._shiftTimer)

			arg0_2._shiftTimer = nil

			if arg4_2 then
				arg4_2()
			end
		end
	end

	arg0_2._shiftTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, arg3_2, var2_2, true)
end

function var1_0.UpdateSpeedScaler(arg0_4)
	arg0_4:setSpeedScaler(var0_0.Battle.BattleVariable.MapSpeedRatio)
end

function var1_0.UpdateBufferAlpha(arg0_5, arg1_5)
	local var0_5 = arg1_5 * 0.1

	arg0_5._bufferRenderer.color = Color.New(1, 1, 1, var0_5)
end

function var1_0.SetExposeLine(arg0_6, arg1_6, arg2_6, arg3_6)
	function instantiateLine(arg0_7, arg1_7)
		local var0_7 = var0_0.Battle.BattleResourceManager.GetInstance():InstMap(arg1_7)
		local var1_7 = arg0_6._go.transform:Find("seaLayer")

		setParent(var0_7, var1_7, false)

		local var2_7 = var0_7:GetComponent("SpriteRenderer")
		local var3_7 = var2_7.bounds.extents.max

		var2_7.sortingOrder = -1501

		local var4_7 = tf(var0_7).localScale

		tf(var0_7).localScale = Vector3.New(arg1_6 * var4_7.x, var4_7.y, var4_7.z)

		local var5_7 = tf(var0_7).localPosition
		local var6_7 = var2_7.bounds.extents.x * arg1_6

		tf(var0_7).localPosition = Vector3.New(arg0_7 - var6_7, var5_7.y, var5_7.z)
	end

	instantiateLine(arg2_6, "visionLine")

	if arg3_6 then
		instantiateLine(arg3_6, "exposeLine")
	end
end

function var1_0.setSpeedScaler(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.mapLayerCtrls) do
		iter1_8.speedScaler = arg1_8
	end
end

function var1_0.updateSeaSpeed(arg0_9)
	local var0_9 = var0_0.Battle.BattleVariable.MapSpeedRatio

	for iter0_9, iter1_9 in ipairs(arg0_9.seaAnimList) do
		iter1_9:AdjustAnimSpeed(var0_9)
	end
end

function var1_0.Dispose(arg0_10)
	if arg0_10._shiftTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_10._shiftTimer)
	end

	if arg0_10._go then
		Object.Destroy(arg0_10._go)

		arg0_10._go = nil
		arg0_10._buffer = nil
		arg0_10._bufferRenderer = nil
	end
end

function var1_0.GetMapResNames(arg0_11, arg1_11)
	local var0_11 = pg.map_data[arg0_11]

	return string.split(var0_11[arg1_11 .. "_shot"], ";")
end

function var1_0.setActive(arg0_12, arg1_12)
	SetActive(arg0_12._go, arg1_12)
end
