local var0 = singletonClass("PoolMgr")

pg = pg or {}
pg.PoolMgr = var0
PoolMgr = var0

local var1 = require("Mgr/Pool/PoolPlural")
local var2 = require("Mgr/Pool/PoolSingleton")
local var3 = require("Mgr/Pool/PoolObjPack")
local var4 = require("Mgr/Pool/PoolUtil")
local var5 = ResourceMgr.Inst

function var0.Ctor(arg0)
	arg0.root = GameObject.New("__Pool__").transform
	arg0.pools_plural = {}
	arg0.pools_pack = {}
	arg0.callbacks = {}
	arg0.pluralIndex = 0
	arg0.singleIndex = 0
	arg0.paintingCount = 0
	arg0.commanderPaintingCount = 0
	arg0.preloads = {
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
	arg0.ui_tempCache = {}
end

function var0.Init(arg0, arg1)
	print("initializing pool manager...")

	local var0 = 0
	local var1 = table.getCount(arg0.preloads)

	local function var2()
		var0 = var0 + 1

		if var0 == var1 then
			arg1()
		end
	end

	for iter0, iter1 in pairs(arg0.preloads) do
		if #iter1 > 0 then
			local var3 = typeof(Sprite)
			local var4 = false

			local function var5(arg0)
				return
			end

			buildTempAB(iter0, function(arg0)
				for iter0, iter1 in ipairs(iter1) do
					local var0 = arg0:LoadAssetSync(iter1, var3, var4, false)
					local var1 = iter0
					local var2 = iter1

					if arg0.pools_pack[var1] and arg0.pools_pack[var1]:Get(var2) then
						var5(arg0.pools_pack[var1]:Get(var2))
					else
						if not arg0.pools_pack[var1] then
							arg0.pools_pack[var1] = var3.New(var3)
						end

						if not arg0.pools_pack[var1]:Get(var2) then
							arg0.pools_pack[var1]:Set(var2, var0)
						end

						var5(var0)
					end
				end

				var2()
			end)
		else
			buildTempAB(iter0, function(arg0)
				var2()
			end)
		end
	end
end

function var0.GetSpineChar(arg0, arg1, arg2, arg3)
	local var0 = ("char/" .. arg1) .. arg1

	local function var1()
		local var0 = arg0.pools_plural[var0]

		var0.index = arg0.pluralIndex
		arg0.pluralIndex = arg0.pluralIndex + 1

		local var1 = var0:Dequeue()

		var1:SetActive(true)
		arg3(var1)
	end

	if not arg0.pools_plural[var0] then
		arg0:GetSpineSkel(arg1, arg2, function(arg0)
			assert(arg0 ~= nil, "Spine角色不存在: " .. arg1)

			if not arg0.pools_plural[var0] then
				arg0 = SpineAnimUI.AnimChar(arg1, arg0)

				arg0:SetActive(false)
				tf(arg0):SetParent(arg0.root, false)

				local var0 = arg0:GetComponent("SkeletonGraphic")

				var0.material = var0.skeletonDataAsset.atlasAssets[0].materials[0]
				arg0.pools_plural[var0] = var1.New(arg0, 1)
			end

			var1()
		end)
	else
		var1()
	end
end

function var0.ReturnSpineChar(arg0, arg1, arg2)
	local var0 = ("char/" .. arg1) .. arg1

	if IsNil(arg2) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1))
	elseif arg0.pools_plural[var0] then
		if arg2:GetComponent("SkeletonGraphic").allowMultipleCanvasRenderers then
			UIUtil.ClearChildren(arg2, {
				"Renderer"
			})
		else
			UIUtil.ClearChildren(arg2)
		end

		setActiveViaLayer(arg2.transform, true)
		arg2:SetActive(false)
		arg2.transform:SetParent(arg0.root, false)

		arg2.transform.localPosition = Vector3.New(0, 0, 0)
		arg2.transform.localScale = Vector3.New(0.5, 0.5, 1)
		arg2.transform.localRotation = Quaternion.identity

		arg0.pools_plural[var0]:Enqueue(arg2)
		arg0:ExcessSpineChar()
	else
		var4.Destroy(arg2)
	end
end

