local var0 = class("EquipmentTransformInfoLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "EquipmentTransformInfoUI"
end

function var0.init(arg0)
	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	assert(arg0.contextData.equipVO, "Not Pass EquipVO")

	local var0 = arg0._tf:Find("Main"):Find("item")
	local var1 = {
		type = DROP_TYPE_EQUIP,
		id = arg0.contextData.equipVO.id
	}

	updateDrop(var0, var1)
	onButton(arg0, var0, function()
		arg0:emit(var0.ON_DROP, var1)
	end, SFX_PANEL)

	local var2

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0.loader:GetPrefab("ui/equipupgradeAni", "", function(arg0)
		setParent(arg0, arg0._tf)
		setActive(arg0, true)

		local var0 = arg0:GetComponent(typeof(DftAniEvent))

		var0:SetTriggerEvent(function(arg0)
			var2 = true
		end)
		var0:SetEndEvent(function(arg0)
			arg0:closeView()
		end)

		function arg0.unloadEffect()
			var0:SetTriggerEvent(nil)
			var0:SetEndEvent(nil)
		end
	end)
	onButton(arg0, arg0._tf, function()
		if var2 then
			arg0:closeView()
		end
	end)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.unloadEffect then
		arg0.unloadEffect()
	end

	arg0.loader:Clear()
end

return var0
