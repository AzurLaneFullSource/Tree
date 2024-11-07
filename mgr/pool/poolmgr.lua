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
	arg0_1.preloadSprites = {
		shiptype = {
			"battle_hangmu",
			"battle_qingxun",
			"battle_quzhu",
			"battle_weixiu",
			"battle_zhanlie",
			"battle_zhongxun",
			"hangmu",
			"hangxun",
			"hangzhan",
			"leixun",
			"qingxun",
			"quzhu",
			"weixiu",
			"xunyang",
			"zhanlie",
			"zhongxun"
		},
		shipframe = {
			"1",
			"2",
			"3",
			"4",
			"4_0",
			"4_1",
			"5",
			"5_0",
			"5_1",
			"prop",
			"prop4_0",
			"prop4_1",
			"prop5_0"
		},
		shipframeb = {
			"b1",
			"b2",
			"b3",
			"b3_1",
			"b4",
			"b4_0",
			"b4_1",
			"b5",
			"b5_0",
			"b5_1",
			"ba",
			"bl",
			"bprop",
			"bprop4_0",
			"bprop4_1",
			"bprop5_0"
		},
		["shipyardicon/unknown"] = {
			""
		},
		skillframe = {
			"skill_red",
			"skill_blue",
			"skill_yellow"
		},
		weaponframes = {
			"bg1",
			"bg2",
			"bg3",
			"bg3_1",
			"bg4",
			"bg4_0",
			"bg4_1",
			"bg5",
			"bg5_0",
			"bg5_1",
			"bg7",
			"bg8",
			"bg9",
			"bg_skin",
			"frame",
			"frame3_1",
			"frame4_0",
			"frame4_1",
			"frame5_0",
			"frame8",
			"frame9",
			"frame_design",
			"frame_design_owned",
			"frame_npc",
			"frame_prop",
			"frame_prop_meta",
			"frame_skin",
			"frame_dorm"
		},
		energy = {
			"express_1",
			"express_2",
			"express_3",
			"express_4"
		}
	}
	arg0_1.preloadAbs = {
		"shipstatus",
		"channel",
		"painting/mat",
		"ui/commonui_atlas",
		"ui/share/msgbox_atlas",
		"ui/share/world_common_atlas",
		"skinicon",
		"attricon"
	}
	arg0_1.ui_tempCache = {}
end

function var0_0.Init(arg0_2, arg1_2)
	print("initializing pool manager...")

	local var0_2 = 0
	local var1_2 = table.getCount(arg0_2.preloadSprites) + #arg0_2.preloadAbs

	local function var2_2()
		var0_2 = var0_2 + 1

		if var0_2 == var1_2 then
			arg1_2()
		end
	end

	for iter0_2, iter1_2 in pairs(arg0_2.preloadSprites) do
		if #iter1_2 > 0 then
			local var3_2 = typeof(Sprite)

			AssetBundleHelper.loadAssetBundleAsync(iter0_2, function(arg0_4)
				for iter0_4, iter1_4 in ipairs(iter1_2) do
					local var0_4 = arg0_4:LoadAssetSync(iter1_4, var3_2, false, false)

					arg0_2:AddPoolsPack(iter0_2, iter1_4, var3_2, var0_4)
				end

				var2_2()
			end)
		end
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.preloadAbs) do
		AssetBundleHelper.loadAssetBundleAsync(iter3_2, function(arg0_5)
			var2_2()
		end)
	end
end

