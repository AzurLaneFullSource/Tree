local var0_0 = class("EducateCharSelectPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "EducateCharDockSelectUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleTxt = arg0_2:findTF("title/Text"):GetComponent(typeof(Text))
	arg0_2.labelTxt = arg0_2:findTF("left/label/icon"):GetComponent(typeof(Image))
	arg0_2.paintingTr = arg0_2:findTF("left/print/mask/painting")
	arg0_2.scrollrect = arg0_2:findTF("list")
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("list/content"), arg0_2:findTF("list/content/tpl"))
	arg0_2.dotUIItemList = UIItemList.New(arg0_2:findTF("list/dots"), arg0_2:findTF("list/dots/tpl"))
	arg0_2.confirmBtn = arg0_2:findTF("confirm_btn")
	arg0_2.nextArr = arg0_2:findTF("prints/next")
	arg0_2.prevArr = arg0_2:findTF("prints/prev")
	arg0_2.nextPrint = arg0_2:findTF("prints/print1")
	arg0_2.prevPrint = arg0_2:findTF("prints/print2")
	arg0_2.animation = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.doAnim then
			return
		end

		if not arg0_3.selectedId then
			return
		end

		arg0_3:emit(EducateCharDockScene.ON_SELECTED, arg0_3.selectedId)

		arg0_3.doAnim = true

		arg0_3:Back(function()
			arg0_3.doAnim = nil

			arg0_3:emit(EducateCharDockScene.ON_CONFIRM, arg0_3.selectedId)
		end)
	end, SFX_PANEL)
	arg0_3:bind(EducateCharDockScene.MSG_CLEAR_TIP, function(arg0_6, arg1_6)
		return
	end)
end

function var0_0.Back(arg0_7, arg1_7)
	arg0_7.dftAniEvent:SetEndEvent(function(arg0_8)
		arg0_7.dftAniEvent:SetEndEvent(nil)
		arg1_7()
	end)
	arg0_7.animation:Play("anim_educate_chardockselect_out")
end

function var0_0.Update(arg0_9, arg1_9, arg2_9)
	arg0_9.group = arg1_9

	if arg1_9:IsSelected(arg2_9) then
		arg0_9.selectedId = arg2_9
	end

	arg0_9.timers = {}

	arg0_9:FlushPainting(arg1_9:GetShowPainting())
	arg0_9:InitLabel()
	arg0_9:UpdateTitle()
	arg0_9:InitList()
	arg0_9:UpdateDots()
	arg0_9:Show()
end

function var0_0.UpdateTitle(arg0_10)
	local var0_10 = arg0_10.group

	arg0_10.titleTxt.text = var0_10:GetTitle()
end

function var0_0.InitLabel(arg0_11)
	local var0_11 = arg0_11.group

	arg0_11.labelTxt.sprite = GetSpriteFromAtlas("ui/EducateDockUI_atlas", var0_11:GetSpriteName())

	arg0_11.labelTxt:SetNativeSize()
end

function var0_0.FlushPainting(arg0_12, arg1_12)
	arg0_12:ReturnPainting()
	setPaintingPrefabAsync(arg0_12.paintingTr, arg1_12, "tb1")

	arg0_12.paintingName = arg1_12
end

