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

function var0_0.PreloadPainting(arg0_28, arg1_28, arg2_28)
	local var0_28 = {}
	local var1_28 = ("painting/" .. arg1_28) .. arg1_28

	if not arg0_28.pools_plural[var1_28] then
		table.insert(var0_28, function(arg0_29)
			arg0_28:GetPainting(arg1_28, true, function(arg0_30)
				arg0_28.pools_plural[var1_28]:Enqueue(arg0_30)
				arg0_29()
			end)
		end)
	end

	seriesAsync(var0_28, arg2_28)
end

function var0_0.GetPainting(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = "painting/" .. arg1_31
	local var1_31 = var0_31 .. arg1_31

	arg0_31:FromPlural(var0_31, arg1_31, arg2_31, 1, function(arg0_32)
		arg0_32:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_31) then
			setActive(tf(arg0_32):Find("face"), true)
		end

		arg3_31(arg0_32)
	end, true)
end

function var0_0.ReturnPainting(arg0_33, arg1_33, arg2_33)
	local var0_33 = ("painting/" .. arg1_33) .. arg1_33

	if IsNil(arg2_33) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_33))
	elseif arg0_33.pools_plural[var0_33] then
		setActiveViaLayer(arg2_33, true)

		local var1_33 = tf(arg2_33):Find("face")

		if var1_33 then
			setActive(var1_33, false)
		end

		arg2_33:SetActive(false)
		arg2_33.transform:SetParent(arg0_33.root, false)
		arg0_33.pools_plural[var0_33]:Enqueue(arg2_33)
		arg0_33:ExcessPainting()
	else
		var4_0.Destroy(arg2_33, true)
	end
end

function var0_0.ExcessPainting(arg0_34)
	local var0_34 = 0
	local var1_34 = 4
	local var2_34 = {}

	for iter0_34, iter1_34 in pairs(arg0_34.pools_plural) do
		local var3_34 = string.find(iter0_34, "painting/")

		if var3_34 and var3_34 >= 1 then
			table.insert(var2_34, iter0_34)
		end
	end

	if var1_34 < #var2_34 then
		table.sort(var2_34, function(arg0_35, arg1_35)
			return arg0_34.pools_plural[arg0_35].index > arg0_34.pools_plural[arg1_35].index
		end)

		for iter2_34 = var1_34 + 1, #var2_34 do
			local var4_34 = var2_34[iter2_34]

			arg0_34.pools_plural[var4_34]:Clear(true)

			arg0_34.pools_plural[var4_34] = nil
		end

		var5_0:unloadUnusedAssetBundles()

		arg0_34.paintingCount = arg0_34.paintingCount + 1

		if arg0_34.paintingCount > 10 then
			arg0_34.paintingCount = 0

			var5_0.Inst:ResUnloadAsync()
		end
	end
end

function var0_0.GetPaintingWithPrefix(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	local var0_36 = arg4_36 .. arg1_36
	local var1_36 = var0_36 .. arg1_36

	arg0_36:FromPlural(var0_36, arg1_36, arg2_36, 1, function(arg0_37)
		arg0_37:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_36) then
			setActive(tf(arg0_37):Find("face"), true)
		end

		arg3_36(arg0_37)
	end, true)
end

function var0_0.ReturnPaintingWithPrefix(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = (arg3_38 .. arg1_38) .. arg1_38

	if IsNil(arg2_38) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_38))
	elseif arg0_38.pools_plural[var0_38] then
		setActiveViaLayer(arg2_38, true)

		local var1_38 = tf(arg2_38):Find("face")

		if var1_38 then
			setActive(var1_38, false)
		end

		arg2_38:SetActive(false)
		arg2_38.transform:SetParent(arg0_38.root, false)
		arg0_38.pools_plural[var0_38]:Enqueue(arg2_38)
		arg0_38:ExcessPainting()
	else
		var4_0.Destroy(arg2_38, true)
	end
end

