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
		"custom_builtin",
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
		AssetBundleHelper.LoadAssetBundle(iter0_2, true, true, function(arg0_4)
			arg0_2:AddPoolsPack(iter0_2, arg0_4)

			for iter0_4, iter1_4 in ipairs(iter1_2) do
				arg0_2.pools_pack[iter0_2]:Get(iter1_4, typeof(Sprite))
			end

			var2_2()
		end)
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.preloadAbs) do
		AssetBundleHelper.LoadAssetBundle(iter3_2, true, false, function(arg0_5)
			arg0_2:AddPoolsPack(iter3_2, arg0_5)
			var2_2()
		end)
	end
end

function var0_0.GetSpineChar(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = {}
	local var1_6 = "char/" .. arg1_6

	if not arg0_6.pools_plural[var1_6] then
		table.insert(var0_6, function(arg0_7)
			arg0_6:GetSpineSkel(arg1_6, arg2_6, function(arg0_8)
				assert(arg0_8 ~= nil, "Spine角色不存在: " .. arg1_6)

				if not arg0_6.pools_plural[var1_6] then
					arg0_8 = SpineAnimUI.AnimChar(arg1_6, arg0_8)

					arg0_8:SetActive(false)
					tf(arg0_8):SetParent(arg0_6.root, false)

					local var0_8 = arg0_8:GetComponent("SkeletonGraphic")

					var0_8.material = var0_8.skeletonDataAsset.atlasAssets[0].materials[0]
					arg0_6.pools_plural[var1_6] = var1_0.New(arg0_8, 1)
				end

				arg0_7()
			end)
		end)
	end

	seriesAsync(var0_6, function()
		local var0_9 = arg0_6.pools_plural[var1_6]

		var0_9.index = arg0_6.pluralIndex
		arg0_6.pluralIndex = arg0_6.pluralIndex + 1

		local var1_9 = var0_9:Dequeue()

		var1_9:SetActive(true)
		arg3_6(var1_9)
	end)
end

function var0_0.ReturnSpineChar(arg0_10, arg1_10, arg2_10)
	local var0_10 = "char/" .. arg1_10

	if IsNil(arg2_10) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_10))
	elseif arg0_10.pools_plural[var0_10] then
		if arg2_10:GetComponent("SkeletonGraphic").allowMultipleCanvasRenderers then
			UIUtil.ClearChildren(arg2_10, {
				"Renderer"
			})
		else
			UIUtil.ClearChildren(arg2_10)
		end

		setActiveViaLayer(arg2_10.transform, true)
		arg2_10:SetActive(false)
		arg2_10.transform:SetParent(arg0_10.root, false)

		arg2_10.transform.localPosition = Vector3.New(0, 0, 0)
		arg2_10.transform.localScale = Vector3.New(0.5, 0.5, 1)
		arg2_10.transform.localRotation = Quaternion.identity

		arg0_10.pools_plural[var0_10]:Enqueue(arg2_10)
		arg0_10:ExcessSpineChar()
	else
		var4_0.Destroy(arg2_10)
	end
end

function var0_0.ExcessSpineChar(arg0_11)
	local var0_11 = 0
	local var1_11 = 6
	local var2_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.pools_plural) do
		if string.find(iter0_11, "char/") == 1 then
			table.insert(var2_11, iter0_11)
		end
	end

	if var1_11 < #var2_11 then
		table.sort(var2_11, function(arg0_12, arg1_12)
			return arg0_11.pools_plural[arg0_12].index > arg0_11.pools_plural[arg1_12].index
		end)

		for iter2_11 = var1_11 + 1, #var2_11 do
			local var3_11 = var2_11[iter2_11]

			arg0_11.pools_plural[var3_11]:Clear()

			arg0_11.pools_plural[var3_11] = nil
		end
	end
end

