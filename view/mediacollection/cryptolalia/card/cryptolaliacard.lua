local var0_0 = class("CryptolaliaCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.iconImg = arg0_1._tf:Find("icon"):GetComponent(typeof(Image))
	arg0_1.nameTxt = arg0_1._tf:Find("name"):GetComponent(typeof(Text))
	arg0_1.shipNameTxt = arg0_1._tf:Find("shipname"):GetComponent(typeof(Text))
	arg0_1.timeTxt = arg0_1._tf:Find("time"):GetComponent(typeof(Text))
	arg0_1.timeCG = arg0_1._tf:Find("time"):GetComponent(typeof(CanvasGroup))
	arg0_1.selected = arg0_1._tf:Find("selected")
	arg0_1.stateBtn = arg0_1._tf:Find("name/state"):GetComponent(typeof(Image))
	arg0_1.stateIcon = arg0_1._tf:Find("name/state/icon"):GetComponent(typeof(Image))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.cryptolalia = arg1_2

	local var0_2 = arg1_2:ShipIcon()

	PoolMgr.GetInstance():GetSprite("SquareIcon/" .. var0_2, var0_2, true, function(arg0_3)
		if arg0_2.exited then
			return
		end

		arg0_2.iconImg.sprite = arg0_3
	end)

	local var1_2 = arg0_2:GetColor(arg3_2)

	arg0_2.nameTxt.text = setColorStr(arg1_2:GetName(), var1_2)
	arg0_2.shipNameTxt.text = setColorStr(arg1_2:GetShipName(), var1_2)
	arg0_2.timeCG.alpha = arg3_2 and 1 or 0.7

	if not arg1_2:IsForever() and arg1_2:IsLock() then
		arg0_2.timeTxt.text = setColorStr(arg1_2:GetExpiredTimeStr(), var1_2)
	else
		arg0_2.timeTxt.text = ""
	end

	setActive(arg0_2.selected, arg3_2)

	local var2_2 = arg1_2:IsLock()
	local var3_2 = var2_2 or not arg1_2:IsDownloadAllRes()

	setActive(arg0_2.stateBtn, var3_2)

	if var3_2 then
		local var4_2 = arg0_2:_GetColor(arg3_2)

		arg0_2.stateBtn.color = var4_2
		arg0_2.stateIcon.color = var4_2

		local var5_2 = var2_2 and "list_panel_lock" or "list_panel_download"

		arg0_2.stateIcon.sprite = GetSpriteFromAtlas("ui/CryptolaliaUI_atlas", var5_2)
	end
end

function var0_0.GetColor(arg0_4, arg1_4)
	return arg1_4 and "#C33A4A" or "#363737"
end

function var0_0._GetColor(arg0_5, arg1_5)
	return arg1_5 and Color.New(0.764, 0.227, 0.29) or Color.New(0.211, 0.215, 0.215)
end

function var0_0.Dispose(arg0_6)
	arg0_6.exited = true
end

return var0_0
