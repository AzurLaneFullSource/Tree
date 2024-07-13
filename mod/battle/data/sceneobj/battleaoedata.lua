ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = class("BattleAOEData")

var0_0.Battle.BattleAOEData = var2_0
var2_0.__name = "BattleAOEData"
var2_0.ALIGNMENT_LEFT = "left"
var2_0.ALIGNMENT_RIGHT = "right"
var2_0.ALIGNMENT_MIDDLE = "middle"

function var2_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._areaUniqueID = arg1_1
	arg0_1._areaCldFunc = arg3_1
	arg0_1._endFunc = arg4_1
	arg0_1._IFF = arg2_1
	arg0_1._cldObjList = {}
	arg0_1._cldObjDistanceList = {}

	arg0_1:SetTickness(10)

	arg0_1._alignment = Vector3.zero
	arg0_1._angle = 0
	arg0_1._component = {}
	arg0_1._timeExemptKey = "aoe_" .. arg0_1._areaUniqueID
end

function var2_0.StartTimer(arg0_2)
	if arg0_2._lifeTime == -1 then
		arg0_2._flag = false

		return
	end

	arg0_2._flag = true

	if arg0_2._lifeTime > 0 then
		arg0_2._lifeTimer = pg.TimeMgr.GetInstance():AddBattleTimer("areaTimer", 0, arg0_2._lifeTime, function()
			arg0_2:RemoveTimer()
		end, true)
	end
end

function var2_0.GetTimeRationExemptKey(arg0_4)
	return arg0_4._timeExemptKey
end

function var2_0.RemoveTimer(arg0_5)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_5._lifeTimer)

	arg0_5._lifeTimer = nil
	arg0_5._flag = false
end

function var2_0.ClearCLDList(arg0_6)
	arg0_6._cldObjList = {}
end

