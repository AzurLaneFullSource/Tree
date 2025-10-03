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
	arg0_1.preloadDic = {
		["ui/share/msgbox_atlas"] = 1,
		["shipyardicon/unknown"] = 1,
		["ui/commonui_atlas"] = 1,
		shipframeb = 1,
		skillframe = 1,
		energy = 1,
		["painting/mat"] = 1,
		shipstatus = 1,
		["ui/story_atlas"] = 1,
		["ui/guide_atlas"] = 1,
		["ui/share/world_common_atlas"] = 1,
		weaponframes = 1,
		attricon = 1,
		skinicon = 1,
		channel = 1,
		custom_builtin = 1,
		shiptype = 1,
		shipframe = 1
	}
	arg0_1.keepDic = {}
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

	arg0_2:RegisterUIConst()
	seriesAsync(var0_2, arg1_2)
end

function var0_0.GetSpineChar(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = {}
	local var1_5 = "char/" .. arg1_5
	local var2_5, var3_5 = HXSet.autoHxShiftPath("char/" .. arg1_5, arg1_5)
	local var4_5 = var3_5 .. "_SkeletonData"

	arg0_5:FromPlural(var2_5, "", arg2_5, 1, function(arg0_6)
		setActiveViaLayer(arg0_6, true)
		arg3_5(arg0_6)
	end, function(arg0_7)
		assert(arg0_7 ~= nil, "Spine角色不存在: " .. arg1_5)

		arg0_7 = SpineAnimUI.AnimChar(arg1_5, arg0_7)

		tf(arg0_7):SetParent(arg0_5.root, false)

		local var0_7 = arg0_7:GetComponent("SkeletonGraphic")

		var0_7.material = var0_7.skeletonDataAsset.atlasAssets[0].materials[0]

		arg0_7:SetActive(false)

		return arg0_7
	end)
end

function var0_0.ReturnSpineChar(arg0_8, arg1_8, arg2_8)
	local var0_8 = "char/" .. arg1_8

	if IsNil(arg2_8) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_8))
	elseif arg0_8.pools_plural[var0_8] then
		if arg2_8:GetComponent("SkeletonGraphic").allowMultipleCanvasRenderers then
			UIUtil.ClearChildren(arg2_8, {
				"Renderer"
			})
		else
			UIUtil.ClearChildren(arg2_8)
		end

		setActiveViaLayer(arg2_8.transform, true)
		arg2_8:SetActive(false)
		arg2_8.transform:SetParent(arg0_8.root, false)

		arg2_8.transform.localPosition = Vector3.New(0, 0, 0)
		arg2_8.transform.localScale = Vector3.New(0.5, 0.5, 1)
		arg2_8.transform.localRotation = Quaternion.identity

		arg0_8.pools_plural[var0_8]:Enqueue(arg2_8)
		arg0_8:ExcessSpineChar()
	else
		var4_0.Destroy(arg2_8)
	end
end

function var0_0.ExcessSpineChar(arg0_9, arg1_9)
	local var0_9 = 0
	local var1_9 = 6
	local var2_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.pools_plural) do
		if string.find(iter0_9, "char/", nil, true) == 1 and iter1_9:AllReturned() then
			table.insert(var2_9, iter0_9)
		end
	end

	if arg1_9 then
		for iter2_9, iter3_9 in ipairs(var2_9) do
			arg0_9.pools_plural[iter3_9]:Clear()

			arg0_9.pools_plural[iter3_9] = nil
		end
	elseif var1_9 < #var2_9 then
		gcAll()
	end
end

