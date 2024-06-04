local var0 = class("SixthAnniversaryJPHotSpringMediator", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringMediator"))

function var0.register(arg0)
	arg0:bind(var0.UNLOCK_SLOT, function(arg0, arg1)
		local var0, var1 = arg0.activity:GetUpgradeCost()

		MsgboxMediator.ShowMsgBox({
			type = MSGBOX_TYPE_NORMAL,
			content = i18n("jp6th_spring_tip1", var1),
			contextSprites = {
				{
					name = "wenquanshoupai",
					path = "props/wenquanshoupai"
				}
			},
			onYes = function()
				if arg0.activity:GetCoins() < var1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("jp6th_spring_tip2"))

					return
				end

				arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
					activity_id = arg1,
					cmd = SpringActivity.OPERATION_UNLOCK
				})
			end
		})
	end)
	arg0:bind(var0.OPEN_CHUANWU, function(arg0, arg1, arg2)
		arg0:OnSelShips(arg1, arg2)
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	arg0.activity = var0

	arg0.viewComponent:SetActivity(var0)
	arg0:bind(var0.OPEN_INFO, function()
		arg0:addSubLayers(Context.New({
			mediator = NewYearHotSpringShipSelectMediator,
			viewComponent = NewYearHotSpringShipSelectLayer,
			data = {
				actId = var0.id
			}
		}))
	end)
end

return var0
