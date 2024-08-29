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

function updateEmoji(arg0_118, arg1_118, arg2_118)
	local var0_118 = findTF(arg0_118, "icon_bg/icon")
	local var1_118 = "icon_emoji"

	GetImageSpriteFromAtlasAsync("Props/" .. var1_118, "", var0_118)

	local var2_118 = 4

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var2_118, findTF(arg0_118, "icon_bg"))
	setFrame(findTF(arg0_118, "icon_bg/frame"), var2_118)
	setIconName(arg0_118, arg1_118.name, arg2_118)
end

function updateEquipmentSkin(arg0_119, arg1_119, arg2_119)
	arg2_119 = arg2_119 or {}

	local var0_119 = EquipmentRarity.Rarity2Print(arg1_119.rarity)

	GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var0_119, findTF(arg0_119, "icon_bg"))
	setFrame(findTF(arg0_119, "icon_bg/frame"), var0_119, "frame_skin")

	local var1_119 = findTF(arg0_119, "icon_bg/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. arg1_119.icon, "", var1_119)
	setIconStars(arg0_119, false)
	setIconName(arg0_119, arg1_119.name, arg2_119)
	setIconCount(arg0_119, arg1_119.count)
	setIconColorful(arg0_119, arg1_119.rarity - 1, arg2_119)
end

function NoPosMsgBox(arg0_120, arg1_120, arg2_120, arg3_120)
	local var0_120
	local var1_120 = {}

	if arg1_120 then
		table.insert(var1_120, {
			text = "text_noPos_clear",
			atuoClose = true,
			onCallback = arg1_120
		})
	end

	if arg2_120 then
		table.insert(var1_120, {
			text = "text_noPos_buy",
			atuoClose = true,
			onCallback = arg2_120
		})
	end

	if arg3_120 then
		table.insert(var1_120, {
			text = "text_noPos_intensify",
			atuoClose = true,
			onCallback = arg3_120
		})
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		hideYes = true,
		hideNo = true,
		content = arg0_120,
		custom = var1_120,
		weight = LayerWeightConst.TOP_LAYER
	})
end

function openDestroyEquip()
	if pg.m02:hasMediator(EquipmentMediator.__cname) then
		local var0_121 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_121 and var0_121.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_121
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
		local var0_122 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(EquipmentMediator)

		if var0_122 and var0_122.data.shipId then
			pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_122
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
		onClick = function(arg0_125, arg1_125)
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
				page = 3,
				shipId = arg0_125.id,
				shipVOs = arg1_125
			})
		end
	})
end

function GoShoppingMsgBox(arg0_126, arg1_126, arg2_126)
	if arg2_126 then
		local var0_126 = ""

		for iter0_126, iter1_126 in ipairs(arg2_126) do
			local var1_126 = Item.getConfigData(iter1_126[1])

			var0_126 = var0_126 .. i18n(iter1_126[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var1_126.name, iter1_126[2])

			if iter0_126 < #arg2_126 then
				var0_126 = var0_126 .. i18n("text_noRes_info_tip_link")
			end
		end

		if var0_126 ~= "" then
			arg0_126 = arg0_126 .. "\n" .. i18n("text_noRes_tip", var0_126)
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = arg0_126,
		weight = LayerWeightConst.SECOND_LAYER,
		onYes = function()
			gotoChargeScene(arg1_126, arg2_126)
		end
	})
end

function shoppingBatch(arg0_128, arg1_128, arg2_128, arg3_128, arg4_128)
	local var0_128 = pg.shop_template[arg0_128]

	assert(var0_128, "shop_template中找不到商品id：" .. arg0_128)

	local var1_128 = getProxy(PlayerProxy):getData()[id2res(var0_128.resource_type)]
	local var2_128 = arg1_128.price or var0_128.resource_num
	local var3_128 = math.floor(var1_128 / var2_128)

	var3_128 = var3_128 <= 0 and 1 or var3_128
	var3_128 = arg2_128 ~= nil and arg2_128 < var3_128 and arg2_128 or var3_128

	local var4_128 = true
	local var5_128 = 1

	if var0_128 ~= nil and arg1_128.id then
		print(var3_128 * var0_128.num, "--", var3_128)
		assert(Item.getConfigData(arg1_128.id), "item config should be existence")

		local var6_128 = Item.New({
			id = arg1_128.id
		}):getConfig("name")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			needCounter = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_128.id
			},
			addNum = var0_128.num,
			maxNum = var3_128 * var0_128.num,
			defaultNum = var0_128.num,
			numUpdate = function(arg0_129, arg1_129)
				var5_128 = math.floor(arg1_129 / var0_128.num)

				local var0_129 = var5_128 * var2_128

				if var0_129 > var1_128 then
					setText(arg0_129, i18n(arg3_128, var0_129, arg1_129, COLOR_RED, var6_128))

					var4_128 = false
				else
					setText(arg0_129, i18n(arg3_128, var0_129, arg1_129, COLOR_GREEN, var6_128))

					var4_128 = true
				end
			end,
			onYes = function()
				if var4_128 then
					pg.m02:sendNotification(GAME.SHOPPING, {
						id = arg0_128,
						count = var5_128
					})
				elseif arg4_128 then
					pg.TipsMgr.GetInstance():ShowTips(i18n(arg4_128))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("main_playerInfoLayer_error_changeNameNoGem"))
				end
			end
		})
	end
end

function gotoChargeScene(arg0_131, arg1_131)
	local var0_131 = getProxy(ContextProxy)
	local var1_131 = getProxy(ContextProxy):getCurrentContext()

	if instanceof(var1_131.mediator, ChargeMediator) then
		var1_131.mediator:getViewComponent():switchSubViewByTogger(arg0_131)
	else
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
			wrap = arg0_131 or ChargeScene.TYPE_ITEM,
			noRes = arg1_131
		})
	end
end

function clearDrop(arg0_132)
	local var0_132 = findTF(arg0_132, "icon_bg")
	local var1_132 = findTF(arg0_132, "icon_bg/frame")
	local var2_132 = findTF(arg0_132, "icon_bg/icon")
	local var3_132 = findTF(arg0_132, "icon_bg/icon/icon")

	clearImageSprite(var0_132)
	clearImageSprite(var1_132)
	clearImageSprite(var2_132)

	if var3_132 then
		clearImageSprite(var3_132)
	end
end

local var7_0 = {
	red = Color.New(1, 0.25, 0.25),
	blue = Color.New(0.11, 0.55, 0.64),
	yellow = Color.New(0.92, 0.52, 0)
}

function updateSkill(arg0_133, arg1_133, arg2_133, arg3_133)
	local var0_133 = findTF(arg0_133, "skill")
	local var1_133 = findTF(arg0_133, "lock")
	local var2_133 = findTF(arg0_133, "unknown")

	if arg1_133 then
		setActive(var0_133, true)
		setActive(var2_133, false)
		setActive(var1_133, not arg2_133)
		LoadImageSpriteAsync("skillicon/" .. arg1_133.icon, findTF(var0_133, "icon"))

		local var3_133 = arg1_133.color or "blue"

		setText(findTF(var0_133, "name"), shortenString(getSkillName(arg1_133.id), arg3_133 or 8))

		local var4_133 = findTF(var0_133, "level")

		setText(var4_133, "LEVEL: " .. (arg2_133 and arg2_133.level or "??"))
		setTextColor(var4_133, var7_0[var3_133])
	else
		setActive(var0_133, false)
		setActive(var2_133, true)
		setActive(var1_133, false)
	end
end

local var8_0 = true

function onBackButton(arg0_134, arg1_134, arg2_134, arg3_134)
	local var0_134 = GetOrAddComponent(arg1_134, "UILongPressTrigger")

	assert(arg2_134, "callback should exist")

	var0_134.longPressThreshold = defaultValue(arg3_134, 1)

	local function var1_134(arg0_135)
		return function()
			if var8_0 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SOUND_BACK)
			end

			local var0_136, var1_136 = arg2_134()

			if var0_136 then
				arg0_135(var1_136)
			end
		end
	end

	local var2_134 = var0_134.onReleased

	pg.DelegateInfo.Add(arg0_134, var2_134)
	var2_134:RemoveAllListeners()
	var2_134:AddListener(var1_134(function(arg0_137)
		arg0_137:emit(BaseUI.ON_BACK)
	end))

	local var3_134 = var0_134.onLongPressed

	pg.DelegateInfo.Add(arg0_134, var3_134)
	var3_134:RemoveAllListeners()
	var3_134:AddListener(var1_134(function(arg0_138)
		arg0_138:emit(BaseUI.ON_HOME)
	end))
end

function GetZeroTime()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function GetHalfHour()
	return pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0, 1800)
end

function GetNextHour(arg0_141)
	local var0_141 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_141, var2_141 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_141)

	return var1_141 * 86400 + (var2_141 + arg0_141) * 3600
end

function GetPerceptualSize(arg0_142)
	local function var0_142(arg0_143)
		if not arg0_143 then
			return 0, 1
		elseif arg0_143 > 240 then
			return 4, 1
		elseif arg0_143 > 225 then
			return 3, 1
		elseif arg0_143 > 192 then
			return 2, 1
		elseif arg0_143 < 126 then
			return 1, 0.5
		else
			return 1, 1
		end
	end

	if type(arg0_142) == "number" then
		return var0_142(arg0_142)
	end

	local var1_142 = 1
	local var2_142 = 0
	local var3_142 = 0
	local var4_142 = #arg0_142

	while var1_142 <= var4_142 do
		local var5_142 = string.byte(arg0_142, var1_142)
		local var6_142, var7_142 = var0_142(var5_142)

		var1_142 = var1_142 + var6_142
		var2_142 = var2_142 + var7_142
	end

	return var2_142
end

function shortenString(arg0_144, arg1_144)
	local var0_144 = 1
	local var1_144 = 0
	local var2_144 = 0
	local var3_144 = #arg0_144

	while var0_144 <= var3_144 do
		local var4_144 = string.byte(arg0_144, var0_144)
		local var5_144, var6_144 = GetPerceptualSize(var4_144)

		var0_144 = var0_144 + var5_144
		var1_144 = var1_144 + var6_144

		if arg1_144 <= math.ceil(var1_144) then
			var2_144 = var0_144

			break
		end
	end

	if var2_144 == 0 or var3_144 < var2_144 then
		return arg0_144
	end

	return string.sub(arg0_144, 1, var2_144 - 1) .. ".."
end

function shouldShortenString(arg0_145, arg1_145)
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
		return false
	end

	return true
end

