local var0 = class("CryptolaliaCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.iconImg = arg0._tf:Find("icon"):GetComponent(typeof(Image))
	arg0.nameTxt = arg0._tf:Find("name"):GetComponent(typeof(Text))
	arg0.shipNameTxt = arg0._tf:Find("shipname"):GetComponent(typeof(Text))
	arg0.timeTxt = arg0._tf:Find("time"):GetComponent(typeof(Text))
	arg0.timeCG = arg0._tf:Find("time"):GetComponent(typeof(CanvasGroup))
	arg0.selected = arg0._tf:Find("selected")
	arg0.stateBtn = arg0._tf:Find("name/state"):GetComponent(typeof(Image))
	arg0.stateIcon = arg0._tf:Find("name/state/icon"):GetComponent(typeof(Image))
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0.cryptolalia = arg1

	local var0 = arg1:ShipIcon()

	PoolMgr.GetInstance():GetSprite("SquareIcon/" .. var0, var0, true, function(arg0)
		if arg0.exited then
			return
		end

		arg0.iconImg.sprite = arg0
	end)

	local var1 = arg0:GetColor(arg3)

	arg0.nameTxt.text = setColorStr(arg1:GetName(), var1)
	arg0.shipNameTxt.text = setColorStr(arg1:GetShipName(), var1)
	arg0.timeCG.alpha = arg3 and 1 or 0.7

	if not arg1:IsForever() and arg1:IsLock() then
		arg0.timeTxt.text = setColorStr(arg1:GetExpiredTimeStr(), var1)
	else
		arg0.timeTxt.text = ""
	end

	setActive(arg0.selected, arg3)

	local var2 = arg1:IsLock()
	local var3 = var2 or not arg1:IsDownloadAllRes()

	setActive(arg0.stateBtn, var3)

	if var3 then
		local var4 = arg0:_GetColor(arg3)

		arg0.stateBtn.color = var4
		arg0.stateIcon.color = var4

		local var5 = var2 and "list_panel_lock" or "list_panel_download"

		arg0.stateIcon.sprite = GetSpriteFromAtlas("ui/CryptolaliaUI_atlas", var5)
	end
end

function var0.GetColor(arg0, arg1)
	return arg1 and "#C33A4A" or "#363737"
end

function var0._GetColor(arg0, arg1)
	return arg1 and Color.New(0.764, 0.227, 0.29) or Color.New(0.211, 0.215, 0.215)
end

function var0.Dispose(arg0)
	arg0.exited = true
end

return var0
