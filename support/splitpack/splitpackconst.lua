local var0_0 = {}

SplitPackConst = var0_0

function var0_0.DownloadByLuaArr(arg0_1, arg1_1, arg2_1)
	arg2_1 = arg2_1 or {}

	local var0_1 = AssetBundleHelper.GetTotalRefList(arg0_1) or {}

	if EDITOR_TOOL then
		local var1_1 = {}

		for iter0_1, iter1_1 in ipairs(var0_1) do
			if not checkABExist(iter1_1) then
				table.insert(var1_1, iter1_1)
			end
		end

		if #var1_1 > 0 then
			warning(string.format("Split pack resource missing: %s", table.concat(var1_1, ", ")))
		end

		local var2_1 = #var0_1
		local var3_1 = System.Array.CreateInstance(typeof(System.String), var2_1)

		for iter2_1 = 0, var2_1 - 1 do
			var3_1[iter2_1] = var0_1[iter2_1 + 1]
		end

		ReflectionHelp.RefCallMethod(typeof(ResourceMgr), "UpdateMarkedShortPathList", ResourceMgr.Inst, {
			typeof("System.String[]")
		}, {
			var3_1
		})
		existCall(arg1_1)
	elseif #var0_1 > 0 then
		local var4_1 = {}

		var4_1.isShowBox = false
		var4_1.fileList = var0_1
		var4_1.finishFunc = arg1_1
		var4_1.showMask = arg2_1.showMask == true

		function var4_1.onNo()
			return
		end

		function var4_1.onClose()
			return
		end

		DownloadConst.Download(var4_1)
	else
		existCall(arg1_1)
	end
end

return var0_0