function var0_0.GetSpineSkel(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10, var1_10 = HXSet.autoHxShiftPath("char/" .. arg1_10, arg1_10)
	local var2_10 = var1_10 .. "_SkeletonData"

	arg0_10:LoadAsset(var0_10, "", typeof(Object), arg2_10, function(arg0_11)
		arg3_10(arg0_11)
	end, true)
end

function var0_0.IsSpineSkelCached(arg0_12, arg1_12)
	local var0_12 = "char/" .. arg1_12

	return arg0_12.pools_plural[var0_12] ~= nil
end

local var6_0 = {
	ResPanel = 3,
	WorldResPanel = 3
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

function var0_0.RegisterUIConst(arg0_13)
	for iter0_13, iter1_13 in ipairs(var7_0) do
		arg0_13:KeepUICache(iter1_13, true)
	end
end

function var0_0.GetUI(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = "ui/" .. arg1_14
	local var1_14 = var6_0[arg1_14] or 1

	arg0_14:FromPlural(var0_14, "", arg2_14, var1_14, arg3_14)
end

function var0_0.ReturnUI(arg0_15, arg1_15, arg2_15)
	local var0_15 = "ui/" .. arg1_15

	if IsNil(arg2_15) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_15))
	elseif arg0_15.pools_plural[var0_15] then
		setActiveViaLayer(arg2_15, false)
		arg2_15.transform:SetParent(arg0_15.root, false)
		arg0_15.pools_plural[var0_15]:Enqueue(arg2_15, true)

		if arg0_15.pools_plural[var0_15]:AllReturned() and (not arg0_15.callbacks[var0_15] or #arg0_15.callbacks[var0_15] == 0) then
			arg0_15.pools_plural[var0_15]:Clear()

			arg0_15.pools_plural[var0_15] = nil
		end
	else
		var4_0.Destroy(arg2_15)
	end
end

function var0_0.PreloadUI(arg0_16, arg1_16, arg2_16)
	local var0_16 = {}
	local var1_16 = "ui/" .. arg1_16

	if not arg0_16.pools_plural[var1_16] then
		table.insert(var0_16, function(arg0_17)
			arg0_16:GetUI(arg1_16, true, function(arg0_18)
				setActive(arg0_18, false)
				arg0_16.pools_plural[var1_16]:Enqueue(arg0_18)
				arg0_17()
			end)
		end)
	end

	seriesAsync(var0_16, arg2_16)
end

function var0_0.KeepUICache(arg0_19, arg1_19, arg2_19)
	local var0_19 = "ui/" .. arg1_19

	arg0_19.keepDic[var0_19] = arg2_19 or nil

	if arg0_19.pools_plural[var0_19] then
		arg0_19.pools_plural[var0_19]:SetKeep(tobool(arg0_19.keepDic[var0_19]))

		if arg0_19.pools_plural[var0_19]:AllReturned() and (not arg0_19.callbacks[var0_19] or #arg0_19.callbacks[var0_19] == 0) then
			arg0_19.pools_plural[var0_19]:Clear()

			arg0_19.pools_plural[var0_19] = nil
		end
	end
end

function var0_0.PreloadPainting(arg0_20, arg1_20, arg2_20)
	local var0_20 = {}
	local var1_20 = "painting/" .. arg1_20

	if not arg0_20.pools_plural[var1_20] then
		table.insert(var0_20, function(arg0_21)
			arg0_20:GetPainting(arg1_20, true, function(arg0_22)
				arg0_20.pools_plural[var1_20]:Enqueue(arg0_22)
				arg0_21()
			end)
		end)
	end

	seriesAsync(var0_20, arg2_20)
end

function var0_0.GetPainting(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = "painting/" .. arg1_23
	local var1_23 = var0_23

	arg0_23:FromPlural(var0_23, "", arg2_23, 1, function(arg0_24)
		arg0_24:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_23) then
			setActive(tf(arg0_24):Find("face"), true)
		end

		arg3_23(arg0_24)
	end)
end

function var0_0.ReturnPainting(arg0_25, arg1_25, arg2_25)
	local var0_25 = "painting/" .. arg1_25

	if IsNil(arg2_25) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_25))
	elseif arg0_25.pools_plural[var0_25] then
		setActiveViaLayer(arg2_25, true)

		local var1_25 = tf(arg2_25):Find("face")

		if var1_25 then
			setActive(var1_25, false)
		end

		arg2_25:SetActive(false)
		arg2_25.transform:SetParent(arg0_25.root, false)
		arg0_25.pools_plural[var0_25]:Enqueue(arg2_25)
		arg0_25:ExcessPainting()
	else
		var4_0.Destroy(arg2_25)
	end
end

function var0_0.ExcessPainting(arg0_26, arg1_26)
	local var0_26 = 0
	local var1_26 = 6
	local var2_26 = {}

	for iter0_26, iter1_26 in pairs(arg0_26.pools_plural) do
		if string.find(iter0_26, "painting/", nil, true) == 1 and iter1_26:AllReturned() then
			table.insert(var2_26, iter0_26)
		end
	end

	if arg1_26 then
		for iter2_26, iter3_26 in ipairs(var2_26) do
			arg0_26.pools_plural[iter3_26]:Clear()

			arg0_26.pools_plural[iter3_26] = nil
		end
	elseif var1_26 < #var2_26 then
		gcAll(false)
	end
end

function var0_0.GetPaintingWithPrefix(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27)
	local var0_27 = arg4_27 .. arg1_27
	local var1_27 = var0_27

	arg0_27:FromPlural(var0_27, "", arg2_27, 1, function(arg0_28)
		arg0_28:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_27) then
			setActive(tf(arg0_28):Find("face"), true)
		end

		arg3_27(arg0_28)
	end)