function var0_0.GetSpineSkel(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13, var1_13 = HXSet.autoHxShiftPath("char/" .. arg1_13, arg1_13)
	local var2_13 = var1_13 .. "_SkeletonData"

	arg0_13:LoadAsset(var0_13, "", typeof(Object), arg2_13, function(arg0_14)
		arg3_13(arg0_14)
	end, true)
end

function var0_0.IsSpineSkelCached(arg0_15, arg1_15)
	local var0_15 = "char/" .. arg1_15

	return arg0_15.pools_plural[var0_15] ~= nil
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

function var0_0.GetUI(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = "ui/" .. arg1_16
	local var1_16 = table.contains(var6_0, arg1_16) and 3 or 1

	arg0_16:FromPlural(var0_16, "", arg2_16, var1_16, function(arg0_17)
		local function var0_17()
			arg3_16(arg0_17)
		end

		if table.indexof(var8_0, arg1_16) then
			local var1_17 = var0_16

			arg0_16.pools_plural[var1_17].prefab:GetComponent(typeof(UIArchiver)):Clear()
			arg0_17:GetComponent(typeof(UIArchiver)):Load(var0_17)
		else
			var0_17()
		end
	end, true)
end

function var0_0.ReturnUI(arg0_19, arg1_19, arg2_19)
	local var0_19 = "ui/" .. arg1_19

	if IsNil(arg2_19) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_19))
	elseif arg0_19.pools_plural[var0_19] then
		if table.indexof(var6_0, arg1_19) then
			arg2_19.transform:SetParent(arg0_19.root, false)
		end

		if table.indexof(var7_0, arg1_19) or arg0_19.ui_tempCache[arg1_19] then
			setActiveViaLayer(arg2_19.transform, false)
			arg0_19.pools_plural[var0_19]:Enqueue(arg2_19)
		elseif table.indexof(var8_0, arg1_19) then
			setActiveViaLayer(arg2_19.transform, false)
			arg2_19:GetComponent(typeof(UIArchiver)):Clear()
			arg0_19.pools_plural[var0_19]:Enqueue(arg2_19)
		else
			arg0_19.pools_plural[var0_19]:Enqueue(arg2_19, true)

			if arg0_19.pools_plural[var0_19]:AllReturned() and (not arg0_19.callbacks[var0_19] or #arg0_19.callbacks[var0_19] == 0) then
				arg0_19.pools_plural[var0_19]:Clear()

				arg0_19.pools_plural[var0_19] = nil
			end
		end
	else
		var4_0.Destroy(arg2_19)
	end
end

function var0_0.HasCacheUI(arg0_20, arg1_20)
	local var0_20 = "ui/" .. arg1_20

	return arg0_20.pools_plural[var0_20] ~= nil
end

function var0_0.PreloadUI(arg0_21, arg1_21, arg2_21)
	local var0_21 = {}
	local var1_21 = "ui/" .. arg1_21

	if not arg0_21.pools_plural[var1_21] then
		table.insert(var0_21, function(arg0_22)
			arg0_21:GetUI(arg1_21, true, function(arg0_23)
				arg0_21.pools_plural[var1_21]:Enqueue(arg0_23)
				arg0_22()
			end)
		end)
	end

	seriesAsync(var0_21, arg2_21)
end

function var0_0.AddTempCache(arg0_24, arg1_24)
	arg0_24.ui_tempCache[arg1_24] = true
end

function var0_0.DelTempCache(arg0_25, arg1_25)
	arg0_25.ui_tempCache[arg1_25] = nil
end

function var0_0.ClearAllTempCache(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.ui_tempCache) do
		if iter1_26 then
			local var0_26 = "ui/" .. iter0_26

			if arg0_26.pools_plural[var0_26] then
				arg0_26.pools_plural[var0_26]:Clear()

				arg0_26.pools_plural[var0_26] = nil
			end
		end
	end
end

function var0_0.PreloadPainting(arg0_27, arg1_27, arg2_27)
	local var0_27 = {}
	local var1_27 = "painting/" .. arg1_27

	if not arg0_27.pools_plural[var1_27] then
		table.insert(var0_27, function(arg0_28)
			arg0_27:GetPainting(arg1_27, true, function(arg0_29)
				arg0_27.pools_plural[var1_27]:Enqueue(arg0_29)
				arg0_28()
			end)
		end)
	end

	seriesAsync(var0_27, arg2_27)
end

function var0_0.GetPainting(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = "painting/" .. arg1_30
	local var1_30 = var0_30

	arg0_30:FromPlural(var0_30, "", arg2_30, 1, function(arg0_31)
		arg0_31:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_30) then
			setActive(tf(arg0_31):Find("face"), true)
		end

		arg3_30(arg0_31)
	end, true)
end

function var0_0.ReturnPainting(arg0_32, arg1_32, arg2_32)
	local var0_32 = "painting/" .. arg1_32

	if IsNil(arg2_32) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_32))
	elseif arg0_32.pools_plural[var0_32] then
		setActiveViaLayer(arg2_32, true)

		local var1_32 = tf(arg2_32):Find("face")

		if var1_32 then
			setActive(var1_32, false)
		end

		arg2_32:SetActive(false)
		arg2_32.transform:SetParent(arg0_32.root, false)
		arg0_32.pools_plural[var0_32]:Enqueue(arg2_32)
		arg0_32:ExcessPainting()
	else
		var4_0.Destroy(arg2_32, true)
	end
