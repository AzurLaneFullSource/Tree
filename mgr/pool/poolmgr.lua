local var0_0 = singletonClass("PoolMgr")

pg = pg or {}
pg.PoolMgr = var0_0
PoolMgr = var0_0

local var1_0 = require("Mgr/Pool/PoolPlural")
local var2_0 = require("Mgr/Pool/PoolSingleton")
local var3_0 = require("Mgr/Pool/PoolObjPack")
local var4_0 = require("Mgr/Pool/PoolUtil")
local var5_0 = ResourceMgr.Inst

function var0_0.Ctor(arg0_1)
	arg0_1.root = GameObject.New("__Pool__").transform
	arg0_1.pools_plural = {}
	arg0_1.pools_pack = {}
	arg0_1.callbacks = {}
	arg0_1.pluralIndex = 0
	arg0_1.singleIndex = 0
	arg0_1.paintingCount = 0
	arg0_1.commanderPaintingCount = 0
	arg0_1.preloadDic = {
		shiptype = {},
		shipframe = {},
		shipframeb = {},
		["shipyardicon/unknown"] = {},
		skillframe = {},
		weaponframes = {},
		energy = {},
		custom_builtin = {},
		shipstatus = {},
		channel = {},
		["painting/mat"] = {},
		["ui/commonui_atlas"] = {},
		["ui/share/msgbox_atlas"] = {},
		["ui/share/world_common_atlas"] = {},
		skinicon = {},
		attricon = {}
	}
	arg0_1.ui_tempCache = {}
end

function var0_0.Init(arg0_2, arg1_2)
	print("initializing pool manager...")

	local var0_2 = {}

	for iter0_2, iter1_2 in pairs(arg0_2.preloadDic) do
		table.insert(var0_2, function(arg0_3)
			AssetBundleHelper.LoadAssetBundle(iter0_2, true, true, function(arg0_4)
				arg0_2:AddPoolsPack(iter0_2, arg0_4)
				arg0_3()
			end)
		end)
	end

	seriesAsync(var0_2, arg1_2)
end

function var0_0.GetSpineChar(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = {}
	local var1_5 = "char/" .. arg1_5

	if not arg0_5.pools_plural[var1_5] then
		table.insert(var0_5, function(arg0_6)
			arg0_5:GetSpineSkel(arg1_5, arg2_5, function(arg0_7)
				assert(arg0_7 ~= nil, "Spine角色不存在: " .. arg1_5)

				if not arg0_5.pools_plural[var1_5] then
					arg0_7 = SpineAnimUI.AnimChar(arg1_5, arg0_7)

					arg0_7:SetActive(false)
					tf(arg0_7):SetParent(arg0_5.root, false)

					local var0_7 = arg0_7:GetComponent("SkeletonGraphic")

					var0_7.material = var0_7.skeletonDataAsset.atlasAssets[0].materials[0]
					arg0_5.pools_plural[var1_5] = var1_0.New(arg0_7, 1)
				end

				arg0_6()
			end)
		end)
	end

	seriesAsync(var0_5, function()
		local var0_8 = arg0_5.pools_plural[var1_5]

		var0_8.index = arg0_5.pluralIndex
		arg0_5.pluralIndex = arg0_5.pluralIndex + 1

		local var1_8 = var0_8:Dequeue()

		var1_8:SetActive(true)
		arg3_5(var1_8)
	end)
end

function var0_0.ReturnSpineChar(arg0_9, arg1_9, arg2_9)
	local var0_9 = "char/" .. arg1_9

	if IsNil(arg2_9) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_9))
	elseif arg0_9.pools_plural[var0_9] then
		if arg2_9:GetComponent("SkeletonGraphic").allowMultipleCanvasRenderers then
			UIUtil.ClearChildren(arg2_9, {
				"Renderer"
			})
		else
			UIUtil.ClearChildren(arg2_9)
		end

		setActiveViaLayer(arg2_9.transform, true)
		arg2_9:SetActive(false)
		arg2_9.transform:SetParent(arg0_9.root, false)

		arg2_9.transform.localPosition = Vector3.New(0, 0, 0)
		arg2_9.transform.localScale = Vector3.New(0.5, 0.5, 1)
		arg2_9.transform.localRotation = Quaternion.identity

		arg0_9.pools_plural[var0_9]:Enqueue(arg2_9)
		arg0_9:ExcessSpineChar()
	else
		var4_0.Destroy(arg2_9)
	end
