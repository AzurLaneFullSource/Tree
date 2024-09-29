local var0_0 = UnityEngine

function flog(arg0_1, arg1_1)
	if arg0_1 and arg1_1 and pg.ConnectionMgr.GetInstance():isConnected() then
		pg.m02:sendNotification(GAME.SEND_CMD, {
			cmd = "log",
			arg1 = arg0_1,
			arg2 = arg1_1
		})
	end
end

function throttle(arg0_2, arg1_2, arg2_2)
	local var0_2
	local var1_2
	local var2_2
	local var3_2 = 0

	local function var4_2()
		var3_2 = arg2_2 and Time.unscaledTime or 0
		var0_2 = nil
		var2_2 = arg0_2(unpackEx(var1_2))

		if not var0_2 then
			var1_2 = nil
		end
	end

	return function(...)
		local var0_4 = Time.unscaledTime

		if not var3_2 and not arg2_2 then
			var3_2 = var0_4
		end

		local var1_4 = arg1_2 - (var0_4 - var3_2)

		var1_2 = packEx(...)

		if var1_4 <= 0 or var1_4 > arg1_2 then
			if var0_2 then
				var0_2:Stop()

				var0_2 = nil
			end

			var3_2 = var0_4
			var2_2 = arg0_2(unpackEx(var1_2))

			if not var0_2 then
				var1_2 = nil
			end
		elseif not var0_2 and arg2_2 then
			var0_2 = Timer.New(var4_2, var1_4, 1)

			var0_2:Start()
		end

		return var2_2
	end
end

function debounce(arg0_5, arg1_5, arg2_5)
	local var0_5
	local var1_5
	local var2_5
	local var3_5
	local var4_5

	local function var5_5()
		local var0_6 = Time.unscaledTime - var2_5

		if var0_6 < arg1_5 and var0_6 > 0 then
			var0_5 = Timer.New(var5_5, arg1_5 - var0_6, 1)

			var0_5:Start()
		else
			var0_5 = nil

			if not arg2_5 then
				var3_5 = arg0_5(unpackEx(var1_5))

				if not var0_5 then
					var1_5 = nil
				end
			else
				arg2_5 = false
			end
		end
	end

	return function(...)
		var1_5 = packEx(...)
		var2_5 = Time.unscaledTime

		local var0_7 = arg2_5 and not var0_5

		if not var0_5 then
			var0_5 = Timer.New(var5_5, arg1_5, 1)

			var0_5:Start()
		end

		if var0_7 then
			var3_5 = arg0_5(unpackEx(var1_5))
			var1_5 = nil
		end

		return var3_5
	end
end

function createLog(arg0_8, arg1_8)
	if LOG and arg1_8 then
		return function(...)
			print(arg0_8 .. ": ", ...)
		end
	else
		print(arg0_8 .. ": log disabled")

		return function()
			return
		end
	end
end

function getProxy(arg0_11)
	assert(pg.m02, "game is not started")

	return pg.m02:retrieveProxy(arg0_11.__cname)
end

function LoadAndInstantiateAsync(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	arg4_12 = defaultValue(arg4_12, true)
	arg3_12 = defaultValue(arg3_12, true)
	arg0_12, arg1_12 = HXSet.autoHxShift(arg0_12 .. "/", arg1_12)

	ResourceMgr.Inst:getAssetAsync(arg0_12 .. arg1_12, arg1_12, var0_0.Events.UnityAction_UnityEngine_Object(function(arg0_13)
		local var0_13 = Instantiate(arg0_13)

		arg2_12(var0_13)
	end), arg3_12, arg4_12)
end

function LoadAndInstantiateSync(arg0_14, arg1_14, arg2_14, arg3_14)
	arg3_14 = defaultValue(arg3_14, true)
	arg2_14 = defaultValue(arg2_14, true)
	arg0_14, arg1_14 = HXSet.autoHxShift(arg0_14 .. "/", arg1_14)

	local var0_14 = ResourceMgr.Inst:getAssetSync(arg0_14 .. arg1_14, arg1_14, arg2_14, arg3_14)

	return (Instantiate(var0_14))
end

local var1_0 = {}

function LoadSprite(arg0_15, arg1_15)
	arg0_15, arg1_15 = HXSet.autoHxShiftPath(arg0_15, arg1_15)

	return ResourceMgr.Inst:getAssetSync(arg0_15, arg1_15 or "", typeof(Sprite), true, false)
end

function LoadSpriteAtlasAsync(arg0_16, arg1_16, arg2_16)
	arg0_16, arg1_16 = HXSet.autoHxShiftPath(arg0_16, arg1_16)

	ResourceMgr.Inst:getAssetAsync(arg0_16, arg1_16 or "", typeof(Sprite), var0_0.Events.UnityAction_UnityEngine_Object(function(arg0_17)
		arg2_16(arg0_17)
	end), true, false)
end

function LoadSpriteAsync(arg0_18, arg1_18)
	LoadSpriteAtlasAsync(arg0_18, nil, arg1_18)
end

function LoadAny(arg0_19, arg1_19, arg2_19)
	arg0_19, arg1_19 = HXSet.autoHxShiftPath(arg0_19, arg1_19)

	return ResourceMgr.Inst:getAssetSync(arg0_19, arg1_19, arg2_19, true, false)
end

function LoadAnyAsync(arg0_20, arg1_20, arg2_20, arg3_20)
	arg0_20, arg1_20 = HXSet.autoHxShiftPath(arg0_20, arg1_20)

	return ResourceMgr.Inst:getAssetAsync(arg0_20, arg1_20, arg2_20, arg3_20, true, false)
end

function LoadImageSpriteAtlasAsync(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg2_21:GetComponent(typeof(Image))

	var0_21.enabled = false
	var1_0[var0_21] = arg0_21

	LoadSpriteAtlasAsync(arg0_21, arg1_21, function(arg0_22)
		if not IsNil(var0_21) and var1_0[var0_21] == arg0_21 then
			var1_0[var0_21] = nil
			var0_21.enabled = true
			var0_21.sprite = arg0_22

			if arg3_21 then
				var0_21:SetNativeSize()
			end
		end
	end)
end

function LoadImageSpriteAsync(arg0_23, arg1_23, arg2_23)
	LoadImageSpriteAtlasAsync(arg0_23, nil, arg1_23, arg2_23)
end

function GetSpriteFromAtlas(arg0_24, arg1_24)
	local var0_24

	arg0_24, arg1_24 = HXSet.autoHxShiftPath(arg0_24, arg1_24)

	PoolMgr.GetInstance():GetSprite(arg0_24, arg1_24, false, function(arg0_25)
		var0_24 = arg0_25
	end)

	return var0_24
end

function GetSpriteFromAtlasAsync(arg0_26, arg1_26, arg2_26)
	arg0_26, arg1_26 = HXSet.autoHxShiftPath(arg0_26, arg1_26)

	PoolMgr.GetInstance():GetSprite(arg0_26, arg1_26, true, function(arg0_27)
		arg2_26(arg0_27)
	end)
end

function GetImageSpriteFromAtlasAsync(arg0_28, arg1_28, arg2_28, arg3_28)
	arg0_28, arg1_28 = HXSet.autoHxShiftPath(arg0_28, arg1_28)

	local var0_28 = arg2_28:GetComponent(typeof(Image))

	var0_28.enabled = false
	var1_0[var0_28] = arg0_28 .. arg1_28

	GetSpriteFromAtlasAsync(arg0_28, arg1_28, function(arg0_29)
		if not IsNil(var0_28) and var1_0[var0_28] == arg0_28 .. arg1_28 then
			var1_0[var0_28] = nil
			var0_28.enabled = true
			var0_28.sprite = arg0_29

			if arg3_28 then
				var0_28:SetNativeSize()
			end
		end
	end)
end

function SetAction(arg0_30, arg1_30, arg2_30)
	GetComponent(arg0_30, "SkeletonGraphic").AnimationState:SetAnimation(0, arg1_30, defaultValue(arg2_30, true))
end

function SetActionCallback(arg0_31, arg1_31)
	GetOrAddComponent(arg0_31, typeof(SpineAnimUI)):SetActionCallBack(arg1_31)
end

function emojiText(arg0_32, arg1_32)
	local var0_32 = AssetBundleHelper.loadAssetBundleSync("emojis")
	local var1_32 = GetComponent(arg0_32, "TextMesh")
	local var2_32 = GetComponent(arg0_32, "MeshRenderer")
	local var3_32 = Shader.Find("UI/Unlit/Transparent")
	local var4_32 = var2_32.materials
	local var5_32 = {
		var4_32[0]
	}
	local var6_32 = {}
	local var7_32 = 0

	var1_32.text = string.gsub(arg1_32, "#(%d+)#", function(arg0_33)
		if not var6_32[arg0_33] then
			var7_32 = var7_32 + 1

			local var0_33 = Material.New(var3_32)

			var0_33.mainTexture = var0_32:LoadAssetSync("emoji" .. arg0_33, false, false)

			table.insert(var5_32, var0_33)

			var6_32[arg0_33] = var7_32

			local var1_33 = var7_32
		end

		return "<quad material=" .. var7_32 .. " />"
	end)
	var2_32.materials = var5_32

	ResourceMgr.Inst:ClearBundleRef("emojis", false, false)
end

function setPaintingImg(arg0_34, arg1_34)
	local var0_34 = LoadSprite("painting/" .. arg1_34) or LoadSprite("painting/unknown")

	setImageSprite(arg0_34, var0_34)
	resetAspectRatio(arg0_34)
end

function setPaintingPrefab(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = findTF(arg0_35, "fitter")

	assert(var0_35, "请添加子物体fitter")
	removeAllChildren(var0_35)

	local var1_35 = GetOrAddComponent(var0_35, "PaintingScaler")

	var1_35.FrameName = arg2_35 or ""
	var1_35.Tween = 1

	local var2_35 = arg1_35

	if not arg3_35 and checkABExist("painting/" .. arg1_35 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_35, 0) ~= 0 then
		arg1_35 = arg1_35 .. "_n"
	end

	PoolMgr.GetInstance():GetPainting(arg1_35, false, function(arg0_36)
		setParent(arg0_36, var0_35, false)

		local var0_36 = findTF(arg0_36, "Touch")

		if not IsNil(var0_36) then
			setActive(var0_36, false)
		end

		local var1_36 = findTF(arg0_36, "hx")

		if not IsNil(var1_36) then
			setActive(var1_36, HXSet.isHx())
		end

		ShipExpressionHelper.SetExpression(var0_35:GetChild(0), var2_35)
	end)
end

local var2_0 = {}

function setPaintingPrefabAsync(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	local var0_37 = arg1_37

	if checkABExist("painting/" .. arg1_37 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_37, 0) ~= 0 then
		arg1_37 = arg1_37 .. "_n"
	end

	LoadPaintingPrefabAsync(arg0_37, var0_37, arg1_37, arg2_37, arg3_37)
end

function LoadPaintingPrefabAsync(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38)
	local var0_38 = findTF(arg0_38, "fitter")

	assert(var0_38, "请添加子物体fitter")
	removeAllChildren(var0_38)

	local var1_38 = GetOrAddComponent(var0_38, "PaintingScaler")

	var1_38.FrameName = arg3_38 or ""
	var1_38.Tween = 1
	var2_0[arg0_38] = arg2_38

	PoolMgr.GetInstance():GetPainting(arg2_38, true, function(arg0_39)
		if IsNil(arg0_38) or var2_0[arg0_38] ~= arg2_38 then
			PoolMgr.GetInstance():ReturnPainting(arg2_38, arg0_39)

			return
		else
			setParent(arg0_39, var0_38, false)

			var2_0[arg0_38] = nil

			ShipExpressionHelper.SetExpression(arg0_39, arg1_38)
		end

		local var0_39 = findTF(arg0_39, "Touch")

		if not IsNil(var0_39) then
			setActive(var0_39, false)
		end

		local var1_39 = findTF(arg0_39, "Drag")

		if not IsNil(var1_39) then
			setActive(var1_39, false)
		end

		local var2_39 = findTF(arg0_39, "hx")

		if not IsNil(var2_39) then
			setActive(var2_39, HXSet.isHx())
		end

		if arg4_38 then
			arg4_38()
		end
	end)
end

function retPaintingPrefab(arg0_40, arg1_40, arg2_40)
	if arg0_40 and arg1_40 then
		local var0_40 = findTF(arg0_40, "fitter")

		if var0_40 and var0_40.childCount > 0 then
			local var1_40 = var0_40:GetChild(0)

			if not IsNil(var1_40) then
				local var2_40 = findTF(var1_40, "Touch")

				if not IsNil(var2_40) then
					eachChild(var2_40, function(arg0_41)
						local var0_41 = arg0_41:GetComponent(typeof(Button))

						if not IsNil(var0_41) then
							removeOnButton(arg0_41)
						end
					end)
				end

				if not arg2_40 then
					PoolMgr.GetInstance():ReturnPainting(string.gsub(var1_40.name, "%(Clone%)", ""), var1_40.gameObject)
				else
					PoolMgr.GetInstance():ReturnPaintingWithPrefix(string.gsub(var1_40.name, "%(Clone%)", ""), var1_40.gameObject, arg2_40)
				end
			end
		end

		var2_0[arg0_40] = nil
	end
end

function checkPaintingPrefab(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42)
	local var0_42 = findTF(arg0_42, "fitter")

	assert(var0_42, "请添加子物体fitter")
	removeAllChildren(var0_42)

	local var1_42 = GetOrAddComponent(var0_42, "PaintingScaler")

	var1_42.FrameName = arg2_42 or ""
	var1_42.Tween = 1

	local var2_42 = arg4_42 or "painting/"
	local var3_42 = arg1_42

	if not arg3_42 and checkABExist(var2_42 .. arg1_42 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_42, 0) ~= 0 then
		arg1_42 = arg1_42 .. "_n"
	end

	return var0_42, arg1_42, var3_42
end

function onLoadedPaintingPrefab(arg0_43)
	local var0_43 = arg0_43.paintingTF
	local var1_43 = arg0_43.fitterTF
	local var2_43 = arg0_43.defaultPaintingName

	setParent(var0_43, var1_43, false)

	local var3_43 = findTF(var0_43, "Touch")

	if not IsNil(var3_43) then
		setActive(var3_43, false)
	end

	local var4_43 = findTF(var0_43, "hx")

	if not IsNil(var4_43) then
		setActive(var4_43, HXSet.isHx())
	end

	ShipExpressionHelper.SetExpression(var1_43:GetChild(0), var2_43)
end

function onLoadedPaintingPrefabAsync(arg0_44)
	local var0_44 = arg0_44.paintingTF
	local var1_44 = arg0_44.fitterTF
	local var2_44 = arg0_44.objectOrTransform
	local var3_44 = arg0_44.paintingName
	local var4_44 = arg0_44.defaultPaintingName
	local var5_44 = arg0_44.callback

	if IsNil(var2_44) or var2_0[var2_44] ~= var3_44 then
		PoolMgr.GetInstance():ReturnPainting(var3_44, var0_44)

		return
	else
		setParent(var0_44, var1_44, false)

		var2_0[var2_44] = nil

		ShipExpressionHelper.SetExpression(var0_44, var4_44)
	end

	local var6_44 = findTF(var0_44, "Touch")

	if not IsNil(var6_44) then
		setActive(var6_44, false)
	end

	local var7_44 = findTF(var0_44, "hx")

	if not IsNil(var7_44) then
		setActive(var7_44, HXSet.isHx())
	end

	if var5_44 then
		var5_44()
	end
end

function setCommanderPaintingPrefab(arg0_45, arg1_45, arg2_45, arg3_45)
	local var0_45, var1_45, var2_45 = checkPaintingPrefab(arg0_45, arg1_45, arg2_45, arg3_45)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_45, false, function(arg0_46)
		local var0_46 = {
			paintingTF = arg0_46,
			fitterTF = var0_45,
			defaultPaintingName = var2_45
		}

		onLoadedPaintingPrefab(var0_46)
	end, "commanderpainting/")
end

function setCommanderPaintingPrefabAsync(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47)
	local var0_47, var1_47, var2_47 = checkPaintingPrefab(arg0_47, arg1_47, arg2_47, arg4_47)

	var2_0[arg0_47] = var1_47

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_47, true, function(arg0_48)
		local var0_48 = {
			paintingTF = arg0_48,
			fitterTF = var0_47,
			objectOrTransform = arg0_47,
			paintingName = var1_47,
			defaultPaintingName = var2_47,
			callback = arg3_47
		}

		onLoadedPaintingPrefabAsync(var0_48)
	end, "commanderpainting/")
end

function retCommanderPaintingPrefab(arg0_49, arg1_49)
	retPaintingPrefab(arg0_49, arg1_49, "commanderpainting/")
end

function setMetaPaintingPrefab(arg0_50, arg1_50, arg2_50, arg3_50)
	local var0_50, var1_50, var2_50 = checkPaintingPrefab(arg0_50, arg1_50, arg2_50, arg3_50)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_50, false, function(arg0_51)
		local var0_51 = {
			paintingTF = arg0_51,
			fitterTF = var0_50,
			defaultPaintingName = var2_50
		}

		onLoadedPaintingPrefab(var0_51)
	end, "metapainting/")
end

function setMetaPaintingPrefabAsync(arg0_52, arg1_52, arg2_52, arg3_52, arg4_52)
	local var0_52, var1_52, var2_52 = checkPaintingPrefab(arg0_52, arg1_52, arg2_52, arg4_52)

	var2_0[arg0_52] = var1_52

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_52, true, function(arg0_53)
		local var0_53 = {
			paintingTF = arg0_53,
			fitterTF = var0_52,
			objectOrTransform = arg0_52,
			paintingName = var1_52,
			defaultPaintingName = var2_52,
			callback = arg3_52
		}

		onLoadedPaintingPrefabAsync(var0_53)
	end, "metapainting/")
