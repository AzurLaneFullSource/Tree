local var0_0 = class("FulankelinMainPage", import("view.base.BaseActivityPage"))
local var1_0 = 71122
local var2_0 = ActivityConst.Valleyhospital_ACT_ID
local var3_0 = ActivityConst.Valleyhospital_ACT_ID

function var0_0.OnInit(arg0_1)
	arg0_1.ad = arg0_1:findTF("AD")
	arg0_1.btnCollect = findTF(arg0_1.ad, "btnCollect")
	arg0_1.btnSkin = findTF(arg0_1.ad, "btnSkin")
	arg0_1.btnSkinText = findTF(arg0_1.btnSkin, "bgTime/text")
	arg0_1.btnAct = findTF(arg0_1.ad, "btnAct")
	arg0_1.btnActText = findTF(arg0_1.btnAct, "bgTime/text")
	arg0_1.btnBuild = findTF(arg0_1.ad, "btnBuild")
	arg0_1.btnBuildText = findTF(arg0_1.btnBuild, "bgTime/text")

	GetComponent(arg0_1.btnCollect, typeof(Image)):SetNativeSize()
	GetComponent(arg0_1.btnSkin, typeof(Image)):SetNativeSize()
	GetComponent(arg0_1.btnAct, typeof(Image)):SetNativeSize()
	GetComponent(arg0_1.btnBuild, typeof(Image)):SetNativeSize()
	onButton(arg0_1, arg0_1.btnCollect, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_ALBUM
		})
	end)
	onButton(arg0_1, arg0_1.btnSkin, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_CONFIRM)
	onButton(arg0_1, arg0_1.btnAct, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CLUE_MAP)
	end, SFX_CONFIRM)
	onButton(arg0_1, arg0_1.btnBuild, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD
		})
	end, SFX_CONFIRM)
end

function var0_0.OnDataSetting(arg0_6)
	return
end

function var0_0.OnFirstFlush(arg0_7)
	arg0_7:updateUI()
end

function var0_0.OnUpdateFlush(arg0_8)
	arg0_8:updateUI()
end

function var0_0.updateUI(arg0_9)
	local var0_9, var1_9 = pg.TimeMgr.GetInstance():inTime(pg.shop_template[var1_0].time)
	local var2_9

	if var1_9 then
		local var3_9 = pg.TimeMgr.GetInstance():Table2ServerTime(var1_9)

		var2_9 = skinCommdityTimeStamp(var3_9)
	end

	local var4_9, var5_9 = pg.TimeMgr.GetInstance():inTime(pg.activity_template[var3_0].time)
	local var6_9

	if var5_9 then
		local var7_9 = pg.TimeMgr.GetInstance():Table2ServerTime(var5_9)

		var6_9 = skinCommdityTimeStamp(var7_9)
	end

	if var2_9 then
		setText(arg0_9.btnSkinText, var2_9)
	else
		setActive(findTF(arg0_9.btnSkin, "bgTime"), false)
	end

	setText(arg0_9.btnActText, "")

	if var6_9 then
		setText(arg0_9.btnBuildText, var6_9)
	else
		setActive(findTF(arg0_9.btnBuild, "bgTime"), false)
	end
end

return var0_0
