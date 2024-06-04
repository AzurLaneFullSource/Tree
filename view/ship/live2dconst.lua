local var0 = class("Live2dConst")

var0.UnLoadL2dPating = nil

function var0.SaveL2dIdle(arg0, arg1, arg2)
	local var0 = var0.GetL2dIdleSaveName(arg0, arg1)

	PlayerPrefs.SetInt(var0, arg2)
end

function var0.SaveL2dAction(arg0, arg1, arg2)
	local var0 = var0.GetL2dActionSaveName(arg0, arg1)

	PlayerPrefs.SetInt(var0, arg2)
end

function var0.GetL2dIdleSaveName(arg0, arg1)
	return "l2d_" .. tostring(arg0) .. "_" .. tostring(arg1) .. "_idle_index"
end

function var0.GetL2dActionSaveName(arg0, arg1)
	return "l2d_" .. tostring(arg0) .. "_" .. tostring(arg1) .. "_action_id"
end

function var0.GetL2dSaveData(arg0, arg1)
	local var0 = var0.GetL2dIdleSaveName(arg0, arg1)
	local var1 = var0.GetL2dActionSaveName(arg0, arg1)

	return PlayerPrefs.GetInt(var0), PlayerPrefs.GetInt(var1)
end

function var0.SaveDragData(arg0, arg1, arg2, arg3)
	local var0 = var0.GetDragSaveName(arg0, arg1, arg2)

	PlayerPrefs.SetFloat(var0, arg3)
end

function var0.GetDragData(arg0, arg1, arg2)
	local var0 = var0.GetDragSaveName(arg0, arg1, arg2)

	return PlayerPrefs.GetFloat(var0)
end

function var0.GetDragSaveName(arg0, arg1, arg2)
	return "l2d_drag_" .. tostring(arg0) .. "_" .. tostring(arg1) .. "_" .. tostring(arg2) .. "_target"
end

function var0.SetDragActionIndex(arg0, arg1, arg2, arg3)
	local var0 = var0.GetDragActionIndexName(arg0, arg1, arg2)

	PlayerPrefs.SetInt(var0, arg3)
end

function var0.GetDragActionIndex(arg0, arg1, arg2)
	local var0 = var0.GetDragActionIndexName(arg0, arg1, arg2)
	local var1 = PlayerPrefs.GetInt(var0)

	if not var1 or var1 <= 0 then
		var1 = 1
	end

	return var1
end

function var0.GetDragActionIndexName(arg0, arg1, arg2)
	return "l2d_drag_" .. tostring(arg0) .. "_" .. tostring(arg1) .. "_" .. tostring(arg2) .. "_action_index"
end

function var0.ClearLive2dSave(arg0, arg1)
	if not arg0 or not arg1 then
		warning("skinId 或 shipId 不能为空")

		return
	end

	if not pg.ship_skin_template[arg0] then
		warning("找不到skinId" .. tostring(arg0) .. " 清理失败")

		return
	end

	local var0 = pg.ship_skin_template[arg0].ship_l2d_id

	if var0 and #var0 > 0 then
		Live2dConst.SaveL2dIdle(arg0, arg1, 0)
		Live2dConst.SaveL2dAction(arg0, arg1, 0)

		for iter0, iter1 in ipairs(var0) do
			if pg.ship_l2d[iter1] then
				local var1 = pg.ship_l2d[iter1].start_value or 0

				Live2dConst.SaveDragData(iter1, arg0, arg1, var1)
				Live2dConst.SetDragActionIndex(iter1, arg0, arg1, 1)
			else
				warning(tostring(iter1) .. "不存在，不清理该dragid")
			end
		end
	end

	pg.TipsMgr.GetInstance():ShowTips(i18n("live2d_reset_desc"))
end

return var0