function nameValidityCheck(arg0_146, arg1_146, arg2_146, arg3_146)
	local var0_146 = true
	local var1_146, var2_146 = utf8_to_unicode(arg0_146)
	local var3_146 = filterEgyUnicode(filterSpecChars(arg0_146))
	local var4_146 = wordVer(arg0_146)

	if not checkSpaceValid(arg0_146) then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_146[1]))

		var0_146 = false
	elseif var4_146 > 0 or var3_146 ~= arg0_146 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_146[4]))

		var0_146 = false
	elseif var2_146 < arg1_146 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_146[2]))

		var0_146 = false
	elseif arg2_146 < var2_146 then
		pg.TipsMgr.GetInstance():ShowTips(i18n(arg3_146[3]))

		var0_146 = false
	end

	return var0_146
end

function checkSpaceValid(arg0_147)
	if PLATFORM_CODE == PLATFORM_US then
		return true
	end

	local var0_147 = string.gsub(arg0_147, " ", "")

	return arg0_147 == string.gsub(var0_147, "　", "")
end

function filterSpecChars(arg0_148)
	local var0_148 = {}
	local var1_148 = 0
	local var2_148 = 0
	local var3_148 = 0
	local var4_148 = 1

	while var4_148 <= #arg0_148 do
		local var5_148 = string.byte(arg0_148, var4_148)

		if not var5_148 then
			break
		end

		if var5_148 >= 48 and var5_148 <= 57 or var5_148 >= 65 and var5_148 <= 90 or var5_148 == 95 or var5_148 >= 97 and var5_148 <= 122 then
			table.insert(var0_148, string.char(var5_148))
		elseif var5_148 >= 228 and var5_148 <= 233 then
			local var6_148 = string.byte(arg0_148, var4_148 + 1)
			local var7_148 = string.byte(arg0_148, var4_148 + 2)

			if var6_148 and var7_148 and var6_148 >= 128 and var6_148 <= 191 and var7_148 >= 128 and var7_148 <= 191 then
				var4_148 = var4_148 + 2

				table.insert(var0_148, string.char(var5_148, var6_148, var7_148))

				var1_148 = var1_148 + 1
			end
		elseif var5_148 == 45 or var5_148 == 40 or var5_148 == 41 then
			table.insert(var0_148, string.char(var5_148))
		elseif var5_148 == 194 then
			local var8_148 = string.byte(arg0_148, var4_148 + 1)

			if var8_148 == 183 then
				var4_148 = var4_148 + 1

				table.insert(var0_148, string.char(var5_148, var8_148))

				var1_148 = var1_148 + 1
			end
		elseif var5_148 == 239 then
			local var9_148 = string.byte(arg0_148, var4_148 + 1)
			local var10_148 = string.byte(arg0_148, var4_148 + 2)

			if var9_148 == 188 and (var10_148 == 136 or var10_148 == 137) then
				var4_148 = var4_148 + 2

				table.insert(var0_148, string.char(var5_148, var9_148, var10_148))

				var1_148 = var1_148 + 1
			end
		elseif var5_148 == 206 or var5_148 == 207 then
			local var11_148 = string.byte(arg0_148, var4_148 + 1)

			if var5_148 == 206 and var11_148 >= 177 or var5_148 == 207 and var11_148 <= 134 then
				var4_148 = var4_148 + 1

				table.insert(var0_148, string.char(var5_148, var11_148))

				var1_148 = var1_148 + 1
			end
		elseif var5_148 == 227 and PLATFORM_CODE == PLATFORM_JP then
			local var12_148 = string.byte(arg0_148, var4_148 + 1)
			local var13_148 = string.byte(arg0_148, var4_148 + 2)

			if var12_148 and var13_148 and var12_148 > 128 and var12_148 <= 191 and var13_148 >= 128 and var13_148 <= 191 then
				var4_148 = var4_148 + 2

				table.insert(var0_148, string.char(var5_148, var12_148, var13_148))

				var2_148 = var2_148 + 1
			end
		elseif var5_148 >= 224 and PLATFORM_CODE == PLATFORM_KR then
			local var14_148 = string.byte(arg0_148, var4_148 + 1)
			local var15_148 = string.byte(arg0_148, var4_148 + 2)

			if var14_148 and var15_148 and var14_148 >= 128 and var14_148 <= 191 and var15_148 >= 128 and var15_148 <= 191 then
				var4_148 = var4_148 + 2

				table.insert(var0_148, string.char(var5_148, var14_148, var15_148))

				var3_148 = var3_148 + 1
			end
		elseif PLATFORM_CODE == PLATFORM_US then
			if var4_148 ~= 1 and var5_148 == 32 and string.byte(arg0_148, var4_148 + 1) ~= 32 then
				table.insert(var0_148, string.char(var5_148))
			end

			if var5_148 >= 192 and var5_148 <= 223 then
				local var16_148 = string.byte(arg0_148, var4_148 + 1)

				var4_148 = var4_148 + 1

				if var5_148 == 194 and var16_148 and var16_148 >= 128 then
					table.insert(var0_148, string.char(var5_148, var16_148))
				elseif var5_148 == 195 and var16_148 and var16_148 <= 191 then
					table.insert(var0_148, string.char(var5_148, var16_148))
				end
			end

			if var5_148 == 195 then
				local var17_148 = string.byte(arg0_148, var4_148 + 1)

				if var17_148 == 188 then
					table.insert(var0_148, string.char(var5_148, var17_148))
				end
			end
		end

		var4_148 = var4_148 + 1
	end

	return table.concat(var0_148), var1_148 + var2_148 + var3_148
end

function filterEgyUnicode(arg0_149)
	arg0_149 = string.gsub(arg0_149, "�[�-�][�-�]", "")
	arg0_149 = string.gsub(arg0_149, "�[�-�]", "")

	return arg0_149
end

function shiftPanel(arg0_150, arg1_150, arg2_150, arg3_150, arg4_150, arg5_150, arg6_150, arg7_150, arg8_150)
	arg3_150 = arg3_150 or 0.2

	if arg5_150 then
		LeanTween.cancel(go(arg0_150))
	end

	local var0_150 = rtf(arg0_150)

	arg1_150 = arg1_150 or var0_150.anchoredPosition.x
	arg2_150 = arg2_150 or var0_150.anchoredPosition.y

	local var1_150 = LeanTween.move(var0_150, Vector3(arg1_150, arg2_150, 0), arg3_150)

	arg7_150 = arg7_150 or LeanTweenType.easeInOutSine

	var1_150:setEase(arg7_150)

	if arg4_150 then
		var1_150:setDelay(arg4_150)
	end

	if arg6_150 then
		GetOrAddComponent(arg0_150, "CanvasGroup").blocksRaycasts = false
	end

	var1_150:setOnComplete(System.Action(function()
		if arg8_150 then
			arg8_150()
		end

		if arg6_150 then
			GetOrAddComponent(arg0_150, "CanvasGroup").blocksRaycasts = true
		end
	end))

	return var1_150
end

function TweenValue(arg0_152, arg1_152, arg2_152, arg3_152, arg4_152, arg5_152, arg6_152, arg7_152)
	local var0_152 = LeanTween.value(go(arg0_152), arg1_152, arg2_152, arg3_152):setOnUpdate(System.Action_float(function(arg0_153)
		if arg5_152 then
			arg5_152(arg0_153)
		end
	end)):setOnComplete(System.Action(function()
		if arg6_152 then
			arg6_152()
		end
	end)):setDelay(arg4_152 or 0)

	if arg7_152 and arg7_152 > 0 then
		var0_152:setRepeat(arg7_152)
	end

	return var0_152
end

function rotateAni(arg0_155, arg1_155, arg2_155)
	return LeanTween.rotate(rtf(arg0_155), 360 * arg1_155, arg2_155):setLoopClamp()
end

function blinkAni(arg0_156, arg1_156, arg2_156, arg3_156)
	return LeanTween.alpha(rtf(arg0_156), arg3_156 or 0, arg1_156):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(arg2_156 or 0)
end

function scaleAni(arg0_157, arg1_157, arg2_157, arg3_157)
	return LeanTween.scale(rtf(arg0_157), arg3_157 or 0, arg1_157):setLoopPingPong(arg2_157 or 0)
end

function floatAni(arg0_158, arg1_158, arg2_158, arg3_158)
	local var0_158 = arg0_158.localPosition.y + arg1_158

	return LeanTween.moveY(rtf(arg0_158), var0_158, arg2_158):setLoopPingPong(arg3_158 or 0)
end

local var9_0 = tostring

function tostring(arg0_159)
	if arg0_159 == nil then
		return "nil"
	end

	local var0_159 = var9_0(arg0_159)

	if var0_159 == nil then
		if type(arg0_159) == "table" then
			return "{}"
		end

		return " ~nil"
	end

	return var0_159
end

function wordVer(arg0_160, arg1_160)
	if arg0_160.match(arg0_160, ChatConst.EmojiCodeMatch) then
		return 0, arg0_160
	end

	arg1_160 = arg1_160 or {}

	local var0_160 = filterEgyUnicode(arg0_160)

	if #var0_160 ~= #arg0_160 then
		if arg1_160.isReplace then
			arg0_160 = var0_160
		else
			return 1
		end
	end

	local var1_160 = wordSplit(arg0_160)
	local var2_160 = pg.word_template
	local var3_160 = pg.word_legal_template

	arg1_160.isReplace = arg1_160.isReplace or false
	arg1_160.replaceWord = arg1_160.replaceWord or "*"

	local var4_160 = #var1_160
	local var5_160 = 1
	local var6_160 = ""
	local var7_160 = 0

	while var5_160 <= var4_160 do
		local var8_160, var9_160, var10_160 = wordLegalMatch(var1_160, var3_160, var5_160)

		if var8_160 then
			var5_160 = var9_160
			var6_160 = var6_160 .. var10_160
		else
			local var11_160, var12_160, var13_160 = wordVerMatch(var1_160, var2_160, arg1_160, var5_160, "", false, var5_160, "")

			if var11_160 then
				var5_160 = var12_160
				var7_160 = var7_160 + 1

				if arg1_160.isReplace then
					var6_160 = var6_160 .. var13_160
				end
			else
				if arg1_160.isReplace then
					var6_160 = var6_160 .. var1_160[var5_160]
				end

				var5_160 = var5_160 + 1
			end
		end
	end

	if arg1_160.isReplace then
		return var7_160, var6_160
	else
		return var7_160
	end
end

