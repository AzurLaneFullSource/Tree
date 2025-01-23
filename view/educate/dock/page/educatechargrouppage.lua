local var0_0 = class("EducateCharGroupPage", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)
	var0_0.super.Ctor(arg0_1, arg2_1)

	arg0_1.contextData = arg3_1
	arg0_1.tf = arg1_1
	arg0_1.go = arg1_1.gameObject
	arg0_1.confirmBtn = findTF(arg1_1, "confirm_btn")
	arg0_1.cancelBtn = findTF(arg1_1, "cancel_btn")
	arg0_1.uiItemList = UIItemList.New(findTF(arg1_1, "main/list"), findTF(arg1_1, "main/list/tpl"))
	arg0_1.tabItemList = UIItemList.New(findTF(arg1_1, "tab/list"), findTF(arg1_1, "tab/list/tpl"))
	arg0_1.profileBtn = findTF(arg1_1, "right/icon")
	arg0_1.animation = arg1_1:GetComponent(typeof(Animation))
	arg0_1.dftAniEvent = arg1_1:GetComponent(typeof(DftAniEvent))
	arg0_1.timers = {}

	arg0_1:RegisterEvent()
end

function var0_0.RegisterEvent(arg0_2)
	onButton(arg0_2, arg0_2.profileBtn, function()
		arg0_2:emit(EducateCharDockMediator.GO_PROFILE, arg0_2.selectedCharacterId)
	end, SFX_PANEL)
	arg0_2:bind(EducateCharDockScene.MSG_CLEAR_TIP, function(arg0_4, arg1_4)
		arg0_2:FlushList(arg0_2.selectedId)
	end)
end

function var0_0.Update(arg0_5)
	arg0_5:InitData()
	arg0_5:InitTabs()
	arg0_5:InitList()
	arg0_5:CheckChangeFormShop()
end

function var0_0.Show(arg0_6)
	setActive(arg0_6.tf, true)
end

function var0_0.Hide(arg0_7)
	setActive(arg0_7.tf, false)
	arg0_7:RemoveAllTimer()
end

function var0_0.GetSelectedId(arg0_8)
	return getProxy(PlayerProxy):getRawData():GetEducateCharacter()
end

function var0_0.GetSelectedCharacterId(arg0_9)
	local var0_9 = arg0_9:GetSelectedId()

	if arg0_9.contextData.tbSkinId then
		var0_9 = NewEducateHelper.GetSecIdBySkinId(arg0_9.contextData.tbSkinId)
	end

	for iter0_9, iter1_9 in ipairs(arg0_9.characterList) do
		if iter1_9:IsSelected(var0_9) then
			return iter0_9
		end
	end

	for iter2_9, iter3_9 in ipairs(arg0_9.characterList) do
		if not iter3_9:IsLock() then
			return iter2_9
		end
	end
end

function var0_0.InitData(arg0_10)
	arg0_10.characterList = NewEducateHelper.GetEducateCharacterList()
	arg0_10.selectedCharacterId = arg0_10:GetSelectedCharacterId()
	arg0_10.selectedId = arg0_10:GetSelectedId()
end

function var0_0.CheckChangeFormShop(arg0_11)
	if not arg0_11.contextData.tbSkinId then
		return
	end

	local var0_11 = NewEducateHelper.GetSecIdBySkinId(arg0_11.contextData.tbSkinId)
	local var1_11 = arg0_11.characterList[arg0_11.selectedCharacterId].id
	local var2_11 = pg.secretary_special_ship[var0_11].group

	for iter0_11, iter1_11 in ipairs(arg0_11.characterList) do
		if iter1_11.id == var1_11 then
			local var3_11 = iter1_11:GetGroupById(var2_11)

			arg0_11:emit(EducateCharDockScene.ON_SELECT, var3_11, arg0_11.selectedId)

			return
		end
	end
end

