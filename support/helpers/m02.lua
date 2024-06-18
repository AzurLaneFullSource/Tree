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
	local var0_32 = buildTempAB("emojis", false)
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

function numberFormat(arg0_42, arg1_42)
	local var0_42 = ""
	local var1_42 = tostring(arg0_42)
	local var2_42 = string.len(var1_42)

	if arg1_42 == nil then
		arg1_42 = ","
	end

	arg1_42 = tostring(arg1_42)

	for iter0_42 = 1, var2_42 do
		var0_42 = string.char(string.byte(var1_42, var2_42 + 1 - iter0_42)) .. var0_42

		if iter0_42 % 3 == 0 and var2_42 - iter0_42 ~= 0 then
			var0_42 = arg1_42 .. var0_42
		end
	end

	return var0_42
end

function usMoneyFormat(arg0_43, arg1_43)
	local var0_43 = arg0_43 % 100
	local var1_43 = math.floor(arg0_43 / 100)

	if var0_43 > 0 then
		var0_43 = var0_43 > 10 and var0_43 or "0" .. var0_43

		if var1_43 < 1 then
			return "0." .. var0_43
		else
			return numberFormat(var1_43, arg1_43) .. "." .. var0_43
		end
	else
		return numberFormat(var1_43, arg1_43)
	end
end

function checkPaintingPrefab(arg0_44, arg1_44, arg2_44, arg3_44, arg4_44)
	local var0_44 = findTF(arg0_44, "fitter")

	assert(var0_44, "请添加子物体fitter")
	removeAllChildren(var0_44)

	local var1_44 = GetOrAddComponent(var0_44, "PaintingScaler")

	var1_44.FrameName = arg2_44 or ""
	var1_44.Tween = 1

	local var2_44 = arg4_44 or "painting/"
	local var3_44 = arg1_44

	if not arg3_44 and checkABExist(var2_44 .. arg1_44 .. "_n") and PlayerPrefs.GetInt("paint_hide_other_obj_" .. arg1_44, 0) ~= 0 then
		arg1_44 = arg1_44 .. "_n"
	end

	return var0_44, arg1_44, var3_44
end

function onLoadedPaintingPrefab(arg0_45)
	local var0_45 = arg0_45.paintingTF
	local var1_45 = arg0_45.fitterTF
	local var2_45 = arg0_45.defaultPaintingName

	setParent(var0_45, var1_45, false)

	local var3_45 = findTF(var0_45, "Touch")

	if not IsNil(var3_45) then
		setActive(var3_45, false)
	end

	local var4_45 = findTF(var0_45, "hx")

	if not IsNil(var4_45) then
		setActive(var4_45, HXSet.isHx())
	end

	ShipExpressionHelper.SetExpression(var1_45:GetChild(0), var2_45)
end

function onLoadedPaintingPrefabAsync(arg0_46)
	local var0_46 = arg0_46.paintingTF
	local var1_46 = arg0_46.fitterTF
	local var2_46 = arg0_46.objectOrTransform
	local var3_46 = arg0_46.paintingName
	local var4_46 = arg0_46.defaultPaintingName
	local var5_46 = arg0_46.callback

	if IsNil(var2_46) or var2_0[var2_46] ~= var3_46 then
		PoolMgr.GetInstance():ReturnPainting(var3_46, var0_46)

		return
	else
		setParent(var0_46, var1_46, false)

		var2_0[var2_46] = nil

		ShipExpressionHelper.SetExpression(var0_46, var4_46)
	end

	local var6_46 = findTF(var0_46, "Touch")

	if not IsNil(var6_46) then
		setActive(var6_46, false)
	end

	local var7_46 = findTF(var0_46, "hx")

	if not IsNil(var7_46) then
		setActive(var7_46, HXSet.isHx())
	end

	if var5_46 then
		var5_46()
	end
end

function setCommanderPaintingPrefab(arg0_47, arg1_47, arg2_47, arg3_47)
	local var0_47, var1_47, var2_47 = checkPaintingPrefab(arg0_47, arg1_47, arg2_47, arg3_47)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_47, false, function(arg0_48)
		local var0_48 = {
			paintingTF = arg0_48,
			fitterTF = var0_47,
			defaultPaintingName = var2_47
		}

		onLoadedPaintingPrefab(var0_48)
	end, "commanderpainting/")
end

function setCommanderPaintingPrefabAsync(arg0_49, arg1_49, arg2_49, arg3_49, arg4_49)
	local var0_49, var1_49, var2_49 = checkPaintingPrefab(arg0_49, arg1_49, arg2_49, arg4_49)

	var2_0[arg0_49] = var1_49

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_49, true, function(arg0_50)
		local var0_50 = {
			paintingTF = arg0_50,
			fitterTF = var0_49,
			objectOrTransform = arg0_49,
			paintingName = var1_49,
			defaultPaintingName = var2_49,
			callback = arg3_49
		}

		onLoadedPaintingPrefabAsync(var0_50)
	end, "commanderpainting/")
end

function retCommanderPaintingPrefab(arg0_51, arg1_51)
	retPaintingPrefab(arg0_51, arg1_51, "commanderpainting/")
end

function setMetaPaintingPrefab(arg0_52, arg1_52, arg2_52, arg3_52)
	local var0_52, var1_52, var2_52 = checkPaintingPrefab(arg0_52, arg1_52, arg2_52, arg3_52)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_52, false, function(arg0_53)
		local var0_53 = {
			paintingTF = arg0_53,
			fitterTF = var0_52,
			defaultPaintingName = var2_52
		}

		onLoadedPaintingPrefab(var0_53)
	end, "metapainting/")
end

function setMetaPaintingPrefabAsync(arg0_54, arg1_54, arg2_54, arg3_54, arg4_54)
	local var0_54, var1_54, var2_54 = checkPaintingPrefab(arg0_54, arg1_54, arg2_54, arg4_54)

	var2_0[arg0_54] = var1_54

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_54, true, function(arg0_55)
		local var0_55 = {
			paintingTF = arg0_55,
			fitterTF = var0_54,
			objectOrTransform = arg0_54,
			paintingName = var1_54,
			defaultPaintingName = var2_54,
			callback = arg3_54
		}

		onLoadedPaintingPrefabAsync(var0_55)
	end, "metapainting/")
end

function retMetaPaintingPrefab(arg0_56, arg1_56)
	retPaintingPrefab(arg0_56, arg1_56, "metapainting/")
end

function setGuildPaintingPrefab(arg0_57, arg1_57, arg2_57, arg3_57)
	local var0_57, var1_57, var2_57 = checkPaintingPrefab(arg0_57, arg1_57, arg2_57, arg3_57)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_57, false, function(arg0_58)
		local var0_58 = {
			paintingTF = arg0_58,
			fitterTF = var0_57,
			defaultPaintingName = var2_57
		}

		onLoadedPaintingPrefab(var0_58)
	end, "guildpainting/")
end

function setGuildPaintingPrefabAsync(arg0_59, arg1_59, arg2_59, arg3_59, arg4_59)
	local var0_59, var1_59, var2_59 = checkPaintingPrefab(arg0_59, arg1_59, arg2_59, arg4_59)

	var2_0[arg0_59] = var1_59

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_59, true, function(arg0_60)
		local var0_60 = {
			paintingTF = arg0_60,
			fitterTF = var0_59,
			objectOrTransform = arg0_59,
			paintingName = var1_59,
			defaultPaintingName = var2_59,
			callback = arg3_59
		}

		onLoadedPaintingPrefabAsync(var0_60)
	end, "guildpainting/")
end

function retGuildPaintingPrefab(arg0_61, arg1_61)
	retPaintingPrefab(arg0_61, arg1_61, "guildpainting/")
end

function setShopPaintingPrefab(arg0_62, arg1_62, arg2_62, arg3_62)
	local var0_62, var1_62, var2_62 = checkPaintingPrefab(arg0_62, arg1_62, arg2_62, arg3_62)

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_62, false, function(arg0_63)
		local var0_63 = {
			paintingTF = arg0_63,
			fitterTF = var0_62,
			defaultPaintingName = var2_62
		}

		onLoadedPaintingPrefab(var0_63)
	end, "shoppainting/")
end

function retShopPaintingPrefab(arg0_64, arg1_64)
	retPaintingPrefab(arg0_64, arg1_64, "shoppainting/")
end

function setBuildPaintingPrefabAsync(arg0_65, arg1_65, arg2_65, arg3_65, arg4_65)
	local var0_65, var1_65, var2_65 = checkPaintingPrefab(arg0_65, arg1_65, arg2_65, arg4_65)

	var2_0[arg0_65] = var1_65

	PoolMgr.GetInstance():GetPaintingWithPrefix(var1_65, true, function(arg0_66)
		local var0_66 = {
			paintingTF = arg0_66,
			fitterTF = var0_65,
			objectOrTransform = arg0_65,
			paintingName = var1_65,
			defaultPaintingName = var2_65,
			callback = arg3_65
		}

		onLoadedPaintingPrefabAsync(var0_66)
	end, "buildpainting/")
end

function retBuildPaintingPrefab(arg0_67, arg1_67)
	retPaintingPrefab(arg0_67, arg1_67, "buildpainting/")
end

function setColorCount(arg0_68, arg1_68, arg2_68)
	setText(arg0_68, string.format(arg1_68 < arg2_68 and "<color=" .. COLOR_RED .. ">%d</color>/%d" or "%d/%d", arg1_68, arg2_68))
end

function setColorStr(arg0_69, arg1_69)
	return "<color=" .. arg1_69 .. ">" .. arg0_69 .. "</color>"
end

function setSizeStr(arg0_70, arg1_70)
	local var0_70, var1_70 = string.gsub(arg0_70, "[<]size=%d+[>]", "<size=" .. arg1_70 .. ">")

	if var1_70 == 0 then
		var0_70 = "<size=" .. arg1_70 .. ">" .. var0_70 .. "</size>"
	end

	return var0_70
end

function getBgm(arg0_71)
	local var0_71 = pg.voice_bgm[arg0_71]

	if pg.CriMgr.GetInstance():IsDefaultBGM() then
		return var0_71 and var0_71.default_bgm or nil
	elseif var0_71 then
		local var1_71 = var0_71.special_bgm
		local var2_71 = var0_71.time

		if var1_71 and type(var1_71) == "string" and #var1_71 > 0 and var2_71 and type(var2_71) == "table" then
			local var3_71 = var0_71.time
			local var4_71 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var3_71[1])
			local var5_71 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var3_71[2])
			local var6_71 = pg.TimeMgr.GetInstance():GetServerTime()

			if var4_71 <= var6_71 and var6_71 <= var5_71 then
				return var1_71
			else
				return var0_71.bgm
			end
		else
			return var0_71 and var0_71.bgm or nil
		end
	else
		return nil
	end
end

function playStory(arg0_72, arg1_72)
	pg.NewStoryMgr.GetInstance():Play(arg0_72, arg1_72)
end

function errorMessage(arg0_73)
	local var0_73 = ERROR_MESSAGE[arg0_73]

	if var0_73 == nil then
		var0_73 = ERROR_MESSAGE[9999] .. ":" .. arg0_73
	end

	return var0_73
end

function errorTip(arg0_74, arg1_74, ...)
	local var0_74 = pg.gametip[arg0_74 .. "_error"]
	local var1_74

	if var0_74 then
		var1_74 = var0_74.tip
	else
		var1_74 = pg.gametip.common_error.tip
	end

	local var2_74 = arg0_74 .. "_error_" .. arg1_74

	if pg.gametip[var2_74] then
		local var3_74 = i18n(var2_74, ...)

		return var1_74 .. var3_74
	else
		local var4_74 = "common_error_" .. arg1_74

		if pg.gametip[var4_74] then
			local var5_74 = i18n(var4_74, ...)

			return var1_74 .. var5_74
		else
			local var6_74 = errorMessage(arg1_74)

			return var1_74 .. arg1_74 .. ":" .. var6_74
		end
	end
end

function colorNumber(arg0_75, arg1_75)
	local var0_75 = "@COLOR_SCOPE"
	local var1_75 = {}

	arg0_75 = string.gsub(arg0_75, "<color=#%x+>", function(arg0_76)
		table.insert(var1_75, arg0_76)

		return var0_75
	end)
	arg0_75 = string.gsub(arg0_75, "%d+%.?%d*%%*", function(arg0_77)
		return "<color=" .. arg1_75 .. ">" .. arg0_77 .. "</color>"
	end)

	if #var1_75 > 0 then
		local var2_75 = 0

		return (string.gsub(arg0_75, var0_75, function(arg0_78)
			var2_75 = var2_75 + 1

			return var1_75[var2_75]
		end))
	else
		return arg0_75
	end
end

function getBounds(arg0_79)
	local var0_79 = LuaHelper.GetWorldCorners(rtf(arg0_79))
	local var1_79 = Bounds.New(var0_79[0], Vector3.zero)

	var1_79:Encapsulate(var0_79[2])

	return var1_79
end

local function var3_0(arg0_80, arg1_80)
	arg0_80.localScale = Vector3.one
	arg0_80.anchorMin = Vector2.zero
	arg0_80.anchorMax = Vector2.one
	arg0_80.offsetMin = Vector2(arg1_80[1], arg1_80[2])
	arg0_80.offsetMax = Vector2(-arg1_80[3], -arg1_80[4])
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
	other = {
		-2.5,
		-4.5,
		-3,
		-4.5
	}
}