end

function var0_0.ReturnPaintingWithPrefix(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = arg3_29 .. arg1_29

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

function var0_0.GetSpinePainting(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30
	local var1_30, var2_30 = HXSet.autoHxShift("spinePainting/", arg1_30)

	arg1_30 = var2_30

	local var3_30 = var1_30 .. arg1_30

	arg0_30:FromPlural(var3_30, "", arg2_30, 1, function(arg0_31)
		arg0_31:SetActive(true)
		arg3_30(arg0_31)
	end)
end

function var0_0.ReturnSpinePainting(arg0_32, arg1_32, arg2_32)
	local var0_32
	local var1_32, var2_32 = HXSet.autoHxShift("spinePainting/", arg1_32)

	arg1_32 = var2_32

	local var3_32 = var1_32 .. arg1_32

	if IsNil(arg2_32) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_32))
	elseif arg0_32.pools_plural[var3_32] then
		setActiveViaLayer(arg2_32, true)
		arg2_32:SetActive(false)
		arg2_32.transform:SetParent(arg0_32.root, false)
		arg0_32.pools_plural[var3_32]:Enqueue(arg2_32)
		arg0_32:ExcessDymPainting()
	else
		var4_0.Destroy(arg2_32)
	end
end

function var0_0.GetLive2D(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33
	local var1_33, var2_33 = HXSet.autoHxShift("live2d/", arg1_33)

	arg1_33 = var2_33

	local var3_33 = var1_33 .. arg1_33

	arg0_33:FromPlural(var3_33, "", arg2_33, 1, function(arg0_34)
		arg0_34:SetActive(true)
		arg3_33(arg0_34)
	end)
end

function var0_0.ReturnLive2D(arg0_35, arg1_35, arg2_35)
	local var0_35
	local var1_35, var2_35 = HXSet.autoHxShift("live2d/", arg1_35)

	arg1_35 = var2_35

	local var3_35 = var1_35 .. arg1_35

	if IsNil(arg2_35) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_35))
	elseif arg0_35.pools_plural[var3_35] then
		setActiveViaLayer(arg2_35, true)
		arg2_35:SetActive(false)
		arg2_35.transform:SetParent(arg0_35.root, false)
		arg0_35.pools_plural[var3_35]:Enqueue(arg2_35)
		arg0_35.pools_plural[var3_35]:ClearItems()
		arg0_35:ExcessDymPainting()
	else
		var4_0.Destroy(arg2_35)
	end
end

local var8_0 = {
	["live2d/"] = true,
	["spinePainting/"] = true
}
local var9_0 = ApartmentProxy.CheckDeviceRAMEnough() and 6 or 2
local var10_0 = 0

function var0_0.ExcessDymPainting(arg0_36, arg1_36)
	local var0_36 = 0
	local var1_36 = var9_0
	local var2_36 = {}

	for iter0_36, iter1_36 in pairs(arg0_36.pools_plural) do
		local var3_36 = string.find(iter0_36, "/", nil, true)

		if var3_36 and var8_0[string.sub(iter0_36, 1, var3_36)] and iter1_36:AllReturned() then
			table.insert(var2_36, iter0_36)
		end
	end

	var10_0 = var10_0 + 1

	if arg1_36 then
		for iter2_36, iter3_36 in ipairs(var2_36) do
			arg0_36.pools_plural[iter3_36]:Clear()

			arg0_36.pools_plural[iter3_36] = nil
		end
	elseif var1_36 < #var2_36 then
		gcAll(false)
	elseif var10_0 >= 10 then
		gcAll(false)
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

local var11_0 = 64
local var12_0 = {
	"chapter/",
	"emoji/",
	"world/"
}