function var0_0.InitTabs(arg0_12)
	arg0_12.tabItemList:make(function(arg0_13, arg1_13, arg2_13)
		local var0_13 = arg1_13 + 1
		local var1_13 = arg0_12.characterList[var0_13]

		if arg0_13 == UIItemList.EventUpdate then
			setActive(arg2_13:Find("lock"), var1_13:IsLock())
			setActive(arg2_13:Find("border/selected"), var0_13 == arg0_12.selectedCharacterId)
			setActive(arg2_13:Find("border/normal"), var0_13 ~= arg0_12.selectedCharacterId)
			setActive(arg2_13:Find("tip"), var1_13:ShouldTip())
		elseif arg0_13 == UIItemList.EventInit then
			GetImageSpriteFromAtlasAsync("qicon/" .. var1_13:GetDefaultFrame(), "", arg2_13:Find("frame"))
			onButton(arg0_12, arg2_13, function()
				if var1_13:IsLock() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_character_unlock"))

					return
				end

				if var0_13 ~= arg0_12.selectedCharacterId then
					arg0_12.selectedCharacterId = var0_13

					arg0_12.tabItemList:align(#arg0_12.characterList)
					arg0_12:InitList()
				end
			end)
		end
	end)
	arg0_12.tabItemList:align(#arg0_12.characterList)
end

function var0_0.InitList(arg0_15)
	arg0_15.cards = {}

	local var0_15 = arg0_15.characterList[arg0_15.selectedCharacterId]:GetGroupList()

	table.sort(var0_15, function(arg0_16, arg1_16)
		return arg0_16:GetSortWeight() < arg1_16:GetSortWeight()
	end)
	arg0_15:RemoveAllTimer()
	arg0_15.uiItemList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = var0_15[arg1_17 + 1]

			arg0_15:InitCard(arg2_17, var0_17, arg1_17)
			arg0_15:UpdateCard(arg2_17, var0_17)

			arg0_15.cards[arg2_17] = var0_17
		end
	end)
	arg0_15.uiItemList:align(#var0_15)
end

function var0_0.FlushList(arg0_18, arg1_18)
	arg0_18.selectedId = arg1_18

	arg0_18:InitList()
	arg0_18.tabItemList:align(#arg0_18.characterList)
end

function var0_0.InitCard(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg1_19:Find("anim_root")
	local var1_19 = arg2_19:IsSp()

	setActive(var0_19:Find("bg"), not var1_19)
	setActive(var0_19:Find("sp_bg"), var1_19)
	setActive(var0_19:Find("mask"), not var1_19)
	setActive(var0_19:Find("sp_mask"), var1_19)
	setActive(var0_19:Find("sp"), var1_19)
	setActive(var0_19:Find("label"), not var1_19)
	setActive(var0_19:Find("sp_label"), var1_19)

	local var2_19 = arg2_19:GetShowPainting()

	if var1_19 then
		setPaintingPrefabAsync(var0_19:Find("sp_mask/painting"), var2_19, "tb2")
	else
		local var3_19 = var0_19:Find("label/Text"):GetComponent(typeof(Image))

		var3_19.sprite = GetSpriteFromAtlas("ui/EducateDockUI_atlas", arg2_19:GetSpriteName())

		var3_19:SetNativeSize()
		setPaintingPrefabAsync(var0_19:Find("mask/painting"), var2_19, "tb2")
	end

	onButton(arg0_19, var0_19, function()
		if arg0_19.doAnim then
			return
		end

		if arg2_19:IsLock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_lock_tip"))

			return
		end

		arg0_19.doAnim = true

		arg0_19.dftAniEvent:SetEndEvent(function(arg0_21)
			arg0_19.doAnim = nil

			arg0_19.dftAniEvent:SetEndEvent(nil)
			arg0_19:emit(EducateCharDockScene.ON_SELECT, arg2_19, arg0_19.selectedId)
		end)
		arg0_19.animation:Play("anim_educate_chardock_grouppage_out")
	end, SFX_PANEL)
	setActive(var0_19, false)

	arg0_19.timers[arg3_19] = Timer.New(function()
		setActive(var0_19, true)
		var0_19:GetComponent(typeof(Animation)):Play("anim_educate_chardock_tpl")
	end, math.max(1e-05, arg3_19 * 0.066), 1)

	arg0_19.timers[arg3_19]:Start()
end

function var0_0.UpdateCard(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23:Find("anim_root")

	setActive(var0_23:Find("lock"), arg2_23:IsLock())
	setActive(var0_23:Find("mark"), arg2_23:IsSelected(arg0_23.selectedId))
	setScrollText(var0_23:Find("lock/desc/Text"), arg2_23:GetUnlockDesc())
	setActive(var0_23:Find("tip"), arg2_23:ShouldTip())
end

function var0_0.RemoveAllTimer(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.timers) do
		iter1_24:Stop()

		iter1_24 = nil
	end

	arg0_24.timers = {}
end

function var0_0.Destroy(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.cards or {}) do
		local var0_25 = iter1_25:IsSp() and iter0_25:Find("sp_mask/painting") or iter0_25:Find("mask/painting")
		local var1_25 = iter1_25:GetShowPainting()

		retPaintingPrefab(var0_25, var1_25)
	end

	pg.DelegateInfo.Dispose(arg0_25)
	arg0_25.dftAniEvent:SetEndEvent(nil)
	arg0_25:RemoveAllTimer()
end

return var0_0
