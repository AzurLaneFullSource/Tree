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
		if var0_71.special_bgm and type(var0_71.special_bgm) == "table" and #var0_71.special_bgm > 0 and _.all(var0_71.special_bgm, function(arg0_72)
			return type(arg0_72) == "table" and #arg0_72 > 2 and type(arg0_72[2]) == "number"
		end) then
			local var1_71 = Clone(var0_71.special_bgm)

			table.sort(var1_71, function(arg0_73, arg1_73)
				return arg0_73[2] > arg1_73[2]
			end)

			local var2_71 = ""

			_.each(var1_71, function(arg0_74)
				if var2_71 ~= "" then
					return
				end

				local var0_74 = arg0_74[1]
				local var1_74 = arg0_74[3]

				switch(var0_74, {
					function()
						local var0_75 = var1_74[1]
						local var1_75 = var1_74[2]

						if #var0_75 == 1 then
							if var0_75[1] ~= "always" then
								return
							end
						elseif not pg.TimeMgr.GetInstance():inTime(var0_75) then
							return
						end

						_.each(var1_75, function(arg0_76)
							if var2_71 ~= "" then
								return
							end

							if #arg0_76 == 2 and pg.TimeMgr.GetInstance():inPeriod(arg0_76[1]) then
								var2_71 = arg0_76[2]
							elseif #arg0_76 == 3 and pg.TimeMgr.GetInstance():inPeriod(arg0_76[1], arg0_76[2]) then
								var2_71 = arg0_76[3]
							end
						end)
					end,
					function()
						local var0_77 = false
						local var1_77 = ""

						_.each(var1_74, function(arg0_78)
							if #arg0_78 ~= 2 or var0_77 then
								return
							end

							if pg.NewStoryMgr.GetInstance():IsPlayed(arg0_78[1]) then
								var2_71 = arg0_78[2]

								if var2_71 ~= "" then
									var1_77 = var2_71
								else
									var2_71 = var1_77
								end
							else
								var0_77 = true
							end
						end)
					end
				})
			end)

			return var2_71 ~= "" and var2_71 or var0_71.bgm
		else
			return var0_71 and var0_71.bgm or nil
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

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_107:getIcon(), "", var2_107)
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

	GetImageSpriteFromAtlasAsync("furnitureicon/" .. arg1_108:getIcon(), "", var2_108)
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
	local var0_110 = arg1_110:getConfig("rarity")

	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var0_110), arg0_110)

	local var1_110 = arg0_110:Find("icon")

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

function updateEmoji(arg0_119, arg1_119, arg2_119)
	local var0_119 = findTF(arg0_119, "icon_bg/icon")
	local var1_119 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_119, "", var0_119)

	local var2_119 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_119, findTF(arg0_119, "icon_bg"))
	setFrame(findTF(arg0_119, "icon_bg/frame"), var2_119)
	setIconName(arg0_119, arg1_119.name, arg2_119)
end

function updateEquipmentSkin(arg0_120, arg1_120, arg2_120)
	arg2_120 = arg2_120 or {}

	local var0_120 = EquipmentRarity.Rarity2Print(arg1_120.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_120, findTF(arg0_120, "icon_bg"))
	setFrame(findTF(arg0_120, "icon_bg/frame"), var0_120, "frame_skin")

	local var1_120 = findTF(arg0_120, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_120.icon, "", var1_120)
	setIconStars(arg0_120, false)
	setIconName(arg0_120, arg1_120.name, arg2_120)
	setIconCount(arg0_120, arg1_120.count)
	setIconColorful(arg0_120, arg1_120.rarity - 1, arg2_120)
end

function NoPosMsgBox(arg0_121, arg1_121, arg2_121, arg3_121)
	local var0_121
	local var1_121 = {}

	if arg1_121 then
		table.insert(var1_121, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_121
		})
	end

	if arg2_121 then
		table.insert(var1_121, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_121
		})
	end

	if arg3_121 then
		table.insert(var1_121, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_121
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_121,
		custom = var1_121,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_122 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_122 and var0_122.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_122
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
		local var0_123 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_123 and var0_123.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_123
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
		onClick = function(arg0_126, arg1_126)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_126.id,
				shipVOs = arg1_126
			})
		end
	})
end

function GoShoppingMsgBox(arg0_127, arg1_127, arg2_127)
	if arg2_127 then
		local var0_127 = ""

		for iter0_127, iter1_127 in ipairs(arg2_127) do
			local var1_127 = Item.getConfigData(iter1_127[1])

			var0_127 = var0_127 .. i18n(iter1_127[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_127.name, iter1_127[2])

			if iter0_127 < #arg2_127 then
				var0_127 = var0_127 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_127 ~= "" then
			arg0_127 = arg0_127 .. "\n" .. i18n("text_noRes_tip", var0_127)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_127,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_127, arg2_127)
		end
	})
end

function shoppingBatch(arg0_129, arg1_129, arg2_129, arg3_129, arg4_129)
	local var0_129 = pg.shop_template[arg0_129]

	assert(var0_129, "shop_template中找不到商品id：" .. arg0_129)

	local var1_129 = getProxy(PlayerProxy):getData()[id2res(var0_129.resource_type)]
	local var2_129 = arg1_129.price or var0_129.resource_num
	local var3_129 = math.floor(var1_129 / var2_129)

	var3_129 = var3_129 <= 0 and 1 or var3_129
	var3_129 = arg2_129 ~= nil and arg2_129 < var3_129 and arg2_129 or var3_129

	local var4_129 = true
	local var5_129 = 1

	if var0_129 ~= nil and arg1_129.id then
		print(var3_129 * var0_129.num, "--", var3_129)
		assert(Item.getConfigData(arg1_129.id), "item config should be existence")

		local var6_129 = Item.New({
			id = arg1_129.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_129.id
			},
			addNum = var0_129.num,
			maxNum = var3_129 * var0_129.num,
			defaultNum = var0_129.num,
			numUpdate = function(arg0_130, arg1_130)
				var5_129 = math.floor(arg1_130 / var0_129.num)

				local var0_130 = var5_129 * var2_129

				if var0_130 > var1_129 then
					setText(arg0_130, i18n(arg3_129, var0_130, arg1_130, COLOR_RED, var6_129))

					var4_129 = false
				else
					setText(arg0_130, i18n(arg3_129, var0_130, arg1_130, COLOR_GREEN, var6_129))

					var4_129 = true
				end
			end,
			onYes = function()
				if var4_129 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_129,
						count = var5_129
					})
				elseif arg4_129 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_129))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function gotoChargeScene(arg0_132, arg1_132)
	local var0_132 = getProxy(ContextProxy)
	local var1_132 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_132.mediator, ChargeMediator) then
		var1_132.mediator:getViewComponent():switchSubViewByTogger(arg0_132)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_132 or ChargeScene.TYPE_ITEM,
			noRes = arg1_132
		})
	end
end

function clearDrop(arg0_133)
	local var0_133 = findTF(arg0_133, "icon_bg")
	local var1_133 = findTF(arg0_133, "icon_bg/frame")
	local var2_133 = findTF(arg0_133, "icon_bg/icon")
	local var3_133 = findTF(arg0_133, "icon_bg/icon/icon")

	clearImageSprite(var0_133)
	clearImageSprite(var1_133)
	clearImageSprite(var2_133)

	if var3_133 then
		clearImageSprite(var3_133)
	end
end

local var7_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_134, arg1_134, arg2_134, arg3_134)
	local var0_134 = findTF(arg0_134, "skill")
	local var1_134 = findTF(arg0_134, "lock")
	local var2_134 = findTF(arg0_134, "unknown")

	if arg1_134 then
		setActive(var0_134, true)
		setActive(var2_134, false)
		setActive(var1_134, not arg2_134)
		LoadImageSpriteAsync("skillicon/" .. arg1_134.icon, findTF(var0_134, "icon"))

		local var3_134 = arg1_134.color or "blue"

		setText(findTF(var0_134, "name"), shortenString(getSkillName(arg1_134.id), arg3_134 or 8))

		local var4_134 = findTF(var0_134, "level")

		setText(var4_134, "LEVEL: " .. (arg2_134 and arg2_134.level or "??"))
		setTextColor(var4_134, var7_0[var3_134])
	else
		setActive(var0_134, false)
		setActive(var2_134, true)
		setActive(var1_134, false)
	end
end

local var8_0 = true

function onBackButton(arg0_135, arg1_135, arg2_135, arg3_135)
	local var0_135 = GetOrAddComponent(arg1_135, "UILongPressTrigger")

	assert(arg2_135, "callback should exist")

	var0_135.longPressThreshold = defaultValue(arg3_135, 1)

	local function var1_135(arg0_136)
		return function()
			if var8_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_137, var1_137 = arg2_135()

			if var0_137 then
				arg0_136(var1_137)
			end
		end
	end

	local var2_135 = var0_135.onReleased

	pg.DelegateInfo.Add(arg0_135, var2_135)
	var2_135:RemoveAllListeners()
	var2_135:AddListener(var1_135(function(arg0_138)
		arg0_138:emit(BaseUI.ON_BACK)
	end))

	local var3_135 = var0_135.onLongPressed

	pg.DelegateInfo.Add(arg0_135, var3_135)
	var3_135:RemoveAllListeners()
	var3_135:AddListener(var1_135(function(arg0_139)
		arg0_139:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_142)
	local var0_142 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_142, var2_142 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_142)

	return var1_142 * 86400 + (var2_142 + arg0_142) * 3600