function setFrame(arg0_81, arg1_81, arg2_81)
	arg1_81 = tostring(arg1_81)

	local var0_81, var1_81 = unpack((string.split(arg1_81, "_")))

	if var1_81 or tonumber(var0_81) > 5 then
		arg2_81 = arg2_81 or "frame" .. arg1_81
	end

	GetImageSpriteFromAtlasAsync("weaponframes", "frame", arg0_81)

	local var2_81 = arg2_81 and Color.white or Color.NewHex(ItemRarity.Rarity2FrameHexColor(var0_81 and tonumber(var0_81) or ItemRarity.Gray))

	setImageColor(arg0_81, var2_81)

	local var3_81 = findTF(arg0_81, "specialFrame")

	if arg2_81 then
		if var3_81 then
			setActive(var3_81, true)
		else
			var3_81 = cloneTplTo(arg0_81, arg0_81, "specialFrame")

			removeAllChildren(var3_81)
		end

		var3_0(var3_81, var4_0[arg2_81] or var4_0.other)
		GetImageSpriteFromAtlasAsync("weaponframes", arg2_81, var3_81)
	elseif var3_81 then
		setActive(var3_81, false)
	end
end

function setIconColorful(arg0_82, arg1_82, arg2_82, arg3_82)
	arg3_82 = arg3_82 or {
		[ItemRarity.SSR] = {
			name = "IconColorful",
			active = function(arg0_83, arg1_83)
				return not arg1_83.noIconColorful and arg0_83 == ItemRarity.SSR
			end
		}
	}

	local var0_82 = findTF(arg0_82, "icon_bg/frame")

	for iter0_82, iter1_82 in pairs(arg3_82) do
		local var1_82 = iter1_82.name
		local var2_82 = iter1_82.active(arg1_82, arg2_82)
		local var3_82 = var0_82:Find(var1_82 .. "(Clone)")

		if var3_82 then
			setActive(var3_82, var2_82)
		elseif var2_82 then
			LoadAndInstantiateAsync("ui", string.lower(var1_82), function(arg0_84)
				if IsNil(arg0_82) or var0_82:Find(var1_82 .. "(Clone)") then
					Object.Destroy(arg0_84)
				else
					setParent(arg0_84, var0_82)
					setActive(arg0_84, var2_82)
				end
			end)
		end
	end
end

function setIconStars(arg0_85, arg1_85, arg2_85)
	local var0_85 = findTF(arg0_85, "icon_bg/startpl")
	local var1_85 = findTF(arg0_85, "icon_bg/stars")

	if var1_85 and var0_85 then
		setActive(var1_85, false)
		setActive(var0_85, false)
	end

	if not var1_85 or not arg1_85 then
		return
	end

	for iter0_85 = 1, math.max(arg2_85, var1_85.childCount) do
		setActive(iter0_85 > var1_85.childCount and cloneTplTo(var0_85, var1_85) or var1_85:GetChild(iter0_85 - 1), iter0_85 <= arg2_85)
	end

	setActive(var1_85, true)
end

local function var5_0(arg0_86, arg1_86)
	local var0_86 = findTF(arg0_86, "icon_bg/slv")

	if not IsNil(var0_86) then
		setActive(var0_86, arg1_86 > 0)
		setText(findTF(var0_86, "Text"), arg1_86)
	end
end

function setIconName(arg0_87, arg1_87, arg2_87)
	local var0_87 = findTF(arg0_87, "name")

	if not IsNil(var0_87) then
		setText(var0_87, arg1_87)
		setTextAlpha(var0_87, (arg2_87.hideName or arg2_87.anonymous) and 0 or 1)
	end
end

function setIconCount(arg0_88, arg1_88)
	local var0_88 = findTF(arg0_88, "icon_bg/count")

	if not IsNil(var0_88) then
		setText(var0_88, arg1_88 and (type(arg1_88) ~= "number" or arg1_88 > 0) and arg1_88 or "")
	end
end

function updateEquipment(arg0_89, arg1_89, arg2_89)
	arg2_89 = arg2_89 or {}

	assert(arg1_89, "equipmentVo can not be nil.")

	local var0_89 = EquipmentRarity.Rarity2Print(arg1_89:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_89, findTF(arg0_89, "icon_bg"))
	setFrame(findTF(arg0_89, "icon_bg/frame"), var0_89)

	local var1_89 = findTF(arg0_89, "icon_bg/icon")

	var3_0(var1_89, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync("equips/" .. arg1_89:getConfig("icon"), "", var1_89)
	setIconStars(arg0_89, true, arg1_89:getConfig("rarity"))
	var5_0(arg0_89, arg1_89:getConfig("level") - 1)
	setIconName(arg0_89, arg1_89:getConfig("name"), arg2_89)
	setIconCount(arg0_89, arg1_89.count)
	setIconColorful(arg0_89, arg1_89:getConfig("rarity") - 1, arg2_89)
end

function updateItem(arg0_90, arg1_90, arg2_90)
	arg2_90 = arg2_90 or {}

	local var0_90 = ItemRarity.Rarity2Print(arg1_90:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_90, findTF(arg0_90, "icon_bg"))

	local var1_90

	if arg1_90:getConfig("type") == 9 then
		var1_90 = "frame_design"
	elseif arg2_90.frame then
		var1_90 = arg2_90.frame
	end

	setFrame(findTF(arg0_90, "icon_bg/frame"), var0_90, var1_90)

	local var2_90 = findTF(arg0_90, "icon_bg/icon")
	local var3_90 = arg1_90.icon or arg1_90:getConfig("icon")

	if arg1_90:getConfig("type") == Item.LOVE_LETTER_TYPE then
		assert(arg1_90.extra, "without extra data")

		var3_90 = "SquareIcon/" .. ShipGroup.getDefaultSkin(arg1_90.extra).prefab
	end

	GetImageSpriteFromAtlasAsync(var3_90, "", var2_90)
	setIconStars(arg0_90, false)
	setIconName(arg0_90, arg1_90:getName(), arg2_90)
	setIconColorful(arg0_90, arg1_90:getConfig("rarity"), arg2_90)
end

function updateWorldItem(arg0_91, arg1_91, arg2_91)
	arg2_91 = arg2_91 or {}

	local var0_91 = ItemRarity.Rarity2Print(arg1_91:getConfig("rarity"))

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_91, findTF(arg0_91, "icon_bg"))
	setFrame(findTF(arg0_91, "icon_bg/frame"), var0_91)

	local var1_91 = findTF(arg0_91, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync(arg1_91.icon or arg1_91:getConfig("icon"), "", var1_91)
	setIconStars(arg0_91, false)
	setIconName(arg0_91, arg1_91:getConfig("name"), arg2_91)
	setIconColorful(arg0_91, arg1_91:getConfig("rarity"), arg2_91)
end

function updateWorldCollection(arg0_92, arg1_92, arg2_92)
	arg2_92 = arg2_92 or {}

	assert(arg1_92:getConfigTable(), "world_collection_file_template 和 world_collection_record_template 表中找不到配置: " .. arg1_92.id)

	local var0_92 = arg1_92:getDropRarity()
	local var1_92 = ItemRarity.Rarity2Print(var0_92)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_92, findTF(arg0_92, "icon_bg"))
	setFrame(findTF(arg0_92, "icon_bg/frame"), var1_92)

	local var2_92 = findTF(arg0_92, "icon_bg/icon")
	local var3_92 = WorldCollectionProxy.GetCollectionType(arg1_92.id) == WorldCollectionProxy.WorldCollectionType.FILE and "shoucangguangdie" or "shoucangjiaojuan"

	GetImageSpriteFromAtlasAsync("props/" .. var3_92, "", var2_92)
	setIconStars(arg0_92, false)
	setIconName(arg0_92, arg1_92:getName(), arg2_92)
	setIconColorful(arg0_92, var0_92, arg2_92)
end

function updateWorldBuff(arg0_93, arg1_93, arg2_93)
	arg2_93 = arg2_93 or {}

	local var0_93 = pg.world_SLGbuff_data[arg1_93]

	assert(var0_93, "找不到大世界buff配置: " .. arg1_93)

	local var1_93 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_93, findTF(arg0_93, "icon_bg"))
	setFrame(findTF(arg0_93, "icon_bg/frame"), var1_93)

	local var2_93 = findTF(arg0_93, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("world/buff/" .. var0_93.icon, "", var2_93)

	local var3_93 = arg0_93:Find("icon_bg/stars")

	if not IsNil(var3_93) then
		setActive(var3_93, false)
	end

	local var4_93 = findTF(arg0_93, "name")

	if not IsNil(var4_93) then
		setText(var4_93, var0_93.name)
	end

	local var5_93 = findTF(arg0_93, "icon_bg/count")

	if not IsNil(var5_93) then
		SetActive(var5_93, false)
	end
end

function updateShip(arg0_94, arg1_94, arg2_94)
	arg2_94 = arg2_94 or {}

	local var0_94 = arg1_94:rarity2bgPrint()
	local var1_94 = arg1_94:getPainting()

	if arg2_94.anonymous then
		var0_94 = "1"
		var1_94 = "unknown"
	end

	if arg2_94.unknown_small then
		var1_94 = "unknown_small"
	end

	local var2_94 = findTF(arg0_94, "icon_bg/new")

	if var2_94 then
		if arg2_94.isSkin then
			setActive(var2_94, not arg2_94.isTimeLimit and arg2_94.isNew)
		else
			setActive(var2_94, arg1_94.virgin)
		end
	end

	local var3_94 = findTF(arg0_94, "icon_bg/timelimit")

	if var3_94 then
		setActive(var3_94, arg2_94.isTimeLimit)
	end

	local var4_94 = findTF(arg0_94, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_94.isSkin and "_skin" or var0_94), var4_94)

	local var5_94 = findTF(arg0_94, "icon_bg/frame")
	local var6_94

	if arg1_94.isNpc then
		var6_94 = "frame_npc"
	elseif arg1_94:ShowPropose() then
		var6_94 = "frame_prop"

		if arg1_94:isMetaShip() then
			var6_94 = var6_94 .. "_meta"
		end
	elseif arg2_94.isSkin then
		var6_94 = "frame_skin"
	end

	setFrame(var5_94, var0_94, var6_94)

	if arg2_94.gray then
		setGray(var4_94, true, true)
	end

	local var7_94 = findTF(arg0_94, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg2_94.Q and "QIcon/" or "SquareIcon/") .. var1_94, "", var7_94)

	local var8_94 = findTF(arg0_94, "icon_bg/lv")

	if var8_94 then
		setActive(var8_94, not arg1_94.isNpc)

		if not arg1_94.isNpc then
			local var9_94 = findTF(var8_94, "Text")

			if var9_94 and arg1_94.level then
				setText(var9_94, arg1_94.level)
			end
		end
	end

	local var10_94 = findTF(arg0_94, "ship_type")

	if var10_94 then
		setActive(var10_94, true)
		setImageSprite(var10_94, GetSpriteFromAtlas("shiptype", shipType2print(arg1_94:getShipType())))
	end

	local var11_94 = var4_94:Find("npc")

	if not IsNil(var11_94) then
		if var2_94 and go(var2_94).activeSelf then
			setActive(var11_94, false)
		else
			setActive(var11_94, arg1_94:isActivityNpc())
		end
	end

	local var12_94 = arg0_94:Find("group_locked")

	if var12_94 then
		setActive(var12_94, not arg2_94.isSkin and not getProxy(CollectionProxy):getShipGroup(arg1_94.groupId))
	end

	setIconStars(arg0_94, arg2_94.initStar, arg1_94:getStar())
	setIconName(arg0_94, arg2_94.isSkin and arg1_94:GetSkinConfig().name or arg1_94:getName(), arg2_94)
	setIconColorful(arg0_94, arg2_94.isSkin and ItemRarity.Gold or arg1_94:getRarity() - 1, arg2_94)
end

function updateCommander(arg0_95, arg1_95, arg2_95)
	arg2_95 = arg2_95 or {}

	local var0_95 = arg1_95:getDropRarity()
	local var1_95 = ShipRarity.Rarity2Print(var0_95)
	local var2_95 = arg1_95:getConfig("painting")

	if arg2_95.anonymous then
		var1_95 = 1
		var2_95 = "unknown"
	end

	local var3_95 = findTF(arg0_95, "icon_bg")

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. (arg2_95.isSkin and "-skin" or var1_95), var3_95)

	local var4_95 = findTF(arg0_95, "icon_bg/frame")

	setFrame(var4_95, var1_95)

	if arg2_95.gray then
		setGray(var3_95, true, true)
	end

	local var5_95 = findTF(arg0_95, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("CommanderIcon/" .. var2_95, "", var5_95)
	setIconStars(arg0_95, arg2_95.initStar, 0)
	setIconName(arg0_95, arg1_95:getName(), arg2_95)
end

function updateStrategy(arg0_96, arg1_96, arg2_96)
	arg2_96 = arg2_96 or {}

	local var0_96 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_96, findTF(arg0_96, "icon_bg"))
	setFrame(findTF(arg0_96, "icon_bg/frame"), var0_96)

	local var1_96 = findTF(arg0_96, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync((arg1_96.isWorldBuff and "world/buff/" or "strategyicon/") .. arg1_96:getIcon(), "", var1_96)
	setIconStars(arg0_96, false)
	setIconName(arg0_96, arg1_96:getName(), arg2_96)
	setIconColorful(arg0_96, ItemRarity.Gray, arg2_96)
end

function updateFurniture(arg0_97, arg1_97, arg2_97)
	arg2_97 = arg2_97 or {}

	local var0_97 = arg1_97:getDropRarity()
	local var1_97 = ItemRarity.Rarity2Print(var0_97)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_97, findTF(arg0_97, "icon_bg"))
	setFrame(findTF(arg0_97, "icon_bg/frame"), var1_97)

	local var2_97 = findTF(arg0_97, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_97:getIcon(), "", var2_97)
	setIconStars(arg0_97, false)
	setIconName(arg0_97, arg1_97:getName(), arg2_97)
	setIconColorful(arg0_97, var0_97, arg2_97)
end