function var0.ExcessSpineChar(arg0)
	local var0 = 0
	local var1 = 6
	local var2 = {}

	for iter0, iter1 in pairs(arg0.pools_plural) do
		if string.find(iter0, "char/") == 1 then
			table.insert(var2, iter0)
		end
	end

	if var1 < #var2 then
		table.sort(var2, function(arg0, arg1)
			return arg0.pools_plural[arg0].index > arg0.pools_plural[arg1].index
		end)

		for iter2 = var1 + 1, #var2 do
			local var3 = var2[iter2]

			arg0.pools_plural[var3]:Clear()

			arg0.pools_plural[var3] = nil
		end
	end
end

function var0.GetSpineSkel(arg0, arg1, arg2, arg3)
	local var0, var1 = HXSet.autoHxShiftPath("char/" .. arg1, arg1)
	local var2 = var1 .. "_SkeletonData"

	arg0:LoadAsset(var0, var2, arg2, typeof(Object), function(arg0)
		arg3(arg0)
	end, true)
end

function var0.IsSpineSkelCached(arg0, arg1)
	local var0 = ("char/" .. arg1) .. arg1

	return arg0.pools_plural[var0] ~= nil
end

local var6 = {
	"ResPanel",
	"WorldResPanel"
}
local var7 = {
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
local var8 = {}

function var0.GetUI(arg0, arg1, arg2, arg3)
	local var0 = "ui/" .. arg1
	local var1 = table.contains(var6, arg1) and 3 or 1
	local var2 = table.contains(var7, arg1) or table.contains(var8, arg1)

	arg0:FromPlural(var0, arg1, arg2, var1, function(arg0)
		local function var0()
			arg3(arg0)
		end

		if table.indexof(var8, arg1) then
			local var1 = var0 .. arg1

			arg0.pools_plural[var1].prefab:GetComponent(typeof(UIArchiver)):Clear()
			arg0:GetComponent(typeof(UIArchiver)):Load(var0)
		else
			var0()
		end
	end, var2)
end

function var0.BuildUIPlural(arg0, arg1, arg2)
	local var0 = "ui/" .. arg1
	local var1 = var0 .. arg1

	if arg0.pools_plural[var1] then
		return
	end

	local var2 = table.contains(var6, arg1) and 3 or 1
	local var3 = table.contains(var7, arg1) or table.contains(var8, arg1)

	arg0:LoadAsset(var0, arg1, true, typeof(Object), function(arg0)
		if arg0 == nil then
			Debugger.LogError("can not find asset: " .. var0 .. " : " .. arg1)

			return
		end

		if not arg0.pools_plural[var1] then
			arg0.pools_plural[var1] = var1.New(arg0, var2)
		end

		existCall(arg2)
	end, var3)
end

function var0.ReturnUI(arg0, arg1, arg2)
	local var0 = "ui/" .. arg1
	local var1 = var0 .. arg1

	if IsNil(arg2) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1))
	elseif arg0.pools_plural[var1] then
		if table.indexof(var6, arg1) then
			arg2.transform:SetParent(arg0.root, false)
		end

		if table.indexof(var7, arg1) or arg0.ui_tempCache[arg1] then
			setActiveViaLayer(arg2.transform, false)
			arg0.pools_plural[var1]:Enqueue(arg2)
		elseif table.indexof(var8, arg1) then
			setActiveViaLayer(arg2.transform, false)
			arg2:GetComponent(typeof(UIArchiver)):Clear()
			arg0.pools_plural[var1]:Enqueue(arg2)
		else
			arg0.pools_plural[var1]:Enqueue(arg2, true)

			if arg0.pools_plural[var1]:AllReturned() and (not arg0.callbacks[var1] or #arg0.callbacks[var1] == 0) then
				var5:ClearBundleRef(var0, true, true)
				arg0.pools_plural[var1]:Clear()

				arg0.pools_plural[var1] = nil
			end
		end
	else
		var4.Destroy(arg2)
	end
end

function var0.HasCacheUI(arg0, arg1)
	local var0 = ("ui/" .. arg1) .. arg1

	return arg0.pools_plural[var0] ~= nil
end

function var0.PreloadUI(arg0, arg1, arg2)
	local var0 = {}
	local var1 = ("ui/" .. arg1) .. arg1

	if not arg0.pools_plural[var1] then
		table.insert(var0, function(arg0)
			arg0:GetUI(arg1, true, function(arg0)
				arg0.pools_plural[var1]:Enqueue(arg0)
				arg0()
			end)
		end)
	end

	seriesAsync(var0, arg2)
end

function var0.AddTempCache(arg0, arg1)
	arg0.ui_tempCache[arg1] = true
end

function var0.DelTempCache(arg0, arg1)
	arg0.ui_tempCache[arg1] = nil
end

function var0.PreloadPainting(arg0, arg1, arg2)
	local var0 = {}
	local var1 = ("painting/" .. arg1) .. arg1

	if not arg0.pools_plural[var1] then
		table.insert(var0, function(arg0)
			arg0:GetPainting(arg1, true, function(arg0)
				arg0.pools_plural[var1]:Enqueue(arg0)
				arg0()
			end)
		end)
	end

	seriesAsync(var0, arg2)
end

function var0.GetPainting(arg0, arg1, arg2, arg3)
	local var0 = "painting/" .. arg1
	local var1 = var0 .. arg1

	arg0:FromPlural(var0, arg1, arg2, 1, function(arg0)
		arg0:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1) then
			setActive(tf(arg0):Find("face"), true)
		end

		arg3(arg0)
	end, true)
