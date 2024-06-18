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

function var0_0.ClearLive2dSave(arg0_12, arg1_12)
	if not arg0_12 or not arg1_12 then
		warning("skinId 或 shipId 不能为空")

		return
	end

	if not pg.ship_skin_template[arg0_12] then
		warning("找不到skinId" .. tostring(arg0_12) .. " 清理失败")

		return
	end

	local var0_12 = pg.ship_skin_template[arg0_12].ship_l2d_id

	if var0_12 and #var0_12 > 0 then
		Live2dConst.SaveL2dIdle(arg0_12, arg1_12, 0)
		Live2dConst.SaveL2dAction(arg0_12, arg1_12, 0)

		for iter0_12, iter1_12 in ipairs(var0_12) do
			if pg.ship_l2d[iter1_12] then
				local var1_12 = pg.ship_l2d[iter1_12].start_value or 0

				Live2dConst.SaveDragData(iter1_12, arg0_12, arg1_12, var1_12)
				Live2dConst.SetDragActionIndex(iter1_12, arg0_12, arg1_12, 1)
			else
				warning(tostring(iter1_12) .. "不存在，不清理该dragid")
			end
		end
	end

	pg.TipsMgr.GetInstance():ShowTips(i18n("live2d_reset_desc"))
end

return var0_0
