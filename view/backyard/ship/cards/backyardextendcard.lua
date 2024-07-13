local var0_0 = class("BackYardExtendCard", import(".BackYardBaseCard"))

function var0_0.OnInit(arg0_1)
	onButton(arg0_1, arg0_1._content, function()
		arg0_1:Unlock()
	end, SFX_PANEL)
end

function var0_0.Unlock(arg0_3)
	local var0_3 = getProxy(DormProxy):getRawData():getExtendTrainPosShopId()

	if var0_3 then
		local var1_3 = pg.shop_template[var0_3].resource_num

		_BackyardMsgBoxMgr:Show({
			content = i18n("backyard_backyardShipInfoLayer_quest_openPos", var1_3),
			onYes = function()
				local var0_4 = getProxy(PlayerProxy):getRawData()

				if var0_4 and var0_4:getTotalGem() < var1_3 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
				else
					arg0_3:emit(NewBackYardShipInfoMediator.EXTEND, var0_3, 1)
				end
			end
		})
	end
end

return var0_0
