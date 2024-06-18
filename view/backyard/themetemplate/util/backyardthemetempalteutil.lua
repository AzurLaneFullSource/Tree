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

function var0_0.TakePhoto(arg0_13)
	local var0_13 = pg.UIMgr.GetInstance().UIMain.parent
	local var1_13 = var0_13.sizeDelta.x
	local var2_13 = var0_13.sizeDelta.y

	return ScreenShooter.TakePhoto(arg0_13, var1_13, var2_13)
end

function var0_0.TakeIcon(arg0_14)
	local var0_14 = pg.UIMgr.GetInstance().UIMain.parent
	local var1_14 = var0_14.sizeDelta.x
	local var2_14 = var0_14.sizeDelta.y
	local var3_14 = 426
	local var4_14 = 320
	local var5_14 = var1_14 * 0.5 - var3_14 * 0.5
	local var6_14 = var2_14 * 0.5 - var4_14 * 0.5
	local var7_14 = UnityEngine.Rect.New(var5_14, var6_14, var3_14, var4_14)

	return ScreenShooter.TakePhoto(arg0_14, var1_14, var1_14, var7_14)
end

function var0_0.SavePhoto(arg0_15, arg1_15, arg2_15, arg3_15)
	seriesAsync({
		function(arg0_16)
			local var0_16 = var8_0(arg0_15 .. "_icon")

			ScreenShooter.SaveTextureToLocal(var0_16, arg2_15, true)
			arg0_16()
		end,
		function(arg0_17)
			onNextTick(arg0_17)
		end,
		function(arg0_18)
			local var0_18 = var8_0(arg0_15)

			ScreenShooter.SaveTextureToLocal(var0_18, arg1_15, true)
			arg0_18()
		end
	}, function()
		if arg3_15 then
			arg3_15()
		end
	end)
end

local function var15_0(arg0_20)
	return _.detect(var0_0.caches, function(arg0_21)
		return arg0_21.name == arg0_20
	end)
end

local function var16_0(arg0_22, arg1_22, arg2_22)
	local function var0_22(arg0_23)
		if arg0_23 then
			var0_0.CheckCache()
			table.insert(var0_0.caches, {
				name = arg0_22,
				asset = arg0_23
			})
		end

		arg2_22(arg0_23)
	end

	if not arg1_22 or arg1_22 == "" then
		var0_22(nil)
	elseif var0_0.FileExists(arg0_22) and arg1_22 == var10_0(var8_0(arg0_22)) then
		var11_0(arg0_22, arg1_22, var0_22)
	else
		var12_0(arg0_22, arg1_22, var0_22)
	end
end

function var0_0.GetTexture(arg0_24, arg1_24, arg2_24)
	local var0_24 = var15_0(arg0_24)

	if var0_24 then
		arg2_24(var0_24.asset)

		return
	end

	var16_0(arg0_24, arg1_24, arg2_24)
end

function var0_0.GetNonCacheTexture(arg0_25, arg1_25, arg2_25)
	if not arg1_25 or arg1_25 == "" then
		arg2_25(nil)
	elseif var0_0.FileExists(arg0_25) and arg1_25 == var10_0(var8_0(arg0_25)) then
		var11_0(arg0_25, arg1_25, arg2_25)
	else
		var12_0(arg0_25, arg1_25, arg2_25)
	end
end

function var0_0.UploadTexture(arg0_26, arg1_26)
	var14_0(arg0_26, arg1_26)
end

function var0_0.DeleteTexture(arg0_27, arg1_27)
	var13_0(arg0_27, arg1_27)
end

function var0_0.GetMd5(arg0_28)
	local var0_28 = var8_0(arg0_28)

	return var10_0(var0_28)
end

function var0_0.GetIconMd5(arg0_29)
	local var0_29 = arg0_29 .. "_icon"

	return var0_0.GetMd5(var0_29)
end

function var0_0.CheckCache()
	if #var0_0.caches >= var5_0 then
		var0_0.ClearCache(1)
		gcAll(false)
	end
end

function var0_0.CheckSaveDirectory()
	local var0_31 = var7_0()

	if not System.IO.Directory.Exists(var0_31) then
		System.IO.Directory.CreateDirectory(var0_31)
	end
end

function var0_0.ClearCaches(arg0_32)
	if not var0_0.caches or #var0_0.caches == 0 then
		return
	end

	for iter0_32, iter1_32 in ipairs(arg0_32) do
		for iter2_32 = #var0_0.caches, 1, -1 do
			if var0_0.caches[iter2_32].name == iter1_32 then
				var0_0.ClearCache(iter2_32, destroy)
			end
		end
	end
end

function var0_0.ClearCache(arg0_33, arg1_33)
	local var0_33 = table.remove(var0_0.caches, arg0_33)

	if arg1_33 and not IsNil(var0_33.asset) then
		Object.Destroy(var0_33.asset)
	end
end

function var0_0.ClearAllCacheAsyn()
	for iter0_34, iter1_34 in pairs(var0_0.caches) do
		if not IsNil(iter1_34.asset) then
			Object.Destroy(iter1_34.asset)
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
