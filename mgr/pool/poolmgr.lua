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

function var0_0.GetUI(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = "ui/" .. arg1_15
	local var1_15 = table.contains(var6_0, arg1_15) and 3 or 1

	arg0_15:FromPlural(var0_15, "", arg2_15, var1_15, arg3_15)
end

function var0_0.ReturnUI(arg0_16, arg1_16, arg2_16)
	local var0_16 = "ui/" .. arg1_16

	if IsNil(arg2_16) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_16))
	elseif arg0_16.pools_plural[var0_16] then
		if table.indexof(var6_0, arg1_16) then
			arg2_16.transform:SetParent(arg0_16.root, false)
		end

		if table.indexof(var7_0, arg1_16) or arg0_16.ui_tempCache[arg1_16] then
			setActiveViaLayer(arg2_16.transform, false)
			arg0_16.pools_plural[var0_16]:Enqueue(arg2_16)
		else
			arg0_16.pools_plural[var0_16]:Enqueue(arg2_16, true)

			if arg0_16.pools_plural[var0_16]:AllReturned() and (not arg0_16.callbacks[var0_16] or #arg0_16.callbacks[var0_16] == 0) then
				arg0_16.pools_plural[var0_16]:Clear()

				arg0_16.pools_plural[var0_16] = nil
			end
		end
	else
		var4_0.Destroy(arg2_16)
	end
end

function var0_0.HasCacheUI(arg0_17, arg1_17)
	local var0_17 = "ui/" .. arg1_17

	return arg0_17.pools_plural[var0_17] ~= nil
end

function var0_0.PreloadUI(arg0_18, arg1_18, arg2_18)
	local var0_18 = {}
	local var1_18 = "ui/" .. arg1_18

	if not arg0_18.pools_plural[var1_18] then
		table.insert(var0_18, function(arg0_19)
			arg0_18:GetUI(arg1_18, true, function(arg0_20)
				setActive(arg0_20, false)
				arg0_18.pools_plural[var1_18]:Enqueue(arg0_20)
				arg0_19()
			end)
		end)
	end

	seriesAsync(var0_18, arg2_18)
end

function var0_0.AddTempCache(arg0_21, arg1_21)
	arg0_21.ui_tempCache[arg1_21] = true
end

function var0_0.DelTempCache(arg0_22, arg1_22)
	arg0_22.ui_tempCache[arg1_22] = nil
end

function var0_0.ClearAllTempCache(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23.ui_tempCache) do
		if iter1_23 then
			local var0_23 = "ui/" .. iter0_23

			if arg0_23.pools_plural[var0_23] then
				arg0_23.pools_plural[var0_23]:Clear()

				arg0_23.pools_plural[var0_23] = nil
			end
		end
	end
end

function var0_0.PreloadPainting(arg0_24, arg1_24, arg2_24)
	local var0_24 = {}
	local var1_24 = "painting/" .. arg1_24

	if not arg0_24.pools_plural[var1_24] then
		table.insert(var0_24, function(arg0_25)
			arg0_24:GetPainting(arg1_24, true, function(arg0_26)
				arg0_24.pools_plural[var1_24]:Enqueue(arg0_26)
				arg0_25()
			end)
		end)
	end

	seriesAsync(var0_24, arg2_24)
end

function var0_0.GetPainting(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = "painting/" .. arg1_27
	local var1_27 = var0_27

	arg0_27:FromPlural(var0_27, "", arg2_27, 1, function(arg0_28)
		arg0_28:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_27) then
			setActive(tf(arg0_28):Find("face"), true)
		end

		arg3_27(arg0_28)
	end)
end

function var0_0.ReturnPainting(arg0_29, arg1_29, arg2_29)
	local var0_29 = "painting/" .. arg1_29

	if IsNil(arg2_29) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_29))
	elseif arg0_29.pools_plural[var0_29] then
		setActiveViaLayer(arg2_29, true)

		local var1_29 = tf(arg2_29):Find("face")

		if var1_29 then
			setActive(var1_29, false)
		end

		arg2_29:SetActive(false)
		arg2_29.transform:SetParent(arg0_29.root, false)
		arg0_29.pools_plural[var0_29]:Enqueue(arg2_29)
		arg0_29:ExcessPainting()
	else
		var4_0.Destroy(arg2_29)
	end
end

