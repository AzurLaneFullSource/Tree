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
		"attricon",
		"artresource/effect/chuanwukuang/duang_6_mask",
		"artresource/effect/communicationjamming/line5",
		"artresource/effect/communicationjamming/line6",
		"artresource/effect/wupinkuang/iconcolorfulmask",
		"artresource/effect/wupinkuang/iconcolorfulwave01"
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
			local var4_2 = false

			local function var5_2(arg0_4)
				return
			end

			AssetBundleHelper.loadAssetBundleAsync(iter0_2, function(arg0_5)
				for iter0_5, iter1_5 in ipairs(iter1_2) do
					local var0_5 = arg0_5:LoadAssetSync(iter1_5, var3_2, var4_2, false)
					local var1_5 = iter0_2
					local var2_5 = iter1_5

					if arg0_2.pools_pack[var1_5] and arg0_2.pools_pack[var1_5]:Get(var2_5) then
						var5_2(arg0_2.pools_pack[var1_5]:Get(var2_5))
					else
						if not arg0_2.pools_pack[var1_5] then
							arg0_2.pools_pack[var1_5] = var3_0.New(var3_2)
						end

						if not arg0_2.pools_pack[var1_5]:Get(var2_5) then
							arg0_2.pools_pack[var1_5]:Set(var2_5, var0_5)
						end

						var5_2(var0_5)
					end
				end

				var2_2()
			end)
		end
	end

	for iter2_2, iter3_2 in ipairs(arg0_2.preloadAbs) do
		AssetBundleHelper.loadAssetBundleAsync(iter3_2, function(arg0_6)
			var2_2()
		end)
	end
end

function var0_0.GetSpineChar(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = ("char/" .. arg1_7) .. arg1_7

	local function var1_7()
		local var0_8 = arg0_7.pools_plural[var0_7]

		var0_8.index = arg0_7.pluralIndex
		arg0_7.pluralIndex = arg0_7.pluralIndex + 1

		local var1_8 = var0_8:Dequeue()

		var1_8:SetActive(true)
		arg3_7(var1_8)
	end

	if not arg0_7.pools_plural[var0_7] then
		arg0_7:GetSpineSkel(arg1_7, arg2_7, function(arg0_9)
			assert(arg0_9 ~= nil, "Spine角色不存在: " .. arg1_7)

			if not arg0_7.pools_plural[var0_7] then
				arg0_9 = SpineAnimUI.AnimChar(arg1_7, arg0_9)

				arg0_9:SetActive(false)
				tf(arg0_9):SetParent(arg0_7.root, false)

				local var0_9 = arg0_9:GetComponent("SkeletonGraphic")

				var0_9.material = var0_9.skeletonDataAsset.atlasAssets[0].materials[0]
				arg0_7.pools_plural[var0_7] = var1_0.New(arg0_9, 1)
			end

			var1_7()
		end)
	else
		var1_7()
	end
end

function var0_0.ReturnSpineChar(arg0_10, arg1_10, arg2_10)
	local var0_10 = ("char/" .. arg1_10) .. arg1_10

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

	arg0_13:LoadAsset(var0_13, var2_13, arg2_13, typeof(Object), function(arg0_14)
		arg3_13(arg0_14)
	end, true)
end

function var0_0.IsSpineSkelCached(arg0_15, arg1_15)
	local var0_15 = ("char/" .. arg1_15) .. arg1_15

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
	local var2_16 = table.contains(var7_0, arg1_16) or table.contains(var8_0, arg1_16)

	arg0_16:FromPlural(var0_16, arg1_16, arg2_16, var1_16, function(arg0_17)
		local function var0_17()
			arg3_16(arg0_17)
		end

		if table.indexof(var8_0, arg1_16) then
			local var1_17 = var0_16 .. arg1_16

			arg0_16.pools_plural[var1_17].prefab:GetComponent(typeof(UIArchiver)):Clear()
			arg0_17:GetComponent(typeof(UIArchiver)):Load(var0_17)
		else
			var0_17()
		end
	end, var2_16)
end

function var0_0.ReturnUI(arg0_19, arg1_19, arg2_19)
	local var0_19 = "ui/" .. arg1_19
	local var1_19 = var0_19 .. arg1_19

	if IsNil(arg2_19) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_19))
	elseif arg0_19.pools_plural[var1_19] then
		if table.indexof(var6_0, arg1_19) then
			arg2_19.transform:SetParent(arg0_19.root, false)
		end

		if table.indexof(var7_0, arg1_19) or arg0_19.ui_tempCache[arg1_19] then
			setActiveViaLayer(arg2_19.transform, false)
			arg0_19.pools_plural[var1_19]:Enqueue(arg2_19)
		elseif table.indexof(var8_0, arg1_19) then
			setActiveViaLayer(arg2_19.transform, false)
			arg2_19:GetComponent(typeof(UIArchiver)):Clear()
			arg0_19.pools_plural[var1_19]:Enqueue(arg2_19)
		else
			arg0_19.pools_plural[var1_19]:Enqueue(arg2_19, true)

			if arg0_19.pools_plural[var1_19]:AllReturned() and (not arg0_19.callbacks[var1_19] or #arg0_19.callbacks[var1_19] == 0) then
				var5_0:ClearBundleRef(var0_19, true, true)
				arg0_19.pools_plural[var1_19]:Clear()

				arg0_19.pools_plural[var1_19] = nil
			end
		end
	else
		var4_0.Destroy(arg2_19)
	end
end

function var0_0.HasCacheUI(arg0_20, arg1_20)
	local var0_20 = ("ui/" .. arg1_20) .. arg1_20

	return arg0_20.pools_plural[var0_20] ~= nil
end

function var0_0.PreloadUI(arg0_21, arg1_21, arg2_21)
	local var0_21 = {}
	local var1_21 = ("ui/" .. arg1_21) .. arg1_21

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
			local var1_26 = var0_26 .. iter0_26

			if arg0_26.pools_plural[var1_26] then
				var5_0:ClearBundleRef(var0_26, true, true)
				arg0_26.pools_plural[var1_26]:Clear()

				arg0_26.pools_plural[var1_26] = nil
			end
		end
	end
end

function var0_0.PreloadPainting(arg0_27, arg1_27, arg2_27)
	local var0_27 = {}
	local var1_27 = ("painting/" .. arg1_27) .. arg1_27

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
	local var1_30 = var0_30 .. arg1_30

	arg0_30:FromPlural(var0_30, arg1_30, arg2_30, 1, function(arg0_31)
		arg0_31:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_30) then
			setActive(tf(arg0_31):Find("face"), true)
		end

		arg3_30(arg0_31)
	end, true)
