local var0_0 = class("PreviewTemplatePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.btnList = arg0_1:findTF("btn_list", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2:initBtn()
	eachChild(arg0_2.btnList, function(arg0_3)
		arg0_2.btnFuncList[arg0_3.name](arg0_3)
	end)
end

function var0_0.initBtn(arg0_4)
	local function var0_4(arg0_5)
		local var0_5 = getProxy(ActivityProxy):getActivityById(arg0_5)

		if not var0_5 or var0_5 and var0_5:isEnd() then
			return true
		else
			return false
		end
	end

	local var1_4 = arg0_4.activity:getConfig("config_client")

	arg0_4.btnFuncList = {
		task = function(arg0_6)
			onButton(arg0_4, arg0_6, function()
				if var1_4.taskLinkActID and var0_4(var1_4.taskLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
					page = "activity"
				})
			end)
		end,
		academy = function(arg0_8)
			onButton(arg0_4, arg0_8, function()
				arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NAVALACADEMYSCENE, {
					page = "activity"
				})
			end)
		end,
		shop = function(arg0_10)
			local var0_10 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0_11)
				return arg0_11:getConfig("config_client").pt_id == pg.gameset.activity_res_id.key_value
			end)

			onButton(arg0_4, arg0_10, function()
				if var1_4.shopLinkActID and var0_4(var1_4.shopLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_4:emit(ActivityMediator.GO_SHOPS_LAYER, {
					warp = NewShopsScene.TYPE_ACTIVITY,
					actId = var0_10 and var0_10.id
				})
			end)
		end,
		build = function(arg0_13)
			onButton(arg0_4, arg0_13, function()
				if var1_4.buildLinkActID and var0_4(var1_4.buildLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
					page = BuildShipScene.PAGE_BUILD,
					projectName = BuildShipScene.PROJECTS.ACTIVITY
				})
			end)
		end,
		fight = function(arg0_15)
			onButton(arg0_4, arg0_15, function()
				if var1_4.fightLinkActID and var0_4(var1_4.fightLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_4:emit(ActivityMediator.BATTLE_OPERA)
			end)
		end,
		lottery = function(arg0_17)
			onButton(arg0_4, arg0_17, function()
				if var1_4.lotteryLinkActID and var0_4(var1_4.lotteryLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0_4:emit(ActivityMediator.GO_LOTTERY)
			end)
		end,
		memory = function(arg0_19)
			return
		end,
		activity = function(arg0_20)
			return
		end,
		mountain = function(arg0_21)
			return
		end,
		skinshop = function(arg0_22)
			onButton(arg0_4, arg0_22, function()
				arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
			end)
		end
	}
end

return var0_0
