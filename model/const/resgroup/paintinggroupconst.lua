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
	return DownloadConst.IsNeedCheck()
end

function var0_0.FiltePaintingRes(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5) do
		iter1_5 = string.lower(iter1_5)

		if string.match(iter1_5, "^painting/") then
			table.insert(var0_5, iter1_5)
		end
	end

	return var0_5
end

function var0_0.AddPaintingNameWithFilteMap(arg0_6, arg1_6)
	arg1_6 = string.lower(arg1_6)

	if not pg.painting_filte_map then
		warning("painting_filte_map not exist")

		return
	end

	if not pg.painting_filte_map[arg1_6] then
		warning("painting_filte_map not exist key: " .. arg1_6)

		return
	end

	local var0_6 = pg.painting_filte_map[arg1_6].res_list

	for iter0_6, iter1_6 in ipairs(var0_6) do
		if not table.contains(arg0_6, iter1_6) and var0_0.VerifyPaintingFileName(iter1_6) then
			table.insert(arg0_6, iter1_6)
		end
	end
end

function var0_0.AddPaintingNameByShipGroupID(arg0_7, arg1_7)
	if var0_0.IsPaintingNeedCheck() then
		local var0_7 = ShipGroup.getDefaultSkin(arg1_7).painting

		var0_0.AddPaintingNameWithFilteMap(arg0_7, var0_7)
	end
end

function var0_0.AddPaintingNameByShipConfigID(arg0_8, arg1_8)
	if var0_0.IsPaintingNeedCheck() then
		local var0_8 = {
			configId = arg1_8
		}
		local var1_8 = Ship.getGroupId(var0_8)

		var0_0.AddPaintingNameByShipGroupID(arg0_8, var1_8)
	end
end

function var0_0.AddPaintingNameBySkinID(arg0_9, arg1_9)
	if var0_0.IsPaintingNeedCheck() then
		local var0_9 = {
			arg1_9
		}

		if ShipSkin.IsChangeSkin(arg1_9) then
			local var1_9 = ShipSkin.GetAllChangeSkinIds(arg1_9)

			for iter0_9, iter1_9 in ipairs(var1_9) do
				if not table.contains(var0_9, iter1_9) then
					table.insert(var0_9, iter1_9)
				end
			end
		end

		for iter2_9, iter3_9 in ipairs(var0_9) do
			local var2_9 = pg.ship_skin_template[iter3_9].painting

			if #var2_9 > 0 then
				var0_0.AddPaintingNameWithFilteMap(arg0_9, var2_9)
			end
		end
	end
end

function var0_0.GetPaintingNameListInLogin()
	local var0_10 = {}
	local var1_10 = var0_0.GetPaintingMgr()
	local var2_10 = getProxy(ShipSkinProxy)

	if var2_10 then
		local var3_10 = var2_10:GetOwnAndShareSkins()

		for iter0_10, iter1_10 in pairs(var3_10) do
			var0_0.AddPaintingNameBySkinID(var0_10, iter1_10.id)
		end
	end

	local var4_10 = getProxy(CollectionProxy)

	if var4_10 then
		local var5_10 = var4_10:getGroups()

		for iter2_10, iter3_10 in pairs(var5_10) do
			var0_0.AddPaintingNameByShipGroupID(var0_10, iter3_10.id)
		end
	end

	local var6_10 = getProxy(BayProxy)

	if var6_10 then
		local var7_10 = var6_10.activityNPCShipIds

		for iter4_10, iter5_10 in ipairs(var7_10) do
			local var8_10 = var6_10:getShipById(iter5_10)

			var0_0.AddPaintingNameByShipGroupID(var0_10, var8_10.groupId)
		end
	end

	return var0_10
end

function var0_0.GetPaintingNameListForTec()
	local var0_11 = {}

	for iter0_11, iter1_11 in ipairs(pg.ship_data_blueprint.all) do
		var0_0.AddPaintingNameByShipGroupID(var0_11, iter1_11)
	end

	return var0_11
end

function var0_0.GetPaintingNameListForAwardList(arg0_12)
	local var0_12 = {}

	for iter0_12 = 1, #arg0_12 do
		local var1_12 = arg0_12[iter0_12]
		local var2_12 = var1_12.type

		if var2_12 == DROP_TYPE_SHIP then
			local var3_12 = var1_12.id

			var0_0.AddPaintingNameByShipConfigID(var0_12, var3_12)
		elseif var2_12 == DROP_TYPE_NPC_SHIP then
			local var4_12 = getProxy(BayProxy):getShipById(var1_12.id)

			var0_0.AddPaintingNameByShipConfigID(var0_12, var4_12.configId)
		elseif var2_12 == DROP_TYPE_SKIN then
			local var5_12 = var1_12.id

			var0_0.AddPaintingNameBySkinID(var0_12, var5_12)
		end
	end

	return var0_12
end

function var0_0.GetPaintingNameListByShipVO(arg0_13)
	local var0_13 = {}
	local var1_13 = getProxy(ShipSkinProxy)
	local var2_13 = var1_13:GetAllSkinForShip(arg0_13)

	for iter0_13, iter1_13 in ipairs(var2_13) do
		var0_0.AddPaintingNameBySkinID(var0_13, iter1_13.id)
	end

	local var3_13 = var1_13:GetShareSkinsForShip(arg0_13)

	for iter2_13, iter3_13 in ipairs(var3_13) do
		var0_0.AddPaintingNameBySkinID(var0_13, iter3_13.id)
	end

	return var0_13
end

function var0_0.GetPaintingNameListForMallAct(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(pg.activity_mall_custom_order.all) do
		var0_0.AddPaintingNameBySkinID(var0_14, pg.activity_mall_custom_order[iter1_14].char)
	end

	return var0_14
end

function var0_0.PaintingDownload(arg0_15)
	local var0_15 = {}

	if var0_0.IsPaintingNeedCheck() then
		local var1_15 = arg0_15.isShowBox
		local var2_15 = pg.FileDownloadMgr.GetInstance():IsNeedRemind()
		local var3_15 = IsUsingWifi()
		local var4_15 = var1_15 and var2_15
		local var5_15 = arg0_15.paintingNameList

		if #var5_15 > 0 then
			if not var3_15 and var4_15 then
				local var6_15, var7_15 = var0_0.CalcPaintingListSize(var5_15)

				if var6_15 > 0 then
					table.insert(var0_15, function(arg0_16)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							modal = true,
							locked = true,
							type = MSGBOX_TYPE_FILE_DOWNLOAD,
							content = string.format(i18n("file_down_msgbox", var7_15)),
							onYes = arg0_16,
							onNo = arg0_15.onNo,
							onClose = arg0_15.onClose
						})
					end)
				end
			end

			table.insert(var0_15, function(arg0_17)
				local var0_17 = {
					groupName = var0_0.PaintingGroupName,
					fileNameList = var5_15
				}
				local var1_17 = {
					dataList = {
						var0_17
					},
					onFinish = arg0_17
				}

				pg.FileDownloadMgr.GetInstance():Main(var1_17)
			end)
			table.insert(var0_15, function(arg0_18)
				pg.m02:sendNotification(var0_0.NotifyPaintingDownloadFinish)
				arg0_18()
			end)
		end
	end

	seriesAsync(var0_15, arg0_15.finishFunc)
end

return var0_0
