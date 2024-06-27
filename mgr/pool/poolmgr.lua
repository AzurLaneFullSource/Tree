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
	arg0_1.preloads = {
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
			"frame_skin"
		},
		energy = {
			"express_1",
			"express_2",
			"express_3",
			"express_4"
		},
		shipstatus = {},
		channel = {},
		["painting/mat"] = {}
	}
	arg0_1.ui_tempCache = {}
end

function var0_0.Init(arg0_2, arg1_2)
	print("initializing pool manager...")

	local var0_2 = 0
	local var1_2 = table.getCount(arg0_2.preloads)

	local function var2_2()
		var0_2 = var0_2 + 1

		if var0_2 == var1_2 then
			arg1_2()
		end
	end

	for iter0_2, iter1_2 in pairs(arg0_2.preloads) do
		if #iter1_2 > 0 then
			local var3_2 = typeof(Sprite)
			local var4_2 = false

			local function var5_2(arg0_4)
				return
			end

			buildTempAB(iter0_2, function(arg0_5)
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
		else
			buildTempAB(iter0_2, function(arg0_6)
				var2_2()
			end)
		end
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
	"ToastUI",
	"MsgBox",
	"TipPanel",
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

function var0_0.BuildUIPlural(arg0_19, arg1_19, arg2_19)
	local var0_19 = "ui/" .. arg1_19
	local var1_19 = var0_19 .. arg1_19

	if arg0_19.pools_plural[var1_19] then
		return
	end

	local var2_19 = table.contains(var6_0, arg1_19) and 3 or 1
	local var3_19 = table.contains(var7_0, arg1_19) or table.contains(var8_0, arg1_19)

	arg0_19:LoadAsset(var0_19, arg1_19, true, typeof(Object), function(arg0_20)
		if arg0_20 == nil then
			Debugger.LogError("can not find asset: " .. var0_19 .. " : " .. arg1_19)

			return
		end

		if not arg0_19.pools_plural[var1_19] then
			arg0_19.pools_plural[var1_19] = var1_0.New(arg0_20, var2_19)
		end

		existCall(arg2_19)
	end, var3_19)
end

function var0_0.ReturnUI(arg0_21, arg1_21, arg2_21)
	local var0_21 = "ui/" .. arg1_21
	local var1_21 = var0_21 .. arg1_21

	if IsNil(arg2_21) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_21))
	elseif arg0_21.pools_plural[var1_21] then
		if table.indexof(var6_0, arg1_21) then
			arg2_21.transform:SetParent(arg0_21.root, false)
		end

		if table.indexof(var7_0, arg1_21) or arg0_21.ui_tempCache[arg1_21] then
			setActiveViaLayer(arg2_21.transform, false)
			arg0_21.pools_plural[var1_21]:Enqueue(arg2_21)
		elseif table.indexof(var8_0, arg1_21) then
			setActiveViaLayer(arg2_21.transform, false)
			arg2_21:GetComponent(typeof(UIArchiver)):Clear()
			arg0_21.pools_plural[var1_21]:Enqueue(arg2_21)
		else
			arg0_21.pools_plural[var1_21]:Enqueue(arg2_21, true)

			if arg0_21.pools_plural[var1_21]:AllReturned() and (not arg0_21.callbacks[var1_21] or #arg0_21.callbacks[var1_21] == 0) then
				var5_0:ClearBundleRef(var0_21, true, true)
				arg0_21.pools_plural[var1_21]:Clear()

				arg0_21.pools_plural[var1_21] = nil
			end
		end
	else
		var4_0.Destroy(arg2_21)
	end
end

function var0_0.HasCacheUI(arg0_22, arg1_22)
	local var0_22 = ("ui/" .. arg1_22) .. arg1_22

	return arg0_22.pools_plural[var0_22] ~= nil
end

function var0_0.PreloadUI(arg0_23, arg1_23, arg2_23)
	local var0_23 = {}
	local var1_23 = ("ui/" .. arg1_23) .. arg1_23

	if not arg0_23.pools_plural[var1_23] then
		table.insert(var0_23, function(arg0_24)
			arg0_23:GetUI(arg1_23, true, function(arg0_25)
				arg0_23.pools_plural[var1_23]:Enqueue(arg0_25)
				arg0_24()
			end)
		end)
	end

	seriesAsync(var0_23, arg2_23)
end

function var0_0.AddTempCache(arg0_26, arg1_26)
	arg0_26.ui_tempCache[arg1_26] = true
end

function var0_0.DelTempCache(arg0_27, arg1_27)
	arg0_27.ui_tempCache[arg1_27] = nil
end

function var0_0.ClearAllTempCache(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.ui_tempCache) do
		if iter1_28 then
			local var0_28 = "ui/" .. iter0_28
			local var1_28 = var0_28 .. iter0_28

			if arg0_28.pools_plural[var1_28] then
				var5_0:ClearBundleRef(var0_28, true, true)
				arg0_28.pools_plural[var1_28]:Clear()

				arg0_28.pools_plural[var1_28] = nil
			end
		end
	end
end

function var0_0.PreloadPainting(arg0_29, arg1_29, arg2_29)
	local var0_29 = {}
	local var1_29 = ("painting/" .. arg1_29) .. arg1_29

	if not arg0_29.pools_plural[var1_29] then
		table.insert(var0_29, function(arg0_30)
			arg0_29:GetPainting(arg1_29, true, function(arg0_31)
				arg0_29.pools_plural[var1_29]:Enqueue(arg0_31)
				arg0_30()
			end)
		end)
	end

	seriesAsync(var0_29, arg2_29)
end

function var0_0.GetPainting(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = "painting/" .. arg1_32
	local var1_32 = var0_32 .. arg1_32

	arg0_32:FromPlural(var0_32, arg1_32, arg2_32, 1, function(arg0_33)
		arg0_33:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_32) then
			setActive(tf(arg0_33):Find("face"), true)
		end

		arg3_32(arg0_33)
	end, true)
end

function var0_0.ReturnPainting(arg0_34, arg1_34, arg2_34)
	local var0_34 = ("painting/" .. arg1_34) .. arg1_34

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
		var4_0.Destroy(arg2_34, true)
	end
end

function var0_0.ExcessPainting(arg0_35)
	local var0_35 = 0
	local var1_35 = 4
	local var2_35 = {}

	for iter0_35, iter1_35 in pairs(arg0_35.pools_plural) do
		local var3_35 = string.find(iter0_35, "painting/")

		if var3_35 and var3_35 >= 1 then
			table.insert(var2_35, iter0_35)
		end
	end

	if var1_35 < #var2_35 then
		table.sort(var2_35, function(arg0_36, arg1_36)
			return arg0_35.pools_plural[arg0_36].index > arg0_35.pools_plural[arg1_36].index
		end)

		for iter2_35 = var1_35 + 1, #var2_35 do
			local var4_35 = var2_35[iter2_35]

			arg0_35.pools_plural[var4_35]:Clear(true)

			arg0_35.pools_plural[var4_35] = nil
		end

		var5_0:unloadUnusedAssetBundles()

		arg0_35.paintingCount = arg0_35.paintingCount + 1

		if arg0_35.paintingCount > 10 then
			arg0_35.paintingCount = 0

			var5_0.Inst:ResUnloadAsync()
		end
	end
end

function var0_0.GetPaintingWithPrefix(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	local var0_37 = arg4_37 .. arg1_37
	local var1_37 = var0_37 .. arg1_37

	arg0_37:FromPlural(var0_37, arg1_37, arg2_37, 1, function(arg0_38)
		arg0_38:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_37) then
			setActive(tf(arg0_38):Find("face"), true)
		end

		arg3_37(arg0_38)
	end, true)
end

function var0_0.ReturnPaintingWithPrefix(arg0_39, arg1_39, arg2_39, arg3_39)
	local var0_39 = (arg3_39 .. arg1_39) .. arg1_39

	if IsNil(arg2_39) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_39))
	elseif arg0_39.pools_plural[var0_39] then
		setActiveViaLayer(arg2_39, true)

		local var1_39 = tf(arg2_39):Find("face")

		if var1_39 then
			setActive(var1_39, false)
		end

		arg2_39:SetActive(false)
		arg2_39.transform:SetParent(arg0_39.root, false)
		arg0_39.pools_plural[var0_39]:Enqueue(arg2_39)
		arg0_39:ExcessPainting()
	else
		var4_0.Destroy(arg2_39, true)
	end