end

function GetPerceptualSize(arg0_143)
	local function var0_143(arg0_144)
		if not arg0_144 then
			return 0, 1
		elseif arg0_144 > 240 then
			return 4, 1
		elseif arg0_144 > 225 then
			return 3, 1
		elseif arg0_144 > 192 then
			return 2, 1
		elseif arg0_144 < 126 then
			return 1, 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_143) == "number" then
		return var0_143(arg0_143)
	end

	local var1_143 = 1
	local var2_143 = 0
	local var3_143 = 0
	local var4_143 = #arg0_143

	while var1_143 <= var4_143 do
		local var5_143 = string.byte(arg0_143, var1_143)
		local var6_143, var7_143 = var0_143(var5_143)

		var1_143 = var1_143 + var6_143
		var2_143 = var2_143 + var7_143
	end

	return var2_143
end

function shortenString(arg0_145, arg1_145)
	local var0_145 = 1
	local var1_145 = 0
	local var2_145 = 0
	local var3_145 = #arg0_145

	while var0_145 <= var3_145 do
		local var4_145 = string.byte(arg0_145, var0_145)
		local var5_145, var6_145 = GetPerceptualSize(var4_145)

		var0_145 = var0_145 + var5_145
		var1_145 = var1_145 + var6_145

		if arg1_145 <= math.ceil(var1_145) then
			var2_145 = var0_145

			break
		end
	end

	if var2_145 == 0 or var3_145 < var2_145 then
		return arg0_145
	end

	return string.sub(arg0_145, 1, var2_145 - 1) .. ".."
end

function shouldShortenString(arg0_146, arg1_146)
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
		return false
	end

	return true
end

function nameValidityCheck(arg0_147, arg1_147, arg2_147, arg3_147)
	local var0_147 = true
	local var1_147, var2_147 = utf8_to_unicode(arg0_147)
	local var3_147 = filterEgyUnicode(filterSpecChars(arg0_147))
	local var4_147 = wordVer(arg0_147)

	if not checkSpaceValid(arg0_147) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_147[1]))

		var0_147 = false
	elseif var4_147 > 0 or var3_147 ~= arg0_147 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_147[4]))

		var0_147 = false
	elseif var2_147 < arg1_147 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_147[2]))

		var0_147 = false
	elseif arg2_147 < var2_147 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_147[3]))

		var0_147 = false
	end

	return var0_147
end

function checkSpaceValid(arg0_148)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_148 = string.gsub(arg0_148, " ", "")

	return arg0_148 == string.gsub(var0_148, "　", "")
end

function filterSpecChars(arg0_149)
	local var0_149 = {}
	local var1_149 = 0
	local var2_149 = 0
	local var3_149 = 0
	local var4_149 = 1

	while var4_149 <= #arg0_149 do
		local var5_149 = string.byte(arg0_149, var4_149)

		if not var5_149 then
			break
		end

		if var5_149 >= 48 and var5_149 <= 57 or var5_149 >= 65 and var5_149 <= 90 or var5_149 == 95 or var5_149 >= 97 and var5_149 <= 122 then
			table.insert(var0_149, string.char(var5_149))
		elseif var5_149 >= 228 and var5_149 <= 233 then
			local var6_149 = string.byte(arg0_149, var4_149 + 1)
			local var7_149 = string.byte(arg0_149, var4_149 + 2)

			if var6_149 and var7_149 and var6_149 >= 128 and var6_149 <= 191 and var7_149 >= 128 and var7_149 <= 191 then
				var4_149 = var4_149 + 2

				table.insert(var0_149, string.char(var5_149, var6_149, var7_149))

				var1_149 = var1_149 + 1
			end
		elseif var5_149 == 45 or var5_149 == 40 or var5_149 == 41 then
			table.insert(var0_149, string.char(var5_149))
		elseif var5_149 == 194 then
			local var8_149 = string.byte(arg0_149, var4_149 + 1)

			if var8_149 == 183 then
				var4_149 = var4_149 + 1

				table.insert(var0_149, string.char(var5_149, var8_149))

				var1_149 = var1_149 + 1
			end
		elseif var5_149 == 239 then
			local var9_149 = string.byte(arg0_149, var4_149 + 1)
			local var10_149 = string.byte(arg0_149, var4_149 + 2)

			if var9_149 == 188 and (var10_149 == 136 or var10_149 == 137) then
				var4_149 = var4_149 + 2

				table.insert(var0_149, string.char(var5_149, var9_149, var10_149))

				var1_149 = var1_149 + 1
			end
		elseif var5_149 == 206 or var5_149 == 207 then
			local var11_149 = string.byte(arg0_149, var4_149 + 1)

			if var5_149 == 206 and var11_149 >= 177 or var5_149 == 207 and var11_149 <= 134 then
				var4_149 = var4_149 + 1

				table.insert(var0_149, string.char(var5_149, var11_149))

				var1_149 = var1_149 + 1
			end
		elseif var5_149 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_149 = string.byte(arg0_149, var4_149 + 1)
			local var13_149 = string.byte(arg0_149, var4_149 + 2)

			if var12_149 and var13_149 and var12_149 > 128 and var12_149 <= 191 and var13_149 >= 128 and var13_149 <= 191 then
				var4_149 = var4_149 + 2

				table.insert(var0_149, string.char(var5_149, var12_149, var13_149))

				var2_149 = var2_149 + 1
			end
		elseif var5_149 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_149 = string.byte(arg0_149, var4_149 + 1)
			local var15_149 = string.byte(arg0_149, var4_149 + 2)

			if var14_149 and var15_149 and var14_149 >= 128 and var14_149 <= 191 and var15_149 >= 128 and var15_149 <= 191 then
				var4_149 = var4_149 + 2

				table.insert(var0_149, string.char(var5_149, var14_149, var15_149))

				var3_149 = var3_149 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_149 ~= 1 and var5_149 == 32 and string.byte(arg0_149, var4_149 + 1) ~= 32 then
				table.insert(var0_149, string.char(var5_149))
			end

			if var5_149 >= 192 and var5_149 <= 223 then
				local var16_149 = string.byte(arg0_149, var4_149 + 1)

				var4_149 = var4_149 + 1

				if var5_149 == 194 and var16_149 and var16_149 >= 128 then
					table.insert(var0_149, string.char(var5_149, var16_149))
				elseif var5_149 == 195 and var16_149 and var16_149 <= 191 then
					table.insert(var0_149, string.char(var5_149, var16_149))
				end
			end

			if var5_149 == 195 then
				local var17_149 = string.byte(arg0_149, var4_149 + 1)

				if var17_149 == 188 then
					table.insert(var0_149, string.char(var5_149, var17_149))
				end
			end
		end

		var4_149 = var4_149 + 1
	end

	return table.concat(var0_149), var1_149 + var2_149 + var3_149
end

function filterEgyUnicode(arg0_150)
	arg0_150 = string.gsub(arg0_150, "�[�-�][�-�]", "")
	arg0_150 = string.gsub(arg0_150, "�[�-�]", "")

	return arg0_150
end

