local var0_0 = class("ReversePacmanTechnologyHrItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiGiftBtn, function()
		if not ReversePacmanTools.IsUnlockRole(arg0_2.roleID) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("reverse_pacman_unlock_role"))

			return
		end

		if not ReversePacmanTools.IsHireRole(arg0_2.roleID) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("reverse_pacman_unhire_role"))

			return
		end

		if arg0_2.maxFavorabilityValue <= arg0_2.curFavorabilityValue then
			print("满级", arg0_2.maxFavorabilityValue, arg0_2.curFavorabilityValue)

			return
		end

		local var0_3 = ReversePacmanTools.GetGiftItemID()

		if ReversePacmanTools.GetItemCnt(var0_3) < 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("reverse_pacman_ not_enough_gifts"))

			return
		end

		arg0_2:emit(ReversePacmanTechnologyMediator.CMD_GIFT, {
			roleID = arg0_2.roleID,
			itemID = var0_3
		})
	end, SFX_PANEL)
	setText(arg0_2.uiGiftText, i18n("reverse_pacman_send_gift"))
end

function var0_0.didEnter(arg0_4, arg1_4)
	arg0_4.roleID = arg1_4

	local var0_4 = pg.activity_chasing_character[arg1_4]
	local var1_4 = ShipGroup.getDefaultShipConfig(pg.ship_skin_template[var0_4.skin_id].ship_group).id
	local var2_4 = Ship.New({
		id = var1_4,
		configId = var1_4,
		skin_id = var0_4.skin_id
	})

	GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var2_4:getPainting(), var2_4:getPainting(), arg0_4.uiIconImage)

	if not ReversePacmanTools.IsUnlockRole(arg1_4) then
		setImageColor(arg0_4.uiIconImage, Color.NewHex("#00000096"))
	elseif ReversePacmanTools.IsHireRole(arg1_4) then
		setImageColor(arg0_4.uiIconImage, Color.NewHex("#ffffffff"))
	else
		setImageColor(arg0_4.uiIconImage, Color.NewHex("#5E5D5Dff"))
	end

	arg0_4.maxFavorabilityValue = ReversePacmanTools.GetMaxFavorabilityValue(arg1_4)
	arg0_4.curFavorabilityValue = ReversePacmanTools.GetFavorabilityValue(arg1_4)

	arg0_4:RefreshFavorability()
	arg0_4:RefreshTip()
	arg0_4:RefreshBtn()
end

function var0_0.RefreshFavorability(arg0_5)
	local var0_5 = pg.activity_chasing_character[arg0_5.roleID]
	local var1_5 = 0

	for iter0_5, iter1_5 in ipairs(var0_5.love_level) do
		if arg0_5.curFavorabilityValue >= iter1_5[2] then
			setFillAmount(arg0_5[string.format("uiHeartImage%s", iter0_5)], 1)
		else
			local var2_5 = arg0_5.curFavorabilityValue - var1_5

			if var2_5 < 0 then
				var2_5 = 0
			end

			setFillAmount(arg0_5[string.format("uiHeartImage%s", iter0_5)], var2_5 / (iter1_5[2] - var1_5))
		end

		var1_5 = iter1_5[2]
	end
end

function var0_0.RefreshBtn(arg0_6)
	if not ReversePacmanTools.IsHireRole(arg0_6.roleID) then
		setGray(arg0_6.uiGiftBtn, true)

		return
	end

	if arg0_6.maxFavorabilityValue <= arg0_6.curFavorabilityValue then
		setGray(arg0_6.uiGiftBtn, true)

		return
	end

	setGray(arg0_6.uiGiftBtn, false)
end

function var0_0.RefreshTip(arg0_7)
	setActive(arg0_7.uiGiftTipGo, arg0_7:HasTip())
end

function var0_0.HasTip(arg0_8)
	if not ReversePacmanTools.IsHireRole(arg0_8.roleID) then
		return false
	end

	if arg0_8.maxFavorabilityValue <= arg0_8.curFavorabilityValue then
		return false
	end

	return ReversePacmanTools.GetActivity():GetGiftTip()
end

function var0_0.willExit(arg0_9)
	arg0_9:detach()
end

return var0_0
