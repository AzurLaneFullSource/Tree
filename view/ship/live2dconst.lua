local var0_0 = class("Live2dConst")

var0_0.UnLoadL2dPating = nil

function var0_0.SaveL2dIdle(arg0_1, arg1_1, arg2_1)
	local var0_1 = var0_0.GetL2dIdleSaveName(arg0_1, arg1_1)

	PlayerPrefs.SetInt(var0_1, arg2_1)
end

function var0_0.SaveL2dAction(arg0_2, arg1_2, arg2_2)
	local var0_2 = var0_0.GetL2dActionSaveName(arg0_2, arg1_2)

	PlayerPrefs.SetInt(var0_2, arg2_2)
end

function var0_0.GetL2dIdleSaveName(arg0_3, arg1_3)
	return "l2d_" .. tostring(arg0_3) .. "_" .. tostring(arg1_3) .. "_idle_index"
end

function var0_0.GetL2dActionSaveName(arg0_4, arg1_4)
	return "l2d_" .. tostring(arg0_4) .. "_" .. tostring(arg1_4) .. "_action_id"
end

function var0_0.GetL2dSaveData(arg0_5, arg1_5)
	local var0_5 = var0_0.GetL2dIdleSaveName(arg0_5, arg1_5)
	local var1_5 = var0_0.GetL2dActionSaveName(arg0_5, arg1_5)

	return PlayerPrefs.GetInt(var0_5), PlayerPrefs.GetInt(var1_5)
end

function var0_0.SaveDragData(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = var0_0.GetDragSaveName(arg0_6, arg1_6, arg2_6)

	PlayerPrefs.SetFloat(var0_6, arg3_6)
end

function var0_0.GetDragData(arg0_7, arg1_7, arg2_7)
	local var0_7 = var0_0.GetDragSaveName(arg0_7, arg1_7, arg2_7)

	return PlayerPrefs.GetFloat(var0_7)
end

function var0_0.GetDragSaveName(arg0_8, arg1_8, arg2_8)
	return "l2d_drag_" .. tostring(arg0_8) .. "_" .. tostring(arg1_8) .. "_" .. tostring(arg2_8) .. "_target"
end

function var0_0.SetDragActionIndex(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = var0_0.GetDragActionIndexName(arg0_9, arg1_9, arg2_9)

	PlayerPrefs.SetInt(var0_9, arg3_9)
end

function var0_0.GetDragActionIndex(arg0_10, arg1_10, arg2_10)
	local var0_10 = var0_0.GetDragActionIndexName(arg0_10, arg1_10, arg2_10)
	local var1_10 = PlayerPrefs.GetInt(var0_10)

	if not var1_10 or var1_10 <= 0 then
		var1_10 = 1
	end

	return var1_10
end

function var0_0.GetDragActionIndexName(arg0_11, arg1_11, arg2_11)
	return "l2d_drag_" .. tostring(arg0_11) .. "_" .. tostring(arg1_11) .. "_" .. tostring(arg2_11) .. "_action_index"
end

var0_0.RELATION_DRAG_X = "drag_x"
var0_0.RELATION_DRAG_Y = "drag_y"
var0_0.RELATION_DRAG_NAME_LIST = {
	var0_0.RELATION_DRAG_X,
	var0_0.RELATION_DRAG_Y
}

function var0_0.SetRelationData(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = var0_0.GetRelationName()
	local var1_12 = string.gsub(var0_12, "%$1", arg0_12)
	local var2_12 = string.gsub(var1_12, "%$2", arg1_12)
	local var3_12 = string.gsub(var2_12, "%$3", arg2_12)

	for iter0_12 = 1, #var0_0.RELATION_DRAG_NAME_LIST do
		local var4_12 = var0_0.RELATION_DRAG_NAME_LIST[iter0_12]
		local var5_12 = var3_12 .. var4_12

		PlayerPrefs.SetFloat(var5_12, arg3_12[var4_12])
	end
end

function var0_0.GetRelationData(arg0_13, arg1_13, arg2_13)
	local var0_13 = var0_0.GetRelationName()
	local var1_13 = string.gsub(var0_13, "%$1", arg0_13)
	local var2_13 = string.gsub(var1_13, "%$2", arg1_13)
	local var3_13 = string.gsub(var2_13, "%$3", arg2_13)
	local var4_13 = {}

	for iter0_13 = 1, #var0_0.RELATION_DRAG_NAME_LIST do
		local var5_13 = var0_0.RELATION_DRAG_NAME_LIST[iter0_13]
		local var6_13 = var3_13 .. var5_13

		var4_13[var5_13] = PlayerPrefs.GetFloat(var6_13) ~= nil and PlayerPrefs.GetFloat(var6_13) or 0
	end

	return var4_13
end

function var0_0.GetRelationName(arg0_14, arg1_14, arg2_14)
	return "l2d_relation_$1_$2_$3_"
end

function var0_0.ClearLive2dSave(arg0_15, arg1_15)
	if not arg0_15 or not arg1_15 then
		warning("skinId 或 shipId 不能为空")

		return
	end

	if not pg.ship_skin_template[arg0_15] then
		warning("找不到skinId" .. tostring(arg0_15) .. " 清理失败")

		return
	end

	local var0_15 = pg.ship_skin_template[arg0_15].ship_l2d_id

	if var0_15 and #var0_15 > 0 then
		Live2dConst.SaveL2dIdle(arg0_15, arg1_15, 0)
		Live2dConst.SaveL2dAction(arg0_15, arg1_15, 0)

		for iter0_15, iter1_15 in ipairs(var0_15) do
			local var1_15 = pg.ship_l2d[iter1_15]

			if var1_15 then
				local var2_15 = var1_15.start_value or 0

				Live2dConst.SaveDragData(iter1_15, arg0_15, arg1_15, var2_15)
				Live2dConst.SetDragActionIndex(iter1_15, arg0_15, arg1_15, 1)

				if var1_15.relation_parameter and var1_15.relation_parameter.list then
					local var3_15 = var0_0.GetRelationName()
					local var4_15 = string.gsub(var3_15, "%$1", iter1_15)
					local var5_15 = string.gsub(var4_15, "%$2", arg0_15)
					local var6_15 = string.gsub(var5_15, "%$3", arg1_15)

					for iter2_15 = 1, #var0_0.RELATION_DRAG_NAME_LIST do
						local var7_15 = var0_0.RELATION_DRAG_NAME_LIST[iter2_15]
						local var8_15 = var6_15 .. var7_15

						PlayerPrefs.SetFloat(var8_15, 0)
					end
				end
			else
				warning(tostring(iter1_15) .. "不存在，不清理该dragid")
			end
		end
	end

	pg.TipsMgr.GetInstance():ShowTips(i18n("live2d_reset_desc"))
end

return var0_0