function var0_0.GetSprite(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	arg0_39:FromObjPack(arg1_39, tostring(arg2_39), arg3_39, typeof(Sprite), function(arg0_40)
		arg4_39(arg0_40)
	end)
end

function var0_0.DecreasSprite(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg1_41
	local var1_41 = typeof(Sprite)

	if arg0_41.pools_pack[var0_41] and arg0_41.pools_pack[var0_41].type == var1_41 then
		if arg0_41.pools_pack[var0_41]:Remove(arg2_41) then
			var5_0:ClearBundleRef(var0_41, false, false)
		end

		if arg0_41.pools_pack[var0_41]:GetAmount() <= 0 then
			arg0_41.pools_pack[var0_41]:Clear()

			arg0_41.pools_pack[var0_41] = nil
		end
	end
end

function var0_0.DestroySprite(arg0_42, arg1_42)
	local var0_42 = arg1_42
	local var1_42 = typeof(Sprite)

	if arg0_42.pools_pack[var0_42] and arg0_42.pools_pack[var0_42].type == var1_42 then
		local var2_42 = arg0_42.pools_pack[var0_42]:GetAmount()

		arg0_42.pools_pack[var0_42]:Clear()

		arg0_42.pools_pack[var0_42] = nil

		for iter0_42 = 1, var2_42 do
			var5_0:ClearBundleRef(var0_42, false, false)
		end
	end
end

function var0_0.DestroyAllSprite(arg0_43)
	local var0_43 = {}
	local var1_43 = typeof(Sprite)

	for iter0_43, iter1_43 in pairs(arg0_43.pools_pack) do
		if iter1_43.type == var1_43 and not arg0_43.preloads[iter0_43] then
			var0_43[iter0_43] = iter1_43
		end
	end

	for iter2_43, iter3_43 in pairs(var0_43) do
		local var2_43 = arg0_43.pools_pack[iter2_43]:GetAmount()

		arg0_43.pools_pack[iter2_43]:Clear()

		arg0_43.pools_pack[iter2_43] = nil

		for iter4_43 = 1, var2_43 do
			var5_0:ClearBundleRef(iter2_43, false, false)
		end
	end

	var5_0:unloadUnusedAssetBundles()
end

function var0_0.DisplayPoolPacks(arg0_44)
	local var0_44 = ""

	for iter0_44, iter1_44 in pairs(arg0_44.pools_pack) do
		for iter2_44, iter3_44 in pairs(iter1_44.items) do
			if #var0_44 > 0 then
				var0_44 = var0_44 .. "\n"
			end

			local var1_44 = _.map({
				iter0_44,
				"assetName:",
				iter2_44,
				"type:",
				iter1_44.type.FullName
			}, function(arg0_45)
				return tostring(arg0_45)
			end)

			var0_44 = var0_44 .. " " .. table.concat(var1_44, " ")
		end
	end

	warning(var0_44)
end

function var0_0.SpriteMemUsage(arg0_46)
	local var0_46 = 0
	local var1_46 = 9.5367431640625e-07
	local var2_46 = typeof(Sprite)

	for iter0_46, iter1_46 in pairs(arg0_46.pools_pack) do
		if iter1_46.type == var2_46 then
			local var3_46 = {}

			for iter2_46, iter3_46 in pairs(iter1_46.items) do
				local var4_46 = iter3_46.texture
				local var5_46 = var4_46.name

				if not var3_46[var5_46] then
					local var6_46 = 4
					local var7_46 = var4_46.format

					if var7_46 == TextureFormat.RGB24 then
						var6_46 = 3
					elseif var7_46 == TextureFormat.ARGB4444 or var7_46 == TextureFormat.RGBA4444 then
						var6_46 = 2
					elseif var7_46 == TextureFormat.DXT5 or var7_46 == TextureFormat.ETC2_RGBA8 then
						var6_46 = 1
					elseif var7_46 == TextureFormat.PVRTC_RGB4 or var7_46 == TextureFormat.PVRTC_RGBA4 or var7_46 == TextureFormat.ETC_RGB4 or var7_46 == TextureFormat.ETC2_RGB or var7_46 == TextureFormat.DXT1 then
						var6_46 = 0.5
					end

					var0_46 = var0_46 + var4_46.width * var4_46.height * var6_46 * var1_46
					var3_46[var5_46] = true
				end
			end
		end
	end

	return var0_46
end

local var9_0 = 64
local var10_0 = {
	"chapter/",
	"emoji/",
	"world/"
}

function var0_0.GetPrefab(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47, arg5_47)
	local var0_47 = arg1_47 .. arg2_47

	arg0_47:FromPlural(arg1_47, arg2_47, arg3_47, arg5_47 or var9_0, function(arg0_48)
		if string.find(arg1_47, "emoji/") == 1 then
			local var0_48 = arg0_48:GetComponent(typeof(CriManaEffectUI))

			if var0_48 then
				var0_48:Pause(false)
			end
		end

		arg0_48:SetActive(true)
		tf(arg0_48):SetParent(arg0_47.root, false)
		arg4_47(arg0_48)
	end, true)
end

function var0_0.ReturnPrefab(arg0_49, arg1_49, arg2_49, arg3_49, arg4_49)
	local var0_49 = arg1_49 .. arg2_49

	if IsNil(arg3_49) then
		Debugger.LogError(debug.traceback("empty go: " .. arg2_49))
	elseif arg0_49.pools_plural[var0_49] then
		if string.find(arg1_49, "emoji/") == 1 then
			local var1_49 = arg3_49:GetComponent(typeof(CriManaEffectUI))

			if var1_49 then
				var1_49:Pause(true)
			end
		end

		arg3_49:SetActive(false)
		arg3_49.transform:SetParent(arg0_49.root, false)
		arg0_49.pools_plural[var0_49]:Enqueue(arg3_49)

		if arg4_49 and arg0_49.pools_plural[var0_49].balance <= 0 and (not arg0_49.callbacks[var0_49] or #arg0_49.callbacks[var0_49] == 0) then
			arg0_49:DestroyPrefab(arg1_49, arg2_49)
		end
	else
		var4_0.Destroy(arg3_49)
	end
end

function var0_0.DestroyPrefab(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg1_50 .. arg2_50

	if arg0_50.pools_plural[var0_50] then
		arg0_50.pools_plural[var0_50]:Clear()

		arg0_50.pools_plural[var0_50] = nil

		var5_0:ClearBundleRef(arg1_50, true, false)
	end
end

function var0_0.DestroyAllPrefab(arg0_51)
	local var0_51 = {}

	for iter0_51, iter1_51 in pairs(arg0_51.pools_plural) do
		if _.any(var10_0, function(arg0_52)
			return string.find(iter0_51, arg0_52) == 1
		end) then
			iter1_51:Clear()
			var5_0:ClearBundleRef(iter0_51, true, false)
			table.insert(var0_51, iter0_51)
		end
	end

	_.each(var0_51, function(arg0_53)
		arg0_51.pools_plural[arg0_53] = nil
	end)
end

function var0_0.DisplayPluralPools(arg0_54)
	local var0_54 = ""

	for iter0_54, iter1_54 in pairs(arg0_54.pools_plural) do
		if #var0_54 > 0 then
			var0_54 = var0_54 .. "\n"
		end

		local var1_54 = _.map({
			iter0_54,
			"balance",
			iter1_54.balance,
			"currentItmes",
			#iter1_54.items
		}, function(arg0_55)
			return tostring(arg0_55)
		end)

		var0_54 = var0_54 .. " " .. table.concat(var1_54, " ")
	end

	warning(var0_54)
end

function var0_0.GetPluralStatus(arg0_56, arg1_56)
	if not arg0_56.pools_plural[arg1_56] then
		return "NIL"
	end

	local var0_56 = arg0_56.pools_plural[arg1_56]
	local var1_56 = _.map({
		arg1_56,
		"balance",
		var0_56.balance,
		"currentItmes",
		#var0_56.items
	}, tostring)

	return table.concat(var1_56, " ")
end

function var0_0.FromPlural(arg0_57, arg1_57, arg2_57, arg3_57, arg4_57, arg5_57, arg6_57)
	local var0_57 = arg1_57 .. arg2_57

	local function var1_57()
		local var0_58 = arg0_57.pools_plural[var0_57]

		var0_58.index = arg0_57.pluralIndex
		arg0_57.pluralIndex = arg0_57.pluralIndex + 1

		arg5_57(var0_58:Dequeue())
	end

	if not arg0_57.pools_plural[var0_57] then
		arg0_57:LoadAsset(arg1_57, arg2_57, arg3_57, typeof(Object), function(arg0_59)
			if arg0_59 == nil then
				Debugger.LogError("can not find asset: " .. arg1_57 .. " : " .. arg2_57)

				return
			end

			if not arg0_57.pools_plural[var0_57] then
				arg0_57.pools_plural[var0_57] = var1_0.New(arg0_59, arg4_57)
			end

			var1_57()
		end, arg6_57)
	else
		var1_57()
	end
end

function var0_0.FromObjPack(arg0_60, arg1_60, arg2_60, arg3_60, arg4_60, arg5_60)
	local var0_60 = arg1_60

	if not arg0_60.pools_pack[var0_60] or not arg0_60.pools_pack[var0_60]:Get(arg2_60) then
		arg0_60:LoadAsset(arg1_60, arg2_60, arg3_60, arg4_60, function(arg0_61)
			if not arg0_60.pools_pack[var0_60] then
				arg0_60.pools_pack[var0_60] = var3_0.New(arg4_60)
			end

			if not arg0_60.pools_pack[var0_60]:Get(arg2_60) then
				arg0_60.pools_pack[var0_60]:Set(arg2_60, arg0_61)
			end

			arg5_60(arg0_61)
		end, false)
	else
		arg5_60(arg0_60.pools_pack[var0_60]:Get(arg2_60))
	end
end

function var0_0.LoadAsset(arg0_62, arg1_62, arg2_62, arg3_62, arg4_62, arg5_62, arg6_62)
	arg1_62, arg2_62 = HXSet.autoHxShiftPath(arg1_62, arg2_62)

	local var0_62 = arg1_62 .. arg2_62

	if arg0_62.callbacks[var0_62] then
		if not arg3_62 then
			errorMsg("Sync Loading after async operation")
		end

		table.insert(arg0_62.callbacks[var0_62], arg5_62)
	elseif arg3_62 then
		arg0_62.callbacks[var0_62] = {
			arg5_62
		}

		var5_0:getAssetAsync(arg1_62, arg2_62, arg4_62, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_63)
			if arg0_62.callbacks[var0_62] then
				local var0_63 = arg0_62.callbacks[var0_62]

				arg0_62.callbacks[var0_62] = nil

				while next(var0_63) do
					table.remove(var0_63)(arg0_63)
				end
			end
		end), arg6_62, false)
	else
		arg5_62(var5_0:getAssetSync(arg1_62, arg2_62, arg4_62, arg6_62, false))
	end
end

function var0_0.PrintPools(arg0_64)
	local var0_64 = ""

	for iter0_64, iter1_64 in pairs(arg0_64.pools_plural) do
		var0_64 = var0_64 .. "\n" .. iter0_64
	end

	warning(var0_64)
end

function var0_0.PrintObjPack(arg0_65)
	local var0_65 = ""

	for iter0_65, iter1_65 in pairs(arg0_65.pools_pack) do
		for iter2_65, iter3_65 in pairs(iter1_65.items) do
			var0_65 = var0_65 .. "\n" .. iter0_65 .. " " .. iter2_65
		end
	end

	warning(var0_65)
end

return var0_0