end

function retMetaPaintingPrefab(arg0_54, arg1_54)
	retPaintingPrefab(arg0_54, arg1_54, "metapainting/")
end

function setGuildPaintingPrefab(arg0_55, arg1_55, arg2_55, arg3_55)
	local var0_55, var1_55, var2_55 = checkPaintingPrefab(arg0_55, arg1_55, arg2_55, arg3_55)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_55, false, function(arg0_56)
		local var0_56 = {
			paintingTF = arg0_56,
			fitterTF = var0_55,
			defaultPaintingName = var2_55
		}

		onLoadedPaintingPrefab(var0_56)
	end, "guildpainting/")
end

function setGuildPaintingPrefabAsync(arg0_57, arg1_57, arg2_57, arg3_57, arg4_57)
	local var0_57, var1_57, var2_57 = checkPaintingPrefab(arg0_57, arg1_57, arg2_57, arg4_57)

	var2_0[arg0_57] = var1_57

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_57, true, function(arg0_58)
		local var0_58 = {
			paintingTF = arg0_58,
			fitterTF = var0_57,
			objectOrTransform = arg0_57,
			paintingName = var1_57,
			defaultPaintingName = var2_57,
			callback = arg3_57
		}

		onLoadedPaintingPrefabAsync(var0_58)
	end, "guildpainting/")
end

function retGuildPaintingPrefab(arg0_59, arg1_59)
	retPaintingPrefab(arg0_59, arg1_59, "guildpainting/")
end

function setShopPaintingPrefab(arg0_60, arg1_60, arg2_60, arg3_60)
	local var0_60, var1_60, var2_60 = checkPaintingPrefab(arg0_60, arg1_60, arg2_60, arg3_60)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_60, false, function(arg0_61)
		local var0_61 = {
			paintingTF = arg0_61,
			fitterTF = var0_60,
			defaultPaintingName = var2_60
		}

		onLoadedPaintingPrefab(var0_61)
	end, "shoppainting/")
end

function retShopPaintingPrefab(arg0_62, arg1_62)
	retPaintingPrefab(arg0_62, arg1_62, "shoppainting/")
end

function setBuildPaintingPrefabAsync(arg0_63, arg1_63, arg2_63, arg3_63, arg4_63)
	local var0_63, var1_63, var2_63 = checkPaintingPrefab(arg0_63, arg1_63, arg2_63, arg4_63)

	var2_0[arg0_63] = var1_63

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_63, true, function(arg0_64)
		local var0_64 = {
			paintingTF = arg0_64,
			fitterTF = var0_63,
			objectOrTransform = arg0_63,
			paintingName = var1_63,
			defaultPaintingName = var2_63,
			callback = arg3_63
		}

		onLoadedPaintingPrefabAsync(var0_64)
	end, "buildpainting/")
end

function retBuildPaintingPrefab(arg0_65, arg1_65)
	retPaintingPrefab(arg0_65, arg1_65, "buildpainting/")
end

function setColorCount(arg0_66, arg1_66, arg2_66)
	setText(arg0_66, string.format(arg1_66 < arg2_66 and "<color=" .. COLOR_RED .. ">%d</color>/%d" or "%d/%d", arg1_66, arg2_66))
end

function setColorStr(arg0_67, arg1_67)
	return "<color=" .. arg1_67 .. ">" .. arg0_67 .. "</color>"
end

function setSizeStr(arg0_68, arg1_68)
	local var0_68, var1_68 = string.gsub(arg0_68, "[<]size=%d+[>]", "<size=" .. arg1_68 .. ">")

	if var1_68 == 0 then
		var0_68 = "<size=" .. arg1_68 .. ">" .. var0_68 .. "</size>"
	end

	return var0_68
end

function getBgm(arg0_69, arg1_69)
	local var0_69 = pg.voice_bgm[arg0_69]

	if pg.CriMgr.GetInstance():IsDefaultBGM() then
		return var0_69 and var0_69.default_bgm or nil
	elseif var0_69 then
		if var0_69.special_bgm and type(var0_69.special_bgm) == "table" and #var0_69.special_bgm > 0 and _.all(var0_69.special_bgm, function(arg0_70)
			return type(arg0_70) == "table" and #arg0_70 > 2 and type(arg0_70[2]) == "number"
		end) then
			local var1_69 = Clone(var0_69.special_bgm)

			table.sort(var1_69, function(arg0_71, arg1_71)
				return arg0_71[2] > arg1_71[2]
			end)

			local var2_69 = ""

			_.each(var1_69, function(arg0_72)
				if var2_69 ~= "" then
					return
				end

				local var0_72 = arg0_72[1]
				local var1_72 = arg0_72[3]

				switch(var0_72, {
					function()
						local var0_73 = var1_72[1]
						local var1_73 = var1_72[2]

						if #var0_73 == 1 then
							if var0_73[1] ~= "always" then
								return
							end
						elseif not pg.TimeMgr.GetInstance():inTime(var0_73) then
							return
						end

						_.each(var1_73, function(arg0_74)
							if var2_69 ~= "" then
								return
							end

							if #arg0_74 == 2 and pg.TimeMgr.GetInstance():inPeriod(arg0_74[1]) then
								var2_69 = arg0_74[2]
							elseif #arg0_74 == 3 and pg.TimeMgr.GetInstance():inPeriod(arg0_74[1], arg0_74[2]) then
								var2_69 = arg0_74[3]
							end
						end)
					end,
					function()
						local var0_75 = false
						local var1_75 = ""

						_.each(var1_72, function(arg0_76)
							if #arg0_76 ~= 2 or var0_75 then
								return
							end

							if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_76[1]) then
								var2_69 = arg0_76[2]

								if var2_69 ~= "" then
									var1_75 = var2_69
								else
									var2_69 = var1_75
								end
							else
								var0_75 = true
							end
						end)
					end,
					function()
						if not arg1_69 then
							return
						end

						_.each(var1_72, function(arg0_78)
							if #arg0_78 == 2 and arg0_78[1] == arg1_69 then
								var2_69 = arg0_78[2]

								return
							end
						end)
					end
				})
			end)

			return var2_69 ~= "" and var2_69 or var0_69.bgm
		else
			return var0_69 and var0_69.bgm or nil
		end
	else
		return nil
	end
end

function playStory(arg0_79, arg1_79)
	pg.NewStoryMgr.GetInstance():Play(arg0_79, arg1_79)
end

function errorMessage(arg0_80)
	local var0_80 = ERROR_MESSAGE[arg0_80]

	if var0_80 == nil then
		var0_80 = ERROR_MESSAGE[9999] .. ":" .. arg0_80
	end

	return var0_80
end

function errorTip(arg0_81, arg1_81, ...)
	local var0_81 = pg.gametip[arg0_81 .. "_error"]
	local var1_81

	if var0_81 then
		var1_81 = var0_81.tip
	else
		var1_81 = pg.gametip.common_error.tip
	end

	local var2_81 = arg0_81 .. "_error_" .. arg1_81

	if pg.gametip[var2_81] then
		local var3_81 = i18n(var2_81, ...)

		return var1_81 .. var3_81
	else
		local var4_81 = "common_error_" .. arg1_81

		if pg.gametip[var4_81] then
			local var5_81 = i18n(var4_81, ...)

			return var1_81 .. var5_81
		else
			local var6_81 = errorMessage(arg1_81)

			return var1_81 .. arg1_81 .. ":" .. var6_81
		end
	end
end

function colorNumber(arg0_82, arg1_82)
	local var0_82 = "@COLOR_SCOPE"
	local var1_82 = {}

	arg0_82 = string.gsub(arg0_82, "<color=#%x+>", function(arg0_83)
		table.insert(var1_82, arg0_83)

		return var0_82
	end)
	arg0_82 = string.gsub(arg0_82, "%d+%.?%d*%%*", function(arg0_84)
		return "<color=" .. arg1_82 .. ">" .. arg0_84 .. "</color>"
	end)

	if #var1_82 > 0 then
		local var2_82 = 0

		return (string.gsub(arg0_82, var0_82, function(arg0_85)
			var2_82 = var2_82 + 1

			return var1_82[var2_82]
		end))
	else
		return arg0_82
	end
end

function getBounds(arg0_86)
	local var0_86 = LuaHelper.GetWorldCorners(rtf(arg0_86))
	local var1_86 = Bounds.New(var0_86[0], Vector3.zero)

	var1_86:Encapsulate(var0_86[2])

	return var1_86
end

local function var3_0(arg0_87, arg1_87)
	arg0_87.localScale = Vector3.one
	arg0_87.anchorMin = Vector2.zero
	arg0_87.anchorMax = Vector2.one
	arg0_87.offsetMin = Vector2(arg1_87[1], arg1_87[2])
	arg0_87.offsetMax = Vector2(-arg1_87[3], -arg1_87[4])
end

local var4_0 = {
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
	frame_battle_ui = {
		-16,
		-3.4,
		-2.6,
		-31
	},
	other = {
		-2.5,
		-4.5,
		-3,
		-4.5
	},
	frame_dorm = {
		-16.5,
		-2.5,
		-3.5,
		-16.5
	}
}

function setFrame(arg0_88, arg1_88, arg2_88)
	arg1_88 = tostring(arg1_88)

	local var0_88, var1_88 = unpack((string.split(arg1_88, "_")))

	if var1_88 or tonumber(var0_88) > 5 then
		arg2_88 = arg2_88 or "frame" .. arg1_88
	end

	GetImageSpriteFromAtlasAsync("weaponframes", "frame", arg0_88)

	local var2_88 = arg2_88 and Color.white or Color.NewHex(ItemRarity.Rarity2FrameHexColor(var0_88 and tonumber(var0_88) or ItemRarity.Gray))

	setImageColor(arg0_88, var2_88)

	local var3_88 = findTF(arg0_88, "specialFrame")

	if arg2_88 then
		if var3_88 then
			setActive(var3_88, true)
		else
			var3_88 = cloneTplTo(arg0_88, arg0_88, "specialFrame")

			removeAllChildren(var3_88)
		end

		var3_0(var3_88, var4_0[arg2_88] or var4_0.other)
		GetImageSpriteFromAtlasAsync("weaponframes", arg2_88, var3_88)
	elseif var3_88 then
		setActive(var3_88, false)
	end
end

function setIconColorful(arg0_89, arg1_89, arg2_89, arg3_89)
	arg3_89 = arg3_89 or {
		[ItemRarity.SSR] = {
			name = "IconColorful",
			active = function(arg0_90, arg1_90)
				return not arg1_90.noIconColorful and arg0_90 == ItemRarity.SSR
			end
		}
	}

	local var0_89 = findTF(arg0_89, "icon_bg/frame")

	for iter0_89, iter1_89 in pairs(arg3_89) do
		local var1_89 = iter1_89.name
		local var2_89 = iter1_89.active(arg1_89, arg2_89)
		local var3_89 = var0_89:Find(var1_89 .. "(Clone)")

		if var3_89 then
			setActive(var3_89, var2_89)
		elseif var2_89 then
			LoadAndInstantiateAsync("ui", string.lower(var1_89), function(arg0_91)
				if IsNil(arg0_89) or var0_89:Find(var1_89 .. "(Clone)") then
					Object.Destroy(arg0_91)
				else
					setParent(arg0_91, var0_89)
					setActive(arg0_91, var2_89)
				end
			end)
		end
	end
end

function setIconStars(arg0_92, arg1_92, arg2_92)
	local var0_92 = findTF(arg0_92, "icon_bg/startpl")
	local var1_92 = findTF(arg0_92, "icon_bg/stars")

	if var1_92 and var0_92 then
		setActive(var1_92, false)
		setActive(var0_92, false)
	end

	if not var1_92 or not arg1_92 then
		return
	end

	for iter0_92 = 1, math.max(arg2_92, var1_92.childCount) do
		setActive(iter0_92 > var1_92.childCount and cloneTplTo(var0_92, var1_92) or var1_92:GetChild(iter0_92 - 1), iter0_92 <= arg2_92)
	end

	setActive(var1_92, true)
end

local function var5_0(arg0_93, arg1_93)
	local var0_93 = findTF(arg0_93, "icon_bg/slv")

	if not IsNil(var0_93) then
		setActive(var0_93, arg1_93 > 0)
		setText(findTF(var0_93, "Text"), arg1_93)
	end
end

function setIconName(arg0_94, arg1_94, arg2_94)
	local var0_94 = findTF(arg0_94, "name")

	if not IsNil(var0_94) then
		setText(var0_94, arg1_94)
		setTextAlpha(var0_94, (arg2_94.hideName or arg2_94.anonymous) and 0 or 1)
	end
end

function setIconCount(arg0_95, arg1_95)
	local var0_95 = findTF(arg0_95, "icon_bg/count")

	if not IsNil(var0_95) then
		setText(var0_95, arg1_95 and (type(arg1_95) ~= "number" or arg1_95 > 0) and arg1_95 or "")
	end
end

