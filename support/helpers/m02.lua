local var0 = UnityEngine

function flog(arg0, arg1)
	if arg0 and arg1 and pg.ConnectionMgr.GetInstance():isConnected() then
		pg.m02:sendNotification(GAME.SEND_CMD, {
			cmd = "log",
			arg1 = arg0,
			arg2 = arg1
		})
	end
end

function throttle(arg0, arg1, arg2)
	local var0
	local var1
	local var2
	local var3 = 0

	local function var4()
		var3 = arg2 and Time.unscaledTime or 0
		var0 = nil
		var2 = arg0(unpackEx(var1))

		if not var0 then
			var1 = nil
		end
	end

	return function(...)
		local var0 = Time.unscaledTime

		if not var3 and not arg2 then
			var3 = var0
		end

		local var1 = arg1 - (var0 - var3)

		var1 = packEx(...)

		if var1 <= 0 or var1 > arg1 then
			if var0 then
				var0:Stop()

				var0 = nil
			end

			var3 = var0
			var2 = arg0(unpackEx(var1))

			if not var0 then
				var1 = nil
			end
		elseif not var0 and arg2 then
			var0 = Timer.New(var4, var1, 1)

			var0:Start()
		end

		return var2
	end
end

function debounce(arg0, arg1, arg2)
	local var0
	local var1
	local var2
	local var3
	local var4

	local function var5()
		local var0 = Time.unscaledTime - var2

		if var0 < arg1 and var0 > 0 then
			var0 = Timer.New(var5, arg1 - var0, 1)

			var0:Start()
		else
			var0 = nil

			if not arg2 then
				var3 = arg0(unpackEx(var1))

				if not var0 then
					var1 = nil
				end
			else
				arg2 = false
			end
		end
	end

	return function(...)
		var1 = packEx(...)
		var2 = Time.unscaledTime

		local var0 = arg2 and not var0

		if not var0 then
			var0 = Timer.New(var5, arg1, 1)

			var0:Start()
		end

		if var0 then
			var3 = arg0(unpackEx(var1))
			var1 = nil
		end

		return var3
	end
end

function createLog(arg0, arg1)
	if LOG and arg1 then
		return function(...)
			print(arg0 .. ": ", ...)
		end
	else
		print(arg0 .. ": log disabled")

		return function()
			return
		end
	end
end

function getProxy(arg0)
	assert(pg.m02, "game is not started")

	return pg.m02:retrieveProxy(arg0.__cname)
end

function LoadAndInstantiateAsync(arg0, arg1, arg2, arg3, arg4)
	arg4 = defaultValue(arg4, true)
	arg3 = defaultValue(arg3, true)
	arg0, arg1 = HXSet.autoHxShift(arg0 .. "/", arg1)

	ResourceMgr.Inst:getAssetAsync(arg0 .. arg1, arg1, var0.Events.UnityAction_UnityEngine_Object(function(arg0)
		local var0 = Instantiate(arg0)

		arg2(var0)
	end), arg3, arg4)
end

function LoadAndInstantiateSync(arg0, arg1, arg2, arg3)
	arg3 = defaultValue(arg3, true)
	arg2 = defaultValue(arg2, true)
	arg0, arg1 = HXSet.autoHxShift(arg0 .. "/", arg1)

	local var0 = ResourceMgr.Inst:getAssetSync(arg0 .. arg1, arg1, arg2, arg3)

	return (Instantiate(var0))
end

local var1 = {}

function LoadSprite(arg0, arg1)
	arg0, arg1 = HXSet.autoHxShiftPath(arg0, arg1)

	return ResourceMgr.Inst:getAssetSync(arg0, arg1 or "", typeof(Sprite), true, false)
end

function LoadSpriteAtlasAsync(arg0, arg1, arg2)
	arg0, arg1 = HXSet.autoHxShiftPath(arg0, arg1)

	ResourceMgr.Inst:getAssetAsync(arg0, arg1 or "", typeof(Sprite), var0.Events.UnityAction_UnityEngine_Object(function(arg0)
		arg2(arg0)
	end), true, false)
end

function LoadSpriteAsync(arg0, arg1)
	LoadSpriteAtlasAsync(arg0, nil, arg1)
end

function LoadAny(arg0, arg1, arg2)
	arg0, arg1 = HXSet.autoHxShiftPath(arg0, arg1)

	return ResourceMgr.Inst:getAssetSync(arg0, arg1, arg2, true, false)
end

function LoadAnyAsync(arg0, arg1, arg2, arg3)
	arg0, arg1 = HXSet.autoHxShiftPath(arg0, arg1)

	return ResourceMgr.Inst:getAssetAsync(arg0, arg1, arg2, arg3, true, false)
end

function LoadImageSpriteAtlasAsync(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetComponent(typeof(Image))

	var0.enabled = false
	var1[var0] = arg0

	LoadSpriteAtlasAsync(arg0, arg1, function(arg0)
		if not IsNil(var0) and var1[var0] == arg0 then
			var1[var0] = nil
			var0.enabled = true
			var0.sprite = arg0

			if arg3 then
				var0:SetNativeSize()
			end
		end
	end)
end

function LoadImageSpriteAsync(arg0, arg1, arg2)
	LoadImageSpriteAtlasAsync(arg0, nil, arg1, arg2)
end

function GetSpriteFromAtlas(arg0, arg1)
	local var0

	arg0, arg1 = HXSet.autoHxShiftPath(arg0, arg1)

	PoolMgr.GetInstance():GetSprite(arg0, arg1, false, function(arg0)
		var0 = arg0
	end)

	return var0
end

function GetSpriteFromAtlasAsync(arg0, arg1, arg2)
	arg0, arg1 = HXSet.autoHxShiftPath(arg0, arg1)

	PoolMgr.GetInstance():GetSprite(arg0, arg1, true, function(arg0)
		arg2(arg0)
	end)
end

function GetImageSpriteFromAtlasAsync(arg0, arg1, arg2, arg3)
	arg0, arg1 = HXSet.autoHxShiftPath(arg0, arg1)

	local var0 = arg2:GetComponent(typeof(Image))

	var0.enabled = false
	var1[var0] = arg0 .. arg1

	GetSpriteFromAtlasAsync(arg0, arg1, function(arg0)
		if not IsNil(var0) and var1[var0] == arg0 .. arg1 then
			var1[var0] = nil
			var0.enabled = true
			var0.sprite = arg0

			if arg3 then
				var0:SetNativeSize()
			end
		end
	end)
end

function SetAction(arg0, arg1, arg2)
	GetComponent(arg0, "SkeletonGraphic").AnimationState:SetAnimation(0, arg1, defaultValue(arg2, true))
end

function SetActionCallback(arg0, arg1)
	GetOrAddComponent(arg0, typeof(SpineAnimUI)):SetActionCallBack(arg1)
end

function emojiText(arg0, arg1)
	local var0 = buildTempAB("emojis", false)
	local var1 = GetComponent(arg0, "TextMesh")
	local var2 = GetComponent(arg0, "MeshRenderer")
	local var3 = Shader.Find("UI/Unlit/Transparent")
	local var4 = var2.materials
	local var5 = {
		var4[0]
	}
	local var6 = {}
	local var7 = 0

	var1.text = string.gsub(arg1, "#(%d+)#", function(arg0)
		if not var6[arg0] then
			var7 = var7 + 1

			local var0 = Material.New(var3)

			var0.mainTexture = var0:LoadAssetSync("emoji" .. arg0, false, false)

			table.insert(var5, var0)

			var6[arg0] = var7

			local var1 = var7
		end

		return "<quad material=" .. var7 .. " />"
	end)
	var2.materials = var5

	ResourceMgr.Inst:ClearBundleRef("emojis", false, false)
end

function setPaintingImg(arg0, arg1)
	local var0 = LoadSprite("painting/" .. arg1) or LoadSprite("painting/unknown")

	setImageSprite(arg0, var0)
	resetAspectRatio(arg0)
end

function setPaintingPrefab(arg0, arg1, arg2, arg3)
	local var0 = findTF(arg0, "fitter")

	assert(var0, "请添加子物体fitter")
	removeAllChildren(var0)

	local var1 = GetOrAddComponent(var0, "PaintingScaler")

	var1.FrameName = arg2 or ""
	var1.Tween = 1

	local var2 = arg1

	if not arg3 and checkABExist("painting/" .. arg1 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1, 0) ~= 0 then
		arg1 = arg1 .. "_n"
	end

	PoolMgr.GetInstance():GetPainting(arg1, false, function(arg0)
		setParent(arg0, var0, false)

		local var0 = findTF(arg0, "Touch")

		if not IsNil(var0) then
			setActive(var0, false)
		end

		local var1 = findTF(arg0, "hx")

		if not IsNil(var1) then
			setActive(var1, HXSet.isHx())
		end

		ShipExpressionHelper.SetExpression(var0:GetChild(0), var2)
	end)
end

local var2 = {}

function setPaintingPrefabAsync(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1

	if checkABExist("painting/" .. arg1 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1, 0) ~= 0 then
		arg1 = arg1 .. "_n"
	end

	LoadPaintingPrefabAsync(arg0, var0, arg1, arg2, arg3)
end

function LoadPaintingPrefabAsync(arg0, arg1, arg2, arg3, arg4)
	local var0 = findTF(arg0, "fitter")

	assert(var0, "请添加子物体fitter")
	removeAllChildren(var0)

	local var1 = GetOrAddComponent(var0, "PaintingScaler")

	var1.FrameName = arg3 or ""
	var1.Tween = 1
	var2[arg0] = arg2

	PoolMgr.GetInstance():GetPainting(arg2, true, function(arg0)
		if IsNil(arg0) or var2[arg0] ~= arg2 then
			PoolMgr.GetInstance():ReturnPainting(arg2, arg0)

			return
		else
			setParent(arg0, var0, false)

			var2[arg0] = nil

			ShipExpressionHelper.SetExpression(arg0, arg1)
		end

		local var0 = findTF(arg0, "Touch")

		if not IsNil(var0) then
			setActive(var0, false)
		end

		local var1 = findTF(arg0, "Drag")

		if not IsNil(var1) then
			setActive(var1, false)
		end

		local var2 = findTF(arg0, "hx")

		if not IsNil(var2) then
			setActive(var2, HXSet.isHx())
		end

		if arg4 then
			arg4()
		end
	end)
end

function retPaintingPrefab(arg0, arg1, arg2)
	if arg0 and arg1 then
		local var0 = findTF(arg0, "fitter")

		if var0 and var0.childCount > 0 then
			local var1 = var0:GetChild(0)

			if not IsNil(var1) then
				local var2 = findTF(var1, "Touch")

				if not IsNil(var2) then
					eachChild(var2, function(arg0)
						local var0 = arg0:GetComponent(typeof(Button))

						if not IsNil(var0) then
							removeOnButton(arg0)
						end
					end)
				end

				if not arg2 then
					PoolMgr.GetInstance():ReturnPainting(string.gsub(var1.name, "%(Clone%)", ""), var1.gameObject)
				else
					PoolMgr.GetInstance():ReturnPaintingWithPrefix(string.gsub(var1.name, "%(Clone%)", ""), var1.gameObject, arg2)
				end
			end
		end

		var2[arg0] = nil
	end
end

function numberFormat(arg0, arg1)
	local var0 = ""
	local var1 = tostring(arg0)
	local var2 = string.len(var1)

	if arg1 == nil then
		arg1 = ","
	end

	arg1 = tostring(arg1)

	for iter0 = 1, var2 do
		var0 = string.char(string.byte(var1, var2 + 1 - iter0)) .. var0

		if iter0 % 3 == 0 and var2 - iter0 ~= 0 then
			var0 = arg1 .. var0
		end
	end

	return var0
end

function usMoneyFormat(arg0, arg1)
	local var0 = arg0 % 100
	local var1 = math.floor(arg0 / 100)

	if var0 > 0 then
		var0 = var0 > 10 and var0 or "0" .. var0

		if var1 < 1 then
			return "0." .. var0
		else
			return numberFormat(var1, arg1) .. "." .. var0
		end
	else
		return numberFormat(var1, arg1)
	end
end

function checkPaintingPrefab(arg0, arg1, arg2, arg3, arg4)
	local var0 = findTF(arg0, "fitter")

	assert(var0, "请添加子物体fitter")
	removeAllChildren(var0)

	local var1 = GetOrAddComponent(var0, "PaintingScaler")

	var1.FrameName = arg2 or ""
	var1.Tween = 1

	local var2 = arg4 or "painting/"
	local var3 = arg1

	if not arg3 and checkABExist(var2 .. arg1 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1, 0) ~= 0 then
		arg1 = arg1 .. "_n"
	end

	return var0, arg1, var3
end

function onLoadedPaintingPrefab(arg0)
	local var0 = arg0.paintingTF
	local var1 = arg0.fitterTF
	local var2 = arg0.defaultPaintingName

	setParent(var0, var1, false)

	local var3 = findTF(var0, "Touch")

	if not IsNil(var3) then
		setActive(var3, false)
	end

	local var4 = findTF(var0, "hx")

	if not IsNil(var4) then
		setActive(var4, HXSet.isHx())
	end

	ShipExpressionHelper.SetExpression(var1:GetChild(0), var2)
end

function onLoadedPaintingPrefabAsync(arg0)
	local var0 = arg0.paintingTF
	local var1 = arg0.fitterTF
	local var2 = arg0.objectOrTransform
	local var3 = arg0.paintingName
	local var4 = arg0.defaultPaintingName
	local var5 = arg0.callback

	if IsNil(var2) or var2[var2] ~= var3 then
		PoolMgr.GetInstance():ReturnPainting(var3, var0)

		return
	else
		setParent(var0, var1, false)

		var2[var2] = nil

		ShipExpressionHelper.SetExpression(var0, var4)
	end

	local var6 = findTF(var0, "Touch")

	if not IsNil(var6) then
		setActive(var6, false)
	end

	local var7 = findTF(var0, "hx")

	if not IsNil(var7) then
		setActive(var7, HXSet.isHx())
	end

	if var5 then
		var5()
	end
end

function setCommanderPaintingPrefab(arg0, arg1, arg2, arg3)
	local var0, var1, var2 = checkPaintingPrefab(arg0, arg1, arg2, arg3)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1, false, function(arg0)
		local var0 = {
			paintingTF = arg0,
			fitterTF = var0,
			defaultPaintingName = var2
		}

		onLoadedPaintingPrefab(var0)
	end, "commanderpainting/")
end

function setCommanderPaintingPrefabAsync(arg0, arg1, arg2, arg3, arg4)
	local var0, var1, var2 = checkPaintingPrefab(arg0, arg1, arg2, arg4)

	var2[arg0] = var1

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1, true, function(arg0)
		local var0 = {
			paintingTF = arg0,
			fitterTF = var0,
			objectOrTransform = arg0,
			paintingName = var1,
			defaultPaintingName = var2,
			callback = arg3
		}

		onLoadedPaintingPrefabAsync(var0)
	end, "commanderpainting/")
