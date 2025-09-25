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

function var0_0.RegisterUIConst(arg0_15)
	for iter0_15, iter1_15 in ipairs(var7_0) do
		arg0_15:KeepUICache(iter1_15, true)
	end
end

function var0_0.GetUI(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = "ui/" .. arg1_16
	local var1_16 = var6_0[arg1_16] or 1

	arg0_16:FromPlural(var0_16, "", arg2_16, var1_16, arg3_16)
end

function var0_0.ReturnUI(arg0_17, arg1_17, arg2_17)
	local var0_17 = "ui/" .. arg1_17

	if IsNil(arg2_17) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_17))
	elseif arg0_17.pools_plural[var0_17] then
		setActiveViaLayer(arg2_17, false)
		arg2_17.transform:SetParent(arg0_17.root, false)
		arg0_17.pools_plural[var0_17]:Enqueue(arg2_17, true)

		if arg0_17.pools_plural[var0_17]:AllReturned() and (not arg0_17.callbacks[var0_17] or #arg0_17.callbacks[var0_17] == 0) then
			arg0_17.pools_plural[var0_17]:Clear()

			arg0_17.pools_plural[var0_17] = nil
		end
	else
		var4_0.Destroy(arg2_17)
	end
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

function var0_0.KeepUICache(arg0_21, arg1_21, arg2_21)
	local var0_21 = "ui/" .. arg1_21

	arg0_21.keepDic[var0_21] = arg2_21 or nil

	if arg0_21.pools_plural[var0_21] then
		arg0_21.pools_plural[var0_21]:SetKeep(tobool(arg0_21.keepDic[var0_21]))

		if arg0_21.pools_plural[var0_21]:AllReturned() and (not arg0_21.callbacks[var0_21] or #arg0_21.callbacks[var0_21] == 0) then
			arg0_21.pools_plural[var0_21]:Clear()

			arg0_21.pools_plural[var0_21] = nil
		end
	end
end

function var0_0.PreloadPainting(arg0_22, arg1_22, arg2_22)
	local var0_22 = {}
	local var1_22 = "painting/" .. arg1_22

	if not arg0_22.pools_plural[var1_22] then
		table.insert(var0_22, function(arg0_23)
			arg0_22:GetPainting(arg1_22, true, function(arg0_24)
				arg0_22.pools_plural[var1_22]:Enqueue(arg0_24)
				arg0_23()
			end)
		end)
	end

	seriesAsync(var0_22, arg2_22)
end

function var0_0.GetPainting(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = "painting/" .. arg1_25
	local var1_25 = var0_25

	arg0_25:FromPlural(var0_25, "", arg2_25, 1, function(arg0_26)
		arg0_26:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_25) then
			setActive(tf(arg0_26):Find("face"), true)
		end

		arg3_25(arg0_26)
	end)
end

function var0_0.ReturnPainting(arg0_27, arg1_27, arg2_27)
	local var0_27 = "painting/" .. arg1_27

	if IsNil(arg2_27) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1_27))
	elseif arg0_27.pools_plural[var0_27] then
		setActiveViaLayer(arg2_27, true)

		local var1_27 = tf(arg2_27):Find("face")

		if var1_27 then
			setActive(var1_27, false)
		end

		arg2_27:SetActive(false)
		arg2_27.transform:SetParent(arg0_27.root, false)
		arg0_27.pools_plural[var0_27]:Enqueue(arg2_27)
		arg0_27:ExcessPainting()
	else
		var4_0.Destroy(arg2_27)
	end
end

function var0_0.ExcessPainting(arg0_28, arg1_28)
	local var0_28 = 0
	local var1_28 = 4
	local var2_28 = {}

	for iter0_28, iter1_28 in pairs(arg0_28.pools_plural) do
		local var3_28 = string.find(iter0_28, "painting/")

		if var3_28 and var3_28 >= 1 then
			table.insert(var2_28, iter0_28)
		end
	end

	if var1_28 < #var2_28 then
		table.sort(var2_28, function(arg0_29, arg1_29)
			return arg0_28.pools_plural[arg0_29].index > arg0_28.pools_plural[arg1_29].index
		end)

		for iter2_28 = var1_28 + 1, #var2_28 do
			local var4_28 = var2_28[iter2_28]

			arg0_28.pools_plural[var4_28]:Clear(true)

			arg0_28.pools_plural[var4_28] = nil
		end

		arg0_28.paintingCount = arg0_28.paintingCount + 1
	end

	if arg1_28 then
		arg0_28.paintingCount = 0
	elseif arg0_28.paintingCount >= 10 then
		arg0_28.paintingCount = 0

		gcAll(false)
	end