function shiftPanel(arg0_151, arg1_151, arg2_151, arg3_151, arg4_151, arg5_151, arg6_151, arg7_151, arg8_151)
	arg3_151 = arg3_151 or 0.2

	if arg5_151 then
		LeanTween.cancel(go(arg0_151))
	end

	local var0_151 = rtf(arg0_151)

	arg1_151 = arg1_151 or var0_151.anchoredPosition.x
	arg2_151 = arg2_151 or var0_151.anchoredPosition.y

	local var1_151 = LeanTween.move(var0_151, Vector3(arg1_151, arg2_151, 0), arg3_151)

	arg7_151 = arg7_151 or LeanTweenType.easeInOutSine

	var1_151:setEase(arg7_151)

	if arg4_151 then
		var1_151:setDelay(arg4_151)
	end

	if arg6_151 then
		GetOrAddComponent(arg0_151, "CanvasGroup").blocksRaycasts = false
	end

	var1_151:setOnComplete(System.Action(function()
		if arg8_151 then
			arg8_151()
		end

		if arg6_151 then
			GetOrAddComponent(arg0_151, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_151
end

function TweenValue(arg0_153, arg1_153, arg2_153, arg3_153, arg4_153, arg5_153, arg6_153, arg7_153)
	local var0_153 = LeanTween.value(go(arg0_153), arg1_153, arg2_153, arg3_153):setOnUpdate(System.Action_float(function(arg0_154)
		if arg5_153 then
			arg5_153(arg0_154)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_153 then
			arg6_153()
		end
	end)):setDelay(arg4_153 or 0)

	if arg7_153 and arg7_153 > 0 then
		var0_153:setRepeat(arg7_153)
	end

	return var0_153
end

function rotateAni(arg0_156, arg1_156, arg2_156)
	return LeanTween.rotate(rtf(arg0_156), 360 * arg1_156, arg2_156):setLoopClamp()
end

function blinkAni(arg0_157, arg1_157, arg2_157, arg3_157)
	return LeanTween.alpha(rtf(arg0_157), arg3_157 or 0, arg1_157):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_157 or 0)
end

function scaleAni(arg0_158, arg1_158, arg2_158, arg3_158)
	return LeanTween.scale(rtf(arg0_158), arg3_158 or 0, arg1_158):setLoopPingPong(arg2_158 or 0)
end

function floatAni(arg0_159, arg1_159, arg2_159, arg3_159)
	local var0_159 = arg0_159.localPosition.y + arg1_159

	return LeanTween.moveY(rtf(arg0_159), var0_159, arg2_159):setLoopPingPong(arg3_159 or 0)
end

local var9_0 = tostring

function tostring(arg0_160)
	if arg0_160 == nil then
		return "nil"
	end

	local var0_160 = var9_0(arg0_160)

	if var0_160 == nil then
		if type(arg0_160) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_160
end

function wordVer(arg0_161, arg1_161)
	if arg0_161.match(arg0_161, ChatConst.EmojiCodeMatch) then
		return 0, arg0_161
	end

	arg1_161 = arg1_161 or {}

	local var0_161 = filterEgyUnicode(arg0_161)

	if #var0_161 ~= #arg0_161 then
		if arg1_161.isReplace then
			arg0_161 = var0_161
		else
			return 1
		end
	end

	local var1_161 = wordSplit(arg0_161)
	local var2_161 = pg.word_template
	local var3_161 = pg.word_legal_template

	arg1_161.isReplace = arg1_161.isReplace or false
	arg1_161.replaceWord = arg1_161.replaceWord or "*"

	local var4_161 = #var1_161
	local var5_161 = 1
	local var6_161 = ""
	local var7_161 = 0

	while var5_161 <= var4_161 do
		local var8_161, var9_161, var10_161 = wordLegalMatch(var1_161, var3_161, var5_161)

		if var8_161 then
			var5_161 = var9_161
			var6_161 = var6_161 .. var10_161
		else
			local var11_161, var12_161, var13_161 = wordVerMatch(var1_161, var2_161, arg1_161, var5_161, "", false, var5_161, "")

			if var11_161 then
				var5_161 = var12_161
				var7_161 = var7_161 + 1

				if arg1_161.isReplace then
					var6_161 = var6_161 .. var13_161
				end
			else
				if arg1_161.isReplace then
					var6_161 = var6_161 .. var1_161[var5_161]
				end

				var5_161 = var5_161 + 1
			end
		end
	end

	if arg1_161.isReplace then
		return var7_161, var6_161
	else
		return var7_161
	end
end

function wordLegalMatch(arg0_162, arg1_162, arg2_162, arg3_162, arg4_162)
	if arg2_162 > #arg0_162 then
		return arg3_162, arg2_162, arg4_162
	end

	local var0_162 = arg0_162[arg2_162]
	local var1_162 = arg1_162[var0_162]

	arg4_162 = arg4_162 == nil and "" or arg4_162

	if var1_162 then
		if var1_162.this then
			return wordLegalMatch(arg0_162, var1_162, arg2_162 + 1, true, arg4_162 .. var0_162)
		else
			return wordLegalMatch(arg0_162, var1_162, arg2_162 + 1, false, arg4_162 .. var0_162)
		end
	else
		return arg3_162, arg2_162, arg4_162
	end
end

local var10_0 = string.byte("a")
local var11_0 = string.byte("z")
local var12_0 = string.byte("A")
local var13_0 = string.byte("Z")

local function var14_0(arg0_163)
	if not arg0_163 then
		return arg0_163
	end

	local var0_163 = string.byte(arg0_163)

	if var0_163 > 128 then
		return
	end

	if var0_163 >= var10_0 and var0_163 <= var11_0 then
		return string.char(var0_163 - 32)
	elseif var0_163 >= var12_0 and var0_163 <= var13_0 then
		return string.char(var0_163 + 32)
	else
		return arg0_163
	end
end

function wordVerMatch(arg0_164, arg1_164, arg2_164, arg3_164, arg4_164, arg5_164, arg6_164, arg7_164)
	if arg3_164 > #arg0_164 then
		return arg5_164, arg6_164, arg7_164
	end

	local var0_164 = arg0_164[arg3_164]
	local var1_164 = arg1_164[var0_164]

	if var1_164 then
		local var2_164, var3_164, var4_164 = wordVerMatch(arg0_164, var1_164, arg2_164, arg3_164 + 1, arg2_164.isReplace and arg4_164 .. arg2_164.replaceWord or arg4_164, var1_164.this or arg5_164, var1_164.this and arg3_164 + 1 or arg6_164, var1_164.this and (arg2_164.isReplace and arg4_164 .. arg2_164.replaceWord or arg4_164) or arg7_164)

		if var2_164 then
			return var2_164, var3_164, var4_164
		end
	end

	local var5_164 = var14_0(var0_164)
	local var6_164 = arg1_164[var5_164]

	if var5_164 ~= var0_164 and var6_164 then
		local var7_164, var8_164, var9_164 = wordVerMatch(arg0_164, var6_164, arg2_164, arg3_164 + 1, arg2_164.isReplace and arg4_164 .. arg2_164.replaceWord or arg4_164, var6_164.this or arg5_164, var6_164.this and arg3_164 + 1 or arg6_164, var6_164.this and (arg2_164.isReplace and arg4_164 .. arg2_164.replaceWord or arg4_164) or arg7_164)

		if var7_164 then
			return var7_164, var8_164, var9_164
		end
	end

	return arg5_164, arg6_164, arg7_164
end

function wordSplit(arg0_165)
	local var0_165 = {}

	for iter0_165 in arg0_165.gmatch(arg0_165, "[\x01-\x7F�-�][�-�]*") do
		var0_165[#var0_165 + 1] = iter0_165
	end

	return var0_165
end

function contentWrap(arg0_166, arg1_166, arg2_166)
	local var0_166 = LuaHelper.WrapContent(arg0_166, arg1_166, arg2_166)

	return #var0_166 ~= #arg0_166, var0_166
end

function cancelRich(arg0_167)
	local var0_167

	for iter0_167 = 1, 20 do
		local var1_167

		arg0_167, var1_167 = string.gsub(arg0_167, "<([^>]*)>", "%1")

		if var1_167 <= 0 then
			break
		end
	end

	return arg0_167
end

function getSkillConfig(arg0_168)
	local var0_168 = require("GameCfg.buff.buff_" .. arg0_168)

	if not var0_168 then
		warning("找不到技能配置: " .. arg0_168)

		return
	end

	local var1_168 = Clone(var0_168)

	var1_168.name = getSkillName(arg0_168)
	var1_168.desc = HXSet.hxLan(var1_168.desc)
	var1_168.desc_get = HXSet.hxLan(var1_168.desc_get)

	_.each(var1_168, function(arg0_169)
		arg0_169.desc = HXSet.hxLan(arg0_169.desc)
	end)

	return var1_168
end

function getSkillName(arg0_170)
	local var0_170 = pg.skill_data_template[arg0_170] or pg.skill_data_display[arg0_170]

	if var0_170 then
		return HXSet.hxLan(var0_170.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_171, arg1_171)
	local var0_171 = arg1_171 and pg.skill_world_display[arg0_171] and setmetatable({}, {
		__index = function(arg0_172, arg1_172)
			return pg.skill_world_display[arg0_171][arg1_172] or pg.skill_data_template[arg0_171][arg1_172]
		end
	}) or pg.skill_data_template[arg0_171]

	if not var0_171 then
		return ""
	end

	local var1_171 = var0_171.desc_get ~= "" and var0_171.desc_get or var0_171.desc

	for iter0_171, iter1_171 in pairs(var0_171.desc_get_add) do
		local var2_171 = setColorStr(iter1_171[1], COLOR_GREEN)

		if iter1_171[2] then
			var2_171 = var2_171 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_171[2], COLOR_GREEN))
		end

		var1_171 = specialGSub(var1_171, "$" .. iter0_171, var2_171)
	end

	return HXSet.hxLan(var1_171)
end

function getSkillDescLearn(arg0_173, arg1_173, arg2_173)
	local var0_173 = arg2_173 and pg.skill_world_display[arg0_173] and setmetatable({}, {
		__index = function(arg0_174, arg1_174)
			return pg.skill_world_display[arg0_173][arg1_174] or pg.skill_data_template[arg0_173][arg1_174]
		end
	}) or pg.skill_data_template[arg0_173]

	if not var0_173 then
		return ""
	end

	local var1_173 = var0_173.desc

	if not var0_173.desc_add then
		return HXSet.hxLan(var1_173)
	end

	for iter0_173, iter1_173 in pairs(var0_173.desc_add) do
		local var2_173 = iter1_173[arg1_173][1]

		if iter1_173[arg1_173][2] then
			var2_173 = var2_173 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_173[arg1_173][2])
		end

		var1_173 = specialGSub(var1_173, "$" .. iter0_173, setColorStr(var2_173, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_173)
end

function getSkillDesc(arg0_175, arg1_175, arg2_175)
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
		local var2_175 = setColorStr(iter1_175[arg1_175][1], COLOR_GREEN)

		var1_175 = specialGSub(var1_175, "$" .. iter0_175, var2_175)
	end

	return HXSet.hxLan(var1_175)
end

function specialGSub(arg0_177, arg1_177, arg2_177)
	arg0_177 = string.gsub(arg0_177, "<color=#", "<color=NNN")
	arg0_177 = string.gsub(arg0_177, "#", "")
	arg2_177 = string.gsub(arg2_177, "%%", "%%%%")
	arg0_177 = string.gsub(arg0_177, arg1_177, arg2_177)
	arg0_177 = string.gsub(arg0_177, "<color=NNN", "<color=#")

	return arg0_177
end

function topAnimation(arg0_178, arg1_178, arg2_178, arg3_178, arg4_178, arg5_178)
	local var0_178 = {}

	arg4_178 = arg4_178 or 0.27

	local var1_178 = 0.05

	if arg0_178 then
		local var2_178 = arg0_178.transform.localPosition.x

		setAnchoredPosition(arg0_178, {
			x = var2_178 - 500
		})
		shiftPanel(arg0_178, var2_178, nil, 0.05, arg4_178, true, true)
		setActive(arg0_178, true)
	end

	setActive(arg1_178, false)
	setActive(arg2_178, false)
	setActive(arg3_178, false)

	for iter0_178 = 1, 3 do
		table.insert(var0_178, LeanTween.delayedCall(arg4_178 + 0.13 + var1_178 * iter0_178, System.Action(function()
			if arg1_178 then
				setActive(arg1_178, not arg1_178.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_178, LeanTween.delayedCall(arg4_178 + 0.02 + var1_178 * iter0_178, System.Action(function()
			if arg2_178 then
				setActive(arg2_178, not go(arg2_178).activeSelf)
			end

			if arg2_178 then
				setActive(arg3_178, not go(arg3_178).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_178 then
		table.insert(var0_178, LeanTween.delayedCall(arg4_178 + 0.13 + var1_178 * 3 + 0.1, System.Action(function()
			arg5_178()
		end)).uniqueId)
	end

	return var0_178
end

function cancelTweens(arg0_182)
	assert(arg0_182, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_182, iter1_182 in ipairs(arg0_182) do
		if iter1_182 then
			LeanTween.cancel(iter1_182)
		end
	end
end

function getOfflineTimeStamp(arg0_183)
	local var0_183 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_183
	local var1_183 = ""

	if var0_183 <= 59 then
		var1_183 = i18n("just_now")
	elseif var0_183 <= 3599 then
		var1_183 = i18n("several_minutes_before", math.floor(var0_183 / 60))
	elseif var0_183 <= 86399 then
		var1_183 = i18n("several_hours_before", math.floor(var0_183 / 3600))
	else
		var1_183 = i18n("several_days_before", math.floor(var0_183 / 86400))
	end

	return var1_183
end

function playMovie(arg0_184, arg1_184, arg2_184)
	local var0_184 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_184) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_184, function(arg0_185)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_185 = GCHandle.Alloc(arg0_185, GCHandleType.Pinned)

			setActive(var0_184, true)

			local var1_185 = var0_184:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_185.player:SetData(arg0_185, arg0_185.Length)

			var1_185.target = var0_184:GetComponent(typeof(Image))
			var1_185.loop = false
			var1_185.additiveMode = false
			var1_185.playOnStart = true

			local var2_185

			var2_185 = Timer.New(function()
				if var1_185.player.status == CriMana.Player.Status.PlayEnd or var1_185.player.status == CriMana.Player.Status.Stop or var1_185.player.status == CriMana.Player.Status.Error then
					var2_185:Stop()
					Object.Destroy(var1_185)
					GCHandle.Free(var0_185)
					setActive(var0_184, false)

					if arg1_184 then
						arg1_184()
					end
				end
			end, 0.2, -1)

			var2_185:Start()
			removeOnButton(var0_184)

			if arg2_184 then
				onButton(nil, var0_184, function()
					var1_185:Stop()
					GetOrAddComponent(var0_184, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_184 then
		arg1_184()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_188)
	if PaintCameraAdjustOn ~= arg0_188 then
		local var0_188 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_188 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0_188.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_188.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0_188.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0_188
	end
end

function ManhattonDist(arg0_189, arg1_189)
	return math.abs(arg0_189.row - arg1_189.row) + math.abs(arg0_189.column - arg1_189.column)
end

function checkFirstHelpShow(arg0_190)
	local var0_190 = getProxy(SettingsProxy)

	if not var0_190:checkReadHelp(arg0_190) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_190].tip
		})
		var0_190:recordReadHelp(arg0_190)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_191)
	enableNotch(arg0_191, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_192)
	enableNotch(arg0_192, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_192 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_194, arg1_194)
	if arg0_194 == nil then
		return
	end

	local var0_194 = arg0_194:GetComponent("NotchAdapt")
	local var1_194 = arg0_194:GetComponent("AspectRatioFitter")

	var0_194.enabled = arg1_194

	if var1_194 then
		if arg1_194 then
			var1_194.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1_194.enabled
			var1_194.enabled = false
		end
	end
end

function comma_value(arg0_195)
	local var0_195 = arg0_195
	local var1_195 = 0

	repeat
		local var2_195

		var0_195, var2_195 = string.gsub(var0_195, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_195 == 0

	return var0_195
end

local var15_0 = 0.2

function SwitchPanel(arg0_196, arg1_196, arg2_196, arg3_196, arg4_196, arg5_196)
	arg3_196 = defaultValue(arg3_196, var15_0)

	if arg5_196 then
		LeanTween.cancel(go(arg0_196))
	end

	local var0_196 = Vector3.New(tf(arg0_196).localPosition.x, tf(arg0_196).localPosition.y, tf(arg0_196).localPosition.z)

	if arg1_196 then
		var0_196.x = arg1_196
	end

	if arg2_196 then
		var0_196.y = arg2_196
	end

	local var1_196 = LeanTween.move(rtf(arg0_196), var0_196, arg3_196):setEase(LeanTweenType.easeInOutSine)

	if arg4_196 then
		var1_196:setDelay(arg4_196)
	end

	return var1_196
end

function updateActivityTaskStatus(arg0_197)
	local var0_197 = arg0_197:getConfig("config_id")
	local var1_197, var2_197 = getActivityTask(arg0_197, true)

	if not var2_197 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_197.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_198)
	local var0_198 = getProxy(TaskProxy)
	local var1_198 = arg0_198:getNDay()

	for iter0_198, iter1_198 in ipairs(arg0_198:getConfig("config_data")) do
		local var2_198 = pg.battlepass_task_group[iter1_198]

		if var1_198 >= var2_198.time and underscore.any(underscore.flatten(var2_198.task_group), function(arg0_199)
			return var0_198:getTaskVO(arg0_199) == nil
		end) then
			pg.m02:sendNotification(GAME.CRUSING_CMD, {
				cmd = 1,
				activity_id = arg0_198.id
			})

			return true
		end
	end

	return false
end

function setShipCardFrame(arg0_200, arg1_200, arg2_200)
	arg0_200.localScale = Vector3.one
	arg0_200.anchorMin = Vector2.zero
	arg0_200.anchorMax = Vector2.one

	local var0_200 = arg2_200 or arg1_200

	GetImageSpriteFromAtlasAsync("shipframe", var0_200, arg0_200)

	local var1_200 = pg.frame_resource[var0_200]

	if var1_200 then
		local var2_200 = var1_200.param

		arg0_200.offsetMin = Vector2(var2_200[1], var2_200[2])
		arg0_200.offsetMax = Vector2(var2_200[3], var2_200[4])
	else
		arg0_200.offsetMin = Vector2.zero
		arg0_200.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_201, arg1_201, arg2_201)
	arg0_201.localScale = Vector3.one
	arg0_201.anchorMin = Vector2.zero
	arg0_201.anchorMax = Vector2.one

	setImageSprite(arg0_201, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_201 or arg1_201)))

	local var0_201 = "b" .. (arg2_201 or arg1_201)
	local var1_201 = pg.frame_resource[var0_201]

	if var1_201 then
		local var2_201 = var1_201.param

		arg0_201.offsetMin = Vector2(var2_201[1], var2_201[2])
		arg0_201.offsetMax = Vector2(var2_201[3], var2_201[4])
	else
		arg0_201.offsetMin = Vector2.zero
		arg0_201.offsetMax = Vector2.zero
	end
end

function setFrameEffect(arg0_202, arg1_202)
	if arg1_202 then
		local var0_202 = arg1_202 .. "(Clone)"
		local var1_202 = false

		eachChild(arg0_202, function(arg0_203)
			setActive(arg0_203, arg0_203.name == var0_202)

			var1_202 = var1_202 or arg0_203.name == var0_202
		end)

		if not var1_202 then
			LoadAndInstantiateAsync("effect", arg1_202, function(arg0_204)
				if IsNil(arg0_202) or findTF(arg0_202, var0_202) then
					Object.Destroy(arg0_204)
				else
					setParent(arg0_204, arg0_202)
					setActive(arg0_204, true)
				end
			end)
		end
	end

	setActive(arg0_202, arg1_202)
end

function setProposeMarkIcon(arg0_205, arg1_205)
	local var0_205 = arg0_205:Find("proposeShipCard(Clone)")
	local var1_205 = arg1_205.propose and not arg1_205:ShowPropose()

	if var0_205 then
		setActive(var0_205, var1_205)
	elseif var1_205 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_206)
			if IsNil(arg0_205) or arg0_205:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_206)
			else
				setParent(arg0_206, arg0_205, false)
			end
		end)
	end