function var0_0.ExcessPainting(arg0_30, arg1_30)
	local var0_30 = 0
	local var1_30 = 4
	local var2_30 = {}

	for iter0_30, iter1_30 in pairs(arg0_30.pools_plural) do
		local var3_30 = string.find(iter0_30, "painting/")

		if var3_30 and var3_30 >= 1 then
			table.insert(var2_30, iter0_30)
		end
	end

	if var1_30 < #var2_30 then
		table.sort(var2_30, function(arg0_31, arg1_31)
			return arg0_30.pools_plural[arg0_31].index > arg0_30.pools_plural[arg1_31].index
		end)

		for iter2_30 = var1_30 + 1, #var2_30 do
			local var4_30 = var2_30[iter2_30]

			arg0_30.pools_plural[var4_30]:Clear(true)

			arg0_30.pools_plural[var4_30] = nil
		end

		arg0_30.paintingCount = arg0_30.paintingCount + 1
	end

	if arg1_30 then
		arg0_30.paintingCount = 0
	elseif arg0_30.paintingCount >= 10 then
		arg0_30.paintingCount = 0

		gcAll(false)
	end
end

function var0_0.GetPaintingWithPrefix(arg0_32, arg1_32, arg2_32, arg3_32, arg4_32)
	local var0_32 = arg4_32 .. arg1_32
	local var1_32 = var0_32

	arg0_32:FromPlural(var0_32, "", arg2_32, 1, function(arg0_33)
		arg0_33:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_32) then
			setActive(tf(arg0_33):Find("face"), true)
		end

		arg3_32(arg0_33)
	end)
end

function var0_0.ReturnPaintingWithPrefix(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = arg3_34 .. arg1_34

	if IsNil(arg2_34) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_34))
	elseif arg0_34.pools_plural[var0_34] then
		setActiveViaLayer(arg2_34, true)

		local var1_34 = tf(arg2_34):Find("face")

		if var1_34 then
			setActive(var1_34, false)
		end

		arg2_34:SetActive(false)
		arg2_34.transform:SetParent(arg0_34.root, false)
		arg0_34.pools_plural[var0_34]:Enqueue(arg2_34)
		arg0_34:ExcessPainting()
	else
		var4_0.Destroy(arg2_34)
	end
end

