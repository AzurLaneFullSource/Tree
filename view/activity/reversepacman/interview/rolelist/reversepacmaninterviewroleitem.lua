local var0_0 = class("ReversePacmanInterviewRoleItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1
	arg0_1.roleID = arg3_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
	arg0_1:didEnter()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiBtn, function()
		arg0_2:emit(ReversePacmanInterviewScene.ON_SELECTED_ROLE, arg0_2.roleID)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_4)
	return
end

function var0_0.SetRoleID(arg0_5, arg1_5)
	arg0_5.roleID = arg1_5

	arg0_5:RefreshUI()
end

function var0_0.RefreshUI(arg0_6)
	local var0_6 = pg.activity_chasing_character[arg0_6.roleID]
	local var1_6 = ShipGroup.getDefaultShipConfig(pg.ship_skin_template[var0_6.skin_id].ship_group).id
	local var2_6 = Ship.New({
		id = var1_6,
		configId = var1_6,
		skin_id = var0_6.skin_id
	})

	GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var2_6:getPainting(), var2_6:getPainting(), arg0_6.uiIconImage)

	local var3_6 = ReversePacmanTools.IsUnlockRole(arg0_6.roleID)

	if not ReversePacmanTools.IsUnlockRole(arg0_6.roleID) then
		setImageColor(arg0_6.uiIconImage, Color.NewHex("#00000096"))
	elseif ReversePacmanTools.IsHireRole(arg0_6.roleID) then
		setImageColor(arg0_6.uiIconImage, Color.NewHex("#ffffffff"))
	else
		setImageColor(arg0_6.uiIconImage, Color.NewHex("#5E5D5Dff"))
	end

	setActive(arg0_6.uiSelectedGo, false)
	setActive(arg0_6.uiOwnedGo, getProxy(ShipSkinProxy):hasSkin(var0_6.skin_id))
	arg0_6:Show(true)
end

function var0_0.Show(arg0_7, arg1_7)
	setActive(arg0_7._go, arg1_7)
end

function var0_0.OnSlectedRole(arg0_8, arg1_8)
	setActive(arg0_8.uiSelectedGo, arg0_8.roleID == arg1_8)
end

function var0_0.willExit(arg0_9)
	arg0_9:detach()
	Object.Destroy(arg0_9._go)

	arg0_9._tf = nil
	arg0_9._go = nil
end

return var0_0
