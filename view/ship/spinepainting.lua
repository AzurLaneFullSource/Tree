local var0_0 = class("SpinePainting")
local var1_0 = require("Mgr/Pool/PoolUtil")
local var2_0 = {
	"aimudeng_4",
	"aimudeng_4M"
}
local var3_0 = {
	"gaoxiong_6",
	"aimudeng_4M"
}

function var0_0.GenerateData(arg0_1)
	local var0_1 = {
		SetData = function(arg0_2, arg1_2)
			arg0_2.ship = arg1_2.ship
			arg0_2.parent = arg1_2.parent
			arg0_2.effectParent = arg1_2.effectParent

			local var0_2 = arg0_2:GetShipSkinConfig()

			arg0_2.pos = arg1_2.position + BuildVector3(var0_2.spine_offset[1])

			local var1_2 = var0_2.spine_offset[2][1]

			arg0_2.scale = Vector3(var1_2, var1_2, var1_2)

			if #var0_2.special_effects > 0 then
				arg0_2.bgEffectName = var0_2.special_effects[1]
				arg0_2.bgEffectPos = arg1_2.position + BuildVector3(var0_2.special_effects[2])

				local var2_2 = var0_2.special_effects[3][1]

				arg0_2.bgEffectScale = Vector3(var2_2, var2_2, var2_2)
			end
		end,
		GetShipName = function(arg0_3)
			return arg0_3.ship:getPainting()
		end,
		GetShipSkinConfig = function(arg0_4)
			return arg0_4.ship:GetSkinConfig()
		end,
		isEmpty = function(arg0_5)
			return arg0_5.ship == nil
		end,
		Clear = function(arg0_6)
			arg0_6.ship = nil
			arg0_6.parent = nil
			arg0_6.scale = nil
			arg0_6.pos = nil
			arg0_6.bgEffectName = nil
			arg0_6.bgEffectPos = nil
			arg0_6.bgEffectScale = nil
			arg0_6.effectParent = nil
		end
	}

	var0_1:SetData(arg0_1)

	return var0_1
end

