local var0_0 = class("GuildMemberBasePage", import("....base.BaseSubView"))

function var0_0.SetCallBack(arg0_1, arg1_1, arg2_1)
	arg0_1.onShowCallBack = arg1_1
	arg0_1.onHideCallBack = arg2_1
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.buttonContainer = arg0_2:findTF("frame/opera")

	local var0_2 = pg.UIMgr:GetInstance().OverlayMain.transform:InverseTransformPoint(arg0_2.buttonContainer.position)

	arg0_2.buttonPos = Vector3(var0_2.x, var0_2.y, 0)
end

function var0_0.Show(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	if arg4_3 then
		arg4_3()
	end

	arg0_3.guildVO = arg1_3
	arg0_3.playerVO = arg2_3
	arg0_3.memberVO = arg3_3

	if not arg0_3:ShouldShow() then
		return
	end

	arg0_3:OnShow()
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	var0_0.super.Show(arg0_3)
	arg0_3._tf:SetAsLastSibling()
	arg0_3.onShowCallBack(arg0_3.buttonPos)
end

function var0_0.Hide(arg0_4)
	if arg0_4:isShowing() then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf, arg0_4._parentTf)
	end

	if arg0_4.circle.childCount > 0 then
		local var0_4 = arg0_4.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0_4.name, var0_4.name, var0_4)
	end

	var0_0.super.Hide(arg0_4)
	arg0_4.onHideCallBack()
end

function var0_0.OnDestroy(arg0_5)
	arg0_5:Hide()
end

function var0_0.ShouldShow(arg0_6)
	return true
end

function var0_0.OnShow(arg0_7)
	return
end

return var0_0
