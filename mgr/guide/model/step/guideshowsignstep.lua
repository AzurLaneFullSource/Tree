local var0 = class("GuideShowSignStep", import(".GuideStep"))

var0.SIGN_TYPE_2 = 2
var0.SIGN_TYPE_3 = 3

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	local var0 = arg1.showSign

	arg0.sType = var0.type
	arg0.duration = var0.duration
	arg0.clickUI = arg0:GenClickData(var0.clickUI)
	arg0.clickArea = var0.clickArea
	arg0.longPress = var0.longPress
	arg0.signIndexList = {}

	for iter0, iter1 in ipairs(var0.signList) do
		local var1 = iter1.signType
		local var2 = iter1.pos
		local var3 = iter1.cachedIndex

		if type(var2) == "string" then
			if var2 == "useCachePos" then
				var2 = WorldGuider.GetInstance():GetTempGridPos(var3)
			end
		elseif type(var2) == "table" then
			var2 = Vector3.New(var2[1], var2[2], var2[3])
		end

		table.insert(arg0.signIndexList, {
			pos = var2 or Vector3(0, 0, 0),
			signName = arg0:GetSignResName(var1),
			atlasName = iter1.atlasName,
			fileName = iter1.fileName
		})
	end
end

function var0.GenClickData(arg0, arg1)
	if not arg1 then
		return nil
	end

	local var0 = arg0:GenSearchData(arg1)
	local var1 = arg1.sizeDeltaPlus or {
		0,
		0
	}

	var0.sizeDeltaPlus = Vector2(var1[1], var1[2])

	return var0
end

function var0.GetType(arg0)
	return GuideStep.TYPE_SHOWSIGN
end

function var0.GetSignType(arg0)
	return arg0.sType
end

function var0.GetFirstSign(arg0)
	return arg0.signIndexList[1]
end

function var0.GetSignList(arg0)
	return arg0.signIndexList
end

function var0.GetSignResName(arg0, arg1)
	local var0 = ""

	if arg1 == 1 or arg1 == 6 then
		var0 = "wTask"
	elseif arg1 == 2 then
		var0 = "wDanger"
	elseif arg1 == 3 then
		var0 = "wForbidden"
	elseif arg1 == 4 then
		var0 = "wClickArea"
	elseif arg1 == 5 then
		var0 = "wShowArea"
	end

	return var0
end

function var0.ShouldClick(arg0)
	return arg0.clickUI ~= nil
end

function var0.GetClickData(arg0)
	return arg0.clickUI
end

function var0.ExistClickArea(arg0)
	return arg0.clickArea ~= nil
end

function var0.GetClickArea(arg0)
	local var0 = arg0.clickArea or {
		0,
		0
	}

	return Vector2(var0[1], var0[2])
end

function var0.GetTriggerType(arg0)
	return arg0.longPress
end

function var0.GetExitDelay(arg0)
	return arg0.duration or 0
end

function var0.ExistTrigger(arg0)
	return arg0:GetSignType() ~= var0.SIGN_TYPE_3
end

return var0