end

function var0_0.ReturnPainting(arg0_32, arg1_32, arg2_32)
	local var0_32 = ("painting/" .. arg1_32) .. arg1_32

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

			var5_0.Inst:ResUnloadAsync()
		end
	end
end

function var0_0.GetPaintingWithPrefix(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	local var0_35 = arg4_35 .. arg1_35
	local var1_35 = var0_35 .. arg1_35

	arg0_35:FromPlural(var0_35, arg1_35, arg2_35, 1, function(arg0_36)
		arg0_36:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_35) then
			setActive(tf(arg0_36):Find("face"), true)
		end

		arg3_35(arg0_36)
	end, true)
end

function var0_0.ReturnPaintingWithPrefix(arg0_37, arg1_37, arg2_37, arg3_37)
	local var0_37 = (arg3_37 .. arg1_37) .. arg1_37

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
	arg0_38:FromObjPack(arg1_38, tostring(arg2_38), arg3_38, typeof(Sprite), function(arg0_39)
		arg4_38(arg0_39)
	end)
end

function var0_0.DecreasSprite(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg1_40
	local var1_40 = typeof(Sprite)

	if arg0_40.pools_pack[var0_40] and arg0_40.pools_pack[var0_40].type == var1_40 then
		if arg0_40.pools_pack[var0_40]:Remove(arg2_40) then
			var5_0:ClearBundleRef(var0_40, false, false)
		end

		if arg0_40.pools_pack[var0_40]:GetAmount() <= 0 then
			arg0_40.pools_pack[var0_40]:Clear()

			arg0_40.pools_pack[var0_40] = nil
		end
	end
end

function var0_0.DestroySprite(arg0_41, arg1_41)
	local var0_41 = arg1_41
	local var1_41 = typeof(Sprite)

	if arg0_41.pools_pack[var0_41] and arg0_41.pools_pack[var0_41].type == var1_41 then
		local var2_41 = arg0_41.pools_pack[var0_41]:GetAmount()

		arg0_41.pools_pack[var0_41]:Clear()

		arg0_41.pools_pack[var0_41] = nil

		for iter0_41 = 1, var2_41 do
			var5_0:ClearBundleRef(var0_41, false, false)
		end
	end
end

function var0_0.DestroyAllSprite(arg0_42)
	local var0_42 = {}
	local var1_42 = typeof(Sprite)

	for iter0_42, iter1_42 in pairs(arg0_42.pools_pack) do
		if iter1_42.type == var1_42 and not arg0_42.preloadSprites[iter0_42] then
			var0_42[iter0_42] = iter1_42
		end
	end

	for iter2_42, iter3_42 in pairs(var0_42) do
		local var2_42 = arg0_42.pools_pack[iter2_42]:GetAmount()

		arg0_42.pools_pack[iter2_42]:Clear()

		arg0_42.pools_pack[iter2_42] = nil

		for iter4_42 = 1, var2_42 do
			var5_0:ClearBundleRef(iter2_42, false, false)
		end
	end

	var5_0:unloadUnusedAssetBundles()
end

function var0_0.DisplayPoolPacks(arg0_43)
	local var0_43 = ""

	for iter0_43, iter1_43 in pairs(arg0_43.pools_pack) do
		for iter2_43, iter3_43 in pairs(iter1_43.items) do
			if #var0_43 > 0 then
				var0_43 = var0_43 .. "\n"
			end

			local var1_43 = _.map({
				iter0_43,
				"assetName:",
				iter2_43,
				"type:",
				iter1_43.type.FullName
			}, function(arg0_44)
				return tostring(arg0_44)
			end)

			var0_43 = var0_43 .. " " .. table.concat(var1_43, " ")
		end
	end

	warning(var0_43)
end

function var0_0.SpriteMemUsage(arg0_45)
	local var0_45 = 0
	local var1_45 = 9.5367431640625e-07
	local var2_45 = typeof(Sprite)

	for iter0_45, iter1_45 in pairs(arg0_45.pools_pack) do
		if iter1_45.type == var2_45 then
			local var3_45 = {}

			for iter2_45, iter3_45 in pairs(iter1_45.items) do
				local var4_45 = iter3_45.texture
				local var5_45 = var4_45.name

				if not var3_45[var5_45] then
					local var6_45 = 4
					local var7_45 = var4_45.format

					if var7_45 == TextureFormat.RGB24 then
						var6_45 = 3
					elseif var7_45 == TextureFormat.ARGB4444 or var7_45 == TextureFormat.RGBA4444 then
						var6_45 = 2
					elseif var7_45 == TextureFormat.DXT5 or var7_45 == TextureFormat.ETC2_RGBA8 then
						var6_45 = 1
					elseif var7_45 == TextureFormat.PVRTC_RGB4 or var7_45 == TextureFormat.PVRTC_RGBA4 or var7_45 == TextureFormat.ETC_RGB4 or var7_45 == TextureFormat.ETC2_RGB or var7_45 == TextureFormat.DXT1 then
						var6_45 = 0.5
					end

					var0_45 = var0_45 + var4_45.width * var4_45.height * var6_45 * var1_45
					var3_45[var5_45] = true
				end
			end
		end
	end

	return var0_45
end

local var9_0 = 64
local var10_0 = {
	"chapter/",
	"emoji/",
	"world/"
}

function var0_0.GetPrefab(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46, arg5_46)
	local var0_46 = arg1_46 .. arg2_46

	arg0_46:FromPlural(arg1_46, arg2_46, arg3_46, arg5_46 or var9_0, function(arg0_47)
		if string.find(arg1_46, "emoji/") == 1 then
			local var0_47 = arg0_47:GetComponent(typeof(CriManaEffectUI))

			if var0_47 then
				var0_47:Pause(false)
			end
		end

		arg0_47:SetActive(true)
		tf(arg0_47):SetParent(arg0_46.root, false)
		arg4_46(arg0_47)
	end, true)
end

function var0_0.ReturnPrefab(arg0_48, arg1_48, arg2_48, arg3_48, arg4_48)
	local var0_48 = arg1_48 .. arg2_48

	if IsNil(arg3_48) then
		Debugger.LogError(debug.traceback("empty go: " .. arg2_48))
	elseif arg0_48.pools_plural[var0_48] then
		if string.find(arg1_48, "emoji/") == 1 then
			local var1_48 = arg3_48:GetComponent(typeof(CriManaEffectUI))

			if var1_48 then
				var1_48:Pause(true)
			end
		end

		arg3_48:SetActive(false)
		arg3_48.transform:SetParent(arg0_48.root, false)
		arg0_48.pools_plural[var0_48]:Enqueue(arg3_48)

		if arg4_48 and arg0_48.pools_plural[var0_48].balance <= 0 and (not arg0_48.callbacks[var0_48] or #arg0_48.callbacks[var0_48] == 0) then
			arg0_48:DestroyPrefab(arg1_48, arg2_48)
		end
	else
		var4_0.Destroy(arg3_48)
	end
end

function var0_0.DestroyPrefab(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg1_49 .. arg2_49

	if arg0_49.pools_plural[var0_49] then
		arg0_49.pools_plural[var0_49]:Clear()

		arg0_49.pools_plural[var0_49] = nil

		var5_0:ClearBundleRef(arg1_49, true, false)
	end
end

function var0_0.DestroyAllPrefab(arg0_50)
	local var0_50 = {}

	for iter0_50, iter1_50 in pairs(arg0_50.pools_plural) do
		if _.any(var10_0, function(arg0_51)
			return string.find(iter0_50, arg0_51) == 1
		end) then
			iter1_50:Clear()
			var5_0:ClearBundleRef(iter0_50, true, false)
			table.insert(var0_50, iter0_50)
		end
	end

	_.each(var0_50, function(arg0_52)
		arg0_50.pools_plural[arg0_52] = nil
	end)
end

function var0_0.DisplayPluralPools(arg0_53)
	local var0_53 = ""

	for iter0_53, iter1_53 in pairs(arg0_53.pools_plural) do
		if #var0_53 > 0 then
			var0_53 = var0_53 .. "\n"
		end

		local var1_53 = _.map({
			iter0_53,
			"balance",
			iter1_53.balance,
			"currentItmes",
			#iter1_53.items
		}, function(arg0_54)
			return tostring(arg0_54)
		end)

		var0_53 = var0_53 .. " " .. table.concat(var1_53, " ")
	end

	warning(var0_53)
end

function var0_0.GetPluralStatus(arg0_55, arg1_55)
	if not arg0_55.pools_plural[arg1_55] then
		return "NIL"
	end

	local var0_55 = arg0_55.pools_plural[arg1_55]
	local var1_55 = _.map({
		arg1_55,
		"balance",
		var0_55.balance,
		"currentItmes",
		#var0_55.items
	}, tostring)

	return table.concat(var1_55, " ")
end

function var0_0.FromPlural(arg0_56, arg1_56, arg2_56, arg3_56, arg4_56, arg5_56, arg6_56)
	local var0_56 = arg1_56 .. arg2_56

	local function var1_56()
		local var0_57 = arg0_56.pools_plural[var0_56]

		var0_57.index = arg0_56.pluralIndex
		arg0_56.pluralIndex = arg0_56.pluralIndex + 1

		arg5_56(var0_57:Dequeue())
	end

	if not arg0_56.pools_plural[var0_56] then
		arg0_56:LoadAsset(arg1_56, arg2_56, arg3_56, typeof(Object), function(arg0_58)
			if arg0_58 == nil then
				Debugger.LogError("can not find asset: " .. arg1_56 .. " : " .. arg2_56)

				return
			end

			if not arg0_56.pools_plural[var0_56] then
				arg0_56.pools_plural[var0_56] = var1_0.New(arg0_58, arg4_56)
			end

			var1_56()
		end, arg6_56)
	else
		var1_56()
	end
end

function var0_0.FromObjPack(arg0_59, arg1_59, arg2_59, arg3_59, arg4_59, arg5_59)
	local var0_59 = arg1_59

	if not arg0_59.pools_pack[var0_59] or not arg0_59.pools_pack[var0_59]:Get(arg2_59) then
		arg0_59:LoadAsset(arg1_59, arg2_59, arg3_59, arg4_59, function(arg0_60)
			if arg0_60 == nil then
				Debugger.LogError("can not find asset: " .. arg1_59 .. " : " .. arg2_59)

				return
			end

			if not arg0_59.pools_pack[var0_59] then
				arg0_59.pools_pack[var0_59] = var3_0.New(arg4_59)
			end

			if not arg0_59.pools_pack[var0_59]:Get(arg2_59) then
				arg0_59.pools_pack[var0_59]:Set(arg2_59, arg0_60)
			end

			arg5_59(arg0_60)
		end, false)
	else
		arg5_59(arg0_59.pools_pack[var0_59]:Get(arg2_59))
	end
end

function var0_0.LoadAsset(arg0_61, arg1_61, arg2_61, arg3_61, arg4_61, arg5_61, arg6_61)
	arg1_61, arg2_61 = HXSet.autoHxShiftPath(arg1_61, arg2_61)

	local var0_61 = arg1_61 .. arg2_61

	if arg0_61.callbacks[var0_61] then
		if not arg3_61 then
			errorMsg("Sync Loading after async operation")
		end

		table.insert(arg0_61.callbacks[var0_61], arg5_61)
	elseif arg3_61 then
		arg0_61.callbacks[var0_61] = {
			arg5_61
		}

		var5_0:getAssetAsync(arg1_61, arg2_61, arg4_61, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_62)
			if arg0_61.callbacks[var0_61] then
				local var0_62 = arg0_61.callbacks[var0_61]

				arg0_61.callbacks[var0_61] = nil

				while next(var0_62) do
					table.remove(var0_62)(arg0_62)
				end
			end
		end), arg6_61, false)
	else
		arg5_61(var5_0:getAssetSync(arg1_61, arg2_61, arg4_61, arg6_61, false))
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