end

function var0_0.ExcessPainting(arg0_33)
	local var0_33 = 0
	local var1_33 = 4
	local var2_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33.pools_plural) do
		local var3_33 = string.find(iter0_33, "painting/")

		if var3_33 and var3_33 >= 1 then
			table.insert(var2_33, iter0_33)
		end
	end

	if var1_33 < #var2_33 then
		table.sort(var2_33, function(arg0_34, arg1_34)
			return arg0_33.pools_plural[arg0_34].index > arg0_33.pools_plural[arg1_34].index
		end)

		for iter2_33 = var1_33 + 1, #var2_33 do
			local var4_33 = var2_33[iter2_33]

			arg0_33.pools_plural[var4_33]:Clear(true)

			arg0_33.pools_plural[var4_33] = nil
		end

		var5_0:unloadUnusedAssetBundles()

		arg0_33.paintingCount = arg0_33.paintingCount + 1

		if arg0_33.paintingCount > 10 then
			arg0_33.paintingCount = 0

			var5_0:ResUnloadAsync()
		end
	end
end

function var0_0.GetPaintingWithPrefix(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	local var0_35 = arg4_35 .. arg1_35
	local var1_35 = var0_35

	arg0_35:FromPlural(var0_35, "", arg2_35, 1, function(arg0_36)
		arg0_36:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_35) then
			setActive(tf(arg0_36):Find("face"), true)
		end

		arg3_35(arg0_36)
	end, true)
end

function var0_0.ReturnPaintingWithPrefix(arg0_37, arg1_37, arg2_37, arg3_37)
	local var0_37 = arg3_37 .. arg1_37

	if IsNil(arg2_37) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_37))
	elseif arg0_37.pools_plural[var0_37] then
		setActiveViaLayer(arg2_37, true)

		local var1_37 = tf(arg2_37):Find("face")

		if var1_37 then
			setActive(var1_37, false)
		end

		arg2_37:SetActive(false)
		arg2_37.transform:SetParent(arg0_37.root, false)
		arg0_37.pools_plural[var0_37]:Enqueue(arg2_37)
		arg0_37:ExcessPainting()
	else
		var4_0.Destroy(arg2_37, true)
	end
end