end

function flushShipCard(arg0_207, arg1_207)
	local var0_207 = arg1_207:rarity2bgPrint()
	local var1_207 = findTF(arg0_207, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_207, "", var1_207)

	local var2_207 = findTF(arg0_207, "content/ship_icon")
	local var3_207 = arg1_207 and {
		"shipYardIcon/" .. arg1_207:getPainting(),
		arg1_207:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_207[1], var3_207[2], var2_207)

	local var4_207 = arg1_207:getShipType()
	local var5_207 = findTF(arg0_207, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_207), var5_207)
	setText(findTF(arg0_207, "content/dockyard/lv/Text"), defaultValue(arg1_207.level, 1))

	local var6_207 = arg1_207:getStar()
	local var7_207 = arg1_207:getMaxStar()
	local var8_207 = findTF(arg0_207, "content/front/stars")

	setActive(var8_207, true)

	local var9_207 = findTF(var8_207, "star_tpl")
	local var10_207 = var8_207.childCount

	for iter0_207 = 1, Ship.CONFIG_MAX_STAR do
		local var11_207 = var10_207 < iter0_207 and cloneTplTo(var9_207, var8_207) or var8_207:GetChild(iter0_207 - 1)

		setActive(var11_207, iter0_207 <= var7_207)
		triggerToggle(var11_207, iter0_207 <= var6_207)
	end

	local var12_207 = findTF(arg0_207, "content/front/frame")
	local var13_207, var14_207 = arg1_207:GetFrameAndEffect()

	setShipCardFrame(var12_207, var0_207, var13_207)
	setFrameEffect(findTF(arg0_207, "content/front/bg_other"), var14_207)
	setProposeMarkIcon(arg0_207:Find("content/dockyard/propose"), arg1_207)