function updateSpWeapon(arg0_98, arg1_98, arg2_98)
	arg2_98 = arg2_98 or {}

	assert(arg1_98, "spWeaponVO can not be nil.")
	assert(isa(arg1_98, SpWeapon), "spWeaponVO is not Equipment.")

	local var0_98 = ItemRarity.Rarity2Print(arg1_98:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_98, findTF(arg0_98, "icon_bg"))
	setFrame(findTF(arg0_98, "icon_bg/frame"), var0_98)

	local var1_98 = findTF(arg0_98, "icon_bg/icon")

	var3_0(var1_98, {
		16,
		16,
		16,
		16
	})
	GetImageSpriteFromAtlasAsync(arg1_98:GetIconPath(), "", var1_98)
	setIconStars(arg0_98, true, arg1_98:GetRarity())
	var5_0(arg0_98, arg1_98:GetLevel() - 1)
	setIconName(arg0_98, arg1_98:GetName(), arg2_98)
	setIconCount(arg0_98, arg1_98.count)
	setIconColorful(arg0_98, arg1_98:GetRarity(), arg2_98)
end

function UpdateSpWeaponSlot(arg0_99, arg1_99, arg2_99)
	local var0_99 = ItemRarity.Rarity2Print(arg1_99:GetRarity())

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_99, findTF(arg0_99, "Icon/Mask/icon_bg"))

	local var1_99 = findTF(arg0_99, "Icon/Mask/icon_bg/icon")

	arg2_99 = arg2_99 or {
		16,
		16,
		16,
		16
	}

	var3_0(var1_99, arg2_99)
	GetImageSpriteFromAtlasAsync(arg1_99:GetIconPath(), "", var1_99)

	local var2_99 = arg1_99:GetLevel() - 1
	local var3_99 = findTF(arg0_99, "Icon/LV")

	setActive(var3_99, var2_99 > 0)
	setText(findTF(var3_99, "Text"), var2_99)
end

function updateDorm3dFurniture(arg0_100, arg1_100, arg2_100)
	arg2_100 = arg2_100 or {}

	local var0_100 = arg1_100:getDropRarity()
	local var1_100 = ItemRarity.Rarity2Print(var0_100)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_100, findTF(arg0_100, "icon_bg"))
	setFrame(findTF(arg0_100, "icon_bg/frame"), var1_100)

	local var2_100 = findTF(arg0_100, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_100:getIcon(), "", var2_100)
	setIconStars(arg0_100, false)
	setIconName(arg0_100, arg1_100:getName(), arg2_100)
	setIconColorful(arg0_100, var0_100, arg2_100)
end

function updateDorm3dGift(arg0_101, arg1_101, arg2_101)
	arg2_101 = arg2_101 or {}

	local var0_101 = arg1_101:getDropRarity()
	local var1_101 = ItemRarity.Rarity2Print(var0_101) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_101, arg0_101:Find("icon_bg"))
	setFrame(arg0_101:Find("icon_bg/frame"), var1_101)

	local var2_101 = arg0_101:Find("icon_bg/icon")

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_101:getIcon(), "", var2_101)
	setIconStars(arg0_101, false)
	setIconName(arg0_101, arg1_101:getName(), arg2_101)
	setIconColorful(arg0_101, var0_101, arg2_101)
end

function updateDorm3dSkin(arg0_102, arg1_102, arg2_102)
	arg2_102 = arg2_102 or {}

	local var0_102 = arg1_102:getDropRarity()
	local var1_102 = ItemRarity.Rarity2Print(var0_102) or ItemRarity.Gray

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_102, arg0_102:Find("icon_bg"))
	setFrame(arg0_102:Find("icon_bg/frame"), var1_102)

	local var2_102 = arg0_102:Find("icon_bg/icon")

	setIconStars(arg0_102, false)
	setIconName(arg0_102, arg1_102:getName(), arg2_102)
	setIconColorful(arg0_102, var0_102, arg2_102)
end

function updateDorm3dIcon(arg0_103, arg1_103)
	local var0_103 = arg1_103:getConfig("rarity")

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_103), arg0_103)

	local var1_103 = arg0_103:Find("icon")

	setText(arg0_103:Find("count/Text"), "x" .. arg1_103.count)
	setText(arg0_103:Find("name/Text"), arg1_103:getName())
end

local var6_0

function findCullAndClipWorldRect(arg0_104)
	if #arg0_104 == 0 then
		return false
	end

	local var0_104 = arg0_104[1].canvasRect

	for iter0_104 = 1, #arg0_104 do
		var0_104 = rectIntersect(var0_104, arg0_104[iter0_104].canvasRect)
	end

	if var0_104.width <= 0 or var0_104.height <= 0 then
		return false
	end

	var6_0 = var6_0 or GameObject.Find("UICamera/Canvas").transform

	local var1_104 = var6_0:TransformPoint(Vector3(var0_104.x, var0_104.y, 0))
	local var2_104 = var6_0:TransformPoint(Vector3(var0_104.x + var0_104.width, var0_104.y + var0_104.height, 0))

	return true, Vector4(var1_104.x, var1_104.y, var2_104.x, var2_104.y)
end

function rectIntersect(arg0_105, arg1_105)
	local var0_105 = math.max(arg0_105.x, arg1_105.x)
	local var1_105 = math.min(arg0_105.x + arg0_105.width, arg1_105.x + arg1_105.width)
	local var2_105 = math.max(arg0_105.y, arg1_105.y)
	local var3_105 = math.min(arg0_105.y + arg0_105.height, arg1_105.y + arg1_105.height)

	if var0_105 <= var1_105 and var2_105 <= var3_105 then
		return var0_0.Rect.New(var0_105, var2_105, var1_105 - var0_105, var3_105 - var2_105)
	end

	return var0_0.Rect.New(0, 0, 0, 0)
end

function getDropInfo(arg0_106)
	local var0_106 = {}

	for iter0_106, iter1_106 in ipairs(arg0_106) do
		local var1_106 = Drop.Create(iter1_106)

		var1_106.count = var1_106.count or 1

		if var1_106.type == DROP_TYPE_EMOJI then
			table.insert(var0_106, var1_106:getName())
		else
			table.insert(var0_106, var1_106:getName() .. "x" .. var1_106.count)
		end
	end

	return table.concat(var0_106, "、")
end

function updateDrop(arg0_107, arg1_107, arg2_107)
	Drop.Change(arg1_107)

	arg2_107 = arg2_107 or {}

	local var0_107 = {
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
	local var1_107

	for iter0_107, iter1_107 in ipairs(var0_107) do
		local var2_107 = arg0_107:Find(iter1_107[1])

		if arg1_107.type ~= iter1_107[2] and not IsNil(var2_107) then
			setActive(var2_107, false)
		end
	end

	arg0_107:Find("icon_bg/frame"):GetComponent(typeof(Image)).enabled = true

	setIconColorful(arg0_107, arg1_107:getDropRarity(), arg2_107, {
		[ItemRarity.Gold] = {
			name = "Item_duang5",
			active = function(arg0_108, arg1_108)
				return arg1_108.fromAwardLayer and arg0_108 >= ItemRarity.Gold
			end
		}
	})
	var3_0(findTF(arg0_107, "icon_bg/icon"), {
		2,
		2,
		2,
		2
	})
	arg1_107:UpdateDropTpl(arg0_107, arg2_107)
	setIconCount(arg0_107, arg2_107.count or arg1_107:getCount())
end

function updateBuff(arg0_109, arg1_109, arg2_109)
	arg2_109 = arg2_109 or {}

	local var0_109 = ItemRarity.Rarity2Print(ItemRarity.Gray)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_109, findTF(arg0_109, "icon_bg"))

	local var1_109 = pg.benefit_buff_template[arg1_109]

	setFrame(findTF(arg0_109, "icon_bg/frame"), var0_109)
	setText(findTF(arg0_109, "icon_bg/count"), 1)

	local var2_109 = findTF(arg0_109, "icon_bg/icon")
	local var3_109 = var1_109.icon

	GetImageSpriteFromAtlasAsync(var3_109, "", var2_109)
	setIconStars(arg0_109, false)
	setIconName(arg0_109, var1_109.name, arg2_109)
	setIconColorful(arg0_109, ItemRarity.Gold, arg2_109)
end

function updateAttire(arg0_110, arg1_110, arg2_110, arg3_110)
	local var0_110 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_110, findTF(arg0_110, "icon_bg"))
	setFrame(findTF(arg0_110, "icon_bg/frame"), var0_110)

	local var1_110 = findTF(arg0_110, "icon_bg/icon")
	local var2_110

	if arg1_110 == AttireConst.TYPE_CHAT_FRAME then
		var2_110 = "chat_frame"
	elseif arg1_110 == AttireConst.TYPE_ICON_FRAME then
		var2_110 = "icon_frame"
	end

	GetImageSpriteFromAtlasAsync("Props/" .. var2_110, "", var1_110)
	setIconName(arg0_110, arg2_110.name, arg3_110)
end

function updateEmoji(arg0_111, arg1_111, arg2_111)
	local var0_111 = findTF(arg0_111, "icon_bg/icon")
	local var1_111 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_111, "", var0_111)

	local var2_111 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_111, findTF(arg0_111, "icon_bg"))
	setFrame(findTF(arg0_111, "icon_bg/frame"), var2_111)
	setIconName(arg0_111, arg1_111.name, arg2_111)
end

function updateEquipmentSkin(arg0_112, arg1_112, arg2_112)
	arg2_112 = arg2_112 or {}

	local var0_112 = EquipmentRarity.Rarity2Print(arg1_112.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_112, findTF(arg0_112, "icon_bg"))
	setFrame(findTF(arg0_112, "icon_bg/frame"), var0_112, "frame_skin")

	local var1_112 = findTF(arg0_112, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_112.icon, "", var1_112)
	setIconStars(arg0_112, false)
	setIconName(arg0_112, arg1_112.name, arg2_112)
	setIconCount(arg0_112, arg1_112.count)
	setIconColorful(arg0_112, arg1_112.rarity - 1, arg2_112)
end

function NoPosMsgBox(arg0_113, arg1_113, arg2_113, arg3_113)
	local var0_113
	local var1_113 = {}

	if arg1_113 then
		table.insert(var1_113, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_113
		})
	end

	if arg2_113 then
		table.insert(var1_113, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_113
		})
	end

	if arg3_113 then
		table.insert(var1_113, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_113
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_113,
		custom = var1_113,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_114 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_114 and var0_114.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_114
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
		local var0_115 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_115 and var0_115.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_115
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
		onClick = function(arg0_118, arg1_118)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_118.id,
				shipVOs = arg1_118
			})
		end
	})
end

function GoShoppingMsgBox(arg0_119, arg1_119, arg2_119)
	if arg2_119 then
		local var0_119 = ""

		for iter0_119, iter1_119 in ipairs(arg2_119) do
			local var1_119 = Item.getConfigData(iter1_119[1])

			var0_119 = var0_119 .. i18n(iter1_119[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_119.name, iter1_119[2])

			if iter0_119 < #arg2_119 then
				var0_119 = var0_119 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_119 ~= "" then
			arg0_119 = arg0_119 .. "\n" .. i18n("text_noRes_tip", var0_119)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_119,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_119, arg2_119)
		end
	})
end

function shoppingBatch(arg0_121, arg1_121, arg2_121, arg3_121, arg4_121)
	local var0_121 = pg.shop_template[arg0_121]

	assert(var0_121, "shop_template中找不到商品id：" .. arg0_121)

	local var1_121 = getProxy(PlayerProxy):getData()[id2res(var0_121.resource_type)]
	local var2_121 = arg1_121.price or var0_121.resource_num
	local var3_121 = math.floor(var1_121 / var2_121)

	var3_121 = var3_121 <= 0 and 1 or var3_121
	var3_121 = arg2_121 ~= nil and arg2_121 < var3_121 and arg2_121 or var3_121

	local var4_121 = true
	local var5_121 = 1

	if var0_121 ~= nil and arg1_121.id then
		print(var3_121 * var0_121.num, "--", var3_121)
		assert(Item.getConfigData(arg1_121.id), "item config should be existence")

		local var6_121 = Item.New({
			id = arg1_121.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_121.id
			},
			addNum = var0_121.num,
			maxNum = var3_121 * var0_121.num,
			defaultNum = var0_121.num,
			numUpdate = function(arg0_122, arg1_122)
				var5_121 = math.floor(arg1_122 / var0_121.num)

				local var0_122 = var5_121 * var2_121

				if var0_122 > var1_121 then
					setText(arg0_122, i18n(arg3_121, var0_122, arg1_122, COLOR_RED, var6_121))

					var4_121 = false
				else
					setText(arg0_122, i18n(arg3_121, var0_122, arg1_122, COLOR_GREEN, var6_121))

					var4_121 = true
				end
			end,
			onYes = function()
				if var4_121 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_121,
						count = var5_121
					})
				elseif arg4_121 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_121))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function gotoChargeScene(arg0_124, arg1_124)
	local var0_124 = getProxy(ContextProxy)
	local var1_124 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_124.mediator, ChargeMediator) then
		var1_124.mediator:getViewComponent():switchSubViewByTogger(arg0_124)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_124 or ChargeScene.TYPE_ITEM,
			noRes = arg1_124
		})
	end
end

function clearDrop(arg0_125)
	local var0_125 = findTF(arg0_125, "icon_bg")
	local var1_125 = findTF(arg0_125, "icon_bg/frame")
	local var2_125 = findTF(arg0_125, "icon_bg/icon")
	local var3_125 = findTF(arg0_125, "icon_bg/icon/icon")

	clearImageSprite(var0_125)
	clearImageSprite(var1_125)
	clearImageSprite(var2_125)

	if var3_125 then
		clearImageSprite(var3_125)
	end
end

local var7_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_126, arg1_126, arg2_126, arg3_126)
	local var0_126 = findTF(arg0_126, "skill")
	local var1_126 = findTF(arg0_126, "lock")
	local var2_126 = findTF(arg0_126, "unknown")

	if arg1_126 then
		setActive(var0_126, true)
		setActive(var2_126, false)
		setActive(var1_126, not arg2_126)
		LoadImageSpriteAsync("skillicon/" .. arg1_126.icon, findTF(var0_126, "icon"))

		local var3_126 = arg1_126.color or "blue"

		setText(findTF(var0_126, "name"), shortenString(getSkillName(arg1_126.id), arg3_126 or 8))

		local var4_126 = findTF(var0_126, "level")

		setText(var4_126, "LEVEL: " .. (arg2_126 and arg2_126.level or "??"))
		setTextColor(var4_126, var7_0[var3_126])
	else
		setActive(var0_126, false)
		setActive(var2_126, true)
		setActive(var1_126, false)
	end
