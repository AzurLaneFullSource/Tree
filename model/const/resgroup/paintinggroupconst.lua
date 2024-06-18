local var0_0 = {}

var0_0.PaintingGroupName = "PAINTING"
var0_0.PaintingMgr = nil

function var0_0.GetPaintingMgr()
	if not var0_0.PaintingMgr then
		var0_0.PaintingMgr = BundleWizard.Inst:GetGroupMgr(var0_0.PaintingGroupName)
	end

	return var0_0.PaintingMgr
end

var0_0.NotifyPaintingDownloadFinish = "PaintingGroupConst.NotifyPaintingDownloadFinish"

function var0_0.VerifyPaintingFileName(arg0_2)
	return GroupHelper.VerifyFile(var0_0.PaintingGroupName, arg0_2)
end

function var0_0.CalcPaintingListSize(arg0_3)
	local var0_3 = GroupHelper.CreateArrByLuaFileList(var0_0.PaintingGroupName, arg0_3)
	local var1_3 = GroupHelper.CalcSizeWithFileArr(var0_0.PaintingGroupName, var0_3)
	local var2_3 = HashUtil.BytesToString(var1_3)

	return var1_3, var2_3
end

function var0_0.IsPaintingNeedCheck()
	if Application.isEditor then
		return false
	end

	if GroupHelper.IsGroupVerLastest(var0_0.PaintingGroupName) then
		return false
	end

	if not GroupHelper.IsGroupWaitToUpdate(var0_0.PaintingGroupName) then
		return false
	end

	return true
end

function var0_0.AddPaintingNameWithFilteMap(arg0_5, arg1_5)
	arg1_5 = string.lower(arg1_5)

	if not pg.painting_filte_map then
		warning("painting_filte_map not exist")

		return
	end

	if not pg.painting_filte_map[arg1_5] then
		warning("painting_filte_map not exist key: " .. arg1_5)

		return
	end

	local var0_5 = pg.painting_filte_map[arg1_5].res_list

	for iter0_5, iter1_5 in ipairs(var0_5) do
		if not table.contains(arg0_5, iter1_5) and var0_0.VerifyPaintingFileName(iter1_5) then
			table.insert(arg0_5, iter1_5)
		end
	end
end

function var0_0.AddPaintingNameByShipGroupID(arg0_6, arg1_6)
	if var0_0.IsPaintingNeedCheck() then
		local var0_6 = ShipGroup.getDefaultSkin(arg1_6).painting

		var0_0.AddPaintingNameWithFilteMap(arg0_6, var0_6)
	end
end

function var0_0.AddPaintingNameByShipConfigID(arg0_7, arg1_7)
	if var0_0.IsPaintingNeedCheck() then
		local var0_7 = {
			configId = arg1_7
		}
		local var1_7 = Ship.getGroupId(var0_7)

		var0_0.AddPaintingNameByShipGroupID(arg0_7, var1_7)
	end
end

function var0_0.AddPaintingNameBySkinID(arg0_8, arg1_8)
	if var0_0.IsPaintingNeedCheck() then
		local var0_8 = pg.ship_skin_template[arg1_8].painting

		if #var0_8 > 0 then
			var0_0.AddPaintingNameWithFilteMap(arg0_8, var0_8)
		end
	end
end

function var0_0.GetPaintingNameListInLogin()
	local var0_9 = {}
	local var1_9 = var0_0.GetPaintingMgr()
	local var2_9 = getProxy(ShipSkinProxy)

	if var2_9 then
		local var3_9 = var2_9:GetOwnAndShareSkins()

		for iter0_9, iter1_9 in pairs(var3_9) do
			var0_0.AddPaintingNameBySkinID(var0_9, iter1_9.id)
		end
	end

	local var4_9 = getProxy(CollectionProxy)

	if var4_9 then
		local var5_9 = var4_9:getGroups()

		for iter2_9, iter3_9 in pairs(var5_9) do
			var0_0.AddPaintingNameByShipGroupID(var0_9, iter3_9.id)
		end
	end

	local var6_9 = getProxy(BayProxy)

	if var6_9 then
		local var7_9 = var6_9.activityNpcShipIds

		for iter4_9, iter5_9 in ipairs(var7_9) do
			local var8_9 = var6_9:getShipById(iter5_9)

			var0_0.AddPaintingNameByShipGroupID(var0_9, var8_9.groupId)
		end
	end

	return var0_9