end

function retCommanderPaintingPrefab(arg0, arg1)
	retPaintingPrefab(arg0, arg1, "commanderpainting/")
end

function setMetaPaintingPrefab(arg0, arg1, arg2, arg3)
	local var0, var1, var2 = checkPaintingPrefab(arg0, arg1, arg2, arg3)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1, false, function(arg0)
		local var0 = {
			paintingTF = arg0,
			fitterTF = var0,
			defaultPaintingName = var2
		}

		onLoadedPaintingPrefab(var0)
	end, "metapainting/")
end

function setMetaPaintingPrefabAsync(arg0, arg1, arg2, arg3, arg4)
	local var0, var1, var2 = checkPaintingPrefab(arg0, arg1, arg2, arg4)

	var2[arg0] = var1

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1, true, function(arg0)
		local var0 = {
			paintingTF = arg0,
			fitterTF = var0,
			objectOrTransform = arg0,
			paintingName = var1,
			defaultPaintingName = var2,
			callback = arg3
		}

		onLoadedPaintingPrefabAsync(var0)
	end, "metapainting/")
end

function retMetaPaintingPrefab(arg0, arg1)
	retPaintingPrefab(arg0, arg1, "metapainting/")
end

function setGuildPaintingPrefab(arg0, arg1, arg2, arg3)
	local var0, var1, var2 = checkPaintingPrefab(arg0, arg1, arg2, arg3)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1, false, function(arg0)
		local var0 = {
			paintingTF = arg0,
			fitterTF = var0,
			defaultPaintingName = var2
		}

		onLoadedPaintingPrefab(var0)
	end, "guildpainting/")
end

function setGuildPaintingPrefabAsync(arg0, arg1, arg2, arg3, arg4)
	local var0, var1, var2 = checkPaintingPrefab(arg0, arg1, arg2, arg4)

	var2[arg0] = var1

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1, true, function(arg0)
		local var0 = {
			paintingTF = arg0,
			fitterTF = var0,
			objectOrTransform = arg0,
			paintingName = var1,
			defaultPaintingName = var2,
			callback = arg3
		}

		onLoadedPaintingPrefabAsync(var0)
	end, "guildpainting/")
end

function retGuildPaintingPrefab(arg0, arg1)
	retPaintingPrefab(arg0, arg1, "guildpainting/")
end

function setShopPaintingPrefab(arg0, arg1, arg2, arg3)
	local var0, var1, var2 = checkPaintingPrefab(arg0, arg1, arg2, arg3)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1, false, function(arg0)
		local var0 = {
			paintingTF = arg0,
			fitterTF = var0,
			defaultPaintingName = var2
		}

		onLoadedPaintingPrefab(var0)
	end, "shoppainting/")
end

function retShopPaintingPrefab(arg0, arg1)
	retPaintingPrefab(arg0, arg1, "shoppainting/")
end

function setBuildPaintingPrefabAsync(arg0, arg1, arg2, arg3, arg4)
	local var0, var1, var2 = checkPaintingPrefab(arg0, arg1, arg2, arg4)

	var2[arg0] = var1

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1, true, function(arg0)
		local var0 = {
			paintingTF = arg0,
			fitterTF = var0,
			objectOrTransform = arg0,
			paintingName = var1,
			defaultPaintingName = var2,
			callback = arg3
		}

		onLoadedPaintingPrefabAsync(var0)
	end, "buildpainting/")
end

function retBuildPaintingPrefab(arg0, arg1)
	retPaintingPrefab(arg0, arg1, "buildpainting/")
end

function setColorCount(arg0, arg1, arg2)
	setText(arg0, string.format(arg1 < arg2 and "<color=" .. COLOR_RED .. ">%d</color>/%d" or "%d/%d", arg1, arg2))
end

function setColorStr(arg0, arg1)
	return "<color=" .. arg1 .. ">" .. arg0 .. "</color>"
end

function setSizeStr(arg0, arg1)
	local var0, var1 = string.gsub(arg0, "[<]size=%d+[>]", "<size=" .. arg1 .. ">")

	if var1 == 0 then
		var0 = "<size=" .. arg1 .. ">" .. var0 .. "</size>"
	end

	return var0
end

function getBgm(arg0)
	local var0 = pg.voice_bgm[arg0]

	if pg.CriMgr.GetInstance():IsDefaultBGM() then
		return var0 and var0.default_bgm or nil
	elseif var0 then
		local var1 = var0.special_bgm
		local var2 = var0.time

		if var1 and type(var1) == "string" and #var1 > 0 and var2 and type(var2) == "table" then
			local var3 = var0.time
			local var4 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var3[1])
			local var5 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var3[2])
			local var6 = pg.TimeMgr.GetInstance():GetServerTime()

			if var4 <= var6 and var6 <= var5 then
				return var1
			else
				return var0.bgm
			end
		else
			return var0 and var0.bgm or nil
		end
	else
		return nil
	end
end

function playStory(arg0, arg1)
	pg.NewStoryMgr.GetInstance():Play(arg0, arg1)
end

function errorMessage(arg0)
	local var0 = ERROR_MESSAGE[arg0]

	if var0 == nil then
		var0 = ERROR_MESSAGE[9999] .. ":" .. arg0
	end

	return var0
end

function errorTip(arg0, arg1, ...)
	local var0 = pg.gametip[arg0 .. "_error"]
	local var1

	if var0 then
		var1 = var0.tip
	else
		var1 = pg.gametip.common_error.tip
	end

	local var2 = arg0 .. "_error_" .. arg1

	if pg.gametip[var2] then
		local var3 = i18n(var2, ...)

		return var1 .. var3
	else
		local var4 = "common_error_" .. arg1

		if pg.gametip[var4] then
			local var5 = i18n(var4, ...)

			return var1 .. var5
		else
			local var6 = errorMessage(arg1)

			return var1 .. arg1 .. ":" .. var6
		end
	end
end

function colorNumber(arg0, arg1)
	local var0 = "@COLOR_SCOPE"
	local var1 = {}

	arg0 = string.gsub(arg0, "<color=#%x+>", function(arg0)
		table.insert(var1, arg0)

		return var0
	end)
	arg0 = string.gsub(arg0, "%d+%.?%d*%%*", function(arg0)
		return "<color=" .. arg1 .. ">" .. arg0 .. "</color>"
	end)

	if #var1 > 0 then
		local var2 = 0

		return (string.gsub(arg0, var0, function(arg0)
			var2 = var2 + 1

			return var1[var2]
		end))
	else
		return arg0
	end
end

function getBounds(arg0)
	local var0 = LuaHelper.GetWorldCorners(rtf(arg0))
	local var1 = Bounds.New(var0[0], Vector3.zero)

	var1:Encapsulate(var0[2])

	return var1
end

local function var3(arg0, arg1)
	arg0.localScale = Vector3.one
	arg0.anchorMin = Vector2.zero
	arg0.anchorMax = Vector2.one
	arg0.offsetMin = Vector2(arg1[1], arg1[2])
	arg0.offsetMax = Vector2(-arg1[3], -arg1[4])
end

local var4 = {
	frame4_0 = {
		-8,
		-8.5,
		-8,
		-8
	},
	frame5_0 = {
		-8,
		-8.5,
		-8,
		-8
	},
	frame4_1 = {
		-8,
		-8.5,
		-8,
		-8
	},
	frame_design = {
		-16.5,
		-2.5,
		-3.5,
		-16.5
	},
	frame_skin = {
		-16.5,
		-2.5,
		-3.5,
		-16.5
	},
	frame_npc = {
		-4,
		-4,
		-4,
		-4
	},
	frame_store = {
		-17,
		-3,
		-3,
		-18
	},
	frame_prop = {
		-11,
		-12,
		-14,
		-14
	},
	frame_prop_meta = {
		-11,
		-12,
		-14,
		-14
	},
	other = {
		-2.5,
		-4.5,
		-3,
		-4.5
	}
}

function setFrame(arg0, arg1, arg2)
	arg1 = tostring(arg1)

	local var0, var1 = unpack((string.split(arg1, "_")))

	if var1 or tonumber(var0) > 5 then
		arg2 = arg2 or "frame" .. arg1
	end

	GetImageSpriteFromAtlasAsync("weaponframes", "frame", arg0)

	local var2 = arg2 and Color.white or Color.NewHex(ItemRarity.Rarity2FrameHexColor(var0 and tonumber(var0) or ItemRarity.Gray))

	setImageColor(arg0, var2)

	local var3 = findTF(arg0, "specialFrame")

	if arg2 then
		if var3 then
			setActive(var3, true)
		else
			var3 = cloneTplTo(arg0, arg0, "specialFrame")

			removeAllChildren(var3)
		end

		var3(var3, var4[arg2] or var4.other)
		GetImageSpriteFromAtlasAsync("weaponframes", arg2, var3)
	elseif var3 then
		setActive(var3, false)
	end
end

function setIconColorful(arg0, arg1, arg2, arg3)
	arg3 = arg3 or {
		[ItemRarity.SSR] = {
			name = "IconColorful",
			active = function(arg0, arg1)
				return not arg1.noIconColorful and arg0 == ItemRarity.SSR
			end
		}
	}

	local var0 = findTF(arg0, "icon_bg/frame")

	for iter0, iter1 in pairs(arg3) do
		local var1 = iter1.name
		local var2 = iter1.active(arg1, arg2)
		local var3 = var0:Find(var1 .. "(Clone)")

		if var3 then
			setActive(var3, var2)
		elseif var2 then
			LoadAndInstantiateAsync("ui", string.lower(var1), function(arg0)
				if IsNil(arg0) or var0:Find(var1 .. "(Clone)") then
					Object.Destroy(arg0)
				else
					setParent(arg0, var0)
					setActive(arg0, var2)
				end
			end)
		end
	end
end

function setIconStars(arg0, arg1, arg2)
	local var0 = findTF(arg0, "icon_bg/startpl")
	local var1 = findTF(arg0, "icon_bg/stars")

	if var1 and var0 then
		setActive(var1, false)
		setActive(var0, false)
	end

	if not var1 or not arg1 then
		return
	end

	for iter0 = 1, math.max(arg2, var1.childCount) do
		setActive(iter0 > var1.childCount and cloneTplTo(var0, var1) or var1:GetChild(iter0 - 1), iter0 <= arg2)
	end

	setActive(var1, true)
end

local function var5(arg0, arg1)
	local var0 = findTF(arg0, "icon_bg/slv")

	if not IsNil(var0) then
		setActive(var0, arg1 > 0)
		setText(findTF(var0, "Text"), arg1)
	end
end

function setIconName(arg0, arg1, arg2)
	local var0 = findTF(arg0, "name")

	if not IsNil(var0) then
		setText(var0, arg1)
		setTextAlpha(var0, (arg2.hideName or arg2.anonymous) and 0 or 1)
	end
end