end

function TweenItemAlphaAndWhite(arg0_208)
	LeanTween.cancel(arg0_208)

	local var0_208 = GetOrAddComponent(arg0_208, "CanvasGroup")

	var0_208.alpha = 0

	LeanTween.alphaCanvas(var0_208, 1, 0.2):setUseEstimatedTime(true)

	local var1_208 = findTF(arg0_208.transform, "white_mask")

	if var1_208 then
		setActive(var1_208, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_209)
	LeanTween.cancel(arg0_209)

	GetOrAddComponent(arg0_209, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_210)
	local var0_210 = {}
	local var1_210 = getProxy(ShipSkinProxy):getSkinList()
	local var2_210 = getProxy(CollectionProxy):getShipGroup(arg0_210)

	if var2_210 then
		local var3_210 = ShipGroup.getSkinList(arg0_210)

		for iter0_210, iter1_210 in ipairs(var3_210) do
			if iter1_210.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_210, iter1_210.id) or iter1_210.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_210.trans or iter1_210.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_210.married == 1 then
				var0_210[iter1_210.id] = true
			end
		end
	end

	return var0_210
end

function split(arg0_211, arg1_211)
	local var0_211 = {}

	if not arg0_211 then
		return nil
	end

	local var1_211 = #arg0_211
	local var2_211 = 1

	while var2_211 <= var1_211 do
		local var3_211 = string.find(arg0_211, arg1_211, var2_211)

		if var3_211 == nil then
			table.insert(var0_211, string.sub(arg0_211, var2_211, var1_211))

			break
		end

		table.insert(var0_211, string.sub(arg0_211, var2_211, var3_211 - 1))

		if var3_211 == var1_211 then
			table.insert(var0_211, "")

			break
		end

		var2_211 = var3_211 + 1
	end

	return var0_211
end

function NumberToChinese(arg0_212, arg1_212)
	local var0_212 = ""
	local var1_212 = #arg0_212

	for iter0_212 = 1, var1_212 do
		local var2_212 = string.sub(arg0_212, iter0_212, iter0_212)

		if var2_212 ~= "0" or var2_212 == "0" and not arg1_212 then
			if arg1_212 then
				if var1_212 >= 2 then
					if iter0_212 == 1 then
						if var2_212 == "1" then
							var0_212 = i18n("number_" .. 10)
						else
							var0_212 = i18n("number_" .. var2_212) .. i18n("number_" .. 10)
						end
					else
						var0_212 = var0_212 .. i18n("number_" .. var2_212)
					end
				else
					var0_212 = var0_212 .. i18n("number_" .. var2_212)
				end
			else
				var0_212 = var0_212 .. i18n("number_" .. var2_212)
			end
		end
	end

	return var0_212
end

function getActivityTask(arg0_213, arg1_213)
	local var0_213 = getProxy(TaskProxy)
	local var1_213 = arg0_213:getConfig("config_data")
	local var2_213 = arg0_213:getNDay(arg0_213.data1)
	local var3_213
	local var4_213
	local var5_213

	for iter0_213 = math.max(arg0_213.data3, 1), math.min(var2_213, #var1_213) do
		local var6_213 = _.flatten({
			var1_213[iter0_213]
		})

		for iter1_213, iter2_213 in ipairs(var6_213) do
			local var7_213 = var0_213:getTaskById(iter2_213)

			if var7_213 then
				return var7_213.id, var7_213
			end

			if var4_213 then
				var5_213 = var0_213:getFinishTaskById(iter2_213)

				if var5_213 then
					var4_213 = var5_213
				elseif arg1_213 then
					return iter2_213
				else
					return var4_213.id, var4_213
				end
			else
				var4_213 = var0_213:getFinishTaskById(iter2_213)
				var5_213 = var5_213 or iter2_213
			end
		end
	end

	if var4_213 then
		return var4_213.id, var4_213
	else
		return var5_213
	end
end

function setImageFromImage(arg0_214, arg1_214, arg2_214)
	local var0_214 = GetComponent(arg0_214, "Image")

	var0_214.sprite = GetComponent(arg1_214, "Image").sprite

	if arg2_214 then
		var0_214:SetNativeSize()
	end
end

function skinTimeStamp(arg0_215)
	local var0_215, var1_215, var2_215, var3_215 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_215)

	if var0_215 >= 1 then
		return i18n("limit_skin_time_day", var0_215)
	elseif var0_215 <= 0 and var1_215 > 0 then
		return i18n("limit_skin_time_day_min", var1_215, var2_215)
	elseif var0_215 <= 0 and var1_215 <= 0 and (var2_215 > 0 or var3_215 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_215, 1))
	elseif var0_215 <= 0 and var1_215 <= 0 and var2_215 <= 0 and var3_215 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_216)
	local var0_216 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_216 = math.max(arg0_216 - var0_216, 0)
	local var2_216 = math.floor(var1_216 / 86400)

	if var2_216 > 0 then
		return i18n("time_remaining_tip") .. var2_216 .. i18n("word_date")
	else
		local var3_216 = math.floor(var1_216 / 3600)

		if var3_216 > 0 then
			return i18n("time_remaining_tip") .. var3_216 .. i18n("word_hour")
		else
			local var4_216 = math.floor(var1_216 / 60)

			if var4_216 > 0 then
				return i18n("time_remaining_tip") .. var4_216 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_216 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_217)
	local var0_217 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_217
	local var1_217 = var0_217 / 86400

	if var1_217 > 1 then
		return i18n("ins_word_day", math.floor(var1_217))
	else
		local var2_217 = var0_217 / 3600

		if var2_217 > 1 then
			return i18n("ins_word_hour", math.floor(var2_217))
		else
			local var3_217 = var0_217 / 60

			if var3_217 > 1 then
				return i18n("ins_word_minu", math.floor(var3_217))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_218)
	local var0_218 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_218
	local var1_218 = var0_218 / 86400

	if var1_218 > 1 then
		return i18n1(math.floor(var1_218) .. "d")
	else
		local var2_218 = var0_218 / 3600

		if var2_218 > 1 then
			return i18n1(math.floor(var2_218) .. "h")
		else
			local var3_218 = var0_218 / 60

			if var3_218 > 1 then
				return i18n1(math.floor(var3_218) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_219)
	local var0_219, var1_219, var2_219, var3_219 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_219)

	if var0_219 <= 0 and var1_219 <= 0 and var2_219 <= 0 and var3_219 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_219, var1_219, var2_219)
	end
end

function checkExist(arg0_220, ...)
	local var0_220 = {
		...
	}

	for iter0_220, iter1_220 in ipairs(var0_220) do
		if arg0_220 == nil then
			break
		end

		assert(type(arg0_220) == "table", "type error : intermediate target should be table")
		assert(type(iter1_220) == "table", "type error : param should be table")

		if type(arg0_220[iter1_220[1]]) == "function" then
			arg0_220 = arg0_220[iter1_220[1]](arg0_220, unpack(iter1_220[2] or {}))
		else
			arg0_220 = arg0_220[iter1_220[1]]
		end
	end

	return arg0_220
end

function AcessWithinNull(arg0_221, arg1_221)
	if arg0_221 == nil then
		return
	end

	assert(type(arg0_221) == "table")

	return arg0_221[arg1_221]
end

function showRepairMsgbox()
	local var0_222 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_222 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_222 = {
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
			var2_222,
			var1_222,
			var0_222
		}
	})
end

function resourceVerify(arg0_226, arg1_226)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_226 = Application.persistentDataPath .. "/hashes.csv"
	local var1_226
	local var2_226 = PathMgr.ReadAllLines(var0_226)
	local var3_226 = {}

	if arg0_226 then
		setActive(arg0_226, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_226()
		if arg0_226 then
			setActive(arg0_226, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_226)

		if var1_226 then
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

	local var5_226 = var2_226.Length
	local var6_226

	local function var7_226(arg0_229)
		if arg0_229 < 0 then
			var4_226()

			return
		end

		if arg1_226 then
			setSlider(arg1_226, 0, var5_226, var5_226 - arg0_229)
		end

		local var0_229 = string.split(var2_226[arg0_229], ",")
		local var1_229 = var0_229[1]
		local var2_229 = var0_229[3]
		local var3_229 = PathMgr.getAssetBundle(var1_229)

		if PathMgr.FileExists(var3_229) then
			local var4_229 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_229))

			if var2_229 == HashUtil.CalcMD5(var4_229) then
				onNextTick(function()
					var7_226(arg0_229 - 1)
				end)

				return
			end
		end

		var1_226 = var1_229

		var4_226()
	end

	var7_226(var5_226 - 1)
