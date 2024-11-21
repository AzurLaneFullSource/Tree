local var0_0 = class("PuzzleConnectLayer", import("..base.BaseUI"))

var0_0.OPEN_DETAIL = "open detail panel"
var0_0.OPEN_MENU = "open menu panel"
var0_0.OPEN_GAME = "open game panel"

function var0_0.getUIName(arg0_1)
	return "PuzzleConnectUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2.menuPanel = PuzzleConnectMenu.New(findTF(arg0_2._tf, "ad/menu"), arg0_2)
	arg0_2.detailPanel = PuzzleConnectDetail.New(findTF(arg0_2._tf, "ad/detail"), arg0_2)
	arg0_2.gamePanel = PuzzleConnectGame.New(findTF(arg0_2._tf, "ad/game"), arg0_2)
	arg0_2.panelDic = {
		arg0_2.menuPanel,
		arg0_2.detailPanel,
		arg0_2.gamePanel
	}

	arg0_2:bind(PuzzleConnectLayer.OPEN_DETAIL, function(arg0_3, arg1_3)
		arg0_2:show(arg0_2.menuPanel)
		arg0_2:show(arg0_2.detailPanel, true)

		if arg1_3 then
			arg0_2.detailPanel:setData(arg1_3)

			arg0_2._activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLE_CONNECT)

			arg0_2.detailPanel:setActivity(arg0_2._activity)
		end
	end)
	arg0_2:bind(PuzzleConnectLayer.OPEN_MENU, function(arg0_4, arg1_4)
		arg0_2:show(arg0_2.menuPanel)
	end)
	arg0_2:bind(PuzzleConnectLayer.OPEN_GAME, function(arg0_5, arg1_5)
		arg0_2:show(arg0_2.gamePanel)

		if arg1_5 then
			arg0_2.gamePanel:setData(arg1_5)
		end
	end)
	arg0_2:show(arg0_2.menuPanel)

	arg0_2._activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLE_CONNECT)

	if arg0_2._activity then
		local var0_2 = arg0_2._activity:getConfig("config_data")

		arg0_2.menuPanel:setData(var0_2)
	else
		arg0_2.menuPanel:setData({
			1,
			2,
			3,
			4,
			5,
			6,
			7
		})
	end

	if PlayerPrefs.GetInt("puzzle_connect_first_" .. tostring(getProxy(PlayerProxy):getPlayerId())) ~= 1 then
		pg.NewStoryMgr.GetInstance():Play("WEIXIANFAMINGPOJINZHONGWEITUO1", function()
			PlayerPrefs.SetInt("puzzle_connect_first_" .. tostring(getProxy(PlayerProxy):getPlayerId()), 1)
		end)
	end

	arg0_2:updateActivity()
end

function var0_0.show(arg0_7, arg1_7, arg2_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.panelDic) do
		if iter1_7 == arg1_7 then
			iter1_7:show()
		elseif not arg2_7 then
			iter1_7:hide()
		end
	end
end

function var0_0.updateActivity(arg0_8)
	arg0_8._activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLE_CONNECT)

	if arg0_8._activity then
		local var0_8 = arg0_8._activity:getConfig("config_data")

		arg0_8.menuPanel:setActivity(arg0_8._activity)
		arg0_8.detailPanel:setActivity(arg0_8._activity)
		arg0_8.gamePanel:setActivity(arg0_8._activity)

		local var1_8 = getProxy(PlayerProxy)
		local var2_8 = arg0_8._activity.data1_list
		local var3_8 = arg0_8._activity.data2_list
		local var4_8 = arg0_8._activity.data3_list
		local var5_8 = arg0_8._activity:getDayIndex()
		local var6_8 = 0

		for iter0_8 = 1, #var0_8 do
			local var7_8 = var0_8[iter0_8]

			if iter0_8 <= var5_8 then
				if not table.contains(var4_8, var7_8) then
					if not table.contains(var2_8, var7_8) and iter0_8 == var6_8 + 1 then
						local var8_8 = pg.activity_tolove_jigsaw[var7_8].need[3]
						local var9_8 = pg.activity_tolove_jigsaw[var7_8].need[2]

						if var8_8 <= var1_8:getData():getResource(var9_8) then
							arg0_8:emit(PuzzleConnectMediator.CMD_ACTIVITY, {
								index = 1,
								config_id = var7_8
							})
						end
					end
				else
					var6_8 = var6_8 < iter0_8 and iter0_8 or var6_8
				end
			end
		end
	end
end

function var0_0.initEvent(arg0_9)
	return
end

function var0_0.willExit(arg0_10)
	arg0_10.detailPanel:dispose()
	arg0_10.menuPanel:dispose()
	arg0_10.gamePanel:dispose()
end

return var0_0
