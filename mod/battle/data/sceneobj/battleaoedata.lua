ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = class("BattleAOEData")

var0.Battle.BattleAOEData = var2
var2.__name = "BattleAOEData"
var2.ALIGNMENT_LEFT = "left"
var2.ALIGNMENT_RIGHT = "right"
var2.ALIGNMENT_MIDDLE = "middle"

function var2.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._areaUniqueID = arg1
	arg0._areaCldFunc = arg3
	arg0._endFunc = arg4
	arg0._IFF = arg2
	arg0._cldObjList = {}
	arg0._cldObjDistanceList = {}

	arg0:SetTickness(10)

	arg0._alignment = Vector3.zero
	arg0._angle = 0
	arg0._component = {}
	arg0._timeExemptKey = "aoe_" .. arg0._areaUniqueID
end

function var2.StartTimer(arg0)
	if arg0._lifeTime == -1 then
		arg0._flag = false

		return
	end

	arg0._flag = true

	if arg0._lifeTime > 0 then
		arg0._lifeTimer = pg.TimeMgr.GetInstance():AddBattleTimer("areaTimer", 0, arg0._lifeTime, function()
			arg0:RemoveTimer()
		end, true)
	end
end

function var2.GetTimeRationExemptKey(arg0)
	return arg0._timeExemptKey
end

function var2.RemoveTimer(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._lifeTimer)

	arg0._lifeTimer = nil
	arg0._flag = false
end

function var2.ClearCLDList(arg0)
	arg0._cldObjList = {}
end