function updateEquipment(arg0_96, arg1_96, arg2_96)
	arg2_96 = arg2_96 or {}

	assert(arg1_96, "equipmentVo can not be nil.")

	local var0_96 = EquipmentRarity.Rarity2Print(arg1_96:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_96, findTF(arg0_96, "icon_bg"))
	setFrame(findTF(arg0_96, "icon_bg/frame"), var0_96)

	local var1_96 = findTF(arg0_96, "icon_bg/icon")

	var3_0(var1_96, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync("equips/" .. arg1_96:getConfig("icon"), "", var1_96)
	setIconStars(arg0_96, true, arg1_96:getConfig("rarity"))
	var5_0(arg0_96, arg1_96:getConfig("level") - 1)
	setIconName(arg0_96, arg1_96:getConfig("name"), arg2_96)
	setIconCount(arg0_96, arg1_96.count)
	setIconColorful(arg0_96, arg1_96:getConfig("rarity") - 1, arg2_96)
end

function updateItem(arg0_97, arg1_97, arg2_97)
	arg2_97 = arg2_97 or {}

	local var0_97 = ItemRarity.Rarity2Print(arg1_97:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_97, findTF(arg0_97, "icon_bg"))

	local var1_97

	if arg1_97:getConfig("type") == 9 then
		var1_97 = "frame_design"
	elseif arg1_97:getConfig("type") == 100 then
		var1_97 = "frame_dorm"
	elseif arg2_97.frame then
		var1_97 = arg2_97.frame
	end

	setFrame(findTF(arg0_97, "icon_bg/frame"), var0_97, var1_97)

	local var2_97 = findTF(arg0_97, "icon_bg/icon")
	local var3_97 = arg1_97.icon or arg1_97:getConfig("icon")

	if arg1_97:getConfig("type") == Item.LOVE_LETTER_TYPE then
		assert(arg1_97.extra, "without extra data")

		var3_97 = "SquareIcon/" .. ShipGroup.getDefaultSkin(arg1_97.extra).prefab
	end

	GetImageSpriteFromAtlasAsync(var3_97, "", var2_97)
	setIconStars(arg0_97, false)
	setIconName(arg0_97, arg1_97:getName(), arg2_97)
	setIconColorful(arg0_97, arg1_97:getConfig("rarity"), arg2_97)
end

function updateWorldItem(arg0_98, arg1_98, arg2_98)
	arg2_98 = arg2_98 or {}

	local var0_98 = ItemRarity.Rarity2Print(arg1_98:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_98, findTF(arg0_98, "icon_bg"))
	setFrame(findTF(arg0_98, "icon_bg/frame"), var0_98)

	local var1_98 = findTF(arg0_98, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_98.icon or arg1_98:getConfig("icon"), "", var1_98)
	setIconStars(arg0_98, false)
	setIconName(arg0_98, arg1_98:getConfig("name"), arg2_98)
	setIconColorful(arg0_98, arg1_98:getConfig("rarity"), arg2_98)
end

function updateWorldCollection(arg0_99, arg1_99, arg2_99)
	arg2_99 = arg2_99 or {}

	assert(arg1_99:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_99.id)

	local var0_99 = arg1_99:getDropRarity()
	local var1_99 = ItemRarity.Rarity2Print(var0_99)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_99, findTF(arg0_99, "icon_bg"))
	setFrame(findTF(arg0_99, "icon_bg/frame"), var1_99)

	local var2_99 = findTF(arg0_99, "icon_bg/icon")
	local var3_99 = WorldCollectionProxy.GetCollectionType(arg1_99.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_99, "", var2_99)
	setIconStars(arg0_99, false)
	setIconName(arg0_99, arg1_99:getName(), arg2_99)
	setIconColorful(arg0_99, var0_99, arg2_99)
end

function updateWorldBuff(arg0_100, arg1_100, arg2_100)
	arg2_100 = arg2_100 or {}

	local var0_100 = pg.world_SLGbuff_data[arg1_100]

	assert(var0_100, "找不到大世界buff配置: " .. arg1_100)

	local var1_100 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_100, findTF(arg0_100, "icon_bg"))
	setFrame(findTF(arg0_100, "icon_bg/frame"), var1_100)

	local var2_100 = findTF(arg0_100, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_100.icon, "", var2_100)

	local var3_100 = arg0_100:Find("icon_bg/stars")

	if not IsNil(var3_100) then
		setActive(var3_100, false)
	end

	local var4_100 = findTF(arg0_100, "name")

	if not IsNil(var4_100) then
		setText(var4_100, var0_100.name)
	end

	local var5_100 = findTF(arg0_100, "icon_bg/count")

	if not IsNil(var5_100) then
		SetActive(var5_100, false)
	end
end

function updateShip(arg0_101, arg1_101, arg2_101)
	arg2_101 = arg2_101 or {}

	local var0_101 = arg1_101:rarity2bgPrint()
	local var1_101 = arg1_101:getPainting()

	if arg2_101.anonymous then
		var0_101 = "1"
		var1_101 = "unknown"
	end

	if arg2_101.unknown_small then
		var1_101 = "unknown_small"
	end

	local var2_101 = findTF(arg0_101, "icon_bg/new")

	if var2_101 then
		if arg2_101.isSkin then
			setActive(var2_101, not arg2_101.isTimeLimit and arg2_101.isNew)
		else
			setActive(var2_101, arg1_101.virgin)
		end
	end

	local var3_101 = findTF(arg0_101, "icon_bg/timelimit")

	if var3_101 then
		setActive(var3_101, arg2_101.isTimeLimit)
	end

	local var4_101 = findTF(arg0_101, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_101.isSkin and "_skin" or var0_101), var4_101)

	local var5_101 = findTF(arg0_101, "icon_bg/frame")
	local var6_101

	if arg1_101.isNpc then
		var6_101 = "frame_npc"
	elseif arg1_101:ShowPropose() then
		var6_101 = "frame_prop"

		if arg1_101:isMetaShip() then
			var6_101 = var6_101 .. "_meta"
		end
	elseif arg2_101.isSkin then
		var6_101 = "frame_skin"
	end

	setFrame(var5_101, var0_101, var6_101)

	if arg2_101.gray then
		setGray(var4_101, true, true)
	end

	local var7_101 = findTF(arg0_101, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_101.Q and "QIcon/" or "SquareIcon/") .. var1_101, "", var7_101)

	local var8_101 = findTF(arg0_101, "icon_bg/lv")

	if var8_101 then
		setActive(var8_101, not arg1_101.isNpc)

		if not arg1_101.isNpc then
			local var9_101 = findTF(var8_101, "Text")

			if var9_101 and arg1_101.level then
				setText(var9_101, arg1_101.level)
			end
		end
	end

	local var10_101 = findTF(arg0_101, "ship_type")

	if var10_101 then
		setActive(var10_101, true)
		setImageSprite(var10_101, GetSpriteFromAtlas("shiptype", shipType2print(arg1_101:getShipType())))
	end

	local var11_101 = var4_101:Find("npc")

	if not IsNil(var11_101) then
		if var2_101 and go(var2_101).activeSelf then
			setActive(var11_101, false)
		else
			setActive(var11_101, arg1_101:isActivityNpc())
		end
	end

	local var12_101 = arg0_101:Find("group_locked")

	if var12_101 then
		setActive(var12_101, not arg2_101.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_101.groupId))
	end

	setIconStars(arg0_101, arg2_101.initStar, arg1_101:getStar())
	setIconName(arg0_101, arg2_101.isSkin and arg1_101:GetSkinConfig().name or arg1_101:getName(), arg2_101)
	setIconColorful(arg0_101, arg2_101.isSkin and ItemRarity.Gold or arg1_101:getRarity() - 1, arg2_101)
end

function updateCommander(arg0_102, arg1_102, arg2_102)
	arg2_102 = arg2_102 or {}

	local var0_102 = arg1_102:getDropRarity()
	local var1_102 = ItemRarity.Rarity2Print(var0_102)
	local var2_102 = arg1_102:getConfig("painting")

	if arg2_102.anonymous then
		var1_102 = 1
		var2_102 = "unknown"
	end

	local var3_102 = findTF(arg0_102, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_102, var3_102)

	local var4_102 = findTF(arg0_102, "icon_bg/frame")

	setFrame(var4_102, var1_102)

	if arg2_102.gray then
		setGray(var3_102, true, true)
	end

	local var5_102 = findTF(arg0_102, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_102, "", var5_102)
	setIconStars(arg0_102, arg2_102.initStar, 0)
	setIconName(arg0_102, arg1_102:getName(), arg2_102)
end

function updateStrategy(arg0_103, arg1_103, arg2_103)
	arg2_103 = arg2_103 or {}

	local var0_103 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_103, findTF(arg0_103, "icon_bg"))
	setFrame(findTF(arg0_103, "icon_bg/frame"), var0_103)

	local var1_103 = findTF(arg0_103, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_103.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_103:getIcon(), "", var1_103)
	setIconStars(arg0_103, false)
	setIconName(arg0_103, arg1_103:getName(), arg2_103)
	setIconColorful(arg0_103, ItemRarity.Gray, arg2_103)
end

function updateFurniture(arg0_104, arg1_104, arg2_104)
	arg2_104 = arg2_104 or {}

	local var0_104 = arg1_104:getDropRarity()
	local var1_104 = ItemRarity.Rarity2Print(var0_104)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_104, findTF(arg0_104, "icon_bg"))
	setFrame(findTF(arg0_104, "icon_bg/frame"), var1_104)

	local var2_104 = findTF(arg0_104, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_104:getIcon(), "", var2_104)
	setIconStars(arg0_104, false)
	setIconName(arg0_104, arg1_104:getName(), arg2_104)
	setIconColorful(arg0_104, var0_104, arg2_104)
end

function updateSpWeapon(arg0_105, arg1_105, arg2_105)
	arg2_105 = arg2_105 or {}

	assert(arg1_105, "spWeaponVO can not be nil.")
	assert(isa(arg1_105, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_105 = ItemRarity.Rarity2Print(arg1_105:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_105, findTF(arg0_105, "icon_bg"))
	setFrame(findTF(arg0_105, "icon_bg/frame"), var0_105)

	local var1_105 = findTF(arg0_105, "icon_bg/icon")

	var3_0(var1_105, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_105:GetIconPath(), "", var1_105)
	setIconStars(arg0_105, true, arg1_105:GetRarity())
	var5_0(arg0_105, arg1_105:GetLevel() - 1)
	setIconName(arg0_105, arg1_105:GetName(), arg2_105)
	setIconCount(arg0_105, arg1_105.count)
	setIconColorful(arg0_105, arg1_105:GetRarity(), arg2_105)
end

function UpdateSpWeaponSlot(arg0_106, arg1_106, arg2_106)
	local var0_106 = ItemRarity.Rarity2Print(arg1_106:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_106, findTF(arg0_106, "Icon/Mask/icon_bg"))

	local var1_106 = findTF(arg0_106, "Icon/Mask/icon_bg/icon")

	arg2_106 = arg2_106 or {
		16,
		16,
		16,
		16
	}

	var3_0(var1_106, arg2_106)
	GetImageSpriteFromAtlasAsync(arg1_106:GetIconPath(), "", var1_106)

	local var2_106 = arg1_106:GetLevel() - 1
	local var3_106 = findTF(arg0_106, "Icon/LV")

	setActive(var3_106, var2_106 > 0)
	setText(findTF(var3_106, "Text"), var2_106)
end

function updateDorm3dFurniture(arg0_107, arg1_107, arg2_107)
	arg2_107 = arg2_107 or {}

	local var0_107 = arg1_107:getDropRarity()
	local var1_107 = ItemRarity.Rarity2Print(var0_107)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_107, findTF(arg0_107, "icon_bg"))
	setFrame(findTF(arg0_107, "icon_bg/frame"), var1_107)

	local var2_107 = findTF(arg0_107, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_107:getIcon(), "", var2_107)
	setIconStars(arg0_107, false)
	setIconName(arg0_107, arg1_107:getName(), arg2_107)
	setIconColorful(arg0_107, var0_107, arg2_107)
end

function updateDorm3dGift(arg0_108, arg1_108, arg2_108)
	arg2_108 = arg2_108 or {}

	local var0_108 = arg1_108:getDropRarity()
	local var1_108 = ItemRarity.Rarity2Print(var0_108) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_108, arg0_108:Find("icon_bg"))
	setFrame(arg0_108:Find("icon_bg/frame"), var1_108)

	local var2_108 = arg0_108:Find("icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_108:getIcon(), "", var2_108)
	setIconStars(arg0_108, false)
	setIconName(arg0_108, arg1_108:getName(), arg2_108)
	setIconColorful(arg0_108, var0_108, arg2_108)
end

function updateDorm3dSkin(arg0_109, arg1_109, arg2_109)
	arg2_109 = arg2_109 or {}

	local var0_109 = arg1_109:getDropRarity()
	local var1_109 = ItemRarity.Rarity2Print(var0_109) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_109, arg0_109:Find("icon_bg"))
	setFrame(arg0_109:Find("icon_bg/frame"), var1_109)

	local var2_109 = arg0_109:Find("icon_bg/icon")

	setIconStars(arg0_109, false)
	setIconName(arg0_109, arg1_109:getName(), arg2_109)
	setIconColorful(arg0_109, var0_109, arg2_109)
end

function updateDorm3dIcon(arg0_110, arg1_110)
	local var0_110 = arg1_110:getDropRarityDorm()

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_110), arg0_110)

	local var1_110 = arg0_110:Find("icon")

	GetImageSpriteFromAtlasAsync(arg1_110:getIcon(), "", var1_110)
	setText(arg0_110:Find("count/Text"), "x" .. arg1_110.count)
	setText(arg0_110:Find("name/Text"), arg1_110:getName())
end

local var6_0

function findCullAndClipWorldRect(arg0_111)
	if #arg0_111 == 0 then
		return false
	end

	local var0_111 = arg0_111[1].canvasRect

	for iter0_111 = 1, #arg0_111 do
		var0_111 = rectIntersect(var0_111, arg0_111[iter0_111].canvasRect)
	end

	if var0_111.width <= 0 or var0_111.height <= 0 then
		return false
	end

	var6_0 = var6_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_111 = var6_0:TransformPoint(Vector3(var0_111.x, var0_111.y, 0))
	local var2_111 = var6_0:TransformPoint(Vector3(var0_111.x + var0_111.width, var0_111.y + var0_111.height, 0))

	return true, Vector4(var1_111.x, var1_111.y, var2_111.x, var2_111.y)
end

function rectIntersect(arg0_112, arg1_112)
	local var0_112 = math.max(arg0_112.x, arg1_112.x)
	local var1_112 = math.min(arg0_112.x + arg0_112.width, arg1_112.x + arg1_112.width)
	local var2_112 = math.max(arg0_112.y, arg1_112.y)
	local var3_112 = math.min(arg0_112.y + arg0_112.height, arg1_112.y + arg1_112.height)

	if var0_112 <= var1_112 and var2_112 <= var3_112 then
		return var0_0.Rect.New(var0_112, var2_112, var1_112 - var0_112, var3_112 - var2_112)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_113)
	local var0_113 = {}

	for iter0_113, iter1_113 in ipairs(arg0_113) do
		local var1_113 = Drop.Create(iter1_113)

		var1_113.count = var1_113.count or 1

		if var1_113.type == DROP_TYPE_EMOJI then
			table.insert(var0_113, var1_113:getName())
		else
			table.insert(var0_113, var1_113:getName() .. "x" .. var1_113.count)
		end
	end

	return table.concat(var0_113, "、")
end