end

function var0_0.GetSprite(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40)
	arg0_40:FromObjPack(arg1_40, tostring(arg2_40), arg3_40, typeof(Sprite), function(arg0_41)
		arg4_40(arg0_41)
	end)
end

function var0_0.DecreasSprite(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg1_42
	local var1_42 = typeof(Sprite)

	if arg0_42.pools_pack[var0_42] and arg0_42.pools_pack[var0_42].type == var1_42 then
		if arg0_42.pools_pack[var0_42]:Remove(arg2_42) then
			var5_0:ClearBundleRef(var0_42, false, false)
		end

		if arg0_42.pools_pack[var0_42]:GetAmount() <= 0 then
			arg0_42.pools_pack[var0_42]:Clear()

			arg0_42.pools_pack[var0_42] = nil
		end
	end
end

function var0_0.DestroySprite(arg0_43, arg1_43)
	local var0_43 = arg1_43
	local var1_43 = typeof(Sprite)

	if arg0_43.pools_pack[var0_43] and arg0_43.pools_pack[var0_43].type == var1_43 then
		local var2_43 = arg0_43.pools_pack[var0_43]:GetAmount()

		arg0_43.pools_pack[var0_43]:Clear()

		arg0_43.pools_pack[var0_43] = nil

		for iter0_43 = 1, var2_43 do
			var5_0:ClearBundleRef(var0_43, false, false)
		end
	end
end

function var0_0.DestroyAllSprite(arg0_44)
	local var0_44 = {}
	local var1_44 = typeof(Sprite)

	for iter0_44, iter1_44 in pairs(arg0_44.pools_pack) do
		if iter1_44.type == var1_44 and not arg0_44.preloads[iter0_44] then
			var0_44[iter0_44] = iter1_44
		end
	end

	for iter2_44, iter3_44 in pairs(var0_44) do
		local var2_44 = arg0_44.pools_pack[iter2_44]:GetAmount()

		arg0_44.pools_pack[iter2_44]:Clear()

		arg0_44.pools_pack[iter2_44] = nil

		for iter4_44 = 1, var2_44 do
			var5_0:ClearBundleRef(iter2_44, false, false)
		end
	end

	var5_0:unloadUnusedAssetBundles()
end

function var0_0.DisplayPoolPacks(arg0_45)
	local var0_45 = ""

	for iter0_45, iter1_45 in pairs(arg0_45.pools_pack) do
		for iter2_45, iter3_45 in pairs(iter1_45.items) do
			if #var0_45 > 0 then
				var0_45 = var0_45 .. "\n"
			end

			local var1_45 = _.map({
				iter0_45,
				"assetName:",
				iter2_45,
				"type:",
				iter1_45.type.FullName
			}, function(arg0_46)
				return tostring(arg0_46)
			end)

			var0_45 = var0_45 .. " " .. table.concat(var1_45, " ")
		end
	end

	warning(var0_45)
end

function var0_0.SpriteMemUsage(arg0_47)
	local var0_47 = 0
	local var1_47 = 9.5367431640625e-07
	local var2_47 = typeof(Sprite)

	for iter0_47, iter1_47 in pairs(arg0_47.pools_pack) do
		if iter1_47.type == var2_47 then
			local var3_47 = {}

			for iter2_47, iter3_47 in pairs(iter1_47.items) do
				local var4_47 = iter3_47.texture
				local var5_47 = var4_47.name

				if not var3_47[var5_47] then
					local var6_47 = 4
					local var7_47 = var4_47.format

					if var7_47 == TextureFormat.RGB24 then
						var6_47 = 3
					elseif var7_47 == TextureFormat.ARGB4444 or var7_47 == TextureFormat.RGBA4444 then
						var6_47 = 2
					elseif var7_47 == TextureFormat.DXT5 or var7_47 == TextureFormat.ETC2_RGBA8 then
						var6_47 = 1
					elseif var7_47 == TextureFormat.PVRTC_RGB4 or var7_47 == TextureFormat.PVRTC_RGBA4 or var7_47 == TextureFormat.ETC_RGB4 or var7_47 == TextureFormat.ETC2_RGB or var7_47 == TextureFormat.DXT1 then
						var6_47 = 0.5
					end

					var0_47 = var0_47 + var4_47.width * var4_47.height * var6_47 * var1_47
					var3_47[var5_47] = true
				end
			end
		end
	end

	return var0_47
end

local var9_0 = 64
local var10_0 = {
	"chapter/",
	"emoji/",
	"world/"
}

function var0_0.GetPrefab(arg0_48, arg1_48, arg2_48, arg3_48, arg4_48, arg5_48)
	local var0_48 = arg1_48 .. arg2_48

	arg0_48:FromPlural(arg1_48, arg2_48, arg3_48, arg5_48 or var9_0, function(arg0_49)
		if string.find(arg1_48, "emoji/") == 1 then
			local var0_49 = arg0_49:GetComponent(typeof(CriManaEffectUI))

			if var0_49 then
				var0_49:Pause(false)
			end
		end

		arg0_49:SetActive(true)
		tf(arg0_49):SetParent(arg0_48.root, false)
		arg4_48(arg0_49)
	end, true)
end

function var0_0.ReturnPrefab(arg0_50, arg1_50, arg2_50, arg3_50, arg4_50)
	local var0_50 = arg1_50 .. arg2_50

	if IsNil(arg3_50) then
		Debugger.LogError(debug.traceback("empty go: " .. arg2_50))
	elseif arg0_50.pools_plural[var0_50] then
		if string.find(arg1_50, "emoji/") == 1 then
			local var1_50 = arg3_50:GetComponent(typeof(CriManaEffectUI))

			if var1_50 then
				var1_50:Pause(true)
			end
		end

		arg3_50:SetActive(false)
		arg3_50.transform:SetParent(arg0_50.root, false)
		arg0_50.pools_plural[var0_50]:Enqueue(arg3_50)

		if arg4_50 and arg0_50.pools_plural[var0_50].balance <= 0 and (not arg0_50.callbacks[var0_50] or #arg0_50.callbacks[var0_50] == 0) then
			arg0_50:DestroyPrefab(arg1_50, arg2_50)
		end
	else
		var4_0.Destroy(arg3_50)
	end
end

function var0_0.DestroyPrefab(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg1_51 .. arg2_51

	if arg0_51.pools_plural[var0_51] then
		arg0_51.pools_plural[var0_51]:Clear()

		arg0_51.pools_plural[var0_51] = nil

		var5_0:ClearBundleRef(arg1_51, true, false)
	end
end

function var0_0.DestroyAllPrefab(arg0_52)
	local var0_52 = {}

	for iter0_52, iter1_52 in pairs(arg0_52.pools_plural) do
		if _.any(var10_0, function(arg0_53)
			return string.find(iter0_52, arg0_53) == 1
		end) then
			iter1_52:Clear()
			var5_0:ClearBundleRef(iter0_52, true, false)
			table.insert(var0_52, iter0_52)
		end
	end

	_.each(var0_52, function(arg0_54)
		arg0_52.pools_plural[arg0_54] = nil
	end)
end

function var0_0.DisplayPluralPools(arg0_55)
	local var0_55 = ""

	for iter0_55, iter1_55 in pairs(arg0_55.pools_plural) do
		if #var0_55 > 0 then
			var0_55 = var0_55 .. "\n"
		end

		local var1_55 = _.map({
			iter0_55,
			"balance",
			iter1_55.balance,
			"currentItmes",
			#iter1_55.items
		}, function(arg0_56)
			return tostring(arg0_56)
		end)

		var0_55 = var0_55 .. " " .. table.concat(var1_55, " ")
	end

	warning(var0_55)
end

function var0_0.GetPluralStatus(arg0_57, arg1_57)
	if not arg0_57.pools_plural[arg1_57] then
		return "NIL"
	end

	local var0_57 = arg0_57.pools_plural[arg1_57]
	local var1_57 = _.map({
		arg1_57,
		"balance",
		var0_57.balance,
		"currentItmes",
		#var0_57.items
	}, tostring)

	return table.concat(var1_57, " ")
end

function var0_0.FromPlural(arg0_58, arg1_58, arg2_58, arg3_58, arg4_58, arg5_58, arg6_58)
	local var0_58 = arg1_58 .. arg2_58

	local function var1_58()
		local var0_59 = arg0_58.pools_plural[var0_58]

		var0_59.index = arg0_58.pluralIndex
		arg0_58.pluralIndex = arg0_58.pluralIndex + 1

		arg5_58(var0_59:Dequeue())
	end

	if not arg0_58.pools_plural[var0_58] then
		arg0_58:LoadAsset(arg1_58, arg2_58, arg3_58, typeof(Object), function(arg0_60)
			if arg0_60 == nil then
				Debugger.LogError("can not find asset: " .. arg1_58 .. " : " .. arg2_58)

				return
			end

			if not arg0_58.pools_plural[var0_58] then
				arg0_58.pools_plural[var0_58] = var1_0.New(arg0_60, arg4_58)
			end

			var1_58()
		end, arg6_58)
	else
		var1_58()
	end
end

function var0_0.FromObjPack(arg0_61, arg1_61, arg2_61, arg3_61, arg4_61, arg5_61)
	local var0_61 = arg1_61

	if not arg0_61.pools_pack[var0_61] or not arg0_61.pools_pack[var0_61]:Get(arg2_61) then
		arg0_61:LoadAsset(arg1_61, arg2_61, arg3_61, arg4_61, function(arg0_62)
			if arg0_62 == nil then
				Debugger.LogError("can not find asset: " .. arg1_61 .. " : " .. arg2_61)

				return
			end

			if not arg0_61.pools_pack[var0_61] then
				arg0_61.pools_pack[var0_61] = var3_0.New(arg4_61)
			end

			if not arg0_61.pools_pack[var0_61]:Get(arg2_61) then
				arg0_61.pools_pack[var0_61]:Set(arg2_61, arg0_62)
			end

			arg5_61(arg0_62)
		end, false)
	else
		arg5_61(arg0_61.pools_pack[var0_61]:Get(arg2_61))
	end
end

function var0_0.LoadAsset(arg0_63, arg1_63, arg2_63, arg3_63, arg4_63, arg5_63, arg6_63)
	arg1_63, arg2_63 = HXSet.autoHxShiftPath(arg1_63, arg2_63)

	local var0_63 = arg1_63 .. arg2_63

	if arg0_63.callbacks[var0_63] then
		if not arg3_63 then
			errorMsg("Sync Loading after async operation")
		end

		table.insert(arg0_63.callbacks[var0_63], arg5_63)
	elseif arg3_63 then
		arg0_63.callbacks[var0_63] = {
			arg5_63
		}

		var5_0:getAssetAsync(arg1_63, arg2_63, arg4_63, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_64)
			if arg0_63.callbacks[var0_63] then
				local var0_64 = arg0_63.callbacks[var0_63]

				arg0_63.callbacks[var0_63] = nil

				while next(var0_64) do
					table.remove(var0_64)(arg0_64)
				end
			end
		end), arg6_63, false)
	else
		arg5_63(var5_0:getAssetSync(arg1_63, arg2_63, arg4_63, arg6_63, false))
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
