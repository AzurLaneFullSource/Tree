local var0 = class("SpinePainting")
local var1 = require("Mgr/Pool/PoolUtil")
local var2 = {
	"aimudeng_4",
	"aimudeng_4M"
}
local var3 = {
	"gaoxiong_6",
	"aimudeng_4M"
}

function var0.GenerateData(arg0)
	local var0 = {
		SetData = function(arg0, arg1)
			arg0.ship = arg1.ship
			arg0.parent = arg1.parent
			arg0.effectParent = arg1.effectParent

			local var0 = arg0:GetShipSkinConfig()

			arg0.pos = arg1.position + BuildVector3(var0.spine_offset[1])

			local var1 = var0.spine_offset[2][1]

			arg0.scale = Vector3(var1, var1, var1)

			if #var0.special_effects > 0 then
				arg0.bgEffectName = var0.special_effects[1]
				arg0.bgEffectPos = arg1.position + BuildVector3(var0.special_effects[2])

				local var2 = var0.special_effects[3][1]

				arg0.bgEffectScale = Vector3(var2, var2, var2)
			end
		end,
		GetShipName = function(arg0)
			return arg0.ship:getPainting()
		end,
		GetShipSkinConfig = function(arg0)
			return arg0.ship:GetSkinConfig()
		end,
		isEmpty = function(arg0)
			return arg0.ship == nil
		end,
		Clear = function(arg0)
			arg0.ship = nil
			arg0.parent = nil
			arg0.scale = nil
			arg0.pos = nil
			arg0.bgEffectName = nil
			arg0.bgEffectPos = nil
			arg0.bgEffectScale = nil
			arg0.effectParent = nil
		end
	}

	var0:SetData(arg0)

	return var0
end

