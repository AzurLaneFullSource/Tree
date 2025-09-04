local var0_0 = class("BackYardThemeTempalteUtil")
local var1_0 = false
local var2_0 = true
local var3_0 = 1920
local var4_0 = 1080

var0_0.TakeScale = 0.86
var0_0.HideGos = {}
var0_0.ScaleGos = {}
var0_0.loader = {}

local var5_0 = 7

var0_0.caches = {}

local function var6_0(...)
	if var1_0 then
		print(...)
	end
end

local function var7_0()
	return Application.persistentDataPath .. "/screen_scratch"
end

local function var8_0(arg0_3)
	return Application.persistentDataPath .. "/screen_scratch/" .. arg0_3 .. ".png"
end

local function var9_0(arg0_4)
	return arg0_4 .. ".png"
end

local function var10_0(arg0_5)
	if PathMgr.FileExists(arg0_5) then
		return HashUtil.HashFile(arg0_5)
	else
		return ""
	end
end

local function var11_0(arg0_6, arg1_6, arg2_6)
	if not var0_0.FileExists(arg0_6) then
		arg2_6()

		return
	end

	local var0_6 = var8_0(arg0_6)
	local var1_6 = var9_0(arg0_6)

	pg.OSSMgr.GetInstance():GetTexture2D(var1_6, var0_6, false, var3_0, var4_0, function(arg0_7, arg1_7)
		if arg0_7 and arg1_7 then
			arg2_6(arg1_7)
		else
			arg2_6()
		end
	end)
end

local function var12_0(arg0_8, arg1_8, arg2_8)
	if not var2_0 then
		arg2_8()

		return
	end

	local var0_8 = var8_0(arg0_8)
	local var1_8 = var9_0(arg0_8)

	pg.OSSMgr.GetInstance():GetTexture2D(var1_8, var0_8, true, var3_0, var4_0, function(arg0_9, arg1_9)
		if arg0_9 and arg1_9 and arg1_8 == var10_0(var0_8) then
			arg2_8(arg1_9)
		else
			arg2_8()
		end
	end)
end

local function var13_0(arg0_10, arg1_10)
	if not var2_0 then
		arg1_10()

		return
	end

	local var0_10 = var8_0(arg0_10)
	local var1_10 = var9_0(arg0_10)

	pg.OSSMgr.GetInstance():DeleteObject(var1_10, arg1_10)
end

local function var14_0(arg0_11, arg1_11)
	if not var2_0 then
		arg1_11()

		return
	end

	local var0_11 = var8_0(arg0_11)
	local var1_11 = var9_0(arg0_11)

	pg.OSSMgr.GetInstance():AsynUpdateLoad(var1_11, var0_11, arg1_11)
end

function var0_0.FileExists(arg0_12)
	local var0_12 = var8_0(arg0_12)

	return PathMgr.FileExists(var0_12)
end

function var0_0.TakePreview(arg0_13, arg1_13)
	var0_0.TakePhoto(arg0_13, arg1_13)
end

function var0_0.TakeIcon(arg0_14, arg1_14)
	local var0_14 = 426
	local var1_14 = 320

	var0_0.TakePhoto(arg0_14, function(arg0_15)
		if arg0_15.width < var0_14 or arg0_15.height < var1_14 then
			arg1_14(arg0_15)

			return
		end

		local var0_15 = arg0_15.width * 0.5 - var0_14 * 0.5
		local var1_15 = arg0_15.height * 0.5 - var1_14 * 0.5
		local var2_15 = arg0_15:GetPixels(var0_15, var1_15, var0_14, var1_14)
		local var3_15 = UnityEngine.Texture2D.New(var0_14, var1_14)

		var3_15:SetPixels(var2_15)
		var3_15:Apply()
		arg1_14(var3_15)
	end)
end

function var0_0.TakePhoto(arg0_16, arg1_16)
	BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(arg0_16, arg1_16)
end

