local var0 = class("CourtYardTopPanel", import(".CourtYardBasePanel"))

function var0.GetUIName(arg0)
	return "main/topPanel"
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("btns/topleft/return")
	arg0.nameTxt = arg0:findTF("btns/topleft/name/Text"):GetComponent(typeof(Text))
	arg0.renameBtn = arg0:findTF("btns/topleft/name")
	arg0.comfortableBtn = arg0:findTF("btns/topright/comfortable")
	arg0.comfortableTxt = arg0:findTF("btns/topright/comfortable/Text"):GetComponent(typeof(Text))
	arg0.comfortableImg = arg0:findTF("btns/topright/comfortable/icon"):GetComponent(typeof(Image))
	arg0.switchBtn = arg0:findTF("btns/topright/switch")
	arg0.switchTxt = arg0.switchBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.renamePage = CourtYardRenamePage.New(arg0._tf.parent.parent, arg0.parent.event)
	arg0.comfortablePage = CourtYardComfortablePage.New(arg0._tf.parent.parent, arg0.parent.event)
	arg0.cg = GetOrAddComponent(arg0:findTF("btns/topright"), typeof(CanvasGroup))

	setText(arg0:findTF("btns/topright/comfortable/label"), i18n("word_comfort_level"))
	setText(arg0:findTF("btns/topright/switch/label"), i18n("courtyard_label_floor"))
end

function var0.OnRegister(arg0)
	onButton(arg0, arg0.renameBtn, function()
		if arg0.cg.blocksRaycasts then
			arg0.renamePage:ExecuteAction("Flush")
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		_courtyard:GetController():Quit()
	end, SFX_PANEL)
	onButton(arg0, arg0.comfortableBtn, function()
		arg0.comfortablePage:ExecuteAction("Show", arg0.dorm)
	end, SFX_PANEL)
	onButton(arg0, arg0.switchBtn, function()
		local var0 = arg0.contextData.floor == 1 and 2 or 1

		if not arg0.dorm:isUnlockFloor(var0) then
			arg0:UnLockTip()
		else
			arg0:emit(CourtYardMediator.SWITCH, var0)
		end
	end, SFX_PANEL)
end

function var0.UnLockTip(arg0)
	if not arg0.dorm:IsMaxLevel() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("sec_floor_limit_tip"))

		return
	end

	local var0 = ShopArgs.DORM_FLOOR_ID
	local var1 = pg.shop_template[var0].resource_num

	_BackyardMsgBoxMgr:Show({
		content = i18n("backyard_open_2floor", var1),
		onYes = function()
			arg0:emit(CourtYardMediator.UN_LOCK_2FLOOR, var0, 1)
		end
	})
end

function var0.UpdateFloor(arg0)
	local var0 = arg0.contextData.floor or 1

	arg0.switchTxt.text = var0 .. "F"
end

function var0.OnVisitRegister(arg0)
	onButton(arg0, arg0.backBtn, function()
		_courtyard:GetController():Quit()
	end, SFX_PANEL)
end

function var0.OnVisitFlush(arg0)
	arg0:OnFlush()
end

function var0.OnFlush(arg0, arg1)
	arg1 = arg1 or bit.bor(BackYardConst.DORM_UPDATE_TYPE_NAME, BackYardConst.DORM_UPDATE_TYPE_LEVEL)

	if bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_NAME) > 0 then
		arg0:FlushName()
	end

	if bit.band(arg1, BackYardConst.DORM_UPDATE_TYPE_LEVEL) > 0 then
		arg0:FlushComfortable()
		arg0:UpdateFloor()
	end
end

function var0.FlushName(arg0)
	local var0 = arg0.dorm:GetName()

	if not var0 or var0 == "" then
		var0 = getProxy(PlayerProxy):getRawData().name
		arg0.nameTxt.text = var0
	else
		arg0.nameTxt.text = var0
	end
end

function var0.FlushComfortable(arg0)
	local var0 = arg0.dorm
	local var1 = var0:getComfortable()

	arg0.comfortableTxt.text = var1

	local var2 = var0:GetComfortableLevel(var1)

	LoadSpriteAtlasAsync("ui/CourtyardUI_atlas", "express_" .. var2, function(arg0)
		if arg0.exited then
			return
		end

		arg0.comfortableImg.sprite = arg0

		arg0.comfortableImg:SetNativeSize()
	end)
end

function var0.GetMoveY(arg0)
	return {
		{
			arg0._tf,
			1
		}
	}
end

function var0.OnEnterEditMode(arg0)
	arg0.cg.blocksRaycasts = false
end

function var0.OnExitEditMode(arg0)
	arg0.cg.blocksRaycasts = true
end

function var0.onBackPressed(arg0)
	if arg0.renamePage:GetLoaded() and arg0.renamePage:isShowing() then
		arg0.renamePage:Hide()

		return true
	end

	return false
end

function var0.OnDispose(arg0)
	arg0.exited = true

	if arg0.renamePage then
		arg0.renamePage:Destroy()

		arg0.renamePage = nil
	end

	if arg0.comfortablePage then
		arg0.comfortablePage:Destroy()

		arg0.comfortablePage = nil
	end
end

return var0
