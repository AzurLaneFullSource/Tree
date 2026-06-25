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

function var0_0.GetGroupId(arg0_12)
	return arg0_12:getConfig("ship_group")
end

function var0_0.ShouldApplyHiddenPartInTimeline(arg0_13)
	return arg0_13:getConfig("hidden_part_apply_in_timeline") == 1
end

function var0_0.GetHiddenPartIcons(arg0_14, arg1_14)
	local var0_14 = arg0_14:getConfig("hidden_part")
	local var1_14 = {}

	for iter0_14, iter1_14 in ipairs(arg1_14) do
		local var2_14 = iter0_14.find(var0_14, function(arg0_15)
			return arg0_15[1] == iter1_14
		end)

		if var2_14 then
			table.insert(var1_14, var2_14[2])
		end
	end

	return var1_14
end

function var0_0.GetActiveAndHiddenPartNames(arg0_16, arg1_16)
	local var0_16 = arg0_16:getConfig("hidden_part")
	local var1_16 = {}
	local var2_16 = {}

	for iter0_16, iter1_16 in ipairs(var0_16) do
		if table.contains(arg1_16, iter1_16[1]) then
			table.insert(var2_16, iter1_16[3])
		else
			table.insert(var1_16, iter1_16[3])
		end
	end

	return var1_16, var2_16
end

function var0_0.GetRarity(arg0_17)
	return 5
end

function var0_0.GetModelName(arg0_18)
	return arg0_18:getConfig("model_id")
end

function var0_0.IsShow(arg0_19)
	return arg0_19:getConfig("is_show_change_skin") == 1
end

return var0_0