function var0_0.GetSpineChar(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = ("char/" .. arg1_6) .. arg1_6

	local function var1_6()
		local var0_7 = arg0_6.pools_plural[var0_6]

		var0_7.index = arg0_6.pluralIndex
		arg0_6.pluralIndex = arg0_6.pluralIndex + 1

		local var1_7 = var0_7:Dequeue()

		var1_7:SetActive(true)
		arg3_6(var1_7)
	end

	if not arg0_6.pools_plural[var0_6] then
		arg0_6:GetSpineSkel(arg1_6, arg2_6, function(arg0_8)
			assert(arg0_8 ~= nil, "Spine角色不存在: " .. arg1_6)

			if not arg0_6.pools_plural[var0_6] then
				arg0_8 = SpineAnimUI.AnimChar(arg1_6, arg0_8)

				arg0_8:SetActive(false)
				tf(arg0_8):SetParent(arg0_6.root, false)

				local var0_8 = arg0_8:GetComponent("SkeletonGraphic")

				var0_8.material = var0_8.skeletonDataAsset.atlasAssets[0].materials[0]
				arg0_6.pools_plural[var0_6] = var1_0.New(arg0_8, 1)
			end

			var1_6()
		end)
	else
		var1_6()
	end
end

function var0_0.ReturnSpineChar(arg0_9, arg1_9, arg2_9)
	local var0_9 = ("char/" .. arg1_9) .. arg1_9

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
	local var0_14 = ("char/" .. arg1_14) .. arg1_14

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
			local var1_16 = var0_15 .. arg1_15

			arg0_15.pools_plural[var1_16].prefab:GetComponent(typeof(UIArchiver)):Clear()
			arg0_16:GetComponent(typeof(UIArchiver)):Load(var0_16)
		else
			var0_16()
		end
	end, true)
end

function var0_0.ReturnUI(arg0_18, arg1_18, arg2_18)
	local var0_18 = "ui/" .. arg1_18
	local var1_18 = var0_18 .. arg1_18

	if IsNil(arg2_18) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_18))
	elseif arg0_18.pools_plural[var1_18] then
		if table.indexof(var6_0, arg1_18) then
			arg2_18.transform:SetParent(arg0_18.root, false)
		end

		if table.indexof(var7_0, arg1_18) or arg0_18.ui_tempCache[arg1_18] then
			setActiveViaLayer(arg2_18.transform, false)
			arg0_18.pools_plural[var1_18]:Enqueue(arg2_18)
		elseif table.indexof(var8_0, arg1_18) then
			setActiveViaLayer(arg2_18.transform, false)
			arg2_18:GetComponent(typeof(UIArchiver)):Clear()
			arg0_18.pools_plural[var1_18]:Enqueue(arg2_18)
		else
			arg0_18.pools_plural[var1_18]:Enqueue(arg2_18, true)

			if arg0_18.pools_plural[var1_18]:AllReturned() and (not arg0_18.callbacks[var1_18] or #arg0_18.callbacks[var1_18] == 0) then
				var5_0:ClearBundleRef(var0_18, true, true)
				arg0_18.pools_plural[var1_18]:Clear()

				arg0_18.pools_plural[var1_18] = nil
			end
		end
	else
		var4_0.Destroy(arg2_18)
	end
end

function var0_0.HasCacheUI(arg0_19, arg1_19)
	local var0_19 = ("ui/" .. arg1_19) .. arg1_19

	return arg0_19.pools_plural[var0_19] ~= nil
end

function var0_0.PreloadUI(arg0_20, arg1_20, arg2_20)
	local var0_20 = {}
	local var1_20 = ("ui/" .. arg1_20) .. arg1_20

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
			local var1_25 = var0_25 .. iter0_25

			if arg0_25.pools_plural[var1_25] then
				var5_0:ClearBundleRef(var0_25, true, true)
				arg0_25.pools_plural[var1_25]:Clear()

				arg0_25.pools_plural[var1_25] = nil
			end
		end
	end
end

function var0_0.PreloadPainting(arg0_26, arg1_26, arg2_26)
	local var0_26 = {}
	local var1_26 = ("painting/" .. arg1_26) .. arg1_26

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
	local var1_29 = var0_29 .. arg1_29

	arg0_29:FromPlural(var0_29, "", arg2_29, 1, function(arg0_30)
		arg0_30:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_29) then
			setActive(tf(arg0_30):Find("face"), true)
		end

		arg3_29(arg0_30)
	end, true)
end

function var0_0.ReturnPainting(arg0_31, arg1_31, arg2_31)
	local var0_31 = ("painting/" .. arg1_31) .. arg1_31

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
		var4_0.Destroy(arg2_31, true)
	end
end

