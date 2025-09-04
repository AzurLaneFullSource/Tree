local var0_0 = class("IslandMainBaseBtn")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1.event = arg2_1
	arg0_1.configId = arg3_1
	arg0_1.config = pg.island_main_btns[arg0_1.configId]
	arg0_1.iconTF = arg0_1._tf
	arg0_1.tipTF = arg0_1._tf:Find("tip")

	arg0_1:Init()
end

function var0_0.SetAsLastSibling(arg0_2)
	arg0_2._tf:SetAsLastSibling()
end

function var0_0.Init(arg0_3)
	LoadImageSpriteAtlasAsync("island/islandbtnicon", arg0_3.config.icon, arg0_3.iconTF, true)

	arg0_3._tf.name = arg0_3.config.btn_name

	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:OnClick()
	end, SFX_PANEL)
end

function var0_0.GetAbilityId(arg0_5)
	return arg0_5.config.ability_id
end

function var0_0.OnClick(arg0_6)
	if arg0_6.config.open_page ~= "" then
		arg0_6:emit(IslandMediator.OPEN_PAGE, arg0_6.config.open_page, arg0_6.config.page_param)
	end
end

function var0_0.Flush(arg0_7)
	arg0_7:UnlockCheck()
	arg0_7:TipCheck()
end

function var0_0.UnlockCheck(arg0_8)
	setActive(arg0_8._tf, arg0_8:IsUnlock())
end

function var0_0.IsUnlock(arg0_9)
	return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(arg0_9:GetAbilityId())
end

function var0_0.TipCheck(arg0_10)
	setActive(arg0_10.tipTF, arg0_10:IsUnlock() and arg0_10:IsTip())
end

function var0_0.IsTip(arg0_11)
	return IslandMainBtnTipHelper.IsTip(arg0_11.config.btn_name)
end

function var0_0.emit(arg0_12, ...)
	arg0_12.event:emit(...)
end

function var0_0.Dispose(arg0_13)
	pg.DelegateInfo.Dispose(arg0_13)
end

return var0_0