local function var4(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)

	UIUtil.SetLayerRecursively(arg0._go, LayerMask.NameToLayer("UI"))
	arg0._tf:SetParent(arg0._spinePaintingData.parent, true)

	arg0._tf.localScale = arg0._spinePaintingData.scale
	arg0._tf.localPosition = arg0._spinePaintingData.pos
	arg0.spineAnimList = {}

	local var0 = arg0._tf:GetComponent(typeof(ItemList)).prefabItem

	for iter0 = 0, var0.Length - 1 do
		arg0.spineAnimList[#arg0.spineAnimList + 1] = GetOrAddComponent(var0[iter0], "SpineAnimUI")
	end

	local var1 = #arg0.spineAnimList

	assert(var1 > 0, "动态立绘至少要保证有一个spine动画，请检查" .. arg0._spinePaintingData:GetShipName())

	if var1 == 1 then
		arg0.mainSpineAnim = arg0.spineAnimList[1]
	else
		arg0.mainSpineAnim = arg0.spineAnimList[#arg0.spineAnimList]
	end

	arg0._skeletonGraphic = arg0.mainSpineAnim:GetComponent("SkeletonGraphic")
	arg0.idleName = arg0:getNormalName()

	arg0:checkActionShow()
end

function var0.getNormalName(arg0)
	return "normal"
end

local function var5(arg0, arg1)
	arg0._bgEffectGo = arg1
	arg0._bgEffectTf = tf(arg1)

	UIUtil.SetLayerRecursively(arg0._bgEffectGo, LayerMask.NameToLayer("UI"))
	arg0._bgEffectTf:SetParent(arg0._spinePaintingData.effectParent, true)

	arg0._bgEffectTf.localScale = arg0._spinePaintingData.bgEffectScale
	arg0._bgEffectTf.localPosition = arg0._spinePaintingData.bgEffectPos
end

function var0.Ctor(arg0, arg1, arg2)
	arg0._spinePaintingData = arg1
	arg0._loader = AutoLoader.New()

	parallelAsync({
		function(arg0)
			local var0 = arg0._spinePaintingData:GetShipName()
			local var1, var2 = HXSet.autoHxShift("spinepainting/", var0)
			local var3 = var1 .. var2

			arg0._loader:LoadPrefab(var3, nil, function(arg0)
				var4(arg0, arg0)
				arg0()
			end, var3)
		end,
		function(arg0)
			local var0 = arg0._spinePaintingData.bgEffectName

			if var0 ~= nil then
				local var1 = "ui/" .. var0

				arg0._loader:LoadPrefab(var1, var0, function(arg0)
					var5(arg0, arg0)
					arg0()
				end, var1)
			else
				arg0()
			end
		end
	}, function()
		setActive(arg0._spinePaintingData.parent, true)
		setActive(arg0._spinePaintingData.effectParent, true)

		if arg2 then
			arg2(arg0)
		end
	end)
end

function var0.SetVisible(arg0, arg1)
	setActive(arg0._spinePaintingData.effectParent, arg1)
	setActiveViaLayer(arg0._spinePaintingData.effectParent, arg1)

	if not arg1 then
		arg0.mainSpineAnim:SetActionCallBack(nil)

		arg0.inAction = false

		if LeanTween.isTweening(go(arg0._tf)) then
			LeanTween.cancel(go(arg0._tf))
		end

		if arg0._baseShader then
			arg0._skeletonGraphic.material.shader = arg0._baseShader
			arg0._baseShader = nil
		end
	end

	arg0:checkActionShow()
end

function var0.checkActionShow(arg0)
	local var0 = tostring(arg0.mainSpineAnim.name) .. "_" .. tostring(arg0._spinePaintingData.ship.id)
	local var1 = PlayerPrefs.GetString(var0)

	if var1 and #var1 > 0 then
		if PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) == 1 and arg0.idleName ~= var1 then
			arg0.idleName = var1

			arg0:SetAction(var1, 0)
		elseif PlayerPrefs.GetInt(LIVE2D_STATUS_SAVE, 1) ~= 1 and arg0.idleName ~= arg0:getNormalName() then
			arg0.idleName = arg0:getNormalName()

			arg0:SetAction(arg0.idleName, 0)
		end
	end
end

function var0.DoSpecialTouch(arg0)
	if not arg0.inAction then
		arg0.inAction = true

		arg0:SetActionWithCallback("special", 0, function()
			arg0:SetAction(arg0:getNormalName(), 0)

			arg0.inAction = false
		end)
	end
end

function var0.DoDragClick(arg0)
	return
end

function var0.DoDragTouch(arg0)
	local var0 = false

	for iter0, iter1 in ipairs(var3) do
		var0 = var0 or string.find(arg0.mainSpineAnim.name, iter1) == 1
	end

	if var0 and not arg0.inAction then
		arg0.inAction = true

		if not arg0.idleName or arg0.idleName ~= "ex" then
			arg0.idleName = "ex"

			if string.find(arg0.mainSpineAnim.name, "aimudeng_4") then
				arg0._baseMaterial = arg0._skeletonGraphic.material

				arg0:getSpineMaterial("SkeletonGraphicDefaultRGBSplit", function(arg0)
					arg0._skeletonGraphic.material = arg0

					LeanTween.delayedCall(go(arg0._tf), 0.5, System.Action(function()
						arg0._skeletonGraphic.material = arg0._baseMaterial

						arg0:changeSpecialIdle(arg0.idleName)
					end))
				end)
			else
				arg0:SetActionWithFinishCallback("drag", 0, function()
					arg0:changeSpecialIdle(arg0.idleName)
				end)
			end
		elseif arg0.idleName == "ex" then
			arg0.idleName = "normal"

			if string.find(arg0.mainSpineAnim.name, "aimudeng_4") then
				arg0._baseMaterial = arg0._skeletonGraphic.material

				arg0:getSpineMaterial("SkeletonGraphicDefaultRGBSplit", function(arg0)
					arg0._skeletonGraphic.material = arg0

					LeanTween.delayedCall(go(arg0._tf), 0.5, System.Action(function()
						arg0._skeletonGraphic.material = arg0._baseMaterial

						arg0:changeSpecialIdle(arg0.idleName)
					end))
				end)
			else
				arg0:SetActionWithFinishCallback("drag_ex", 0, function()
					arg0:changeSpecialIdle(arg0.idleName)
				end)
			end
		end
	end
end

function var0.getSpineMaterial(arg0, arg1, arg2)
	if not arg0._materialDic then
		arg0._materialDic = {}
	end

	if arg0._materialDic[arg1] then
		arg2(arg0._materialDic[arg1])
	end

	PoolMgr:GetInstance():LoadAsset("spinematerials", arg1, false, typeof(Material), function(arg0)
		arg0._materialDic[arg1] = arg0

		arg2(arg0._materialDic[arg1])
	end, false)
end

function var0.changeSpecialIdle(arg0, arg1)
	arg0:SetAction(arg1, 0)

	local var0 = tostring(arg0.mainSpineAnim.name) .. "_" .. tostring(arg0._spinePaintingData.ship.id)

	PlayerPrefs.SetString(var0, arg1)

	arg0.inAction = false
end

function var0.SetAction(arg0, arg1, arg2)
	if arg2 == 1 then
		if arg0.inAction then
			return
		end

		local var0, var1 = arg0:getMultipFaceData()
		local var2 = tonumber(arg1)

		if var2 and var0 then
			arg1 = tostring(var2 + var1)
		end
	end

	if arg1 == arg0:getNormalName() and arg0.idleName ~= nil then
		arg1 = arg0.idleName
	end

	for iter0, iter1 in ipairs(arg0.spineAnimList) do
		iter1:SetAction(arg1, arg2)
	end
end

function var0.SetActionWithCallback(arg0, arg1, arg2, arg3)
	arg0:SetAction(arg1, arg2)

	if arg0.mainSpineAnim then
		arg0.mainSpineAnim:SetActionCallBack(function(arg0)
			arg0.mainSpineAnim:SetActionCallBack(nil)

			if arg0 == "finish" and arg3 then
				arg3()
			end
		end)
		arg0.mainSpineAnim:SetAction(arg1, 0)
	end
end

function var0.SetActionWithFinishCallback(arg0, arg1, arg2, arg3)
	arg0:SetAction(arg1, arg2)

	if arg0.mainSpineAnim then
		arg0.mainSpineAnim:SetActionCallBack(function(arg0)
			if arg0 == "finish" and arg3 then
				arg0.mainSpineAnim:SetActionCallBack(nil)
				arg3()
			end
		end)
		arg0.mainSpineAnim:SetAction(arg1, 0)
	end
end

function var0.SetEmptyAction(arg0, arg1)
	arg0:SetVisible(true)

	for iter0, iter1 in ipairs(arg0.spineAnimList) do
		local var0 = iter1:GetAnimationState()

		if var0 then
			var0:SetEmptyAnimation(arg1, 0)
			GetComponent(iter1.transform, "SkeletonGraphic"):Update(Time.deltaTime)
		end
	end
end

function var0.getMultipFaceData(arg0)
	if table.contains(var2, arg0.mainSpineAnim.name) and arg0.idleName == "ex" then
		return true, 5
	end
end

function var0.Dispose(arg0)
	arg0._materialDic = {}

	if arg0._spinePaintingData then
		arg0._spinePaintingData:Clear()
	end

	arg0._loader:Clear()

	if arg0._go ~= nil then
		var1.Destroy(arg0._go)
	end

	if arg0._bgEffectGo ~= nil then
		var1.Destroy(arg0._bgEffectGo)
	end

	arg0._go = nil
	arg0._tf = nil
	arg0._bgEffectGo = nil
	arg0._bgEffectTf = nil

	if arg0.spineAnim then
		arg0.spineAnim:SetActionCallBack(nil)
	end
end

return var0
