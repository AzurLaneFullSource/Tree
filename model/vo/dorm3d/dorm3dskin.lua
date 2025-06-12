local var0_0 = class("Dorm3dSkin", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.dorm3d_resource
end

function var0_0.GetName(arg0_2)
	return arg0_2:getConfig("name")
end

function var0_0.GetType(arg0_3)
	return arg0_3:getConfig("type")
end

function var0_0.GetUnlock(arg0_4)
	return arg0_4:getConfig("unlock")
end

function var0_0.GetShopId(arg0_5)
	return arg0_5:getConfig("shop_id")
end

function var0_0.GetPublicRoomId(arg0_6)
	return arg0_6:GetUnlock()[2]
end

function var0_0.GetIcon(arg0_7)
	return arg0_7:getConfig("head_Icon")
end

function var0_0.GetUnlockText(arg0_8)
	return arg0_8:getConfig("unlock_text")
end

function var0_0.GetSwitchAnim(arg0_9)
	return arg0_9:getConfig("switch_anim")
end

function var0_0.GetWearAnim(arg0_10)
	return arg0_10:getConfig("wear_anim")
end

function var0_0.GetRemarks(arg0_11)
	return arg0_11:getConfig("remarks")
end

function var0_0.GetHiddenPartIcons(arg0_12, arg1_12)
	local var0_12 = arg0_12:getConfig("hidden_part")
	local var1_12 = {}

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		local var2_12 = iter0_12.find(var0_12, function(arg0_13)
			return arg0_13[1] == iter1_12
		end)

		if var2_12 then
			table.insert(var1_12, var2_12[2])
		end
	end

	return var1_12
end

function var0_0.GetActiveAndHiddenPartNames(arg0_14, arg1_14)
	local var0_14 = arg0_14:getConfig("hidden_part")
	local var1_14 = {}
	local var2_14 = {}

	for iter0_14, iter1_14 in ipairs(var0_14) do
		if table.contains(arg1_14, iter1_14[1]) then
			table.insert(var2_14, iter1_14[3])
		else
			table.insert(var1_14, iter1_14[3])
		end
	end

	return var1_14, var2_14
end

function var0_0.GetRarity(arg0_15)
	return 5
end

return var0_0