end

function splitByWordEN(arg0_231, arg1_231)
	local var0_231 = string.split(arg0_231, " ")
	local var1_231 = ""
	local var2_231 = ""
	local var3_231 = arg1_231:GetComponent(typeof(RectTransform))
	local var4_231 = arg1_231:GetComponent(typeof(Text))
	local var5_231 = var3_231.rect.width

	for iter0_231, iter1_231 in ipairs(var0_231) do
		local var6_231 = var2_231

		var2_231 = var2_231 == "" and iter1_231 or var2_231 .. " " .. iter1_231

		setText(arg1_231, var2_231)

		if var5_231 < var4_231.preferredWidth then
			var1_231 = var1_231 == "" and var6_231 or var1_231 .. "\n" .. var6_231
			var2_231 = iter1_231
		end

		if iter0_231 >= #var0_231 then
			var1_231 = var1_231 == "" and var2_231 or var1_231 .. "\n" .. var2_231
		end
	end

	return var1_231
end

function checkBirthFormat(arg0_232)
	if #arg0_232 ~= 8 then
		return false
	end

	local var0_232 = 0
	local var1_232 = #arg0_232

	while var0_232 < var1_232 do
		local var2_232 = string.byte(arg0_232, var0_232 + 1)

		if var2_232 < 48 or var2_232 > 57 then
			return false
		end

		var0_232 = var0_232 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_233)
	local var0_233 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_233, function(arg0_234)
		return arg0_234 == arg0_233
	end)
end

function GetServerState(arg0_235)
	local var0_235 = -1
	local var1_235 = 0
	local var2_235 = 1
	local var3_235 = 2
	local var4_235 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_235 = string.gsub(var4_235, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_235, function(arg0_236, arg1_236)
		local var0_236 = true
		local var1_236 = false

		for iter0_236 in string.gmatch(arg1_236, "\"state\":%d") do
			if iter0_236 ~= "\"state\":1" then
				var0_236 = false
			end

			var1_236 = true
		end

		if not var1_236 then
			var0_236 = false
		end

		if arg0_235 ~= nil then
			arg0_235(var0_236 and var2_235 or var1_235)
		end
	end)
end

function setScrollText(arg0_237, arg1_237)
	GetOrAddComponent(arg0_237, "ScrollText"):SetText(arg1_237)
end

function changeToScrollText(arg0_238, arg1_238)
	local var0_238 = GetComponent(arg0_238, typeof(Text))

	assert(var0_238, "without component<Text>")

	local var1_238 = arg0_238:Find("subText")

	if not var1_238 then
		var1_238 = cloneTplTo(arg0_238, arg0_238, "subText")

		eachChild(arg0_238, function(arg0_239)
			setActive(arg0_239, arg0_239 == var1_238)
		end)

		arg0_238:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_238, arg1_238)
end

local var16_0
local var17_0
local var18_0
local var19_0

local function var20_0(arg0_240, arg1_240, arg2_240)
	local var0_240 = arg0_240:Find("base")
	local var1_240, var2_240, var3_240 = Equipment.GetInfoTrans(arg1_240, arg2_240)

	if arg1_240.nextValue then
		local var4_240 = {
			name = arg1_240.name,
			type = arg1_240.type,
			value = arg1_240.nextValue
		}
		local var5_240, var6_240 = Equipment.GetInfoTrans(var4_240, arg2_240)

		var2_240 = var2_240 .. setColorStr("   >   " .. var6_240, COLOR_GREEN)
	end

	setText(var0_240:Find("name"), var1_240)

	if var3_240 then
		local var7_240 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_240:Find("value"), var2_240 .. var7_240)
	else
		setText(var0_240:Find("value"), var2_240)
	end

	setActive(var0_240:Find("value/up"), arg1_240.compare and arg1_240.compare > 0)
	setActive(var0_240:Find("value/down"), arg1_240.compare and arg1_240.compare < 0)
	triggerToggle(var0_240, arg1_240.lock_open)

	if not arg1_240.lock_open and arg1_240.sub and #arg1_240.sub > 0 then
		GetComponent(var0_240, typeof(Toggle)).enabled = true
	else
		setActive(var0_240:Find("name/close"), false)
		setActive(var0_240:Find("name/open"), false)

		GetComponent(var0_240, typeof(Toggle)).enabled = false
	end
end

local function var21_0(arg0_241, arg1_241, arg2_241, arg3_241)
	var20_0(arg0_241, arg2_241, arg3_241)

	if not arg2_241.sub or #arg2_241.sub == 0 then
		return
	end

	var18_0(arg0_241:Find("subs"), arg1_241, arg2_241.sub, arg3_241)
end

function var18_0(arg0_242, arg1_242, arg2_242, arg3_242)
	removeAllChildren(arg0_242)
	var19_0(arg0_242, arg1_242, arg2_242, arg3_242)
end

function var19_0(arg0_243, arg1_243, arg2_243, arg3_243)
	for iter0_243, iter1_243 in ipairs(arg2_243) do
		local var0_243 = cloneTplTo(arg1_243, arg0_243)

		var21_0(var0_243, arg1_243, iter1_243, arg3_243)
	end
end

