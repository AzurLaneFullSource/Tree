local var0 = class("BackYardExtendCard", import(".BackYardBaseCard"))

function var0.OnInit(arg0)
	onButton(arg0, arg0._content, function()
		arg0:Unlock()
	end, SFX_PANEL)
end

function var0.Unlock(arg0)
	local var0 = getProxy(DormProxy):getRawData():getExtendTrainPosShopId()

	if var0 then
		local var1 = pg.shop_template[var0].resource_num

		_BackyardMsgBoxMgr:Show({
			content = i18n("backyard_backyardShipInfoLayer_quest_openPos", var1),
			onYes = function()
				local var0 = getProxy(PlayerProxy):getRawData()

				if var0 and var0:getTotalGem() < var1 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
				else
					arg0:emit(NewBackYardShipInfoMediator.EXTEND, var0, 1)
				end
			end
		})
	end
end

return var0