end

local var8_0 = true

function onBackButton(arg0_127, arg1_127, arg2_127, arg3_127)
	local var0_127 = GetOrAddComponent(arg1_127, "UILongPressTrigger")

	assert(arg2_127, "callback should exist")

	var0_127.longPressThreshold = defaultValue(arg3_127, 1)

	local function var1_127(arg0_128)
		return function()
			if var8_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_129, var1_129 = arg2_127()

			if var0_129 then
				arg0_128(var1_129)
			end
		end
	end

	local var2_127 = var0_127.onReleased

	pg.DelegateInfo.Add(arg0_127, var2_127)
	var2_127:RemoveAllListeners()
	var2_127:AddListener(var1_127(function(arg0_130)
		arg0_130:emit(BaseUI.ON_BACK)
	end))

	local var3_127 = var0_127.onLongPressed

	pg.DelegateInfo.Add(arg0_127, var3_127)
	var3_127:RemoveAllListeners()
	var3_127:AddListener(var1_127(function(arg0_131)
		arg0_131:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_134)
	local var0_134 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_134, var2_134 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_134)

	return var1_134 * 86400 + (var2_134 + arg0_134) * 3600
end

function GetPerceptualSize(arg0_135)
	local function var0_135(arg0_136)
		if not arg0_136 then
			return 0, 1
		elseif arg0_136 > 240 then
			return 4, 1
		elseif arg0_136 > 225 then
			return 3, 1
		elseif arg0_136 > 192 then
			return 2, 1
		elseif arg0_136 < 126 then
			return 1, 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_135) == "number" then
		return var0_135(arg0_135)
	end

	local var1_135 = 1
	local var2_135 = 0
	local var3_135 = 0
	local var4_135 = #arg0_135

	while var1_135 <= var4_135 do
		local var5_135 = string.byte(arg0_135, var1_135)
		local var6_135, var7_135 = var0_135(var5_135)

		var1_135 = var1_135 + var6_135
		var2_135 = var2_135 + var7_135
	end

	return var2_135
end

function shortenString(arg0_137, arg1_137)
	local var0_137 = 1
	local var1_137 = 0
	local var2_137 = 0
	local var3_137 = #arg0_137

	while var0_137 <= var3_137 do
		local var4_137 = string.byte(arg0_137, var0_137)
		local var5_137, var6_137 = GetPerceptualSize(var4_137)

		var0_137 = var0_137 + var5_137
		var1_137 = var1_137 + var6_137

		if arg1_137 <= math.ceil(var1_137) then
			var2_137 = var0_137

			break
		end
	end

	if var2_137 == 0 or var3_137 < var2_137 then
		return arg0_137
	end

	return string.sub(arg0_137, 1, var2_137 - 1) .. ".."
end

function shouldShortenString(arg0_138, arg1_138)
	local var0_138 = 1
	local var1_138 = 0
	local var2_138 = 0
	local var3_138 = #arg0_138

	while var0_138 <= var3_138 do
		local var4_138 = string.byte(arg0_138, var0_138)
		local var5_138, var6_138 = GetPerceptualSize(var4_138)

		var0_138 = var0_138 + var5_138
		var1_138 = var1_138 + var6_138

		if arg1_138 <= math.ceil(var1_138) then
			var2_138 = var0_138

			break
		end
	end

	if var2_138 == 0 or var3_138 < var2_138 then
		return false
	end

	return true
end

function nameValidityCheck(arg0_139, arg1_139, arg2_139, arg3_139)
	local var0_139 = true
	local var1_139, var2_139 = utf8_to_unicode(arg0_139)
	local var3_139 = filterEgyUnicode(filterSpecChars(arg0_139))
	local var4_139 = wordVer(arg0_139)

	if not checkSpaceValid(arg0_139) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_139[1]))

		var0_139 = false
	elseif var4_139 > 0 or var3_139 ~= arg0_139 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_139[4]))

		var0_139 = false
	elseif var2_139 < arg1_139 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_139[2]))

		var0_139 = false
	elseif arg2_139 < var2_139 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_139[3]))

		var0_139 = false
	end

	return var0_139
end

function checkSpaceValid(arg0_140)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_140 = string.gsub(arg0_140, " ", "")

	return arg0_140 == string.gsub(var0_140, "　", "")
end

function filterSpecChars(arg0_141)
	local var0_141 = {}
	local var1_141 = 0
	local var2_141 = 0
	local var3_141 = 0
	local var4_141 = 1

	while var4_141 <= #arg0_141 do
		local var5_141 = string.byte(arg0_141, var4_141)

		if not var5_141 then
			break
		end

		if var5_141 >= 48 and var5_141 <= 57 or var5_141 >= 65 and var5_141 <= 90 or var5_141 == 95 or var5_141 >= 97 and var5_141 <= 122 then
			table.insert(var0_141, string.char(var5_141))
		elseif var5_141 >= 228 and var5_141 <= 233 then
			local var6_141 = string.byte(arg0_141, var4_141 + 1)
			local var7_141 = string.byte(arg0_141, var4_141 + 2)

			if var6_141 and var7_141 and var6_141 >= 128 and var6_141 <= 191 and var7_141 >= 128 and var7_141 <= 191 then
				var4_141 = var4_141 + 2

				table.insert(var0_141, string.char(var5_141, var6_141, var7_141))

				var1_141 = var1_141 + 1
			end
		elseif var5_141 == 45 or var5_141 == 40 or var5_141 == 41 then
			table.insert(var0_141, string.char(var5_141))
		elseif var5_141 == 194 then
			local var8_141 = string.byte(arg0_141, var4_141 + 1)

			if var8_141 == 183 then
				var4_141 = var4_141 + 1

				table.insert(var0_141, string.char(var5_141, var8_141))

				var1_141 = var1_141 + 1
			end
		elseif var5_141 == 239 then
			local var9_141 = string.byte(arg0_141, var4_141 + 1)
			local var10_141 = string.byte(arg0_141, var4_141 + 2)

			if var9_141 == 188 and (var10_141 == 136 or var10_141 == 137) then
				var4_141 = var4_141 + 2

				table.insert(var0_141, string.char(var5_141, var9_141, var10_141))

				var1_141 = var1_141 + 1
			end
		elseif var5_141 == 206 or var5_141 == 207 then
			local var11_141 = string.byte(arg0_141, var4_141 + 1)

			if var5_141 == 206 and var11_141 >= 177 or var5_141 == 207 and var11_141 <= 134 then
				var4_141 = var4_141 + 1

				table.insert(var0_141, string.char(var5_141, var11_141))

				var1_141 = var1_141 + 1
			end
		elseif var5_141 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_141 = string.byte(arg0_141, var4_141 + 1)
			local var13_141 = string.byte(arg0_141, var4_141 + 2)

			if var12_141 and var13_141 and var12_141 > 128 and var12_141 <= 191 and var13_141 >= 128 and var13_141 <= 191 then
				var4_141 = var4_141 + 2

				table.insert(var0_141, string.char(var5_141, var12_141, var13_141))

				var2_141 = var2_141 + 1
			end
		elseif var5_141 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_141 = string.byte(arg0_141, var4_141 + 1)
			local var15_141 = string.byte(arg0_141, var4_141 + 2)

			if var14_141 and var15_141 and var14_141 >= 128 and var14_141 <= 191 and var15_141 >= 128 and var15_141 <= 191 then
				var4_141 = var4_141 + 2

				table.insert(var0_141, string.char(var5_141, var14_141, var15_141))

				var3_141 = var3_141 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_141 ~= 1 and var5_141 == 32 and string.byte(arg0_141, var4_141 + 1) ~= 32 then
				table.insert(var0_141, string.char(var5_141))
			end

			if var5_141 >= 192 and var5_141 <= 223 then
				local var16_141 = string.byte(arg0_141, var4_141 + 1)

				var4_141 = var4_141 + 1

				if var5_141 == 194 and var16_141 and var16_141 >= 128 then
					table.insert(var0_141, string.char(var5_141, var16_141))
				elseif var5_141 == 195 and var16_141 and var16_141 <= 191 then
					table.insert(var0_141, string.char(var5_141, var16_141))
				end
			end

			if var5_141 == 195 then
				local var17_141 = string.byte(arg0_141, var4_141 + 1)

				if var17_141 == 188 then
					table.insert(var0_141, string.char(var5_141, var17_141))
				end
			end
		end

		var4_141 = var4_141 + 1
	end

	return table.concat(var0_141), var1_141 + var2_141 + var3_141
end

function filterEgyUnicode(arg0_142)
	arg0_142 = string.gsub(arg0_142, "\xF0\x93[\x80-\x8F][\x80-\xBF]", "")
	arg0_142 = string.gsub(arg0_142, "\xF0\x93\x90[\x80-\xAF]", "")

	return arg0_142
end

