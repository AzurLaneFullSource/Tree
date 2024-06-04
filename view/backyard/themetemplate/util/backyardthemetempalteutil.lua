local var0 = class("BackYardThemeTempalteUtil")
local var1 = false
local var2 = true
local var3 = 1920
local var4 = 1080

var0.TakeScale = 0.86
var0.HideGos = {}
var0.ScaleGos = {}
var0.loader = {}

local var5 = 7

var0.caches = {}

local function var6(...)
	if var1 then
		print(...)
	end
end

local function var7()
	return Application.persistentDataPath .. "/screen_scratch"
end

local function var8(arg0)
	return Application.persistentDataPath .. "/screen_scratch/" .. arg0 .. ".png"
end

local function var9(arg0)
	return arg0 .. ".png"
end

local function var10(arg0)
	if PathMgr.FileExists(arg0) then
		return HashUtil.HashFile(arg0)
	else
		return ""
	end
end

local function var11(arg0, arg1, arg2)
	if not var0.FileExists(arg0) then
		arg2()

		return
	end

	local var0 = var8(arg0)
	local var1 = var9(arg0)

	pg.OSSMgr.GetInstance():GetTexture2D(var1, var0, false, var3, var4, function(arg0, arg1)
		if arg0 and arg1 then
			arg2(arg1)
		else
			arg2()
		end
	end)
end

local function var12(arg0, arg1, arg2)
	if not var2 then
		arg2()

		return
	end

	local var0 = var8(arg0)
	local var1 = var9(arg0)

	pg.OSSMgr.GetInstance():GetTexture2D(var1, var0, true, var3, var4, function(arg0, arg1)
		if arg0 and arg1 and arg1 == var10(var0) then
			arg2(arg1)
		else
			arg2()
		end
	end)
end

local function var13(arg0, arg1)
	if not var2 then
		arg1()

		return
	end

	local var0 = var8(arg0)
	local var1 = var9(arg0)

	pg.OSSMgr.GetInstance():DeleteObject(var1, arg1)
end

local function var14(arg0, arg1)
	if not var2 then
		arg1()

		return
	end

	local var0 = var8(arg0)
	local var1 = var9(arg0)

	pg.OSSMgr.GetInstance():AsynUpdateLoad(var1, var0, arg1)
end

function var0.FileExists(arg0)
	local var0 = var8(arg0)

	return PathMgr.FileExists(var0)
end

function var0.TakePhoto(arg0)
	local var0 = pg.UIMgr.GetInstance().UIMain.parent
	local var1 = var0.sizeDelta.x
	local var2 = var0.sizeDelta.y

	return ScreenShooter.TakePhoto(arg0, var1, var2)
end

function var0.TakeIcon(arg0)
	local var0 = pg.UIMgr.GetInstance().UIMain.parent
	local var1 = var0.sizeDelta.x
	local var2 = var0.sizeDelta.y
	local var3 = 426
	local var4 = 320
	local var5 = var1 * 0.5 - var3 * 0.5
	local var6 = var2 * 0.5 - var4 * 0.5
	local var7 = UnityEngine.Rect.New(var5, var6, var3, var4)

	return ScreenShooter.TakePhoto(arg0, var1, var1, var7)
end

function var0.SavePhoto(arg0, arg1, arg2, arg3)
	seriesAsync({
		function(arg0)
			local var0 = var8(arg0 .. "_icon")

			ScreenShooter.SaveTextureToLocal(var0, arg2, true)
			arg0()
		end,
		function(arg0)
			onNextTick(arg0)
		end,
		function(arg0)
			local var0 = var8(arg0)

			ScreenShooter.SaveTextureToLocal(var0, arg1, true)
			arg0()
		end
	}, function()
		if arg3 then
			arg3()
		end
	end)
end

local function var15(arg0)
	return _.detect(var0.caches, function(arg0)
		return arg0.name == arg0
	end)
end

local function var16(arg0, arg1, arg2)
	local var0 = function(arg0)
		if arg0 then
			var0.CheckCache()
			table.insert(var0.caches, {
				name = arg0,
				asset = arg0
			})
		end

		arg2(arg0)
	end

	if not arg1 or arg1 == "" then
		var0(nil)
	elseif var0.FileExists(arg0) and arg1 == var10(var8(arg0)) then
		var11(arg0, arg1, var0)
	else
		var12(arg0, arg1, var0)
	end
end

function var0.GetTexture(arg0, arg1, arg2)
	local var0 = var15(arg0)

	if var0 then
		arg2(var0.asset)

		return
	end

	var16(arg0, arg1, arg2)
end

function var0.GetNonCacheTexture(arg0, arg1, arg2)
	if not arg1 or arg1 == "" then
		arg2(nil)
	elseif var0.FileExists(arg0) and arg1 == var10(var8(arg0)) then
		var11(arg0, arg1, arg2)
	else
		var12(arg0, arg1, arg2)
	end
end

function var0.UploadTexture(arg0, arg1)
	var14(arg0, arg1)
end

function var0.DeleteTexture(arg0, arg1)
	var13(arg0, arg1)
end

function var0.GetMd5(arg0)
	local var0 = var8(arg0)

	return var10(var0)
end

function var0.GetIconMd5(arg0)
	local var0 = arg0 .. "_icon"

	return var0.GetMd5(var0)
end

function var0.CheckCache()
	if #var0.caches >= var5 then
		var0.ClearCache(1)
		gcAll(false)
	end
end

function var0.CheckSaveDirectory()
	local var0 = var7()

	if not System.IO.Directory.Exists(var0) then
		System.IO.Directory.CreateDirectory(var0)
	end
end

function var0.ClearCaches(arg0)
	if not var0.caches or #var0.caches == 0 then
		return
	end

	for iter0, iter1 in ipairs(arg0) do
		for iter2 = #var0.caches, 1, -1 do
			if var0.caches[iter2].name == iter1 then
				var0.ClearCache(iter2, destroy)
			end
		end
	end
end

function var0.ClearCache(arg0, arg1)
	local var0 = table.remove(var0.caches, arg0)

	if arg1 and not IsNil(var0.asset) then
		Object.Destroy(var0.asset)
	end
end

function var0.ClearAllCacheAsyn()
	for iter0, iter1 in pairs(var0.caches) do
		if not IsNil(iter1.asset) then
			Object.Destroy(iter1.asset)
		end
	end

	var0.caches = {}

	gcAll(false)
end

function var0.ClearAllCache()
	var0.loader = {}

	var0.ClearAllCacheAsyn()
end

return var0