function updateEquipInfo(arg0_244, arg1_244, arg2_244, arg3_244)
	local var0_244 = arg0_244:Find("attr_tpl")

	var18_0(arg0_244:Find("attrs"), var0_244, arg1_244.attrs, arg3_244)
	setActive(arg0_244:Find("skill"), arg2_244)

	if arg2_244 then
		var21_0(arg0_244:Find("skill/attr"), var0_244, {
			name = i18n("skill"),
			value = setColorStr(arg2_244.name, "#FFDE00FF")
		}, arg3_244)
		setText(arg0_244:Find("skill/value/Text"), getSkillDescGet(arg2_244.id))
	end

	setActive(arg0_244:Find("weapon"), #arg1_244.weapon.sub > 0)

	if #arg1_244.weapon.sub > 0 then
		var18_0(arg0_244:Find("weapon"), var0_244, {
			arg1_244.weapon
		}, arg3_244)
	end

	setActive(arg0_244:Find("equip_info"), #arg1_244.equipInfo.sub > 0)

	if #arg1_244.equipInfo.sub > 0 then
		var18_0(arg0_244:Find("equip_info"), var0_244, {
			arg1_244.equipInfo
		}, arg3_244)
	end

	var21_0(arg0_244:Find("part/attr"), var0_244, {
		name = i18n("equip_info_23")
	}, arg3_244)

	local var1_244 = arg0_244:Find("part/value")
	local var2_244 = var1_244:Find("label")
	local var3_244 = {}
	local var4_244 = {}

	if #arg1_244.part[1] == 0 and #arg1_244.part[2] == 0 then
		setmetatable(var3_244, {
			__index = function(arg0_245, arg1_245)
				return true
			end
		})
		setmetatable(var4_244, {
			__index = function(arg0_246, arg1_246)
				return true
			end
		})
	else
		for iter0_244, iter1_244 in ipairs(arg1_244.part[1]) do
			var3_244[iter1_244] = true
		end

		for iter2_244, iter3_244 in ipairs(arg1_244.part[2]) do
			var4_244[iter3_244] = true
		end
	end

	local var5_244 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_244, var4_244)

	UIItemList.StaticAlign(var1_244, var2_244, #var5_244, function(arg0_247, arg1_247, arg2_247)
		arg1_247 = arg1_247 + 1

		if arg0_247 == UIItemList.EventUpdate then
			local var0_247 = var5_244[arg1_247]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_247), arg2_247)
			setActive(arg2_247:Find("main"), var3_244[var0_247] and not var4_244[var0_247])
			setActive(arg2_247:Find("sub"), var4_244[var0_247] and not var3_244[var0_247])
			setImageAlpha(arg2_247, not var3_244[var0_247] and not var4_244[var0_247] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_248, arg1_248, arg2_248)
	local var0_248 = arg0_248:Find("attr_tpl")

	var18_0(arg0_248:Find("attrs"), var0_248, arg1_248.attrs, arg2_248)
	setActive(arg0_248:Find("weapon"), #arg1_248.weapon.sub > 0)

	if #arg1_248.weapon.sub > 0 then
		var18_0(arg0_248:Find("weapon"), var0_248, {
			arg1_248.weapon
		}, arg2_248)
	end

	setActive(arg0_248:Find("equip_info"), #arg1_248.equipInfo.sub > 0)

	if #arg1_248.equipInfo.sub > 0 then
		var18_0(arg0_248:Find("equip_info"), var0_248, {
			arg1_248.equipInfo
		}, arg2_248)
	end
end

function setCanvasOverrideSorting(arg0_249, arg1_249)
	local var0_249 = arg0_249.parent

	arg0_249:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_249) then
		GetOrAddComponent(arg0_249, typeof(Canvas)).overrideSorting = arg1_249
	else
		setActive(arg0_249, true)

		GetOrAddComponent(arg0_249, typeof(Canvas)).overrideSorting = arg1_249

		setActive(arg0_249, false)
	end

	arg0_249:SetParent(var0_249, false)
end

function createNewGameObject(arg0_250, arg1_250)
	local var0_250 = GameObject.New()

	if arg0_250 then
		var0_250.name = "model"
	end

	var0_250.layer = arg1_250 or Layer.UI

	return GetOrAddComponent(var0_250, "RectTransform")
end

function CreateShell(arg0_251)
	if type(arg0_251) ~= "table" and type(arg0_251) ~= "userdata" then
		return arg0_251
	end

	local var0_251 = setmetatable({
		__index = arg0_251
	}, arg0_251)

	return setmetatable({}, var0_251)
end

function CameraFittingSettin(arg0_252)
	local var0_252 = GetComponent(arg0_252, typeof(Camera))
	local var1_252 = 1.77777777777778
	local var2_252 = Screen.width / Screen.height

	if var2_252 < var1_252 then
		local var3_252 = var2_252 / var1_252

		var0_252.rect = var0_0.Rect.New(0, (1 - var3_252) / 2, 1, var3_252)
	end
end

function SwitchSpecialChar(arg0_253, arg1_253)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_253 = arg0_253:gsub(" ", " ")
		arg0_253 = arg0_253:gsub("\t", "    ")
	end

	if not arg1_253 then
		arg0_253 = arg0_253:gsub("\n", " ")
	end

	return arg0_253
end

function AfterCheck(arg0_254, arg1_254)
	local var0_254 = {}

	for iter0_254, iter1_254 in ipairs(arg0_254) do
		var0_254[iter0_254] = iter1_254[1]()
	end

	arg1_254()

	for iter2_254, iter3_254 in ipairs(arg0_254) do
		if var0_254[iter2_254] ~= iter3_254[1]() then
			iter3_254[2]()
		end

		var0_254[iter2_254] = iter3_254[1]()
	end
end

function CompareFuncs(arg0_255, arg1_255)
	local var0_255 = {}

	local function var1_255(arg0_256, arg1_256)
		var0_255[arg0_256] = var0_255[arg0_256] or {}
		var0_255[arg0_256][arg1_256] = var0_255[arg0_256][arg1_256] or arg0_255[arg0_256](arg1_256)

		return var0_255[arg0_256][arg1_256]
	end

	return function(arg0_257, arg1_257)
		local var0_257 = 1

		while var0_257 <= #arg0_255 do
			local var1_257 = var1_255(var0_257, arg0_257)
			local var2_257 = var1_255(var0_257, arg1_257)

			if var1_257 == var2_257 then
				var0_257 = var0_257 + 1
			else
				return var1_257 < var2_257
			end
		end

		return tobool(arg1_255)
	end
end

function DropResultIntegration(arg0_258)
	local var0_258 = {}
	local var1_258 = 1

	while var1_258 <= #arg0_258 do
		local var2_258 = arg0_258[var1_258].type
		local var3_258 = arg0_258[var1_258].id

		var0_258[var2_258] = var0_258[var2_258] or {}

		if var0_258[var2_258][var3_258] then
			local var4_258 = arg0_258[var0_258[var2_258][var3_258]]
			local var5_258 = table.remove(arg0_258, var1_258)

			var4_258.count = var4_258.count + var5_258.count
		else
			var0_258[var2_258][var3_258] = var1_258
			var1_258 = var1_258 + 1
		end
	end

	local var6_258 = {
		function(arg0_259)
			local var0_259 = arg0_259.type
			local var1_259 = arg0_259.id

			if var0_259 == DROP_TYPE_SHIP then
				return 1
			elseif var0_259 == DROP_TYPE_RESOURCE then
				if var1_259 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_259 == DROP_TYPE_ITEM then
				if var1_259 == 59010 then
					return 4
				elseif var1_259 == 59900 then
					return 5
				else
					local var2_259 = Item.getConfigData(var1_259)
					local var3_259 = var2_259 and var2_259.type or 0

					if var3_259 == 9 then
						return 6
					elseif var3_259 == 5 then
						return 7
					elseif var3_259 == 4 then
						return 8
					elseif var3_259 == 7 then
						return 9
					end
				end
			elseif var0_259 == DROP_TYPE_VITEM and var1_259 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_260)
			local var0_260

			if arg0_260.type == DROP_TYPE_SHIP then
				var0_260 = pg.ship_data_statistics[arg0_260.id]
			elseif arg0_260.type == DROP_TYPE_ITEM then
				var0_260 = Item.getConfigData(arg0_260.id)
			end

			return (var0_260 and var0_260.rarity or 0) * -1
		end,
		function(arg0_261)
			return arg0_261.id
		end
	}

	table.sort(arg0_258, CompareFuncs(var6_258))
end

function getLoginConfig()
	local var0_262 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_262 = 1

	for iter0_262, iter1_262 in ipairs(pg.login.all) do
		if pg.login[iter1_262].date ~= "stop" then
			local var2_262, var3_262 = parseTimeConfig(pg.login[iter1_262].date)

			assert(not var3_262)

			if pg.TimeMgr.GetInstance():inTime(var2_262, var0_262) then
				var1_262 = iter1_262

				break
			end
		end
	end

	local var4_262 = pg.login[var1_262].login_static

	var4_262 = var4_262 ~= "" and var4_262 or "login"

	local var5_262 = pg.login[var1_262].login_cri
	local var6_262 = var5_262 ~= "" and true or false
	local var7_262 = pg.login[var1_262].op_play == 1 and true or false
	local var8_262 = pg.login[var1_262].op_time

	if var8_262 == "" or not pg.TimeMgr.GetInstance():inTime(var8_262, var0_262) then
		var7_262 = false
	end

	local var9_262 = var8_262 == "" and var8_262 or table.concat(var8_262[1][1])

	return var6_262, var6_262 and var5_262 or var4_262, pg.login[var1_262].bgm, var7_262, var9_262
end

function setIntimacyIcon(arg0_263, arg1_263, arg2_263)
	local var0_263 = {}
	local var1_263

	seriesAsync({
		function(arg0_264)
			if arg0_263.childCount > 0 then
				var1_263 = arg0_263:GetChild(0)

				arg0_264()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_265)
					var1_263 = tf(arg0_265)

					setParent(var1_263, arg0_263)
					arg0_264()
				end)
			end
		end,
		function(arg0_266)
			setImageAlpha(var1_263, arg2_263 and 0 or 1)
			eachChild(var1_263, function(arg0_267)
				setActive(arg0_267, false)
			end)

			if arg2_263 then
				local var0_266 = var1_263:Find(arg2_263 .. "(Clone)")

				if not var0_266 then
					LoadAndInstantiateAsync("ui", arg2_263, function(arg0_268)
						setParent(arg0_268, var1_263)
						setActive(arg0_268, true)
					end)
				else
					setActive(var0_266, true)
				end
			elseif arg1_263 then
				setImageSprite(var1_263, GetSpriteFromAtlas("energy", arg1_263), true)
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

function switch(arg0_271, arg1_271, arg2_271, ...)
	if arg1_271[arg0_271] then
		return arg1_271[arg0_271](...)
	elseif arg2_271 then
		return arg2_271(...)
	end
end

function parseTimeConfig(arg0_272)
	if type(arg0_272[1]) == "table" then
		return arg0_272[2], arg0_272[1]
	else
		return arg0_272
	end
end

local var23_0 = {
	__add = function(arg0_273, arg1_273)
		return NewPos(arg0_273.x + arg1_273.x, arg0_273.y + arg1_273.y)
	end,
	__sub = function(arg0_274, arg1_274)
		return NewPos(arg0_274.x - arg1_274.x, arg0_274.y - arg1_274.y)
	end,
	__mul = function(arg0_275, arg1_275)
		if type(arg1_275) == "number" then
			return NewPos(arg0_275.x * arg1_275, arg0_275.y * arg1_275)
		else
			return NewPos(arg0_275.x * arg1_275.x, arg0_275.y * arg1_275.y)
		end
	end,
	__eq = function(arg0_276, arg1_276)
		return arg0_276.x == arg1_276.x and arg0_276.y == arg1_276.y
	end,
	__tostring = function(arg0_277)
		return arg0_277.x .. "_" .. arg0_277.y
	end
}

function NewPos(arg0_278, arg1_278)
	assert(arg0_278 and arg1_278)

	local var0_278 = setmetatable({
		x = arg0_278,
		y = arg1_278
	}, var23_0)

	function var0_278.SqrMagnitude(arg0_279)
		return arg0_279.x * arg0_279.x + arg0_279.y * arg0_279.y
	end

	function var0_278.Normalize(arg0_280)
		local var0_280 = arg0_280:SqrMagnitude()

		if var0_280 > 1e-05 then
			return arg0_280 * (1 / math.sqrt(var0_280))
		else
			return NewPos(0, 0)
		end
	end

	return var0_278
end

local var24_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var24_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var24_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_282)
	return (string.char(226, 133, 160 + (arg0_282 - 1)))
end

function quickPlayAnimator(arg0_283, arg1_283)
	arg0_283:GetComponent(typeof(Animator)):Play(arg1_283, -1, 0)
end

function quickCheckAndPlayAnimator(arg0_284, arg1_284)
	local var0_284 = arg0_284:GetComponent(typeof(Animator))
	local var1_284 = Animator.StringToHash(arg1_284)

	if var0_284:HasState(0, var1_284) then
		var0_284:Play(arg1_284, -1, 0)
	end
end

