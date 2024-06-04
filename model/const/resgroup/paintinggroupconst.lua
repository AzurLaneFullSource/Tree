local var0 = {}

var0.PaintingGroupName = "PAINTING"
var0.PaintingMgr = nil

function var0.GetPaintingMgr()
	if not var0.PaintingMgr then
		var0.PaintingMgr = BundleWizard.Inst:GetGroupMgr(var0.PaintingGroupName)
	end

	return var0.PaintingMgr
end

var0.NotifyPaintingDownloadFinish = "PaintingGroupConst.NotifyPaintingDownloadFinish"

function var0.VerifyPaintingFileName(arg0)
	return GroupHelper.VerifyFile(var0.PaintingGroupName, arg0)
end

function var0.CalcPaintingListSize(arg0)
	local var0 = GroupHelper.CreateArrByLuaFileList(var0.PaintingGroupName, arg0)
	local var1 = GroupHelper.CalcSizeWithFileArr(var0.PaintingGroupName, var0)
	local var2 = HashUtil.BytesToString(var1)

	return var1, var2
end

function var0.IsPaintingNeedCheck()
	if Application.isEditor then
		return false
	end

	if GroupHelper.IsGroupVerLastest(var0.PaintingGroupName) then
		return false
	end

	if not GroupHelper.IsGroupWaitToUpdate(var0.PaintingGroupName) then
		return false
	end

	return true
end

function var0.AddPaintingNameWithFilteMap(arg0, arg1)
	arg1 = string.lower(arg1)

	if not pg.painting_filte_map then
		warning("painting_filte_map not exist")

		return
	end

	if not pg.painting_filte_map[arg1] then
		warning("painting_filte_map not exist key: " .. arg1)

		return
	end

	local var0 = pg.painting_filte_map[arg1].res_list

	for iter0, iter1 in ipairs(var0) do
		if not table.contains(arg0, iter1) and var0.VerifyPaintingFileName(iter1) then
			table.insert(arg0, iter1)
		end
	end
end

function var0.AddPaintingNameByShipGroupID(arg0, arg1)
	if var0.IsPaintingNeedCheck() then
		local var0 = ShipGroup.getDefaultSkin(arg1).painting

		var0.AddPaintingNameWithFilteMap(arg0, var0)
	end
end

function var0.AddPaintingNameByShipConfigID(arg0, arg1)
	if var0.IsPaintingNeedCheck() then
		local var0 = {
			configId = arg1
		}
		local var1 = Ship.getGroupId(var0)

		var0.AddPaintingNameByShipGroupID(arg0, var1)
	end
end

function var0.AddPaintingNameBySkinID(arg0, arg1)
	if var0.IsPaintingNeedCheck() then
		local var0 = pg.ship_skin_template[arg1].painting

		if #var0 > 0 then
			var0.AddPaintingNameWithFilteMap(arg0, var0)
		end
	end
end

function var0.GetPaintingNameListInLogin()
	local var0 = {}
	local var1 = var0.GetPaintingMgr()
	local var2 = getProxy(ShipSkinProxy)

	if var2 then
		local var3 = var2:GetOwnAndShareSkins()

		for iter0, iter1 in pairs(var3) do
			var0.AddPaintingNameBySkinID(var0, iter1.id)
		end
	end

	local var4 = getProxy(CollectionProxy)

	if var4 then
		local var5 = var4:getGroups()

		for iter2, iter3 in pairs(var5) do
			var0.AddPaintingNameByShipGroupID(var0, iter3.id)
		end
	end

	local var6 = getProxy(BayProxy)

	if var6 then
		local var7 = var6.activityNpcShipIds

		for iter4, iter5 in ipairs(var7) do
			local var8 = var6:getShipById(iter5)

			var0.AddPaintingNameByShipGroupID(var0, var8.groupId)
		end
	end

	return var0
end

function var0.GetPaintingNameListForTec()
	local var0 = {}

	for iter0, iter1 in ipairs(pg.ship_data_blueprint.all) do
		var0.AddPaintingNameByShipGroupID(var0, iter1)
	end

	return var0
end

function var0.GetPaintingNameListForAwardList(arg0)
	local var0 = {}

	for iter0 = 1, #arg0 do
		local var1 = arg0[iter0]
		local var2 = var1.type

		if var2 == DROP_TYPE_SHIP then
			local var3 = var1.id

			var0.AddPaintingNameByShipConfigID(var0, var3)
		elseif var2 == DROP_TYPE_NPC_SHIP then
			local var4 = getProxy(BayProxy):getShipById(var1.id)

			var0.AddPaintingNameByShipConfigID(var0, var4.configId)
		elseif var2 == DROP_TYPE_SKIN then
			local var5 = var1.id

			var0.AddPaintingNameBySkinID(var0, var5)
		end
	end

	return var0
end

function var0.GetPaintingNameListByShipVO(arg0)
	local var0 = {}
	local var1 = getProxy(ShipSkinProxy)
	local var2 = var1:GetAllSkinForShip(arg0)

	for iter0, iter1 in ipairs(var2) do
		var0.AddPaintingNameBySkinID(var0, iter1.id)
	end

	local var3 = var1:GetShareSkinsForShip(arg0)

	for iter2, iter3 in ipairs(var3) do
		var0.AddPaintingNameBySkinID(var0, iter3.id)
	end

	return var0
end

function var0.PaintingDownload(arg0)
	local var0 = {}

	if var0.IsPaintingNeedCheck() then
		local var1 = arg0.isShowBox
		local var2 = pg.FileDownloadMgr.GetInstance():IsNeedRemind()
		local var3 = IsUsingWifi()
		local var4 = var1 and var2
		local var5 = arg0.paintingNameList

		if #var5 > 0 then
			if not var3 and var4 then
				local var6, var7 = var0.CalcPaintingListSize(var5)

				if var6 > 0 then
					table.insert(var0, function(arg0)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							modal = true,
							locked = true,
							type = MSGBOX_TYPE_FILE_DOWNLOAD,
							content = string.format(i18n("file_down_msgbox", var7)),
							onYes = arg0,
							onNo = arg0.onNo,
							onClose = arg0.onClose
						})
					end)
				end
			end

			table.insert(var0, function(arg0)
				local var0 = {
					groupName = var0.PaintingGroupName,
					fileNameList = var5
				}
				local var1 = {
					dataList = {
						var0
					},
					onFinish = arg0
				}

				pg.FileDownloadMgr.GetInstance():Main(var1)
			end)
			table.insert(var0, function(arg0)
				pg.m02:sendNotification(var0.NotifyPaintingDownloadFinish)
				arg0()
			end)
		end
	end

	seriesAsync(var0, arg0.finishFunc)
end

return var0
