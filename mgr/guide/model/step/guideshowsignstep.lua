local var0_0 = class("GuideShowSignStep", import(".GuideStep"))

var0_0.SIGN_TYPE_2 = 2
var0_0.SIGN_TYPE_3 = 3

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	local var0_1 = arg1_1.showSign

	arg0_1.sType = var0_1.type
	arg0_1.duration = var0_1.duration
	arg0_1.clickUI = arg0_1:GenClickData(var0_1.clickUI)
	arg0_1.clickArea = var0_1.clickArea
	arg0_1.longPress = var0_1.longPress
	arg0_1.signIndexList = {}

	for iter0_1, iter1_1 in ipairs(var0_1.signList) do
		local var1_1 = iter1_1.signType
		local var2_1 = iter1_1.pos
		local var3_1 = iter1_1.cachedIndex

		if type(var2_1) == "string" then
			if var2_1 == "useCachePos" then
				var2_1 = WorldGuider.GetInstance():GetTempGridPos(var3_1)
			end
		elseif type(var2_1) == "table" then
			var2_1 = Vector3.New(var2_1[1], var2_1[2], var2_1[3])
		end

		table.insert(arg0_1.signIndexList, {
			pos = var2_1 or Vector3(0, 0, 0),
			signName = arg0_1:GetSignResName(var1_1),
			atlasName = iter1_1.atlasName,
			fileName = iter1_1.fileName
		})
	end
end

function var0_0.GenClickData(arg0_2, arg1_2)
	if not arg1_2 then
		return nil
	end

	local var0_2 = arg0_2:GenSearchData(arg1_2)
	local var1_2 = arg1_2.sizeDeltaPlus or {
		0,
		0
	}

	var0_2.sizeDeltaPlus = Vector2(var1_2[1], var1_2[2])

	return var0_2
end

function var0_0.GetType(arg0_3)
	return GuideStep.TYPE_SHOWSIGN
end

function var0_0.GetSignType(arg0_4)
	return arg0_4.sType
end

function var0_0.GetFirstSign(arg0_5)
	return arg0_5.signIndexList[1]
end

function var0_0.GetSignList(arg0_6)
	return arg0_6.signIndexList
end

function var0_0.GetSignResName(arg0_7, arg1_7)
	local var0_7 = ""

	if arg1_7 == 1 or arg1_7 == 6 then
		var0_7 = "wTask"
	elseif arg1_7 == 2 then
		var0_7 = "wDanger"
	elseif arg1_7 == 3 then
		var0_7 = "wForbidden"
	elseif arg1_7 == 4 then
		var0_7 = "wClickArea"
	elseif arg1_7 == 5 then
		var0_7 = "wShowArea"
	end

	return var0_7
end

function var0_0.ShouldClick(arg0_8)
	return arg0_8.clickUI ~= nil
end

function var0_0.GetClickData(arg0_9)
	return arg0_9.clickUI
end

function var0_0.ExistClickArea(arg0_10)
	return arg0_10.clickArea ~= nil
end

function var0_0.GetClickArea(arg0_11)
	local var0_11 = arg0_11.clickArea or {
		0,
		0
	}

	return Vector2(var0_11[1], var0_11[2])
end

function var0_0.GetTriggerType(arg0_12)
	return arg0_12.longPress
end

function var0_0.GetExitDelay(arg0_13)
	return arg0_13.duration or 0
end

function var0_0.ExistTrigger(arg0_14)
	return arg0_14:GetSignType() ~= var0_0.SIGN_TYPE_3
end

return var0_0