function var0_0.InitList(arg0_13)
	local var0_13 = arg0_13.group:GetCharIdList()

	arg0_13:ReturnCardList()

	arg0_13.cards = {}

	arg0_13:RemoveAllTimer()
	arg0_13.uiItemList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14 + 1]

			arg0_13:UpdateCard(arg2_14, var0_14, arg1_14)

			arg0_13.cards[var0_14] = arg2_14
		end
	end)
	arg0_13.uiItemList:align(#var0_13)

	local var1_13 = #var0_13 > 2

	setActive(arg0_13.nextArr, var1_13)
	setActive(arg0_13.prevArr, var1_13)
	setActive(arg0_13.nextPrint, not var1_13)
	setActive(arg0_13.prevPrint, not var1_13)
	scrollTo(arg0_13.scrollrect, 0, 0)
end

function var0_0.UpdateDots(arg0_15)
	local var0_15 = arg0_15.group:GetCharIdList()

	arg0_15.dotUIItemList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var0_15[arg1_16 + 1]

			setActive(arg2_16:Find("Image"), var0_16 == arg0_15.selectedId)
		end
	end)
	arg0_15.dotUIItemList:align(#var0_15)
end

function var0_0.IsLockCard(arg0_17, arg1_17)
	local var0_17 = NewEducateHelper.GetAllUnlockSecretaryIds()

	return not table.contains(var0_17, arg1_17)
end

function var0_0.UpdateCard(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg1_18:Find("anim_root")
	local var1_18 = pg.secretary_special_ship[arg2_18]

	setPaintingPrefab(var0_18:Find("mask/painting"), var1_18.prefab, "tb")
	setActive(var0_18:Find("lock"), arg0_18:IsLockCard(var1_18.id))
	setScrollText(var0_18:Find("lock/desc/Text"), var1_18.unlock_desc)

	local function var2_18()
		setActive(var0_18:Find("tip"), getProxy(SettingsProxy):_ShouldEducateCharTip(arg2_18))
	end

	var2_18()

	local function var3_18()
		setActive(var0_18:Find("mark"), true)

		arg0_18.selectedId = arg2_18

		arg0_18:UpdateDots()
		arg0_18:FlushPainting(var1_18.painting)

		arg0_18.prevSelected = var0_18

		arg0_18.animation:Stop()
		arg0_18.animation:Play("anim_educate_chardockselect_change")
	end

	onButton(arg0_18, var0_18, function()
		if arg0_18:IsLockCard(arg2_18) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_lock_tip"))

			return
		end

		if getProxy(SettingsProxy):ClearEducateCharTip(arg2_18) then
			var2_18()
		end

		arg0_18:ClearPrevSelected()

		if arg0_18.selectedId == arg2_18 then
			arg0_18.selectedId = 0

			arg0_18:UpdateDots()

			return
		end

		var3_18()
	end, SFX_PANEL)

	if arg0_18.selectedId == arg2_18 then
		var3_18()
	end

	setActive(var0_18, false)

	arg0_18.timers[arg3_18] = Timer.New(function()
		setActive(var0_18, true)
		var0_18:GetComponent(typeof(Animation)):Play("anim_educate_chardockselect_tpl")
	end, math.max(1e-05, arg3_18 * 0.066), 1)

	arg0_18.timers[arg3_18]:Start()
end

function var0_0.RemoveAllTimer(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23.timers) do
		iter1_23:Stop()

		iter1_23 = nil
	end

	arg0_23.timers = {}
end

function var0_0.ClearPrevSelected(arg0_24)
	if arg0_24.prevSelected then
		setActive(arg0_24.prevSelected:Find("mark"), false)

		arg0_24.prevSelected = nil
	end
end

function var0_0.ReturnPainting(arg0_25)
	if arg0_25.paintingName then
		retPaintingPrefab(arg0_25.paintingTr, arg0_25.paintingName)

		arg0_25.paintingName = nil
	end
end

function var0_0.ReturnCardList(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.cards or {}) do
		local var0_26 = pg.secretary_special_ship[iter0_26]

		retPaintingPrefab(iter1_26:Find("mask/painting"), var0_26.prefab)
	end

	arg0_26.cards = {}
end

function var0_0.Hide(arg0_27)
	var0_0.super.Hide(arg0_27)
	arg0_27:ClearPrevSelected()

	arg0_27.selectedId = nil

	arg0_27:ReturnCardList()
	arg0_27:RemoveAllTimer()
end

function var0_0.OnDestroy(arg0_28)
	arg0_28:RemoveAllTimer()
	arg0_28:ReturnPainting()
	arg0_28:ReturnCardList()
	arg0_28.dftAniEvent:SetEndEvent(nil)
end

return var0_0