function var2_0.AppendCldObj(arg0_7, arg1_7)
	arg0_7._cldObjList[#arg0_7._cldObjList + 1] = arg1_7
end

function var2_0.Settle(arg0_8)
	arg0_8.SortCldObjList(arg0_8._cldObjList)
	arg0_8._cldComponent:GetCldData().func(arg0_8._cldObjList)
end

function var2_0.SettleFinale(arg0_9)
	if arg0_9._endFunc then
		arg0_9.SortCldObjList(arg0_9._cldObjList)
		arg0_9._endFunc(arg0_9._cldObjList)
	end
end

function var2_0.ForceExit(arg0_10)
	return
end

function var2_0.SortCldObjList(arg0_11)
	table.sort(arg0_11, var2_0._Fun_SortCldObjList)
end

function var2_0._Fun_SortCldObjList(arg0_12, arg1_12)
	if arg0_12.IsBoss ~= arg1_12.IsBoss then
		if arg1_12.IsBoss then
			return true
		else
			return false
		end
	else
		return arg0_12.UID < arg1_12.UID
	end
end

function var2_0.SetOpponentAffected(arg0_13, arg1_13)
	arg0_13._opponentAffected = arg1_13
end

function var2_0.OpponentAffected(arg0_14)
	return arg0_14._opponentAffected
end

function var2_0.SetIndiscriminate(arg0_15, arg1_15)
	arg0_15._indicriminate = arg1_15
end

function var2_0.GetIndiscriminate(arg0_16)
	return arg0_16._indicriminate
end

function var2_0.GetActiveFlag(arg0_17)
	return arg0_17._flag
end

function var2_0.SetActiveFlag(arg0_18, arg1_18)
	arg0_18._flag = arg1_18
end

function var2_0.Dispose(arg0_19)
	for iter0_19, iter1_19 in ipairs(arg0_19._component) do
		iter1_19:Dispose()
	end

	arg0_19._component = nil

	arg0_19:RemoveTimer()

	arg0_19._cldObjList = nil
end

function var2_0.GetUniqueID(arg0_20)
	return arg0_20._areaUniqueID
end

function var2_0.GetIFF(arg0_21)
	return arg0_21._IFF
end

function var2_0.GetAreaType(arg0_22)
	return arg0_22._areaType
end

function var2_0.GetPosition(arg0_23)
	return arg0_23._pos
end

function var2_0.GetTickness(arg0_24)
	return arg0_24._tickness
end

function var2_0.GetLifeTime(arg0_25)
	return arg0_25._lifeTime
end

function var2_0.GetFieldType(arg0_26)
	return arg0_26._fieldType
end

function var2_0.GetDiveFilter(arg0_27)
	return arg0_27._diveFilter
end

function var2_0.GetCldFunc(arg0_28)
	return arg0_28._areaCldFunc
end

function var2_0.GetHeight(arg0_29)
	return arg0_29._height
end

function var2_0.GetWidth(arg0_30)
	return arg0_30._width
end

function var2_0.GetAngle(arg0_31)
	return arg0_31._angle
end

function var2_0.GetRange(arg0_32)
	return arg0_32._range
end

function var2_0.GetSectorAngle(arg0_33)
	return arg0_33._sectorAngle
end

function var2_0.SetAreaType(arg0_34, arg1_34)
	arg0_34._areaType = arg1_34

	arg0_34:InitCldComponent()
end

function var2_0.SetDiveFilter(arg0_35, arg1_35)
	arg0_35._diveFilter = arg1_35
end

function var2_0.SetPosition(arg0_36, arg1_36)
	arg0_36._pos = arg1_36
end

function var2_0.SetTickness(arg0_37, arg1_37)
	arg0_37._tickness = arg1_37
end

function var2_0.SetFieldType(arg0_38, arg1_38)
	arg0_38._fieldType = arg1_38
end

function var2_0.SetLifeTime(arg0_39, arg1_39)
	arg0_39._lifeTime = arg1_39
end

function var2_0.SetHeight(arg0_40, arg1_40)
	arg0_40._height = arg1_40
end

function var2_0.SetWidth(arg0_41, arg1_41)
	arg0_41._width = arg1_41
end

function var2_0.SetAngle(arg0_42, arg1_42)
	arg0_42._angle = arg1_42
end

function var2_0.SetRange(arg0_43, arg1_43)
	arg0_43._range = arg1_43
end

function var2_0.SetSectorAngle(arg0_44, arg1_44, arg2_44)
	arg0_44._sectorAngle = arg1_44
	arg0_44._sectorDir = arg2_44

	local var0_44 = arg0_44._sectorAngle / 2

	arg0_44._upperEdge = math.deg2Rad * var0_44
	arg0_44._lowerEdge = -1 * arg0_44._upperEdge

	local var1_44 = 0

	if arg2_44 == var1_0.UnitDir.LEFT then
		arg0_44._normalizeOffset = math.pi - var1_44
	elseif arg2_44 == var1_0.UnitDir.RIGHT then
		arg0_44._normalizeOffset = var1_44
	end

	arg0_44._wholeCircle = math.pi - arg0_44._normalizeOffset
	arg0_44._negativeCircle = -math.pi - arg0_44._normalizeOffset
	arg0_44._wholeCircleNormalizeOffset = arg0_44._normalizeOffset - math.pi * 2
	arg0_44._negativeCircleNormalizeOffset = arg0_44._normalizeOffset + math.pi * 2
end

function var2_0.SetAnchorPointAlignment(arg0_45, arg1_45)
	if arg1_45 == var2_0.ALIGNMENT_LEFT then
		arg0_45._alignment = Vector3(arg0_45._width * 0.5, 0, 0)
	elseif arg1_45 == var2_0.ALIGNMENT_RIGHT then
		arg0_45._alignment = Vector3(arg0_45._width * -0.5, 0, 0)
	end
end

function var2_0.GetAnchorPointAlignment(arg0_46)
	return arg0_46._alignment
end

function var2_0.GetFXStatic(arg0_47)
	return arg0_47._fxStatic
end

function var2_0.SetFXStatic(arg0_48, arg1_48)
	arg0_48._fxStatic = arg1_48
end

function var2_0.AppendComponent(arg0_49, arg1_49)
	table.insert(arg0_49._component, arg1_49)
end

function var2_0.InitCldComponent(arg0_50)
	if arg0_50._areaType == var1_0.AreaType.CUBE then
		arg0_50._cldComponent = var0_0.Battle.BattleCubeCldComponent.New(arg0_50._width, arg0_50._tickness, arg0_50._height, 0, 0)
	elseif arg0_50._areaType == var1_0.AreaType.COLUMN then
		arg0_50._cldComponent = var0_0.Battle.BattleColumnCldComponent.New(arg0_50._range, arg0_50._tickness)
	end

	local var0_50 = {
		type = var1_0.CldType.AOE,
		UID = arg0_50:GetUniqueID(),
		IFF = arg0_50:GetIFF(),
		func = arg0_50:GetCldFunc()
	}

	arg0_50._cldComponent:SetCldData(var0_50)
	arg0_50._cldComponent:SetActive(true)
end

function var2_0.GetCldComponent(arg0_51)
	return arg0_51._cldComponent
end

function var2_0.DeactiveCldBox(arg0_52)
	arg0_52._cldComponent:SetActive(false)
end

function var2_0.GetCldBox(arg0_53)
	return arg0_53._cldComponent:GetCldBox(arg0_53:GetPosition() + arg0_53._alignment)
end

function var2_0.GetCldData(arg0_54)
	return arg0_54._cldComponent:GetCldData()
end

function var2_0.UpdateDistanceInfo(arg0_55)
	for iter0_55, iter1_55 in ipairs(arg0_55._cldObjList) do
		local var0_55
		local var1_55 = iter1_55.LeftBound
		local var2_55 = iter1_55.RightBound
		local var3_55 = iter1_55.UpperBound
		local var4_55 = iter1_55.LowerBound
		local var5_55 = arg0_55._pos.x
		local var6_55
		local var7_55

		if var1_55 <= var5_55 and var5_55 <= var2_55 then
			var6_55 = true
		elseif var5_55 < var1_55 then
			var7_55 = var1_55
		elseif var2_55 < var5_55 then
			var7_55 = var2_55
		end

		local var8_55 = arg0_55._pos.z
		local var9_55
		local var10_55

		if var4_55 <= var8_55 and var8_55 <= var3_55 then
			var9_55 = true
		elseif var8_55 < var4_55 then
			var10_55 = var4_55
		elseif var3_55 < var8_55 then
			var10_55 = var3_55
		end

		if var6_55 and var9_55 then
			var0_55 = 0
		elseif var6_55 then
			var0_55 = math.abs(var10_55 - var8_55)
		elseif var9_55 then
			var0_55 = math.abs(var7_55 - var5_55)
		else
			var0_55 = math.sqrt((var7_55 - var5_55)^2 + (var10_55 - var8_55)^2)
		end

		arg0_55._cldObjDistanceList[iter1_55.UID] = var0_55
	end
end

function var2_0.GetDistance(arg0_56, arg1_56)
	return arg0_56._cldObjDistanceList[arg1_56]
end

function var2_0.IsOutOfAngle(arg0_57, arg1_57)
	if not arg0_57._sectorAngle or arg0_57._sectorAngle >= 360 then
		return false
	else
		local var0_57 = arg1_57:GetPosition()
		local var1_57 = math.atan2(var0_57.z - arg0_57._pos.z, var0_57.x - arg0_57._pos.x)

		if var1_57 > arg0_57._wholeCircle then
			var1_57 = var1_57 + arg0_57._wholeCircleNormalizeOffset
		elseif var1_57 < arg0_57._negativeCircle then
			var1_57 = var1_57 + arg0_57._negativeCircleNormalizeOffset
		else
			var1_57 = var1_57 + arg0_57._normalizeOffset
		end

		if var1_57 > arg0_57._lowerEdge and var1_57 < arg0_57._upperEdge then
			return false
		else
			return true
		end
	end
end