function var2.AppendCldObj(arg0, arg1)
	arg0._cldObjList[#arg0._cldObjList + 1] = arg1
end

function var2.Settle(arg0)
	arg0.SortCldObjList(arg0._cldObjList)
	arg0._cldComponent:GetCldData().func(arg0._cldObjList)
end

function var2.SettleFinale(arg0)
	if arg0._endFunc then
		arg0.SortCldObjList(arg0._cldObjList)
		arg0._endFunc(arg0._cldObjList)
	end
end

function var2.ForceExit(arg0)
	return
end

function var2.SortCldObjList(arg0)
	table.sort(arg0, var2._Fun_SortCldObjList)
end

function var2._Fun_SortCldObjList(arg0, arg1)
	if arg0.IsBoss ~= arg1.IsBoss then
		if arg1.IsBoss then
			return true
		else
			return false
		end
	else
		return arg0.UID < arg1.UID
	end
end

function var2.SetOpponentAffected(arg0, arg1)
	arg0._opponentAffected = arg1
end

function var2.OpponentAffected(arg0)
	return arg0._opponentAffected
end

function var2.SetIndiscriminate(arg0, arg1)
	arg0._indicriminate = arg1
end

function var2.GetIndiscriminate(arg0)
	return arg0._indicriminate
end

function var2.GetActiveFlag(arg0)
	return arg0._flag
end

function var2.SetActiveFlag(arg0, arg1)
	arg0._flag = arg1
end

function var2.Dispose(arg0)
	for iter0, iter1 in ipairs(arg0._component) do
		iter1:Dispose()
	end

	arg0._component = nil

	arg0:RemoveTimer()

	arg0._cldObjList = nil
end

function var2.GetUniqueID(arg0)
	return arg0._areaUniqueID
end

function var2.GetIFF(arg0)
	return arg0._IFF
end

function var2.GetAreaType(arg0)
	return arg0._areaType
end

function var2.GetPosition(arg0)
	return arg0._pos
end

function var2.GetTickness(arg0)
	return arg0._tickness
end

function var2.GetLifeTime(arg0)
	return arg0._lifeTime
end

function var2.GetFieldType(arg0)
	return arg0._fieldType
end

function var2.GetDiveFilter(arg0)
	return arg0._diveFilter
end

function var2.GetCldFunc(arg0)
	return arg0._areaCldFunc
end

function var2.GetHeight(arg0)
	return arg0._height
end

function var2.GetWidth(arg0)
	return arg0._width
end

function var2.GetAngle(arg0)
	return arg0._angle
end

function var2.GetRange(arg0)
	return arg0._range
end

function var2.GetSectorAngle(arg0)
	return arg0._sectorAngle
end

function var2.SetAreaType(arg0, arg1)
	arg0._areaType = arg1

	arg0:InitCldComponent()
end

function var2.SetDiveFilter(arg0, arg1)
	arg0._diveFilter = arg1
end

function var2.SetPosition(arg0, arg1)
	arg0._pos = arg1
end

function var2.SetTickness(arg0, arg1)
	arg0._tickness = arg1
end

function var2.SetFieldType(arg0, arg1)
	arg0._fieldType = arg1
end

function var2.SetLifeTime(arg0, arg1)
	arg0._lifeTime = arg1
end

function var2.SetHeight(arg0, arg1)
	arg0._height = arg1
end

function var2.SetWidth(arg0, arg1)
	arg0._width = arg1
end

function var2.SetAngle(arg0, arg1)
	arg0._angle = arg1
end

function var2.SetRange(arg0, arg1)
	arg0._range = arg1
end

function var2.SetSectorAngle(arg0, arg1, arg2)
	arg0._sectorAngle = arg1
	arg0._sectorDir = arg2

	local var0 = arg0._sectorAngle / 2

	arg0._upperEdge = math.deg2Rad * var0
	arg0._lowerEdge = -1 * arg0._upperEdge

	local var1 = 0

	if arg2 == var1.UnitDir.LEFT then
		arg0._normalizeOffset = math.pi - var1
	elseif arg2 == var1.UnitDir.RIGHT then
		arg0._normalizeOffset = var1
	end

	arg0._wholeCircle = math.pi - arg0._normalizeOffset
	arg0._negativeCircle = -math.pi - arg0._normalizeOffset
	arg0._wholeCircleNormalizeOffset = arg0._normalizeOffset - math.pi * 2
	arg0._negativeCircleNormalizeOffset = arg0._normalizeOffset + math.pi * 2
end

function var2.SetAnchorPointAlignment(arg0, arg1)
	if arg1 == var2.ALIGNMENT_LEFT then
		arg0._alignment = Vector3(arg0._width * 0.5, 0, 0)
	elseif arg1 == var2.ALIGNMENT_RIGHT then
		arg0._alignment = Vector3(arg0._width * -0.5, 0, 0)
	end
end

function var2.GetAnchorPointAlignment(arg0)
	return arg0._alignment
end

function var2.GetFXStatic(arg0)
	return arg0._fxStatic
end

function var2.SetFXStatic(arg0, arg1)
	arg0._fxStatic = arg1
end

function var2.AppendComponent(arg0, arg1)
	table.insert(arg0._component, arg1)
end

function var2.InitCldComponent(arg0)
	if arg0._areaType == var1.AreaType.CUBE then
		arg0._cldComponent = var0.Battle.BattleCubeCldComponent.New(arg0._width, arg0._tickness, arg0._height, 0, 0)
	elseif arg0._areaType == var1.AreaType.COLUMN then
		arg0._cldComponent = var0.Battle.BattleColumnCldComponent.New(arg0._range, arg0._tickness)
	end

	local var0 = {
		type = var1.CldType.AOE,
		UID = arg0:GetUniqueID(),
		IFF = arg0:GetIFF(),
		func = arg0:GetCldFunc()
	}

	arg0._cldComponent:SetCldData(var0)
	arg0._cldComponent:SetActive(true)
end

function var2.GetCldComponent(arg0)
	return arg0._cldComponent
end

function var2.DeactiveCldBox(arg0)
	arg0._cldComponent:SetActive(false)
end

function var2.GetCldBox(arg0)
	return arg0._cldComponent:GetCldBox(arg0:GetPosition() + arg0._alignment)
end

function var2.GetCldData(arg0)
	return arg0._cldComponent:GetCldData()
end

function var2.UpdateDistanceInfo(arg0)
	for iter0, iter1 in ipairs(arg0._cldObjList) do
		local var0
		local var1 = iter1.LeftBound
		local var2 = iter1.RightBound
		local var3 = iter1.UpperBound
		local var4 = iter1.LowerBound
		local var5 = arg0._pos.x
		local var6
		local var7

		if var1 <= var5 and var5 <= var2 then
			var6 = true
		elseif var5 < var1 then
			var7 = var1
		elseif var2 < var5 then
			var7 = var2
		end

		local var8 = arg0._pos.z
		local var9
		local var10

		if var4 <= var8 and var8 <= var3 then
			var9 = true
		elseif var8 < var4 then
			var10 = var4
		elseif var3 < var8 then
			var10 = var3
		end

		if var6 and var9 then
			var0 = 0
		elseif var6 then
			var0 = math.abs(var10 - var8)
		elseif var9 then
			var0 = math.abs(var7 - var5)
		else
			var0 = math.sqrt((var7 - var5)^2 + (var10 - var8)^2)
		end

		arg0._cldObjDistanceList[iter1.UID] = var0
	end
end

function var2.GetDistance(arg0, arg1)
	return arg0._cldObjDistanceList[arg1]
end

function var2.IsOutOfAngle(arg0, arg1)
	if not arg0._sectorAngle or arg0._sectorAngle >= 360 then
		return false
	else
		local var0 = arg1:GetPosition()
		local var1 = math.atan2(var0.z - arg0._pos.z, var0.x - arg0._pos.x)

		if var1 > arg0._wholeCircle then
			var1 = var1 + arg0._wholeCircleNormalizeOffset
		elseif var1 < arg0._negativeCircle then
			var1 = var1 + arg0._negativeCircleNormalizeOffset
		else
			var1 = var1 + arg0._normalizeOffset
		end

		if var1 > arg0._lowerEdge and var1 < arg0._upperEdge then
			return false
		else
			return true
		end
	end
end
