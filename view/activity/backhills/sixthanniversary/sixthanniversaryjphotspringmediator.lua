local var0_0 = class("SixthAnniversaryJPHotSpringMediator", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.UNLOCK_SLOT, function(arg0_2, arg1_2)
		local var0_2, var1_2 = arg0_1.activity:GetUpgradeCost()

		MsgboxMediator.ShowMsgBox({
			type = MSGBOX_TYPE_NORMAL,
			content = i18n("jp6th_spring_tip1", var1_2),
			contextSprites = {
				{
					name = "wenquanshoupai",
					path = "props/wenquanshoupai"
				}
			},
			onYes = function()
				if arg0_1.activity:GetCoins() < var1_2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("jp6th_spring_tip2"))

					return
				end

				arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
					activity_id = arg1_2,
					cmd = SpringActivity.OPERATION_UNLOCK
				})
			end
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHUANWU, function(arg0_4, arg1_4, arg2_4)
		arg0_1:OnSelShips(arg1_4, arg2_4)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	arg0_1.activity = var0_1

	arg0_1.viewComponent:SetActivity(var0_1)
	arg0_1:bind(var0_0.OPEN_INFO, function()
		arg0_1:addSubLayers(Context.New({
			mediator = NewYearHotSpringShipSelectMediator,
			viewComponent = NewYearHotSpringShipSelectLayer,
			data = {
				actId = var0_1.id
			}
		}))
	end)
end

return var0_0