end

function var0_0.ExcessSpineChar(arg0_10)
	local var0_10 = 0
	local var1_10 = 6
	local var2_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10.pools_plural) do
		if string.find(iter0_10, "char/") == 1 then
			table.insert(var2_10, iter0_10)
		end
	end

	if var1_10 < #var2_10 then
		table.sort(var2_10, function(arg0_11, arg1_11)
			return arg0_10.pools_plural[arg0_11].index > arg0_10.pools_plural[arg1_11].index
		end)

		for iter2_10 = var1_10 + 1, #var2_10 do
			local var3_10 = var2_10[iter2_10]

			arg0_10.pools_plural[var3_10]:Clear()

			arg0_10.pools_plural[var3_10] = nil
		end
	end
end

function var0_0.GetSpineSkel(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12, var1_12 = HXSet.autoHxShiftPath("char/" .. arg1_12, arg1_12)
	local var2_12 = var1_12 .. "_SkeletonData"

	arg0_12:LoadAsset(var0_12, "", typeof(Object), arg2_12, function(arg0_13)
		arg3_12(arg0_13)
	end, true)
end

function var0_0.IsSpineSkelCached(arg0_14, arg1_14)
	local var0_14 = "char/" .. arg1_14

	return arg0_14.pools_plural[var0_14] ~= nil
end

local var6_0 = {
	"ResPanel",
	"WorldResPanel"
}
local var7_0 = {
	"ResPanel",
	"WorldResPanel",
	"NewMainUI",
	"DockyardUI",
	"AwardInfoUI",
	"SkillInfoUI",
	"ItemInfoUI",
	"ShipDetailView",
	"LevelFleetSelectView",
	"Loading",
	"WorldUI"
}
local var8_0 = {}

function var0_0.GetUI(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = "ui/" .. arg1_15
	local var1_15 = table.contains(var6_0, arg1_15) and 3 or 1

	arg0_15:FromPlural(var0_15, "", arg2_15, var1_15, function(arg0_16)
		local function var0_16()
			arg3_15(arg0_16)
		end

		if table.indexof(var8_0, arg1_15) then
			local var1_16 = var0_15

			arg0_15.pools_plural[var1_16].prefab:GetComponent(typeof(UIArchiver)):Clear()
			arg0_16:GetComponent(typeof(UIArchiver)):Load(var0_16)
		else
			var0_16()
		end
	end)
end

function var0_0.ReturnUI(arg0_18, arg1_18, arg2_18)
	local var0_18 = "ui/" .. arg1_18

	if IsNil(arg2_18) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_18))
	elseif arg0_18.pools_plural[var0_18] then
		if table.indexof(var6_0, arg1_18) then
			arg2_18.transform:SetParent(arg0_18.root, false)
		end

		if table.indexof(var7_0, arg1_18) or arg0_18.ui_tempCache[arg1_18] then
			setActiveViaLayer(arg2_18.transform, false)
			arg0_18.pools_plural[var0_18]:Enqueue(arg2_18)
		elseif table.indexof(var8_0, arg1_18) then
			setActiveViaLayer(arg2_18.transform, false)
			arg2_18:GetComponent(typeof(UIArchiver)):Clear()
			arg0_18.pools_plural[var0_18]:Enqueue(arg2_18)
		else
			arg0_18.pools_plural[var0_18]:Enqueue(arg2_18, true)

			if arg0_18.pools_plural[var0_18]:AllReturned() and (not arg0_18.callbacks[var0_18] or #arg0_18.callbacks[var0_18] == 0) then
				arg0_18.pools_plural[var0_18]:Clear()

				arg0_18.pools_plural[var0_18] = nil
			end
		end
	else
		var4_0.Destroy(arg2_18)
	end
end

function var0_0.HasCacheUI(arg0_19, arg1_19)
	local var0_19 = "ui/" .. arg1_19

	return arg0_19.pools_plural[var0_19] ~= nil
end

function var0_0.PreloadUI(arg0_20, arg1_20, arg2_20)
	local var0_20 = {}
	local var1_20 = "ui/" .. arg1_20

	if not arg0_20.pools_plural[var1_20] then
		table.insert(var0_20, function(arg0_21)
			arg0_20:GetUI(arg1_20, true, function(arg0_22)
				arg0_20.pools_plural[var1_20]:Enqueue(arg0_22)
				arg0_21()
			end)
		end)
	end

	seriesAsync(var0_20, arg2_20)
end

function var0_0.AddTempCache(arg0_23, arg1_23)
	arg0_23.ui_tempCache[arg1_23] = true
end

function var0_0.DelTempCache(arg0_24, arg1_24)
	arg0_24.ui_tempCache[arg1_24] = nil
end

function var0_0.ClearAllTempCache(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.ui_tempCache) do
		if iter1_25 then
			local var0_25 = "ui/" .. iter0_25

			if arg0_25.pools_plural[var0_25] then
				arg0_25.pools_plural[var0_25]:Clear()

				arg0_25.pools_plural[var0_25] = nil
			end
		end
	end
end

function var0_0.PreloadPainting(arg0_26, arg1_26, arg2_26)
	local var0_26 = {}
	local var1_26 = "painting/" .. arg1_26

	if not arg0_26.pools_plural[var1_26] then
		table.insert(var0_26, function(arg0_27)
			arg0_26:GetPainting(arg1_26, true, function(arg0_28)
				arg0_26.pools_plural[var1_26]:Enqueue(arg0_28)
				arg0_27()
			end)
		end)
	end

	seriesAsync(var0_26, arg2_26)
end

function var0_0.GetPainting(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = "painting/" .. arg1_29
	local var1_29 = var0_29

	arg0_29:FromPlural(var0_29, "", arg2_29, 1, function(arg0_30)
		arg0_30:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_29) then
			setActive(tf(arg0_30):Find("face"), true)
		end

		arg3_29(arg0_30)
	end)
end

function var0_0.ReturnPainting(arg0_31, arg1_31, arg2_31)
	local var0_31 = "painting/" .. arg1_31

	if IsNil(arg2_31) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_31))
	elseif arg0_31.pools_plural[var0_31] then
		setActiveViaLayer(arg2_31, true)

		local var1_31 = tf(arg2_31):Find("face")

		if var1_31 then
			setActive(var1_31, false)
		end

		arg2_31:SetActive(false)
		arg2_31.transform:SetParent(arg0_31.root, false)
		arg0_31.pools_plural[var0_31]:Enqueue(arg2_31)
		arg0_31:ExcessPainting()
	else
		var4_0.Destroy(arg2_31)
	end