function updateDrop(arg0_114, arg1_114, arg2_114)
	Drop.Change(arg1_114)

	arg2_114 = arg2_114 or {}

	local var0_114 = {
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
	local var1_114

	for iter0_114, iter1_114 in ipairs(var0_114) do
		local var2_114 = arg0_114:Find(iter1_114[1])

		if arg1_114.type ~= iter1_114[2] and not IsNil(var2_114) then
			setActive(var2_114, false)
		end
	end

	arg0_114:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

	setIconColorful(arg0_114, arg1_114:getDropRarity(), arg2_114, {
		[ItemRarity.Gold] = {
			name = "Item_duang5",
			active = function(arg0_115, arg1_115)
				return arg1_115.fromAwardLayer and arg0_115 >= ItemRarity.Gold
			end
		}
	})
	var3_0(findTF(arg0_114, "icon_bg/icon"), {
		2,
		2,
		2,
		2
	})
	arg1_114:UpdateDropTpl(arg0_114, arg2_114)
	setIconCount(arg0_114, arg2_114.count or arg1_114:getCount())
end

function updateBuff(arg0_116, arg1_116, arg2_116)
	arg2_116 = arg2_116 or {}

	local var0_116 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_116, findTF(arg0_116, "icon_bg"))

	local var1_116 = pg.benefit_buff_template[arg1_116]

	setFrame(findTF(arg0_116, "icon_bg/frame"), var0_116)
	setText(findTF(arg0_116, "icon_bg/count"), 1)

	local var2_116 = findTF(arg0_116, "icon_bg/icon")
	local var3_116 = var1_116.icon

	GetImageSpriteFromAtlasAsync(var3_116, "", var2_116)
	setIconStars(arg0_116, false)
	setIconName(arg0_116, var1_116.name, arg2_116)
	setIconColorful(arg0_116, ItemRarity.Gold, arg2_116)
end

function updateAttire(arg0_117, arg1_117, arg2_117, arg3_117)
	local var0_117 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_117, findTF(arg0_117, "icon_bg"))
	setFrame(findTF(arg0_117, "icon_bg/frame"), var0_117)

	local var1_117 = findTF(arg0_117, "icon_bg/icon")
	local var2_117

	if arg1_117 == AttireConst.TYPE_CHAT_FRAME then
		var2_117 = "chat_frame"
	elseif arg1_117 == AttireConst.TYPE_ICON_FRAME then
		var2_117 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_117, "", var1_117)
	setIconName(arg0_117, arg2_117.name, arg3_117)
end

function updateAttireCombatUI(arg0_118, arg1_118, arg2_118, arg3_118)
	local var0_118 = arg2_118.rare

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_118, findTF(arg0_118, "icon_bg"))
	setFrame(findTF(arg0_118, "icon_bg/frame"), var0_118, "frame_battle_ui")

	local var1_118 = findTF(arg0_118, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("Props/" .. arg2_118.display_icon, "", var1_118)
	setIconName(arg0_118, arg2_118.name, arg3_118)
end

function updateCover(arg0_119, arg1_119, arg2_119)
	local var0_119 = arg1_119:getDropRarity()

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_119, findTF(arg0_119, "icon_bg"))
	setFrame(findTF(arg0_119, "icon_bg/frame"), var0_119)

	local var1_119 = findTF(arg0_119, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_119:getIcon(), "", var1_119)
	setIconName(arg0_119, arg1_119:getName(), arg2_119)
	setIconStars(arg0_119, false)
end

function updateEmoji(arg0_120, arg1_120, arg2_120)
	local var0_120 = findTF(arg0_120, "icon_bg/icon")
	local var1_120 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_120, "", var0_120)

	local var2_120 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_120, findTF(arg0_120, "icon_bg"))
	setFrame(findTF(arg0_120, "icon_bg/frame"), var2_120)
	setIconName(arg0_120, arg1_120.name, arg2_120)
end

function updateEquipmentSkin(arg0_121, arg1_121, arg2_121)
	arg2_121 = arg2_121 or {}

	local var0_121 = EquipmentRarity.Rarity2Print(arg1_121.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_121, findTF(arg0_121, "icon_bg"))
	setFrame(findTF(arg0_121, "icon_bg/frame"), var0_121, "frame_skin")

	local var1_121 = findTF(arg0_121, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_121.icon, "", var1_121)
	setIconStars(arg0_121, false)
	setIconName(arg0_121, arg1_121.name, arg2_121)
	setIconCount(arg0_121, arg1_121.count)
	setIconColorful(arg0_121, arg1_121.rarity - 1, arg2_121)
end

function NoPosMsgBox(arg0_122, arg1_122, arg2_122, arg3_122)
	local var0_122
	local var1_122 = {}

	if arg1_122 then
		table.insert(var1_122, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_122
		})
	end

	if arg2_122 then
		table.insert(var1_122, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_122
		})
	end

	if arg3_122 then
		table.insert(var1_122, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_122
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_122,
		custom = var1_122,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_123 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_123 and var0_123.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_123
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
		local var0_124 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_124 and var0_124.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_124
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
		onClick = function(arg0_127, arg1_127)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_127.id,
				shipVOs = arg1_127
			})
		end
	})
end

function GoShoppingMsgBox(arg0_128, arg1_128, arg2_128)
	if arg2_128 then
		local var0_128 = ""

		for iter0_128, iter1_128 in ipairs(arg2_128) do
			local var1_128 = Item.getConfigData(iter1_128[1])

			var0_128 = var0_128 .. i18n(iter1_128[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_128.name, iter1_128[2])

			if iter0_128 < #arg2_128 then
				var0_128 = var0_128 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_128 ~= "" then
			arg0_128 = arg0_128 .. "\n" .. i18n("text_noRes_tip", var0_128)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_128,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_128, arg2_128)
		end
	})
end

function shoppingBatch(arg0_130, arg1_130, arg2_130, arg3_130, arg4_130)
	local var0_130 = pg.shop_template[arg0_130]

	assert(var0_130, "shop_template中找不到商品id：" .. arg0_130)

	local var1_130 = getProxy(PlayerProxy):getData()[id2res(var0_130.resource_type)]
	local var2_130 = arg1_130.price or var0_130.resource_num
	local var3_130 = math.floor(var1_130 / var2_130)

	var3_130 = var3_130 <= 0 and 1 or var3_130
	var3_130 = arg2_130 ~= nil and arg2_130 < var3_130 and arg2_130 or var3_130

	local var4_130 = true
	local var5_130 = 1

	if var0_130 ~= nil and arg1_130.id then
		print(var3_130 * var0_130.num, "--", var3_130)
		assert(Item.getConfigData(arg1_130.id), "item config should be existence")

		local var6_130 = Item.New({
			id = arg1_130.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_130.id
			},
			addNum = var0_130.num,
			maxNum = var3_130 * var0_130.num,
			defaultNum = var0_130.num,
			numUpdate = function(arg0_131, arg1_131)
				var5_130 = math.floor(arg1_131 / var0_130.num)

				local var0_131 = var5_130 * var2_130

				if var0_131 > var1_130 then
					setText(arg0_131, i18n(arg3_130, var0_131, arg1_131, COLOR_RED, var6_130))

					var4_130 = false
				else
					setText(arg0_131, i18n(arg3_130, var0_131, arg1_131, COLOR_GREEN, var6_130))

					var4_130 = true
				end
			end,
			onYes = function()
				if var4_130 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_130,
						count = var5_130
					})
				elseif arg4_130 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_130))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function gotoChargeScene(arg0_133, arg1_133)
	local var0_133 = getProxy(ContextProxy)
	local var1_133 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_133.mediator, ChargeMediator) then
		var1_133.mediator:getViewComponent():switchSubViewByTogger(arg0_133)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_133 or ChargeScene.TYPE_ITEM,
			noRes = arg1_133
		})
	end
end

function clearDrop(arg0_134)
	local var0_134 = findTF(arg0_134, "icon_bg")
	local var1_134 = findTF(arg0_134, "icon_bg/frame")
	local var2_134 = findTF(arg0_134, "icon_bg/icon")
	local var3_134 = findTF(arg0_134, "icon_bg/icon/icon")

	clearImageSprite(var0_134)
	clearImageSprite(var1_134)
	clearImageSprite(var2_134)

	if var3_134 then
		clearImageSprite(var3_134)
	end
end

local var7_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_135, arg1_135, arg2_135, arg3_135)
	local var0_135 = findTF(arg0_135, "skill")
	local var1_135 = findTF(arg0_135, "lock")
	local var2_135 = findTF(arg0_135, "unknown")

	if arg1_135 then
		setActive(var0_135, true)
		setActive(var2_135, false)
		setActive(var1_135, not arg2_135)
		LoadImageSpriteAsync("skillicon/" .. arg1_135.icon, findTF(var0_135, "icon"))

		local var3_135 = arg1_135.color or "blue"

		setText(findTF(var0_135, "name"), shortenString(getSkillName(arg1_135.id), arg3_135 or 8))

		local var4_135 = findTF(var0_135, "level")

		setText(var4_135, "LEVEL: " .. (arg2_135 and arg2_135.level or "??"))
		setTextColor(var4_135, var7_0[var3_135])
	else
		setActive(var0_135, false)
		setActive(var2_135, true)
		setActive(var1_135, false)
	end
end

local var8_0 = true

function onBackButton(arg0_136, arg1_136, arg2_136, arg3_136)
	local var0_136 = GetOrAddComponent(arg1_136, "UILongPressTrigger")

	assert(arg2_136, "callback should exist")

	var0_136.longPressThreshold = defaultValue(arg3_136, 1)

	local function var1_136(arg0_137)
		return function()
			if var8_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_138, var1_138 = arg2_136()

			if var0_138 then
				arg0_137(var1_138)
			end
		end
	end

	local var2_136 = var0_136.onReleased

	pg.DelegateInfo.Add(arg0_136, var2_136)
	var2_136:RemoveAllListeners()
	var2_136:AddListener(var1_136(function(arg0_139)
		arg0_139:emit(BaseUI.ON_BACK)
	end))

	local var3_136 = var0_136.onLongPressed

	pg.DelegateInfo.Add(arg0_136, var3_136)
	var3_136:RemoveAllListeners()
	var3_136:AddListener(var1_136(function(arg0_140)
		arg0_140:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_143)
	local var0_143 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_143, var2_143 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_143)

	return var1_143 * 86400 + (var2_143 + arg0_143) * 3600
end

function GetPerceptualSize(arg0_144)
	local function var0_144(arg0_145)
		if not arg0_145 then
			return 0, 1
		elseif arg0_145 > 240 then
			return 4, 1
		elseif arg0_145 > 225 then
			return 3, 1
		elseif arg0_145 > 192 then
			return 2, 1
		elseif arg0_145 < 126 then
			return 1, 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_144) == "number" then
		return var0_144(arg0_144)
	end

	local var1_144 = 1
	local var2_144 = 0
	local var3_144 = 0
	local var4_144 = #arg0_144

	while var1_144 <= var4_144 do
		local var5_144 = string.byte(arg0_144, var1_144)
		local var6_144, var7_144 = var0_144(var5_144)

		var1_144 = var1_144 + var6_144
		var2_144 = var2_144 + var7_144
	end

	return var2_144
end

function shortenString(arg0_146, arg1_146)
	local var0_146 = 1
	local var1_146 = 0
	local var2_146 = 0
	local var3_146 = #arg0_146

	while var0_146 <= var3_146 do
		local var4_146 = string.byte(arg0_146, var0_146)
		local var5_146, var6_146 = GetPerceptualSize(var4_146)

		var0_146 = var0_146 + var5_146
		var1_146 = var1_146 + var6_146

		if arg1_146 <= math.ceil(var1_146) then
			var2_146 = var0_146

			break
		end
	end

	if var2_146 == 0 or var3_146 < var2_146 then
		return arg0_146
	end

	return string.sub(arg0_146, 1, var2_146 - 1) .. ".."
end

function shouldShortenString(arg0_147, arg1_147)
	local var0_147 = 1
	local var1_147 = 0
	local var2_147 = 0
	local var3_147 = #arg0_147

	while var0_147 <= var3_147 do
		local var4_147 = string.byte(arg0_147, var0_147)
		local var5_147, var6_147 = GetPerceptualSize(var4_147)

		var0_147 = var0_147 + var5_147
		var1_147 = var1_147 + var6_147

		if arg1_147 <= math.ceil(var1_147) then
			var2_147 = var0_147

			break
		end
	end

	if var2_147 == 0 or var3_147 < var2_147 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_148, arg1_148, arg2_148, arg3_148)
	local var0_148 = true
	local var1_148, var2_148 = utf8_to_unicode(arg0_148)
	local var3_148 = filterEgyUnicode(filterSpecChars(arg0_148))
	local var4_148 = wordVer(arg0_148)

	if not checkSpaceValid(arg0_148) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_148[1]))

		var0_148 = false
	elseif var4_148 > 0 or var3_148 ~= arg0_148 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_148[4]))

		var0_148 = false
	elseif var2_148 < arg1_148 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_148[2]))

		var0_148 = false
	elseif arg2_148 < var2_148 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_148[3]))

		var0_148 = false
	end

	return var0_148
end

function checkSpaceValid(arg0_149)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_149 = string.gsub(arg0_149, " ", "")

	return arg0_149 == string.gsub(var0_149, "　", "")
end

function filterSpecChars(arg0_150)
	local var0_150 = {}
	local var1_150 = 0
	local var2_150 = 0
	local var3_150 = 0
	local var4_150 = 1

	while var4_150 <= #arg0_150 do
		local var5_150 = string.byte(arg0_150, var4_150)

		if not var5_150 then
			break
		end

		if var5_150 >= 48 and var5_150 <= 57 or var5_150 >= 65 and var5_150 <= 90 or var5_150 == 95 or var5_150 >= 97 and var5_150 <= 122 then
			table.insert(var0_150, string.char(var5_150))
		elseif var5_150 >= 228 and var5_150 <= 233 then
			local var6_150 = string.byte(arg0_150, var4_150 + 1)
			local var7_150 = string.byte(arg0_150, var4_150 + 2)

			if var6_150 and var7_150 and var6_150 >= 128 and var6_150 <= 191 and var7_150 >= 128 and var7_150 <= 191 then
				var4_150 = var4_150 + 2

				table.insert(var0_150, string.char(var5_150, var6_150, var7_150))

				var1_150 = var1_150 + 1
			end
		elseif var5_150 == 45 or var5_150 == 40 or var5_150 == 41 then
			table.insert(var0_150, string.char(var5_150))
		elseif var5_150 == 194 then
			local var8_150 = string.byte(arg0_150, var4_150 + 1)

			if var8_150 == 183 then
				var4_150 = var4_150 + 1

				table.insert(var0_150, string.char(var5_150, var8_150))

				var1_150 = var1_150 + 1
			end
		elseif var5_150 == 239 then
			local var9_150 = string.byte(arg0_150, var4_150 + 1)
			local var10_150 = string.byte(arg0_150, var4_150 + 2)

			if var9_150 == 188 and (var10_150 == 136 or var10_150 == 137) then
				var4_150 = var4_150 + 2

				table.insert(var0_150, string.char(var5_150, var9_150, var10_150))

				var1_150 = var1_150 + 1
			end
		elseif var5_150 == 206 or var5_150 == 207 then
			local var11_150 = string.byte(arg0_150, var4_150 + 1)

			if var5_150 == 206 and var11_150 >= 177 or var5_150 == 207 and var11_150 <= 134 then
				var4_150 = var4_150 + 1

				table.insert(var0_150, string.char(var5_150, var11_150))

				var1_150 = var1_150 + 1
			end
		elseif var5_150 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_150 = string.byte(arg0_150, var4_150 + 1)
			local var13_150 = string.byte(arg0_150, var4_150 + 2)

			if var12_150 and var13_150 and var12_150 > 128 and var12_150 <= 191 and var13_150 >= 128 and var13_150 <= 191 then
				var4_150 = var4_150 + 2

				table.insert(var0_150, string.char(var5_150, var12_150, var13_150))

				var2_150 = var2_150 + 1
			end
		elseif var5_150 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_150 = string.byte(arg0_150, var4_150 + 1)
			local var15_150 = string.byte(arg0_150, var4_150 + 2)

			if var14_150 and var15_150 and var14_150 >= 128 and var14_150 <= 191 and var15_150 >= 128 and var15_150 <= 191 then
				var4_150 = var4_150 + 2

				table.insert(var0_150, string.char(var5_150, var14_150, var15_150))

				var3_150 = var3_150 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_150 ~= 1 and var5_150 == 32 and string.byte(arg0_150, var4_150 + 1) ~= 32 then
				table.insert(var0_150, string.char(var5_150))
			end

			if var5_150 >= 192 and var5_150 <= 223 then
				local var16_150 = string.byte(arg0_150, var4_150 + 1)

				var4_150 = var4_150 + 1

				if var5_150 == 194 and var16_150 and var16_150 >= 128 then
					table.insert(var0_150, string.char(var5_150, var16_150))
				elseif var5_150 == 195 and var16_150 and var16_150 <= 191 then
					table.insert(var0_150, string.char(var5_150, var16_150))
				end
			end
		end

		var4_150 = var4_150 + 1
	end

	return table.concat(var0_150), var1_150 + var2_150 + var3_150
