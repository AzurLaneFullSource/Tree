local var0_0 = class("SuperBulinPopView", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SuperBulinPopView"
end

function var0_0.didEnter(arg0_2)
	arg0_2.bulinAnim = arg0_2._tf:Find("Bulin"):GetComponent("SpineAnimUI")

	arg0_2.bulinAnim:SetActionCallBack(nil)
	onButton(arg0_2, arg0_2._tf, function()
		seriesAsync({
			function(arg0_4)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("super_bulin"),
					onYes = arg0_4,
					onNo = function()
						arg0_2:closeView()
					end
				})
			end,
			function(arg0_6)
				local var0_6 = arg0_2.contextData.actId
				local var1_6 = arg0_2.contextData.stageId

				arg0_2:closeView()
				pg.m02:sendNotification(GAME.BEGIN_STAGE, {
					warnMsg = "bulin_tip_other3",
					system = SYSTEM_SIMULATION,
					stageId = var1_6,
					exitCallback = function()
						local var0_7 = getProxy(ActivityProxy)
						local var1_7 = var0_7:getActivityById(var0_6)

						if var1_7.data1 == 2 then
							return
						end

						var1_7.data3 = 1

						var0_7:updateActivity(var1_7)
					end
				})
			end
		})
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.willExit(arg0_8)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf)
end

return var0_0
