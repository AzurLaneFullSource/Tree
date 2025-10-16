local var0_0 = class("AgoraPaveTileView", import("Mod.Island.Core.View.IslandASynLoadSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandAgoraPaveTileUI"
end

function var0_0.FirstFlush(arg0_2)
	arg0_2.nameTxt = arg0_2._tf:Find("name"):GetComponent(typeof(Text))
	arg0_2.icon = arg0_2._tf:Find("icon"):GetComponent(typeof(Image))
	arg0_2.exitBtn = arg0_2._tf:Find("exit")
	arg0_2.rotation = arg0_2._tf:Find("revert")
	arg0_2.confirmBtn = arg0_2._tf:Find("confirm")
	arg0_2.mode = arg0_2._tf:Find("mode")

	setText(arg0_2._tf:Find("desc"), i18n("island_agora_pave_tip"))
	arg0_2:RegisterEvent()
end

function var0_0.RegisterEvent(arg0_3)
	onButton(arg0_3, arg0_3.exitBtn, function()
		arg0_3:Op("RevertPaveLayer")
		arg0_3:GetView():ExitPaveTileMode()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.mode, function(arg0_5)
		arg0_3:Op("ChangePaveMode", arg0_5)
	end, true)
	onButton(arg0_3, arg0_3.rotation, function()
		if arg0_3.shapeId == IslandConst.AGORA_TILE_SHAPE_ALL then
			return
		end

		arg0_3.shapeId = arg0_3.shapeId + 1

		if arg0_3.shapeId > arg0_3.maxShapeId then
			arg0_3.shapeId = arg0_3.minShapeId
		end

		arg0_3:Op("ChangeSelectedShape", arg0_3.shapeId)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:GetView():ExitPaveTileMode()
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_8, arg1_8, arg2_8)
	arg0_8.shapeId = arg2_8
	arg0_8.minShapeId = arg2_8
	arg0_8.maxShapeId = arg0_8.shapeId + 3
	arg0_8.nameTxt.text = arg1_8:GetName()

	LoadSpriteAsync("island/IslandFurnitureIcon/" .. arg1_8:GetIcon(), function(arg0_9)
		arg0_8.icon.sprite = arg0_9
	end)
	triggerToggle(arg0_8.mode, false)
end

function var0_0.OnDestroy(arg0_10)
	return
end

return var0_0