function shiftPanel(arg0_143, arg1_143, arg2_143, arg3_143, arg4_143, arg5_143, arg6_143, arg7_143, arg8_143)
	arg3_143 = arg3_143 or 0.2

	if arg5_143 then
		LeanTween.cancel(go(arg0_143))
	end

	local var0_143 = rtf(arg0_143)

	arg1_143 = arg1_143 or var0_143.anchoredPosition.x
	arg2_143 = arg2_143 or var0_143.anchoredPosition.y

	local var1_143 = LeanTween.move(var0_143, Vector3(arg1_143, arg2_143, 0), arg3_143)

	arg7_143 = arg7_143 or LeanTweenType.easeInOutSine

	var1_143:setEase(arg7_143)

	if arg4_143 then
		var1_143:setDelay(arg4_143)
	end

	if arg6_143 then
		GetOrAddComponent(arg0_143, "CanvasGroup").blocksRaycasts = false
	end

	var1_143:setOnComplete(System.Action(function()
		if arg8_143 then
			arg8_143()
		end

		if arg6_143 then
			GetOrAddComponent(arg0_143, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_143
end

function TweenValue(arg0_145, arg1_145, arg2_145, arg3_145, arg4_145, arg5_145, arg6_145, arg7_145)
	local var0_145 = LeanTween.value(go(arg0_145), arg1_145, arg2_145, arg3_145):setOnUpdate(System.Action_float(function(arg0_146)
		if arg5_145 then
			arg5_145(arg0_146)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_145 then
			arg6_145()
		end
	end)):setDelay(arg4_145 or 0)

	if arg7_145 and arg7_145 > 0 then
		var0_145:setRepeat(arg7_145)
	end

	return var0_145
end

function rotateAni(arg0_148, arg1_148, arg2_148)
	return LeanTween.rotate(rtf(arg0_148), 360 * arg1_148, arg2_148):setLoopClamp()
end

function blinkAni(arg0_149, arg1_149, arg2_149, arg3_149)
	return LeanTween.alpha(rtf(arg0_149), arg3_149 or 0, arg1_149):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_149 or 0)
end

function scaleAni(arg0_150, arg1_150, arg2_150, arg3_150)
	return LeanTween.scale(rtf(arg0_150), arg3_150 or 0, arg1_150):setLoopPingPong(arg2_150 or 0)
end

function floatAni(arg0_151, arg1_151, arg2_151, arg3_151)
	local var0_151 = arg0_151.localPosition.y + arg1_151

	return LeanTween.moveY(rtf(arg0_151), var0_151, arg2_151):setLoopPingPong(arg3_151 or 0)
end

local var9_0 = tostring

function tostring(arg0_152)
	if arg0_152 == nil then
		return "nil"
	end

	local var0_152 = var9_0(arg0_152)

	if var0_152 == nil then
		if type(arg0_152) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_152
end

function wordVer(arg0_153, arg1_153)
	if arg0_153.match(arg0_153, ChatConst.EmojiCodeMatch) then
		return 0, arg0_153
	end

	arg1_153 = arg1_153 or {}

	local var0_153 = filterEgyUnicode(arg0_153)

	if #var0_153 ~= #arg0_153 then
		if arg1_153.isReplace then
			arg0_153 = var0_153
		else
			return 1
		end
	end

	local var1_153 = wordSplit(arg0_153)
	local var2_153 = pg.word_template
	local var3_153 = pg.word_legal_template

	arg1_153.isReplace = arg1_153.isReplace or false
	arg1_153.replaceWord = arg1_153.replaceWord or "*"

	local var4_153 = #var1_153
	local var5_153 = 1
	local var6_153 = ""
	local var7_153 = 0

	while var5_153 <= var4_153 do
		local var8_153, var9_153, var10_153 = wordLegalMatch(var1_153, var3_153, var5_153)

		if var8_153 then
			var5_153 = var9_153
			var6_153 = var6_153 .. var10_153
		else
			local var11_153, var12_153, var13_153 = wordVerMatch(var1_153, var2_153, arg1_153, var5_153, "", false, var5_153, "")

			if var11_153 then
				var5_153 = var12_153
				var7_153 = var7_153 + 1

				if arg1_153.isReplace then
					var6_153 = var6_153 .. var13_153
				end
			else
				if arg1_153.isReplace then
					var6_153 = var6_153 .. var1_153[var5_153]
				end

				var5_153 = var5_153 + 1
			end
		end
	end

	if arg1_153.isReplace then
		return var7_153, var6_153
	else
		return var7_153
	end
end

function wordLegalMatch(arg0_154, arg1_154, arg2_154, arg3_154, arg4_154)
	if arg2_154 > #arg0_154 then
		return arg3_154, arg2_154, arg4_154
	end

	local var0_154 = arg0_154[arg2_154]
	local var1_154 = arg1_154[var0_154]

	arg4_154 = arg4_154 == nil and "" or arg4_154

	if var1_154 then
		if var1_154.this then
			return wordLegalMatch(arg0_154, var1_154, arg2_154 + 1, true, arg4_154 .. var0_154)
		else
			return wordLegalMatch(arg0_154, var1_154, arg2_154 + 1, false, arg4_154 .. var0_154)
		end
	else
		return arg3_154, arg2_154, arg4_154
	end
end

local var10_0 = string.byte("a")
local var11_0 = string.byte("z")
local var12_0 = string.byte("A")
local var13_0 = string.byte("Z")

local function var14_0(arg0_155)
	if not arg0_155 then
		return arg0_155
	end

	local var0_155 = string.byte(arg0_155)

	if var0_155 > 128 then
		return
	end

	if var0_155 >= var10_0 and var0_155 <= var11_0 then
		return string.char(var0_155 - 32)
	elseif var0_155 >= var12_0 and var0_155 <= var13_0 then
		return string.char(var0_155 + 32)
	else
		return arg0_155
	end
end

function wordVerMatch(arg0_156, arg1_156, arg2_156, arg3_156, arg4_156, arg5_156, arg6_156, arg7_156)
	if arg3_156 > #arg0_156 then
		return arg5_156, arg6_156, arg7_156
	end

	local var0_156 = arg0_156[arg3_156]
	local var1_156 = arg1_156[var0_156]

	if var1_156 then
		local var2_156, var3_156, var4_156 = wordVerMatch(arg0_156, var1_156, arg2_156, arg3_156 + 1, arg2_156.isReplace and arg4_156 .. arg2_156.replaceWord or arg4_156, var1_156.this or arg5_156, var1_156.this and arg3_156 + 1 or arg6_156, var1_156.this and (arg2_156.isReplace and arg4_156 .. arg2_156.replaceWord or arg4_156) or arg7_156)

		if var2_156 then
			return var2_156, var3_156, var4_156
		end
	end

	local var5_156 = var14_0(var0_156)
	local var6_156 = arg1_156[var5_156]

	if var5_156 ~= var0_156 and var6_156 then
		local var7_156, var8_156, var9_156 = wordVerMatch(arg0_156, var6_156, arg2_156, arg3_156 + 1, arg2_156.isReplace and arg4_156 .. arg2_156.replaceWord or arg4_156, var6_156.this or arg5_156, var6_156.this and arg3_156 + 1 or arg6_156, var6_156.this and (arg2_156.isReplace and arg4_156 .. arg2_156.replaceWord or arg4_156) or arg7_156)

		if var7_156 then
			return var7_156, var8_156, var9_156
		end
	end

	return arg5_156, arg6_156, arg7_156
end

function wordSplit(arg0_157)
	local var0_157 = {}

	for iter0_157 in arg0_157.gmatch(arg0_157, "[\x01-\x7F\xC2-\xF4][\x80-\xBF]*") do
		var0_157[#var0_157 + 1] = iter0_157
	end

	return var0_157
end

function contentWrap(arg0_158, arg1_158, arg2_158)
	local var0_158 = LuaHelper.WrapContent(arg0_158, arg1_158, arg2_158)

	return #var0_158 ~= #arg0_158, var0_158
end

function cancelRich(arg0_159)
	local var0_159

	for iter0_159 = 1, 20 do
		local var1_159

		arg0_159, var1_159 = string.gsub(arg0_159, "<([^>]*)>", "%1")

		if var1_159 <= 0 then
			break
		end
	end

	return arg0_159
end

function getSkillConfig(arg0_160)
	local var0_160 = require("GameCfg.buff.buff_" .. arg0_160)

	if not var0_160 then
		warning("找不到技能配置: " .. arg0_160)

		return
	end

	local var1_160 = Clone(var0_160)

	var1_160.name = getSkillName(arg0_160)
	var1_160.desc = HXSet.hxLan(var1_160.desc)
	var1_160.desc_get = HXSet.hxLan(var1_160.desc_get)

	_.each(var1_160, function(arg0_161)
		arg0_161.desc = HXSet.hxLan(arg0_161.desc)
	end)

	return var1_160
end

function getSkillName(arg0_162)
	local var0_162 = pg.skill_data_template[arg0_162] or pg.skill_data_display[arg0_162]

	if var0_162 then
		return HXSet.hxLan(var0_162.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_163, arg1_163)
	local var0_163 = arg1_163 and pg.skill_world_display[arg0_163] and setmetatable({}, {
		__index = function(arg0_164, arg1_164)
			return pg.skill_world_display[arg0_163][arg1_164] or pg.skill_data_template[arg0_163][arg1_164]
		end
	}) or pg.skill_data_template[arg0_163]

	if not var0_163 then
		return ""
	end

	local var1_163 = var0_163.desc_get ~= "" and var0_163.desc_get or var0_163.desc

	for iter0_163, iter1_163 in pairs(var0_163.desc_get_add) do
		local var2_163 = setColorStr(iter1_163[1], COLOR_GREEN)

		if iter1_163[2] then
			var2_163 = var2_163 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_163[2], COLOR_GREEN))
		end

		var1_163 = specialGSub(var1_163, "$" .. iter0_163, var2_163)
	end

	return HXSet.hxLan(var1_163)
end

function getSkillDescLearn(arg0_165, arg1_165, arg2_165)
	local var0_165 = arg2_165 and pg.skill_world_display[arg0_165] and setmetatable({}, {
		__index = function(arg0_166, arg1_166)
			return pg.skill_world_display[arg0_165][arg1_166] or pg.skill_data_template[arg0_165][arg1_166]
		end
	}) or pg.skill_data_template[arg0_165]

	if not var0_165 then
		return ""
	end

	local var1_165 = var0_165.desc

	if not var0_165.desc_add then
		return HXSet.hxLan(var1_165)
	end

	for iter0_165, iter1_165 in pairs(var0_165.desc_add) do
		local var2_165 = iter1_165[arg1_165][1]

		if iter1_165[arg1_165][2] then
			var2_165 = var2_165 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_165[arg1_165][2])
		end

		var1_165 = specialGSub(var1_165, "$" .. iter0_165, setColorStr(var2_165, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_165)
end

function getSkillDesc(arg0_167, arg1_167, arg2_167)
	local var0_167 = arg2_167 and pg.skill_world_display[arg0_167] and setmetatable({}, {
		__index = function(arg0_168, arg1_168)
			return pg.skill_world_display[arg0_167][arg1_168] or pg.skill_data_template[arg0_167][arg1_168]
		end
	}) or pg.skill_data_template[arg0_167]

	if not var0_167 then
		return ""
	end

	local var1_167 = var0_167.desc

	if not var0_167.desc_add then
		return HXSet.hxLan(var1_167)
	end

	for iter0_167, iter1_167 in pairs(var0_167.desc_add) do
		local var2_167 = setColorStr(iter1_167[arg1_167][1], COLOR_GREEN)

		var1_167 = specialGSub(var1_167, "$" .. iter0_167, var2_167)
	end

	return HXSet.hxLan(var1_167)
end

function specialGSub(arg0_169, arg1_169, arg2_169)
	arg0_169 = string.gsub(arg0_169, "<color=#", "<color=NNN")
	arg0_169 = string.gsub(arg0_169, "#", "")
	arg2_169 = string.gsub(arg2_169, "%%", "%%%%")
	arg0_169 = string.gsub(arg0_169, arg1_169, arg2_169)
	arg0_169 = string.gsub(arg0_169, "<color=NNN", "<color=#")

	return arg0_169
end

function topAnimation(arg0_170, arg1_170, arg2_170, arg3_170, arg4_170, arg5_170)
	local var0_170 = {}

	arg4_170 = arg4_170 or 0.27

	local var1_170 = 0.05

	if arg0_170 then
		local var2_170 = arg0_170.transform.localPosition.x

		setAnchoredPosition(arg0_170, {
			x = var2_170 - 500
		})
		shiftPanel(arg0_170, var2_170, nil, 0.05, arg4_170, true, true)
		setActive(arg0_170, true)
	end

	setActive(arg1_170, false)
	setActive(arg2_170, false)
	setActive(arg3_170, false)

	for iter0_170 = 1, 3 do
		table.insert(var0_170, LeanTween.delayedCall(arg4_170 + 0.13 + var1_170 * iter0_170, System.Action(function()
			if arg1_170 then
				setActive(arg1_170, not arg1_170.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_170, LeanTween.delayedCall(arg4_170 + 0.02 + var1_170 * iter0_170, System.Action(function()
			if arg2_170 then
				setActive(arg2_170, not go(arg2_170).activeSelf)
			end

			if arg2_170 then
				setActive(arg3_170, not go(arg3_170).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_170 then
		table.insert(var0_170, LeanTween.delayedCall(arg4_170 + 0.13 + var1_170 * 3 + 0.1, System.Action(function()
			arg5_170()
		end)).uniqueId)
	end

	return var0_170
end

function cancelTweens(arg0_174)
	assert(arg0_174, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_174, iter1_174 in ipairs(arg0_174) do
		if iter1_174 then
			LeanTween.cancel(iter1_174)
		end
	end
end

function getOfflineTimeStamp(arg0_175)
	local var0_175 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_175
	local var1_175 = ""

	if var0_175 <= 59 then
		var1_175 = i18n("just_now")
	elseif var0_175 <= 3599 then
		var1_175 = i18n("several_minutes_before", math.floor(var0_175 / 60))
	elseif var0_175 <= 86399 then
		var1_175 = i18n("several_hours_before", math.floor(var0_175 / 3600))
	else
		var1_175 = i18n("several_days_before", math.floor(var0_175 / 86400))
	end

	return var1_175
end

function playMovie(arg0_176, arg1_176, arg2_176)
	local var0_176 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_176) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_176, function(arg0_177)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_177 = GCHandle.Alloc(arg0_177, GCHandleType.Pinned)

			setActive(var0_176, true)

			local var1_177 = var0_176:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_177.player:SetData(arg0_177, arg0_177.Length)

			var1_177.target = var0_176:GetComponent(typeof(Image))
			var1_177.loop = false
			var1_177.additiveMode = false
			var1_177.playOnStart = true

			local var2_177

			var2_177 = Timer.New(function()
				if var1_177.player.status == CriMana.Player.Status.PlayEnd or var1_177.player.status == CriMana.Player.Status.Stop or var1_177.player.status == CriMana.Player.Status.Error then
					var2_177:Stop()
					Object.Destroy(var1_177)
					GCHandle.Free(var0_177)
					setActive(var0_176, false)

					if arg1_176 then
						arg1_176()
					end
				end
			end, 0.2, -1)

			var2_177:Start()
			removeOnButton(var0_176)

			if arg2_176 then
				onButton(nil, var0_176, function()
					var1_177:Stop()
					GetOrAddComponent(var0_176, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_176 then
		arg1_176()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_180)
	if PaintCameraAdjustOn ~= arg0_180 then
		local var0_180 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_180 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0_180.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_180.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0_180.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0_180
	end
end

function ManhattonDist(arg0_181, arg1_181)
	return math.abs(arg0_181.row - arg1_181.row) + math.abs(arg0_181.column - arg1_181.column)
end

function checkFirstHelpShow(arg0_182)
	local var0_182 = getProxy(SettingsProxy)

	if not var0_182:checkReadHelp(arg0_182) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_182].tip
		})
		var0_182:recordReadHelp(arg0_182)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_183)
	enableNotch(arg0_183, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_184)
	enableNotch(arg0_184, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_184 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_186, arg1_186)
	if arg0_186 == nil then
		return
	end

	local var0_186 = arg0_186:GetComponent("NotchAdapt")
	local var1_186 = arg0_186:GetComponent("AspectRatioFitter")

	var0_186.enabled = arg1_186

	if var1_186 then
		if arg1_186 then
			var1_186.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1_186.enabled
			var1_186.enabled = false
		end
	end
end

function comma_value(arg0_187)
	local var0_187 = arg0_187
	local var1_187 = 0

	repeat
		local var2_187

		var0_187, var2_187 = string.gsub(var0_187, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_187 == 0

	return var0_187
end

local var15_0 = 0.2

function SwitchPanel(arg0_188, arg1_188, arg2_188, arg3_188, arg4_188, arg5_188)
	arg3_188 = defaultValue(arg3_188, var15_0)

	if arg5_188 then
		LeanTween.cancel(go(arg0_188))
	end

	local var0_188 = Vector3.New(tf(arg0_188).localPosition.x, tf(arg0_188).localPosition.y, tf(arg0_188).localPosition.z)

	if arg1_188 then
		var0_188.x = arg1_188
	end

	if arg2_188 then
		var0_188.y = arg2_188
	end

	local var1_188 = LeanTween.move(rtf(arg0_188), var0_188, arg3_188):setEase(LeanTweenType.easeInOutSine)

	if arg4_188 then
		var1_188:setDelay(arg4_188)
	end

	return var1_188
end

function updateActivityTaskStatus(arg0_189)
	local var0_189 = arg0_189:getConfig("config_id")
	local var1_189, var2_189 = getActivityTask(arg0_189, true)

	if not var2_189 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_189.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_190)
	local var0_190 = getProxy(TaskProxy)
	local var1_190 = arg0_190:getNDay()

	for iter0_190, iter1_190 in ipairs(arg0_190:getConfig("config_data")) do
		local var2_190 = pg.battlepass_task_group[iter1_190]

		if var1_190 >= var2_190.time and underscore.any(underscore.flatten(var2_190.task_group), function(arg0_191)
			return var0_190:getTaskVO(arg0_191) == nil
		end) then
			pg.m02:sendNotification(GAME.CRUSING_CMD, {
				cmd = 1,
				activity_id = arg0_190.id
			})

			return true
		end
	end

	return false
end

function setShipCardFrame(arg0_192, arg1_192, arg2_192)
	arg0_192.localScale = Vector3.one
	arg0_192.anchorMin = Vector2.zero
	arg0_192.anchorMax = Vector2.one

	local var0_192 = arg2_192 or arg1_192

	GetImageSpriteFromAtlasAsync("shipframe", var0_192, arg0_192)

	local var1_192 = pg.frame_resource[var0_192]

	if var1_192 then
		local var2_192 = var1_192.param

		arg0_192.offsetMin = Vector2(var2_192[1], var2_192[2])
		arg0_192.offsetMax = Vector2(var2_192[3], var2_192[4])
	else
		arg0_192.offsetMin = Vector2.zero
		arg0_192.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_193, arg1_193, arg2_193)
	arg0_193.localScale = Vector3.one
	arg0_193.anchorMin = Vector2.zero
	arg0_193.anchorMax = Vector2.one

	setImageSprite(arg0_193, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_193 or arg1_193)))

	local var0_193 = "b" .. (arg2_193 or arg1_193)
	local var1_193 = pg.frame_resource[var0_193]

	if var1_193 then
		local var2_193 = var1_193.param

		arg0_193.offsetMin = Vector2(var2_193[1], var2_193[2])
		arg0_193.offsetMax = Vector2(var2_193[3], var2_193[4])
	else
		arg0_193.offsetMin = Vector2.zero
		arg0_193.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_194, arg1_194)
	if arg1_194 then
		local var0_194 = arg1_194 .. "(Clone)"
		local var1_194 = false

		eachChild(arg0_194, function(arg0_195)
			setActive(arg0_195, arg0_195.name == var0_194)

			var1_194 = var1_194 or arg0_195.name == var0_194
		end)

		if not var1_194 then
			LoadAndInstantiateAsync("effect", arg1_194, function(arg0_196)
				if IsNil(arg0_194) or findTF(arg0_194, var0_194) then
					Object.Destroy(arg0_196)
				else
					setParent(arg0_196, arg0_194)
					setActive(arg0_196, true)
				end
			end)
		end
	end

	setActive(arg0_194, arg1_194)
end

function setProposeMarkIcon(arg0_197, arg1_197)
	local var0_197 = arg0_197:Find("proposeShipCard(Clone)")
	local var1_197 = arg1_197.propose and not arg1_197:ShowPropose()

	if var0_197 then
		setActive(var0_197, var1_197)
	elseif var1_197 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_198)
			if IsNil(arg0_197) or arg0_197:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_198)
			else
				setParent(arg0_198, arg0_197, false)
			end
		end)
	end
