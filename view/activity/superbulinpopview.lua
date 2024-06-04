local var0 = class("SuperBulinPopView", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "SuperBulinPopView"
end

function var0.didEnter(arg0)
	arg0.bulinAnim = arg0._tf:Find("Bulin"):GetComponent("SpineAnimUI")

	arg0.bulinAnim:SetActionCallBack(nil)
	onButton(arg0, arg0._tf, function()
		seriesAsync({
			function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("super_bulin"),
					onYes = arg0,
					onNo = function()
						arg0:closeView()
					end
				})
			end,
			function(arg0)
				local var0 = arg0.contextData.actId
				local var1 = arg0.contextData.stageId

				arg0:closeView()
				pg.m02:sendNotification(GAME.BEGIN_STAGE, {
					warnMsg = "bulin_tip_other3",
					system = SYSTEM_SIMULATION,
					stageId = var1,
					exitCallback = function()
						local var0 = getProxy(ActivityProxy)
						local var1 = var0:getActivityById(var0)

						if var1.data1 == 2 then
							return
						end

						var1.data3 = 1

						var0:updateActivity(var1)
					end
				})
			end
		})
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