function var0_0.GetPrefab(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44, arg5_44)
	local var0_44 = arg1_44

	arg0_44:FromPlural(arg1_44, "", arg3_44, arg5_44 or var11_0, function(arg0_45)
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

		if arg4_46 and arg0_46.pools_plural[var0_46]:AllReturned() and (not arg0_46.callbacks[var0_46] or #arg0_46.callbacks[var0_46] == 0) then
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
		if _.any(var12_0, function(arg0_49)
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

function var0_0.FromPlural(arg0_54, arg1_54, arg2_54, arg3_54, arg4_54, arg5_54, arg6_54)
	local var0_54 = arg2_54 == "" and arg1_54 or arg1_54 .. "|" .. arg2_54
	local var1_54 = {}

	if not arg0_54.pools_plural[var0_54] then
		table.insert(var1_54, function(arg0_55)
			arg0_54:LoadAsset(arg1_54, arg2_54, typeof(Object), arg3_54, function(arg0_56)
				if arg0_56 == nil then
					Debugger.LogError("can not find asset: " .. arg1_54 .. " : " .. arg2_54)

					return
				end

				if arg6_54 then
					arg0_56 = arg6_54(arg0_56)
				end

				if not arg0_54.pools_plural[var0_54] then
					arg0_54.pools_plural[var0_54] = var1_0.New(arg0_56, arg4_54)

					arg0_54.pools_plural[var0_54]:SetKeep(tobool(arg0_54.keepDic[var0_54]))
				end

				arg0_55()
			end, true, true)
		end)
	end

	seriesAsync(var1_54, function()
		local var0_57 = arg0_54.pools_plural[var0_54]

		var0_57.index = arg0_54.pluralIndex
		arg0_54.pluralIndex = arg0_54.pluralIndex + 1

		arg5_54(var0_57:Dequeue())
	end)
end

function var0_0.FromObjPack(arg0_58, arg1_58, arg2_58, arg3_58, arg4_58, arg5_58)
	local var0_58 = arg1_58
	local var1_58 = {}

	if not arg0_58.pools_pack[var0_58] then
		table.insert(var1_58, function(arg0_59)
			AssetBundleHelper.LoadAssetBundle(arg1_58, arg4_58, true, function(arg0_60)
				arg0_58:AddPoolsPack(arg1_58, arg0_60)
				arg0_59()
			end)
		end)
	end

	seriesAsync(var1_58, function()
		arg5_58(arg0_58.pools_pack[var0_58]:Get(arg2_58, arg3_58))
	end)
end

function var0_0.LoadAsset(arg0_62, arg1_62, arg2_62, arg3_62, arg4_62, arg5_62, arg6_62, arg7_62)
	arg1_62, arg2_62 = HXSet.autoHxShiftPath(arg1_62, arg2_62)

	local var0_62 = arg1_62 .. "|" .. arg2_62

	if arg0_62.callbacks[var0_62] then
		if not arg4_62 then
			errorMsg("Sync Loading after async operation")
		end

		table.insert(arg0_62.callbacks[var0_62], arg5_62)
	elseif arg4_62 then
		arg0_62.callbacks[var0_62] = {
			arg5_62
		}

		var5_0:getAssetAsync(arg1_62, arg2_62, arg3_62, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_63)
			if arg0_62.callbacks[var0_62] then
				local var0_63 = arg0_62.callbacks[var0_62]

				arg0_62.callbacks[var0_62] = nil

				while next(var0_63) do
					table.remove(var0_63)(arg0_63)
				end
			end
		end), arg6_62, arg7_62 or false)
	else
		arg5_62(var5_0:getAssetSync(arg1_62, arg2_62, arg3_62, arg6_62, arg7_62 or false))
	end
end

function var0_0.AddPoolsPack(arg0_64, arg1_64, arg2_64)
	if arg0_64.pools_pack[arg1_64] then
		arg2_64:Dispose()
	else
		arg0_64.pools_pack[arg1_64] = var3_0.New(arg1_64, arg2_64)
	end
end

function var0_0.RemovePoolsPack(arg0_65, arg1_65)
	if not arg0_65.pools_pack[arg1_65] or arg0_65.preloadDic[arg1_65] then
		return
	end

	arg0_65.pools_pack[arg1_65]:Clear()

	arg0_65.pools_pack[arg1_65] = nil
end

function var0_0.PrintPools(arg0_66)
	local var0_66 = ""

	for iter0_66, iter1_66 in pairs(arg0_66.pools_plural) do
		var0_66 = var0_66 .. "\n" .. iter0_66
	end

	warning(var0_66)
end

function var0_0.PrintObjPack(arg0_67)
	local var0_67 = {}

	for iter0_67, iter1_67 in pairs(arg0_67.pools_pack) do
		table.insert(var0_67, iter0_67)

		for iter2_67, iter3_67 in pairs(iter1_67.items) do
			table.insert(var0_67, "    :" .. iter2_67)
		end
	end

	warning(table.concat(var0_67, "\n"))
end

return var0_0
