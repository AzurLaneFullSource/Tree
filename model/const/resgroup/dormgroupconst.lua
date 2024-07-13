local var0_0 = {}

var0_0.DormGroupName = "DORM"
var0_0.DormMgr = nil

function var0_0.GetDormMgr()
	if not var0_0.DormMgr then
		var0_0.DormMgr = BundleWizard.Inst:GetGroupMgr(var0_0.DormGroupName)
	end

	return var0_0.DormMgr
end

var0_0.NotifyDormDownloadFinish = "DormGroupConst.NotifyDormDownloadFinish"

function var0_0.VerifyDormFileName(arg0_2)
	return GroupHelper.VerifyFile(var0_0.DormGroupName, arg0_2)
end

function var0_0.CalcDormListSize(arg0_3)
	local var0_3 = GroupHelper.CreateArrByLuaFileList(var0_0.DormGroupName, arg0_3)
	local var1_3 = GroupHelper.CalcSizeWithFileArr(var0_0.DormGroupName, var0_3)
	local var2_3 = HashUtil.BytesToString(var1_3)

	return var1_3, var2_3
end

function var0_0.IsDormNeedCheck()
	if Application.isEditor then
		return false
	end

	if GroupHelper.IsGroupVerLastest(var0_0.DormGroupName) then
		return false
	end

	if not GroupHelper.IsGroupWaitToUpdate(var0_0.DormGroupName) then
		return false
	end

	return true
end

function var0_0.DormDownload(arg0_5)
	local var0_5 = {}

	if var0_0.IsDormNeedCheck() then
		local var1_5 = arg0_5.isShowBox
		local var2_5 = pg.FileDownloadMgr.GetInstance():IsNeedRemind()
		local var3_5 = IsUsingWifi()
		local var4_5 = var1_5 and var2_5
		local var5_5 = arg0_5.fileList

		if #var5_5 > 0 then
			if not var3_5 and var4_5 then
				local var6_5, var7_5 = var0_0.CalcDormListSize(var5_5)

				if var6_5 > 0 then
					table.insert(var0_5, function(arg0_6)
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							modal = true,
							locked = true,
							type = MSGBOX_TYPE_FILE_DOWNLOAD,
							content = string.format(i18n("file_down_msgbox", var7_5)),
							onYes = arg0_6,
							onNo = arg0_5.onNo,
							onClose = arg0_5.onClose
						})
					end)
				end
			end

			table.insert(var0_5, function(arg0_7)
				local var0_7 = {
					groupName = var0_0.DormGroupName,
					fileNameList = var5_5
				}
				local var1_7 = {
					dataList = {
						var0_7
					},
					onFinish = arg0_7
				}

				pg.FileDownloadMgr.GetInstance():Main(var1_7)
			end)
			table.insert(var0_5, function(arg0_8)
				pg.m02:sendNotification(var0_0.NotifyDormDownloadFinish)
				arg0_8()
			end)
		end
	end

	seriesAsync(var0_5, arg0_5.finishFunc)
end

return var0_0