end

function filterEgyUnicode(arg0_151)
	arg0_151 = string.gsub(arg0_151, "�[�-�][�-�]", "")
	arg0_151 = string.gsub(arg0_151, "�[�-�]", "")

	return arg0_151
end

function shiftPanel(arg0_152, arg1_152, arg2_152, arg3_152, arg4_152, arg5_152, arg6_152, arg7_152, arg8_152)
	arg3_152 = arg3_152 or 0.2

	if arg5_152 then
		LeanTween.cancel(go(arg0_152))
	end

	local var0_152 = rtf(arg0_152)

	arg1_152 = arg1_152 or var0_152.anchoredPosition.x
	arg2_152 = arg2_152 or var0_152.anchoredPosition.y

	local var1_152 = LeanTween.move(var0_152, Vector3(arg1_152, arg2_152, 0), arg3_152)

	arg7_152 = arg7_152 or LeanTweenType.easeInOutSine

	var1_152:setEase(arg7_152)

	if arg4_152 then
		var1_152:setDelay(arg4_152)
	end

	if arg6_152 then
		GetOrAddComponent(arg0_152, "CanvasGroup").blocksRaycasts = false
	end

	var1_152:setOnComplete(System.Action(function()
		if arg8_152 then
			arg8_152()
		end

		if arg6_152 then
			GetOrAddComponent(arg0_152, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_152
end

function TweenValue(arg0_154, arg1_154, arg2_154, arg3_154, arg4_154, arg5_154, arg6_154, arg7_154)
	local var0_154 = LeanTween.value(go(arg0_154), arg1_154, arg2_154, arg3_154):setOnUpdate(System.Action_float(function(arg0_155)
		if arg5_154 then
			arg5_154(arg0_155)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_154 then
			arg6_154()
		end
	end)):setDelay(arg4_154 or 0)

	if arg7_154 and arg7_154 > 0 then
		var0_154:setRepeat(arg7_154)
	end

	return var0_154
end

function rotateAni(arg0_157, arg1_157, arg2_157)
	return LeanTween.rotate(rtf(arg0_157), 360 * arg1_157, arg2_157):setLoopClamp()
end

function blinkAni(arg0_158, arg1_158, arg2_158, arg3_158)
	return LeanTween.alpha(rtf(arg0_158), arg3_158 or 0, arg1_158):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_158 or 0)
end

function scaleAni(arg0_159, arg1_159, arg2_159, arg3_159)
	return LeanTween.scale(rtf(arg0_159), arg3_159 or 0, arg1_159):setLoopPingPong(arg2_159 or 0)
end

function floatAni(arg0_160, arg1_160, arg2_160, arg3_160)
	local var0_160 = arg0_160.localPosition.y + arg1_160

	return LeanTween.moveY(rtf(arg0_160), var0_160, arg2_160):setLoopPingPong(arg3_160 or 0)
end

local var9_0 = tostring

function tostring(arg0_161)
	if arg0_161 == nil then
		return "nil"
	end

	local var0_161 = var9_0(arg0_161)

	if var0_161 == nil then
		if type(arg0_161) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_161
end

function wordVer(arg0_162, arg1_162)
	if arg0_162.match(arg0_162, ChatConst.EmojiCodeMatch) then
		return 0, arg0_162
	end

	arg1_162 = arg1_162 or {}

	local var0_162 = filterEgyUnicode(arg0_162)

	if #var0_162 ~= #arg0_162 then
		if arg1_162.isReplace then
			arg0_162 = var0_162
		else
			return 1
		end
	end

	local var1_162 = wordSplit(arg0_162)
	local var2_162 = pg.word_template
	local var3_162 = pg.word_legal_template

	arg1_162.isReplace = arg1_162.isReplace or false
	arg1_162.replaceWord = arg1_162.replaceWord or "*"

	local var4_162 = #var1_162
	local var5_162 = 1
	local var6_162 = ""
	local var7_162 = 0

	while var5_162 <= var4_162 do
		local var8_162, var9_162, var10_162 = wordLegalMatch(var1_162, var3_162, var5_162)

		if var8_162 then
			var5_162 = var9_162
			var6_162 = var6_162 .. var10_162
		else
			local var11_162, var12_162, var13_162 = wordVerMatch(var1_162, var2_162, arg1_162, var5_162, "", false, var5_162, "")

			if var11_162 then
				var5_162 = var12_162
				var7_162 = var7_162 + 1

				if arg1_162.isReplace then
					var6_162 = var6_162 .. var13_162
				end
			else
				if arg1_162.isReplace then
					var6_162 = var6_162 .. var1_162[var5_162]
				end

				var5_162 = var5_162 + 1
			end
		end
	end

	if arg1_162.isReplace then
		return var7_162, var6_162
	else
		return var7_162
	end
end

function wordLegalMatch(arg0_163, arg1_163, arg2_163, arg3_163, arg4_163)
	if arg2_163 > #arg0_163 then
		return arg3_163, arg2_163, arg4_163
	end

	local var0_163 = arg0_163[arg2_163]
	local var1_163 = arg1_163[var0_163]

	arg4_163 = arg4_163 == nil and "" or arg4_163

	if var1_163 then
		if var1_163.this then
			return wordLegalMatch(arg0_163, var1_163, arg2_163 + 1, true, arg4_163 .. var0_163)
		else
			return wordLegalMatch(arg0_163, var1_163, arg2_163 + 1, false, arg4_163 .. var0_163)
		end
	else
		return arg3_163, arg2_163, arg4_163
	end
end

local var10_0 = string.byte("a")
local var11_0 = string.byte("z")
local var12_0 = string.byte("A")
local var13_0 = string.byte("Z")

local function var14_0(arg0_164)
	if not arg0_164 then
		return arg0_164
	end

	local var0_164 = string.byte(arg0_164)

	if var0_164 > 128 then
		return
	end

	if var0_164 >= var10_0 and var0_164 <= var11_0 then
		return string.char(var0_164 - 32)
	elseif var0_164 >= var12_0 and var0_164 <= var13_0 then
		return string.char(var0_164 + 32)
	else
		return arg0_164
	end
end

function wordVerMatch(arg0_165, arg1_165, arg2_165, arg3_165, arg4_165, arg5_165, arg6_165, arg7_165)
	if arg3_165 > #arg0_165 then
		return arg5_165, arg6_165, arg7_165
	end

	local var0_165 = arg0_165[arg3_165]
	local var1_165 = arg1_165[var0_165]

	if var1_165 then
		local var2_165, var3_165, var4_165 = wordVerMatch(arg0_165, var1_165, arg2_165, arg3_165 + 1, arg2_165.isReplace and arg4_165 .. arg2_165.replaceWord or arg4_165, var1_165.this or arg5_165, var1_165.this and arg3_165 + 1 or arg6_165, var1_165.this and (arg2_165.isReplace and arg4_165 .. arg2_165.replaceWord or arg4_165) or arg7_165)

		if var2_165 then
			return var2_165, var3_165, var4_165
		end
	end

	local var5_165 = var14_0(var0_165)
	local var6_165 = arg1_165[var5_165]

	if var5_165 ~= var0_165 and var6_165 then
		local var7_165, var8_165, var9_165 = wordVerMatch(arg0_165, var6_165, arg2_165, arg3_165 + 1, arg2_165.isReplace and arg4_165 .. arg2_165.replaceWord or arg4_165, var6_165.this or arg5_165, var6_165.this and arg3_165 + 1 or arg6_165, var6_165.this and (arg2_165.isReplace and arg4_165 .. arg2_165.replaceWord or arg4_165) or arg7_165)

		if var7_165 then
			return var7_165, var8_165, var9_165
		end
	end

	return arg5_165, arg6_165, arg7_165
end

function wordSplit(arg0_166)
	local var0_166 = {}

	for iter0_166 in arg0_166.gmatch(arg0_166, "[\x01-\x7F�-�][�-�]*") do
		var0_166[#var0_166 + 1] = iter0_166
	end

	return var0_166
end

function contentWrap(arg0_167, arg1_167, arg2_167)
	local var0_167 = LuaHelper.WrapContent(arg0_167, arg1_167, arg2_167)

	return #var0_167 ~= #arg0_167, var0_167
end

function cancelRich(arg0_168)
	local var0_168

	for iter0_168 = 1, 20 do
		local var1_168

		arg0_168, var1_168 = string.gsub(arg0_168, "<([^>]*)>", "%1")

		if var1_168 <= 0 then
			break
		end
	end

	return arg0_168
end

function cancelColorRich(arg0_169)
	local var0_169

	for iter0_169 = 1, 20 do
		local var1_169

		arg0_169, var1_169 = string.gsub(arg0_169, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")

		if var1_169 <= 0 then
			break
		end
	end

	return arg0_169
end

function getSkillConfig(arg0_170)
	local var0_170 = require("GameCfg.buff.buff_" .. arg0_170)

	if not var0_170 then
		warning("找不到技能配置: " .. arg0_170)

		return
	end

	local var1_170 = Clone(var0_170)

	var1_170.name = getSkillName(arg0_170)
	var1_170.desc = HXSet.hxLan(var1_170.desc)
	var1_170.desc_get = HXSet.hxLan(var1_170.desc_get)

	_.each(var1_170, function(arg0_171)
		arg0_171.desc = HXSet.hxLan(arg0_171.desc)
	end)

	return var1_170
end

function getSkillName(arg0_172)
	local var0_172 = pg.skill_data_template[arg0_172] or pg.skill_data_display[arg0_172]

	if var0_172 then
		return HXSet.hxLan(var0_172.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_173, arg1_173)
	local var0_173 = arg1_173 and pg.skill_world_display[arg0_173] and setmetatable({}, {
		__index = function(arg0_174, arg1_174)
			return pg.skill_world_display[arg0_173][arg1_174] or pg.skill_data_template[arg0_173][arg1_174]
		end
	}) or pg.skill_data_template[arg0_173]

	if not var0_173 then
		return ""
	end

	local var1_173 = var0_173.desc_get ~= "" and var0_173.desc_get or var0_173.desc

	for iter0_173, iter1_173 in pairs(var0_173.desc_get_add) do
		local var2_173 = setColorStr(iter1_173[1], COLOR_GREEN)

		if iter1_173[2] then
			var2_173 = var2_173 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_173[2], COLOR_GREEN))
		end

		var1_173 = specialGSub(var1_173, "$" .. iter0_173, var2_173)
	end

	return HXSet.hxLan(var1_173)
end

function getSkillDescLearn(arg0_175, arg1_175, arg2_175)
	local var0_175 = arg2_175 and pg.skill_world_display[arg0_175] and setmetatable({}, {
		__index = function(arg0_176, arg1_176)
			return pg.skill_world_display[arg0_175][arg1_176] or pg.skill_data_template[arg0_175][arg1_176]
		end
	}) or pg.skill_data_template[arg0_175]

	if not var0_175 then
		return ""
	end

	local var1_175 = var0_175.desc

	if not var0_175.desc_add then
		return HXSet.hxLan(var1_175)
	end

	for iter0_175, iter1_175 in pairs(var0_175.desc_add) do
		local var2_175 = iter1_175[arg1_175][1]

		if iter1_175[arg1_175][2] then
			var2_175 = var2_175 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_175[arg1_175][2])
		end

		var1_175 = specialGSub(var1_175, "$" .. iter0_175, setColorStr(var2_175, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_175)
end

function getSkillDesc(arg0_177, arg1_177, arg2_177)
	local var0_177 = arg2_177 and pg.skill_world_display[arg0_177] and setmetatable({}, {
		__index = function(arg0_178, arg1_178)
			return pg.skill_world_display[arg0_177][arg1_178] or pg.skill_data_template[arg0_177][arg1_178]
		end
	}) or pg.skill_data_template[arg0_177]

	if not var0_177 then
		return ""
	end

	local var1_177 = var0_177.desc

	if not var0_177.desc_add then
		return HXSet.hxLan(var1_177)
	end

	for iter0_177, iter1_177 in pairs(var0_177.desc_add) do
		local var2_177 = setColorStr(iter1_177[arg1_177][1], COLOR_GREEN)

		var1_177 = specialGSub(var1_177, "$" .. iter0_177, var2_177)
	end

	return HXSet.hxLan(var1_177)
end

function specialGSub(arg0_179, arg1_179, arg2_179)
	arg0_179 = string.gsub(arg0_179, "<color=#", "<color=NNN")
	arg0_179 = string.gsub(arg0_179, "#", "")
	arg2_179 = string.gsub(arg2_179, "%%", "%%%%")
	arg0_179 = string.gsub(arg0_179, arg1_179, arg2_179)
	arg0_179 = string.gsub(arg0_179, "<color=NNN", "<color=#")

	return arg0_179
end

function topAnimation(arg0_180, arg1_180, arg2_180, arg3_180, arg4_180, arg5_180)
	local var0_180 = {}

	arg4_180 = arg4_180 or 0.27

	local var1_180 = 0.05

	if arg0_180 then
		local var2_180 = arg0_180.transform.localPosition.x

		setAnchoredPosition(arg0_180, {
			x = var2_180 - 500
		})
		shiftPanel(arg0_180, var2_180, nil, 0.05, arg4_180, true, true)
		setActive(arg0_180, true)
	end

	setActive(arg1_180, false)
	setActive(arg2_180, false)
	setActive(arg3_180, false)

	for iter0_180 = 1, 3 do
		table.insert(var0_180, LeanTween.delayedCall(arg4_180 + 0.13 + var1_180 * iter0_180, System.Action(function()
			if arg1_180 then
				setActive(arg1_180, not arg1_180.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_180, LeanTween.delayedCall(arg4_180 + 0.02 + var1_180 * iter0_180, System.Action(function()
			if arg2_180 then
				setActive(arg2_180, not go(arg2_180).activeSelf)
			end

			if arg2_180 then
				setActive(arg3_180, not go(arg3_180).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_180 then
		table.insert(var0_180, LeanTween.delayedCall(arg4_180 + 0.13 + var1_180 * 3 + 0.1, System.Action(function()
			arg5_180()
		end)).uniqueId)
	end

	return var0_180
end

function cancelTweens(arg0_184)
	assert(arg0_184, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_184, iter1_184 in ipairs(arg0_184) do
		if iter1_184 then
			LeanTween.cancel(iter1_184)
		end
	end
end

function getOfflineTimeStamp(arg0_185)
	local var0_185 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_185
	local var1_185 = ""

	if var0_185 <= 59 then
		var1_185 = i18n("just_now")
	elseif var0_185 <= 3599 then
		var1_185 = i18n("several_minutes_before", math.floor(var0_185 / 60))
	elseif var0_185 <= 86399 then
		var1_185 = i18n("several_hours_before", math.floor(var0_185 / 3600))
	else
		var1_185 = i18n("several_days_before", math.floor(var0_185 / 86400))
	end

	return var1_185
end

function playMovie(arg0_186, arg1_186, arg2_186)
	local var0_186 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_186) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_186, function(arg0_187)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_187 = GCHandle.Alloc(arg0_187, GCHandleType.Pinned)

			setActive(var0_186, true)

			local var1_187 = var0_186:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_187.player:SetData(arg0_187, arg0_187.Length)

			var1_187.target = var0_186:GetComponent(typeof(Image))
			var1_187.loop = false
			var1_187.additiveMode = false
			var1_187.playOnStart = true

			local var2_187

			var2_187 = Timer.New(function()
				if var1_187.player.status == CriMana.Player.Status.PlayEnd or var1_187.player.status == CriMana.Player.Status.Stop or var1_187.player.status == CriMana.Player.Status.Error then
					var2_187:Stop()
					Object.Destroy(var1_187)
					GCHandle.Free(var0_187)
					setActive(var0_186, false)

					if arg1_186 then
						arg1_186()
					end
				end
			end, 0.2, -1)

			var2_187:Start()
			removeOnButton(var0_186)

			if arg2_186 then
				onButton(nil, var0_186, function()
					var1_187:Stop()
					GetOrAddComponent(var0_186, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_186 then
		arg1_186()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_190)
	if PaintCameraAdjustOn ~= arg0_190 then
		local var0_190 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_190 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0_190.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_190.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0_190.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0_190
	end
end

function ManhattonDist(arg0_191, arg1_191)
	return math.abs(arg0_191.row - arg1_191.row) + math.abs(arg0_191.column - arg1_191.column)
end

function checkFirstHelpShow(arg0_192)
	local var0_192 = getProxy(SettingsProxy)

	if not var0_192:checkReadHelp(arg0_192) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_192].tip
		})
		var0_192:recordReadHelp(arg0_192)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_193)
	enableNotch(arg0_193, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_194)
	enableNotch(arg0_194, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_194 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_196, arg1_196)
	if arg0_196 == nil then
		return
	end

	local var0_196 = arg0_196:GetComponent("NotchAdapt")
	local var1_196 = arg0_196:GetComponent("AspectRatioFitter")

	var0_196.enabled = arg1_196

	if var1_196 then
		if arg1_196 then
			var1_196.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1_196.enabled
			var1_196.enabled = false
		end
	end
end

function comma_value(arg0_197)
	local var0_197 = arg0_197
	local var1_197 = 0

	repeat
		local var2_197

		var0_197, var2_197 = string.gsub(var0_197, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_197 == 0

	return var0_197
end

local var15_0 = 0.2

function SwitchPanel(arg0_198, arg1_198, arg2_198, arg3_198, arg4_198, arg5_198)
	arg3_198 = defaultValue(arg3_198, var15_0)

	if arg5_198 then
		LeanTween.cancel(go(arg0_198))
	end

	local var0_198 = Vector3.New(tf(arg0_198).localPosition.x, tf(arg0_198).localPosition.y, tf(arg0_198).localPosition.z)

	if arg1_198 then
		var0_198.x = arg1_198
	end

	if arg2_198 then
		var0_198.y = arg2_198
	end

	local var1_198 = LeanTween.move(rtf(arg0_198), var0_198, arg3_198):setEase(LeanTweenType.easeInOutSine)

	if arg4_198 then
		var1_198:setDelay(arg4_198)
	end

	return var1_198
end

function updateActivityTaskStatus(arg0_199)
	local var0_199 = arg0_199:getConfig("config_id")
	local var1_199, var2_199 = getActivityTask(arg0_199, true)

	if not var2_199 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_199.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_200)
	local var0_200 = getProxy(TaskProxy)
	local var1_200 = arg0_200:getNDay()

	for iter0_200, iter1_200 in ipairs(arg0_200:getConfig("config_data")) do
		local var2_200 = pg.battlepass_task_group[iter1_200]

		if var1_200 >= var2_200.time and underscore.any(underscore.flatten(var2_200.task_group), function(arg0_201)
			return var0_200:getTaskVO(arg0_201) == nil
		end) then
			pg.m02:sendNotification(GAME.CRUSING_CMD, {
				cmd = 1,
				activity_id = arg0_200.id
			})

			return true
		end
	end

	return false
end

function setShipCardFrame(arg0_202, arg1_202, arg2_202)
	arg0_202.localScale = Vector3.one
	arg0_202.anchorMin = Vector2.zero
	arg0_202.anchorMax = Vector2.one

	local var0_202 = arg2_202 or arg1_202

	GetImageSpriteFromAtlasAsync("shipframe", var0_202, arg0_202)

	local var1_202 = pg.frame_resource[var0_202]

	if var1_202 then
		local var2_202 = var1_202.param

		arg0_202.offsetMin = Vector2(var2_202[1], var2_202[2])
		arg0_202.offsetMax = Vector2(var2_202[3], var2_202[4])
	else
		arg0_202.offsetMin = Vector2.zero
		arg0_202.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_203, arg1_203, arg2_203)
	arg0_203.localScale = Vector3.one
	arg0_203.anchorMin = Vector2.zero
	arg0_203.anchorMax = Vector2.one

	setImageSprite(arg0_203, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_203 or arg1_203)))

	local var0_203 = "b" .. (arg2_203 or arg1_203)
	local var1_203 = pg.frame_resource[var0_203]

	if var1_203 then
		local var2_203 = var1_203.param

		arg0_203.offsetMin = Vector2(var2_203[1], var2_203[2])
		arg0_203.offsetMax = Vector2(var2_203[3], var2_203[4])
	else
		arg0_203.offsetMin = Vector2.zero
		arg0_203.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_204, arg1_204)
	if arg1_204 then
		local var0_204 = arg1_204 .. "(Clone)"
		local var1_204 = false

		eachChild(arg0_204, function(arg0_205)
			setActive(arg0_205, arg0_205.name == var0_204)

			var1_204 = var1_204 or arg0_205.name == var0_204
		end)

		if not var1_204 then
			LoadAndInstantiateAsync("effect", arg1_204, function(arg0_206)
				if IsNil(arg0_204) or findTF(arg0_204, var0_204) then
					Object.Destroy(arg0_206)
				else
					setParent(arg0_206, arg0_204)
					setActive(arg0_206, true)
				end
			end)
		end
	end

	setActive(arg0_204, arg1_204)
end

function setProposeMarkIcon(arg0_207, arg1_207)
	local var0_207 = arg0_207:Find("proposeShipCard(Clone)")
	local var1_207 = arg1_207.propose and not arg1_207:ShowPropose()

	if var0_207 then
		setActive(var0_207, var1_207)
	elseif var1_207 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_208)
			if IsNil(arg0_207) or arg0_207:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_208)
			else
				setParent(arg0_208, arg0_207, false)
			end
		end)
	end