end

function var0.ReturnPainting(arg0, arg1, arg2)
	local var0 = ("painting/" .. arg1) .. arg1

	if IsNil(arg2) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1))
	elseif arg0.pools_plural[var0] then
		setActiveViaLayer(arg2, true)

		local var1 = tf(arg2):Find("face")

		if var1 then
			setActive(var1, false)
		end

		arg2:SetActive(false)
		arg2.transform:SetParent(arg0.root, false)
		arg0.pools_plural[var0]:Enqueue(arg2)
		arg0:ExcessPainting()
	else
		var4.Destroy(arg2, true)
	end
end

function var0.ExcessPainting(arg0)
	local var0 = 0
	local var1 = 4
	local var2 = {}

	for iter0, iter1 in pairs(arg0.pools_plural) do
		local var3 = string.find(iter0, "painting/")

		if var3 and var3 >= 1 then
			table.insert(var2, iter0)
		end
	end

	if var1 < #var2 then
		table.sort(var2, function(arg0, arg1)
			return arg0.pools_plural[arg0].index > arg0.pools_plural[arg1].index
		end)

		for iter2 = var1 + 1, #var2 do
			local var4 = var2[iter2]

			arg0.pools_plural[var4]:Clear(true)

			arg0.pools_plural[var4] = nil
		end

		var5:unloadUnusedAssetBundles()

		arg0.paintingCount = arg0.paintingCount + 1

		if arg0.paintingCount > 10 then
			arg0.paintingCount = 0

			var5.Inst:ResUnloadAsync()
		end
	end
end

