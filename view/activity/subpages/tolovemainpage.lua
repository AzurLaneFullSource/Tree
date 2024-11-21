local var0_0 = class("ToLoveMainPage", import(".TemplatePage.PreviewTemplatePage"))

var0_0.CHARIMG_NUM = 6

function var0_0.OnInit(arg0_1)
	arg0_1.super.OnInit(arg0_1)

	arg0_1.charImg = arg0_1.bg:Find("character/Image")
	arg0_1.skinShop = arg0_1.bg:Find("btn_list/skinshop")
	arg0_1.build = arg0_1.bg:Find("btn_list/build")
end

function var0_0.OnFirstFlush(arg0_2)
	arg0_2.buildLinkId = arg0_2.activity:getConfig("config_client").build_linkId
	arg0_2.skinLinkId = arg0_2.activity:getConfig("config_client").skin_linkId

	arg0_2:initBtn()

	function arg0_2.btnFuncList.activity(arg0_3)
		onButton(arg0_2, arg0_3, function()
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TOLOVE_COLLAB_BACKHILL)
		end)
	end

	eachChild(arg0_2.btnList, function(arg0_5)
		arg0_2.btnFuncList[arg0_5.name](arg0_5)
	end)

	local var0_2 = getProxy(ActivityProxy):getActivityById(arg0_2.buildLinkId)

	if not var0_2 or var0_2:isEnd() then
		setActive(arg0_2.build:Find("time"), false)
	else
		local var1_2 = var0_2.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		setActive(arg0_2.build:Find("time"), var1_2 < 86400)
		setText(arg0_2.build:Find("time/Text"), i18n("tolovemainpage_build_countdown"))
	end

	local var2_2 = pg.shop_template[arg0_2.skinLinkId].time
	local var3_2, var4_2 = pg.TimeMgr.GetInstance():inTime(var2_2)

	if var3_2 then
		local var5_2 = pg.TimeMgr.GetInstance():Table2ServerTime(var4_2) - pg.TimeMgr.GetInstance():GetServerTime()

		setActive(arg0_2.skinShop:Find("time"), var5_2 < 86400)
		setText(arg0_2.skinShop:Find("time/Text"), i18n("tolovemainpage_skin_countdown", math.floor(var5_2 / 3600)))
	else
		setActive(arg0_2.skinShop, false)
	end

	local var6_2 = math.random(1, var0_0.CHARIMG_NUM)

	GetImageSpriteFromAtlasAsync("ui/activityuipage/tolovemainpage_atlas", "character_" .. var6_2, arg0_2.charImg)
end

return var0_0