end

function flushShipCard(arg0_209, arg1_209)
	local var0_209 = arg1_209:rarity2bgPrint()
	local var1_209 = findTF(arg0_209, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_209, "", var1_209)

	local var2_209 = findTF(arg0_209, "content/ship_icon")
	local var3_209 = arg1_209 and {
		"shipYardIcon/" .. arg1_209:getPainting(),
		arg1_209:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_209[1], var3_209[2], var2_209)

	local var4_209 = arg1_209:getShipType()
	local var5_209 = findTF(arg0_209, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_209), var5_209)
	setText(findTF(arg0_209, "content/dockyard/lv/Text"), defaultValue(arg1_209.level, 1))

	local var6_209 = arg1_209:getStar()
	local var7_209 = arg1_209:getMaxStar()
	local var8_209 = findTF(arg0_209, "content/front/stars")

	setActive(var8_209, true)

	local var9_209 = findTF(var8_209, "star_tpl")
	local var10_209 = var8_209.childCount

	for iter0_209 = 1, Ship.CONFIG_MAX_STAR do
		local var11_209 = var10_209 < iter0_209 and cloneTplTo(var9_209, var8_209) or var8_209:GetChild(iter0_209 - 1)

		setActive(var11_209, iter0_209 <= var7_209)
		triggerToggle(var11_209, iter0_209 <= var6_209)
	end

	local var12_209 = findTF(arg0_209, "content/front/frame")
	local var13_209, var14_209 = arg1_209:GetFrameAndEffect()

	setShipCardFrame(var12_209, var0_209, var13_209)
	setFrameEffect(findTF(arg0_209, "content/front/bg_other"), var14_209)
	setProposeMarkIcon(arg0_209:Find("content/dockyard/propose"), arg1_209)
end

function TweenItemAlphaAndWhite(arg0_210)
	LeanTween.cancel(arg0_210)

	local var0_210 = GetOrAddComponent(arg0_210, "CanvasGroup")

	var0_210.alpha = 0

	LeanTween.alphaCanvas(var0_210, 1, 0.2):setUseEstimatedTime(true)

	local var1_210 = findTF(arg0_210.transform, "white_mask")

	if var1_210 then
		setActive(var1_210, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_211)
	LeanTween.cancel(arg0_211)

	GetOrAddComponent(arg0_211, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_212)
	local var0_212 = {}
	local var1_212 = getProxy(ShipSkinProxy):getSkinList()
	local var2_212 = getProxy(CollectionProxy):getShipGroup(arg0_212)

	if var2_212 then
		local var3_212 = ShipGroup.getSkinList(arg0_212)

		for iter0_212, iter1_212 in ipairs(var3_212) do
			if iter1_212.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_212, iter1_212.id) or iter1_212.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_212.trans or iter1_212.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_212.married == 1 then
				var0_212[iter1_212.id] = true
			end
		end
	end

	return var0_212
end

function split(arg0_213, arg1_213)
	local var0_213 = {}

	if not arg0_213 then
		return nil
	end

	local var1_213 = #arg0_213
	local var2_213 = 1

	while var2_213 <= var1_213 do
		local var3_213 = string.find(arg0_213, arg1_213, var2_213)

		if var3_213 == nil then
			table.insert(var0_213, string.sub(arg0_213, var2_213, var1_213))

			break
		end

		table.insert(var0_213, string.sub(arg0_213, var2_213, var3_213 - 1))

		if var3_213 == var1_213 then
			table.insert(var0_213, "")

			break
		end

		var2_213 = var3_213 + 1
	end

	return var0_213
end

function NumberToChinese(arg0_214, arg1_214)
	local var0_214 = ""
	local var1_214 = #arg0_214

	for iter0_214 = 1, var1_214 do
		local var2_214 = string.sub(arg0_214, iter0_214, iter0_214)

		if var2_214 ~= "0" or var2_214 == "0" and not arg1_214 then
			if arg1_214 then
				if var1_214 >= 2 then
					if iter0_214 == 1 then
						if var2_214 == "1" then
							var0_214 = i18n("number_" .. 10)
						else
							var0_214 = i18n("number_" .. var2_214) .. i18n("number_" .. 10)
						end
					else
						var0_214 = var0_214 .. i18n("number_" .. var2_214)
					end
				else
					var0_214 = var0_214 .. i18n("number_" .. var2_214)
				end
			else
				var0_214 = var0_214 .. i18n("number_" .. var2_214)
			end
		end
	end

	return var0_214
end

function getActivityTask(arg0_215, arg1_215)
	local var0_215 = getProxy(TaskProxy)
	local var1_215 = arg0_215:getConfig("config_data")
	local var2_215 = arg0_215:getNDay(arg0_215.data1)
	local var3_215
	local var4_215
	local var5_215

	for iter0_215 = math.max(arg0_215.data3, 1), math.min(var2_215, #var1_215) do
		local var6_215 = _.flatten({
			var1_215[iter0_215]
		})

		for iter1_215, iter2_215 in ipairs(var6_215) do
			local var7_215 = var0_215:getTaskById(iter2_215)

			if var7_215 then
				return var7_215.id, var7_215
			end

			if var4_215 then
				var5_215 = var0_215:getFinishTaskById(iter2_215)

				if var5_215 then
					var4_215 = var5_215
				elseif arg1_215 then
					return iter2_215
				else
					return var4_215.id, var4_215
				end
			else
				var4_215 = var0_215:getFinishTaskById(iter2_215)
				var5_215 = var5_215 or iter2_215
			end
		end
	end

	if var4_215 then
		return var4_215.id, var4_215
	else
		return var5_215
	end
end

function setImageFromImage(arg0_216, arg1_216, arg2_216)
	local var0_216 = GetComponent(arg0_216, "Image")

	var0_216.sprite = GetComponent(arg1_216, "Image").sprite

	if arg2_216 then
		var0_216:SetNativeSize()
	end
end

function skinTimeStamp(arg0_217)
	local var0_217, var1_217, var2_217, var3_217 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_217)

	if var0_217 >= 1 then
		return i18n("limit_skin_time_day", var0_217)
	elseif var0_217 <= 0 and var1_217 > 0 then
		return i18n("limit_skin_time_day_min", var1_217, var2_217)
	elseif var0_217 <= 0 and var1_217 <= 0 and (var2_217 > 0 or var3_217 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_217, 1))
	elseif var0_217 <= 0 and var1_217 <= 0 and var2_217 <= 0 and var3_217 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_218)
	local var0_218 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_218 = math.max(arg0_218 - var0_218, 0)
	local var2_218 = math.floor(var1_218 / 86400)

	if var2_218 > 0 then
		return i18n("time_remaining_tip") .. var2_218 .. i18n("word_date")
	else
		local var3_218 = math.floor(var1_218 / 3600)

		if var3_218 > 0 then
			return i18n("time_remaining_tip") .. var3_218 .. i18n("word_hour")
		else
			local var4_218 = math.floor(var1_218 / 60)

			if var4_218 > 0 then
				return i18n("time_remaining_tip") .. var4_218 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_218 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_219)
	local var0_219 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_219
	local var1_219 = var0_219 / 86400

	if var1_219 > 1 then
		return i18n("ins_word_day", math.floor(var1_219))
	else
		local var2_219 = var0_219 / 3600

		if var2_219 > 1 then
			return i18n("ins_word_hour", math.floor(var2_219))
		else
			local var3_219 = var0_219 / 60

			if var3_219 > 1 then
				return i18n("ins_word_minu", math.floor(var3_219))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_220)
	local var0_220 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_220
	local var1_220 = var0_220 / 86400

	if var1_220 > 1 then
		return i18n1(math.floor(var1_220) .. "d")
	else
		local var2_220 = var0_220 / 3600

		if var2_220 > 1 then
			return i18n1(math.floor(var2_220) .. "h")
		else
			local var3_220 = var0_220 / 60

			if var3_220 > 1 then
				return i18n1(math.floor(var3_220) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_221)
	local var0_221, var1_221, var2_221, var3_221 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_221)

	if var0_221 <= 0 and var1_221 <= 0 and var2_221 <= 0 and var3_221 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_221, var1_221, var2_221)
	end