function var0_0.GetSprite(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	arg0_35:FromObjPack(arg1_35, tostring(arg2_35), typeof(Sprite), arg3_35, function(arg0_36)
		arg4_35(arg0_36)
	end)
end

function var0_0.DecreasSprite(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg1_37

	if arg0_37.pools_pack[var0_37] then
		arg0_37.pools_pack[var0_37]:Remove(arg2_37)

		if arg0_37.pools_pack[var0_37]:GetAmount() <= 0 then
			arg0_37:RemovePoolsPack(var0_37)
		end
	end
end

function var0_0.DestroySprite(arg0_38, arg1_38)
	arg0_38:RemovePoolsPack(arg1_38)
end

function var0_0.DestroyAllSprite(arg0_39)
	local var0_39 = arg0_39:SpriteMemUsage()
	local var1_39 = 24

	print("cached sprite size: " .. math.ceil(var0_39 * 10) / 10 .. "/" .. var1_39 .. "MB")

	for iter0_39, iter1_39 in pairs(arg0_39.pools_pack) do
		arg0_39:RemovePoolsPack(iter0_39)
	end

	var5_0:unloadUnusedAssetBundles()
end

function var0_0.DisplayPoolPacks(arg0_40)
	local var0_40

	for iter0_40, iter1_40 in pairs(arg0_40.pools_pack) do
		table.insert(var0_40, iter0_40)

		for iter2_40, iter3_40 in pairs(iter1_40.items) do
			table.insert(var0_40, string.format("assetName:%s type:%s", iter2_40, tostring(iter1_40.type.FullName)))
		end
	end

	warning(table.concat(var0_40, "\n"))
end

function var0_0.SpriteMemUsage(arg0_41)
	local var0_41 = 0
	local var1_41 = 9.5367431640625e-07
	local var2_41 = typeof(Sprite)

	for iter0_41, iter1_41 in pairs(arg0_41.pools_pack) do
		local var3_41 = {}

		for iter2_41, iter3_41 in pairs(iter1_41.items) do
			if iter1_41.typeDic[iter2_41] == var2_41 then
				local var4_41 = iter1_41.items[iter2_41].texture
				local var5_41 = var4_41.name

				if not var3_41[var5_41] then
					local var6_41 = 4
					local var7_41 = var4_41.format

					if var7_41 == TextureFormat.RGB24 then
						var6_41 = 3
					elseif var7_41 == TextureFormat.ARGB4444 or var7_41 == TextureFormat.RGBA4444 then
						var6_41 = 2
					elseif var7_41 == TextureFormat.DXT5 or var7_41 == TextureFormat.ASTC_4x4 or var7_41 == TextureFormat.ETC2_RGBA8 then
						var6_41 = 1
					elseif var7_41 == TextureFormat.PVRTC_RGB4 or var7_41 == TextureFormat.PVRTC_RGBA4 or var7_41 == TextureFormat.ETC_RGB4 or var7_41 == TextureFormat.ETC2_RGB or var7_41 == TextureFormat.ASTC_6x6 or var7_41 == TextureFormat.DXT1 then
						var6_41 = 0.5
					end

					var0_41 = var0_41 + var4_41.width * var4_41.height * var6_41 * var1_41 / 8
					var3_41[var5_41] = true
				end
			end
		end
	end

	return var0_41
end

local var8_0 = 64
local var9_0 = {
	"chapter/",
	"emoji/",
	"world/"
}

function var0_0.GetPrefab(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42, arg5_42)
	local var0_42 = arg1_42

	arg0_42:FromPlural(arg1_42, "", arg3_42, arg5_42 or var8_0, function(arg0_43)
		if string.find(arg1_42, "emoji/") == 1 then
			local var0_43 = arg0_43:GetComponent(typeof(CriManaEffectUI))

			if var0_43 then
				var0_43:Pause(false)
			end
		end

		arg0_43:SetActive(true)
		tf(arg0_43):SetParent(arg0_42.root, false)
		arg4_42(arg0_43)
	end)
end

function var0_0.ReturnPrefab(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44)
	local var0_44 = arg1_44

	if IsNil(arg3_44) then
		Debugger.LogError(debug.traceback("empty go: " .. arg2_44))
	elseif arg0_44.pools_plural[var0_44] then
		if string.find(arg1_44, "emoji/") == 1 then
			local var1_44 = arg3_44:GetComponent(typeof(CriManaEffectUI))

			if var1_44 then
				var1_44:Pause(true)
			end
		end

		arg3_44:SetActive(false)
		arg3_44.transform:SetParent(arg0_44.root, false)
		arg0_44.pools_plural[var0_44]:Enqueue(arg3_44)

		if arg4_44 and arg0_44.pools_plural[var0_44].balance <= 0 and (not arg0_44.callbacks[var0_44] or #arg0_44.callbacks[var0_44] == 0) then
			arg0_44:DestroyPrefab(arg1_44, arg2_44)
		end
	else
		var4_0.Destroy(arg3_44)
	end
end

function var0_0.DestroyPrefab(arg0_45, arg1_45, arg2_45)
	local var0_45 = arg1_45

	if arg0_45.pools_plural[var0_45] then
		arg0_45.pools_plural[var0_45]:Clear()

		arg0_45.pools_plural[var0_45] = nil
	end
end

function var0_0.DestroyAllPrefab(arg0_46)
	local var0_46 = {}

	for iter0_46, iter1_46 in pairs(arg0_46.pools_plural) do
		if _.any(var9_0, function(arg0_47)
			return string.find(iter0_46, arg0_47) == 1
		end) then
			iter1_46:Clear()
			table.insert(var0_46, iter0_46)
		end
	end

	_.each(var0_46, function(arg0_48)
		arg0_46.pools_plural[arg0_48] = nil
	end)
end

function var0_0.DisplayPluralPools(arg0_49)
	local var0_49 = ""

	for iter0_49, iter1_49 in pairs(arg0_49.pools_plural) do
		if #var0_49 > 0 then
			var0_49 = var0_49 .. "\n"
		end

		local var1_49 = _.map({
			iter0_49,
			"balance",
			iter1_49.balance,
			"currentItmes",
			#iter1_49.items
		}, function(arg0_50)
			return tostring(arg0_50)
		end)

		var0_49 = var0_49 .. " " .. table.concat(var1_49, " ")
	end

	warning(var0_49)
end

function var0_0.GetPluralStatus(arg0_51, arg1_51)
	if not arg0_51.pools_plural[arg1_51] then
		return "NIL"
	end

	local var0_51 = arg0_51.pools_plural[arg1_51]
	local var1_51 = _.map({
		arg1_51,
		"balance",
		var0_51.balance,
		"currentItmes",
		#var0_51.items
	}, tostring)

	return table.concat(var1_51, " ")
end

function var0_0.FromPlural(arg0_52, arg1_52, arg2_52, arg3_52, arg4_52, arg5_52)
	local var0_52 = arg2_52 == "" and arg1_52 or arg1_52 .. "|" .. arg2_52
	local var1_52 = {}

	if not arg0_52.pools_plural[var0_52] then
		table.insert(var1_52, function(arg0_53)
			arg0_52:LoadAsset(arg1_52, arg2_52, typeof(Object), arg3_52, function(arg0_54)
				if arg0_54 == nil then
					Debugger.LogError("can not find asset: " .. arg1_52 .. " : " .. arg2_52)

					return
				end

				if not arg0_52.pools_plural[var0_52] then
					arg0_52.pools_plural[var0_52] = var1_0.New(arg0_54, arg4_52)
				end

				arg0_53()
			end, true)
		end)
	end

	seriesAsync(var1_52, function()
		local var0_55 = arg0_52.pools_plural[var0_52]

		var0_55.index = arg0_52.pluralIndex
		arg0_52.pluralIndex = arg0_52.pluralIndex + 1

		arg5_52(var0_55:Dequeue())
	end)
end

function var0_0.FromObjPack(arg0_56, arg1_56, arg2_56, arg3_56, arg4_56, arg5_56)
	local var0_56 = arg1_56
	local var1_56 = {}

	if not arg0_56.pools_pack[var0_56] then
		table.insert(var1_56, function(arg0_57)
			AssetBundleHelper.LoadAssetBundle(arg1_56, arg4_56, true, function(arg0_58)
				arg0_56:AddPoolsPack(arg1_56, arg0_58)
				arg0_57()
			end)
		end)
	end

	seriesAsync(var1_56, function()
		arg5_56(arg0_56.pools_pack[var0_56]:Get(arg2_56, arg3_56))
	end)
end

function var0_0.LoadAsset(arg0_60, arg1_60, arg2_60, arg3_60, arg4_60, arg5_60, arg6_60)
	arg1_60, arg2_60 = HXSet.autoHxShiftPath(arg1_60, arg2_60)

	local var0_60 = arg1_60 .. "|" .. arg2_60

	if arg0_60.callbacks[var0_60] then
		if not arg4_60 then
			errorMsg("Sync Loading after async operation")
		end

		table.insert(arg0_60.callbacks[var0_60], arg5_60)
	elseif arg4_60 then
		arg0_60.callbacks[var0_60] = {
			arg5_60
		}

		var5_0:getAssetAsync(arg1_60, arg2_60, arg3_60, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_61)
			if arg0_60.callbacks[var0_60] then
				local var0_61 = arg0_60.callbacks[var0_60]

				arg0_60.callbacks[var0_60] = nil

				while next(var0_61) do
					table.remove(var0_61)(arg0_61)
				end
			end
		end), arg6_60, false)
	else
		arg5_60(var5_0:getAssetSync(arg1_60, arg2_60, arg3_60, arg6_60, false))
	end
end

function var0_0.AddPoolsPack(arg0_62, arg1_62, arg2_62)
	if arg0_62.pools_pack[arg1_62] then
		arg2_62:Dispose()
	else
		arg0_62.pools_pack[arg1_62] = var3_0.New(arg1_62, arg2_62)
	end
end

function var0_0.RemovePoolsPack(arg0_63, arg1_63)
	if not arg0_63.pools_pack[arg1_63] or arg0_63.preloadDic[arg1_63] then
		return
	end

	arg0_63.pools_pack[arg1_63]:Clear()

	arg0_63.pools_pack[arg1_63] = nil
end

function var0_0.PrintPools(arg0_64)
	local var0_64 = ""

	for iter0_64, iter1_64 in pairs(arg0_64.pools_plural) do
		var0_64 = var0_64 .. "\n" .. iter0_64
	end

	warning(var0_64)
end

function var0_0.PrintObjPack(arg0_65)
	local var0_65 = {}

	for iter0_65, iter1_65 in pairs(arg0_65.pools_pack) do
		table.insert(var0_65, iter0_65)

		for iter2_65, iter3_65 in pairs(iter1_65.items) do
			table.insert(var0_65, "    :" .. iter2_65)
		end
	end

	warning(table.concat(var0_65, "\n"))
end

return var0_0