function wordLegalMatch(arg0_161, arg1_161, arg2_161, arg3_161, arg4_161)
	if arg2_161 > #arg0_161 then
		return arg3_161, arg2_161, arg4_161
	end

	local var0_161 = arg0_161[arg2_161]
	local var1_161 = arg1_161[var0_161]

	arg4_161 = arg4_161 == nil and "" or arg4_161

	if var1_161 then
		if var1_161.this then
			return wordLegalMatch(arg0_161, var1_161, arg2_161 + 1, true, arg4_161 .. var0_161)
		else
			return wordLegalMatch(arg0_161, var1_161, arg2_161 + 1, false, arg4_161 .. var0_161)
		end
	else
		return arg3_161, arg2_161, arg4_161
	end
end

local var10_0 = string.byte("a")
local var11_0 = string.byte("z")
local var12_0 = string.byte("A")
local var13_0 = string.byte("Z")

local function var14_0(arg0_162)
	if not arg0_162 then
		return arg0_162
	end

	local var0_162 = string.byte(arg0_162)

	if var0_162 > 128 then
		return
	end

	if var0_162 >= var10_0 and var0_162 <= var11_0 then
		return string.char(var0_162 - 32)
	elseif var0_162 >= var12_0 and var0_162 <= var13_0 then
		return string.char(var0_162 + 32)
	else
		return arg0_162
	end
end

function wordVerMatch(arg0_163, arg1_163, arg2_163, arg3_163, arg4_163, arg5_163, arg6_163, arg7_163)
	if arg3_163 > #arg0_163 then
		return arg5_163, arg6_163, arg7_163
	end

	local var0_163 = arg0_163[arg3_163]
	local var1_163 = arg1_163[var0_163]

	if var1_163 then
		local var2_163, var3_163, var4_163 = wordVerMatch(arg0_163, var1_163, arg2_163, arg3_163 + 1, arg2_163.isReplace and arg4_163 .. arg2_163.replaceWord or arg4_163, var1_163.this or arg5_163, var1_163.this and arg3_163 + 1 or arg6_163, var1_163.this and (arg2_163.isReplace and arg4_163 .. arg2_163.replaceWord or arg4_163) or arg7_163)

		if var2_163 then
			return var2_163, var3_163, var4_163
		end
	end

	local var5_163 = var14_0(var0_163)
	local var6_163 = arg1_163[var5_163]

	if var5_163 ~= var0_163 and var6_163 then
		local var7_163, var8_163, var9_163 = wordVerMatch(arg0_163, var6_163, arg2_163, arg3_163 + 1, arg2_163.isReplace and arg4_163 .. arg2_163.replaceWord or arg4_163, var6_163.this or arg5_163, var6_163.this and arg3_163 + 1 or arg6_163, var6_163.this and (arg2_163.isReplace and arg4_163 .. arg2_163.replaceWord or arg4_163) or arg7_163)

		if var7_163 then
			return var7_163, var8_163, var9_163
		end
	end

	return arg5_163, arg6_163, arg7_163
end

function wordSplit(arg0_164)
	local var0_164 = {}

	for iter0_164 in arg0_164.gmatch(arg0_164, "[\x01-\x7F�-�][�-�]*") do
		var0_164[#var0_164 + 1] = iter0_164
	end

	return var0_164
end

function contentWrap(arg0_165, arg1_165, arg2_165)
	local var0_165 = LuaHelper.WrapContent(arg0_165, arg1_165, arg2_165)

	return #var0_165 ~= #arg0_165, var0_165
end

function cancelRich(arg0_166)
	local var0_166

	for iter0_166 = 1, 20 do
		local var1_166

		arg0_166, var1_166 = string.gsub(arg0_166, "<([^>]*)>", "%1")

		if var1_166 <= 0 then
			break
		end
	end

	return arg0_166
end

function getSkillConfig(arg0_167)
	local var0_167 = require("GameCfg.buff.buff_" .. arg0_167)

	if not var0_167 then
		warning("找不到技能配置: " .. arg0_167)

		return
	end

	local var1_167 = Clone(var0_167)

	var1_167.name = getSkillName(arg0_167)
	var1_167.desc = HXSet.hxLan(var1_167.desc)
	var1_167.desc_get = HXSet.hxLan(var1_167.desc_get)

	_.each(var1_167, function(arg0_168)
		arg0_168.desc = HXSet.hxLan(arg0_168.desc)
	end)

	return var1_167
end

function getSkillName(arg0_169)
	local var0_169 = pg.skill_data_template[arg0_169] or pg.skill_data_display[arg0_169]

	if var0_169 then
		return HXSet.hxLan(var0_169.name)
	else
		return ""
	end
end

function getSkillDescGet(arg0_170, arg1_170)
	local var0_170 = arg1_170 and pg.skill_world_display[arg0_170] and setmetatable({}, {
		__index = function(arg0_171, arg1_171)
			return pg.skill_world_display[arg0_170][arg1_171] or pg.skill_data_template[arg0_170][arg1_171]
		end
	}) or pg.skill_data_template[arg0_170]

	if not var0_170 then
		return ""
	end

	local var1_170 = var0_170.desc_get ~= "" and var0_170.desc_get or var0_170.desc

	for iter0_170, iter1_170 in pairs(var0_170.desc_get_add) do
		local var2_170 = setColorStr(iter1_170[1], COLOR_GREEN)

		if iter1_170[2] then
			var2_170 = var2_170 .. specialGSub(i18n("word_skill_desc_get"), "$1", setColorStr(iter1_170[2], COLOR_GREEN))
		end

		var1_170 = specialGSub(var1_170, "$" .. iter0_170, var2_170)
	end

	return HXSet.hxLan(var1_170)
end

function getSkillDescLearn(arg0_172, arg1_172, arg2_172)
	local var0_172 = arg2_172 and pg.skill_world_display[arg0_172] and setmetatable({}, {
		__index = function(arg0_173, arg1_173)
			return pg.skill_world_display[arg0_172][arg1_173] or pg.skill_data_template[arg0_172][arg1_173]
		end
	}) or pg.skill_data_template[arg0_172]

	if not var0_172 then
		return ""
	end

	local var1_172 = var0_172.desc

	if not var0_172.desc_add then
		return HXSet.hxLan(var1_172)
	end

	for iter0_172, iter1_172 in pairs(var0_172.desc_add) do
		local var2_172 = iter1_172[arg1_172][1]

		if iter1_172[arg1_172][2] then
			var2_172 = var2_172 .. specialGSub(i18n("word_skill_desc_learn"), "$1", iter1_172[arg1_172][2])
		end

		var1_172 = specialGSub(var1_172, "$" .. iter0_172, setColorStr(var2_172, COLOR_YELLOW))
	end

	return HXSet.hxLan(var1_172)
end

function getSkillDesc(arg0_174, arg1_174, arg2_174)
	local var0_174 = arg2_174 and pg.skill_world_display[arg0_174] and setmetatable({}, {
		__index = function(arg0_175, arg1_175)
			return pg.skill_world_display[arg0_174][arg1_175] or pg.skill_data_template[arg0_174][arg1_175]
		end
	}) or pg.skill_data_template[arg0_174]

	if not var0_174 then
		return ""
	end

	local var1_174 = var0_174.desc

	if not var0_174.desc_add then
		return HXSet.hxLan(var1_174)
	end

	for iter0_174, iter1_174 in pairs(var0_174.desc_add) do
		local var2_174 = setColorStr(iter1_174[arg1_174][1], COLOR_GREEN)

		var1_174 = specialGSub(var1_174, "$" .. iter0_174, var2_174)
	end

	return HXSet.hxLan(var1_174)
end

function specialGSub(arg0_176, arg1_176, arg2_176)
	arg0_176 = string.gsub(arg0_176, "<color=#", "<color=NNN")
	arg0_176 = string.gsub(arg0_176, "#", "")
	arg2_176 = string.gsub(arg2_176, "%%", "%%%%")
	arg0_176 = string.gsub(arg0_176, arg1_176, arg2_176)
	arg0_176 = string.gsub(arg0_176, "<color=NNN", "<color=#")

	return arg0_176
end

function topAnimation(arg0_177, arg1_177, arg2_177, arg3_177, arg4_177, arg5_177)
	local var0_177 = {}

	arg4_177 = arg4_177 or 0.27

	local var1_177 = 0.05

	if arg0_177 then
		local var2_177 = arg0_177.transform.localPosition.x

		setAnchoredPosition(arg0_177, {
			x = var2_177 - 500
		})
		shiftPanel(arg0_177, var2_177, nil, 0.05, arg4_177, true, true)
		setActive(arg0_177, true)
	end

	setActive(arg1_177, false)
	setActive(arg2_177, false)
	setActive(arg3_177, false)

	for iter0_177 = 1, 3 do
		table.insert(var0_177, LeanTween.delayedCall(arg4_177 + 0.13 + var1_177 * iter0_177, System.Action(function()
			if arg1_177 then
				setActive(arg1_177, not arg1_177.gameObject.activeSelf)
			end
		end)).uniqueId)
		table.insert(var0_177, LeanTween.delayedCall(arg4_177 + 0.02 + var1_177 * iter0_177, System.Action(function()
			if arg2_177 then
				setActive(arg2_177, not go(arg2_177).activeSelf)
			end

			if arg2_177 then
				setActive(arg3_177, not go(arg3_177).activeSelf)
			end
		end)).uniqueId)
	end

	if arg5_177 then
		table.insert(var0_177, LeanTween.delayedCall(arg4_177 + 0.13 + var1_177 * 3 + 0.1, System.Action(function()
			arg5_177()
		end)).uniqueId)
	end

	return var0_177
end

function cancelTweens(arg0_181)
	assert(arg0_181, "must provide cancel targets, LeanTween.cancelAll is not allow")

	for iter0_181, iter1_181 in ipairs(arg0_181) do
		if iter1_181 then
			LeanTween.cancel(iter1_181)
		end
	end
end

function getOfflineTimeStamp(arg0_182)
	local var0_182 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_182
	local var1_182 = ""

	if var0_182 <= 59 then
		var1_182 = i18n("just_now")
	elseif var0_182 <= 3599 then
		var1_182 = i18n("several_minutes_before", math.floor(var0_182 / 60))
	elseif var0_182 <= 86399 then
		var1_182 = i18n("several_hours_before", math.floor(var0_182 / 3600))
	else
		var1_182 = i18n("several_days_before", math.floor(var0_182 / 86400))
	end

	return var1_182
end

function playMovie(arg0_183, arg1_183, arg2_183)
	local var0_183 = GameObject.Find("OverlayCamera/Overlay/UITop/MoviePanel")

	if not IsNil(var0_183) then
		pg.UIMgr.GetInstance():LoadingOn()
		WWWLoader.Inst:LoadStreamingAsset(arg0_183, function(arg0_184)
			pg.UIMgr.GetInstance():LoadingOff()

			local var0_184 = GCHandle.Alloc(arg0_184, GCHandleType.Pinned)

			setActive(var0_183, true)

			local var1_184 = var0_183:AddComponent(typeof(CriManaMovieControllerForUI))

			var1_184.player:SetData(arg0_184, arg0_184.Length)

			var1_184.target = var0_183:GetComponent(typeof(Image))
			var1_184.loop = false
			var1_184.additiveMode = false
			var1_184.playOnStart = true

			local var2_184

			var2_184 = Timer.New(function()
				if var1_184.player.status == CriMana.Player.Status.PlayEnd or var1_184.player.status == CriMana.Player.Status.Stop or var1_184.player.status == CriMana.Player.Status.Error then
					var2_184:Stop()
					Object.Destroy(var1_184)
					GCHandle.Free(var0_184)
					setActive(var0_183, false)

					if arg1_183 then
						arg1_183()
					end
				end
			end, 0.2, -1)

			var2_184:Start()
			removeOnButton(var0_183)

			if arg2_183 then
				onButton(nil, var0_183, function()
					var1_184:Stop()
					GetOrAddComponent(var0_183, typeof(Button)).onClick:RemoveAllListeners()
				end, SFX_CANCEL)
			end
		end)
	elseif arg1_183 then
		arg1_183()
	end
end

PaintCameraAdjustOn = false

function cameraPaintViewAdjust(arg0_187)
	if PaintCameraAdjustOn ~= arg0_187 then
		local var0_187 = GameObject.Find("UICamera/Canvas"):GetComponent(typeof(CanvasScaler))

		if arg0_187 then
			CameraMgr.instance.AutoAdapt = false

			CameraMgr.instance:Revert()

			var0_187.screenMatchMode = CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
			var0_187.matchWidthOrHeight = 1
		else
			CameraMgr.instance.AutoAdapt = true
			CameraMgr.instance.CurrentWidth = 1
			CameraMgr.instance.CurrentHeight = 1
			CameraMgr.instance.AspectRatio = 1.77777777777778
			var0_187.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand
		end

		PaintCameraAdjustOn = arg0_187
	end
end

function ManhattonDist(arg0_188, arg1_188)
	return math.abs(arg0_188.row - arg1_188.row) + math.abs(arg0_188.column - arg1_188.column)
end

function checkFirstHelpShow(arg0_189)
	local var0_189 = getProxy(SettingsProxy)

	if not var0_189:checkReadHelp(arg0_189) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[arg0_189].tip
		})
		var0_189:recordReadHelp(arg0_189)
	end
