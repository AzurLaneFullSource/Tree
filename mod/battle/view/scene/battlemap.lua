ys = ys or {}

local var0 = ys
local var1 = class("BattleMap")

var0.Battle.BattleMap = var1
var1.__name = "BattleMap"

local var2 = pg.map_data

var1.LAYERS = {
	"close",
	"mid",
	"long",
	"sky",
	"sea"
}

function var1.Ctor(arg0, arg1)
	arg0._go = GameObject.New("scenes")
	arg0.mapLayerCtrls = {}
	arg0.seaAnimList = {}

	local var0 = pg.map_data[arg1]

	assert(var0, "找不到地图: " .. arg1)

	for iter0, iter1 in ipairs(var1.LAYERS) do
		local var1 = GameObject.New(iter1 .. "Layer")

		setParent(var1, arg0._go, false)

		if iter1 ~= "sky" then
			local var2 = GetOrAddComponent(var1, "MapLayerCtrl")

			var2.leftBorder = var0.range_left
			var2.rightBorder = var0.range_right
			var2.speedToLeft = var0[iter1 .. "_speed"] or 0
			var2.speedScaler = 1

			table.insert(arg0.mapLayerCtrls, var2)
		end

		local var3 = arg0.GetMapResNames(arg1, iter1)
		local var4 = string.split(var0[iter1 .. "_pos"], ";")
		local var5 = string.split(var0[iter1 .. "_scale"], ";")

		for iter2, iter3 in ipairs(var3) do
			local var6 = var0.Battle.BattleResourceManager.GetInstance():InstMap(iter3)

			tf(var6).localScale = string2vector3(var5[iter2])

			setParent(var6, var1, false)

			tf(var6).localPosition = string2vector3(var4[iter2])

			local var7 = var6:GetComponent(typeof(SeaAnim))

			if var7 then
				table.insert(arg0.seaAnimList, var7)
			end

			local var8 = var6:GetComponent(typeof(Renderer))

			if var8 then
				var8.sortingOrder = -1500
			end
		end

		if iter1 == "sea" then
			arg0._buffer = var1.transform:Find("gelidai(Clone)")

			if arg0._buffer then
				arg0._bufferRenderer = arg0._buffer:GetComponent("SpriteRenderer")
				arg0._bufferRenderer.color = Color.New(1, 1, 1, 0)
				arg0._bufferRenderer.sortingOrder = -1500
			end
		end
	end

	arg0:UpdateSpeedScaler()

	return arg0._go
end

function var1.ShiftSurface(arg0, arg1, arg2, arg3, arg4)
	if arg0._shiftTimer then
		return
	end

	local var0 = arg1
	local var1

	if arg2 < arg1 then
		var1 = -1
	elseif arg1 < arg2 then
		var1 = 1
	else
		return
	end

	local function var2()
		if (arg2 - var0) * var1 > 0 then
			var0.Battle.BattleVariable.AppendMapFactor("seaSurfaceShift", var0)
			arg0:updateSeaSpeed()
			arg0:UpdateSpeedScaler()

			var0 = var0 + var1
		else
			pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._shiftTimer)

			arg0._shiftTimer = nil

			if arg4 then
				arg4()
			end
		end
	end

	arg0._shiftTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, arg3, var2, true)
end

function var1.UpdateSpeedScaler(arg0)
	arg0:setSpeedScaler(var0.Battle.BattleVariable.MapSpeedRatio)
end

function var1.UpdateBufferAlpha(arg0, arg1)
	local var0 = arg1 * 0.1

	arg0._bufferRenderer.color = Color.New(1, 1, 1, var0)
end

function var1.SetExposeLine(arg0, arg1, arg2, arg3)
	function instantiateLine(arg0, arg1)
		local var0 = var0.Battle.BattleResourceManager.GetInstance():InstMap(arg1)
		local var1 = arg0._go.transform:Find("seaLayer")

		setParent(var0, var1, false)

		local var2 = var0:GetComponent("SpriteRenderer")
		local var3 = var2.bounds.extents.max

		var2.sortingOrder = -1501

		local var4 = tf(var0).localScale

		tf(var0).localScale = Vector3.New(arg1 * var4.x, var4.y, var4.z)

		local var5 = tf(var0).localPosition
		local var6 = var2.bounds.extents.x * arg1

		tf(var0).localPosition = Vector3.New(arg0 - var6, var5.y, var5.z)
	end

	instantiateLine(arg2, "visionLine")

	if arg3 then
		instantiateLine(arg3, "exposeLine")
	end
end

function var1.setSpeedScaler(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.mapLayerCtrls) do
		iter1.speedScaler = arg1
	end
end

function var1.updateSeaSpeed(arg0)
	local var0 = var0.Battle.BattleVariable.MapSpeedRatio

	for iter0, iter1 in ipairs(arg0.seaAnimList) do
		iter1:AdjustAnimSpeed(var0)
	end
end

function var1.Dispose(arg0)
	if arg0._shiftTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._shiftTimer)
	end

	if arg0._go then
		Object.Destroy(arg0._go)

		arg0._go = nil
		arg0._buffer = nil
		arg0._bufferRenderer = nil
	end
end

function var1.GetMapResNames(arg0, arg1)
	local var0 = pg.map_data[arg0]

	return string.split(var0[arg1 .. "_shot"], ";")
end

function var1.setActive(arg0, arg1)
	SetActive(arg0._go, arg1)
end
