local var0_0 = class("Dorm3dSlideInviteLayer", import("view.dorm3d.Dorm3dInviteLayer"))

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)
end

function var0_0.ShowInvitePanel(arg0_2)
	var0_0.super.ShowInvitePanel(arg0_2)
	onButton(arg0_2, arg0_2.rtInvitePanel:Find("window/btn_confirm"), function()
		local var0_3 = {}

		if #arg0_2.selectIds >= 3 and not ApartmentProxy.CheckDeviceRAMEnough() then
			table.insert(var0_3, function(arg0_4)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("drom3d_beach_memory_limit_tip"),
					onYes = arg0_4
				})
			end)
		end

		seriesAsync(var0_3, function()
			local var0_5 = getProxy(ApartmentProxy)
			local var1_5 = ApartmentProxy.GetRoomInviteList(arg0_2.contextData.roomId)
			local var2_5, var3_5, var4_5 = table.Diff(var1_5, arg0_2.selectIds)

			if #var3_5 > 0 then
				local var5_5 = table.merge(var1_5, var3_5)

				var0_5:SetRoomInviteList(arg0_2.contextData.roomId, var5_5, function()
					var0_5:SetSlideInviteList(arg0_2.selectIds)
				end)
			else
				var0_5:SetSlideInviteList(arg0_2.selectIds)
			end

			arg0_2:closeView()
		end)
	end, SFX_DORM_CLICK)
end

function var0_0.didEnter(arg0_7)
	arg0_7.selectIds = arg0_7.contextData.groupIds

	arg0_7:ShowInvitePanel()
end

return var0_0