function setIconCount(arg0, arg1)
	local var0 = findTF(arg0, "icon_bg/count")

	if not IsNil(var0) then
		setText(var0, arg1 and (type(arg1) ~= "number" or arg1 > 0) and arg1 or "")
	end
end

function updateEquipment(arg0, arg1, arg2)
	arg2 = arg2 or {}

	assert(arg1, "equipmentVo can not be nil.")

	local var0 = EquipmentRarity.Rarity2Print(arg1:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var0)

	local var1 = findTF(arg0, "icon_bg/icon")

	var3(var1, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync("equips/" .. arg1:getConfig("icon"), "", var1)
	setIconStars(arg0, true, arg1:getConfig("rarity"))
	var5(arg0, arg1:getConfig("level") - 1)
	setIconName(arg0, arg1:getConfig("name"), arg2)
	setIconCount(arg0, arg1.count)
	setIconColorful(arg0, arg1:getConfig("rarity") - 1, arg2)
end

function updateItem(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = ItemRarity.Rarity2Print(arg1:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0, findTF(arg0, "icon_bg"))

	local var1

	if arg1:getConfig("type") == 9 then
		var1 = "frame_design"
	elseif arg2.frame then
		var1 = arg2.frame
	end

	setFrame(findTF(arg0, "icon_bg/frame"), var0, var1)

	local var2 = findTF(arg0, "icon_bg/icon")
	local var3 = arg1.icon or arg1:getConfig("icon")

	if arg1:getConfig("type") == Item.LOVE_LETTER_TYPE then
		assert(arg1.extra, "without extra data")

		var3 = "SquareIcon/" .. ShipGroup.getDefaultSkin(arg1.extra).prefab
	end

	GetImageSpriteFromAtlasAsync(var3, "", var2)
	setIconStars(arg0, false)
	setIconName(arg0, arg1:getName(), arg2)
	setIconColorful(arg0, arg1:getConfig("rarity"), arg2)
end

function updateWorldItem(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = ItemRarity.Rarity2Print(arg1:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var0)

	local var1 = findTF(arg0, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1.icon or arg1:getConfig("icon"), "", var1)
	setIconStars(arg0, false)
	setIconName(arg0, arg1:getConfig("name"), arg2)
	setIconColorful(arg0, arg1:getConfig("rarity"), arg2)
end

function updateWorldCollection(arg0, arg1, arg2)
	arg2 = arg2 or {}

	assert(arg1:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1.id)

	local var0 = arg1:getDropRarity()
	local var1 = ItemRarity.Rarity2Print(var0)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var1)

	local var2 = findTF(arg0, "icon_bg/icon")
	local var3 = WorldCollectionProxy.GetCollectionType(arg1.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3, "", var2)
	setIconStars(arg0, false)
	setIconName(arg0, arg1:getName(), arg2)
	setIconColorful(arg0, var0, arg2)
end

function updateWorldBuff(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = pg.world_SLGbuff_data[arg1]

	assert(var0, "找不到大世界buff配置: " .. arg1)

	local var1 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var1)

	local var2 = findTF(arg0, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0.icon, "", var2)

	local var3 = arg0:Find("icon_bg/stars")

	if not IsNil(var3) then
		setActive(var3, false)
	end

	local var4 = findTF(arg0, "name")

	if not IsNil(var4) then
		setText(var4, var0.name)
	end

	local var5 = findTF(arg0, "icon_bg/count")

	if not IsNil(var5) then
		SetActive(var5, false)
	end
end

function updateShip(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = arg1:rarity2bgPrint()
	local var1 = arg1:getPainting()

	if arg2.anonymous then
		var0 = "1"
		var1 = "unknown"
	end

	if arg2.unknown_small then
		var1 = "unknown_small"
	end

	local var2 = findTF(arg0, "icon_bg/new")

	if var2 then
		if arg2.isSkin then
			setActive(var2, not arg2.isTimeLimit and arg2.isNew)
		else
			setActive(var2, arg1.virgin)
		end
	end

	local var3 = findTF(arg0, "icon_bg/timelimit")

	if var3 then
		setActive(var3, arg2.isTimeLimit)
	end

	local var4 = findTF(arg0, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2.isSkin and "_skin" or var0), var4)

	local var5 = findTF(arg0, "icon_bg/frame")
	local var6

	if arg1.isNpc then
		var6 = "frame_npc"
	elseif arg1:ShowPropose() then
		var6 = "frame_prop"

		if arg1:isMetaShip() then
			var6 = var6 .. "_meta"
		end
	elseif arg2.isSkin then
		var6 = "frame_skin"
	end

	setFrame(var5, var0, var6)

	if arg2.gray then
		setGray(var4, true, true)
	end

	local var7 = findTF(arg0, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2.Q and "QIcon/" or "SquareIcon/") .. var1, "", var7)

	local var8 = findTF(arg0, "icon_bg/lv")

	if var8 then
		setActive(var8, not arg1.isNpc)

		if not arg1.isNpc then
			local var9 = findTF(var8, "Text")

			if var9 and arg1.level then
				setText(var9, arg1.level)
			end
		end
	end

	local var10 = findTF(arg0, "ship_type")

	if var10 then
		setActive(var10, true)
		setImageSprite(var10, GetSpriteFromAtlas("shiptype", shipType2print(arg1:getShipType())))
	end

	local var11 = var4:Find("npc")

	if not IsNil(var11) then
		if var2 and go(var2).activeSelf then
			setActive(var11, false)
		else
			setActive(var11, arg1:isActivityNpc())
		end
	end

	local var12 = arg0:Find("group_locked")

	if var12 then
		setActive(var12, not arg2.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1.groupId))
	end

	setIconStars(arg0, arg2.initStar, arg1:getStar())
	setIconName(arg0, arg2.isSkin and arg1:GetSkinConfig().name or arg1:getName(), arg2)
	setIconColorful(arg0, arg2.isSkin and ItemRarity.Gold or arg1:getRarity() - 1, arg2)
end

function updateCommander(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = arg1:getDropRarity()
	local var1 = ShipRarity.Rarity2Print(var0)
	local var2 = arg1:getConfig("painting")

	if arg2.anonymous then
		var1 = 1
		var2 = "unknown"
	end

	local var3 = findTF(arg0, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2.isSkin and "-skin" or var1), var3)

	local var4 = findTF(arg0, "icon_bg/frame")

	setFrame(var4, var1)

	if arg2.gray then
		setGray(var3, true, true)
	end

	local var5 = findTF(arg0, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2, "", var5)
	setIconStars(arg0, arg2.initStar, 0)
	setIconName(arg0, arg1:getName(), arg2)
end

function updateStrategy(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var0)

	local var1 = findTF(arg0, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1:getIcon(), "", var1)
	setIconStars(arg0, false)
	setIconName(arg0, arg1:getName(), arg2)
	setIconColorful(arg0, ItemRarity.Gray, arg2)
end

function updateFurniture(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = arg1:getDropRarity()
	local var1 = ItemRarity.Rarity2Print(var0)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var1)

	local var2 = findTF(arg0, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1:getIcon(), "", var2)
	setIconStars(arg0, false)
	setIconName(arg0, arg1:getName(), arg2)
	setIconColorful(arg0, var0, arg2)
end

function updateSpWeapon(arg0, arg1, arg2)
	arg2 = arg2 or {}

	assert(arg1, "spWeaponVO can not be nil.")
	assert(isa(arg1, SpWeapon), "spWeaponVO is not Equipment.")

	local var0 = ItemRarity.Rarity2Print(arg1:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var0)

	local var1 = findTF(arg0, "icon_bg/icon")

	var3(var1, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1:GetIconPath(), "", var1)
	setIconStars(arg0, true, arg1:GetRarity())
	var5(arg0, arg1:GetLevel() - 1)
	setIconName(arg0, arg1:GetName(), arg2)
	setIconCount(arg0, arg1.count)
	setIconColorful(arg0, arg1:GetRarity(), arg2)
end

function UpdateSpWeaponSlot(arg0, arg1, arg2)
	local var0 = ItemRarity.Rarity2Print(arg1:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0, findTF(arg0, "Icon/Mask/icon_bg"))

	local var1 = findTF(arg0, "Icon/Mask/icon_bg/icon")

	arg2 = arg2 or {
		16,
		16,
		16,
		16
	}

	var3(var1, arg2)
	GetImageSpriteFromAtlasAsync(arg1:GetIconPath(), "", var1)

	local var2 = arg1:GetLevel() - 1
	local var3 = findTF(arg0, "Icon/LV")

	setActive(var3, var2 > 0)
	setText(findTF(var3, "Text"), var2)
end

function updateDorm3dFurniture(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = arg1:getDropRarity()
	local var1 = ItemRarity.Rarity2Print(var0)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var1)

	local var2 = findTF(arg0, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1:getIcon(), "", var2)
	setIconStars(arg0, false)
	setIconName(arg0, arg1:getName(), arg2)
	setIconColorful(arg0, var0, arg2)
end

function updateDorm3dGift(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = arg1:getDropRarity()
	local var1 = ItemRarity.Rarity2Print(var0) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1, arg0:Find("icon_bg"))
	setFrame(arg0:Find("icon_bg/frame"), var1)

	local var2 = arg0:Find("icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1:getIcon(), "", var2)
	setIconStars(arg0, false)
	setIconName(arg0, arg1:getName(), arg2)
	setIconColorful(arg0, var0, arg2)
end

function updateDorm3dSkin(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = arg1:getDropRarity()
	local var1 = ItemRarity.Rarity2Print(var0) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1, arg0:Find("icon_bg"))
	setFrame(arg0:Find("icon_bg/frame"), var1)

	local var2 = arg0:Find("icon_bg/icon")

	setIconStars(arg0, false)
	setIconName(arg0, arg1:getName(), arg2)
	setIconColorful(arg0, var0, arg2)
end

function updateDorm3dIcon(arg0, arg1)
	local var0 = arg1:getConfig("rarity")

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0), arg0)

	local var1 = arg0:Find("icon")

	setText(arg0:Find("count/Text"), "x" .. arg1.count)
	setText(arg0:Find("name/Text"), arg1:getName())
end

local var6

function findCullAndClipWorldRect(arg0)
	if #arg0 == 0 then
		return false
	end

	local var0 = arg0[1].canvasRect

	for iter0 = 1, #arg0 do
		var0 = rectIntersect(var0, arg0[iter0].canvasRect)
	end

	if var0.width <= 0 or var0.height <= 0 then
		return false
	end

	var6 = var6 or GameObject.Find("UICamera/Canvas").transform

	local var1 = var6:TransformPoint(Vector3(var0.x, var0.y, 0))
	local var2 = var6:TransformPoint(Vector3(var0.x + var0.width, var0.y + var0.height, 0))

	return true, Vector4(var1.x, var1.y, var2.x, var2.y)
end

function rectIntersect(arg0, arg1)
	local var0 = math.max(arg0.x, arg1.x)
	local var1 = math.min(arg0.x + arg0.width, arg1.x + arg1.width)
	local var2 = math.max(arg0.y, arg1.y)
	local var3 = math.min(arg0.y + arg0.height, arg1.y + arg1.height)

	if var0 <= var1 and var2 <= var3 then
		return var0.Rect.New(var0, var2, var1 - var0, var3 - var2)
	end

	return var0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		local var1 = Drop.Create(iter1)

		var1.count = var1.count or 1

		if var1.type == DROP_TYPE_EMOJI then
			table.insert(var0, var1:getName())
		else
			table.insert(var0, var1:getName() .. "x" .. var1.count)
		end
	end

	return table.concat(var0, "、")
end

function updateDrop(arg0, arg1, arg2)
	Drop.Change(arg1)

	arg2 = arg2 or {}

	local var0 = {
		{
			"icon_bg/slv"
		},
		{
			"icon_bg/frame/specialFrame"
		},
		{
			"ship_type",
			DROP_TYPE_SHIP
		},
		{
			"icon_bg/new",
			DROP_TYPE_SHIP
		},
		{
			"icon_bg/npc",
			DROP_TYPE_SHIP
		},
		{
			"group_locked",
			DROP_TYPE_SHIP
		}
	}
	local var1

	for iter0, iter1 in ipairs(var0) do
		local var2 = arg0:Find(iter1[1])

		if arg1.type ~= iter1[2] and not IsNil(var2) then
			setActive(var2, false)
		end
	end

	arg0:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

	setIconColorful(arg0, arg1:getDropRarity(), arg2, {
		[ItemRarity.Gold] = {
			name = "Item_duang5",
			active = function(arg0, arg1)
				return arg1.fromAwardLayer and arg0 >= ItemRarity.Gold
			end
		}
	})
	var3(findTF(arg0, "icon_bg/icon"), {
		2,
		2,
		2,
		2
	})
	arg1:UpdateDropTpl(arg0, arg2)
	setIconCount(arg0, arg2.count or arg1:getCount())
end

