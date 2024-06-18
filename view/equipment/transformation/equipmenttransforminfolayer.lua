local var0_0 = class("EquipmentTransformInfoLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EquipmentTransformInfoUI"
end

function var0_0.init(arg0_2)
	arg0_2.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_3)
	assert(arg0_3.contextData.equipVO, "Not Pass EquipVO")

	local var0_3 = arg0_3._tf:Find("Main"):Find("item")
	local var1_3 = {
		type = DROP_TYPE_EQUIP,
		id = arg0_3.contextData.equipVO.id
	}

	updateDrop(var0_3, var1_3)
	onButton(arg0_3, var0_3, function()
		arg0_3:emit(var0_0.ON_DROP, var1_3)
	end, SFX_PANEL)

	local var2_3

	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	arg0_3.loader:GetPrefab("ui/equipupgradeAni", "", function(arg0_5)
		setParent(arg0_5, arg0_3._tf)
		setActive(arg0_5, true)

		local var0_5 = arg0_5:GetComponent(typeof(DftAniEvent))

		var0_5:SetTriggerEvent(function(arg0_6)
			var2_3 = true
		end)
		var0_5:SetEndEvent(function(arg0_7)
			arg0_3:closeView()
		end)

		function arg0_3.unloadEffect()
			var0_5:SetTriggerEvent(nil)
			var0_5:SetEndEvent(nil)
		end
	end)
	onButton(arg0_3, arg0_3._tf, function()
		if var2_3 then
			arg0_3:closeView()
		end
	end)
end

function var0_0.willExit(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf)

	if arg0_10.unloadEffect then
		arg0_10.unloadEffect()
	end

	arg0_10.loader:Clear()
end

return var0_0