end

function flushShipCard(arg0_199, arg1_199)
	local var0_199 = arg1_199:rarity2bgPrint()
	local var1_199 = findTF(arg0_199, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_199, "", var1_199)

	local var2_199 = findTF(arg0_199, "content/ship_icon")
	local var3_199 = arg1_199 and {
		"shipYardIcon/" .. arg1_199:getPainting(),
		arg1_199:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_199[1], var3_199[2], var2_199)

	local var4_199 = arg1_199:getShipType()
	local var5_199 = findTF(arg0_199, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_199), var5_199)
	setText(findTF(arg0_199, "content/dockyard/lv/Text"), defaultValue(arg1_199.level, 1))

	local var6_199 = arg1_199:getStar()
	local var7_199 = arg1_199:getMaxStar()
	local var8_199 = findTF(arg0_199, "content/front/stars")

	setActive(var8_199, true)

	local var9_199 = findTF(var8_199, "star_tpl")
	local var10_199 = var8_199.childCount

	for iter0_199 = 1, Ship.CONFIG_MAX_STAR do
		local var11_199 = var10_199 < iter0_199 and cloneTplTo(var9_199, var8_199) or var8_199:GetChild(iter0_199 - 1)

		setActive(var11_199, iter0_199 <= var7_199)
		triggerToggle(var11_199, iter0_199 <= var6_199)
	end

	local var12_199 = findTF(arg0_199, "content/front/frame")
	local var13_199, var14_199 = arg1_199:GetFrameAndEffect()

	setShipCardFrame(var12_199, var0_199, var13_199)
	setFrameEffect(findTF(arg0_199, "content/front/bg_other"), var14_199)
	setProposeMarkIcon(arg0_199:Find("content/dockyard/propose"), arg1_199)
end

function TweenItemAlphaAndWhite(arg0_200)
	LeanTween.cancel(arg0_200)

	local var0_200 = GetOrAddComponent(arg0_200, "CanvasGroup")

	var0_200.alpha = 0

	LeanTween.alphaCanvas(var0_200, 1, 0.2):setUseEstimatedTime(true)

	local var1_200 = findTF(arg0_200.transform, "white_mask")

	if var1_200 then
		setActive(var1_200, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_201)
	LeanTween.cancel(arg0_201)

	GetOrAddComponent(arg0_201, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_202)
	local var0_202 = {}
	local var1_202 = getProxy(ShipSkinProxy):getSkinList()
	local var2_202 = getProxy(CollectionProxy):getShipGroup(arg0_202)

	if var2_202 then
		local var3_202 = ShipGroup.getSkinList(arg0_202)

		for iter0_202, iter1_202 in ipairs(var3_202) do
			if iter1_202.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_202, iter1_202.id) or iter1_202.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_202.trans or iter1_202.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_202.married == 1 then
				var0_202[iter1_202.id] = true
			end
		end
	end

	return var0_202
end

function split(arg0_203, arg1_203)
	local var0_203 = {}

	if not arg0_203 then
		return nil
	end

	local var1_203 = #arg0_203
	local var2_203 = 1

	while var2_203 <= var1_203 do
		local var3_203 = string.find(arg0_203, arg1_203, var2_203)

		if var3_203 == nil then
			table.insert(var0_203, string.sub(arg0_203, var2_203, var1_203))

			break
		end

		table.insert(var0_203, string.sub(arg0_203, var2_203, var3_203 - 1))

		if var3_203 == var1_203 then
			table.insert(var0_203, "")

			break
		end

		var2_203 = var3_203 + 1
	end

	return var0_203
end

function NumberToChinese(arg0_204, arg1_204)
	local var0_204 = ""
	local var1_204 = #arg0_204

	for iter0_204 = 1, var1_204 do
		local var2_204 = string.sub(arg0_204, iter0_204, iter0_204)

		if var2_204 ~= "0" or var2_204 == "0" and not arg1_204 then
			if arg1_204 then
				if var1_204 >= 2 then
					if iter0_204 == 1 then
						if var2_204 == "1" then
							var0_204 = i18n("number_" .. 10)
						else
							var0_204 = i18n("number_" .. var2_204) .. i18n("number_" .. 10)
						end
					else
						var0_204 = var0_204 .. i18n("number_" .. var2_204)
					end
				else
					var0_204 = var0_204 .. i18n("number_" .. var2_204)
				end
			else
				var0_204 = var0_204 .. i18n("number_" .. var2_204)
			end
		end
	end

	return var0_204
end

function getActivityTask(arg0_205, arg1_205)
	local var0_205 = getProxy(TaskProxy)
	local var1_205 = arg0_205:getConfig("config_data")
	local var2_205 = arg0_205:getNDay(arg0_205.data1)
	local var3_205
	local var4_205
	local var5_205

	for iter0_205 = math.max(arg0_205.data3, 1), math.min(var2_205, #var1_205) do
		local var6_205 = _.flatten({
			var1_205[iter0_205]
		})

		for iter1_205, iter2_205 in ipairs(var6_205) do
			local var7_205 = var0_205:getTaskById(iter2_205)

			if var7_205 then
				return var7_205.id, var7_205
			end

			if var4_205 then
				var5_205 = var0_205:getFinishTaskById(iter2_205)

				if var5_205 then
					var4_205 = var5_205
				elseif arg1_205 then
					return iter2_205
				else
					return var4_205.id, var4_205
				end
			else
				var4_205 = var0_205:getFinishTaskById(iter2_205)
				var5_205 = var5_205 or iter2_205
			end
		end
	end

	if var4_205 then
		return var4_205.id, var4_205
	else
		return var5_205
	end
end

function setImageFromImage(arg0_206, arg1_206, arg2_206)
	local var0_206 = GetComponent(arg0_206, "Image")

	var0_206.sprite = GetComponent(arg1_206, "Image").sprite

	if arg2_206 then
		var0_206:SetNativeSize()
	end
end

function skinTimeStamp(arg0_207)
	local var0_207, var1_207, var2_207, var3_207 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_207)

	if var0_207 >= 1 then
		return i18n("limit_skin_time_day", var0_207)
	elseif var0_207 <= 0 and var1_207 > 0 then
		return i18n("limit_skin_time_day_min", var1_207, var2_207)
	elseif var0_207 <= 0 and var1_207 <= 0 and (var2_207 > 0 or var3_207 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_207, 1))
	elseif var0_207 <= 0 and var1_207 <= 0 and var2_207 <= 0 and var3_207 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_208)
	local var0_208 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_208 = math.max(arg0_208 - var0_208, 0)
	local var2_208 = math.floor(var1_208 / 86400)

	if var2_208 > 0 then
		return i18n("time_remaining_tip") .. var2_208 .. i18n("word_date")
	else
		local var3_208 = math.floor(var1_208 / 3600)

		if var3_208 > 0 then
			return i18n("time_remaining_tip") .. var3_208 .. i18n("word_hour")
		else
			local var4_208 = math.floor(var1_208 / 60)

			if var4_208 > 0 then
				return i18n("time_remaining_tip") .. var4_208 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_208 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_209)
	local var0_209 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_209
	local var1_209 = var0_209 / 86400

	if var1_209 > 1 then
		return i18n("ins_word_day", math.floor(var1_209))
	else
		local var2_209 = var0_209 / 3600

		if var2_209 > 1 then
			return i18n("ins_word_hour", math.floor(var2_209))
		else
			local var3_209 = var0_209 / 60

			if var3_209 > 1 then
				return i18n("ins_word_minu", math.floor(var3_209))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_210)
	local var0_210 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_210
	local var1_210 = var0_210 / 86400

	if var1_210 > 1 then
		return i18n1(math.floor(var1_210) .. "d")
	else
		local var2_210 = var0_210 / 3600

		if var2_210 > 1 then
			return i18n1(math.floor(var2_210) .. "h")
		else
			local var3_210 = var0_210 / 60

			if var3_210 > 1 then
				return i18n1(math.floor(var3_210) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_211)
	local var0_211, var1_211, var2_211, var3_211 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_211)

	if var0_211 <= 0 and var1_211 <= 0 and var2_211 <= 0 and var3_211 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_211, var1_211, var2_211)
	end
end

function checkExist(arg0_212, ...)
	local var0_212 = {
		...
	}

	for iter0_212, iter1_212 in ipairs(var0_212) do
		if arg0_212 == nil then
			break
		end

		assert(type(arg0_212) == "table", "type error : intermediate target should be table")
		assert(type(iter1_212) == "table", "type error : param should be table")

		if type(arg0_212[iter1_212[1]]) == "function" then
			arg0_212 = arg0_212[iter1_212[1]](arg0_212, unpack(iter1_212[2] or {}))
		else
			arg0_212 = arg0_212[iter1_212[1]]
		end
	end

	return arg0_212
end

function AcessWithinNull(arg0_213, arg1_213)
	if arg0_213 == nil then
		return
	end

	assert(type(arg0_213) == "table")

	return arg0_213[arg1_213]
end

function showRepairMsgbox()
	local var0_214 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_214 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_214 = {
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
			var2_214,
			var1_214,
			var0_214
		}
	})
end

function resourceVerify(arg0_218, arg1_218)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_218 = Application.persistentDataPath .. "/hashes.csv"
	local var1_218
	local var2_218 = PathMgr.ReadAllLines(var0_218)
	local var3_218 = {}

	if arg0_218 then
		setActive(arg0_218, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_218()
		if arg0_218 then
			setActive(arg0_218, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_218)

		if var1_218 then
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

	local var5_218 = var2_218.Length
	local var6_218

	local function var7_218(arg0_221)
		if arg0_221 < 0 then
			var4_218()

			return
		end

		if arg1_218 then
			setSlider(arg1_218, 0, var5_218, var5_218 - arg0_221)
		end

		local var0_221 = string.split(var2_218[arg0_221], ",")
		local var1_221 = var0_221[1]
		local var2_221 = var0_221[3]
		local var3_221 = PathMgr.getAssetBundle(var1_221)

		if PathMgr.FileExists(var3_221) then
			local var4_221 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_221))

			if var2_221 == HashUtil.CalcMD5(var4_221) then
				onNextTick(function()
					var7_218(arg0_221 - 1)
				end)

				return
			end
		end

		var1_218 = var1_221

		var4_218()
	end

	var7_218(var5_218 - 1)
end

function splitByWordEN(arg0_223, arg1_223)
	local var0_223 = string.split(arg0_223, " ")
	local var1_223 = ""
	local var2_223 = ""
	local var3_223 = arg1_223:GetComponent(typeof(RectTransform))
	local var4_223 = arg1_223:GetComponent(typeof(Text))
	local var5_223 = var3_223.rect.width

	for iter0_223, iter1_223 in ipairs(var0_223) do
		local var6_223 = var2_223

		var2_223 = var2_223 == "" and iter1_223 or var2_223 .. " " .. iter1_223

		setText(arg1_223, var2_223)

		if var5_223 < var4_223.preferredWidth then
			var1_223 = var1_223 == "" and var6_223 or var1_223 .. "\n" .. var6_223
			var2_223 = iter1_223
		end

		if iter0_223 >= #var0_223 then
			var1_223 = var1_223 == "" and var2_223 or var1_223 .. "\n" .. var2_223
		end
	end

	return var1_223
end

function checkBirthFormat(arg0_224)
	if #arg0_224 ~= 8 then
		return false
	end

	local var0_224 = 0
	local var1_224 = #arg0_224

	while var0_224 < var1_224 do
		local var2_224 = string.byte(arg0_224, var0_224 + 1)

		if var2_224 < 48 or var2_224 > 57 then
			return false
		end

		var0_224 = var0_224 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_225)
	local var0_225 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_225, function(arg0_226)
		return arg0_226 == arg0_225
	end)
