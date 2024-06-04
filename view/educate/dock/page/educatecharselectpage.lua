local var0 = class("EducateCharSelectPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "EducateCharDockSelectUI"
end

function var0.OnLoaded(arg0)
	arg0.titleTxt = arg0:findTF("title/Text"):GetComponent(typeof(Text))
	arg0.labelTxt = arg0:findTF("left/label/icon"):GetComponent(typeof(Image))
	arg0.paintingTr = arg0:findTF("left/print/painting")
	arg0.scrollrect = arg0:findTF("list")
	arg0.uiItemList = UIItemList.New(arg0:findTF("list/content"), arg0:findTF("list/content/tpl"))
	arg0.dotUIItemList = UIItemList.New(arg0:findTF("list/dots"), arg0:findTF("list/dots/tpl"))
	arg0.confirmBtn = arg0:findTF("confirm_btn")
	arg0.nextArr = arg0:findTF("prints/next")
	arg0.prevArr = arg0:findTF("prints/prev")
	arg0.nextPrint = arg0:findTF("prints/print1")
	arg0.prevPrint = arg0:findTF("prints/print2")
	arg0.animation = arg0._tf:GetComponent(typeof(Animation))
	arg0.dftAniEvent = arg0._tf:GetComponent(typeof(DftAniEvent))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.doAnim then
			return
		end

		if not arg0.selectedId then
			return
		end

		arg0.doAnim = true

		arg0:Back(function()
			arg0.doAnim = nil

			arg0:emit(EducateCharDockScene.ON_CONFIRM, arg0.selectedId)
		end)
	end, SFX_PANEL)
	arg0:bind(EducateCharDockScene.MSG_CLEAR_TIP, function(arg0, arg1)
		return
	end)
end

function var0.Back(arg0, arg1)
	arg0.dftAniEvent:SetEndEvent(function(arg0)
		arg0.dftAniEvent:SetEndEvent(nil)
		arg1()
	end)
	arg0.animation:Play("anim_educate_chardockselect_out")
end

function var0.Update(arg0, arg1, arg2)
	arg0.group = arg1

	if arg1:IsSelected(arg2) then
		arg0.selectedId = arg2
	end

	arg0.timers = {}

	arg0:FlushPainting(arg1:GetShowPainting())
	arg0:InitLabel()
	arg0:UpdateTitle()
	arg0:InitList()
	arg0:UpdateDots()
	arg0:Show()
end

function var0.UpdateTitle(arg0)
	local var0 = arg0.group

	arg0.titleTxt.text = var0:GetTitle()
end

function var0.InitLabel(arg0)
	local var0 = arg0.group

	arg0.labelTxt.sprite = GetSpriteFromAtlas("ui/EducateDockUI_atlas", var0:GetSpriteName())

	arg0.labelTxt:SetNativeSize()
end

function var0.FlushPainting(arg0, arg1)
	arg0:ReturnPainting()
	setPaintingPrefab(arg0.paintingTr, arg1, "tb1")

	arg0.paintingName = arg1
end

function var0.InitList(arg0)
	local var0 = arg0.group:GetCharIdList()

	arg0:ReturnCardList()

	arg0.cards = {}

	arg0:RemoveAllTimer()
	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			arg0:UpdateCard(arg2, var0, arg1)

			arg0.cards[var0] = arg2
		end
	end)
	arg0.uiItemList:align(#var0)

	local var1 = #var0 > 2

	setActive(arg0.nextArr, var1)
	setActive(arg0.prevArr, var1)
	setActive(arg0.nextPrint, not var1)
	setActive(arg0.prevPrint, not var1)
	scrollTo(arg0.scrollrect, 0, 0)
end

function var0.UpdateDots(arg0)
	local var0 = arg0.group:GetCharIdList()

	arg0.dotUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			setActive(arg2:Find("Image"), var0 == arg0.selectedId)
		end
	end)
	arg0.dotUIItemList:align(#var0)
end

function var0.IsLockCard(arg0, arg1)
	local var0 = getProxy(EducateProxy):GetSecretaryIDs()

	return not table.contains(var0, arg1)
end

function var0.UpdateCard(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("anim_root")
	local var1 = pg.secretary_special_ship[arg2]

	setPaintingPrefab(var0:Find("mask/painting"), var1.prefab, "tb")
	setActive(var0:Find("lock"), arg0:IsLockCard(var1.id))
	setText(var0:Find("lock/desc/Text"), var1.unlock_desc)

	local function var2()
		setActive(var0:Find("tip"), getProxy(SettingsProxy):_ShouldEducateCharTip(arg2))
	end

	var2()

	local function var3()
		setActive(var0:Find("mark"), true)

		arg0.selectedId = arg2

		arg0:UpdateDots()
		arg0:FlushPainting(var1.prefab)

		arg0.prevSelected = var0

		arg0.animation:Stop()
		arg0.animation:Play("anim_educate_chardockselect_change")
	end

	onButton(arg0, var0, function()
		if arg0:IsLockCard(arg2) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_lock_tip"))

			return
		end

		if getProxy(SettingsProxy):ClearEducateCharTip(arg2) then
			var2()
		end

		arg0:ClearPrevSelected()

		if arg0.selectedId == arg2 then
			arg0.selectedId = 0

			arg0:UpdateDots()

			return
		end

		var3()
	end, SFX_PANEL)

	if arg0.selectedId == arg2 then
		var3()
	end

	setActive(var0, false)

	arg0.timers[arg3] = Timer.New(function()
		setActive(var0, true)
		var0:GetComponent(typeof(Animation)):Play("anim_educate_chardockselect_tpl")
	end, math.max(1e-05, arg3 * 0.066), 1)

	arg0.timers[arg3]:Start()
end

function var0.RemoveAllTimer(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()

		iter1 = nil
	end

	arg0.timers = {}
end

function var0.ClearPrevSelected(arg0)
	if arg0.prevSelected then
		setActive(arg0.prevSelected:Find("mark"), false)

		arg0.prevSelected = nil
	end
end

function var0.ReturnPainting(arg0)
	if arg0.paintingName then
		retPaintingPrefab(arg0.paintingTr, arg0.paintingName)

		arg0.paintingName = nil
	end
end

function var0.ReturnCardList(arg0)
	for iter0, iter1 in pairs(arg0.cards or {}) do
		local var0 = pg.secretary_special_ship[iter0]

		retPaintingPrefab(iter1:Find("mask/painting"), var0.prefab)
	end

	arg0.cards = {}
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:ClearPrevSelected()

	arg0.selectedId = nil

	arg0:ReturnCardList()
	arg0:RemoveAllTimer()
end

function var0.OnDestroy(arg0)
	arg0:RemoveAllTimer()
	arg0:ReturnPainting()
	arg0:ReturnCardList()
	arg0.dftAniEvent:SetEndEvent(nil)
end

return var0