end

preOrientation = nil
preNotchFitterEnabled = false

function openPortrait(arg0_190)
	enableNotch(arg0_190, true)

	preOrientation = Input.deviceOrientation:ToString()

	originalPrint("Begining Orientation:" .. preOrientation)

	Screen.autorotateToPortrait = true
	Screen.autorotateToPortraitUpsideDown = true

	cameraPaintViewAdjust(true)
end

function closePortrait(arg0_191)
	enableNotch(arg0_191, false)

	Screen.autorotateToPortrait = false
	Screen.autorotateToPortraitUpsideDown = false

	originalPrint("Closing Orientation:" .. preOrientation)

	Screen.orientation = ScreenOrientation.LandscapeLeft

	local var0_191 = Timer.New(function()
		Screen.orientation = ScreenOrientation.AutoRotation
	end, 0.2, 1):Start()

	cameraPaintViewAdjust(false)
end

function enableNotch(arg0_193, arg1_193)
	if arg0_193 == nil then
		return
	end

	local var0_193 = arg0_193:GetComponent("NotchAdapt")
	local var1_193 = arg0_193:GetComponent("AspectRatioFitter")

	var0_193.enabled = arg1_193

	if var1_193 then
		if arg1_193 then
			var1_193.enabled = preNotchFitterEnabled
		else
			preNotchFitterEnabled = var1_193.enabled
			var1_193.enabled = false
		end
	end
end

function comma_value(arg0_194)
	local var0_194 = arg0_194
	local var1_194 = 0

	repeat
		local var2_194

		var0_194, var2_194 = string.gsub(var0_194, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var2_194 == 0

	return var0_194
end

local var15_0 = 0.2

function SwitchPanel(arg0_195, arg1_195, arg2_195, arg3_195, arg4_195, arg5_195)
	arg3_195 = defaultValue(arg3_195, var15_0)

	if arg5_195 then
		LeanTween.cancel(go(arg0_195))
	end

	local var0_195 = Vector3.New(tf(arg0_195).localPosition.x, tf(arg0_195).localPosition.y, tf(arg0_195).localPosition.z)

	if arg1_195 then
		var0_195.x = arg1_195
	end

	if arg2_195 then
		var0_195.y = arg2_195
	end

	local var1_195 = LeanTween.move(rtf(arg0_195), var0_195, arg3_195):setEase(LeanTweenType.easeInOutSine)

	if arg4_195 then
		var1_195:setDelay(arg4_195)
	end

	return var1_195
end

function updateActivityTaskStatus(arg0_196)
	local var0_196 = arg0_196:getConfig("config_id")
	local var1_196, var2_196 = getActivityTask(arg0_196, true)

	if not var2_196 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_196.id
		})

		return true
	end

	return false
end

function updateCrusingActivityTask(arg0_197)
	local var0_197 = getProxy(TaskProxy)
	local var1_197 = arg0_197:getNDay()

	for iter0_197, iter1_197 in ipairs(arg0_197:getConfig("config_data")) do
		local var2_197 = pg.battlepass_task_group[iter1_197]

		if var1_197 >= var2_197.time and underscore.any(underscore.flatten(var2_197.task_group), function(arg0_198)
			return var0_197:getTaskVO(arg0_198) == nil
		end) then
			pg.m02:sendNotification(GAME.CRUSING_CMD, {
				cmd = 1,
				activity_id = arg0_197.id
			})

			return true
		end
	end

	return false
end

function setShipCardFrame(arg0_199, arg1_199, arg2_199)
	arg0_199.localScale = Vector3.one
	arg0_199.anchorMin = Vector2.zero
	arg0_199.anchorMax = Vector2.one

	local var0_199 = arg2_199 or arg1_199

	GetImageSpriteFromAtlasAsync("shipframe", var0_199, arg0_199)

	local var1_199 = pg.frame_resource[var0_199]

	if var1_199 then
		local var2_199 = var1_199.param

		arg0_199.offsetMin = Vector2(var2_199[1], var2_199[2])
		arg0_199.offsetMax = Vector2(var2_199[3], var2_199[4])
	else
		arg0_199.offsetMin = Vector2.zero
		arg0_199.offsetMax = Vector2.zero
	end
end

function setRectShipCardFrame(arg0_200, arg1_200, arg2_200)
	arg0_200.localScale = Vector3.one
	arg0_200.anchorMin = Vector2.zero
	arg0_200.anchorMax = Vector2.one

	setImageSprite(arg0_200, GetSpriteFromAtlas("shipframeb", "b" .. (arg2_200 or arg1_200)))

	local var0_200 = "b" .. (arg2_200 or arg1_200)
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

function setFrameEffect(arg0_201, arg1_201)
	if arg1_201 then
		local var0_201 = arg1_201 .. "(Clone)"
		local var1_201 = false

		eachChild(arg0_201, function(arg0_202)
			setActive(arg0_202, arg0_202.name == var0_201)

			var1_201 = var1_201 or arg0_202.name == var0_201
		end)

		if not var1_201 then
			LoadAndInstantiateAsync("effect", arg1_201, function(arg0_203)
				if IsNil(arg0_201) or findTF(arg0_201, var0_201) then
					Object.Destroy(arg0_203)
				else
					setParent(arg0_203, arg0_201)
					setActive(arg0_203, true)
				end
			end)
		end
	end

	setActive(arg0_201, arg1_201)
end

function setProposeMarkIcon(arg0_204, arg1_204)
	local var0_204 = arg0_204:Find("proposeShipCard(Clone)")
	local var1_204 = arg1_204.propose and not arg1_204:ShowPropose()

	if var0_204 then
		setActive(var0_204, var1_204)
	elseif var1_204 then
		pg.PoolMgr.GetInstance():GetUI("proposeShipCard", true, function(arg0_205)
			if IsNil(arg0_204) or arg0_204:Find("proposeShipCard(Clone)") then
				pg.PoolMgr.GetInstance():ReturnUI("proposeShipCard", arg0_205)
			else
				setParent(arg0_205, arg0_204, false)
			end
		end)
	end
end

function flushShipCard(arg0_206, arg1_206)
	local var0_206 = arg1_206:rarity2bgPrint()
	local var1_206 = findTF(arg0_206, "content/bg")

	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var0_206, "", var1_206)

	local var2_206 = findTF(arg0_206, "content/ship_icon")
	local var3_206 = arg1_206 and {
		"shipYardIcon/" .. arg1_206:getPainting(),
		arg1_206:getPainting()
	} or {
		"shipYardIcon/unknown",
		""
	}

	GetImageSpriteFromAtlasAsync(var3_206[1], var3_206[2], var2_206)

	local var4_206 = arg1_206:getShipType()
	local var5_206 = findTF(arg0_206, "content/info/top/type")

	GetImageSpriteFromAtlasAsync("shiptype", shipType2print(var4_206), var5_206)
	setText(findTF(arg0_206, "content/dockyard/lv/Text"), defaultValue(arg1_206.level, 1))

	local var6_206 = arg1_206:getStar()
	local var7_206 = arg1_206:getMaxStar()
	local var8_206 = findTF(arg0_206, "content/front/stars")

	setActive(var8_206, true)

	local var9_206 = findTF(var8_206, "star_tpl")
	local var10_206 = var8_206.childCount

	for iter0_206 = 1, Ship.CONFIG_MAX_STAR do
		local var11_206 = var10_206 < iter0_206 and cloneTplTo(var9_206, var8_206) or var8_206:GetChild(iter0_206 - 1)

		setActive(var11_206, iter0_206 <= var7_206)
		triggerToggle(var11_206, iter0_206 <= var6_206)
	end

	local var12_206 = findTF(arg0_206, "content/front/frame")
	local var13_206, var14_206 = arg1_206:GetFrameAndEffect()

	setShipCardFrame(var12_206, var0_206, var13_206)
	setFrameEffect(findTF(arg0_206, "content/front/bg_other"), var14_206)
	setProposeMarkIcon(arg0_206:Find("content/dockyard/propose"), arg1_206)