function var0_0.GetSprite(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	arg0_38:FromObjPack(arg1_38, tostring(arg2_38), typeof(Sprite), arg3_38, function(arg0_39)
		arg4_38(arg0_39)
	end)
end

function var0_0.DecreasSprite(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg1_40

	if arg0_40.pools_pack[var0_40] then
		arg0_40.pools_pack[var0_40]:Remove(arg2_40)

		if arg0_40.pools_pack[var0_40]:GetAmount() <= 0 then
			arg0_40.pools_pack[var0_40]:Clear()

			arg0_40.pools_pack[var0_40] = nil
		end
	end
end

function var0_0.DestroySprite(arg0_41, arg1_41)
	local var0_41 = arg1_41

	if arg0_41.pools_pack[var0_41] then
		arg0_41.pools_pack[var0_41]:Clear()

		arg0_41.pools_pack[var0_41] = nil
	end
end

function var0_0.DestroyAllSprite(arg0_42)
	local var0_42 = {}
	local var1_42 = typeof(Sprite)

	for iter0_42, iter1_42 in pairs(arg0_42.pools_pack) do
		if not arg0_42.preloadSprites[iter0_42] and not arg0_42.preloadAbs[iter0_42] then
			arg0_42.pools_pack[iter0_42]:Clear()

			arg0_42.pools_pack[iter0_42] = nil
		end
	end

	var5_0:unloadUnusedAssetBundles()
end

function var0_0.DisplayPoolPacks(arg0_43)
	local var0_43

	for iter0_43, iter1_43 in pairs(arg0_43.pools_pack) do
		table.insert(var0_43, iter0_43)

		for iter2_43, iter3_43 in pairs(iter1_43.items) do
			table.insert(var0_43, string.format("assetName:%s type:%s", iter2_43, tostring(iter1_43.type.FullName)))
		end
	end

	warning(table.concat(var0_43, "\n"))
end

function var0_0.SpriteMemUsage(arg0_44)
	local var0_44 = 0
	local var1_44 = 9.5367431640625e-07
	local var2_44 = typeof(Sprite)

	for iter0_44, iter1_44 in pairs(arg0_44.pools_pack) do
		local var3_44 = {}

		for iter2_44, iter3_44 in pairs(iter1_44.items) do
			if iter1_44.typeDic[iter2_44] == var2_44 then
				local var4_44 = iter1_44.items[iter2_44].texture
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
	local var0_45 = arg1_45

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
	local var0_47 = arg1_47

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
	local var0_48 = arg1_48

	if arg0_48.pools_plural[var0_48] then
		arg0_48.pools_plural[var0_48]:Clear()

		arg0_48.pools_plural[var0_48] = nil
	end
end

function var0_0.DestroyAllPrefab(arg0_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in pairs(arg0_49.pools_plural) do
		if _.any(var10_0, function(arg0_50)
			return string.find(iter0_49, arg0_50) == 1
		end) then
			iter1_49:Clear()
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
	local var0_55 = arg2_55 == "" and arg1_55 or arg1_55 .. "|" .. arg2_55

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

function var0_0.LoadAsset(arg0_62, arg1_62, arg2_62, arg3_62, arg4_62, arg5_62, arg6_62)
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
		end), arg6_62, false)
	else
		arg5_62(var5_0:getAssetSync(arg1_62, arg2_62, arg3_62, arg6_62, false))
	end
end

function var0_0.AddPoolsPack(arg0_64, arg1_64, arg2_64)
	if arg0_64.pools_pack[arg1_64] then
		arg2_64:Dispose()
	else
		arg0_64.pools_pack[arg1_64] = var3_0.New(arg1_64, arg2_64)
	end
end

function var0_0.PrintPools(arg0_65)
	local var0_65 = ""

	for iter0_65, iter1_65 in pairs(arg0_65.pools_plural) do
		var0_65 = var0_65 .. "\n" .. iter0_65
	end

	warning(var0_65)
end

function var0_0.PrintObjPack(arg0_66)
	local var0_66 = ""

	for iter0_66, iter1_66 in pairs(arg0_66.pools_pack) do
		for iter2_66, iter3_66 in pairs(iter1_66.items) do
			var0_66 = var0_66 .. "\n" .. iter0_66 .. " " .. iter2_66
		end
	end

	warning(var0_66)
end

return var0_0