end

function var0_0.GetPaintingNameListForTec()
	local var0_10 = {}

	for iter0_10, iter1_10 in ipairs(pg.ship_data_blueprint.all) do
		var0_0.AddPaintingNameByShipGroupID(var0_10, iter1_10)
	end

	return var0_10
end

function var0_0.GetPaintingNameListForAwardList(arg0_11)
	local var0_11 = {}

	for iter0_11 = 1, #arg0_11 do
		local var1_11 = arg0_11[iter0_11]
		local var2_11 = var1_11.type

		if var2_11 == DROP_TYPE_SHIP then
			local var3_11 = var1_11.id

			var0_0.AddPaintingNameByShipConfigID(var0_11, var3_11)
		elseif var2_11 == DROP_TYPE_NPC_SHIP then
			local var4_11 = getProxy(BayProxy):getShipById(var1_11.id)

			var0_0.AddPaintingNameByShipConfigID(var0_11, var4_11.configId)
		elseif var2_11 == DROP_TYPE_SKIN then
			local var5_11 = var1_11.id

			var0_0.AddPaintingNameBySkinID(var0_11, var5_11)
		end
	end

	return var0_11
end

function var0_0.GetPaintingNameListByShipVO(arg0_12)
	local var0_12 = {}
	local var1_12 = getProxy(ShipSkinProxy)
	local var2_12 = var1_12:GetAllSkinForShip(arg0_12)

	for iter0_12, iter1_12 in ipairs(var2_12) do
		var0_0.AddPaintingNameBySkinID(var0_12, iter1_12.id)
	end

	local var3_12 = var1_12:GetShareSkinsForShip(arg0_12)

	for iter2_12, iter3_12 in ipairs(var3_12) do
		var0_0.AddPaintingNameBySkinID(var0_12, iter3_12.id)
	end

	return var0_12
end

function var0_0.PaintingDownload(arg0_13)
	local var0_13 = {}

	if var0_0.IsPaintingNeedCheck() then
		local var1_13 = arg0_13.isShowBox
		local var2_13 = pg.FileDownloadMgr.GetInstance():IsNeedRemind()
		local var3_13 = IsUsingWifi()
		local var4_13 = var1_13 and var2_13
		local var5_13 = arg0_13.paintingNameList

		if #var5_13 > 0 then
			if not var3_13 and var4_13 then
				local var6_13, var7_13 = var0_0.CalcPaintingListSize(var5_13)

				if var6_13 > 0 then
					table.insert(var0_13, function(arg0_14)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							modal = true,
							locked = true,
							type = MSGBOX_TYPE_FILE_DOWNLOAD,
							content = string.format(i18n("file_down_msgbox", var7_13)),
							onYes = arg0_14,
							onNo = arg0_13.onNo,
							onClose = arg0_13.onClose
						})
					end)
				end
			end

			table.insert(var0_13, function(arg0_15)
				local var0_15 = {
					groupName = var0_0.PaintingGroupName,
					fileNameList = var5_13
				}
				local var1_15 = {
					dataList = {
						var0_15
					},
					onFinish = arg0_15
				}

				pg.FileDownloadMgr.GetInstance():Main(var1_15)
			end)
			table.insert(var0_13, function(arg0_16)
				pg.m02:sendNotification(var0_0.NotifyPaintingDownloadFinish)
				arg0_16()
			end)
		end
	end

	seriesAsync(var0_13, arg0_13.finishFunc)
end

return var0_0