function updateBuff(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0, findTF(arg0, "icon_bg"))

	local var1 = pg.benefit_buff_template[arg1]

	setFrame(findTF(arg0, "icon_bg/frame"), var0)
	setText(findTF(arg0, "icon_bg/count"), 1)

	local var2 = findTF(arg0, "icon_bg/icon")
	local var3 = var1.icon

	GetImageSpriteFromAtlasAsync(var3, "", var2)
	setIconStars(arg0, false)
	setIconName(arg0, var1.name, arg2)
	setIconColorful(arg0, ItemRarity.Gold, arg2)
end

function updateAttire(arg0, arg1, arg2, arg3)
	local var0 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var0)

	local var1 = findTF(arg0, "icon_bg/icon")
	local var2

	if arg1 == AttireConst.TYPE_CHAT_FRAME then
		var2 = "chat_frame"
	elseif arg1 == AttireConst.TYPE_ICON_FRAME then
		var2 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2, "", var1)
	setIconName(arg0, arg2.name, arg3)
end

function updateEmoji(arg0, arg1, arg2)
	local var0 = findTF(arg0, "icon_bg/icon")
	local var1 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1, "", var0)

	local var2 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var2)
	setIconName(arg0, arg1.name, arg2)
end

function updateEquipmentSkin(arg0, arg1, arg2)
	arg2 = arg2 or {}

	local var0 = EquipmentRarity.Rarity2Print(arg1.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0, findTF(arg0, "icon_bg"))
	setFrame(findTF(arg0, "icon_bg/frame"), var0, "frame_skin")

	local var1 = findTF(arg0, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1.icon, "", var1)
	setIconStars(arg0, false)
	setIconName(arg0, arg1.name, arg2)
	setIconCount(arg0, arg1.count)
	setIconColorful(arg0, arg1.rarity - 1, arg2)
end

function NoPosMsgBox(arg0, arg1, arg2, arg3)
	local var0
	local var1 = {}

	if arg1 then
		table.insert(var1, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1
		})
	end

	if arg2 then
		table.insert(var1, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2
		})
	end

	if arg3 then
		table.insert(var1, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0,
		custom = var1,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0 and var0.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0
			})
		else
			pg.m02:sendNotification(EquipmentMediator.BATCHDESTROY_MODE)

			return
		end
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
		warp = StoreHouseConst.WARP_TO_WEAPON,
		mode = StoreHouseConst.DESTROY
	})
end

function OpenSpWeaponPage()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0 and var0.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0
			})
		else
			pg.m02:sendNotification(EquipmentMediator.SWITCH_TO_SPWEAPON_PAGE)

			return
		end
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
		warp = StoreHouseConst.WARP_TO_WEAPON,
		mode = StoreHouseConst.SPWEAPON
	})
end

function openDockyardClear()
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		blockLock = true,
		mode = DockyardScene.MODE_DESTROY,
		leftTopInfo = i18n("word_destroy"),
		selectedMax = getGameset("ship_select_limit")[1],
		onShip = ShipStatus.canDestroyShip,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		})
	})
end

function openDockyardIntensify()
	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		mode = DockyardScene.MODE_OVERVIEW,
		onClick = function(arg0, arg1)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0.id,
				shipVOs = arg1
			})
		end
	})
end

function GoShoppingMsgBox(arg0, arg1, arg2)
	if arg2 then
		local var0 = ""

		for iter0, iter1 in ipairs(arg2) do
			local var1 = Item.getConfigData(iter1[1])

			var0 = var0 .. i18n(iter1[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1.name, iter1[2])

			if iter0 < #arg2 then
				var0 = var0 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0 ~= "" then
			arg0 = arg0 .. "\n" .. i18n("text_noRes_tip", var0)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1, arg2)
		end
	})
end

function shoppingBatch(arg0, arg1, arg2, arg3, arg4)
	local var0 = pg.shop_template[arg0]

	assert(var0, "shop_template中找不到商品id：" .. arg0)

	local var1 = getProxy(PlayerProxy):getData()[id2res(var0.resource_type)]
	local var2 = arg1.price or var0.resource_num
	local var3 = math.floor(var1 / var2)

	var3 = var3 <= 0 and 1 or var3
	var3 = arg2 ~= nil and arg2 < var3 and arg2 or var3

	local var4 = true
	local var5 = 1

	if var0 ~= nil and arg1.id then
		print(var3 * var0.num, "--", var3)
		assert(Item.getConfigData(arg1.id), "item config should be existence")

		local var6 = Item.New({
			id = arg1.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1.id
			},
			addNum = var0.num,
			maxNum = var3 * var0.num,
			defaultNum = var0.num,
			numUpdate = function(arg0, arg1)
				var5 = math.floor(arg1 / var0.num)

				local var0 = var5 * var2

				if var0 > var1 then
					setText(arg0, i18n(arg3, var0, arg1, COLOR_RED, var6))

					var4 = false
				else
					setText(arg0, i18n(arg3, var0, arg1, COLOR_GREEN, var6))

					var4 = true
				end
			end,
			onYes = function()
				if var4 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0,
						count = var5
					})
				elseif arg4 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function gotoChargeScene(arg0, arg1)
	local var0 = getProxy(ContextProxy)
	local var1 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1.mediator, ChargeMediator) then
		var1.mediator:getViewComponent():switchSubViewByTogger(arg0)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0 or ChargeScene.TYPE_ITEM,
			noRes = arg1
		})
	end
end

function clearDrop(arg0)
	local var0 = findTF(arg0, "icon_bg")
	local var1 = findTF(arg0, "icon_bg/frame")
	local var2 = findTF(arg0, "icon_bg/icon")
	local var3 = findTF(arg0, "icon_bg/icon/icon")

	clearImageSprite(var0)
	clearImageSprite(var1)
	clearImageSprite(var2)

	if var3 then
		clearImageSprite(var3)
	end
end

local var7 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0, arg1, arg2, arg3)
	local var0 = findTF(arg0, "skill")
	local var1 = findTF(arg0, "lock")
	local var2 = findTF(arg0, "unknown")

	if arg1 then
		setActive(var0, true)
		setActive(var2, false)
		setActive(var1, not arg2)
		LoadImageSpriteAsync("skillicon/" .. arg1.icon, findTF(var0, "icon"))

		local var3 = arg1.color or "blue"

		setText(findTF(var0, "name"), shortenString(getSkillName(arg1.id), arg3 or 8))

		local var4 = findTF(var0, "level")

		setText(var4, "LEVEL: " .. (arg2 and arg2.level or "??"))
		setTextColor(var4, var7[var3])
	else
		setActive(var0, false)
		setActive(var2, true)
		setActive(var1, false)
	end
end

local var8 = true

function onBackButton(arg0, arg1, arg2, arg3)
	local var0 = GetOrAddComponent(arg1, "UILongPressTrigger")

	assert(arg2, "callback should exist")

	var0.longPressThreshold = defaultValue(arg3, 1)

	local function var1(arg0)
		return function()
			if var8 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0, var1 = arg2()

			if var0 then
				arg0(var1)
			end
		end
	end

	local var2 = var0.onReleased

	pg.DelegateInfo.Add(arg0, var2)
	var2:RemoveAllListeners()
	var2:AddListener(var1(function(arg0)
		arg0:emit(BaseUI.ON_BACK)
	end))

	local var3 = var0.onLongPressed

	pg.DelegateInfo.Add(arg0, var3)
	var3:RemoveAllListeners()
	var3:AddListener(var1(function(arg0)
		arg0:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1, var2 = pg.TimeMgr.GetInstance():parseTimeFrom(var0)

	return var1 * 86400 + (var2 + arg0) * 3600
end

function GetPerceptualSize(arg0)
	local function var0(arg0)
		if not arg0 then
			return 0, 1
		elseif arg0 > 240 then
			return 4, 1
		elseif arg0 > 225 then
			return 3, 1
		elseif arg0 > 192 then
			return 2, 1
		elseif arg0 < 126 then
			return 1, 0.5
		else
			return 1, 1
		end
	end

	if type(arg0) == "number" then
		return var0(arg0)
	end

	local var1 = 1
	local var2 = 0
	local var3 = 0
	local var4 = #arg0

	while var1 <= var4 do
		local var5 = string.byte(arg0, var1)
		local var6, var7 = var0(var5)

		var1 = var1 + var6
		var2 = var2 + var7
	end

	return var2
end

function shortenString(arg0, arg1)
	local var0 = 1
	local var1 = 0
	local var2 = 0
	local var3 = #arg0

	while var0 <= var3 do
		local var4 = string.byte(arg0, var0)
		local var5, var6 = GetPerceptualSize(var4)

		var0 = var0 + var5
		var1 = var1 + var6

		if arg1 <= math.ceil(var1) then
			var2 = var0

			break
		end
	end

	if var2 == 0 or var3 < var2 then
		return arg0
	end

	return string.sub(arg0, 1, var2 - 1) .. ".."
end

function shouldShortenString(arg0, arg1)
	local var0 = 1
	local var1 = 0
	local var2 = 0
	local var3 = #arg0

	while var0 <= var3 do
		local var4 = string.byte(arg0, var0)
		local var5, var6 = GetPerceptualSize(var4)

		var0 = var0 + var5
		var1 = var1 + var6

		if arg1 <= math.ceil(var1) then
			var2 = var0

			break
		end
	end

	if var2 == 0 or var3 < var2 then
		return false
	end

	return true
end

function nameValidityCheck(arg0, arg1, arg2, arg3)
	local var0 = true
	local var1, var2 = utf8_to_unicode(arg0)
	local var3 = filterEgyUnicode(filterSpecChars(arg0))
	local var4 = wordVer(arg0)

	if not checkSpaceValid(arg0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3[1]))

		var0 = false
	elseif var4 > 0 or var3 ~= arg0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3[4]))

		var0 = false
	elseif var2 < arg1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3[2]))

		var0 = false
	elseif arg2 < var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3[3]))

		var0 = false
	end

	return var0
end

function checkSpaceValid(arg0)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0 = string.gsub(arg0, " ", "")

	return arg0 == string.gsub(var0, "　", "")
end

function filterSpecChars(arg0)
	local var0 = {}
	local var1 = 0
	local var2 = 0
	local var3 = 0
	local var4 = 1

	while var4 <= #arg0 do
		local var5 = string.byte(arg0, var4)

		if not var5 then
			break
		end

		if var5 >= 48 and var5 <= 57 or var5 >= 65 and var5 <= 90 or var5 == 95 or var5 >= 97 and var5 <= 122 then
			table.insert(var0, string.char(var5))
		elseif var5 >= 228 and var5 <= 233 then
			local var6 = string.byte(arg0, var4 + 1)
			local var7 = string.byte(arg0, var4 + 2)

			if var6 and var7 and var6 >= 128 and var6 <= 191 and var7 >= 128 and var7 <= 191 then
				var4 = var4 + 2

				table.insert(var0, string.char(var5, var6, var7))

				var1 = var1 + 1
			end
		elseif var5 == 45 or var5 == 40 or var5 == 41 then
			table.insert(var0, string.char(var5))
		elseif var5 == 194 then
			local var8 = string.byte(arg0, var4 + 1)

			if var8 == 183 then
				var4 = var4 + 1

				table.insert(var0, string.char(var5, var8))

				var1 = var1 + 1
			end
		elseif var5 == 239 then
			local var9 = string.byte(arg0, var4 + 1)
			local var10 = string.byte(arg0, var4 + 2)

			if var9 == 188 and (var10 == 136 or var10 == 137) then
				var4 = var4 + 2

				table.insert(var0, string.char(var5, var9, var10))

				var1 = var1 + 1
			end
		elseif var5 == 206 or var5 == 207 then
			local var11 = string.byte(arg0, var4 + 1)

			if var5 == 206 and var11 >= 177 or var5 == 207 and var11 <= 134 then
				var4 = var4 + 1

				table.insert(var0, string.char(var5, var11))

				var1 = var1 + 1
			end
		elseif var5 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12 = string.byte(arg0, var4 + 1)
			local var13 = string.byte(arg0, var4 + 2)

			if var12 and var13 and var12 > 128 and var12 <= 191 and var13 >= 128 and var13 <= 191 then
				var4 = var4 + 2

				table.insert(var0, string.char(var5, var12, var13))

				var2 = var2 + 1
			end
		elseif var5 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14 = string.byte(arg0, var4 + 1)
			local var15 = string.byte(arg0, var4 + 2)

			if var14 and var15 and var14 >= 128 and var14 <= 191 and var15 >= 128 and var15 <= 191 then
				var4 = var4 + 2

				table.insert(var0, string.char(var5, var14, var15))

				var3 = var3 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4 ~= 1 and var5 == 32 and string.byte(arg0, var4 + 1) ~= 32 then
				table.insert(var0, string.char(var5))
			end

			if var5 >= 192 and var5 <= 223 then
				local var16 = string.byte(arg0, var4 + 1)

				var4 = var4 + 1

				if var5 == 194 and var16 and var16 >= 128 then
					table.insert(var0, string.char(var5, var16))
				elseif var5 == 195 and var16 and var16 <= 191 then
					table.insert(var0, string.char(var5, var16))
				end
			end

			if var5 == 195 then
				local var17 = string.byte(arg0, var4 + 1)

				if var17 == 188 then
					table.insert(var0, string.char(var5, var17))
				end
			end
		end

		var4 = var4 + 1
	end

	return table.concat(var0), var1 + var2 + var3