end

function GetServerState(arg0_227)
	local var0_227 = -1
	local var1_227 = 0
	local var2_227 = 1
	local var3_227 = 2
	local var4_227 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_227 = string.gsub(var4_227, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_227, function(arg0_228, arg1_228)
		local var0_228 = true
		local var1_228 = false

		for iter0_228 in string.gmatch(arg1_228, "\"state\":%d") do
			if iter0_228 ~= "\"state\":1" then
				var0_228 = false
			end

			var1_228 = true
		end

		if not var1_228 then
			var0_228 = false
		end

		if arg0_227 ~= nil then
			arg0_227(var0_228 and var2_227 or var1_227)
		end
	end)
end

function setScrollText(arg0_229, arg1_229)
	GetOrAddComponent(arg0_229, "ScrollText"):SetText(arg1_229)
end

function changeToScrollText(arg0_230, arg1_230)
	local var0_230 = GetComponent(arg0_230, typeof(Text))

	assert(var0_230, "without component<Text>")

	local var1_230 = arg0_230:Find("subText")

	if not var1_230 then
		var1_230 = cloneTplTo(arg0_230, arg0_230, "subText")

		eachChild(arg0_230, function(arg0_231)
			setActive(arg0_231, arg0_231 == var1_230)
		end)

		arg0_230:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_230, arg1_230)
end

local var16_0
local var17_0
local var18_0
local var19_0

local function var20_0(arg0_232, arg1_232, arg2_232)
	local var0_232 = arg0_232:Find("base")
	local var1_232, var2_232, var3_232 = Equipment.GetInfoTrans(arg1_232, arg2_232)

	if arg1_232.nextValue then
		local var4_232 = {
			name = arg1_232.name,
			type = arg1_232.type,
			value = arg1_232.nextValue
		}
		local var5_232, var6_232 = Equipment.GetInfoTrans(var4_232, arg2_232)

		var2_232 = var2_232 .. setColorStr("   >   " .. var6_232, COLOR_GREEN)
	end

	setText(var0_232:Find("name"), var1_232)

	if var3_232 then
		local var7_232 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_232:Find("value"), var2_232 .. var7_232)
	else
		setText(var0_232:Find("value"), var2_232)
	end

	setActive(var0_232:Find("value/up"), arg1_232.compare and arg1_232.compare > 0)
	setActive(var0_232:Find("value/down"), arg1_232.compare and arg1_232.compare < 0)
	triggerToggle(var0_232, arg1_232.lock_open)

	if not arg1_232.lock_open and arg1_232.sub and #arg1_232.sub > 0 then
		GetComponent(var0_232, typeof(Toggle)).enabled = true
	else
		setActive(var0_232:Find("name/close"), false)
		setActive(var0_232:Find("name/open"), false)

		GetComponent(var0_232, typeof(Toggle)).enabled = false
	end
end

local function var21_0(arg0_233, arg1_233, arg2_233, arg3_233)
	var20_0(arg0_233, arg2_233, arg3_233)

	if not arg2_233.sub or #arg2_233.sub == 0 then
		return
	end

	var18_0(arg0_233:Find("subs"), arg1_233, arg2_233.sub, arg3_233)
end

function var18_0(arg0_234, arg1_234, arg2_234, arg3_234)
	removeAllChildren(arg0_234)
	var19_0(arg0_234, arg1_234, arg2_234, arg3_234)
end

function var19_0(arg0_235, arg1_235, arg2_235, arg3_235)
	for iter0_235, iter1_235 in ipairs(arg2_235) do
		local var0_235 = cloneTplTo(arg1_235, arg0_235)

		var21_0(var0_235, arg1_235, iter1_235, arg3_235)
	end
end

function updateEquipInfo(arg0_236, arg1_236, arg2_236, arg3_236)
	local var0_236 = arg0_236:Find("attr_tpl")

	var18_0(arg0_236:Find("attrs"), var0_236, arg1_236.attrs, arg3_236)
	setActive(arg0_236:Find("skill"), arg2_236)

	if arg2_236 then
		var21_0(arg0_236:Find("skill/attr"), var0_236, {
			name = i18n("skill"),
			value = setColorStr(arg2_236.name, "#FFDE00FF")
		}, arg3_236)
		setText(arg0_236:Find("skill/value/Text"), getSkillDescGet(arg2_236.id))
	end

	setActive(arg0_236:Find("weapon"), #arg1_236.weapon.sub > 0)

	if #arg1_236.weapon.sub > 0 then
		var18_0(arg0_236:Find("weapon"), var0_236, {
			arg1_236.weapon
		}, arg3_236)
	end

	setActive(arg0_236:Find("equip_info"), #arg1_236.equipInfo.sub > 0)

	if #arg1_236.equipInfo.sub > 0 then
		var18_0(arg0_236:Find("equip_info"), var0_236, {
			arg1_236.equipInfo
		}, arg3_236)
	end

	var21_0(arg0_236:Find("part/attr"), var0_236, {
		name = i18n("equip_info_23")
	}, arg3_236)

	local var1_236 = arg0_236:Find("part/value")
	local var2_236 = var1_236:Find("label")
	local var3_236 = {}
	local var4_236 = {}

	if #arg1_236.part[1] == 0 and #arg1_236.part[2] == 0 then
		setmetatable(var3_236, {
			__index = function(arg0_237, arg1_237)
				return true
			end
		})
		setmetatable(var4_236, {
			__index = function(arg0_238, arg1_238)
				return true
			end
		})
	else
		for iter0_236, iter1_236 in ipairs(arg1_236.part[1]) do
			var3_236[iter1_236] = true
		end

		for iter2_236, iter3_236 in ipairs(arg1_236.part[2]) do
			var4_236[iter3_236] = true
		end
	end

	local var5_236 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_236, var4_236)

	UIItemList.StaticAlign(var1_236, var2_236, #var5_236, function(arg0_239, arg1_239, arg2_239)
		arg1_239 = arg1_239 + 1

		if arg0_239 == UIItemList.EventUpdate then
			local var0_239 = var5_236[arg1_239]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_239), arg2_239)
			setActive(arg2_239:Find("main"), var3_236[var0_239] and not var4_236[var0_239])
			setActive(arg2_239:Find("sub"), var4_236[var0_239] and not var3_236[var0_239])
			setImageAlpha(arg2_239, not var3_236[var0_239] and not var4_236[var0_239] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_240, arg1_240, arg2_240)
	local var0_240 = arg0_240:Find("attr_tpl")

	var18_0(arg0_240:Find("attrs"), var0_240, arg1_240.attrs, arg2_240)
	setActive(arg0_240:Find("weapon"), #arg1_240.weapon.sub > 0)

	if #arg1_240.weapon.sub > 0 then
		var18_0(arg0_240:Find("weapon"), var0_240, {
			arg1_240.weapon
		}, arg2_240)
	end

	setActive(arg0_240:Find("equip_info"), #arg1_240.equipInfo.sub > 0)

	if #arg1_240.equipInfo.sub > 0 then
		var18_0(arg0_240:Find("equip_info"), var0_240, {
			arg1_240.equipInfo
		}, arg2_240)
	end
end

function setCanvasOverrideSorting(arg0_241, arg1_241)
	local var0_241 = arg0_241.parent

	arg0_241:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_241) then
		GetOrAddComponent(arg0_241, typeof(Canvas)).overrideSorting = arg1_241
	else
		setActive(arg0_241, true)

		GetOrAddComponent(arg0_241, typeof(Canvas)).overrideSorting = arg1_241

		setActive(arg0_241, false)
	end

	arg0_241:SetParent(var0_241, false)
end

function createNewGameObject(arg0_242, arg1_242)
	local var0_242 = GameObject.New()

	if arg0_242 then
		var0_242.name = "model"
	end

	var0_242.layer = arg1_242 or Layer.UI

	return GetOrAddComponent(var0_242, "RectTransform")
end

function CreateShell(arg0_243)
	if type(arg0_243) ~= "table" and type(arg0_243) ~= "userdata" then
		return arg0_243
	end

	local var0_243 = setmetatable({
		__index = arg0_243
	}, arg0_243)

	return setmetatable({}, var0_243)
end

function CameraFittingSettin(arg0_244)
	local var0_244 = GetComponent(arg0_244, typeof(Camera))
	local var1_244 = 1.77777777777778
	local var2_244 = Screen.width / Screen.height

	if var2_244 < var1_244 then
		local var3_244 = var2_244 / var1_244

		var0_244.rect = var0_0.Rect.New(0, (1 - var3_244) / 2, 1, var3_244)
	end
end

function SwitchSpecialChar(arg0_245, arg1_245)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_245 = arg0_245:gsub(" ", " ")
		arg0_245 = arg0_245:gsub("\t", "    ")
	end

	if not arg1_245 then
		arg0_245 = arg0_245:gsub("\n", " ")
	end

	return arg0_245
end

function AfterCheck(arg0_246, arg1_246)
	local var0_246 = {}

	for iter0_246, iter1_246 in ipairs(arg0_246) do
		var0_246[iter0_246] = iter1_246[1]()
	end

	arg1_246()

	for iter2_246, iter3_246 in ipairs(arg0_246) do
		if var0_246[iter2_246] ~= iter3_246[1]() then
			iter3_246[2]()
		end

		var0_246[iter2_246] = iter3_246[1]()
	end
end

function CompareFuncs(arg0_247, arg1_247)
	local var0_247 = {}

	local function var1_247(arg0_248, arg1_248)
		var0_247[arg0_248] = var0_247[arg0_248] or {}
		var0_247[arg0_248][arg1_248] = var0_247[arg0_248][arg1_248] or arg0_247[arg0_248](arg1_248)

		return var0_247[arg0_248][arg1_248]
	end

	return function(arg0_249, arg1_249)
		local var0_249 = 1

		while var0_249 <= #arg0_247 do
			local var1_249 = var1_247(var0_249, arg0_249)
			local var2_249 = var1_247(var0_249, arg1_249)

			if var1_249 == var2_249 then
				var0_249 = var0_249 + 1
			else
				return var1_249 < var2_249
			end
		end

		return tobool(arg1_247)
	end
end

function DropResultIntegration(arg0_250)
	local var0_250 = {}
	local var1_250 = 1

	while var1_250 <= #arg0_250 do
		local var2_250 = arg0_250[var1_250].type
		local var3_250 = arg0_250[var1_250].id

		var0_250[var2_250] = var0_250[var2_250] or {}

		if var0_250[var2_250][var3_250] then
			local var4_250 = arg0_250[var0_250[var2_250][var3_250]]
			local var5_250 = table.remove(arg0_250, var1_250)

			var4_250.count = var4_250.count + var5_250.count
		else
			var0_250[var2_250][var3_250] = var1_250
			var1_250 = var1_250 + 1
		end
	end

	local var6_250 = {
		function(arg0_251)
			local var0_251 = arg0_251.type
			local var1_251 = arg0_251.id

			if var0_251 == DROP_TYPE_SHIP then
				return 1
			elseif var0_251 == DROP_TYPE_RESOURCE then
				if var1_251 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_251 == DROP_TYPE_ITEM then
				if var1_251 == 59010 then
					return 4
				elseif var1_251 == 59900 then
					return 5
				else
					local var2_251 = Item.getConfigData(var1_251)
					local var3_251 = var2_251 and var2_251.type or 0

					if var3_251 == 9 then
						return 6
					elseif var3_251 == 5 then
						return 7
					elseif var3_251 == 4 then
						return 8
					elseif var3_251 == 7 then
						return 9
					end
				end
			elseif var0_251 == DROP_TYPE_VITEM and var1_251 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_252)
			local var0_252

			if arg0_252.type == DROP_TYPE_SHIP then
				var0_252 = pg.ship_data_statistics[arg0_252.id]
			elseif arg0_252.type == DROP_TYPE_ITEM then
				var0_252 = Item.getConfigData(arg0_252.id)
			end

			return (var0_252 and var0_252.rarity or 0) * -1
		end,
		function(arg0_253)
			return arg0_253.id
		end
	}

	table.sort(arg0_250, CompareFuncs(var6_250))
end

function getLoginConfig()
	local var0_254 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_254 = 1

	for iter0_254, iter1_254 in ipairs(pg.login.all) do
		if pg.login[iter1_254].date ~= "stop" then
			local var2_254, var3_254 = parseTimeConfig(pg.login[iter1_254].date)

			assert(not var3_254)

			if pg.TimeMgr.GetInstance():inTime(var2_254, var0_254) then
				var1_254 = iter1_254

				break
			end
		end
	end

	local var4_254 = pg.login[var1_254].login_static

	var4_254 = var4_254 ~= "" and var4_254 or "login"

	local var5_254 = pg.login[var1_254].login_cri
	local var6_254 = var5_254 ~= "" and true or false
	local var7_254 = pg.login[var1_254].op_play == 1 and true or false
	local var8_254 = pg.login[var1_254].op_time

	if var8_254 == "" or not pg.TimeMgr.GetInstance():inTime(var8_254, var0_254) then
		var7_254 = false
	end

	local var9_254 = var8_254 == "" and var8_254 or table.concat(var8_254[1][1])

	return var6_254, var6_254 and var5_254 or var4_254, pg.login[var1_254].bgm, var7_254, var9_254
end

function setIntimacyIcon(arg0_255, arg1_255, arg2_255)
	local var0_255 = {}
	local var1_255

	if arg0_255.childCount > 0 then
		var1_255 = arg0_255:GetChild(0)
	else
		var1_255 = LoadAndInstantiateSync("template", "intimacytpl").transform

		setParent(var1_255, arg0_255)
	end

	setImageAlpha(var1_255, arg2_255 and 0 or 1)
	eachChild(var1_255, function(arg0_256)
		setActive(arg0_256, false)
	end)

	if arg2_255 then
		local var2_255 = var1_255:Find(arg2_255 .. "(Clone)")

		if not var2_255 then
			var2_255 = LoadAndInstantiateSync("ui", arg2_255)

			setParent(var2_255, var1_255)
		end

		setActive(var2_255, true)
	elseif arg1_255 then
		setImageSprite(var1_255, GetSpriteFromAtlas("energy", arg1_255), true)
	else
		assert(false, "param error")
	end

	return var1_255
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