function getSurveyUrl(arg0_285)
	local var0_285 = pg.survey_data_template[arg0_285]
	local var1_285

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_285 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_285 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_285 = var0_285.main_url
				else
					var1_285 = var0_285.uo_url
				end
			elseif var2_285 == PLATFORM_IPHONEPLAYER then
				var1_285 = var0_285.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			var1_285 = var0_285.main_url
		end
	else
		var1_285 = var0_285.main_url
	end

	local var3_285 = getProxy(PlayerProxy):getRawData().id
	local var4_285 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_285
	local var6_285 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_285 = getProxy(UserProxy):getRawData()
	local var8_285 = getProxy(ServerProxy):getRawData()[var7_285 and var7_285.server or 0]
	local var9_285 = var8_285 and var8_285.id or ""
	local var10_285 = getProxy(PlayerProxy):getRawData().level
	local var11_285 = var3_285 .. "_" .. arg0_285
	local var12_285 = var1_285
	local var13_285 = {
		var3_285,
		var4_285,
		var6_285,
		var9_285,
		var10_285,
		var11_285
	}

	if var12_285 then
		for iter0_285, iter1_285 in ipairs(var13_285) do
			var12_285 = string.gsub(var12_285, "$" .. iter0_285, tostring(iter1_285))
		end
	end

	warning(var12_285)

	return var12_285
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

function FilterVarchar(arg0_287)
	assert(type(arg0_287) == "string" or type(arg0_287) == "table")

	if arg0_287 == "" then
		return nil
	end

	return arg0_287
end

function getGameset(arg0_288)
	local var0_288 = pg.gameset[arg0_288]

	assert(var0_288)

	return {
		var0_288.key_value,
		var0_288.description
	}
end

function getDorm3dGameset(arg0_289)
	local var0_289 = pg.dorm3d_set[arg0_289]

	assert(var0_289)

	return {
		var0_289.key_value_int,
		var0_289.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_290)
	arg0_290 = arg0_290 or {}

	local var0_290 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_290 > 0 do
		local var1_290 = table.remove(arg0_290)

		switch(var1_290.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_290:getConfig("open_directly") == 1 then
					for iter0_291, iter1_291 in ipairs(var1_290:getConfig("display_icon")) do
						local var0_291 = Drop.Create(iter1_291)

						var0_291.count = var0_291.count * var1_290.count

						table.insert(arg0_290, var0_291)
					end
				elseif var1_290:getSubClass():IsShipExpType() then
					var0_290[var1_290.type][var1_290.id] = defaultValue(var0_290[var1_290.type][var1_290.id], 0) + var1_290.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_290[var1_290.type][var1_290.id] = defaultValue(var0_290[var1_290.type][var1_290.id], 0) + var1_290.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_290[var1_290.type] = var0_290[var1_290.type] + var1_290.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_290[var1_290.type] = var0_290[var1_290.type] + var1_290.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_290[var1_290.type] = var0_290[var1_290.type] + var1_290.count
			end
		})
	end

	return var0_290
end

function CheckOverflow(arg0_296, arg1_296)
	local var0_296 = {}
	local var1_296 = arg0_296[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_296 = arg0_296[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_296 = arg0_296[DROP_TYPE_EQUIP]
	local var4_296 = arg0_296[DROP_TYPE_SHIP]
	local var5_296 = getProxy(PlayerProxy):getRawData()
	local var6_296 = false

	if arg1_296 then
		local var7_296 = var5_296:OverStore(PlayerConst.ResStoreGold, var1_296)
		local var8_296 = var5_296:OverStore(PlayerConst.ResStoreOil, var2_296)

		if var7_296 > 0 or var8_296 > 0 then
			var0_296.isStoreOverflow = {
				var7_296,
				var8_296
			}
		end
	else
		if var1_296 > 0 and var5_296:GoldMax(var1_296) then
			return false, "gold"
		end

		if var2_296 > 0 and var5_296:OilMax(var2_296) then
			return false, "oil"
		end
	end

	var0_296.isExpBookOverflow = {}

	for iter0_296, iter1_296 in pairs(arg0_296[DROP_TYPE_ITEM]) do
		local var9_296 = Item.getConfigData(iter0_296)

		if getProxy(BagProxy):getItemCountById(iter0_296) + iter1_296 > var9_296.max_num then
			table.insert(var0_296.isExpBookOverflow, iter0_296)
		end
	end

	local var10_296 = getProxy(EquipmentProxy):getCapacity()

	if var3_296 > 0 and var3_296 + var10_296 > var5_296:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_296 = getProxy(BayProxy):getShipCount()

	if var4_296 > 0 and var4_296 + var11_296 > var5_296:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_296
end

function CheckShipExpOverflow(arg0_297)
	local var0_297 = getProxy(BagProxy)

	for iter0_297, iter1_297 in pairs(arg0_297[DROP_TYPE_ITEM]) do
		if var0_297:getItemCountById(iter0_297) + iter1_297 > Item.getConfigData(iter0_297).max_num then
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

function RegisterDetailButton(arg0_298, arg1_298, arg2_298)
	Drop.Change(arg2_298)
	switch(arg2_298.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_298:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_299 = Item.getConfigData(arg2_298.id).usage_arg
				local var1_299 = var0_299[3]

				if Item.InTimeLimitSkinAssigned(arg2_298.id) then
					var1_299 = table.mergeArray(var0_299[2], var1_299, true)
				end

				local var2_299 = {}

				for iter0_299, iter1_299 in ipairs(var0_299[2]) do
					var2_299[iter1_299] = true
				end

				onButton(arg0_298, arg1_298, function()
					arg0_298:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_298.id,
								selectableSkinList = underscore.map(var1_299, function(arg0_301)
									return SelectableSkin.New({
										id = arg0_301,
										isTimeLimit = var2_299[arg0_301] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_298, true)
			else
				local var3_299 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_298.id) and "tech" or arg2_298:getConfig("type")

				if var25_0[var3_299] then
					local var4_299 = {
						item2Row = true,
						content = i18n(var25_0[var3_299]),
						itemList = underscore.map(arg2_298:getConfig("display_icon"), function(arg0_302)
							return Drop.Create(arg0_302)
						end)
					}

					if var3_299 == 11 then
						onButton(arg0_298, arg1_298, function()
							arg0_298:emit(BaseUI.ON_DROP_LIST_OWN, var4_299)
						end, SFX_PANEL)
					else
						onButton(arg0_298, arg1_298, function()
							arg0_298:emit(BaseUI.ON_DROP_LIST, var4_299)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_298, tobool(var25_0[var3_299]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_298, arg1_298, function()
				arg0_298:emit(BaseUI.ON_DROP, arg2_298)
			end, SFX_PANEL)
			setActive(arg1_298, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_298, arg1_298, function()
				arg0_298:emit(BaseUI.ON_DROP, arg2_298)
			end, SFX_PANEL)
			setActive(arg1_298, true)
		end
	}, function()
		setActive(arg1_298, false)
	end)
end

function UpdateOwnDisplay(arg0_310, arg1_310)
	local var0_310, var1_310 = arg1_310:getOwnedCount()

	setActive(arg0_310, var1_310 and var0_310 > 0)

	if var1_310 and var0_310 > 0 then
		setText(arg0_310:Find("label"), i18n("word_own1"))
		setText(arg0_310:Find("Text"), var0_310)
	end
end

function Damp(arg0_311, arg1_311, arg2_311)
	arg1_311 = Mathf.Max(1, arg1_311)

	local var0_311 = Mathf.Epsilon

	if arg1_311 < var0_311 or var0_311 > Mathf.Abs(arg0_311) then
		return arg0_311
	end

	if arg2_311 < var0_311 then
		return 0
	end

	local var1_311 = -4.605170186

	return arg0_311 * (1 - Mathf.Exp(var1_311 * arg2_311 / arg1_311))
end

function checkCullResume(arg0_312)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_312, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_312 = arg0_312:GetComponentsInChildren(typeof(MeshImage))

		for iter0_312 = 1, var0_312.Length do
			var0_312[iter0_312 - 1]:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_313)
	local var0_313 = {}

	if arg0_313 and arg0_313 ~= "" then
		local var1_313 = base64.dec(arg0_313)

		var0_313 = string.split(var1_313, "/")
		var0_313[5], var0_313[6] = unpack(string.split(var0_313[5], "\\"))

		if #var0_313 < 6 or arg0_313 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_313, 5), "/"),
			var0_313[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_313 = {}
		end
	end

	for iter0_313 = 1, 6 do
		var0_313[iter0_313] = var0_313[iter0_313] and tonumber(var0_313[iter0_313], 32) or 0
	end

	return var0_313
end

function buildEquipCode(arg0_314)
	local var0_314 = underscore.map(arg0_314:getAllEquipments(), function(arg0_315)
		return ConversionBase(32, arg0_315 and arg0_315.id or 0)
	end)
	local var1_314 = {
		table.concat(var0_314, "/"),
		ConversionBase(32, checkExist(arg0_314:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_314, "\\"))
end

function setDirectorSpeed(arg0_316, arg1_316)
	GetComponent(arg0_316, "TimelineSpeed"):SetTimelineSpeed(arg1_316)
end

function setDefaultZeroMetatable(arg0_317)
	return setmetatable(arg0_317, {
		__index = function(arg0_318, arg1_318)
			if rawget(arg0_318, arg1_318) == nil then
				arg0_318[arg1_318] = 0
			end

			return arg0_318[arg1_318]
		end
	})
end

function checkABExist(arg0_319)
	if EDITOR_TOOL then
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_319)) or ResourceMgr.Inst:AssetExist(arg0_319)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_319))
	end
end