local function var4_0(arg0_7, arg1_7)
	arg0_7._go = arg1_7
	arg0_7._tf = tf(arg1_7)

	UIUtil.SetLayerRecursively(arg0_7._go, LayerMask.NameToLayer("UI"))
	arg0_7._tf:SetParent(arg0_7._spinePaintingData.parent, true)

	arg0_7._tf.localScale = arg0_7._spinePaintingData.scale
	arg0_7._tf.localPosition = arg0_7._spinePaintingData.pos
	arg0_7.spineAnimList = {}

	local var0_7 = arg0_7._tf:GetComponent(typeof(ItemList)).prefabItem

	for iter0_7 = 0, var0_7.Length - 1 do
		arg0_7.spineAnimList[#arg0_7.spineAnimList + 1] = GetOrAddComponent(var0_7[iter0_7], "SpineAnimUI")
	end

	local var1_7 = #arg0_7.spineAnimList

	assert(var1_7 > 0, "动态立绘至少要保证有一个spine动画，请检查" .. arg0_7._spinePaintingData:GetShipName())

	if var1_7 == 1 then
		arg0_7.mainSpineAnim = arg0_7.spineAnimList[1]
	else
		arg0_7.mainSpineAnim = arg0_7.spineAnimList[#arg0_7.spineAnimList]
	end

	arg0_7._skeletonGraphic = arg0_7.mainSpineAnim:GetComponent("SkeletonGraphic")
	arg0_7.idleName = arg0_7:getNormalName()

	arg0_7:checkActionShow()
end

function var0_0.getNormalName(arg0_8)
	return "normal"
end

local function var5_0(arg0_9, arg1_9)
	arg0_9._bgEffectGo = arg1_9
	arg0_9._bgEffectTf = tf(arg1_9)

	UIUtil.SetLayerRecursively(arg0_9._bgEffectGo, LayerMask.NameToLayer("UI"))
	arg0_9._bgEffectTf:SetParent(arg0_9._spinePaintingData.effectParent, true)

	arg0_9._bgEffectTf.localScale = arg0_9._spinePaintingData.bgEffectScale
	arg0_9._bgEffectTf.localPosition = arg0_9._spinePaintingData.bgEffectPos
end

function var0_0.Ctor(arg0_10, arg1_10, arg2_10)
	arg0_10._spinePaintingData = arg1_10
	arg0_10._loader = AutoLoader.New()

	parallelAsync({
		function(arg0_11)
			local var0_11 = arg0_10._spinePaintingData:GetShipName()
			local var1_11, var2_11 = HXSet.autoHxShift("spinepainting/", var0_11)
			local var3_11 = var1_11 .. var2_11

			arg0_10._loader:LoadPrefab(var3_11, nil, function(arg0_12)
				var4_0(arg0_10, arg0_12)
				arg0_11()
			end, var3_11)
		end,
		function(arg0_13)
			local var0_13 = arg0_10._spinePaintingData.bgEffectName

			if var0_13 ~= nil then
				local var1_13 = "ui/" .. var0_13

				arg0_10._loader:LoadPrefab(var1_13, var0_13, function(arg0_14)
					var5_0(arg0_10, arg0_14)
					arg0_13()
				end, var1_13)
			else
				arg0_13()
			end
		end
	}, function()
		setActive(arg0_10._spinePaintingData.parent, true)
		setActive(arg0_10._spinePaintingData.effectParent, true)

		if arg2_10 then
			arg2_10(arg0_10)
		end
	end)
end

function var0_0.SetVisible(arg0_16, arg1_16)
	setActive(arg0_16._spinePaintingData.effectParent, arg1_16)
	setActiveViaLayer(arg0_16._spinePaintingData.effectParent, arg1_16)

	if not arg1_16 then
		arg0_16.mainSpineAnim:SetActionCallBack(nil)

		arg0_16.inAction = false

		if LeanTween.isTweening(go(arg0_16._tf)) then
			LeanTween.cancel(go(arg0_16._tf))
		end

		if arg0_16._baseShader then
			arg0_16._skeletonGraphic.material.shader = arg0_16._baseShader
			arg0_16._baseShader = nil
		end
	end

	arg0_16:checkActionShow()
end

function var0_0.checkActionShow(arg0_17)
	local var0_17 = tostring(arg0_17.mainSpineAnim.name) .. "_" .. tostring(arg0_17._spinePaintingData.ship.id)
	local var1_17 = PlayerPrefs.GetString(var0_17)

	if var1_17 and #var1_17 > 0 then
		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0_17.idleName ~= var1_17 then
			arg0_17.idleName = var1_17

			arg0_17:SetAction(var1_17, 0)
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0_17.idleName ~= arg0_17:getNormalName() then
			arg0_17.idleName = arg0_17:getNormalName()

			arg0_17:SetAction(arg0_17.idleName, 0)
		end
	end
end

function var0_0.DoSpecialTouch(arg0_18)
	if not arg0_18.inAction then
		arg0_18.inAction = true

		arg0_18:SetActionWithCallback("special", 0, function()
			arg0_18:SetAction(arg0_18:getNormalName(), 0)

			arg0_18.inAction = false
		end)
	end
end

function var0_0.DoDragClick(arg0_20)
	return
end

function var0_0.DoDragTouch(arg0_21)
	local var0_21 = false

	for iter0_21, iter1_21 in ipairs(var3_0) do
		var0_21 = var0_21 or string.find(arg0_21.mainSpineAnim.name, iter1_21) == 1
	end

	if var0_21 and not arg0_21.inAction then
		arg0_21.inAction = true

		if not arg0_21.idleName or arg0_21.idleName ~= "ex" then
			arg0_21.idleName = "ex"

			if string.find(arg0_21.mainSpineAnim.name, "aimudeng_4") then
				arg0_21._baseMaterial = arg0_21._skeletonGraphic.material

				arg0_21:getSpineMaterial("SkeletonGraphicDefaultRGBSplit", function(arg0_22)
					arg0_21._skeletonGraphic.material = arg0_22

					LeanTween.delayedCall(go(arg0_21._tf), 0.5, System.Action(function()
						arg0_21._skeletonGraphic.material = arg0_21._baseMaterial

						arg0_21:changeSpecialIdle(arg0_21.idleName)
					end))
				end)
			else
				arg0_21:SetActionWithFinishCallback("drag", 0, function()
					arg0_21:changeSpecialIdle(arg0_21.idleName)
				end)
			end
		elseif arg0_21.idleName == "ex" then
			arg0_21.idleName = "normal"

			if string.find(arg0_21.mainSpineAnim.name, "aimudeng_4") then
				arg0_21._baseMaterial = arg0_21._skeletonGraphic.material

				arg0_21:getSpineMaterial("SkeletonGraphicDefaultRGBSplit", function(arg0_25)
					arg0_21._skeletonGraphic.material = arg0_25

					LeanTween.delayedCall(go(arg0_21._tf), 0.5, System.Action(function()
						arg0_21._skeletonGraphic.material = arg0_21._baseMaterial

						arg0_21:changeSpecialIdle(arg0_21.idleName)
					end))
				end)
			else
				arg0_21:SetActionWithFinishCallback("drag_ex", 0, function()
					arg0_21:changeSpecialIdle(arg0_21.idleName)
				end)
			end
		end
	end
end

function var0_0.getSpineMaterial(arg0_28, arg1_28, arg2_28)
	if not arg0_28._materialDic then
		arg0_28._materialDic = {}
	end

	if arg0_28._materialDic[arg1_28] then
		arg2_28(arg0_28._materialDic[arg1_28])
	end

	PoolMgr:GetInstance():LoadAsset("spinematerials", arg1_28, false, typeof(Material), function(arg0_29)
		arg0_28._materialDic[arg1_28] = arg0_29

		arg2_28(arg0_28._materialDic[arg1_28])
	end, false)
end

function var0_0.changeSpecialIdle(arg0_30, arg1_30)
	arg0_30:SetAction(arg1_30, 0)

	local var0_30 = tostring(arg0_30.mainSpineAnim.name) .. "_" .. tostring(arg0_30._spinePaintingData.ship.id)

	PlayerPrefs.SetString(var0_30, arg1_30)

	arg0_30.inAction = false
end

function var0_0.SetAction(arg0_31, arg1_31, arg2_31)
	if arg2_31 == 1 then
		if arg0_31.inAction then
			return
		end

		local var0_31, var1_31 = arg0_31:getMultipFaceData()
		local var2_31 = tonumber(arg1_31)

		if var2_31 and var0_31 then
			arg1_31 = tostring(var2_31 + var1_31)
		end
	end

	if arg1_31 == arg0_31:getNormalName() and arg0_31.idleName ~= nil then
		arg1_31 = arg0_31.idleName
	end

	for iter0_31, iter1_31 in ipairs(arg0_31.spineAnimList) do
		iter1_31:SetAction(arg1_31, arg2_31)
	end
end

function var0_0.SetActionWithCallback(arg0_32, arg1_32, arg2_32, arg3_32)
	arg0_32:SetAction(arg1_32, arg2_32)

	if arg0_32.mainSpineAnim then
		arg0_32.mainSpineAnim:SetActionCallBack(function(arg0_33)
			arg0_32.mainSpineAnim:SetActionCallBack(nil)

			if arg0_33 == "finish" and arg3_32 then
				arg3_32()
			end
		end)
		arg0_32.mainSpineAnim:SetAction(arg1_32, 0)
	end
end

function var0_0.SetActionWithFinishCallback(arg0_34, arg1_34, arg2_34, arg3_34)
	arg0_34:SetAction(arg1_34, arg2_34)

	if arg0_34.mainSpineAnim then
		arg0_34.mainSpineAnim:SetActionCallBack(function(arg0_35)
			if arg0_35 == "finish" and arg3_34 then
				arg0_34.mainSpineAnim:SetActionCallBack(nil)
				arg3_34()
			end
		end)
		arg0_34.mainSpineAnim:SetAction(arg1_34, 0)
	end
end

function var0_0.SetEmptyAction(arg0_36, arg1_36)
	arg0_36:SetVisible(true)

	for iter0_36, iter1_36 in ipairs(arg0_36.spineAnimList) do
		local var0_36 = iter1_36:GetAnimationState()

		if var0_36 then
			var0_36:SetEmptyAnimation(arg1_36, 0)
			GetComponent(iter1_36.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0_0.getMultipFaceData(arg0_37)
	if table.contains(var2_0, arg0_37.mainSpineAnim.name) and arg0_37.idleName == "ex" then
		return true, 5
	end
end

function var0_0.Dispose(arg0_38)
	arg0_38._materialDic = {}

	if arg0_38._spinePaintingData then
		arg0_38._spinePaintingData:Clear()
	end

	arg0_38._loader:Clear()

	if arg0_38._go ~= nil then
		var1_0.Destroy(arg0_38._go)
	end

	if arg0_38._bgEffectGo ~= nil then
		var1_0.Destroy(arg0_38._bgEffectGo)
	end

	arg0_38._go = nil
	arg0_38._tf = nil
	arg0_38._bgEffectGo = nil
	arg0_38._bgEffectTf = nil

	if arg0_38.spineAnim then
		arg0_38.spineAnim:SetActionCallBack(nil)
	end
end

return var0_0