function switch(arg0_259, arg1_259, arg2_259, ...)
	if arg1_259[arg0_259] then
		return arg1_259[arg0_259](...)
	elseif arg2_259 then
		return arg2_259(...)
	end
end

function parseTimeConfig(arg0_260)
	if type(arg0_260[1]) == "table" then
		return arg0_260[2], arg0_260[1]
	else
		return arg0_260
	end
end

local var23_0 = {
	__add = function(arg0_261, arg1_261)
		return NewPos(arg0_261.x + arg1_261.x, arg0_261.y + arg1_261.y)
	end,
	__sub = function(arg0_262, arg1_262)
		return NewPos(arg0_262.x - arg1_262.x, arg0_262.y - arg1_262.y)
	end,
	__mul = function(arg0_263, arg1_263)
		if type(arg1_263) == "number" then
			return NewPos(arg0_263.x * arg1_263, arg0_263.y * arg1_263)
		else
			return NewPos(arg0_263.x * arg1_263.x, arg0_263.y * arg1_263.y)
		end
	end,
	__eq = function(arg0_264, arg1_264)
		return arg0_264.x == arg1_264.x and arg0_264.y == arg1_264.y
	end,
	__tostring = function(arg0_265)
		return arg0_265.x .. "_" .. arg0_265.y
	end
}

function NewPos(arg0_266, arg1_266)
	assert(arg0_266 and arg1_266)

	local var0_266 = setmetatable({
		x = arg0_266,
		y = arg1_266
	}, var23_0)

	function var0_266.SqrMagnitude(arg0_267)
		return arg0_267.x * arg0_267.x + arg0_267.y * arg0_267.y
	end

	function var0_266.Normalize(arg0_268)
		local var0_268 = arg0_268:SqrMagnitude()

		if var0_268 > 1e-05 then
			return arg0_268 * (1 / math.sqrt(var0_268))
		else
			return NewPos(0, 0)
		end
	end

	return var0_266
end

local var24_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var24_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var24_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_270)
	return (string.char(226, 133, 160 + (arg0_270 - 1)))
end

function quickPlayAnimator(arg0_271, arg1_271)
	arg0_271:GetComponent(typeof(Animator)):Play(arg1_271, -1, 0)
end

function getSurveyUrl(arg0_272)
	local var0_272 = pg.survey_data_template[arg0_272]
	local var1_272

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_272 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_272 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_272 = var0_272.main_url
				else
					var1_272 = var0_272.uo_url
				end
			elseif var2_272 == PLATFORM_IPHONEPLAYER then
				var1_272 = var0_272.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			var1_272 = var0_272.main_url
		end
	else
		var1_272 = var0_272.main_url
	end

	local var3_272 = getProxy(PlayerProxy):getRawData().id
	local var4_272 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_272
	local var6_272 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_272 = getProxy(UserProxy):getRawData()
	local var8_272 = getProxy(ServerProxy):getRawData()[var7_272 and var7_272.server or 0]
	local var9_272 = var8_272 and var8_272.id or ""
	local var10_272 = getProxy(PlayerProxy):getRawData().level
	local var11_272 = var3_272 .. "_" .. arg0_272
	local var12_272 = var1_272
	local var13_272 = {
		var3_272,
		var4_272,
		var6_272,
		var9_272,
		var10_272,
		var11_272
	}

	if var12_272 then
		for iter0_272, iter1_272 in ipairs(var13_272) do
			var12_272 = string.gsub(var12_272, "$" .. iter0_272, tostring(iter1_272))
		end
	end

	warning(var12_272)

	return var12_272
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

function FilterVarchar(arg0_274)
	assert(type(arg0_274) == "string" or type(arg0_274) == "table")

	if arg0_274 == "" then
		return nil
	end

	return arg0_274
end

function getGameset(arg0_275)
	local var0_275 = pg.gameset[arg0_275]

	assert(var0_275)

	return {
		var0_275.key_value,
		var0_275.description
	}
end

function getDorm3dGameset(arg0_276)
	local var0_276 = pg.dorm3d_set[arg0_276]

	assert(var0_276)

	return {
		var0_276.key_value_int,
		var0_276.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_277)
	arg0_277 = arg0_277 or {}

	local var0_277 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_277 > 0 do
		local var1_277 = table.remove(arg0_277)

		switch(var1_277.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_277:getConfig("open_directly") == 1 then
					for iter0_278, iter1_278 in ipairs(var1_277:getConfig("display_icon")) do
						local var0_278 = Drop.Create(iter1_278)

						var0_278.count = var0_278.count * var1_277.count

						table.insert(arg0_277, var0_278)
					end
				elseif var1_277:getSubClass():IsShipExpType() then
					var0_277[var1_277.type][var1_277.id] = defaultValue(var0_277[var1_277.type][var1_277.id], 0) + var1_277.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_277[var1_277.type][var1_277.id] = defaultValue(var0_277[var1_277.type][var1_277.id], 0) + var1_277.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_277[var1_277.type] = var0_277[var1_277.type] + var1_277.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_277[var1_277.type] = var0_277[var1_277.type] + var1_277.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_277[var1_277.type] = var0_277[var1_277.type] + var1_277.count
			end
		})
	end

	return var0_277
end

function CheckOverflow(arg0_283, arg1_283)
	local var0_283 = {}
	local var1_283 = arg0_283[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_283 = arg0_283[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_283 = arg0_283[DROP_TYPE_EQUIP]
	local var4_283 = arg0_283[DROP_TYPE_SHIP]
	local var5_283 = getProxy(PlayerProxy):getRawData()
	local var6_283 = false

	if arg1_283 then
		local var7_283 = var5_283:OverStore(PlayerConst.ResStoreGold, var1_283)
		local var8_283 = var5_283:OverStore(PlayerConst.ResStoreOil, var2_283)

		if var7_283 > 0 or var8_283 > 0 then
			var0_283.isStoreOverflow = {
				var7_283,
				var8_283
			}
		end
	else
		if var1_283 > 0 and var5_283:GoldMax(var1_283) then
			return false, "gold"
		end

		if var2_283 > 0 and var5_283:OilMax(var2_283) then
			return false, "oil"
		end
	end

	var0_283.isExpBookOverflow = {}

	for iter0_283, iter1_283 in pairs(arg0_283[DROP_TYPE_ITEM]) do
		local var9_283 = Item.getConfigData(iter0_283)

		if getProxy(BagProxy):getItemCountById(iter0_283) + iter1_283 > var9_283.max_num then
			table.insert(var0_283.isExpBookOverflow, iter0_283)
		end
	end

	local var10_283 = getProxy(EquipmentProxy):getCapacity()

	if var3_283 > 0 and var3_283 + var10_283 > var5_283:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_283 = getProxy(BayProxy):getShipCount()

	if var4_283 > 0 and var4_283 + var11_283 > var5_283:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_283
end

function CheckShipExpOverflow(arg0_284)
	local var0_284 = getProxy(BagProxy)

	for iter0_284, iter1_284 in pairs(arg0_284[DROP_TYPE_ITEM]) do
		if var0_284:getItemCountById(iter0_284) + iter1_284 > Item.getConfigData(iter0_284).max_num then
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

function RegisterDetailButton(arg0_285, arg1_285, arg2_285)
	Drop.Change(arg2_285)
	switch(arg2_285.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_285:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_286 = Item.getConfigData(arg2_285.id).usage_arg
				local var1_286 = var0_286[3]

				if Item.InTimeLimitSkinAssigned(arg2_285.id) then
					var1_286 = table.mergeArray(var0_286[2], var1_286, true)
				end

				local var2_286 = {}

				for iter0_286, iter1_286 in ipairs(var0_286[2]) do
					var2_286[iter1_286] = true
				end

				onButton(arg0_285, arg1_285, function()
					arg0_285:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_285.id,
								selectableSkinList = underscore.map(var1_286, function(arg0_288)
									return SelectableSkin.New({
										id = arg0_288,
										isTimeLimit = var2_286[arg0_288] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_285, true)
			else
				local var3_286 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_285.id) and "tech" or arg2_285:getConfig("type")

				if var25_0[var3_286] then
					local var4_286 = {
						item2Row = true,
						content = i18n(var25_0[var3_286]),
						itemList = underscore.map(arg2_285:getConfig("display_icon"), function(arg0_289)
							return Drop.Create(arg0_289)
						end)
					}

					if var3_286 == 11 then
						onButton(arg0_285, arg1_285, function()
							arg0_285:emit(BaseUI.ON_DROP_LIST_OWN, var4_286)
						end, SFX_PANEL)
					else
						onButton(arg0_285, arg1_285, function()
							arg0_285:emit(BaseUI.ON_DROP_LIST, var4_286)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_285, tobool(var25_0[var3_286]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_285, arg1_285, function()
				arg0_285:emit(BaseUI.ON_DROP, arg2_285)
			end, SFX_PANEL)
			setActive(arg1_285, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_285, arg1_285, function()
				arg0_285:emit(BaseUI.ON_DROP, arg2_285)
			end, SFX_PANEL)
			setActive(arg1_285, true)
		end
	}, function()
		setActive(arg1_285, false)
	end)
end

function UpdateOwnDisplay(arg0_297, arg1_297)
	local var0_297, var1_297 = arg1_297:getOwnedCount()

	setActive(arg0_297, var1_297 and var0_297 > 0)

	if var1_297 and var0_297 > 0 then
		setText(arg0_297:Find("label"), i18n("word_own1"))
		setText(arg0_297:Find("Text"), var0_297)
	end
end

function Damp(arg0_298, arg1_298, arg2_298)
	arg1_298 = Mathf.Max(1, arg1_298)

	local var0_298 = Mathf.Epsilon

	if arg1_298 < var0_298 or var0_298 > Mathf.Abs(arg0_298) then
		return arg0_298
	end

	if arg2_298 < var0_298 then
		return 0
	end

	local var1_298 = -4.605170186

	return arg0_298 * (1 - Mathf.Exp(var1_298 * arg2_298 / arg1_298))
end

function checkCullResume(arg0_299)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_299, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_299 = arg0_299:GetComponentsInChildren(typeof(MeshImage))

		for iter0_299 = 1, var0_299.Length do
			var0_299[iter0_299 - 1]:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_300)
	local var0_300 = {}

	if arg0_300 and arg0_300 ~= "" then
		local var1_300 = base64.dec(arg0_300)

		var0_300 = string.split(var1_300, "/")
		var0_300[5], var0_300[6] = unpack(string.split(var0_300[5], "\\"))

		if #var0_300 < 6 or arg0_300 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_300, 5), "/"),
			var0_300[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_300 = {}
		end
	end

	for iter0_300 = 1, 6 do
		var0_300[iter0_300] = var0_300[iter0_300] and tonumber(var0_300[iter0_300], 32) or 0
	end

	return var0_300
end

function buildEquipCode(arg0_301)
	local var0_301 = underscore.map(arg0_301:getAllEquipments(), function(arg0_302)
		return ConversionBase(32, arg0_302 and arg0_302.id or 0)
	end)
	local var1_301 = {
		table.concat(var0_301, "/"),
		ConversionBase(32, checkExist(arg0_301:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_301, "\\"))
end

function setDirectorSpeed(arg0_303, arg1_303)
	GetComponent(arg0_303, "TimelineSpeed"):SetTimelineSpeed(arg1_303)
end

function envFunc(arg0_304, arg1_304)
	assert(not getmetatable(arg1_304), "table has error metatable")
	setfenv(arg0_304, setmetatable(arg1_304, {
		__index = _G
	}))
	arg0_304()
	setfenv(arg0_304, _G)

	return setmetatable(arg1_304, nil)
end

function setDefaultZeroMetatable(arg0_305)
	return setmetatable(arg0_305, {
		__index = function(arg0_306, arg1_306)
			if rawget(arg0_306, arg1_306) == nil then
				arg0_306[arg1_306] = 0
			end

			return arg0_306[arg1_306]
		end
	})
end

if EDITOR_TOOL then
	local var26_0 = {
		__index = {
			LoadAssetSync = function(arg0_307, ...)
				return ResourceMgr.Inst:getAssetSync(arg0_307.path, ...)
			end,
			GetAllAssetNames = function(arg0_308, ...)
				return ReflectionHelp.RefCallMethod(typeof(ResourceMgr), "GetAssetBundleAllAssetNames", ResourceMgr.Inst, {
					typeof("System.String")
				}, {
					arg0_308.path
				})
			end
		}
	}

	function buildTempAB(arg0_309, arg1_309)
		local var0_309 = setmetatable({
			path = arg0_309
		}, var26_0)

		if arg1_309 then
			onNextTick(function()
				arg1_309(var0_309)
			end)
		end

		return var0_309
	end

	function checkABExist(arg0_311)
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_311)) or ResourceMgr.Inst:AssetExist(arg0_311)
	end
else
	local var27_0 = {
		__index = {
			LoadAssetSync = function(arg0_312, ...)
				return ResourceMgr.Inst:LoadAssetSync(arg0_312.ab, ...)
			end,
			GetAllAssetNames = function(arg0_313, ...)
				return arg0_313.ab:GetAllAssetNames(...)
			end
		}
	}

	function buildTempAB(arg0_314, arg1_314)
		local var0_314 = setmetatable({
			path = arg0_314
		}, var27_0)

		if arg1_314 then
			ResourceMgr.Inst:loadAssetBundleAsync(arg0_314, function(arg0_315)
				var0_314.ab = arg0_315

				arg1_314(var0_314)
			end)
		else
			var0_314.ab = ResourceMgr.Inst:loadAssetBundleSync(arg0_314)
		end

		return var0_314
	end

	function checkABExist(arg0_316)
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_316))
	end
end