end

function TweenItemAlphaAndWhite(arg0_207)
	LeanTween.cancel(arg0_207)

	local var0_207 = GetOrAddComponent(arg0_207, "CanvasGroup")

	var0_207.alpha = 0

	LeanTween.alphaCanvas(var0_207, 1, 0.2):setUseEstimatedTime(true)

	local var1_207 = findTF(arg0_207.transform, "white_mask")

	if var1_207 then
		setActive(var1_207, false)
	end
end

function ClearTweenItemAlphaAndWhite(arg0_208)
	LeanTween.cancel(arg0_208)

	GetOrAddComponent(arg0_208, "CanvasGroup").alpha = 0
end

function getGroupOwnSkins(arg0_209)
	local var0_209 = {}
	local var1_209 = getProxy(ShipSkinProxy):getSkinList()
	local var2_209 = getProxy(CollectionProxy):getShipGroup(arg0_209)

	if var2_209 then
		local var3_209 = ShipGroup.getSkinList(arg0_209)

		for iter0_209, iter1_209 in ipairs(var3_209) do
			if iter1_209.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(var1_209, iter1_209.id) or iter1_209.skin_type == ShipSkin.SKIN_TYPE_REMAKE and var2_209.trans or iter1_209.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and var2_209.married == 1 then
				var0_209[iter1_209.id] = true
			end
		end
	end

	return var0_209
end

function split(arg0_210, arg1_210)
	local var0_210 = {}

	if not arg0_210 then
		return nil
	end

	local var1_210 = #arg0_210
	local var2_210 = 1

	while var2_210 <= var1_210 do
		local var3_210 = string.find(arg0_210, arg1_210, var2_210)

		if var3_210 == nil then
			table.insert(var0_210, string.sub(arg0_210, var2_210, var1_210))

			break
		end

		table.insert(var0_210, string.sub(arg0_210, var2_210, var3_210 - 1))

		if var3_210 == var1_210 then
			table.insert(var0_210, "")

			break
		end

		var2_210 = var3_210 + 1
	end

	return var0_210
end

function NumberToChinese(arg0_211, arg1_211)
	local var0_211 = ""
	local var1_211 = #arg0_211

	for iter0_211 = 1, var1_211 do
		local var2_211 = string.sub(arg0_211, iter0_211, iter0_211)

		if var2_211 ~= "0" or var2_211 == "0" and not arg1_211 then
			if arg1_211 then
				if var1_211 >= 2 then
					if iter0_211 == 1 then
						if var2_211 == "1" then
							var0_211 = i18n("number_" .. 10)
						else
							var0_211 = i18n("number_" .. var2_211) .. i18n("number_" .. 10)
						end
					else
						var0_211 = var0_211 .. i18n("number_" .. var2_211)
					end
				else
					var0_211 = var0_211 .. i18n("number_" .. var2_211)
				end
			else
				var0_211 = var0_211 .. i18n("number_" .. var2_211)
			end
		end
	end

	return var0_211
end

function getActivityTask(arg0_212, arg1_212)
	local var0_212 = getProxy(TaskProxy)
	local var1_212 = arg0_212:getConfig("config_data")
	local var2_212 = arg0_212:getNDay(arg0_212.data1)
	local var3_212
	local var4_212
	local var5_212

	for iter0_212 = math.max(arg0_212.data3, 1), math.min(var2_212, #var1_212) do
		local var6_212 = _.flatten({
			var1_212[iter0_212]
		})

		for iter1_212, iter2_212 in ipairs(var6_212) do
			local var7_212 = var0_212:getTaskById(iter2_212)

			if var7_212 then
				return var7_212.id, var7_212
			end

			if var4_212 then
				var5_212 = var0_212:getFinishTaskById(iter2_212)

				if var5_212 then
					var4_212 = var5_212
				elseif arg1_212 then
					return iter2_212
				else
					return var4_212.id, var4_212
				end
			else
				var4_212 = var0_212:getFinishTaskById(iter2_212)
				var5_212 = var5_212 or iter2_212
			end
		end
	end

	if var4_212 then
		return var4_212.id, var4_212
	else
		return var5_212
	end
end

function setImageFromImage(arg0_213, arg1_213, arg2_213)
	local var0_213 = GetComponent(arg0_213, "Image")

	var0_213.sprite = GetComponent(arg1_213, "Image").sprite

	if arg2_213 then
		var0_213:SetNativeSize()
	end
end

function skinTimeStamp(arg0_214)
	local var0_214, var1_214, var2_214, var3_214 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_214)

	if var0_214 >= 1 then
		return i18n("limit_skin_time_day", var0_214)
	elseif var0_214 <= 0 and var1_214 > 0 then
		return i18n("limit_skin_time_day_min", var1_214, var2_214)
	elseif var0_214 <= 0 and var1_214 <= 0 and (var2_214 > 0 or var3_214 > 0) then
		return i18n("limit_skin_time_min", math.max(var2_214, 1))
	elseif var0_214 <= 0 and var1_214 <= 0 and var2_214 <= 0 and var3_214 <= 0 then
		return i18n("limit_skin_time_overtime")
	end
end

function skinCommdityTimeStamp(arg0_215)
	local var0_215 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_215 = math.max(arg0_215 - var0_215, 0)
	local var2_215 = math.floor(var1_215 / 86400)

	if var2_215 > 0 then
		return i18n("time_remaining_tip") .. var2_215 .. i18n("word_date")
	else
		local var3_215 = math.floor(var1_215 / 3600)

		if var3_215 > 0 then
			return i18n("time_remaining_tip") .. var3_215 .. i18n("word_hour")
		else
			local var4_215 = math.floor(var1_215 / 60)

			if var4_215 > 0 then
				return i18n("time_remaining_tip") .. var4_215 .. i18n("word_minute")
			else
				return i18n("time_remaining_tip") .. var1_215 .. i18n("word_second")
			end
		end
	end
end

function InstagramTimeStamp(arg0_216)
	local var0_216 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_216
	local var1_216 = var0_216 / 86400

	if var1_216 > 1 then
		return i18n("ins_word_day", math.floor(var1_216))
	else
		local var2_216 = var0_216 / 3600

		if var2_216 > 1 then
			return i18n("ins_word_hour", math.floor(var2_216))
		else
			local var3_216 = var0_216 / 60

			if var3_216 > 1 then
				return i18n("ins_word_minu", math.floor(var3_216))
			else
				return i18n("ins_word_minu", 1)
			end
		end
	end
end

function InstagramReplyTimeStamp(arg0_217)
	local var0_217 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_217
	local var1_217 = var0_217 / 86400

	if var1_217 > 1 then
		return i18n1(math.floor(var1_217) .. "d")
	else
		local var2_217 = var0_217 / 3600

		if var2_217 > 1 then
			return i18n1(math.floor(var2_217) .. "h")
		else
			local var3_217 = var0_217 / 60

			if var3_217 > 1 then
				return i18n1(math.floor(var3_217) .. "min")
			else
				return i18n1("1min")
			end
		end
	end
end

function attireTimeStamp(arg0_218)
	local var0_218, var1_218, var2_218, var3_218 = pg.TimeMgr.GetInstance():parseTimeFrom(arg0_218)

	if var0_218 <= 0 and var1_218 <= 0 and var2_218 <= 0 and var3_218 <= 0 then
		return i18n("limit_skin_time_overtime")
	else
		return i18n("attire_time_stamp", var0_218, var1_218, var2_218)
	end
end

function checkExist(arg0_219, ...)
	local var0_219 = {
		...
	}

	for iter0_219, iter1_219 in ipairs(var0_219) do
		if arg0_219 == nil then
			break
		end

		assert(type(arg0_219) == "table", "type error : intermediate target should be table")
		assert(type(iter1_219) == "table", "type error : param should be table")

		if type(arg0_219[iter1_219[1]]) == "function" then
			arg0_219 = arg0_219[iter1_219[1]](arg0_219, unpack(iter1_219[2] or {}))
		else
			arg0_219 = arg0_219[iter1_219[1]]
		end
	end

	return arg0_219
end

function AcessWithinNull(arg0_220, arg1_220)
	if arg0_220 == nil then
		return
	end

	assert(type(arg0_220) == "table")

	return arg0_220[arg1_220]
end

function showRepairMsgbox()
	local var0_221 = {
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var1_221 = {
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
	local var2_221 = {
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
			var2_221,
			var1_221,
			var0_221
		}
	})
end

function resourceVerify(arg0_225, arg1_225)
	if CSharpVersion > 35 then
		BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()

		return
	end

	local var0_225 = Application.persistentDataPath .. "/hashes.csv"
	local var1_225
	local var2_225 = PathMgr.ReadAllLines(var0_225)
	local var3_225 = {}

	if arg0_225 then
		setActive(arg0_225, true)
	else
		pg.UIMgr.GetInstance():LoadingOn()
	end

	local function var4_225()
		if arg0_225 then
			setActive(arg0_225, false)
		else
			pg.UIMgr.GetInstance():LoadingOff()
		end

		print(var1_225)

		if var1_225 then
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

	local var5_225 = var2_225.Length
	local var6_225

	local function var7_225(arg0_228)
		if arg0_228 < 0 then
			var4_225()

			return
		end

		if arg1_225 then
			setSlider(arg1_225, 0, var5_225, var5_225 - arg0_228)
		end

		local var0_228 = string.split(var2_225[arg0_228], ",")
		local var1_228 = var0_228[1]
		local var2_228 = var0_228[3]
		local var3_228 = PathMgr.getAssetBundle(var1_228)

		if PathMgr.FileExists(var3_228) then
			local var4_228 = PathMgr.ReadAllBytes(PathMgr.getAssetBundle(var1_228))

			if var2_228 == HashUtil.CalcMD5(var4_228) then
				onNextTick(function()
					var7_225(arg0_228 - 1)
				end)

				return
			end
		end

		var1_225 = var1_228

		var4_225()
	end

	var7_225(var5_225 - 1)
end

function splitByWordEN(arg0_230, arg1_230)
	local var0_230 = string.split(arg0_230, " ")
	local var1_230 = ""
	local var2_230 = ""
	local var3_230 = arg1_230:GetComponent(typeof(RectTransform))
	local var4_230 = arg1_230:GetComponent(typeof(Text))
	local var5_230 = var3_230.rect.width

	for iter0_230, iter1_230 in ipairs(var0_230) do
		local var6_230 = var2_230

		var2_230 = var2_230 == "" and iter1_230 or var2_230 .. " " .. iter1_230

		setText(arg1_230, var2_230)

		if var5_230 < var4_230.preferredWidth then
			var1_230 = var1_230 == "" and var6_230 or var1_230 .. "\n" .. var6_230
			var2_230 = iter1_230
		end

		if iter0_230 >= #var0_230 then
			var1_230 = var1_230 == "" and var2_230 or var1_230 .. "\n" .. var2_230
		end
	end

	return var1_230