function var0_0.ExcessPainting(arg0_32)
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

		var5_0:unloadUnusedAssetBundles()

		arg0_32.paintingCount = arg0_32.paintingCount + 1

		if arg0_32.paintingCount > 10 then
			arg0_32.paintingCount = 0

			var5_0:ResUnloadAsync()
		end
	end
end

function var0_0.GetPaintingWithPrefix(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	local var0_34 = arg4_34 .. arg1_34
	local var1_34 = var0_34 .. arg1_34

	arg0_34:FromPlural(var0_34, "", arg2_34, 1, function(arg0_35)
		arg0_35:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_34) then
			setActive(tf(arg0_35):Find("face"), true)
		end

		arg3_34(arg0_35)
	end, true)
end

function var0_0.ReturnPaintingWithPrefix(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = (arg3_36 .. arg1_36) .. arg1_36

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
		var4_0.Destroy(arg2_36, true)
	end
end

function var0_0.GetSprite(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	arg0_37:FromObjPack(arg1_37, tostring(arg2_37), typeof(Sprite), arg3_37, function(arg0_38)
		arg4_37(arg0_38)
	end)
end

function var0_0.DecreasSprite(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg1_39
	local var1_39 = typeof(Sprite)

	if arg0_39.pools_pack[var0_39] and arg0_39.pools_pack[var0_39].type == var1_39 then
		if arg0_39.pools_pack[var0_39]:Remove(arg2_39) then
			var5_0:ClearBundleRef(var0_39, false, false)
		end

		if arg0_39.pools_pack[var0_39]:GetAmount() <= 0 then
			arg0_39.pools_pack[var0_39]:Clear()

			arg0_39.pools_pack[var0_39] = nil
		end
	end
end

function var0_0.DestroySprite(arg0_40, arg1_40)
	local var0_40 = arg1_40
	local var1_40 = typeof(Sprite)

	if arg0_40.pools_pack[var0_40] and arg0_40.pools_pack[var0_40].type == var1_40 then
		local var2_40 = arg0_40.pools_pack[var0_40]:GetAmount()

		arg0_40.pools_pack[var0_40]:Clear()

		arg0_40.pools_pack[var0_40] = nil

		for iter0_40 = 1, var2_40 do
			var5_0:ClearBundleRef(var0_40, false, false)
		end
	end
end

function var0_0.DestroyAllSprite(arg0_41)
	local var0_41 = {}
	local var1_41 = typeof(Sprite)

	for iter0_41, iter1_41 in pairs(arg0_41.pools_pack) do
		if iter1_41.type == var1_41 and not arg0_41.preloadSprites[iter0_41] then
			var0_41[iter0_41] = iter1_41
		end
	end

	for iter2_41, iter3_41 in pairs(var0_41) do
		local var2_41 = arg0_41.pools_pack[iter2_41]:GetAmount()

		arg0_41.pools_pack[iter2_41]:Clear()

		arg0_41.pools_pack[iter2_41] = nil

		for iter4_41 = 1, var2_41 do
			var5_0:ClearBundleRef(iter2_41, false, false)
		end
	end

	var5_0:unloadUnusedAssetBundles()
end

function var0_0.DisplayPoolPacks(arg0_42)
	local var0_42 = ""

	for iter0_42, iter1_42 in pairs(arg0_42.pools_pack) do
		for iter2_42, iter3_42 in pairs(iter1_42.items) do
			if #var0_42 > 0 then
				var0_42 = var0_42 .. "\n"
			end

			local var1_42 = _.map({
				iter0_42,
				"assetName:",
				iter2_42,
				"type:",
				iter1_42.type.FullName
			}, function(arg0_43)
				return tostring(arg0_43)
			end)

			var0_42 = var0_42 .. " " .. table.concat(var1_42, " ")
		end
	end

	warning(var0_42)
end

function var0_0.SpriteMemUsage(arg0_44)
	local var0_44 = 0
	local var1_44 = 9.5367431640625e-07
	local var2_44 = typeof(Sprite)

	for iter0_44, iter1_44 in pairs(arg0_44.pools_pack) do
		if iter1_44.type == var2_44 then
			local var3_44 = {}

			for iter2_44, iter3_44 in pairs(iter1_44.items) do
				local var4_44 = iter3_44.texture
				local var5_44 = var4_44.name

				if not var3_44[var5_44] then
					local var6_44 = 4
					local var7_44 = var4_44.format

					if var7_44 == TextureFormat.RGB24 then
						var6_44 = 3
					elseif var7_44 == TextureFormat.ARGB4444 or var7_44 == TextureFormat.RGBA4444 then
						var6_44 = 2
					elseif var7_44 == TextureFormat.DXT5 or var7_44 == TextureFormat.ASTC_4x4 or var7_44 == TextureFormat.ETC2_RGBA8 then
						var6_44 = 1
					elseif var7_44 == TextureFormat.PVRTC_RGB4 or var7_44 == TextureFormat.PVRTC_RGBA4 or var7_44 == TextureFormat.ETC_RGB4 or var7_44 == TextureFormat.ETC2_RGB or var7_44 == TextureFormat.ASTC_6x6 or var7_44 == TextureFormat.DXT1 then
						var6_44 = 0.5
					end

					var0_44 = var0_44 + var4_44.width * var4_44.height * var6_44 * var1_44 / 8
					var3_44[var5_44] = true
				end
			end
		end
	end

	return var0_44
end

local var9_0 = 64
local var10_0 = {
	"chapter/",
	"emoji/",
	"world/"
}

function var0_0.GetPrefab(arg0_45, arg1_45, arg2_45, arg3_45, arg4_45, arg5_45)
	local var0_45 = arg1_45 .. arg2_45

	arg0_45:FromPlural(arg1_45, "", arg3_45, arg5_45 or var9_0, function(arg0_46)
		if string.find(arg1_45, "emoji/") == 1 then
			local var0_46 = arg0_46:GetComponent(typeof(CriManaEffectUI))

			if var0_46 then
				var0_46:Pause(false)
			end
		end

		arg0_46:SetActive(true)
		tf(arg0_46):SetParent(arg0_45.root, false)
		arg4_45(arg0_46)
	end, true)
end

function var0_0.ReturnPrefab(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47)
	local var0_47 = arg1_47 .. arg2_47

	if IsNil(arg3_47) then
		Debugger.LogError(debug.traceback("empty go: " .. arg2_47))
	elseif arg0_47.pools_plural[var0_47] then
		if string.find(arg1_47, "emoji/") == 1 then
			local var1_47 = arg3_47:GetComponent(typeof(CriManaEffectUI))

			if var1_47 then
				var1_47:Pause(true)
			end
		end

		arg3_47:SetActive(false)
		arg3_47.transform:SetParent(arg0_47.root, false)
		arg0_47.pools_plural[var0_47]:Enqueue(arg3_47)

		if arg4_47 and arg0_47.pools_plural[var0_47].balance <= 0 and (not arg0_47.callbacks[var0_47] or #arg0_47.callbacks[var0_47] == 0) then
			arg0_47:DestroyPrefab(arg1_47, arg2_47)
		end
	else
		var4_0.Destroy(arg3_47)
	end
end

function var0_0.DestroyPrefab(arg0_48, arg1_48, arg2_48)
	local var0_48 = arg1_48 .. arg2_48

	if arg0_48.pools_plural[var0_48] then
		arg0_48.pools_plural[var0_48]:Clear()

		arg0_48.pools_plural[var0_48] = nil

		var5_0:ClearBundleRef(arg1_48, true, false)
	end
end

function var0_0.DestroyAllPrefab(arg0_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in pairs(arg0_49.pools_plural) do
		if _.any(var10_0, function(arg0_50)
			return string.find(iter0_49, arg0_50) == 1
		end) then
			iter1_49:Clear()
			var5_0:ClearBundleRef(iter0_49, true, false)
			table.insert(var0_49, iter0_49)
		end
	end

	_.each(var0_49, function(arg0_51)
		arg0_49.pools_plural[arg0_51] = nil
	end)
end

function var0_0.DisplayPluralPools(arg0_52)
	local var0_52 = ""

	for iter0_52, iter1_52 in pairs(arg0_52.pools_plural) do
		if #var0_52 > 0 then
			var0_52 = var0_52 .. "\n"
		end

		local var1_52 = _.map({
			iter0_52,
			"balance",
			iter1_52.balance,
			"currentItmes",
			#iter1_52.items
		}, function(arg0_53)
			return tostring(arg0_53)
		end)

		var0_52 = var0_52 .. " " .. table.concat(var1_52, " ")
	end

	warning(var0_52)
end

function var0_0.GetPluralStatus(arg0_54, arg1_54)
	if not arg0_54.pools_plural[arg1_54] then
		return "NIL"
	end

	local var0_54 = arg0_54.pools_plural[arg1_54]
	local var1_54 = _.map({
		arg1_54,
		"balance",
		var0_54.balance,
		"currentItmes",
		#var0_54.items
	}, tostring)

	return table.concat(var1_54, " ")
end

function var0_0.FromPlural(arg0_55, arg1_55, arg2_55, arg3_55, arg4_55, arg5_55, arg6_55)
	local var0_55 = arg1_55 .. arg2_55

	local function var1_55()
		local var0_56 = arg0_55.pools_plural[var0_55]

		var0_56.index = arg0_55.pluralIndex
		arg0_55.pluralIndex = arg0_55.pluralIndex + 1

		arg5_55(var0_56:Dequeue())
	end

	if not arg0_55.pools_plural[var0_55] then
		arg0_55:LoadAsset(arg1_55, arg2_55, typeof(Object), arg3_55, function(arg0_57)
			if arg0_57 == nil then
				Debugger.LogError("can not find asset: " .. arg1_55 .. " : " .. arg2_55)

				return
			end

			if not arg0_55.pools_plural[var0_55] then
				arg0_55.pools_plural[var0_55] = var1_0.New(arg0_57, arg4_55)
			end

			var1_55()
		end, arg6_55)
	else
		var1_55()
	end
end

function var0_0.FromObjPack(arg0_58, arg1_58, arg2_58, arg3_58, arg4_58, arg5_58)
	local var0_58 = arg1_58

	if not arg0_58.pools_pack[var0_58] or not arg0_58.pools_pack[var0_58]:Get(arg2_58) then
		AssetBundleHelper.LoadAsset(arg1_58, arg2_58, arg3_58, arg4_58, function(arg0_59)
			if arg0_59 == nil then
				Debugger.LogError("can not find asset: " .. arg1_58 .. " : " .. arg2_58)

				return
			end

			arg0_58:AddPoolsPack(var0_58, arg2_58, arg3_58, arg0_59)
			arg5_58(arg0_59)
		end, false)
	else
		arg5_58(arg0_58.pools_pack[var0_58]:Get(arg2_58))
	end
end

function var0_0.LoadAsset(arg0_60, arg1_60, arg2_60, arg3_60, arg4_60, arg5_60, arg6_60)
	arg1_60, arg2_60 = HXSet.autoHxShiftPath(arg1_60, arg2_60)

	local var0_60 = arg1_60 .. arg2_60

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

function var0_0.AddPoolsPack(arg0_62, arg1_62, arg2_62, arg3_62, arg4_62)
	if not arg0_62.pools_pack[arg1_62] then
		arg0_62.pools_pack[arg1_62] = var3_0.New(arg3_62)
	end

	if not arg0_62.pools_pack[arg1_62]:Get(arg2_62) then
		arg0_62.pools_pack[arg1_62]:Set(arg2_62, arg4_62)
	end
end

function var0_0.PrintPools(arg0_63)
	local var0_63 = ""

	for iter0_63, iter1_63 in pairs(arg0_63.pools_plural) do
		var0_63 = var0_63 .. "\n" .. iter0_63
	end

	warning(var0_63)
end

function var0_0.PrintObjPack(arg0_64)
	local var0_64 = ""

	for iter0_64, iter1_64 in pairs(arg0_64.pools_pack) do
		for iter2_64, iter3_64 in pairs(iter1_64.items) do
			var0_64 = var0_64 .. "\n" .. iter0_64 .. " " .. iter2_64
		end
	end

	warning(var0_64)
end

return var0_0
