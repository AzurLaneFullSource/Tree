local var0_0 = {}

DownloadConst = var0_0
var0_0.NotifyDownloadFinish = "DownloadConst.NotifyDownloadFinish"

function var0_0.GetAllGroup()
	return BundleWizard.Inst:GetAllGroups()
end

function var0_0.VerifyFile(arg0_2)
	local var0_2 = GroupHelper.GetGroupNameByFilePath(arg0_2)

	return GroupHelper.VerifyFile(var0_2, arg0_2)
end

function var0_0.IsNeedCheck()
	local var0_3 = Application.isEditor
	local var1_3 = SplitPackHelper.Inst:IsSplitPackMode()

	if var0_3 and not var1_3 then
		return false
	end

	local var2_3 = GroupHelper.IsAllGroupVerLastest()
	local var3_3 = GroupHelper.IsAnyGroupWaitToUpdate()

	if not var1_3 then
		if var0_3 or var2_3 or not var3_3 then
			return false
		else
			return true
		end
	elseif var3_3 then
		return true
	else
		return false
	end
end

function var0_0.CalcListSize(arg0_4)
	local var0_4 = 0

	for iter0_4, iter1_4 in pairs(arg0_4) do
		var0_4 = var0_4 + GroupHelper.CalcSizeWithFileArr(iter0_4, iter1_4)
	end

	local var1_4 = HashUtil.BytesToString(var0_4)

	return var0_4, var1_4
end

function var0_0.IndexFileListByGroup(arg0_5)
	local var0_5 = 0
	local var1_5 = {}

	for iter0_5, iter1_5 in ipairs(arg0_5) do
		iter1_5 = string.lower(iter1_5)

		local var2_5 = GroupHelper.GetGroupNameByFilePath(iter1_5)

		if var1_5[var2_5] == nil then
			var1_5[var2_5] = {}
		end

		if var0_0.VerifyFile(iter1_5) and not table.contains(var1_5[var2_5], iter1_5) then
			table.insert(var1_5[var2_5], iter1_5)

			var0_5 = var0_5 + 1
		end
	end

	return var1_5, var0_5
end

function var0_0.Download(arg0_6)
	local var0_6 = {}

	if var0_0.IsNeedCheck() then
		local var1_6 = arg0_6.isShowBox
		local var2_6 = pg.FileDownloadMgr.GetInstance():IsNeedRemind()
		local var3_6 = IsUsingWifi()
		local var4_6 = var1_6 and var2_6
		local var5_6, var6_6 = var0_0.IndexFileListByGroup(arg0_6.fileList)

		if var6_6 > 0 then
			if var4_6 then
				local var7_6, var8_6 = var0_0.CalcListSize(var5_6)

				table.insert(var0_6, function(arg0_7)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						modal = true,
						locked = true,
						hideToggle = true,
						type = MSGBOX_TYPE_FILE_DOWNLOAD,
						content = string.format(i18n("file_down_msgbox", var8_6)),
						onYes = arg0_7,
						onNo = arg0_6.onNo,
						onClose = arg0_6.onClose
					})
				end)
			end

			table.insert(var0_6, function(arg0_8)
				local var0_8 = {
					dataList = {},
					onFinish = arg0_8
				}

				for iter0_8, iter1_8 in pairs(var5_6) do
					local var1_8 = {
						groupName = iter0_8,
						fileNameList = iter1_8
					}

					table.insert(var0_8.dataList, var1_8)
				end

				pg.FileDownloadMgr.GetInstance():Main(var0_8)
			end)
			table.insert(var0_6, function(arg0_9)
				pg.m02:sendNotification(var0_0.NotifyDownloadFinish)
				arg0_9()
			end)
		end
	end

	seriesAsync(var0_6, arg0_6.finishFunc)
end

return var0_0