end

function var0_0.GetPaintingWithPrefix(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
	local var0_30 = arg4_30 .. arg1_30
	local var1_30 = var0_30

	arg0_30:FromPlural(var0_30, "", arg2_30, 1, function(arg0_31)
		arg0_31:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1_30) then
			setActive(tf(arg0_31):Find("face"), true)
		end

		arg3_30(arg0_31)
	end)
end

function var0_0.ReturnPaintingWithPrefix(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = arg3_32 .. arg1_32

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
		var4_0.Destroy(arg2_32)
	end
end

function var0_0.GetSprite(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	arg0_33:FromObjPack(arg1_33, tostring(arg2_33), typeof(Sprite), arg3_33, function(arg0_34)
		arg4_33(arg0_34)
	end)
end

function var0_0.DecreasSprite(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg1_35

	if arg0_35.pools_pack[var0_35] then
		arg0_35.pools_pack[var0_35]:Remove(arg2_35)

		if arg0_35.pools_pack[var0_35]:GetAmount() <= 0 then
			arg0_35:RemovePoolsPack(var0_35)
		end
	end
end

function var0_0.DestroySprite(arg0_36, arg1_36)
	arg0_36:RemovePoolsPack(arg1_36)
end

function var0_0.DestroyAllSprite(arg0_37)
	local var0_37 = arg0_37:SpriteMemUsage()
	local var1_37 = 24

	print("cached sprite size: " .. math.ceil(var0_37 * 10) / 10 .. "/" .. var1_37 .. "MB")

	for iter0_37, iter1_37 in pairs(arg0_37.pools_pack) do
		arg0_37:RemovePoolsPack(iter0_37)
	end

	var5_0:unloadUnusedAssetBundles()
end

function var0_0.DisplayPoolPacks(arg0_38)
	local var0_38

	for iter0_38, iter1_38 in pairs(arg0_38.pools_pack) do
		table.insert(var0_38, iter0_38)

		for iter2_38, iter3_38 in pairs(iter1_38.items) do
			table.insert(var0_38, string.format("assetName:%s type:%s", iter2_38, tostring(iter1_38.type.FullName)))
		end
	end

	warning(table.concat(var0_38, "\n"))
end

function var0_0.SpriteMemUsage(arg0_39)
	local var0_39 = 0
	local var1_39 = 9.5367431640625e-07
	local var2_39 = typeof(Sprite)

	for iter0_39, iter1_39 in pairs(arg0_39.pools_pack) do
		local var3_39 = {}

		for iter2_39, iter3_39 in pairs(iter1_39.items) do
			if iter1_39.typeDic[iter2_39] == var2_39 then
				local var4_39 = iter1_39.items[iter2_39].texture
				local var5_39 = var4_39.name

				if not var3_39[var5_39] then
					local var6_39 = 4
					local var7_39 = var4_39.format

					if var7_39 == TextureFormat.RGB24 then
						var6_39 = 3
					elseif var7_39 == TextureFormat.ARGB4444 or var7_39 == TextureFormat.RGBA4444 then
						var6_39 = 2
					elseif var7_39 == TextureFormat.DXT5 or var7_39 == TextureFormat.ASTC_4x4 or var7_39 == TextureFormat.ETC2_RGBA8 then
						var6_39 = 1
					elseif var7_39 == TextureFormat.PVRTC_RGB4 or var7_39 == TextureFormat.PVRTC_RGBA4 or var7_39 == TextureFormat.ETC_RGB4 or var7_39 == TextureFormat.ETC2_RGB or var7_39 == TextureFormat.ASTC_6x6 or var7_39 == TextureFormat.DXT1 then
						var6_39 = 0.5
					end

					var0_39 = var0_39 + var4_39.width * var4_39.height * var6_39 * var1_39 / 8
					var3_39[var5_39] = true
				end
			end
		end
	end

	return var0_39
end

local var8_0 = 64
local var9_0 = {
	"chapter/",
	"emoji/",
	"world/"
}

function var0_0.GetPrefab(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40, arg5_40)
	local var0_40 = arg1_40

	arg0_40:FromPlural(arg1_40, "", arg3_40, arg5_40 or var8_0, function(arg0_41)
		if string.find(arg1_40, "emoji/") == 1 then
			local var0_41 = arg0_41:GetComponent(typeof(CriManaEffectUI))

			if var0_41 then
				var0_41:Pause(false)
			end
		end

		arg0_41:SetActive(true)
		tf(arg0_41):SetParent(arg0_40.root, false)
		arg4_40(arg0_41)
	end)
end

function var0_0.ReturnPrefab(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42)
	local var0_42 = arg1_42

	if IsNil(arg3_42) then
		Debugger.LogError(debug.traceback("empty go: " .. arg2_42))
	elseif arg0_42.pools_plural[var0_42] then
		if string.find(arg1_42, "emoji/") == 1 then
			local var1_42 = arg3_42:GetComponent(typeof(CriManaEffectUI))

			if var1_42 then
				var1_42:Pause(true)
			end
		end

		arg3_42:SetActive(false)
		arg3_42.transform:SetParent(arg0_42.root, false)
		arg0_42.pools_plural[var0_42]:Enqueue(arg3_42)

		if arg4_42 and arg0_42.pools_plural[var0_42].balance <= 0 and (not arg0_42.callbacks[var0_42] or #arg0_42.callbacks[var0_42] == 0) then
			arg0_42:DestroyPrefab(arg1_42, arg2_42)
		end
	else
		var4_0.Destroy(arg3_42)
	end
end

function var0_0.DestroyPrefab(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg1_43

	if arg0_43.pools_plural[var0_43] then
		arg0_43.pools_plural[var0_43]:Clear()

		arg0_43.pools_plural[var0_43] = nil
	end
end

function var0_0.DestroyAllPrefab(arg0_44)
	local var0_44 = {}

	for iter0_44, iter1_44 in pairs(arg0_44.pools_plural) do
		if _.any(var9_0, function(arg0_45)
			return string.find(iter0_44, arg0_45) == 1
		end) then
			iter1_44:Clear()
			table.insert(var0_44, iter0_44)
		end
	end

	_.each(var0_44, function(arg0_46)
		arg0_44.pools_plural[arg0_46] = nil
	end)
end

function var0_0.DisplayPluralPools(arg0_47)
	local var0_47 = ""

	for iter0_47, iter1_47 in pairs(arg0_47.pools_plural) do
		if #var0_47 > 0 then
			var0_47 = var0_47 .. "\n"
		end

		local var1_47 = _.map({
			iter0_47,
			"balance",
			iter1_47.balance,
			"currentItmes",
			#iter1_47.items
		}, function(arg0_48)
			return tostring(arg0_48)
		end)

		var0_47 = var0_47 .. " " .. table.concat(var1_47, " ")
	end

	warning(var0_47)
end

function var0_0.GetPluralStatus(arg0_49, arg1_49)
	if not arg0_49.pools_plural[arg1_49] then
		return "NIL"
	end

	local var0_49 = arg0_49.pools_plural[arg1_49]
	local var1_49 = _.map({
		arg1_49,
		"balance",
		var0_49.balance,
		"currentItmes",
		#var0_49.items
	}, tostring)

	return table.concat(var1_49, " ")
end

function var0_0.FromPlural(arg0_50, arg1_50, arg2_50, arg3_50, arg4_50, arg5_50)
	local var0_50 = arg2_50 == "" and arg1_50 or arg1_50 .. "|" .. arg2_50
	local var1_50 = {}

	if not arg0_50.pools_plural[var0_50] then
		table.insert(var1_50, function(arg0_51)
			arg0_50:LoadAsset(arg1_50, arg2_50, typeof(Object), arg3_50, function(arg0_52)
				if arg0_52 == nil then
					Debugger.LogError("can not find asset: " .. arg1_50 .. " : " .. arg2_50)

					return
				end

				if not arg0_50.pools_plural[var0_50] then
					arg0_50.pools_plural[var0_50] = var1_0.New(arg0_52, arg4_50)

					arg0_50.pools_plural[var0_50]:SetKeep(tobool(arg0_50.keepDic[var0_50]))
				end

				arg0_51()
			end, true)
		end)
	end

	seriesAsync(var1_50, function()
		local var0_53 = arg0_50.pools_plural[var0_50]

		var0_53.index = arg0_50.pluralIndex
		arg0_50.pluralIndex = arg0_50.pluralIndex + 1

		arg5_50(var0_53:Dequeue())
	end)
end

function var0_0.FromObjPack(arg0_54, arg1_54, arg2_54, arg3_54, arg4_54, arg5_54)
	local var0_54 = arg1_54
	local var1_54 = {}

	if not arg0_54.pools_pack[var0_54] then
		table.insert(var1_54, function(arg0_55)
			AssetBundleHelper.LoadAssetBundle(arg1_54, arg4_54, true, function(arg0_56)
				arg0_54:AddPoolsPack(arg1_54, arg0_56)
				arg0_55()
			end)
		end)
	end

	seriesAsync(var1_54, function()
		arg5_54(arg0_54.pools_pack[var0_54]:Get(arg2_54, arg3_54))
	end)
end

function var0_0.LoadAsset(arg0_58, arg1_58, arg2_58, arg3_58, arg4_58, arg5_58, arg6_58)
	arg1_58, arg2_58 = HXSet.autoHxShiftPath(arg1_58, arg2_58)

	local var0_58 = arg1_58 .. "|" .. arg2_58

	if arg0_58.callbacks[var0_58] then
		if not arg4_58 then
			errorMsg("Sync Loading after async operation")
		end

		table.insert(arg0_58.callbacks[var0_58], arg5_58)
	elseif arg4_58 then
		arg0_58.callbacks[var0_58] = {
			arg5_58
		}

		var5_0:getAssetAsync(arg1_58, arg2_58, arg3_58, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_59)
			if arg0_58.callbacks[var0_58] then
				local var0_59 = arg0_58.callbacks[var0_58]

				arg0_58.callbacks[var0_58] = nil

				while next(var0_59) do
					table.remove(var0_59)(arg0_59)
				end
			end
		end), arg6_58, false)
	else
		arg5_58(var5_0:getAssetSync(arg1_58, arg2_58, arg3_58, arg6_58, false))
	end
end

function var0_0.AddPoolsPack(arg0_60, arg1_60, arg2_60)
	if arg0_60.pools_pack[arg1_60] then
		arg2_60:Dispose()
	else
		arg0_60.pools_pack[arg1_60] = var3_0.New(arg1_60, arg2_60)
	end
end

function var0_0.RemovePoolsPack(arg0_61, arg1_61)
	if not arg0_61.pools_pack[arg1_61] or arg0_61.preloadDic[arg1_61] then
		return
	end

	arg0_61.pools_pack[arg1_61]:Clear()

	arg0_61.pools_pack[arg1_61] = nil
end

function var0_0.PrintPools(arg0_62)
	local var0_62 = ""

	for iter0_62, iter1_62 in pairs(arg0_62.pools_plural) do
		var0_62 = var0_62 .. "\n" .. iter0_62
	end

	warning(var0_62)
end

function var0_0.PrintObjPack(arg0_63)
	local var0_63 = {}

	for iter0_63, iter1_63 in pairs(arg0_63.pools_pack) do
		table.insert(var0_63, iter0_63)

		for iter2_63, iter3_63 in pairs(iter1_63.items) do
			table.insert(var0_63, "    :" .. iter2_63)
		end
	end

	warning(table.concat(var0_63, "\n"))
end

return var0_0