end

function var0_0.ExcessPainting(arg0_32, arg1_32)
	local var0_32 = 0
	local var1_32 = 4
	local var2_32 = {}

	for iter0_32, iter1_32 in pairs(arg0_32.pools_plural) do
		local var3_32 = string.find(iter0_32, "painting/")

		if var3_32 and var3_32 >= 1 then
			table.insert(var2_32, iter0_32)
		end
	end

	if var1_32 < #var2_32 then
		table.sort(var2_32, function(arg0_33, arg1_33)
			return arg0_32.pools_plural[arg0_33].index > arg0_32.pools_plural[arg1_33].index
		end)

		for iter2_32 = var1_32 + 1, #var2_32 do
			local var4_32 = var2_32[iter2_32]

			arg0_32.pools_plural[var4_32]:Clear(true)

			arg0_32.pools_plural[var4_32] = nil
		end

		arg0_32.paintingCount = arg0_32.paintingCount + 1
	end

	if arg1_32 then
		arg0_32.paintingCount = 0
	elseif arg0_32.paintingCount >= 10 then
		arg0_32.paintingCount = 0

		gcAll(false)
	end
end

function var0_0.GetPaintingWithPrefix(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	local var0_34 = arg4_34 .. arg1_34
	local var1_34 = var0_34

	arg0_34:FromPlural(var0_34, "", arg2_34, 1, function(arg0_35)
		arg0_35:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_34) then
			setActive(tf(arg0_35):Find("face"), true)
		end

		arg3_34(arg0_35)
	end)