function var0.GetPaintingWithPrefix(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg4 .. arg1
	local var1 = var0 .. arg1

	arg0:FromPlural(var0, arg1, arg2, 1, function(arg0)
		arg0:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(arg1) then
			setActive(tf(arg0):Find("face"), true)
		end

		arg3(arg0)
	end, true)
end

function var0.ReturnPaintingWithPrefix(arg0, arg1, arg2, arg3)
	local var0 = (arg3 .. arg1) .. arg1

	if IsNil(arg2) then
		Debugger.LogError(debug.traceback("empty go: " .. arg1))
	elseif arg0.pools_plural[var0] then
		setActiveViaLayer(arg2, true)

		local var1 = tf(arg2):Find("face")

		if var1 then
			setActive(var1, false)
		end

		arg2:SetActive(false)
		arg2.transform:SetParent(arg0.root, false)
		arg0.pools_plural[var0]:Enqueue(arg2)
		arg0:ExcessPainting()
	else
		var4.Destroy(arg2, true)
	end
end

function var0.GetSprite(arg0, arg1, arg2, arg3, arg4)
	arg0:FromObjPack(arg1, tostring(arg2), arg3, typeof(Sprite), function(arg0)
		arg4(arg0)
	end)
end

function var0.DecreasSprite(arg0, arg1, arg2)
	local var0 = arg1
	local var1 = typeof(Sprite)

	if arg0.pools_pack[var0] and arg0.pools_pack[var0].type == var1 then
		if arg0.pools_pack[var0]:Remove(arg2) then
			var5:ClearBundleRef(var0, false, false)
		end

		if arg0.pools_pack[var0]:GetAmount() <= 0 then
			arg0.pools_pack[var0]:Clear()

			arg0.pools_pack[var0] = nil
		end
	end
end

function var0.DestroySprite(arg0, arg1)
	local var0 = arg1
	local var1 = typeof(Sprite)

	if arg0.pools_pack[var0] and arg0.pools_pack[var0].type == var1 then
		local var2 = arg0.pools_pack[var0]:GetAmount()

		arg0.pools_pack[var0]:Clear()

		arg0.pools_pack[var0] = nil

		for iter0 = 1, var2 do
			var5:ClearBundleRef(var0, false, false)
		end
	end
end

function var0.DestroyAllSprite(arg0)
	local var0 = {}
	local var1 = typeof(Sprite)

	for iter0, iter1 in pairs(arg0.pools_pack) do
		if iter1.type == var1 and not arg0.preloads[iter0] then
			var0[iter0] = iter1
		end
	end

	for iter2, iter3 in pairs(var0) do
		local var2 = arg0.pools_pack[iter2]:GetAmount()

		arg0.pools_pack[iter2]:Clear()

		arg0.pools_pack[iter2] = nil

		for iter4 = 1, var2 do
			var5:ClearBundleRef(iter2, false, false)
		end
	end

	var5:unloadUnusedAssetBundles()
end

function var0.DisplayPoolPacks(arg0)
	local var0 = ""

	for iter0, iter1 in pairs(arg0.pools_pack) do
		for iter2, iter3 in pairs(iter1.items) do
			if #var0 > 0 then
				var0 = var0 .. "\n"
			end

			local var1 = _.map({
				iter0,
				"assetName:",
				iter2,
				"type:",
				iter1.type.FullName
			}, function(arg0)
				return tostring(arg0)
			end)

			var0 = var0 .. " " .. table.concat(var1, " ")
		end
	end

	warning(var0)
end

function var0.SpriteMemUsage(arg0)
	local var0 = 0
	local var1 = 9.5367431640625e-07
	local var2 = typeof(Sprite)

	for iter0, iter1 in pairs(arg0.pools_pack) do
		if iter1.type == var2 then
			local var3 = {}

			for iter2, iter3 in pairs(iter1.items) do
				local var4 = iter3.texture
				local var5 = var4.name

				if not var3[var5] then
					local var6 = 4
					local var7 = var4.format

					if var7 == TextureFormat.RGB24 then
						var6 = 3
					elseif var7 == TextureFormat.ARGB4444 or var7 == TextureFormat.RGBA4444 then
						var6 = 2
					elseif var7 == TextureFormat.DXT5 or var7 == TextureFormat.ETC2_RGBA8 then
						var6 = 1
					elseif var7 == TextureFormat.PVRTC_RGB4 or var7 == TextureFormat.PVRTC_RGBA4 or var7 == TextureFormat.ETC_RGB4 or var7 == TextureFormat.ETC2_RGB or var7 == TextureFormat.DXT1 then
						var6 = 0.5
					end

					var0 = var0 + var4.width * var4.height * var6 * var1
					var3[var5] = true
				end
			end
		end
	end

	return var0
end

local var9 = 64
local var10 = {
	"chapter/",
	"emoji/",
	"world/"
}

function var0.GetPrefab(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg1 .. arg2

	arg0:FromPlural(arg1, arg2, arg3, arg5 or var9, function(arg0)
		if string.find(arg1, "emoji/") == 1 then
			local var0 = arg0:GetComponent(typeof(CriManaEffectUI))

			if var0 then
				var0:Pause(false)
			end
		end

		arg0:SetActive(true)
		tf(arg0):SetParent(arg0.root, false)
		arg4(arg0)
	end, true)
end

function var0.ReturnPrefab(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1 .. arg2

	if IsNil(arg3) then
		Debugger.LogError(debug.traceback("empty go: " .. arg2))
	elseif arg0.pools_plural[var0] then
		if string.find(arg1, "emoji/") == 1 then
			local var1 = arg3:GetComponent(typeof(CriManaEffectUI))

			if var1 then
				var1:Pause(true)
			end
		end

		arg3:SetActive(false)
		arg3.transform:SetParent(arg0.root, false)
		arg0.pools_plural[var0]:Enqueue(arg3)

		if arg4 and arg0.pools_plural[var0].balance <= 0 and (not arg0.callbacks[var0] or #arg0.callbacks[var0] == 0) then
			arg0:DestroyPrefab(arg1, arg2)
		end
	else
		var4.Destroy(arg3)
	end
end

function var0.DestroyPrefab(arg0, arg1, arg2)
	local var0 = arg1 .. arg2

	if arg0.pools_plural[var0] then
		arg0.pools_plural[var0]:Clear()

		arg0.pools_plural[var0] = nil

		var5:ClearBundleRef(arg1, true, false)
	end
end

function var0.DestroyAllPrefab(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.pools_plural) do
		if _.any(var10, function(arg0)
			return string.find(iter0, arg0) == 1
		end) then
			iter1:Clear()
			var5:ClearBundleRef(iter0, true, false)
			table.insert(var0, iter0)
		end
	end

	_.each(var0, function(arg0)
		arg0.pools_plural[arg0] = nil
	end)
end

function var0.DisplayPluralPools(arg0)
	local var0 = ""

	for iter0, iter1 in pairs(arg0.pools_plural) do
		if #var0 > 0 then
			var0 = var0 .. "\n"
		end

		local var1 = _.map({
			iter0,
			"balance",
			iter1.balance,
			"currentItmes",
			#iter1.items
		}, function(arg0)
			return tostring(arg0)
		end)

		var0 = var0 .. " " .. table.concat(var1, " ")
	end

	warning(var0)
end

function var0.GetPluralStatus(arg0, arg1)
	if not arg0.pools_plural[arg1] then
		return "NIL"
	end

	local var0 = arg0.pools_plural[arg1]
	local var1 = _.map({
		arg1,
		"balance",
		var0.balance,
		"currentItmes",
		#var0.items
	}, tostring)

	return table.concat(var1, " ")
end

function var0.FromPlural(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = arg1 .. arg2

	local function var1()
		local var0 = arg0.pools_plural[var0]

		var0.index = arg0.pluralIndex
		arg0.pluralIndex = arg0.pluralIndex + 1

		arg5(var0:Dequeue())
	end

	if not arg0.pools_plural[var0] then
		arg0:LoadAsset(arg1, arg2, arg3, typeof(Object), function(arg0)
			if arg0 == nil then
				Debugger.LogError("can not find asset: " .. arg1 .. " : " .. arg2)

				return
			end

			if not arg0.pools_plural[var0] then
				arg0.pools_plural[var0] = var1.New(arg0, arg4)
			end

			var1()
		end, arg6)
	else
		var1()
	end
end

function var0.FromObjPack(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg1

	if not arg0.pools_pack[var0] or not arg0.pools_pack[var0]:Get(arg2) then
		arg0:LoadAsset(arg1, arg2, arg3, arg4, function(arg0)
			if not arg0.pools_pack[var0] then
				arg0.pools_pack[var0] = var3.New(arg4)
			end

			if not arg0.pools_pack[var0]:Get(arg2) then
				arg0.pools_pack[var0]:Set(arg2, arg0)
			end

			arg5(arg0)
		end, false)
	else
		arg5(arg0.pools_pack[var0]:Get(arg2))
	end
end

function var0.LoadAsset(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg1, arg2 = HXSet.autoHxShiftPath(arg1, arg2)

	local var0 = arg1 .. arg2

	if arg0.callbacks[var0] then
		if not arg3 then
			errorMsg("Sync Loading after async operation")
		end

		table.insert(arg0.callbacks[var0], arg5)
	elseif arg3 then
		arg0.callbacks[var0] = {
			arg5
		}

		var5:getAssetAsync(arg1, arg2, arg4, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.callbacks[var0] then
				local var0 = arg0.callbacks[var0]

				arg0.callbacks[var0] = nil

				while next(var0) do
					table.remove(var0)(arg0)
				end
			end
		end), arg6, false)
	else
		arg5(var5:getAssetSync(arg1, arg2, arg4, arg6, false))
	end
end

function var0.PrintPools(arg0)
	local var0 = ""

	for iter0, iter1 in pairs(arg0.pools_plural) do
		var0 = var0 .. "\n" .. iter0
	end

	warning(var0)
end

function var0.PrintObjPack(arg0)
	local var0 = ""

	for iter0, iter1 in pairs(arg0.pools_pack) do
		for iter2, iter3 in pairs(iter1.items) do
			var0 = var0 .. "\n" .. iter0 .. " " .. iter2
		end
	end

	warning(var0)
end

return var0