end

function filterEgyUnicode(arg0)
	arg0 = string.gsub(arg0, "\xF0\x93[\x80-\x8F][\x80-\xBF]", "")
	arg0 = string.gsub(arg0, "\xF0\x93\x90[\x80-\xAF]", "")

	return arg0
end

function shiftPanel(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	arg3 = arg3 or 0.2

	if arg5 then
		LeanTween.cancel(go(arg0))
	end

	local var0 = rtf(arg0)

	arg1 = arg1 or var0.anchoredPosition.x
	arg2 = arg2 or var0.anchoredPosition.y

	local var1 = LeanTween.move(var0, Vector3(arg1, arg2, 0), arg3)

	arg7 = arg7 or LeanTweenType.easeInOutSine

	var1:setEase(arg7)

	if arg4 then
		var1:setDelay(arg4)
	end

	if arg6 then
		GetOrAddComponent(arg0, "CanvasGroup").blocksRaycasts = false
	end

	var1:setOnComplete(System.Action(function()
		if arg8 then
			arg8()
		end

		if arg6 then
			GetOrAddComponent(arg0, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1
end

function TweenValue(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local var0 = LeanTween.value(go(arg0), arg1, arg2, arg3):setOnUpdate(System.Action_float(function(arg0)
		if arg5 then
			arg5(arg0)
		end
	end)):setOnComplete(System.Action(function()
		if arg6 then
			arg6()
		end
	end)):setDelay(arg4 or 0)

	if arg7 and arg7 > 0 then
		var0:setRepeat(arg7)
	end

	return var0
end

function rotateAni(arg0, arg1, arg2)
	return LeanTween.rotate(rtf(arg0), 360 * arg1, arg2):setLoopClamp()
end

function blinkAni(arg0, arg1, arg2, arg3)
	return LeanTween.alpha(rtf(arg0), arg3 or 0, arg1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2 or 0)
end

function scaleAni(arg0, arg1, arg2, arg3)
	return LeanTween.scale(rtf(arg0), arg3 or 0, arg1):setLoopPingPong(arg2 or 0)
end

function floatAni(arg0, arg1, arg2, arg3)
	local var0 = arg0.localPosition.y + arg1

	return LeanTween.moveY(rtf(arg0), var0, arg2):setLoopPingPong(arg3 or 0)
end

local var9 = tostring

function tostring(arg0)
	if arg0 == nil then
		return "nil"
	end

	local var0 = var9(arg0)

	if var0 == nil then
		if type(arg0) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0
end

function wordVer(arg0, arg1)
	if arg0.match(arg0, ChatConst.EmojiCodeMatch) then
		return 0, arg0
	end

	arg1 = arg1 or {}

	local var0 = filterEgyUnicode(arg0)

	if #var0 ~= #arg0 then
		if arg1.isReplace then
			arg0 = var0
		else
			return 1
		end
	end

	local var1 = wordSplit(arg0)
	local var2 = pg.word_template
	local var3 = pg.word_legal_template

	arg1.isReplace = arg1.isReplace or false
	arg1.replaceWord = arg1.replaceWord or "*"

	local var4 = #var1
	local var5 = 1
	local var6 = ""
	local var7 = 0

	while var5 <= var4 do
		local var8, var9, var10 = wordLegalMatch(var1, var3, var5)

		if var8 then
			var5 = var9
			var6 = var6 .. var10
		else
			local var11, var12, var13 = wordVerMatch(var1, var2, arg1, var5, "", false, var5, "")

			if var11 then
				var5 = var12
				var7 = var7 + 1

				if arg1.isReplace then
					var6 = var6 .. var13
				end
			else
				if arg1.isReplace then
					var6 = var6 .. var1[var5]
				end

				var5 = var5 + 1
			end
		end
	end

	if arg1.isReplace then
		return var7, var6
	else
		return var7
	end
end

function wordLegalMatch(arg0, arg1, arg2, arg3, arg4)
	if arg2 > #arg0 then
		return arg3, arg2, arg4
	end

	local var0 = arg0[arg2]
	local var1 = arg1[var0]

	arg4 = arg4 == nil and "" or arg4

	if var1 then
		if var1.this then
			return wordLegalMatch(arg0, var1, arg2 + 1, true, arg4 .. var0)
		else
			return wordLegalMatch(arg0, var1, arg2 + 1, false, arg4 .. var0)
		end
	else
		return arg3, arg2, arg4
	end
end

local var10 = string.byte("a")
local var11 = string.byte("z")
local var12 = string.byte("A")
local var13 = string.byte("Z")

local function var14(arg0)
	if not arg0 then
		return arg0
	end

	local var0 = string.byte(arg0)

	if var0 > 128 then
		return
	end

	if var0 >= var10 and var0 <= var11 then
		return string.char(var0 - 32)
	elseif var0 >= var12 and var0 <= var13 then
		return string.char(var0 + 32)
	else
		return arg0
	end
end

function wordVerMatch(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	if arg3 > #arg0 then
		return arg5, arg6, arg7
	end

	local var0 = arg0[arg3]
	local var1 = arg1[var0]

	if var1 then
		local var2, var3, var4 = wordVerMatch(arg0, var1, arg2, arg3 + 1, arg2.isReplace and arg4 .. arg2.replaceWord or arg4, var1.this or arg5, var1.this and arg3 + 1 or arg6, var1.this and (arg2.isReplace and arg4 .. arg2.replaceWord or arg4) or arg7)

		if var2 then
			return var2, var3, var4
		end
	end

	local var5 = var14(var0)
	local var6 = arg1[var5]

	if var5 ~= var0 and var6 then
		local var7, var8, var9 = wordVerMatch(arg0, var6, arg2, arg3 + 1, arg2.isReplace and arg4 .. arg2.replaceWord or arg4, var6.this or arg5, var6.this and arg3 + 1 or arg6, var6.this and (arg2.isReplace and arg4 .. arg2.replaceWord or arg4) or arg7)

		if var7 then
			return var7, var8, var9
		end
	end

	return arg5, arg6, arg7
end

function wordSplit(arg0)
	local var0 = {}

	for iter0 in arg0.gmatch(arg0, "[\x01-\x7F\xC2-\xF4][\x80-\xBF]*") do
		var0[#var0 + 1] = iter0
	end

	return var0
end

function contentWrap(arg0, arg1, arg2)
	local var0 = LuaHelper.WrapContent(arg0, arg1, arg2)

	return #var0 ~= #arg0, var0
end

function cancelRich(arg0)
	local var0

	for iter0 = 1, 20 do
		local var1

		arg0, var1 = string.gsub(arg0, "<([^>]*)>", "%1")

		if var1 <= 0 then
			break
		end
	end

	return arg0
end

function getSkillConfig(arg0)
	local var0 = require("GameCfg.buff.buff_" .. arg0)

	if not var0 then
		warning("找不到技能配置: " .. arg0)

		return
	end

	local var1 = Clone(var0)

	var1.name = getSkillName(arg0)
	var1.desc = HXSet.hxLan(var1.desc)
	var1.desc_get = HXSet.hxLan(var1.desc_get)

	_.each(var1, function(arg0)
		arg0.desc = HXSet.hxLan(arg0.desc)
	end)

	return var1
end

function getSkillName(arg0)
	local var0 = pg.skill_data_template[arg0] or pg.skill_data_display[arg0]

	if var0 then
		return HXSet.hxLan(var0.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0, arg1)
	local var0 = arg1 and pg.skill_world_display[arg0] and setmetatable({}, {
		__index = function(arg0, arg1)
			return pg.skill_world_display[arg0][arg1] or pg.skill_data_template[arg0][arg1]
		end
	}) or pg.skill_data_template[arg0]

	if not var0 then
		return ""
	end

	local var1 = var0.desc_get ~= "" and var0.desc_get or var0.desc

	for iter0, iter1 in pairs(var0.desc_get_add) do
		local var2 = setColorStr(iter1[1], COLOR_GREEN)

		if iter1[2] then
			var2 = var2 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1[2], COLOR_GREEN))
		end

		var1 = specialGSub(var1, "$" .. iter0, var2)
	end

	return HXSet.hxLan(var1)
end

function getSkillDescLearn(arg0, arg1, arg2)
	local var0 = arg2 and pg.skill_world_display[arg0] and setmetatable({}, {
		__index = function(arg0, arg1)
			return pg.skill_world_display[arg0][arg1] or pg.skill_data_template[arg0][arg1]
		end
	}) or pg.skill_data_template[arg0]

	if not var0 then
		return ""
	end

	local var1 = var0.desc

	if not var0.desc_add then
		return HXSet.hxLan(var1)
	end

	for iter0, iter1 in pairs(var0.desc_add) do
		local var2 = iter1[arg1][1]

		if iter1[arg1][2] then
			var2 = var2 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1[arg1][2])
		end

		var1 = specialGSub(var1, "$" .. iter0, setColorStr(var2, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1)
end

function getSkillDesc(arg0, arg1, arg2)
	local var0 = arg2 and pg.skill_world_display[arg0] and setmetatable({}, {
		__index = function(arg0, arg1)
			return pg.skill_world_display[arg0][arg1] or pg.skill_data_template[arg0][arg1]
		end
	}) or pg.skill_data_template[arg0]

	if not var0 then
		return ""
	end

	local var1 = var0.desc

	if not var0.desc_add then
		return HXSet.hxLan(var1)
	end

	for iter0, iter1 in pairs(var0.desc_add) do
		local var2 = setColorStr(iter1[arg1][1], COLOR_GREEN)

		var1 = specialGSub(var1, "$" .. iter0, var2)
	end

	return HXSet.hxLan(var1)
end

function specialGSub(arg0, arg1, arg2)
	arg0 = string.gsub(arg0, "<color=#", "<color=NNN")
	arg0 = string.gsub(arg0, "#", "")
	arg2 = string.gsub(arg2, "%%", "%%%%")
	arg0 = string.gsub(arg0, arg1, arg2)
	arg0 = string.gsub(arg0, "<color=NNN", "<color=#")

	return arg0
end

function topAnimation(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = {}

	arg4 = arg4 or 0.27

	local var1 = 0.05

	if arg0 then
		local var2 = arg0.transform.localPosition.x

		setAnchoredPosition(arg0, {
			x = var2 - 500
		})
		shiftPanel(arg0, var2, nil, 0.05, arg4, true, true)
		setActive(arg0, true)
	end

	setActive(arg1, false)
	setActive(arg2, false)
	setActive(arg3, false)

	for iter0 = 1, 3 do
		table.insert(var0, LeanTween.delayedCall(arg4 + 0.13 + var1 * iter0, System.Action(function()
			if arg1 then
				setActive(arg1, not arg1.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0, LeanTween.delayedCall(arg4 + 0.02 + var1 * iter0, System.Action(function()
			if arg2 then
				setActive(arg2, not go(arg2).activeSelf)
			end

			if arg2 then
				setActive(arg3, not go(arg3).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5 then
		table.insert(var0, LeanTween.delayedCall(arg4 + 0.13 + var1 * 3 + 0.1, System.Action(function()
			arg5()
		end)).uniqueId)
	end

	return var0
end

function cancelTweens(arg0)
	assert(arg0, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0, iter1 in ipairs(arg0) do
		if iter1 then
			LeanTween.cancel(iter1)
		end
	end
end

function getOfflineTimeStamp(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime() - arg0
	local var1 = ""

	if var0 <= 59 then
		var1 = i18n("just_now")
	elseif var0 <= 3599 then
		var1 = i18n("several_minutes_before", math.floor(var0 / 60))
	elseif var0 <= 86399 then
		var1 = i18n("several_hours_before", math.floor(var0 / 3600))
	else
		var1 = i18n("several_days_before", math.floor(var0 / 86400))
	end

	return var1
end

function playMovie(arg0, arg1, arg2)
	local var0 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0, function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0 = GCHandle.Alloc(arg0, GCHandleType.Pinned)

			setActive(var0, true)

			local var1 = var0:AddComponent(typeof(CriManaMovieControllerForUI))

			var1.player:SetData(arg0, arg0.Length)

			var1.target = var0:GetComponent(typeof(Image))
			var1.loop = false
			var1.additiveMode = false
			var1.playOnStart = true

			local var2

			var2 = Timer.New(function()
				if var1.player.status == CriMana.Player.Status.PlayEnd or var1.player.status == CriMana.Player.Status.Stop or var1.player.status == CriMana.Player.Status.Error then
					var2:Stop()
					Object.Destroy(var1)
					GCHandle.Free(var0)
					setActive(var0, false)

					if arg1 then
						arg1()
					end
				end
			end, 0.2, -1)

			var2:Start()
			removeOnButton(var0)

			if arg2 then
				onButton(nil, var0, function()
					var1:Stop()
					GetOrAddComponent(var0, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1 then
		arg1()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0)
	if PaintCameraAdjustOn ~= arg0 then
		local var0 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0
	end
end

function ManhattonDist(arg0, arg1)
	return math.abs(arg0.row - arg1.row) + math.abs(arg0.column - arg1.column)
end

function checkFirstHelpShow(arg0)
	local var0 = getProxy(SettingsProxy)

	if not var0:checkReadHelp(arg0) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0].tip
		})
		var0:recordReadHelp(arg0)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0)
	enableNotch(arg0, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0)
	enableNotch(arg0, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0, arg1)
	if arg0 == nil then
		return
	end

	local var0 = arg0:GetComponent("NotchAdapt")
	local var1 = arg0:GetComponent("AspectRatioFitter")

	var0.enabled = arg1

	if var1 then
		if arg1 then
			var1.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1.enabled
			var1.enabled = false
		end
	end
end

function comma_value(arg0)
	local var0 = arg0
	local var1 = 0

	repeat
		local var2

		var0, var2 = string.gsub(var0, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2 == 0

	return var0
end

local var15 = 0.2

function SwitchPanel(arg0, arg1, arg2, arg3, arg4, arg5)
	arg3 = defaultValue(arg3, var15)

	if arg5 then
		LeanTween.cancel(go(arg0))
	end

	local var0 = Vector3.New(tf(arg0).localPosition.x, tf(arg0).localPosition.y, tf(arg0).localPosition.z)

	if arg1 then
		var0.x = arg1
	end

	if arg2 then
		var0.y = arg2
	end

	local var1 = LeanTween.move(rtf(arg0), var0, arg3):setEase(LeanTweenType.easeInOutSine)

	if arg4 then
		var1:setDelay(arg4)
	end

	return var1
end

function updateActivityTaskStatus(arg0)
	local var0 = arg0:getConfig("config_id")
	local var1, var2 = getActivityTask(arg0, true)

	if not var2 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0)
	local var0 = getProxy(TaskProxy)
	local var1 = arg0:getNDay()

	for iter0, iter1 in ipairs(arg0:getConfig("config_data")) do
		local var2 = pg.battlepass_task_group[iter1]

		if var1 >= var2.time and underscore.any(underscore.flatten(var2.task_group), function(arg0)
			return var0:getTaskVO(arg0) == nil
		end) then
			pg.m02:sendNotification(GAME.CRUSING_CMD, {
				cmd = 1,
				activity_id = arg0.id
			})

			return true
		end
	end

	return false
end

function setShipCardFrame(arg0, arg1, arg2)
	arg0.localScale = Vector3.one
	arg0.anchorMin = Vector2.zero
	arg0.anchorMax = Vector2.one

	local var0 = arg2 or arg1

	GetImageSpriteFromAtlasAsync("shipframe", var0, arg0)

	local var1 = pg.frame_resource[var0]

	if var1 then
		local var2 = var1.param

		arg0.offsetMin = Vector2(var2[1], var2[2])
		arg0.offsetMax = Vector2(var2[3], var2[4])
	else
		arg0.offsetMin = Vector2.zero
		arg0.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0, arg1, arg2)
	arg0.localScale = Vector3.one
	arg0.anchorMin = Vector2.zero
	arg0.anchorMax = Vector2.one

	setImageSprite(arg0, GetSpriteFromAtlas("shipframeb", "b" .. (arg2 or arg1)))

	local var0 = "b" .. (arg2 or arg1)
	local var1 = pg.frame_resource[var0]

	if var1 then
		local var2 = var1.param

		arg0.offsetMin = Vector2(var2[1], var2[2])
		arg0.offsetMax = Vector2(var2[3], var2[4])
	else
		arg0.offsetMin = Vector2.zero
		arg0.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0, arg1)
	if arg1 then
		local var0 = arg1 .. "(Clone)"
		local var1 = false

		eachChild(arg0, function(arg0)
			setActive(arg0, arg0.name == var0)

			var1 = var1 or arg0.name == var0
		end)

		if not var1 then
			LoadAndInstantiateAsync("effect", arg1, function(arg0)
				if IsNil(arg0) or findTF(arg0, var0) then
					Object.Destroy(arg0)
				else
					setParent(arg0, arg0)
					setActive(arg0, true)
				end
			end)
		end
	end

	setActive(arg0, arg1)
end

function setProposeMarkIcon(arg0, arg1)
	local var0 = arg0:Find("proposeShipCard(Clone)")
	local var1 = arg1.propose and not arg1:ShowPropose()

	if var0 then
		setActive(var0, var1)
	elseif var1 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0)
			if IsNil(arg0) or arg0:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0)
			else
				setParent(arg0, arg0, false)
			end
		end)
	end
end

function flushShipCard(arg0, arg1)
	local var0 = arg1:rarity2bgPrint()
	local var1 = findTF(arg0, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0, "", var1)

	local var2 = findTF(arg0, "content/ship_icon")
	local var3 = arg1 and {
		"shipYardIcon/" .. arg1:getPainting(),
		arg1:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3[1], var3[2], var2)

	local var4 = arg1:getShipType()
	local var5 = findTF(arg0, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4), var5)
	setText(findTF(arg0, "content/dockyard/lv/Text"), defaultValue(arg1.level, 1))

	local var6 = arg1:getStar()
	local var7 = arg1:getMaxStar()
	local var8 = findTF(arg0, "content/front/stars")

	setActive(var8, true)

	local var9 = findTF(var8, "star_tpl")
	local var10 = var8.childCount

	for iter0 = 1, Ship.CONFIG_MAX_STAR do
		local var11 = var10 < iter0 and cloneTplTo(var9, var8) or var8:GetChild(iter0 - 1)

		setActive(var11, iter0 <= var7)
		triggerToggle(var11, iter0 <= var6)
	end

	local var12 = findTF(arg0, "content/front/frame")
	local var13, var14 = arg1:GetFrameAndEffect()

	setShipCardFrame(var12, var0, var13)
	setFrameEffect(findTF(arg0, "content/front/bg_other"), var14)
	setProposeMarkIcon(arg0:Find("content/dockyard/propose"), arg1)
end

function TweenItemAlphaAndWhite(arg0)
	LeanTween.cancel(arg0)

	local var0 = GetOrAddComponent(arg0, "CanvasGroup")

	var0.alpha = 0

	LeanTween.alphaCanvas(var0, 1, 0.2):setUseEstimatedTime(true)

	local var1 = findTF(arg0.transform, "white_mask")

	if var1 then
		setActive(var1, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0)
	LeanTween.cancel(arg0)

	GetOrAddComponent(arg0, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0)
	local var0 = {}
	local var1 = getProxy(ShipSkinProxy):getSkinList()
	local var2 = getProxy(CollectionProxy):getShipGroup(arg0)

	if var2 then
		local var3 = ShipGroup.getSkinList(arg0)

		for iter0, iter1 in ipairs(var3) do
			if iter1.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1, iter1.id) or iter1.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2.trans or iter1.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2.married == 1 then
				var0[iter1.id] = true
			end
		end
	end

	return var0
end

function split(arg0, arg1)
	local var0 = {}

	if not arg0 then
		return nil
	end

	local var1 = #arg0
	local var2 = 1

	while var2 <= var1 do
		local var3 = string.find(arg0, arg1, var2)

		if var3 == nil then
			table.insert(var0, string.sub(arg0, var2, var1))

			break
		end

		table.insert(var0, string.sub(arg0, var2, var3 - 1))

		if var3 == var1 then
			table.insert(var0, "")

			break
		end

		var2 = var3 + 1
	end

	return var0
end

function NumberToChinese(arg0, arg1)
	local var0 = ""
	local var1 = #arg0

	for iter0 = 1, var1 do
		local var2 = string.sub(arg0, iter0, iter0)

		if var2 ~= "0" or var2 == "0" and not arg1 then
			if arg1 then
				if var1 >= 2 then
					if iter0 == 1 then
						if var2 == "1" then
							var0 = i18n("number_" .. 10)
						else
							var0 = i18n("number_" .. var2) .. i18n("number_" .. 10)
						end
					else
						var0 = var0 .. i18n("number_" .. var2)
					end
				else
					var0 = var0 .. i18n("number_" .. var2)
				end
			else
				var0 = var0 .. i18n("number_" .. var2)
			end
		end
	end

	return var0
end

function getActivityTask(arg0, arg1)
	local var0 = getProxy(TaskProxy)
	local var1 = arg0:getConfig("config_data")
	local var2 = arg0:getNDay(arg0.data1)
	local var3
	local var4
	local var5

	for iter0 = math.max(arg0.data3, 1), math.min(var2, #var1) do
		local var6 = _.flatten({
			var1[iter0]
		})

		for iter1, iter2 in ipairs(var6) do
			local var7 = var0:getTaskById(iter2)

			if var7 then
				return var7.id, var7
			end

			if var4 then
				var5 = var0:getFinishTaskById(iter2)

				if var5 then
					var4 = var5
				elseif arg1 then
					return iter2
				else
					return var4.id, var4
				end
			else
				var4 = var0:getFinishTaskById(iter2)
				var5 = var5 or iter2
			end
		end
	end

	if var4 then
		return var4.id, var4
	else
		return var5
	end
end

function setImageFromImage(arg0, arg1, arg2)
	local var0 = GetComponent(arg0, "Image")

	var0.sprite = GetComponent(arg1, "Image").sprite

	if arg2 then
		var0:SetNativeSize()
	end
end

function skinTimeStamp(arg0)
	local var0, var1, var2, var3 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0)

	if var0 >= 1 then
		return i18n("limit_skin_time_day", var0)
	elseif var0 <= 0 and var1 > 0 then
		return i18n("limit_skin_time_day_min", var1, var2)
	elseif var0 <= 0 and var1 <= 0 and (var2 > 0 or var3 > 0) then
		return i18n("limit_skin_time_min", math.max(var2, 1))
	elseif var0 <= 0 and var1 <= 0 and var2 <= 0 and var3 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = math.max(arg0 - var0, 0)
	local var2 = math.floor(var1 / 86400)

	if var2 > 0 then
		return i18n("time_remaining_tip") .. var2 .. i18n("word_date")
	else
		local var3 = math.floor(var1 / 3600)

		if var3 > 0 then
			return i18n("time_remaining_tip") .. var3 .. i18n("word_hour")
		else
			local var4 = math.floor(var1 / 60)

			if var4 > 0 then
				return i18n("time_remaining_tip") .. var4 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime() - arg0
	local var1 = var0 / 86400

	if var1 > 1 then
		return i18n("ins_word_day", math.floor(var1))
	else
		local var2 = var0 / 3600

		if var2 > 1 then
			return i18n("ins_word_hour", math.floor(var2))
		else
			local var3 = var0 / 60

			if var3 > 1 then
				return i18n("ins_word_minu", math.floor(var3))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime() - arg0
	local var1 = var0 / 86400

	if var1 > 1 then
		return i18n1(math.floor(var1) .. "d")
	else
		local var2 = var0 / 3600

		if var2 > 1 then
			return i18n1(math.floor(var2) .. "h")
		else
			local var3 = var0 / 60

			if var3 > 1 then
				return i18n1(math.floor(var3) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0)
	local var0, var1, var2, var3 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0)

	if var0 <= 0 and var1 <= 0 and var2 <= 0 and var3 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0, var1, var2)
	end
end

function checkExist(arg0, ...)
	local var0 = {
		...
	}

	for iter0, iter1 in ipairs(var0) do
		if arg0 == nil then
			break
		end

		assert(type(arg0) == "table", "type error : intermediate target should be table")
		assert(type(iter1) == "table", "type error : param should be table")

		if type(arg0[iter1[1]]) == "function" then
			arg0 = arg0[iter1[1]](arg0, unpack(iter1[2] or {}))
		else
			arg0 = arg0[iter1[1]]
		end
	end

	return arg0
end

function AcessWithinNull(arg0, arg1)
	if arg0 == nil then
		return
	end

	assert(type(arg0) == "table")

	return arg0[arg1]
end

function showRepairMsgbox()
	local var0 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2 = {
		text = i18n("msgbox_repair_painting"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-painting.csv") then
				BundleWizard.Inst:GetGroupMgr("PAINTING"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = i18n("resource_verify_warn"),
		custom = {
			var2,
			var1,
			var0
		}
	})
end

function resourceVerify(arg0, arg1)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0 = Application.persistentDataPath .. "/hashes.csv"
	local var1
	local var2 = PathMgr.ReadAllLines(var0)
	local var3 = {}

	if arg0 then
		setActive(arg0, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4()
		if arg0 then
			setActive(arg0, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1)

		if var1 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("resource_verify_fail", ""),
				onYes = function()
					VersionMgr.Inst:DeleteCacheFiles()
					Application.Quit()
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("resource_verify_success")
			})
		end
	end

	local var5 = var2.Length
	local var6

	local function var7(arg0)
		if arg0 < 0 then
			var4()

			return
		end

		if arg1 then
			setSlider(arg1, 0, var5, var5 - arg0)
		end

		local var0 = string.split(var2[arg0], ",")
		local var1 = var0[1]
		local var2 = var0[3]
		local var3 = PathMgr.getAssetBundle(var1)

		if PathMgr.FileExists(var3) then
			local var4 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1))

			if var2 == HashUtil.CalcMD5(var4) then
				onNextTick(function()
					var7(arg0 - 1)
				end)

				return
			end
		end

		var1 = var1

		var4()
	end

	var7(var5 - 1)
end

function splitByWordEN(arg0, arg1)
	local var0 = string.split(arg0, " ")
	local var1 = ""
	local var2 = ""
	local var3 = arg1:GetComponent(typeof(RectTransform))
	local var4 = arg1:GetComponent(typeof(Text))
	local var5 = var3.rect.width

	for iter0, iter1 in ipairs(var0) do
		local var6 = var2

		var2 = var2 == "" and iter1 or var2 .. " " .. iter1

		setText(arg1, var2)

		if var5 < var4.preferredWidth then
			var1 = var1 == "" and var6 or var1 .. "\n" .. var6
			var2 = iter1
		end

		if iter0 >= #var0 then
			var1 = var1 == "" and var2 or var1 .. "\n" .. var2
		end
	end

	return var1
end

function checkBirthFormat(arg0)
	if #arg0 ~= 8 then
		return false
	end

	local var0 = 0
	local var1 = #arg0

	while var0 < var1 do
		local var2 = string.byte(arg0, var0 + 1)

		if var2 < 48 or var2 > 57 then
			return false
		end

		var0 = var0 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0)
	local var0 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0, function(arg0)
		return arg0 == arg0
	end)
