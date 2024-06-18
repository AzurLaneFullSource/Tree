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
	arg0_1.profileBtn = findTF(arg1_1, "left/icon")
	arg0_1.animation = arg1_1:GetComponent(typeof(Animation))
	arg0_1.dftAniEvent = arg1_1:GetComponent(typeof(DftAniEvent))
	arg0_1.timers = {}

	arg0_1:RegisterEvent()
end

function var0_0.RegisterEvent(arg0_2)
	onButton(arg0_2, arg0_2.profileBtn, function()
		arg0_2:emit(EducateCharDockMediator.GO_PROFILE)
	end, SFX_PANEL)
	arg0_2:bind(EducateCharDockScene.MSG_CLEAR_TIP, function(arg0_4, arg1_4)
		arg0_2:FlushList(arg0_2.selectedId)
	end)
end

function var0_0.Update(arg0_5)
	arg0_5:InitList()
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

function var0_0.InitList(arg0_9)
	arg0_9.cards = {}
	arg0_9.selectedId = arg0_9:GetSelectedId()

	local var0_9 = getProxy(EducateProxy):GetEducateGroupList()

	table.sort(var0_9, function(arg0_10, arg1_10)
		return arg0_10:GetSortWeight() < arg1_10:GetSortWeight()
	end)
	arg0_9:RemoveAllTimer()
	arg0_9.uiItemList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = var0_9[arg1_11 + 1]

			arg0_9:InitCard(arg2_11, var0_11, arg1_11)
			arg0_9:UpdateCard(arg2_11, var0_11)

			arg0_9.cards[arg2_11] = var0_11
		end
	end)
	arg0_9.uiItemList:align(#var0_9)
end

function var0_0.FlushList(arg0_12, arg1_12)
	arg0_12.selectedId = arg1_12

	for iter0_12, iter1_12 in pairs(arg0_12.cards) do
		arg0_12:UpdateCard(iter0_12, iter1_12)
	end
end

function var0_0.InitCard(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = arg1_13:Find("anim_root")
	local var1_13 = var0_13:Find("label/Text"):GetComponent(typeof(Image))

	var1_13.sprite = GetSpriteFromAtlas("ui/EducateDockUI_atlas", arg2_13:GetSpriteName())

	var1_13:SetNativeSize()

	local var2_13 = arg2_13:GetShowPainting()

	setPaintingPrefab(var0_13:Find("mask/painting"), var2_13, "tb2")
	onButton(arg0_13, var0_13, function()
		if arg0_13.doAnim then
			return
		end

		if arg2_13:IsLock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_lock_tip"))

			return
		end

		arg0_13.doAnim = true

		arg0_13.dftAniEvent:SetEndEvent(function(arg0_15)
			arg0_13.doAnim = nil

			arg0_13.dftAniEvent:SetEndEvent(nil)
			arg0_13:emit(EducateCharDockScene.ON_SELECT, arg2_13, arg0_13.selectedId)
		end)
		arg0_13.animation:Play("anim_educate_chardock_grouppage_out")
	end, SFX_PANEL)
	setActive(var0_13, false)

	arg0_13.timers[arg3_13] = Timer.New(function()
		setActive(var0_13, true)
		var0_13:GetComponent(typeof(Animation)):Play("anim_educate_chardock_tpl")
	end, math.max(1e-05, arg3_13 * 0.066), 1)

	arg0_13.timers[arg3_13]:Start()
end

function var0_0.UpdateCard(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17:Find("anim_root")

	setActive(var0_17:Find("lock"), arg2_17:IsLock())
	setActive(var0_17:Find("mark"), arg2_17:IsSelected(arg0_17.selectedId))
	setText(var0_17:Find("lock/desc/Text"), arg2_17:GetUnlockDesc())
	setActive(var0_17:Find("tip"), arg2_17:ShouldTip())
end

function var0_0.RemoveAllTimer(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.timers) do
		iter1_18:Stop()

		iter1_18 = nil
	end

	arg0_18.timers = {}
end

function var0_0.Destroy(arg0_19)
	for iter0_19, iter1_19 in pairs(arg0_19.cards or {}) do
		local var0_19 = iter0_19:Find("mask/painting")
		local var1_19 = iter1_19:GetShowPainting()

		retPaintingPrefab(var0_19, var1_19)
	end

	pg.DelegateInfo.Dispose(arg0_19)
	arg0_19.dftAniEvent:SetEndEvent(nil)
	arg0_19:RemoveAllTimer()
end

return var0_0
