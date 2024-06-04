local var0 = class("GuildMemberBasePage", import("....base.BaseSubView"))

function var0.SetCallBack(arg0, arg1, arg2)
	arg0.onShowCallBack = arg1
	arg0.onHideCallBack = arg2
end

function var0.OnLoaded(arg0)
	arg0.buttonContainer = arg0:findTF("frame/opera")

	local var0 = pg.UIMgr:GetInstance().OverlayMain.transform:InverseTransformPoint(arg0.buttonContainer.position)

	arg0.buttonPos = Vector3(var0.x, var0.y, 0)
end

function var0.Show(arg0, arg1, arg2, arg3, arg4)
	if arg4 then
		arg4()
	end

	arg0.guildVO = arg1
	arg0.playerVO = arg2
	arg0.memberVO = arg3

	if not arg0:ShouldShow() then
		return
	end

	arg0:OnShow()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	var0.super.Show(arg0)
	arg0._tf:SetAsLastSibling()
	arg0.onShowCallBack(arg0.buttonPos)
end

function var0.Hide(arg0)
	if arg0:isShowing() then
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	end

	if arg0.circle.childCount > 0 then
		local var0 = arg0.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0.name, var0.name, var0)
	end

	var0.super.Hide(arg0)
	arg0.onHideCallBack()
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

function var0.ShouldShow(arg0)
	return true
end

function var0.OnShow(arg0)
	return
end

return var0