end

function GetServerState(arg0)
	local var0 = -1
	local var1 = 0
	local var2 = 1
	local var3 = 2
	local var4 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4 = string.gsub(var4, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4, function(arg0, arg1)
		local var0 = true
		local var1 = false

		for iter0 in string.gmatch(arg1, "\"state\":%d") do
			if iter0 ~= "\"state\":1" then
				var0 = false
			end

			var1 = true
		end

		if not var1 then
			var0 = false
		end

		if arg0 ~= nil then
			arg0(var0 and var2 or var1)
		end
	end)
end

function setScrollText(arg0, arg1)
	GetOrAddComponent(arg0, "ScrollText"):SetText(arg1)
end

function changeToScrollText(arg0, arg1)
	local var0 = GetComponent(arg0, typeof(Text))

	assert(var0, "without component<Text>")

	local var1 = arg0:Find("subText")

	if not var1 then
		var1 = cloneTplTo(arg0, arg0, "subText")

		eachChild(arg0, function(arg0)
			setActive(arg0, arg0 == var1)
		end)

		arg0:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1, arg1)
end

local var16
local var17
local var18
local var19

local function var20(arg0, arg1, arg2)
	local var0 = arg0:Find("base")
	local var1, var2, var3 = Equipment.GetInfoTrans(arg1, arg2)

	if arg1.nextValue then
		local var4 = {
			name = arg1.name,
			type = arg1.type,
			value = arg1.nextValue
		}
		local var5, var6 = Equipment.GetInfoTrans(var4, arg2)

		var2 = var2 .. setColorStr("   >   " .. var6, COLOR_GREEN)
	end

	setText(var0:Find("name"), var1)

	if var3 then
		local var7 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0:Find("value"), var2 .. var7)
	else
		setText(var0:Find("value"), var2)
	end

	setActive(var0:Find("value/up"), arg1.compare and arg1.compare > 0)
	setActive(var0:Find("value/down"), arg1.compare and arg1.compare < 0)
	triggerToggle(var0, arg1.lock_open)

	if not arg1.lock_open and arg1.sub and #arg1.sub > 0 then
		GetComponent(var0, typeof(Toggle)).enabled = true
	else
		setActive(var0:Find("name/close"), false)
		setActive(var0:Find("name/open"), false)

		GetComponent(var0, typeof(Toggle)).enabled = false
	end