end

function checkExist(arg0_222, ...)
	local var0_222 = {
		...
	}

	for iter0_222, iter1_222 in ipairs(var0_222) do
		if arg0_222 == nil then
			break
		end

		assert(type(arg0_222) == "table", "type error : intermediate target should be table")
		assert(type(iter1_222) == "table", "type error : param should be table")

		if type(arg0_222[iter1_222[1]]) == "function" then
			arg0_222 = arg0_222[iter1_222[1]](arg0_222, unpack(iter1_222[2] or {}))
		else
			arg0_222 = arg0_222[iter1_222[1]]
		end
	end

	return arg0_222
end

function AcessWithinNull(arg0_223, arg1_223)
	if arg0_223 == nil then
		return
	end

	assert(type(arg0_223) == "table")

	return arg0_223[arg1_223]
end

function showRepairMsgbox()
	local var0_224 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_224 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_224 = {
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
			var2_224,
			var1_224,
			var0_224
		}
	})
end

function resourceVerify(arg0_228, arg1_228)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_228 = Application.persistentDataPath .. "/hashes.csv"
	local var1_228
	local var2_228 = PathMgr.ReadAllLines(var0_228)
	local var3_228 = {}

	if arg0_228 then
		setActive(arg0_228, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_228()
		if arg0_228 then
			setActive(arg0_228, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_228)

		if var1_228 then
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

	local var5_228 = var2_228.Length
	local var6_228

	local function var7_228(arg0_231)
		if arg0_231 < 0 then
			var4_228()

			return
		end

		if arg1_228 then
			setSlider(arg1_228, 0, var5_228, var5_228 - arg0_231)
		end

		local var0_231 = string.split(var2_228[arg0_231], ",")
		local var1_231 = var0_231[1]
		local var2_231 = var0_231[3]
		local var3_231 = PathMgr.getAssetBundle(var1_231)

		if PathMgr.FileExists(var3_231) then
			local var4_231 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_231))

			if var2_231 == HashUtil.CalcMD5(var4_231) then
				onNextTick(function()
					var7_228(arg0_231 - 1)
				end)

				return
			end
		end

		var1_228 = var1_231

		var4_228()
	end

	var7_228(var5_228 - 1)
end

function splitByWordEN(arg0_233, arg1_233)
	local var0_233 = string.split(arg0_233, " ")
	local var1_233 = ""
	local var2_233 = ""
	local var3_233 = arg1_233:GetComponent(typeof(RectTransform))
	local var4_233 = arg1_233:GetComponent(typeof(Text))
	local var5_233 = var3_233.rect.width

	for iter0_233, iter1_233 in ipairs(var0_233) do
		local var6_233 = var2_233

		var2_233 = var2_233 == "" and iter1_233 or var2_233 .. " " .. iter1_233

		setText(arg1_233, var2_233)

		if var5_233 < var4_233.preferredWidth then
			var1_233 = var1_233 == "" and var6_233 or var1_233 .. "\n" .. var6_233
			var2_233 = iter1_233
		end

		if iter0_233 >= #var0_233 then
			var1_233 = var1_233 == "" and var2_233 or var1_233 .. "\n" .. var2_233
		end
	end

	return var1_233
end

function checkBirthFormat(arg0_234)
	if #arg0_234 ~= 8 then
		return false
	end

	local var0_234 = 0
	local var1_234 = #arg0_234

	while var0_234 < var1_234 do
		local var2_234 = string.byte(arg0_234, var0_234 + 1)

		if var2_234 < 48 or var2_234 > 57 then
			return false
		end

		var0_234 = var0_234 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_235)
	local var0_235 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_235, function(arg0_236)
		return arg0_236 == arg0_235
	end)
end

function GetServerState(arg0_237)
	local var0_237 = -1
	local var1_237 = 0
	local var2_237 = 1
	local var3_237 = 2
	local var4_237 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_237 = string.gsub(var4_237, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_237, function(arg0_238, arg1_238)
		local var0_238 = true
		local var1_238 = false

		for iter0_238 in string.gmatch(arg1_238, "\"state\":%d") do
			if iter0_238 ~= "\"state\":1" then
				var0_238 = false
			end

			var1_238 = true
		end

		if not var1_238 then
			var0_238 = false
		end

		if arg0_237 ~= nil then
			arg0_237(var0_238 and var2_237 or var1_237)
		end
	end)
end

function setScrollText(arg0_239, arg1_239)
	GetOrAddComponent(arg0_239, "ScrollText"):SetText(arg1_239)
end

function changeToScrollText(arg0_240, arg1_240)
	local var0_240 = GetComponent(arg0_240, typeof(Text))

	assert(var0_240, "without component<Text>")

	local var1_240 = arg0_240:Find("subText")

	if not var1_240 then
		var1_240 = cloneTplTo(arg0_240, arg0_240, "subText")

		eachChild(arg0_240, function(arg0_241)
			setActive(arg0_241, arg0_241 == var1_240)
		end)

		arg0_240:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_240, arg1_240)
end

local var16_0
local var17_0
local var18_0
local var19_0

local function var20_0(arg0_242, arg1_242, arg2_242)
	local var0_242 = arg0_242:Find("base")
	local var1_242, var2_242, var3_242 = Equipment.GetInfoTrans(arg1_242, arg2_242)

	if arg1_242.nextValue then
		local var4_242 = {
			name = arg1_242.name,
			type = arg1_242.type,
			value = arg1_242.nextValue
		}
		local var5_242, var6_242 = Equipment.GetInfoTrans(var4_242, arg2_242)

		var2_242 = var2_242 .. setColorStr("   >   " .. var6_242, COLOR_GREEN)
	end

	setText(var0_242:Find("name"), var1_242)

	if var3_242 then
		local var7_242 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_242:Find("value"), var2_242 .. var7_242)
	else
		setText(var0_242:Find("value"), var2_242)
	end

	setActive(var0_242:Find("value/up"), arg1_242.compare and arg1_242.compare > 0)
	setActive(var0_242:Find("value/down"), arg1_242.compare and arg1_242.compare < 0)
	triggerToggle(var0_242, arg1_242.lock_open)

	if not arg1_242.lock_open and arg1_242.sub and #arg1_242.sub > 0 then
		GetComponent(var0_242, typeof(Toggle)).enabled = true
	else
		setActive(var0_242:Find("name/close"), false)
		setActive(var0_242:Find("name/open"), false)

		GetComponent(var0_242, typeof(Toggle)).enabled = false
	end
end

local function var21_0(arg0_243, arg1_243, arg2_243, arg3_243)
	var20_0(arg0_243, arg2_243, arg3_243)

	if not arg2_243.sub or #arg2_243.sub == 0 then
		return
	end

	var18_0(arg0_243:Find("subs"), arg1_243, arg2_243.sub, arg3_243)
end

function var18_0(arg0_244, arg1_244, arg2_244, arg3_244)
	removeAllChildren(arg0_244)
	var19_0(arg0_244, arg1_244, arg2_244, arg3_244)
end

function var19_0(arg0_245, arg1_245, arg2_245, arg3_245)
	for iter0_245, iter1_245 in ipairs(arg2_245) do
		local var0_245 = cloneTplTo(arg1_245, arg0_245)

		var21_0(var0_245, arg1_245, iter1_245, arg3_245)
	end
end

function updateEquipInfo(arg0_246, arg1_246, arg2_246, arg3_246)
	local var0_246 = arg0_246:Find("attr_tpl")

	var18_0(arg0_246:Find("attrs"), var0_246, arg1_246.attrs, arg3_246)
	setActive(arg0_246:Find("skill"), arg2_246)

	if arg2_246 then
		var21_0(arg0_246:Find("skill/attr"), var0_246, {
			name = i18n("skill"),
			value = setColorStr(arg2_246.name, "#FFDE00FF")
		}, arg3_246)
		setText(arg0_246:Find("skill/value/Text"), getSkillDescGet(arg2_246.id))
	end

	setActive(arg0_246:Find("weapon"), #arg1_246.weapon.sub > 0)

	if #arg1_246.weapon.sub > 0 then
		var18_0(arg0_246:Find("weapon"), var0_246, {
			arg1_246.weapon
		}, arg3_246)
	end

	setActive(arg0_246:Find("equip_info"), #arg1_246.equipInfo.sub > 0)

	if #arg1_246.equipInfo.sub > 0 then
		var18_0(arg0_246:Find("equip_info"), var0_246, {
			arg1_246.equipInfo
		}, arg3_246)
	end

	var21_0(arg0_246:Find("part/attr"), var0_246, {
		name = i18n("equip_info_23")
	}, arg3_246)

	local var1_246 = arg0_246:Find("part/value")
	local var2_246 = var1_246:Find("label")
	local var3_246 = {}
	local var4_246 = {}

	if #arg1_246.part[1] == 0 and #arg1_246.part[2] == 0 then
		setmetatable(var3_246, {
			__index = function(arg0_247, arg1_247)
				return true
			end
		})
		setmetatable(var4_246, {
			__index = function(arg0_248, arg1_248)
				return true
			end
		})
	else
		for iter0_246, iter1_246 in ipairs(arg1_246.part[1]) do
			var3_246[iter1_246] = true
		end

		for iter2_246, iter3_246 in ipairs(arg1_246.part[2]) do
			var4_246[iter3_246] = true
		end
	end

	local var5_246 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_246, var4_246)

	UIItemList.StaticAlign(var1_246, var2_246, #var5_246, function(arg0_249, arg1_249, arg2_249)
		arg1_249 = arg1_249 + 1

		if arg0_249 == UIItemList.EventUpdate then
			local var0_249 = var5_246[arg1_249]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_249), arg2_249)
			setActive(arg2_249:Find("main"), var3_246[var0_249] and not var4_246[var0_249])
			setActive(arg2_249:Find("sub"), var4_246[var0_249] and not var3_246[var0_249])
			setImageAlpha(arg2_249, not var3_246[var0_249] and not var4_246[var0_249] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_250, arg1_250, arg2_250)
	local var0_250 = arg0_250:Find("attr_tpl")

	var18_0(arg0_250:Find("attrs"), var0_250, arg1_250.attrs, arg2_250)
	setActive(arg0_250:Find("weapon"), #arg1_250.weapon.sub > 0)

	if #arg1_250.weapon.sub > 0 then
		var18_0(arg0_250:Find("weapon"), var0_250, {
			arg1_250.weapon
		}, arg2_250)
	end

	setActive(arg0_250:Find("equip_info"), #arg1_250.equipInfo.sub > 0)

	if #arg1_250.equipInfo.sub > 0 then
		var18_0(arg0_250:Find("equip_info"), var0_250, {
			arg1_250.equipInfo
		}, arg2_250)
	end
end

function setCanvasOverrideSorting(arg0_251, arg1_251)
	local var0_251 = arg0_251.parent

	arg0_251:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_251) then
		GetOrAddComponent(arg0_251, typeof(Canvas)).overrideSorting = arg1_251
	else
		setActive(arg0_251, true)

		GetOrAddComponent(arg0_251, typeof(Canvas)).overrideSorting = arg1_251

		setActive(arg0_251, false)
	end

	arg0_251:SetParent(var0_251, false)
end

function createNewGameObject(arg0_252, arg1_252)
	local var0_252 = GameObject.New()

	if arg0_252 then
		var0_252.name = "model"
	end

	var0_252.layer = arg1_252 or Layer.UI

	return GetOrAddComponent(var0_252, "RectTransform")
end

function CreateShell(arg0_253)
	if type(arg0_253) ~= "table" and type(arg0_253) ~= "userdata" then
		return arg0_253
	end

	local var0_253 = setmetatable({
		__index = arg0_253
	}, arg0_253)

	return setmetatable({}, var0_253)
end

function CameraFittingSettin(arg0_254)
	local var0_254 = GetComponent(arg0_254, typeof(Camera))
	local var1_254 = 1.77777777777778
	local var2_254 = Screen.width / Screen.height

	if var2_254 < var1_254 then
		local var3_254 = var2_254 / var1_254

		var0_254.rect = var0_0.Rect.New(0, (1 - var3_254) / 2, 1, var3_254)
	end
end

function SwitchSpecialChar(arg0_255, arg1_255)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_255 = arg0_255:gsub(" ", " ")
		arg0_255 = arg0_255:gsub("\t", "    ")
	end

	if not arg1_255 then
		arg0_255 = arg0_255:gsub("\n", " ")
	end

	return arg0_255
end

function AfterCheck(arg0_256, arg1_256)
	local var0_256 = {}

	for iter0_256, iter1_256 in ipairs(arg0_256) do
		var0_256[iter0_256] = iter1_256[1]()
	end

	arg1_256()

	for iter2_256, iter3_256 in ipairs(arg0_256) do
		if var0_256[iter2_256] ~= iter3_256[1]() then
			iter3_256[2]()
		end

		var0_256[iter2_256] = iter3_256[1]()
	end
end

function CompareFuncs(arg0_257, arg1_257)
	local var0_257 = {}

	local function var1_257(arg0_258, arg1_258)
		var0_257[arg0_258] = var0_257[arg0_258] or {}
		var0_257[arg0_258][arg1_258] = var0_257[arg0_258][arg1_258] or arg0_257[arg0_258](arg1_258)

		return var0_257[arg0_258][arg1_258]
	end

	return function(arg0_259, arg1_259)
		local var0_259 = 1

		while var0_259 <= #arg0_257 do
			local var1_259 = var1_257(var0_259, arg0_259)
			local var2_259 = var1_257(var0_259, arg1_259)

			if var1_259 == var2_259 then
				var0_259 = var0_259 + 1
			else
				return var1_259 < var2_259
			end
		end

		return tobool(arg1_257)
	end
end

function DropResultIntegration(arg0_260)
	local var0_260 = {}
	local var1_260 = 1

	while var1_260 <= #arg0_260 do
		local var2_260 = arg0_260[var1_260].type
		local var3_260 = arg0_260[var1_260].id

		var0_260[var2_260] = var0_260[var2_260] or {}

		if var0_260[var2_260][var3_260] then
			local var4_260 = arg0_260[var0_260[var2_260][var3_260]]
			local var5_260 = table.remove(arg0_260, var1_260)

			var4_260.count = var4_260.count + var5_260.count
		else
			var0_260[var2_260][var3_260] = var1_260
			var1_260 = var1_260 + 1
		end
	end

	local var6_260 = {
		function(arg0_261)
			local var0_261 = arg0_261.type
			local var1_261 = arg0_261.id

			if var0_261 == DROP_TYPE_SHIP then
				return 1
			elseif var0_261 == DROP_TYPE_RESOURCE then
				if var1_261 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_261 == DROP_TYPE_ITEM then
				if var1_261 == 59010 then
					return 4
				elseif var1_261 == 59900 then
					return 5
				else
					local var2_261 = Item.getConfigData(var1_261)
					local var3_261 = var2_261 and var2_261.type or 0

					if var3_261 == 9 then
						return 6
					elseif var3_261 == 5 then
						return 7
					elseif var3_261 == 4 then
						return 8
					elseif var3_261 == 7 then
						return 9
					end
				end
			elseif var0_261 == DROP_TYPE_VITEM and var1_261 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_262)
			local var0_262

			if arg0_262.type == DROP_TYPE_SHIP then
				var0_262 = pg.ship_data_statistics[arg0_262.id]
			elseif arg0_262.type == DROP_TYPE_ITEM then
				var0_262 = Item.getConfigData(arg0_262.id)
			end

			return (var0_262 and var0_262.rarity or 0) * -1
		end,
		function(arg0_263)
			return arg0_263.id
		end
	}

	table.sort(arg0_260, CompareFuncs(var6_260))
