local var0 = class("EducateCharGroupPage", import("view.base.BaseEventLogic"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	pg.DelegateInfo.New(arg0)
	var0.super.Ctor(arg0, arg2)

	arg0.contextData = arg3
	arg0.tf = arg1
	arg0.go = arg1.gameObject
	arg0.confirmBtn = findTF(arg1, "confirm_btn")
	arg0.cancelBtn = findTF(arg1, "cancel_btn")
	arg0.uiItemList = UIItemList.New(findTF(arg1, "main/list"), findTF(arg1, "main/list/tpl"))
	arg0.profileBtn = findTF(arg1, "left/icon")
	arg0.animation = arg1:GetComponent(typeof(Animation))
	arg0.dftAniEvent = arg1:GetComponent(typeof(DftAniEvent))
	arg0.timers = {}

	arg0:RegisterEvent()
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0.profileBtn, function()
		arg0:emit(EducateCharDockMediator.GO_PROFILE)
	end, SFX_PANEL)
	arg0:bind(EducateCharDockScene.MSG_CLEAR_TIP, function(arg0, arg1)
		arg0:FlushList(arg0.selectedId)
	end)
end

function var0.Update(arg0)
	arg0:InitList()
end

function var0.Show(arg0)
	setActive(arg0.tf, true)
end

function var0.Hide(arg0)
	setActive(arg0.tf, false)
	arg0:RemoveAllTimer()
end

function var0.GetSelectedId(arg0)
	return getProxy(PlayerProxy):getRawData():GetEducateCharacter()
end

function var0.InitList(arg0)
	arg0.cards = {}
	arg0.selectedId = arg0:GetSelectedId()

	local var0 = getProxy(EducateProxy):GetEducateGroupList()

	table.sort(var0, function(arg0, arg1)
		return arg0:GetSortWeight() < arg1:GetSortWeight()
	end)
	arg0:RemoveAllTimer()
	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			arg0:InitCard(arg2, var0, arg1)
			arg0:UpdateCard(arg2, var0)

			arg0.cards[arg2] = var0
		end
	end)
	arg0.uiItemList:align(#var0)
end

function var0.FlushList(arg0, arg1)
	arg0.selectedId = arg1

	for iter0, iter1 in pairs(arg0.cards) do
		arg0:UpdateCard(iter0, iter1)
	end
end

function var0.InitCard(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("anim_root")
	local var1 = var0:Find("label/Text"):GetComponent(typeof(Image))

	var1.sprite = GetSpriteFromAtlas("ui/EducateDockUI_atlas", arg2:GetSpriteName())

	var1:SetNativeSize()

	local var2 = arg2:GetShowPainting()

	setPaintingPrefab(var0:Find("mask/painting"), var2, "tb2")
	onButton(arg0, var0, function()
		if arg0.doAnim then
			return
		end

		if arg2:IsLock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_lock_tip"))

			return
		end

		arg0.doAnim = true

		arg0.dftAniEvent:SetEndEvent(function(arg0)
			arg0.doAnim = nil

			arg0.dftAniEvent:SetEndEvent(nil)
			arg0:emit(EducateCharDockScene.ON_SELECT, arg2, arg0.selectedId)
		end)
		arg0.animation:Play("anim_educate_chardock_grouppage_out")
	end, SFX_PANEL)
	setActive(var0, false)

	arg0.timers[arg3] = Timer.New(function()
		setActive(var0, true)
		var0:GetComponent(typeof(Animation)):Play("anim_educate_chardock_tpl")
	end, math.max(1e-05, arg3 * 0.066), 1)

	arg0.timers[arg3]:Start()
end

function var0.UpdateCard(arg0, arg1, arg2)
	local var0 = arg1:Find("anim_root")

	setActive(var0:Find("lock"), arg2:IsLock())
	setActive(var0:Find("mark"), arg2:IsSelected(arg0.selectedId))
	setText(var0:Find("lock/desc/Text"), arg2:GetUnlockDesc())
	setActive(var0:Find("tip"), arg2:ShouldTip())
end

function var0.RemoveAllTimer(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()

		iter1 = nil
	end

	arg0.timers = {}
end

function var0.Destroy(arg0)
	for iter0, iter1 in pairs(arg0.cards or {}) do
		local var0 = iter0:Find("mask/painting")
		local var1 = iter1:GetShowPainting()

		retPaintingPrefab(var0, var1)
	end

	pg.DelegateInfo.Dispose(arg0)
	arg0.dftAniEvent:SetEndEvent(nil)
	arg0:RemoveAllTimer()
end

return var0