end

function var0_0.ReturnPaintingWithPrefix(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = arg3_36 .. arg1_36

	if IsNil(arg2_36) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_36))
	elseif arg0_36.pools_plural[var0_36] then
		setActiveViaLayer(arg2_36, true)

		local var1_36 = tf(arg2_36):Find("face")

		if var1_36 then
			setActive(var1_36, false)
		end

		arg2_36:SetActive(false)
		arg2_36.transform:SetParent(arg0_36.root, false)
		arg0_36.pools_plural[var0_36]:Enqueue(arg2_36)
		arg0_36:ExcessPainting()
	else
		var4_0.Destroy(arg2_36)
	end
end

function var0_0.GetSprite(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	arg0_37:FromObjPack(arg1_37, tostring(arg2_37), typeof(Sprite), arg3_37, function(arg0_38)
		arg4_37(arg0_38)
	end)
end

function var0_0.DecreasSprite(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg1_39

	if arg0_39.pools_pack[var0_39] then
		arg0_39.pools_pack[var0_39]:Remove(arg2_39)

		if arg0_39.pools_pack[var0_39]:GetAmount() <= 0 then
			arg0_39:RemovePoolsPack(var0_39)
		end
	end
end

function var0_0.DestroySprite(arg0_40, arg1_40)
	arg0_40:RemovePoolsPack(arg1_40)
end

function var0_0.DestroyAllSprite(arg0_41)
	local var0_41 = arg0_41:SpriteMemUsage()
	local var1_41 = 24

	print("cached sprite size: " .. math.ceil(var0_41 * 10) / 10 .. "/" .. var1_41 .. "MB")

	for iter0_41, iter1_41 in pairs(arg0_41.pools_pack) do
		arg0_41:RemovePoolsPack(iter0_41)
	end

	var5_0:unloadUnusedAssetBundles()
end

function var0_0.DisplayPoolPacks(arg0_42)
	local var0_42

	for iter0_42, iter1_42 in pairs(arg0_42.pools_pack) do
		table.insert(var0_42, iter0_42)

		for iter2_42, iter3_42 in pairs(iter1_42.items) do
			table.insert(var0_42, string.format("assetName:%s type:%s", iter2_42, tostring(iter1_42.type.FullName)))
		end
	end

	warning(table.concat(var0_42, "\n"))
end

function var0_0.SpriteMemUsage(arg0_43)
	local var0_43 = 0
	local var1_43 = 9.5367431640625e-07
	local var2_43 = typeof(Sprite)

	for iter0_43, iter1_43 in pairs(arg0_43.pools_pack) do
		local var3_43 = {}

		for iter2_43, iter3_43 in pairs(iter1_43.items) do
			if iter1_43.typeDic[iter2_43] == var2_43 then
				local var4_43 = iter1_43.items[iter2_43].texture
				local var5_43 = var4_43.name

				if not var3_43[var5_43] then
					local var6_43 = 4
					local var7_43 = var4_43.format

					if var7_43 == TextureFormat.RGB24 then
						var6_43 = 3
					elseif var7_43 == TextureFormat.ARGB4444 or var7_43 == TextureFormat.RGBA4444 then
						var6_43 = 2
					elseif var7_43 == TextureFormat.DXT5 or var7_43 == TextureFormat.ASTC_4x4 or var7_43 == TextureFormat.ETC2_RGBA8 then
						var6_43 = 1
					elseif var7_43 == TextureFormat.PVRTC_RGB4 or var7_43 == TextureFormat.PVRTC_RGBA4 or var7_43 == TextureFormat.ETC_RGB4 or var7_43 == TextureFormat.ETC2_RGB or var7_43 == TextureFormat.ASTC_6x6 or var7_43 == TextureFormat.DXT1 then
						var6_43 = 0.5
					end

					var0_43 = var0_43 + var4_43.width * var4_43.height * var6_43 * var1_43 / 8
					var3_43[var5_43] = true
				end
			end
		end
	end

	return var0_43
end

local var9_0 = 64
local var10_0 = {
	"chapter/",
	"emoji/",
	"world/"
}

function var0_0.GetPrefab(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44, arg5_44)
	local var0_44 = arg1_44

	arg0_44:FromPlural(arg1_44, "", arg3_44, arg5_44 or var9_0, function(arg0_45)
		if string.find(arg1_44, "emoji/") == 1 then
			local var0_45 = arg0_45:GetComponent(typeof(CriManaEffectUI))

			if var0_45 then
				var0_45:Pause(false)
			end
		end

		arg0_45:SetActive(true)
		tf(arg0_45):SetParent(arg0_44.root, false)
		arg4_44(arg0_45)
	end)
end

function var0_0.ReturnPrefab(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46)
	local var0_46 = arg1_46

	if IsNil(arg3_46) then
		Debugger.LogError(debug.traceback("empty go: " .. arg2_46))
	elseif arg0_46.pools_plural[var0_46] then
		if string.find(arg1_46, "emoji/") == 1 then
			local var1_46 = arg3_46:GetComponent(typeof(CriManaEffectUI))

			if var1_46 then
				var1_46:Pause(true)
			end
		end

		arg3_46:SetActive(false)
		arg3_46.transform:SetParent(arg0_46.root, false)
		arg0_46.pools_plural[var0_46]:Enqueue(arg3_46)

		if arg4_46 and arg0_46.pools_plural[var0_46].balance <= 0 and (not arg0_46.callbacks[var0_46] or #arg0_46.callbacks[var0_46] == 0) then
			arg0_46:DestroyPrefab(arg1_46, arg2_46)
		end
	else
		var4_0.Destroy(arg3_46)
	end
end

function var0_0.DestroyPrefab(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg1_47

	if arg0_47.pools_plural[var0_47] then
		arg0_47.pools_plural[var0_47]:Clear()

		arg0_47.pools_plural[var0_47] = nil
	end
end

function var0_0.DestroyAllPrefab(arg0_48)
	local var0_48 = {}

	for iter0_48, iter1_48 in pairs(arg0_48.pools_plural) do
		if _.any(var10_0, function(arg0_49)
			return string.find(iter0_48, arg0_49) == 1
		end) then
			iter1_48:Clear()
			table.insert(var0_48, iter0_48)
		end
	end

	_.each(var0_48, function(arg0_50)
		arg0_48.pools_plural[arg0_50] = nil
	end)
end

function var0_0.DisplayPluralPools(arg0_51)
	local var0_51 = ""

	for iter0_51, iter1_51 in pairs(arg0_51.pools_plural) do
		if #var0_51 > 0 then
			var0_51 = var0_51 .. "\n"
		end

		local var1_51 = _.map({
			iter0_51,
			"balance",
			iter1_51.balance,
			"currentItmes",
			#iter1_51.items
		}, function(arg0_52)
			return tostring(arg0_52)
		end)

		var0_51 = var0_51 .. " " .. table.concat(var1_51, " ")
	end

	warning(var0_51)
end

function var0_0.GetPluralStatus(arg0_53, arg1_53)
	if not arg0_53.pools_plural[arg1_53] then
		return "NIL"
	end

	local var0_53 = arg0_53.pools_plural[arg1_53]
	local var1_53 = _.map({
		arg1_53,
		"balance",
		var0_53.balance,
		"currentItmes",
		#var0_53.items
	}, tostring)

	return table.concat(var1_53, " ")
end

function var0_0.FromPlural(arg0_54, arg1_54, arg2_54, arg3_54, arg4_54, arg5_54)
	local var0_54 = arg2_54 == "" and arg1_54 or arg1_54 .. "|" .. arg2_54

	local function var1_54()
		local var0_55 = arg0_54.pools_plural[var0_54]

		var0_55.index = arg0_54.pluralIndex
		arg0_54.pluralIndex = arg0_54.pluralIndex + 1

		arg5_54(var0_55:Dequeue())
	end

	if not arg0_54.pools_plural[var0_54] then
		arg0_54:LoadAsset(arg1_54, arg2_54, typeof(Object), arg3_54, function(arg0_56)
			if arg0_56 == nil then
				Debugger.LogError("can not find asset: " .. arg1_54 .. " : " .. arg2_54)

				return
			end

			if not arg0_54.pools_plural[var0_54] then
				arg0_54.pools_plural[var0_54] = var1_0.New(arg0_56, arg4_54)
			end

			var1_54()
		end, true)
	else
		var1_54()
	end
end

function var0_0.FromObjPack(arg0_57, arg1_57, arg2_57, arg3_57, arg4_57, arg5_57)
	local var0_57 = arg1_57
	local var1_57 = {}

	if not arg0_57.pools_pack[var0_57] then
		table.insert(var1_57, function(arg0_58)
			AssetBundleHelper.LoadAssetBundle(arg1_57, arg4_57, true, function(arg0_59)
				arg0_57:AddPoolsPack(arg1_57, arg0_59)
				arg0_58()
			end)
		end)
	end

	seriesAsync(var1_57, function()
		arg5_57(arg0_57.pools_pack[var0_57]:Get(arg2_57, arg3_57))
	end)
end

function var0_0.LoadAsset(arg0_61, arg1_61, arg2_61, arg3_61, arg4_61, arg5_61, arg6_61)
	arg1_61, arg2_61 = HXSet.autoHxShiftPath(arg1_61, arg2_61)

	local var0_61 = arg1_61 .. "|" .. arg2_61

	if arg0_61.callbacks[var0_61] then
		if not arg4_61 then
			errorMsg("Sync Loading after async operation")
		end

		table.insert(arg0_61.callbacks[var0_61], arg5_61)
	elseif arg4_61 then
		arg0_61.callbacks[var0_61] = {
			arg5_61
		}

		var5_0:getAssetAsync(arg1_61, arg2_61, arg3_61, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_62)
			if arg0_61.callbacks[var0_61] then
				local var0_62 = arg0_61.callbacks[var0_61]

				arg0_61.callbacks[var0_61] = nil

				while next(var0_62) do
					table.remove(var0_62)(arg0_62)
				end
			end
		end), arg6_61, false)
	else
		arg5_61(var5_0:getAssetSync(arg1_61, arg2_61, arg3_61, arg6_61, false))
	end
end

function var0_0.AddPoolsPack(arg0_63, arg1_63, arg2_63)
	if arg0_63.pools_pack[arg1_63] then
		arg2_63:Dispose()
	else
		arg0_63.pools_pack[arg1_63] = var3_0.New(arg1_63, arg2_63)
	end
end

function var0_0.RemovePoolsPack(arg0_64, arg1_64)
	if not arg0_64.pools_pack[arg1_64] or arg0_64.preloadDic[arg1_64] then
		return
	end

	arg0_64.pools_pack[arg1_64]:Clear()

	arg0_64.pools_pack[arg1_64] = nil
end

function var0_0.PrintPools(arg0_65)
	local var0_65 = ""

	for iter0_65, iter1_65 in pairs(arg0_65.pools_plural) do
		var0_65 = var0_65 .. "\n" .. iter0_65
	end

	warning(var0_65)
end

function var0_0.PrintObjPack(arg0_66)
	local var0_66 = {}

	for iter0_66, iter1_66 in pairs(arg0_66.pools_pack) do
		table.insert(var0_66, iter0_66)

		for iter2_66, iter3_66 in pairs(iter1_66.items) do
			table.insert(var0_66, "    :" .. iter2_66)
		end
	end

	warning(table.concat(var0_66, "\n"))
end

return var0_0