end

function checkBirthFormat(arg0_231)
	if #arg0_231 ~= 8 then
		return false
	end

	local var0_231 = 0
	local var1_231 = #arg0_231

	while var0_231 < var1_231 do
		local var2_231 = string.byte(arg0_231, var0_231 + 1)

		if var2_231 < 48 or var2_231 > 57 then
			return false
		end

		var0_231 = var0_231 + 1
	end

	return true
end

function isHalfBodyLive2D(arg0_232)
	local var0_232 = {
		"biaoqiang",
		"z23",
		"lafei",
		"lingbo",
		"mingshi",
		"xuefeng"
	}

	return _.any(var0_232, function(arg0_233)
		return arg0_233 == arg0_232
	end)
end

function GetServerState(arg0_234)
	local var0_234 = -1
	local var1_234 = 0
	local var2_234 = 1
	local var3_234 = 2
	local var4_234 = NetConst.GetServerStateUrl()

	if PLATFORM_CODE == PLATFORM_CH then
		var4_234 = string.gsub(var4_234, "https", "http")
	end

	VersionMgr.Inst:WebRequest(var4_234, function(arg0_235, arg1_235)
		local var0_235 = true
		local var1_235 = false

		for iter0_235 in string.gmatch(arg1_235, "\"state\":%d") do
			if iter0_235 ~= "\"state\":1" then
				var0_235 = false
			end

			var1_235 = true
		end

		if not var1_235 then
			var0_235 = false
		end

		if arg0_234 ~= nil then
			arg0_234(var0_235 and var2_234 or var1_234)
		end
	end)
end

function setScrollText(arg0_236, arg1_236)
	GetOrAddComponent(arg0_236, "ScrollText"):SetText(arg1_236)
end

function changeToScrollText(arg0_237, arg1_237)
	local var0_237 = GetComponent(arg0_237, typeof(Text))

	assert(var0_237, "without component<Text>")

	local var1_237 = arg0_237:Find("subText")

	if not var1_237 then
		var1_237 = cloneTplTo(arg0_237, arg0_237, "subText")

		eachChild(arg0_237, function(arg0_238)
			setActive(arg0_238, arg0_238 == var1_237)
		end)

		arg0_237:GetComponent(typeof(Text)).enabled = false
	end

	setScrollText(var1_237, arg1_237)
end

local var16_0
local var17_0
local var18_0
local var19_0

local function var20_0(arg0_239, arg1_239, arg2_239)
	local var0_239 = arg0_239:Find("base")
	local var1_239, var2_239, var3_239 = Equipment.GetInfoTrans(arg1_239, arg2_239)

	if arg1_239.nextValue then
		local var4_239 = {
			name = arg1_239.name,
			type = arg1_239.type,
			value = arg1_239.nextValue
		}
		local var5_239, var6_239 = Equipment.GetInfoTrans(var4_239, arg2_239)

		var2_239 = var2_239 .. setColorStr("   >   " .. var6_239, COLOR_GREEN)
	end

	setText(var0_239:Find("name"), var1_239)

	if var3_239 then
		local var7_239 = "<color=#afff72>(+" .. ys.Battle.BattleConst.UltimateBonus.AuxBoostValue * 100 .. "%)</color>"

		setText(var0_239:Find("value"), var2_239 .. var7_239)
	else
		setText(var0_239:Find("value"), var2_239)
	end

	setActive(var0_239:Find("value/up"), arg1_239.compare and arg1_239.compare > 0)
	setActive(var0_239:Find("value/down"), arg1_239.compare and arg1_239.compare < 0)
	triggerToggle(var0_239, arg1_239.lock_open)

	if not arg1_239.lock_open and arg1_239.sub and #arg1_239.sub > 0 then
		GetComponent(var0_239, typeof(Toggle)).enabled = true
	else
		setActive(var0_239:Find("name/close"), false)
		setActive(var0_239:Find("name/open"), false)

		GetComponent(var0_239, typeof(Toggle)).enabled = false
	end
end

local function var21_0(arg0_240, arg1_240, arg2_240, arg3_240)
	var20_0(arg0_240, arg2_240, arg3_240)

	if not arg2_240.sub or #arg2_240.sub == 0 then
		return
	end

	var18_0(arg0_240:Find("subs"), arg1_240, arg2_240.sub, arg3_240)
end

function var18_0(arg0_241, arg1_241, arg2_241, arg3_241)
	removeAllChildren(arg0_241)
	var19_0(arg0_241, arg1_241, arg2_241, arg3_241)
end

function var19_0(arg0_242, arg1_242, arg2_242, arg3_242)
	for iter0_242, iter1_242 in ipairs(arg2_242) do
		local var0_242 = cloneTplTo(arg1_242, arg0_242)

		var21_0(var0_242, arg1_242, iter1_242, arg3_242)
	end
end

function updateEquipInfo(arg0_243, arg1_243, arg2_243, arg3_243)
	local var0_243 = arg0_243:Find("attr_tpl")

	var18_0(arg0_243:Find("attrs"), var0_243, arg1_243.attrs, arg3_243)
	setActive(arg0_243:Find("skill"), arg2_243)

	if arg2_243 then
		var21_0(arg0_243:Find("skill/attr"), var0_243, {
			name = i18n("skill"),
			value = setColorStr(arg2_243.name, "#FFDE00FF")
		}, arg3_243)
		setText(arg0_243:Find("skill/value/Text"), getSkillDescGet(arg2_243.id))
	end

	setActive(arg0_243:Find("weapon"), #arg1_243.weapon.sub > 0)

	if #arg1_243.weapon.sub > 0 then
		var18_0(arg0_243:Find("weapon"), var0_243, {
			arg1_243.weapon
		}, arg3_243)
	end

	setActive(arg0_243:Find("equip_info"), #arg1_243.equipInfo.sub > 0)

	if #arg1_243.equipInfo.sub > 0 then
		var18_0(arg0_243:Find("equip_info"), var0_243, {
			arg1_243.equipInfo
		}, arg3_243)
	end

	var21_0(arg0_243:Find("part/attr"), var0_243, {
		name = i18n("equip_info_23")
	}, arg3_243)

	local var1_243 = arg0_243:Find("part/value")
	local var2_243 = var1_243:Find("label")
	local var3_243 = {}
	local var4_243 = {}

	if #arg1_243.part[1] == 0 and #arg1_243.part[2] == 0 then
		setmetatable(var3_243, {
			__index = function(arg0_244, arg1_244)
				return true
			end
		})
		setmetatable(var4_243, {
			__index = function(arg0_245, arg1_245)
				return true
			end
		})
	else
		for iter0_243, iter1_243 in ipairs(arg1_243.part[1]) do
			var3_243[iter1_243] = true
		end

		for iter2_243, iter3_243 in ipairs(arg1_243.part[2]) do
			var4_243[iter3_243] = true
		end
	end

	local var5_243 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var3_243, var4_243)

	UIItemList.StaticAlign(var1_243, var2_243, #var5_243, function(arg0_246, arg1_246, arg2_246)
		arg1_246 = arg1_246 + 1

		if arg0_246 == UIItemList.EventUpdate then
			local var0_246 = var5_243[arg1_246]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_246), arg2_246)
			setActive(arg2_246:Find("main"), var3_243[var0_246] and not var4_243[var0_246])
			setActive(arg2_246:Find("sub"), var4_243[var0_246] and not var3_243[var0_246])
			setImageAlpha(arg2_246, not var3_243[var0_246] and not var4_243[var0_246] and 0.3 or 1)
		end
	end)
end