end

function getLoginConfig()
	local var0_264 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_264 = 1

	for iter0_264, iter1_264 in ipairs(pg.login.all) do
		if pg.login[iter1_264].date ~= "stop" then
			local var2_264, var3_264 = parseTimeConfig(pg.login[iter1_264].date)

			assert(not var3_264)

			if pg.TimeMgr.GetInstance():inTime(var2_264, var0_264) then
				var1_264 = iter1_264

				break
			end
		end
	end

	local var4_264 = pg.login[var1_264].login_static

	var4_264 = var4_264 ~= "" and var4_264 or "login"

	local var5_264 = pg.login[var1_264].login_cri
	local var6_264 = var5_264 ~= "" and true or false
	local var7_264 = pg.login[var1_264].op_play == 1 and true or false
	local var8_264 = pg.login[var1_264].op_time

	if var8_264 == "" or not pg.TimeMgr.GetInstance():inTime(var8_264, var0_264) then
		var7_264 = false
	end

	local var9_264 = var8_264 == "" and var8_264 or table.concat(var8_264[1][1])

	return var6_264, var6_264 and var5_264 or var4_264, pg.login[var1_264].bgm, var7_264, var9_264
end

function setIntimacyIcon(arg0_265, arg1_265, arg2_265)
	local var0_265 = {}
	local var1_265

	seriesAsync({
		function(arg0_266)
			if arg0_265.childCount > 0 then
				var1_265 = arg0_265:GetChild(0)

				arg0_266()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_267)
					var1_265 = tf(arg0_267)

					setParent(var1_265, arg0_265)
					arg0_266()
				end)
			end
		end,
		function(arg0_268)
			setImageAlpha(var1_265, arg2_265 and 0 or 1)
			eachChild(var1_265, function(arg0_269)
				setActive(arg0_269, false)
			end)

			if arg2_265 then
				local var0_268 = var1_265:Find(arg2_265 .. "(Clone)")

				if not var0_268 then
					LoadAndInstantiateAsync("ui", arg2_265, function(arg0_270)
						setParent(arg0_270, var1_265)
						setActive(arg0_270, true)
					end)
				else
					setActive(var0_268, true)
				end
			elseif arg1_265 then
				setImageSprite(var1_265, GetSpriteFromAtlas("energy", arg1_265), true)
			else
				assert(false, "param error")
			end
		end
	})
end

local var22_0

function nowWorld()
	var22_0 = var22_0 or getProxy(WorldProxy)

	return var22_0 and var22_0.world
end

function removeWorld()
	var22_0.world:Dispose()

	var22_0.world = nil
	var22_0 = nil
end

function switch(arg0_273, arg1_273, arg2_273, ...)
	if arg1_273[arg0_273] then
		return arg1_273[arg0_273](...)
	elseif arg2_273 then
		return arg2_273(...)
	end
end

function parseTimeConfig(arg0_274)
	if type(arg0_274[1]) == "table" then
		return arg0_274[2], arg0_274[1]
	else
		return arg0_274
	end
end

local var23_0 = {
	__add = function(arg0_275, arg1_275)
		return NewPos(arg0_275.x + arg1_275.x, arg0_275.y + arg1_275.y)
	end,
	__sub = function(arg0_276, arg1_276)
		return NewPos(arg0_276.x - arg1_276.x, arg0_276.y - arg1_276.y)
	end,
	__mul = function(arg0_277, arg1_277)
		if type(arg1_277) == "number" then
			return NewPos(arg0_277.x * arg1_277, arg0_277.y * arg1_277)
		else
			return NewPos(arg0_277.x * arg1_277.x, arg0_277.y * arg1_277.y)
		end
	end,
	__eq = function(arg0_278, arg1_278)
		return arg0_278.x == arg1_278.x and arg0_278.y == arg1_278.y
	end,
	__tostring = function(arg0_279)
		return arg0_279.x .. "_" .. arg0_279.y
	end
}

function NewPos(arg0_280, arg1_280)
	assert(arg0_280 and arg1_280)

	local var0_280 = setmetatable({
		x = arg0_280,
		y = arg1_280
	}, var23_0)

	function var0_280.SqrMagnitude(arg0_281)
		return arg0_281.x * arg0_281.x + arg0_281.y * arg0_281.y
	end

	function var0_280.Normalize(arg0_282)
		local var0_282 = arg0_282:SqrMagnitude()

		if var0_282 > 1e-05 then
			return arg0_282 * (1 / math.sqrt(var0_282))
		else
			return NewPos(0, 0)
		end
	end

	return var0_280
end

local var24_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var24_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var24_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_284)
	return (string.char(226, 133, 160 + (arg0_284 - 1)))
end

function quickPlayAnimator(arg0_285, arg1_285)
	arg0_285:GetComponent(typeof(Animator)):Play(arg1_285, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_286, arg1_286)
	local var0_286 = arg0_286:GetComponent(typeof(Animator))
	local var1_286 = Animator.StringToHash(arg1_286)

	if var0_286:HasState(0, var1_286) then
		var0_286:Play(arg1_286, -1, 0)
	end
end

function quickPlayAnimation(arg0_287, arg1_287)
	arg0_287:GetComponent(typeof(Animation)):Play(arg1_287)
end

function getSurveyUrl(arg0_288)
	local var0_288 = pg.survey_data_template[arg0_288]
	local var1_288

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_288 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_288 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_288 = var0_288.main_url
				else
					var1_288 = var0_288.uo_url
				end
			elseif var2_288 == PLATFORM_IPHONEPLAYER then
				var1_288 = var0_288.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			var1_288 = var0_288.main_url
		end
	else
		var1_288 = var0_288.main_url
	end

	local var3_288 = getProxy(PlayerProxy):getRawData().id
	local var4_288 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_288
	local var6_288 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_288 = getProxy(UserProxy):getRawData()
	local var8_288 = getProxy(ServerProxy):getRawData()[var7_288 and var7_288.server or 0]
	local var9_288 = var8_288 and var8_288.id or ""
	local var10_288 = getProxy(PlayerProxy):getRawData().level
	local var11_288 = var3_288 .. "_" .. arg0_288
	local var12_288 = var1_288
	local var13_288 = {
		var3_288,
		var4_288,
		var6_288,
		var9_288,
		var10_288,
		var11_288
	}

	if var12_288 then
		for iter0_288, iter1_288 in ipairs(var13_288) do
			var12_288 = string.gsub(var12_288, "$" .. iter0_288, tostring(iter1_288))
		end
	end

	warning(var12_288)

	return var12_288
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

function FilterVarchar(arg0_290)
	assert(type(arg0_290) == "string" or type(arg0_290) == "table")

	if arg0_290 == "" then
		return nil
	end

	return arg0_290
end

function getGameset(arg0_291)
	local var0_291 = pg.gameset[arg0_291]

	assert(var0_291)

	return {
		var0_291.key_value,
		var0_291.description
	}
end

function getDorm3dGameset(arg0_292)
	local var0_292 = pg.dorm3d_set[arg0_292]

	assert(var0_292)

	return {
		var0_292.key_value_int,
		var0_292.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_293)
	arg0_293 = arg0_293 or {}

	local var0_293 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_293 > 0 do
		local var1_293 = table.remove(arg0_293)

		switch(var1_293.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_293:getConfig("open_directly") == 1 then
					for iter0_294, iter1_294 in ipairs(var1_293:getConfig("display_icon")) do
						local var0_294 = Drop.Create(iter1_294)

						var0_294.count = var0_294.count * var1_293.count

						table.insert(arg0_293, var0_294)
					end
				elseif var1_293:getSubClass():IsShipExpType() then
					var0_293[var1_293.type][var1_293.id] = defaultValue(var0_293[var1_293.type][var1_293.id], 0) + var1_293.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_293[var1_293.type][var1_293.id] = defaultValue(var0_293[var1_293.type][var1_293.id], 0) + var1_293.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_293[var1_293.type] = var0_293[var1_293.type] + var1_293.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_293[var1_293.type] = var0_293[var1_293.type] + var1_293.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_293[var1_293.type] = var0_293[var1_293.type] + var1_293.count
			end
		})
	end

	return var0_293
end

function CheckOverflow(arg0_299, arg1_299)
	local var0_299 = {}
	local var1_299 = arg0_299[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_299 = arg0_299[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_299 = arg0_299[DROP_TYPE_EQUIP]
	local var4_299 = arg0_299[DROP_TYPE_SHIP]
	local var5_299 = getProxy(PlayerProxy):getRawData()
	local var6_299 = false

	if arg1_299 then
		local var7_299 = var5_299:OverStore(PlayerConst.ResStoreGold, var1_299)
		local var8_299 = var5_299:OverStore(PlayerConst.ResStoreOil, var2_299)

		if var7_299 > 0 or var8_299 > 0 then
			var0_299.isStoreOverflow = {
				var7_299,
				var8_299
			}
		end
	else
		if var1_299 > 0 and var5_299:GoldMax(var1_299) then
			return false, "gold"
		end

		if var2_299 > 0 and var5_299:OilMax(var2_299) then
			return false, "oil"
		end
	end

	var0_299.isExpBookOverflow = {}

	for iter0_299, iter1_299 in pairs(arg0_299[DROP_TYPE_ITEM]) do
		local var9_299 = Item.getConfigData(iter0_299)

		if getProxy(BagProxy):getItemCountById(iter0_299) + iter1_299 > var9_299.max_num then
			table.insert(var0_299.isExpBookOverflow, iter0_299)
		end
	end

	local var10_299 = getProxy(EquipmentProxy):getCapacity()

	if var3_299 > 0 and var3_299 + var10_299 > var5_299:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_299 = getProxy(BayProxy):getShipCount()

	if var4_299 > 0 and var4_299 + var11_299 > var5_299:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_299
end

function CheckShipExpOverflow(arg0_300)
	local var0_300 = getProxy(BagProxy)

	for iter0_300, iter1_300 in pairs(arg0_300[DROP_TYPE_ITEM]) do
		if var0_300:getItemCountById(iter0_300) + iter1_300 > Item.getConfigData(iter0_300).max_num then
			return false
		end
	end

	return true
end

local var25_0 = {
	[17] = "item_type17_tip2",
	tech = "techpackage_item_use_confirm",
	[16] = "item_type16_tip2",
	[11] = "equip_skin_detail_tip",
	[13] = "item_type13_tip2"
}

function RegisterDetailButton(arg0_301, arg1_301, arg2_301)
	Drop.Change(arg2_301)
	switch(arg2_301.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_301:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_302 = Item.getConfigData(arg2_301.id).usage_arg
				local var1_302 = var0_302[3]

				if Item.InTimeLimitSkinAssigned(arg2_301.id) then
					var1_302 = table.mergeArray(var0_302[2], var1_302, true)
				end

				local var2_302 = {}

				for iter0_302, iter1_302 in ipairs(var0_302[2]) do
					var2_302[iter1_302] = true
				end

				onButton(arg0_301, arg1_301, function()
					arg0_301:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_301.id,
								selectableSkinList = underscore.map(var1_302, function(arg0_304)
									return SelectableSkin.New({
										id = arg0_304,
										isTimeLimit = var2_302[arg0_304] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_301, true)
			else
				local var3_302 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_301.id) and "tech" or arg2_301:getConfig("type")

				if var25_0[var3_302] then
					local var4_302 = {
						item2Row = true,
						content = i18n(var25_0[var3_302]),
						itemList = underscore.map(arg2_301:getConfig("display_icon"), function(arg0_305)
							return Drop.Create(arg0_305)
						end)
					}

					if var3_302 == 11 then
						onButton(arg0_301, arg1_301, function()
							arg0_301:emit(BaseUI.ON_DROP_LIST_OWN, var4_302)
						end, SFX_PANEL)
					else
						onButton(arg0_301, arg1_301, function()
							arg0_301:emit(BaseUI.ON_DROP_LIST, var4_302)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_301, tobool(var25_0[var3_302]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_301, arg1_301, function()
				arg0_301:emit(BaseUI.ON_DROP, arg2_301)
			end, SFX_PANEL)
			setActive(arg1_301, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_301, arg1_301, function()
				arg0_301:emit(BaseUI.ON_DROP, arg2_301)
			end, SFX_PANEL)
			setActive(arg1_301, true)
		end
	}, function()
		setActive(arg1_301, false)
	end)
end

function UpdateOwnDisplay(arg0_313, arg1_313)
	local var0_313, var1_313 = arg1_313:getOwnedCount()

	setActive(arg0_313, var1_313 and var0_313 > 0)

	if var1_313 and var0_313 > 0 then
		setText(arg0_313:Find("label"), i18n("word_own1"))
		setText(arg0_313:Find("Text"), var0_313)
	end
end

function Damp(arg0_314, arg1_314, arg2_314)
	arg1_314 = Mathf.Max(1, arg1_314)

	local var0_314 = Mathf.Epsilon

	if arg1_314 < var0_314 or var0_314 > Mathf.Abs(arg0_314) then
		return arg0_314
	end

	if arg2_314 < var0_314 then
		return 0
	end

	local var1_314 = -4.605170186

	return arg0_314 * (1 - Mathf.Exp(var1_314 * arg2_314 / arg1_314))
end

function checkCullResume(arg0_315)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_315, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_315 = arg0_315:GetComponentsInChildren(typeof(MeshImage))

		for iter0_315 = 1, var0_315.Length do
			var0_315[iter0_315 - 1]:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_316)
	local var0_316 = {}

	if arg0_316 and arg0_316 ~= "" then
		local var1_316 = base64.dec(arg0_316)

		var0_316 = string.split(var1_316, "/")
		var0_316[5], var0_316[6] = unpack(string.split(var0_316[5], "\\"))

		if #var0_316 < 6 or arg0_316 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_316, 5), "/"),
			var0_316[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_316 = {}
		end
	end

	for iter0_316 = 1, 6 do
		var0_316[iter0_316] = var0_316[iter0_316] and tonumber(var0_316[iter0_316], 32) or 0
	end

	return var0_316
end

function buildEquipCode(arg0_317)
	local var0_317 = underscore.map(arg0_317:getAllEquipments(), function(arg0_318)
		return ConversionBase(32, arg0_318 and arg0_318.id or 0)
	end)
	local var1_317 = {
		table.concat(var0_317, "/"),
		ConversionBase(32, checkExist(arg0_317:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_317, "\\"))
end

function setDirectorSpeed(arg0_319, arg1_319)
	GetComponent(arg0_319, "TimelineSpeed"):SetTimelineSpeed(arg1_319)
end

function setDefaultZeroMetatable(arg0_320)
	return setmetatable(arg0_320, {
		__index = function(arg0_321, arg1_321)
			if rawget(arg0_321, arg1_321) == nil then
				arg0_321[arg1_321] = 0
			end

			return arg0_321[arg1_321]
		end
	})
end

function checkABExist(arg0_322)
	if EDITOR_TOOL then
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_322)) or ResourceMgr.Inst:AssetExist(arg0_322)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_322))
	end
end
