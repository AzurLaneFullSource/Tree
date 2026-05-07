local var0_0 = {}

SplitPackConst = var0_0

function var0_0.DownloadByLuaArr(arg0_1, arg1_1)
	local var0_1 = AssetBundleHelper.GetTotalRefList(arg0_1)

	if var0_1 and #var0_1 > 0 then
		local var1_1 = {}

		var1_1.isShowBox = false
		var1_1.fileList = var0_1
		var1_1.finishFunc = arg1_1

		function var1_1.onNo()
			return
		end

		function var1_1.onClose()
			return
		end

		DownloadConst.Download(var1_1)
	elseif arg1_1 then
		arg1_1()
	end
end

function var0_0.StartMainDownload()
	local var0_4 = {
		GroupMainHelper.DefaultGroupName
	}

	local function var1_4(arg0_5, arg1_5, arg2_5)
		return
	end

	local function var2_4(arg0_6, arg1_6)
		return
	end

	local function var3_4(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7, arg5_7)
		local var0_7 = string.format("成功: %d, 失败: %d, 总文件数: %d, 下载速度: %s", arg0_7, arg1_7, arg2_7, arg5_7)

		print(var0_7)
	end

	local var4_4 = BundleWizardUpdater.Inst:GetFileList(var0_4)
	local var5_4 = BundleWizardUpdater.Inst:CreateListInfo(GroupMainHelper.DefaultGroupName, var4_4, var1_4, var2_4, var3_4)

	BundleWizardUpdater.Inst:StartUpdate(var5_4)
end

return var0_0
