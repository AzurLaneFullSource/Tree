local var0_0 = class("CourtYardTopPanel", import(".CourtYardBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "main/topPanel"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("btns/topleft/return")
	arg0_2.nameTxt = arg0_2:findTF("btns/topleft/name/Text"):GetComponent(typeof(Text))
	arg0_2.renameBtn = arg0_2:findTF("btns/topleft/name")
	arg0_2.comfortableBtn = arg0_2:findTF("btns/topright/comfortable")
	arg0_2.comfortableTxt = arg0_2:findTF("btns/topright/comfortable/Text"):GetComponent(typeof(Text))
	arg0_2.comfortableImg = arg0_2:findTF("btns/topright/comfortable/icon"):GetComponent(typeof(Image))
	arg0_2.switchBtn = arg0_2:findTF("btns/topright/switch")
	arg0_2.switchTxt = arg0_2.switchBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_2.renamePage = CourtYardRenamePage.New(arg0_2._tf.parent.parent, arg0_2.parent.event)
	arg0_2.comfortablePage = CourtYardComfortablePage.New(arg0_2._tf.parent.parent, arg0_2.parent.event)
	arg0_2.cg = GetOrAddComponent(arg0_2:findTF("btns/topright"), typeof(CanvasGroup))

	setText(arg0_2:findTF("btns/topright/comfortable/label"), i18n("word_comfort_level"))
	setText(arg0_2:findTF("btns/topright/switch/label"), i18n("courtyard_label_floor"))
end

function var0_0.OnRegister(arg0_3)
	onButton(arg0_3, arg0_3.renameBtn, function()
		if arg0_3.cg.blocksRaycasts then
			arg0_3.renamePage:ExecuteAction("Flush")
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.backBtn, function()
		_courtyard:GetController():Quit()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.comfortableBtn, function()
		arg0_3.comfortablePage:ExecuteAction("Show", arg0_3.dorm)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.switchBtn, function()
		local var0_7 = arg0_3.contextData.floor == 1 and 2 or 1

		if not arg0_3.dorm:isUnlockFloor(var0_7) then
			arg0_3:UnLockTip()
		else
			arg0_3:emit(CourtYardMediator.SWITCH, var0_7)
		end
	end, SFX_PANEL)
end

function var0_0.UnLockTip(arg0_8)
	if not arg0_8.dorm:IsMaxLevel() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("sec_floor_limit_tip"))

		return
	end

	local var0_8 = ShopArgs.DORM_FLOOR_ID
	local var1_8 = pg.shop_template[var0_8].resource_num

	_BackyardMsgBoxMgr:Show({
		content = i18n("backyard_open_2floor", var1_8),
		onYes = function()
			arg0_8:emit(CourtYardMediator.UN_LOCK_2FLOOR, var0_8, 1)
		end
	})
end

function var0_0.UpdateFloor(arg0_10)
	local var0_10 = arg0_10.contextData.floor or 1

	arg0_10.switchTxt.text = var0_10 .. "F"
end

function var0_0.OnVisitRegister(arg0_11)
	onButton(arg0_11, arg0_11.backBtn, function()
		_courtyard:GetController():Quit()
	end, SFX_PANEL)
end

function var0_0.OnVisitFlush(arg0_13)
	arg0_13:OnFlush()
end

function var0_0.OnFlush(arg0_14, arg1_14)
	arg1_14 = arg1_14 or bit.bor(BackYardConst.DORM_UPDATE_TYPE_NAME, BackYardConst.DORM_UPDATE_TYPE_LEVEL)

	if bit.band(arg1_14, BackYardConst.DORM_UPDATE_TYPE_NAME) > 0 then
		arg0_14:FlushName()
	end

	if bit.band(arg1_14, BackYardConst.DORM_UPDATE_TYPE_LEVEL) > 0 then
		arg0_14:FlushComfortable()
		arg0_14:UpdateFloor()
	end
end

function var0_0.FlushName(arg0_15)
	local var0_15 = arg0_15.dorm:GetName()

	if not var0_15 or var0_15 == "" then
		var0_15 = getProxy(PlayerProxy):getRawData().name
		arg0_15.nameTxt.text = var0_15
	else
		arg0_15.nameTxt.text = var0_15
	end
end

function var0_0.FlushComfortable(arg0_16)
	local var0_16 = arg0_16.dorm
	local var1_16 = var0_16:getComfortable()

	arg0_16.comfortableTxt.text = var1_16

	local var2_16 = var0_16:GetComfortableLevel(var1_16)

	LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "express_" .. var2_16, function(arg0_17)
		if arg0_16.exited then
			return
		end

		arg0_16.comfortableImg.sprite = arg0_17

		arg0_16.comfortableImg:SetNativeSize()
	end)
end

function var0_0.GetMoveY(arg0_18)
	return {
		{
			arg0_18._tf,
			1
		}
	}
end

function var0_0.OnEnterEditMode(arg0_19)
	arg0_19.cg.blocksRaycasts = false
end

function var0_0.OnExitEditMode(arg0_20)
	arg0_20.cg.blocksRaycasts = true
end

function var0_0.onBackPressed(arg0_21)
	if arg0_21.renamePage:GetLoaded() and arg0_21.renamePage:isShowing() then
		arg0_21.renamePage:Hide()

		return true
	end

	return false
end

function var0_0.OnDispose(arg0_22)
	arg0_22.exited = true

	if arg0_22.renamePage then
		arg0_22.renamePage:Destroy()

		arg0_22.renamePage = nil
	end

	if arg0_22.comfortablePage then
		arg0_22.comfortablePage:Destroy()

		arg0_22.comfortablePage = nil
	end
end

return var0_0