function var0_0.SavePhoto(arg0_17, arg1_17, arg2_17, arg3_17)
	seriesAsync({
		function(arg0_18)
			local var0_18 = var8_0(arg0_17 .. "_icon")

			ScreenShooter.SaveTextureToLocal(var0_18, arg2_17, true)
			arg0_18()
		end,
		function(arg0_19)
			onNextTick(arg0_19)
		end,
		function(arg0_20)
			local var0_20 = var8_0(arg0_17)

			ScreenShooter.SaveTextureToLocal(var0_20, arg1_17, true)
			arg0_20()
		end
	}, function()
		if arg3_17 then
			arg3_17()
		end
	end)
end

local function var15_0(arg0_22)
	return _.detect(var0_0.caches, function(arg0_23)
		return arg0_23.name == arg0_22
	end)
end

local function var16_0(arg0_24, arg1_24, arg2_24)
	local function var0_24(arg0_25)
		if arg0_25 then
			var0_0.CheckCache()
			table.insert(var0_0.caches, {
				name = arg0_24,
				asset = arg0_25
			})
		end

		arg2_24(arg0_25)
	end

	if not arg1_24 or arg1_24 == "" then
		var0_24(nil)
	elseif var0_0.FileExists(arg0_24) and arg1_24 == var10_0(var8_0(arg0_24)) then
		var11_0(arg0_24, arg1_24, var0_24)
	else
		var12_0(arg0_24, arg1_24, var0_24)
	end
end

function var0_0.GetTexture(arg0_26, arg1_26, arg2_26)
	local var0_26 = var15_0(arg0_26)

	if var0_26 then
		arg2_26(var0_26.asset)

		return
	end

	var16_0(arg0_26, arg1_26, arg2_26)
end

function var0_0.GetNonCacheTexture(arg0_27, arg1_27, arg2_27)
	if not arg1_27 or arg1_27 == "" then
		arg2_27(nil)
	elseif var0_0.FileExists(arg0_27) and arg1_27 == var10_0(var8_0(arg0_27)) then
		var11_0(arg0_27, arg1_27, arg2_27)
	else
		var12_0(arg0_27, arg1_27, arg2_27)
	end
end

function var0_0.UploadTexture(arg0_28, arg1_28)
	var14_0(arg0_28, arg1_28)
end

function var0_0.DeleteTexture(arg0_29, arg1_29)
	var13_0(arg0_29, arg1_29)
end

function var0_0.GetMd5(arg0_30)
	local var0_30 = var8_0(arg0_30)

	return var10_0(var0_30)
end

function var0_0.GetIconMd5(arg0_31)
	local var0_31 = arg0_31 .. "_icon"

	return var0_0.GetMd5(var0_31)
end

function var0_0.CheckCache()
	if #var0_0.caches >= var5_0 then
		var0_0.ClearCache(1)
		gcAll(false)
	end
end

function var0_0.CheckSaveDirectory()
	local var0_33 = var7_0()

	if not System.IO.Directory.Exists(var0_33) then
		System.IO.Directory.CreateDirectory(var0_33)
	end
end

function var0_0.ClearCaches(arg0_34)
	if not var0_0.caches or #var0_0.caches == 0 then
		return
	end

	for iter0_34, iter1_34 in ipairs(arg0_34) do
		for iter2_34 = #var0_0.caches, 1, -1 do
			if var0_0.caches[iter2_34].name == iter1_34 then
				var0_0.ClearCache(iter2_34, destroy)
			end
		end
	end
end

function var0_0.ClearCache(arg0_35, arg1_35)
	local var0_35 = table.remove(var0_0.caches, arg0_35)

	if arg1_35 and not IsNil(var0_35.asset) then
		Object.Destroy(var0_35.asset)
	end
end

function var0_0.ClearAllCacheAsyn()
	for iter0_36, iter1_36 in pairs(var0_0.caches) do
		if not IsNil(iter1_36.asset) then
			Object.Destroy(iter1_36.asset)
		end
	end

	var0_0.caches = {}

	gcAll(false)
end

function var0_0.ClearAllCache()
	var0_0.loader = {}

	var0_0.ClearAllCacheAsyn()
end

return var0_0