end

local function var21(arg0, arg1, arg2, arg3)
	var20(arg0, arg2, arg3)

	if not arg2.sub or #arg2.sub == 0 then
		return
	end

	var18(arg0:Find("subs"), arg1, arg2.sub, arg3)
end

function var18(arg0, arg1, arg2, arg3)
	removeAllChildren(arg0)
	var19(arg0, arg1, arg2, arg3)
end

function var19(arg0, arg1, arg2, arg3)
	for iter0, iter1 in ipairs(arg2) do
		local var0 = cloneTplTo(arg1, arg0)

		var21(var0, arg1, iter1, arg3)
	end
end

function updateEquipInfo(arg0, arg1, arg2, arg3)
	local var0 = arg0:Find("attr_tpl")

	var18(arg0:Find("attrs"), var0, arg1.attrs, arg3)
	setActive(arg0:Find("skill"), arg2)

	if arg2 then
		var21(arg0:Find("skill/attr"), var0, {
			name = i18n("skill"),
			value = setColorStr(arg2.name, "#FFDE00FF")
		}, arg3)
		setText(arg0:Find("skill/value/Text"), getSkillDescGet(arg2.id))
	end

	setActive(arg0:Find("weapon"), #arg1.weapon.sub > 0)

	if #arg1.weapon.sub > 0 then
		var18(arg0:Find("weapon"), var0, {
			arg1.weapon
		}, arg3)
	end

	setActive(arg0:Find("equip_info"), #arg1.equipInfo.sub > 0)

	if #arg1.equipInfo.sub > 0 then
		var18(arg0:Find("equip_info"), var0, {
			arg1.equipInfo
		}, arg3)
	end

	var21(arg0:Find("part/attr"), var0, {
		name = i18n("equip_info_23")
	}, arg3)

	local var1 = arg0:Find("part/value")
	local var2 = var1:Find("label")
	local var3 = {}
	local var4 = {}

	if #arg1.part[1] == 0 and #arg1.part[2] == 0 then
		setmetatable(var3, {
			__index = function(arg0, arg1)
				return true
			end
		})
		setmetatable(var4, {
			__index = function(arg0, arg1)
				return true
			end
		})
	else
		for iter0, iter1 in ipairs(arg1.part[1]) do
			var3[iter1] = true
		end

		for iter2, iter3 in ipairs(arg1.part[2]) do
			var4[iter3] = true
		end
	end

	local var5 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3, var4)

	UIItemList.StaticAlign(var1, var2, #var5, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var5[arg1]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0), arg2)
			setActive(arg2:Find("main"), var3[var0] and not var4[var0])
			setActive(arg2:Find("sub"), var4[var0] and not var3[var0])
			setImageAlpha(arg2, not var3[var0] and not var4[var0] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0, arg1, arg2)
	local var0 = arg0:Find("attr_tpl")

	var18(arg0:Find("attrs"), var0, arg1.attrs, arg2)
	setActive(arg0:Find("weapon"), #arg1.weapon.sub > 0)

	if #arg1.weapon.sub > 0 then
		var18(arg0:Find("weapon"), var0, {
			arg1.weapon
		}, arg2)
	end

	setActive(arg0:Find("equip_info"), #arg1.equipInfo.sub > 0)

	if #arg1.equipInfo.sub > 0 then
		var18(arg0:Find("equip_info"), var0, {
			arg1.equipInfo
		}, arg2)
	end
end

function setCanvasOverrideSorting(arg0, arg1)
	local var0 = arg0.parent

	arg0:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0) then
		GetOrAddComponent(arg0, typeof(Canvas)).overrideSorting = arg1
	else
		setActive(arg0, true)

		GetOrAddComponent(arg0, typeof(Canvas)).overrideSorting = arg1

		setActive(arg0, false)
	end

	arg0:SetParent(var0, false)
end

function createNewGameObject(arg0, arg1)
	local var0 = GameObject.New()

	if arg0 then
		var0.name = "model"
	end

	var0.layer = arg1 or Layer.UI

	return GetOrAddComponent(var0, "RectTransform")
end

function CreateShell(arg0)
	if type(arg0) ~= "table" and type(arg0) ~= "userdata" then
		return arg0
	end

	local var0 = setmetatable({
		__index = arg0
	}, arg0)

	return setmetatable({}, var0)
end

function CameraFittingSettin(arg0)
	local var0 = GetComponent(arg0, typeof(Camera))
	local var1 = 1.77777777777778
	local var2 = Screen.width / Screen.height

	if var2 < var1 then
		local var3 = var2 / var1

		var0.rect = var0.Rect.New(0, (1 - var3) / 2, 1, var3)
	end
end

function SwitchSpecialChar(arg0, arg1)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0 = arg0:gsub(" ", " ")
		arg0 = arg0:gsub("\t", "    ")
	end

	if not arg1 then
		arg0 = arg0:gsub("\n", " ")
	end

	return arg0
end

function AfterCheck(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		var0[iter0] = iter1[1]()
	end

	arg1()

	for iter2, iter3 in ipairs(arg0) do
		if var0[iter2] ~= iter3[1]() then
			iter3[2]()
		end

		var0[iter2] = iter3[1]()
	end
end

function CompareFuncs(arg0, arg1)
	local var0 = {}

	local function var1(arg0, arg1)
		var0[arg0] = var0[arg0] or {}
		var0[arg0][arg1] = var0[arg0][arg1] or arg0[arg0](arg1)

		return var0[arg0][arg1]
	end

	return function(arg0, arg1)
		local var0 = 1

		while var0 <= #arg0 do
			local var1 = var1(var0, arg0)
			local var2 = var1(var0, arg1)

			if var1 == var2 then
				var0 = var0 + 1
			else
				return var1 < var2
			end
		end

		return tobool(arg1)
	end
end

function DropResultIntegration(arg0)
	local var0 = {}
	local var1 = 1

	while var1 <= #arg0 do
		local var2 = arg0[var1].type
		local var3 = arg0[var1].id

		var0[var2] = var0[var2] or {}

		if var0[var2][var3] then
			local var4 = arg0[var0[var2][var3]]
			local var5 = table.remove(arg0, var1)

			var4.count = var4.count + var5.count
		else
			var0[var2][var3] = var1
			var1 = var1 + 1
		end
	end

	local var6 = {
		function(arg0)
			local var0 = arg0.type
			local var1 = arg0.id

			if var0 == DROP_TYPE_SHIP then
				return 1
			elseif var0 == DROP_TYPE_RESOURCE then
				if var1 == 1 then
					return 2
				else
					return 3
				end
			elseif var0 == DROP_TYPE_ITEM then
				if var1 == 59010 then
					return 4
				elseif var1 == 59900 then
					return 5
				else
					local var2 = Item.getConfigData(var1)
					local var3 = var2 and var2.type or 0

					if var3 == 9 then
						return 6
					elseif var3 == 5 then
						return 7
					elseif var3 == 4 then
						return 8
					elseif var3 == 7 then
						return 9
					end
				end
			elseif var0 == DROP_TYPE_VITEM and var1 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0)
			local var0

			if arg0.type == DROP_TYPE_SHIP then
				var0 = pg.ship_data_statistics[arg0.id]
			elseif arg0.type == DROP_TYPE_ITEM then
				var0 = Item.getConfigData(arg0.id)
			end

			return (var0 and var0.rarity or 0) * -1
		end,
		function(arg0)
			return arg0.id
		end
	}

	table.sort(arg0, CompareFuncs(var6))
end

function getLoginConfig()
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = 1

	for iter0, iter1 in ipairs(pg.login.all) do
		if pg.login[iter1].date ~= "stop" then
			local var2, var3 = parseTimeConfig(pg.login[iter1].date)

			assert(not var3)

			if pg.TimeMgr.GetInstance():inTime(var2, var0) then
				var1 = iter1

				break
			end
		end
	end

	local var4 = pg.login[var1].login_static

	var4 = var4 ~= "" and var4 or "login"

	local var5 = pg.login[var1].login_cri
	local var6 = var5 ~= "" and true or false
	local var7 = pg.login[var1].op_play == 1 and true or false
	local var8 = pg.login[var1].op_time

	if var8 == "" or not pg.TimeMgr.GetInstance():inTime(var8, var0) then
		var7 = false
	end

	local var9 = var8 == "" and var8 or table.concat(var8[1][1])

	return var6, var6 and var5 or var4, pg.login[var1].bgm, var7, var9
end

function setIntimacyIcon(arg0, arg1, arg2)
	local var0 = {}
	local var1

	if arg0.childCount > 0 then
		var1 = arg0:GetChild(0)
	else
		var1 = LoadAndInstantiateSync("template", "intimacytpl").transform

		setParent(var1, arg0)
	end

	setImageAlpha(var1, arg2 and 0 or 1)
	eachChild(var1, function(arg0)
		setActive(arg0, false)
	end)

	if arg2 then
		local var2 = var1:Find(arg2 .. "(Clone)")

		if not var2 then
			var2 = LoadAndInstantiateSync("ui", arg2)

			setParent(var2, var1)
		end

		setActive(var2, true)
	elseif arg1 then
		setImageSprite(var1, GetSpriteFromAtlas("energy", arg1), true)
	else
		assert(false, "param error")
	end

	return var1
end

local var22

function nowWorld()
	var22 = var22 or getProxy(WorldProxy)

	return var22 and var22.world
end

function removeWorld()
	var22.world:Dispose()

	var22.world = nil
	var22 = nil
end

function switch(arg0, arg1, arg2, ...)
	if arg1[arg0] then
		return arg1[arg0](...)
	elseif arg2 then
		return arg2(...)
	end
end

function parseTimeConfig(arg0)
	if type(arg0[1]) == "table" then
		return arg0[2], arg0[1]
	else
		return arg0
	end
end

local var23 = {
	__add = function(arg0, arg1)
		return NewPos(arg0.x + arg1.x, arg0.y + arg1.y)
	end,
	__sub = function(arg0, arg1)
		return NewPos(arg0.x - arg1.x, arg0.y - arg1.y)
	end,
	__mul = function(arg0, arg1)
		if type(arg1) == "number" then
			return NewPos(arg0.x * arg1, arg0.y * arg1)
		else
			return NewPos(arg0.x * arg1.x, arg0.y * arg1.y)
		end
	end,
	__eq = function(arg0, arg1)
		return arg0.x == arg1.x and arg0.y == arg1.y
	end,
	__tostring = function(arg0)
		return arg0.x .. "_" .. arg0.y
	end
}

function NewPos(arg0, arg1)
	assert(arg0 and arg1)

	local var0 = setmetatable({
		x = arg0,
		y = arg1
	}, var23)

	function var0.SqrMagnitude(arg0)
		return arg0.x * arg0.x + arg0.y * arg0.y
	end

	function var0.Normalize(arg0)
		local var0 = arg0:SqrMagnitude()

		if var0 > 1e-05 then
			return arg0 * (1 / math.sqrt(var0))
		else
			return NewPos(0, 0)
		end
	end

	return var0
end

local var24

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var24 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var24 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0)
	return (string.char(226, 133, 160 + (arg0 - 1)))
end

function quickPlayAnimator(arg0, arg1)
	arg0:GetComponent(typeof(Animator)):Play(arg1, -1, 0)
end

function getSurveyUrl(arg0)
	local var0 = pg.survey_data_template[arg0]
	local var1

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1 = var0.main_url
				else
					var1 = var0.uo_url
				end
			elseif var2 == PLATFORM_IPHONEPLAYER then
				var1 = var0.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			var1 = var0.main_url
		end
	else
		var1 = var0.main_url
	end

	local var3 = getProxy(PlayerProxy):getRawData().id
	local var4 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5
	local var6 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7 = getProxy(UserProxy):getRawData()
	local var8 = getProxy(ServerProxy):getRawData()[var7 and var7.server or 0]
	local var9 = var8 and var8.id or ""
	local var10 = getProxy(PlayerProxy):getRawData().level
	local var11 = var3 .. "_" .. arg0
	local var12 = var1
	local var13 = {
		var3,
		var4,
		var6,
		var9,
		var10,
		var11
	}

	if var12 then
		for iter0, iter1 in ipairs(var13) do
			var12 = string.gsub(var12, "$" .. iter0, tostring(iter1))
		end
	end

	warning(var12)

	return var12
end

function GetMoneySymbol()
	if PLATFORM_CH == PLATFORM_CODE then
		return "￥"
	elseif PLATFORM_JP == PLATFORM_CODE then
		return "￥"
	elseif PLATFORM_KR == PLATFORM_CODE then
		return "₩"
	elseif PLATFORM_US == PLATFORM_CODE then
		return "$"
	elseif PLATFORM_CHT == PLATFORM_CODE then
		return "TWD"
	end

	return ""
end

function FilterVarchar(arg0)
	assert(type(arg0) == "string" or type(arg0) == "table")

	if arg0 == "" then
		return nil
	end

	return arg0
end

function getGameset(arg0)
	local var0 = pg.gameset[arg0]

	assert(var0)

	return {
		var0.key_value,
		var0.description
	}
end

function getDorm3dGameset(arg0)
	local var0 = pg.dorm3d_set[arg0]

	assert(var0)

	return {
		var0.key_value_int,
		var0.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0)
	arg0 = arg0 or {}

	local var0 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0 > 0 do
		local var1 = table.remove(arg0)

		switch(var1.type, {
			[DROP_TYPE_ITEM] = function()
				if var1:getConfig("open_directly") == 1 then
					for iter0, iter1 in ipairs(var1:getConfig("display_icon")) do
						local var0 = Drop.Create(iter1)

						var0.count = var0.count * var1.count

						table.insert(arg0, var0)
					end
				elseif var1:getSubClass():IsShipExpType() then
					var0[var1.type][var1.id] = defaultValue(var0[var1.type][var1.id], 0) + var1.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0[var1.type][var1.id] = defaultValue(var0[var1.type][var1.id], 0) + var1.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0[var1.type] = var0[var1.type] + var1.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0[var1.type] = var0[var1.type] + var1.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0[var1.type] = var0[var1.type] + var1.count
			end
		})
	end

	return var0
end

function CheckOverflow(arg0, arg1)
	local var0 = {}
	local var1 = arg0[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2 = arg0[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3 = arg0[DROP_TYPE_EQUIP]
	local var4 = arg0[DROP_TYPE_SHIP]
	local var5 = getProxy(PlayerProxy):getRawData()
	local var6 = false

	if arg1 then
		local var7 = var5:OverStore(PlayerConst.ResStoreGold, var1)
		local var8 = var5:OverStore(PlayerConst.ResStoreOil, var2)

		if var7 > 0 or var8 > 0 then
			var0.isStoreOverflow = {
				var7,
				var8
			}
		end
	else
		if var1 > 0 and var5:GoldMax(var1) then
			return false, "gold"
		end

		if var2 > 0 and var5:OilMax(var2) then
			return false, "oil"
		end
	end

	var0.isExpBookOverflow = {}

	for iter0, iter1 in pairs(arg0[DROP_TYPE_ITEM]) do
		local var9 = Item.getConfigData(iter0)

		if getProxy(BagProxy):getItemCountById(iter0) + iter1 > var9.max_num then
			table.insert(var0.isExpBookOverflow, iter0)
		end
	end

	local var10 = getProxy(EquipmentProxy):getCapacity()

	if var3 > 0 and var3 + var10 > var5:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11 = getProxy(BayProxy):getShipCount()

	if var4 > 0 and var4 + var11 > var5:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0
end

function CheckShipExpOverflow(arg0)
	local var0 = getProxy(BagProxy)

	for iter0, iter1 in pairs(arg0[DROP_TYPE_ITEM]) do
		if var0:getItemCountById(iter0) + iter1 > Item.getConfigData(iter0).max_num then
			return false
		end
	end

	return true
end

local var25 = {
	[17] = "item_type17_tip2",
	tech = "techpackage_item_use_confirm",
	[16] = "item_type16_tip2",
	[11] = "equip_skin_detail_tip",
	[13] = "item_type13_tip2"
}

function RegisterDetailButton(arg0, arg1, arg2)
	Drop.Change(arg2)
	switch(arg2.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0 = Item.getConfigData(arg2.id).usage_arg
				local var1 = var0[3]

				if Item.InTimeLimitSkinAssigned(arg2.id) then
					var1 = table.mergeArray(var0[2], var1, true)
				end

				local var2 = {}

				for iter0, iter1 in ipairs(var0[2]) do
					var2[iter1] = true
				end

				onButton(arg0, arg1, function()
					arg0:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2.id,
								selectableSkinList = underscore.map(var1, function(arg0)
									return SelectableSkin.New({
										id = arg0,
										isTimeLimit = var2[arg0] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1, true)
			else
				local var3 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2.id) and "tech" or arg2:getConfig("type")

				if var25[var3] then
					local var4 = {
						item2Row = true,
						content = i18n(var25[var3]),
						itemList = underscore.map(arg2:getConfig("display_icon"), function(arg0)
							return Drop.Create(arg0)
						end)
					}

					if var3 == 11 then
						onButton(arg0, arg1, function()
							arg0:emit(BaseUI.ON_DROP_LIST_OWN, var4)
						end, SFX_PANEL)
					else
						onButton(arg0, arg1, function()
							arg0:emit(BaseUI.ON_DROP_LIST, var4)
						end, SFX_PANEL)
					end
				end

				setActive(arg1, tobool(var25[var3]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0, arg1, function()
				arg0:emit(BaseUI.ON_DROP, arg2)
			end, SFX_PANEL)
			setActive(arg1, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0, arg1, function()
				arg0:emit(BaseUI.ON_DROP, arg2)
			end, SFX_PANEL)
			setActive(arg1, true)
		end
	}, function()
		setActive(arg1, false)
	end)
end

function UpdateOwnDisplay(arg0, arg1)
	local var0, var1 = arg1:getOwnedCount()

	setActive(arg0, var1 and var0 > 0)

	if var1 and var0 > 0 then
		setText(arg0:Find("label"), i18n("word_own1"))
		setText(arg0:Find("Text"), var0)
	end
end

function Damp(arg0, arg1, arg2)
	arg1 = Mathf.Max(1, arg1)

	local var0 = Mathf.Epsilon

	if arg1 < var0 or var0 > Mathf.Abs(arg0) then
		return arg0
	end

	if arg2 < var0 then
		return 0
	end

	local var1 = -4.605170186

	return arg0 * (1 - Mathf.Exp(var1 * arg2 / arg1))
end

function checkCullResume(arg0)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0 = arg0:GetComponentsInChildren(typeof(MeshImage))

		for iter0 = 1, var0.Length do
			var0[iter0 - 1]:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0)
	local var0 = {}

	if arg0 and arg0 ~= "" then
		local var1 = base64.dec(arg0)

		var0 = string.split(var1, "/")
		var0[5], var0[6] = unpack(string.split(var0[5], "\\"))

		if #var0 < 6 or arg0 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0, 5), "/"),
			var0[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0 = {}
		end
	end

	for iter0 = 1, 6 do
		var0[iter0] = var0[iter0] and tonumber(var0[iter0], 32) or 0
	end

	return var0
end

function buildEquipCode(arg0)
	local var0 = underscore.map(arg0:getAllEquipments(), function(arg0)
		return ConversionBase(32, arg0 and arg0.id or 0)
	end)
	local var1 = {
		table.concat(var0, "/"),
		ConversionBase(32, checkExist(arg0:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1, "\\"))
end

function setDirectorSpeed(arg0, arg1)
	GetComponent(arg0, "TimelineSpeed"):SetTimelineSpeed(arg1)
end

function envFunc(arg0, arg1)
	assert(not getmetatable(arg1), "table has error metatable")
	setfenv(arg0, setmetatable(arg1, {
		__index = _G
	}))
	arg0()
	setfenv(arg0, _G)

	return setmetatable(arg1, nil)
end

function setDefaultZeroMetatable(arg0)
	return setmetatable(arg0, {
		__index = function(arg0, arg1)
			if rawget(arg0, arg1) == nil then
				arg0[arg1] = 0
			end

			return arg0[arg1]
		end
	})
end

if EDITOR_TOOL then
	local var26 = {
		__index = {
			LoadAssetSync = function(arg0, ...)
				return ResourceMgr.Inst:getAssetSync(arg0.path, ...)
			end,
			GetAllAssetNames = function(arg0, ...)
				return ReflectionHelp.RefCallMethod(typeof(ResourceMgr), "GetAssetBundleAllAssetNames", ResourceMgr.Inst, {
					typeof("System.String")
				}, {
					arg0.path
				})
			end
		}
	}

	function buildTempAB(arg0, arg1)
		local var0 = setmetatable({
			path = arg0
		}, var26)

		if arg1 then
			onNextTick(function()
				arg1(var0)
			end)
		end

		return var0
	end

	function checkABExist(arg0)
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0)) or ResourceMgr.Inst:AssetExist(arg0)
	end
else
	local var27 = {
		__index = {
			LoadAssetSync = function(arg0, ...)
				return ResourceMgr.Inst:LoadAssetSync(arg0.ab, ...)
			end,
			GetAllAssetNames = function(arg0, ...)
				return arg0.ab:GetAllAssetNames(...)
			end
		}
	}

	function buildTempAB(arg0, arg1)
		local var0 = setmetatable({
			path = arg0
		}, var27)

		if arg1 then
			ResourceMgr.Inst:loadAssetBundleAsync(arg0, function(arg0)
				var0.ab = arg0

				arg1(var0)
			end)
		else
			var0.ab = ResourceMgr.Inst:loadAssetBundleSync(arg0)
		end

		return var0
	end

	function checkABExist(arg0)
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0))
	end
end