function updateEquipUpgradeInfo(arg0_247, arg1_247, arg2_247)
	local var0_247 = arg0_247:Find("attr_tpl")

	var18_0(arg0_247:Find("attrs"), var0_247, arg1_247.attrs, arg2_247)
	setActive(arg0_247:Find("weapon"), #arg1_247.weapon.sub > 0)

	if #arg1_247.weapon.sub > 0 then
		var18_0(arg0_247:Find("weapon"), var0_247, {
			arg1_247.weapon
		}, arg2_247)
	end

	setActive(arg0_247:Find("equip_info"), #arg1_247.equipInfo.sub > 0)

	if #arg1_247.equipInfo.sub > 0 then
		var18_0(arg0_247:Find("equip_info"), var0_247, {
			arg1_247.equipInfo
		}, arg2_247)
	end
end

function setCanvasOverrideSorting(arg0_248, arg1_248)
	local var0_248 = arg0_248.parent

	arg0_248:SetParent(pg.LayerWeightMgr.GetInstance().uiOrigin, false)

	if isActive(arg0_248) then
		GetOrAddComponent(arg0_248, typeof(Canvas)).overrideSorting = arg1_248
	else
		setActive(arg0_248, true)

		GetOrAddComponent(arg0_248, typeof(Canvas)).overrideSorting = arg1_248

		setActive(arg0_248, false)
	end

	arg0_248:SetParent(var0_248, false)
end

function createNewGameObject(arg0_249, arg1_249)
	local var0_249 = GameObject.New()

	if arg0_249 then
		var0_249.name = "model"
	end

	var0_249.layer = arg1_249 or Layer.UI

	return GetOrAddComponent(var0_249, "RectTransform")
end

function CreateShell(arg0_250)
	if type(arg0_250) ~= "table" and type(arg0_250) ~= "userdata" then
		return arg0_250
	end

	local var0_250 = setmetatable({
		__index = arg0_250
	}, arg0_250)

	return setmetatable({}, var0_250)
end

function CameraFittingSettin(arg0_251)
	local var0_251 = GetComponent(arg0_251, typeof(Camera))
	local var1_251 = 1.77777777777778
	local var2_251 = Screen.width / Screen.height

	if var2_251 < var1_251 then
		local var3_251 = var2_251 / var1_251

		var0_251.rect = var0_0.Rect.New(0, (1 - var3_251) / 2, 1, var3_251)
	end
end

function SwitchSpecialChar(arg0_252, arg1_252)
	if PLATFORM_CODE ~= PLATFORM_US then
		arg0_252 = arg0_252:gsub(" ", " ")
		arg0_252 = arg0_252:gsub("\t", "    ")
	end

	if not arg1_252 then
		arg0_252 = arg0_252:gsub("\n", " ")
	end

	return arg0_252
end

function AfterCheck(arg0_253, arg1_253)
	local var0_253 = {}

	for iter0_253, iter1_253 in ipairs(arg0_253) do
		var0_253[iter0_253] = iter1_253[1]()
	end

	arg1_253()

	for iter2_253, iter3_253 in ipairs(arg0_253) do
		if var0_253[iter2_253] ~= iter3_253[1]() then
			iter3_253[2]()
		end

		var0_253[iter2_253] = iter3_253[1]()
	end
end

function CompareFuncs(arg0_254, arg1_254)
	local var0_254 = {}

	local function var1_254(arg0_255, arg1_255)
		var0_254[arg0_255] = var0_254[arg0_255] or {}
		var0_254[arg0_255][arg1_255] = var0_254[arg0_255][arg1_255] or arg0_254[arg0_255](arg1_255)

		return var0_254[arg0_255][arg1_255]
	end

	return function(arg0_256, arg1_256)
		local var0_256 = 1

		while var0_256 <= #arg0_254 do
			local var1_256 = var1_254(var0_256, arg0_256)
			local var2_256 = var1_254(var0_256, arg1_256)

			if var1_256 == var2_256 then
				var0_256 = var0_256 + 1
			else
				return var1_256 < var2_256
			end
		end

		return tobool(arg1_254)
	end
end

function DropResultIntegration(arg0_257)
	local var0_257 = {}
	local var1_257 = 1

	while var1_257 <= #arg0_257 do
		local var2_257 = arg0_257[var1_257].type
		local var3_257 = arg0_257[var1_257].id

		var0_257[var2_257] = var0_257[var2_257] or {}

		if var0_257[var2_257][var3_257] then
			local var4_257 = arg0_257[var0_257[var2_257][var3_257]]
			local var5_257 = table.remove(arg0_257, var1_257)

			var4_257.count = var4_257.count + var5_257.count
		else
			var0_257[var2_257][var3_257] = var1_257
			var1_257 = var1_257 + 1
		end
	end

	local var6_257 = {
		function(arg0_258)
			local var0_258 = arg0_258.type
			local var1_258 = arg0_258.id

			if var0_258 == DROP_TYPE_SHIP then
				return 1
			elseif var0_258 == DROP_TYPE_RESOURCE then
				if var1_258 == 1 then
					return 2
				else
					return 3
				end
			elseif var0_258 == DROP_TYPE_ITEM then
				if var1_258 == 59010 then
					return 4
				elseif var1_258 == 59900 then
					return 5
				else
					local var2_258 = Item.getConfigData(var1_258)
					local var3_258 = var2_258 and var2_258.type or 0

					if var3_258 == 9 then
						return 6
					elseif var3_258 == 5 then
						return 7
					elseif var3_258 == 4 then
						return 8
					elseif var3_258 == 7 then
						return 9
					end
				end
			elseif var0_258 == DROP_TYPE_VITEM and var1_258 == 59011 then
				return 4
			end

			return 100
		end,
		function(arg0_259)
			local var0_259

			if arg0_259.type == DROP_TYPE_SHIP then
				var0_259 = pg.ship_data_statistics[arg0_259.id]
			elseif arg0_259.type == DROP_TYPE_ITEM then
				var0_259 = Item.getConfigData(arg0_259.id)
			end

			return (var0_259 and var0_259.rarity or 0) * -1
		end,
		function(arg0_260)
			return arg0_260.id
		end
	}

	table.sort(arg0_257, CompareFuncs(var6_257))
end

function getLoginConfig()
	local var0_261 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_261 = 1

	for iter0_261, iter1_261 in ipairs(pg.login.all) do
		if pg.login[iter1_261].date ~= "stop" then
			local var2_261, var3_261 = parseTimeConfig(pg.login[iter1_261].date)

			assert(not var3_261)

			if pg.TimeMgr.GetInstance():inTime(var2_261, var0_261) then
				var1_261 = iter1_261

				break
			end
		end
	end

	local var4_261 = pg.login[var1_261].login_static

	var4_261 = var4_261 ~= "" and var4_261 or "login"

	local var5_261 = pg.login[var1_261].login_cri
	local var6_261 = var5_261 ~= "" and true or false
	local var7_261 = pg.login[var1_261].op_play == 1 and true or false
	local var8_261 = pg.login[var1_261].op_time

	if var8_261 == "" or not pg.TimeMgr.GetInstance():inTime(var8_261, var0_261) then
		var7_261 = false
	end

	local var9_261 = var8_261 == "" and var8_261 or table.concat(var8_261[1][1])

	return var6_261, var6_261 and var5_261 or var4_261, pg.login[var1_261].bgm, var7_261, var9_261
end

function setIntimacyIcon(arg0_262, arg1_262, arg2_262)
	local var0_262 = {}
	local var1_262

	seriesAsync({
		function(arg0_263)
			if arg0_262.childCount > 0 then
				var1_262 = arg0_262:GetChild(0)

				arg0_263()
			else
				LoadAndInstantiateAsync("template", "intimacytpl", function(arg0_264)
					var1_262 = tf(arg0_264)

					setParent(var1_262, arg0_262)
					arg0_263()
				end)
			end
		end,
		function(arg0_265)
			setImageAlpha(var1_262, arg2_262 and 0 or 1)
			eachChild(var1_262, function(arg0_266)
				setActive(arg0_266, false)
			end)

			if arg2_262 then
				local var0_265 = var1_262:Find(arg2_262 .. "(Clone)")

				if not var0_265 then
					LoadAndInstantiateAsync("ui", arg2_262, function(arg0_267)
						setParent(arg0_267, var1_262)
						setActive(arg0_267, true)
					end)
				else
					setActive(var0_265, true)
				end
			elseif arg1_262 then
				setImageSprite(var1_262, GetSpriteFromAtlas("energy", arg1_262), true)
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

function switch(arg0_270, arg1_270, arg2_270, ...)
	if arg1_270[arg0_270] then
		return arg1_270[arg0_270](...)
	elseif arg2_270 then
		return arg2_270(...)
	end
end

function parseTimeConfig(arg0_271)
	if type(arg0_271[1]) == "table" then
		return arg0_271[2], arg0_271[1]
	else
		return arg0_271
	end
end

local var23_0 = {
	__add = function(arg0_272, arg1_272)
		return NewPos(arg0_272.x + arg1_272.x, arg0_272.y + arg1_272.y)
	end,
	__sub = function(arg0_273, arg1_273)
		return NewPos(arg0_273.x - arg1_273.x, arg0_273.y - arg1_273.y)
	end,
	__mul = function(arg0_274, arg1_274)
		if type(arg1_274) == "number" then
			return NewPos(arg0_274.x * arg1_274, arg0_274.y * arg1_274)
		else
			return NewPos(arg0_274.x * arg1_274.x, arg0_274.y * arg1_274.y)
		end
	end,
	__eq = function(arg0_275, arg1_275)
		return arg0_275.x == arg1_275.x and arg0_275.y == arg1_275.y
	end,
	__tostring = function(arg0_276)
		return arg0_276.x .. "_" .. arg0_276.y
	end
}

function NewPos(arg0_277, arg1_277)
	assert(arg0_277 and arg1_277)

	local var0_277 = setmetatable({
		x = arg0_277,
		y = arg1_277
	}, var23_0)

	function var0_277.SqrMagnitude(arg0_278)
		return arg0_278.x * arg0_278.x + arg0_278.y * arg0_278.y
	end

	function var0_277.Normalize(arg0_279)
		local var0_279 = arg0_279:SqrMagnitude()

		if var0_279 > 1e-05 then
			return arg0_279 * (1 / math.sqrt(var0_279))
		else
			return NewPos(0, 0)
		end
	end

	return var0_277
end

local var24_0

function Timekeeping()
	warning(Time.realtimeSinceStartup - (var24_0 or Time.realtimeSinceStartup), Time.realtimeSinceStartup)

	var24_0 = Time.realtimeSinceStartup
end

function GetRomanDigit(arg0_281)
	return (string.char(226, 133, 160 + (arg0_281 - 1)))
end

function quickPlayAnimator(arg0_282, arg1_282)
	arg0_282:GetComponent(typeof(Animator)):Play(arg1_282, -1, 0)
end

function getSurveyUrl(arg0_283)
	local var0_283 = pg.survey_data_template[arg0_283]
	local var1_283

	if not IsUnityEditor then
		if PLATFORM_CODE == PLATFORM_CH then
			local var2_283 = getProxy(UserProxy):GetCacheGatewayInServerLogined()

			if var2_283 == PLATFORM_ANDROID then
				if LuaHelper.GetCHPackageType() == PACKAGE_TYPE_BILI then
					var1_283 = var0_283.main_url
				else
					var1_283 = var0_283.uo_url
				end
			elseif var2_283 == PLATFORM_IPHONEPLAYER then
				var1_283 = var0_283.ios_url
			end
		elseif PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP then
			var1_283 = var0_283.main_url
		end
	else
		var1_283 = var0_283.main_url
	end

	local var3_283 = getProxy(PlayerProxy):getRawData().id
	local var4_283 = getProxy(UserProxy):getRawData().arg2 or ""
	local var5_283
	local var6_283 = PLATFORM == PLATFORM_ANDROID and 1 or PLATFORM == PLATFORM_IPHONEPLAYER and 2 or 3
	local var7_283 = getProxy(UserProxy):getRawData()
	local var8_283 = getProxy(ServerProxy):getRawData()[var7_283 and var7_283.server or 0]
	local var9_283 = var8_283 and var8_283.id or ""
	local var10_283 = getProxy(PlayerProxy):getRawData().level
	local var11_283 = var3_283 .. "_" .. arg0_283
	local var12_283 = var1_283
	local var13_283 = {
		var3_283,
		var4_283,
		var6_283,
		var9_283,
		var10_283,
		var11_283
	}

	if var12_283 then
		for iter0_283, iter1_283 in ipairs(var13_283) do
			var12_283 = string.gsub(var12_283, "$" .. iter0_283, tostring(iter1_283))
		end
	end

	warning(var12_283)

	return var12_283
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

function FilterVarchar(arg0_285)
	assert(type(arg0_285) == "string" or type(arg0_285) == "table")

	if arg0_285 == "" then
		return nil
	end

	return arg0_285
end

function getGameset(arg0_286)
	local var0_286 = pg.gameset[arg0_286]

	assert(var0_286)

	return {
		var0_286.key_value,
		var0_286.description
	}
end

function getDorm3dGameset(arg0_287)
	local var0_287 = pg.dorm3d_set[arg0_287]

	assert(var0_287)

	return {
		var0_287.key_value_int,
		var0_287.key_value_varchar
	}
end

function GetItemsOverflowDic(arg0_288)
	arg0_288 = arg0_288 or {}

	local var0_288 = {
		[DROP_TYPE_ITEM] = {},
		[DROP_TYPE_RESOURCE] = {},
		[DROP_TYPE_EQUIP] = 0,
		[DROP_TYPE_SHIP] = 0,
		[DROP_TYPE_WORLD_ITEM] = 0
	}

	while #arg0_288 > 0 do
		local var1_288 = table.remove(arg0_288)

		switch(var1_288.type, {
			[DROP_TYPE_ITEM] = function()
				if var1_288:getConfig("open_directly") == 1 then
					for iter0_289, iter1_289 in ipairs(var1_288:getConfig("display_icon")) do
						local var0_289 = Drop.Create(iter1_289)

						var0_289.count = var0_289.count * var1_288.count

						table.insert(arg0_288, var0_289)
					end
				elseif var1_288:getSubClass():IsShipExpType() then
					var0_288[var1_288.type][var1_288.id] = defaultValue(var0_288[var1_288.type][var1_288.id], 0) + var1_288.count
				end
			end,
			[DROP_TYPE_RESOURCE] = function()
				var0_288[var1_288.type][var1_288.id] = defaultValue(var0_288[var1_288.type][var1_288.id], 0) + var1_288.count
			end,
			[DROP_TYPE_EQUIP] = function()
				var0_288[var1_288.type] = var0_288[var1_288.type] + var1_288.count
			end,
			[DROP_TYPE_SHIP] = function()
				var0_288[var1_288.type] = var0_288[var1_288.type] + var1_288.count
			end,
			[DROP_TYPE_WORLD_ITEM] = function()
				var0_288[var1_288.type] = var0_288[var1_288.type] + var1_288.count
			end
		})
	end

	return var0_288
end

function CheckOverflow(arg0_294, arg1_294)
	local var0_294 = {}
	local var1_294 = arg0_294[DROP_TYPE_RESOURCE][PlayerConst.ResGold] or 0
	local var2_294 = arg0_294[DROP_TYPE_RESOURCE][PlayerConst.ResOil] or 0
	local var3_294 = arg0_294[DROP_TYPE_EQUIP]
	local var4_294 = arg0_294[DROP_TYPE_SHIP]
	local var5_294 = getProxy(PlayerProxy):getRawData()
	local var6_294 = false

	if arg1_294 then
		local var7_294 = var5_294:OverStore(PlayerConst.ResStoreGold, var1_294)
		local var8_294 = var5_294:OverStore(PlayerConst.ResStoreOil, var2_294)

		if var7_294 > 0 or var8_294 > 0 then
			var0_294.isStoreOverflow = {
				var7_294,
				var8_294
			}
		end
	else
		if var1_294 > 0 and var5_294:GoldMax(var1_294) then
			return false, "gold"
		end

		if var2_294 > 0 and var5_294:OilMax(var2_294) then
			return false, "oil"
		end
	end

	var0_294.isExpBookOverflow = {}

	for iter0_294, iter1_294 in pairs(arg0_294[DROP_TYPE_ITEM]) do
		local var9_294 = Item.getConfigData(iter0_294)

		if getProxy(BagProxy):getItemCountById(iter0_294) + iter1_294 > var9_294.max_num then
			table.insert(var0_294.isExpBookOverflow, iter0_294)
		end
	end

	local var10_294 = getProxy(EquipmentProxy):getCapacity()

	if var3_294 > 0 and var3_294 + var10_294 > var5_294:getMaxEquipmentBag() then
		return false, "equip"
	end

	local var11_294 = getProxy(BayProxy):getShipCount()

	if var4_294 > 0 and var4_294 + var11_294 > var5_294:getMaxShipBag() then
		return false, "ship"
	end

	return true, var0_294
end

function CheckShipExpOverflow(arg0_295)
	local var0_295 = getProxy(BagProxy)

	for iter0_295, iter1_295 in pairs(arg0_295[DROP_TYPE_ITEM]) do
		if var0_295:getItemCountById(iter0_295) + iter1_295 > Item.getConfigData(iter0_295).max_num then
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

function RegisterDetailButton(arg0_296, arg1_296, arg2_296)
	Drop.Change(arg2_296)
	switch(arg2_296.type, {
		[DROP_TYPE_ITEM] = function()
			if arg2_296:getConfig("type") == Item.SKIN_ASSIGNED_TYPE then
				local var0_297 = Item.getConfigData(arg2_296.id).usage_arg
				local var1_297 = var0_297[3]

				if Item.InTimeLimitSkinAssigned(arg2_296.id) then
					var1_297 = table.mergeArray(var0_297[2], var1_297, true)
				end

				local var2_297 = {}

				for iter0_297, iter1_297 in ipairs(var0_297[2]) do
					var2_297[iter1_297] = true
				end

				onButton(arg0_296, arg1_296, function()
					arg0_296:closeView()
					pg.m02:sendNotification(GAME.LOAD_LAYERS, {
						parentContext = getProxy(ContextProxy):getCurrentContext(),
						context = Context.New({
							viewComponent = SelectSkinLayer,
							mediator = SkinAtlasMediator,
							data = {
								mode = SelectSkinLayer.MODE_VIEW,
								itemId = arg2_296.id,
								selectableSkinList = underscore.map(var1_297, function(arg0_299)
									return SelectableSkin.New({
										id = arg0_299,
										isTimeLimit = var2_297[arg0_299] or false
									})
								end)
							}
						})
					})
				end, SFX_PANEL)
				setActive(arg1_296, true)
			else
				local var3_297 = getProxy(TechnologyProxy):getItemCanUnlockBluePrint(arg2_296.id) and "tech" or arg2_296:getConfig("type")

				if var25_0[var3_297] then
					local var4_297 = {
						item2Row = true,
						content = i18n(var25_0[var3_297]),
						itemList = underscore.map(arg2_296:getConfig("display_icon"), function(arg0_300)
							return Drop.Create(arg0_300)
						end)
					}

					if var3_297 == 11 then
						onButton(arg0_296, arg1_296, function()
							arg0_296:emit(BaseUI.ON_DROP_LIST_OWN, var4_297)
						end, SFX_PANEL)
					else
						onButton(arg0_296, arg1_296, function()
							arg0_296:emit(BaseUI.ON_DROP_LIST, var4_297)
						end, SFX_PANEL)
					end
				end

				setActive(arg1_296, tobool(var25_0[var3_297]))
			end
		end,
		[DROP_TYPE_EQUIP] = function()
			onButton(arg0_296, arg1_296, function()
				arg0_296:emit(BaseUI.ON_DROP, arg2_296)
			end, SFX_PANEL)
			setActive(arg1_296, true)
		end,
		[DROP_TYPE_SPWEAPON] = function()
			onButton(arg0_296, arg1_296, function()
				arg0_296:emit(BaseUI.ON_DROP, arg2_296)
			end, SFX_PANEL)
			setActive(arg1_296, true)
		end
	}, function()
		setActive(arg1_296, false)
	end)
end

function UpdateOwnDisplay(arg0_308, arg1_308)
	local var0_308, var1_308 = arg1_308:getOwnedCount()

	setActive(arg0_308, var1_308 and var0_308 > 0)

	if var1_308 and var0_308 > 0 then
		setText(arg0_308:Find("label"), i18n("word_own1"))
		setText(arg0_308:Find("Text"), var0_308)
	end
end

function Damp(arg0_309, arg1_309, arg2_309)
	arg1_309 = Mathf.Max(1, arg1_309)

	local var0_309 = Mathf.Epsilon

	if arg1_309 < var0_309 or var0_309 > Mathf.Abs(arg0_309) then
		return arg0_309
	end

	if arg2_309 < var0_309 then
		return 0
	end

	local var1_309 = -4.605170186

	return arg0_309 * (1 - Mathf.Exp(var1_309 * arg2_309 / arg1_309))
end

function checkCullResume(arg0_310)
	if not ReflectionHelp.RefCallMethodEx(typeof("UnityEngine.CanvasRenderer"), "GetMaterial", GetComponent(arg0_310, "CanvasRenderer"), {
		typeof("System.Int32")
	}, {
		0
	}) then
		local var0_310 = arg0_310:GetComponentsInChildren(typeof(MeshImage))

		for iter0_310 = 1, var0_310.Length do
			var0_310[iter0_310 - 1]:SetVerticesDirty()
		end

		return false
	end

	return true
end

function parseEquipCode(arg0_311)
	local var0_311 = {}

	if arg0_311 and arg0_311 ~= "" then
		local var1_311 = base64.dec(arg0_311)

		var0_311 = string.split(var1_311, "/")
		var0_311[5], var0_311[6] = unpack(string.split(var0_311[5], "\\"))

		if #var0_311 < 6 or arg0_311 ~= base64.enc(table.concat({
			table.concat(underscore.first(var0_311, 5), "/"),
			var0_311[6]
		}, "\\")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_illegal"))

			var0_311 = {}
		end
	end

	for iter0_311 = 1, 6 do
		var0_311[iter0_311] = var0_311[iter0_311] and tonumber(var0_311[iter0_311], 32) or 0
	end

	return var0_311
end

function buildEquipCode(arg0_312)
	local var0_312 = underscore.map(arg0_312:getAllEquipments(), function(arg0_313)
		return ConversionBase(32, arg0_313 and arg0_313.id or 0)
	end)
	local var1_312 = {
		table.concat(var0_312, "/"),
		ConversionBase(32, checkExist(arg0_312:GetSpWeapon(), {
			"id"
		}) or 0)
	}

	return base64.enc(table.concat(var1_312, "\\"))
end

function setDirectorSpeed(arg0_314, arg1_314)
	GetComponent(arg0_314, "TimelineSpeed"):SetTimelineSpeed(arg1_314)
end

function setDefaultZeroMetatable(arg0_315)
	return setmetatable(arg0_315, {
		__index = function(arg0_316, arg1_316)
			if rawget(arg0_316, arg1_316) == nil then
				arg0_316[arg1_316] = 0
			end

			return arg0_316[arg1_316]
		end
	})
end

function checkABExist(arg0_317)
	if EDITOR_TOOL then
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_317)) or ResourceMgr.Inst:AssetExist(arg0_317)
	else
		return PathMgr.FileExists(PathMgr.getAssetBundle(arg0_317))
	end
end
